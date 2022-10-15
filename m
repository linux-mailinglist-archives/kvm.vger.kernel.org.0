Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5AB5FF828
	for <lists+kvm@lfdr.de>; Sat, 15 Oct 2022 05:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiJODTp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 23:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiJODTn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 23:19:43 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407C2E7D;
        Fri, 14 Oct 2022 20:19:38 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so9549305pjq.3;
        Fri, 14 Oct 2022 20:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=62n/SKrDkBxAMeilZhMyUB+MsRZ+hq6qWI8NmvUUw/Y=;
        b=ZgXqEF1Cf0UI0SlcSm6xYR2RqEJMRcTTEYUOLuYzMrWP4a1ySXtjBwBX+UeSqYrgud
         8K9h3/PzsXf/pPH73Q1OqFNevxJXgkOtsMsawPfu8Q+TNhvz8n9DB088m82Q2UH+7Dab
         HmvVICBXmIBOlQT1Kwx/btsSaQrr8lZ0LCTFuXycvwYRhRRX6V7dBgyhHp4j/g9cqfCh
         GDnl4plmjDjOg5vAJ+u+hDoRXLUTkuznJnHKi2rgHiF3eQoSL6cgTzi7TvDOyHLRUTIX
         pEw5b3KhucQRm3oU7XegKBJK8AiYM0bYKn6ZK3HGDZKtlcJNJrLvdScaY/Ewt1/gf2PH
         K3Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=62n/SKrDkBxAMeilZhMyUB+MsRZ+hq6qWI8NmvUUw/Y=;
        b=LHEG3qwi7mDHx3KNPhq1hvAX18IKCOJPTRzJgI5pfLBOk+RKqKIDsDP4H3OLTlC4s/
         zML7dya+yEoHwb4Li4XNOCORLChV6qnW6spI3icUKa+uVdwyKctFyX2/RQvPaCwcYkPf
         GynFqugsbQ9CuBOr4z4u2SPRQjpLFeZD0zr2dmKkPJokJmMqx50xdKUioKajTF5Xlk9n
         Lb9oRg5QrVMfCgDpcIlW0FWILRnQySPj9Dj2SiI4nEIlHqQeo1zGWufv5bF7RM5ip5jt
         3S4liFhPCmK3Fu2b6UR3NmCvgzUkZbzvxhXT9H/kdOxW0hf5d+AN9xRUhs6De2Us+HP5
         Qv5Q==
X-Gm-Message-State: ACrzQf1IYx5pnRxWEKSzebzeLFM172jWezMSoluZoEWf8PRsAKmcUv/2
        mJYh5NYe/bb2rQa4bIhbLyA=
X-Google-Smtp-Source: AMsMyM5NBdJT1xV/iPskYV3xpxtHE/cTYEF+pA7jg6hgAcKEZTikivegIkKlM1tCU28TSxnGn/EYAQ==
X-Received: by 2002:a17:902:9048:b0:17f:93a5:4638 with SMTP id w8-20020a170902904800b0017f93a54638mr1077192plz.108.1665803977349;
        Fri, 14 Oct 2022 20:19:37 -0700 (PDT)
Received: from e69h04161.et15sqa.tbsite.net ([140.205.118.227])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090a290200b0020a7d076bfesm2129699pjd.2.2022.10.14.20.19.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Oct 2022 20:19:36 -0700 (PDT)
From:   Eric Ren <renzhengeek@gmail.com>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        eauger@redhat.com, maz@kernel.org
Cc:     james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        catalin.marinas@arm.com, will@kernel.org, ricarkol@google.com,
        eric.auger@redhat.com, yuzhe@nfschina.com, gshan@redhat.com,
        justin.he@arm.com
Subject: [PATCH V2] KVM: arm64: vgic: fix wrong loop condition in scan_its_table()
Date:   Sat, 15 Oct 2022 11:19:28 +0800
Message-Id: <d9c3a564af9e2c5bf63f48a7dcbf08cd593c5c0b.1665802985.git.renzhengeek@gmail.com>
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
2. Perform VM migration which calls save/restore device tables;
3. vgic its use 2 level device table.

In that setup, we get a big "offset" between 2 device_ids (
one is small, another is big), which makes unsigned "len" round
up a big positive number, causing loop to continue with a
bad GPA. For example,

1. L1 table has 2 entries;
2. and we are now scanning at L2 table entry index 2075 (pointed by L1
first entry)
3. if next device id is 9472, we will get a big offset: 7397;
4. with signed 'len', 'len -= offset * esz', len will underflow to a
positive number, mistakenly into next iteration with a bad GPA;
(It should break the current L2 table scanning, and jump into the next
L1 table entry)
5. that bad GPA fails the guest read.

Fix it by stopping the L2 table scan when the next device id fits
into next L1 table entry.

Thanks Eric Auger's suggestion for the fix.

Fixes: 920a7a8fa92a ("KVM: arm64: vgic-its: Add infrastructure for tableookup")
Signed-off-by: Eric Ren <renzhengeek@gmail.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 24d7778..733b530 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2149,7 +2149,7 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
 
 	memset(entry, 0, esz);
 
-	while (len > 0) {
+	while (true) {
 		int next_offset;
 		size_t byte_offset;
 
@@ -2162,6 +2162,9 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
 			return next_offset;
 
 		byte_offset = next_offset * esz;
+		if (byte_offset >= len)
+			break;
+
 		id += next_offset;
 		gpa += byte_offset;
 		len -= byte_offset;
-- 
1.8.3.1

