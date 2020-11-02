Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40312A2E2F
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 16:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgKBPVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 10:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbgKBPUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 10:20:51 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5821C061A4A
        for <kvm@vger.kernel.org>; Mon,  2 Nov 2020 07:20:50 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id 23so1259349wmg.1
        for <kvm@vger.kernel.org>; Mon, 02 Nov 2020 07:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iECHQmtOjlKNpXGH67tnBHQ9XW515B1GPzEiiSpCWAs=;
        b=gVI6AXHj1TR9hrfeYHb9dFp1mjew1HU6tCdihy0BU74lIamhYA7I2Voy1vdbHNesjR
         p/9fN/OWbbHskwd+E8JR5E7mlF2yPwnRyYtplyTXp1xuKHzcS1KZmAQ11HYDiDqqk7yd
         tY/OlfBK/MIoUqiunGYPPRAv9qXuTyoKnb4oe0deS/0lvO8WRDkT4MMl7YYdbRLIjP6A
         WZTM13vo3qiWMFhDQgKf19/bBsn2+22jmj9vBOz0Wr1g2h4AsIo5xnYen4guGQ+vuB7M
         tIBujecjdmcR/Z2ixrsAyoeQ+6Gr/0jPL5uAk5wnvtIcZr9YQMnQKa+inwhetM8theTJ
         LUMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iECHQmtOjlKNpXGH67tnBHQ9XW515B1GPzEiiSpCWAs=;
        b=GUpFpOsp9oH92f0IP2ucpVkvkLwiJEO6z7FuO6YuRmtDBxbmuK/GKcnc7SfAMSjaXP
         TwRQSzmIrmswyKbaQzWMVni3Uuw48Qg8FzPWZF4+Ea1sDJ3yxg3CrGX0TZg62W3HSaJ9
         nLFZk6bmJdYOtPYXs5ISxpU2R/Fa1OEXXD29NPByTRWy96GUGy0IPRcerlVQsGPQAb0w
         oebeCCFmifZA/+9NbrTjo7kXGF+1biow1IB/FOWsEtKV8/PqOApF9cNO+RnVDeaT1KY1
         7aEcZ6oaVQxAZ3hLKqIczm3iR95dEmrp0NdVIo2rGAE5uL2UfXK2RowCaiNjdk5fZ2CS
         +Bwg==
X-Gm-Message-State: AOAM5339Oh9R3mJCer8ZNFv7IPjdD6XnMWofCjliE/qHazLaYh56n0KI
        dy8/txoyO24bGmlRCAdkfdigAg==
X-Google-Smtp-Source: ABdhPJx9fmpXAPU0JQHKuUawZdLrOPu5JMkxXUw7mS4v/KP1pdXlJ+GdMVgsN3hdsL/yk/nVdd3HMQ==
X-Received: by 2002:a05:600c:1497:: with SMTP id c23mr13426695wmh.95.1604330449377;
        Mon, 02 Nov 2020 07:20:49 -0800 (PST)
Received: from debian-brgl.home (amarseille-656-1-4-167.w90-8.abo.wanadoo.fr. [90.8.158.167])
        by smtp.gmail.com with ESMTPSA id b18sm15138014wmj.41.2020.11.02.07.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 07:20:48 -0800 (PST)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-gpio@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v2 4/8] pinctrl: use krealloc_array()
Date:   Mon,  2 Nov 2020 16:20:33 +0100
Message-Id: <20201102152037.963-5-brgl@bgdev.pl>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201102152037.963-1-brgl@bgdev.pl>
References: <20201102152037.963-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Use the helper that checks for overflows internally instead of manually
calculating the size of the new array.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/pinctrl/pinctrl-utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-utils.c b/drivers/pinctrl/pinctrl-utils.c
index f2bcbf62c03d..93df0d4c0a24 100644
--- a/drivers/pinctrl/pinctrl-utils.c
+++ b/drivers/pinctrl/pinctrl-utils.c
@@ -39,7 +39,7 @@ int pinctrl_utils_reserve_map(struct pinctrl_dev *pctldev,
 	if (old_num >= new_num)
 		return 0;
 
-	new_map = krealloc(*map, sizeof(*new_map) * new_num, GFP_KERNEL);
+	new_map = krealloc_array(*map, new_num, sizeof(*new_map), GFP_KERNEL);
 	if (!new_map) {
 		dev_err(pctldev->dev, "krealloc(map) failed\n");
 		return -ENOMEM;
-- 
2.29.1

