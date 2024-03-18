Return-Path: <kvm+bounces-12056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 96FDC87F415
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 00:36:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F1893B22D7D
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:35:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BE79605C6;
	Mon, 18 Mar 2024 23:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hTt9iVwj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629F55FBBA
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 23:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710804844; cv=none; b=YCfKQ9s/+yHmCsvdTWzgIht+UM0mdTqJtoOilufAFAa9PoJrSuLVyGiOoDHR4C7Zdu7Takgp8Z25LshDkIFD3zEMnRhDAPsYeLx2scut0I+lMp+SD2DGItRYrQKbN4QwMSqPV0fQ67VZsp9GAsS1jKOkYkWLlh6gMBh//rfL1Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710804844; c=relaxed/simple;
	bh=gVhXZp7D2FX+RWTWnzcYfGuPus3+3YFukcYrvmieSsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GmbHs4E3Dbi/1K7DffMJUXvoIUQcm51ee9xzI7HHHeAMf6YorRzyvgfhrJTn9qIW0/yCilRIBxiu5gBM3uDZF3c19/bdnTkFayrOTIIjlBw0v8QMhY6RaTus27CD3SV+Jej7upfIYRVb4BjZAQLSYAA2mAXbrS0WV5zyvk9MWnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hTt9iVwj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710804841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fkB/jZzJWu6iGlLIjwIwVN9PbRsSCEpGznj0vBuSrWQ=;
	b=hTt9iVwjUwxLYtW0RtG3Rnkwe+dE296rvw+C1fCAAQC/QS9T8yguOwR450DFvFcN/jcN/D
	33Ff3e5lXY5SmFSIqFSG0MWv0/tEsoz5/ufBmor0gD4r/KRm/iZXTFn3O6/+Yem2W9sMEe
	iXL7e3y/udUIHzP59wpVLzVcQzoqFfo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-222-0urRuAKXP7m47rsA74xufg-1; Mon,
 18 Mar 2024 19:33:57 -0400
X-MC-Unique: 0urRuAKXP7m47rsA74xufg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4EF233C0245A;
	Mon, 18 Mar 2024 23:33:56 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2923B1C060A4;
	Mon, 18 Mar 2024 23:33:56 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com,
	seanjc@google.com
Subject: [PATCH v4 12/15] KVM: SEV: introduce KVM_SEV_INIT2 operation
Date: Mon, 18 Mar 2024 19:33:49 -0400
Message-ID: <20240318233352.2728327-13-pbonzini@redhat.com>
In-Reply-To: <20240318233352.2728327-1-pbonzini@redhat.com>
References: <20240318233352.2728327-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

The idea that no parameter would ever be necessary when enabling SEV or
SEV-ES for a VM was decidedly optimistic.  In fact, in some sense it's
already a parameter whether SEV or SEV-ES is desired.  Another possible
source of variability is the desired set of VMSA features, as that affects
the measurement of the VM's initial state and cannot be changed
arbitrarily by the hypervisor.

Create a new sub-operation for KVM_MEMORY_ENCRYPT_OP that can take a struct,
and put the new op to work by including the VMSA features as a field of the
struct.  The existing KVM_SEV_INIT and KVM_SEV_ES_INIT use the full set of
supported VMSA features for backwards compatibility.

The struct also includes the usual bells and whistles for future
extensibility: a flags field that must be zero for now, and some padding
at the end.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    | 40 ++++++++++++--
 arch/x86/include/uapi/asm/kvm.h               |  9 ++++
 arch/x86/kvm/svm/sev.c                        | 53 ++++++++++++++++---
 3 files changed, 92 insertions(+), 10 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index fb41470c0310..f7c007d34114 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -76,15 +76,49 @@ are defined in ``<linux/psp-dev.h>``.
 KVM implements the following commands to support common lifecycle events of SEV
 guests, such as launching, running, snapshotting, migrating and decommissioning.
 
-1. KVM_SEV_INIT
----------------
+1. KVM_SEV_INIT2
+----------------
 
-The KVM_SEV_INIT command is used by the hypervisor to initialize the SEV platform
+The KVM_SEV_INIT2 command is used by the hypervisor to initialize the SEV platform
 context. In a typical workflow, this command should be the first command issued.
 
+For this command to be accepted, either KVM_X86_SEV_VM or KVM_X86_SEV_ES_VM
+must have been passed to the KVM_CREATE_VM ioctl.  A virtual machine created
+with those machine types in turn cannot be run until KVM_SEV_INIT2 is invoked.
+
+Parameters: struct kvm_sev_init (in)
 
 Returns: 0 on success, -negative on error
 
