Return-Path: <kvm+bounces-35163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74115A09F75
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:34:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 063297A0603
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D4E9195F0D;
	Sat, 11 Jan 2025 00:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M0R3cfMh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135C51925AF
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555437; cv=none; b=TerQgd6k4Gz7Q3atTIkf12bVdZI1Nr9jaHqcsttoTS9Yg/rTRzr4fMXYTT8yL7A5U5Y+d3fMhaSkCZHI+kTU6THBKGIeCNdaBqgyttt67pdrO3rcpRLfNinEu83/wkK85LLmhf+xgBs/mk6BSK32TRbjdZJu42069V0a1cPRFKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555437; c=relaxed/simple;
	bh=AG2lZf4hql7JMLlay7hN7O3/rUWAX62xZ3g4Ko5iqVo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZBb4NBfRL7y7t2+4+Zb6bV438SIhbTYE/i1BtdWpHclF3D91WuS/JbQ5DbcdivKLAVidC6PZJOQYD9L+6gkG5BNLAn+2r+gwpseBa2Tey4Gm7O6qtpM8GNnIE9Gv5XpA9iHW89xmOA8CcUH3SmXOrtvoR8fI6TNoaa2QfrY10ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M0R3cfMh; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef79403c5eso7421089a91.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736555435; x=1737160235; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0OUonYd6niVAqGjD0N5fWlc8jzGx+15I7hWbB4QzxGw=;
        b=M0R3cfMhlmE14YNbW8aB0FBhglLBPHWoE6jWo95A13KOWjUHF03m7m0C/nvwvUiMYt
         ZBuyf0KG/TdBn3wYxJQubmTVra4/5VzGC4OOCm4Yy21ID04lID8CXmvlMZot+6g4ph9O
         uiV/+lRonqjCEqhT11N90Qt1MaH0Zm2vzWEqGhq04+4RhZNcWh4TIrjFaQkpcx8aZrCo
         hA3cEQsTVU4Cz/Tj/8qpPfbZr7q2XDfeH7cPgJT0MRFnlF2AGcXtLJYS1xo8nVLuUFms
         uHaCv0oi0paLo5yWjWsBfpRl+uTp3P1xYzpY3WLAbJczYbEIV53wpVs93cjxtTkbJjaq
         C7oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736555435; x=1737160235;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0OUonYd6niVAqGjD0N5fWlc8jzGx+15I7hWbB4QzxGw=;
        b=wkjRh5AxsfGMNFvkIS6bb76HBRWliUBv6zS3bCi9SLddkOgZcd/nOO2S/5j1gM1Brg
         BwNcFsNRL43dQmyw7J8HzANDp5JG6EGbNZwdBFXdDcWQ3BjPG8FL+M++8mpbvC9yXnrX
         edU6B9L8HLdfi7IP7/z2sdwTy1STTpXDTw5cDthr6RsjmChXVf+Q4Tfwcc5x7S+RbWHb
         Vy9UgHWOqt0ylUWsffYK2ycWXgSPsJwZvGSrL6XDT1ABkicJkltEnwBvd8ami5w4dKzM
         jGcjA0uEoPYlfAJnKvcDkG2GHbyv2Vpwb5WqSbl1eP2TmPZC6KplxDF/5xRFEraO3vqy
         1efA==
X-Gm-Message-State: AOJu0Ywrajdsu3JvVWcZ/fpC3oOb8+JbvtGEtGP0AA/67hW365pcBbW/
	D8RrFCEItI0AdGx5eMT5Ww4/dijB0ysY/LvATcuW2Sq3Cj3ZuTjlxHECmx/8TSD788DRnTXB1a9
	NQw==
