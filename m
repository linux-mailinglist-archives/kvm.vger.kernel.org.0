Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC5342A2B9
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 12:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236160AbhJLK7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 06:59:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30266 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236036AbhJLK7R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 06:59:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634036235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Zw60AjhnogKvFsid6jZRIlOGhKxa7549SrLAzuCWvc=;
        b=GWO1nZqsAol2WYXbkSt/18HMcJKapvUo03KTt6/fCvygCT2gktmoQqAH2NDJFnXfzzSNcQ
        34DAoI17Bei8APGdR7EZdUjUqnp40EePRg471p71qfrFSVOlwqTyPm8rgawYCMEicfYJI0
        In1pUDrQ9lW+y5n/pm7SHLAC96uU3Ew=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-ttc-XjFDP7qpKN0p4L35Kg-1; Tue, 12 Oct 2021 06:57:12 -0400
X-MC-Unique: ttc-XjFDP7qpKN0p4L35Kg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C14B8801AA7;
        Tue, 12 Oct 2021 10:57:10 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3610C5D6D5;
        Tue, 12 Oct 2021 10:57:10 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dave.hansen@linux.intel.com, seanjc@google.com, x86@kernel.org,
        yang.zhong@intel.com, jarkko@kernel.org
Subject: [PATCH v2 2/2] x86: sgx_vepc: implement SGX_IOC_VEPC_REMOVE ioctl
Date:   Tue, 12 Oct 2021 06:57:08 -0400
Message-Id: <20211012105708.2070480-3-pbonzini@redhat.com>
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

Some userspace implementations of virtual SGX would rather avoid having
to close and reopen the /dev/sgx_vepc file descriptor and re-mmap the
virtual EPC.  For example, they could sandbox themselves after the guest
starts and forbid further calls to open(), in order to mitigate exploits
from untrusted guests.

Therefore, add a ioctl that does this with EREMOVE.  Userspace can
invoke the ioctl to bring its vEPC pages back to uninitialized state.
There is a possibility that some pages fail to be removed if they are
SECS pages, and the child and SECS pages could be in separate vEPC
regions.  Therefore, the ioctl returns the number of EREMOVE failures,
telling userspace to try the ioctl again after it's done with all
vEPC regions.  A more verbose description of the correct usage and
the possible error conditions is documented in sgx.rst.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	v1->v2: return EBUSY for SGX_ENCLAVE_ACT, adjust docs
		add cond_resched

 Documentation/x86/sgx.rst       | 26 +++++++++++++++
 arch/x86/include/asm/sgx.h      |  3 ++
 arch/x86/include/uapi/asm/sgx.h |  2 ++
 arch/x86/kernel/cpu/sgx/virt.c  | 57 +++++++++++++++++++++++++++++++++
 4 files changed, 88 insertions(+)

diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
index dd0ac96ff9ef..7bc9c3b297d6 100644
--- a/Documentation/x86/sgx.rst
+++ b/Documentation/x86/sgx.rst
@@ -250,3 +250,29 @@ user wants to deploy SGX applications both on the host and in guests
 on the same machine, the user should reserve enough EPC (by taking out
 total virtual EPC size of all SGX VMs from the physical EPC size) for
 host SGX applications so they can run with acceptable performance.
