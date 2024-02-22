Return-Path: <kvm+bounces-9408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3749085FDBF
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 17:12:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A7D51C20E1D
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 16:12:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB369154C02;
	Thu, 22 Feb 2024 16:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SNWym13g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C12A154445
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618282; cv=none; b=NHYXU4CCinAoHjEzcUohWGHli6JJGpPpUADoMMNoO4inp/AlG8RS9CDWwLHfHD0onGoPzU3VytUQ08KyEp9n27jvHx3F5C+5bPVmDBNYbDIAPsDdG9aN4+A+00eP9TGiQZ7U3t+zTk0JU8OOawScWnZVuzxzWhjr1ZpsPUpxz6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618282; c=relaxed/simple;
	bh=z/Ih8ZYT5NkMixOWg+Uyve5J68nFw5E7iGVbbYcEx3E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BdjsuUG6oSYXc1vYyF41R7AxwnrBO84O8Oud1yuud9aH4H+HNI5+DfHLHezjWpUvJQGADFFe87qspvoMEUAm4PvCsdiiYOtOB+pqxnTztHWuv3TwzevYdp1TLePDePEY8Qyv9In5Cb+E2b47rEhHK4WPQgUyLG6g836Otpi9rRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SNWym13g; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcbee93a3e1so10570705276.3
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 08:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618280; x=1709223080; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R9jqiln8R3A9VFnaGPClstGN9r3EmzNYJZRGHFrLYA8=;
        b=SNWym13gOGYjvg4dzYGqexNS+tYcWwBiw9R9Sa/odoIYK7EEpgsGMFQ+HkS/mSEyyU
         8ul9VTDNSwJS5PYeI15ombcJ7OX0WYCnUCKhRTXGWn2ya0yEujP73EQajlzo9Qil2Klh
         yWycSeS2M3DilF+TJjTl3UOYCIZ39QCzaWDcZEAcg0s2t1ph8beuoanVRkDuT1aLgML5
         ygT2YrzaOhT0LdzD8YDsJQeZ7WXw7Mf+83Z+5lS9XX8lk5K8ivTOywtQfVq5k3p639T8
         Xjq1IhEuuyFXBfGYnwm86EBkaYAzkWgXyyc1PcaAHr1ECeFysxr2Drdgu05uwRZmrC1O
         Uslw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618280; x=1709223080;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R9jqiln8R3A9VFnaGPClstGN9r3EmzNYJZRGHFrLYA8=;
        b=LbkG+LPcnBaTWc8fHxHRkO7BzlCse8DwLYqAeZICGZVZ+kN9nG4G0lwqsOtaRz/hBj
         zSCh+YRrCuuiVFhgPMCSakyipKT679Vor//sIs6J3aQRLEN7FSqO7k183CXMzFBSc6HG
         IQh3gAZ4aBiZ56AbcbzJJ8w2CLEgZBb6M9R/7HbjZU04w467lHmUi5pEvGTSviLdkRZz
         UHsCYcIsnuklDppTe+jnsf4ewh/V0wcUVLLWEnLz8z0D8x/9ZuKzczrciLpC/p8eQQCv
         7SF+4qIIgVksCGuQh4/MbuDfTpqMSb9ymc+TBJaIP/wtCXZvM+Z1MEbI7FY5lVdtud4a
         1JRQ==
X-Gm-Message-State: AOJu0Ywjkwee8WKl/cMDRvIZ8km45WbAHbvegKIRyxncIJLwNGv0eUoR
	q+4HEQ5RF+R3qRJP1QWzrCiYWFGXfdNZYaDXyn1m4HYx0nkkNIRPZt2dfNOIzaP0eHUciri2qC4
	8fWci4HxAY1nBrMaX5FXW1JBylyle/hJyvg5Ju7UjBxdUKEliTLO2MSzsDvNZEjadwdo4vPBnaF
	hz80qDQkn3mUUpuSJK7uDWYr4=
X-Google-Smtp-Source: AGHT+IGzluF9KV0uQ74p+P4M/V/9xG11z3AVlCw5UzMHVkr7rD/AoyFybmDhnZwJeOh0w7FWclLKEm9ISQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1081:b0:dc7:63e7:7a5c with SMTP id
 v1-20020a056902108100b00dc763e77a5cmr139205ybu.11.1708618279476; Thu, 22 Feb
 2024 08:11:19 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:33 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-13-tabba@google.com>
Subject: [RFC PATCH v1 12/26] KVM: arm64: Allow userspace to receive SHARE and
 UNSHARE notifications
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: Will Deacon <will@kernel.org>

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/arm.c        | 3 ++-
 arch/arm64/kvm/hypercalls.c | 8 +++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index cd6c4df27c7b..6bba6f1fee88 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -61,7 +61,8 @@ static DEFINE_PER_CPU(unsigned char, kvm_hyp_initialized);
 DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
 /* KVM "vendor" hypercalls which may be forwarded to userspace on request. */
-#define KVM_EXIT_HYPERCALL_VALID_MASK	(0)
+#define KVM_EXIT_HYPERCALL_VALID_MASK	(BIT(ARM_SMCCC_KVM_FUNC_MEM_SHARE) |	\
+					 BIT(ARM_SMCCC_KVM_FUNC_MEM_UNSHARE))
 
 bool is_kvm_arm_initialised(void)
 {
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 5e04be7c026a..b93546dd222f 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -83,6 +83,8 @@ static bool kvm_smccc_default_allowed(u32 func_id)
 	 */
 	case ARM_SMCCC_VERSION_FUNC_ID:
 	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
+	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID:
+	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_UNSHARE_FUNC_ID:
 		return true;
 	default:
 		/* PSCI 0.2 and up is in the 0:0x1f range */
@@ -132,7 +134,7 @@ static bool kvm_smccc_test_fw_bmap(struct kvm_vcpu *vcpu, u32 func_id)
 	}
 }
 
-static int __maybe_unused kvm_vcpu_exit_hcall(struct kvm_vcpu *vcpu, u32 nr, u32 nr_args)
+static int kvm_vcpu_exit_hcall(struct kvm_vcpu *vcpu, u32 nr, u32 nr_args)
 {
 	u64 mask = vcpu->kvm->arch.hypercall_exit_enabled;
 	u32 i;
@@ -398,6 +400,10 @@ int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
 		pkvm_host_reclaim_page(vcpu->kvm, smccc_get_arg1(vcpu));
 		val[0] = SMCCC_RET_SUCCESS;
 		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID:
+		return kvm_vcpu_exit_hcall(vcpu, ARM_SMCCC_KVM_FUNC_MEM_SHARE, 3);
+	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_UNSHARE_FUNC_ID:
+		return kvm_vcpu_exit_hcall(vcpu, ARM_SMCCC_KVM_FUNC_MEM_UNSHARE, 3);
 	case ARM_SMCCC_TRNG_VERSION:
 	case ARM_SMCCC_TRNG_FEATURES:
 	case ARM_SMCCC_TRNG_GET_UUID:
-- 
2.44.0.rc1.240.g4c46232300-goog


