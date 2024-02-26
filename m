Return-Path: <kvm+bounces-9892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6917C8678F2
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:47:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBCBF1F2E6DF
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AD39135A7D;
	Mon, 26 Feb 2024 14:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jVSJjN6R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6499135A4E;
	Mon, 26 Feb 2024 14:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958175; cv=none; b=HvZxQQ4k+U2L3hlsQZC2E9YAwIzOh9hct6EFs26PuLCer4kvCHBaarLVeJlFLQWqqwScNdhkZMB5q+eW3N5PsynHKwbiEab9B8t1n3RU7/bLJI5eXlGtGjPUDXTAj7uGALlgH0V0zcXGJizXprbFVT/6kxNbY77K/O8p2JIlIvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958175; c=relaxed/simple;
	bh=s8BFiuzUQau5p+yaQ0/fjHGiJ1v48d8tcf7X9leFdDk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IGAnKKbC+wowGBCSQmM81Ju1K8ke+RsPW8twRijgZr4/HaHn6+raKKKtsAzEiJSp/P8Q/3NPXIGSZ+ji+3MRLMBZF6byy4Ck0M2QUJsaCqK1PbdTrTnl2e8VSE3hAc1SVexqxmMd1wfYMVc3FoMab7gNg6OK+J+VsgTMSdv4h2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jVSJjN6R; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7c78573f31aso149892139f.3;
        Mon, 26 Feb 2024 06:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958172; x=1709562972; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UtUkxsopGOuyKL99aD2RpbSsknxN3/UH+bUJznUscCw=;
        b=jVSJjN6RAGsTofl+30a2DdIfw9wj3m5ZRsCEJMr7Gaq2/lsNAO1tRkNZRV3LeX9/5d
         0A8x9mDQkaZfDPKGBbJmZWoLV1g9csSsyd5gAjHNm82G/ztVPGzf62S2ILd0s38vRXF2
         +isNQobyi0UYJcmI5KIR16Qumv+zv7LSBO/Tzxa9XGen6Vzj9mLmmSqQQ5Es0ZKLUFq9
         BJ2Bgr7zny56w9Oov0TiHwCKAGy8FMXIFAE141A9YFGBd2e8c54GirqhPFHD+K1flmrW
         OJpvcFULu8ANJ/z7m6FpX6tInWcAJcCeTFWCs9j3gZ/MqL6qPP0tL5JYLLSsjt+X8JXP
         4ftQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958172; x=1709562972;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UtUkxsopGOuyKL99aD2RpbSsknxN3/UH+bUJznUscCw=;
        b=SrW+3iOUoMqF4et23l5LqGs6vGW3/8uhK71TfSV3iOa7nrLmnpxB46wus16g8q+0b6
         7Sr1LqohqXEjpisF7zXgiygQnNRQ6Vn+n8eJ8cPhqCCNAu61fX4D+3oGaPQWAyhQ9Kd7
         ojXYvVgEOfR6pDGuce/b69u9giE5c76xMKurZK13nEEI+41RWRkAJHDn/tRDajCl+r5r
         3FBzgwV/sgA7kFmlIpirJIDd35fCrdglJ29WhIH3JyvQpcEhSQlW2DPWBfCgAuDkSu1x
         YE1pjibJWzR9fJ94aeDC9W2nsrzmd2B1HB4BD6+GsHjdDhTAmZPGsCtPJx3Gl/H3o3Dg
         0Q7Q==
X-Forwarded-Encrypted: i=1; AJvYcCX6sgo9YpJVvEQM8cLJhYD46VFHyvfBJO2T4EfdXawyyky2ywCGMQzF1HsPyWncbEyvfBviXwUgOWB2KLq/ixKoN/Ng
X-Gm-Message-State: AOJu0Yzs1YvZdGtBeYqAG1aY6Nb8sb/bNhOBKTEnUaf3NtOBw90VTSjy
	P67ckPmqT/0P7OC8m40Q0rvxSTdFOWX8BN0PRSgUYC9o6MrKHIABCcm6ZRgi
X-Google-Smtp-Source: AGHT+IFQeXNAab//9PiSgKBW3UP1nqq/u+J5D/SgwtYsUNu1ZEVUWMN2GeFBx3/XMSHtKBNQ5klvEw==
X-Received: by 2002:a92:d588:0:b0:365:1305:fac5 with SMTP id a8-20020a92d588000000b003651305fac5mr7579709iln.0.1708958172552;
        Mon, 26 Feb 2024 06:36:12 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id l64-20020a638843000000b005dccf9e3b74sm4047652pgd.92.2024.02.26.06.36.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:36:12 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 29/73] KVM: x86/PVM: Implement allowed range checking for #PF
Date: Mon, 26 Feb 2024 22:35:46 +0800
Message-Id: <20240226143630.33643-30-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

In PVM, guest is only allowed to be running in the reserved virtual
address range provided by the hypervisor. So guest needs to get the
allowed range information from the MSR and the hypervisor needs to check
the fault address and prevent install mapping in the #PF handler.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 74 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/pvm/pvm.h |  5 +++
 2 files changed, 79 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index 92eef226df28..26b2201f7dde 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -144,6 +144,28 @@ static void pvm_write_guest_kernel_gs_base(struct vcpu_pvm *pvm, u64 data)
 	pvm->msr_kernel_gs_base = data;
 }
 
