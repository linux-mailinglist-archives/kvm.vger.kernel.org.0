Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC662772194
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 13:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbjHGLX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 07:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232525AbjHGLWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 07:22:54 -0400
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B648A26AC
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 04:20:08 -0700 (PDT)
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-790b6761117so45036439f.0
        for <kvm@vger.kernel.org>; Mon, 07 Aug 2023 04:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1691406804; x=1692011604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4VJlLpDqVGiuvI83ez+3bl7yR5bVuWalBgtTU2vfBLE=;
        b=i2oZ2Se5RaRdFd0q9t3NqBTv/dUkxD/p2SyHpAjMjg/XHGqyx1ejwAfepurqt3olXd
         4JrDoh1Y9dLDoFntnleeQjfq8XZjg4nTjOSD4Duga+gvfwhzkhg3QVfdrOJlicPQaYUD
         v5DwTanMH6RhkvK4rWOetuDFETnSCGxcV41PCfrrWGGU2b+vPg8IYLTIauqtUI6qQnyf
         JDKJFxqA5C/eh/Oo8gwkHqwPIIO1pJg4e68ItW2uJIdbbavFER6b/PwVILGTxzeWrF6b
         lEtQmpfrwSnO090W7cEUPihusqog8pTCjc32QMYuqZWzqkk8YiBOx308Pfsd+2Yt04OK
         T2NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691406804; x=1692011604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4VJlLpDqVGiuvI83ez+3bl7yR5bVuWalBgtTU2vfBLE=;
        b=QlTgaSky3SPOOrYQwHHE8+SZiRAp8CqAgVcAQafP2BZhKE8nxMyaDbC592IQcu8nje
         2hp9mULKctRPbPpIhBp24Sjfisx04lXAb5BZ9mv13DtGGs+6hMEoZEF1yCYtpq8dI8SA
         GLHQq11uE+/cy2M0kZc5+UF1j4mvf95sUou0Tz1qa0bsAOiljfMOkNNBK7AqccufrlUZ
         hPR+o73fcoD/YKSlVpq2+ZJaQxHmVxpM/H1Uy2+dMr2WZtBssokxxB9spfh/MiYEp2UQ
         j9E+R3WaFoEl2375PGtZ4mFuwYn52xMkmw36IvQciIwe7mvraV1KU8b1jDvYcMYBz0fq
         OhXg==
X-Gm-Message-State: ABy/qLamjfHS8IOCKXV1ppb5+wbvjUuNt9q51t3C5KaM7lFO6+l5r32J
        cLTWhVKBJgs9H1gJCz7JVKxk/Q==
X-Google-Smtp-Source: APBJJlG6KxjpSP18cuDMGPLwCal+2Q6XOYkRmOlR+93TSEU+QOz0TNU1VRvfHZPrdEq648UTFq+gsw==
X-Received: by 2002:a92:d944:0:b0:349:3c78:fd14 with SMTP id l4-20020a92d944000000b003493c78fd14mr13499018ilq.1.1691406803912;
        Mon, 07 Aug 2023 04:13:23 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090aca8d00b0025be7b69d73sm5861191pjt.12.2023.08.07.04.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 04:13:23 -0700 (PDT)
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
Subject: [PATCH v4 16/48] quota: dynamically allocate the dquota-cache shrinker
Date:   Mon,  7 Aug 2023 19:09:04 +0800
Message-Id: <20230807110936.21819-17-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
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
index 9e72bfe8bbad..c303cffdf433 100644
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
@@ -2956,6 +2950,7 @@ static int __init dquot_init(void)
 {
 	int i, ret;
 	unsigned long nr_hash, order;
+	struct shrinker *dqcache_shrinker;
 
 	printk(KERN_NOTICE "VFS: Disk quotas %s\n", __DQUOT_VERSION__);
 
@@ -2990,8 +2985,15 @@ static int __init dquot_init(void)
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

