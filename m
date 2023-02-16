Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE62699771
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 15:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjBPObU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 09:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjBPObS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 09:31:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AC27ABA
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 06:31:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4CCEB8217A
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 14:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814C1C433EF;
        Thu, 16 Feb 2023 14:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676557875;
        bh=AXe3+d84n0T3lT9bC+GGjquzOfxEYZEi3/W6fF4dWR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WmWGv3+ZvoZ/CXpnluQ71vpkUpvqIFAOrD+mKmHhM5tmjZrg96OmNh65Ix3dvaPk6
         VTiAPH4vdU1GP3ZWaVsOx16wDzAdqn5oqIAjbdpQvB28QPqteK9vj1ucqqXn1yK7bp
         tylTyK72AcEh4ysEHijUbfJ8CWuSvDkwFjrz9jMkt7kCepOrSMIoVB2hWENv+TYKtt
         402lm3eq6miyxOl5MkxzHcr3ZZlEXowp3f0R0FJ7ebm9ZJbzJhFQcWvLZlSQcstTnf
         UbPAUwVnpvQgeCzJBGf/HtBhUReN49y9oRF9sY1oZjG06hBL/46pcDYUOFXkEKOOTV
         m2tyCJcgzPCzw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pSf8w-00AuwB-Tr;
        Thu, 16 Feb 2023 14:21:50 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>, dwmw2@infradead.org
Subject: [PATCH 16/16] KVM: arm64: selftests: Deal with spurious timer interrupts
Date:   Thu, 16 Feb 2023 14:21:23 +0000
Message-Id: <20230216142123.2638675-17-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216142123.2638675-1-maz@kernel.org>
References: <20230216142123.2638675-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, dwmw2@infradead.org
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

Make sure the timer test can properly handle a spurious timer
interrupt, something that is far from being unlikely.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/aarch64/arch_timer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 62af0e7d10b4..3f6f0bfa68a2 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -158,6 +158,9 @@ static void guest_irq_handler(struct ex_regs *regs)
 	uint32_t cpu = guest_get_vcpuid();
 	struct test_vcpu_shared_data *shared_data = &vcpu_shared_data[cpu];
 
+	if (intid == IAR_SPURIOUS)
+		return;
+
 	guest_validate_irq(intid, shared_data);
 
 	WRITE_ONCE(shared_data->nr_iter, shared_data->nr_iter + 1);
-- 
2.34.1

