Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC37367ED69
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 19:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235324AbjA0S02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 13:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235273AbjA0S0V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 13:26:21 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EDF7B7AF
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 10:26:19 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id v23so5890047plo.1
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 10:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dXwA+He5Gl75oa0P0/Izb/PHhFUIRPdbLW1x5GmAqWI=;
        b=b1KgQDhzP3LBMu0UWWE4gvo2MupDUaDq7RN2Q1+oBsyYEk5RIMm8udeSuJy/Vzj8Q6
         tZ3Oh2W3Y+iOHXD6rRMREkMG3UUnzd3BhamUanWUdTnzvFWM35Y1JFZ4GpLGQKU17DCE
         14YA+N927/6cyYscb/r9wMchv/BRNWcGAsjtIfE7h0JnB254PdPotP/2NFgIRJkfTTbP
         uQLli0QHjFe+Z8WAhY/x/RXB13KQRkYCYer4S6jYXoV5lwa7SPR5SaDtrOG0RlwL96cE
         3qoLEECh8r/yax1PSm9aclMgysV7A7DUSnIoOAzUHML08r8U/BDcVdJx4AEfSQbJrw7p
         buRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dXwA+He5Gl75oa0P0/Izb/PHhFUIRPdbLW1x5GmAqWI=;
        b=FNcOylt+qXXyf7eRZUi8RQJY4NyuPcjR8xrS1erl8tta3kaHbBoy6xUoLMSlTgJlHN
         TA0yNsM/48Hc02PKstdYmXen0TPrV0zIQa21CY9EA89aF9qjTPZxdqIb+OCvFxH5Fqms
         CimeDRAy5AvTmJVqPxtBRjIAn/OZ8pjh4ojbNBB6qogpdXOVtwWlUeJUXnME/4s/2QiI
         zoNyvlp8Ten6GH8oQBG/DKHBTSJbHTr7p/HWCCu/czuP83PulM5pF6AZh35kqx3N1fUQ
         S3uHDgFV9sW8K6d452RQosVzvBDod67KoxXK0EmsvJ89fkzCYEaU0BhCyhgmInKmEc0s
         p7UA==
X-Gm-Message-State: AO0yUKWH/+8okBxxWxYwhyrDapAjthCnujAg8tXifkKPIE0xYN/OvcfR
        Cx39y0/FV49xQl+z3TMIxhNvXg==
X-Google-Smtp-Source: AK7set/d8UQnl3xzAz8dwQLfXoVWd9ZiHFXIDlsZ1LSYXK3+r5JgV9haxNf31lLbOh0Ae01YKHG44A==
X-Received: by 2002:a17:903:244f:b0:192:7845:e0cc with SMTP id l15-20020a170903244f00b001927845e0ccmr7260781pls.68.1674843979140;
        Fri, 27 Jan 2023 10:26:19 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jc5-20020a17090325c500b00189d4c666c8sm3195219plb.153.2023.01.27.10.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 10:26:18 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v3 06/14] RISC-V: KVM: Modify SBI extension handler to return SBI error code
Date:   Fri, 27 Jan 2023 10:25:50 -0800
Message-Id: <20230127182558.2416400-7-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127182558.2416400-1-atishp@rivosinc.com>
References: <20230127182558.2416400-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, the SBI extension handle is expected to return Linux error code.
The top SBI layer converts the Linux error code to SBI specific error code
that can be returned to guest invoking the SBI calls. This model works
as long as SBI error codes have 1-to-1 mappings between them.
However, that may not be true always. This patch attempts to disassociate
both these error codes by allowing the SBI extension implementation to
return SBI specific error codes as well.

The extension will continue to return the Linux error specific code which
will indicate any problem *with* the extension emulation while the
SBI specific error will indicate the problem *of* the emulation.

Suggested-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h | 10 ++++--
 arch/riscv/kvm/vcpu_sbi.c             | 46 ++++++++------------------
 arch/riscv/kvm/vcpu_sbi_base.c        | 38 ++++++++++------------
 arch/riscv/kvm/vcpu_sbi_hsm.c         | 29 +++++++++--------
 arch/riscv/kvm/vcpu_sbi_replace.c     | 47 ++++++++++++++-------------
 arch/riscv/kvm/vcpu_sbi_v01.c         | 11 +++----
 6 files changed, 84 insertions(+), 97 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index 45ba341..38407b3 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -18,6 +18,12 @@ struct kvm_vcpu_sbi_context {
 	int return_handled;
 };
 