+::
+
+        struct kvm_sev_init {
+                __u64 vmsa_features;  /* initial value of features field in VMSA */
+                __u32 flags;          /* must be 0 */
+                __u32 pad[9];
+        };
+
+It is an error if the hypervisor does not support any of the bits that
+are set in ``flags`` or ``vmsa_features``.  ``vmsa_features`` must be
+0 for SEV virtual machines, as they do not have a VMSA.
+
+This command replaces the deprecated KVM_SEV_INIT and KVM_SEV_ES_INIT commands.
+The commands did not have any parameters (the ```data``` field was unused) and
+only work for the KVM_X86_DEFAULT_VM machine type (0).
+
+They behave as if:
+
+* the VM type is KVM_X86_SEV_VM for KVM_SEV_INIT, or KVM_X86_SEV_ES_VM for
+  KVM_SEV_ES_INIT
+
+* the ``flags`` and ``vmsa_features`` fields of ``struct kvm_sev_init`` are
+  set to zero
+
+If the ``KVM_X86_SEV_VMSA_FEATURES`` attribute does not exist, the hypervisor only
+supports KVM_SEV_INIT and KVM_SEV_ES_INIT.  In that case, note that KVM_SEV_ES_INIT
+might set the debug swap VMSA feature (bit 5) depending on the value of the
+``debug_swap`` parameter of ``kvm-amd.ko``.
+
 2. KVM_SEV_LAUNCH_START
 -----------------------
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 9d950b0b64c9..51b13080ed4b 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -690,6 +690,9 @@ enum sev_cmd_id {
 	/* Guest Migration Extension */
 	KVM_SEV_SEND_CANCEL,
 
+	/* Second time is the charm; improved versions of the above ioctls.  */
+	KVM_SEV_INIT2,
+
 	KVM_SEV_NR_MAX,
 };
 
@@ -701,6 +704,12 @@ struct kvm_sev_cmd {
 	__u32 sev_fd;
 };
 
+struct kvm_sev_init {
+	__u64 vmsa_features;
+	__u32 flags;
+	__u32 pad[9];
+};
+
 struct kvm_sev_launch_start {
 	__u32 handle;
 	__u32 policy;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7c2b0471b92c..dc22b31faebd 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -240,27 +240,31 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 	sev_decommission(handle);
 }
 
-static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
+static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
+			    struct kvm_sev_init *data,
+			    unsigned long vm_type)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_platform_init_args init_args = {0};
+	bool es_active = vm_type != KVM_X86_SEV_VM;
+	u64 valid_vmsa_features = es_active ? sev_supported_vmsa_features : 0;
 	int ret;
 
 	if (kvm->created_vcpus)
 		return -EINVAL;
 
-	if (kvm->arch.vm_type != KVM_X86_DEFAULT_VM)
+	if (data->flags)
+		return -EINVAL;
+
+	if (data->vmsa_features & ~valid_vmsa_features)
 		return -EINVAL;
 
 	if (unlikely(sev->active))
 		return -EINVAL;
 
 	sev->active = true;
-	sev->es_active = argp->id == KVM_SEV_ES_INIT;
-	sev->vmsa_features = sev_supported_vmsa_features;
-	if (sev_supported_vmsa_features)
-		pr_warn_once("Enabling DebugSwap with KVM_SEV_ES_INIT. "
-			     "This will not work starting with Linux 6.10\n");
+	sev->es_active = es_active;
+	sev->vmsa_features = data->vmsa_features;
 
 	ret = sev_asid_new(sev);
 	if (ret)
@@ -290,6 +294,38 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_init data = {
+		.vmsa_features = 0,
+	};
+	unsigned long vm_type;
+
+	if (kvm->arch.vm_type != KVM_X86_DEFAULT_VM)
+		return -EINVAL;
+
+	vm_type = (argp->id == KVM_SEV_INIT ? KVM_X86_SEV_VM : KVM_X86_SEV_ES_VM);
+	return __sev_guest_init(kvm, argp, &data, vm_type);
+}
+
+static int sev_guest_init2(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_init data;
+
+	if (!sev->need_init)
+		return -EINVAL;
+
+	if (kvm->arch.vm_type != KVM_X86_SEV_VM &&
+	    kvm->arch.vm_type != KVM_X86_SEV_ES_VM)
+		return -EINVAL;
+
+	if (copy_from_user(&data, u64_to_user_ptr(argp->data), sizeof(data)))
+		return -EFAULT;
+
+	return __sev_guest_init(kvm, argp, &data, kvm->arch.vm_type);
+}
+
 static int sev_bind_asid(struct kvm *kvm, unsigned int handle, int *error)
 {
 	unsigned int asid = sev_get_asid(kvm);
@@ -1940,6 +1976,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_INIT:
 		r = sev_guest_init(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_INIT2:
+		r = sev_guest_init2(kvm, &sev_cmd);
+		break;
 	case KVM_SEV_LAUNCH_START:
 		r = sev_launch_start(kvm, &sev_cmd);
 		break;
-- 
2.43.0



