Return-Path: <kvm+bounces-54728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E514DB273C7
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:27:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07D14173403
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:26:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7528C19F421;
	Fri, 15 Aug 2025 00:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VTI5SR2D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36BF1624DF
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755217551; cv=none; b=rFXZni4mmlh/1IlW0DXFRgdXIUfzJqxAR3V/l3Jr7oE9v8aHmfswXq1i7NQ8ELJXURAJV87uWX29a6X7fytSPE3Ez+5ZymynZ9N52HDqB6FiLxjmT1sWDEAIxygPvBrRUaVlIuGRRt4d9Ywmj2iHqWEKALuqChuZO5ySX5E/Yyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755217551; c=relaxed/simple;
	bh=wDYWWatnyATO4Eh2mM5XkXQ1kvjBt/+3TzesreC4PmM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VRbB0oIGBEd6Wn5iKkV2prMaxQpbI4AAklDiSJbtJvfPL2GvBHD9f5phR1rXW2ecCyxHblD/+wYKVteuY1zyQID8/3IyXAAYGDpcndBY6jDhTLVw9VXPaeLqaDlJF7oR00RhWDEgTwtD0qS6fknz+vC+JQj9LhKXWSRCdSPF5l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VTI5SR2D; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b471751e03aso914350a12.2
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755217549; x=1755822349; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RKxaIWg0LMjjHqTEVpyc6fMwZ55OLhDLYqJId7CQr6s=;
        b=VTI5SR2DuCfPhsdPsXA4ChWBzlzsuzKGKCgja4mXlt0cqyj8SqzsjRL7YraQ2+feDB
         a3bf9SlKbLHX3XWqeC9EZ92ORgUNKBQsqG6i7hfD5XY/XsvaS0VQSY1UsILUV4hTDDnN
         AENPzWEPLN80zHY9VvvKceTFJ7ZMLCVN6mJGxnkbIc+utaqb23SvjOqhVSBBSHaHRlna
         UoprQvNpR3zS1Zn0vcDD4+uthhwRfIJvNU8NshOT9/ccwrFdENWZ8kFsWTCYxqRIn3+g
         2fLi6qpXgum8BFGydnsn+873icJCnhuscXlwonkOIp20iBPs4xrscX2DPN63mqxaC2Db
         1clQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755217549; x=1755822349;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RKxaIWg0LMjjHqTEVpyc6fMwZ55OLhDLYqJId7CQr6s=;
        b=rZ89I89mbSHQM8Rc+0BI47CHgaht4qUUJeMCykHLuiuo8K6rahOMNPdEPscJ07thoM
         LEaZ3Fo3IfQDBcxnjMHuks9r7VCuR0k3wT6gZzQ8D1FLnzboOEzWxQK23BzJm/Ln8dLr
         qsSirtZAd9aPUFHppzV48udjqPtwEZ9yKv3FiVF9zy039DblF3h8OKjeEnrPT/LMtKvc
         K1Ah/mfwHBTdFCDnKZA6v1Vom1NdtyG9+QDO5o7aoUig0CdS7eALczC9aDF7Y9uxd504
         W/2oSEFs+pbSHAwIj/q1MFve08xOKaZbnvT6T+s9I0k9ymMzb4M6/0/Do03zt5NEhZ9M
         U5Cw==
X-Gm-Message-State: AOJu0YwJQMCMAtiljmkovlGocfvAK46lg3g0kpY2KU7fGMaNT2Ki64Ae
	x48GL6IxbaDMve9fyn97/VUnUvLsj9jlYUi7xOODWltd3otyArTK+hloTBDaSjxKXgggcgUwhD8
	9fRWtSw==
