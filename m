Return-Path: <kvm+bounces-32103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CA549D2FD7
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 21:59:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1AEBA1F23667
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 20:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0442C1D4177;
	Tue, 19 Nov 2024 20:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l9xt6i1Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429DA1D097F
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 20:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732049928; cv=none; b=sIOOsgLN0rqzO0fRNKoS64NXRTaX+vyQ6vM8gf6O778eD2g2FR41+ff8Uj/cOm71D8cZTIbtnJUv1qhTO5kgFrksGOGSveIMh5vGdlVulii+aP9Nj45lOFeAwFWTHdBre1tkUbbRmA8Gh36hLG5NMfofgP+d4NwE42tDzgbm4qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732049928; c=relaxed/simple;
	bh=8WEdVpyGErxs99Yh1r9MEMQl5LIFDjaIDidlxrekh0s=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=e9eO4wf/VL6p50XdCdYp/UTsORdswRNmRYHnPyv/a3zOkc04hdNTrmIRA8QXTWEuSO+4gbPwyDaa+Yb3SEfDmKiq8gymzap1qtg35nKD0nmfiYiH3YFJ+Orfcr3uROb1PiuAmAlID6u711urv+BAnr+ebbpPiKwVWM3utwpJ+s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l9xt6i1Y; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e389ef22432so4313348276.0
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 12:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732049924; x=1732654724; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=r6S4rOH3+OQSdJMr5U+1w/fQ9eAelD/5+HuDvTmNypE=;
        b=l9xt6i1YuApNUB+9iRAFkk7IVe7G35NBDB2dwpPST1RF8TF+kQi62HDn550kYaGVa6
         VklbDet7iwzBtASf2YjvEL23sGE8VBuMd7GB4uX+Vi4NKR46bMpKACy7erbjCHZERhXj
         GF1WtnURGMpWbzhyQxXGYwL16384acnbOxD07CyYY/oRaT9FO12Wns48waGCoBZBLSqh
         IBiqIZY73BN3W20+5bMYHxoukYYi2O+WOFECfGr/wxWGY8p9qQfI3+rYw2UI38lqRboc
         ZtKF20ImsnimunplMJEPi+ayzEW7jjT4hiN+uwT9fu4mYYUxDDRLt452IjgPgQUxY3w5
         Xqvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732049924; x=1732654724;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r6S4rOH3+OQSdJMr5U+1w/fQ9eAelD/5+HuDvTmNypE=;
        b=J0vDAyu8+D4uMHNluCjSEC+eNAZ9X/cGUZPQQJ+drH7BpxcDs/HvttTYZgDGX9ja0H
         f3bE8uUh2g5HsVAEIT97ei1oAcbgXdAoOKfUGP8m71JzbtU9LbcjRChGl4O/VlZzVvZF
         iyf+vxbZ1ObeH753In+gTz3c+4a1guKQxN861jR0TVOmG0YtTx/mjRE0hBIUDYPMTetT
         UjH2Y3SobU6NnGqAtQQr3fMKx267Q7ECHFdO7KkLFObqSqsOaWPLMxtMyGdoReNwRu+o
         +J5H64Zl2E7nvR8jsWKuqbacDNhVCygmE389T/p8FUXyIetE5/5cVbp+Naxp5uz2vXcP
         9+Pw==
X-Forwarded-Encrypted: i=1; AJvYcCUPNSkbCWcYype7Sz9IdYx/B4Vy4XLMf3PeMJLYmGGgHG8u+ARyC7D3rCats07gwe21yBY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwL8okuhC3CyoFCO2vzskXNHe7Q1trRPECjyy0VuShkOkA9tFIm
	C5a0Dsj2f3denHkExzgyIW4SascRthhfsjE1962vpvhM/cH1KhzZ+68L7PccirtSPheh+ne2/Yx
	7Ur8XXQ==
X-Google-Smtp-Source: AGHT+IHpK5pQqyJ2pkrSLDCOOUklWO2InSnJR1eVoVoMwnsqp16+77q4Yb5PQps1c7yCQOY0bhbxQaG15qmS
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fac1])
 (user=rananta job=sendgmr) by 2002:a25:2d0b:0:b0:e38:c40b:a0a9 with SMTP id
 3f1490d57ef6-e38cb60bac3mr38276.5.1732049924316; Tue, 19 Nov 2024 12:58:44
 -0800 (PST)
Date: Tue, 19 Nov 2024 20:58:41 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241119205841.268247-1-rananta@google.com>
Subject: [PATCH] KVM: arm64: Ignore PMCNTENSET_EL0 while checking for overflow status
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

kvm_pmu_overflow_status() currently checks if the PMCs are enabled for
evaluating the PMU overflow condition. However, ARM ARM D13.1.1 states
that a global enable control (PMCR.E), PMOVSSET<n>, and PMINTENSET<n>
are sufficent to consider that the overflow condition is met. Hence,
ignore the check for PMCNTENSET<n>.

The bug was discovered while running the SBSA PMU test, which only sets
PMCR.E, PMOVSSET<0>, PMINTENSET<0>, and expects an overflow interrupt.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index ac36c438b8c1..3940fe893783 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -342,7 +342,6 @@ static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
 
 	if ((kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E)) {
 		reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
-		reg &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 		reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
 	}
 

base-commit: adc218676eef25575469234709c2d87185ca223a
-- 
2.47.0.338.g60cca15819-goog


