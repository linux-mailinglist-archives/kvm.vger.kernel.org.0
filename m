Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1A97674D8
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 20:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236441AbjG1SYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 14:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236595AbjG1SYI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 14:24:08 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E7644A5;
        Fri, 28 Jul 2023 11:23:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 34C0021991;
        Fri, 28 Jul 2023 18:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690568559; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D9V/h3LRgrAhT6RW9phgWATQ91uIGsCOx4xHPfH93yg=;
        b=z0fLQ+NkmjGHxuRX6hTQ5MCbltlYTLSFWf3C1eI2aoXNzaO6D0AVOsr8FTXHdWAsGIPFPM
        uOJYuZKULRSOr8p0VaZNgp+qp+do42IPY9Qa4Bek3Fh4UtpQh4MTuiTpr+C459cq0ERgcp
        5eJ5pPARRZ94ttIRABUEhEgurRcTahc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690568559;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D9V/h3LRgrAhT6RW9phgWATQ91uIGsCOx4xHPfH93yg=;
        b=v3wn31XZnfsIM2/i3uXcQuGaYW/V0otFEswovDGfz0f1a0U0h5fr2jhMXs/MEArsreDG7j
        PV/IMcGvkTmNOcCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id ED8C0139BD;
        Fri, 28 Jul 2023 18:22:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UIMCOW4HxGQ3CwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Fri, 28 Jul 2023 18:22:38 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     deller@gmx.de, javierm@redhat.com, sam@ravnborg.org
Cc:     linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        kvm@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Timur Tabi <timur@kernel.org>
Subject: [PATCH 11/47] fbdev/fsl-diu-fb: Use fbdev I/O helpers
Date:   Fri, 28 Jul 2023 18:39:54 +0200
Message-ID: <20230728182234.10680-12-tzimmermann@suse.de>
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
Cc: Timur Tabi <timur@kernel.org>
---
 drivers/video/fbdev/Kconfig      | 4 +---
 drivers/video/fbdev/fsl-diu-fb.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index e5fe33cb7909..aa92a9c6a801 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -1661,10 +1661,8 @@ config PXA3XX_GCU
 config FB_FSL_DIU
 	tristate "Freescale DIU framebuffer support"
 	depends on FB && FSL_SOC
+	select FB_IO_HELPERS
 	select FB_MODE_HELPERS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
 	select PPC_LIB_RHEAP
 	help
 	  Framebuffer driver for the Freescale SoC DIU
diff --git a/drivers/video/fbdev/fsl-diu-fb.c b/drivers/video/fbdev/fsl-diu-fb.c
index c62b48f27ba9..422e4168e37d 100644
--- a/drivers/video/fbdev/fsl-diu-fb.c
+++ b/drivers/video/fbdev/fsl-diu-fb.c
@@ -1451,13 +1451,11 @@ static int fsl_diu_release(struct fb_info *info, int user)
 
 static const struct fb_ops fsl_diu_ops = {
 	.owner = THIS_MODULE,
+	FB_DEFAULT_IO_OPS,
 	.fb_check_var = fsl_diu_check_var,
 	.fb_set_par = fsl_diu_set_par,
 	.fb_setcolreg = fsl_diu_setcolreg,
 	.fb_pan_display = fsl_diu_pan_display,
-	.fb_fillrect = cfb_fillrect,
-	.fb_copyarea = cfb_copyarea,
-	.fb_imageblit = cfb_imageblit,
 	.fb_ioctl = fsl_diu_ioctl,
 	.fb_open = fsl_diu_open,
 	.fb_release = fsl_diu_release,
-- 
2.41.0

