Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0DA24300C4
	for <lists+kvm@lfdr.de>; Sat, 16 Oct 2021 09:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243744AbhJPHQu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Oct 2021 03:16:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243727AbhJPHQt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 16 Oct 2021 03:16:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634368481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K2TqUaUeibkEimtZ+2xRoDGIDWRIgX1ExdJtIVRIxbU=;
        b=HRZHTF0N2+Lw+y0kk25ZWaPTWi4Kk0W9cIpBYMc7TasMQaEX0LboAL/+GmLwVL5OdpfO9T
        0ovhwh8qp50Q3TLfrQxeJwnbEDZaVJh90PApLQVsX3BvtBSb+Jzw5xSeQ7H+rsxSVU24Ov
        jJTZ+Txr2toZM/mQZdLChQCEm9kZorI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-iak7MvP1OIWn9sAAt6rjPw-1; Sat, 16 Oct 2021 03:14:38 -0400
X-MC-Unique: iak7MvP1OIWn9sAAt6rjPw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 052881808302;
        Sat, 16 Oct 2021 07:14:37 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F51C19E7E;
        Sat, 16 Oct 2021 07:14:36 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dave.hansen@linux.intel.com, seanjc@google.com, x86@kernel.org,
        yang.zhong@intel.com, jarkko@kernel.org, bp@suse.de
Subject: [PATCH v3 1/2] x86: sgx_vepc: extract sgx_vepc_remove_page
Date:   Sat, 16 Oct 2021 03:14:33 -0400
Message-Id: <20211016071434.167591-2-pbonzini@redhat.com>
In-Reply-To: <20211016071434.167591-1-pbonzini@redhat.com>
References: <20211016071434.167591-1-pbonzini@redhat.com>
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
open() after the guest starts; this is doable with heavy use of SCM_RIGHTS
file descriptor passing).

In order to implement this, we will need a ioctl that performs
EREMOVE on all pages mapped by a /dev/sgx_vepc file descriptor:
other possibilities, such as closing and reopening the device,
are racy.

Start the implementation by creating a separate function with just
the __eremove wrapper.

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kernel/cpu/sgx/virt.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 64511c4a5200..59cdf3f742ac 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -111,10 +111,8 @@ static int sgx_vepc_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
-static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
+static int sgx_vepc_remove_page(struct sgx_epc_page *epc_page)
 {
-	int ret;
-
 	/*
 	 * Take a previously guest-owned EPC page and return it to the
 	 * general EPC page pool.
@@ -124,7 +122,12 @@ static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
 	 * case that a guest properly EREMOVE'd this page, a superfluous
 	 * EREMOVE is harmless.
 	 */
-	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
+	return __eremove(sgx_get_epc_virt_addr(epc_page));
+}
+
+static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
+{
+	int ret = sgx_vepc_remove_page(epc_page);
 	if (ret) {
 		/*
 		 * Only SGX_CHILD_PRESENT is expected, which is because of
@@ -144,7 +147,6 @@ static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
 	}
 
 	sgx_free_epc_page(epc_page);
-
 	return 0;
 }
 
-- 
2.27.0


