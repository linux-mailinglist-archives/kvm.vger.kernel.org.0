Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22DED7722E3
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 13:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjHGLlt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 07:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbjHGLlf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 07:41:35 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6593C06
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 04:38:14 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-790af3bfa5cso28285839f.1
        for <kvm@vger.kernel.org>; Mon, 07 Aug 2023 04:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1691408232; x=1692013032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dp1PQp+5gTkm4DG/kxrQVAZ0rB7KyI/rGW6TiEnUaUw=;
        b=hVXdW4Ypj/9ppM9zEEOnUTv9iwEZUZ+1KNGY77clXwP6OX0rSVg/sVZi8nwEF+Vv0x
         pUXqojonmeNVeD75uYVTiWMWMQzTvveUwoxedEBxbPGLAQHTCIEe7v2bPZSwGcpzrjz0
         fLAt/2WwWHBRKXYKVbz3A2FgJheCU3JBZSGlbtxyvDqupibMs8E37NdsBsp404XoccFC
         CqUAKeY1319DKwqkovSFSHY0SdxqDeUUYaQz4DDLxNlhpl3o2fTSBjtUK/j2CIPOvdUm
         SXig43O3cPxAqy61T8pMFeed6fyXXJ8aVl53hacYGGq9SpwNcayirHuyVJh7ymW+dKaC
         hobQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691408232; x=1692013032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dp1PQp+5gTkm4DG/kxrQVAZ0rB7KyI/rGW6TiEnUaUw=;
        b=AU/N9lIQ8o5cNZraeO8kj0iwSHlp86pW+sex7Bo70M94flugxGXwW0fJzPFC7NQb4T
         VAG88sb7xijNWpgwYp886McotjAlrC6bEwtuzWD0HxiDBDaeuTiof5KNECla5CZmPbkB
         DgYrtFb+5nqogEAxb7mPeXU0XlWVMERg95Fj2d4GHamHNsFyvUTNyOYBzOEwSdp3s1cA
         GHMnE7rn7JCgUKfUWTvgUYl+OmB2W8LQ7skfTwpLUGmzNRwKaCDhrDs4f8bOZEyTYEhW
         a73wLuTSjOIYpwMyOO7gxmJTzEsEnhbVAiQ/zY3chjW1y8Znf5+Ir8ZRG5kJ17sqheoa
         gAbA==
X-Gm-Message-State: ABy/qLb9Lb7jalrRNEiwrLxI8D6zkpJzEJkgGFerWZSFLGn8daTu0YgI
        cELlLuDgrt70YzCAbmB5UJEWmYV8tfJ/pVCve+M=
X-Google-Smtp-Source: APBJJlGWGDf3ZP6TvEF/B95Km+XRmBUarTmlKp42txasQQnYUyfeo2SyrhxLvRA3BfrSE4M4+QRzMg==
X-Received: by 2002:a17:902:dace:b0:1b8:17e8:5472 with SMTP id q14-20020a170902dace00b001b817e85472mr32807567plx.1.1691407148534;
        Mon, 07 Aug 2023 04:19:08 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090aca8d00b0025be7b69d73sm5861191pjt.12.2023.08.07.04.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 04:19:07 -0700 (PDT)
From:   Qi Zheng <zhengqi.arch@bytedance.com>
To:     akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
        vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
        brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
        steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
        yujie.liu@intel.com, gregkh@linuxfoundation.org,
        muchun.song@linux.dev, simon.horman@corigine.com,
        dlemoal@kernel.org
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
Subject: [PATCH v4 43/48] drm/ttm: introduce pool_shrink_rwsem
Date:   Mon,  7 Aug 2023 19:09:31 +0800
Message-Id: <20230807110936.21819-44-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, the synchronize_shrinkers() is only used by TTM pool. It only
requires that no shrinkers run in parallel.

After we use RCU+refcount method to implement the lockless slab shrink,
we can not use shrinker_rwsem or synchronize_rcu() to guarantee that all
shrinker invocations have seen an update before freeing memory.

So we introduce a new pool_shrink_rwsem to implement a private
synchronize_shrinkers(), so as to achieve the same purpose.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 drivers/gpu/drm/ttm/ttm_pool.c | 15 +++++++++++++++
 include/linux/shrinker.h       |  2 --
 mm/shrinker.c                  | 15 ---------------
 3 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.c
index c9c9618c0dce..38b4c280725c 100644
--- a/drivers/gpu/drm/ttm/ttm_pool.c
+++ b/drivers/gpu/drm/ttm/ttm_pool.c
@@ -74,6 +74,7 @@ static struct ttm_pool_type global_dma32_uncached[MAX_ORDER + 1];
 static spinlock_t shrinker_lock;
 static struct list_head shrinker_list;
 static struct shrinker *mm_shrinker;
+static DECLARE_RWSEM(pool_shrink_rwsem);
 
 /* Allocate pages of size 1 << order with the given gfp_flags */
 static struct page *ttm_pool_alloc_page(struct ttm_pool *pool, gfp_t gfp_flags,
@@ -317,6 +318,7 @@ static unsigned int ttm_pool_shrink(void)
 	unsigned int num_pages;
 	struct page *p;
 
+	down_read(&pool_shrink_rwsem);
 	spin_lock(&shrinker_lock);
 	pt = list_first_entry(&shrinker_list, typeof(*pt), shrinker_list);
 	list_move_tail(&pt->shrinker_list, &shrinker_list);
@@ -329,6 +331,7 @@ static unsigned int ttm_pool_shrink(void)
 	} else {
 		num_pages = 0;
 	}
+	up_read(&pool_shrink_rwsem);
 
 	return num_pages;
 }
@@ -572,6 +575,18 @@ void ttm_pool_init(struct ttm_pool *pool, struct device *dev,
 }
 EXPORT_SYMBOL(ttm_pool_init);
 
+/**
+ * synchronize_shrinkers - Wait for all running shrinkers to complete.
+ *
+ * This is useful to guarantee that all shrinker invocations have seen an
+ * update, before freeing memory, similar to rcu.
+ */
+static void synchronize_shrinkers(void)
+{
+	down_write(&pool_shrink_rwsem);
+	up_write(&pool_shrink_rwsem);
+}
+
 /**
  * ttm_pool_fini - Cleanup a pool
  *
diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index c55c07c3f0cb..025c8070dd86 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -103,8 +103,6 @@ struct shrinker *shrinker_alloc(unsigned int flags, const char *fmt, ...);
 void shrinker_register(struct shrinker *shrinker);
 void shrinker_free(struct shrinker *shrinker);
 
-extern void synchronize_shrinkers(void);
-
 #ifdef CONFIG_SHRINKER_DEBUG
 extern int __printf(2, 3) shrinker_debugfs_rename(struct shrinker *shrinker,
 						  const char *fmt, ...);
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 3ab301ff122d..a27779ed3798 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -650,18 +650,3 @@ void shrinker_free(struct shrinker *shrinker)
 	kfree(shrinker);
 }
 EXPORT_SYMBOL_GPL(shrinker_free);
-
-/**
- * synchronize_shrinkers - Wait for all running shrinkers to complete.
- *
- * This is equivalent to calling unregister_shrink() and register_shrinker(),
- * but atomically and with less overhead. This is useful to guarantee that all
- * shrinker invocations have seen an update, before freeing memory, similar to
- * rcu.
- */
-void synchronize_shrinkers(void)
-{
-	down_write(&shrinker_rwsem);
-	up_write(&shrinker_rwsem);
-}
-EXPORT_SYMBOL(synchronize_shrinkers);
-- 
2.30.2

