Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D650799234
	for <lists+kvm@lfdr.de>; Sat,  9 Sep 2023 00:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343757AbjIHW35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 18:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240566AbjIHW34 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 18:29:56 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067D51FC9
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 15:29:52 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59b5884836cso13041417b3.0
        for <kvm@vger.kernel.org>; Fri, 08 Sep 2023 15:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212191; x=1694816991; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QprTGpxfsgvH1yfhYL4R5BCfHsypk0V8kYldvoTmsTo=;
        b=YfMkYJvvDkfBDechruOVmdwZb7Bw22h9+lK0NdeF0isSa8GHk5bWYl+83dt7A5NQ8o
         z77YOdCoYyiErbWgYWnWZRqKwtk6CXP8DqOFm0Eetucqdb4Xfr1L9oalxgnxKQ60jdc1
         3sA/M6G9zvA6iYGK65W+XpLshu0Ffq9LK7RWQxexctu94HGCm3Iwm5Ocw3btag22bcG6
         8LxroYKuCAKhKXDP+Sc3hw0mw+qTZP5F9O5umXF6rBBu/Qvkdr49DOydeFbAcbgrUMfQ
         VylBUwJN+76CwhLioM5N1IYg3t9bI9IAdvw1sujUzzfs1PJOv867hEvEzr7DVNJw6KDN
         mFXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212191; x=1694816991;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QprTGpxfsgvH1yfhYL4R5BCfHsypk0V8kYldvoTmsTo=;
        b=R3Vzr5vwjnwGD3R6n3ebqy6Mo2tOcLj11B57/wYv6Prtfa7IBZLxUktp9MfX9Hggs8
         RLPnSoN+82j+gwsfrR6C/wUQx0JGbLsQwLP0pxi6kJwlIaVS+3vdVYBK+Zuxzn7v+LFG
         vxdHSkg2yUiJgaX8yqDoWt38gx+a7YXKWzvIum73WHsOY8evxFs3GsgfXkJyy8WPvh+f
         Mf9DxGAYWfqpdZoxQZjkcIxM/qDluMro1CwQokPs70Yjx9ZPr6NzM7pdY95vswjHyadh
         SjPSIlyqEp0wgG8kM2Pu6YPXvkkQh9omfb3ReNOK9JjuRYKBhymCMeR6d5buIOLkMR2U
         1yig==
X-Gm-Message-State: AOJu0YwHPqadmUZy/XurRRC/SOnKfglWeqQgYTin7UwbrUlwQDTnnYsK
        ctwMnEeIhenzRzg/cYtpJCDfnVNURi+bVw==
X-Google-Smtp-Source: AGHT+IHIr/vLEv+gPrXhAif3UXfspI7EvM71lsU0z0Vz6t4qHW13LUdBjj766mWb+KiW3puYslbOWzUwEl4Icw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:1682:b0:d7b:8d0c:43f1 with SMTP
 id bx2-20020a056902168200b00d7b8d0c43f1mr90723ybb.9.1694212191262; Fri, 08
 Sep 2023 15:29:51 -0700 (PDT)
Date:   Fri,  8 Sep 2023 22:28:50 +0000
In-Reply-To: <20230908222905.1321305-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-4-amoorthy@google.com>
Subject: [PATCH v5 03/17] KVM: Simplify error handling in __gfn_to_pfn_memslot()
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_HVA_ERR_RO_BAD satisfies kvm_is_error_hva(), so there's no need to
duplicate the "if (writable)" block. Fix this by bringing all
kvm_is_error_hva() cases under one conditional.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 12837416ce8a..8b2d5aab32bf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2741,15 +2741,13 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 	if (hva)
 		*hva = addr;
 
-	if (addr == KVM_HVA_ERR_RO_BAD) {
-		if (writable)
-			*writable = false;
-		return KVM_PFN_ERR_RO_FAULT;
-	}
-
 	if (kvm_is_error_hva(addr)) {
 		if (writable)
 			*writable = false;
+
+		if (addr == KVM_HVA_ERR_RO_BAD)
+			return KVM_PFN_ERR_RO_FAULT;
+
 		return KVM_PFN_NOSLOT;
 	}
 
-- 
2.42.0.283.g2d96d420d3-goog

