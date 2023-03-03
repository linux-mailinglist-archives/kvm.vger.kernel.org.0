Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7216A6A8FB3
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 04:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjCCDNQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 22:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjCCDNO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 22:13:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18EC57D13
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 19:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677813150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ncKHv1h1opO4DA5kxu6YhoDiEOVtPQycDQ/UhO4F0qc=;
        b=Y6cHhro8UaOQGSrZn5nuVkRPcO/n4yR/m4Y3Slh4b+sJ2I9XtuSr+33qmvCP/rOOmfBNba
        9Tso7fyo56PutpPwkIKahoajsXSKsVlkO3bX0itIV1Tvz+IG5qoPt/7WS28/wgJxYlVKwe
        f6S3sytNMF6Ij/MjvUOgg5qo1OzyLmE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-116-e2nKKxRJMJmBTJN0Ujc7dQ-1; Thu, 02 Mar 2023 22:12:28 -0500
X-MC-Unique: e2nKKxRJMJmBTJN0Ujc7dQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24D3D101A521;
        Fri,  3 Mar 2023 03:12:28 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1956C492C3E;
        Fri,  3 Mar 2023 03:12:28 +0000 (UTC)
From:   Shaoqin Huang <shahuang@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     Shaoqin Huang <shahuang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        kvm@vger.kernel.org (open list:ARM)
Subject: [kvm-unit-tests PATCH v3 3/3] arm64: microbench: Use gic_enable_irq() macro in microbench test
Date:   Thu,  2 Mar 2023 22:11:47 -0500
Message-Id: <20230303031148.162816-4-shahuang@redhat.com>
In-Reply-To: <20230303031148.162816-1-shahuang@redhat.com>
References: <20230303031148.162816-1-shahuang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use gic_enable_irq() to clean up code.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arm/micro-bench.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 8436612..090fda6 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -212,24 +212,11 @@ static void lpi_exec(void)
 
 static bool timer_prep(void)
 {
-	void *gic_isenabler;
-
 	gic_enable_defaults();
 	install_irq_handler(EL1H_IRQ, gic_irq_handler);
 	local_irq_enable();
 
-	switch (gic_version()) {
-	case 2:
-		gic_isenabler = gicv2_dist_base() + GICD_ISENABLER;
-		break;
-	case 3:
-		gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;
-		break;
-	default:
-		assert_msg(0, "Unreachable");
-	}
-
-	writel(1 << PPI(TIMER_VTIMER_IRQ), gic_isenabler);
+	gic_enable_irq(PPI(TIMER_VTIMER_IRQ));
 	write_sysreg(ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
 	isb();
 
-- 
2.39.1

