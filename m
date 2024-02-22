Return-Path: <kvm+bounces-9407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7349985FDBE
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 17:12:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DE69CB2A8CA
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 16:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C9A6151CEA;
	Thu, 22 Feb 2024 16:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gG4VOgeh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B56153BDE
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618280; cv=none; b=C/vZAtd9is66rrGX0QhCb8TX9nu9EA6MlXnWxuAtLgXAZV1rbDyKYGSJQOvkcNCVvhqqR8H+mERM/E2/qmCOTbbJiYoYHoVBky9Bkx/wC/CUqbI3HBx3VJ/rQ0eRu2ooy8NI3hV6/nui5WTlQE1ThDIr6JMHKI6pzb54G6PLsWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618280; c=relaxed/simple;
	bh=K2jUeoVXhrObEu5srpCVm7xwdKmVYTP7LlgnH3ByD1Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=quMBhmG7ERJi0eCFoI3J3Ynx3G+R0bl3A0Xqcj9YZUUdUp6Qnbt02gZqg7KWzmKTPjqYNkCVe4hgluFKao3Bo+xp6jxhuzzxSAtJnRJNlCeeshWhJ/caqYwVFjyBx9SOMvFMUJfgyY/WP3b8CkpoRQ8PGxFieE9YUqGB4zdIn4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gG4VOgeh; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6047fed0132so122259067b3.1
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 08:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618277; x=1709223077; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yBF7jJN1+Xu+ov0cdEcK8kK8shoa2Uezv3Eymqp79xw=;
        b=gG4VOgehqAT2SQoHxduG4Xbd0rx9P2yyeNC+D6yFquG5KmRCP9mHRblzcHzksY3BDC
         cP1lbpZeFxx9tzCWJEKJbW3WAsK0itpo3rpwjc96mMZ7FWLrUqGJ5mH0y6my80qP1Ij5
         m7mklagy1hUCezPXTqS7mKbniATCW1An36NzP3eqZGkLhQtD7P+SILYSlashAIBjzSv/
         2ErUau9G88QTDUirIcfqWAUKyfEy2BeKS+UwacXQl8IWpRZYnW60rqq4I3Op1Rxsn6BG
         aWGjDwos9bVs2eky8ZeJNI4SdaPCBwEIjEnN9lT6DPpsAG4Fel2ZS0Yfx1vWOPVJXsK2
         THpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618277; x=1709223077;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yBF7jJN1+Xu+ov0cdEcK8kK8shoa2Uezv3Eymqp79xw=;
        b=XKbzNV7Imh2o/BqhMmZhQjf/d52t2vGRjESZXaw1HrkEkGHMscNXdJPeS2gaazSZF+
         qn9ljYnJewUVNHXfAt3Ffv7V049e2rixRvPMdgk3xxt4iFwmtCaPjIvm7HHvm0exzMJc
         ViBgxdJpYShgYiS6oZ/fxImutC5dJnhSbi/Nk2zCfWceXcLFkopfj+hqmLO/DfIrtRvM
         aqVPHf0GJLbj1Fs+Aiyx3XrMIy2C3VJTdMyTpZOXdvjfwfpfz0a8MI3j6XvoaHcXYJj0
         g5+Sys75fzUA7RJKRMJ/LZb/pz+0ou6gnp3UhAUmQQBpRpsxIo0Con/ifVhvej/LLLgO
         B8AQ==
X-Gm-Message-State: AOJu0YyNYdnRFlg+JyMIL/Cjn0OvwqHbKdXLV8lBxQXie1HZMjlzaoX6
	lQXrUDgU+4kGRmrh+oZqBMCLfPQPTU/HLrqZWOvNPG7dxCZNqiCmUekAO5ednbwx/CEL8W1UaQk
	0TCGC20LqBe8MuiYBjSorx0sMWm7M7mPTEeHnpXPgv3upJ98cek4Jxll5/2/FJ/ShtG0F+FrRTk
	VF+vYsxl8dWNZilyuSUHwv3Jk=
