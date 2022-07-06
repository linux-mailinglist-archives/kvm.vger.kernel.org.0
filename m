Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6757569048
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 19:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbiGFRFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 13:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233017AbiGFRFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 13:05:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6999B2A702
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 10:05:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1623CB81E35
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 17:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C888AC341C8;
        Wed,  6 Jul 2022 17:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657127119;
        bh=Yjer1p8CISH7ajZIiicGb4YHKSkfeGDvzPw18NhkF4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mWlYJPhqsk2TklPOCHsibQrywAl7GeTnmJ5+e0T+A6PNTkge0kmc1X0iJP20ukd5h
         I7Z8ApuYtpm2FCT2Bwd6t4KQ4US07gIre/YOAcVCp6VB/KA7j+YMhOdibq1FJoYqsq
         lrxENwPKO4TxhvhWITMGzId3vOYEgOQ0VwkHqO4eVlBp0RfxFOqkonper5Aft06cJD
         e6F4t4B5J0f3XjKVwApB59Dvu/fDp00lxN5nAKqDQlbWlEOchkB2nKbpZTtu6P5cXe
         3pwf0aFI0pL0pzDviogRfBI+yHXz+weY9FTVDm/0KGXCyhSkgZOffba8EkyC8MFRiR
         ThXXepg8nqIIg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1o987N-005h9i-Oa;
        Wed, 06 Jul 2022 17:43:13 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
Subject: [PATCH 14/19] KVM: arm64: vgic: Use {get,put}_user() instead of copy_{from.to}_user
Date:   Wed,  6 Jul 2022 17:42:59 +0100
Message-Id: <20220706164304.1582687-15-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220706164304.1582687-1-maz@kernel.org>
References: <20220706164304.1582687-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, schspa@gmail.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tidy-up vgic_get_common_attr() and vgic_set_common_attr() to use
{get,put}_user() instead of the more complex (and less type-safe)
copy_{from,to}_user().

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index ddead333c232..fbbd0338c782 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -170,7 +170,7 @@ static int vgic_set_common_attr(struct kvm_device *dev,
 		u64 addr;
 		unsigned long type = (unsigned long)attr->attr;
 
-		if (copy_from_user(&addr, uaddr, sizeof(addr)))
+		if (get_user(addr, uaddr))
 			return -EFAULT;
 
 		r = kvm_vgic_addr(dev->kvm, type, &addr, true);
@@ -233,14 +233,14 @@ static int vgic_get_common_attr(struct kvm_device *dev,
 		u64 addr;
 		unsigned long type = (unsigned long)attr->attr;
 
-		if (copy_from_user(&addr, uaddr, sizeof(addr)))
+		if (get_user(addr, uaddr))
 			return -EFAULT;
 
 		r = kvm_vgic_addr(dev->kvm, type, &addr, false);
 		if (r)
 			return (r == -ENODEV) ? -ENXIO : r;
 
-		if (copy_to_user(uaddr, &addr, sizeof(addr)))
+		if (put_user(addr, uaddr))
 			return -EFAULT;
 		break;
 	}
-- 
2.34.1

