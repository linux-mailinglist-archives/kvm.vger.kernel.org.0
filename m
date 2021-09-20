Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE21411500
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 14:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238869AbhITMze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 08:55:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23961 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236310AbhITMzd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 08:55:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632142446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ctBmW62sDbL8h9LyL8VqCSK5u1COilFglpZF2aHJwJA=;
        b=NbSwyHWShy4svzH+iDsfMDcLTlF49vuxqMcam2u14YBHNoe/3GdN8kLrJBNl2E0aPyYGVw
        mbZdTinQofA92TMWf8z+NwoAlis6q0XX6H+asJahkaefHkUALWjG9tA2+hzwQDitKrAcf4
        ht1XvVNGv1x3l08WrRjKGhlWDDybw18=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-U53qcSMzMHe1_9k9N2itfQ-1; Mon, 20 Sep 2021 08:54:04 -0400
X-MC-Unique: U53qcSMzMHe1_9k9N2itfQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98D6C1084686;
        Mon, 20 Sep 2021 12:54:03 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB6086A257;
        Mon, 20 Sep 2021 12:54:02 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
Subject: [PATCH 1/2] x86: sgx_vepc: extract sgx_vepc_remove_page
Date:   Mon, 20 Sep 2021 08:54:00 -0400
Message-Id: <20210920125401.2389105-2-pbonzini@redhat.com>
In-Reply-To: <20210920125401.2389105-1-pbonzini@redhat.com>
References: <20210920125401.2389105-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For bare-metal SGX on real hardware, the hardware provides guarantees
SGX state at reboot.  For instance, all pages start out uninitialized.
The vepc driver provides a similar guarantee today for freshly-opened
vepc instances, but guests such as Windows expect all pages to be in
uninitialized state on startup, including after every guest reboot.

One way to do this is to simply close and reopen the /dev/sgx_vepc file
descriptor and re-mmap the virtual EPC.  However, this is problematic
because it prevents sandboxing the userspace (for example forbidding
open() after the guest starts, or running in a mount namespace that
does not have access to /dev; both are doable with pre-opened file
descriptors and/or SCM_RIGHTS file descriptor passing).

In order to implement this, we will need a ioctl that performs
EREMOVE on all pages mapped by a /dev/sgx_vepc file descriptor:
other possibilities, such as closing and reopening the device,
are racy.

Start the implementation by pulling the EREMOVE into a separate
function.

Tested-by: Yang Zhong <yang.zhong@intel.com>
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


