Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE3DA97DEA
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 17:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729558AbfHUPAk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 11:00:40 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39112 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727725AbfHUPAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 11:00:39 -0400
Received: by mail-pl1-f193.google.com with SMTP id z3so1477461pln.6;
        Wed, 21 Aug 2019 08:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=VitjQQFQG7H0A5JYqbYhHy/YWDiYO6QESupJyX3H62U=;
        b=k2a5K2ECmdb6swy6bHd/xAA0MDd7K9ym8QEcuo2Yh8MrxSUDRJfnZxqnDcQyv0BZeB
         WUSY/nSZQqI+F6Y/vkkK+HYEaKGvN6UXSdDpJESF2TUJx/ITqTLIqvlc80XeABcTTJZ5
         znjbFUnyuBjiqOSg/b3a1bnhG+vBZjuk9oOKuKENGYfrcjcnIQZInnQ7woSmsbs2qXb1
         OuXaFOUvpnHlRCm7vwjNeRwd0ycNjxnBwMDZ4igLcN6CZPKg44vCqE2Sf+PcHG3jgFQ0
         hrqzlA5atInMjmpkGw0fz7iDvXvYYVgPB7mnEj9E37BHfHaHAvoDAQSkB9iryiY88Xlj
         Eyyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=VitjQQFQG7H0A5JYqbYhHy/YWDiYO6QESupJyX3H62U=;
        b=Gap/iX6IGC2Go6Ahh+63P4e9YCj+2pFp8FOb9cHDjU3IAvbsHHhM/JC/26X64nFyol
         GL4HmyeNEkO3fFKb1sNmyrnj2v2o5s2VrtX6NvL1j9LwDBo/YbXWbGDLWTXaV9y/bhPf
         Y73JcElrp+/CcV0T0k20YTQM5dSPga8nqkopdIlU7JX+dkUe7hODuKdMvqPQ8+DLAzmw
         DJl8d2qqC2SZnmZi/oWWxoLmQAJGDcFHZmTdki+VGzg080T7BIS/r/Yq69tbqJViK9fs
         Bs1H7L4/e7X83Pe24fC4Su2E6kdv51UfT5qgsZepAPzicGS+BeDw0YdXRXfgHKpZPaRK
         4clA==
X-Gm-Message-State: APjAAAW1apht04/SqwTQSX3LIzg14YTA+78SXbkbVzH+FFsgkiTfgvk5
        Anjr24JlS1qCNDj0sJjW7g4=
X-Google-Smtp-Source: APXvYqzoQn+RfX4vjD+nR26xkBjnL4PsFBTP+0Ha9xmMLH5TQ58gGkHGrSHmBFrhAWplNCl7l58xYQ==
X-Received: by 2002:a17:902:343:: with SMTP id 61mr35450878pld.215.1566399638758;
        Wed, 21 Aug 2019 08:00:38 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id e13sm29412309pfl.130.2019.08.21.08.00.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 08:00:38 -0700 (PDT)
Subject: [PATCH v6 QEMU 2/3] virtio-balloon: Add bit to notify guest of
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
Date:   Wed, 21 Aug 2019 08:00:37 -0700
Message-ID: <20190821150037.21485.3191.stgit@localhost.localdomain>
In-Reply-To: <20190821145806.20926.22448.stgit@localhost.localdomain>
References: <20190821145806.20926.22448.stgit@localhost.localdomain>
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

