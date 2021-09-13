Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683AE408C1F
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 15:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236673AbhIMNNP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 09:13:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40366 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236017AbhIMNNO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Sep 2021 09:13:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631538718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sfyXCxXLqe/BSeVldQwsrQsccJEXRgInHP7qJo1PTlI=;
        b=D1+gXM1n9agPOwxkoeqrSYh+a7EiFIMXRnPzEjahYb+lostuXUP7W0ERsrhAJhQnKjUNhG
        3Rk9ybWUMojE0jBx7z/gBKlEOr+4mMOjuOceE1kixDSIpUZWYsXZJd+CqS8tUBwe7P4Ljt
        CI//VW41AHJLEWe2/VLGgjaEK8L3BYg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-jS-xm1RWMmOS2OneCy7gfA-1; Mon, 13 Sep 2021 09:11:56 -0400
X-MC-Unique: jS-xm1RWMmOS2OneCy7gfA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5086184A5E6;
        Mon, 13 Sep 2021 13:11:55 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9135A6B54B;
        Mon, 13 Sep 2021 13:11:54 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
Subject: [PATCH 1/2] x86: sgx_vepc: extract sgx_vepc_remove_page
Date:   Mon, 13 Sep 2021 09:11:52 -0400
Message-Id: <20210913131153.1202354-2-pbonzini@redhat.com>
In-Reply-To: <20210913131153.1202354-1-pbonzini@redhat.com>
References: <20210913131153.1202354-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Windows expects all pages to be in uninitialized state on startup.
In order to implement this, we will need a ioctl that performs
EREMOVE on all pages mapped by a /dev/sgx_vepc file descriptor:
other possibilities, such as closing and reopening the device,
are racy.

Start the implementation by pulling the EREMOVE into a separate
function.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kernel/cpu/sgx/virt.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 64511c4a5200..59b9c13121cd 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -111,7 +111,7 @@ static int sgx_vepc_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
-static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
+static int sgx_vepc_remove_page(struct sgx_epc_page *epc_page)
 {
 	int ret;
 
@@ -140,11 +140,17 @@ static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
 		 */
 		WARN_ONCE(ret != SGX_CHILD_PRESENT, EREMOVE_ERROR_MESSAGE,
 			  ret, ret);
-		return ret;
 	}
+	return ret;
+}
 
-	sgx_free_epc_page(epc_page);
+static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
+{
+	int ret = sgx_vepc_remove_page(epc_page);
+	if (ret)
+		return ret;
 
+	sgx_free_epc_page(epc_page);
 	return 0;
 }
 
-- 
2.27.0


