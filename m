Return-Path: <kvm+bounces-42355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F18F3A7800A
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:18:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A99A1188EA0E
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:17:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 059A22222B8;
	Tue,  1 Apr 2025 16:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RlvjR329"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D701221F01
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523933; cv=none; b=PiKzoXiU8IfxuWYkhZc53LRzrjDcfOl5Yv21p934jOXLkcMp6K2zR5Li9iUI0BCpzW98f0srpErEyqMQ9EielnXg0RvtrbOnoxyOtLX4sOjJmC/aC2mIfOaGUxriRw4ZUBZBhKUrMer4M9dQaaPgbFQkx1cHP+QQIifxQqWhquE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523933; c=relaxed/simple;
	bh=6R6OEQxDgjR/HZg6sCVP87ZgC7PikBueK2/660D907Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9XWdpTjzSx0WvG3h9iIqj+lOrt7J8IJE2FeIVgmSPPihTSVvWEJtSlDn79v4mIFh6ngkPGvgFThgeKxr3l7vJSLUgTtYvAP+ZMDpUSlsVZR40CaZgoEz4bdpgIN79FsnJ9mKIjT4FrhloEX72jxPWyiNregcafgaugm7e70hsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RlvjR329; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kkUQYRtnACncLvUHjuKhMmXCrd7LF2Jtv0MEz++g5Qo=;
	b=RlvjR329KmT2/jtSFaZz9te3ccG8O8vK1VM3EIc5Xt/oWwTFX6nzIoh0zOVFZPbJ3BQl7F
	/1DPJmJmQv441Nwm5sQ89Qf4AbPK6C7cqIFajarcG6oWmFnDoTKFzbYzdrXhWv2F3ywI84
	lKZMF2pDWlOZIHl6GnnS5ST2mLZ2oAA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-DgSNDbNePwSormcbKW4vxw-1; Tue, 01 Apr 2025 12:12:08 -0400
X-MC-Unique: DgSNDbNePwSormcbKW4vxw-1
X-Mimecast-MFC-AGG-ID: DgSNDbNePwSormcbKW4vxw_1743523927
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43cf172ff63so37522875e9.3
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:12:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523927; x=1744128727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kkUQYRtnACncLvUHjuKhMmXCrd7LF2Jtv0MEz++g5Qo=;
        b=PMkAiHzC7Mf5er/3RL3OnlljN4XygS1fwUtiXLAHyCCHE8hCgpecXq/2H7yXfeH67n
         mo5Z1KTHE+XHwLKXqPLcqDmjBa6CuvicswOLy5AyMcxJagEDbU9GQGqMqUnKxJn7JDyT
         CwX1NVk4RnF8PTREFxfSHWTI5657HDycLRcDQ6fD1rwm4s4Z+Vho0qpbCb1G+TA3THbq
         aPnAFskhjJhyBSGwa2VD0Ms35aFHK9e0YvP3/29dRdQd0rtCMht3+P8/TuJ6AbUUaOhM
         77FrZY4/1WhkUm5J6JSgQVwyNKS7LaaTrLzh5pI8E0Wela42rw2Dsy3mUi5wphbxPkyC
         YT9w==
X-Forwarded-Encrypted: i=1; AJvYcCWhWleZjy+zXBqUs4EmJT7VjHkDQ4Vb43eZvSvc8ukqqJJ/N8qyPHAWNJoO1t7nQq5JAXs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqPHjyBTeY8tN40Z/6B+6aIEZfWttiGGHEUWO1RKo0B5CbF3ZG
	lCJct1zt2P8AZofaR5X1ZGDiGVZvkZ59Mq7Mkky9nFbdbDugQqrC4MBmvDWP0qn0FoIsosGUG0m
	pEfMd02TlkDhhXzblSde2fjDMqszc68n6/C7nAiiwG87CUOoKuw==
X-Gm-Gg: ASbGncu/jjH5H5sAayOFPfdEAdU5cGg021VPyK5btHp4LBv+1VYFHyLJ4tcry/3Th5I
	5QD1Pd/EzTD19/HLPi0aOjjkq9I5f5usoy46nCvGKHN5beVrOJl/YB+e0GB9KvNftIPXWbYFA4/
	/mIQD99vVLdoEwEkkL4gk2VwWAhaIquwVoxMo4167DQstnqPcfrIbgyBoZ8RDs/Z7P8pbUp6S+W
	rD4PLy7O3aV09oeHTWbSeSQ1xb/q9wuIMOYVUPwe1cx2wTLIL2cIZt4C4EwuCK+h8HP2ptv6hhe
	AmfyKC0AOlweLKTD2j/Vag==
X-Received: by 2002:a05:600c:6792:b0:43c:e9f7:d6a3 with SMTP id 5b1f17b1804b1-43ea7c717femr33648845e9.13.1743523927322;
        Tue, 01 Apr 2025 09:12:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGnhM5o4ZnKjk9+MG32jGQEDPKEoKojaSrwXizsO3e6J/Rj02GKdm3qrLDu+19IPPoL3w0DsA==
X-Received: by 2002:a05:600c:6792:b0:43c:e9f7:d6a3 with SMTP id 5b1f17b1804b1-43ea7c717femr33648325e9.13.1743523926906;
        Tue, 01 Apr 2025 09:12:06 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d82e83482sm207511105e9.14.2025.04.01.09.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:12:05 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: roy.hopkins@suse.com,
	seanjc@google.com,
	thomas.lendacky@amd.com,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	jroedel@suse.de,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com
