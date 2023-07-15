Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3671B754B4C
	for <lists+kvm@lfdr.de>; Sat, 15 Jul 2023 20:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjGOSyP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Jul 2023 14:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbjGOSyB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Jul 2023 14:54:01 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7841D2D65;
        Sat, 15 Jul 2023 11:53:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 265BD21AE4;
        Sat, 15 Jul 2023 18:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1689447231; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HF0ntTEfTFR2eIXkYuLTyCKB+tFcMggnqDzzMkFmIGA=;
        b=epo9Ya2u6FlD9nLz/rIKRF9OMdO+LNGFhrgi7rf57h6jrrZHQJGnRNkaimxXU9JHv6ETGH
        6Y7fXLr7bKAIIItUjzL7zTfV23Sr4VAdvGYcRFePrJcbcOe91GMkkPVirlmPPu+v7wVAyy
        xmnPmGIWIF/AJxQzL4L6meP5PHQznZ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1689447231;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HF0ntTEfTFR2eIXkYuLTyCKB+tFcMggnqDzzMkFmIGA=;
        b=uW5O5mrDRVpr1c3h7FGRD8BpU7mhlgcUS7Bleuu0xigjOEEVU2pD7UO2kP9kaUee3uat+5
        3x5dag1l2yfq+WCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AE02C13A23;
        Sat, 15 Jul 2023 18:53:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id MD+KKT7rsmQCBwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Sat, 15 Jul 2023 18:53:50 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     deller@gmx.de, javierm@redhat.com, geert@linux-m68k.org,
        dan.carpenter@linaro.org
Cc:     linux-sh@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-hyperv@vger.kernel.org,
        linux-omap@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Teddy Wang <teddy.wang@siliconmotion.com>
Subject: [PATCH v4 12/18] staging: Remove flag FBINFO_FLAG_DEFAULT from fbdev drivers
Date:   Sat, 15 Jul 2023 20:51:54 +0200
Message-ID: <20230715185343.7193-13-tzimmermann@suse.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230715185343.7193-1-tzimmermann@suse.de>
References: <20230715185343.7193-1-tzimmermann@suse.de>
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

The flag FBINFO_FLAG_DEFAULT is 0 and has no effect, as struct
fbinfo.flags has been allocated to zero by framebuffer_alloc(). So do
not set it.

Flags should signal differences from the default values. After cleaning
up all occurrences of FBINFO_DEFAULT, the token will be removed.

v2:
	* fix commit message (Miguel)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Teddy Wang <teddy.wang@siliconmotion.com>
---
 drivers/staging/fbtft/fbtft-core.c | 2 +-
 drivers/staging/sm750fb/sm750.c    | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
index 3a4abf3bae40..eac1d570f437 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -684,7 +684,7 @@ struct fb_info *fbtft_framebuffer_alloc(struct fbtft_display *display,
 	info->var.transp.offset =  0;
 	info->var.transp.length =  0;
 
-	info->flags =              FBINFO_FLAG_DEFAULT | FBINFO_VIRTFB;
+	info->flags =              FBINFO_VIRTFB;
 
 	par = info->par;
 	par->info = info;
diff --git a/drivers/staging/sm750fb/sm750.c b/drivers/staging/sm750fb/sm750.c
index c260f73cf570..79bcd5bd4938 100644
--- a/drivers/staging/sm750fb/sm750.c
+++ b/drivers/staging/sm750fb/sm750.c
@@ -807,7 +807,6 @@ static int lynxfb_set_fbinfo(struct fb_info *info, int index)
 	info->screen_base = crtc->v_screen;
 	pr_debug("screen_base vaddr = %p\n", info->screen_base);
 	info->screen_size = line_length * var->yres_virtual;
-	info->flags = FBINFO_FLAG_DEFAULT | 0;
 
 	/* set info->fix */
 	fix->type = FB_TYPE_PACKED_PIXELS;
-- 
2.41.0

