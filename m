Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D630477219A
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 13:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbjHGLX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 07:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232716AbjHGLXT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 07:23:19 -0400
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB4C35AB
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 04:20:50 -0700 (PDT)
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5648fca18b9so575090a12.0
        for <kvm@vger.kernel.org>; Mon, 07 Aug 2023 04:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1691406867; x=1692011667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=igblsYgdIrcTAL0swCZj529c9jjsKo5CwfFS1Qcng2s=;
        b=E/hLPt4J9XwFdy6Q/ScFkKAboS35nT/aVetijUs1uOyzpCdXJrzvux0WuTkbJahYDU
         HJ4RnOFgFoSV4vIvUSABYCFS8MT8O5BBdFRn/e0d22QvpkBHCvD7k0jL91l8VKqh/AnF
         pNO49bmGYrjFLlyM+it2E7+BjcoRQ4qvC4Z3zAnwRx4Mtu2gDzO6KjINZG5u37W7YPwR
         rd9mA5oeLZ1tw0ARUeeWuqEeVLZXyyZpLkD+mkbNh9jB2r9y+xHrPRtEaxpg/6wzvL2p
         pP/svPPe0egiR6EyNxAsA97H1SimGEidDNnScRjB0NSGHk7qAYW8vH7pvvrUaRXF4mmo
         0r3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691406867; x=1692011667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=igblsYgdIrcTAL0swCZj529c9jjsKo5CwfFS1Qcng2s=;
        b=SlW5i5sJtJig+2y13eXmqgFYtAo5cpwt5sIQwYcCyTtBQWb3IXKzGl4IiizfrI1JUU
         XlYjUL/EQCG6m9pwDOfuK2t0S3EdqDVP+6Q7VajYAXIY+902BK8anreErTZsUtKShEPI
         WezNpWZyVG6+AccSeygHcOrDD0PG/7I5ZS/QsagZtJufUsvVCBBgR7eN1D5CTtpcZX+r
         K8CpIw5iHY9RmLRFoVw+w628qE2TUUJ+613ATbbr1mELPiMS0jGjOQtv4eQEyfVQs/xi
         SK9YDGUFPrFg4XfLZ2NuhGDfgMb2YjCnT21shG9KqGmVVdi5y+mkwbT3XozWkN6dLcPu
         B9zw==
X-Gm-Message-State: ABy/qLYxqK8wvUnXLtKwcoBf0RwbheagHElw5C5cG7RVPFCk1ESCqwJw
        7fCj1uFEYdM0Dq5P1p13Pxo6Rg==
X-Google-Smtp-Source: APBJJlGEDKqK4nyUWs8xE2EOJL+ODt25deDnA1/u8sHRAURqC7uD6bjxMDwwed+SXn6y84Un7sE7wA==
X-Received: by 2002:a17:90a:1090:b0:268:126c:8a8b with SMTP id c16-20020a17090a109000b00268126c8a8bmr24570134pja.3.1691406867003;
        Mon, 07 Aug 2023 04:14:27 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090aca8d00b0025be7b69d73sm5861191pjt.12.2023.08.07.04.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 04:14:26 -0700 (PDT)
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
Subject: [PATCH v4 21/48] sunrpc: dynamically allocate the sunrpc_cred shrinker
Date:   Mon,  7 Aug 2023 19:09:09 +0800
Message-Id: <20230807110936.21819-22-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use new APIs to dynamically allocate the sunrpc_cred shrinker.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 net/sunrpc/auth.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 2f16f9d17966..0cc52e39f859 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -861,11 +861,7 @@ rpcauth_uptodatecred(struct rpc_task *task)
 		test_bit(RPCAUTH_CRED_UPTODATE, &cred->cr_flags) != 0;
 }
 
-static struct shrinker rpc_cred_shrinker = {
-	.count_objects = rpcauth_cache_shrink_count,
-	.scan_objects = rpcauth_cache_shrink_scan,
-	.seeks = DEFAULT_SEEKS,
-};
+static struct shrinker *rpc_cred_shrinker;
 
 int __init rpcauth_init_module(void)
 {
@@ -874,9 +870,18 @@ int __init rpcauth_init_module(void)
 	err = rpc_init_authunix();
 	if (err < 0)
 		goto out1;
-	err = register_shrinker(&rpc_cred_shrinker, "sunrpc_cred");
-	if (err < 0)
+	rpc_cred_shrinker = shrinker_alloc(0, "sunrpc_cred");
+	if (!rpc_cred_shrinker) {
+		err = -ENOMEM;
 		goto out2;
+	}
+
+	rpc_cred_shrinker->count_objects = rpcauth_cache_shrink_count;
+	rpc_cred_shrinker->scan_objects = rpcauth_cache_shrink_scan;
+	rpc_cred_shrinker->seeks = DEFAULT_SEEKS;
+
+	shrinker_register(rpc_cred_shrinker);
+
 	return 0;
 out2:
 	rpc_destroy_authunix();
@@ -887,5 +892,5 @@ int __init rpcauth_init_module(void)
 void rpcauth_remove_module(void)
 {
 	rpc_destroy_authunix();
-	unregister_shrinker(&rpc_cred_shrinker);
+	shrinker_free(rpc_cred_shrinker);
 }
-- 
2.30.2

