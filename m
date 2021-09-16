Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2B840EA60
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343986AbhIPS5f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245412AbhIPS51 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 14:57:27 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518F1C04A14B
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:25 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id e2-20020a056602044200b005c23c701e26so13716465iov.21
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3RpJBwIvRP9pmK/0Ce4ZApsRskzFPqH6cQQcNE1phYg=;
        b=brVRcKUDjW8YWhMj164gJJN+u3N/rXel6jjJ5VBvfnF+snrEiDXqSxLCK7g/dXcKSU
         isij6yZK2ghEM3fGjLNp1Ax3lKItUBY2kW727t071Acxg6Tw3DZg+ybJp04yYhlXnsSu
         BiFb3KJctoL6l237QYRTTW0GFqEiyB1tmfJArBth9Dyf3ZbYQ0SQqphiN2fPOXnE4CB8
         2pXo84ot9H0u/o+BQrhifCAEI3qgCMICMYWl2nnTuRP01Eyh+VxxzVmtOFVge4JpiAIN
         Wf3KFTvJNuKnb0c3szNCcD7tvxyTTibMBC+y2eMjNA4cKjSI7h0hQN+luMXWtK+2BLQf
         fNQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3RpJBwIvRP9pmK/0Ce4ZApsRskzFPqH6cQQcNE1phYg=;
        b=Ye4RqI+7JgZOn4n9PqLc4LoOm3xboeLKwPFajPKplLIn6affu0odXtYZR17w8gGvAm
         st6tIOt0DEchXHHspaVCCA/St5JCFFKEoJSdmqGUbq0XObsajIvf0nY7HQcq1rQ21sse
         iFje93igE5rXndKnmilyE1Jn6iZpjtPILk7bJBSjA5j04bWe6QDnM5RFAhowS3x/G5pl
         0t0sg6En5o477iOpmmPU0u/9VhPj2GZ39lfJlZOMT05qN1Vw9tlK0COz8SmwZp833SEp
         UKIrsYJV+IZMF1uyDmqZWiW3fVzf+3Kc4Lj0tJ/brVDeGlik/UC84Zz5w90+LYqE8XZC
         6qLA==
X-Gm-Message-State: AOAM530jVKX1+nVqL6SIViTcJvTE8xX9Jb7e41kINZ24Sg89CN5HwXN3
        qgTCzY2bmNe0HBqokrzU8SwzCP6sn2AxxceW4eg6JsqX7wDIAv91vJmwBcO+WIB8pNaJWYKG2Sw
        7eV8k3AhiIuOcyjrTA1lYuiijHV8eCq7sgjmhSYgDugDollyQmLRZju/gjg==
X-Google-Smtp-Source: ABdhPJx6QoYMzNxz6Jr/FocYXQ2V8gW6BZoL4oAcigjXW7DAc1ZNeN6gOx2OC7wUVtKB/0HOuOb+sGiXNOA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:16d4:: with SMTP id
 g20mr5478616jat.22.1631816124631; Thu, 16 Sep 2021 11:15:24 -0700 (PDT)
Date:   Thu, 16 Sep 2021 18:15:03 +0000
In-Reply-To: <20210916181510.963449-1-oupton@google.com>
Message-Id: <20210916181510.963449-2-oupton@google.com>
Mime-Version: 1.0
References: <20210916181510.963449-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 1/8] KVM: arm64: Refactor update_vtimer_cntvoff()
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

Make the implementation of update_vtimer_cntvoff() generic w.r.t. guest
timer context and spin off into a new helper method for later use.
Require callers of this new helper method to grab the kvm lock
beforehand.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/arch_timer.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 3df67c127489..c0101db75ad4 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -747,22 +747,32 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-/* Make the updates of cntvoff for all vtimer contexts atomic */
-static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
+/* Make offset updates for all timer contexts atomic */
+static void update_timer_offset(struct kvm_vcpu *vcpu,
+				enum kvm_arch_timers timer, u64 offset)
 {
 	int i;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_vcpu *tmp;
 
-	mutex_lock(&kvm->lock);
+	lockdep_assert_held(&kvm->lock);
+
 	kvm_for_each_vcpu(i, tmp, kvm)
-		timer_set_offset(vcpu_vtimer(tmp), cntvoff);
+		timer_set_offset(vcpu_get_timer(tmp, timer), offset);
 
 	/*
 	 * When called from the vcpu create path, the CPU being created is not
 	 * included in the loop above, so we just set it here as well.
 	 */
-	timer_set_offset(vcpu_vtimer(vcpu), cntvoff);
+	timer_set_offset(vcpu_get_timer(vcpu, timer), offset);
+}
+
+static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	mutex_lock(&kvm->lock);
+	update_timer_offset(vcpu, TIMER_VTIMER, cntvoff);
 	mutex_unlock(&kvm->lock);
 }
 
-- 
2.33.0.309.g3052b89438-goog

