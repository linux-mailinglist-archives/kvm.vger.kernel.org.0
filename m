Return-Path: <kvm+bounces-30358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E7899B9838
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 20:15:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31FF728227F
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BBBF1CF5F1;
	Fri,  1 Nov 2024 19:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mHqfa68k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236AF1CF2B8
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 19:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730488495; cv=none; b=BxT/XQAMS2iJ2uYMW76e/0BF55LJrm7C2qkyITPdZ8eahSn2+J6COdyay+CHFc9ajgOTTvfSzzTIpKC3Jy/Xs4cE0xrrg8MjgPSzOqT6HbpLX0GmYGtMeaGfTcl7A6jttOGFhMAP2Zxna4xCaVhPCs5FxkGPAQCj7n1vy4r9TH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730488495; c=relaxed/simple;
	bh=Z8EXJQg9J+JbZJ5bvHzBnxb9K+Y/SuxFmaizU8r2hCI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V8GmrlFFKP58gGdUtiH2UvFaOoyy8m7gKQGVEPS59bTVPTxtLRam+Om/ZoqNFi9UbzNfSJuqbqpA6w11Uv6vOb6BETrsWnCil4ZlI1EE8dUgihcOLDm9UVMR/rXZfxF/juUJOKWVM2MgErKC43V8A/W1Tn+QJ4TkINUTQqo2mdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mHqfa68k; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e31e5d1739so47978207b3.1
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 12:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730488493; x=1731093293; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=v92SLkTXXGmBr8w3sJwcuNbutcUF6pT1F5wULmisia4=;
        b=mHqfa68k4YVgtjNxcRjK4FimwkmvqdSf8tPCHiWUcQT6J9Hz6br/o2Duf5TgFXAUjE
         UiAk5qy/xoVNPhBcFqPe+a2qYdwcjpHXT4RDJEGQylr51J2hHJNiDk5pRhhiWeU5FbUR
         FYwcS6fcHgX5YmU4KyTaVms4V1BCVAEifYMEpyq2IaYdM6GsyCnm5CGlLZJ3fbwk44Up
         qp6ru5VhtXHK0PDLB0VfgDbXeGIbxwWHVz0Lbsy3RfYyB3l/IlIpwu1LVKS26kA3ob7n
         V8uINeOuTFgAJYumJX3lCDsoszyhGj+fxbr2ClZRaS2g7/Rf5cB5qNI9eiM/W3bbUsrY
         bOIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730488493; x=1731093293;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v92SLkTXXGmBr8w3sJwcuNbutcUF6pT1F5wULmisia4=;
        b=VvlAYK/4T5yhL6CxqW4/2OaJKcMR1t7vtLIJyHyGuTEXcTmcYaNF5/auw/t9qwKajk
         b14xGHuxkWmvswzb5KUpE8IGOkd7jXpH4v7Ud0MlJy21ykqAEXkCopmgfkFpMr7HzsdX
         VNVGOkGuzUC2NYrecXtY2g5eVp7pbHkvAEAM1dJyGXO+lgw/a3sfMc+kF59YkBle9RFC
         J5PZjN8UzSUIQDXgxBV810JCQcxc8q9wQnpn5Fc2ICFzd0RvmcYgcRN3XQPiv0Sn4QM9
         rhRS/CoYHlbVfA7NBtrn8hpXZwzTgJBMCgYoQKTIIfKDn8PFjVkArHwl6EMUuSehrZ6q
         3wzw==
X-Gm-Message-State: AOJu0Ywns8AyzAocg1okHisUpVThMxtpvTMOUp1GqHeG20O32dZ3YF/e
	6nWZfHVc6XFfMGh/26sHTlO64FdgHGMUX8mNMsMe7lyXVoC0hcbDZL1kXoB/rkyMtQc6zGyps6M
	JjA==
X-Google-Smtp-Source: AGHT+IF9r8zl08wY2gD7V1mrRcKyxB0hLcWTnA85ohgz9qnHRR8D6x/+fevO5rXxbmNY/LHUGAaznvSD3qo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:680a:b0:6db:c34f:9e4f with SMTP id
 00721157ae682-6ea64c2d414mr803537b3.8.1730488493198; Fri, 01 Nov 2024
 12:14:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Nov 2024 12:14:43 -0700
In-Reply-To: <20241101191447.1807602-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101191447.1807602-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241101191447.1807602-2-seanjc@google.com>
Subject: [PATCH 1/5] KVM: nVMX: Explicitly update vPPR on successful nested VM-Enter
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Always request pending event evaluation after successful nested VM-Enter
if L1 has a pending IRQ, as KVM will effectively do so anyways when APICv
is enabled, by way of vmx_has_apicv_interrupt().  This will allow dropping
the aforementioned APICv check, and will also allow handling nested Posted
Interrupt processing entirely within vmx_check_nested_events(), which is
necessary to honor priority between concurrent events.

Note, checking for pending IRQs has a subtle side effect, as it results in
a PPR update for L1's vAPIC (PPR virtualization does happen at VM-Enter,
but for nested VM-Enter that affects L2's vAPIC, not L1's vAPIC).  However,
KVM updates PPR _constantly_, even when PPR technically shouldn't be
refreshed, e.g. kvm_vcpu_has_events() re-evaluates PPR if IRQs are
unblocked, by way of the same kvm_apic_has_interrupt() check.  Ditto for
nested VM-Enter itself, when nested posted interrupts are enabled.  Thus,
trying to avoid a PPR update on VM-Enter just to be pedantically accurate
is ridiculous, given the behavior elsewhere in KVM.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 746cb41c5b98..84386329474b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3604,7 +3604,8 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	 * effectively unblock various events, e.g. INIT/SIPI cause VM-Exit
 	 * unconditionally.
 	 */
-	if (unlikely(evaluate_pending_interrupts))
+	if (unlikely(evaluate_pending_interrupts) ||
+	    kvm_apic_has_interrupt(vcpu))
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 	/*
-- 
2.47.0.163.g1226f6d8fa-goog


