Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2407676C4B7
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 07:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbjHBFR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 01:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbjHBFRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 01:17:24 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7013F1BFD;
        Tue,  1 Aug 2023 22:17:22 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1b9c5e07c1bso54640345ad.2;
        Tue, 01 Aug 2023 22:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690953442; x=1691558242;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5aA5JIT6ardwan6m5SFrBRELKgm9+/graZUkPPo07yI=;
        b=q7uCK5VordhnMcT6Tz24S/dN/Vn2wrSzLgX2dpILJ6wRV6TK6oN2TyUS6RqCEyV7hL
         nntU07Yf24yserlGDfyafGLY9SzFAEsKDmfQHHEDv9RqIeqOkmAer9sRMOcONoOdzqpp
         nOlHhvW5PXBQb62KXzZZZx+QL7xwtHw+88lyK+MRRl70SEKwGGihs/H7LU5KyZimLcuQ
         G/Lny3nf6gW0DdDIprZEFHbuwDJWIsA/KCtAZnw5+nIe+YXV/PWWRSqqwukDSB9VB+Sq
         BvQ4VI/gyuSHWg/15j1wrojTrs+hE+kIUS9Adqj1vazvrRYP70DsrTMNUfQYv1Y99+TT
         +wgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690953442; x=1691558242;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5aA5JIT6ardwan6m5SFrBRELKgm9+/graZUkPPo07yI=;
        b=MDCbwh42FETez1Fh3+KR3Y7CoU4NBDzbFuW0+qDMRjHKzvkbw13bAeY9cHItkowCrr
         eBCTsIGjgHAXoG3gPE9us7gZl+LhWukPdf7xUCHy7Nmt7l2QL+zlYgOxtXUKmrsLldSR
         f/ZQcQVlPBHQyF2QEEdPP963YQiI/O/1VJ4AOaQpJjB5SHy01bOCV8DbEmpA8IgLYWrW
         YW3QCfzHzobpn7QycSUm91fsMEqLJEbxZPGJ2oVBpbu34Eapd4s+cBhLFOYQ1Qt+vpml
         kjcWrfSpGb1m4GYAj9Rlg/8avfwXMIRgvjoYofj2jd9huOjYAHovRzThBCLt0D9TPHxl
         AOwg==
X-Gm-Message-State: ABy/qLYFR4LWHz0ZTbYdIharnItlk3PnhK9czg5xJA3He8sGdSD6+0RO
        1wzfVqICUNBUVMr8fZCUlK4=
X-Google-Smtp-Source: APBJJlHjwCEcvdsQuQrQOVoQmjE+0k0ALlSHusRTo5K46jnkSLwJUSYTWzmsbQWefU2k+AdsFSv5tQ==
X-Received: by 2002:a17:903:245:b0:1b8:abe7:5a80 with SMTP id j5-20020a170903024500b001b8abe75a80mr17356754plh.40.1690953441838;
        Tue, 01 Aug 2023 22:17:21 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id f8-20020a17090274c800b001bba7002132sm11330446plt.33.2023.08.01.22.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 22:17:21 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH v2 1/2] KVM: eventfd: Fix NULL deref irqbypass producer
Date:   Wed,  2 Aug 2023 13:16:59 +0800
Message-ID: <20230802051700.52321-2-likexu@tencent.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230802051700.52321-1-likexu@tencent.com>
References: <20230802051700.52321-1-likexu@tencent.com>
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
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
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
-- 
2.41.0

