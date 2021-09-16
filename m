Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B09840EA61
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344017AbhIPS5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244914AbhIPS51 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 14:57:27 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDABC04A14C
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:26 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id i26-20020a5e851a000000b005bb55343e9bso13645601ioj.7
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XUo/cabJC2z3w3MrWduFKk4WaDY4TAKhMiRwSkCiAgo=;
        b=FiHKbPWfNLd8h3hHTWDz0wf6UJseMtqwYaIb5d2P8FsRf17sd4QzQ8PbtmcvYUfy9a
         WEGMeW3Vr2Mi3wTUySTqL/ey+OH0o5FU14Z+kfNlq4c9H+9n3/qFgWxsbsXIVEWKPWVP
         H59LQ2whbEZLpR8yNuf39IydUL4SEGNl99MJgNpWNQK1PwR8XFFL+Xos2R++8wflwKte
         fEo39WLray0Axn4POpXXYSTR9Vcotb1h+FcXrzfJh29ePPJOSMxcURU99hRjLpQ3zZp8
         zEkU0vYXWKz2RfP28kSSc+5DK5DOMgG8uWoOgjThWgi1V2zzNjxh+8nGPLzXAIxkWnPX
         kTTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XUo/cabJC2z3w3MrWduFKk4WaDY4TAKhMiRwSkCiAgo=;
        b=qkvrAa+nR4H7LwJAonWODvcBWfNmXvKURIeMaxWt8RXuv6U4mzU25DQCTQr8q1gbZR
         eyHB0+pwQ8KF+2n9aIAcdCp/L3hsxsxcbp4CzQVD8KMVaQcHqeuCIyBoHwxz9czCbv7C
         Z6ZbJS9VltNJoxOdl1nT0zdk2+cdNfc/Iq7yYMzTgLTaMAU2NuirKBK+jxeg3V0B7WiS
         q6Ym+Zkc5wGegn/vKA+Xk+EANIMiP9c704mpDKtxApFvToPpmEk9Kl+eWFVHxlK4+Nfd
         e/I9kJUNzBc5eU/2OBthT2vOaQexU/SERk0jFu0ZtfSHFe+6WNTdsVP7HhuvoHfPPynz
         HUoA==
X-Gm-Message-State: AOAM532ZccBBDVcF2rhZSvsSlNa0h9MtVLhy2xcONaH6sIQT9nBOznMD
        tjpz2lKVnga134SY6XnZO970OtvoAzi0tzfc7/nzcENbwY7oiufZlyVSUEEe0/Q+G+Oy5UIUU5p
        Oxua1M0EKtD96n2Z8riz8IDYhFrlIil4RyE5uEuDdEcUMv+opCRSnN9zm4A==
X-Google-Smtp-Source: ABdhPJwtaweXuS39g26oV8m+aB6wVZTQ+xy+L2QMCX4fbgUnZ0pMTxHQ1syrpggpylUpo2byr1NmjTqgKTU=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:2e13:: with SMTP id
 o19mr5529495iow.9.1631816125727; Thu, 16 Sep 2021 11:15:25 -0700 (PDT)
Date:   Thu, 16 Sep 2021 18:15:04 +0000
In-Reply-To: <20210916181510.963449-1-oupton@google.com>
Message-Id: <20210916181510.963449-3-oupton@google.com>
Mime-Version: 1.0
References: <20210916181510.963449-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 2/8] KVM: arm64: Separate guest/host counter offset values
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
2.33.0.309.g3052b89438-goog

