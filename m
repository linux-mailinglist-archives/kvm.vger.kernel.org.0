Return-Path: <kvm+bounces-46693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 837A5AB8A00
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 16:56:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0E089E1B77
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 14:53:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C46E0218ADE;
	Thu, 15 May 2025 14:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="WEv+Y7eH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E495920E306
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 14:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747320780; cv=none; b=nKQGgwGDhMVloHSb8ER6ja7UFo/MkGV3ndSre/pRugRGsoOqwRvh02Gcl2nxG0B9zW3vWL7X/q4XfqOunrzEf1PTsnJ5IYG+PcVZIS0oQDAtn/ezH4/v0g7JcFgasRc3kbS6XWMgxTKh/eFw0K53sWR9TLvw/bkx6DT8eZeavb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747320780; c=relaxed/simple;
	bh=5aytGyw7U1i0Xd1U4Oy4rPiXiOEcWSKgzOJuZ2cVDao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D9qU26HxoDV6NGqj18c4XvQkefzKaDBy2lpZYWtSRzsdzWyHymXofeMLv+v4/+X0MM2JITJqMikIUSreKao/n+rJ4UW3+aPZGceA6rn8hFgOw6js2rw82y1zyWxatKJ/UDliEm690lwCP3EN2AASCKuPvGttH1y7W35VjfWHzFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=WEv+Y7eH; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-44069f5f3aaso649315e9.2
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 07:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1747320775; x=1747925575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MI4r/0MkyeFCFhMfeAnOJjuw3BBTosdSkQfxrX8t8KQ=;
        b=WEv+Y7eHQVEZVx8KowL7zkt3yzNBiQ0yxWNXzgG4qjZNvjuLFWxKyUpyRkOheOFYGw
         p7VcYHcFCKwnvz5EUx9pVkBx2LyvUIjYdiM7NwYhs7wBfSgf25DlW0ukkcIBJqYzBXC9
         bRgHMnlbSFdcO6IQqp73iSynJJH4wBSbtTp19SnJlJTOOiBGWtRs5T/dr59vfxpOkMTi
         Qhiyy8LXCiJtHv71fAx1263e7oTxnwcNowEcFgPoZ1Eb4l5aoxQOiV0GSkxuR5Ax+vSC
         xO7QRrRJvQ6QQSyjFoFa139KeL5BTr9Iuyi3QyybSabDUH9ZWlsZso7TdC26Nmf6q39H
         UXeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747320775; x=1747925575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MI4r/0MkyeFCFhMfeAnOJjuw3BBTosdSkQfxrX8t8KQ=;
        b=jpHmhr7CWnTgPCNQjSJuAwc27STAPfzApnQVHI0Zxn/AqqsXTreUQSG84/CXjUqTg1
         TSqdCVUwDQ5T9mXnGYwUHKniSjVv2qoitJxd2OueRVeZYVZfEQHiS7mMw/3/qvR/WdAP
         NjFFZWZffoKzrIvDuq1LfOpTRxTRQ4k6s8aaAzJdZhXAZmZm8DKA9OKzDyjSTODYDfWj
         5gEqonMtiSqc3K13xDmdyQvZOaZE2b1fus9kpdWN2z0QA4KYm25iVZLQ+L2qnhNYAvPL
         dBuPotTUhyrol7eCcZTpguw8NT5YwvmqZcrlsMqEn/SG9s4RKk/MO+9iH4ErCFst7jcM
         uAWQ==
X-Gm-Message-State: AOJu0Yz4DQHkEcX6YHwyghnXhH7Qsv551yFSq/gZILyrVvWIezXz1ckG
	2if9LL6nTADW2yiWqTNXv6cjhW6Ji0/67sHnT2QU6SKhebSSMSPJl6Tn0VWqN4I=
X-Gm-Gg: ASbGncs2bI6Y6sFyXKpUqN/9s8Oxi1gCXJxZPZA5VN20pdtP9i/Aj0jc7rnju6iNJxM
	lI+g49Nn+ZbhX/Lbd5qh2CO/Xj48eeMaDX14gJXb6pRfcKLgZ+wbjmEb6k0/S+f2oPGzAPDNcGE
	p1nIbN8AUoBPTdFmdDm+WHJeS+FpfgbHV2nl/VKyp+q4NMFoWpqmavfHGnfna7NpmgR5TLBBGXI
	x0d7QdnmExr3QdG/d3urkG2WPYCH21yRwl0W2sQQ4WXi7Pi+rkMEAWwZPIM8Xiy1+7rJF3lhi2M
	fEF51219paG+sXn70Jg5V3INywdG5hqLc5K4zFB/Lp2kBjZYGEoYIqqY
