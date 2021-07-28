Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37DC3D8E97
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 15:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236391AbhG1NIt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 09:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236371AbhG1NIZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 09:08:25 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9462EC061764
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 06:08:23 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id u9-20020a17090a1f09b029017554809f35so9862978pja.5
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 06:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XX70o1X1Cgw4fNpu8tzLJbjLTB/dJBQIRbJuCgl7gAQ=;
        b=qjJyVPD23XAfvIMFBK0k3lyIPRo9qGbjwyUTtkfxUEQQduxjqJNo1w3+PU5CfpsMmn
         waiUcOznQY7k7MkpnHIzRDkQ8WCOyVySkwmoWt3E2YVUmR1Oc+Ia/TuihSWljmPrwNkP
         YLdTeervyYOsboUmbGXkh8awIeQJeR4eKFDHzB/ItLEkL2FLeYEG7vG8zrffMZr4qoIR
         38tzc3iwVD5lsmYgMSVpahKHc7Tdd4oJR+tuXwa/GODFxCy7bg3slQdCio5v5xl239k5
         AZau68DzYxvhjXBVylam9VNmDAHsmH4DJ+vERsePgfh044NfG8Z+BJZrha2i12Sx6pCA
         Abzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XX70o1X1Cgw4fNpu8tzLJbjLTB/dJBQIRbJuCgl7gAQ=;
        b=DZRhv0m6EGcqBTDXfsb/4TYCqv/pENklz9z2C++nJgrN/uGpHiMqwlhlmhokH+oMOT
         /Z4bBMD2qkBMU3DHd2XyDiQOqq9uCvh7Z3t9Eq9c8X30+D6F0NodpcqueaeTqtSDc3hr
         CWuveWdgGFB754GKNpj68PGRLS0NydLX0AMjdlP5sg0RN7t+f/w1KK7hzoVpMaM1+9QP
         +9iiJuN0MUkQp4KoIcqL0UaXhchTq6jNsqYSZyLVDQWrm4OE7aDs4hFmLLRtKFHHGUnh
         lrRuTUNCSVsTdmfwwEU57uOuivcU77/3hnKwboxK2juUUKDiVNfMJU2102jySQgEp68t
         3CEQ==
X-Gm-Message-State: AOAM532PNL8bEdDVH9eD4ZRt6/13ZcPOyi1r+eR4QxaQOinowz2V36+g
        PBySTlc8fmbBv2qVBFTqAN2r
X-Google-Smtp-Source: ABdhPJz3HJJEY5ok/VLZC6bllUI2mC3K2btVzbWJ0mXyY5ky7iNv19XOgPjBOh4gziWaD4gfyYcEVw==
X-Received: by 2002:a17:902:db0f:b029:12b:880b:ef38 with SMTP id m15-20020a170902db0fb029012b880bef38mr22513206plx.5.1627477703192;
        Wed, 28 Jul 2021 06:08:23 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id j128sm7789048pfd.38.2021.07.28.06.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:08:22 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] vhost: Fix the calculation in vhost_overflow()
Date:   Wed, 28 Jul 2021 21:07:56 +0800
Message-Id: <20210728130756.97-2-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210728130756.97-1-xieyongji@bytedance.com>
References: <20210728130756.97-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This fixes the incorrect calculation for integer overflow
when the last address of iova range is 0xffffffff.

Fixes: ec33d031a14b ("vhost: detect 32 bit integer wrap around“)
Reported-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vhost.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index b9e853e6094d..59edb5a1ffe2 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -735,10 +735,16 @@ static bool log_access_ok(void __user *log_base, u64 addr, unsigned long sz)
 			 (sz + VHOST_PAGE_SIZE * 8 - 1) / VHOST_PAGE_SIZE / 8);
 }
 
+/* Make sure 64 bit math will not overflow. */
 static bool vhost_overflow(u64 uaddr, u64 size)
 {
-	/* Make sure 64 bit math will not overflow. */
-	return uaddr > ULONG_MAX || size > ULONG_MAX || uaddr > ULONG_MAX - size;
+	if (uaddr > ULONG_MAX || size > ULONG_MAX)
+		return true;
+
+	if (!size)
+		return false;
+
+	return uaddr > ULONG_MAX - size + 1;
 }
 
 /* Caller should have vq mutex and device mutex. */
-- 
2.11.0

