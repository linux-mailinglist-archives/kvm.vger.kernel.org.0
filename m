Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B213CB5FA
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 12:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238968AbhGPK0f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 06:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238398AbhGPK0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 06:26:31 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD65C061765
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 03:23:36 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id b12so8553752pfv.6
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 03:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mJYWdsw34aaRbO5ru3xen2MP+EZCEf1FnSIinPAOBxs=;
        b=lfW3C2RlMykUor71r2BAqRYYlG/PW0KIuSkBiSttDLmUoxPDOjn+FANYMaPFQDPbgF
         0ZGWE6wcWYKK0bXHb9Y9xQepzfzmilg/oDUoxtf60gjKQ2N318O8yABWEOP02o6Nd/Wa
         w6Gm6X8EYCVu27mecSuqpL0zooyyAgcek6s646cFx1q/xsQa/U5Txad6U5hXYOX2Q62L
         Cm9rS1Hh1nh03KWD1UaFQyrdp7uEUdH0/wuZqvMI4AR42bYV9bFSE2SyPfVEI+xmhw1j
         ESfq9gRb/fXf2qyyKZUvuGoZpEfJU+Jyls1nO52IIE88k3Pn8jSmB86NDTMuWC5WDW9r
         1+/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mJYWdsw34aaRbO5ru3xen2MP+EZCEf1FnSIinPAOBxs=;
        b=kwctV7tNfe9FaQqlhqJoFaX0CmrTPU3z0dGne9IW0/kpFmrizt6Xy9vvDlvY3YX4VD
         usVCnBUhz3abA6S1gJB4vb3GXyFMCXv39p6vMqjJDK9orZEVly2MReZbT+jRJemVGhjt
         KHfGYlWsVePg8G2TPwwZsrjfWX4WTpMx73Ig9QT+NJqks0Wn/4V3tfUfSveGkERnDzVl
         fnsEU7eD4AcEep8GiPVyqdh6dT9FLpL8MxZEHfWEAdiXHTdIJXEliEX75ZgxcHqFSR7T
         Ajk1lgYV5QapFIihCWsupqieyTV4ZteR5YNMqJ7zZrYYyl/CWkrUcF/oBOCGRjS1t40V
         JTyg==
X-Gm-Message-State: AOAM531FKlvJvYM8OH5cZiI4VXhz4TRYyqwQRcWjCJViEmCXsnc+9p9a
        20pQm7bjKgpNhoBICAjRggDU
X-Google-Smtp-Source: ABdhPJxONsQNT4fPjubNFPLig4RCYzRSiNrG4NZUr7bg0TGdIHNu5HB6tFcl+zKNW/s/fpUFw6yJaQ==
X-Received: by 2002:aa7:854a:0:b029:332:330e:1387 with SMTP id y10-20020aa7854a0000b0290332330e1387mr9452917pfn.67.1626431016369;
        Fri, 16 Jul 2021 03:23:36 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id 1sm9961963pfv.138.2021.07.16.03.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jul 2021 03:23:35 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] vhost-vdpa: Fix integer overflow in vhost_vdpa_process_iotlb_update()
Date:   Fri, 16 Jul 2021 18:22:38 +0800
Message-Id: <20210716102239.96-1-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "msg->iova + msg->size" addition can have an integer overflow
if the iotlb message is from a malicious user space application.
So let's fix it.

Fixes: 1b48dc03e575 ("vhost: vdpa: report iova range")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vhost/vdpa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 210ab35a7ebf..8e3c8790d493 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -615,6 +615,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 	int ret = 0;
 
 	if (msg->iova < v->range.first ||
+	    msg->iova - 1 > U64_MAX - msg->size ||
 	    msg->iova + msg->size - 1 > v->range.last)
 		return -EINVAL;
 
-- 
2.11.0

