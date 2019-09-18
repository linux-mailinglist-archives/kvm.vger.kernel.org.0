Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 176E2B6A00
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 19:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729111AbfIRRxy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 13:53:54 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:41663 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfIRRxy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 13:53:54 -0400
Received: by mail-oi1-f196.google.com with SMTP id w17so339275oiw.8;
        Wed, 18 Sep 2019 10:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=VitjQQFQG7H0A5JYqbYhHy/YWDiYO6QESupJyX3H62U=;
        b=H3wKs22GCSuuo47NHL84cjAcqIxVWe5raJSaPJYEEjR4SjLfOrFfKt6MqETcP09nzp
         mQwVOuGJiDyTUO34zz/FxTfyeK93Ym+rSqbDgLoT/Du3oNzP1D0AIlwxjhzYcrzwwKIs
         xtuGXJ2uADX6hCimeVVU5uKTm/0RBb5zaza/2xkqpEofa5+pRdcP/FX/pDjy6nqeQhrz
         wjIwWTS1OwEhcVqKPV+UX49i5jyRIkdBII/ejcvGqW6cFvW/aBaQMvKszzUiDF4oubCx
         FgrHvJ+7pmJW4fOmM+9tKSwU3cS7m7q8ml0xlT15/H7ej/2b2YhZqe7ipz773fsTquBb
         b4Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=VitjQQFQG7H0A5JYqbYhHy/YWDiYO6QESupJyX3H62U=;
        b=kIbIakxBKm9YFDXzbMAXKJZt0MpC7UrVVKUCZPkoPP96rMj7PGP8DFp7FHtqJcOczF
         gIageJyTYENynA+ozskJtWF9vDvm9EiTBYcPXliUNGPgmCACFIvfDwKlaAz4OhisqIM7
         c+uRCAE08OJmkfRi/CKxYAgc1/AvocjVHuuy78kcKdRPLHkNo41HvkPBljH8rT80Y+nZ
         6vEZ8DD9Qqhlccl1lBTXTmaAmw96tll9WSz0F5/D3twrUeIo8B2mXQYX/jdkaKcRntlS
         /P4M3rllB++r2/eJts0j70OO+mgXnBLnsY1FP0XDiWpjEKTsvT0Rygp8BLc0cLSMDMAD
         llrw==
X-Gm-Message-State: APjAAAVM5nG3yAwmVsVSNpPPPKYkHU3s4XoBisDjQoSFGdKuxjCybWeR
        JvGxmHQqYX1COacZk1CGnKY=
X-Google-Smtp-Source: APXvYqx0/em4LyihxJp1UfPCVlfU74a3jjEiza4M/rCWhu2/BqxunUOAE7tRJ9fzvgWCTQRlNSJFbA==
X-Received: by 2002:aca:dcd5:: with SMTP id t204mr3293467oig.138.1568829232972;
        Wed, 18 Sep 2019 10:53:52 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id o184sm1837530oia.28.2019.09.18.10.53.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 10:53:52 -0700 (PDT)
Subject: [PATCH v10 QEMU 2/3] virtio-balloon: Add bit to notify guest of
 unused page reporting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, vbabka@suse.cz,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        linux-arm-kernel@lists.infradead.org, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com
Date:   Wed, 18 Sep 2019 10:53:50 -0700
Message-ID: <20190918175350.23606.70808.stgit@localhost.localdomain>
In-Reply-To: <20190918175109.23474.67039.stgit@localhost.localdomain>
References: <20190918175109.23474.67039.stgit@localhost.localdomain>
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

