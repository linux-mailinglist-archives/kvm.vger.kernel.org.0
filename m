Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78EC6A79C6
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 04:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjCBDDj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 22:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjCBDDh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 22:03:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA6E55040
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 19:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677726169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hAGv1iCZBmtezd5cdZX633/N33Ksxy9PkYDSRbpiY7k=;
        b=UIl78oGMZaiJLZbVzYZsP1VMcmYM1YboP2oFR9KXn/Qftz37B66wXdyKe/ZBvSw9wzJIrY
        M5BpKVm4kzoDxzSAC5x1ghSrjOjFj4/u4/+iUFi4Oc6DMEdAGgEgpLOC9tzJMh687oUbP7
        jwIbqIyelwhTJom10u/QKERZhzXtudY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-ynCklZYaMTejg9pK7Ip8hA-1; Wed, 01 Mar 2023 22:02:46 -0500
X-MC-Unique: ynCklZYaMTejg9pK7Ip8hA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13CE13C02529;
        Thu,  2 Mar 2023 03:02:46 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 07C182026D4B;
        Thu,  2 Mar 2023 03:02:46 +0000 (UTC)
From:   Shaoqin Huang <shahuang@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     Shaoqin Huang <shahuang@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Eric Auger <eric.auger@redhat.com>,
        kvm@vger.kernel.org (open list:ARM)
Subject: [RESEND kvm-unit-tests 1/3] arm: gic: Write one bit per time in gic_irq_set_clr_enable()
Date:   Wed,  1 Mar 2023 22:02:35 -0500
Message-Id: <20230302030238.158796-2-shahuang@redhat.com>
In-Reply-To: <20230302030238.158796-1-shahuang@redhat.com>
References: <20230302030238.158796-1-shahuang@redhat.com>
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

When use gic_irq_set_clr_enable() to disable an interrupt, it will
disable all interrupt since it first read from Interrupt Clear-Enable
Registers and then write this value with a mask back.

So diretly write one bit per time to enable or disable interrupt.

Fixes: cb573c2 ("arm: gic: Introduce gic_irq_set_clr_enable() helper")
Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 lib/arm/gic.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index 1bfcfcf..89a15fe 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -176,7 +176,6 @@ void gic_ipi_send_mask(int irq, const cpumask_t *dest)
 void gic_irq_set_clr_enable(int irq, bool enable)
 {
 	u32 offset, split = 32, shift = (irq % 32);
-	u32 reg, mask = BIT(shift);
 	void *base;
 
 	assert(irq < 1020);
@@ -199,8 +198,7 @@ void gic_irq_set_clr_enable(int irq, bool enable)
 		assert(0);
 	}
 	base += offset + (irq / split) * 4;
-	reg = readl(base);
-	writel(reg | mask, base);
+	writel(BIT(shift), base);
 }
 
 enum gic_irq_state gic_irq_state(int irq)
-- 
2.39.1

