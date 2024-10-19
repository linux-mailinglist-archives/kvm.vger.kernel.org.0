Return-Path: <kvm+bounces-29189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E333F9A4ADD
	for <lists+kvm@lfdr.de>; Sat, 19 Oct 2024 03:30:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5EE831F212A0
	for <lists+kvm@lfdr.de>; Sat, 19 Oct 2024 01:30:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C27A1BE869;
	Sat, 19 Oct 2024 01:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="viXTgd/+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3DD1BDAA6
	for <kvm@vger.kernel.org>; Sat, 19 Oct 2024 01:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729301388; cv=none; b=m6g3WetIwvZo6u+9epTR22jaAzqPhe3gKtVzhZ6mEkhKidYVTN50sUEtviqADPL2gxoEz2L995+8zudAfapdom5FDeYCXKcgLJYkOvc+2WzPL5P8gFArA6yqBjXq8kylJrWn6TppwghwbddcKNmpvq5ihNv4JL10EI9x7veE4Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729301388; c=relaxed/simple;
	bh=ADHj64695AnmWs6scDXXAuyNjPNjewRXryZ8+dKDUIo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YegSYNwEfjCAQ+KqRGmuUUt1HCMu3kFWvzTOmp5Q1Sa1TwKl0GjhZn6F0s1ENDg9AFQufMqVyoHZ4kYAMuZTkGW7/Wg4hEEWD1qGOfEKfjjE0j2ssAgRKA+SFjaq9XS7cRhcr26hwOLlgt7sdvxAvcAuPpvAKOuwWGvOFth8cxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=viXTgd/+; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e3c638cc27so48949697b3.0
        for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 18:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729301385; x=1729906185; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JWmoU09y+6wa+3R3ifZVkoogK5Ofgf3reUuHP39SGJ0=;
        b=viXTgd/+78WBIA+cBXcXXn9PPKzGgZPL3VXpi9qdNKMmmXitaVomB0T4MCr9+IEzGC
         vP4IDaPubm2fW4tWyAQyuPctcYAbdWz0aCMaOXBPR5vGob8/keahmg7F1sbDrBYUBfu8
         5xMqa29W5f8VjBAdTdvh4vGMisq63G45GMCPeOn5x2qxrA6W/Q+3RJXCHHS/CE7r+oBu
         Co4AgCDiZy8tPkSukpb3LxbZKBdB/v0EIxEhQNNklVjrLdzF/v3SE1FnJtp0mqjNxmCo
         lf/q/TuZ65fHNjXFUDo3HdaAzq3l1kfB1lNXmA6Zco7jMOMKvCAdi0cgYI08ET5ZTKx5
         WMdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729301385; x=1729906185;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JWmoU09y+6wa+3R3ifZVkoogK5Ofgf3reUuHP39SGJ0=;
        b=O+YfSDGxXiV8cCe7IzqE2Vdnxe2FMa1SJvB0W3Of7ddFPpT09dMkEWQmSraC0ldVGW
         Dji3VvHzruQ2RtgszwMR8AveKrl16ovCEiudue9MXOEbk7Lwqzqt+mvzhEUI3b5KC5hd
         JBiT4PSH/Dk+jBc+/r+5nT6+dKBLTS8edtLelUcttTwBJMvHN3C63jwbZa5Y97tRQMcp
         ZuxipzCCFmAsCTAjahDK4PBB8tGBdFfGlG8Kf56iZhDbWPleBStx9ia/uo9yTIY7dX+r
         Fz9/x+cNnSI1Bf08ByJaQmgHQe2aUc2FjJ8dZc+CqLy//ISFgmFp+e0P86lpYNmaBLMS
         RCPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnC3qhxjd/2eJTgeweL8tS13Dxlgcw4h4TIUVDmvL0FAgmMpuWvKSiD1KZsQA73Wdt0HM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIFMG6enWuEXr4D6Np8sFmnDjpBJzxGSYAJ+UYByN1CAup1Zu3
	5FMn+hxFfkWeR4eYDGE3B4qD3xVZIRSKAemBReNMeHrVcz1Hxk0iEavLSRLNVDFKEQNdAjpfoZj
	ViwfZ79mwCZjk9lPMmA==
