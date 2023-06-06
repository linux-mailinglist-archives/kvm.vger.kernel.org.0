Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74357246C7
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 16:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238398AbjFFOu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 10:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238264AbjFFOto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 10:49:44 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771612130
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 07:48:50 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f7ebb2b82cso6776865e9.2
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 07:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686062928; x=1688654928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qP11BZ+0bYtN7sPX4Lr6yDDiHZvt0xfduE9tk3WmOqE=;
        b=dN1OOAWK0Ik3kTXBO7ewCWcD8TURSIsZhB7D5Y5uNkAKnmYXFZsnzdZnndRciP+nOp
         HJgR3cCI3tetqRFzRWfXOjH86qtjTmETOQgsEAWZhZksuRtdOlpQmUXh0EQvQFT/VtO2
         N7HkhzWnB8ECfEC2IpzEac+q9dX/XXS771cHxvcFwgfdkIfo+IM53tbH6gFrhLL7CPFr
         EKtKPt4kBcNe8MjUPYPZUF8vAMl5+1OHCPvNxhu21i2Z3RIX6oV8n1t6pDC0CB9/P8uY
         Sa48rndUY72HwXtb/xRY7OWXOWpnnUZixP5K2p9o45z1iCoA6vS6X8dSE4caXbxcchiG
         H8Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686062928; x=1688654928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qP11BZ+0bYtN7sPX4Lr6yDDiHZvt0xfduE9tk3WmOqE=;
        b=UeqvMrsrg4anb4Ibi4HvEru+JknPwfJjjTaIce1Q6G1lPO7GBQeEa6mpxbmwTS4+Zv
         DvULXVsh54yWaGtu7SgiwAmZJEHpC70ExJfBsanQs1tMQIRa2MwM3Qw1iy8wmQXy5wyo
         TgbV39lm0kf6tjFInTPupZH2jCM11rYT528vcH+gu+9BCgjIhUz++R7HgknLhhKDLcjZ
         8jY3ZOrpcjslDeDnry7KFEYBFrcjz416vTo1WmW7p0TcoH+95mQQxK8GAuwSqqOVqlHg
         1K8qTSKu1pzCRDKoDEeIkibtvXErsO+CptziMw/GEwp/l5ks0d55xu/UTg6IaFG0/fxZ
         /uTQ==
X-Gm-Message-State: AC+VfDz7xfbulLoc7NY2w6G+ipUjWTy5FLsQIqsoE1i27IbooHcLio0F
        KwKAGyFKiJrQHruxOcHVcIKTMXB+XotPYYUSM8MFOQ==
X-Google-Smtp-Source: ACHHUZ6sK5kYN/ko6anK9tUg81nrLVVeLiiSCWg2GET/SDQSDa6ii/AJanNWaPTWwlgW7oGkf4OMuQ==
X-Received: by 2002:a7b:cc8e:0:b0:3f6:766:f76f with SMTP id p14-20020a7bcc8e000000b003f60766f76fmr2333166wma.36.1686062928801;
        Tue, 06 Jun 2023 07:48:48 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id o9-20020a05600c378900b003f7e4d143cfsm5722692wmr.15.2023.06.06.07.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 07:48:48 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 3/3] virtio/rng: Fix build warning from min()
Date:   Tue,  6 Jun 2023 15:37:36 +0100
Message-Id: <20230606143733.994679-4-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606143733.994679-1-jean-philippe@linaro.org>
References: <20230606143733.994679-1-jean-philippe@linaro.org>
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

On a 32-bit build GCC complains about the min() parameters:

include/linux/kernel.h:36:24: error: comparison of distinct pointer types lacks a cast [-Werror]
   36 |         (void) (&_min1 == &_min2);              \
      |                        ^~
virtio/rng.c:78:34: note: in expansion of macro 'min'
   78 |                 iov[0].iov_len = min(iov[0].iov_len, 256UL);
      |                                  ^~~

Use min_t() instead

Fixes: bc23b9d9b152 ("virtio/rng: return at least one byte of entropy")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 virtio/rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virtio/rng.c b/virtio/rng.c
index 77a3a113..6b366552 100644
--- a/virtio/rng.c
+++ b/virtio/rng.c
@@ -75,7 +75,7 @@ static bool virtio_rng_do_io_request(struct kvm *kvm, struct rng_dev *rdev, stru
 		 * just retry here, with the requested size clamped to that
 		 * maximum, in case we were interrupted by a signal.
 		 */
-		iov[0].iov_len = min(iov[0].iov_len, 256UL);
+		iov[0].iov_len = min_t(size_t, iov[0].iov_len, 256UL);
 		len = readv(rdev->fd, iov, 1);
 		if (len < 1)
 			return false;
-- 
2.40.1

