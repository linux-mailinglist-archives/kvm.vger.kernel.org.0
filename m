Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED90436BD2
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 22:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbhJUUOW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 16:14:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37073 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231853AbhJUUOU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 16:14:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634847123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K2TqUaUeibkEimtZ+2xRoDGIDWRIgX1ExdJtIVRIxbU=;
        b=NlcI5QEuaY4QFuRQIMJMnh40OXUb0j5j7gLKxNZtOkVMo6S/yP7fZs4ktDN++Mm60jagXL
        Ui0PU24fCwpJXK3HCU0Nwb9WEPUeZs7SAVbJOUo1QUaXpJ0eqZqqo2OIPz0+aCUnyq2jrR
        k1FSE7x0Rw70i96kCnpaZ/o9OJfIrWg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134--DutdoaEN1qQ913q_LG2cg-1; Thu, 21 Oct 2021 16:12:00 -0400
X-MC-Unique: -DutdoaEN1qQ913q_LG2cg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B700C362F8;
        Thu, 21 Oct 2021 20:11:57 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C478ADCD;
        Thu, 21 Oct 2021 20:11:57 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bp@suse.de, seanjc@google.com, dave.hansen@linux.intel.com,
        jarkko@kernel.org, yang.zhong@intel.com, x86@kernel.org
Subject: [PATCH v4 1/2] x86: sgx_vepc: extract sgx_vepc_remove_page
Date:   Thu, 21 Oct 2021 16:11:54 -0400
Message-Id: <20211021201155.1523989-2-pbonzini@redhat.com>
In-Reply-To: <20211021201155.1523989-1-pbonzini@redhat.com>
References: <20211021201155.1523989-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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


