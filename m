Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4227E7533AE
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 09:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235168AbjGNHwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 03:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235510AbjGNHwB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 03:52:01 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C009530E7;
        Fri, 14 Jul 2023 00:51:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4216422149;
        Fri, 14 Jul 2023 07:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1689321118; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xL43EBO5xnFODw7DI91w3TTT+ZhOge9QgOFwJtZBLCM=;
        b=uQonbdQwrxSxRB9R7XgXzaCoUwMSMRyGOewBPEpCS3GKpWAtCWMg1cPSZ/6lUG6UdfD+V/
        8hY1J+p+R/TsQclnU4ik9MmeuZe4zs4RlkF0pW2vD9ITdCYUsG4FJbJQN6c/0BSFbpsaAt
        a30g6wOrDJ+sWFAwdeKI8TiJJSniWRo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1689321118;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xL43EBO5xnFODw7DI91w3TTT+ZhOge9QgOFwJtZBLCM=;
        b=U2imgWXSb9+jHXoefnoWzaWhg6GhRZlKkRdwnStxcSULewVh7z81p5Pq+TAX6HgaRCLR1J
        p2xmB63lckne/ICw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D9B4513A92;
        Fri, 14 Jul 2023 07:51:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8JZJNJ3+sGQCQwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Fri, 14 Jul 2023 07:51:57 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     deller@gmx.de, javierm@redhat.com
Cc:     linux-sh@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-nvidia@lists.surfsouth.com,
        linux-hyperv@vger.kernel.org, linux-omap@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v3 03/18] fbdev: Remove flag FBINFO_DEFAULT from fbdev drivers
Date:   Fri, 14 Jul 2023 09:49:29 +0200
Message-ID: <20230714075155.5686-4-tzimmermann@suse.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230714075155.5686-1-tzimmermann@suse.de>
References: <20230714075155.5686-1-tzimmermann@suse.de>
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

The flag FBINFO_DEFAULT is 0 and has no effect, as struct fbinfo.flags
has been allocated to zero by kzalloc(). So do not set it.

Flags should signal differences from the default values. After cleaning
up all occurrences of FBINFO_DEFAULT, the token will be removed.

v2:
	* fix commit message (Miguel)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Russell King <linux@armlinux.org.uk>
---
 drivers/video/fbdev/controlfb.c           | 2 +-
 drivers/video/fbdev/cyber2000fb.c         | 2 +-
 drivers/video/fbdev/valkyriefb.c          | 1 -
 drivers/video/fbdev/vermilion/vermilion.c | 2 +-
 drivers/video/fbdev/vt8500lcdfb.c         | 3 +--
 5 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/controlfb.c b/drivers/video/fbdev/controlfb.c
index 82eeb139c4eb..717134c141ff 100644
--- a/drivers/video/fbdev/controlfb.c
+++ b/drivers/video/fbdev/controlfb.c
@@ -775,7 +775,7 @@ static void __init control_init_info(struct fb_info *info, struct fb_info_contro
 	info->par = &p->par;
 	info->fbops = &controlfb_ops;
 	info->pseudo_palette = p->pseudo_palette;
-        info->flags = FBINFO_DEFAULT | FBINFO_HWACCEL_YPAN;
+	info->flags = FBINFO_HWACCEL_YPAN;
 	info->screen_base = p->frame_buffer + CTRLFB_OFF;
 
 	fb_alloc_cmap(&info->cmap, 256, 0);
diff --git a/drivers/video/fbdev/cyber2000fb.c b/drivers/video/fbdev/cyber2000fb.c
index 38c0a6866d76..98ea56a9abf1 100644
--- a/drivers/video/fbdev/cyber2000fb.c
+++ b/drivers/video/fbdev/cyber2000fb.c
@@ -1459,7 +1459,7 @@ static struct cfb_info *cyberpro_alloc_fb_info(unsigned int id, char *name)
 	cfb->fb.var.accel_flags	= FB_ACCELF_TEXT;
 
 	cfb->fb.fbops		= &cyber2000fb_ops;
-	cfb->fb.flags		= FBINFO_DEFAULT | FBINFO_HWACCEL_YPAN;
+	cfb->fb.flags		= FBINFO_HWACCEL_YPAN;
 	cfb->fb.pseudo_palette	= cfb->pseudo_palette;
 
 	spin_lock_init(&cfb->reg_b0_lock);
diff --git a/drivers/video/fbdev/valkyriefb.c b/drivers/video/fbdev/valkyriefb.c
index b166b7cfe0e5..fd4488777032 100644
--- a/drivers/video/fbdev/valkyriefb.c
+++ b/drivers/video/fbdev/valkyriefb.c
@@ -535,7 +535,6 @@ static int __init valkyrie_init_info(struct fb_info *info,
 {
 	info->fbops = &valkyriefb_ops;
 	info->screen_base = p->frame_buffer + 0x1000;
-	info->flags = FBINFO_DEFAULT;
 	info->pseudo_palette = p->pseudo_palette;
 	info->par = &p->par;
 	return fb_alloc_cmap(&info->cmap, 256, 0);
diff --git a/drivers/video/fbdev/vermilion/vermilion.c b/drivers/video/fbdev/vermilion/vermilion.c
index 32e74e02a02f..71584c775efd 100644
--- a/drivers/video/fbdev/vermilion/vermilion.c
+++ b/drivers/video/fbdev/vermilion/vermilion.c
@@ -477,7 +477,7 @@ static int vml_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	}
 
 	info = &vinfo->info;
-	info->flags = FBINFO_DEFAULT | FBINFO_PARTIAL_PAN_OK;
+	info->flags = FBINFO_PARTIAL_PAN_OK;
 
 	err = vmlfb_enable_mmio(par);
 	if (err)
diff --git a/drivers/video/fbdev/vt8500lcdfb.c b/drivers/video/fbdev/vt8500lcdfb.c
index 31d4e85b220c..42d39a9d5130 100644
--- a/drivers/video/fbdev/vt8500lcdfb.c
+++ b/drivers/video/fbdev/vt8500lcdfb.c
@@ -300,8 +300,7 @@ static int vt8500lcd_probe(struct platform_device *pdev)
 	fbi->fb.var.vmode	= FB_VMODE_NONINTERLACED;
 
 	fbi->fb.fbops		= &vt8500lcd_ops;
-	fbi->fb.flags		= FBINFO_DEFAULT
-				| FBINFO_HWACCEL_COPYAREA
+	fbi->fb.flags		= FBINFO_HWACCEL_COPYAREA
 				| FBINFO_HWACCEL_FILLRECT
 				| FBINFO_HWACCEL_YPAN
 				| FBINFO_VIRTFB
-- 
2.41.0