+struct kvm_vcpu_sbi_ext_data {
+	unsigned long out_val;
+	unsigned long err_val;
+	bool uexit;
+};
+
 struct kvm_vcpu_sbi_extension {
 	unsigned long extid_start;
 	unsigned long extid_end;
@@ -27,8 +33,8 @@ struct kvm_vcpu_sbi_extension {
 	 * specific error codes.
 	 */
 	int (*handler)(struct kvm_vcpu *vcpu, struct kvm_run *run,
-		       unsigned long *out_val, struct kvm_cpu_trap *utrap,
-		       bool *exit);
+		       struct kvm_vcpu_sbi_ext_data *edata,
+		       struct kvm_cpu_trap *utrap);
 
 	/* Extension specific probe function */
 	unsigned long (*probe)(struct kvm_vcpu *vcpu);
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index f96991d..aa42da6 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -12,26 +12,6 @@
 #include <asm/sbi.h>
 #include <asm/kvm_vcpu_sbi.h>
 
-static int kvm_linux_err_map_sbi(int err)
-{
-	switch (err) {
-	case 0:
-		return SBI_SUCCESS;
-	case -EPERM:
-		return SBI_ERR_DENIED;
-	case -EINVAL:
-		return SBI_ERR_INVALID_PARAM;
-	case -EFAULT:
-		return SBI_ERR_INVALID_ADDRESS;
-	case -EOPNOTSUPP:
-		return SBI_ERR_NOT_SUPPORTED;
-	case -EALREADY:
-		return SBI_ERR_ALREADY_AVAILABLE;
-	default:
-		return SBI_ERR_FAILURE;
-	};
-}
-
 #ifndef CONFIG_RISCV_SBI_V01
 static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
 	.extid_start = -1UL,
@@ -125,11 +105,10 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	int ret = 1;
 	bool next_sepc = true;
-	bool userspace_exit = false;
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
 	const struct kvm_vcpu_sbi_extension *sbi_ext;
 	struct kvm_cpu_trap utrap = { 0 };
-	unsigned long out_val = 0;
+	struct kvm_vcpu_sbi_ext_data edata_out = { 0 };
 	bool ext_is_v01 = false;
 
 	sbi_ext = kvm_vcpu_sbi_find_ext(cp->a7);
@@ -139,13 +118,22 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		    cp->a7 <= SBI_EXT_0_1_SHUTDOWN)
 			ext_is_v01 = true;
 #endif
-		ret = sbi_ext->handler(vcpu, run, &out_val, &utrap, &userspace_exit);
+		ret = sbi_ext->handler(vcpu, run, &edata_out, &utrap);
 	} else {
 		/* Return error for unsupported SBI calls */
 		cp->a0 = SBI_ERR_NOT_SUPPORTED;
 		goto ecall_done;
 	}
 
+	/*
+	 * When the SBI extension returns a Linux error code, it exits the ioctl
+	 * loop and forwards the error to userspace.
+	 */
+	if (ret < 0) {
+		next_sepc = false;
+		goto ecall_done;
+	}
+
 	/* Handle special error cases i.e trap, exit or userspace forward */
 	if (utrap.scause) {
 		/* No need to increment sepc or exit ioctl loop */
@@ -157,24 +145,18 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	}
 
 	/* Exit ioctl loop or Propagate the error code the guest */
-	if (userspace_exit) {
+	if (edata_out.uexit) {
 		next_sepc = false;
 		ret = 0;
 	} else {
-		/**
-		 * SBI extension handler always returns an Linux error code. Convert
-		 * it to the SBI specific error code that can be propagated the SBI
-		 * caller.
-		 */
-		ret = kvm_linux_err_map_sbi(ret);
-		cp->a0 = ret;
+		cp->a0 = edata_out.err_val;
 		ret = 1;
 	}
 ecall_done:
 	if (next_sepc)
 		cp->sepc += 4;
 	if (!ext_is_v01)
-		cp->a1 = out_val;
+		cp->a1 = edata_out.out_val;
 
 	return ret;
 }
diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
index 846d518..84885e5 100644
--- a/arch/riscv/kvm/vcpu_sbi_base.c
+++ b/arch/riscv/kvm/vcpu_sbi_base.c
@@ -14,24 +14,23 @@
 #include <asm/kvm_vcpu_sbi.h>
 
 static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
-				    unsigned long *out_val,
-				    struct kvm_cpu_trap *trap, bool *exit)
+				    struct kvm_vcpu_sbi_ext_data *edata,
+				    struct kvm_cpu_trap *trap)
 {
-	int ret = 0;
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
 	const struct kvm_vcpu_sbi_extension *sbi_ext;
 
 	switch (cp->a6) {
 	case SBI_EXT_BASE_GET_SPEC_VERSION:
-		*out_val = (KVM_SBI_VERSION_MAJOR <<
+		edata->out_val = (KVM_SBI_VERSION_MAJOR <<
 			    SBI_SPEC_VERSION_MAJOR_SHIFT) |
 			    KVM_SBI_VERSION_MINOR;
 		break;
 	case SBI_EXT_BASE_GET_IMP_ID:
-		*out_val = KVM_SBI_IMPID;
+		edata->out_val = KVM_SBI_IMPID;
 		break;
 	case SBI_EXT_BASE_GET_IMP_VERSION:
-		*out_val = LINUX_VERSION_CODE;
+		edata->out_val = LINUX_VERSION_CODE;
 		break;
 	case SBI_EXT_BASE_PROBE_EXT:
 		if ((cp->a0 >= SBI_EXT_EXPERIMENTAL_START &&
@@ -43,33 +42,33 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			 * forward it to the userspace
 			 */
 			kvm_riscv_vcpu_sbi_forward(vcpu, run);
-			*exit = true;
+			edata->uexit = true;
 		} else {
 			sbi_ext = kvm_vcpu_sbi_find_ext(cp->a0);
 			if (sbi_ext) {
 				if (sbi_ext->probe)
-					*out_val = sbi_ext->probe(vcpu);
+					edata->out_val = sbi_ext->probe(vcpu);
 				else
-					*out_val = 1;
+					edata->out_val = 1;
 			} else
-				*out_val = 0;
+				edata->out_val = 0;
 		}
 		break;
 	case SBI_EXT_BASE_GET_MVENDORID:
-		*out_val = vcpu->arch.mvendorid;
+		edata->out_val = vcpu->arch.mvendorid;
 		break;
 	case SBI_EXT_BASE_GET_MARCHID:
-		*out_val = vcpu->arch.marchid;
+		edata->out_val = vcpu->arch.marchid;
 		break;
 	case SBI_EXT_BASE_GET_MIMPID:
-		*out_val = vcpu->arch.mimpid;
+		edata->out_val = vcpu->arch.mimpid;
 		break;
 	default:
-		ret = -EOPNOTSUPP;
+		edata->err_val = SBI_ERR_NOT_SUPPORTED;
 		break;
 	}
 
-	return ret;
+	return 0;
 }
 
 const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base = {
@@ -79,17 +78,16 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base = {
 };
 
 static int kvm_sbi_ext_forward_handler(struct kvm_vcpu *vcpu,
-					struct kvm_run *run,
-					unsigned long *out_val,
-					struct kvm_cpu_trap *utrap,
-					bool *exit)
+				       struct kvm_run *run,
+				       struct kvm_vcpu_sbi_ext_data *edata,
+				       struct kvm_cpu_trap *utrap)
 {
 	/*
 	 * Both SBI experimental and vendor extensions are
 	 * unconditionally forwarded to userspace.
 	 */
 	kvm_riscv_vcpu_sbi_forward(vcpu, run);
-	*exit = true;
+	edata->uexit = true;
 	return 0;
 }
 
diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
index 619ac0f..5fb526c 100644
--- a/arch/riscv/kvm/vcpu_sbi_hsm.c
+++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
@@ -21,9 +21,9 @@ static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu)
 
 	target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, target_vcpuid);
 	if (!target_vcpu)
-		return -EINVAL;
+		return SBI_ERR_INVALID_PARAM;
 	if (!target_vcpu->arch.power_off)
