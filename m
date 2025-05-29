Return-Path: <kvm+bounces-48045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AE8CEAC8522
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:42:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B9EA1C00110
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:43:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5BD322D9EA;
	Thu, 29 May 2025 23:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yv4LIl8E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3555025DB07
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562033; cv=none; b=YnwTzOOwzpZGEh6F0AWbo6iMY32T2ORJ7imyu8157zUBQit6RvcQC+s/HUSCTTGxQpr/eFra6hPoPSALpSmjCsdz6f8WECk7DgIJymX954CS/MGfUzcix6kr08EJLHOIt6T4c9T+OToYvVZFVKDuoOP18Eaxvi/UZErTLYEm4pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562033; c=relaxed/simple;
	bh=w9qcOUDxn2o93ZPOZkLqGaThFl9+MbTm+hKWzsw1Eq4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hux5vO3QBiuIkPax7YRuoydDY6hLkD3E/yHN6SMcAs7dAnHh5sK/WtBwjiLwOguR9fTIUxyMXAE90nHg3xHOHf9X2zHTf+imf0t19trQI5d2vkeZILxSLDJRQbng5L/f72laZX9z/22WzE+sQyd5EkS0+Ds6IwzM9tvdGgWr3Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yv4LIl8E; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311e7337f26so1119258a91.3
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748562032; x=1749166832; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Fiko08bOlN0blrG6cYr3wwhV1uIlBmvi7ORMBzT1TNE=;
        b=Yv4LIl8Esi5lV7uJnrbmI9hRjCQdVekTVzbYa8w66x9ZVWRhgj33X11d0VDJoA0K3x
         S68TbhxZ5OVmsQDFeBfaEhXP+6gnX8ysC2oYf5iNmyTZ8KrcCY+ufcbH0Box74jawBvp
         REq8oKtXwfFEnu36QhUHWsOmZmGIYPJB5pIYHecJXV/FXPQS7iHwXmRh/m9WZ9uUGDyZ
         zJ1I98pynapt9hfZgF3HR/pnIIyskWdq0mhjO3dTOnqD1fI1pGtiRdq4j+MG3Uk9fF/q
         ErMYCEw/v7rXXJGilIQUO2RImbYuL8P69F5/YsH2GAxnG3rUnuW6Tc3811wIuEMuN3q/
         c56w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562032; x=1749166832;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fiko08bOlN0blrG6cYr3wwhV1uIlBmvi7ORMBzT1TNE=;
        b=RJlsSH8dXBOtNCrEy2UC5RhJm5Y87TJzc1ZWrFulSnB42h2Naay5u9smOREwWJKo4H
         qhhYB7Jpa/sMvPbz/gFJ555TcO+3MeuUBe03oAtI0wcpK7zOppVGuRcvi7E6UTDYZkF7
         3XLcj3f4Gr0Allt22D3K+08E/fBZffrG1KpN16GkXXLRvSDDpuD3cjUxhxx1KnLLgLC5
         /6+str6nYrmBtn3Eh8YsIhHR9xLXcBPIhpebjBDyZeZyPMCNaRCbktvf2fh/chqNKCbU
         grPcdC3J2ORw2poI6nt7BBziC0Bz5Q7QND1EiPxrxXTpl9HAKHnJATllXQLbi9KOl8J/
         dbsw==
X-Gm-Message-State: AOJu0YxNRCAlRWkrfOvbktx/kFzfIVbRpY6XdkP4x6hTHFkz+NSoJVx2
	FaBCwzAIWQSv4E796wx+wYkPJtwW5kvB7Gvt5zzPUgZfrps4XenSXOM9BTpJ3fQvFOLmN26CyUH
	xUO4Png==
X-Google-Smtp-Source: AGHT+IHv/UAQWGvMZg18IQGBREHAo4oLtmBMn3/lYMeAJT0+j2xg4O6aGjuI4OGKjSokpDwr/hXAwRIvxjY=
X-Received: from pjbsg13.prod.google.com ([2002:a17:90b:520d:b0:2fe:800f:23a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c01:b0:311:be51:bdf8
 with SMTP id 98e67ed59e1d1-3124100c9eamr1909211a91.3.1748562031789; Thu, 29
 May 2025 16:40:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 16:39:54 -0700
In-Reply-To: <20250529234013.3826933-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529234013.3826933-10-seanjc@google.com>
Subject: [PATCH 09/28] KVM: nSVM: Omit SEV-ES specific passthrough MSRs from
 L0+L1 bitmap merge
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Don't merge bitmaps on nested VMRUN for MSRs that KVM passes through only
for SEV-ES guests.  KVM doesn't support nested virtualization for SEV-ES,
and likely never will.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e53020939e60..e4a079ea4b27 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -184,7 +184,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	}
 }
 
-static int nested_svm_msrpm_merge_offsets[9] __ro_after_init;
+static int nested_svm_msrpm_merge_offsets[6] __ro_after_init;
 static int nested_svm_nr_msrpm_merge_offsets __ro_after_init;
 
 int __init nested_svm_init_msrpm_merge_offsets(void)
@@ -209,12 +209,6 @@ int __init nested_svm_init_msrpm_merge_offsets(void)
 		MSR_IA32_LASTBRANCHTOIP,
 		MSR_IA32_LASTINTFROMIP,
 		MSR_IA32_LASTINTTOIP,
-
-		MSR_IA32_XSS,
-		MSR_EFER,
-		MSR_IA32_CR_PAT,
-		MSR_AMD64_SEV_ES_GHCB,
-		MSR_TSC_AUX,
 	};
 	int i, j;
 
-- 
2.49.0.1204.g71687c7c1d-goog


