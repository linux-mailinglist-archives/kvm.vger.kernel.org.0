Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27BB3DFD6E
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 10:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236842AbhHDI7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 04:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236858AbhHDI67 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 04:58:59 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1F9C06179B
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 01:58:47 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n192-20020a25dac90000b029054c59edf217so2276143ybf.3
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 01:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=35TVCGaSXP1YX+xl0ynmypPjFUwRXJIFcUTUP7y3OEA=;
        b=uZnF95SUd8tPNPh9UDFmW/BkibQwuIqjWxF/hBpRgMBadermRtPRVOXDB9dmgoECSE
         FKyGfmtyrLDrsggccC+Bh3D5G2gELbtHa3uN0XfY5JKG0ECY2NshKN8FbWDsmNi36LEb
         ctSbdLL+8gkNDC+TlCJ0gt0RNoAPIKSkADIlXB6qQ9GqhxXiuP9bYTOxBYCK/0CJbLyX
         OMo5Qd7rEVm7l+Vl0r9z9VADsMHVwgRinpxvMjgoANM3sIcdXewmA5o0ijE8KaMaarny
         i6gAvU3WwVGrOeGLvkW/NqGz11SdqskIEqbf4Vm2r99E0OmmNmyy0TLewqXP11d4sUzL
         O8HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=35TVCGaSXP1YX+xl0ynmypPjFUwRXJIFcUTUP7y3OEA=;
        b=kb34r4tD2heO0dCyyesEt6tuiP+yHQyY/1tUhqZpukVCxXkrNk5RTWe26UH6TVghVF
         pwC5dczB4ClDsQYU5aEfhm9na76zhWeTmGIV7w4QBsbsS+j9HIaUUdJsLyJYnc8lK0Sa
         dHIwcrjgpETmqEoXnrPChE2R/UI2kR+co8BAvgd5WjF0KR8uy+p8PXndt6HTj8qniUNj
         QMlARF3KKKHytQ2QRJxvFMjtegFemle4ad/j9jL54niujk/zpdD9522VPcHdIslHSlx1
         QgMMaPfb25qlg1AfuF5je4w6PFKcEtgo+/z7w4rGAoasq977mt2s7IqoaamMCxcDvwLr
         ZneA==
X-Gm-Message-State: AOAM532T+NNFqn4F0za9X4F7CEW3TnxNP+SChTUgE+VMQy9fE34GwmmQ
        Cu2BEXKKhDo9E/QxPT0jezOAYIO6KwNn66k0WKebn66siRaQ4EyYk3r4/TqPGbCKPGWK4gAHrs8
        eCQjMO3awXECZlractoT4b4bESgqpirrGTck5Sq+x9AWm2PN21UGV68UgXw==
X-Google-Smtp-Source: ABdhPJwQw2VG+2wPW9YYVkLKNHJyZLMCee16q7ggjAFKp03Ugn+6tAxy0sKWEOCLAMhlJGHciviyBhrNI/s=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:8010:: with SMTP id m16mr34219421ybk.210.1628067526796;
 Wed, 04 Aug 2021 01:58:46 -0700 (PDT)
Date:   Wed,  4 Aug 2021 08:58:09 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-12-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 11/21] KVM: arm64: Refactor update_vtimer_cntvoff()
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
2.32.0.605.g8dce9f2422-goog

