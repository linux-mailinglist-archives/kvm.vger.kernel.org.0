Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F92C772296
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 13:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbjHGLfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 07:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbjHGLfX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 07:35:23 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198AF49CF
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 04:32:05 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id af79cd13be357-767e87b7199so37711685a.1
        for <kvm@vger.kernel.org>; Mon, 07 Aug 2023 04:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1691407872; x=1692012672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=48waxWZGd1WUnLYaDrTSxvJywKXLcopaiUkWgt7j5Rg=;
        b=QbhAcMv1LLx652VnRJecYg+N7BHjOo7JZZdvDDA4qfz74WSNKyYr6ZmNwNsws/HJI6
         ABWAJ5RJgVAAe8PNCBtdMaDGDKoYU71/dG5xST5Y6uS3GzQ/OL84tOCHnhRoHX3TMXx+
         B/mxZSRi39pjm768kEIi02M+TZ/1xWeVM4+7lHrO84OK8tCDYNZ9I4XzNdGj/ey+8Dyg
         98z3DCt8zOH7pm9dknIBgGxxX7Vwbp3m84CMt5aaJncchjdbJRMVNf746VybZwr9VTeS
         fMwp5ZN1qcL/FrO1MtTxaRBF78dsL2dZA9Cz1je18SzVjr2P4OiacWkJPBZv2wBmxvnh
         8Wlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691407872; x=1692012672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=48waxWZGd1WUnLYaDrTSxvJywKXLcopaiUkWgt7j5Rg=;
        b=PqO4ueucMfmzcfepEslj1Aij1Hy7BIPr21MCCQpKoVW/6p1h81YdWUkiybLhVpcoVM
         kreAIWeHlxLwZwNeA33A2xQyHoNQ6wG3wp0hQOqAeVwyjqOxMRNufDKNhRTbC6PiyGKl
         XX4xwrfEb78txuk9yD9GveUzlaO8fFH7CswmXETNjTaVEWRwr5huv+0Fh5AglPNow9yc
         jtEkJ2hn75DTI14JD/LHs16XRS3htwTw+EfZdEaTMNg9Cu62xni/yGilD3l/tHz+vPmt
         vHvC5IrJ669/njPcOBH2Mrv+SHSttkluwsgG382NwWs2FCS+tpq6bbgqpH273FdfzHbk
         Bx4g==
X-Gm-Message-State: ABy/qLY76E3IrY8AXqjlD1vk9dFwPie9u9fEsmQqhWakyhqXyBtLtTDd
        iCBArrkR52u57CggQoqwoE5DYNMw3BSDjPC32gQ=
X-Google-Smtp-Source: APBJJlHbn14CvO5TR8loNSEkHloCg3xrbjPIwtza5v7TtzUnsc09AI3fvHMVCyYd3DTpdbD1pcNBzw==
X-Received: by 2002:a17:90a:4104:b0:25c:1ad3:a4a1 with SMTP id u4-20020a17090a410400b0025c1ad3a4a1mr24600948pjf.1.1691407032801;
        Mon, 07 Aug 2023 04:17:12 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090aca8d00b0025be7b69d73sm5861191pjt.12.2023.08.07.04.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 04:17:12 -0700 (PDT)
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
Subject: [PATCH v4 34/48] jbd2,ext4: dynamically allocate the jbd2-journal shrinker
Date:   Mon,  7 Aug 2023 19:09:22 +0800
Message-Id: <20230807110936.21819-35-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for implementing lockless slab shrink, use new APIs to
dynamically allocate the jbd2-journal shrinker, so that it can be freed
asynchronously using kfree_rcu(). Then it doesn't need to wait for RCU
read-side critical section when releasing the struct journal_s.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 fs/jbd2/journal.c    | 27 +++++++++++++++++----------
 include/linux/jbd2.h |  2 +-
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 1b5a45ab62b0..4c421da03fee 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1298,7 +1298,7 @@ static int jbd2_min_tag_size(void)
 static unsigned long jbd2_journal_shrink_scan(struct shrinker *shrink,
 					      struct shrink_control *sc)
 {
-	journal_t *journal = container_of(shrink, journal_t, j_shrinker);
+	journal_t *journal = shrink->private_data;
 	unsigned long nr_to_scan = sc->nr_to_scan;
 	unsigned long nr_shrunk;
 	unsigned long count;
@@ -1324,7 +1324,7 @@ static unsigned long jbd2_journal_shrink_scan(struct shrinker *shrink,
 static unsigned long jbd2_journal_shrink_count(struct shrinker *shrink,
 					       struct shrink_control *sc)
 {
-	journal_t *journal = container_of(shrink, journal_t, j_shrinker);
+	journal_t *journal = shrink->private_data;
 	unsigned long count;
 
 	count = percpu_counter_read_positive(&journal->j_checkpoint_jh_count);
@@ -1412,19 +1412,26 @@ static journal_t *journal_init_common(struct block_device *bdev,
 	journal->j_superblock = (journal_superblock_t *)bh->b_data;
 
 	journal->j_shrink_transaction = NULL;
-	journal->j_shrinker.scan_objects = jbd2_journal_shrink_scan;
-	journal->j_shrinker.count_objects = jbd2_journal_shrink_count;
-	journal->j_shrinker.seeks = DEFAULT_SEEKS;
-	journal->j_shrinker.batch = journal->j_max_transaction_buffers;
 
 	if (percpu_counter_init(&journal->j_checkpoint_jh_count, 0, GFP_KERNEL))
 		goto err_cleanup;
 
-	if (register_shrinker(&journal->j_shrinker, "jbd2-journal:(%u:%u)",
-			      MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev))) {
+	journal->j_shrinker = shrinker_alloc(0, "jbd2-journal:(%u:%u)",
+					     MAJOR(bdev->bd_dev),
+					     MINOR(bdev->bd_dev));
+	if (!journal->j_shrinker) {
 		percpu_counter_destroy(&journal->j_checkpoint_jh_count);
 		goto err_cleanup;
 	}
+
+	journal->j_shrinker->scan_objects = jbd2_journal_shrink_scan;
+	journal->j_shrinker->count_objects = jbd2_journal_shrink_count;
+	journal->j_shrinker->seeks = DEFAULT_SEEKS;
+	journal->j_shrinker->batch = journal->j_max_transaction_buffers;
+	journal->j_shrinker->private_data = journal;
+
+	shrinker_register(journal->j_shrinker);
+
 	return journal;
 
 err_cleanup:
@@ -2187,9 +2194,9 @@ int jbd2_journal_destroy(journal_t *journal)
 		brelse(journal->j_sb_buffer);
 	}
 
-	if (journal->j_shrinker.flags & SHRINKER_REGISTERED) {
+	if (journal->j_shrinker) {
 		percpu_counter_destroy(&journal->j_checkpoint_jh_count);
-		unregister_shrinker(&journal->j_shrinker);
+		shrinker_free(journal->j_shrinker);
 	}
 	if (journal->j_proc_entry)
 		jbd2_stats_proc_exit(journal);
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 44c298aa58d4..beb4c4586320 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -891,7 +891,7 @@ struct journal_s
 	 * Journal head shrinker, reclaim buffer's journal head which
 	 * has been written back.
 	 */
-	struct shrinker		j_shrinker;
+	struct shrinker		*j_shrinker;
 
 	/**
 	 * @j_checkpoint_jh_count:
-- 
2.30.2

