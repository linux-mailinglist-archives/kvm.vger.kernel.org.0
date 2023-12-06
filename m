Return-Path: <kvm+bounces-3657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6802806599
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 04:21:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 726C7282075
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 03:21:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10A34D266;
	Wed,  6 Dec 2023 03:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IaGpJxPC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5571B6;
	Tue,  5 Dec 2023 19:21:09 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1d03bcf27e9so33405395ad.0;
        Tue, 05 Dec 2023 19:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701832869; x=1702437669; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KG4vDN3r5Jq53Fpae/2yr0v5k4jdcc0jM7Mwk4eiNY0=;
        b=IaGpJxPCP+FRWCuYDWyv7ps7ims5f47Om4ITlXjaOJ6CYd4gWuyGGH5/LtO0339H3T
         u31lDIks+z2KO2rimpZlhDAKCnsoIhy9iCc32SKcVLJxrtX4sRp35ThKipp9EYGVhPbj
         IViql8zefsCyMFU4+gXTANF3C/a/h2KK65lPtJtbrA0Rh3BZzoCwuzjE4BTOxKLzhsSP
         AvOItkcq5f728XNL5+5/yqJEasuCnstqM1ngCYmPQ/dgVbi4kR1r9wUy2aZ67cn84zVg
         JqHfXMNHZvMb7K9k/7KLg6mNfv0TDVeKdyhM1jd3ALcmnqRGgxjk2HwiyDz13+vsYVTA
         kzXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701832869; x=1702437669;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KG4vDN3r5Jq53Fpae/2yr0v5k4jdcc0jM7Mwk4eiNY0=;
        b=bVIktyWftqtZuCcRXUVEmp77imQYlGfopXOUuS6eHqXAbegtpEHE05TXkR3s5CkVP+
         MizXMosSl3Fr3dmEltaf82IXqdtPX/OUQfJcaPMj2tGhPpxRpwaihRqtnNvF01YnM93C
         /ZU/1+Bf0j6V1CiAsehNsFZn+0iZj4jjH/8i1/wiXa0gUkLNe/M7MyE7KJK+vYPSpC2L
         +9rEPUv80LMl7BvRmXBQwV2CnJKQaj08gZLqtpHaMDqnfC+VzWthgufa9CvzS3vW1AXF
         oRxUtL6VZnfZ/PWs+qfw+0B/ZON+Zfek7a5clkEqALzY1aPH/ljPtvBTZad3pn+f/DK4
         JUsw==
X-Gm-Message-State: AOJu0YyzjtbNy9BkYreEtlyfT2VLTivhinp0xo2HJc4wPRHz0PkvpCSE
	kV3SsN04cbE2R4W7vuSxtFw=
X-Google-Smtp-Source: AGHT+IGO1mJ+/7RWkvM2D8JA93HadcJJm0dX9+nK6VfTzVm/7eV8M2rFGBs1IMvK34zZVkSYcQfEfg==
X-Received: by 2002:a17:903:185:b0:1d0:a084:a1e8 with SMTP id z5-20020a170903018500b001d0a084a1e8mr150807plg.106.1701832869038;
        Tue, 05 Dec 2023 19:21:09 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.83])
        by smtp.gmail.com with ESMTPSA id f3-20020a170902e98300b001c5b8087fe5sm8046131plb.94.2023.12.05.19.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 19:21:08 -0800 (PST)
From: Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Andi Kleen <ak@linux.intel.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: x86/intr: Explicitly check NMI from guest to eliminate false positives
Date: Wed,  6 Dec 2023 11:20:54 +0800
Message-ID: <20231206032054.55070-1-likexu@tencent.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Like Xu <likexu@tencent.com>

Explicitly checking the source of external interrupt is indeed NMI and not
other types in the kvm_arch_pmi_in_guest(), which prevents perf-kvm false
positive samples generated in perf/core NMI mode after vm-exit but before
kvm_before_interrupt() from being incorrectly labelled as guest samples:

# test: perf-record + cpu-cycles:HP (which collects host-only precise samples)
# Symbol                                   Overhead       sys       usr  guest sys  guest usr
# .......................................  ........  ........  ........  .........  .........
#
# Before:
  [g] entry_SYSCALL_64                       24.63%     0.00%     0.00%     24.63%      0.00%
  [g] syscall_return_via_sysret              23.23%     0.00%     0.00%     23.23%      0.00%
  [g] files_lookup_fd_raw                     6.35%     0.00%     0.00%      6.35%      0.00%
