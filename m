Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2823DFD71
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 10:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236845AbhHDI7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 04:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236853AbhHDI7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 04:59:00 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56B2C0613D5
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 01:58:48 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id o6-20020a056e020926b0290221b4e37e75so599683ilt.21
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 01:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=83fDaIfLsY16yic2+Bpl9lC9hOGkPIV4LchssH1j3LE=;
        b=SN6GL4hBv6p6nMD4A6e58ghkZoNJfYaNi1MH9O1SIy7AoxXS7cRW68enEg2zIivQkk
         aZholzalc9xdnfdFzpu9eczDYMKU3+21wWy+fHFgrhF1LmBnspbi1VbEK21vIeTc6TgF
         rxlaa1A0gISSGbu1UB7PaIEPBWtI6gYPJAV/mOAXQctzT1NMqQZJYYnplqQFgzPN9OjD
         YtOYVGsAkqQIxCqhX5FD0AOTTtVv8WbFRE/CHjmppQjFKKelImAn2YGU+uu7XY+qyKZr
         CbnHCJveaEuBZkRFO75LP0K3L/M8CD56y8I6K0CXzIBrVp7Y0gEcqjJiNLCF63KqUPgI
         uDFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=83fDaIfLsY16yic2+Bpl9lC9hOGkPIV4LchssH1j3LE=;
        b=IVFVg4Wsxx8RMW2gG40UEaDR0Wn7e9xjBtzIVgPydNMThg0PgLiTCKi5bEOn14yop8
         NH0Qb0lkbCnfHDwtpG+38+3qMZ+YPZRXSaxgTMrRPKXjwXnFWV3f8RjtVKhpJ0ZCfXIj
         Ga57mpsd2rZdhpTGMvtMKjEHcpghJdGatFPpEcCiWxHJ4r/a+uL/bVE64v0oBPftDQ/V
         vGkl0PLDPsjERVkmCIwFM2ofsNFgq3/BT8AkFAGojLW6XaUQHY54rbxBZhU1RE7sGZ0+
         3FLl7onGwM2ZOLSWELekx9p1KQhqoQ5509zevMAHJ5SPfkIXLHPW8Mh5V3mSYifnNm87
         TBNQ==
X-Gm-Message-State: AOAM530yPZKQThF/KSjMryUi5VQ4MOt75q8eaDRHFOwt/N95hL/XoRST
        rG8Qdz4LaXgvMNC1YAkqhjeR0ymo3Tu+l9m97vJZBULfRQtMZdghRWYjzpVY1yaM1yKI7vUeXbt
        AViC3Xg5Cl6TM12AgGli+PYS/FefH0aoO+819rkEynZqN5UWzzrII6eiVSA==
X-Google-Smtp-Source: ABdhPJzi9q8UGwJAYqkti8laANuUPc3nn5R3eDyiiZDnOVn9vGB1o/QfvD8/gVEEbONDuMag3MzbiMyJaWQ=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:5205:: with SMTP id g5mr634503ilb.22.1628067527974;
 Wed, 04 Aug 2021 01:58:47 -0700 (PDT)
Date:   Wed,  4 Aug 2021 08:58:10 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-13-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 12/21] KVM: arm64: Separate guest/host counter offset values
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some instances, a VMM may want to update the guest's counter-timer
offset in a transparent manner, meaning that changes to the hardware
value do not affect the synthetic register presented to the guest or the
VMM through said guest's architectural state. Lay the groundwork to
separate guest offset register writes from the hardware values utilized
by KVM.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/arch_timer.c  | 48 ++++++++++++++++++++++++++++++++----
 include/kvm/arm_arch_timer.h |  3 +++
 2 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index c0101db75ad4..4c2b763a8849 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -87,6 +87,18 @@ static u64 timer_get_offset(struct arch_timer_context *ctxt)
 	struct kvm_vcpu *vcpu = ctxt->vcpu;
 
 	switch(arch_timer_ctx_index(ctxt)) {
+	case TIMER_VTIMER:
+		return ctxt->host_offset;
+	default:
+		return 0;
+	}
+}
+
+static u64 timer_get_guest_offset(struct arch_timer_context *ctxt)
+{
+	struct kvm_vcpu *vcpu = ctxt->vcpu;
+
+	switch (arch_timer_ctx_index(ctxt)) {
 	case TIMER_VTIMER:
 		return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
 	default:
@@ -132,13 +144,31 @@ static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
 
 	switch(arch_timer_ctx_index(ctxt)) {
 	case TIMER_VTIMER:
-		__vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
+		ctxt->host_offset = offset;
 		break;
 	default:
 		WARN(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
 	}
 }
 
+static void timer_set_guest_offset(struct arch_timer_context *ctxt, u64 offset)
+{
+	struct kvm_vcpu *vcpu = ctxt->vcpu;
+
+	switch (arch_timer_ctx_index(ctxt)) {
+	case TIMER_VTIMER: {
+		u64 host_offset = timer_get_offset(ctxt);
+
+		host_offset += offset - __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
+		__vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
+		timer_set_offset(ctxt, host_offset);
+		break;
+	}
+	default:
+		WARN_ONCE(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
+	}
+}
+
 u64 kvm_phys_timer_read(void)
 {
 	return timecounter->cc->read(timecounter->cc);
@@ -749,7 +779,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 
 /* Make offset updates for all timer contexts atomic */
 static void update_timer_offset(struct kvm_vcpu *vcpu,
-				enum kvm_arch_timers timer, u64 offset)
+				enum kvm_arch_timers timer, u64 offset,
+				bool guest_visible)
 {
 	int i;
 	struct kvm *kvm = vcpu->kvm;
@@ -758,13 +789,20 @@ static void update_timer_offset(struct kvm_vcpu *vcpu,
 	lockdep_assert_held(&kvm->lock);
 
 	kvm_for_each_vcpu(i, tmp, kvm)
-		timer_set_offset(vcpu_get_timer(tmp, timer), offset);
+		if (guest_visible)
+			timer_set_guest_offset(vcpu_get_timer(tmp, timer),
+					       offset);
+		else
+			timer_set_offset(vcpu_get_timer(tmp, timer), offset);
 
 	/*
 	 * When called from the vcpu create path, the CPU being created is not
 	 * included in the loop above, so we just set it here as well.
 	 */
-	timer_set_offset(vcpu_get_timer(vcpu, timer), offset);
+	if (guest_visible)
+		timer_set_guest_offset(vcpu_get_timer(vcpu, timer), offset);
+	else
+		timer_set_offset(vcpu_get_timer(vcpu, timer), offset);
 }
 
 static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
@@ -772,7 +810,7 @@ static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
 	struct kvm *kvm = vcpu->kvm;
 
 	mutex_lock(&kvm->lock);
-	update_timer_offset(vcpu, TIMER_VTIMER, cntvoff);
+	update_timer_offset(vcpu, TIMER_VTIMER, cntvoff, true);
 	mutex_unlock(&kvm->lock);
 }
 
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 51c19381108c..9d65d4a29f81 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -42,6 +42,9 @@ struct arch_timer_context {
 	/* Duplicated state from arch_timer.c for convenience */
 	u32				host_timer_irq;
 	u32				host_timer_irq_flags;
+
+	/* offset relative to the host's physical counter-timer */
+	u64				host_offset;
 };
 
 struct timer_map {
-- 
2.32.0.605.g8dce9f2422-goog

