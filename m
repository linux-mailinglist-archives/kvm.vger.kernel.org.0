Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C235E690D
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 19:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbiIVRCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 13:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiIVRCE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 13:02:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E241F85BD
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 10:01:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 019EB636C9
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 17:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DBFC43143;
        Thu, 22 Sep 2022 17:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663866116;
        bh=pC2zxGScPJel5jBl7cmWJaYW0XKiTgMLlXCj7lrGY/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jvcHSo09VGBIrzBbBM8is+vE5mxReBabuYHEIAIkqymDExD6WK/tfO7CtdLCXysxq
         K7LUisvZUSQxPb254/YdXY5ijxDXUdtlVWkB1TayVUqsiztcAME0Ci8Mz4qxvPKQYH
         cp/V2RzuXTIu7oLTiMtuE4rX8YqB3rf9/v3EmP01iRwHzrthBBi5fYm6+i9EyMx8BS
         yBAcyB93ZUvp6V44PbRaMoBODLuds/tO91c3zBh2GFqQSwxhWkvmbxGER0VxEfYqtt
         ROKVFeWjl3RNodYoPSRUn9ozNzseQaWMbJrwILS2Lc0LcysMFHGd5iaCINIksJfh+w
         4jt1IiaG+eK0A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1obPaE-00Bxdo-Bs;
        Thu, 22 Sep 2022 18:01:54 +0100
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
Subject: [PATCH 5/6] KVM: selftests: dirty-log: Upgrade dirty_gfn_set_collected() to store-release
Date:   Thu, 22 Sep 2022 18:01:32 +0100
Message-Id: <20220922170133.2617189-6-maz@kernel.org>
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

To make sure that all the writes to the log marking the entries
as being in need of reset are observed in order, use a
smp_store_release() when updating the log entry flags.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 9c883c94d478..3d29f4bf4f9c 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -17,6 +17,7 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/atomic.h>
+#include <asm/barrier.h>
 
 #include "kvm_util.h"
 #include "test_util.h"
@@ -284,7 +285,7 @@ static inline bool dirty_gfn_is_dirtied(struct kvm_dirty_gfn *gfn)
 
 static inline void dirty_gfn_set_collected(struct kvm_dirty_gfn *gfn)
 {
-	gfn->flags = KVM_DIRTY_GFN_F_RESET;
+	smp_store_release(&gfn->flags, KVM_DIRTY_GFN_F_RESET);
 }
 
 static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
-- 
2.34.1

