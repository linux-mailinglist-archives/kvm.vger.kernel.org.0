Return-Path: <kvm+bounces-58214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9D9EB8B6CD
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:00:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8885587684
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:00:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3472C2D660A;
	Fri, 19 Sep 2025 21:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CORnEqVX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85C12D3EC0
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 21:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758319180; cv=none; b=eluRIW3sVQBbK0DTjzR4SQPlD6b/mt2+MSFZ+xsmlR40vwO5uKQuT9G+Z6fjoEbQeWB4FRVZGnMgOlSyO0PKvk6Uhp8zRS2OkaqYR6mYkxsHeCg+k16H2FBM9toFIXouDcyH4e14XhoEHeokafKaNcMQwtgjr5KJVHmvgRc8jag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758319180; c=relaxed/simple;
	bh=TqI0m8cUaosO9YvbAzshCBHwQ31eU9/jNocSpeBH9U4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LwQe3Gf9oOabuNMIutWAqacOkZDVLsrE+WDFIYVTO0EvV0zItyEogqYUIHqVaA/+toFMllc5HiF7A6azfqj5/9DEplPYiWi4g+hHMWNHSBvqhrSRq0wySPbrdj2dvoHLKi54ehO4CvWlJ4x/oHb/JvZjiXgR0nhvE8gLkVGp25k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CORnEqVX; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b5531279991so307049a12.3
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 14:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758319178; x=1758923978; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=z4vvZVviAKykztVzh+1RERrWNNzj6PiZBM3YIdtRxzo=;
        b=CORnEqVXy/CBfO9EvtPZujCzaza/3sXxgAThywMPIxptlX1nGM3/5iMhH7M6jix8eq
         PgORSV1S+8JAr0OUbPReSInmMEQBd48UPwX7WV9On6vF0LXYN3GjW71dILRzjMRV0egw
         nG7fQ4CqTqyuwySPGyKnqnSoq9k6pR5FDYI2mmv2v18Wslwg1z3CSYsr7Z3i3boCD4zu
         EgCSReL17N794uaFT+o7tzblWok55ZBzQTV27mLw0UZBiCcE6o9AHk/vcM1ly0Z0qMQx
         wRoj1kp4BPDHlSagiDu72eb0gGEzV6O9+PT2M4YpvjyiqaQOIj2yNbJVlmOxCSBhQrWI
         TEWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758319178; x=1758923978;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z4vvZVviAKykztVzh+1RERrWNNzj6PiZBM3YIdtRxzo=;
        b=eT9seVrKl7S0gueMFPK0/kb1YX6HM7qi0BoJFZJTuqgAY9Cs5ZR3OfkYAvSuvIxES9
         yNmWzQKB/CGcLwTaEHZ5IkPVVM3eyG5MJJ/UaO1HqHYFX3rwjC/+M7BXjDgfnCqs3/ic
         KhJAcXF7tGO0Hs6SwtlgsVblRsQ1GAp9+RTsiXAdwC5pPmY+eNjQq6PRo4QASl03fbJW
         6EpPid+WNCL7sYBcpZGc/+FIGABCuFkh8IHsVzHI+kCAuDbeJMYzOf6weDfrdYrhJZFD
         rtM8rszNqz+3MrL1Qg549AoJVBlAyZmZH2Q+RXro06n/zrvJIZaQNYcEhusMO2wANO2y
         WOzQ==
X-Gm-Message-State: AOJu0YwZdfu+ClOwGAsZ7hWBtS7AGDpopWEXz0G/Lz0OeeBuM9Eeweyz
	cbVQHMDjeBjHzn+bS/W4VmGZNkrU6MHV0yzI5mOwmJFW8JjiLNzfoQU43iTBJ1K68kRtT+gcYnv
	M/pyQNw==
