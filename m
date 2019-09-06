Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E48E4ABB83
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 16:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394692AbfIFOyp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 10:54:45 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36383 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbfIFOyp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 10:54:45 -0400
Received: by mail-pg1-f196.google.com with SMTP id l21so3647841pgm.3;
        Fri, 06 Sep 2019 07:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=VitjQQFQG7H0A5JYqbYhHy/YWDiYO6QESupJyX3H62U=;
        b=u2UtpKj+SdvdC7zNNCRKGfWXo1ykUbLduiISlK7UKVNWKJFj7hQRsxtRsM+Ng+JDcs
         v7XIQ4GRg8UpI0VLI4x3HWqouyCX8JuhCd7BtITu+IvldqmAvamdMQRLR/oEiIkIDVDP
         VFzD84K523Z9VpGyOqGTX8ekpRwerKs9WPfJYRFvR5/Yc/QO9drW8rNetKJQZCnQNepA
         1bO3dX5jPRDMkcPBCJdcwOBp6JxR6PqiCYzLbc8uX5ds6xPdIum29TV7dqmdR/fHlT16
         ao4s/16BbpHnyyT0U1nuALIAl+ZaBH0Apbb5NbsVqY6TVc44rduuB/3bWDd/yhsJtFEB
         pXjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=VitjQQFQG7H0A5JYqbYhHy/YWDiYO6QESupJyX3H62U=;
        b=NSJJg4d8h/AlvhdO5Um4RjOM/rUzWn8pBpyYrQgZbQxuo8Fn7NCeSGFaufHzo4A/i3
         LN1rvL30CI20UbyvIcu4lmg4DIB8FXQoAOnY7GlFOphWFI6Bbu9ScEOg2q5qjhlNHHBK
         eKFxNt1HUdqbDVPhXNuuC+Vp+Nx6T8vl1n+LUtIkM4DwQ6ADyS/4yTpM3LcXicr2OVwe
         S5cr1NS7R0Pq7kyPYcTPD5UCWozVk8jd6+GUtAnRjIW9r8Luna660IOur7YbLVX6x8NQ
         qXqNzm4JDd0Vbh3C6UHuvtOzEENQZI5an011ZZA8ycvzCeiSKrDHLpfG+YqTsyoWkphD
         Flmg==
X-Gm-Message-State: APjAAAXUH/wytxB8ov5RFW3gwYCTihL8OGXicWuf0f0aDDJLMQDqGKL7
        E3HNc7qVdd9Dz1q6uQvPgxU=
X-Google-Smtp-Source: APXvYqyq7c3ys8bBHJp63ctlkK7wT7XGiRX8LnzlMCbygnwq1ZTX0Wq3ookzg6WHVMz7aVn1zyE+5Q==
X-Received: by 2002:a65:464d:: with SMTP id k13mr1589674pgr.99.1567781684235;
        Fri, 06 Sep 2019 07:54:44 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id k14sm6784077pfi.98.2019.09.06.07.54.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 07:54:43 -0700 (PDT)
Subject: [PATCH v8 QEMU 2/3] virtio-balloon: Add bit to notify guest of
 unused page reporting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, virtio-dev@lists.oasis-open.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, willy@infradead.org,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, mhocko@kernel.org,
        alexander.h.duyck@linux.intel.com, osalvador@suse.de
Date:   Fri, 06 Sep 2019 07:54:43 -0700
Message-ID: <20190906145443.574.8266.stgit@localhost.localdomain>
In-Reply-To: <20190906145213.32552.30160.stgit@localhost.localdomain>
References: <20190906145213.32552.30160.stgit@localhost.localdomain>
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

