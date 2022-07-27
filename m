Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21635828A3
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 16:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbiG0O3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 10:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233835AbiG0O3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 10:29:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4514C2DAB5
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 07:29:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02A53B82193
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 14:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD161C433D6;
        Wed, 27 Jul 2022 14:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658932166;
        bh=ucMNCrws7KhQhf8hTanOu2XwNAuEOvJybE4pmo7FkqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KRVFoWgDA5r5UCORtgyYITfLOPFZaMQZF3Xk/9OoSjY3wnabf/HfXXf9/cblgFm6N
         UCN2PdTn8lG5AQy17JTLY2Dzv85HgvA0QwCBROHwHfeyZcxyzP7S0BbO17Cce/LBtj
         UOIlDBgUsE0F6EPY2xbjz0z5llKTLnsSRwUUiueSXP8MPoCJld3xgg72KQISAMxEMm
         cejTM4GmLc88Tl5Ib/CsBXfUXp8OzPbSB5co/GO7Zs+rlFRpNa6H+XETAjUVlGG0MW
         8RgNVmnK8xzY1NBcLGeS6W3uFN5APSr2rWzPvok0HbR4nnV5uzJEyt4IE0KZcKw+7A
         sDY3toA8vABrw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oGi2O-00APjL-Uc;
        Wed, 27 Jul 2022 15:29:24 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     mark.rutland@arm.com, broonie@kernel.org,
        madvenka@linux.microsoft.com, tabba@google.com,
        oliver.upton@linux.dev, qperret@google.com, kaleshsingh@google.com,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, catalin.marinas@arm.com,
        andreyknvl@gmail.com, vincenzo.frascino@arm.com,
        mhiramat@kernel.org, ast@kernel.org, wangkefeng.wang@huawei.com,
        elver@google.com, keirf@google.com, yuzenghui@huawei.com,
        ardb@kernel.org, oupton@google.com, kernel-team@android.com
Subject: [PATCH 6/6] arm64: Update 'unwinder howto'
Date:   Wed, 27 Jul 2022 15:29:06 +0100
Message-Id: <20220727142906.1856759-7-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220727142906.1856759-1-maz@kernel.org>
References: <20220726073750.3219117-18-kaleshsingh@google.com>
 <20220727142906.1856759-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, mark.rutland@arm.com, broonie@kernel.org, madvenka@linux.microsoft.com, tabba@google.com, oliver.upton@linux.dev, qperret@google.com, kaleshsingh@google.com, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, andreyknvl@gmail.com, vincenzo.frascino@arm.com, mhiramat@kernel.org, ast@kernel.org, wangkefeng.wang@huawei.com, elver@google.com, keirf@google.com, yuzenghui@huawei.com, ardb@kernel.org, oupton@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implementing a new unwinder is a bit more involved than writing
a couple of helpers, so let's not lure the reader into a false
sense of comfort. Instead, let's point out what they should
call into, and what sort of parameter they need to provide.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/stacktrace/common.h | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
index 18046a7248a2..f58eb944c46f 100644
--- a/arch/arm64/include/asm/stacktrace/common.h
+++ b/arch/arm64/include/asm/stacktrace/common.h
@@ -5,17 +5,11 @@
  * To implement a new arm64 stack unwinder:
  *     1) Include this header
  *
- *     2) Provide implementations for the following functions:
- *          on_overflow_stack():   Returns true if SP is on the overflow
- *                                 stack.
- *          on_accessible_stack(): Returns true is SP is on any accessible
- *                                 stack.
- *          unwind_next():         Performs validation checks on the frame
- *                                 pointer, and transitions unwind_state
- *                                 to the next frame.
+ *     2) Call into unwind_next_common() from your top level unwind
+ *        function, passing it the validation and translation callbacks
+ *        (though the later can be NULL if no translation is required).
  *
- *         See: arch/arm64/include/asm/stacktrace.h for reference
- *              implementations.
+ * See: arch/arm64/kernel/stacktrace.c for the reference implementation.
  *
  * Copyright (C) 2012 ARM Ltd.
  */
-- 
2.34.1

