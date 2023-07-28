Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4403C76755A
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 20:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjG1S0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 14:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbjG1SZ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 14:25:26 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1805844A7;
        Fri, 28 Jul 2023 11:25:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6E5D21F8C8;
        Fri, 28 Jul 2023 18:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690568567; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=amfE9iWg1zAFsDvx2Rsq1/p5noUQya/C12jHqjUtCfI=;
        b=QEIaAnEF6X01KWmUDhIQlelBR1uA8eMjI+wxeuYew7uKNi77VrcSwF6NAfjYvOvVWYxv+n
        5T86KSZNo+J3n5dW0l4aShd3jZpmby2DxNQCTG4aoar/o/DxtfKusymxS4IcLsnbdyTOYu
        fR3If2zAvC83RFXg659mbSwQMw0WcVM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690568567;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=amfE9iWg1zAFsDvx2Rsq1/p5noUQya/C12jHqjUtCfI=;
        b=czjAetp6s/ZazJVEMj5Plcg9px+Qo7fn2blFfyl6eIYGEhYbqWyLlZ+8OvmX51UnovZoz0
        ZyFuDbme8q6UOlCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2F055139BD;
        Fri, 28 Jul 2023 18:22:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eB93CncHxGQ3CwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Fri, 28 Jul 2023 18:22:47 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     deller@gmx.de, javierm@redhat.com, sam@ravnborg.org
Cc:     linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        kvm@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: [PATCH 47/47] vfio-dev/mdpy-fb: Use fbdev I/O helpers
Date:   Fri, 28 Jul 2023 18:40:30 +0200
Message-ID: <20230728182234.10680-48-tzimmermann@suse.de>
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
Cc: Kirti Wankhede <kwankhede@nvidia.com>
---
 samples/Kconfig             | 4 +---
 samples/vfio-mdev/mdpy-fb.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/samples/Kconfig b/samples/Kconfig
index bf49ed0d7362..44b4d8569015 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -210,9 +210,7 @@ config SAMPLE_VFIO_MDEV_MDPY
 config SAMPLE_VFIO_MDEV_MDPY_FB
 	tristate "Build VFIO mdpy example guest fbdev driver"
 	depends on FB
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
+	select FB_IO_HELPERS
 	help
 	  Guest fbdev driver for the virtual display sample driver.
 
diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
index cda477b28685..78140c755bed 100644
--- a/samples/vfio-mdev/mdpy-fb.c
+++ b/samples/vfio-mdev/mdpy-fb.c
@@ -88,11 +88,9 @@ static void mdpy_fb_destroy(struct fb_info *info)
 
 static const struct fb_ops mdpy_fb_ops = {
 	.owner		= THIS_MODULE,
+	FB_DEFAULT_IO_OPS,
 	.fb_destroy	= mdpy_fb_destroy,
 	.fb_setcolreg	= mdpy_fb_setcolreg,
-	.fb_fillrect	= cfb_fillrect,
-	.fb_copyarea	= cfb_copyarea,
-	.fb_imageblit	= cfb_imageblit,
 };
 
 static int mdpy_fb_probe(struct pci_dev *pdev,
-- 
2.41.0

