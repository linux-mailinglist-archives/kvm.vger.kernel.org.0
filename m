Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7615E764D1C
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 10:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234687AbjG0Iar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 04:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235244AbjG0I34 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 04:29:56 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557B659D1
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 01:16:18 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-66d6a9851f3so168971b3a.0
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 01:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690445734; x=1691050534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X5ij/O+E/bk/tTzX9mgxwiCynzBHcXx4EKtI9EsHayo=;
        b=j4pDVeMcXcw7i7IAx1DNlz6iKEYUEIabVz59nN5q7bAhCS1y2gOKuzdzTgG4j/dBwO
         H4HIbZq+pOLjZVM5UGP2bbBpIOa2ebzQlUp84F0j/JFisMPJqEmZ2hJuFivDCiuZb9qk
         P5NgTQLX0gtg3X+vGmP6/3oCCgeQ9FljDUkAtb6pQhQ/VT+3lIzONbNoOLFITLjS+g+5
         Vjj6M2H3z3FRG2iT9u3T7VH/LPW2zOuTNtSoF+jLae0SEMd2/P/I3VxNY7Hl9q3RH2MH
         NSqRY7EFleJMoWuU3X7ly6d0/rJ15DhvMCCJQ4sCCtoszhR0yDF7rbG/n/mEuDtWN3AJ
         wtVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690445734; x=1691050534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X5ij/O+E/bk/tTzX9mgxwiCynzBHcXx4EKtI9EsHayo=;
        b=lKhSsacv7lrJFO+w2lmWTckN0CTRP7+BDB5fK1uU7Ebm4v/R7Qrttx85zhg9Ofgk5e
         QwBlYMlMUMJRhkVaAM2MNe8h2BF9TlXU0JNZBsV8jD7NasJOQCbHogKggXcoYugpbnrf
         bbJuMX8G7h8+VVaMqf6+TCKki7GPzVn6Wp110MgPMSaHB9gBZgVpxLxL/z+sdzj0eAEM
         hHyV364t6N7oH2ClHwirFRCHtLyi3pEq4in1wsfnVnooOCmjJWXFQJcFsX/r++Plq6N6
         5izIPz8eb8oVGrgIxb4dydUofnKKVR5ad6QVb4ukLMZRcZUZzPSX8g+2KCuBO56McD2Z
         wpCw==
X-Gm-Message-State: ABy/qLZrqN6Y7ixbEkPnU3ZUc2dATndF0pX8of5di7uJGrcZF00dovJK
        fz1Bid9iwkZljLzeZspjFyxtYg==
X-Google-Smtp-Source: APBJJlGCk2Vrs4jG84R1mGLjwsvlQmrr2Zz0KCmUr/tZ9etimLEYhkynVpF/d5AFiEeYea7/v2C0Wg==
X-Received: by 2002:a05:6a20:7d87:b0:12e:f6e6:882b with SMTP id v7-20020a056a207d8700b0012ef6e6882bmr6451328pzj.1.1690445734330;
        Thu, 27 Jul 2023 01:15:34 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id j8-20020aa78d08000000b006828e49c04csm885872pfe.75.2023.07.27.01.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 01:15:33 -0700 (PDT)
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
Subject: [PATCH v3 48/49] mm: shrinker: hold write lock to reparent shrinker nr_deferred
Date:   Thu, 27 Jul 2023 16:05:01 +0800
Message-Id: <20230727080502.77895-49-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
References: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For now, reparent_shrinker_deferred() is the only holder of read lock of
shrinker_rwsem. And it already holds the global cgroup_mutex, so it will
not be called in parallel.

Therefore, in order to convert shrinker_rwsem to shrinker_mutex later,
here we change to hold the write lock of shrinker_rwsem to reparent.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/shrinker.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/shrinker.c b/mm/shrinker.c
index fee6f62904fb..a12dede5d21f 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -299,7 +299,7 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 		parent = root_mem_cgroup;
 
 	/* Prevent from concurrent shrinker_info expand */
-	down_read(&shrinker_rwsem);
+	down_write(&shrinker_rwsem);
 	for_each_node(nid) {
 		child_info = shrinker_info_protected(memcg, nid);
 		parent_info = shrinker_info_protected(parent, nid);
@@ -312,7 +312,7 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 			}
 		}
 	}
-	up_read(&shrinker_rwsem);
+	up_write(&shrinker_rwsem);
 }
 #else
 static int shrinker_memcg_alloc(struct shrinker *shrinker)
-- 
2.30.2

