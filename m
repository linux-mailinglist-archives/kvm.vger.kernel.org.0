Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EB83ECBEF
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 02:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbhHPAMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 20:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbhHPAMx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 20:12:53 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D381CC0613C1
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:12:22 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b9-20020a5b07890000b0290558245b7eabso15078669ybq.10
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=onAqEh8W0SBicAWR55u2ngfwbUkFlrlMLEeDkUeYr84=;
        b=qhpICAaFLhU3+IHGm11sW/Isc3WfyB2RHrfJtKUbGw63J9vM6gdE81PvZpG2zwzw8O
         xvVYLTVWjzq99ack7VgFOvIFPZ9F8t1LoJ+Bka5jr0/d1fVgY11AhngDstTL1cvP8CGl
         uzx6mHO3mvAm1M8LD8tT2AZJBhRb1SK4+nTn70NI8oIPj2hNdSXzcfTaW9wyiq8hjMmt
         SeTDHthVV5479sAgDnHPGWxL3jKaNRJ7PjRH2ZZ+VZci3oTPKyXAAOqKsDZ0WtPr0VeB
         9t45HJPdPMTdj85xkXn2iZcBVWBjs8VxIxPa4CqJJyRRVVNRxf2OeHlXRUStSFQlttQb
         94Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=onAqEh8W0SBicAWR55u2ngfwbUkFlrlMLEeDkUeYr84=;
        b=Mdyfn7NB7lseON1UCiSnoUKKOfhlrg9xH62oeKzKmX1NMkRcMvcVSi3MGwSkfEgGPN
         il+wUq7qVy6ZlMt204BqcQbzJRzBA4A9P5N20Vp5UpD7+r0YSWE4Zuc+ks3eO0CMII5c
         hLyz4AqmaEAkU9M6OeRMabNNIqs/hgW/qLZ1R5X48i4Zs+Ja9MVVd3i0H0KofRT9uBnF
         ZjbLmB5mr3UD0Oqc2OiSbFXAhgnau2WkX3u+/RDmoFv88x9V3xiwkOIPXwIHUNQ0k0Qa
         qbOBK401CcCF+AEaxPXKQGDqvOZ5Ic1seLOAkVHHkDfHb4kniypHiSbJngIfPkyIdXtI
         71+A==
X-Gm-Message-State: AOAM531P2ALaex59JI+fVUa+ECpCYNuheHzGQb6n8a1csFsjmL4NnthC
        lfnai/oXWpkneA4a3BpCETZDSdCZXS4jHNn1cpze3t2fjnB2hJvUepLgeQLABmvzET2NSMWg18X
        22Nigw74t1lFR5nfopc9m5AK+j+si0aUpVtwBXpt60hZ79JXvxPmb/68ZIA==
X-Google-Smtp-Source: ABdhPJy6FWA8u3sJLeHS6AWC8Xv9Z0rmwcuGesbQJOl0Ryv15/E1haP7bvTFN3gsAs53WozMzCacm0BdTVs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:8c4:: with SMTP id 187mr17077125ybi.369.1629072741950;
 Sun, 15 Aug 2021 17:12:21 -0700 (PDT)
Date:   Mon, 16 Aug 2021 00:12:11 +0000
In-Reply-To: <20210816001217.3063400-1-oupton@google.com>
Message-Id: <20210816001217.3063400-2-oupton@google.com>
Mime-Version: 1.0
References: <20210816001217.3063400-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 1/7] KVM: arm64: Refactor update_vtimer_cntvoff()
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
2.33.0.rc1.237.g0d66db33f3-goog

