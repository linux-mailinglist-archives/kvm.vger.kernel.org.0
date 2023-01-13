Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F84566A0DA
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 18:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjAMRiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 12:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjAMRhn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 12:37:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B289A857F7
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 09:25:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E764CB8219B
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 17:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDDBC433F0;
        Fri, 13 Jan 2023 17:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673630732;
        bh=GLsGai/HaLX4rlQF1y+E+eiiJYqVXPvgiCUVO/iODC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TzmhEF9Dtrwr2Wgs5zPIv+FcdFKirg2OCG3DDBEaTWvW2XahQnc+0Pg2UdVutjuXi
         gkt3xDri07c7khkZhvWeffUeVVZDBeeoYE4Y3aU7LwyfLqmU8ZWF/97aBu7ba6aAqD
         c94Q2HJwLlgQK+ODsDJUxRmG1XpfNTPZKfkNi+qDyqOKx9ChlCKQOSQAeEiCND1gIK
         /iavORKQo9MRf/9KPHbeFsXyEu5FzlrQj4ZRyVy/zu+AtLz4FZQtk7Ca0T039mIBoN
         0ddl4fwkl4Qi6vjae5aENV4EswKkt70pWz7zVYeAomg9OhbIrCFUfUasdN22OeHhhg
         3t0ioO51D15hQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pGNo2-001bBu-Do;
        Fri, 13 Jan 2023 17:25:30 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 1/2] KVM: arm64: Disable KVM on systems with a VPIPT i-cache
Date:   Fri, 13 Jan 2023 17:25:22 +0000
Message-Id: <20230113172523.2063867-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230113172523.2063867-1-maz@kernel.org>
References: <20230113172523.2063867-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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

Systems with a VMID-tagged PIPT i-cache have been supported for
a while by Linux and KVM. However, these systems never appeared
on our side of the multiverse.

Refuse to initialise KVM on such a machine, should then ever appear.
Following changes will drop the support from the hypervisor.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9c5573bc4614..508deed213a2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2195,6 +2195,11 @@ int kvm_arch_init(void *opaque)
 	int err;
 	bool in_hyp_mode;
 
+	if (icache_is_vpipt()) {
+		kvm_info("Incompatible VPIPT I-Cache policy\n");
+		return -ENODEV;
+	}
+
 	if (!is_hyp_mode_available()) {
 		kvm_info("HYP mode not available\n");
 		return -ENODEV;
-- 
2.34.1

