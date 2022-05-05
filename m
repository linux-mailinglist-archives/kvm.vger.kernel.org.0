Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2ED551BCD7
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 12:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354832AbiEEKMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 06:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239364AbiEEKMS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 06:12:18 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15C049927
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 03:08:38 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d17so3973141plg.0
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 03:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bBSR1WEhLn4UKTPJ4E88a+r4ZuEVjsELUbXLBNmycv8=;
        b=VcTWKMZKPcssRdDPn5osxP+ESwLckKDRTnaMRNiZ4ZCQCC+UiQqSiZliZL0mxLZRZm
         HacGqDjF5zNShvF2V10fWlYpm+Cx4yLjn8wy0wpZUBNAFmStbO+e9Q2zScdIHNtWewOx
         b2GIjOqUVVtecMCYjRP3uoOhYBZjuOAWG6UuNo4l59PJHUvXdV/yjX86vBZ2IZL1gaSF
         h7HggkZ6JWYwE80N2r7oWxWQCZmSpL25K4m4TxqE5cR8/DDlHgOWGwbvKG9hA6JV7XZS
         E/hubaX1jymiOQ1142eC/AbH0t1DHcvzPTaqNqfS/cEtUqnU7pik3/E+Zl6ggxPRWWy4
         tNXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bBSR1WEhLn4UKTPJ4E88a+r4ZuEVjsELUbXLBNmycv8=;
        b=eKf0F26tq1DUjKw5CGfqfk8Tp+Jk5fZss3JpqRRtiKv+a2ebQUJKFGWRpLXIrTm4XE
         TJFF2F4UBynLM1cRwHrTDsCC2JRd1c6sWDcTTa1w/BHIRJShFs59Vx9YzKjHtz2Ymr12
         QqQv44a+xrC+NRaPdMZIjYqjC1c+3KqQ+5Z3QEtG05Q37K9yP0gxaoJmsb2TvosO54fh
         iwYrHDp6PazItu18nQCpTvGUADPkSADJXIllx/kTWZHIs8xe4CbPbnYCVupW6Q++hUyR
         OsbMwK4/7vzXGG7uh+VskbeOW3PStme6atNBjIiafAlQVn5hF6WaDbgna3AJjRBM59HI
         GrgQ==
X-Gm-Message-State: AOAM5321iLkW9TyCyPRFFG+O9f4umep72gtC6YYFCyc7CeY2lzRHTbH1
        w5YCHz4AOvDqBNf6hYdTfmsm
X-Google-Smtp-Source: ABdhPJwrPbseKcZQOr21F19jpSFTW+ZwPsgsqq9GSlbRXxxnkLnsGcOIoRKWpAXxlM3bXre2/embNA==
X-Received: by 2002:a17:90b:3ec3:b0:1c7:24c4:e28f with SMTP id rm3-20020a17090b3ec300b001c724c4e28fmr5212648pjb.191.1651745318317;
        Thu, 05 May 2022 03:08:38 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id c23-20020a170902849700b0015e8d4eb287sm1105413plo.209.2022.05.05.03.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 03:08:37 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, rusty@rustcorp.com.au
Cc:     fam.zheng@bytedance.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2] vringh: Fix loop descriptors check in the indirect cases
Date:   Thu,  5 May 2022 18:09:10 +0800
Message-Id: <20220505100910.137-1-xieyongji@bytedance.com>
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

We should use size of descriptor chain to test loop condition
in the indirect case. And another statistical count is also introduced
for indirect descriptors to avoid conflict with the statistical count
of direct descriptors.

Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Signed-off-by: Fam Zheng <fam.zheng@bytedance.com>
---
 drivers/vhost/vringh.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 14e2043d7685..eab55accf381 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -292,7 +292,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
 	     int (*copy)(const struct vringh *vrh,
 			 void *dst, const void *src, size_t len))
 {
-	int err, count = 0, up_next, desc_max;
+	int err, count = 0, indirect_count = 0, up_next, desc_max;
 	struct vring_desc desc, *descs;
 	struct vringh_range range = { -1ULL, 0 }, slowrange;
 	bool slow = false;
@@ -349,7 +349,12 @@ __vringh_iov(struct vringh *vrh, u16 i,
 			continue;
 		}
 
-		if (count++ == vrh->vring.num) {
+		if (up_next == -1)
+			count++;
+		else
+			indirect_count++;
+
+		if (count > vrh->vring.num || indirect_count > desc_max) {
 			vringh_bad("Descriptor loop in %p", descs);
 			err = -ELOOP;
 			goto fail;
@@ -411,6 +416,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
 				i = return_from_indirect(vrh, &up_next,
 							 &descs, &desc_max);
 				slow = false;
+				indirect_count = 0;
 			} else
 				break;
 		}
-- 
2.20.1

