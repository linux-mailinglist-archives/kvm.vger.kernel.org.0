Return-Path: <kvm+bounces-45901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BEC2AAFD1E
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 16:32:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FE6F4C1891
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 14:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFD262741AF;
	Thu,  8 May 2025 14:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ecd7rJ+p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D436A2701D3
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 14:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746714714; cv=none; b=nuS6Vz4iNJhj3JH4+DLNJlxgpcteG9+N5ZqwTNvEOltHjwAvWTK/Abq8vuZXecF0mxOcMGkDFmVJJIU17cjKBd8T2ZPtisdGzUU7I6WxJ0qrYF0KyIwwZ6ba5Db5wF/8oq4H3BOq/4/Awf4iqdZ24RDv6tkQ1obInwUMgjRczc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746714714; c=relaxed/simple;
	bh=l5Dappur0wGcoRttIXhShtgjIcZxHdOGi/r63rgDfpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YupPGypaaNoIa1PYtUPu6fnajfJdxa9SFjrRbuj5ouyZDTiy/5lhU+DVqlBICioLbEPZl86b+pN1/uTqErTvpXb/Ee0rFdr1e6cEtlupubJdUYWJ3GAHVoiqJrSY2wjtS0aO6AbNz4dqfaG6aJwHO2aVRL9WSul09YtueEqfAp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ecd7rJ+p; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43f106a3591so408005e9.3
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 07:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1746714710; x=1747319510; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Iq0irjOP5JV+UDNdYH88ZnlyC3CUjThrEd11ryaVa8=;
        b=ecd7rJ+pPTF6nXdM+wK6secuGz8jtIILr+TcMKQ8Ef5IFcFE13TGnu4/yPsBdQ3/SZ
         JJu/OQxT4C9ZMYrhIsDx7Bt2QlFPcWDq+LG1U2ulwHsLTFNFm6QdCQpRxiSHWg7pCOrB
         CvBLZl52xVyyMBGoeOwLgDcCCgRxALsg/MoVe4Mbhhys3Sgdv2G8bES5hbOUoBD+b+9u
         k0ReWvyTIHcu4pxdHJfXVvBKzsxlZySKrP/KQyaWKybNxN0/c1ei8ORXVK5HTkI4SmcY
         tp1j8RJkziMm3gI3O6hb0KQS0A1ifM2oxvX2b0LI6pCYKuYLmziCagL3Oduh0gNtQlT1
         6M8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746714710; x=1747319510;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Iq0irjOP5JV+UDNdYH88ZnlyC3CUjThrEd11ryaVa8=;
        b=njFU3XVzMq7IBcUpBulrm+hY9x7QJBVXP3jpn5U0AvyJzgxgKehLLJ3cUCf05G9dy6
         coIqrPZxx8cqlPmZbrPk4uyHRVXiG7/TH2kczNVc0LOj23RQN6rxVt45yEwu4Gm3ptpL
         WL11W5Osxx1wHpdl2InixGNCdBQnuU5e0Hhz1/tn/V7cjKGQKOjRHkPJkRBrtR6zYTxX
         SxY4DViV6LZrHQlOKKti7bVbgnt8Fb87YEJhWKY8SkwiVboSt92sQ85vlREP8PWUdx2w
         h9LlZcHTGTMgCARzoJor9GGPGiLQg6O2t4GuC84Om3KnWGkb/b4OhkeNF+DoGAMe9LsL
         C5NA==
X-Gm-Message-State: AOJu0Ywfixr4+Oh1elNWz1kGctfk5Rnj87PuEe+zzNDi5zbnmAcnTMxT
	0fsIxkCscdxfjWPZvWE5pSLh0YBN0oTxDxteYu9b/Shn8NDLkYrFpxIIIAnFjgc=
X-Gm-Gg: ASbGnctVu2DfsfNRICjiO+WxcsOqp/PDXVireLsnWyVfVSGAkkoBcwz4zBF6EkcaHD9
	dAT7C34N/hCZV/N9pyAX2T9icKyrHlEDj2lQG09ymcuaf2MQXdPhHfVEj2Hc7AIoNK36yoLoHJi
	jRuJ9SA75PyutuDDBDX3+TjQLKGrfsxkxQ7uYFndiJtaWdMHftNkDDIPdSbMcMSyVbWn+rmpXmc
	U89BfTLTAD7FjW5bTso70kwpXjh43UwwwIza0PycWyYJRyHEzkdaMIp39/mAFlhSfLrI/qXqhTL
	Agoz10dmw/9ePBveD1rcPUhdyV4DtSi3fSXlfvZbZtPjjWnv
X-Google-Smtp-Source: AGHT+IFrhrrk91EQvVw5UVBWpi0thZj7ZgnrM7NMkHcfPYOymBEctXqZ2MNdkHKrUQIb01SSED3Y4g==
X-Received: by 2002:a05:600c:1d0d:b0:439:9a5a:d3bb with SMTP id 5b1f17b1804b1-441d44bcab8mr24877085e9.2.1746714710000;
        Thu, 08 May 2025 07:31:50 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:a451:a252:64ea:9a0e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd380a79sm39022965e9.33.2025.05.08.07.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 07:31:49 -0700 (PDT)
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
Subject: [PATCH v2 2/2] RISC-V: KVM: add KVM_CAP_RISCV_MP_STATE_RESET
Date: Thu,  8 May 2025 16:28:43 +0200
Message-ID: <20250508142842.1496099-4-rkrcmar@ventanamicro.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250508142842.1496099-2-rkrcmar@ventanamicro.com>
References: <20250508142842.1496099-2-rkrcmar@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add a toggleable VM capability to modify several reset related code
paths.  The goals are to
 1) Allow userspace to reset any VCPU.
 2) Allow userspace to provide the initial VCPU state.

