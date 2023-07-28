Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C2E7674E3
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 20:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbjG1SYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 14:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235047AbjG1SYO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 14:24:14 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1625B46BE;
        Fri, 28 Jul 2023 11:23:57 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 04A5C1F8BB;
        Fri, 28 Jul 2023 18:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690568563; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QBkUnk6VUz+zM3Q+7NTP+c1OjNwJ9Y4qgQ8Bsx0KOp0=;
        b=jvcKHvy3t9X9crDaVvy/9Znw9U5CIRcc1vNryeHDjFQUz4h1I8PYP1K4TB1yCkRMGid/Dc
        C/nlfjX80WPcT0JioGmxveQcRsl4K3/O2PDrvCa1cZ5WC7itOoB2Eq+iL/RF4UJV6NRgiH
        Y2W+rqRdbhUTU3xtM8KscG3pPwAv464=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690568563;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QBkUnk6VUz+zM3Q+7NTP+c1OjNwJ9Y4qgQ8Bsx0KOp0=;
        b=itjNu3pRvbXEKybCzyh2XiLwPebcxoyYu7MM4fqm/N/1lumGuxqgbNdyQQrcwT91Cv8p8R
        9ZRINRwb2F3kjJDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C97D713276;
        Fri, 28 Jul 2023 18:22:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qGZrMHIHxGQ3CwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Fri, 28 Jul 2023 18:22:42 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     deller@gmx.de, javierm@redhat.com, sam@ravnborg.org
Cc:     linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        kvm@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 27/47] fbdev/ocfb: Use fbdev I/O helpers
Date:   Fri, 28 Jul 2023 18:40:10 +0200
Message-ID: <20230728182234.10680-28-tzimmermann@suse.de>
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
 drivers/video/fbdev/Kconfig | 4 +---
 drivers/video/fbdev/ocfb.c  | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index ffc621dbe6b4..0ba3d0f0ef88 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -672,9 +672,7 @@ config FB_PVR2
 config FB_OPENCORES
 	tristate "OpenCores VGA/LCD core 2.0 framebuffer support"
 	depends on FB && HAS_DMA
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
+	select FB_IO_HELPERS
 	help
 	  This enables support for the OpenCores VGA/LCD core.
 
diff --git a/drivers/video/fbdev/ocfb.c b/drivers/video/fbdev/ocfb.c
index 7ebe794583e1..93c0dad56da1 100644
--- a/drivers/video/fbdev/ocfb.c
+++ b/drivers/video/fbdev/ocfb.c
@@ -287,10 +287,8 @@ static int ocfb_init_var(struct ocfb_dev *fbdev)
 
 static const struct fb_ops ocfb_ops = {
 	.owner		= THIS_MODULE,
+	FB_DEFAULT_IO_OPS,
 	.fb_setcolreg	= ocfb_setcolreg,
-	.fb_fillrect	= cfb_fillrect,
-	.fb_copyarea	= cfb_copyarea,
-	.fb_imageblit	= cfb_imageblit,
 };
 
 static int ocfb_probe(struct platform_device *pdev)
-- 
2.41.0

