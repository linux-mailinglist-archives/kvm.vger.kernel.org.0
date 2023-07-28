Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479287674A7
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 20:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbjG1SXi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 14:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233880AbjG1SXg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 14:23:36 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992441FC4;
        Fri, 28 Jul 2023 11:23:15 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0179E2198D;
        Fri, 28 Jul 2023 18:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690568559; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=inkYYvvEFppg8AIMbhLy5elNFC7aFHKDR/CVQldJr3w=;
        b=y0AYz/Et3qZlX/MXPlH3lsbQeKiOLY757+waHlnqX9UqzzRYjbkqxY8MKQ5oTtQCffwNky
        +YAVfzfn10YTE9r2M280ugLaJEoW00MoJAlya/mV1fxTEHJgPw9FdtD88r9HwSltmkKeun
        PKZ2GARh1mYe5MCS3CpAhq7oSr+2W5o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690568559;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=inkYYvvEFppg8AIMbhLy5elNFC7aFHKDR/CVQldJr3w=;
        b=Yu5UwuY9oRSV/jvokCTDXgAZ2JrCPEzYVez4nnvdTysZHjSC9zr4YorGRtUMY8CIMC+6rd
        zjH/4fQ7heRLM5Dg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B2E2C13276;
        Fri, 28 Jul 2023 18:22:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0EavKm4HxGQ3CwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Fri, 28 Jul 2023 18:22:38 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     deller@gmx.de, javierm@redhat.com, sam@ravnborg.org
Cc:     linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        kvm@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 10/47] fbdev/fm2fb: Use fbdev I/O helpers
Date:   Fri, 28 Jul 2023 18:39:53 +0200
Message-ID: <20230728182234.10680-11-tzimmermann@suse.de>
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
 drivers/video/fbdev/fm2fb.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index 62e24e47b677..e5fe33cb7909 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -269,9 +269,7 @@ config FB_AMIGA_AGA
 config FB_FM2
 	bool "Amiga FrameMaster II/Rainbow II support"
 	depends on (FB = y) && ZORRO
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
+	select FB_IO_HELPERS
 	help
 	  This is the frame buffer device driver for the Amiga FrameMaster
 	  card from BSC (exhibited 1992 but not shipped as a CBM product).
diff --git a/drivers/video/fbdev/fm2fb.c b/drivers/video/fbdev/fm2fb.c
index 4dcb9dd79bf8..a25cbb999934 100644
--- a/drivers/video/fbdev/fm2fb.c
+++ b/drivers/video/fbdev/fm2fb.c
@@ -167,11 +167,9 @@ static int fm2fb_blank(int blank, struct fb_info *info);
 
 static const struct fb_ops fm2fb_ops = {
 	.owner		= THIS_MODULE,
+	FB_DEFAULT_IO_OPS,
 	.fb_setcolreg	= fm2fb_setcolreg,
 	.fb_blank	= fm2fb_blank,
-	.fb_fillrect	= cfb_fillrect,
-	.fb_copyarea	= cfb_copyarea,
-	.fb_imageblit	= cfb_imageblit,
 };
 
     /*
-- 
2.41.0

