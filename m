Return-Path: <kvm+bounces-27737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 738D498B367
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:05:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A58E01C23230
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:05:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B9D1BFDED;
	Tue,  1 Oct 2024 05:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="PKlEfkeK"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFD11BBBED;
	Tue,  1 Oct 2024 05:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758940; cv=none; b=sx4pHR0/9QKDYleT3dLN/brSLhXZPyZN12ETm67sarivr6OCL7k0eqo1mG8QVdoQPkbycth9OP19Up4Q6kZh3/e12W3DInjaQysEESKEB9wRclCHOqlOKtjFAFCx+JtcI3PZaoc5DQCSwGMyfARTEbZyQ7WhF7qAfVjGchpjsoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758940; c=relaxed/simple;
	bh=29tSKrCbeAOlx9UJj6AeDJapdDmlRGBi0sBmlWQo0l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnJoVl4RqrZonhtubEyrRNlMqy8K+p9Zshsk6Dch1hI5Swj/OncqsT/ol75CeqJQP21bnWITcGeghTV/pLloXp13xgL9+c6gACiUU04K2cREkYxT/IeSecYm5GSTK1wiGddw9ipTJtXR/GRZRHVAef7zikD+iGZ8jJz1fSMZrtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=PKlEfkeK; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7a3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:26 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7a3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758887;
	bh=jX5u5mN2GSQ5NDH8yxCY+M0uBUF/2YuarNFQDDjk5ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PKlEfkeKiuaYX66ZDL5aJViQaBlAf9NBg4cvh4G1j8f5TZXv+nmSRFxiFWW6TAWlS
	 0zLLrenFftlQDNRIYpqEun7Yz9vgkrfhA/haSXSWSHKwCTyIu4UoRvlczLmZEfbBOU
	 lyMHMHS0Yx7rAYZIW9Ra+s2glJPWQwZpRMo/s7u5xOw43nMNqNOFDkREWve2RssHkW
	 N0MXcP3CwadHzweyAZFzYmrnnKAv1sX2C5i+IRDx4ZodBu2oTd8ua7DDlDuJ+8RECQ
	 xlRykqk2QRpFfXjHPl+kh/BjYyCQ+NVaqGrEiD4E74hVw9HZYu6Fno3+qfLC0DS3cc
	 qjLiD8GdLEFxQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 11/27] KVM: VMX: Save/restore guest FRED RSP0
Date: Mon, 30 Sep 2024 22:00:54 -0700
Message-ID: <20241001050110.3643764-12-xin@zytor.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241001050110.3643764-1-xin@zytor.com>
References: <20241001050110.3643764-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Save guest FRED RSP0 in vmx_prepare_switch_to_host() and restore it
in vmx_prepare_switch_to_guest() because MSR_IA32_FRED_RSP0 is passed
through to the guest, the guest value is volatile/unknown.

Note, host FRED RSP0 is restored in arch_exit_to_user_mode_prepare(),
regardless of whether it is modified in KVM.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---

Changes since v2:
* KVM only needs to save/restore guest FRED RSP0 now as host FRED RSP0
  is restored in arch_exit_to_user_mode_prepare() (Sean Christopherson).

Changes since v1:
* Don't use guest_cpuid_has() in vmx_prepare_switch_to_{host,guest}(),
  which are called from IRQ-disabled context (Chao Gao).
* Reset msr_guest_fred_rsp0 in __vmx_vcpu_reset() (Chao Gao).
---
 arch/x86/kvm/vmx/vmx.c | 8 ++++++++
 arch/x86/kvm/vmx/vmx.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c10c955722a3..c638492ebd59 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1348,6 +1348,9 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	}
 
 	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
+
+	if (cpu_feature_enabled(X86_FEATURE_FRED) && guest_can_use(vcpu, X86_FEATURE_FRED))
+		wrmsrns(MSR_IA32_FRED_RSP0, vmx->msr_guest_fred_rsp0);
 #else
 	savesegment(fs, fs_sel);
 	savesegment(gs, gs_sel);
@@ -1392,6 +1395,11 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
 	invalidate_tss_limit();
 #ifdef CONFIG_X86_64
 	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
+
+	if (cpu_feature_enabled(X86_FEATURE_FRED) && guest_can_use(&vmx->vcpu, X86_FEATURE_FRED)) {
+		vmx->msr_guest_fred_rsp0 = read_msr(MSR_IA32_FRED_RSP0);
+		fred_sync_rsp0(vmx->msr_guest_fred_rsp0);
+	}
 #endif
 	load_fixmap_gdt(raw_smp_processor_id());
 	vmx->guest_state_loaded = false;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e7409f8f28b1..9ba960472c5f 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -277,6 +277,7 @@ struct vcpu_vmx {
 #ifdef CONFIG_X86_64
 	u64		      msr_host_kernel_gs_base;
 	u64		      msr_guest_kernel_gs_base;
+	u64		      msr_guest_fred_rsp0;
 #endif
 
 	u64		      spec_ctrl;
-- 
2.46.2


