Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57955EABF3
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 18:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbiIZQDg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 12:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiIZQCk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 12:02:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D75C72847
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 07:51:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6A06B80AC8
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 14:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E516C43470;
        Mon, 26 Sep 2022 14:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664203885;
        bh=EVi74rZsj2dxHCFe99XuaMnXMvVeBo4LqBXbi4Nk9RA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5gO1V23DOdHquXim5s9cdYDYLKTIPgWVNAyoWwmxjnfXtKMFliJH7hOGXjZgaRJi
         ogBlLLMKo7XWkklLoExr+Bz8Jmx63KYt3MorgYlFPPBVx1Ry5O0l+vgjqwNmkwZixF
         ZipMiW3Rvk3mt0btBbBY8xVmPUdndHOM7ktY7B7DboannckxQ+B3Hs1ucWTyF+i65g
         1av4n4kMrX+NowObAkNx1uv5+YSijZxS4azYYIy/XZjEzRo4Qa03Vy0KUrkbhmVejh
         ZE9l8xIakDyV93HDHsNCkAoYF9wTqBwByMce1ogmVRdc4RNK15uc9HF9vdLERHNTnt
         qZD+qt31qJlvA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ocpS7-00Cips-Aw;
        Mon, 26 Sep 2022 15:51:23 +0100
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
Subject: [PATCH v2 1/6] KVM: Use acquire/release semantics when accessing dirty ring GFN state
Date:   Mon, 26 Sep 2022 15:51:15 +0100
Message-Id: <20220926145120.27974-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220926145120.27974-1-maz@kernel.org>
References: <20220926145120.27974-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org, andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com, peterx@redhat.com, pbonzini@redhat.com, zhenyzha@redhat.com, shan.gavin@gmail.com, gshan@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index f4c2a6eb1666..d6fabf238032 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -74,7 +74,7 @@ int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size)
 
 static inline void kvm_dirty_gfn_set_invalid(struct kvm_dirty_gfn *gfn)
 {
-	gfn->flags = 0;
+	smp_store_release(&gfn->flags, 0);
 }
 
 static inline void kvm_dirty_gfn_set_dirtied(struct kvm_dirty_gfn *gfn)
@@ -84,7 +84,7 @@ static inline void kvm_dirty_gfn_set_dirtied(struct kvm_dirty_gfn *gfn)
 
 static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
 {
-	return gfn->flags & KVM_DIRTY_GFN_F_RESET;
+	return smp_load_acquire(&gfn->flags) & KVM_DIRTY_GFN_F_RESET;
 }
 
 int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
-- 
2.34.1