X-Google-Smtp-Source: AGHT+IE7mxydzjHIcaCtSw9GRjaWSidW3zTmTU0yiTMTLG+FkvhjpHmaauVlHv0Tv7yfhEo/zPT4VQCUKP70YtII
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:13d:fb22:ac12:a84b])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:2e90:b0:6e3:1627:e866 with
 SMTP id 00721157ae682-6e5bfbd836bmr424387b3.3.1729301385447; Fri, 18 Oct 2024
 18:29:45 -0700 (PDT)
Date: Sat, 19 Oct 2024 01:29:38 +0000
In-Reply-To: <20241019012940.3656292-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241019012940.3656292-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241019012940.3656292-2-jthoughton@google.com>
Subject: [PATCH 1/2] mm: multi-gen LRU: remove MM_LEAF_OLD and
 MM_NONLEAF_TOTAL stats
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	David Stevens <stevensd@google.com>, Yu Zhao <yuzhao@google.com>, Wei Xu <weixugc@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

From: Yu Zhao <yuzhao@google.com>

The removed stats, MM_LEAF_OLD and MM_NONLEAF_TOTAL, are not very
helpful and become more complicated to properly compute when adding
test/clear_young() notifiers in MGLRU's mm walk.

Signed-off-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/mmzone.h |  2 --
 mm/vmscan.c            | 14 +++++---------
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 96dea31fb211..691c635d8d1f 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -460,9 +460,7 @@ struct lru_gen_folio {
 
 enum {
 	MM_LEAF_TOTAL,		/* total leaf entries */
-	MM_LEAF_OLD,		/* old leaf entries */
 	MM_LEAF_YOUNG,		/* young leaf entries */
-	MM_NONLEAF_TOTAL,	/* total non-leaf entries */
 	MM_NONLEAF_FOUND,	/* non-leaf entries found in Bloom filters */
 	MM_NONLEAF_ADDED,	/* non-leaf entries added to Bloom filters */
 	NR_MM_STATS
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2d0486189804..60669f8bba46 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3405,7 +3405,6 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 			continue;
 
 		if (!pte_young(ptent)) {
-			walk->mm_stats[MM_LEAF_OLD]++;
 			continue;
 		}
 
@@ -3558,7 +3557,6 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			walk->mm_stats[MM_LEAF_TOTAL]++;
 
 			if (!pmd_young(val)) {
-				walk->mm_stats[MM_LEAF_OLD]++;
 				continue;
 			}
 
@@ -3570,8 +3568,6 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			continue;
 		}
 
-		walk->mm_stats[MM_NONLEAF_TOTAL]++;
-
 		if (!walk->force_scan && should_clear_pmd_young()) {
 			if (!pmd_young(val))
 				continue;
@@ -5262,11 +5258,11 @@ static void lru_gen_seq_show_full(struct seq_file *m, struct lruvec *lruvec,
 	for (tier = 0; tier < MAX_NR_TIERS; tier++) {
 		seq_printf(m, "            %10d", tier);
 		for (type = 0; type < ANON_AND_FILE; type++) {
-			const char *s = "   ";
+			const char *s = "xxx";
 			unsigned long n[3] = {};
 
 			if (seq == max_seq) {
-				s = "RT ";
+				s = "RTx";
 				n[0] = READ_ONCE(lrugen->avg_refaulted[type][tier]);
 				n[1] = READ_ONCE(lrugen->avg_total[type][tier]);
 			} else if (seq == min_seq[type] || NR_HIST_GENS > 1) {
@@ -5288,14 +5284,14 @@ static void lru_gen_seq_show_full(struct seq_file *m, struct lruvec *lruvec,
 
 	seq_puts(m, "                      ");
 	for (i = 0; i < NR_MM_STATS; i++) {
-		const char *s = "      ";
+		const char *s = "xxxx";
 		unsigned long n = 0;
 
 		if (seq == max_seq && NR_HIST_GENS == 1) {
-			s = "LOYNFA";
+			s = "TYFA";
 			n = READ_ONCE(mm_state->stats[hist][i]);
 		} else if (seq != max_seq && NR_HIST_GENS > 1) {
-			s = "loynfa";
+			s = "tyfa";
 			n = READ_ONCE(mm_state->stats[hist][i]);
 		}
 
-- 
2.47.0.105.g07ac214952-goog