X-Google-Smtp-Source: AGHT+IGrCya8m8uAuRpFxFybFUAEU0iwPgGXeWFUDgySqY7is6FBp4ITlzxd28T47Jmynwc+rSuknB6rAQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a0d:d685:0:b0:607:7564:a830 with SMTP id
 y127-20020a0dd685000000b006077564a830mr3732341ywd.0.1708618277048; Thu, 22
 Feb 2024 08:11:17 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:32 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-12-tabba@google.com>
Subject: [RFC PATCH v1 11/26] KVM: arm64: Add initial support for KVM_CAP_EXIT_HYPERCALL
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

Allow the VMM to hook into and handle a subset of guest hypercalls
advertised by the host. For now, no such hypercalls exist, and so the
new capability returns 0 when queried.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              | 25 +++++++++++++++++++++++++
 arch/arm64/kvm/hypercalls.c       | 19 +++++++++++++++++++
 3 files changed, 46 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 55de71791233..f6187526685a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -325,6 +325,8 @@ struct kvm_arch {
 	 * the associated pKVM instance in the hypervisor.
 	 */
 	struct kvm_protected_vm pkvm;
+
+	u64 hypercall_exit_enabled;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c0e683bde111..cd6c4df27c7b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -60,6 +60,9 @@ static bool vgic_present, kvm_arm_initialised;
 static DEFINE_PER_CPU(unsigned char, kvm_hyp_initialized);
 DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
+/* KVM "vendor" hypercalls which may be forwarded to userspace on request. */
+#define KVM_EXIT_HYPERCALL_VALID_MASK	(0)
+
 bool is_kvm_arm_initialised(void)
 {
 	return kvm_arm_initialised;
@@ -123,6 +126,19 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->slots_lock);
 		break;
+	case KVM_CAP_EXIT_HYPERCALL:
+		if (cap->flags)
+			return -EINVAL;
+
+		if (cap->args[0] & ~KVM_EXIT_HYPERCALL_VALID_MASK)
+			return -EINVAL;
+
+		if (cap->args[1] || cap->args[2] || cap->args[3])
+			return -EINVAL;
+
+		WRITE_ONCE(kvm->arch.hypercall_exit_enabled, cap->args[0]);
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -334,6 +350,9 @@ static int kvm_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES:
 		r = BIT(0);
 		break;
+	case KVM_CAP_EXIT_HYPERCALL:
+		r = KVM_EXIT_HYPERCALL_VALID_MASK;
+		break;
 	default:
 		r = 0;
 	}
@@ -1071,6 +1090,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		ret = kvm_handle_mmio_return(vcpu);
 		if (ret <= 0)
 			return ret;
+	} else if (run->exit_reason == KVM_EXIT_HYPERCALL) {
+		smccc_set_retval(vcpu,
+				 vcpu->run->hypercall.ret,
+				 vcpu->run->hypercall.args[0],
+				 vcpu->run->hypercall.args[1],
+				 vcpu->run->hypercall.args[2]);
 	}
 
 	vcpu_load(vcpu);
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 89b5b61bc9f7..5e04be7c026a 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -132,6 +132,25 @@ static bool kvm_smccc_test_fw_bmap(struct kvm_vcpu *vcpu, u32 func_id)
 	}
 }
 
+static int __maybe_unused kvm_vcpu_exit_hcall(struct kvm_vcpu *vcpu, u32 nr, u32 nr_args)
+{
+	u64 mask = vcpu->kvm->arch.hypercall_exit_enabled;
+	u32 i;
+
+	if (nr_args > 6 || !(mask & BIT(nr))) {
+		smccc_set_retval(vcpu, SMCCC_RET_INVALID_PARAMETER, 0, 0, 0);
+		return 1;
+	}
+
+	vcpu->run->exit_reason		= KVM_EXIT_HYPERCALL;
+	vcpu->run->hypercall.nr		= nr;
+
+	for (i = 0; i < nr_args; ++i)
+		vcpu->run->hypercall.args[i] = vcpu_get_reg(vcpu, i + 1);
+
+	return 0;
+}
+
 #define SMC32_ARCH_RANGE_BEGIN	ARM_SMCCC_VERSION_FUNC_ID
 #define SMC32_ARCH_RANGE_END	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
 						   ARM_SMCCC_SMC_32,		\
-- 
2.44.0.rc1.240.g4c46232300-goog


