Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F14876B10A
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 12:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbjHAKQi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 06:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233939AbjHAKQH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 06:16:07 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5809E1712;
        Tue,  1 Aug 2023 03:15:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8E6D121E46;
        Tue,  1 Aug 2023 10:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690884952; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CII0YZAfLqhx4Cr+2BFJT+i9mzuLVeE7dd78KttFA2o=;
        b=jy3JtXoPDTRHxJdQlqybEzwwNtFH+3R3OJTAZ0p0XN192iJyO7EA80FEkns/HjGx2H2jc0
        Y6VI89BB0HIdkzN8RetG2aHLwJKrDbs8BUZr/7/dwxUleATQrXPvdXVn368as8j2VFA+FK
        Ir6d5udErkD0W8ez17i4Tk/OeO7q8nA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690884952;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CII0YZAfLqhx4Cr+2BFJT+i9mzuLVeE7dd78KttFA2o=;
        b=pD6cECa5AeMJ3yULzu9WBQeB0l6/jodPVtqsvrf9yCXkGcnJsnUTyE+GXLzNrUiHMmS/mH
        AMUdOfrxems145DQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5782B139BD;
        Tue,  1 Aug 2023 10:15:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KIRdFFjbyGQBXQAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Tue, 01 Aug 2023 10:15:52 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     deller@gmx.de, javierm@redhat.com, sam@ravnborg.org
Cc:     linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        kvm@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH v2 21/47] fbdev/kyro: Use fbdev I/O helpers
Date:   Tue,  1 Aug 2023 12:13:26 +0200
Message-ID: <20230801101541.900-22-tzimmermann@suse.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801101541.900-1-tzimmermann@suse.de>
References: <20230801101541.900-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set struct fb_ops and with FB_DEFAULT_IO_OPS, fbdev's initializer
for I/O memory. Sets the callbacks to the cfb_ and fb_io_ functions.
Select the correct modules with Kconfig's FB_IO_HELPERS token.

The macro and token set the currently selected values, so there is
no functional change.

v2:
	* updated to use _IOMEM_ tokens

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Helge Deller <deller@gmx.de>
---
 drivers/video/fbdev/Kconfig      | 4 +---
 drivers/video/fbdev/kyro/fbdev.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index 6c032a1e7ab6..231450ef449f 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -1306,9 +1306,7 @@ config FB_NEOMAGIC
 config FB_KYRO
 	tristate "IMG Kyro support"
 	depends on FB && PCI
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
+	select FB_IOMEM_HELPERS
 	select VIDEO_NOMODESET
 	help
 	  Say Y here if you have a STG4000 / Kyro / PowerVR 3 based
diff --git a/drivers/video/fbdev/kyro/fbdev.c b/drivers/video/fbdev/kyro/fbdev.c
index 1109326ca3c4..af6c0581d3e2 100644
--- a/drivers/video/fbdev/kyro/fbdev.c
+++ b/drivers/video/fbdev/kyro/fbdev.c
@@ -661,13 +661,11 @@ static struct pci_driver kyrofb_pci_driver = {
 
 static const struct fb_ops kyrofb_ops = {
 	.owner		= THIS_MODULE,
+	FB_DEFAULT_IOMEM_OPS,
 	.fb_check_var	= kyrofb_check_var,
 	.fb_set_par	= kyrofb_set_par,
 	.fb_setcolreg	= kyrofb_setcolreg,
 	.fb_ioctl	= kyrofb_ioctl,
-	.fb_fillrect	= cfb_fillrect,
-	.fb_copyarea	= cfb_copyarea,
-	.fb_imageblit	= cfb_imageblit,
 };
 
 static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
-- 
2.41.0

