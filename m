Return-Path: <kvm+bounces-39469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B9134A4717A
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:45:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 184811894AFC
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CD6E230270;
	Thu, 27 Feb 2025 01:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D7P1QwZY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1FB22F38E
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619562; cv=none; b=O2FXJSAVzjSYfKDb+H6rbd62JiBGCmGzzIfVnT4md0yhkJxxDWESsmXJq1xwWP7eh4R5F1vwYrfCbIo92HjS+BbcmUddVqNb1toIPAwkvmfE9sjeFasEcY4X0oU7O7wagI0gEM7M9u/iOLnkPwfFMv2pqTrqzAX5PCrjg6fXSMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619562; c=relaxed/simple;
	bh=k1zCPxyx7QffMCA40qqfLOdgRpM8zvCQvs8fM/N6VGQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IErKIGOzQT2UGMqdtkImZhGXQYn+QmML/5bElyt5J2NAA9xIpXIqFEGTOiGSqeD7oc6FSJ0u7NVHASi/ZkWIkT/3Zv7lyMkQR2L+ZTQYGq0wFpkKo7nU/TNhnpjOVsXEcTDL4o7q/7u0v3+4EcYwhZVaJ6GNPsyRTiUBnFihHY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D7P1QwZY; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fe86c01f5cso943400a91.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740619561; x=1741224361; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hRttPNtyo2FhaDhgSxaXYjlTdMIPvE2NOxByRas6vdI=;
        b=D7P1QwZYcj6gVWhWAM6yplvh3rCPt1r3fDyautquYJ3arM3qXWHf/H9HRvO3IiDrEJ
         V1WDxILmSnHIOZw1BheuHelMl04pgSYFG7szAcZDIYirzjWvfrdU2K1Bpf750ZQ+8Tbv
         qBm3poVPnxlvBVsAv4lB0QU3FNbeOPVi90oPbaqzZ467FJm3C81dZqGQuYgrTt0I8SGQ
         NSF2wC3PD2B7+/bESG8SHZMiF3qD3pcJZM09dYhF6TBz70prT53wBOL9kASPPAuVNE4b
         dDYSNM247CmtrCF8opYpMpQZRPy9uzzaqGqpKlgx6Ucsjov6SWw3aGnuw3WAolYI1jzS
         nx7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740619561; x=1741224361;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hRttPNtyo2FhaDhgSxaXYjlTdMIPvE2NOxByRas6vdI=;
        b=a4s9ehVWymieflRAO2JtNjlGq5VRp6ZOQmWi1tDzb87GCZlYQs12vnz/WfoC5OPHRX
         w2MnnzqqNz9tMB7iQAgT1rgKk+YyEXW9siRlQvky+GIiNIN0gjj22S2Z1iF6c/YZXfpl
         HVd0ZE1RUCvQFbPw+p8dzEHh74roP71TpNBVii7R6bRhHWO68rBYJQdM+iXuwxDxbX2L
         +dGC8jCLel4Y3we1XcDxUTwtDdkqDkZWfoZseaWUVGjp4IH07gfT3KXJ49yjlGllKvxZ
         xe/Kb18oJ1asIgKvnC+NGi6/0yczVL1bk1J68MJyi5maGxWGGAd8LyGMVEpX0daUOAWZ
         33gg==
X-Gm-Message-State: AOJu0Yz76Vl1JRn0i/I27NnT6lD6S0HUKCoH0O3OkRNdT2FzOPe58Mmo
	ZfpMflKZKq1nLR76VDcYCEOKJEJa6BDScmOG4zuZFdrGWntOXyzT1JgqaLFBVm/cxFW0QsekCjg
	J9A==
X-Google-Smtp-Source: AGHT+IG8HbiE4dqqw9uPDJvINPCaXcP21RIIbdqv90GTh7egSO6SkFb9wzrb+echyxtbBa5rvPfSgawyvUM=
X-Received: from pfbfa11.prod.google.com ([2002:a05:6a00:2d0b:b0:730:7e2d:df66])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:4310:b0:1ee:d92d:f6f3
 with SMTP id adf61e73a8af0-1f0fc998e0fmr15792313637.37.1740619560644; Wed, 26
 Feb 2025 17:26:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 17:25:41 -0800
In-Reply-To: <20250227012541.3234589-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227012541.3234589-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227012541.3234589-11-seanjc@google.com>
Subject: [PATCH v2 10/10] KVM: SVM: Invalidate "next" SNP VMSA GPA even on failure
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="UTF-8"

When processing an SNP AP Creation event, invalidate the "next" VMSA GPA
even if acquiring the page/pfn for the new VMSA fails.  In practice, the
next GPA will never be used regardless of whether or not its invalidated,
as the entire flow is guarded by snp_ap_waiting_for_reset, and said guard
and snp_vmsa_gpa are always written as a pair.  But that's really hard to
see in the code.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3f85bd1cac37..de153a19fa6c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3875,6 +3875,7 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 		return;
 
 	gfn = gpa_to_gfn(svm->sev_es.snp_vmsa_gpa);
+	svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
 
 	slot = gfn_to_memslot(vcpu->kvm, gfn);
 	if (!slot)
@@ -3904,8 +3905,6 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 	/* Mark the vCPU as runnable */
 	kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
 
-	svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
-
 	/*
 	 * gmem pages aren't currently migratable, but if this ever changes
 	 * then care should be taken to ensure svm->sev_es.vmsa is pinned
-- 
2.48.1.711.g2feabab25a-goog