+static __always_inline bool pvm_guest_allowed_va(struct kvm_vcpu *vcpu, u64 va)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+
+	if ((s64)va > 0)
+		return true;
+	if (pvm->l4_range_start <= va && va < pvm->l4_range_end)
+		return true;
+	if (pvm->l5_range_start <= va && va < pvm->l5_range_end)
+		return true;
+
+	return false;
+}
+
+static bool pvm_disallowed_va(struct kvm_vcpu *vcpu, u64 va)
+{
+	if (is_noncanonical_address(va, vcpu))
+		return true;
+
+	return !pvm_guest_allowed_va(vcpu, va);
+}
+
 // switch_to_smod() and switch_to_umod() switch the mode (smod/umod) and
 // the CR3.  No vTLB flushing when switching the CR3 per PVM Spec.
 static inline void switch_to_smod(struct kvm_vcpu *vcpu)
@@ -380,6 +402,48 @@ static void pvm_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
 }
 
+static void pvm_set_msr_linear_address_range(struct vcpu_pvm *pvm,
+					     u64 pml4_i_s, u64 pml4_i_e,
+					     u64 pml5_i_s, u64 pml5_i_e)
+{
+	pvm->msr_linear_address_range = ((0xfe00 | pml4_i_s) << 0) |
+					((0xfe00 | pml4_i_e) << 16) |
+					((0xfe00 | pml5_i_s) << 32) |
+					((0xfe00 | pml5_i_e) << 48);
+
+	pvm->l4_range_start = (0x1fffe00 | pml4_i_s) * PT_L4_SIZE;
+	pvm->l4_range_end = (0x1fffe00 | pml4_i_e) * PT_L4_SIZE;
+	pvm->l5_range_start = (0xfe00 | pml5_i_s) * PT_L5_SIZE;
+	pvm->l5_range_end = (0xfe00 | pml5_i_e) * PT_L5_SIZE;
+}
+
+static void pvm_set_default_msr_linear_address_range(struct vcpu_pvm *pvm)
+{
+	pvm_set_msr_linear_address_range(pvm, pml4_index_start, pml4_index_end,
+					 pml5_index_start, pml5_index_end);
+}
+
+static bool pvm_check_and_set_msr_linear_address_range(struct vcpu_pvm *pvm, u64 msr)
+{
+	u64 pml4_i_s = (msr >> 0) & 0x1ff;
+	u64 pml4_i_e = (msr >> 16) & 0x1ff;
+	u64 pml5_i_s = (msr >> 32) & 0x1ff;
+	u64 pml5_i_e = (msr >> 48) & 0x1ff;
+
+	/* PVM specification requires those bits to be all set. */
+	if ((msr & 0xff00ff00ff00ff00) != 0xff00ff00ff00ff00)
+		return false;
+
+	/* Guest ranges should be inside what the hypervisor can provide. */
+	if (pml4_i_s < pml4_index_start || pml4_i_e > pml4_index_end ||
+	    pml5_i_s < pml5_index_start || pml5_i_e > pml5_index_end)
+		return false;
+
+	pvm_set_msr_linear_address_range(pvm, pml4_i_s, pml4_i_e, pml5_i_s, pml5_i_e);
+
+	return true;
+}
+
 static int pvm_get_msr_feature(struct kvm_msr_entry *msr)
 {
 	return 1;
@@ -456,6 +520,9 @@ static int pvm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_PVM_SWITCH_CR3:
 		msr_info->data = pvm->msr_switch_cr3;
 		break;
+	case MSR_PVM_LINEAR_ADDRESS_RANGE:
+		msr_info->data = pvm->msr_linear_address_range;
+		break;
 	default:
 		ret = kvm_get_msr_common(vcpu, msr_info);
 	}
@@ -552,6 +619,10 @@ static int pvm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_PVM_SWITCH_CR3:
 		pvm->msr_switch_cr3 = msr_info->data;
 		break;
+	case MSR_PVM_LINEAR_ADDRESS_RANGE:
+		if (!pvm_check_and_set_msr_linear_address_range(pvm, msr_info->data))
+			return 1;
+		break;
 	default:
 		ret = kvm_set_msr_common(vcpu, msr_info);
 	}
@@ -1273,6 +1344,7 @@ static void pvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	pvm->msr_retu_rip_plus2 = 0;
 	pvm->msr_rets_rip_plus2 = 0;
 	pvm->msr_switch_cr3 = 0;
+	pvm_set_default_msr_linear_address_range(pvm);
 }
 
 static int pvm_vcpu_create(struct kvm_vcpu *vcpu)
@@ -1520,6 +1592,8 @@ static struct kvm_x86_ops pvm_x86_ops __initdata = {
 	.msr_filter_changed = pvm_msr_filter_changed,
 	.complete_emulated_msr = kvm_complete_insn_gp,
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+
+	.disallowed_va = pvm_disallowed_va,
 	.vcpu_gpc_refresh = pvm_vcpu_gpc_refresh,
 };
 
diff --git a/arch/x86/kvm/pvm/pvm.h b/arch/x86/kvm/pvm/pvm.h
index 39506ddbe5c5..bf3a6a1837c0 100644
--- a/arch/x86/kvm/pvm/pvm.h
+++ b/arch/x86/kvm/pvm/pvm.h
@@ -82,6 +82,11 @@ struct vcpu_pvm {
 	unsigned long msr_switch_cr3;
 	unsigned long msr_linear_address_range;
 
+	u64 l4_range_start;
+	u64 l4_range_end;
+	u64 l5_range_start;
+	u64 l5_range_end;
+
 	struct kvm_segment segments[NR_VCPU_SREG];
 	struct desc_ptr idt_ptr;
 	struct desc_ptr gdt_ptr;
-- 
2.19.1.6.gb485710b


