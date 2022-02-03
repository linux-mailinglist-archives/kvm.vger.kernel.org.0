Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C868F4A7D24
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348666AbiBCBBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348674AbiBCBBW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:01:22 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373C2C061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:01:22 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id e37-20020a635465000000b00364dfbc8031so566973pgm.10
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tJTEmnOoq97nBjhDDGiFw1d5hYrxIBizGAgKf7X10Mo=;
        b=re95RWG+4sNe5gVyOOB+XqKh1H15R81aKdDAqzZHeiGXnQi0iojvNvioxU4HcZ2o9f
         dNsgkq8onbjGC6MfRMbjY11ZMN0WUv3PxIPrAdR//FnM7lUWVVVfQ/jSHMZGz4b16P1k
         99GtKR5gVwF8NZ2vi7FF6Ks7KHaloIwKqXkQRyrVeZUIvldRMz3bFz6gSt60VUxjLB6Q
         XdMbDP60AkPu1i2/Gr7f3Jiw/y2ngxyA0NNUD1BiB7p2TRKUW2635exrnUfWPjM0T2of
         PVcCi6IKqWFeQqHO/7iuu0NbjnWTry5icy/Uak/mC5m1AAqy0vtBoDxtrhGaTg5L/uMA
         B0lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tJTEmnOoq97nBjhDDGiFw1d5hYrxIBizGAgKf7X10Mo=;
        b=FOZyNgoqWJoU+XZt/EDvquqGkwiSRo/umAgVfWZfmZPMCUT5mxzhqIrAPifVBLku/7
         R6729MishnzO6u4iEFWOqM23Kvnf/p04mr957g94J1cfLjqqUYTxpQ/WrgvhT6Y1u6tf
         0ernLow4jLPSl7TE1e0LzhlmTaHhr/6W2XxQhXXNVTgylLv8TD2p5fTN2pOWFv+x8DBr
         lDFYIwBWHN0BSx0M3+ZqVnoYRtZAATnL5E//QtcCWQ6sO8r1sHCJZqcDNF4gDnBnYymq
         0QSSzAnkG/OhRbvese/YgosXViWYKThOLZtm3GutUle2xm37yvQ5UjkRe+aoQrJowLWx
         9uuA==
X-Gm-Message-State: AOAM530ALDT4+JT4h96wsX3qLo+Rr8YGpscGNiJ5Scil3eZDrY9xIL7j
        Ddax7fKyTPIMX4mjd43yRmJO0JbUvLn0Zg==
X-Google-Smtp-Source: ABdhPJyK7fj6w+08G3wCOZt4TDefrrmA+Hz2RetwxPXkR7BGmpnFbrKknQ7euNCPtLY2AFH0j+/6MeCpyD8rNg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:ecc1:: with SMTP id
 a1mr32545543plh.72.1643850081718; Wed, 02 Feb 2022 17:01:21 -0800 (PST)
Date:   Thu,  3 Feb 2022 01:00:41 +0000
In-Reply-To: <20220203010051.2813563-1-dmatlack@google.com>
Message-Id: <20220203010051.2813563-14-dmatlack@google.com>
Mime-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 13/23] KVM: x86/mmu: Update page stats in __rmap_add()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>, maciej.szmigiero@oracle.com,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the page stats in __rmap_add() rather than at the call site. This
will avoid having to manually update page stats when splitting huge
pages in a subsequent commit.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c2f7f026d414..ae1564e67e49 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1621,6 +1621,8 @@ static void __rmap_add(struct kvm *kvm,
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 	rmap_count = pte_list_add(cache, spte, rmap_head);
 
+	kvm_update_page_stats(kvm, sp->role.level, 1);
+
 	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
 		kvm_unmap_rmapp(kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
 		kvm_flush_remote_tlbs_with_address(
@@ -2831,7 +2833,6 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 
 	if (!was_rmapped) {
 		WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
-		kvm_update_page_stats(vcpu->kvm, level, 1);
 		rmap_add(vcpu, slot, sptep, gfn);
 	}
 
-- 
2.35.0.rc2.247.g8bbb082509-goog

