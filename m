Return-Path: <kvm+bounces-23111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AEFA946371
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:56:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68BC81C21407
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 18:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1BE616BE22;
	Fri,  2 Aug 2024 18:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PDw3Ddam"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE29166F1F
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 18:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722624927; cv=none; b=PBWyGa3zAghAokGitHr6LRi6VViskF/sHu/XihSqu1ML+MPlRPCeEdJN8ZxMq/kmOIa7sEgCF51werLXzCKT4UvJlEEGgOMKPTw+/mdCVKm+/tme/bZQP5SH/c3RXIEfcUbC7ojJO2W1dEwGHRNF2m6qTvdgYHxthf1kf4ziSY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722624927; c=relaxed/simple;
	bh=LDOaWJALh8LIEd1qVXVH8rc9BOsSwO8ZCATmsDwRVXQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bM6u3GDMhUYj14Wa50sGaA2OFhmOw9RtsLL9h95Pcu4ODG23xPfT1SzVn+JgL/jyZ+CjdvWhhAVZEMkZj8ypMDPf3785EQ+FkZgzJ7RPNPxg5lq/fd07uuYXbe5nGC0EB0i2/jq3t+XAnTRFwep+y4KitZ0nqd+U7grFNf0Pvm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PDw3Ddam; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0bcd04741fso4509649276.2
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 11:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722624925; x=1723229725; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FE77h25ouI+MvHqHcKNFD0Aq2a2Ny5IL+xeLrJLvY5s=;
        b=PDw3DdamHXrRNXvwvIcYifvgTmEBS7X4Qz3hQbuupkM4SxaQvUxRqWmNPiNZn6TkwV
         2KlvUdUokRBQ3NOmBly0C8JlQl30QB1HhGQbINRnKscyNvDvXi5Rd6cBkew4+4zi21rf
         k5OWASfQzDPhRJwC+AIoQ3GYiSi3xAFNcBCC/U80SN/7xS8Cj8mT3dXeNwdLAOD3lLsB
         2NBSihb4gqzMo9hulpm1SF6toxxRBv9B+U81l09nmYVxy0iMpAS6oLYl5ySOH/uXtxMV
         zSR5Tagz1TQ0ndVVt8qSagsobAp2KiCHq81diK6LuUalEtOpG8Y5z7XlQd/s6AQclKkt
         0w7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722624925; x=1723229725;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FE77h25ouI+MvHqHcKNFD0Aq2a2Ny5IL+xeLrJLvY5s=;
        b=wouX1j6lFxjPOE4cpsUUute4iNERGBI5IO771v00U22F/aRwqKLMRE1UO8AY7iiTT7
         wCfo7qM1htAf0ON3h4Roy5iTRnMzrV9SgmjvUdUaReqtLhZw468Hk4DAgFbUyAW/FAuY
         p0W454b3oMTnpL0Ylg8KAhy+k92/z3BomsefjYQpDwLF51moD/M5tQXjHGwJovvS2Cg0
         Ii44Ha5BLYgih2HHYCD3QfNexggGwFS54mwdkh2+Amu49kHkEsqJbC9nOZkoDfZbXCPP
         Ek1NbTfGoMYL1FhJ4bNUoq9/aBfigA6geg9boFmmSp7Ziu4FRpkBJK4YfFTo4DM7Ync+
         g3qA==
X-Gm-Message-State: AOJu0YzkWGjQqN586rWp3EiEMJTLKO4zrz053LVbk2gmGX/czONPYqGJ
	zjMpflpcHsAhibzU4ngzOGLflxrZBADrMEaqkSPB86rhTnuRYEJolEYtKc67LVF3rUphmPVMpJt
	qQw==
X-Google-Smtp-Source: AGHT+IEzFcg9v5dqpL46Kk3NBRRR4k+8FlZyX8gqz3k2cnpL3lAj/Gmokl2ZzR9H5/8TOAiTDCSBElhz7Yk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:154e:b0:dfb:22ca:1efd with SMTP id
 3f1490d57ef6-e0bde3ec6a5mr266556276.9.1722624925601; Fri, 02 Aug 2024
 11:55:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 11:55:07 -0700
In-Reply-To: <20240802185511.305849-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802185511.305849-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802185511.305849-6-seanjc@google.com>
Subject: [PATCH 5/9] KVM: VMX: Remove restriction that PMU version > 0 for PERF_CAPABILITIES
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Drop the restriction that the PMU version is non-zero when handling writes
to PERF_CAPABILITIES now that KVM unconditionally checks for PDCM support.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c1d06f800b8e..f636d811bdc1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2460,8 +2460,6 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
 	case MSR_IA32_PERF_CAPABILITIES:
-		if (data && !vcpu_to_pmu(vcpu)->version)
-			return 1;
 		if (data & PMU_CAP_LBR_FMT) {
 			if ((data & PMU_CAP_LBR_FMT) !=
 			    (kvm_caps.supported_perf_cap & PMU_CAP_LBR_FMT))
-- 
2.46.0.rc2.264.g509ed76dc8-goog


