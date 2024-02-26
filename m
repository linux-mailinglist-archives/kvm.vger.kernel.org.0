Return-Path: <kvm+bounces-9979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CCA1186806A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 20:06:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5935F1F24AF3
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:06:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 491C013247F;
	Mon, 26 Feb 2024 19:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jB+kvqb7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46C312FB10
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 19:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708974237; cv=none; b=Q0M9nZ4i0etnAfCPsGs79FPhIJ7dwj7rgDxY+4LFMLRKjYzZvukXRvTmAHyZ/Mo5hJ5ep40WTninxlwy2nQhdL9pxRLRz9QVqxP59rYbzr4KgtGbfzZlFX09uI2EvsJfd1R35hLgIvlWddBcsV2KuA1KpiPI8/mcnH4dYOJV618=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708974237; c=relaxed/simple;
	bh=ACV9GX05LP/uXF67efFuziAxbRY+oLm7ryO9IkGcD4I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CrRYIeN5+/c4NlbcWZNmvqToEtMdVMhIewk8CXQLxG/TaQBycjxzLLnFszNTj4vcPQRw1M+s36sAQ3nHuCD0jAOiij8e5d8SFrJj4M4RtYmzmPMTq02MdSkOADx+vn5HNkv7q/YZgC+iSmnQzcb2FVjo4/UM7MNedPr5ezkDASs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jB+kvqb7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708974230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3tt8a6opMBzdJFhAlpH3ZDJmOiKI7i0clbFhI4GnT6A=;
	b=jB+kvqb7wq5nTYH1fcOv0rEAuV5edflRJmXGOrdttj7dDMXYCQOOePz1JRRwp73/WoN4/U
	0BJDzRL63Xbf/may6Iq2fyWfsR2WEbqnsSDWgcSGi/pcIjPZEv8Q+vf+vgBRyz4bBEy9EE
	VWhPG6fqjyFrqawDNWjW0iejkXs5mdc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-KILAEtVQOzOhvJTNl1SuJw-1; Mon, 26 Feb 2024 14:03:48 -0500
X-MC-Unique: KILAEtVQOzOhvJTNl1SuJw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 883E3185A781;
	Mon, 26 Feb 2024 19:03:48 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 628DC400D784;
	Mon, 26 Feb 2024 19:03:48 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	aik@amd.com
Subject: [PATCH v3 14/15] KVM: SEV: introduce KVM_SEV_INIT2 operation
Date: Mon, 26 Feb 2024 14:03:43 -0500
Message-Id: <20240226190344.787149-15-pbonzini@redhat.com>
In-Reply-To: <20240226190344.787149-1-pbonzini@redhat.com>
References: <20240226190344.787149-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

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
 .../virt/kvm/x86/amd-memory-encryption.rst    | 40 +++++++++++++--
 arch/x86/include/uapi/asm/kvm.h               |  9 ++++
 arch/x86/kvm/svm/sev.c                        | 50 +++++++++++++++++--
 3 files changed, 92 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 5ed11bc16b96..b951d82af26c 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -75,15 +75,49 @@ are defined in ``<linux/psp-dev.h>``.
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
+        struct struct kvm_sev_init {
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
index 1248ccf433e8..909e67a9044b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -239,23 +239,30 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 	sev_decommission(handle);
 }
 
-static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
+static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
+			    struct kvm_sev_init *data,
+			    unsigned long vm_type)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	bool es_active = kvm->arch.has_protected_state;
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
-	sev->vmsa_features = 0;
+	sev->es_active = es_active;
+	sev->vmsa_features = data->vmsa_features;
 
 	ret = sev_asid_new(sev);
 	if (ret)
@@ -283,6 +290,38 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -1898,6 +1937,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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
2.39.1