# After:
  [k] perf_adjust_freq_unthr_context         57.23%    57.23%     0.00%      0.00%      0.00%
  [k] __vmx_vcpu_run                          4.09%     4.09%     0.00%      0.00%      0.00%
  [k] vmx_update_host_rsp                     3.17%     3.17%     0.00%      0.00%      0.00%

In the above case, perf records the samples labelled '[g]', the RIPs behind
the weird samples are actually being queried by perf_instruction_pointer()
after determining whether it's in GUEST state or not, and here's the issue:

If vm-exit is caused by a non-NMI interrupt (such as hrtimer_interrupt) and
at least one PMU counter is enabled on host, the kvm_arch_pmi_in_guest()
will remain true (KVM_HANDLING_IRQ is set) until kvm_before_interrupt().

During this window, if a PMI occurs on host (since the KVM instructions on
host are being executed), the control flow, with the help of the host NMI
context, will be transferred to perf/core to generate performance samples,
thus perf_instruction_pointer() and perf_guest_get_ip() is called.

Since kvm_arch_pmi_in_guest() only checks if there is an interrupt, it may
cause perf/core to mistakenly assume that the source RIP of the host NMI
belongs to the guest world and use perf_guest_get_ip() to get the RIP of
a vCPU that has already exited by a non-NMI interrupt.

Error samples are recorded and presented to the end-user via perf-report.
Such false positive samples could be eliminated by explicitly determining
if the exit reason is KVM_HANDLING_NMI.

Note that when vm-exit is indeed triggered by PMI and before HANDLING_NMI
is cleared, it's also still possible that another PMI is generated on host.
Also for perf/core timer mode, the false positives are still possible since
that non-NMI sources of interrupts are not always being used by perf/core.
In both cases above, perf/core should correctly distinguish between real
RIP sources or even need to generate two samples, belonging to host and
guest separately, but that's perf/core's story for interested warriors.

Fixes: dd60d217062f ("KVM: x86: Fix perf timer mode IP reporting")
Signed-off-by: Like Xu <likexu@tencent.com>
---
V1 -> V2 Changelog:
- Refine commit message to cover both perf/core timer and NMI modes;
- Use in_nmi() to distinguish whether it's NMI mode or not; (Sean)
V1: https://lore.kernel.org/kvm/20231204074535.9567-1-likexu@tencent.com/
 arch/x86/include/asm/kvm_host.h | 10 +++++++++-
 arch/x86/kvm/x86.h              |  6 ------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c8c7e2475a18..167d592e08d0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1868,8 +1868,16 @@ static inline int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn,
 }
 #endif /* CONFIG_HYPERV */
 
+enum kvm_intr_type {
+	/* Values are arbitrary, but must be non-zero. */
+	KVM_HANDLING_IRQ = 1,
+	KVM_HANDLING_NMI,
+};
+
+/* Enable perf NMI and timer modes to work, and minimise false positives. */
 #define kvm_arch_pmi_in_guest(vcpu) \
-	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
+	((vcpu) && (vcpu)->arch.handling_intr_from_guest && \
+	 (in_nmi() == ((vcpu)->arch.handling_intr_from_guest == KVM_HANDLING_NMI)))
 
 void __init kvm_mmu_x86_module_init(void);
 int kvm_mmu_vendor_module_init(void);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 2f7e19166658..4dc38092d599 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -431,12 +431,6 @@ static inline bool kvm_notify_vmexit_enabled(struct kvm *kvm)
 	return kvm->arch.notify_vmexit_flags & KVM_X86_NOTIFY_VMEXIT_ENABLED;
 }
 
-enum kvm_intr_type {
-	/* Values are arbitrary, but must be non-zero. */
-	KVM_HANDLING_IRQ = 1,
-	KVM_HANDLING_NMI,
-};
-
 static __always_inline void kvm_before_interrupt(struct kvm_vcpu *vcpu,
 						 enum kvm_intr_type intr)
 {

base-commit: 1ab097653e4dd8d23272d028a61352c23486fd4a
-- 
2.43.0


