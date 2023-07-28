Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 521D8767556
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 20:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236787AbjG1S0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 14:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236774AbjG1SZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 14:25:25 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7CD44A1;
        Fri, 28 Jul 2023 11:25:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E49A61F8C4;
        Fri, 28 Jul 2023 18:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690568566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9t49TG3tdz3dclsUxP/ZsniQP+Xid5EeomRIjBjbq1Q=;
        b=sxRN9sw51QT6SKJ/gxgr8eUqMfn5sDpsPiuG2qQvZKmRD17QPAQ5Wg+qCCoXBmDB8n2ABN
        vyJI0sdiVCR9UV1vUdTeqpZ1CwbY0dRhp8iXmNUN/EMf58xSUSPQXfcEniwd6oG2xsrgiV
        59Tf7WkO7WMvIHC6eCLKeX9AbE0Qe40=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690568566;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9t49TG3tdz3dclsUxP/ZsniQP+Xid5EeomRIjBjbq1Q=;
        b=8PSL4tAZC7PhOQMe3mh/bEbLL/8XxAWycmXMEJd27XFk3XmSiQR9Pf0ZbI1k/wR1WT0W/n
        hRsbrUl0vLHyFkCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B0248139BD;
        Fri, 28 Jul 2023 18:22:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qCQdKnYHxGQ3CwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Fri, 28 Jul 2023 18:22:46 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     deller@gmx.de, javierm@redhat.com, sam@ravnborg.org
Cc:     linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        kvm@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 45/47] fbdev/vesafb: Use fbdev I/O helpers
Date:   Fri, 28 Jul 2023 18:40:28 +0200
Message-ID: <20230728182234.10680-46-tzimmermann@suse.de>
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
 drivers/video/fbdev/Kconfig  | 4 +---
 drivers/video/fbdev/vesafb.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index d81c376012ad..b0cb2d38415c 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -453,9 +453,7 @@ config FB_VESA
 	bool "VESA VGA graphics support"
 	depends on (FB = y) && X86
 	select APERTURE_HELPERS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
+	select FB_IO_HELPERS
 	select SYSFB
 	help
 	  This is the frame buffer device driver for generic VESA 2.0
diff --git a/drivers/video/fbdev/vesafb.c b/drivers/video/fbdev/vesafb.c
index 422a1c53decd..3cad5dd716ed 100644
--- a/drivers/video/fbdev/vesafb.c
+++ b/drivers/video/fbdev/vesafb.c
@@ -201,12 +201,10 @@ static void vesafb_destroy(struct fb_info *info)
 
 static struct fb_ops vesafb_ops = {
 	.owner		= THIS_MODULE,
+	FB_DEFAULT_IO_OPS,
 	.fb_destroy     = vesafb_destroy,
 	.fb_setcolreg	= vesafb_setcolreg,
 	.fb_pan_display	= vesafb_pan_display,
-	.fb_fillrect	= cfb_fillrect,
-	.fb_copyarea	= cfb_copyarea,
-	.fb_imageblit	= cfb_imageblit,
 };
 
 static int vesafb_setup(char *options)
-- 
2.41.0

