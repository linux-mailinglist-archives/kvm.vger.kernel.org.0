Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14E476B0DA
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 12:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbjHAKQT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 06:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbjHAKQC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 06:16:02 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A891B7;
        Tue,  1 Aug 2023 03:15:50 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 66A6921DE2;
        Tue,  1 Aug 2023 10:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690884948; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vNnMD4aI3WpDOFhKR8FlIsi2xefaxpGkXdXuT6IvU4I=;
        b=eykwveeGeJj+A/vFHWGsS8DP6IxYQ2I3ETmDE3DxGOZd9DJ6ggqJUTffODOFDoz8g7Dnc7
        VD+ZAf/Z2QjrMyEPsgw233LkCNu69ctRiaP4RunXpyoEe9AEiguyJzoEYSeyC84ZtParpa
        pEVi9z0JGpqHb/L9lRh1vVyrZk79Ocg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690884948;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vNnMD4aI3WpDOFhKR8FlIsi2xefaxpGkXdXuT6IvU4I=;
        b=CMqstDW1cVFr108glxHA3gKX0YzVre7S+I62L4+z/ZleqwZ3MqQkxA7+ChedAtZoFSmRUL
        4olCTRTmjSCknlAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 317AE139BD;
        Tue,  1 Aug 2023 10:15:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id QE8zC1TbyGQBXQAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Tue, 01 Aug 2023 10:15:48 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     deller@gmx.de, javierm@redhat.com, sam@ravnborg.org
Cc:     linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        kvm@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH v2 05/47] fbdev/aty128fb: Use fbdev I/O helpers
Date:   Tue,  1 Aug 2023 12:13:10 +0200
Message-ID: <20230801101541.900-6-tzimmermann@suse.de>
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
 drivers/video/fbdev/Kconfig        | 4 +---
 drivers/video/fbdev/aty/aty128fb.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index 850d5c07587f..ea24f8114ac7 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -1098,10 +1098,8 @@ config FB_RADEON_DEBUG
 config FB_ATY128
 	tristate "ATI Rage128 display support"
 	depends on FB && PCI
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
 	select FB_BACKLIGHT if FB_ATY128_BACKLIGHT
+	select FB_IOMEM_HELPERS
 	select FB_MACMODES if PPC_PMAC
 	select VIDEO_NOMODESET
 	help
diff --git a/drivers/video/fbdev/aty/aty128fb.c b/drivers/video/fbdev/aty/aty128fb.c
index b44fc78ccd4f..f4de11f19235 100644
--- a/drivers/video/fbdev/aty/aty128fb.c
+++ b/drivers/video/fbdev/aty/aty128fb.c
@@ -504,6 +504,7 @@ static void aty128_bl_set_power(struct fb_info *info, int power);
 
 static const struct fb_ops aty128fb_ops = {
 	.owner		= THIS_MODULE,
+	FB_DEFAULT_IOMEM_OPS,
 	.fb_check_var	= aty128fb_check_var,
 	.fb_set_par	= aty128fb_set_par,
 	.fb_setcolreg	= aty128fb_setcolreg,
@@ -511,9 +512,6 @@ static const struct fb_ops aty128fb_ops = {
 	.fb_blank	= aty128fb_blank,
 	.fb_ioctl	= aty128fb_ioctl,
 	.fb_sync	= aty128fb_sync,
-	.fb_fillrect	= cfb_fillrect,
-	.fb_copyarea	= cfb_copyarea,
-	.fb_imageblit	= cfb_imageblit,
 };
 
     /*
-- 
2.41.0

