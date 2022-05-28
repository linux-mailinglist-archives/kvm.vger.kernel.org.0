Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6BC536CAE
	for <lists+kvm@lfdr.de>; Sat, 28 May 2022 13:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355129AbiE1LuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 May 2022 07:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355042AbiE1LuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 May 2022 07:50:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D4F10544
        for <kvm@vger.kernel.org>; Sat, 28 May 2022 04:50:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7035FB81705
        for <kvm@vger.kernel.org>; Sat, 28 May 2022 11:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2088AC34118;
        Sat, 28 May 2022 11:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653738604;
        bh=KMwi+oCF55/vO8plIgUNFSEzhuYgMbACCUE98soIwB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T3hI8rfuQBsgLszaqhqU15iR8sD+Z2zDQM27dvaj32XX2yhaZztqlT4xRjLMiJ8Qa
         3/6YpzAeXwhtl2a7vx6Q/effM1FskrKMbYFpP1CCmjTbHWY8oQ1yKl8+WhYBFhcq8L
         +MJWCI7UweKTJ4bQ+IX3quF1bNxiP43mfy+SsgZpEiZvHnEmW4yJL625/VtTBwVJc3
         9aU/UfBkibE18T1Z0v/DjcM8Hb9j+wJLqw+gfD/voc4fZmIIeU9pcPRKLeYd9VwVkd
         B4fEX2XBEiSqwQ/PsgUwmSXy7O/+8rAn33kK6J/s10cmr6ZRH3hmtqEaC5Uqw2ZhyN
         BpIMfC7v0kTsQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nuumD-00EEGh-Tr; Sat, 28 May 2022 12:38:37 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Mark Brown <broonie@kernel.org>, kernel-team@android.com
Subject: [PATCH 18/18] KVM: arm64: Document why pause cannot be turned into a flag
Date:   Sat, 28 May 2022 12:38:28 +0100
Message-Id: <20220528113829.1043361-19-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220528113829.1043361-1-maz@kernel.org>
References: <20220528113829.1043361-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com, will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It would be tempting to turn the 'pause' state into a flag.

However, this cannot easily be done as it is updated out of context,
while all the flags expect to only be updated from the vcpu thread.
Turning it into a flag would require to make all flag updates
atomic, which isn't necessary desireable.

Document this, and take this opportunity to move the field next
to the flag sets, filling a hole in the vcpu structure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 83f3dae4333a..8c47b7f8ef92 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -344,6 +344,15 @@ struct kvm_vcpu_arch {
 	/* State flags, unused by the hypervisor code */
 	u8 sflags;
 
+	/*
+	 * Don't run the guest (internal implementation need).
+	 *
+	 * Contrary to the flags above, this is set/cleared outside of
+	 * a vcpu context, and thus cannot be mixed with the flags
+	 * themselves (or the flag accesses need to be made atomic).
+	 */
+	bool pause;
+
 	/*
 	 * We maintain more than a single set of debug registers to support
 	 * debugging the guest from the host and to maintain separate host and
@@ -397,9 +406,6 @@ struct kvm_vcpu_arch {
 	/* vcpu power state */
 	struct kvm_mp_state mp_state;
 
-	/* Don't run the guest (internal implementation need) */
-	bool pause;
-
 	/* Cache some mmu pages needed inside spinlock regions */
 	struct kvm_mmu_memory_cache mmu_page_cache;
 
-- 
2.34.1

