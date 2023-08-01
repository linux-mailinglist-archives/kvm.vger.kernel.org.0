Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F1D76B180
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 12:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbjHAKRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 06:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234025AbjHAKQQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 06:16:16 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B54A114;
        Tue,  1 Aug 2023 03:16:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 537D021E52;
        Tue,  1 Aug 2023 10:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690884957; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p4GF8G36pwLZCVfWUyIFNyu8z8x/NIX9YCQDlW8SZYY=;
        b=fBhvcKfLP+Rlw+ZGy6uqxrhCZIYsNf497pf+pR67fIuHTAuOiauPbmOx1PEAGopQy5w/t7
        Uh/oS6/zQ2BvOXHYfyA3/lOS0Pj6sDtToH96fL8RHL/ejXrbV/gIiITeSoZwt9Z1eDaa97
        9xI3MlKqxaMp/9wez36KNl+cpbMilrk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690884957;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p4GF8G36pwLZCVfWUyIFNyu8z8x/NIX9YCQDlW8SZYY=;
        b=o5jhYfDK6rJBQxTjSkV55m8suSFEhppkIVfdLSWSz9+4xmHjYbgv4yUck5S2frJCMFlyqt
        49dQEQ+z6OjRcaBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1B1FE139BD;
        Tue,  1 Aug 2023 10:15:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qM61BV3byGQBXQAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Tue, 01 Aug 2023 10:15:57 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     deller@gmx.de, javierm@redhat.com, sam@ravnborg.org
Cc:     linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        kvm@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH v2 40/47] fbdev/sstfb: Use fbdev I/O helpers
Date:   Tue,  1 Aug 2023 12:13:45 +0200
Message-ID: <20230801101541.900-41-tzimmermann@suse.de>
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
 drivers/video/fbdev/Kconfig | 4 +---
 drivers/video/fbdev/sstfb.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index 9b11a394bd82..ba02a31977d4 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -1340,9 +1340,7 @@ config FB_VOODOO1
 	tristate "3Dfx Voodoo Graphics (sst1) support"
 	depends on FB && PCI
 	depends on FB_DEVICE
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
+	select FB_IOMEM_HELPERS
 	select VIDEO_NOMODESET
 	help
 	  Say Y here if you have a 3Dfx Voodoo Graphics (Voodoo1/sst1) or
diff --git a/drivers/video/fbdev/sstfb.c b/drivers/video/fbdev/sstfb.c
index 8d2b1d60dd2e..f8ae54ca0cc3 100644
--- a/drivers/video/fbdev/sstfb.c
+++ b/drivers/video/fbdev/sstfb.c
@@ -1310,12 +1310,10 @@ static int sstfb_setup(char *options)
 
 static const struct fb_ops sstfb_ops = {
 	.owner		= THIS_MODULE,
+	FB_DEFAULT_IOMEM_OPS,
 	.fb_check_var	= sstfb_check_var,
 	.fb_set_par	= sstfb_set_par,
 	.fb_setcolreg	= sstfb_setcolreg,
-	.fb_fillrect	= cfb_fillrect, /* sstfb_fillrect */
-	.fb_copyarea	= cfb_copyarea, /* sstfb_copyarea */
-	.fb_imageblit	= cfb_imageblit,
 	.fb_ioctl	= sstfb_ioctl,
 };
 
-- 
2.41.0

