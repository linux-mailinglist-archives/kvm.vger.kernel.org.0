Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1994951995C
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 10:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235755AbiEDIPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 04:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235359AbiEDIPk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 04:15:40 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615CA2251B
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 01:12:05 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id k1so780413pll.4
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 01:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hD5USw9FF9HV/X5U0aivzbN+ZnORBn+kZgdLtLnjivk=;
        b=iw4c104tFQPywYFsLCBUYs1gaK85bbfAUayleb5ynkagf1bNl3V8nAn2OwXJLETfse
         gdpaJV7QbDewtmT5M8fErnlWtBLTzdyZ3mr4BGoWwYtkphyrqdqlyTKMeOepQCTGf2xQ
         qjbG1/dycWIEiXn62vgH/0yBxCnyo+14tHEHVerFovcA3EDIF+9y0VXG6EpZBPuYddMR
         VmfIb/QrsuFlL/aaKCy3uHh51N/8IfQrNF1oDjMHGmfTqr5/9q8rTOs8MG6dWG0Jc3rj
         0o1W+inGhkIuTi6p2Bf7my59Yu2biuaWVwJH4NOBnyxHFRcbBBc0TsFujiQazBTTU6NB
         woIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hD5USw9FF9HV/X5U0aivzbN+ZnORBn+kZgdLtLnjivk=;
        b=l7DeKdIbIbafjKqJgOHUXLTXAFpoBs8DlqB1gx/HelQ6Fa6SBoH4dwiaSWYdCgaWd2
         B0QatpJjAwPFz3355i10NN6LQ3hXT/eJbmZc9BqX5OrRJWfrrf9DwFQ+Xmy1O5Z2CQpp
         nRY110jWr+BljJdx1GH+ubgguxaMmq3ufT7M74thqyj4wxovP2bptJD661bLbfGjJ2Hn
         Tx2vniozsR6CHN63IIwncWSQP3MWdpMRDMX4UaExTpZpRaPOD1aOoWCQabQXbVsZ7Lim
         0hGW9UDUqv2CgzwLE8VQVS3TZBtvpqEIdsVeN6eh+aYVyUEVFPrw+U6xVpN+l1MCEBOb
         cy1Q==
X-Gm-Message-State: AOAM5312u3Ww9y0Ge+ypWQP1BEBjh8KUaIrVT0f3d50lYIKwBsae7Py6
        0Kr37q+arHr3GgYH2niUzAqz
X-Google-Smtp-Source: ABdhPJxlDBjjlaq1Yq8i/MYBmyKtklqnCphnh45P1MtvJFIGd77EBP1ya0sLGPCSaZMXez2lo7zwKQ==
X-Received: by 2002:a17:902:6bc9:b0:158:b9d0:1e3b with SMTP id m9-20020a1709026bc900b00158b9d01e3bmr20382359plt.84.1651651924918;
        Wed, 04 May 2022 01:12:04 -0700 (PDT)
Received: from localhost ([139.177.225.233])
        by smtp.gmail.com with ESMTPSA id o3-20020a63f143000000b003c14af5062asm13659174pgk.66.2022.05.04.01.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 01:12:03 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, rusty@rustcorp.com.au
Cc:     fam.zheng@bytedance.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] vringh: Fix maximum number check for indirect descriptors
Date:   Wed,  4 May 2022 16:11:17 +0800
Message-Id: <20220504081117.40-1-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We should use size of descriptor chain to check the maximum
number of consumed descriptors in indirect case. And the
statistical counts should also be reset to zero each time
we get an indirect descriptor.

Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Signed-off-by: Fam Zheng <fam.zheng@bytedance.com>
---
 drivers/vhost/vringh.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 14e2043d7685..c1810b77a05e 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -344,12 +344,13 @@ __vringh_iov(struct vringh *vrh, u16 i,
 			addr = (void *)(long)(a + range.offset);
 			err = move_to_indirect(vrh, &up_next, &i, addr, &desc,
 					       &descs, &desc_max);
+			count = 0;
 			if (err)
 				goto fail;
 			continue;
 		}
 
-		if (count++ == vrh->vring.num) {
+		if (count++ == desc_max) {
 			vringh_bad("Descriptor loop in %p", descs);
 			err = -ELOOP;
 			goto fail;
@@ -410,6 +411,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
 			if (unlikely(up_next > 0)) {
 				i = return_from_indirect(vrh, &up_next,
 							 &descs, &desc_max);
+				count = 0;
 				slow = false;
 			} else
 				break;
-- 
2.20.1

