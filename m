Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93321ABB6B
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 16:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394675AbfIFOxa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 10:53:30 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40857 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394669AbfIFOx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 10:53:29 -0400
Received: by mail-pl1-f195.google.com with SMTP id y10so3255778pll.7;
        Fri, 06 Sep 2019 07:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=y1UWMqHdCnekLv2dWzC/1NNH0fQiwzlC8Wszz/ILY4M=;
        b=Mag0NQ/BaY/evlZK7rDqVpVa4SoD20yegY2gnU1J5QJ3cQlPeV/WcjiNsMRjYj4UlO
         j47A4eB1Yyu6XTdDMn6pahVscdhXahzaiE5xjJhESZqtYaG0lzLUqBsiW6/Fy9NG09xg
         C0aLIvy/oDX59quZyauouhcpPyWzxdO81zIGT2WvnflPokAj/pLHMhQ3mj+xzsqp14Ls
         7ab/Q7uvHBNht0vduEP9dnyrW2UuVdwFLJ4a6jdGsKR41YoqTUo9nnlYCGO6X4dQ9RcX
         uROSr2vodVMG9kRIlO3cfEccObq9fvrETCZcgM7na40pGHl+LKkghJ1Aria9vjVlnarm
         gZnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=y1UWMqHdCnekLv2dWzC/1NNH0fQiwzlC8Wszz/ILY4M=;
        b=D+QuEgMur72/ZwM1Z/RDG1Fqr+haTXeSz+4w83cyAkq31F9tg1zQkTFqLFDQwfxU0j
         pHNcOxaQwMMAC36k2+td+Ut+bCV0Xi9ybUaADbQ9s0LipMBG42du8TSy1QWnGbCLSAx/
         lbxSpQyLRVHc7paX/8Hs0cSVua6Y+FoquQ9HPx+CDYMd23f+y2fHbo8wi3gnS187YAG2
         6mbOE9s4r/T0XLCNYw90KAhthzT53FTYmiqWBaz6IxDZeFcde9yoN02d1yYfpCDEuCba
         qIQ1hs0H8t0WcdtT2w41Ui2iE11pyALweJLj79HG2fgK9xtDdoz4OWFZhOQ6ZCvajqi9
         UTGg==
X-Gm-Message-State: APjAAAUe1RHFRLCm/VzIlaOILYS0K0APQXxCbdAOBSCLhhvpzAYpUgNu
        DfUEPAppWr1vb5ci/4kN/u8=
X-Google-Smtp-Source: APXvYqwXbA80G+oF/wmxkLk0iz+eT1kKPHeORFg6MaYksK5+TYFebrUDE34FVzIfkIJ4DDYs9NYZbQ==
X-Received: by 2002:a17:902:a01:: with SMTP id 1mr9873072plo.278.1567781608953;
        Fri, 06 Sep 2019 07:53:28 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id c1sm11390068pfb.135.2019.09.06.07.53.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 07:53:28 -0700 (PDT)
Subject: [PATCH v8 1/7] mm: Add per-cpu logic to page shuffling
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        virtio-dev@lists.oasis-open.org, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Fri, 06 Sep 2019 07:53:27 -0700
Message-ID: <20190906145327.32552.39455.stgit@localhost.localdomain>
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

Change the logic used to generate randomness in the suffle path so that we
can avoid cache line bouncing. The previous logic was sharing the offset
and entropy word between all CPUs. As such this can result in cache line
bouncing and will ultimately hurt performance when enabled.

To resolve this I have moved to a per-cpu logic for maintaining a unsigned
long containing some amount of bits, and an offset value for which bit we
can use for entropy with each call.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 mm/shuffle.c |   33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/mm/shuffle.c b/mm/shuffle.c
index 3ce12481b1dc..9ba542ecf335 100644
--- a/mm/shuffle.c
+++ b/mm/shuffle.c
@@ -183,25 +183,38 @@ void __meminit __shuffle_free_memory(pg_data_t *pgdat)
 		shuffle_zone(z);
 }
 
+struct batched_bit_entropy {
+	unsigned long entropy_bool;
+	int position;
+};
+
+static DEFINE_PER_CPU(struct batched_bit_entropy, batched_entropy_bool);
+
 void add_to_free_area_random(struct page *page, struct free_area *area,
 		int migratetype)
 {
-	static u64 rand;
-	static u8 rand_bits;
+	struct batched_bit_entropy *batch;
+	unsigned long entropy;
+	int position;
 
 	/*
-	 * The lack of locking is deliberate. If 2 threads race to
-	 * update the rand state it just adds to the entropy.
+	 * We shouldn't need to disable IRQs as the only caller is
+	 * __free_one_page and it should only be called with the zone lock
+	 * held and either from IRQ context or with local IRQs disabled.
 	 */
-	if (rand_bits == 0) {
-		rand_bits = 64;
-		rand = get_random_u64();
+	batch = raw_cpu_ptr(&batched_entropy_bool);
+	position = batch->position;
+
+	if (--position < 0) {
+		batch->entropy_bool = get_random_long();
+		position = BITS_PER_LONG - 1;
 	}
 
-	if (rand & 1)
+	batch->position = position;
+	entropy = batch->entropy_bool;
+
+	if (1ul & (entropy >> position))
 		add_to_free_area(page, area, migratetype);
 	else
 		add_to_free_area_tail(page, area, migratetype);
-	rand_bits--;
-	rand >>= 1;
 }

