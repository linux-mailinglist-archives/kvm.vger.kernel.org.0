Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0F46A81EF
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 13:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjCBMLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 07:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjCBMLt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 07:11:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CEDD3E601
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 04:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677759061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BnA1zuhpTm2PtZce9SymWm0HXGJokQBnV5kaA5s8cFQ=;
        b=C3SDbuZtVGkMaBzxIS4iTOpJgi6YGJNes6cMpOTvG16av54iSrAR/DtzXdpn3O0zblfSzm
        4N3sofR0tvEb5MRU2G6FEQ/sdgLiKD2wUzTPn8ibSUBs2U5fzDLN+sx5rIdkB6/GBp/NeL
        cMT32gycbzZNKpG5Pg1Z2DcgAPDm1Nw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-gpVxZ4u6N_G8B_x3n2pxzg-1; Thu, 02 Mar 2023 07:10:58 -0500
X-MC-Unique: gpVxZ4u6N_G8B_x3n2pxzg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 144A3101A521;
        Thu,  2 Mar 2023 12:10:58 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08A042026D4B;
        Thu,  2 Mar 2023 12:10:58 +0000 (UTC)
From:   Shaoqin Huang <shahuang@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     Shaoqin Huang <shahuang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        kvm@vger.kernel.org (open list:ARM)
Subject: [kvm-unit-tests PATCH v2 2/3] arm64: timer: Use gic_enable/disable_irq() macro in timer test
Date:   Thu,  2 Mar 2023 07:10:48 -0500
Message-Id: <20230302121049.160466-3-shahuang@redhat.com>
In-Reply-To: <20230302121049.160466-1-shahuang@redhat.com>
References: <20230302121049.160466-1-shahuang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use gic_enable/disable_irq() to clean up the code.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arm/timer.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index c4e7b10..c0a8388 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -14,9 +14,6 @@
 #include <asm/gic.h>
 #include <asm/io.h>
 
-static void *gic_isenabler;
-static void *gic_icenabler;
-
 static bool ptimer_unsupported;
 
 static void ptimer_unsupported_handler(struct pt_regs *regs, unsigned int esr)
@@ -139,12 +136,12 @@ static struct timer_info ptimer_info = {
 
 static void set_timer_irq_enabled(struct timer_info *info, bool enabled)
 {
-	u32 val = 1 << PPI(info->irq);
+	u32 irq = PPI(info->irq);
 
 	if (enabled)
-		writel(val, gic_isenabler);
+		gic_enable_irq(irq);
 	else
-		writel(val, gic_icenabler);
+		gic_disable_irq(irq);
 }
 
 static void irq_handler(struct pt_regs *regs)
@@ -366,17 +363,6 @@ static void test_init(void)
 
 	gic_enable_defaults();
 
-	switch (gic_version()) {
-	case 2:
-		gic_isenabler = gicv2_dist_base() + GICD_ISENABLER;
-		gic_icenabler = gicv2_dist_base() + GICD_ICENABLER;
-		break;
-	case 3:
-		gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;
-		gic_icenabler = gicv3_sgi_base() + GICR_ICENABLER0;
-		break;
-	}
-
 	install_irq_handler(EL1H_IRQ, irq_handler);
 	set_timer_irq_enabled(&ptimer_info, true);
 	set_timer_irq_enabled(&vtimer_info, true);
-- 
2.39.1

