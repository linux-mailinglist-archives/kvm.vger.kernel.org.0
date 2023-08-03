Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1539F76F208
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 20:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbjHCSkq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 14:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbjHCSkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 14:40:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBF82D45;
        Thu,  3 Aug 2023 11:40:39 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 40BA321941;
        Thu,  3 Aug 2023 18:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1691088038; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rsfHzEmcWbJAJjqVCoJIzdgJwYXNTRfIrd9e2fBso+A=;
        b=ceSDqgul6H+Ir2CjYSNoeC+RLrpjvdAS5tavYJn5is7lL+dQN79yqE/4sk1rMG853WkWN5
        +DJggKFpeDTeq3ysz8PElibq7jtNDwsjsqjo7l8TniceJtT3KJ+YVatRPQ8aHYPpsqBgZ1
        L0Zjy0zQFuj5tx1ydv1OgA8bZrx2ugA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1691088038;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rsfHzEmcWbJAJjqVCoJIzdgJwYXNTRfIrd9e2fBso+A=;
        b=mzxW+Y28hWI342Zvcu05LRP/pX1KwxvzNlsL8dYgOqQtHEdqMJwKoxCTuz5+9h4fZWTIv2
        C1DhzffhtXzbPKBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EEF2D139BD;
        Thu,  3 Aug 2023 18:40:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oClwOaX0y2TLGAAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Thu, 03 Aug 2023 18:40:37 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     deller@gmx.de, javierm@redhat.com, sam@ravnborg.org
Cc:     linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        kvm@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v3 01/47] media/vivid: Use fbdev I/O helpers
Date:   Thu,  3 Aug 2023 20:35:26 +0200
Message-ID: <20230803184034.6456-2-tzimmermann@suse.de>
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
Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Helge Deller <deller@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
---
 drivers/media/test-drivers/vivid/Kconfig     | 4 +---
 drivers/media/test-drivers/vivid/vivid-osd.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/test-drivers/vivid/Kconfig b/drivers/media/test-drivers/vivid/Kconfig
index 318799d317ba..5b08a5ad291e 100644
--- a/drivers/media/test-drivers/vivid/Kconfig
+++ b/drivers/media/test-drivers/vivid/Kconfig
@@ -3,11 +3,9 @@ config VIDEO_VIVID
 	tristate "Virtual Video Test Driver"
 	depends on VIDEO_DEV && !SPARC32 && !SPARC64 && FB
 	depends on HAS_DMA
+	select FB_IOMEM_HELPERS
 	select FONT_SUPPORT
 	select FONT_8x16
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
 	select VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEO_V4L2_TPG
diff --git a/drivers/media/test-drivers/vivid/vivid-osd.c b/drivers/media/test-drivers/vivid/vivid-osd.c
index 051f1805a16d..5c931b94a7b5 100644
--- a/drivers/media/test-drivers/vivid/vivid-osd.c
+++ b/drivers/media/test-drivers/vivid/vivid-osd.c
@@ -246,12 +246,10 @@ static int vivid_fb_blank(int blank_mode, struct fb_info *info)
 
 static const struct fb_ops vivid_fb_ops = {
 	.owner = THIS_MODULE,
+	FB_DEFAULT_IOMEM_OPS,
 	.fb_check_var   = vivid_fb_check_var,
 	.fb_set_par     = vivid_fb_set_par,
 	.fb_setcolreg   = vivid_fb_setcolreg,
-	.fb_fillrect    = cfb_fillrect,
-	.fb_copyarea    = cfb_copyarea,
-	.fb_imageblit   = cfb_imageblit,
 	.fb_cursor      = NULL,
 	.fb_ioctl       = vivid_fb_ioctl,
 	.fb_pan_display = vivid_fb_pan_display,
-- 
2.41.0

