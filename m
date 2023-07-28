Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE37276750F
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 20:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236691AbjG1SYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 14:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233935AbjG1SYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 14:24:39 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6150C44B4;
        Fri, 28 Jul 2023 11:24:19 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 435F21F8C2;
        Fri, 28 Jul 2023 18:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690568565; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V6HSDp08sFH3VQogEpk/MpISIfsIIbRWYA94E8nkx0E=;
        b=QdXnP2f/mlkuoefOQf8AjejYtCLdQCYX7ZRHgWYxmU4fixWOwqxvIfYjkoO8gc8pxq0+5P
        EZfwho6bltAHD4oZpmjkvQr/KvOse6rDW+N4b9d5nf+0dX1MFrvycmCpPNnZpbDO8Mc0JD
        /wdc0TT6g5zPr7fZlZ2JyWvsMemr6qs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690568565;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V6HSDp08sFH3VQogEpk/MpISIfsIIbRWYA94E8nkx0E=;
        b=cF+WHwxTu5jIuq/0vR/1AiZuN7eQYazrB026pckjWoHVVEukaDESkogJrhCyIFyuSnI54o
        pD2vTSlulT43+EAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1482A13276;
        Fri, 28 Jul 2023 18:22:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id QA8+BHUHxGQ3CwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Fri, 28 Jul 2023 18:22:45 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     deller@gmx.de, javierm@redhat.com, sam@ravnborg.org
Cc:     linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        kvm@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 38/47] fbdev/sh7760fb: Use fbdev I/O helpers
Date:   Fri, 28 Jul 2023 18:40:21 +0200
Message-ID: <20230728182234.10680-39-tzimmermann@suse.de>
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
 drivers/video/fbdev/Kconfig    | 4 +---
 drivers/video/fbdev/sh7760fb.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index e55aa4f13aba..cdfe5b797d8f 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -1778,9 +1778,7 @@ config FB_SH7760
 	bool "SH7760/SH7763/SH7720/SH7721 LCDC support"
 	depends on FB && (CPU_SUBTYPE_SH7760 || CPU_SUBTYPE_SH7763 \
 		|| CPU_SUBTYPE_SH7720 || CPU_SUBTYPE_SH7721)
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
+	select FB_IO_HELPERS
 	help
 	  Support for the SH7760/SH7763/SH7720/SH7721 integrated
 	  (D)STN/TFT LCD Controller.
diff --git a/drivers/video/fbdev/sh7760fb.c b/drivers/video/fbdev/sh7760fb.c
index db898112f9a5..89866e765b04 100644
--- a/drivers/video/fbdev/sh7760fb.c
+++ b/drivers/video/fbdev/sh7760fb.c
@@ -345,13 +345,11 @@ static int sh7760fb_set_par(struct fb_info *info)
 
 static const struct fb_ops sh7760fb_ops = {
 	.owner = THIS_MODULE,
+	FB_DEFAULT_IO_OPS,
 	.fb_blank = sh7760fb_blank,
 	.fb_check_var = sh7760fb_check_var,
 	.fb_setcolreg = sh7760_setcolreg,
 	.fb_set_par = sh7760fb_set_par,
-	.fb_fillrect = cfb_fillrect,
-	.fb_copyarea = cfb_copyarea,
-	.fb_imageblit = cfb_imageblit,
 };
 
 static void sh7760fb_free_mem(struct fb_info *info)
-- 
2.41.0