X-Google-Smtp-Source: AGHT+IEpZ9PaXNge5gggaswM8grdAbE7qn5UMWCZgDtX4BmC48cndXLVf7sy1H74LQs3vsjF1NgKpw==
X-Received: by 2002:a05:600c:1ca3:b0:43b:c938:1d0e with SMTP id 5b1f17b1804b1-442f20bfcd5mr27466075e9.2.1747320774631;
        Thu, 15 May 2025 07:52:54 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:59f5:9ec:79d9:ffc])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442f9053b4dsm29668385e9.4.2025.05.15.07.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 May 2025 07:52:54 -0700 (PDT)
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
To: kvm-riscv@lists.infradead.org
Cc: kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH v3 1/2] RISC-V: KVM: add KVM_CAP_RISCV_MP_STATE_RESET
Date: Thu, 15 May 2025 16:37:25 +0200
Message-ID: <20250515143723.2450630-5-rkrcmar@ventanamicro.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250515143723.2450630-4-rkrcmar@ventanamicro.com>
References: <20250515143723.2450630-4-rkrcmar@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add a toggleable VM capability to reset the VCPU from userspace by
setting MP_STATE_INIT_RECEIVED through IOCTL.

Reset through a mp_state to avoid adding a new IOCTL.
Do not reset on a transition from STOPPED to RUNNABLE, because it's
better to avoid side effects that would complicate userspace adoption.
The MP_STATE_INIT_RECEIVED is not a permanent mp_state -- IOCTL resets
the VCPU while preserving the original mp_state -- because we wouldn't
gain much from having a new state it in the rest of KVM, but it's a very
non-standard use of the IOCTL.

Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
---
If we want a permanent mp_state, I think that MP_STATE_UNINITIALIZED
would be reasonable.  KVM could reset on transition to any other state.

v3: do not allow allow userspace to set the HSM reset state [Anup]
v2: new
---
 Documentation/virt/kvm/api.rst        | 11 +++++++++++
 arch/riscv/include/asm/kvm_host.h     |  3 +++
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  1 +
 arch/riscv/kvm/vcpu.c                 | 27 ++++++++++++++-------------
 arch/riscv/kvm/vcpu_sbi.c             | 17 +++++++++++++++++
 arch/riscv/kvm/vm.c                   | 13 +++++++++++++
 include/uapi/linux/kvm.h              |  1 +
 7 files changed, 60 insertions(+), 13 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 47c7c3f92314..e107694fb41f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8496,6 +8496,17 @@ aforementioned registers before the first KVM_RUN. These registers are VM
 scoped, meaning that the same set of values are presented on all vCPUs in a
 given VM.
 
+7.43 KVM_CAP_RISCV_MP_STATE_RESET
+---------------------------------
+
+:Architectures: riscv
+:Type: VM
+:Parameters: None
+:Returns: 0 on success, -EINVAL if arg[0] is not zero
+
+When this capability is enabled, KVM resets the VCPU when setting
+MP_STATE_INIT_RECEIVED through IOCTL.  The original MP_STATE is preserved.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index f673ebfdadf3..85cfebc32e4c 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -119,6 +119,9 @@ struct kvm_arch {
 
 	/* AIA Guest/VM context */
 	struct kvm_aia aia;
+
+	/* KVM_CAP_RISCV_MP_STATE_RESET */
+	bool mp_state_reset;
 };
 
 struct kvm_cpu_trap {
diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index da28235939d1..439ab2b3534f 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -57,6 +57,7 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
 				     u32 type, u64 flags);
 void kvm_riscv_vcpu_sbi_request_reset(struct kvm_vcpu *vcpu,
 				      unsigned long pc, unsigned long a1);
+void kvm_riscv_vcpu_sbi_load_reset_state(struct kvm_vcpu *vcpu);
 int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_riscv_vcpu_set_reg_sbi_ext(struct kvm_vcpu *vcpu,
 				   const struct kvm_one_reg *reg);
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index a78f9ec2fa0e..521cd41bfffa 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -51,11 +51,11 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 		       sizeof(kvm_vcpu_stats_desc),
 };
 