X-Google-Smtp-Source: AGHT+IHA4KH8oOcK/PIZhKxCn6eWhYsPqQGFXHEna4LG8tEcBbH3eiAyVFCZTr7RiTvr1YV2pXKjJCl0ut0=
X-Received: from pji16.prod.google.com ([2002:a17:90b:3fd0:b0:32d:7097:81f1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2ecf:b0:267:776b:a31a
 with SMTP id d9443c01a7336-269ba517048mr59720995ad.29.1758319178239; Fri, 19
 Sep 2025 14:59:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 14:59:28 -0700
In-Reply-To: <20250919215934.1590410-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919215934.1590410-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919215934.1590410-2-seanjc@google.com>
Subject: [PATCH v4 1/7] KVM: SVM: Make svm_x86_ops globally visible, clean up
 on-HyperV usage
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Make svm_x86_ops globally visible in anticipation of modifying the struct
in avic.c, and clean up the KVM-on-HyperV usage, as declaring _and using_
a local variable in a header that's only defined in one specific .c-file
is all kinds of ugly.

Opportunistically make svm_hv_enable_l2_tlb_flush() local to
svm_onhyperv.c, as the only reason it was visible was due to the
aforementioned shenanigans in svm_onhyperv.h.

Alternatively, svm_x86_ops could be explicitly passed to
svm_hv_hardware_setup() as a parameter.  While that approach is slightly
safer, e.g. avoids "hidden" updates, for better or worse, the Intel side
of KVM has already chosen to expose vt_x86_ops (and vt_init_ops).  Given
that svm_x86_ops is only truly consumed by kvm_ops_update, the odds of a
"hidden" update causing problems are extremely low.  So, absent a strong
reason to rework the VMX/TDX code, make svm_x86_ops visible, as having all
updates use exactly "svm_x86_ops." is advantageous in its own right.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c          |  2 +-
 arch/x86/kvm/svm/svm.h          |  2 ++
 arch/x86/kvm/svm/svm_onhyperv.c | 28 +++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm_onhyperv.h | 31 +------------------------------
 4 files changed, 31 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 67f4eed01526..8117d79036bb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5032,7 +5032,7 @@ static void *svm_alloc_apic_backing_page(struct kvm_vcpu *vcpu)
 	return page_address(page);
 }
 
-static struct kvm_x86_ops svm_x86_ops __initdata = {
+struct kvm_x86_ops svm_x86_ops __initdata = {
 	.name = KBUILD_MODNAME,
 
 	.check_processor_compatibility = svm_check_processor_compat,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5d39c0b17988..1652a868c578 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -52,6 +52,8 @@ extern bool x2avic_enabled;
 extern bool vnmi;
 extern int lbrv;
 
+extern struct kvm_x86_ops svm_x86_ops __initdata;
+
 /*
  * Clean bits in VMCB.
  * VMCB_ALL_CLEAN_MASK might also need to
diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
index 3971b3ea5d04..a8e78c0e5956 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.c
+++ b/arch/x86/kvm/svm/svm_onhyperv.c
@@ -15,7 +15,7 @@
 #include "kvm_onhyperv.h"
 #include "svm_onhyperv.h"
 
-int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
+static int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
 {
 	struct hv_vmcb_enlightenments *hve;
 	hpa_t partition_assist_page = hv_get_partition_assist_page(vcpu);
@@ -35,3 +35,29 @@ int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+__init void svm_hv_hardware_setup(void)
+{
+	if (npt_enabled &&
+	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB) {
+		pr_info(KBUILD_MODNAME ": Hyper-V enlightened NPT TLB flush enabled\n");
+		svm_x86_ops.flush_remote_tlbs = hv_flush_remote_tlbs;
+		svm_x86_ops.flush_remote_tlbs_range = hv_flush_remote_tlbs_range;
+	}
+
+	if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH) {
+		int cpu;
+
+		pr_info(KBUILD_MODNAME ": Hyper-V Direct TLB Flush enabled\n");
+		for_each_online_cpu(cpu) {
+			struct hv_vp_assist_page *vp_ap =
+				hv_get_vp_assist_page(cpu);
+
+			if (!vp_ap)
+				continue;
+
+			vp_ap->nested_control.features.directhypercall = 1;
+		}
+		svm_x86_ops.enable_l2_tlb_flush =
+				svm_hv_enable_l2_tlb_flush;
+	}
+}
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index f85bc617ffe4..08f14e6f195c 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -13,9 +13,7 @@
 #include "kvm_onhyperv.h"
 #include "svm/hyperv.h"
 
-static struct kvm_x86_ops svm_x86_ops;
-
-int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu);
+__init void svm_hv_hardware_setup(void);
 
 static inline bool svm_hv_is_enlightened_tlb_enabled(struct kvm_vcpu *vcpu)
 {
@@ -40,33 +38,6 @@ static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
 		hve->hv_enlightenments_control.msr_bitmap = 1;
 }
 
-static inline __init void svm_hv_hardware_setup(void)
-{
-	if (npt_enabled &&
-	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB) {
-		pr_info(KBUILD_MODNAME ": Hyper-V enlightened NPT TLB flush enabled\n");
-		svm_x86_ops.flush_remote_tlbs = hv_flush_remote_tlbs;
-		svm_x86_ops.flush_remote_tlbs_range = hv_flush_remote_tlbs_range;
-	}
-
-	if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH) {
-		int cpu;
-
-		pr_info(KBUILD_MODNAME ": Hyper-V Direct TLB Flush enabled\n");
-		for_each_online_cpu(cpu) {
-			struct hv_vp_assist_page *vp_ap =
-				hv_get_vp_assist_page(cpu);
-
-			if (!vp_ap)
-				continue;
-
-			vp_ap->nested_control.features.directhypercall = 1;
-		}
-		svm_x86_ops.enable_l2_tlb_flush =
-				svm_hv_enable_l2_tlb_flush;
-	}
-}
-
 static inline void svm_hv_vmcb_dirty_nested_enlightenments(
 		struct kvm_vcpu *vcpu)
 {
-- 
2.51.0.470.ga7dc726c21-goog