X-Google-Smtp-Source: AGHT+IGHzexSNXukCre2Zz0F5woCd1hCPY+5qAAb65oZUM8TAMMzqSiCzgnuMcCVbkJpcZ9vAgqx6zlEWZk=
X-Received: from pgbfe14.prod.google.com ([2002:a05:6a02:288e:b0:b42:189a:ccef])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a11d:b0:23f:fbb1:c230
 with SMTP id adf61e73a8af0-240d2eea4efmr355758637.21.1755217549254; Thu, 14
 Aug 2025 17:25:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:25:23 -0700
In-Reply-To: <20250815002540.2375664-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250815002540.2375664-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815002540.2375664-4-seanjc@google.com>
Subject: [PATCH 6.6.y 03/20] KVM: x86: Plumb in the vCPU to kvm_x86_ops.hwapic_isr_update()
From: Sean Christopherson <seanjc@google.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

[ Upstream commit 76bce9f10162cd4b36ac0b7889649b22baf70ebd ]

Pass the target vCPU to the hwapic_isr_update() vendor hook so that VMX
can defer the update until after nested VM-Exit if an EOI for L1's vAPIC
occurs while L2 is active.

Note, commit d39850f57d21 ("KVM: x86: Drop @vcpu parameter from
kvm_x86_ops.hwapic_isr_update()") removed the parameter with the
justification that doing so "allows for a decent amount of (future)
cleanup in the APIC code", but it's not at all clear what cleanup was
intended, or if it was ever realized.

No functional change intended.

Cc: stable@vger.kernel.org
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Chao Gao <chao.gao@intel.com>
Link: https://lore.kernel.org/r/20241128000010.4051275-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[sean: account for lack of kvm_x86_call(), drop vmx/x86_ops.h change]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/lapic.c            | 8 ++++----
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5dfb8cc9616e..5fc89d255550 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1657,7 +1657,7 @@ struct kvm_x86_ops {
 	bool allow_apicv_in_x2apic_without_x2apic_virtualization;
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
-	void (*hwapic_isr_update)(int isr);
+	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
 	bool (*guest_apic_has_interrupt)(struct kvm_vcpu *vcpu);
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 66c7f2367bb3..cbf85a1ffb74 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -750,7 +750,7 @@ static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
 	 * just set SVI.
 	 */
 	if (unlikely(apic->apicv_active))
-		static_call_cond(kvm_x86_hwapic_isr_update)(vec);
+		static_call_cond(kvm_x86_hwapic_isr_update)(apic->vcpu, vec);
 	else {
 		++apic->isr_count;
 		BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
@@ -795,7 +795,7 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
 	 * and must be left alone.
 	 */
 	if (unlikely(apic->apicv_active))
-		static_call_cond(kvm_x86_hwapic_isr_update)(apic_find_highest_isr(apic));
+		static_call_cond(kvm_x86_hwapic_isr_update)(apic->vcpu, apic_find_highest_isr(apic));
 	else {
 		--apic->isr_count;
 		BUG_ON(apic->isr_count < 0);
@@ -2772,7 +2772,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (apic->apicv_active) {
 		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
 		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, -1);
-		static_call_cond(kvm_x86_hwapic_isr_update)(-1);
+		static_call_cond(kvm_x86_hwapic_isr_update)(vcpu, -1);
 	}
 
 	vcpu->arch.apic_arb_prio = 0;
@@ -3072,7 +3072,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	if (apic->apicv_active) {
 		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
 		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, apic_find_highest_irr(apic));
-		static_call_cond(kvm_x86_hwapic_isr_update)(apic_find_highest_isr(apic));
+		static_call_cond(kvm_x86_hwapic_isr_update)(vcpu, apic_find_highest_isr(apic));
 	}
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	if (ioapic_in_kernel(vcpu->kvm))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e53620e18925..cde01eb1f5e3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6834,7 +6834,7 @@ static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 	kvm_release_pfn_clean(pfn);
 }
 
-static void vmx_hwapic_isr_update(int max_isr)
+static void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
 {
 	u16 status;
 	u8 old;
-- 
2.51.0.rc1.163.g2494970778-goog