-static void kvm_riscv_vcpu_context_reset(struct kvm_vcpu *vcpu)
+static void kvm_riscv_vcpu_context_reset(struct kvm_vcpu *vcpu,
+					 bool kvm_sbi_reset)
 {
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
 	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
-	struct kvm_vcpu_reset_state *reset_state = &vcpu->arch.reset_state;
 	void *vector_datap = cntx->vector.datap;
 
 	memset(cntx, 0, sizeof(*cntx));
@@ -65,13 +65,8 @@ static void kvm_riscv_vcpu_context_reset(struct kvm_vcpu *vcpu)
 	/* Restore datap as it's not a part of the guest context. */
 	cntx->vector.datap = vector_datap;
 
-	/* Load SBI reset values */
-	cntx->a0 = vcpu->vcpu_id;
-
-	spin_lock(&reset_state->lock);
-	cntx->sepc = reset_state->pc;
-	cntx->a1 = reset_state->a1;
-	spin_unlock(&reset_state->lock);
+	if (kvm_sbi_reset)
+		kvm_riscv_vcpu_sbi_load_reset_state(vcpu);
 
 	/* Setup reset state of shadow SSTATUS and HSTATUS CSRs */
 	cntx->sstatus = SR_SPP | SR_SPIE;
@@ -84,7 +79,7 @@ static void kvm_riscv_vcpu_context_reset(struct kvm_vcpu *vcpu)
 	csr->scounteren = 0x7;
 }
 
-static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
+static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu, bool kvm_sbi_reset)
 {
 	bool loaded;
 
@@ -100,7 +95,7 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.last_exit_cpu = -1;
 
-	kvm_riscv_vcpu_context_reset(vcpu);
+	kvm_riscv_vcpu_context_reset(vcpu, kvm_sbi_reset);
 
 	kvm_riscv_vcpu_fp_reset(vcpu);
 
@@ -177,7 +172,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kvm_riscv_vcpu_sbi_init(vcpu);
 
 	/* Reset VCPU */
-	kvm_riscv_reset_vcpu(vcpu);
+	kvm_riscv_reset_vcpu(vcpu, false);
 
 	return 0;
 }
@@ -526,6 +521,12 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 	case KVM_MP_STATE_STOPPED:
 		__kvm_riscv_vcpu_power_off(vcpu);
 		break;
+	case KVM_MP_STATE_INIT_RECEIVED:
+		if (vcpu->kvm->arch.mp_state_reset)
+			kvm_riscv_reset_vcpu(vcpu, false);
+		else
+			ret = -EINVAL;
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -714,7 +715,7 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
 		}
 
 		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
-			kvm_riscv_reset_vcpu(vcpu);
+			kvm_riscv_reset_vcpu(vcpu, true);
 
 		if (kvm_check_request(KVM_REQ_UPDATE_HGATP, vcpu))
 			kvm_riscv_gstage_update_hgatp(vcpu);
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 0afef0bb261d..31fd3cc98d66 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -167,6 +167,23 @@ void kvm_riscv_vcpu_sbi_request_reset(struct kvm_vcpu *vcpu,
 	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
 }
 
+void kvm_riscv_vcpu_sbi_load_reset_state(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+	struct kvm_vcpu_reset_state *reset_state = &vcpu->arch.reset_state;
+
+	cntx->a0 = vcpu->vcpu_id;
+
+	spin_lock(&vcpu->arch.reset_state.lock);
+	cntx->sepc = reset_state->pc;
+	cntx->a1 = reset_state->a1;
+	spin_unlock(&vcpu->arch.reset_state.lock);
+
+	cntx->sstatus &= ~SR_SIE;
+	csr->vsatp = 0;
+}
+
 int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 7396b8654f45..b27ec8f96697 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -209,6 +209,19 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	return r;
 }
 
+int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
+{
+	switch (cap->cap) {
+	case KVM_CAP_RISCV_MP_STATE_RESET:
+		if (cap->flags)
+			return -EINVAL;
+		kvm->arch.mp_state_reset = true;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 {
 	return -EINVAL;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index b6ae8ad8934b..454b7d4a0448 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -930,6 +930,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
 #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
+#define KVM_CAP_RISCV_MP_STATE_RESET 240
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.49.0


