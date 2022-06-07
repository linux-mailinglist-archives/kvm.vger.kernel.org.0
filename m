Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB61541362
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 21:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357899AbiFGT7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 15:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357941AbiFGT7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 15:59:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 312081BBACE
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 11:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654626234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P4f3wHn7jIrIURtw341a5ADfTmzk5i8t59cyMFQz5Qc=;
        b=Xw4HHWK9BFohqfbyqXsndyNgX19ayI7Gri9nvVyAhnDSAS69b3VGCx5V+2JkJo2Pm6n78f
        eOdI75AOMO6uAafiZiDTCndifelG6JaNCAf8WoiJt5UZ9yJRsS5kMvG62DbTJNUVKqbBy3
        1S7frUjuyDro36D10+XguV9r3j4lLVc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86--1rTJZggMOC_Em0mQJ-ZVQ-1; Tue, 07 Jun 2022 14:23:53 -0400
X-MC-Unique: -1rTJZggMOC_Em0mQJ-ZVQ-1
Received: by mail-wr1-f71.google.com with SMTP id p10-20020adfaa0a000000b0020c4829af5fso4197681wrd.16
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 11:23:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P4f3wHn7jIrIURtw341a5ADfTmzk5i8t59cyMFQz5Qc=;
        b=0MIIOYWd+RqVPxY6em/28yEYi1fnMIFJX8gn24sCeO1gp8Pu1vkj0s8ImQNlEgIgDH
         Gfd04KB/lHbRbbBJLSObHjjgudkYJs6DjQEtrwWzur3fK2jhfZCMCXc8dJxLNXzmLaq0
         mK9fDW5IILNocDwMgtElv28kpYsa0CEe6RI0ks+CJWhOACedIaNMRoDYkUV7xAbFu7Mx
         Mz2NdpRR4mKPebJWzZwgD5vkB/x6gf1UOQXXOjmthbzzfT/NwOs8IpNRyikdjuOJjznr
         GA6GUC41t2VjG+ow76wtws6JqV/JPVX6HceEGu1ryxtrTwQw0uIzaatj+R5uDIajZKVA
         L0QA==
X-Gm-Message-State: AOAM5311srSdxfmzV5qtIGYW/WnrQz86XJjjeT5XUR3lVd8DOIDfqnsi
        p7Nq0aerdC+Mk7mItxXVCLx09EDEs2cAC3YQzJeTW4iKs5R9xN6NTpJ7aQbY8Z0NmvHMZa5s/l3
        OlzhpwrD4pkzh
X-Received: by 2002:a05:6000:711:b0:217:371e:b7ff with SMTP id bs17-20020a056000071100b00217371eb7ffmr16261824wrb.127.1654626232063;
        Tue, 07 Jun 2022 11:23:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/N4WjMmddIXMJgSScZ/qUGCGSnIp6UQDq474dS3NmqfffRft8Ws4ePchj9FzlpDpPJ0DOSA==
X-Received: by 2002:a05:6000:711:b0:217:371e:b7ff with SMTP id bs17-20020a056000071100b00217371eb7ffmr16261787wrb.127.1654626231742;
        Tue, 07 Jun 2022 11:23:51 -0700 (PDT)
Received: from minerva.home (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id m8-20020a05600c4f4800b003942a244f51sm28267502wmq.42.2022.06.07.11.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 11:23:51 -0700 (PDT)
From:   Javier Martinez Canillas <javierm@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Laszlo Ersek <lersek@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, kvm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        kernel test robot <lkp@intel.com>,
        Jens Frederich <jfrederich@gmail.com>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        linux-staging@lists.linux.dev,
        Daniel Vetter <daniel.vetter@intel.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>, Helge Deller <deller@gmx.de>,
        Matthew Wilcox <willy@infradead.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        linux-fbdev@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v6 5/5] fbdev: Make registered_fb[] private to fbmem.c
Date:   Tue,  7 Jun 2022 20:23:38 +0200
Message-Id: <20220607182338.344270-6-javierm@redhat.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607182338.344270-1-javierm@redhat.com>
References: <20220607182338.344270-1-javierm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

Well except when the olpc dcon fbdev driver is enabled, that thing
digs around in there in rather unfixable ways.

Cc oldc_dcon maintainers as fyi.

v2: I typoed the config name (0day)

Cc: kernel test robot <lkp@intel.com>
Cc: Jens Frederich <jfrederich@gmail.com>
Cc: Jon Nettleton <jon.nettleton@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-staging@lists.linux.dev
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: linux-fbdev@vger.kernel.org
Cc: Zheyu Ma <zheyuma97@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
---

(no changes since v1)

 drivers/video/fbdev/core/fbmem.c | 8 ++++++--
 include/linux/fb.h               | 7 +++----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index e0720fef0ee6..bdb08b665b43 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -50,10 +50,14 @@
 static DEFINE_MUTEX(registration_lock);
 
 struct fb_info *registered_fb[FB_MAX] __read_mostly;
-EXPORT_SYMBOL(registered_fb);
-
 int num_registered_fb __read_mostly;
+#if IS_ENABLED(CONFIG_FB_OLPC_DCON)
+EXPORT_SYMBOL(registered_fb);
 EXPORT_SYMBOL(num_registered_fb);
+#endif
+#define for_each_registered_fb(i)		\
+	for (i = 0; i < FB_MAX; i++)		\
+		if (!registered_fb[i]) {} else
 
 bool fb_center_logo __read_mostly;
 
diff --git a/include/linux/fb.h b/include/linux/fb.h
index bbe1e4571899..c563e24b6293 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -632,16 +632,15 @@ extern int fb_get_color_depth(struct fb_var_screeninfo *var,
 extern int fb_get_options(const char *name, char **option);
 extern int fb_new_modelist(struct fb_info *info);
 
+#if IS_ENABLED(CONFIG_FB_OLPC_DCON)
 extern struct fb_info *registered_fb[FB_MAX];
+
 extern int num_registered_fb;
+#endif
 extern bool fb_center_logo;
 extern int fb_logo_count;
 extern struct class *fb_class;
 
-#define for_each_registered_fb(i)		\
-	for (i = 0; i < FB_MAX; i++)		\
-		if (!registered_fb[i]) {} else
-
 static inline void lock_fb_info(struct fb_info *info)
 {
 	mutex_lock(&info->lock);
-- 
2.36.1

