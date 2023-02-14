Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0271E695791
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 04:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbjBNDqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 22:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjBNDqW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 22:46:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59737EB57
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 19:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676346329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rXXqhL3i2rw+CD2SWSpGnLLy2TCQWbs5XnC6wXJkit0=;
        b=H+04QcFP/CmeYZtX+i9Y+lhuE65wjAlyfWZBc45D0CDUwx4+pS8yX8Tye23ufqWUSbjZ6s
        rpP6uTktvqSh9J4eVFLoVncdVw5BB9UrrwKQu7xLqiCPJf9jQhQ/PRKi2J/Z9PzaADsoxt
        t2nXhZBFKQtz3whmqvPABqCWCepybIw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-ahTsTAxNNyiILwCNL55fQA-1; Mon, 13 Feb 2023 22:45:11 -0500
X-MC-Unique: ahTsTAxNNyiILwCNL55fQA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 94889101A55E;
        Tue, 14 Feb 2023 03:45:11 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E1FAC16022;
        Tue, 14 Feb 2023 03:45:11 +0000 (UTC)
From:   shahuang@redhat.com
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc:     Shaoqin Huang <shahuang@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests 3/3] arm64: microbench: Use gic_enable_irq() macro in microbench test
Date:   Mon, 13 Feb 2023 22:44:53 -0500
Message-Id: <20230214034453.148494-4-shahuang@redhat.com>
In-Reply-To: <20230214034453.148494-1-shahuang@redhat.com>
References: <20230214034453.148494-1-shahuang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Shaoqin Huang <shahuang@redhat.com>

Use gic_enable_irq() to clean up code.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
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

