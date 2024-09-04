Return-Path: <kvm+bounces-25906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B08996C8B8
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 22:42:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E6D71C22730
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 20:42:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95C2414B94C;
	Wed,  4 Sep 2024 20:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gXlxnbEp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420A9148317
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 20:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482548; cv=none; b=LbsofGS/BrhFteQIgfWP450sLaAS25iQu3YO2RuaPonobD+5WT3wKBU7ZWjYwM1cZAXm48BRy4IXZN+wUjPjfp8TP2EKzyWlNA41XZFmvlGYM7toVMW/fFSE63rnm6mtG5EF0SuoXkfN04Xn/Z5+Fq9mx+RmU2mgSWv53zqcDhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482548; c=relaxed/simple;
	bh=bU4WEHMjUXB/BkK12gdh/Hp4CZbybNrEQm4BQE9Nplg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=a8d8MVgGOW11S/kzT/XCwQKOqaZ0mjW+HqddEdOsj/V9H+iLMvZuRjW7nHT6cC1wBXgzNUpRieFr20ypDJ5H3vw9HESjHD6ob3tQKwwPE7gHNaH1jaTuXp9OZdb8QVJ9KsIfSItTRLdDOC39TZT3p7JIcr+rcTlk128iYxp5Lnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gXlxnbEp; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-39f5fe61ae0so315095ab.2
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2024 13:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725482546; x=1726087346; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ctqYquz1bwE1hQvpJznobcopye7Y9x/XQ0ajqPcWFZo=;
        b=gXlxnbEpCzAt0WU83UfpmQv6Q0etOtjR1xH6p1QD+XIERdbN/y7bzOw/aeVN6a6tH5
         B8YH1EizQnSeSaq8/q5ktGx3kCAGEowB/BDeYP9rT2Nb9SWAgypo4yRtagG2LxxYJU1j
         Sf5XuXFlWbgvCyiqSCyMh1nf4fARrVDJ4oNb0quTUBEX0zCRyudrICb14feqh/rVdxzR
         RZ1+zukuiamxPzPy3GXCB9eEg2oUKopGg22h9vPeJM4ts1u9NcmhOSb+c1VU9W/oLwkQ
         GicVMGk0yOvn1GVUH4J5aU+NITuXSDQMtUjAoMxWy0vu5iI+ZLMC4WmiB2p7MgaKTZPZ
         Ma8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725482546; x=1726087346;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ctqYquz1bwE1hQvpJznobcopye7Y9x/XQ0ajqPcWFZo=;
        b=gqC1geAEDgsZpjbYqtlmtTKitMLM0aJU7kJoIC5QTdRuv9CQ55FnL7nFmn6rdujJmU
         rUHCjSrmI+cFad0OKtkpbror8L4QJQRFeoxGxpoMljDHUAb4gWDEcM/errWqRHFtYPG4
         chCYQ0UCfw6VGdWPmee3s8HA56vG84CTLBI7bxU8+mQAYdrPMnQ4J+GaWZV4l9EQEwqD
         nRSjz6s/oEOL834VXjxHUGlCDN2ZdIHgGrkYTJCADhJyO/Qh6TcwZ/zrGQ3dVgtQLGQH
         jnYvggcEq8EIgFZP2NV6+8qKjcpqvEzgTN8dp2D5gWXHDNSRd2RzlT1UIb6fcaa1HYJ0
         XD3g==
X-Gm-Message-State: AOJu0YzDGwfLCin7yrmtqC11RtoOEKMh10W0w6Ac1PsKnFdWLI0yGykk
	9NVx//fOp6Mo+hIatDX/ZDl2rh9jsJ7/f4x11fzdX4QSa/9EZAjrSiLJUYE9A8OO2T1VDVsQZzK
	xkP0mBBiESulOEtmAm2MIPsqbpas0Vo+k8W5wfi6MT1eVg69Bojug4pGVy4rjWBSBpNBZzqgPad
	sbQy2Vi7Vg3ouDqzM8DySlgjfanO0Uqhw/QimlZeWP5UUNGMfq7yq3hJ4=
X-Google-Smtp-Source: AGHT+IEtsSJC9/om1b8HlFPuz7GXNfmJVWOiKxpoFqh5UO+7l+qZhOjL2xwg2jTs7pit3+eAfsD2jQ82kAHSW+Wrgw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6602:15cd:b0:81f:8d10:6f00 with
 SMTP id ca18e2360f4ac-82a262ca171mr93032039f.2.1725482546134; Wed, 04 Sep
 2024 13:42:26 -0700 (PDT)
Date: Wed,  4 Sep 2024 20:41:28 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240904204133.1442132-1-coltonlewis@google.com>
Subject: [PATCH 0/5] Correct perf sampling with guest VMs
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Kan Liang <kan.liang@linux.intel.com>, Will Deacon <will@kernel.org>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Naveen N Rao <naveen@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

This series cleans up perf recording around guest events and improves
the accuracy of the resulting perf reports.

Perf was incorrectly counting any PMU overflow interrupt that occured
while a VCPU was loaded as a guest event even when the events were not
truely guest events. This lead to much less accurate and useful perf
recordings.