(Right now, the boot VCPU isn't reset by KVM and KVM sets the state for
 VCPUs brought up by sbi_hart_start while userspace for all others.)

The goals are achieved with the following changes:
 * Reset the VCPU when setting MP_STATE_INIT_RECEIVED through IOCTL.
 * Preserve the userspace initialized VCPU state on sbi_hart_start.
 * Return to userspace on sbi_hart_stop.
 * Don't make VCPU reset request on sbi_system_suspend.

The patch is reusing MP_STATE_INIT_RECEIVED, because we didn't want to
add a new IOCTL, sorry. :)

Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
---
If you search for cap 7.42 in api.rst, you'll see that it has a wrong
number, which is why we're 7.43, in case someone bothers to fix ARM.

I was also strongly considering creating all VCPUs in RUNNABLE state --
do you know of any similar quirks that aren't important, but could be
fixed with the new userspace toggle?
---
 Documentation/virt/kvm/api.rst        | 15 +++++++++++
 arch/riscv/include/asm/kvm_host.h     |  3 +++
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  1 +
 arch/riscv/kvm/vcpu.c                 | 36 +++++++++++++++++----------
 arch/riscv/kvm/vcpu_sbi.c             | 17 +++++++++++++
 arch/riscv/kvm/vcpu_sbi_hsm.c         |  7 +++++-
 arch/riscv/kvm/vcpu_sbi_system.c      |  3 ++-
 arch/riscv/kvm/vm.c                   | 13 ++++++++++
 include/uapi/linux/kvm.h              |  1 +
 9 files changed, 81 insertions(+), 15 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 47c7c3f92314..63e6d23d34f0 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8496,6 +8496,21 @@ aforementioned registers before the first KVM_RUN. These registers are VM
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
+When this capability is enabled, KVM:
+* Resets the VCPU when setting MP_STATE_INIT_RECEIVED through IOCTL.
+  The original MP_STATE is preserved.
+* Preserves the userspace initialized VCPU state on sbi_hart_start.
+* Returns to userspace on sbi_hart_stop.
+* Doesn't make VCPU reset request on sbi_system_suspend.
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
index a78f9ec2fa0e..961b22c05981 100644
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
@@ -84,10 +79,19 @@ static void kvm_riscv_vcpu_context_reset(struct kvm_vcpu *vcpu)
 	csr->scounteren = 0x7;
 }
 
-static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
+static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu, bool kvm_sbi_reset)
 {
 	bool loaded;
 
+	/*
+	 * The userspace should have triggered a full reset earlier and could
+	 * have set initial state that needs to be preserved.
+	 */
+	if (kvm_sbi_reset && vcpu->kvm->arch.mp_state_reset) {
+		kvm_riscv_vcpu_sbi_load_reset_state(vcpu);
+		return;
+	}
+
 	/**
 	 * The preemption should be disabled here because it races with
 	 * kvm_sched_out/kvm_sched_in(called from preempt notifiers) which
@@ -100,7 +104,7 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.last_exit_cpu = -1;
 
-	kvm_riscv_vcpu_context_reset(vcpu);
+	kvm_riscv_vcpu_context_reset(vcpu, kvm_sbi_reset);
 
 	kvm_riscv_vcpu_fp_reset(vcpu);
 
@@ -177,7 +181,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kvm_riscv_vcpu_sbi_init(vcpu);
 
 	/* Reset VCPU */
-	kvm_riscv_reset_vcpu(vcpu);
+	kvm_riscv_reset_vcpu(vcpu, false);
 
 	return 0;
 }
@@ -526,6 +530,12 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
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
@@ -714,7 +724,7 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
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
diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
index f26207f84bab..d1bf1348eefd 100644
--- a/arch/riscv/kvm/vcpu_sbi_hsm.c
+++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
@@ -89,7 +89,12 @@ static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		ret = kvm_sbi_hsm_vcpu_start(vcpu);
 		break;
 	case SBI_EXT_HSM_HART_STOP:
-		ret = kvm_sbi_hsm_vcpu_stop(vcpu);
+		if (vcpu->kvm->arch.mp_state_reset) {
+			kvm_riscv_vcpu_sbi_forward(vcpu, run);
+			retdata->uexit = true;
+		} else {
+			ret = kvm_sbi_hsm_vcpu_stop(vcpu);
+		}
 		break;
 	case SBI_EXT_HSM_HART_STATUS:
 		ret = kvm_sbi_hsm_vcpu_get_status(vcpu);
diff --git a/arch/riscv/kvm/vcpu_sbi_system.c b/arch/riscv/kvm/vcpu_sbi_system.c
index 359be90b0fc5..0482968705f8 100644
--- a/arch/riscv/kvm/vcpu_sbi_system.c
+++ b/arch/riscv/kvm/vcpu_sbi_system.c
@@ -44,7 +44,8 @@ static int kvm_sbi_ext_susp_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			}
 		}
 
-		kvm_riscv_vcpu_sbi_request_reset(vcpu, cp->a1, cp->a2);
+		if (!vcpu->kvm->arch.mp_state_reset)
+			kvm_riscv_vcpu_sbi_request_reset(vcpu, cp->a1, cp->a2);
 
 		/* userspace provides the suspend implementation */
 		kvm_riscv_vcpu_sbi_forward(vcpu, run);
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


