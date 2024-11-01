Return-Path: <kvm+bounces-30375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8E749B98C0
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 20:36:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAF641C2209B
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5CA21D9A78;
	Fri,  1 Nov 2024 19:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vGut7Hxo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674571D9A58
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 19:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730489737; cv=none; b=fR9Z2+5/NoVVkk3JiOECgpPbzlqMp/9M8QZxIkU7DTe7cH6G2ANTr8trzEPL+npXMfCflTHJC54YLAqOcoZNh3jtIlhk9YuPSz8sphf/1/LiKJKZhPAoadztGc4KSTDwSa53Ws/ejvz/M3Tv/xpMP+JBYAvqdkB46Bz/yuX8+xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730489737; c=relaxed/simple;
	bh=S/oFiR+vJC2zXaL2rYvJPNfkmusIpPM2DSCGWXv6Dyg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=KPq70NnQOWfLWeHWChBoFW8E2rcvz/V7/mz/UVx8oQhdM/mPDFlBpLfhCAgQTCAbSKcWxlOVbl2J/DGQZ3PAxj5yO/vDDQ21ioM97SWz9xinl8GBp9rMxK1erPDBhElsjAQY14G3A67UTBNyVX2ke1X0R/lCvIUdtrS8LT2sdKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vGut7Hxo; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e30c7a7ca60so3419846276.0
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 12:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730489734; x=1731094534; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uUy5ZopjlqJWDufwe8vqXw7HsEJ5VFkUPkkuX0f959Y=;
        b=vGut7Hxopl41L+yUzFGVqMubOhmTLpO80wzvhWrh/hyOvdnPfTwzzZJwTKIy3ByjrK
         4J+1NsJaj0HFQDQS5fDbQd0vWZicPua8iZxzEY6fuazCW5x530kfwE0XTwrg9J7tNrH6
         UkmewPNcIaYjTGJLxCQHO6rYh90P2/XUM3QPv3OzbWL66fHID2cglW6gSkj5TMNgbK11
         nM1RYyCz9V6EdpyAywtTpRgty1hOHXW/XFbhuL+Z/6qVFVQ45K+Fa7UUKQ8lzk3BbYvx
         QH4Ms/jgAgPAXWJJpYLYhFOCInVDig3zAsfC58/Syvp98RlyRAa3cN+JS82sWqEmF9CL
         fN5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730489734; x=1731094534;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uUy5ZopjlqJWDufwe8vqXw7HsEJ5VFkUPkkuX0f959Y=;
        b=jMSNXFI7zgnXsowbY3W3SGc+00KBXPs1RcRBYnSUUoEYMUSh9COkw3P78JST3/q8y5
         l4UNdzmHrU4Z+uHkmWuhe+mug35SW1082yWzS3G9L3bFIB8t6LbINXfVp3L3LTWx8zfS
         7gXo7T3xDvE1p04ZWqGbxZj5HqA4ncQE/FrZGB97cUEqUzfft98Ha1dvoSunEVvbWMkK
         8MmZ4JPlIPzlMfaEm9S0nc2rQ8uvcpwknD0OQdsvhAePQT8wVC06lCyfiBvYGOW4FIHn
         vxL4l+ze08VeytmrsXma5a07vnz/t5JtSqjArvdnKkNJKnCyu2IXSaNRKAaqwY2fNstJ
         66TA==
X-Gm-Message-State: AOJu0Yzdqk2DUY466kD0g+3W/JWLnMzrWUyb9uxVeDblVGKKP5wXmW0M
	BUBVP6HZspj4mI6Y+OdjWgecKlQ75OmrT5U3yuceAEkb3ukb//oBuU5czrYtuoNvii0DzhO8xjg
	+eQ==
X-Google-Smtp-Source: AGHT+IFL5eQqn+yUkx/nmKef/J3UAoZeVywmBetLKzDmO6D7CBi8heV8pn93AUnwAMp0MBljsLb1ED8hw20=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a5b:f0f:0:b0:e2e:2cba:ac1f with SMTP id
 3f1490d57ef6-e3087bd5414mr136150276.6.1730489734464; Fri, 01 Nov 2024
 12:35:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Nov 2024 12:35:32 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241101193532.1817004-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Update irr_pending when setting APIC state with
 APICv disabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yong He <zhuangel570@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly set apic->irr_pending after stuffing the vIRR when userspace
sets APIC state and APICv is disabled, otherwise KVM will skip scanning
the vIRR in subsequent calls to apic_find_highest_irr(), and ultimately
fail to inject the interrupt until another interrupt happens to be added
to the vIRR.

Only the APICv-disabled case is flawed, as KVM forces apic->irr_pending to
be true if APICv is enabled, because not all vIRR updates will be visible
to KVM.

Note, irr_pending is intentionally not updated in kvm_apic_update_apicv(),
because when APICv is being inhibited/disabled, KVM needs to keep the flag
set until the next emulated EOI so that KVM will correctly handle any
in-flight updates to the vIRR from hardware.  But when setting APIC state,
neither the VM nor the VMM can assume specific ordering between an update
from hardware and overwriting all state in kvm_apic_set_state(), thus KVM
can safely clear irr_pending if the vIRR is empty.

Reported-by: Yong He <zhuangel570@gmail.com>
Closes: https://lkml.kernel.org/r/20241023124527.1092810-1-alexyonghe%40tencent.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 65412640cfc7..deb73aea2c06 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -3086,6 +3086,15 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 		kvm_x86_call(hwapic_irr_update)(vcpu,
 						apic_find_highest_irr(apic));
 		kvm_x86_call(hwapic_isr_update)(apic_find_highest_isr(apic));
+	} else {
+		/*
+		 * Note, kvm_apic_update_apicv() is responsible for updating
+		 * isr_count and highest_isr_cache.  irr_pending is somewhat
+		 * special because it mustn't be cleared when APICv is disabled
+		 * at runtime, and only state restore can cause an IRR bit to
+		 * be set without also refreshing irr_pending.
+		 */
+		apic->irr_pending = apic_search_irr(apic) != -1;
 	}
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	if (ioapic_in_kernel(vcpu->kvm))

base-commit: 5cb1659f412041e4780f2e8ee49b2e03728a2ba6
-- 
2.47.0.163.g1226f6d8fa-goog


