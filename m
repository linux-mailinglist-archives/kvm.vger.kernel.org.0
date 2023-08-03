Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A5976F24E
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 20:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234996AbjHCSlE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 14:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbjHCSku (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 14:40:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164BE30FD;
        Thu,  3 Aug 2023 11:40:46 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 639BC1F891;
        Thu,  3 Aug 2023 18:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1691088044; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aCm0gSeEdso493MPkGH/lHDOM868nilCn6Nlg50+/Ng=;
        b=qtYSxsnCRcxZe9Oxkxp1q6c3IgiAhbgPsKcEbS0OpRmb8vFX28pM+9/WEB6vUcwkRArabK
        0BpoPJQrXGIsbMpWWTe0VtVQTINk8xl8FX3UHMvnuEiPAQjL5fMdaeXMzdA1XSDBHgM6Uw
        QJGRMuxdViBSTqdj11q+uZ4blIuGOvA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1691088044;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aCm0gSeEdso493MPkGH/lHDOM868nilCn6Nlg50+/Ng=;
        b=6xdSqE/2UNfHWj/q/e4cbWnJk9QLwjqaHY33ZTdCgzVgwcqJMWV43OPq28KgmMWcLmuH0L
        x2iNkGN3/TtBpzBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2D8F91333C;
        Thu,  3 Aug 2023 18:40:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SBI8Cqz0y2TLGAAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Thu, 03 Aug 2023 18:40:44 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     deller@gmx.de, javierm@redhat.com, sam@ravnborg.org
Cc:     linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        kvm@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH v3 25/47] fbdev/mmpfb: Use fbdev I/O helpers
Date:   Thu,  3 Aug 2023 20:35:50 +0200
Message-ID: <20230803184034.6456-26-tzimmermann@suse.de>
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

