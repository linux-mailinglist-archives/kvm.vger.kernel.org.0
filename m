Return-Path: <kvm+bounces-7379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A260F8410C7
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 18:32:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6A2B1C21D69
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 17:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ADF776C70;
	Mon, 29 Jan 2024 17:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W8sNyCXd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D468C76C67
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 17:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706549539; cv=none; b=StlfA8j3tBrD3NkKDhCd4tpmLVydjk3IlWisuvc76IHoz6wkub4BRU7La7Wan/buYYal/GCkh0Gg+sXDGIahkayjRr88v+dS2EqJr7SMlZdRz8xRjTY4AiPQYcENqIN6nPnLvFJTlvLJwkEL1dvRnLYGuVugWMaA72dMiiVSD1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706549539; c=relaxed/simple;
	bh=YRp4BUluCZHs8RgVpTg5d5hV53aVQO6lRbp0r5NoFfM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dBVv9ic+iknh2mF3R2bkAZPls06P5TM3iSR6NQTULTNQ1PEXetmeau/SFYhXmj0i29GwmNf7SC8olc43oLeXJFHO/ig/gQ8wPG37DeWKuHcMTTUnmgHhSj9+bFlRA74SGUhn1GazWHRHN9PxXEC0AAHj3WkOQ8Ddswl0fFJAvL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W8sNyCXd; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbf618042daso4863682276.0
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 09:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706549537; x=1707154337; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pZZGujZoT6sM5Lr8hNPPy5oQsn3CrEfvKDxIfmYq8To=;
        b=W8sNyCXd/N/qXjTacvZp/gRU9lBcHQyo9Hy/X00w1IgkgC0m2DwOsjhRywKuViFdIV
         fElKQG3Y91tPAm0IRGVaeQLLccTpSBLvXfz24K1mpugNLei5OhejOkiTJFsH1jlUIsLi
         /Bj5L/FPfL5EU7tCmCdxZkbd7sEswBjVuWQx8bZ1qvjU9b+B+GToH5L03a8lXTduaMvg
         SUty3EMo4zs2lQdNWMqHoAHCVw3M7FJwMIH5vfXQGDkA/8enPjWXsPtarKVcPjE9Pr6P
         kCcGcAdtBq7UWXqTbKvHRngxXrUCN3gGQ5N1ieXpTKSCMDLdDaAVmFSUv5YImbnF68Ft
         Lsaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706549537; x=1707154337;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pZZGujZoT6sM5Lr8hNPPy5oQsn3CrEfvKDxIfmYq8To=;
        b=aBEjWJuOuLmXt1tQghylocEchK+l5z9eN6cL/l1xcw2ISP8VOBovrxqutEeeXQC4M0
         i/hygRT/zAH7UWMLDoBS76Mwm+ftbZDmJ4XmuwhdnG4A3muIHkOdL5bvhaYUH4pzQKEk
         PRzUBvG70BK6+d+vbZ6rntvZBcLNaKLLZsMszUJMmyAsJ2HiYScRsKOjYSDzz21zFl+V
         3lqMGXqdOCrf8AzCOHKQDKtMxCcXAkZqiaWTYS3e6fQBimYuwGmWtEiuSc8K9MytXtjn
         JbHyELe5NVDDYoB87A+jZeDekZ29mSVQQ3qXrUdOt7kcLRprTGK3Lr1VwvlsxBjLV5yq
         Y2PQ==
X-Gm-Message-State: AOJu0YxjDr1nLQMQ41NBW6DydbUww9HeRsHgtiGd8ybk+/jDg9mjytml
	zszXFHWe2LyCFz3/npyDvDmnqgb8K4noLATPm66sGKKiGoVN6zdjnSBA+Cc74eJolfP0LCVSjFs
	+vQ==
X-Google-Smtp-Source: AGHT+IHJ/i4DPTqnqZB8npqnNHttUvFnACIn8Jmuz+nWARXZQ5V5oTWnuYa0qw0vDT+AepoC6NmM+pUL1H4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:144e:b0:dc2:3a02:4fc8 with SMTP id
 a14-20020a056902144e00b00dc23a024fc8mr424567ybv.6.1706549536834; Mon, 29 Jan
 2024 09:32:16 -0800 (PST)
Date: Mon, 29 Jan 2024 09:32:15 -0800
In-Reply-To: <Zbdf+GSYU+5EGfBL@linux.bj.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240122064053.2825097-1-tao1.su@linux.intel.com>
 <ZbQYlYz5aCPFal5f@google.com> <Zbdf+GSYU+5EGfBL@linux.bj.intel.com>
Message-ID: <ZbfhH1ubtrql2Mt5@google.com>
Subject: Re: [PATCH v2] KVM: selftests: Fix dirty_log_page_splitting_test as
 page migration
From: Sean Christopherson <seanjc@google.com>
To: Tao Su <tao1.su@linux.intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org, 
	yi1.lai@intel.com, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 29, 2024, Tao Su wrote:
