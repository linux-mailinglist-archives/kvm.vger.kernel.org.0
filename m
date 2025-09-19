Return-Path: <kvm+bounces-58243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B607B8B87B
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:43:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BB9C37BEC54
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:36:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 479C72EB5B5;
	Fri, 19 Sep 2025 22:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NGUvXG+L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF10F2D6611
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321215; cv=none; b=PKdbKWScEXP8pgJrrdjE3NhJU5puymIxxpEQYakGGexBjeL7EHhJfDYahly3YPID26LmIhqFdPX+MfncMhaxTj5URuLnaccDB34MT2Um2emGGjogxF6+gWg12wWQycT/fJ7l1SLDO+01A4EeGqBIZy87KJujKS8bRMpdojDhSrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321215; c=relaxed/simple;
	bh=HEkJNOg3fukhyvlPxWiVIcVFk89Ev4TjVKZ4rbVl6iY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uqLtSBshF0GU1/W7NAZyYgrr2PbMjrcHfMSAk0s0V9QPju8Jp6d+FAQsyzh5fOHkGUpRodhwJlem8vLmDz/jXxeCwv/3sq5Z7eyhFYvbM0uxPVqb6sSJ+kMlJyKmThb2lybdmohW57Yt+kNX3jl/KQ12zzoAhGVbmOew96Zaz6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NGUvXG+L; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eb18b5659so2674473a91.2
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321213; x=1758926013; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SgNuCWJ0Kshu8P8RVZ3w+7X0SuHGq8/X41iuZdsbg84=;
        b=NGUvXG+Lv6LcxjoOmv5Wzvk2g7OyXOriOC6/IlvB4TwhAHkHvnaCr5QS+muhLZpx01
         /Pvn/FsMAjGmbBBCsZrKdurEng4Wf3EhMuO+QnVthKmsZPD7MpmpdtdrttvbqtraKZHR
         7H7UvuSrwqBEpmBXlZbC2fuaLthwOWDo78kvoyGkij0uw5AjBwsr4E2bx0/dr4iE8Me3
         VPYQy8Q5B2bU2xc2fBOLE4Xt/jPBmvvg1KEG81q83xwSW7ipGjvGzTfCUwhSI9AwUi/p
         a44PIqutg9/qFov2NnGtiqK8ijTzvyLaxaJGxWuPHWBzvSagGAYT9hEU3PSfMKiUJwt5
         ZvQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321213; x=1758926013;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SgNuCWJ0Kshu8P8RVZ3w+7X0SuHGq8/X41iuZdsbg84=;
        b=t6Qd1xUdNCLE+FpcRe1SCsS62XYs8wyEdP7RCCfPIOWM4CsVS6G52E81LUi0BYlwOx
         kULvUz2LYtstUSxdmPXRFnQGxmJFy9ZN89zHIFTwIQovuK0bxg0o8DxqcTO+vMu7t1Uu
         AfxCIvcZmxVR/ZefI9Wo/e8nQKLyrCtE0iwCTjj7ysCwW3mMbS2I3KFOrFfFHAQB42A+
         /nzWS3d51dMu0cZ9GI/Ranobpi3TzcA+zuiXGhAOqY0cE4+92eKfxfJknitLPE+DAQZg
         n6ZVa1OWuzVBlRA+4XjH9HeoJ8UtQKxCZRvkiTSlSUMZf6uTvb9huUJBKq5aV+wYWlgV
         v2KQ==
X-Gm-Message-State: AOJu0YyXuc3W5tlzmxt/kglQQTSxixACgCUz3GqqD5kXwGM2BQ6XPYhS
	4cMQXyVOZ2W7AZW1/9jrma42k6aPKcs8NOk7AfvCxkBtEnqx0N5ptdAE32gbFaSkl9yQ+OVKF73
	N5hQxTg==
X-Google-Smtp-Source: AGHT+IFlfcEaDECOLCIYlfDWXjUKejDEVlHyepr/5JJ+6BpQhH93ka0y/qLlXn9wdJM8Rl8KPJ2WMOD9FkY=
X-Received: from pjff6.prod.google.com ([2002:a17:90b:5626:b0:329:7dfc:f4e1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a8c:b0:32e:d9db:7a86
 with SMTP id 98e67ed59e1d1-33097fe0889mr5834323a91.7.1758321213138; Fri, 19
 Sep 2025 15:33:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:22 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-16-seanjc@google.com>
Subject: [PATCH v16 15/51] KVM: x86: Save and reload SSP to/from SMRAM
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

From: Yang Weijiang <weijiang.yang@intel.com>

Save CET SSP to SMRAM on SMI and reload it on RSM. KVM emulates HW arch
behavior when guest enters/leaves SMM mode,i.e., save registers to SMRAM
at the entry of SMM and reload them at the exit to SMM. Per SDM, SSP is
one of such registers on 64-bit Arch, and add the support for SSP.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/smm.c | 8 ++++++++
 arch/x86/kvm/smm.h | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index 5dd8a1646800..b0b14ba37f9a 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -269,6 +269,10 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
 	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
 
 	smram->int_shadow = kvm_x86_call(get_interrupt_shadow)(vcpu);
+
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
+	    kvm_msr_read(vcpu, MSR_KVM_INTERNAL_GUEST_SSP, &smram->ssp))
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 }
 #endif
 
@@ -558,6 +562,10 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 	kvm_x86_call(set_interrupt_shadow)(vcpu, 0);
 	ctxt->interruptibility = (u8)smstate->int_shadow;
 
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
+	    kvm_msr_write(vcpu, MSR_KVM_INTERNAL_GUEST_SSP, smstate->ssp))
+		return X86EMUL_UNHANDLEABLE;
+
 	return X86EMUL_CONTINUE;
 }
 #endif
diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
index 551703fbe200..db3c88f16138 100644
--- a/arch/x86/kvm/smm.h
+++ b/arch/x86/kvm/smm.h
@@ -116,8 +116,8 @@ struct kvm_smram_state_64 {
 	u32 smbase;
 	u32 reserved4[5];
 
-	/* ssp and svm_* fields below are not implemented by KVM */
 	u64 ssp;
+	/* svm_* fields below are not implemented by KVM */
 	u64 svm_guest_pat;
 	u64 svm_host_efer;
 	u64 svm_host_cr4;
-- 
2.51.0.470.ga7dc726c21-goog


