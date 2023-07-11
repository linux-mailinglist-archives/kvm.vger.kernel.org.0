Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE78974F61B
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 18:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbjGKQxf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 12:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbjGKQxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 12:53:33 -0400
Received: from out-9.mta1.migadu.com (out-9.mta1.migadu.com [95.215.58.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A662210C4
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 09:53:31 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689093837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JsW608w9Icre+eeXWiPepSjKi7cGG5If1vSETO465rs=;
        b=QF9u5YarQ3XzlTFgOQ75cikl4e7GNbilk51J/EF5FT5P17CXSbsJhIZPn2v2xfDNiD3iPg
        OL2K7w14/U1uqKbPrZ+SREEjfjWxoRcLu+YoI4CCjBNUfs96b9Eb/rlpz4+aGHn7BvrvUg
        A5l4s7aCH2f1LJn0RlazEQQwuZEJWso=
From:   Sui Jingfeng <sui.jingfeng@linux.dev>
To:     David Airlie <airlied@gmail.com>
Cc:     amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        kvm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Sui Jingfeng <suijingfeng@loongson.cn>
Subject: [PATCH v3 9/9] drm/loongson: Add an implement for the is_primary_gpu function callback
Date:   Wed, 12 Jul 2023 00:43:10 +0800
Message-Id: <20230711164310.791756-10-sui.jingfeng@linux.dev>
In-Reply-To: <20230711164310.791756-1-sui.jingfeng@linux.dev>
References: <20230711164310.791756-1-sui.jingfeng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sui Jingfeng <suijingfeng@loongson.cn>

Signed-off-by: Sui Jingfeng <suijingfeng@loongson.cn>
---
 drivers/gpu/drm/loongson/lsdc_drv.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/loongson/lsdc_drv.c b/drivers/gpu/drm/loongson/lsdc_drv.c
index d10a28c2c494..92ef07d6a534 100644
--- a/drivers/gpu/drm/loongson/lsdc_drv.c
+++ b/drivers/gpu/drm/loongson/lsdc_drv.c
@@ -257,6 +257,14 @@ static unsigned int lsdc_vga_set_decode(struct pci_dev *pdev, bool state)
 	return VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM;
 }
 
+static bool lsdc_is_primary_gpu(struct pci_dev *pdev)
+{
+	struct drm_device *ddev = pci_get_drvdata(pdev);
+	struct lsdc_device *ldev = to_lsdc(ddev);
+
+	return drm_aperture_contain_firmware_fb(ldev->vram_base, ldev->vram_size);
+}
+
 static int lsdc_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	const struct lsdc_desc *descp;
@@ -289,7 +297,7 @@ static int lsdc_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_drvdata(pdev, ddev);
 
-	vga_client_register(pdev, lsdc_vga_set_decode, NULL);
+	vga_client_register(pdev, lsdc_vga_set_decode, lsdc_is_primary_gpu);
 
 	drm_kms_helper_poll_init(ddev);
 
-- 
2.25.1

