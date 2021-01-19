Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52CE32FB459
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 09:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbhASFWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 00:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388937AbhASFGN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 00:06:13 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F74EC0613ED
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 21:04:42 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id g3so9841764plp.2
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 21:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WpzztgDjuirSaoCm4Y9iwgLXbmOFGv5bSk1ou8troPs=;
        b=qst643HflCVIEfriJwFNkoqnsyAa5ZihDHq5MY2p+sCG7pvdwgfVfWzDs7CyLXzUd+
         X5uFyzZCSZ64/Hp2K0p+C+NqylNT+3OiWFg2Ej65miParVF8OeJLkwoS9jnaFI+wtI0Q
         lXnOrClMEjsYSBLjzze08LxElrkh9rDDFZG4NpZj1vBBw0KYdlW9EiU1Oqdd7abo8655
         YHy2xoK2ETSc2On6BciBqVp5jFgbCsIs1R3h9DY01PpB87KzpOEMy5avoFjp/pmcioUN
         +x7E/3nOu6rB2x31lmd8Bdb+nLCMZYSnKtcS8EPFLa7M6DLN4bahTjy5UUUFTb1aGyef
         ogCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WpzztgDjuirSaoCm4Y9iwgLXbmOFGv5bSk1ou8troPs=;
        b=BTYeE0GOIUBkV8i9J0BRlGYK6S9TgkNBWqpFCYMpjv6dYfIVOdl1XpT/AsElvQkFR6
         HGrvOHgEHiJ4G3aeHE/i+BBey5oWhgucOp/BWmoeu3anDIXcSp1GgLAOOCbsM7PApeyE
         h1vmxfTFLMUTyfPVBxSmoJyXQA4dA+dFZ9LN39Oi873yji0KDCjzlwD44KLvHoi7di/m
         wUv3RCzGMwArzDfay2V2BIyhjzZ/jmb2rsjLaPK2LyqIFbccAW9wFJ1dwYYl6vGmNBNf
         ndHNBdHzsILxOdUxh3RGVh17EJ3s1ZpZnFegLgWP5qIlB59TtOM0KruKEQaEGkemFsyJ
         TmiA==
X-Gm-Message-State: AOAM532UV+fQv00gWBwb8wtPOFpcympLiYYo17DHNN3Hl6XGSJ5UxzCB
        gptZ6HYowRfpuNCPXNvqsN2L
X-Google-Smtp-Source: ABdhPJw7CNS8s3U6DU1iDibWMlmFKz5BWY5qR5AaOZK841X966zGeE7AOSATjocWL+j9RMwjLVZkkg==
X-Received: by 2002:a17:90a:2e88:: with SMTP id r8mr3289055pjd.84.1611032681770;
        Mon, 18 Jan 2021 21:04:41 -0800 (PST)
Received: from localhost ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id p187sm17220675pfp.60.2021.01.18.21.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 21:04:41 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC v3 02/11] eventfd: Increase the recursion depth of eventfd_signal()
Date:   Tue, 19 Jan 2021 12:59:11 +0800
Message-Id: <20210119045920.447-3-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119045920.447-1-xieyongji@bytedance.com>
References: <20210119045920.447-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Increase the recursion depth of eventfd_signal() to 1. This
will be used in VDUSE case later.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 fs/eventfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 2df24f9bada3..478cdc175949 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -25,7 +25,7 @@
 #include <linux/idr.h>
 #include <linux/uio.h>
 
-#define EVENTFD_WAKE_DEPTH 0
+#define EVENTFD_WAKE_DEPTH 1
 
 DEFINE_PER_CPU(int, eventfd_wake_count);
 
-- 
2.11.0