-		return -EALREADY;
+		return SBI_ERR_ALREADY_AVAILABLE;
 
 	reset_cntx = &target_vcpu->arch.guest_reset_context;
 	/* start address */
@@ -42,7 +42,7 @@ static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu)
 static int kvm_sbi_hsm_vcpu_stop(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.power_off)
-		return -EACCES;
+		return SBI_ERR_FAILURE;
 
 	kvm_riscv_vcpu_power_off(vcpu);
 
@@ -57,7 +57,7 @@ static int kvm_sbi_hsm_vcpu_get_status(struct kvm_vcpu *vcpu)
 
 	target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, target_vcpuid);
 	if (!target_vcpu)
-		return -EINVAL;
+		return SBI_ERR_INVALID_PARAM;
 	if (!target_vcpu->arch.power_off)
 		return SBI_HSM_STATE_STARTED;
 	else if (vcpu->stat.generic.blocking)
@@ -67,9 +67,8 @@ static int kvm_sbi_hsm_vcpu_get_status(struct kvm_vcpu *vcpu)
 }
 
 static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
-				   unsigned long *out_val,
-				   struct kvm_cpu_trap *utrap,
-				   bool *exit)
+				   struct kvm_vcpu_sbi_ext_data *edata,
+				   struct kvm_cpu_trap *utrap)
 {
 	int ret = 0;
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
@@ -88,27 +87,29 @@ static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	case SBI_EXT_HSM_HART_STATUS:
 		ret = kvm_sbi_hsm_vcpu_get_status(vcpu);
 		if (ret >= 0) {
-			*out_val = ret;
-			ret = 0;
+			edata->out_val = ret;
+			edata->err_val = 0;
 		}
-		break;
+		return 0;
 	case SBI_EXT_HSM_HART_SUSPEND:
 		switch (cp->a0) {
 		case SBI_HSM_SUSPEND_RET_DEFAULT:
 			kvm_riscv_vcpu_wfi(vcpu);
 			break;
 		case SBI_HSM_SUSPEND_NON_RET_DEFAULT:
-			ret = -EOPNOTSUPP;
+			ret = SBI_ERR_NOT_SUPPORTED;
 			break;
 		default:
-			ret = -EINVAL;
+			ret = SBI_ERR_INVALID_PARAM;
 		}
 		break;
 	default:
-		ret = -EOPNOTSUPP;
+		ret = SBI_ERR_NOT_SUPPORTED;
 	}
 
-	return ret;
+	edata->err_val = ret;
+
+	return 0;
 }
 
 const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm = {
diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index 03a0198..abeb55f 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -14,15 +14,16 @@
 #include <asm/kvm_vcpu_sbi.h>
 
 static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
-				    unsigned long *out_val,
-				    struct kvm_cpu_trap *utrap, bool *exit)
+				    struct kvm_vcpu_sbi_ext_data *edata,
+				    struct kvm_cpu_trap *utrap)
 {
-	int ret = 0;
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
 	u64 next_cycle;
 
-	if (cp->a6 != SBI_EXT_TIME_SET_TIMER)
-		return -EINVAL;
+	if (cp->a6 != SBI_EXT_TIME_SET_TIMER) {
+		edata->err_val = SBI_ERR_INVALID_PARAM;
+		return 0;
+	}
 
 #if __riscv_xlen == 32
 	next_cycle = ((u64)cp->a1 << 32) | (u64)cp->a0;
@@ -31,7 +32,7 @@ static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 #endif
 	kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
 
-	return ret;
+	return 0;
 }
 
 const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time = {
@@ -41,8 +42,8 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time = {
 };
 
 static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
-				   unsigned long *out_val,
-				   struct kvm_cpu_trap *utrap, bool *exit)
+				   struct kvm_vcpu_sbi_ext_data *edata,
+				   struct kvm_cpu_trap *utrap)
 {
 	int ret = 0;
 	unsigned long i;
@@ -51,8 +52,10 @@ static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	unsigned long hmask = cp->a0;
 	unsigned long hbase = cp->a1;
 
-	if (cp->a6 != SBI_EXT_IPI_SEND_IPI)
-		return -EINVAL;
+	if (cp->a6 != SBI_EXT_IPI_SEND_IPI) {
+		edata->err_val = SBI_ERR_INVALID_PARAM;
+		return 0;
+	}
 
 	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
 		if (hbase != -1UL) {
@@ -76,10 +79,9 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi = {
 };
 
 static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
-				      unsigned long *out_val,
-				      struct kvm_cpu_trap *utrap, bool *exit)
+				      struct kvm_vcpu_sbi_ext_data *edata,
+				      struct kvm_cpu_trap *utrap)
 {
-	int ret = 0;
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
 	unsigned long hmask = cp->a0;
 	unsigned long hbase = cp->a1;
@@ -116,10 +118,10 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 		 */
 		break;
 	default:
-		ret = -EOPNOTSUPP;
+		edata->err_val = SBI_ERR_NOT_SUPPORTED;
 	}
 
