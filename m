Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFEE767513
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 20:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbjG1SYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 14:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235855AbjG1SYp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 14:24:45 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6683D46A0;
        Fri, 28 Jul 2023 11:24:21 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E232321996;
        Fri, 28 Jul 2023 18:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690568560; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GMXi8CXlF60aOtFAiLiWTVUiZsrn9tM6TmEFfCe7+Do=;
        b=f+JPnauWFv+XFNMSIGHUorBJKMpqkBqwZXmIuHBv/odACImR9eR2J6+dUkAEhbqnEqc2Nq
        QiX1m1lfWfzcOFxqGpNKOAvP6nXfYFsJYZVR7nrgnDu2CxLc2SMEihETzAp6VABfVtuHpo
        8/8Yi4FfThv4gqagpthq6/8ZLePiKoQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690568560;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GMXi8CXlF60aOtFAiLiWTVUiZsrn9tM6TmEFfCe7+Do=;
        b=0bGR9SPmMuLNgRneXBY+ydeEfpR0mIftdb+EEODtO6hFhSV17QSEw6XrmkQBFAxOeF5sC8
        CvLAM5n8WGdU6nBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A906D139BD;
        Fri, 28 Jul 2023 18:22:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EABPKHAHxGQ3CwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Fri, 28 Jul 2023 18:22:40 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     deller@gmx.de, javierm@redhat.com, sam@ravnborg.org
Cc:     linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        kvm@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 18/47] fbdev/gxt4500: Use fbdev I/O helpers
Date:   Fri, 28 Jul 2023 18:40:01 +0200
Message-ID: <20230728182234.10680-19-tzimmermann@suse.de>
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
 drivers/video/fbdev/Kconfig   | 4 +---
 drivers/video/fbdev/gxt4500.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index a7fe64fe2582..2484235ac117 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -1752,9 +1752,7 @@ config FB_UDL
 config FB_IBM_GXT4500
 	tristate "Framebuffer support for IBM GXT4000P/4500P/6000P/6500P adaptors"
 	depends on FB
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
+	select FB_IO_HELPERS
 	select VIDEO_NOMODESET
 	help
 	  Say Y here to enable support for the IBM GXT4000P/6000P and
diff --git a/drivers/video/fbdev/gxt4500.c b/drivers/video/fbdev/gxt4500.c
index 8d0976578ddf..f52bb24ed7d5 100644
--- a/drivers/video/fbdev/gxt4500.c
+++ b/drivers/video/fbdev/gxt4500.c
@@ -602,14 +602,12 @@ static const struct fb_fix_screeninfo gxt4500_fix = {
 
 static const struct fb_ops gxt4500_ops = {
 	.owner = THIS_MODULE,
+	FB_DEFAULT_IO_OPS,
 	.fb_check_var = gxt4500_check_var,
 	.fb_set_par = gxt4500_set_par,
 	.fb_setcolreg = gxt4500_setcolreg,
 	.fb_pan_display = gxt4500_pan_display,
 	.fb_blank = gxt4500_blank,
-	.fb_fillrect = cfb_fillrect,
-	.fb_copyarea = cfb_copyarea,
-	.fb_imageblit = cfb_imageblit,
 };
 
 /* PCI functions */
-- 
2.41.0

