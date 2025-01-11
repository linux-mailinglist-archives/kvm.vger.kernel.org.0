Return-Path: <kvm+bounces-35153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 389D3A09F62
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:31:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03C82188EA58
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4482515381A;
	Sat, 11 Jan 2025 00:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QwBmfj0a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875E64A1E
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555421; cv=none; b=C8RP9Fl5sVrVr2cH29kgmM6VznX9Qf9m0uu6WjYJ4fKWI8Q2Z76+n/Mod/sYHETcWAuYgYWGwP+JpUogepnxbrGx2muqJDBNrxK1yEC5gD6yElDfNxxesvIQQvD17Urf9gO+0eteOINoRNk2cG/Uxwc3YeBhO8Qr7lIfRR0V2MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555421; c=relaxed/simple;
	bh=rXm6MMpaJw1qyS71V+xzDjJly4UwYlWkG0d7xvwWsQY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mgA1VbPw8H7fKudkm6cgKVqkdMNuzgt8zXpzUkO1tp6PXlg7APg61V6eUbl8xqCBcb6h2Qaaaa62h0U9QKBBXrPx1UtrmH6PoHXUWTOlILfj3c7+KAD+rf8GWX9mgRA8yY8zic+uKmSoC7BzTe1ubyV5mc38y0gTRmqWAzvai64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QwBmfj0a; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9e4c5343so6654907a91.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736555419; x=1737160219; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=6IhW12gqYntCz1+c2D5eBg8yPy5WGu0Pw6mNyLGrlAc=;
        b=QwBmfj0aX/nLbvgdBIxuKwpN3JomCHl7lT8hne1JEbhKbFG/LtH3wHityFXMvkA0zE
         7ykVI/7KsstbTWD31dW1QlInBZMdZR0C4l7ENdgb1BQbm0ggPSd6D9qV5cA13vylbr1w
         Socwvgdzd4JERkV9vpHqMbY4qojF4GTszam29Ej6ym8peQw6ic2YTQhWT/909CPzZSg8
         wz+M/ptizYuPOKQAKmEOHth/xQncpAiRCc+05nDoDj6S3ym6iOgSchH0mSwBiiPvpD46
         dM6F9NAWwuAizQm59chGhiwocofoSFyCmjLKTd4JOy4oUscbecyHaMIKMh2J4bURNs+r
         F/SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736555419; x=1737160219;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6IhW12gqYntCz1+c2D5eBg8yPy5WGu0Pw6mNyLGrlAc=;
        b=ImX1C+FyIavQWOBU+3sFBoJtZqiWnaZlIjwmwBBRAuKTeppFTTMUO3Pd0dKxfYe9ut
         n7ZYX8v7+ATlbIk8XSTUB3HLUYdjBqEU8sJm1KdoJIdHPw6ESR6lt6RW8QTD/ZbmJE43
         2GpwWivIMMD66pMwx2Ldqw5A8F0Ioxf8/dM23Y+Y8UzSp1+Xih5j8TyRDPNK0yn13OGc
         7nPe9ct79xO9+8ULaNkw6R7foriR/JZRmoFgvuGfvtERH0m7Yh5iBDHggEaqD7a3q7Kp
         b1/u4NsNQeLXvtWNtku6tpukrjrdT/ZJ3vMwg8bzNDUJCK1J5TzYnd6A/IDKfys5DO5W
         VSbw==
X-Gm-Message-State: AOJu0YzE4/NIwbGEI/z19RBPtuQwFYzA5UH5Ss+pqlJccsG2teTM9kv9
	RGfoH5eWZDdqSkQc7Putm9WJAqsk55fxDzKqVRvWJUJJQVJMMTlOS/45vGxgrs2RFA+Lrofr6tu
	cpA==
X-Google-Smtp-Source: AGHT+IGBV97wTYRM8hlFr4fJkGJVU7xqzfHB/Clf/Nbfpa7h/esWcwhR69zEh8pcrRr99qn6u0ZSD0nAMiI=
X-Received: from pjwx3.prod.google.com ([2002:a17:90a:c2c3:b0:2ea:931d:7ced])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d43:b0:2ee:fdf3:390d
 with SMTP id 98e67ed59e1d1-2f5490ed82dmr16491422a91.31.1736555418949; Fri, 10
 Jan 2025 16:30:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:29:50 -0800
In-Reply-To: <20250111003004.1235645-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111003004.1235645-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111003004.1235645-7-seanjc@google.com>
Subject: [PATCH v2 06/20] KVM: selftests: Read per-page value into local var
 when verifying dirty_log_test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Cache the page's value during verification in a local variable, re-reading
from the pointer is ugly and error prone, e.g. allows for bugs like
checking the pointer itself instead of the value.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 08cbecd1a135..5a04a7bd73e0 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -520,11 +520,10 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 {
 	uint64_t page, nr_dirty_pages = 0, nr_clean_pages = 0;
 	uint64_t step = vm_num_host_pages(mode, 1);
-	uint64_t *value_ptr;
 	uint64_t min_iter = 0;
 
 	for (page = 0; page < host_num_pages; page += step) {
-		value_ptr = host_test_mem + page * host_page_size;
+		uint64_t val = *(uint64_t *)(host_test_mem + page * host_page_size);
 
 		/* If this is a special page that we were tracking... */
 		if (__test_and_clear_bit_le(page, host_bmap_track)) {
@@ -545,11 +544,10 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 			 * the corresponding page should be either the
 			 * previous iteration number or the current one.
 			 */
-			matched = (*value_ptr == iteration ||
-				   *value_ptr == iteration - 1);
+			matched = (val == iteration || val == iteration - 1);
 
 			if (host_log_mode == LOG_MODE_DIRTY_RING && !matched) {
-				if (*value_ptr == iteration - 2 && min_iter <= iteration - 2) {
+				if (val == iteration - 2 && min_iter <= iteration - 2) {
 					/*
 					 * Short answer: this case is special
 					 * only for dirty ring test where the
@@ -597,7 +595,7 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 			TEST_ASSERT(matched,
 				    "Set page %"PRIu64" value %"PRIu64
 				    " incorrect (iteration=%"PRIu64")",
-				    page, *value_ptr, iteration);
+				    page, val, iteration);
 		} else {
 			nr_clean_pages++;
 			/*
@@ -619,11 +617,11 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 			 *     we'll see that page P is cleared, with
 			 *     value "iteration-1".
 			 */
-			TEST_ASSERT(*value_ptr <= iteration,
+			TEST_ASSERT(val <= iteration,
 				    "Clear page %"PRIu64" value %"PRIu64
 				    " incorrect (iteration=%"PRIu64")",
-				    page, *value_ptr, iteration);
-			if (*value_ptr == iteration) {
+				    page, val, iteration);
+			if (val == iteration) {
 				/*
 				 * This page is _just_ modified; it
 				 * should report its dirtyness in the
-- 
2.47.1.613.gc27f4b7a9f-goog


