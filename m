Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27778F090D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 23:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387487AbfKEWGt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 17:06:49 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33665 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387476AbfKEWGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 17:06:48 -0500
Received: by mail-pl1-f193.google.com with SMTP id ay6so3340081plb.0;
        Tue, 05 Nov 2019 14:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=VitjQQFQG7H0A5JYqbYhHy/YWDiYO6QESupJyX3H62U=;
        b=dpkpTXimibOaJbaCEiTOvdx4Sg5R+LPRID9WsbtvON8KZsyg5WRQCqiDmRtWwPFB79
         RvgSWM9iHwKfMh2W5qgOcvx5JdZ6+YfOZ73d8qankdkJ0NZoTPx3C9md1kpI5j4U13Em
         zg5yln/gzdsI1DZWnNU9+MwtueFrJAapdH9GJlTNRDy55EnKRXFrK3TO3dlkji91QCP7
         tcQm1AQrdI9k1QD+2ji4RsKZELTpKKWww2Y08CeINqdVXoF3lSDTIjEd+JzW+HDGTyjJ
         lulviB87wO4x4Jtr4cUUAcCZv/6UiNENfYxGZIFj1H0XsNJgvF7SeYx+hi97qvy9YHQ/
         2ZbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=VitjQQFQG7H0A5JYqbYhHy/YWDiYO6QESupJyX3H62U=;
        b=B6xeSJPTb/KUAbOgHdolIsFzjDgI1LiPxr/j1xLr5km9+q3iE3jKqOJy3ZGDonfgqN
         bD0bdWqaTHiBcnO1OMiw9JM+R+D5+yY29BIoeQ5hxD7dVjQtZgcX/mAc90uiA79UEOd7
         TPeXbc5/V+x8KgM3sdSDJ3SXKJ4FPOuHliJ4yx3TIUiQzgZ0Wjibu3RfBEGVZVFaox+4
         OA7QdYwuGO98xQ/hnSKCSTOlFP3WecIEc5xsh+okflTR0Wg42mxFQ7Sv3rVPEW02osgE
         Vdh1BDcO2U3qxE01AK0u2u9fNsMooFoK68I9eGvG+Z6hz2kWceX7BVRgThJ3+tjlUe8L
         u/nQ==
X-Gm-Message-State: APjAAAWguXkwQaZ9seBA2/lpiJ8fBS4GbKOQSFbNoUPPW0sP9ygHzCFa
        oEh4EGBZdLrOrpBanjipxLw=
X-Google-Smtp-Source: APXvYqxd2Q0rTJz608ziiC7guBdp3u7fxjo1jKTOG90Pc2Yi/iRJ5ku6rmBeJgZMazGaqQnjvrOw0A==
X-Received: by 2002:a17:902:9347:: with SMTP id g7mr35245872plp.291.1572991607655;
        Tue, 05 Nov 2019 14:06:47 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id x10sm18021600pgl.53.2019.11.05.14.06.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 14:06:47 -0800 (PST)
Subject: [PATCH v13 QEMU 2/3] virtio-balloon: Add bit to notify guest of
 unused page reporting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        david@redhat.com, pagupta@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com,
        osalvador@suse.de
Date:   Tue, 05 Nov 2019 14:06:46 -0800
Message-ID: <20191105220646.15373.19405.stgit@localhost.localdomain>
In-Reply-To: <20191105215940.15144.65968.stgit@localhost.localdomain>
References: <20191105215940.15144.65968.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Add a bit for the page reporting feature provided by virtio-balloon.

This patch should be replaced once the feature is added to the Linux kernel
and the bit is backported into this exported kernel header.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/standard-headers/linux/virtio_balloon.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/standard-headers/linux/virtio_balloon.h b/include/standard-headers/linux/virtio_balloon.h
index 9375ca2a70de..1c5f6d6f2de6 100644
--- a/include/standard-headers/linux/virtio_balloon.h
+++ b/include/standard-headers/linux/virtio_balloon.h
@@ -36,6 +36,7 @@
 #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM	2 /* Deflate balloon on OOM */
 #define VIRTIO_BALLOON_F_FREE_PAGE_HINT	3 /* VQ to report free pages */
 #define VIRTIO_BALLOON_F_PAGE_POISON	4 /* Guest is using page poisoning */
+#define VIRTIO_BALLOON_F_REPORTING	5 /* Page reporting virtqueue */
 
 /* Size of a PFN in the balloon interface. */
 #define VIRTIO_BALLOON_PFN_SHIFT 12

