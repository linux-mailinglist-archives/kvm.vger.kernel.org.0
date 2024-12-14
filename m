Return-Path: <kvm+bounces-33797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BA2879F1BB6
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 02:09:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0E1DC7A03A7
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 01:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD26514F9D9;
	Sat, 14 Dec 2024 01:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s5Fbfe8+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCB880BEC
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 01:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734138454; cv=none; b=qU/2CdI1JbhdhMA8LPFfE+i5N7+8ltiQrlzRAm/ecr0qoP+OqKnQL7k9KUyP5EWO4NLC/OlJFD0T0laeFatw22NSc+vgzThTPZRKcmUwLfJ/HAeghH3J+qz/CsEqZAmw7kzndCQ4AyO2R3BipeGarAVpAYMhfgBimoKwQC4yxRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734138454; c=relaxed/simple;
	bh=4pS0dReh/up25k1SmFevQedfviIhDfa09ijAKDGjf8s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EBIG1JkpNbKg8cFnGloxDj9qppdLRqpEP3KeSBf/7RZASWsUPIgUPKdssdBdFGDV6fiAA8KXtrKZIg8gD2H9Nms/6hkT29qgp9Z3GDYOHM5ZW62DcU4HbglotsMye0Sm5L5cizaLruE0BCtuv4+aXl01op8V0qgQVwC6Ev2MrK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s5Fbfe8+; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9dbeb848so2112983a91.0
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 17:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734138453; x=1734743253; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9KFGe38o+KQQhYANMpHrh9BBXbfP6MTs5wlchBkgdrs=;
        b=s5Fbfe8+X01LYdENhRRVQVArOK2pyVlokD/1E96t6+9jDCQ2jY4kSemoZuk9J+L/aX
         eroYUNJeMhCDYsRAytFauu9RherPOcz+x3siQqSb4+uYN3u+KE4bbEX9tLS3iXfJVh7r
         rczmxISzu6flrPF94+XqAwThhIp5t/Lbdwwz3wNZiOeLHFtU50HLeS03k8mWjOfrLfSY
         LDX5lJI+g/l0nks+V0i/G1YOLoIm6ZuVUJ5jUA1ieODxKccifqYPWHqJpISAKK53ozeq
         Ojoxu0oaUCnfigPymylzlhHnA7LrIaTRV25hiXvsRd14AMldLrhSFmSrFc4K3OBuq47W
         nqoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734138453; x=1734743253;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9KFGe38o+KQQhYANMpHrh9BBXbfP6MTs5wlchBkgdrs=;
        b=cCYyxe5GGhtSCV71TJatQ13uBmoRJaQiNJORQgoIlgRbeq2fC6i5rC1VwELNxIkVxx
         fKZP9C0gsQKAj/iHpTrR77jUrv6Zbdk24sW89pkyfXfPB73DGKTdQQbzA2fQw+gmZW+F
         VyYxDxyU0en+uFXXVHTq3MpNJFFyiLo11pKBiDhSxtlE7In2E+Y5f6aoBTMIEvrKm3Bq
         ly7ljwuOHVNkWWT5L0kVIwYBEJLCgrn9msBI8v1he/P9hrzB6wICHzN0PU7NrmByMlQ0
         FHvgnR11sVZjr3v/5r/8HEBGmT4o6cuRKJFb2GE8J5A8PkP7E6aib8xQBL0YJz0UmFJX
         vdXQ==
X-Gm-Message-State: AOJu0Yz7BiSoF0JGgkgM4dI/QrFfioREuhmAs+SfotQdLbuXBDprxgq5
	6s1yuIG2Jre40Jvj6pNq53ocgk6aMq5wHDa6dYAvTZmSbuXaG1tsz1Cg3xcLQHQDIIhNca50YtK
	vhA==
X-Google-Smtp-Source: AGHT+IFLzgs5F8QCfrknTflXosKen4RqTbGemD8kyxhrrln2JSECS9E0IPHmRH8Lkh7TOiPqadAmPbZYuqc=
X-Received: from pjh7.prod.google.com ([2002:a17:90b:3f87:b0:2ef:a732:f48d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d450:b0:2ee:599e:f411
 with SMTP id 98e67ed59e1d1-2f2901b0befmr6154981a91.34.1734138452942; Fri, 13
 Dec 2024 17:07:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Dec 2024 17:07:06 -0800
In-Reply-To: <20241214010721.2356923-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241214010721.2356923-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241214010721.2356923-6-seanjc@google.com>
Subject: [PATCH 05/20] KVM: selftests: Precisely track number of dirty/clear
 pages for each iteration
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


