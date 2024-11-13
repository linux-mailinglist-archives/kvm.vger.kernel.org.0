Return-Path: <kvm+bounces-31796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 85ED89C7BD1
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 20:02:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16D161F22149
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 19:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A309B205AD0;
	Wed, 13 Nov 2024 19:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q3L4AAuY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B874202647
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 19:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731524521; cv=none; b=r24gApUV+kQ7od6SOGsYukVecs0lIK6efSfp/IVlNPfRNqB/xNlEh50tcKj2D6HysXbXwHZ3SGUgHRG8HILDD2zGjwTWpXduxPBbWRzujFhUBEurBcJ+X9vVxcNMCgwD8QCB5+tPDbcJi817SbFt23B2cTgqEZJuNPXsEtQcdm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731524521; c=relaxed/simple;
	bh=wSkHLXFPrs83Pn5/F539ICRvLrsaXMik0UWJ3y+YCFI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IKAP+eQOasA6dlXLSenDAx/hAPSVwsSslDQ3EM8quIT1CJ2MoTS9vdx8aZHliKOy+9hDrsqidniqTjl8lAiNzI0A5MZhUZRZEnwAxB0yeGcxpy3d3arSYv5s8rbKPrOi8bNZMM4u+pew2cztaKqtgb7rlrCzf98ULTxcEU+4hf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q3L4AAuY; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-83adc5130e3so768577439f.0
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 11:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731524519; x=1732129319; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PXcTglpRYSGUG70owXD7nOF+NHWPUf0sMel4JnLxMI0=;
        b=q3L4AAuYm4lvQ/PUvEMyoNQTbtVPNUM54kMpNNpE3LVIdu+hK9bP+KRUDSGwVB6MWS
         beg1sajh0YqZFcpFvMluPTbO+9z7t799P2QpA/+iKnVdbHHLn3wHnoea36cGQQXiEy6O
         Gra/zYxL1FSmVn35g+UPM3su8/h+elv2DPuu+z/YF4Gl8VNEuEB3lUzL2T0knurK9u+k
         3suD8oWFU66HammbakuVrn5xYrSsoQr6D8/FZg8yDnrsyg6UV9WhJjscMbgg7oF3f3b7
         x+jcUYRJXR5WPS+yv+W5nB1GSyaZZ2MJW3Q4DNfr2bH+tz+ak9cvRnjT90YdQVlOaGeO
         tGKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731524519; x=1732129319;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PXcTglpRYSGUG70owXD7nOF+NHWPUf0sMel4JnLxMI0=;
        b=X+5jnr/VJjqiX3klEe5CP/SG/JkZLoRpSSp8BCJkNr4DLX/eAlpTglLGhRfw8iPFVt
         ab/5VZ2rRxXXiIioTqBxv4Qze4QwBGWdOEpbBzstpCJKKGhjYzhtndayQgSyqdDvOOog
         cT7V59Enq8ld1CUf7e/pX34LcbxxcV2K4pWef7OkIjXB7n1vFGA14Mt9BOrPl/rgfBoY
         hsenHyINuzg39bTinFo38faNY7zYD9Ky7Y/s7NzExAuZNjwh8tC+Q7s3CfFutYcRKZe7
         fjGvwFAMAHTsny0sbHq5mCSXh9yzMr0nTI3Sb88mU/vwTXNosi2uGAqkiP6P3IsH7s94
         72sQ==
X-Gm-Message-State: AOJu0Yzo7UV7sILxgh/+0LF+TIFHRAVjZG/dpl4AKO99E+tCTWMvfUUh
	+d5PBfGL1lhE4CVKjFsTA0lX3/NWAvkEYA113+1rDtJpl8CC8k+gHkbz/fD+0jNLsczgrXOOw+F
	+dt+GTU8NXksHrF8p+mYeuMnkV2Kke6D+AalWYjPbEjcLKdQ9AmjCEe32xUGGw+jwFRAMWBUAUs
	MwItofs0pBHbKHBySJVcOLY4qaic+Y6jiDNbreUe0EhN9zTNFTad4+OmI=
X-Google-Smtp-Source: AGHT+IFIUdSo/WNLK0PV98lBe9m4ohTkfvDAOqn44oZ30S/C6GtrbtwtcCTbX1AO1mQEzViQLH/wGxNpeNufHAxBww==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a05:6602:255a:b0:83a:9936:d1a6 with
 SMTP id ca18e2360f4ac-83e4fb9178dmr1860539f.4.1731524519017; Wed, 13 Nov 2024
 11:01:59 -0800 (PST)
Date: Wed, 13 Nov 2024 19:01:50 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241113190156.2145593-1-coltonlewis@google.com>
Subject: [PATCH v8 0/5] Correct perf sampling with Guest VMs
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

v8:
* Improve patch 4 perf flags refactor
* Rebase to v6.12-rc7

v7:
https://lore.kernel.org/all/20241107190336.2963882-1-coltonlewis@google.com/

v6:
https://lore.kernel.org/all/20241105195603.2317483-1-coltonlewis@google.com/

v5:
https://lore.kernel.org/all/20240920174740.781614-1-coltonlewis@google.com/

v4:
https://lore.kernel.org/kvm/20240919190750.4163977-1-coltonlewis@google.com/

v3:
https://lore.kernel.org/kvm/20240912205133.4171576-1-coltonlewis@google.com/

v2:
https://lore.kernel.org/kvm/20240911222433.3415301-1-coltonlewis@google.com/

v1:
https://lore.kernel.org/kvm/20240904204133.1442132-1-coltonlewis@google.com/

This series cleans up perf recording around guest events and improves
the accuracy of the resulting perf reports.

Perf was incorrectly counting any PMU overflow interrupt that occurred
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
 arch/arm/kernel/perf_callchain.c             | 17 ------
 arch/arm64/include/asm/perf_event.h          |  4 --
 arch/arm64/kernel/perf_callchain.c           | 28 ---------
 arch/powerpc/include/asm/perf_event_server.h |  6 +-
 arch/powerpc/perf/callchain.c                |  2 +-
 arch/powerpc/perf/callchain_32.c             |  2 +-
 arch/powerpc/perf/callchain_64.c             |  2 +-
 arch/powerpc/perf/core-book3s.c              |  4 +-
 arch/s390/include/asm/perf_event.h           |  6 +-
 arch/s390/kernel/perf_event.c                |  4 +-
 arch/x86/events/core.c                       | 64 +++++++++++++-------
 arch/x86/include/asm/perf_event.h            | 12 ++--
 include/linux/perf_event.h                   | 26 +++++++-
 kernel/events/core.c                         | 27 ++++++++-
 15 files changed, 111 insertions(+), 100 deletions(-)


base-commit: 2d5404caa8c7bb5c4e0435f94b28834ae5456623
--
2.47.0.338.g60cca15819-goog

