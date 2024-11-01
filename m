Return-Path: <kvm+bounces-30364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BFE2A9B9858
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 20:21:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8009A282EB2
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:21:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 653E61CFEAA;
	Fri,  1 Nov 2024 19:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZIQbVUeK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD621CF5D3
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 19:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730488879; cv=none; b=o+3BzfTyH+mFc1VuzSlG7nKHyCUfJE1eav+1mlH6+lYBQNpLaKwRSTX1CVWLi+apxAHUkjU0IPGsxHgn6vH/4jYaF0KUhT+/QBvmh7wrnZ/6k1WFj4USKkuymO4d/AIS0nZcGO491h+QNmXiU7aYbcVRyPdYyP+myU7y40JaHIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730488879; c=relaxed/simple;
	bh=4aHP8sLShS56T2NW/tyehgRssjrZvgR7eKhwcI7P9DA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VAFMSZzgHz0zilaau3ZYdrJCQ1ldCM/Al894rK8rkL9NsF3TNTNhdkyFnnZxz4ed8SiJZJ8L8Tqu5TTBszygr/C+w8ddKvVjyB2q31KemAFQAxRtKp3OwbmeWq8n+tSgK22yQYLPFx7h41MkGpljrPCr0F3UvGioF1TnNLbVnHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZIQbVUeK; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-20c8a637b77so29010445ad.2
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 12:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730488877; x=1731093677; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xI6w6F0Rq/ewsI+CWOomchy6WB54I1EzgId3O/qxAWU=;
        b=ZIQbVUeKvFJ0LPEMh6P4Jzybq5nPuYEM0vmlpEBPoAxhSvteYoONg91s9szQyNJbNS
         R5LcZBMF9Voh2MB3MLyS+a9Msxo7SSIb2ScVJg2raNW4gi7/mMyuXF5JSiH6D8rEeCAm
         +zLPhHLR+PQlQoAXEm8Dm4bFSNJhScA8c5jI8DqG82crpdr4dtr+CCd4Clil/MLvM4UE
         V2eUMdYBpvaImq4OnnHcSb/OgWyEk06pMvA6dPlwV7AQz+RgHzCMVT6HQL2BESL/0Vda
         MFSCfPB07GN7+lnMb0sUeobdmsdk3yCSubiZVt7qLaffnicUVvtG5vuCIhE27K+Uh+EI
         BB1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730488877; x=1731093677;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xI6w6F0Rq/ewsI+CWOomchy6WB54I1EzgId3O/qxAWU=;
        b=XNV9qzQG8d3F3+QDw+Dakl5Hu67KAhesCbqCoK7eoVRj0gLG7O+7bWSMPk18fOGYot
         az9+NLeVgx0Shv4QJEmhBcGVwhiknaD980yN4KWgMMR+/3CaD705SKSz4l05H+zE+BPl
         7GSzdgBtKXcpymkAsIs49fPMiXm6940ipIhdhVSELuOuc7UVropayQfKLVU+YvjBpGMb
         v4om2xSplR4u65W0AMKdSNjmh7lSZnm9SAnpu8Qh+ZlBimc0lb4FDDcK/8PP7W/d0eDc
         WP4OiqtOrLokai0ch4VfIZUZTOaMHvJLHdDrgSDZ0T9qigxInZE1NKcjN7BR0aJ4A8Bv
         ZXpg==
X-Gm-Message-State: AOJu0YziXNSvvgGlWlu13g4dqkuwPPtCxk3ivJkFkNZDkRIcG89HowlU
	eT0dwznQ5EzkJUT8PIWKXoFWco/t4rmzr4avFN9Q7/O+HZemdeBCa2KFm+ugmyQBVWDbERsJoS0
	guQ==
