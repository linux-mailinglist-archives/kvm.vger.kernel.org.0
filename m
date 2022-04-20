Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 764B550930F
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 00:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348447AbiDTWok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 18:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357858AbiDTWod (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 18:44:33 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4923B42A30;
        Wed, 20 Apr 2022 15:41:32 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id j9so2385109qkg.1;
        Wed, 20 Apr 2022 15:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SwoMNkAayM1tGtIPzhdqe+GGGbTWcPc9hf6KXEvIQFI=;
        b=UChEwxvVmlgoXQ/dzIfmm8v8hKOVL5+jR55AcJURNhPlKL+BIsf/KSWCDjG/m1eXeZ
         6jjDAdazrGaycUznHOyxrC2wC/ZbfE+aZrdeX9QyQ2QYEghLpWG1riyww47UNcWr85yq
         ikujT3FmqgtzcOwQFmFyMUh8X/r9jQIEJFF4U6WvWXoG0cHbmEPcSQn/QxvHOSXIXlNc
         916QzdTupJB+aL4KVRo0D0qWyxHz/faPCVlUinXns/w+dyi8zZgM3rBdYrvsR2do36an
         BY93qO1qWMscBHcej3upnI3g42pFwfFuah9iLLmWSuzuApnuggGHz2EDLY4kztW3PjNN
         VVaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SwoMNkAayM1tGtIPzhdqe+GGGbTWcPc9hf6KXEvIQFI=;
        b=Z81lp+1Qbe2Qeq47olXvK3Z2sfUMiN7A/gmirotPP0qftDR6Ip8VoClhjmPwFXw0Sq
         OeJm+ZGorLXAs2wBKaT92U8nywGveZ3t4pBpid/wIPJBaysGd2WQaIMywuYGP5gnw00X
         VoU5F/CIT0BeHcIaTc7OcYf2LH/0Sj3SFMwMyTR56kunVCV5klpubuP+fAOb6/Z/oBwj
         xV7+8eVbG9tLv6VcJDEtAmGAniEOL2D7Iaq7dePgdm8KQQt945r055mrDD78c2nSyhVa
         kbv1GZS/hWP331UQEuTOoh4Kcp9RMIWa/MyKiIM1P2HtRP0UR8tapE9vN6tBsvVdzOtJ
         dY/Q==
X-Gm-Message-State: AOAM533QAbHvRP8xxxzj1S6qZkDwUZZ5xCbLiOU7oDEAXny601o58flb
        FMvRaH53wdMBpmovMOvjqwgG4zpR8sg=
X-Google-Smtp-Source: ABdhPJx+cJj+hjYtc8sD2VNJvWCriKrBX+gkOIJ7TIxfipQHy/mUJXbSZqqrI18/l4r0rk2iFvqyVg==
X-Received: by 2002:a05:620a:1a99:b0:680:f33c:dbd3 with SMTP id bl25-20020a05620a1a9900b00680f33cdbd3mr14008035qkb.17.1650494487360;
        Wed, 20 Apr 2022 15:41:27 -0700 (PDT)
Received: from localhost ([2601:c4:c432:60a:7d5c:9c92:ea6c:f1c8])
        by smtp.gmail.com with ESMTPSA id x10-20020a37630a000000b0069ecbe5dd32sm2119311qkb.130.2022.04.20.15.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 15:41:27 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Yury Norov <yury.norov@gmail.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Pan Xinhui <Xinhui.Pan@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Chengming Gui <Jack.Gui@amd.com>,
        Darren Powell <darren.powell@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Kevin Wang <kevin1.wang@amd.com>,
        Xiaomeng Hou <Xiaomeng.Hou@amd.com>,
        Prike Liang <Prike.Liang@amd.com>,
        Yifan Zhang <yifan1.zhang@amd.com>,
        Tao Zhou <tao.zhou1@amd.com>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 4/4] drm/amd/pm: use bitmap_{from,to}_arr32 where appropriate
Date:   Wed, 20 Apr 2022 15:41:28 -0700
Message-Id: <20220420224128.911759-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220420222530.910125-1-yury.norov@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The smu_v1X_0_set_allowed_mask() uses bitmap_copy() to convert
bitmap to 32-bit array. This may be wrong due to endianness issues.
Fix it by switching to bitmap_{from,to}_arr32.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c | 2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
index b87f550af26b..5f8809f6990d 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -781,7 +781,7 @@ int smu_v11_0_set_allowed_mask(struct smu_context *smu)
 		goto failed;
 	}
 
-	bitmap_copy((unsigned long *)feature_mask, feature->allowed, 64);
+	bitmap_to_arr32(feature_mask, feature->allowed, 64);
 
 	ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_SetAllowedFeaturesMaskHigh,
 					  feature_mask[1], NULL);
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
index cf09e30bdfe0..747430ce6394 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -730,7 +730,7 @@ int smu_v13_0_set_allowed_mask(struct smu_context *smu)
 	    feature->feature_num < 64)
 		return -EINVAL;
 
-	bitmap_copy((unsigned long *)feature_mask, feature->allowed, 64);
+	bitmap_to_arr32(feature_mask, feature->allowed, 64);
 
 	ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_SetAllowedFeaturesMaskHigh,
 					      feature_mask[1], NULL);
-- 
2.32.0

