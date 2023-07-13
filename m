Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF4F752274
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 15:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbjGMNEO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 09:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234720AbjGMNDu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 09:03:50 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D873F173F;
        Thu, 13 Jul 2023 06:03:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 866B32218D;
        Thu, 13 Jul 2023 13:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1689253428; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ucmT+1GLTDoqupQ1pU8mLni2ss8QN6gSt8DgqXn9pcI=;
        b=xDMQnaXrC0sbzn5vN86LIOql2HUYTjH6Rn2gk6GiGaPIgMn1wM9t8fyeFtlGeVLBKVRych
        jZEQAhl9Cz+rXv2Xmv90zXqwpGPaTq3oQTLgj7bQsU93Ut1zQKNiVkAPZOvZ8Xw/7HLAvF
        hfe8hTWSEW/ctYN/9cd4yTlUaNeyD7A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1689253428;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ucmT+1GLTDoqupQ1pU8mLni2ss8QN6gSt8DgqXn9pcI=;
        b=PyQUJ+mjDGZPkhAsdSpBipeSRqA8G+lVO8ZMG+DvIZIx7osV1ZLdagMlZnxORWjReOpSlc
        CGnqY7btTuRhblDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2CAAD13A94;
        Thu, 13 Jul 2023 13:03:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eLT2CTT2r2TVPgAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Thu, 13 Jul 2023 13:03:48 +0000
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
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH v2 15/18] fbdev/atafb: Remove flag FBINFO_FLAG_DEFAULT
Date:   Thu, 13 Jul 2023 14:58:35 +0200
Message-ID: <20230713130338.31086-16-tzimmermann@suse.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230713130338.31086-1-tzimmermann@suse.de>
References: <20230713130338.31086-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The flag FBINFO_FLAG_DEFAULT is 0 and has no effect, as struct
fbinfo.flags has been allocated to zero by a static declaration. So do
not set it.

Flags should signal differences from the default values. After cleaning
up all occurrences of FBINFO_DEFAULT, the token will be removed.

v2:
	* fix commit message (Miguel)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Helge Deller <deller@gmx.de>
---
 drivers/video/fbdev/atafb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/video/fbdev/atafb.c b/drivers/video/fbdev/atafb.c
index 2bc4089865e6..c4a420b791b9 100644
--- a/drivers/video/fbdev/atafb.c
+++ b/drivers/video/fbdev/atafb.c
@@ -3112,7 +3112,6 @@ static int __init atafb_probe(struct platform_device *pdev)
 #ifdef ATAFB_FALCON
 	fb_info.pseudo_palette = current_par.hw.falcon.pseudo_palette;
 #endif
-	fb_info.flags = FBINFO_FLAG_DEFAULT;
 
 	if (!fb_find_mode(&fb_info.var, &fb_info, mode_option, atafb_modedb,
 			  NUM_TOTAL_MODES, &atafb_modedb[defmode],
-- 
2.41.0

