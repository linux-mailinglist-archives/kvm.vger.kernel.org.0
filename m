Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7665828A0
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 16:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbiG0O3b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 10:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233779AbiG0O32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 10:29:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1182DAB5
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 07:29:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CA26B82184
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 14:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D94C4347C;
        Wed, 27 Jul 2022 14:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658932165;
        bh=HWhdK2O+6AF6A5Z3TJcDil6OutGoVo/EptFSn8Y2FSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=el3k/1HUEhRVl3SHY43exUG7A4KSXpJrVQ1TGBfHxmHaiFGZBeSKrTn13m27WFPtC
         XPXwFk0JOrITMmB4/DU9iBsB9DPcZM3wdzx0Plwy2ppVwaFUpO9eQqKJB5hvxLsO4u
         iW315W08OhyfYTdMxCSn2ad3+aBo/GE01keJ55ZfY13sQfNEoQhu/59OXnKl98EHw+
         uREaVOZwfLt882k7+ZHWEA6S0emzeNkY88clUmcYT1ww+kb0bOPSih742XzMt9Ms7q
         6MU5W19pWLPQra44g11DiWv70Uo6/4+HrsdeelSgeZv0R+iacXbLkfewg5bpuD2aBk
         cfBfqyDIDJ/xw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oGi2N-00APjL-3R;
        Wed, 27 Jul 2022 15:29:23 +0100
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
Subject: [PATCH 1/6] KVM: arm64: Move PROTECTED_NVHE_STACKTRACE around
Date:   Wed, 27 Jul 2022 15:29:01 +0100
Message-Id: <20220727142906.1856759-2-maz@kernel.org>
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

Make the dependency with EL2_DEBUG more obvious by moving the
stacktrace configurtion *after* it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/Kconfig | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 09c995869916..815cc118c675 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -46,6 +46,16 @@ menuconfig KVM
 
 	  If unsure, say N.
 
+config NVHE_EL2_DEBUG
+	bool "Debug mode for non-VHE EL2 object"
+	depends on KVM
+	help
+	  Say Y here to enable the debug mode for the non-VHE KVM EL2 object.
+	  Failure reports will BUG() in the hypervisor. This is intended for
+	  local EL2 hypervisor development.
+
+	  If unsure, say N.
+
 config PROTECTED_NVHE_STACKTRACE
 	bool "Protected KVM hypervisor stacktraces"
 	depends on NVHE_EL2_DEBUG
@@ -53,22 +63,10 @@ config PROTECTED_NVHE_STACKTRACE
 	help
 	  Say Y here to enable pKVM hypervisor stacktraces on hyp_panic()
 
-	  If you are not using protected nVHE (pKVM), say N.
-
 	  If using protected nVHE mode, but cannot afford the associated
 	  memory cost (less than 0.75 page per CPU) of pKVM stacktraces,
 	  say N.
 
-	  If unsure, say N.
-
-config NVHE_EL2_DEBUG
-	bool "Debug mode for non-VHE EL2 object"
-	depends on KVM
-	help
-	  Say Y here to enable the debug mode for the non-VHE KVM EL2 object.
-	  Failure reports will BUG() in the hypervisor. This is intended for
-	  local EL2 hypervisor development.
-
-	  If unsure, say N.
+	  If unsure, or not using protected nVHE (pKVM), say N.
 
 endif # VIRTUALIZATION
-- 
2.34.1

