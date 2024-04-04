Return-Path: <kvm+bounces-13559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B510A898706
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 14:18:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 420141F2346B
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 12:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CF1886652;
	Thu,  4 Apr 2024 12:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LiOEkXmD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E46B86630
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 12:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712232831; cv=none; b=rECwM5GoRxxaaYOSdLetbGFXirzeOVuChLimcHUucXOs01pm8He0AvMQu1ZE7FrheebPQlGE7u8wpQnsxvCsR7Qy0B6wzMQi1+ObVdBB6hGEVWgA1iIffCRgoSEad/3R3pOKdVx3PuD5yjeCPDuvsGK8gANKNsEzbKFPSiur1QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712232831; c=relaxed/simple;
	bh=+myzatVI9VxIM1cG8DVKB+0WaYmY7ruOvQKnx3Vv4NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sJ6eVGCH6gPiKer+5QpA6lZneEtDNnH29HKdmoDGFgEF+rt81SbQip+x3buRCLr1xFfrUGytxFEc8Sk6bPve8acq2HUIlallZcfuPiClbhHrtwL4gjKgYUs7YHUjoH3M8X6wBdWg1E6/9NZ+w/mO1zbvId6l4IHRqZw3XSCqgg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LiOEkXmD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712232828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=huxq/rzsTXGccVaY7VQanT489IGWHYhc7g5YCajSUI4=;
	b=LiOEkXmD+l/07mO/0639MX/D71ce9Ml8NGaL92LGAZvrIhDSFu9nuG+N4fsQXO0gRO2MzN
	PmLcHNufzIrd/Pwl4DWbZ1hXJcR784cpvhS5pHI85xsJFujrWJwS2DM8VEksOyyJOCdqTE
	dXh14ywrCleDNX4dWYJfit84NF0+n1I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-zzWlr5tnOJWAmdPxPaXX_g-1; Thu, 04 Apr 2024 08:13:47 -0400
X-MC-Unique: zzWlr5tnOJWAmdPxPaXX_g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4084180A1A9;
	Thu,  4 Apr 2024 12:13:31 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1EC00492BCA;
	Thu,  4 Apr 2024 12:13:31 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com
Subject: [PATCH v5 15/17] selftests: kvm: switch to using KVM_X86_*_VM
Date: Thu,  4 Apr 2024 08:13:25 -0400
Message-ID: <20240404121327.3107131-16-pbonzini@redhat.com>
In-Reply-To: <20240404121327.3107131-1-pbonzini@redhat.com>
References: <20240404121327.3107131-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

This removes the concept of "subtypes", instead letting the tests use proper
VM types that were recently added.  While the sev_init_vm() and sev_es_init_vm()
are still able to operate with the legacy KVM_SEV_INIT and KVM_SEV_ES_INIT
ioctls, this is limited to VMs that are created manually with
vm_create_barebones().

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  5 ++--
 .../selftests/kvm/include/x86_64/processor.h  |  6 ----
 .../selftests/kvm/include/x86_64/sev.h        | 16 ++--------
 tools/testing/selftests/kvm/lib/kvm_util.c    |  1 -
 .../selftests/kvm/lib/x86_64/processor.c      | 14 +++++----
 tools/testing/selftests/kvm/lib/x86_64/sev.c  | 30 +++++++++++++++++--
 6 files changed, 40 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 7c06ceb36643..8acca8237687 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -93,7 +93,6 @@ enum kvm_mem_region_type {
 struct kvm_vm {
 	int mode;
 	unsigned long type;
-	uint8_t subtype;
 	int kvm_fd;
 	int fd;
 	unsigned int pgtable_levels;
@@ -200,8 +199,8 @@ enum vm_guest_mode {
 struct vm_shape {
 	uint32_t type;
 	uint8_t  mode;
-	uint8_t  subtype;
-	uint16_t padding;
+	uint8_t  pad0;
+	uint16_t pad1;
 };
 
 kvm_static_assert(sizeof(struct vm_shape) == sizeof(uint64_t));
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 81ce37ec407d..74a59c7ce7ed 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -23,12 +23,6 @@
 extern bool host_cpu_is_intel;
 extern bool host_cpu_is_amd;
 
-enum vm_guest_x86_subtype {
-	VM_SUBTYPE_NONE = 0,
-	VM_SUBTYPE_SEV,
-	VM_SUBTYPE_SEV_ES,
-};
-
 /* Forced emulation prefix, used to invoke the emulator unconditionally. */
 #define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
 
diff --git a/tools/testing/selftests/kvm/include/x86_64/sev.h b/tools/testing/selftests/kvm/include/x86_64/sev.h
index 8a1bf88474c9..0719f083351a 100644
--- a/tools/testing/selftests/kvm/include/x86_64/sev.h
+++ b/tools/testing/selftests/kvm/include/x86_64/sev.h
@@ -67,20 +67,8 @@ kvm_static_assert(SEV_RET_SUCCESS == 0);
 	__TEST_ASSERT_VM_VCPU_IOCTL(!ret, #cmd,	ret, vm);		\
 })
 
-static inline void sev_vm_init(struct kvm_vm *vm)
-{
-	vm->arch.sev_fd = open_sev_dev_path_or_exit();
-
-	vm_sev_ioctl(vm, KVM_SEV_INIT, NULL);
-}
-
-
-static inline void sev_es_vm_init(struct kvm_vm *vm)
-{
-	vm->arch.sev_fd = open_sev_dev_path_or_exit();
-
-	vm_sev_ioctl(vm, KVM_SEV_ES_INIT, NULL);
-}
+void sev_vm_init(struct kvm_vm *vm);
+void sev_es_vm_init(struct kvm_vm *vm);
 
 static inline void sev_register_encrypted_memory(struct kvm_vm *vm,
 						 struct userspace_mem_region *region)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index b2262b5fad9e..9da388100f3a 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -276,7 +276,6 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
 
 	vm->mode = shape.mode;
 	vm->type = shape.type;
-	vm->subtype = shape.subtype;
 
 	vm->pa_bits = vm_guest_mode_params[vm->mode].pa_bits;
 	vm->va_bits = vm_guest_mode_params[vm->mode].va_bits;
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 74a4c736c9ae..9f87ca8b7ab6 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -578,10 +578,11 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm)
 	sync_global_to_guest(vm, host_cpu_is_intel);
 	sync_global_to_guest(vm, host_cpu_is_amd);
 
-	if (vm->subtype == VM_SUBTYPE_SEV)
-		sev_vm_init(vm);
-	else if (vm->subtype == VM_SUBTYPE_SEV_ES)
-		sev_es_vm_init(vm);
+	if (vm->type == KVM_X86_SEV_VM || vm->type == KVM_X86_SEV_ES_VM) {
+		struct kvm_sev_init init = { 0 };
+
+		vm_sev_ioctl(vm, KVM_SEV_INIT2, &init);
+	}
 }
 
 void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code)
