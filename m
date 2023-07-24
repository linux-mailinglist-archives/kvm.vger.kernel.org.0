Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB0975F0DA
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 11:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbjGXJyP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 05:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232689AbjGXJxD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 05:53:03 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30ACCE7C
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 02:49:07 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1bb85ed352bso2235865ad.0
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 02:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690192110; x=1690796910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8oqpenbl7KoJJhQpMWpio5jwf7tXqseO0h4l218M5aA=;
        b=aCj2BNfrpcxtoTz1/CdONfPnB9TAYVTaqB4T4WqFv6y7Hxl9V0boEFHOTATComBNn2
         xnFJ8tDKgZzO2TH4FwPeDTaYzb9x0D/uxmdjUcwFhXWgN5824wox+O8c9U9ybGUIohlv
         M3vK6kDUgbRBz02IXlUWPuxdPW8hkxiMWgJebr95xqiqSLJbGYOLAINvEuBU6c5+0m2D
         KwQfMs1a5lB1SKCsavAJR55Sjok6of8gfoBXMKjbRTfwQ6NM1BD/3dZZP6dR7OXOKSHl
         QBl4iWtqq0OikEBOGyMzrxqP+jJMX2cWmHkmCbYCS6DP7MDoD2ilfcJavniQ/pgHFrWu
         bw9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690192110; x=1690796910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8oqpenbl7KoJJhQpMWpio5jwf7tXqseO0h4l218M5aA=;
        b=Y6rUtFCHXA1hNg7X9SQ7ncIZ7npsizRClVrcJeZXZBSYaoJXBEhSq8XS+Njg/X8Cv/
         VkjiGvQ37NI5j+0z3BBnOavRxXgZ3W+DPlQ8ff6tOAfffGRjsHLyPFl/ngmNVDA6fOgI
         BJ2TVP/kocOaX4uV0TNACyRIJcxwiSGi57yaLFEQLHjX0ovXOPIEz5khwUU3vRrVxBEf
         r4xfXuZiBGxSxQEUBoTsTApO++UGO58YWyZx1zjIZ01acUHHQ0gmGLDnqhywv0ZnCd7F
         xf4hYtMvwv3lS/EOF7GIkq869J2OjCSgtOexLYnkIZUhkVkeY7mhIb4DmnTFKeOvXlbv
         3iEw==
X-Gm-Message-State: ABy/qLar9cx9HYdKEXi+84Lfp1SeWI5xDv2zoPqN1AyZnYxOF2x3B7ZV
        tAhA0aBHs/dsOw/gSIOVXJoMVQ==
X-Google-Smtp-Source: APBJJlFv5Kl04F8rp2naJTMNzHe6rYzFJJPXcSejcs04WaV/YhAbklIOobqPbsV/O0Fdd5o/IKlERw==
X-Received: by 2002:a17:902:d484:b0:1b8:a27d:f591 with SMTP id c4-20020a170902d48400b001b8a27df591mr12259746plg.5.1690192110449;
        Mon, 24 Jul 2023 02:48:30 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902c18500b001bb20380bf2sm8467233pld.13.2023.07.24.02.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 02:48:30 -0700 (PDT)
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
Subject: [PATCH v2 17/47] rcu: dynamically allocate the rcu-lazy shrinker
Date:   Mon, 24 Jul 2023 17:43:24 +0800
Message-Id: <20230724094354.90817-18-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use new APIs to dynamically allocate the rcu-lazy shrinker.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 kernel/rcu/tree_nocb.h | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
index 43229d2b0c44..919f17561733 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -1397,12 +1397,7 @@ lazy_rcu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 	return count ? count : SHRINK_STOP;
 }
 
-static struct shrinker lazy_rcu_shrinker = {
-	.count_objects = lazy_rcu_shrink_count,
-	.scan_objects = lazy_rcu_shrink_scan,
-	.batch = 0,
-	.seeks = DEFAULT_SEEKS,
-};
+static struct shrinker *lazy_rcu_shrinker;
 #endif // #ifdef CONFIG_RCU_LAZY
 
 void __init rcu_init_nohz(void)
@@ -1436,8 +1431,16 @@ void __init rcu_init_nohz(void)
 		return;
 
 #ifdef CONFIG_RCU_LAZY
-	if (register_shrinker(&lazy_rcu_shrinker, "rcu-lazy"))
-		pr_err("Failed to register lazy_rcu shrinker!\n");
+	lazy_rcu_shrinker = shrinker_alloc(0, "rcu-lazy");
+	if (!lazy_rcu_shrinker) {
+		pr_err("Failed to allocate lazy_rcu shrinker!\n");
+	} else {
+		lazy_rcu_shrinker->count_objects = lazy_rcu_shrink_count;
+		lazy_rcu_shrinker->scan_objects = lazy_rcu_shrink_scan;
+		lazy_rcu_shrinker->seeks = DEFAULT_SEEKS;
+
+		shrinker_register(lazy_rcu_shrinker);
+	}
 #endif // #ifdef CONFIG_RCU_LAZY
 
 	if (!cpumask_subset(rcu_nocb_mask, cpu_possible_mask)) {
-- 
2.30.2

