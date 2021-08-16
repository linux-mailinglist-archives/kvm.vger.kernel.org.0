Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7778A3ECBF0
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 02:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhHPAMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 20:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbhHPAMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 20:12:54 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC23BC061764
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:12:23 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id bo13-20020a05621414adb029035561c68664so11842059qvb.1
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uLRkJfCEmqyHmwt67N1JORfBg6VVerDIPLLp0n4Mv0U=;
        b=az5D41bG34bsZyE4U/Nl4rUJhZpPihdRW7A67FKbR51vbYA8/c4WWz5DmGb6kA+SAI
         Fy5fnGj6b0cIT+KDkY4NvSAeSZiTilmdZNQaaMzjxMO3xmKhydttHM6ZXtRi4ct/Q+y6
         byU+NodQcgiK/WX5AG7ikc0vn5J7JGvnBxHJ0rwHeo05kMP95N7l+syBD9e9ekADqFC6
         jH8vf2L+PHooPrAuSTPQcLlU5D1nZ4hW3OeUxX8NM/dKDjfhQc+1eniThWPOG8bF8uRK
         M1f63eAHNJnsgC+M4PSzqApfazG0gApt0+KDADuE1BF+Pxg4PKz3G2VuYnk2cSwbBgrG
         6bwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uLRkJfCEmqyHmwt67N1JORfBg6VVerDIPLLp0n4Mv0U=;
        b=JWrBCO5STvuU3oQLtYBewkLtSv1z0c95gDkSLYdrPjDJ11g9B2SbY8w7rcl5GJFueQ
         QZcZ/gBNAoncajaaYw0v/AOJErmq2ZcczTHqYM468Ea+I6CCKLG0JdekbevaJd3sQnXv
         hYViHT1+G8GHZCHh0CNLtk6EwTYXJaheU+u2TTmp0enodoZ26xgEzIpShvuhkWB5e1rU
         K6dWmiPDIOSAvH3oPrOm/gQSSKJYt0wyPMfZqlTs53b7K+j2i/8SaPfnBSIENqA5MVoW
         MkpfEWRSV8PYfveQSLs8xmJyYkGfMRaK/IYh09C9Jtu2qC2dTChnCc0GcMTeBPN3AwRM
         Dbgg==
X-Gm-Message-State: AOAM530HtlFOYfC/NOd9xT6qNgnazF8wmOBPkhLnGbu5zOvHVv5wwOfa
        hq8+kJyJ9G1HsyVdgvSimZ6cNyjBey6gfHVXGdgpmIdziYR9Wikpu632OOBsGUGjFKyJORWfWIP
        pj2bJ+jtjD6SvVF7/KBEVsqrq7nzyw4HcIlxWw3haKWZUq6ZTg8JzeVpm8A==
X-Google-Smtp-Source: ABdhPJxN9vYt2dk3pmPjMhg9I52ySGOOv1oZG7v2jUbr/ARWQpGX10zXw+GycL4prPFR8PpVJgnut/nd4JU=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a0c:b216:: with SMTP id x22mr13766363qvd.55.1629072743021;
 Sun, 15 Aug 2021 17:12:23 -0700 (PDT)
Date:   Mon, 16 Aug 2021 00:12:12 +0000
In-Reply-To: <20210816001217.3063400-1-oupton@google.com>
Message-Id: <20210816001217.3063400-3-oupton@google.com>
Mime-Version: 1.0
References: <20210816001217.3063400-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 2/7] KVM: arm64: Separate guest/host counter offset values
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
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/arch_timer.c  | 42 +++++++++++++++++++++++++++---------
 include/kvm/arm_arch_timer.h |  3 +++
 2 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index c0101db75ad4..cf2f4a034dbe 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -84,11 +84,9 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
 
 static u64 timer_get_offset(struct arch_timer_context *ctxt)
 {
-	struct kvm_vcpu *vcpu = ctxt->vcpu;
-
 	switch(arch_timer_ctx_index(ctxt)) {
 	case TIMER_VTIMER:
-		return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
+		return ctxt->host_offset;
 	default:
 		return 0;
 	}
@@ -128,17 +126,33 @@ static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
 
 static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
 {
-	struct kvm_vcpu *vcpu = ctxt->vcpu;
-
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
@@ -749,7 +763,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 
 /* Make offset updates for all timer contexts atomic */
 static void update_timer_offset(struct kvm_vcpu *vcpu,
-				enum kvm_arch_timers timer, u64 offset)
+				enum kvm_arch_timers timer, u64 offset,
+				bool guest_visible)
 {
 	int i;
 	struct kvm *kvm = vcpu->kvm;
@@ -758,13 +773,20 @@ static void update_timer_offset(struct kvm_vcpu *vcpu,
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
@@ -772,7 +794,7 @@ static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
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
2.33.0.rc1.237.g0d66db33f3-goog

