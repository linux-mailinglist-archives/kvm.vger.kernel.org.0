Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486B0605A9A
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 11:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbiJTJHq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 05:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiJTJHl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 05:07:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3185E19B670
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 02:07:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1F25B826AD
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FABC43140;
        Thu, 20 Oct 2022 09:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666256857;
        bh=L1c/+tFZZRhijg30lPPqIBaHqiyb70GwjjA7yQE8RbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kdHjbnJxE1vsadwz99+FDtf+3bDvjYIypzkkG++XKlx5pC2sCEgLZWVGpRaO+deYE
         rDw2gXsPIO8OXFey6/zSQOejSCNiPwJ274Olia2ILnPtQrx5d8F76hAJSTs2W+pynX
         W/fCe+UDInZhlj/JnXY5oVDVtv3rPMv8lU128yqTn5DqxqF+8y/PCItcN9mG49MrNl
         aCH+r4AGlo1cPKUof1+CeExDOlUAJR47D/5QHHzkjpd1Epx18yhDTMVdH0xuUNRQut
         nt1Xl0+/tVdaedjuNmV9uBWxjr7Dy9cv9bZhD/exzmF+zv5l9HtZCe58h0IEjyHgeN
         17JzpXPpLoMow==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1olRWZ-000Buf-Id;
        Thu, 20 Oct 2022 10:07:35 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH 04/17] arm64: Prevent the use of is_kernel_in_hyp_mode() in hypervisor code
Date:   Thu, 20 Oct 2022 10:07:14 +0100
Message-Id: <20221020090727.3669908-5-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020090727.3669908-1-maz@kernel.org>
References: <20221020090727.3669908-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using is_kernel_in_hyp_mode() in hypervisor code is a pretty bad
mistake. This helper only checks for CurrentEL being EL2, which
is always true.

Make the link fail if using the helper in hypervisor context
by referencing a non-existent function. Whilst we're at it,
flag the helper as __always_inline, which it really should be.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/virt.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index b11a1c8c8b36..5f84a87a6a2d 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -110,8 +110,13 @@ static inline bool is_hyp_mode_mismatched(void)
 	return __boot_cpu_mode[0] != __boot_cpu_mode[1];
 }
 
-static inline bool is_kernel_in_hyp_mode(void)
+extern void gotcha_is_kernel_in_hyp_mode(void);
+
+static __always_inline bool is_kernel_in_hyp_mode(void)
 {
+#if defined(__KVM_NVHE_HYPERVISOR__) || defined(__KVM_VHE_HYPERVISOR__)
+	gotcha_is_kernel_in_hyp_mode();
+#endif
 	return read_sysreg(CurrentEL) == CurrentEL_EL2;
 }
 
-- 
2.34.1

