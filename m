Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163895FB8A5
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 18:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiJKQyS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 12:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiJKQyQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 12:54:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4890BA7A92
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 09:54:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6534EB81644
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 16:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CC6C433C1;
        Tue, 11 Oct 2022 16:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665507247;
        bh=xlwuYvosoE0BbYbq9HHwAmrNUGKKZ8giCfeDw0SQPDU=;
        h=From:To:Cc:Subject:Date:From;
        b=OnGUroGoqo+A2kb/uGY64G53Fuk5sMBo5h9SoFlhYzk/VBfgV5Vd9PhsTSAX+Vup2
         3iNn2Nay8RoSDYsGIZJ1xo53eezwfbGo7Cdb3uLP2GGOQzf6zCa5HfpThOrvZl5P2c
         aZJIN5Sd2Be4LktxeptQd6DI4x2YzdvZoCpWvQeP4QVj1wuz4YIUwuhPYdah/8YUFU
         Q2R3mfjTwucFLJfuwR/g8q+id3EhBkvC1s4XRfIyGupcL45efn1egi5VR07wSXIBHY
         2irXOapsRRpUV5fAf43q6piwhvSPctRqBvojE1UqKYVHlU862Kp1N4AWkBhI/udih9
         ccyI02eoLUtlQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oiIW4-00Fs7W-Oh;
        Tue, 11 Oct 2022 17:54:04 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH] KVM: arm64: pkvm: Fixup boot mode to reflect that the kernel resumes from EL1
Date:   Tue, 11 Oct 2022 17:54:00 +0100
Message-Id: <20221011165400.1241729-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, qperret@google.com, will@kernel.org, vdonnefort@google.com
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

The kernel has an awfully complicated boot sequence in order to cope
with the various EL2 configurations, including those that "enhanced"
the architecture. We go from EL2 to EL1, then back to EL2, staying
at EL2 if VHE capable and otherwise go back to EL1.

Here's a paracetamol tablet for you.

The cpu_resume path follows the same logic, because coming up with
two versions of a square wheel is hard.

However, things aren't this straightforward with pKVM, as the host
resume path is always proxied by the hypervisor, which means that
the kernel is always entered at EL1. Which contradicts what the
__boot_cpu_mode[] array contains (it obviously says EL2).

This thus triggers a HVC call from EL1 to EL2 in a vain attempt
to upgrade from EL1 to EL2 VHE, which we are, funnily enough,
reluctant to grant to the host kernel. This is also completely
unexpected, and puzzles your average EL2 hacker.

Address it by fixing up the boot mode at the point the host gets
deprivileged. is_hyp_mode_available() and co already have a static
branch to deal with this, making it pretty safe.

Reported-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b6c9bfa8492f..cf075c9b9ab1 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2107,6 +2107,17 @@ static int pkvm_drop_host_privileges(void)
 	 * once the host stage 2 is installed.
 	 */
 	static_branch_enable(&kvm_protected_mode_initialized);
+
+	/*
+	 * Fixup the boot mode so that we don't take spurious round
+	 * trips via EL2 on cpu_resume. Flush to the PoC for a good
+	 * measure, so that it can be observed by a CPU coming out of
+	 * suspend with the MMU off.
+	 */
+	__boot_cpu_mode[0] = __boot_cpu_mode[1] = BOOT_CPU_MODE_EL1;
+	dcache_clean_poc((unsigned long)__boot_cpu_mode,
+			 (unsigned long)(__boot_cpu_mode + 2));
+
 	on_each_cpu(_kvm_host_prot_finalize, &ret, 1);
 	return ret;
 }
-- 
2.34.1

