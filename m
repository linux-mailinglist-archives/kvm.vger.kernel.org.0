Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9276A81EE
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 13:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjCBMLs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 07:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCBMLr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 07:11:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE7F1714A
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 04:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677759061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jM0YMtHuHyizNYkbKLa/qVtLG7T10pY8cE1PxFIKoSo=;
        b=Utfqsz1c/zD/b2Tipa+J10UeNsZFHVj5AlIRrBX/igLDcFBPTjtTpGeGroMM5oVR1ZpECb
        YBLzw4hv21QqEoOP+LBfhyc+d3t1hI8RSZF0Fqs6OC7483NaMi/tm1S+x0ZghbPwNLi3uQ
        VRA0ciPHN05QB6THsUmB5qPWyabw+6U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-wSc5omsxNgCioCUT1llORw-1; Thu, 02 Mar 2023 07:10:58 -0500
X-MC-Unique: wSc5omsxNgCioCUT1llORw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED5B829AA2CF;
        Thu,  2 Mar 2023 12:10:57 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D9B102026D76;
        Thu,  2 Mar 2023 12:10:57 +0000 (UTC)
From:   Shaoqin Huang <shahuang@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     Shaoqin Huang <shahuang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        kvm@vger.kernel.org (open list:ARM)
Subject: [kvm-unit-tests PATCH v2 1/3] arm: gic: Write one bit per time in gic_irq_set_clr_enable()
Date:   Thu,  2 Mar 2023 07:10:47 -0500
Message-Id: <20230302121049.160466-2-shahuang@redhat.com>
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

When use gic_irq_set_clr_enable() to disable an interrupt, it will
disable all interrupt since it first read from Interrupt Clear-Enable
Registers where '1' indicates that forwarding of the corresponding
interrupt is enabled and then write this value with a mask back where
'1' indicates disable the interrupt.

So diretly write one bit per time to enable or disable interrupt.

Fixes: cb573c2 ("arm: gic: Introduce gic_irq_set_clr_enable() helper")
Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
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

