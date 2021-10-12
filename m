Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1100242A2B8
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 12:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236137AbhJLK7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 06:59:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24740 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236126AbhJLK7Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 06:59:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634036234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y4eOMfi0FRdlOEtX16+L00odJNz+Fuq7wcCV5MOdEm8=;
        b=KicSKvUzyvbBlmz1UMYvnNZNoYusMwFurqb0gURcBJvm87cnNWo5Kqeh7IWG9+HW6kkKPV
        qlSO1VEelVEPVG7loBghowx8oJFc5x4M5CYhMSgxkzUc2UaejxBeC3fQSd2E6W2Lh19tOT
        hJHapuRW8xFMw/GEJ4DDmbBn2R0Ve/c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-GapcTHaRMwCjVdsyjau27w-1; Tue, 12 Oct 2021 06:57:11 -0400
X-MC-Unique: GapcTHaRMwCjVdsyjau27w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1CC7C1018720;
        Tue, 12 Oct 2021 10:57:10 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 846BD5D6D5;
        Tue, 12 Oct 2021 10:57:09 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dave.hansen@linux.intel.com, seanjc@google.com, x86@kernel.org,
        yang.zhong@intel.com, jarkko@kernel.org
Subject: [PATCH v2 1/2] x86: sgx_vepc: extract sgx_vepc_remove_page
Date:   Tue, 12 Oct 2021 06:57:07 -0400
Message-Id: <20211012105708.2070480-2-pbonzini@redhat.com>
In-Reply-To: <20211012105708.2070480-1-pbonzini@redhat.com>
References: <20211012105708.2070480-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	v1->v2: keep WARN in sgx_vepc_free_page

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


