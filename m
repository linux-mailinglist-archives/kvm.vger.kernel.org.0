Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6AF7674B7
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 20:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236451AbjG1SXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 14:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236357AbjG1SXs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 14:23:48 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B0444A5;
        Fri, 28 Jul 2023 11:23:24 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 697FE2198F;
        Fri, 28 Jul 2023 18:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690568560; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BBtDs6erx0729IKTxv/z5Rm/SZum3oEwi+YiwomwS6g=;
        b=0jJxdcBJB/GASKq/Zdq4DDACViiA7f3Gg6C+U7FXavR7YZvrIfxS2G7qvzxVJcYoKy29wb
        rmhtHlwj8DzCBT/GqEy0wRTd0NtRrfrInTgl7L67BS2LTaFRRPeC3DDxC9yjbptcM2trRz
        6BxNOzovje55PJXSMLgBAc1SSLDQVT0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690568560;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BBtDs6erx0729IKTxv/z5Rm/SZum3oEwi+YiwomwS6g=;
        b=hrJWJ6XQG15X6XizcKmNY3nQ8ErcyKfDUTOrVG6XtwWI8yg6tKOvyycf3ZZBjekFDvONIf
        FKbFXN5Oa3UhYqAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 35683139BD;
        Fri, 28 Jul 2023 18:22:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6DoXDHAHxGQ3CwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Fri, 28 Jul 2023 18:22:40 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     deller@gmx.de, javierm@redhat.com, sam@ravnborg.org
Cc:     linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        kvm@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 16/47] fbdev/goldfishfb: Use fbdev I/O helpers
Date:   Fri, 28 Jul 2023 18:39:59 +0200
Message-ID: <20230728182234.10680-17-tzimmermann@suse.de>
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
---
 drivers/video/fbdev/Kconfig      | 4 +---
 drivers/video/fbdev/goldfishfb.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index b08e632586a9..69c1503f6358 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -1800,9 +1800,7 @@ config FB_GOLDFISH
 	tristate "Goldfish Framebuffer"
 	depends on FB
 	depends on GOLDFISH || COMPILE_TEST
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
+	select FB_IO_HELPERS
 	help
 	  Framebuffer driver for Goldfish Virtual Platform
 
diff --git a/drivers/video/fbdev/goldfishfb.c b/drivers/video/fbdev/goldfishfb.c
index ef2528c3faa9..8b48e8805bca 100644
--- a/drivers/video/fbdev/goldfishfb.c
+++ b/drivers/video/fbdev/goldfishfb.c
@@ -162,14 +162,12 @@ static int goldfish_fb_blank(int blank, struct fb_info *info)
 
 static const struct fb_ops goldfish_fb_ops = {
 	.owner          = THIS_MODULE,
+	FB_DEFAULT_IO_OPS,
 	.fb_check_var   = goldfish_fb_check_var,
 	.fb_set_par     = goldfish_fb_set_par,
 	.fb_setcolreg   = goldfish_fb_setcolreg,
 	.fb_pan_display = goldfish_fb_pan_display,
 	.fb_blank	= goldfish_fb_blank,
-	.fb_fillrect    = cfb_fillrect,
-	.fb_copyarea    = cfb_copyarea,
-	.fb_imageblit   = cfb_imageblit,
 };
 
 
-- 
2.41.0

