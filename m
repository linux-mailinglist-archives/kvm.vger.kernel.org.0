Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C1476B193
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 12:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbjHAKTK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 06:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbjHAKQK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 06:16:10 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BF01728;
        Tue,  1 Aug 2023 03:15:55 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 86F5021E35;
        Tue,  1 Aug 2023 10:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690884953; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uKTw3rS6FZqDeitKmg9wTC2EsTbl+GBTi2n213Yg/y4=;
        b=o+039nTSsrXeJMEnyWI7umk6U1WvhkSjymxVIKv+3encit6kXTtuDEkDAimyrSqhQ44xrx
        FMmEm/8LgO0i6jECVxyPeQFECk/5TeeB5nVx30JOecLsb0HFjBMxom34qy6Y1l/mubex2q
        3MvO/Ftrh4vLtt5lknJJuPmjCbCQlIM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690884953;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uKTw3rS6FZqDeitKmg9wTC2EsTbl+GBTi2n213Yg/y4=;
        b=Pwk7DjHYb6RVRjlF/XnpYm2aPBbbBFLDvLh+f8f8VNRwQ65FGquVrPW9hVCCAOtB7vgPEd
        Qk6iERHsnEVgHJBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5076C139BD;
        Tue,  1 Aug 2023 10:15:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WOm/ElnbyGQBXQAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Tue, 01 Aug 2023 10:15:53 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     deller@gmx.de, javierm@redhat.com, sam@ravnborg.org
Cc:     linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        kvm@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH v2 25/47] fbdev/mmpfb: Use fbdev I/O helpers
Date:   Tue,  1 Aug 2023 12:13:30 +0200
Message-ID: <20230801101541.900-26-tzimmermann@suse.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801101541.900-1-tzimmermann@suse.de>
References: <20230801101541.900-1-tzimmermann@suse.de>
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

v2:
	* updated to use _IOMEM_ tokens

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Helge Deller <deller@gmx.de>
---
 drivers/video/fbdev/mmp/fb/Kconfig | 4 +---
 drivers/video/fbdev/mmp/fb/mmpfb.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/mmp/fb/Kconfig b/drivers/video/fbdev/mmp/fb/Kconfig
index 0ec2e3fb9e17..b13882b34e79 100644
--- a/drivers/video/fbdev/mmp/fb/Kconfig
+++ b/drivers/video/fbdev/mmp/fb/Kconfig
@@ -2,9 +2,7 @@
 config MMP_FB
 	tristate "fb driver for Marvell MMP Display Subsystem"
 	depends on FB
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
+	select FB_IOMEM_HELPERS
 	default y
 	help
 		fb driver for Marvell MMP Display Subsystem
diff --git a/drivers/video/fbdev/mmp/fb/mmpfb.c b/drivers/video/fbdev/mmp/fb/mmpfb.c
index ac9db01f29f2..42a87474bcea 100644
--- a/drivers/video/fbdev/mmp/fb/mmpfb.c
+++ b/drivers/video/fbdev/mmp/fb/mmpfb.c
@@ -454,14 +454,12 @@ static int mmpfb_blank(int blank, struct fb_info *info)
 
 static const struct fb_ops mmpfb_ops = {
 	.owner		= THIS_MODULE,
+	FB_DEFAULT_IOMEM_OPS,
 	.fb_blank	= mmpfb_blank,
 	.fb_check_var	= mmpfb_check_var,
 	.fb_set_par	= mmpfb_set_par,
 	.fb_setcolreg	= mmpfb_setcolreg,
 	.fb_pan_display	= mmpfb_pan_display,
-	.fb_fillrect	= cfb_fillrect,
-	.fb_copyarea	= cfb_copyarea,
-	.fb_imageblit	= cfb_imageblit,
 };
 
 static int modes_setup(struct mmpfb_info *fbi)
-- 
2.41.0

