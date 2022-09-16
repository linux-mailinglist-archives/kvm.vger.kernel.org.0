Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5751D5BA3A3
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 02:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiIPA44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 20:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiIPA4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 20:56:51 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E532D8708D
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 17:56:48 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1oYzew-002Bn9-H3; Fri, 16 Sep 2022 02:56:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=Nbx0qEJbmE3wkbMudVTcZbk3+sR5wz9lz41Vcj7v81w=; b=LXlfqLH5OR7LL1WGfyOqz7HFe5
        bSKErtLPQRCkZSSaS664wJLX5dgl9RStkuTBtoJ59LK1UlfcBPdh2r3ijv6N17s69CCbyJyjmeM9o
        dclxU4TWXIxS5UUQfWfFmxDw9JGlJx3tus2frmXlCo14qTXboYL2AshzXQVrUYcaBSZSYvFnC467c
        aI2umWzikIpo81xEmYDKkH2RhlGBKb/be4kskyVJB2lYm+X8/IjXmHRuroXL+QIfkU3WpIp0/U5QL
        Ajn8VoS1N/rL9nYdWOzC311fdLKgRkfcWwxYlmP275VquDDbZx1QjC94LlsHWeblINi6cl/Mt7Vsy
        g17AAdJg==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1oYzew-00028L-61; Fri, 16 Sep 2022 02:56:46 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1oYzel-0000xy-1Y; Fri, 16 Sep 2022 02:56:35 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, shuah@kernel.org,
        Michal Luczaj <mhal@rbox.co>
Subject: [RFC PATCH 3/4] KVM: x86/xen: Disallow gpc locks reinitialization
Date:   Fri, 16 Sep 2022 02:54:04 +0200
Message-Id: <20220916005405.2362180-4-mhal@rbox.co>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220916005405.2362180-1-mhal@rbox.co>
References: <20220916005405.2362180-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are race conditions possible due to kvm_gfn_to_pfn_cache_init()'s
ability to _re_initialize gfn_to_pfn_cache.lock.

For example: a race between ioctl(KVM_XEN_HVM_EVTCHN_SEND) and
kvm_gfn_to_pfn_cache_init() leads to a corrupted shinfo gpc lock.

                (thread 1)                |           (thread 2)
                                          |
 kvm_xen_set_evtchn_fast                  |
  read_lock_irqsave(&gpc->lock, ...)      |
                                          | kvm_gfn_to_pfn_cache_init
                                          |  rwlock_init(&gpc->lock)
  read_unlock_irqrestore(&gpc->lock, ...) |

Introduce bool locks_initialized.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 include/linux/kvm_types.h | 1 +
 virt/kvm/pfncache.c       | 7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 3ca3db020e0e..7e7b7667cd9e 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -74,6 +74,7 @@ struct gfn_to_pfn_cache {
 	void *khva;
 	kvm_pfn_t pfn;
 	enum pfn_cache_usage usage;
+	bool locks_initialized;
 	bool active;
 	bool valid;
 };
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 68ff41d39545..564607e10586 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -354,8 +354,11 @@ int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 	WARN_ON_ONCE(!usage || (usage & KVM_GUEST_AND_HOST_USE_PFN) != usage);
 
 	if (!gpc->active) {
-		rwlock_init(&gpc->lock);
-		mutex_init(&gpc->refresh_lock);
+		if (!gpc->locks_initialized) {
+			rwlock_init(&gpc->lock);
+			mutex_init(&gpc->refresh_lock);
+			gpc->locks_initialized = true;
+		}
 
 		gpc->khva = NULL;
 		gpc->pfn = KVM_PFN_ERR_FAULT;
-- 
2.37.2

