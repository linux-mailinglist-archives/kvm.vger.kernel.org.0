Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DADDB5FC9A7
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 18:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiJLQ7q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 12:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiJLQ7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 12:59:41 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3835FE92A
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:59:32 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id f193so16086115pgc.0
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ewQpo6SyzsCd+TVr4dngzoh/1LumYtAxcdZG9494fvM=;
        b=DzwjZ6oCSiR0/0Xe5yTo5hS4sfi1Qf3T72pp5dGmxcxXxT6xgKZaRowQ0eOCKSrFqW
         NPdaBbujgUM/v4LsY4eYOoV9mqeKbBXdXgrtMXIxWXwmXqOaQvuuzsgwtUa1mtfkTirK
         qUXL4QjIF2PUCPNZtLlNPgFm8RHMOsURdLD2iKzmgASYJJNOSPZGG4np/+/BLiJ2dOxq
         qiS6tUSX80LtJvGXW/5SNO73P01DSDJCDa6w3qh3YGoQioZRJErV7wKiqVjTaN+56Uxu
         PCOEqIZf9emRspCJ9Xjwf0a8rOunDS1URjX8v3ap42r7l70bV5tCORGN49cTznXnV8mr
         oMQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ewQpo6SyzsCd+TVr4dngzoh/1LumYtAxcdZG9494fvM=;
        b=VwGnhzI+hUlxK2nKbBBtJw58vdCFeoPRSkgtYmf350/XkxzvAIgVBqjYcHUBpSnTg0
         ri2FaREEefqYkYgnAb2QNyxRimlBdmwqNatdpWXZU22OIVCkcr92KzYlAfh6saezQURS
         dDgd2O/q7RJ0SsuyCbV5vWhc5YRBCP0ci9dC1cyh8EAli7q6EoljSTZo9FFZerE8sDBl
         Vf+KmKtGKWLKUC1Rr4WPxGCqFPMurFgjsbZyb3aTl1VeKE+Q8iULcpJHTUJaXm4kvz5x
         zzoqzqhSz+s5BSeu1XgQUOJUj/Nmt5ICEQQQo5xwVFrZwaO271SO3TEbHycfQtYBgxTs
         R3Tg==
X-Gm-Message-State: ACrzQf2i4dK1jZPIjM/eTcyTW5x6L3EuYZxj0IOkGIutasI9o4ciMAaz
        MGiBOhNDK4i20LYCAjqege8d6xEmuDoXOQ==
X-Google-Smtp-Source: AMsMyM6QlAXDkvBArVj2SUglXYsmsrSFS9PDQRCfhtMH5c2TRBrdF5AGwHU929t3lHrPygD60k1epA==
X-Received: by 2002:aa7:9057:0:b0:565:d7dd:a453 with SMTP id n23-20020aa79057000000b00565d7dda453mr305113pfo.33.1665593971047;
        Wed, 12 Oct 2022 09:59:31 -0700 (PDT)
Received: from e69h04161.et15sqa.tbsite.net ([140.205.118.126])
        by smtp.gmail.com with ESMTPSA id f8-20020a170902684800b0017534ffd491sm4462697pln.163.2022.10.12.09.59.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Oct 2022 09:59:30 -0700 (PDT)
From:   Eric Ren <renzhengeek@gmail.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     eric.auger@redhat.com, cdall@linaro.org, marc.zyngier@arm.com
Subject: [PATCH] KVM: arm64: vgic: fix wrong loop condition in scan_its_table()
Date:   Thu, 13 Oct 2022 00:59:25 +0800
Message-Id: <acd9f1643980fbd27cd22523d2d84ca7c9add84a.1665592448.git.renzhengeek@gmail.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reproducer hints:
1. Create ARM virt VM with pxb-pcie bus which adds
   extra host bridges, with qemu command like:

```
  -device pxb-pcie,bus_nr=8,id=pci.x,numa_node=0,bus=pcie.0 \
  -device pcie-root-port,..,bus=pci.x \
  ...
  -device pxb-pcie,bus_nr=37,id=pci.y,numa_node=1,bus=pcie.0 \
  -device pcie-root-port,..,bus=pci.y \
  ...

```
2. Perform VM migration which calls save/restore device tables.

In that setup, we get a big "offset" between 2 device_ids (
one is small, another is big), which makes unsigned "len" round
up a big positive number, causing loop to continue exceptionally.

Signed-off-by: Eric Ren <renzhengeek@gmail.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 24d7778d1ce6..673554ef02f9 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2141,7 +2141,7 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
 			  int start_id, entry_fn_t fn, void *opaque)
 {
 	struct kvm *kvm = its->dev->kvm;
-	unsigned long len = size;
+	ssize_t len = size;
 	int id = start_id;
 	gpa_t gpa = base;
 	char entry[ESZ_MAX];
-- 
2.19.1.6.gb485710b

