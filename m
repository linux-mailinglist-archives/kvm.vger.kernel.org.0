Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD6D5EABF2
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 18:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235705AbiIZQDn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 12:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233205AbiIZQCl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 12:02:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D350E0F
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 07:51:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D96EAB80AC9
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 14:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9DEC43148;
        Mon, 26 Sep 2022 14:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664203886;
        bh=WV5cxf5ghEnKU2Qr6KhozOGjAzkOIr41eedwlY0TKqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eIQck6//OBW+W1dywe0DknHum0rdmkdVAw4UgRVkCmCDEIdmX45GE0xpJyCygUGTP
         WlK7j873Xpn4lCec1VPZDjlQnu6piSbyDiXcY2CfFFGCGNeRIDzy10/4Hf3/3uMjSS
         IJYbT1xOcIMTv539YJ4ReXurJiV2TBeyZktZw8KsUjo54yc0/yzKAHAvAnFsQcvFdn
         VuBf1GPs91dXUCofN4W8M2DTD9yleuYT2uEb6Thd0mji7F+hAhmJLAYpaud2qDHu/5
         mAjV2SPztiS6ouhp/avwTmKB9kKTN3VPLDb9e0iurCs2M1/pI3Fve6joLNmqiwNqJM
         oAXkzq5lVixfQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ocpS8-00Cips-FQ;
        Mon, 26 Sep 2022 15:51:24 +0100
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
Subject: [PATCH v2 5/6] KVM: selftests: dirty-log: Upgrade flag accesses to acquire/release semantics
Date:   Mon, 26 Sep 2022 15:51:19 +0100
Message-Id: <20220926145120.27974-6-maz@kernel.org>
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

In order to preserve ordering, make sure that the flag accesses
in the dirty log are done using acquire/release accessors.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 9c883c94d478..53627add8a7c 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -17,6 +17,7 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/atomic.h>
+#include <asm/barrier.h>
 
 #include "kvm_util.h"
 #include "test_util.h"
@@ -279,12 +280,12 @@ static void dirty_ring_create_vm_done(struct kvm_vm *vm)
 
 static inline bool dirty_gfn_is_dirtied(struct kvm_dirty_gfn *gfn)
 {
-	return gfn->flags == KVM_DIRTY_GFN_F_DIRTY;
+	return smp_load_acquire(&gfn->flags) == KVM_DIRTY_GFN_F_DIRTY;
 }
 
 static inline void dirty_gfn_set_collected(struct kvm_dirty_gfn *gfn)
 {
-	gfn->flags = KVM_DIRTY_GFN_F_RESET;
+	smp_store_release(&gfn->flags, KVM_DIRTY_GFN_F_RESET);
 }
 
 static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
-- 
2.34.1

