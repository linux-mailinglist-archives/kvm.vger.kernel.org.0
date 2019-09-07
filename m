Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66E4BAC80E
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2019 19:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392981AbfIGRZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Sep 2019 13:25:17 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:33230 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392548AbfIGRZR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Sep 2019 13:25:17 -0400
Received: by mail-oi1-f194.google.com with SMTP id e12so7303887oie.0;
        Sat, 07 Sep 2019 10:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=rtCJ9oXMvzyqzSO/6+XMP8VFA+c1bypJ2A9Wi4tC2B0=;
        b=YVxuP3Qw60ve+K16OV/2OTXTVXsnZSGiw8yXWOnvCSAPW2RJsbvv9esY2jbVJk+MTd
         gZaFZgeUDSH31cxpn+4ACT+RtrLyEzlpB9CSFSKqcLbBdu5k7zv4t9ddGWWi0TGCGwiu
         gFWbCI/pIFOqwAWmWO0aBRiIEO3n1vCRrqraKqGz8fVFzLWJMKaeT4nkP76nJ9dVqS5M
         mGxpfLI0pp+7NdvVFdGAITNx/Whl+E8KWWUR6DpIaXjDSmYY2Hh+szZWNaDpLgznhs4Y
         DGw/CpIO4ALtMzKoFiREaJMW+0Vo1vWKa+L+gYpEaIJGJWvuU4XIhs/WSIDDM2sUHuCP
         a9dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=rtCJ9oXMvzyqzSO/6+XMP8VFA+c1bypJ2A9Wi4tC2B0=;
        b=PS58XQ9jAcbwuo3QBBoNSSqjFVMN5GvkdpuoMRdREfxkyF8OTHmBdVwfuMsPxYVaKT
         8jqf7lwzxeIOEiNexjLIcBPZct0lRPrVd0qJgSoSE92/pfFXGWufgxwqunRzjro++XZ3
         3Gaitecd9vfXwlgASMG71ho74sltMbOF4dXVHp/OoE+ghNQ/njxuzC8SNAs8cnFaIcME
         NzS2Qt0Dm+hJiGyNDyB/JenNZbKy3/9Ofh3RZeGfyCO/NA87sZfxaxYsM2/H8Ar0IPhd
         dhDnq04e3yJOnXkffN/QSCxB/ZUghXJRA3foaTL+Bi1VmyFTNvKv8pq9BcSsH6JfffHx
         1o6A==
X-Gm-Message-State: APjAAAVBjfhwC/t8yUNeWFuYe1DWTzplf0PJFBSmHYmpvljuLCc4S52O
        Nko6g0LtcvL8E11PGMsBQrk=
X-Google-Smtp-Source: APXvYqx76pbWI8aVf7Yn3gxH+LEAS1HoAzYWQhYG1OYCBkmvO+49isQhgNq9dB292v9n9IEZQlObWg==
X-Received: by 2002:aca:b388:: with SMTP id c130mr12021078oif.27.1567877115467;
        Sat, 07 Sep 2019 10:25:15 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id h5sm3898728oth.29.2019.09.07.10.25.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2019 10:25:15 -0700 (PDT)
Subject: [PATCH v9 1/8] mm: Add per-cpu logic to page shuffling
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, catalin.marinas@arm.com, david@redhat.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        ying.huang@intel.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, fengguang.wu@intel.com,
        alexander.h.duyck@linux.intel.com, kirill.shutemov@linux.intel.com
Date:   Sat, 07 Sep 2019 10:25:12 -0700
Message-ID: <20190907172512.10910.74435.stgit@localhost.localdomain>
In-Reply-To: <20190907172225.10910.34302.stgit@localhost.localdomain>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
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

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
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

