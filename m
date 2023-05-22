Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B7B70B806
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 10:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbjEVIug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 04:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232443AbjEVIud (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 04:50:33 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC75ACE;
        Mon, 22 May 2023 01:50:32 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-64d18d772bdso4961341b3a.3;
        Mon, 22 May 2023 01:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684745432; x=1687337432;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NJhELKwtMjd03gNF7KmpEmVCJma8B6XT7EEG5otj68M=;
        b=ApcHDbXTiygQvtexd+vH27HcMnwm6bAyv7n6XhOBgE++bWis9vPRqHRS0W6qj5V7DR
         mL5tEC5V7b7/FTroGNrJMazKDOznlB5qH/axuJJeAgq8MC0+ykmqNx5K8iUbqTN3wuRq
         PPSaBggEStKjiLJP/tUl1j7ogRWr0hYF3m9KDRsVamU7UsFj8kaAeBVE09hT6s7x43is
         HqyQ5pfLphm3MK2dL6jdmiGUxET985tsdSBN/vCXQmh8NGz7pIXzdj10SBZ5Y0R4J5gB
         X84ThREsJJGV8FfhQQjm4sVUphClHcb+Edgn7WKcbhuDILxuGPF8UtoSSov/vwb79hvQ
         haDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684745432; x=1687337432;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NJhELKwtMjd03gNF7KmpEmVCJma8B6XT7EEG5otj68M=;
        b=U7ZUpx3/MTHXGDCOli6HWhaAQ3XD+hm00wI935krr5Qyq7xHPT44EPCq8sRSWTq2rO
         Zj2DgZT/B9ntvD17QIXCZ/VvQVakpXa5U5nkyJaHZ5xF/QVy4cjcwemxRkLsBKcJbjXq
         fVvAzm1Rtsi6CrfCgVmguVkCGDrAEGCiVafvLKb/73IF6ZdbyMw+zP/xLyzWEIqepL+G
         d6xoJ0cxc85JUfbo13doOJhkkE+5uXjquInBFDk2EJ2yRVjoJAT0e3dHeGiFozb2iNIx
         /DtDOfgI2eJugdu2p7ZCjeRKvO0L/CEfm9p8TzpbV7xL15+6/vWYkZnpIIiNYEQdNn22
         kPvg==
X-Gm-Message-State: AC+VfDygYMabSxt09wJZBAvdvg7T7ZJh9JVlQ+67ypCk2jH+hJip3XGv
        //N0UARjhbFCnBOWQ3AM+rw=
X-Google-Smtp-Source: ACHHUZ524pmmQh/7hgo03RLWHzP+ui6VLuXisoysGbVKTbXezkSO3sbxAKJtkMiccFEkQI5HkBBPnA==
X-Received: by 2002:a17:902:e5ce:b0:1ac:b449:352d with SMTP id u14-20020a170902e5ce00b001acb449352dmr12242806plf.61.1684745432206;
        Mon, 22 May 2023 01:50:32 -0700 (PDT)
Received: from redkillpc.. ([49.207.202.99])
        by smtp.gmail.com with ESMTPSA id d20-20020a170902c19400b001ab01598f40sm4319367pld.173.2023.05.22.01.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 01:50:31 -0700 (PDT)
From:   Prathu Baronia <prathubaronia2011@gmail.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Prathu Baronia <prathubaronia2011@gmail.com>
Subject: [PATCH] vhost: use kzalloc() instead of kmalloc() followed by memset()
Date:   Mon, 22 May 2023 14:20:19 +0530
Message-Id: <20230522085019.42914-1-prathubaronia2011@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use kzalloc() to allocate new zeroed out msg node instead of
memsetting a node allocated with kmalloc().

Signed-off-by: Prathu Baronia <prathubaronia2011@gmail.com>
---
 drivers/vhost/vhost.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index a92af08e7864..579ecb4ee4d2 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2575,12 +2575,11 @@ EXPORT_SYMBOL_GPL(vhost_disable_notify);
 /* Create a new message. */
 struct vhost_msg_node *vhost_new_msg(struct vhost_virtqueue *vq, int type)
 {
-	struct vhost_msg_node *node = kmalloc(sizeof *node, GFP_KERNEL);
+	/* Make sure all padding within the structure is initialized. */
+	struct vhost_msg_node *node = kzalloc(sizeof(*node), GFP_KERNEL);
 	if (!node)
 		return NULL;
 
-	/* Make sure all padding within the structure is initialized. */
-	memset(&node->msg, 0, sizeof node->msg);
 	node->vq = vq;
 	node->msg.type = type;
 	return node;

base-commit: 4d6d4c7f541d7027beed4fb86eb2c451bd8d6fff
-- 
2.34.1