+
+Architectural behavior is to restore all EPC pages to an uninitialized
+state also after a guest reboot.  Because this state can be reached only
+through the privileged ``ENCLS[EREMOVE]`` instruction, ``/dev/sgx_vepc``
+provides the ``SGX_IOC_VEPC_REMOVE_ALL`` ioctl to execute the instruction
+on all pages in the virtual EPC.
+
+``EREMOVE`` can fail for two reasons, which Linux relays to userspace
+in a different manner:
+
+1. Page removal will always fail when any thread is running in the
+   enclave to which the page belongs.  In this case the ioctl will
+   return ``EBUSY`` independent of whether it has successfully removed
+   some pages; userspace can avoid these failures by preventing execution
+   of any vcpu which maps the virtual EPC.
+
+2) Page removal will also fail for SGX "SECS" metadata pages which still
+   have child pages.  Child pages can be removed by executing
+   ``SGX_IOC_VEPC_REMOVE_ALL`` on all ``/dev/sgx_vepc`` file descriptors
+   mapped into the guest.  This means that the ioctl() must be called
+   twice: an initial set of calls to remove child pages and a subsequent
+   set of calls to remove SECS pages.  The second set of calls is only
+   required for those mappings that returned a nonzero value from the
+   first call.  It indicates a bug in the kernel or the userspace client
+   if any of the second round of ``SGX_IOC_VEPC_REMOVE_ALL`` calls has
+   a return code other than 0.
diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 05f3e21f01a7..2e5d8c97655e 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -50,6 +50,8 @@ enum sgx_encls_function {
  * %SGX_NOT_TRACKED:		Previous ETRACK's shootdown sequence has not
  *				been completed yet.
  * %SGX_CHILD_PRESENT		SECS has child pages present in the EPC.
+ * %SGX_ENCLAVE_ACT		One or more logical processors are executing
+ *				inside the enclave.
  * %SGX_INVALID_EINITTOKEN:	EINITTOKEN is invalid and enclave signer's
  *				public key does not match IA32_SGXLEPUBKEYHASH.
  * %SGX_UNMASKED_EVENT:		An unmasked event, e.g. INTR, was received
@@ -57,6 +59,7 @@ enum sgx_encls_function {
 enum sgx_return_code {
 	SGX_NOT_TRACKED			= 11,
 	SGX_CHILD_PRESENT		= 13,
+	SGX_ENCLAVE_ACT			= 14,
 	SGX_INVALID_EINITTOKEN		= 16,
 	SGX_UNMASKED_EVENT		= 128,
 };
diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 9690d6899ad9..f4b81587e90b 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -27,6 +27,8 @@ enum sgx_page_flags {
 	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
 #define SGX_IOC_ENCLAVE_PROVISION \
 	_IOW(SGX_MAGIC, 0x03, struct sgx_enclave_provision)
+#define SGX_IOC_VEPC_REMOVE_ALL \
+	_IO(SGX_MAGIC, 0x04)
 
 /**
  * struct sgx_enclave_create - parameter structure for the
diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 59cdf3f742ac..81a0a0f22007 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -150,6 +150,46 @@ static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
 	return 0;
 }
 
+static long sgx_vepc_remove_all(struct sgx_vepc *vepc)
+{
+	struct sgx_epc_page *entry;
+	unsigned long index;
+	long failures = 0;
+
+	xa_for_each(&vepc->page_array, index, entry) {
+		int ret = sgx_vepc_remove_page(entry);
+		switch (ret) {
+		case 0:
+			break;
+
+		case SGX_CHILD_PRESENT:
+			failures++;
+			break;
+
+		case SGX_ENCLAVE_ACT:
+			/*
+			 * Unlike in sgx_vepc_free_page, userspace could be calling
+			 * the ioctl while logical processors are running in the
+			 * enclave; do not warn.
+			 */
+			return -EBUSY;
+
+		default:
+			WARN_ONCE(1, EREMOVE_ERROR_MESSAGE, ret, ret);
+			failures++;
+			break;
+		}
+		cond_resched();
+	}
+
+	/*
+	 * Return the number of pages that failed to be removed, so
+	 * userspace knows that there are still SECS pages lying
+	 * around.
+	 */
+	return failures;
+}
+
 static int sgx_vepc_release(struct inode *inode, struct file *file)
 {
 	struct sgx_vepc *vepc = file->private_data;
@@ -235,9 +274,27 @@ static int sgx_vepc_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static long sgx_vepc_ioctl(struct file *file,
+			   unsigned int cmd, unsigned long arg)
+{
+	struct sgx_vepc *vepc = file->private_data;
+
+	switch (cmd) {
+	case SGX_IOC_VEPC_REMOVE_ALL:
+		if (arg)
+			return -EINVAL;
+		return sgx_vepc_remove_all(vepc);
+
+	default:
+		return -ENOTTY;
+	}
+}
+
 static const struct file_operations sgx_vepc_fops = {
 	.owner		= THIS_MODULE,
 	.open		= sgx_vepc_open,
+	.unlocked_ioctl	= sgx_vepc_ioctl,
+	.compat_ioctl	= sgx_vepc_ioctl,
 	.release	= sgx_vepc_release,
 	.mmap		= sgx_vepc_mmap,
 };
-- 
2.27.0

