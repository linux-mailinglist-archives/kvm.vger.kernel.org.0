Return-Path: <kvm+bounces-26586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3C02975BFB
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 22:45:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A901B238DA
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 20:45:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77D5B1BF30F;
	Wed, 11 Sep 2024 20:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OUM6hTdl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2226E1BE852
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 20:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726087367; cv=none; b=H3l7VOjXTWv+Ieysa+ukDb4x1PBRN7vX1RFV3K6+9Cj6YMWEP7WWeonFjXMxsHB37bWpNX3nIe1gYvRopRmLwhNS10clI/e19b+cn+ZPUiGEj6cH620teHxT7sKY5OKLOAgHCJez4mepLwFqxekxArJG+W31y/oCTHJPG9agMqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726087367; c=relaxed/simple;
	bh=8oi3u31KxpdCNwifk0F+crB0nVZG46vd0de0WiqVC9c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gqz+Vqi73WBdq5LMO6P9QsVdqca6CXgB/0txOBRK9GJZSCGCHn3IiUtsnY+6X+yHjK0r37BAmSVRXOr9vT2XFS9BYwbJ4wn1QBXnA1uo3Omi7aygwHHcuXNJh1zYNkKGZuIv3iDnB8Vqp0zzU2Tbgu0barfAj6pHUkM6cR2GVaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OUM6hTdl; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2052e7836a0so6178665ad.0
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 13:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726087365; x=1726692165; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hqBHipBEc9VIgDpl6wbsMWiAPCMzGAxUDsb/VQrQ1Fg=;
        b=OUM6hTdl+tJZhMLUMb4clrwW+vMBVdUKc51lpK9cOdppZR5TmC7Eh9aBoXf0GVP7sS
         MS4iiKhh7dgAeVYe8BvUedALoLD9tvlnQhyg07JnOZRVUAsnROKIYbw8KVwLs+dJuHbV
         X/VKd6VoFmU6k4XORw6wON0AM8JslDkNeG/baQsYuztWKsn/izR3YeLAvZYOI/cZs6PY
         09ZDXOPIpOMUvqvuatpW+ph6kBSX96mpID/rq3O38ZibKvk3scGSKqIM0n4jdak5+xnh
         eYxPH7V6dcwV4Y6Wu43C17EuygG6ZeKoK9Y+TiSbLjyOUOECw80p6gZ+gCL2WaOZ3I21
         eZKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726087365; x=1726692165;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hqBHipBEc9VIgDpl6wbsMWiAPCMzGAxUDsb/VQrQ1Fg=;
        b=OB6g7pbibO8JbDwjfYncla3MoL6EgUB0SbvGd/7EhXsfNXz+iBla5Qt2+BwAUrWiSD
         Y8HJNt17yDTdbhpFR6e7c1yZAaeMv8/rAAedPnv8sMXaFiBefDZRdGH5jwShe58p786Z
         qqvdDO4Q66rDd2cm4llsDzs6KNYgvHx5VUB6vMaVGC4XHt1gI9+gtOnvKkq+ScfWIW89
         6UjZyex9ti3en8qiTOemfECLRRC1JIJMASW4zTXFiXxmBhFpYAQsUQ7OIYXJf5qCj/VQ
         qghmGxjkjsmiuTNVSDLf20SwqdU23sEhFupNjRAjF41D73uu3urNrRdNi55O/4Ou50ez
         SR0g==
X-Forwarded-Encrypted: i=1; AJvYcCVZXVERd9E+IfqMwNEZXGSS3C9Wm1Ph0aYMxd6lrQx6i8njMadEx0QIk23t0YcoEBOpKDE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb7kAKIkZ+r9xifJCcMFfcQi48Eui3J5trKo4Uet5S2YpDRtZ8
	XZpjr5rF+GwaJhNIi7YzBFn5+zcZa5nyHby27Ld81aZ0IMyhcJmCnwmmN0PSaf6aIK1uePDr4ro
	wvg==
X-Google-Smtp-Source: AGHT+IGFL4zTHrWHCMVM8aBCteHxHmYI7HhRHME2L0vYSDU/f35eVCRnBetmKBLszuGgfMu2jElNurnmeFg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f90b:b0:205:937f:3acb with SMTP id
 d9443c01a7336-2076e4768d5mr74435ad.10.1726087365359; Wed, 11 Sep 2024
 13:42:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Sep 2024 13:41:57 -0700
In-Reply-To: <20240911204158.2034295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911204158.2034295-13-seanjc@google.com>
Subject: [PATCH v2 12/13] KVM: selftests: Add a read-only mprotect() phase to mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>
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
2.46.0.598.g6f2099f65c-goog