@@ -1081,9 +1082,12 @@ void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
 
 void kvm_init_vm_address_properties(struct kvm_vm *vm)
 {
-	if (vm->subtype == VM_SUBTYPE_SEV || vm->subtype == VM_SUBTYPE_SEV_ES) {
+	if (vm->type == KVM_X86_SEV_VM || vm->type == KVM_X86_SEV_ES_VM) {
+		vm->arch.sev_fd = open_sev_dev_path_or_exit();
 		vm->arch.c_bit = BIT_ULL(this_cpu_property(X86_PROPERTY_SEV_C_BIT));
 		vm->gpa_tag_mask = vm->arch.c_bit;
+	} else {
+		vm->arch.sev_fd = -1;
 	}
 }
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/sev.c b/tools/testing/selftests/kvm/lib/x86_64/sev.c
index e248d3364b9c..597994fa4f41 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/sev.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/sev.c
@@ -35,6 +35,32 @@ static void encrypt_region(struct kvm_vm *vm, struct userspace_mem_region *regio
 	}
 }
 
+void sev_vm_init(struct kvm_vm *vm)
+{
+	if (vm->type == KVM_X86_DEFAULT_VM) {
+		assert(vm->arch.sev_fd == -1);
+		vm->arch.sev_fd = open_sev_dev_path_or_exit();
+		vm_sev_ioctl(vm, KVM_SEV_INIT, NULL);
+	} else {
+		struct kvm_sev_init init = { 0 };
+		assert(vm->type == KVM_X86_SEV_VM);
+		vm_sev_ioctl(vm, KVM_SEV_INIT2, &init);
+	}
+}
+
+void sev_es_vm_init(struct kvm_vm *vm)
+{
+	if (vm->type == KVM_X86_DEFAULT_VM) {
+		assert(vm->arch.sev_fd == -1);
+		vm->arch.sev_fd = open_sev_dev_path_or_exit();
+		vm_sev_ioctl(vm, KVM_SEV_ES_INIT, NULL);
+	} else {
+		struct kvm_sev_init init = { 0 };
+		assert(vm->type == KVM_X86_SEV_ES_VM);
+		vm_sev_ioctl(vm, KVM_SEV_INIT2, &init);
+	}
+}
+
 void sev_vm_launch(struct kvm_vm *vm, uint32_t policy)
 {
 	struct kvm_sev_launch_start launch_start = {
@@ -91,10 +117,8 @@ struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t policy, void *guest_code,
 					   struct kvm_vcpu **cpu)
 {
 	struct vm_shape shape = {
-		.type = VM_TYPE_DEFAULT,
 		.mode = VM_MODE_DEFAULT,
-		.subtype = policy & SEV_POLICY_ES ? VM_SUBTYPE_SEV_ES :
-						    VM_SUBTYPE_SEV,
+		.type = policy & SEV_POLICY_ES ? KVM_X86_SEV_ES_VM : KVM_X86_SEV_VM,
 	};
 	struct kvm_vm *vm;
 	struct kvm_vcpu *cpus[1];
-- 
2.43.0



