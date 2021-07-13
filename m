Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3A13C74B4
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbhGMQg7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234335AbhGMQgs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:36:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07344C06139F
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:33:57 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x84-20020a2531570000b029055d47682463so26320959ybx.5
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=xu9lt7ml4nTWe9cpEWKdb0fo86g2MaNZbmfwbHMDB9k=;
        b=fvcTCZaP7A7KM7+eVBkJ3b6bqoSUEtZ9Q4kaNDtWYRCWlGiQW1TfaVXqXxNra1YNAk
         3m1x2PMNDOodqjQEvqFbGqj6rmIJe5ICcVTgxeDlgTorX+fCJvENw3/5Lh2uOQAkO/6i
         DxK2XwqqlRjL1sx+zC2vlVjq4RYlbIHTXCgE4Wdafy4UgSRpCofV86xw0AZH1IPVGMzf
         Hz3EewbfVTtRvY+H0ae9dtfNm0bpZgtAmCvwdrbG4a+OyRh5PG5qBNdw6fmvBQv1kVkT
         ESWi9enkzktooOyXyBqI7YYaM3n022F4bsMGGfF02JlavaWBk9/qjpUbUnss58H1NBXS
         M1Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=xu9lt7ml4nTWe9cpEWKdb0fo86g2MaNZbmfwbHMDB9k=;
        b=DJNbx7o2eRTpybREwvqq+ElQkVfrW8UmkIw5NpHZZ2DMGQy7+GiAtH0DYWIu5bj+dU
         A6QcfI95tUBwkL/xut7zz2ypRTIMIHHQFuKg5rEmmbdlQ5P/FMob05su/exvP2raYDJL
         uuQWzBSnz1QJ55t90v7hSKaArEY+a3YcJ2VA2dXPvmkYYpeoNqNQKmHUq48Yv6F2TNEo
         OCrZuyyF6GqaS0JxmQ9PSUZKlgGdQ8sBGnufR6rkITH7lrcpnQIMzxMINcSyzeeRFN7c
         MYVp1aquhQZ8poy/6ZLwAxZUOZsdXO9QxHWS4wCUg995d0OO6pcB3S+vxt3dbvAB3das
         Da3A==
X-Gm-Message-State: AOAM531f+6a0B7qz0S0ZlslJXySK7k5t5uLLNZHemNW5kAfhLxBvO3oH
        sGees0wJqs1V+GUnqdIsWw9KH7AzuSs=
X-Google-Smtp-Source: ABdhPJyUk7ZBK00HqxMu16yC3TPRFg54XBhrFFpZfREhXqq8Th4XViilePl3UFmAj6aEj+O6jCUueIaSxSo=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a25:bcd2:: with SMTP id l18mr6659895ybm.66.1626194037119;
 Tue, 13 Jul 2021 09:33:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:32:50 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-13-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 12/46] KVM: x86: Remove defunct BSP "update" in local APIC reset
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove a BSP APIC update in kvm_lapic_reset() that is a glorified and
confusing nop.  When the code was originally added, kvm_vcpu_is_bsp()
queried kvm->arch.bsp_vcpu, i.e. the intent was to set the BSP bit in the
BSP vCPU's APIC.  But, stuffing the BSP bit at INIT was wrong since the
guest can change its BSP(s); this was fixed by commit 58d269d8cccc ("KVM:
x86: BSP in MSR_IA32_APICBASE is writable").

In other words, kvm_vcpu_is_bsp() is now purely a reflection of
vcpu->arch.apic_base.MSR_IA32_APICBASE_BSP, thus the update will always
set the current value and kvm_lapic_set_base() is effectively a nop if
the new and old values match.  The RESET case, which does need to stuff
the BSP for the reset vCPU, is handled by vendor code (though this will
soon be moved to common code).

No functional change intended.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index add4dd1e3528..a24ce8fe93e5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2367,9 +2367,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	apic->highest_isr_cache = -1;
 	update_divide_count(apic);
 	atomic_set(&apic->lapic_timer.pending, 0);
-	if (kvm_vcpu_is_bsp(vcpu))
-		kvm_lapic_set_base(vcpu,
-				vcpu->arch.apic_base | MSR_IA32_APICBASE_BSP);
+
 	vcpu->arch.pv_eoi.msr_val = 0;
 	apic_update_ppr(apic);
 	if (vcpu->arch.apicv_active) {
-- 
2.32.0.93.g670b81a890-goog

