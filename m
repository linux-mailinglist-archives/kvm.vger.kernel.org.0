Return-Path: <kvm+bounces-35152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 505EDA09F61
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:31:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02DA516AE3D
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:31:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97FA31487D5;
	Sat, 11 Jan 2025 00:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XjkINmoL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA4DBE65
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555419; cv=none; b=EMZ3uSY4ZrQKa0eqsZlmUGYArt7t10dJHy2VSyWkhrVhqWJ4wI4P6aGh0yzT/KM3mTIjr4w48qXBtsIKrjARULuDP4JolzgiwFNVhhyXMWSBCH+hMhcFxQrNfZGNWcN4XuljizoejqQOEywZSa0GuM35xbIENbHJuOHKlx7ZV0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555419; c=relaxed/simple;
	bh=ClODUFGrnkeK47VHzL8EGhn6t9shMEOwc3unT1VlQVE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nOy1PKIGQtALC5hdjBjBTIETmRBoyAUmcTHxgXVsGG/j8/7ZeLUlxkT/4eT2uM+/8iZS+nzUN5bggIcC2AtBNJiJn6OSJNfuIKBCV3uIz58BlDFWcJQqixWj4aez0Km70Advep0ldvOAMLua/vH4tegU+Wv1YDVyWkws5IW8lRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XjkINmoL; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2eebfd6d065so6668781a91.3
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736555417; x=1737160217; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lND6mfK1KolGbB6fWPNpX/ljO5ryDlTwA1yXgkJjBtY=;
        b=XjkINmoLRu+VePp0vMNMhwi1YJKZanuuo9OwUHrDvQk5kBN8PlYWy9jXMkwo1hmH2z
         SW0MbPVU3yyzvi+WHqHm09Coch9U9WNg8A5wGABYg14eNKIQubm7LXEHAFrNvREOxLyy
         H7wSCsAgfcT6OWGPh3E87AvF2itRAgRb7937TvIBNyI8XW/nypvC4RqhGb6lxkkYgDyZ
         CIyF5r4ljXupE1OcvOZ+nweB9yKyg0v5r+sXLIkPr9EAekeLmKeO1quoe6j8Uin4F7+T
         HWBQ/8pqKuIAc6WTP5KU39IwO6cj1hyLKH6WU9ZOUF7ojHxtzipsjdyFHkpQ2+UG2N+b
         W7iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736555417; x=1737160217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lND6mfK1KolGbB6fWPNpX/ljO5ryDlTwA1yXgkJjBtY=;
        b=JAw/ZZEXWi/pn+E44G0+/+FVbxaowG4HnU1SlWtAxKktxaB/UmYUVXbrHbn0zUXikz
         F5NN8Koq1YO0YsM9kpJ+o1s0W+iq6jNCufESfGB7k/MBcyM78FusSWEypZo7+urfhSE6
         l91ib8GxxwAauN0sE94nR1a7jKR/KA9fAti/nHUVtNheYOTuHBByrrucr3urFMTHE8Cm
         4T6xuAekhJq0CWc4vzoYTkErifcFNXXtSQ3BuBPeNxfFiCYxeRDSdf1bLjKuxZHfzv6P
         opwBD45KhgyMdUd8ByP/dQmci3MfFeef0YA/IUxDi/qoPr71Un2Kd59GmyVopYvQSwxG
         +hpw==
X-Gm-Message-State: AOJu0YxOh2MksfoFbubHQm4nt9NFhuFl6DmgQj6cRv7lnGW4uxKQcUyj
	ygqoqN/ImUyoJTBqJyCFrb5AEdeCiKf8Yx9zgslKUa3lZ+zmmEMgIqcyQtzoRl0EWwRJmIBE3Mt
	jsA==
