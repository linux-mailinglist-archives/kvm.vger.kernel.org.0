Return-Path: <kvm+bounces-32594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C4A19DAE75
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:20:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BF80AB22EBF
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA682203705;
	Wed, 27 Nov 2024 20:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m3iRyrKT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A18D202F9B
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732738802; cv=none; b=uvOKfRzfLr87msKnVhk2kuQRTVXYivDIZabnlyg6g3w/FUpivpSY9ToqZd3ccHlVgxD2I8i42guLbGlPPVzQlNuXaF55G5kGaz2ZW7x+9UCpwML9WpqgdJtGtuJZIyZ8zFD/o2cRZ1fwnpmzFoNb0dyshxhmDDf/0ndBApfm4Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732738802; c=relaxed/simple;
	bh=M9Jkgz2EO8xRRD8BrzQJ7+MC6wPnkehquZQSBslCRwk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IUEIgCDyO52DNaqdgXOBVzaVzEWoW30ghQFMqOrr14ONZyPVf0jBT8+13KD8nVtjzOP+x5WlX2NPbNpZH4JX1M5p74msCKh4I258YF4CIaBRWgz7rY9+T6gekY08gggq54inR91lQlILaleQhDhtKyIfOMafLZZ1zD2W8sUxwxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m3iRyrKT; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2edeef8a994so142576a91.2
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 12:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732738800; x=1733343600; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=crARhPJrJmzI1ceolaka7M30zQE5TrnLUEpjfAnpX0U=;
        b=m3iRyrKTx74WglV43DLPNQ4D47MHz9TinUYRBTMfVCQg91w7jwmMx5Q3Jww7KUtqvO
         4cDQdQq1lxBfFXc/DlofHIRsec8BbFGbt+98RoIzzdA16wMwsnRP25U3/Sent9h676U+
         5nemvN21dWh2wKGLxxbpT5HpMoXCfEg+noElqdGQUJbUgfXPfGi7DlGrI2CJu0R2bmNW
         Mxh4g+YGxHxTPqvaxhbopAwrlW4/PVwmBE+wfTS0tp9XPSq8e15I1tlvmNyaJ2nQ0PP2
         FgpqOAUtWbGQxCPXgyxIamIF+S9EQxGcQUOM2Hzs4ZjnQ/lBl6ARztyZnHMaLlD9EY5Q
         b7kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732738800; x=1733343600;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=crARhPJrJmzI1ceolaka7M30zQE5TrnLUEpjfAnpX0U=;
        b=MiYFhC4jPSYTSLUaD+qBoAlrc0OXD9J9etHbixUBn5CQT6lXDLpjMIMbZP3eEzAQod
         7EjdEkFqmlyH1nIFmlIOTwktvdK50OR0crWaFZdaU9sms/ONxUXlAVxLySekMUElN/Lv
         dEz0nqVNki7IBam4jsvksk0p370yY9bdYFSVzPRxezoDxwX87j1RKAzfx6DTUqSslk9S
         /OMSiPftvac66d6e3tPCoa/sZOoVLrHif9QTZLF+gqUM+qyYffpJbg+hmfK0tnXiL22u
         93+MwO8dayFH8dvFIUTKFeOQITHpWEXTqSKO0WI82FSVJhfPUGANjREk+oido/hharNX
         ty4g==
X-Gm-Message-State: AOJu0YzePHicAZKU0u+VYRtwhVNAp/+7V/Xu5bF+xpDVUhLzxvhchqDY
	cbzODPOfbyfTu4dsQAZtU+YN41awUYj1pudXk8iwaeO2vzNBtgYKOPLM6IM1UW9CjSqtopAfhlP
	J8IfdnDf0QWoFUMxCW/rAaaRS6/I1CCNcN5krsYMxsJa/wemW/Og6P4fvACGXLTAldJ3Co9plP1
	NYRknUc5e5DC+vkS1yx61MKtzVtH5gbLLj5aViJHUWtBsDkU7GJg==
X-Google-Smtp-Source: AGHT+IE9IP38JoU3dpJ/46ihSXUGqm4EZse8JoozdPfC116+7DVIACjO+u2FJgMwRCY3evgNV2vfg2IqpMqbI4G4
X-Received: from pjbpt8.prod.google.com ([2002:a17:90b:3d08:b0:2ea:aa56:49c])
 (user=aaronlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2882:b0:2ea:83a0:47a6 with SMTP id 98e67ed59e1d1-2ee097dd78bmr5723308a91.33.1732738800057;
 Wed, 27 Nov 2024 12:20:00 -0800 (PST)
Date: Wed, 27 Nov 2024 20:19:22 +0000
In-Reply-To: <20241127201929.4005605-1-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127201929.4005605-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241127201929.4005605-9-aaronlewis@google.com>
Subject: [PATCH 08/15] KVM: SVM: Pass through GHCB MSR if and only if VM is SEV-ES
From: Aaron Lewis <aaronlewis@google.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"

From: Sean Christopherson <seanjc@google.com>

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2380059727168..25d41709a0eaa 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -108,7 +108,7 @@ static const struct svm_direct_access_msrs {
 	{ .index = MSR_IA32_XSS,			.always = false },
 	{ .index = MSR_EFER,				.always = false },
 	{ .index = MSR_IA32_CR_PAT,			.always = false },
-	{ .index = MSR_AMD64_SEV_ES_GHCB,		.always = true  },
+	{ .index = MSR_AMD64_SEV_ES_GHCB,		.always = false },
 	{ .index = MSR_TSC_AUX,				.always = false },
 	{ .index = X2APIC_MSR(APIC_ID),			.always = false },
 	{ .index = X2APIC_MSR(APIC_LVR),		.always = false },
@@ -919,6 +919,9 @@ void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, unsigned long *msrpm)
 		svm_disable_intercept_for_msr(vcpu, direct_access_msrs[i].index,
 					      MSR_TYPE_RW);
 	}
+
+	if (sev_es_guest(vcpu->kvm))
+		svm_disable_intercept_for_msr(vcpu, MSR_AMD64_SEV_ES_GHCB, MSR_TYPE_RW);
 }
 
 void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
-- 
2.47.0.338.g60cca15819-goog