X-Google-Smtp-Source: AGHT+IHACu9yzXMxt2XBd8lJp3UyNmmpGDcPKIHyoyWG0kqfKEdPmB5cvzCvIkxhgVEQQMZPGusL0PGjcmA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:903:22cf:b0:20c:857b:5dcb with SMTP id
 d9443c01a7336-210c6c1493amr1960935ad.4.1730488877405; Fri, 01 Nov 2024
 12:21:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Nov 2024 12:21:13 -0700
In-Reply-To: <20241101192114.1810198-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101192114.1810198-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241101192114.1810198-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: x86: Plumb in the vCPU to kvm_x86_ops.hwapic_isr_update()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"=?UTF-8?q?Markku=20Ahvenj=C3=A4rvi?=" <mankku@gmail.com>, Janne Karhunen <janne.karhunen@gmail.com>, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Pass the target vCPU to the hwapic_isr_update() vendor hook so that VMX
can defer the update until after nested VM-Exit if an EOI for L1's vAPIC
occurs while L2 is active.

No functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/lapic.c            | 11 +++++------
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 arch/x86/kvm/vmx/x86_ops.h      |  2 +-
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 70c7ed0ef184..3f3de047cbfd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1734,7 +1734,7 @@ struct kvm_x86_ops {
 	bool allow_apicv_in_x2apic_without_x2apic_virtualization;
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
-	void (*hwapic_isr_update)(int isr);
+	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
 	void (*set_apic_access_page_addr)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 65412640cfc7..5be2be44a188 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -763,7 +763,7 @@ static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
 	 * just set SVI.
 	 */
 	if (unlikely(apic->apicv_active))
-		kvm_x86_call(hwapic_isr_update)(vec);
+		kvm_x86_call(hwapic_isr_update)(apic->vcpu, vec);
 	else {
 		++apic->isr_count;
 		BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
@@ -808,7 +808,7 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
 	 * and must be left alone.
 	 */
 	if (unlikely(apic->apicv_active))
-		kvm_x86_call(hwapic_isr_update)(apic_find_highest_isr(apic));
+		kvm_x86_call(hwapic_isr_update)(apic->vcpu, apic_find_highest_isr(apic));
 	else {
 		--apic->isr_count;
 		BUG_ON(apic->isr_count < 0);
@@ -2767,7 +2767,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (apic->apicv_active) {
 		kvm_x86_call(apicv_post_state_restore)(vcpu);
 		kvm_x86_call(hwapic_irr_update)(vcpu, -1);
-		kvm_x86_call(hwapic_isr_update)(-1);
+		kvm_x86_call(hwapic_isr_update)(vcpu, -1);
 	}
 
 	vcpu->arch.apic_arb_prio = 0;
@@ -3083,9 +3083,8 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	kvm_apic_update_apicv(vcpu);
 	if (apic->apicv_active) {
 		kvm_x86_call(apicv_post_state_restore)(vcpu);
-		kvm_x86_call(hwapic_irr_update)(vcpu,
-						apic_find_highest_irr(apic));
-		kvm_x86_call(hwapic_isr_update)(apic_find_highest_isr(apic));
+		kvm_x86_call(hwapic_irr_update)(vcpu, apic_find_highest_irr(apic));
+		kvm_x86_call(hwapic_isr_update)(vcpu, apic_find_highest_isr(apic));
 	}
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	if (ioapic_in_kernel(vcpu->kvm))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6ed801ffe33f..fe9887a5fa4a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6868,7 +6868,7 @@ void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 	read_unlock(&vcpu->kvm->mmu_lock);
 }
 
-void vmx_hwapic_isr_update(int max_isr)
+void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
 {
 	u16 status;
 	u8 old;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index a55981c5216e..48dc76bf0ec0 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -48,7 +48,7 @@ void vmx_migrate_timers(struct kvm_vcpu *vcpu);
 void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 void vmx_apicv_pre_state_restore(struct kvm_vcpu *vcpu);
 void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
-void vmx_hwapic_isr_update(int max_isr);
+void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr);
 int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu);
 void vmx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 			   int trig_mode, int vector);
-- 
2.47.0.163.g1226f6d8fa-goog


