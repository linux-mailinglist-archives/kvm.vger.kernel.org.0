Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3717674EE
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 20:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjG1SY0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 14:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236598AbjG1SYV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 14:24:21 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9DE649E1;
        Fri, 28 Jul 2023 11:24:02 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id AF67D1F8B0;
        Fri, 28 Jul 2023 18:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690568559; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MzY4Z7rVG/OphoGTsd56EsvKTsMPfCHipdK3wXe7h1k=;
        b=y1IQG77pq7PUOj25wm8nglLPJI2IYNE5kfXSPXHYRtkodDlep4bwlJKO6tblpjJhkT3iTo
        XZ+NmR2ZBgjLeb38To+wC2BXEzfk13GJ/hH82ZKVTkG6fXPUzMFxTCiWaNVjLI8DioNtT8
        pG7/J97VioWgzbKLoJnujF/zQzHD4vw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690568559;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MzY4Z7rVG/OphoGTsd56EsvKTsMPfCHipdK3wXe7h1k=;
        b=Pl2zv3Zt2qjyHYC68htaxCLTtJ92EOJDTwrH4ZD/W4Zew8lpbSNlwgy7nK7ZfCPdvcWxp7
        oCxRDk0MwZnTw5Bw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 769F513276;
        Fri, 28 Jul 2023 18:22:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IOwOHG8HxGQ3CwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Fri, 28 Jul 2023 18:22:39 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     deller@gmx.de, javierm@redhat.com, sam@ravnborg.org
Cc:     linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        kvm@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Andres Salomon <dilinger@queued.net>
Subject: [PATCH 13/47] fbdev/geode/gx1fb: Use fbdev I/O helpers
Date:   Fri, 28 Jul 2023 18:39:56 +0200
Message-ID: <20230728182234.10680-14-tzimmermann@suse.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230728182234.10680-1-tzimmermann@suse.de>
References: <20230728182234.10680-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Andres Salomon <dilinger@queued.net>
---
 drivers/video/fbdev/geode/Kconfig      | 4 +---
 drivers/video/fbdev/geode/gx1fb_core.c | 5 +----
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/video/fbdev/geode/Kconfig b/drivers/video/fbdev/geode/Kconfig
index b184085a78c2..511d0b314a1d 100644
--- a/drivers/video/fbdev/geode/Kconfig
+++ b/drivers/video/fbdev/geode/Kconfig
@@ -45,9 +45,7 @@ config FB_GEODE_GX
 config FB_GEODE_GX1
 	tristate "AMD Geode GX1 framebuffer support"
 	depends on FB && FB_GEODE
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
+	select FB_IO_HELPERS
 	select VIDEO_NOMODESET
 	help
 	  Framebuffer driver for the display controller integrated into the
diff --git a/drivers/video/fbdev/geode/gx1fb_core.c b/drivers/video/fbdev/geode/gx1fb_core.c
index ddec35e3bbeb..db009ddcdfcb 100644
--- a/drivers/video/fbdev/geode/gx1fb_core.c
+++ b/drivers/video/fbdev/geode/gx1fb_core.c
@@ -255,14 +255,11 @@ static int parse_panel_option(struct fb_info *info)
 
 static const struct fb_ops gx1fb_ops = {
 	.owner		= THIS_MODULE,
+	FB_DEFAULT_IO_OPS,
 	.fb_check_var	= gx1fb_check_var,
 	.fb_set_par	= gx1fb_set_par,
 	.fb_setcolreg	= gx1fb_setcolreg,
 	.fb_blank       = gx1fb_blank,
-	/* No HW acceleration for now. */
-	.fb_fillrect	= cfb_fillrect,
-	.fb_copyarea	= cfb_copyarea,
-	.fb_imageblit	= cfb_imageblit,
 };
 
 static struct fb_info *gx1fb_init_fbinfo(struct device *dev)
-- 
2.41.0