> On Fri, Jan 26, 2024 at 12:39:49PM -0800, Sean Christopherson wrote:
> > +David
> > 
> 
> [ ... ]
> 
> > >  
> > >  	/*
> > > @@ -192,7 +193,6 @@ static void run_test(enum vm_guest_mode mode, void *unused)
> > >  	 * memory again, the page counts should be the same as they were
> > >  	 * right after initial population of memory.
> > >  	 */
> > > -	TEST_ASSERT_EQ(stats_populated.pages_4k, stats_repopulated.pages_4k);
> > >  	TEST_ASSERT_EQ(stats_populated.pages_2m, stats_repopulated.pages_2m);
> > >  	TEST_ASSERT_EQ(stats_populated.pages_1g, stats_repopulated.pages_1g);
> > 
> > Isn't it possible that something other than guest data could be mapped by THP
> > hugepage, and that that hugepage could get shattered between the initial run and
> > the re-population run?
> 
> Good catch, I found that if the backing source is specified as THP, all hugepages
> can also be migrated.

The backing source for the test slots?  Using THP is inherently fragile for this
test, and IMO is firmly out of scope.  I was talking about any memslots allocated
by the core library, e.g. for the test's code and page tables.  Those should be
forced to be MADV_NOHUGEPAGE, though if the allocations are smaller than 2MiB
(I forget how much we allocate), that would suffice for now.

If we ensure the other memslots can only use 4KiB, then it's only the *.pages_4k
checks that are problematic.  Then the hugepage counts can be precise.

Something like this is what I'm thinking (again, assuming the "other" memslot
created by the library can't use THP).

---
 .../x86_64/dirty_log_page_splitting_test.c    | 21 +++++++++++--------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
index 634c6bfcd572..4864cf3fae57 100644
--- a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
+++ b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
@@ -92,7 +92,6 @@ static void run_test(enum vm_guest_mode mode, void *unused)
 	uint64_t host_num_pages;
 	uint64_t pages_per_slot;
 	int i;
-	uint64_t total_4k_pages;
 	struct kvm_page_stats stats_populated;
 	struct kvm_page_stats stats_dirty_logging_enabled;
 	struct kvm_page_stats stats_dirty_pass[ITERATIONS];
@@ -107,6 +106,9 @@ static void run_test(enum vm_guest_mode mode, void *unused)
 	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
 	host_num_pages = vm_num_host_pages(mode, guest_num_pages);
 	pages_per_slot = host_num_pages / SLOTS;
+	TEST_ASSERT_EQ(host_num_pages, pages_per_slot * SLOTS);
+	TEST_ASSERT(!(host_num_pages % 512),
+		    "Number of pages, '%lu' not a multiple of 2MiB", host_num_pages);
 
 	bitmaps = memstress_alloc_bitmaps(SLOTS, pages_per_slot);
 
@@ -165,10 +167,8 @@ static void run_test(enum vm_guest_mode mode, void *unused)
 	memstress_free_bitmaps(bitmaps, SLOTS);
 	memstress_destroy_vm(vm);
 
-	/* Make assertions about the page counts. */
-	total_4k_pages = stats_populated.pages_4k;
-	total_4k_pages += stats_populated.pages_2m * 512;
-	total_4k_pages += stats_populated.pages_1g * 512 * 512;
+	TEST_ASSERT_EQ((stats_populated.pages_2m * 512 +
+			stats_populated.pages_1g * 512 * 512), host_num_pages);
 
 	/*
 	 * Check that all huge pages were split. Since large pages can only
@@ -180,19 +180,22 @@ static void run_test(enum vm_guest_mode mode, void *unused)
 	 */
 	if (dirty_log_manual_caps) {
 		TEST_ASSERT_EQ(stats_clear_pass[0].hugepages, 0);
-		TEST_ASSERT_EQ(stats_clear_pass[0].pages_4k, total_4k_pages);
+		TEST_ASSERT(stats_clear_pass[0].pages_4k >= host_num_pages,
+			    "Expected at least '%lu' 4KiB pages, found only '%lu'",
+			    host_num_pages, stats_clear_pass[0].pages_4k);
 		TEST_ASSERT_EQ(stats_dirty_logging_enabled.hugepages, stats_populated.hugepages);
 	} else {
 		TEST_ASSERT_EQ(stats_dirty_logging_enabled.hugepages, 0);
-		TEST_ASSERT_EQ(stats_dirty_logging_enabled.pages_4k, total_4k_pages);
+		TEST_ASSERT(stats_dirty_logging_enabled.pages_4k >= host_num_pages,
+			    "Expected at least '%lu' 4KiB pages, found only '%lu'",
+			    host_num_pages, stats_clear_pass[0].pages_4k);
 	}
 
 	/*
 	 * Once dirty logging is disabled and the vCPUs have touched all their
-	 * memory again, the page counts should be the same as they were
+	 * memory again, the hugepage counts should be the same as they were
 	 * right after initial population of memory.
 	 */
-	TEST_ASSERT_EQ(stats_populated.pages_4k, stats_repopulated.pages_4k);
 	TEST_ASSERT_EQ(stats_populated.pages_2m, stats_repopulated.pages_2m);
 	TEST_ASSERT_EQ(stats_populated.pages_1g, stats_repopulated.pages_1g);
 }

base-commit: 0762cdfe8ee16e4035b0ad27418686ef0452932f
-- 

