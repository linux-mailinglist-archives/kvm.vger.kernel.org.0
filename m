Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38CA4B86D2
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 12:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiBPLiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 06:38:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiBPLiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 06:38:13 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18D166AFD
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 03:37:59 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id h7-20020a17090a648700b001b927560c2bso2128490pjj.1
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 03:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oSvJzwbbCZ77mjyEB/Vm/87qVIfqe3Yf5ZgLvOU+jWM=;
        b=xt58ZkjaXPxoUeWp4tnx0bA5+Qm6/am9T4wNyKjpZzxmrj4tCYBzOHvO6m39r8rYR6
         3wyukts5QdHuZl7Vy8YenZdMyZ+hdudE/k1ZYevqbyfAM2ZpJ8TcV+uCZ16IQcwiT9eC
         Q3SzDhimcLr9n1qu21iRcckzOnaW7IV0vDp+Bfs8wemh5KtjAsSSf08r8EIiJl1ZGJ7x
         6FJY2kiE5HK2SqZK90W0Qsv7VXmtdYc9LeOhginJP5rVe7XrUr7/52ZJbrs+PJhJlGhj
         tGpeT4dp44Rkfti5Y1X/bmwy3bzVQK4x88nh7TIX4PMhPkvy7QPdpabtK+c/NJ/xgTrc
         zctg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oSvJzwbbCZ77mjyEB/Vm/87qVIfqe3Yf5ZgLvOU+jWM=;
        b=sD1DP8oet2wOcNVVrmqo0oGnTJBhXFm3iwQaeC2OUHHXXoNkv7+jViGLteKdkH8r7w
         H21b/I4L1MdLt4b+6wghZqH8Z2h4XM+VAFwUxBRhZ9UYhS+GMUZIMlPJFJEgRdfAfkYI
         nQcjGJyTkYdnCljSL9DKF6cJ/LY/1yFJJOVcG3Y2jRxqmQn8R/sfqM3hdaaoa7beOKul
         XKLtHqhwjQ1oGYUgiEaoLo0PRn5tYW3DtlQ17We51BVUXGoHr2B/kPYQD2mP+dHC3Utx
         b1QXPOWL1JktJ3ZmkjePppvQjLlM3d20AJtEuaUt3ozapVBZ2/vGZdzUaR8cHhs0BMvF
         J2Ew==
X-Gm-Message-State: AOAM532mu6xddCusZyJ6P8n807FEhRJDRkekeuPVAx8ewcES8bmC/YZx
        nmEzSfZq+QGSelBwB4re8Q5lPw==
X-Google-Smtp-Source: ABdhPJx7XDfnrklMRt/a8Mvhqt4Uf3PGNqodyXJi0jIDmouHqYU7yQ31GvKvVMdrjDVAAtiZxsLsGw==
X-Received: by 2002:a17:90b:4b92:b0:1b7:aca7:b2f3 with SMTP id lr18-20020a17090b4b9200b001b7aca7b2f3mr1221377pjb.169.1645011479319;
        Wed, 16 Feb 2022 03:37:59 -0800 (PST)
Received: from FVFYT0MHHV2J.tiktokcdn.com ([139.177.225.233])
        by smtp.gmail.com with ESMTPSA id z21sm5248228pgv.21.2022.02.16.03.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 03:37:59 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com,
        alexandru.elisei@arm.com
Cc:     kvm@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH kvmtool v2 1/2] x86: Fix initialization of irq mptable
Date:   Wed, 16 Feb 2022 19:37:34 +0800
Message-Id: <20220216113735.52240-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When dev_hdr->dev_num is greater one, the initialization of last_addr
is wrong.  Fix it.

Fixes: f83cd16 ("kvm tools: irq: replace the x86 irq rbtree with the PCI device tree")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
v2:
- Rework subject.

 x86/mptable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/mptable.c b/x86/mptable.c
index a984de9..f13cf0f 100644
--- a/x86/mptable.c
+++ b/x86/mptable.c
@@ -184,7 +184,7 @@ int mptable__init(struct kvm *kvm)
 		mpc_intsrc = last_addr;
 		mptable_add_irq_src(mpc_intsrc, pcibusid, srcbusirq, ioapicid, pci_hdr->irq_line);
 
-		last_addr = (void *)&mpc_intsrc[dev_hdr->dev_num];
+		last_addr = (void *)&mpc_intsrc[1];
 		nentries++;
 		dev_hdr = device__next_dev(dev_hdr);
 	}
-- 
2.11.0

