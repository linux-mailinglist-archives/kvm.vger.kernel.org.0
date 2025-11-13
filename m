Return-Path: <kvm+bounces-63064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F6C8C5A69F
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:57:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 441B14E7F39
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 22:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3937F327212;
	Thu, 13 Nov 2025 22:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sPElYpZ5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D146B326947
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 22:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763074592; cv=none; b=n89SFFaCXC31xgdNPS1xOl12pPJhbOlu52d/BPIZn9DpEIyfuNTjM+7023LfN4dUNyHtIQ7lZDIaY0LUzy0qHT9TrBfaUGUMjHorBwQqz6i31vcb1x5pCIzGmoLwCdKL14uATJ3RXBo1R2IUKslL4n7UstpHG6HEmp07//kjH2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763074592; c=relaxed/simple;
	bh=DZnTVcVd7ilWEk7QprLP8HYWZGe/PyhrQBrHuLnfjVw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jtDXQ6lfqfA2Ypg6Mn/zFUvrfMJ3EFsn+gKh+Hlj2/OcecY4QI5ljiEptPqxXq1fveYvm4z9xFsMuyYTxklzXw9CwWZYwKsXDg0h7CHkr//bkJNVIFGsd1sPWzj5kWiny/6yYv4FFd+EHbiRzrP0KO92dhsK0u9qHMYlh2rCvV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sPElYpZ5; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-343806688cbso1934242a91.3
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 14:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763074590; x=1763679390; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BxKLVgWi122XtoiJoBFjxbdILt6Adpgcci0Yx4/UOzI=;
        b=sPElYpZ5qbvV7CgEjpxR2Dy+Yl7szuBZgwNYaWy7bX08vGSH4hqLRjN8hCBCmGFA6E
         ViaUerATWkBPozqP8UG4ROfuD4fUzQ4HN7Y+61kXldp6XSMu36u/SgM+soTLymGDemlx
         6rV00Rfozndc+gqSNdJM2XdTNuku/sU9KDTxEmusKUT5PqCwPk1NCMMWlnWosAw7+9Ak
         BRz4NRJi4Aphhbo1FFUy01HDjmrLpnuscxbxa/i1GmbbKEinTZcjDRcC/w4ppfODqBJX
         yY5irAT5Pxb2w4V+dEN6A2OGa4UdRWgG2BQ9bXhMI+vZpIW5WtFwAAiVz01YYnO8IaUq
         nA4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763074590; x=1763679390;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BxKLVgWi122XtoiJoBFjxbdILt6Adpgcci0Yx4/UOzI=;
        b=ReKgUQbKrxjd5VaY8BRKKu73EqzkKZrf+JuJ+OZ0z19zQyLAKRYnQHNPXftRNaahVE
         D4jeJ7aha7t8LtzaSkwfjoFyoOBZ64kvXJxcR+hPU4n/hYOYfROeQCV7XxPYTWAQnAGX
         7Dc4Mr3It+L+slm3hVjbkwnP5DCW2132uMFdHDechx0QmrUdKdQfS7eb+2rqm/PKuFuH
         2jfGOvkrvzLqwc6qnN/JtSNZabdieiZvjhEigGSUopzsKzMmkSNVh7EoVAq3pVlhJ/aI
         D7QwywZs8Zhi55CS/Fz0mGCH0UTInZDqsE60PZAwYk3sz0DOXs7dnXq26C0aXQKAG+yl
         VaCg==
X-Gm-Message-State: AOJu0YyfcNGB82snU8j2w+dd8+VXNeXtb3s0WEalKNccv5k1/8ZYDqw5
	avej9dcKkRFxKO95bZVC4FGsUy6TS+0LS1u84y02Yr/tIbhDTreKzKp27WKUfdVyXpN1UPqVG/i
	lShAHaw==
X-Google-Smtp-Source: AGHT+IFiv3A2MIePSw/tKTb0y96BVRTrr/TBLsOXY9EWmbc08jEkv0VCYdfjj5l0yUt5Qx95CRl430wU9PY=
X-Received: from pjbgw11.prod.google.com ([2002:a17:90b:a4b:b0:343:641d:e8c3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c48:b0:341:2b78:61b8
 with SMTP id 98e67ed59e1d1-343fa637866mr946508a91.20.1763074590204; Thu, 13
 Nov 2025 14:56:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 14:56:13 -0800
In-Reply-To: <20251113225621.1688428-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113225621.1688428-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113225621.1688428-2-seanjc@google.com>
Subject: [PATCH 1/9] KVM: nSVM: Clear exit_code_hi in VMCB when synthesizing
 nested VM-Exits
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>
Cc: kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Explicitly clear exit_code_hi in the VMCB when synthesizing "normal"
nested VM-Exits, as the full exit code is a 64-bit value (spoiler alert),
and all exit codes for non-failing VMRUN use only bits 31:0.

Cc: Jim Mattson <jmattson@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 2 ++
 arch/x86/kvm/svm/svm.h | 7 ++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fc42bcdbb520..7ea034ee6b6c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2433,6 +2433,7 @@ static bool check_selective_cr0_intercepted(struct kvm_vcpu *vcpu,
 
 	if (cr0 ^ val) {
 		svm->vmcb->control.exit_code = SVM_EXIT_CR0_SEL_WRITE;
+		svm->vmcb->control.exit_code_hi = 0;
 		ret = (nested_svm_exit_handled(svm) == NESTED_EXIT_DONE);
 	}
 
@@ -4608,6 +4609,7 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 	if (static_cpu_has(X86_FEATURE_NRIPS))
 		vmcb->control.next_rip  = info->next_rip;
 	vmcb->control.exit_code = icpt_info.exit_code;
+	vmcb->control.exit_code_hi = 0;
 	vmexit = nested_svm_exit_handled(svm);
 
 	ret = (vmexit == NESTED_EXIT_DONE) ? X86EMUL_INTERCEPTED
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index c2acaa49ee1c..253a8dca412c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -763,9 +763,10 @@ int nested_svm_vmexit(struct vcpu_svm *svm);
 
 static inline int nested_svm_simple_vmexit(struct vcpu_svm *svm, u32 exit_code)
 {
-	svm->vmcb->control.exit_code   = exit_code;
-	svm->vmcb->control.exit_info_1 = 0;
-	svm->vmcb->control.exit_info_2 = 0;
+	svm->vmcb->control.exit_code	= exit_code;
+	svm->vmcb->control.exit_code_hi	= 0;
+	svm->vmcb->control.exit_info_1	= 0;
+	svm->vmcb->control.exit_info_2	= 0;
 	return nested_svm_vmexit(svm);
 }
 
-- 
2.52.0.rc1.455.g30608eb744-goog