X-Google-Smtp-Source: AGHT+IHNg8o7uKSRq8i9WX+D0OybaQRuZsnIXdWPpm+yNQBkTw0cagzp8N5KhO48THrkFIPMDIb2kmggOrc=
X-Received: from pjuw3.prod.google.com ([2002:a17:90a:d603:b0:2ea:9d23:79a0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:274b:b0:2ee:8427:4b02
 with SMTP id 98e67ed59e1d1-2f548f5f941mr17976244a91.28.1736555417474; Fri, 10
 Jan 2025 16:30:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:29:49 -0800
In-Reply-To: <20250111003004.1235645-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111003004.1235645-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111003004.1235645-6-seanjc@google.com>
Subject: [PATCH v2 05/20] KVM: selftests: Precisely track number of
 dirty/clear pages for each iteration
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Track and print the number of dirty and clear pages for each iteration.
This provides parity between all log modes, and will allow collecting the
dirty ring multiple times per iteration without spamming the console.

Opportunistically drop the "Dirtied N pages" print, which is redundant
and wrong.  For the dirty ring testcase, the vCPU isn't guaranteed to
complete a loop.  And when the vCPU does complete a loot, there are no
guarantees that it has *dirtied* that many pages; because the writes are
to random address, the vCPU may have written the same page over and over,
i.e. only dirtied one page.

While the number of writes performed by the vCPU is also interesting,
e.g. the pr_info() could be tweaked to use different verbiage, pages_count
doesn't correctly track the number of writes either (because loops aren't
guaranteed to a complete).  Delete the print for now, as a future patch
will precisely track the number of writes, at which point the verification
phase can report the number of writes performed by each iteration.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 55a744373c80..08cbecd1a135 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -388,8 +388,6 @@ static void dirty_ring_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
 
 	if (READ_ONCE(dirty_ring_vcpu_ring_full))
 		dirty_ring_continue_vcpu();
-
-	pr_info("Iteration %ld collected %u pages\n", iteration, count);
 }
 
 static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu)
@@ -508,24 +506,20 @@ static void log_mode_after_vcpu_run(struct kvm_vcpu *vcpu)
 static void *vcpu_worker(void *data)
 {
 	struct kvm_vcpu *vcpu = data;
-	uint64_t pages_count = 0;
 
 	while (!READ_ONCE(host_quit)) {
-		pages_count += TEST_PAGES_PER_LOOP;
 		/* Let the guest dirty the random pages */
 		vcpu_run(vcpu);
 		log_mode_after_vcpu_run(vcpu);
 	}
 
-	pr_info("Dirtied %"PRIu64" pages\n", pages_count);
-
 	return NULL;
 }
 
 static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 {
+	uint64_t page, nr_dirty_pages = 0, nr_clean_pages = 0;
 	uint64_t step = vm_num_host_pages(mode, 1);
-	uint64_t page;
 	uint64_t *value_ptr;
 	uint64_t min_iter = 0;
 
@@ -544,7 +538,7 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 		if (__test_and_clear_bit_le(page, bmap)) {
 			bool matched;
 
-			host_dirty_count++;
+			nr_dirty_pages++;
 
 			/*
 			 * If the bit is set, the value written onto
@@ -605,7 +599,7 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 				    " incorrect (iteration=%"PRIu64")",
 				    page, *value_ptr, iteration);
 		} else {
-			host_clear_count++;
+			nr_clean_pages++;
 			/*
 			 * If cleared, the value written can be any
 			 * value smaller or equals to the iteration
@@ -639,6 +633,12 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 			}
 		}
 	}
+
+	pr_info("Iteration %2ld: dirty: %-6lu clean: %-6lu\n",
+		iteration, nr_dirty_pages, nr_clean_pages);
+
+	host_dirty_count += nr_dirty_pages;
+	host_clear_count += nr_clean_pages;
 }
 
 static struct kvm_vm *create_vm(enum vm_guest_mode mode, struct kvm_vcpu **vcpu,
-- 
2.47.1.613.gc27f4b7a9f-goog


