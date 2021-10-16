Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B694300C7
	for <lists+kvm@lfdr.de>; Sat, 16 Oct 2021 09:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243774AbhJPHRC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Oct 2021 03:17:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50972 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243748AbhJPHQw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 16 Oct 2021 03:16:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634368484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LIEXF7lvWs+24Sue1ZLFYbi/zcZ8MPK/7gpw+rH+j98=;
        b=GGw8cb9BOwx+XiEwjWUNGztSmRxgWgR0w+ex5RIoQdrVTnu1UtpWv1V4/NA/3UtTKlQc3M
        1ziuLcTq2Dgev8xnNzuJSJIuYln90CpWs7pAOfMohlRO+D50zkZbbDOYhL3Qq6YzPK+mUJ
        QO5d4Pi3RIHch3yYkDb8+PMGHK2UpmA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-A68jDBC1OX2dRigZp31Qaw-1; Sat, 16 Oct 2021 03:14:39 -0400
X-MC-Unique: A68jDBC1OX2dRigZp31Qaw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B90DA8042F4;
        Sat, 16 Oct 2021 07:14:37 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F4F560657;
        Sat, 16 Oct 2021 07:14:37 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dave.hansen@linux.intel.com, seanjc@google.com, x86@kernel.org,
        yang.zhong@intel.com, jarkko@kernel.org, bp@suse.de
Subject: [PATCH v3 2/2] x86: sgx_vepc: implement SGX_IOC_VEPC_REMOVE ioctl
Date:   Sat, 16 Oct 2021 03:14:34 -0400
Message-Id: <20211016071434.167591-3-pbonzini@redhat.com>
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

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	v2->v3: return EBUSY for a general protection fault

 Documentation/x86/sgx.rst       | 35 +++++++++++++++++++++
 arch/x86/include/uapi/asm/sgx.h |  2 ++
 arch/x86/kernel/cpu/sgx/virt.c  | 51 +++++++++++++++++++++++++++++++++
 3 files changed, 88 insertions(+)

diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
index dd0ac96ff9ef..7bc9c3b297d6 100644
--- a/Documentation/x86/sgx.rst
+++ b/Documentation/x86/sgx.rst
@@ -250,3 +250,38 @@ user wants to deploy SGX applications both on the host and in guests
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
+``EREMOVE`` can fail for three reasons.  Userspace must pay attention
+to expected failures and handle them as follows:
+
+1. Page removal will always fail when any thread is running in the
+   enclave to which the page belongs.  In this case the ioctl will
+   return ``EBUSY`` independent of whether it has successfully removed
+   some pages; userspace can avoid these failures by preventing execution
+   of any vcpu which maps the virtual EPC.
+
+2. Page removal will cause a general protection fault if two calls to
+   ``EREMOVE`` happen concurrently for pages that refer to the same
+   "SECS" metadata pages.  This can happen if there are concurrent
+   invocations to ``SGX_IOC_VEPC_REMOVE_ALL``, or if a ``/dev/sgx_vepc``
+   file descriptor in the guest is closed at the same time as
+   ``SGX_IOC_VEPC_REMOVE_ALL``; it will also be reported as ``EBUSY``.
+   This can be avoided in userspace by serializing calls to the ioctl()
+   and to close(), but in general it should not be a problem.
+
+3. Finally, page removal will fail for SECS metadata pages which still
+   have child pages.  Child pages can be removed by executing
+   ``SGX_IOC_VEPC_REMOVE_ALL`` on all ``/dev/sgx_vepc`` file descriptors
+   mapped into the guest.  This means that the ioctl() must be called
+   twice: an initial set of calls to remove child pages and a subsequent
+   set of calls to remove SECS pages.  The second set of calls is only
+   required for those mappings that returned a nonzero value from the
+   first call.  It indicates a bug in the kernel or the userspace client
+   if any of the second round of ``SGX_IOC_VEPC_REMOVE_ALL`` calls has
+   a return code other than 0.
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
index 59cdf3f742ac..e8469bf68fd6 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -150,6 +150,39 @@ static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
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
+		if (ret) {
+			if (ret == SGX_CHILD_PRESENT) {
+				failures++;
+			} else {
+				/*
+				 * Unlike in sgx_vepc_free_page, userspace might
+				 * call the ioctl while logical processors are
+				 * running in the enclave, or cause faults due
+				 * to concurrent access to pages under the same
+				 * SECS.  So we cannot warn, we just report it.
+				 */
+				return -EBUSY;
+			}
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
@@ -235,9 +268,27 @@ static int sgx_vepc_open(struct inode *inode, struct file *file)
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

