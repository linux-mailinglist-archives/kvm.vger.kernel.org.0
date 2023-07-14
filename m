Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7497533D9
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 09:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235678AbjGNHwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 03:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235522AbjGNHwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 03:52:03 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDE930EF;
        Fri, 14 Jul 2023 00:52:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 833DC2215B;
        Fri, 14 Jul 2023 07:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1689321120; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AudvpgVwEo8rKBJvmUL4nJ192ctihi90m956sryfWBI=;
        b=wykmJUfY1D5ex36S6LI+kF19ksusw3sJZJUyIAhm/l3ionBeme5uc+s91tFqTAk5mKXcVa
        SYtF2IfGApc4U4IXsnRls72i9Vjv3bMYN8NAXwUDUNwnDNmqbvI4VWDNF7Bu3wjt5KWK98
        yDaasYg8miFghJ2Hz4jGKSJMrANiqsQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1689321120;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AudvpgVwEo8rKBJvmUL4nJ192ctihi90m956sryfWBI=;
        b=9PhfE3CxTj7I8+c5wma73L/mIyx7rd//nxbj+qgoPM+1bXhpSGrjvsEhc0NculMY76Q6a/
        k0fyBdeWeXIOv5AQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 293BC13A92;
        Fri, 14 Jul 2023 07:52:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sLNHCaD+sGQCQwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Fri, 14 Jul 2023 07:52:00 +0000
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
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>
Subject: [PATCH v3 08/18] sh: mach-sh7763rdp: Assign FB_MODE_IS_UNKNOWN to struct fb_videomode.flag
Date:   Fri, 14 Jul 2023 09:49:34 +0200
Message-ID: <20230714075155.5686-9-tzimmermann@suse.de>
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

Assign FB_MODE_IS_UNKNOWN to sh7763fb_videomode.flag instead of
FBINFO_FLAG_DEFAULT. Both are 0, so the stored value does not change.

FBINFO_FLAG_DEFAULT is a flag for a framebuffer in struct fb_info.
Flags for videomodes are prefixed with FB_MODE_.

v3:
	* include board name in commit message (Adrian)
v2:
	* assign FB_MODE_IS_UNKNOWN (Adrian)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
---
 arch/sh/boards/mach-sh7763rdp/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/boards/mach-sh7763rdp/setup.c b/arch/sh/boards/mach-sh7763rdp/setup.c
index 97e715e4e9b3..e25193001ea0 100644
--- a/arch/sh/boards/mach-sh7763rdp/setup.c
+++ b/arch/sh/boards/mach-sh7763rdp/setup.c
@@ -119,7 +119,7 @@ static struct fb_videomode sh7763fb_videomode = {
 	.vsync_len = 1,
 	.sync = 0,
 	.vmode = FB_VMODE_NONINTERLACED,
-	.flag = FBINFO_FLAG_DEFAULT,
+	.flag = FB_MODE_IS_UNKNOWN,
 };
 
 static struct sh7760fb_platdata sh7763fb_def_pdata = {
-- 
2.41.0