Subject: [PATCH 21/29] KVM: x86: add infrastructure to share FPU across planes
Date: Tue,  1 Apr 2025 18:10:58 +0200
Message-ID: <20250401161106.790710-22-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250401161106.790710-1-pbonzini@redhat.com>
References: <20250401161106.790710-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Wrap fpu_alloc_guest_fpstate() and fpu_free_guest_fpstate() so that only
one FPU exists for vCPUs that are in different planes but share the same
vCPU id.

This API could be handy for VTL implementation but it may be tricky
because for some registers sharing would be a bad idea (even MPX right
now if it weren't deprecated, but APX in the future could be worse).

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/x86.c              | 47 ++++++++++++++++++++++++++++-----
 2 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 283d8a4b5b14..9ac39f128a53 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1347,6 +1347,7 @@ struct kvm_arch {
 	unsigned int indirect_shadow_pages;
 	u8 mmu_valid_gen;
 	u8 vm_type;
+	bool planes_share_fpu;
 	bool has_private_mem;
 	bool has_protected_state;
 	bool pre_fault_allowed;
@@ -2447,4 +2448,6 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
  */
 #define KVM_EXIT_HYPERCALL_MBZ		GENMASK_ULL(31, 1)
 
+bool kvm_arch_planes_share_fpu(struct kvm *kvm);
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ce8e623052a7..ebdbd08a840b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6626,6 +6626,17 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.triple_fault_event = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_PLANES_FPU:
+		r = -EINVAL;
+		if (atomic_read(&kvm->online_vcpus))
+			break;
+		if (cap->args[0] > 1)
+			break;
+		if (cap->args[0] && kvm->arch.has_protected_state)
+			break;
+		kvm->arch.planes_share_fpu = cap->args[0];
+		r = 0;
+		break;
 	case KVM_CAP_X86_USER_SPACE_MSR:
 		r = -EINVAL;
 		if (cap->args[0] & ~KVM_MSR_EXIT_REASON_VALID_MASK)
@@ -12332,6 +12343,27 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	return kvm_x86_call(vcpu_precreate)(kvm);
 }
 
+static void kvm_free_guest_fpstate(struct kvm_vcpu *vcpu, unsigned plane)
+{
+	if (plane == 0 || !vcpu->kvm->arch.planes_share_fpu)
+		fpu_free_guest_fpstate(&vcpu->arch.guest_fpu);
+}
+
+static int kvm_init_guest_fpstate(struct kvm_vcpu *vcpu, struct kvm_vcpu *plane0_vcpu)
+{
+	if (plane0_vcpu && vcpu->kvm->arch.planes_share_fpu) {
+		vcpu->arch.guest_fpu = plane0_vcpu->arch.guest_fpu;
+		return 0;
+	}
+
+	if (!fpu_alloc_guest_fpstate(&vcpu->arch.guest_fpu)) {
+		pr_err("failed to allocate vcpu's fpu\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu, struct kvm_plane *plane)
 {
 	struct page *page;
@@ -12378,10 +12410,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu, struct kvm_plane *plane)
 	if (!alloc_emulate_ctxt(vcpu))
 		goto free_wbinvd_dirty_mask;
 
-	if (!fpu_alloc_guest_fpstate(&vcpu->arch.guest_fpu)) {
-		pr_err("failed to allocate vcpu's fpu\n");
+	if (kvm_init_guest_fpstate(vcpu, plane->plane ? vcpu->plane0 : NULL) < 0)
 		goto free_emulate_ctxt;
-	}
 
 	kvm_async_pf_hash_reset(vcpu);
 
@@ -12413,7 +12443,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu, struct kvm_plane *plane)
 	return 0;
 
 free_guest_fpu:
-	fpu_free_guest_fpstate(&vcpu->arch.guest_fpu);
+	kvm_free_guest_fpstate(vcpu, plane->plane);
 free_emulate_ctxt:
 	kmem_cache_free(x86_emulator_cache, vcpu->arch.emulate_ctxt);
 free_wbinvd_dirty_mask:
@@ -12459,7 +12489,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 	kmem_cache_free(x86_emulator_cache, vcpu->arch.emulate_ctxt);
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
-	fpu_free_guest_fpstate(&vcpu->arch.guest_fpu);
+	kvm_free_guest_fpstate(vcpu, vcpu->plane);
 
 	kvm_xen_destroy_vcpu(vcpu);
 	kvm_hv_vcpu_uninit(vcpu);
@@ -12824,7 +12854,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.apic_bus_cycle_ns = APIC_BUS_CYCLE_NS_DEFAULT;
 	kvm->arch.guest_can_read_msr_platform_info = true;
 	kvm->arch.enable_pmu = enable_pmu;
-
+	kvm->arch.planes_share_fpu = false;
 #if IS_ENABLED(CONFIG_HYPERV)
 	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
 	kvm->arch.hv_root_tdp = INVALID_PAGE;
@@ -13881,6 +13911,11 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 }
 EXPORT_SYMBOL_GPL(kvm_handle_invpcid);
 
+bool kvm_arch_planes_share_fpu(struct kvm *kvm)
+{
+	return !kvm || kvm->arch.planes_share_fpu;
+}
+
 static int complete_sev_es_emulated_mmio(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
-- 
2.49.0


