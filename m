Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B51C175F064
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 11:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbjGXJvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 05:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjGXJuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 05:50:06 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52390171F
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 02:48:03 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1b8c364ad3bso8858895ad.1
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 02:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690192062; x=1690796862;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rzRsL3uPXf8EtZhij3twpf+iuH9MzH4dVPBmPqsS5Og=;
        b=gX8Q7SXHLW91QeJQyKDVumBjdRBjyll1XQW/JTChdq9dJqktv+X9ib4/uAMXxgigqH
         2jaNwNGzNzbxV0P1Wq3smVBCy4sNVeMp2d3znSQmH+08EqCorhh8sobS3FzAo1aci+WZ
         ahKKXhVh1u/zcYQLSV07bWs7cg92+ga+7wTGv6JJSEqo99xKqc3+YUXi9LMwyQq6STAk
         AcT7MY/9kuaNFBZqw4pd3+jIBecT2Ao+Yw0ycAdTL8xM/HvxupDlq0E7GLdDU4836YR8
         3HkgcSbyA4vS6vLviPYG979wLCQ5W42uSMh1vXnsGUiqQWrA1KKfF7bNogJb+rMbZ6Yg
         D/lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690192062; x=1690796862;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rzRsL3uPXf8EtZhij3twpf+iuH9MzH4dVPBmPqsS5Og=;
        b=TaYOHvp780qDMB9YGjRLY5YkU8RXSM5GDmQht5/Hf0dee9u8WlDhYlFKyNlC6K8KI0
         /wqbaSZ/wpxpubTQAV7j8B28n6HMlG1v0PVTEWxeueJ+lBLuT2s+4VhCivhOX3k2AYh5
         zYmFlTKSy2QpxDzi/qZp7ruHZ81X2XLN0BuNp/mzpoChMa6eYBWZqFyYhv8ekl5Fn+gj
         9axQoz89MIAe99pY9u1Ib5Pxi96ghPepJ/3ZjKySAh4nno0KWU9hw2z9D2vglX+C8jZ6
         CCfDtDd8iKj+zLqeFJCOndPVhBuRn9LFktqX/ejvG1KhCtqESFm5vrGLCXxobt6sewGf
         6RRA==
X-Gm-Message-State: ABy/qLarqcBEd32RMmhELGXG05b7Fyah8KKRAONYnQYNjAXNqv3iaE8h
        v1a3WOtuZr95kG6mF9Csak1LYw==
X-Google-Smtp-Source: APBJJlE2hlcoboYUdUaSOoRiDnmiId7r6Wv5DYfSEbrHd1JPgB9nwdB4ObCAMGW7eL9gTiY+r7GrFA==
X-Received: by 2002:a17:902:d508:b0:1a6:6bdb:b548 with SMTP id b8-20020a170902d50800b001a66bdbb548mr12141350plg.1.1690192062448;
        Mon, 24 Jul 2023 02:47:42 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902c18500b001bb20380bf2sm8467233pld.13.2023.07.24.02.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 02:47:42 -0700 (PDT)
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
Subject: [PATCH v2 13/47] nfs: dynamically allocate the nfs-acl shrinker
Date:   Mon, 24 Jul 2023 17:43:20 +0800
Message-Id: <20230724094354.90817-14-zhengqi.arch@bytedance.com>
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

Use new APIs to dynamically allocate the nfs-acl shrinker.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 fs/nfs/super.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 2284f749d892..a90b12593383 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -129,11 +129,7 @@ static void nfs_ssc_unregister_ops(void)
 }
 #endif /* CONFIG_NFS_V4_2 */
 
-static struct shrinker acl_shrinker = {
-	.count_objects	= nfs_access_cache_count,
-	.scan_objects	= nfs_access_cache_scan,
-	.seeks		= DEFAULT_SEEKS,
-};
+static struct shrinker *acl_shrinker;
 
 /*
  * Register the NFS filesystems
@@ -153,9 +149,17 @@ int __init register_nfs_fs(void)
 	ret = nfs_register_sysctl();
 	if (ret < 0)
 		goto error_2;
-	ret = register_shrinker(&acl_shrinker, "nfs-acl");
-	if (ret < 0)
+
+	acl_shrinker = shrinker_alloc(0, "nfs-acl");
+	if (!acl_shrinker)
 		goto error_3;
+
+	acl_shrinker->count_objects = nfs_access_cache_count;
+	acl_shrinker->scan_objects = nfs_access_cache_scan;
+	acl_shrinker->seeks = DEFAULT_SEEKS;
+
+	shrinker_register(acl_shrinker);
+
 #ifdef CONFIG_NFS_V4_2
 	nfs_ssc_register_ops();
 #endif
@@ -175,7 +179,7 @@ int __init register_nfs_fs(void)
  */
 void __exit unregister_nfs_fs(void)
 {
-	unregister_shrinker(&acl_shrinker);
+	shrinker_unregister(acl_shrinker);
 	nfs_unregister_sysctl();
 	unregister_nfs4_fs();
 #ifdef CONFIG_NFS_V4_2
-- 
2.30.2

