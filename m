Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81634764BF5
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 10:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbjG0IUb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 04:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbjG0IRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 04:17:50 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89445FD
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 01:10:13 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-686f6231bdeso112904b3a.1
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 01:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690445357; x=1691050157;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1//FAyntSoVVhHGcFkYF5rOUv8OYZDaOr/FI52lXs1g=;
        b=WprFfHhwxvgCbIOGEhvz/77THpnE+uaWMbMuLLIIDpVeL3Jz2616v8wLFkzo7HZvSd
         TNFFTtJffBxh3fLTgZ0hA52iTzwFJ1lb7YC8GT96AcRGLEmRK6UnsPg5TF0WeT/gBbXI
         n3D8mngVfbe3MYXC32UZAJFJiGuaHBVIWM9CunOWIYu990kGDPAj43N4rpm3m8rpgsHd
         02xW2JacWcelFq3TAnDCLUfDJo66VYYZvDcSFvyxJpg5YwEtAXcJf/FphGWJu7IrCr2v
         NhF0NyS2ftTWJJ0Gd6+a6tHW0SZpG4hIgkFC42XLIYM9ZEOFnWGm8ZzCwBndTMQ8KaY8
         M1zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690445357; x=1691050157;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1//FAyntSoVVhHGcFkYF5rOUv8OYZDaOr/FI52lXs1g=;
        b=B7YpM5zqm0Ef1FfwJKgk3ree2lAclXmMGH6xnJe1JlEBwtZWQRmPrrF982O7N3/Hzk
         N7BXd3OZwzjlRX3zUCgpeSWhLFAukZKR/35xZYpkmtQXnEK45M1DLIW+Ye7gFFLSWWW8
         epBA97skl6IKjTQNi9DkRZAwz8ezSebYeyBcK+j4mZEHyK7AFoCo8VbRWCdRAzxoj+6O
         svG3tiYMBsmnafhHu7xUs6Id/xWtpCqkasoU2ahmTJTW/1UddR9wkr1N8jFMdHUhMvU8
         9j/CdFJ8Rm+CkihHT1R3Hmmu8zmeC+xC2pLGayZkfroqo0o3hqh4yhXgdUQCa2JajF0G
         MiqA==
X-Gm-Message-State: ABy/qLbdrRd6ANEYi692D5XCwJouDQx7HzO2IvrJOLZg9nXjesTNdeEd
        z/DLUaGh0OBZ+mE9x//rciBr4Q==
X-Google-Smtp-Source: APBJJlHvmYnqUEfQMupLlQUSLLnEPxVICkIYSDMBUwnFYoQAuRxCEO7ekKLA8kJr4NX0LnRrY6UJ3A==
X-Received: by 2002:a05:6a00:13a3:b0:676:2a5c:7bc5 with SMTP id t35-20020a056a0013a300b006762a5c7bc5mr5229938pfg.1.1690445356761;
        Thu, 27 Jul 2023 01:09:16 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id j8-20020aa78d08000000b006828e49c04csm885872pfe.75.2023.07.27.01.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 01:09:16 -0700 (PDT)
From:   Qi Zheng <zhengqi.arch@bytedance.com>
To:     akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
        vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
        brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
        steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
        yujie.liu@intel.com, gregkh@linuxfoundation.org,
        muchun.song@linux.dev
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-erofs@lists.ozlabs.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-nfs@vger.kernel.org, linux-mtd@lists.infradead.org,
        rcu@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org,
        linux-bcache@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 17/49] quota: dynamically allocate the dquota-cache shrinker
Date:   Thu, 27 Jul 2023 16:04:30 +0800
Message-Id: <20230727080502.77895-18-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
References: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use new APIs to dynamically allocate the dquota-cache shrinker.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 fs/quota/dquot.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index e8232242dd34..8883e6992f7c 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -791,12 +791,6 @@ dqcache_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 	percpu_counter_read_positive(&dqstats.counter[DQST_FREE_DQUOTS]));
 }
 
-static struct shrinker dqcache_shrinker = {
-	.count_objects = dqcache_shrink_count,
-	.scan_objects = dqcache_shrink_scan,
-	.seeks = DEFAULT_SEEKS,
-};
-
 /*
  * Safely release dquot and put reference to dquot.
  */
@@ -2957,6 +2951,7 @@ static int __init dquot_init(void)
 {
 	int i, ret;
 	unsigned long nr_hash, order;
+	struct shrinker *dqcache_shrinker;
 
 	printk(KERN_NOTICE "VFS: Disk quotas %s\n", __DQUOT_VERSION__);
 
@@ -2991,8 +2986,15 @@ static int __init dquot_init(void)
 	pr_info("VFS: Dquot-cache hash table entries: %ld (order %ld,"
 		" %ld bytes)\n", nr_hash, order, (PAGE_SIZE << order));
 
-	if (register_shrinker(&dqcache_shrinker, "dquota-cache"))
-		panic("Cannot register dquot shrinker");
+	dqcache_shrinker = shrinker_alloc(0, "dquota-cache");
+	if (!dqcache_shrinker)
+		panic("Cannot allocate dquot shrinker");
+
+	dqcache_shrinker->count_objects = dqcache_shrink_count;
+	dqcache_shrinker->scan_objects = dqcache_shrink_scan;
+	dqcache_shrinker->seeks = DEFAULT_SEEKS;
+
+	shrinker_register(dqcache_shrinker);
 
 	return 0;
 }
-- 
2.30.2

