Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2897E76F215
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 20:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbjHCSkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 14:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbjHCSkn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 14:40:43 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829E92D73;
        Thu,  3 Aug 2023 11:40:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1499E1F749;
        Thu,  3 Aug 2023 18:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1691088039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=efQ7YNt9iOrsO9InHeNiwl5AlCI8R+Wo62kz+03zvZo=;
        b=vtI38sdKLcTAk1vnAi/JbizYjtHMehheqvZdNF6toYZp/b38MLwP/cSxRfIUAxcaveTKAx
        Mucph2e58idNFdvhmNrdejrFbQ5u1dzfLPIcbdGqwT/raUQiFZG/l6zyfUg0BNj6ilF6Yo
        LaSZkqw64Tp+I8ISM0KoH7bbYtekepo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1691088039;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=efQ7YNt9iOrsO9InHeNiwl5AlCI8R+Wo62kz+03zvZo=;
        b=vJoe2LZVjtmTJuTDMkAbiXoA8L1Y7TYK5sAwLZQKXY4w/hFcNiQza0VwhNgBr9XVfswa7u
        da4AaH5RJJp5wSCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C5BD61333C;
        Thu,  3 Aug 2023 18:40:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2Dc5L6b0y2TLGAAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Thu, 03 Aug 2023 18:40:38 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     deller@gmx.de, javierm@redhat.com, sam@ravnborg.org
Cc:     linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        kvm@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v3 04/47] fbdev/atmel_lcdfb: Use fbdev I/O helpers
Date:   Thu,  3 Aug 2023 20:35:29 +0200
Message-ID: <20230803184034.6456-5-tzimmermann@suse.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230803184034.6456-1-tzimmermann@suse.de>
References: <20230803184034.6456-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set struct fb_ops and with FB_DEFAULT_IOMEM_OPS, fbdev's initializer
for I/O memory. Sets the callbacks to the cfb_ and fb_io_ functions.
Select the correct modules with Kconfig's FB_IOMEM_HELPERS token.

The macro and token set the currently selected values, so there is
no functional change.

v3:
	* use _IOMEM_ in commit message
v2:
	* updated to use _IOMEM_ tokens

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Helge Deller <deller@gmx.de>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/video/fbdev/Kconfig       | 4 +---
 drivers/video/fbdev/atmel_lcdfb.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index 83baef1c8379..850d5c07587f 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -713,9 +713,7 @@ config FB_ATMEL
 	depends on FB && OF && HAVE_CLK && HAS_IOMEM
 	depends on HAVE_FB_ATMEL || COMPILE_TEST
 	select FB_BACKLIGHT
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
+	select FB_IOMEM_HELPERS
 	select FB_MODE_HELPERS
 	select VIDEOMODE_HELPERS
 	help
diff --git a/drivers/video/fbdev/atmel_lcdfb.c b/drivers/video/fbdev/atmel_lcdfb.c
index 3021660b3e87..c75a62287ec4 100644
--- a/drivers/video/fbdev/atmel_lcdfb.c
+++ b/drivers/video/fbdev/atmel_lcdfb.c
@@ -806,14 +806,12 @@ static int atmel_lcdfb_blank(int blank_mode, struct fb_info *info)
 
 static const struct fb_ops atmel_lcdfb_ops = {
 	.owner		= THIS_MODULE,
+	FB_DEFAULT_IOMEM_OPS,
 	.fb_check_var	= atmel_lcdfb_check_var,
 	.fb_set_par	= atmel_lcdfb_set_par,
 	.fb_setcolreg	= atmel_lcdfb_setcolreg,
 	.fb_blank	= atmel_lcdfb_blank,
 	.fb_pan_display	= atmel_lcdfb_pan_display,
-	.fb_fillrect	= cfb_fillrect,
-	.fb_copyarea	= cfb_copyarea,
-	.fb_imageblit	= cfb_imageblit,
 };
 
 static irqreturn_t atmel_lcdfb_interrupt(int irq, void *dev_id)
-- 
2.41.0