X-Google-Smtp-Source: AGHT+IHFSCYgXbnt54jfk0NUzmZPGnmPTpWpi3a7iqhyPYh9Baj/SV5EmS29ezlCSBsaMsUOuiqMn1EdHXk=
X-Received: from pjbsu14.prod.google.com ([2002:a17:90b:534e:b0:2e2:9f67:1ca3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2808:b0:2ee:ab10:c187
 with SMTP id 98e67ed59e1d1-2f548f598e1mr19787131a91.18.1736555435546; Fri, 10
 Jan 2025 16:30:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:30:00 -0800
In-Reply-To: <20250111003004.1235645-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111003004.1235645-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111003004.1235645-17-seanjc@google.com>
Subject: [PATCH v2 16/20] KVM: selftests: Ensure guest writes min number of
 pages in dirty_log_test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Ensure the vCPU fully completes at least one write in each dirty_log_test
iteration, as failure to dirty any pages complicates verification and
forces the test to be overly conservative about possible values.  E.g.
verification needs to allow the last dirty page from a previous iteration
to have *any* value, because the vCPU could get stuck for multiple
iterations, which is unlikely but can happen in heavily overloaded and/or
nested virtualization setups.

Somewhat arbitrarily set the minimum to 0x100/256; high enough to be
interesting, but not so high as to lead to pointlessly long runtimes.

Opportunistically report the number of writes per iteration for debug
purposes, and so that a human can sanity check the test.  Due to each
write targeting a random page, the number of dirty pages will likely be
lower than the number of total writes, but it shouldn't be absurdly lower
(which would suggest the pRNG is broken)

Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 40 ++++++++++++++++++--
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 500257b712e3..c6b843ec8e0c 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -37,6 +37,12 @@
 /* Interval for each host loop (ms) */
 #define TEST_HOST_LOOP_INTERVAL		10UL
 
+/*
+ * Ensure the vCPU is able to perform a reasonable number of writes in each
+ * iteration to provide a lower bound on coverage.
+ */
+#define TEST_MIN_WRITES_PER_ITERATION	0x100
+
 /* Dirty bitmaps are always little endian, so we need to swap on big endian */
 #if defined(__s390x__)
 # define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
@@ -72,6 +78,7 @@ static uint64_t host_page_size;
 static uint64_t guest_page_size;
 static uint64_t guest_num_pages;
 static uint64_t iteration;
+static uint64_t nr_writes;
 static bool vcpu_stop;
 
 /*
@@ -107,6 +114,7 @@ static void guest_code(void)
 	for (i = 0; i < guest_num_pages; i++) {
 		addr = guest_test_virt_mem + i * guest_page_size;
 		vcpu_arch_put_guest(*(uint64_t *)addr, READ_ONCE(iteration));
+		nr_writes++;
 	}
 #endif
 
@@ -118,6 +126,7 @@ static void guest_code(void)
 			addr = align_down(addr, host_page_size);
 
 			vcpu_arch_put_guest(*(uint64_t *)addr, READ_ONCE(iteration));
+			nr_writes++;
 		}
 
 		GUEST_SYNC(1);
@@ -548,8 +557,8 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long **bmap)
 		}
 	}
 
-	pr_info("Iteration %2ld: dirty: %-6lu clean: %-6lu\n",
-		iteration, nr_dirty_pages, nr_clean_pages);
+	pr_info("Iteration %2ld: dirty: %-6lu clean: %-6lu writes: %-6lu\n",
+		iteration, nr_dirty_pages, nr_clean_pages, nr_writes);
 
 	host_dirty_count += nr_dirty_pages;
 	host_clear_count += nr_clean_pages;
@@ -665,6 +674,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	host_dirty_count = 0;
 	host_clear_count = 0;
 	WRITE_ONCE(dirty_ring_vcpu_ring_full, false);
+	WRITE_ONCE(nr_writes, 0);
+	sync_global_to_guest(vm, nr_writes);
 
 	/*
 	 * Ensure the previous iteration didn't leave a dangling semaphore, i.e.
@@ -683,10 +694,22 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 		dirty_ring_prev_iteration_last_page = dirty_ring_last_page;
 
-		/* Give the vcpu thread some time to dirty some pages */
-		for (i = 0; i < p->interval; i++) {
+		/*
+		 * Let the vCPU run beyond the configured interval until it has
+		 * performed the minimum number of writes.  This verifies the
+		 * guest is making forward progress, e.g. isn't stuck because
+		 * of a KVM bug, and puts a firm floor on test coverage.
+		 */
+		for (i = 0; i < p->interval || nr_writes < TEST_MIN_WRITES_PER_ITERATION; i++) {
+			/*
+			 * Sleep in 1ms chunks to keep the interval math simple
+			 * and so that the test doesn't run too far beyond the
+			 * specified interval.
+			 */
 			usleep(1000);
 
+			sync_global_from_guest(vm, nr_writes);
+
 			/*
 			 * Reap dirty pages while the guest is running so that
 			 * dirty ring full events are resolved, i.e. so that a
@@ -737,6 +760,12 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		WRITE_ONCE(vcpu_stop, false);
 		sync_global_to_guest(vm, vcpu_stop);
 
+		/*
+		 * Sync the number of writes performed before verification, the
+		 * info will be printed along with the dirty/clean page counts.
+		 */
+		sync_global_from_guest(vm, nr_writes);
+
 		/*
 		 * NOTE: for dirty ring, it's possible that we didn't stop at
 		 * GUEST_SYNC but instead we stopped because ring is full;
@@ -760,6 +789,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			WRITE_ONCE(host_quit, true);
 		sync_global_to_guest(vm, iteration);
 
+		WRITE_ONCE(nr_writes, 0);
+		sync_global_to_guest(vm, nr_writes);
+
 		WRITE_ONCE(dirty_ring_vcpu_ring_full, false);
 
 		sem_post(&sem_vcpu_cont);
-- 
2.47.1.613.gc27f4b7a9f-goog


