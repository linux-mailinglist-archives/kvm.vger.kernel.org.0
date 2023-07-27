Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65641764D0D
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 10:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbjG0Iae (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 04:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234417AbjG0I2J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 04:28:09 -0400
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2100283CB
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 01:14:38 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-682eef7d752so203716b3a.0
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 01:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690445308; x=1691050108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PjmSZHUI5/Kx8ZOfBbo02iydikdUH/y22dszJBbwnrc=;
        b=Xysv3RsPsBshttSMBUyUOf01pFj7ACJomxAeSKClYNtUM/IzDnc+1qcVpxKo3Yk7lI
         PMJO/0QAsBuNTHH31vZSyAI+mqZzOZhxUKyEZ0z882UMy5ds0dV7wjv4n79QhgQIluxL
         7aiFKUJGI5uVRXEWRoqfDwEepuojrPx+nt9lSRf3+jabTyI60DcKdVq5RfgL5+gSsYt+
         gIHfo7xL/z2KDHdpCbDlWUD9Wlzvl0HFxAouF/jEEZTs97EVMQFcZk2wLBhFoNV93wDr
         cOODQ3G+tMDc7b4BNamRJNYxJL3PiF9jIw3/5zQqa59OSVfyqIzXn4AyZmUz4TWVr103
         SUHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690445308; x=1691050108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PjmSZHUI5/Kx8ZOfBbo02iydikdUH/y22dszJBbwnrc=;
        b=EOMZAIZR/8hcYRrXMWLQPNzmnSqadc6HW0wMwIVLiyqwSW8LWkGl66IsPrdImbuQu1
         +SfpVTg/cG2w7O0pXtXvqcYjKN6v9oHW5BVV2qAT3DjUe8yS3aDjZQym0TsHOcNhXMdw
         60H1v/VE+XxphwlFafqgCIN3O29+rR1ZKHPok9amT6nRpce6pABjGhJDU9iejst7zXgy
         MMSx2dYYsuOctB8BXfRM0K01VjFimaWVmG3HAWvzxoj0rBlI7D8j/AmNaYAW86f0tSla
         EhsBgSfhQ5TDmJNZ6Z2/5Nfe6viY3KAFwXjuwHXxRdnzXbRpycAR9QyKSmObrPvcNkeR
         q/hw==
X-Gm-Message-State: ABy/qLbu+G6Cy7H36y+uLgwrPkr2NjqdLdPdqXitSA3qPA8Vo+zBXXy7
        a3Um9IJJuc5u5H9SEUS31Bhffw==
X-Google-Smtp-Source: APBJJlEap1sNysOWJSQnWaDnt336ll2X4eQUWxGjP7f0SXFaJg3Iw5H2LPNpa2qt6BR3D4CNzXfNwg==
X-Received: by 2002:a05:6a00:4a0e:b0:677:3439:874a with SMTP id do14-20020a056a004a0e00b006773439874amr5196539pfb.3.1690445308627;
        Thu, 27 Jul 2023 01:08:28 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id j8-20020aa78d08000000b006828e49c04csm885872pfe.75.2023.07.27.01.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 01:08:28 -0700 (PDT)
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
Subject: [PATCH v3 13/49] gfs2: dynamically allocate the gfs2-qd shrinker
Date:   Thu, 27 Jul 2023 16:04:26 +0800
Message-Id: <20230727080502.77895-14-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
References: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use new APIs to dynamically allocate the gfs2-qd shrinker.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 fs/gfs2/main.c  |  6 +++---
 fs/gfs2/quota.c | 26 ++++++++++++++++++++------
 fs/gfs2/quota.h |  3 ++-
 3 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index afcb32854f14..e47b1cc79f59 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -147,7 +147,7 @@ static int __init init_gfs2_fs(void)
 	if (!gfs2_trans_cachep)
 		goto fail_cachep8;
 
-	error = register_shrinker(&gfs2_qd_shrinker, "gfs2-qd");
+	error = gfs2_qd_shrinker_init();
 	if (error)
 		goto fail_shrinker;
 
@@ -196,7 +196,7 @@ static int __init init_gfs2_fs(void)
 fail_wq2:
 	destroy_workqueue(gfs_recovery_wq);
 fail_wq1:
-	unregister_shrinker(&gfs2_qd_shrinker);
+	gfs2_qd_shrinker_exit();
 fail_shrinker:
 	kmem_cache_destroy(gfs2_trans_cachep);
 fail_cachep8:
@@ -229,7 +229,7 @@ static int __init init_gfs2_fs(void)
 
 static void __exit exit_gfs2_fs(void)
 {
-	unregister_shrinker(&gfs2_qd_shrinker);
+	gfs2_qd_shrinker_exit();
 	gfs2_glock_exit();
 	gfs2_unregister_debugfs();
 	unregister_filesystem(&gfs2_fs_type);
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index aa5fd06d47bc..6cbf323bc4d0 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -186,13 +186,27 @@ static unsigned long gfs2_qd_shrink_count(struct shrinker *shrink,
 	return vfs_pressure_ratio(list_lru_shrink_count(&gfs2_qd_lru, sc));
 }
 
-struct shrinker gfs2_qd_shrinker = {
-	.count_objects = gfs2_qd_shrink_count,
-	.scan_objects = gfs2_qd_shrink_scan,
-	.seeks = DEFAULT_SEEKS,
-	.flags = SHRINKER_NUMA_AWARE,
-};
+static struct shrinker *gfs2_qd_shrinker;
+
+int __init gfs2_qd_shrinker_init(void)
+{
+	gfs2_qd_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE, "gfs2-qd");
+	if (!gfs2_qd_shrinker)
+		return -ENOMEM;
+
+	gfs2_qd_shrinker->count_objects = gfs2_qd_shrink_count;
+	gfs2_qd_shrinker->scan_objects = gfs2_qd_shrink_scan;
+	gfs2_qd_shrinker->seeks = DEFAULT_SEEKS;
+
+	shrinker_register(gfs2_qd_shrinker);
 
+	return 0;
+}
+
+void gfs2_qd_shrinker_exit(void)
+{
+	shrinker_free(gfs2_qd_shrinker);
+}
 
 static u64 qd2index(struct gfs2_quota_data *qd)
 {
diff --git a/fs/gfs2/quota.h b/fs/gfs2/quota.h
index 21ada332d555..f0d54dcbbc75 100644
--- a/fs/gfs2/quota.h
+++ b/fs/gfs2/quota.h
@@ -59,7 +59,8 @@ static inline int gfs2_quota_lock_check(struct gfs2_inode *ip,
 }
 
 extern const struct quotactl_ops gfs2_quotactl_ops;
-extern struct shrinker gfs2_qd_shrinker;
+int __init gfs2_qd_shrinker_init(void);
+void gfs2_qd_shrinker_exit(void);
 extern struct list_lru gfs2_qd_lru;
 extern void __init gfs2_quota_hash_init(void);
 
-- 
2.30.2

