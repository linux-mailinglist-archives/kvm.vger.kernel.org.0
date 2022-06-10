Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F28654628F
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 11:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245750AbiFJJfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 05:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348347AbiFJJfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 05:35:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5CE215
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 02:35:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83C1361E8F
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 09:35:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA67C34114;
        Fri, 10 Jun 2022 09:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654853733;
        bh=S85Gho6tKCAJq6nccolLm+QaZWBGnvHyY2hcy5bXr3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m3UExdEB0HqFTeWuUjMPeMyqAdOhCUV2DL2P3DUW6AoAQuC95rUEFDEdHweDzNFdt
         p7R0ebnCsTRBGGUY1ruenwEMGtlpl5MWqO9YLN9XrdDFaew5oyi2bR1FsE8m+8Tr0I
         ltdhzdX44i4GWkWYEiYkOOhvlZcsTIFaVeWyv0P26jUNUHnbnLfZ5cr/N6x0rJReGU
         nlTAE5GcrKq5F+P41rLuDmaBQUMKNsIzlTXDYWecsznbZc6PfCVa0wP7LVlKVP3Z4n
         CImJqp2aPGDfIdF4Nu6qABUKWnio7HjYIeyLikMCtvPAYQU1Uv4mww+cE6NgnFEyED
         VIrTL57e8wA6w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nzaws-00H6Dt-6s; Fri, 10 Jun 2022 10:28:58 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Mark Brown <broonie@kernel.org>,
        Reiji Watanabe <reijiw@google.com>, kernel-team@android.com
Subject: [PATCH v2 18/19] KVM: arm64: Document why pause cannot be turned into a flag
Date:   Fri, 10 Jun 2022 10:28:37 +0100
Message-Id: <20220610092838.1205755-19-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610092838.1205755-1-maz@kernel.org>
References: <20220610092838.1205755-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com, will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org, reijiw@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c6975ecf5a5f..2cc42e1fec18 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -341,6 +341,15 @@ struct kvm_vcpu_arch {
 	/* State flags for kernel bookkeeping, unused by the hypervisor code */
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
@@ -394,9 +403,6 @@ struct kvm_vcpu_arch {
 	/* vcpu power state */
 	struct kvm_mp_state mp_state;
 
-	/* Don't run the guest (internal implementation need) */
-	bool pause;
-
 	/* Cache some mmu pages needed inside spinlock regions */
 	struct kvm_mmu_memory_cache mmu_page_cache;
 
-- 
2.34.1

