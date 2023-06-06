Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A857243A6
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 15:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237951AbjFFNFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 09:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237919AbjFFNFW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 09:05:22 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF622118
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 06:05:20 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f6da07feb2so60670225e9.0
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 06:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686056720; x=1688648720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H8CiZLAonXPhMpCBmNdJAlRlloBFl60CEtSHxKl/b6Y=;
        b=qtKeEMKVJ/8CiyNzrp5tN5cjwJCoe3eyabwWLYBFWtWVidAdKTigL7EQePI9UjWu9/
         0XCS4OSiglO6Z57C8M9SzHGa2js2aZKNQs8xHk2vrWhZi+EDJh2bttYraQhEPxNHRyy7
         +gDYV7XNWSF8AoN1zfuenViUZAzfyvCoF10BlKoMyNRFf60Y5aF4Q0/GWYTPC76/dirQ
         UNNtIiAAY+0evixIefbWScbNISMjeXmcPDiXkM7EOKrigjw2vWnVlDSKwFkPXPsRZejJ
         1dF76whoe+bBaZClN9tdVZxracVr4BgPiybK/YQdy7wAuNvrQJNFtGVWw51bW1Qh1OjL
         TJNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686056720; x=1688648720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H8CiZLAonXPhMpCBmNdJAlRlloBFl60CEtSHxKl/b6Y=;
        b=IP+wIRFz++a2bvWgMMfpBenSJqID83fzbQHHKwXydI6r6HTB7gR/YwGWuCBBFzCWVd
         4uXbiWH0Qs/nLvObw8Iy1P0oH/UBms/7ZeNHoLrFd1N7EjpsKghh66B1t6dk4OET2psN
         cdJyryXGLMescwJhtMFj/FCt6niOfC9MRlUsXIhBhAIM3LC8uHmYsI1vwKAsYFPLFdcf
         B7vc2dcVLN1D2s8wby3P4ZwOGNdUbY+9dy+8yASd7qEDxIS0Q7AB7l4doJzzW8fvKzwk
         g+MBWSOMQW4cqtNTAWKGRyh6MYM5gZTNeLKGc0CyCaxXcWcCproMRNqhPh6oO5RUrOlN
         Yj5A==
X-Gm-Message-State: AC+VfDx34uJ9LB6PUzLmZb2mFW06aLWyYN7nXn83dr64mGjGCq67x0iN
        GM+EnNVmsOQnwPWftZO4nNOVnTLlhuRQxzrkQep7hw==
X-Google-Smtp-Source: ACHHUZ5+9j7szOf4UJJe8yB402qVI5zVrAn2knHGQqVCi44H8chcpcDpANdomK6S75HtZezhcymNdw==
X-Received: by 2002:a7b:cb94:0:b0:3f7:381a:f5b5 with SMTP id m20-20020a7bcb94000000b003f7381af5b5mr2042256wmi.9.1686056720607;
        Tue, 06 Jun 2023 06:05:20 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id h14-20020a5d504e000000b00300aee6c9cesm12636125wrt.20.2023.06.06.06.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 06:05:20 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     andre.przywara@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool v2 14/17] virtio/net: Warn about enabling multiqueue with vhost
Date:   Tue,  6 Jun 2023 14:04:23 +0100
Message-Id: <20230606130426.978945-15-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606130426.978945-1-jean-philippe@linaro.org>
References: <20230606130426.978945-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vhost-net requires to open one file descriptor for each TX/RX queue
pair. At the moment kvmtool does not support multi-queue vhost: it
issues all vhost ioctls on the first pair, and the other pairs are
broken. Refuse the enable vhost when the user asks for multi-queue.

Using multi-queue vhost-net also requires creating the tap interface
with the 'multi_queue' parameter.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 virtio/net.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/virtio/net.c b/virtio/net.c
index c4d20f22..02667176 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -741,6 +741,11 @@ static struct virtio_ops net_dev_virtio_ops = {
 
 static void virtio_net__vhost_init(struct kvm *kvm, struct net_dev *ndev)
 {
+	if (ndev->queue_pairs > 1) {
+		pr_warning("multiqueue is not supported with vhost yet");
+		return;
+	}
+
 	ndev->vhost_fd = open("/dev/vhost-net", O_RDWR);
 	if (ndev->vhost_fd < 0)
 		die_perror("Failed openning vhost-net device");
-- 
2.40.1

