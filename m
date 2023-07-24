Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84DBC75F1B2
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 12:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbjGXKBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 06:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbjGXKAh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 06:00:37 -0400
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266FB2D4E
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 02:54:21 -0700 (PDT)
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-55b5a37acb6so327155a12.0
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 02:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690192350; x=1690797150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=guTIXae/kI3JPez6Art55JYiwmImAmg2GBvF3i236eo=;
        b=T5pLZeng3kilrZ5OsnvGTDioSzbaJCT88B3/JHb49aZTbZwkP7SQy7bBJoydE9spSc
         QIxkCjfHPkCmZ3YIN0z+vz21Kuh2hIgEDSPHHynjot/NbMHOuV4niRtD3jI5KIBaaa0O
         QjmZCafpm4KClLD1lVXUS+elEzy69vq+ucFXQ9CjFJ4T1DxZVWoYTT1w3KSYOQJv3GQd
         ajkkZaaoOEQUBpPKcbabEPlKAYj8bt1g6LICLF4Sb/Oh/OZdyOCaK9S/uK8Sx83ZxUOS
         cV5UpYXnJF2ZClJYAKOlUHJYPAwRn2oigN8jrAEhI2JaJXKMB9RmC8T2WtXgjmkuAGWv
         WtUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690192350; x=1690797150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=guTIXae/kI3JPez6Art55JYiwmImAmg2GBvF3i236eo=;
        b=L5LXPfHR035RXXOs136aJYnIjLIVsl9q/y8e4yZGSd5IGqSUGV/np2JPLyw5XpVind
         hzN2Br6HbPYutHVYKk2OtNGUnScktBjsJgMYUYkF3X4QyXVHjsyBVA/VLeGcKaIacukH
         hrB1sv4uhhjx262RZNKGYi+RFGEfVyW6EQlD5jJEpqZajywBNgKdMIE7ouyK6m9rZMPK
         B7zxSApqflB3gsOlGbTaQ47cNILfmqmQrq5ytnJue6kFmNULnVu9299EevHRwrI9PXgc
         UuFRETqeqxg3yW1vwQZwPJOAsRL4J1pItQSqf/1cDuZXuwSXWrJdmtTnOhNuDMa6/vzq
         RBmw==
X-Gm-Message-State: ABy/qLaY9J4RuTHa4zqo9D/nbhN/wNcAURkjWBYWmJuQqjF3qUmRMGbK
        fYOB7ku9VZKNuDwbTCmHQXziRw==
X-Google-Smtp-Source: APBJJlHJFdqX7YvzDE87sV65msd4BgjSJaSlmkLSDmv21X9cTIYDURxtd2XgOOda4P7o7DorEuOAJA==
X-Received: by 2002:a17:903:41cd:b0:1bb:9e6e:a9f3 with SMTP id u13-20020a17090341cd00b001bb9e6ea9f3mr4119632ple.4.1690192350104;
        Mon, 24 Jul 2023 02:52:30 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902c18500b001bb20380bf2sm8467233pld.13.2023.07.24.02.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 02:52:29 -0700 (PDT)
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
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 37/47] xfs: dynamically allocate the xfs-inodegc shrinker
Date:   Mon, 24 Jul 2023 17:43:44 +0800
Message-Id: <20230724094354.90817-38-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for implementing lockless slab shrink, use new APIs to
dynamically allocate the xfs-inodegc shrinker, so that it can be freed
asynchronously using kfree_rcu(). Then it doesn't need to wait for RCU
read-side critical section when releasing the struct xfs_mount.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 fs/xfs/xfs_icache.c | 26 +++++++++++++++-----------
 fs/xfs/xfs_mount.c  |  4 ++--
 fs/xfs/xfs_mount.h  |  2 +-
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 453890942d9f..751c380afd5a 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -2225,8 +2225,7 @@ xfs_inodegc_shrinker_count(
 	struct shrinker		*shrink,
 	struct shrink_control	*sc)
 {
-	struct xfs_mount	*mp = container_of(shrink, struct xfs_mount,
-						   m_inodegc_shrinker);
+	struct xfs_mount	*mp = shrink->private_data;
 	struct xfs_inodegc	*gc;
 	int			cpu;
 
@@ -2247,8 +2246,7 @@ xfs_inodegc_shrinker_scan(
 	struct shrinker		*shrink,
 	struct shrink_control	*sc)
 {
-	struct xfs_mount	*mp = container_of(shrink, struct xfs_mount,
-						   m_inodegc_shrinker);
+	struct xfs_mount	*mp = shrink->private_data;
 	struct xfs_inodegc	*gc;
 	int			cpu;
 	bool			no_items = true;
@@ -2284,13 +2282,19 @@ int
 xfs_inodegc_register_shrinker(
 	struct xfs_mount	*mp)
 {
-	struct shrinker		*shrink = &mp->m_inodegc_shrinker;
+	mp->m_inodegc_shrinker = shrinker_alloc(SHRINKER_NONSLAB,
+						"xfs-inodegc:%s",
+						mp->m_super->s_id);
+	if (!mp->m_inodegc_shrinker)
+		return -ENOMEM;
+
+	mp->m_inodegc_shrinker->count_objects = xfs_inodegc_shrinker_count;
+	mp->m_inodegc_shrinker->scan_objects = xfs_inodegc_shrinker_scan;
+	mp->m_inodegc_shrinker->seeks = 0;
+	mp->m_inodegc_shrinker->batch = XFS_INODEGC_SHRINKER_BATCH;
+	mp->m_inodegc_shrinker->private_data = mp;
 
-	shrink->count_objects = xfs_inodegc_shrinker_count;
-	shrink->scan_objects = xfs_inodegc_shrinker_scan;
-	shrink->seeks = 0;
-	shrink->flags = SHRINKER_NONSLAB;
-	shrink->batch = XFS_INODEGC_SHRINKER_BATCH;
+	shrinker_register(mp->m_inodegc_shrinker);
 
-	return register_shrinker(shrink, "xfs-inodegc:%s", mp->m_super->s_id);
+	return 0;
 }
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index fb87ffb48f7f..27c2d24797c9 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1018,7 +1018,7 @@ xfs_mountfs(
  out_log_dealloc:
 	xfs_log_mount_cancel(mp);
  out_inodegc_shrinker:
-	unregister_shrinker(&mp->m_inodegc_shrinker);
+	shrinker_unregister(mp->m_inodegc_shrinker);
  out_fail_wait:
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_buftarg_drain(mp->m_logdev_targp);
@@ -1100,7 +1100,7 @@ xfs_unmountfs(
 #if defined(DEBUG)
 	xfs_errortag_clearall(mp);
 #endif
-	unregister_shrinker(&mp->m_inodegc_shrinker);
+	shrinker_unregister(mp->m_inodegc_shrinker);
 	xfs_free_perag(mp);
 
 	xfs_errortag_del(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e2866e7fa60c..562c294ca08e 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -217,7 +217,7 @@ typedef struct xfs_mount {
 	atomic_t		m_agirotor;	/* last ag dir inode alloced */
 
 	/* Memory shrinker to throttle and reprioritize inodegc */
-	struct shrinker		m_inodegc_shrinker;
+	struct shrinker		*m_inodegc_shrinker;
 	/*
 	 * Workqueue item so that we can coalesce multiple inode flush attempts
 	 * into a single flush.
-- 
2.30.2

