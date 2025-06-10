Return-Path: <kvm+bounces-48901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B4636AD464A
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:02:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A7D11886807
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FA2A2DCC06;
	Tue, 10 Jun 2025 22:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MMUVUEn/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6952D8DA4
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596291; cv=none; b=j3uEpAa6sNXS33su9FvC6OMugeSX+z5RXOIqiZzYQ3JZnCxP95BczhNHd2xRsQuMrHskDNEv9rl1gi5tvIX1+S/bobRtMRxTUsW0ft+TYRhlT1EeZo8SbLjBbjBKofiqE33ndQtUHK7VFmU8gXy2HoIMvaH5SpnV05Gf2UuUFe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596291; c=relaxed/simple;
	bh=R4cTawn6FPBvedLrqxVNysJ0af/k1o1HGGxQjl1UZQ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HksFnCITOIKyyVLPg+1WYQQ2VrwHaeZULlk8xkiRYxAtnCZEnOYHKpC3cBRmqv60Z8EN4tAgSabeZq1Pk2NjejN4epib+2UgI1Df5fJ4apTS0I2OKIxLRJPUkjFyAc8ldZ7lC8ZbdXayq52LqbKLwHC6FlzK9dEcIv3KQJTmsHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MMUVUEn/; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31215090074so8254997a91.0
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596289; x=1750201089; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cYslCc1aEse5AOWlTO9NEcAl50WRTRVtzpSVWqQhl98=;
        b=MMUVUEn/TI4tfUlLXvBbvTyjZJvRZABrdnO7XCt2KoQK8vzfZnZ5RbadUnhhALGfry
         T3lNyYQkCtHkOR/zC5uu8G7l1breg2JC8+PCF3iXIYJn0z3GsVJk9/XIpeh+G8gl8ygi
         +K4uum1JAjxoWHQh9Lehys+snWenChgcuF98n9dT7Cl8+xvbrA6ud1x5FQwyw2B3MRKJ
         WZUD2/RRK1HWmStvcJdIaLbPjYd11rOY5rs8wkJ2jaS+cJ94tMuHJJyC1e9tUoyH/jFM
         Im5+Nw7hgiibpU9FDJ/cl1d/KE0liwhfqfysDXnp2oVXvBn22pEG76SHEX3hZNLKGcRc
         Mnxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596289; x=1750201089;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cYslCc1aEse5AOWlTO9NEcAl50WRTRVtzpSVWqQhl98=;
        b=Jw8dFogjBThQ2/Urn94vMx2DopD3vqRQc4mC4p74l/qlahKKjcvINkhOTAQy0l0tvU
         WK3pVsvxTRR06i4unS30Zb4G7wx9VNHEdRLRFA45U34njBc8WqvDNdPFlZ/TNqgnea0l
         vVQY0pHrqj8m+ycvJfjgsMAYonHhG5PqPEVX48rHnIY5Qnry7Dx6VG9K94ZY9wZyQbV5
         /SWDQ90BEEdPm5Qh3QyulRgXkvUK0pF3ShoXm1oLGSSPy46Yq+qkgroWxpfV4JWc8L3s
         X3FzQlN6dcG0wRpva6h6LyDyGJdzOsa/DPFemSrjOssjmjqf17L33+IJcsskEpxpVaOJ
         2lWQ==
X-Gm-Message-State: AOJu0YxalJr8kqh8E359h6je/hRUWUubhR8CoNIhPSzm4nxRbOQNTHnu
	SXk226M95tJrGMbevaG6/svVKi7bn9LGqk3rEWCMeJoL7otTxtlLThqGp3+XrA/L3b0zg5FD8jB
	dsbRIjg==
X-Google-Smtp-Source: AGHT+IFMCxHrCFjA3fTBqnet51XeAQL96yY3myWBi4ZzqvgxQeZxtwfutpeMyQ4+ahm0ojHbTWI8frORyHw=
X-Received: from pjee8.prod.google.com ([2002:a17:90b:5788:b0:313:285a:5547])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:584d:b0:311:c939:c859
 with SMTP id 98e67ed59e1d1-313af28d147mr1646696a91.30.1749596289376; Tue, 10
 Jun 2025 15:58:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:22 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-18-seanjc@google.com>
Subject: [PATCH v2 17/32] KVM: x86: Move definition of X2APIC_MSR() to lapic.h
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

Dedup the definition of X2APIC_MSR and put it in the local APIC code
where it belongs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.h   | 2 ++
 arch/x86/kvm/svm/svm.c | 2 --
 arch/x86/kvm/vmx/vmx.h | 2 --
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 4ce30db65828..4518b4e0552f 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -21,6 +21,8 @@
 #define APIC_BROADCAST			0xFF
 #define X2APIC_BROADCAST		0xFFFFFFFFul
 
+#define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
+
 enum lapic_mode {
 	LAPIC_MODE_DISABLED = 0,
 	LAPIC_MODE_INVALID = X2APIC_ENABLE,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4ee92e444dde..900a1303e0e7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -81,8 +81,6 @@ static uint64_t osvw_len = 4, osvw_status;
 
 static DEFINE_PER_CPU(u64, current_tsc_ratio);
 
-#define X2APIC_MSR(x)	(APIC_BASE_MSR + (x >> 4))
-
 static const u32 direct_access_msrs[] = {
 	MSR_STAR,
 	MSR_IA32_SYSENTER_CS,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index b5758c33c60f..0afe97e3478f 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -19,8 +19,6 @@
 #include "../mmu.h"
 #include "common.h"
 
-#define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
-
 #ifdef CONFIG_X86_64
 #define MAX_NR_USER_RETURN_MSRS	7
 #else
-- 
2.50.0.rc0.642.g800a2b2222-goog


