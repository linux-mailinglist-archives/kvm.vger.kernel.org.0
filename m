Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8BF176F2E5
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 20:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235503AbjHCSmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 14:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbjHCSkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 14:40:46 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF392D4C;
        Thu,  3 Aug 2023 11:40:43 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DF7252196E;
        Thu,  3 Aug 2023 18:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1691088041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Td1/Qj2/pz3diy21E/DN1ypT6S8tpHvGa3amB9hoOp4=;
        b=Ot03Cz4Q0j1qOKbhH2VakZPsGzwZRC7cslMTyg6flulssM6e4GP36VVHPDMyXt0BDRfE9O
        LOajcOjp+fmpJb6Ijk1G1ZskJTodY9Mzo4lRj8vyVsVYtkzCFS6QI35j61cWMV+ARVARgz
        r+Gp8CukWZ5MZoMpEUDEjJ554eoD634=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1691088041;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Td1/Qj2/pz3diy21E/DN1ypT6S8tpHvGa3amB9hoOp4=;
        b=MjMgjShhHUapkgGySafxSEQ2wM8Z6zqKs1qhZ/kCPx3BCoSKi0qPse82OXmlID+KjMrRan
        dmlhqi641cS68NCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A2E641333C;
        Thu,  3 Aug 2023 18:40:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oNbaJqn0y2TLGAAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Thu, 03 Aug 2023 18:40:41 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     deller@gmx.de, javierm@redhat.com, sam@ravnborg.org
Cc:     linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        kvm@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Andres Salomon <dilinger@queued.net>
Subject: [PATCH v3 15/47] fbdev/geode/lxfb: Use fbdev I/O helpers
Date:   Thu,  3 Aug 2023 20:35:40 +0200
Message-ID: <20230803184034.6456-16-tzimmermann@suse.de>
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
Cc: Andres Salomon <dilinger@queued.net>
---
 drivers/video/fbdev/geode/Kconfig     | 4 +---
 drivers/video/fbdev/geode/lxfb_core.c | 5 +----
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/video/fbdev/geode/Kconfig b/drivers/video/fbdev/geode/Kconfig
index 957ef0756ced..9a49916e0492 100644
--- a/drivers/video/fbdev/geode/Kconfig
+++ b/drivers/video/fbdev/geode/Kconfig
@@ -13,9 +13,7 @@ config FB_GEODE
 config FB_GEODE_LX
 	tristate "AMD Geode LX framebuffer support"
 	depends on FB && FB_GEODE
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
+	select FB_IOMEM_HELPERS
 	select VIDEO_NOMODESET
 	help
 	  Framebuffer driver for the display controller integrated into the
diff --git a/drivers/video/fbdev/geode/lxfb_core.c b/drivers/video/fbdev/geode/lxfb_core.c
index b70b286f43e4..cad99f5b7fe8 100644
--- a/drivers/video/fbdev/geode/lxfb_core.c
+++ b/drivers/video/fbdev/geode/lxfb_core.c
@@ -392,14 +392,11 @@ static int lxfb_map_video_memory(struct fb_info *info, struct pci_dev *dev)
 
 static const struct fb_ops lxfb_ops = {
 	.owner		= THIS_MODULE,
+	FB_DEFAULT_IOMEM_OPS,
 	.fb_check_var	= lxfb_check_var,
 	.fb_set_par	= lxfb_set_par,
 	.fb_setcolreg	= lxfb_setcolreg,
 	.fb_blank       = lxfb_blank,
-	/* No HW acceleration for now. */
-	.fb_fillrect	= cfb_fillrect,
-	.fb_copyarea	= cfb_copyarea,
-	.fb_imageblit	= cfb_imageblit,
 };
 
 static struct fb_info *lxfb_init_fbinfo(struct device *dev)
-- 
2.41.0

