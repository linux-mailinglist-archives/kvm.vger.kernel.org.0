Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CCD3E0A1C
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 23:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbhHDVq1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 17:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhHDVq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 17:46:26 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6E1C0613D5
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 14:46:13 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id dl20-20020ad44e140000b0290347c39b05c0so877426qvb.3
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 14:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=C4TQOA8B8J/q4Zfe5kHKEB3lmPCutdPC4QZ7gqnArH8=;
        b=YNPOfuewQrcWJCQ/5Iz1uNhVfCb1JkA4TKkX/0eh8jFXMExJPlyT8oXMGZuw00qiCd
         C1/GMBA6RZBqyhevuhfebMNc+N2QsjkyLxFe07Cc+rN13zJCqwy7DrMvbPFF7OQaZO5K
         bhXLFz6y7Of7H+rEatnX55xtleoN0xU/Aud13OEC0HEB35o5FXSwWY+qLM6V8dOi80aB
         yLbZWKMiIA2jqt8de0baS96IM6KRrc0+2tfoXthF8vlgqfgtK5Hnfm5/a54wXuChfA35
         sTHKSjHy5zp4Sr8X9yl8pPez1sljtm+vUKXWatUrSr4GvZk7U/8pozMdAIwomPipG4CQ
         OnqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=C4TQOA8B8J/q4Zfe5kHKEB3lmPCutdPC4QZ7gqnArH8=;
        b=mqlauntmXdhzf1MSdvWQmk6IppxYC4KBw3zahquaGaTVO+fDVwz1erM0+eeHnPjGYA
         p10fNYX0rBle+UWeqNEfOb6tJVVSiBFqUJ+EzRXuYrp/Lx04L9+rZHiqvxisTTTj5OCO
         ZvOnnQ6b/+0mk0Pk/MjN8v4CJUhD/EvFflBFCrIS8KlEC4dwH1/MV4RTdfUrgrh8My04
         CJ5sX1kruoaWqksc7kZe0AcP/6sKFneYHxGkR4BpzGMve7J2EZkZOQbGiUIeQzXE5smC
         QkbglA2Q2l7gOqOKHU5xGMloY39NxXhyZCSH6I2hDKRp3MC1O6FyhuJJFkae6YKH1yel
         z8eA==
X-Gm-Message-State: AOAM530jcDnLVX+qZuXUa1v5jQPNGlQyquh+8kC6Ulq5MnnQ8Qwod6MI
        r1jY67WY9uIA6XSCEO76vpVOlVPaLh0=
X-Google-Smtp-Source: ABdhPJzre0zuQgcoCCv3rfHIjO6dR7eyTRXfK2AxxKiu1wox9S+sbtAdIzb3L38QimrvyQF7xC/AQRzu05o=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e041:28e5:75db:9055])
 (user=seanjc job=sendgmr) by 2002:a0c:a321:: with SMTP id u30mr1545572qvu.57.1628113573026;
 Wed, 04 Aug 2021 14:46:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 Aug 2021 14:46:09 -0700
Message-Id: <20210804214609.1096003-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH] KVM: x86/mmu: Fix per-cpu counter corruption on 32-bit builds
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Take a signed 'long' instead of an 'unsigned long' for the number of
pages to add/subtract to the total number of pages used by the MMU.  This
fixes a zero-extension bug on 32-bit kernels that effectively corrupts
the per-cpu counter used by the shrinker.

Per-cpu counters take a signed 64-bit value on both 32-bit and 64-bit
kernels, whereas kvm_mod_used_mmu_pages() takes an unsigned long and thus
an unsigned 32-bit value on 32-bit kernels.  As a result, the value used
to adjust the per-cpu counter is zero-extended (unsigned -> signed), not
sign-extended (signed -> signed), and so KVM's intended -1 gets morphed to
4294967295 and effectively corrupts the counter.

This was found by a staggering amount of sheer dumb luck when running
kvm-unit-tests on a 32-bit KVM build.  The shrinker just happened to kick
in while running tests and do_shrink_slab() logged an error about trying
to free a negative number of objects.  The truly lucky part is that the
kernel just happened to be a slightly stale build, as the shrinker no
longer yells about negative objects as of commit 18bb473e5031 ("mm:
vmscan: shrink deferred objects proportional to priority").

 vmscan: shrink_slab: mmu_shrink_scan+0x0/0x210 [kvm] negative objects to delete nr=-858993460

Fixes: bc8a3d8925a8 ("kvm: mmu: Fix overflow on kvm mmu page limit calculation")
Cc: stable@vger.kernel.org
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b4b65c21b2ca..082a0ba79edd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1700,7 +1700,7 @@ static int is_empty_shadow_page(u64 *spt)
  * aggregate version in order to make the slab shrinker
  * faster
  */
-static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, unsigned long nr)
+static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
 {
 	kvm->arch.n_used_mmu_pages += nr;
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
-- 
2.32.0.554.ge1b32706d8-goog

