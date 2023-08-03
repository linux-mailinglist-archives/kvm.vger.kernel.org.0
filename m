Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9596776F2DE
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 20:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235417AbjHCSmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 14:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233941AbjHCSkw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 14:40:52 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597262D71;
        Thu,  3 Aug 2023 11:40:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5DC131F897;
        Thu,  3 Aug 2023 18:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1691088045; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OZqN7Pc/roMFL0AMlWydngdrYaMSJUPD5Fi0FROQWF8=;
        b=e+K56gaei6Fm9L1880PABWeMEx0f6mtJE6xJso9aLA27HNbi3fna0q5k0uSMCwNNwAZRv3
        vuO8DZ3H6BmEABe3WuZpIuqy9ssIcbrfPBClxJ1xjVUDc7brGFVkL/Rh4SqOjuQoI1Y64X
        siK94wF2fkKABt0hbSpK6h9pY3fDvic=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1691088045;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OZqN7Pc/roMFL0AMlWydngdrYaMSJUPD5Fi0FROQWF8=;
        b=61olfcOkUB7EQ22uv/NivusgJiXJOEkHvC3cwjBZl3p2GtrsVRxSEAleJzBMLJX74FBicl
        1UPg97JCoItXhCAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 26FA41333C;
        Thu,  3 Aug 2023 18:40:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GMKpCK30y2TLGAAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Thu, 03 Aug 2023 18:40:45 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     deller@gmx.de, javierm@redhat.com, sam@ravnborg.org
Cc:     linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        kvm@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH v3 29/47] fbdev/omapfb: Use fbdev I/O helpers
Date:   Thu,  3 Aug 2023 20:35:54 +0200
Message-ID: <20230803184034.6456-30-tzimmermann@suse.de>
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
 drivers/video/fbdev/omap/Kconfig       | 4 +---
 drivers/video/fbdev/omap/omapfb_main.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/omap/Kconfig b/drivers/video/fbdev/omap/Kconfig
index a6548283451f..f01278238d50 100644
--- a/drivers/video/fbdev/omap/Kconfig
+++ b/drivers/video/fbdev/omap/Kconfig
@@ -3,9 +3,7 @@ config FB_OMAP
 	tristate "OMAP frame buffer support"
 	depends on FB
 	depends on ARCH_OMAP1 || (ARM && COMPILE_TEST)
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
+	select FB_IOMEM_HELPERS
 	help
 	  Frame buffer driver for OMAP based boards.
 
diff --git a/drivers/video/fbdev/omap/omapfb_main.c b/drivers/video/fbdev/omap/omapfb_main.c
index 783bbe026207..f28cb90947a3 100644
--- a/drivers/video/fbdev/omap/omapfb_main.c
+++ b/drivers/video/fbdev/omap/omapfb_main.c
@@ -1216,13 +1216,11 @@ static int omapfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
  */
 static struct fb_ops omapfb_ops = {
 	.owner		= THIS_MODULE,
+	FB_DEFAULT_IOMEM_OPS,
 	.fb_open        = omapfb_open,
 	.fb_release     = omapfb_release,
 	.fb_setcolreg	= omapfb_setcolreg,
 	.fb_setcmap	= omapfb_setcmap,
-	.fb_fillrect	= cfb_fillrect,
-	.fb_copyarea	= cfb_copyarea,
-	.fb_imageblit	= cfb_imageblit,
 	.fb_blank       = omapfb_blank,
 	.fb_ioctl	= omapfb_ioctl,
 	.fb_check_var	= omapfb_check_var,
-- 
2.41.0

