Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01F89C391B
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 17:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389747AbfJAPbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 11:31:14 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42884 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389674AbfJAPbN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 11:31:13 -0400
Received: by mail-pl1-f193.google.com with SMTP id e5so5644384pls.9;
        Tue, 01 Oct 2019 08:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=VitjQQFQG7H0A5JYqbYhHy/YWDiYO6QESupJyX3H62U=;
        b=L5Twh0JhZGvdhXHXw1oaxNXeSNQCxXg+4kR8o8X1F1TzlD00uzAO3QGcQGeCH+pYyv
         eM9UzTiOoj4NhZ/y/SfE4biRkKz0cfZib7gcIwCdBqTO0mnj3MDDRzQ0MbZPocBM+B5h
         msJsxIMWdqcGBjoeyS0PE3+F5FIPQogg6c3lfPb8yAknZ2IT7jOdFrlCQjYDtCtMWPhl
         4w7vbAU55orIiWGUYtYwdGgYBtWzc+mw27eRVFrAhrP6HZJdSIZmDr6LwANpN6U01hfj
         YkPCSsjAhoW6bmeFIjD638fXGmLVvvBI8kOBrNNBTD3nuHzYxjT+4gohPDBQIy3H/4oR
         +rjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=VitjQQFQG7H0A5JYqbYhHy/YWDiYO6QESupJyX3H62U=;
        b=YcLd3FoBytgdAicc+ykwfb7UF37KZbW/O59GoKaRaWRd0K9k0+CL9yulgUlI5Xkgbo
         hb7Cotdu9uRGIK/4bu4XJkDWDuGft1GJTdMnZyNT9K4ijwMWih3dLpqTpaCVwUGkNPhe
         /4X5ntUzuHlFNY3CLMWqhbg0eBVj4NdwAZeDpULbvpUpyJXQvpfB7z7fJDu0rawUJdhd
         sgKEW1onvXI0CUV7MHbAGEzmOUu7ePf5sPQ0AmDUmPeDqaNMXeQbP0g4FQBY8K9WvNpa
         e181soijUx+yY/GcrV47a+vAnOu7QkfeuEV1BoZU7BpEpsqEywX7FZfi9rXpEMxR5gtf
         H+uw==
X-Gm-Message-State: APjAAAUGsbCAWkhWx4FRqbREMd5y0EoVasIgjfG4mP0lQXg0chjOL7EG
        lOTkGpgNGG7xCTsQHxxJ7bg=
X-Google-Smtp-Source: APXvYqzm4jBxzqNzEFwRHGBmE42pgOuyceYI3OqLlxS3hh8mqGpCUV/zK2gp1R2fYuXU9RD1oRP5gw==
X-Received: by 2002:a17:902:82c8:: with SMTP id u8mr16796422plz.38.1569943872768;
        Tue, 01 Oct 2019 08:31:12 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id c8sm20343042pga.42.2019.10.01.08.31.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 08:31:12 -0700 (PDT)
Subject: [PATCH v11 QEMU 2/3] virtio-balloon: Add bit to notify guest of
 unused page reporting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        mgorman@techsingularity.net, vbabka@suse.cz, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com
Date:   Tue, 01 Oct 2019 08:31:10 -0700
Message-ID: <20191001153110.4422.81414.stgit@localhost.localdomain>
In-Reply-To: <20191001152441.27008.99285.stgit@localhost.localdomain>
References: <20191001152441.27008.99285.stgit@localhost.localdomain>
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

