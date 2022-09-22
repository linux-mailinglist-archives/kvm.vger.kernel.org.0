Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B87D5E690F
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 19:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiIVRCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 13:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiIVRCE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 13:02:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C097F8C01
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 10:01:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6AC2B80AF0
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 17:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463CEC433C1;
        Thu, 22 Sep 2022 17:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663866115;
        bh=k79Y4hLlE6C9zOK8ak9v3sdPQfDZmueRgBsCVRUicak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rurnMhTfLjVG27gPLBTEYM2BqHtNZldocEHOIvbzyh0jOnr1rcY7QgbNVqUCgRxIb
         J2Cp97nXtPNMGyA40It4ALqwi4PwZFPQr5vdLATbNQ/K1cFuROqHELn8OVgkXg7Pmx
         0OQf5EksnCDucYGidMzs5blTKLfT4t8PCWFTtcOC4lFonC+GOC10mOU8QqYESt7tS5
         tEr3n8Rd7mgompykfLZ8IoTLKxb9HmdN4FlccjCCPzLcedDskIZim8sKBzleaLrW1x
         VitlUxSLTtOuLy8Pn1hDcvIlKXkRuwa9KlONGSQarx4wNvR5L2pIo7vNbZKRKGt0Kk
         K5LzB0yXPY9/A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1obPaD-00Bxdo-6C;
        Thu, 22 Sep 2022 18:01:53 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc:     catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        peterx@redhat.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com, gshan@redhat.com,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/6] KVM: Use acquire/release semantics when accessing dirty ring GFN state
Date:   Thu, 22 Sep 2022 18:01:28 +0100
Message-Id: <20220922170133.2617189-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922170133.2617189-1-maz@kernel.org>
References: <20220922170133.2617189-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org, andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com, peterx@redhat.com, pbonzini@redhat.com, zhenyzha@redhat.com, shan.gavin@gmail.com, gshan@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current implementation of the dirty ring has an implicit requirement
that stores to the dirty ring from userspace must be:

- be ordered with one another

- visible from another CPU executing a ring reset

While these implicit requirements work well for x86 (and any other
TSO-like architecture), they do not work for more relaxed architectures
such as arm64 where stores to different addresses can be freely
reordered, and loads from these addresses not observing writes from
another CPU unless the required barriers (or acquire/release semantics)
are used.

In order to start fixing this, upgrade the ring reset accesses:

- the kvm_dirty_gfn_harvested() helper now uses acquire semantics
  so it is ordered after all previous writes, including that from
  userspace

- the kvm_dirty_gfn_set_invalid() helper now uses release semantics
  so that the next_slot and next_offset reads don't drift past
  the entry invalidation

This is only a partial fix as the userspace side also need upgrading.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/dirty_ring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index f4c2a6eb1666..784bed80221d 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -79,12 +79,12 @@ static inline void kvm_dirty_gfn_set_invalid(struct kvm_dirty_gfn *gfn)
 
 static inline void kvm_dirty_gfn_set_dirtied(struct kvm_dirty_gfn *gfn)
 {
-	gfn->flags = KVM_DIRTY_GFN_F_DIRTY;
+	smp_store_release(&gfn->flags, KVM_DIRTY_GFN_F_DIRTY);
 }
 
 static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
 {
-	return gfn->flags & KVM_DIRTY_GFN_F_RESET;
+	return smp_load_acquire(&gfn->flags) & KVM_DIRTY_GFN_F_RESET;
 }
 
 int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
-- 
2.34.1

