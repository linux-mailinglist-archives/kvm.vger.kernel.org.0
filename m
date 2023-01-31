Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D3C68291B
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 10:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbjAaJlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 04:41:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbjAaJk5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 04:40:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978742FCE7
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:40:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DADE3CE1BDB
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 09:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4991DC433D2;
        Tue, 31 Jan 2023 09:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675158050;
        bh=BqWGGG6P0Q1EZNUaobu4OneFEfRFSI4gFWADamGwyEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vLz3gBvtu5uXbisjJp6/wBgoiYRrDUuso9bZ0UtYCXKd9o2MOzCjVUuz9PTqgq59O
         VTiPCw2Ga4Wh3WIQc8qcbq0EIBxs3ZmbsxpgBO4Mh4hi/t2JlF92Em0R8ViUZefhXk
         BYQiqZU5pwKVnaNPg9XbXMsar1M4idPjDAZIFFF9m741tHb7bUFKGYGKhQD2fYYFdN
         Uh9XnynOTP5tMmqME+dBVjJkB3OrRZ6NVYmiaXESLeX8y08g5cQiRn9PUwFan8Swxd
         296sGxOtA+QoUPcIG3mWqSI4bu6qaejbtsF+BNm32TKzFfk/Xc67H6g7v7h3LfMUQA
         svOBA56JK7X+Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pMmtq-0067U2-7d;
        Tue, 31 Jan 2023 09:25:58 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v8 43/69] KVM: arm64: nv: Fold guest's HCR_EL2 configuration into the host's
Date:   Tue, 31 Jan 2023 09:24:38 +0000
Message-Id: <20230131092504.2880505-44-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131092504.2880505-1-maz@kernel.org>
References: <20230131092504.2880505-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When entering a L2 guest (nested virt enabled, but not in hypervisor
context), we need to honor the traps the L1 guest has asked enabled.

For now, just OR the guest's HCR_EL2 into the host's. We may have to do
some filtering in the future though.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index a17bf261d501..ff77b37b6f45 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -81,6 +81,11 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 			if (!vcpu_el2_tge_is_set(vcpu))
 				hcr |= HCR_AT | HCR_TTLB;
 		}
+	} else if (vcpu_has_nv(vcpu)) {
+		u64 vhcr_el2 = __vcpu_sys_reg(vcpu, HCR_EL2);
+
+		vhcr_el2 &= ~HCR_GUEST_NV_FILTER_FLAGS;
+		hcr |= vhcr_el2;
 	}
 
 	___activate_traps(vcpu, hcr);
-- 
2.34.1