-	return ret;
+	return 0;
 }
 
 const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence = {
@@ -130,14 +132,13 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence = {
 
 static int kvm_sbi_ext_srst_handler(struct kvm_vcpu *vcpu,
 				    struct kvm_run *run,
-				    unsigned long *out_val,
-				    struct kvm_cpu_trap *utrap, bool *exit)
+				    struct kvm_vcpu_sbi_ext_data *edata,
+				    struct kvm_cpu_trap *utrap)
 {
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
 	unsigned long funcid = cp->a6;
 	u32 reason = cp->a1;
 	u32 type = cp->a0;
-	int ret = 0;
 
 	switch (funcid) {
 	case SBI_EXT_SRST_RESET:
@@ -146,24 +147,24 @@ static int kvm_sbi_ext_srst_handler(struct kvm_vcpu *vcpu,
 			kvm_riscv_vcpu_sbi_system_reset(vcpu, run,
 						KVM_SYSTEM_EVENT_SHUTDOWN,
 						reason);
-			*exit = true;
+			edata->uexit = true;
 			break;
 		case SBI_SRST_RESET_TYPE_COLD_REBOOT:
 		case SBI_SRST_RESET_TYPE_WARM_REBOOT:
 			kvm_riscv_vcpu_sbi_system_reset(vcpu, run,
 						KVM_SYSTEM_EVENT_RESET,
 						reason);
-			*exit = true;
+			edata->uexit = true;
 			break;
 		default:
-			ret = -EOPNOTSUPP;
+			edata->err_val = SBI_ERR_NOT_SUPPORTED;
 		}
 		break;
 	default:
-		ret = -EOPNOTSUPP;
+		edata->err_val = SBI_ERR_NOT_SUPPORTED;
 	}
 
-	return ret;
+	return 0;
 }
 
 const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst = {
diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/vcpu_sbi_v01.c
index 489f225..c0ccc58 100644
--- a/arch/riscv/kvm/vcpu_sbi_v01.c
+++ b/arch/riscv/kvm/vcpu_sbi_v01.c
@@ -14,9 +14,8 @@
 #include <asm/kvm_vcpu_sbi.h>
 
 static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
-				      unsigned long *out_val,
-				      struct kvm_cpu_trap *utrap,
-				      bool *exit)
+				   struct kvm_vcpu_sbi_ext_data *edata,
+				   struct kvm_cpu_trap *utrap)
 {
 	ulong hmask;
 	int i, ret = 0;
@@ -33,7 +32,7 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		 * handled in kernel so we forward these to user-space
 		 */
 		kvm_riscv_vcpu_sbi_forward(vcpu, run);
-		*exit = true;
+		edata->uexit = true;
 		break;
 	case SBI_EXT_0_1_SET_TIMER:
 #if __riscv_xlen == 32
@@ -65,7 +64,7 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	case SBI_EXT_0_1_SHUTDOWN:
 		kvm_riscv_vcpu_sbi_system_reset(vcpu, run,
 						KVM_SYSTEM_EVENT_SHUTDOWN, 0);
-		*exit = true;
+		edata->uexit = true;
 		break;
 	case SBI_EXT_0_1_REMOTE_FENCE_I:
 	case SBI_EXT_0_1_REMOTE_SFENCE_VMA:
@@ -103,7 +102,7 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		}
 		break;
 	default:
-		ret = -EINVAL;
+		edata->err_val = SBI_ERR_NOT_SUPPORTED;
 		break;
 	}
 
-- 
2.25.1

