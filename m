Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81EF44D89A6
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 17:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236700AbiCNQmn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 12:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241618AbiCNQmN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 12:42:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9965A434A1
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 09:40:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 247DF60B06
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 16:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C89C340E9;
        Mon, 14 Mar 2022 16:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647276056;
        bh=3tLm9nswi5yzJZX6DTahnSFJwPs0XmW4BZzo9Gu2cdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQ2JbVhzBBVV/A62ljkhfo/yCOc9E8cC0ZdE9m7QBfsQwwSk/4azlEoeNSeBfmm7h
         YrtaY89iHIHTAqHuCHyud+t05nLl64BX0ZlTbBGdqJOUrJtCStDHicuf6nwq0wHXaQ
         zJg629JyWrg8CFtQvf1BvLViaVYvMfCPsDhvKwSKfTMrtD243DVtZCChjvXfXdQPno
         GNaoKIhovOI69czolvtmrUpKhPThw0AQLMMy/28yLHJG7psqW6VqWjMDXEhibJMRsg
         ZXqYent4I8CB3HT53Cg4kxMg/a+T6QFwfWvGNMZ74yq7eJWcl1DVbDGJofn4Jdnaeh
         /OEc/nV6nYzwQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nTnkc-00EPS0-Ez; Mon, 14 Mar 2022 16:40:54 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com
Subject: [PATCH 1/4] irqchip/gic-v3: Exposes bit values for GICR_CTLR.{IR,CES}
Date:   Mon, 14 Mar 2022 16:40:41 +0000
Message-Id: <20220314164044.772709-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220314164044.772709-1-maz@kernel.org>
References: <20220314164044.772709-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, andre.przywara@arm.com, eric.auger@redhat.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As we're about to expose GICR_CTLR.{IR,CES} to guests, populate
the include file with the architectural values.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/linux/irqchip/arm-gic-v3.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 12d91f0dedf9..aeb8ced53880 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -127,6 +127,8 @@
 #define GICR_PIDR2			GICD_PIDR2
 
 #define GICR_CTLR_ENABLE_LPIS		(1UL << 0)
+#define GICR_CTLR_IR			(1UL << 1)
+#define GICR_CTLR_CES			(1UL << 2)
 #define GICR_CTLR_RWP			(1UL << 3)
 
 #define GICR_TYPER_CPU_NUMBER(r)	(((r) >> 8) & 0xffff)
-- 
2.34.1

