Return-Path: <kvm+bounces-8472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F62F84FC17
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 19:40:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D18972814F6
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 18:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75092129A70;
	Fri,  9 Feb 2024 18:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ibl3e4Wz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C96A84A3F
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 18:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707503874; cv=none; b=f9ybM86am1hEODJhjTOaUDDoTZ61ozIfDM7n8VOQfVSlPAT1ZFppdmqxBTgJNUIrod8hrzHePkIO4K7jDrWQH1FvLdr3MxRgYJv+ljMNpQUDmr18XMizZjtQzYvmQ5R549OOu2XPAaARqPBK/n8OURjmScRIB65A9dh2abmIvTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707503874; c=relaxed/simple;
	bh=Gv/Kr8TOzPt0rp3aa81lJO/6g/pp+CHZVu5w3lMoNB8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mBUdbPfLzt51r8ImuvOghqSWoRtSdR1biwdba/tNSD2fZGMm5NYU73kLbqwHYBPoiY0EmCA64OAlgPpMfxnoDGfS4GA6eUX5kr+WvnQOG7mfwbipxKd6c851hSbg32sH++P007MXgIOpfmU3KIe/7ZogCZLLAdT100jm64zrjJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ibl3e4Wz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707503871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KMuM2iDsKyRXLwOQwCqQqqcOLqtJ/Pinx6UZ/VSyKIk=;
	b=Ibl3e4WzC7wQwcO4EHMkeQzyp5EUvjp8gm3gxs6UfmC0ru/zSzzsMMrnVAc3uj047z+mKB
	YT8HZqsqwNUHrj80oxJ33gBwMuJrXFtL5S/add1F7bOetCoes/g0dPvHnW3zfuMadYAPeh
	ZC0gS6k1CI1sF1mc6H7jRPGxX8vuOAc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-Z88hIqB6NMWbVDBrYewrdA-1; Fri, 09 Feb 2024 13:37:46 -0500
X-MC-Unique: Z88hIqB6NMWbVDBrYewrdA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD37810665A0;
	Fri,  9 Feb 2024 18:37:45 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AF969492BC6;
	Fri,  9 Feb 2024 18:37:45 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	aik@amd.com,
	isaku.yamahata@intel.com
Subject: [PATCH 09/10] KVM: SEV: introduce KVM_SEV_INIT2 operation
Date: Fri,  9 Feb 2024 13:37:41 -0500
Message-Id: <20240209183743.22030-10-pbonzini@redhat.com>
In-Reply-To: <20240209183743.22030-1-pbonzini@redhat.com>
References: <20240209183743.22030-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

The idea that no parameter would ever be necessary when enabling SEV or
SEV-ES for a VM was decidedly optimistic.  In fact, in some sense it's
already a parameter whether SEV or SEV-ES is desired.  Another possible
source of variability is the desired set of VMSA features, as that affects
the measurement of the VM's initial state and cannot be changed
arbitrarily by the hypervisor.

Create a new sub-operation for KVM_MEM_ENCRYPT_OP that can take a struct,
and put the new op to work by including the VMSA features as a field of the
struct.  The existing KVM_SEV_INIT and KVM_SEV_ES_INIT use the full set of
supported VMSA features for backwards compatibility.

The struct also includes the usual bells and whistles for future
extensibility: a flags field that must be zero for now, and some padding
at the end.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    | 41 ++++++++++++++--
 arch/x86/include/uapi/asm/kvm.h               | 10 ++++
 arch/x86/kvm/svm/sev.c                        | 48 +++++++++++++++++--
 3 files changed, 92 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 5ed11bc16b96..a4291e7bd8ed 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -75,15 +75,50 @@ are defined in ``<linux/psp-dev.h>``.
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
+                __u32 flags;          /* must be 0 */
+                __u64 vmsa_features;  /* initial value of features field in VMSA */
+                __u32 pad[8];
+        };
+
+It is an error if the hypervisor does not support any of the bits that
+are set in ``flags`` or ``vmsa_features``.
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
+* the ``flags`` field of ``struct kvm_sev_init`` is set to zero
+
+* the ``vmsa_features`` field of ``struct kvm_sev_init`` is set to all features
+  supported by the hypervisor (as returned by ``KVM_GET_DEVICE_ATTR`` when
+  passed group 0 and attribute id ``KVM_X86_SEV_VMSA_FEATURES``).
+
+If the ``KVM_X86_SEV_VMSA_FEATURES`` attribute does not exist, the hypervisor only
+supports KVM_SEV_INIT and KVM_SEV_ES_INIT.  In that case the set of VMSA features is
+undefined.
+
 2. KVM_SEV_LAUNCH_START
 -----------------------
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 7c46e96cfe62..6baf18335c7b 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -683,6 +683,9 @@ enum sev_cmd_id {
 	/* Guest Migration Extension */
 	KVM_SEV_SEND_CANCEL,
 
+	/* Second time is the charm; improved versions of the above ioctls.  */
+	KVM_SEV_INIT2,
+
 	KVM_SEV_NR_MAX,
 };
 
@@ -694,6 +697,13 @@ struct kvm_sev_cmd {
 	__u32 sev_fd;
 };
 
+struct kvm_sev_init {
+	__u32 vm_type;
+	__u32 flags;
+	__u64 vmsa_features;
+	__u32 pad[8];
+};
+
 struct kvm_sev_launch_start {
 	__u32 handle;
 	__u32 policy;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index acf5c45ef14e..78c52764453f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -252,7 +252,9 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 	sev_decommission(handle);
 }
 
-static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
+static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
+			    struct kvm_sev_init *data,
+			    unsigned long vm_type)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	int asid, ret;
@@ -260,7 +262,10 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (kvm->created_vcpus)
 		return -EINVAL;
 
-	if (kvm->arch.vm_type != KVM_X86_DEFAULT_VM)
+	if (data->flags)
+		return -EINVAL;
+
+	if (data->vmsa_features & ~sev_supported_vmsa_features)
 		return -EINVAL;
 
 	ret = -EBUSY;
@@ -268,8 +273,8 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		return ret;
 
 	sev->active = true;
-	sev->es_active = argp->id == KVM_SEV_ES_INIT;
-	sev->vmsa_features = sev_supported_vmsa_features;
+	sev->es_active = (vm_type & __KVM_X86_PROTECTED_STATE_TYPE) != 0;
+	sev->vmsa_features = data->vmsa_features;
 
 	asid = sev_asid_new(sev);
 	if (asid < 0)
@@ -298,6 +303,38 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_init data = {
+		.vmsa_features = sev_supported_vmsa_features,
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
+	if (copy_from_user(&data, (void __user *)(uintptr_t)argp->data, sizeof(data)))
+		return -EFAULT;
+
+	return __sev_guest_init(kvm, argp, &data, kvm->arch.vm_type);
+}
+
 static int sev_bind_asid(struct kvm *kvm, unsigned int handle, int *error)
 {
 	struct sev_data_activate activate;
@@ -1915,6 +1952,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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
2.39.0



