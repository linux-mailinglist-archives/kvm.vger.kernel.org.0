Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9713B75EF9B
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 11:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbjGXJqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 05:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbjGXJqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 05:46:02 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8959910D1
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 02:45:31 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-6864c144897so1022430b3a.1
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 02:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690191931; x=1690796731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ewD/GNBDsb9emQZc+crYJJhL9Ok7DRtPygkZmojk224=;
        b=DyvUb16iFXGbECeKR4Jj5b9Aqu7GqNXEePNkHat23I7b1VL4ke9XL7AFF21PJI8D03
         dadzrjq6WC5mtymsIwcgysKxt2IeQhVQYSg0yzEciG/3J3jMvvonWrabgIjT5cyrH4U0
         K1NmdQ2LZEMZR3X0ctjhZi8pkjfdY6FiANez7gH72dxDBt7t+C7AalBczQoExmv/leVd
         sjx5yitsqqA/ZPm80lkfCIhjuAfvEuRwNIJ4RlVw9F2GYFjyskW1Ygf/DVx+iz0W5Dlm
         41zeCUlShQCZl1UPIlyRzbY5fG4LbR2jBKDZp6zvisQp1bayYn113SLSSif4m+cEaf+t
         mhLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690191931; x=1690796731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ewD/GNBDsb9emQZc+crYJJhL9Ok7DRtPygkZmojk224=;
        b=E8ABetBuRO6wRSHLAO10rpjLJCGeeO7cshQ5qCPB8M/RoItHL8UfvDsjGvXml3Nr6p
         Scn0Q7z7vNf5ZgFSSpLBcmB37gYgCS8K0Wjnz1LVqvuolvxQXAQnYOJZrqCf69nFuE+E
         ODpCQGnfQbfki1A4NKZHCcWFEEc+jJudWBY/5qeAGB2IwTadgflK3HLPFeNhTS25wdYE
         7xwN5RGFFTzLJUCGRVf1kvwFeM1tCX7zDioWnFc1f4erH73H/8xnoVk82lfGXEm91K68
         zgWw+4KImcFbB/hnaXApLdzW6hj+srSARf8IpOHDc7kJYwfkdCZI5ToUM6V32bm70WIE
         buKA==
X-Gm-Message-State: ABy/qLYTjCFr3HQ/4ikuBmEQhs6mGRXP/jNW3VMXi0GqYCHXD1Fs/No8
        3YpxY55OOchyjkGt/Rpvm15Fyw==
X-Google-Smtp-Source: APBJJlF4hVHTEAcnrryQeIsWufK3e63a7rX2g1OMpnBMufUIHv2BcOagu97Dc7evIwstimu7xBX17w==
X-Received: by 2002:a17:902:e849:b0:1b8:35fa:cdcc with SMTP id t9-20020a170902e84900b001b835facdccmr12688015plg.5.1690191930816;
        Mon, 24 Jul 2023 02:45:30 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902c18500b001bb20380bf2sm8467233pld.13.2023.07.24.02.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 02:45:30 -0700 (PDT)
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
Subject: [PATCH v2 02/47] mm: shrinker: remove redundant shrinker_rwsem in debugfs operations
Date:   Mon, 24 Jul 2023 17:43:09 +0800
Message-Id: <20230724094354.90817-3-zhengqi.arch@bytedance.com>
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

The debugfs_remove_recursive() will wait for debugfs_file_put() to return,
so the shrinker will not be freed when doing debugfs operations (such as
shrinker_debugfs_count_show() and shrinker_debugfs_scan_write()), so there
is no need to hold shrinker_rwsem during debugfs operations.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/shrinker_debug.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
index 3ab53fad8876..f1becfd45853 100644
--- a/mm/shrinker_debug.c
+++ b/mm/shrinker_debug.c
@@ -55,11 +55,6 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
 	if (!count_per_node)
 		return -ENOMEM;
 
-	ret = down_read_killable(&shrinker_rwsem);
-	if (ret) {
-		kfree(count_per_node);
-		return ret;
-	}
 	rcu_read_lock();
 
 	memcg_aware = shrinker->flags & SHRINKER_MEMCG_AWARE;
@@ -92,7 +87,6 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
 
 	rcu_read_unlock();
-	up_read(&shrinker_rwsem);
 
 	kfree(count_per_node);
 	return ret;
@@ -117,7 +111,6 @@ static ssize_t shrinker_debugfs_scan_write(struct file *file,
 	struct mem_cgroup *memcg = NULL;
 	int nid;
 	char kbuf[72];
-	ssize_t ret;
 
 	read_len = size < (sizeof(kbuf) - 1) ? size : (sizeof(kbuf) - 1);
 	if (copy_from_user(kbuf, buf, read_len))
@@ -146,12 +139,6 @@ static ssize_t shrinker_debugfs_scan_write(struct file *file,
 		return -EINVAL;
 	}
 
-	ret = down_read_killable(&shrinker_rwsem);
-	if (ret) {
-		mem_cgroup_put(memcg);
-		return ret;
-	}
-
 	sc.nid = nid;
 	sc.memcg = memcg;
 	sc.nr_to_scan = nr_to_scan;
@@ -159,7 +146,6 @@ static ssize_t shrinker_debugfs_scan_write(struct file *file,
 
 	shrinker->scan_objects(shrinker, &sc);
 
-	up_read(&shrinker_rwsem);
 	mem_cgroup_put(memcg);
 
 	return size;
-- 
2.30.2

