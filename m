Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853EE411503
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 14:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238909AbhITMzi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 08:55:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55324 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238907AbhITMzg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 08:55:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632142449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l6mk+n34sfL1pXWuYCuaJUnLQS89NC9xSQSnu2eYuTo=;
        b=QxxO1bqy55hRyamErCphjpqyvl5TALeAo6GBQ56SrRiYy0KNYIiCXuZvpfC17mNOB2+FFD
        JKxLkbjFllLJWftKUPKf+Ha5oDps0W+g0nI974mktXTnYgOXZErzSXDWjnKAsm984d8tCU
        YfpvT9GSnRoCEGB+yWa14F62kkFlekM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-C1VAFJgPPvGGr1GnEqwMwA-1; Mon, 20 Sep 2021 08:54:06 -0400
X-MC-Unique: C1VAFJgPPvGGr1GnEqwMwA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 495221084688;
        Mon, 20 Sep 2021 12:54:04 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B21151346F;
        Mon, 20 Sep 2021 12:54:03 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
Subject: [PATCH 2/2] x86: sgx_vepc: implement SGX_IOC_VEPC_REMOVE_ALL ioctl
Date:   Mon, 20 Sep 2021 08:54:01 -0400
Message-Id: <20210920125401.2389105-3-pbonzini@redhat.com>
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

Some userspace implementations of virtual SGX would rather avoid having
to close and reopen the /dev/sgx_vepc file descriptor and re-mmap the
virtual EPC.  For example, they could be sandboxing themselves before the
guest starts in order to mitigate exploits from untrusted guests,
forbidding further calls to open().

Therefore, add a ioctl that does this with EREMOVE.  Userspace can
invoke the ioctl to bring its vEPC pages back to uninitialized state.
There is a possibility that some pages fail to be removed if they are
SECS pages, so the ioctl returns the number of EREMOVE failures.  The
correct usage is documented in sgx.rst.

Tested-by: Yang Zhong <yang.zhong@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/x86/sgx.rst       | 14 +++++++++++++
 arch/x86/include/uapi/asm/sgx.h |  2 ++
 arch/x86/kernel/cpu/sgx/virt.c  | 36 +++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+)

diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
index dd0ac96ff9ef..b855db96c6c6 100644
--- a/Documentation/x86/sgx.rst
+++ b/Documentation/x86/sgx.rst
@@ -250,3 +250,17 @@ user wants to deploy SGX applications both on the host and in guests
 on the same machine, the user should reserve enough EPC (by taking out
 total virtual EPC size of all SGX VMs from the physical EPC size) for
 host SGX applications so they can run with acceptable performance.
+
+Some guests, such as Windows, require that all pages are uninitialized
+at startup or after a guest reboot.  Because this state can be reached
+only through the privileged ``ENCLS[EREMOVE]`` instruction, ``/dev/sgx_vepc``
+provides the ``SGX_IOC_VEPC_REMOVE_ALL`` ioctl to execute the instruction on
+all pages in the virtual EPC.
+
+The ioctl will often not able to remove SECS pages, in case their child
+pages have not gone through ``EREMOVE`` yet; therefore, the ioctl returns the
+number of pages that failed to be removed.  ``SGX_IOC_VEPC_REMOVE_ALL`` should
+first be invoked on all the ``/dev/sgx_vepc`` file descriptors mapped
+into the guest; a second call to the ioctl will be able to remove all
+leftover pages and will return 0.  Any other return value on the second call
+would be a symptom of a bug in either Linux or the userspace client.
diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 9690d6899ad9..f79d84ce8033 100644
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
index 59b9c13121cd..81dc186fda2e 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -154,6 +154,24 @@ static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
 	return 0;
 }
 
+static long sgx_vepc_remove_all(struct sgx_vepc *vepc)
+{
+	struct sgx_epc_page *entry;
+	unsigned long index;
+	long failures = 0;
+
+	xa_for_each(&vepc->page_array, index, entry)
+		if (sgx_vepc_remove_page(entry))
+			failures++;
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
@@ -239,9 +257,27 @@ static int sgx_vepc_open(struct inode *inode, struct file *file)
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