See as an example the below reports of `perf record
dirty_log_perf_test -m 2 -v 4` before and after the series on ARM64.

Without series:

Samples: 15K of event 'instructions', Event count (approx.): 31830580924
Overhead  Command          Shared Object        Symbol
  54.54%  dirty_log_perf_  dirty_log_perf_test  [.] run_test
   5.39%  dirty_log_perf_  dirty_log_perf_test  [.] vcpu_worker
   0.89%  dirty_log_perf_  [kernel.vmlinux]     [k] release_pages
   0.70%  dirty_log_perf_  [kernel.vmlinux]     [k] free_pcppages_bulk
   0.62%  dirty_log_perf_  dirty_log_perf_test  [.] userspace_mem_region_find
   0.49%  dirty_log_perf_  dirty_log_perf_test  [.] sparsebit_is_set
   0.46%  dirty_log_perf_  dirty_log_perf_test  [.] _virt_pg_map
   0.46%  dirty_log_perf_  dirty_log_perf_test  [.] node_add
   0.37%  dirty_log_perf_  dirty_log_perf_test  [.] node_reduce
   0.35%  dirty_log_perf_  [kernel.vmlinux]     [k] free_unref_page_commit
   0.33%  dirty_log_perf_  [kernel.vmlinux]     [k] __kvm_pgtable_walk
   0.31%  dirty_log_perf_  [kernel.vmlinux]     [k] stage2_attr_walker
   0.29%  dirty_log_perf_  [kernel.vmlinux]     [k] unmap_page_range
   0.29%  dirty_log_perf_  dirty_log_perf_test  [.] test_assert
   0.26%  dirty_log_perf_  [kernel.vmlinux]     [k] __mod_memcg_lruvec_state
   0.24%  dirty_log_perf_  [kernel.vmlinux]     [k] kvm_s2_put_page

With series:

Samples: 15K of event 'instructions', Event count (approx.): 31830580924
Samples: 15K of event 'instructions', Event count (approx.): 30898031385
Overhead  Command          Shared Object        Symbol
  54.05%  dirty_log_perf_  dirty_log_perf_test  [.] run_test
   5.48%  dirty_log_perf_  [kernel.kallsyms]    [k] kvm_arch_vcpu_ioctl_run
   4.70%  dirty_log_perf_  dirty_log_perf_test  [.] vcpu_worker
   3.11%  dirty_log_perf_  [kernel.kallsyms]    [k] kvm_handle_guest_abort
   2.24%  dirty_log_perf_  [kernel.kallsyms]    [k] up_read
   1.98%  dirty_log_perf_  [kernel.kallsyms]    [k] __kvm_tlb_flush_vmid_ipa_nsh
   1.97%  dirty_log_perf_  [kernel.kallsyms]    [k] __pi_clear_page
   1.30%  dirty_log_perf_  [kernel.kallsyms]    [k] down_read
   1.13%  dirty_log_perf_  [kernel.kallsyms]    [k] release_pages
   1.12%  dirty_log_perf_  [kernel.kallsyms]    [k] __kvm_pgtable_walk
   1.08%  dirty_log_perf_  [kernel.kallsyms]    [k] folio_batch_move_lru
   1.06%  dirty_log_perf_  [kernel.kallsyms]    [k] __srcu_read_lock
   1.03%  dirty_log_perf_  [kernel.kallsyms]    [k] get_page_from_freelist
   1.01%  dirty_log_perf_  [kernel.kallsyms]    [k] __pte_offset_map_lock
   0.82%  dirty_log_perf_  [kernel.kallsyms]    [k] handle_mm_fault
   0.74%  dirty_log_perf_  [kernel.kallsyms]    [k] mas_state_walk


Colton Lewis (5):
  arm: perf: Drop unused functions
  perf: Hoist perf_instruction_pointer() and perf_misc_flags()
  powerpc: perf: Use perf_arch_instruction_pointer()
  x86: perf: Refactor misc flag assignments
  perf: Correct perf sampling with guest VMs

 arch/arm/include/asm/perf_event.h            |  7 ---
 arch/arm/kernel/perf_callchain.c             | 17 -------
 arch/arm64/include/asm/perf_event.h          |  4 --
 arch/arm64/kernel/perf_callchain.c           | 28 ------------
 arch/powerpc/include/asm/perf_event_server.h |  6 +--
 arch/powerpc/perf/callchain.c                |  2 +-
 arch/powerpc/perf/callchain_32.c             |  2 +-
 arch/powerpc/perf/callchain_64.c             |  2 +-
 arch/powerpc/perf/core-book3s.c              |  4 +-
 arch/s390/include/asm/perf_event.h           |  6 +--
 arch/s390/kernel/perf_event.c                |  4 +-
 arch/x86/events/core.c                       | 47 +++++++++++---------
 arch/x86/include/asm/perf_event.h            | 12 ++---
 include/linux/perf_event.h                   | 26 +++++++++--
 kernel/events/core.c                         | 27 ++++++++++-
 15 files changed, 95 insertions(+), 99 deletions(-)

--
2.46.0.469.g59c65b2a67-goog

