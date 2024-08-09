Return-Path: <kvm+bounces-23784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8BE494D796
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:46:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 944AB283513
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 582A0192B94;
	Fri,  9 Aug 2024 19:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yJzVP8fp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CD116F265
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723232636; cv=none; b=JwnbeHMA1fqsqeCjGQ75TetXZ5p+Mt5Q1n94pa1ChQE5wiZ+SChfRCNMe3kB2dHAWrqgG0N5uhFTbEsX6b1Lu1Lqn0Bhn/tZTSwbOa9X6IgZtav8Ao8Wz1OrTlCNJSvPHG9XyrlPY43z0exz0BBSC9sAj4ZA6oYhbY2qScd5eqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723232636; c=relaxed/simple;
	bh=JMLriyucuH1C15GtvvibdoIfA8+6so79QMDBwKK8/UQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HFPNlBpSGeHyBOpxwYG53wYlNrBmfnxpwfBd+mmkyi0BQa2I72oUzUtD/+oDQWcsKG/8/a4VYr4+Wl23R/MMfvdkymBqS7LTWAaeOC4gG0/MZ0IZ3hQiYtM9H09wu2JJ2oo0yDq0uy5f+cGfyxI32fqgkXLR10k3gdhxUUUga7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yJzVP8fp; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2d1989d103eso3012763a91.2
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723232634; x=1723837434; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KtOd9aj4hqeGD1AC+o3mLs+Sgxz7FerwNOXhm7lsLkU=;
        b=yJzVP8fpammFpUwlRKxnR30bVqCTcPr6UQpxuw18PmiM5fSSjMw+yv4gKxL4pi3sqF
         zhHLJAzpPap6QdBRQO6yPeYO+2Sdloc0CW5kdXRlnbNToXyyQgxA2yHm9Tv9beKhM3fA
         njYEpKrjTfqEZUZ2Cbu2moRRTsH1NRhAsExnPh27+dmmEEoUYkhcD6gr/fuVSkaoroAP
         aejQhHfhgbOH+AcKZNqGr4lHfca35Vk0WCVTq/mVCtgEX1NOplJGnEoJJ0jTwC9pgu4O
         +1i5/m0EGXGqbldIFrQgbVih2h0K3ZEWMEt7SZoQKVxn2QpgeiZDZAT2Hff9oVJ/eUXh
         UsXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723232634; x=1723837434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KtOd9aj4hqeGD1AC+o3mLs+Sgxz7FerwNOXhm7lsLkU=;
        b=L5uP9WssUx5b1MhTZ2jKmLJN2ItBEL8j6N1SxkxoUrH3u6yE30ESuC3EjLsJcWlSdu
         xJfLm0f/NBE2i7TPDmP6er+YwR9aQ/FpygobysdTM3wFg4nz9kkdVykhHHFMVIzIySxO
         /HzDn4wKOOY3zdQ91g17GiTxtgfTVkGUaVwKhd/HIpukNB1VZBNQt1HqKUrzZRt8zBse
         y64EKndGXeUuRWpduPqaj7YO+NAd3rvMSgfehu9FhA9EQDCKBkVpUu577SMWn51fbCWo
         ipXk0LJleNnhIa8bhfPiWGdLX/y/HQPm8W9OiXf2gqsmPQ0w5x8zv7dZ6m9pWuXRit0Y
         UMuQ==
X-Gm-Message-State: AOJu0Yy+CLcVMowDA4Xa/8HALohqO/npDvlwRN/RqSiuwn8AP5vGzOjs
	IQPAKaBD9Zkam8mLcamQeIGM2gRNi/jeeDAo3jmWMEO1k55HJB7oCYf+ksCAWgUWl/q3CokWSn8
	aAw==
X-Google-Smtp-Source: AGHT+IGvAmg8+tqrGrCIZoGsSdnG8ZSFhwx3qgY9wt9WSt5Z7jq3JEgK8XnEDH316ti3bUud1crZuHLg05M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:a88:b0:2c3:1985:e9c3 with SMTP id
 98e67ed59e1d1-2d1e80b80femr12946a91.3.1723232634383; Fri, 09 Aug 2024
 12:43:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:43:20 -0700
In-Reply-To: <20240809194335.1726916-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809194335.1726916-9-seanjc@google.com>
Subject: [PATCH 08/22] KVM: selftests: Add a read-only mprotect() phase to mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a third phase of mmu_stress_test to verify that mprotect()ing guest
memory to make it read-only doesn't cause explosions, e.g. to verify KVM
correctly handles the resulting mmu_notifier invalidations.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 22 +++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 9573ed0e696d..50c3a17418c4 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -27,6 +27,10 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 		GUEST_SYNC(i);
 	}
 
+	for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
+		*((volatile uint64_t *)gpa);
+	GUEST_SYNC(2);
+
 	GUEST_ASSERT(0);
 }
 
@@ -94,6 +98,10 @@ static void *vcpu_worker(void *data)
 	run_vcpu(vcpu, 1);
 	rendezvous_with_boss();
 
+	/* Stage 2, read all of guest memory, which is now read-only. */
+	run_vcpu(vcpu, 2);
+	rendezvous_with_boss();
+
 	return NULL;
 }
 
@@ -174,7 +182,7 @@ int main(int argc, char *argv[])
 	const uint64_t start_gpa = SZ_4G;
 	const int first_slot = 1;
 
-	struct timespec time_start, time_run1, time_reset, time_run2;
+	struct timespec time_start, time_run1, time_reset, time_run2, time_ro;
 	uint64_t max_gpa, gpa, slot_size, max_mem, i;
 	int max_slots, slot, opt, fd;
 	bool hugepages = false;
@@ -278,14 +286,20 @@ int main(int argc, char *argv[])
 	rendezvous_with_vcpus(&time_reset, "reset");
 	rendezvous_with_vcpus(&time_run2, "run 2");
 
+	mprotect(mem, slot_size, PROT_READ);
+	rendezvous_with_vcpus(&time_ro, "mprotect RO");
+
+	time_ro    = timespec_sub(time_ro,     time_run2);
 	time_run2  = timespec_sub(time_run2,   time_reset);
-	time_reset = timespec_sub(time_reset, time_run1);
+	time_reset = timespec_sub(time_reset,  time_run1);
 	time_run1  = timespec_sub(time_run1,   time_start);
 
-	pr_info("run1 = %ld.%.9lds, reset = %ld.%.9lds, run2 =  %ld.%.9lds\n",
+	pr_info("run1 = %ld.%.9lds, reset = %ld.%.9lds, run2 = %ld.%.9lds, "
+		"ro = %ld.%.9lds\n",
 		time_run1.tv_sec, time_run1.tv_nsec,
 		time_reset.tv_sec, time_reset.tv_nsec,
-		time_run2.tv_sec, time_run2.tv_nsec);
+		time_run2.tv_sec, time_run2.tv_nsec,
+		time_ro.tv_sec, time_ro.tv_nsec);
 
 	/*
 	 * Delete even numbered slots (arbitrary) and unmap the first half of
-- 
2.46.0.76.ge559c4bf1a-goog


