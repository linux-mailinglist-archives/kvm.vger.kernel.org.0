Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB3376AB6D
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 10:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbjHAIyx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 04:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbjHAIye (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 04:54:34 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EA71734;
        Tue,  1 Aug 2023 01:54:27 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1b8b4749013so42763555ad.2;
        Tue, 01 Aug 2023 01:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690880067; x=1691484867;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=obIIqi6GQIJIZ75YlNmR0Jy7uI7YvSp7DyHd5K6a0bc=;
        b=OpL9SHmw/Skx7X4Ev7MOvhr24Yvt17nK61O+WEtVU0+wFsPveuFjvoUFVDZWmsjh4s
         kSsDzmOPmDr9C4NbPL3XYYw9+TeC+TdM+MRk80mWn7sn7tmmthql+eaEWImN/YWFupEj
         9pRXQmUo6ZJIwBeir3gm/wczaktTrCvPXfL9qAOeDpkds5mOvRpsR5utbowBXoHpCRdP
         uKPvXOunZjC89+AH2uDDgbwjH6bpQv46uemSNk11E30caBBDL64OR5M+MXqhY6A/yt/i
         nWn5Vb4gWgMAhfWcU34pBDXwkXzXLSiHPov49MnBugZrKJhA6RD/FkkTbb0WKHdoWETV
         Ltuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690880067; x=1691484867;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=obIIqi6GQIJIZ75YlNmR0Jy7uI7YvSp7DyHd5K6a0bc=;
        b=J7eNUPqCwY7Y5haBikbjsg/noLDXTXCVBxMMaD1HB8jZ+X1r+qgLiHUafUGt6on7sw
         tYsBd8ecqbGyg/mchPisyQyPiUCl5c4Cm4cHBThcB8altao9UTU3A52L/VMhSWtCVsDb
         r0Ce1JC+WrU0zWYhRye7iQdF7cXrNa72oXJGTtQ3Nk654EXRkHzsj0vGA1ZeGxPvChRV
         2UJaN1+/hwEfm3aWu1wf4sgbNrPxvm9G2o87jcygQnON5Q880M7sP/uKlQpiDQe0mrEm
         ElQQ5TzBLYAlkg0lGwDKhaKBhCFJ5VTyOP0AK0tW+P+6BRHBerOsehMDliSBEA/iPM4t
         9naA==
X-Gm-Message-State: ABy/qLapx5fqDkW9AzS32C3vfykTyOgm/zix4a3za22dZTUHkNHsSXgm
        hsIO+uPcquzxjcdZgzRyRJY=
X-Google-Smtp-Source: APBJJlF3xYLfEJ+5g98Vrd4slkN7LscyOiT+lLySO+fG8IZ0yNkHPPcstcK2eqJDRXdNBA4bx6JHmA==
X-Received: by 2002:a17:902:8f85:b0:1ac:7345:f254 with SMTP id z5-20020a1709028f8500b001ac7345f254mr10938331plo.33.1690880067249;
        Tue, 01 Aug 2023 01:54:27 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id e4-20020a170902b78400b001ba066c589dsm9877598pls.137.2023.08.01.01.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 01:54:26 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: eventfd: fix NULL deref irqbypass producer
Date:   Tue,  1 Aug 2023 16:54:08 +0800
Message-ID: <20230801085408.69597-1-likexu@tencent.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Adding guard logic to make irq_bypass_register/unregister_producer()
looks for the producer entry based on producer pointer itself instead
of pure token matching.

As was attempted commit 4f3dbdf47e15 ("KVM: eventfd: fix NULL deref
irqbypass consumer"), two different producers may occasionally have two
identical eventfd's. In this case, the later producer may unregister
the previous one after the registration fails (since they share the same
token), then NULL deref incurres in the path of deleting producer from
the producers list.

Registration should also fail if a registered producer changes its
token and registers again via the same producer pointer.

Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 virt/lib/irqbypass.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
index 28fda42e471b..e0aabbbf27ec 100644
--- a/virt/lib/irqbypass.c
+++ b/virt/lib/irqbypass.c
@@ -98,7 +98,7 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer)
 	mutex_lock(&lock);
 
 	list_for_each_entry(tmp, &producers, node) {
-		if (tmp->token == producer->token) {
+		if (tmp->token == producer->token || tmp == producer) {
 			ret = -EBUSY;
 			goto out_err;
 		}
@@ -148,7 +148,7 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
 	mutex_lock(&lock);
 
 	list_for_each_entry(tmp, &producers, node) {
-		if (tmp->token != producer->token)
+		if (tmp != producer)
 			continue;
 
 		list_for_each_entry(consumer, &consumers, node) {

base-commit: 5a7591176c47cce363c1eed704241e5d1c42c5a6
-- 
2.41.0

