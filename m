Return-Path: <kvm+bounces-31145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 76AED9C0E3C
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 20:04:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 010911F21718
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 19:04:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2078521766D;
	Thu,  7 Nov 2024 19:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1HGrMamM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DCF216E17
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 19:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731006266; cv=none; b=VooSmo90SdcT+5XwUcbQ6dpEfGOiEK8ko5LQJvZVAPGo2hkxcT4ThnKf8SKA3kz5kMTab6QY+uwcTkAqpD00sGxhihiQaFF3p7ki5fSGnknevT+KfQggEcsP0ElmgkAZHTl/xxmJnqSctWtTlka5DWHDHSqyk9PXAEjRFaZ3IMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731006266; c=relaxed/simple;
	bh=rH+0U/U8QuJjNW02LPfeGGz9R6pA7ntPpm1SvusvDpE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=uYvIjDT/eX2EdLGZRWq0SrAoCLPVhoqqQzTysjDIbhHgLUB7j45f9DA7M66xZWmlDTrM978zulkcAdozndoUORRXm8MzBhsOWprHqK3bC2VhDmdimU7bZsA20hvbqTYiIVsd2WgJgibOx3KoT9On44e0K5GtdTEtIfXKNJwXv6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1HGrMamM; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3a6b7974696so16666315ab.1
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 11:04:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731006264; x=1731611064; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=307d+oKSDEQceCQxX9m+tC9eleFe8W0Ggi8DlXu2swQ=;
        b=1HGrMamMfG8TEuoGfwUwlM8sCbBJVk+oBkT+rnoFa4r4YhGn3Xxv69nFLfNTfLB3ID
         Ufb+95OcIwK8sHZDbW+eJhTV/YfwxzkOewpN0H7UGEHHCCAGsDiLGUGbj9ayDs0M+7Yh
         OMu+s9h6T2EExBMPgm5+en4TdDCEHh8kUo/iBje4FhO/venIahVvR6b5Z7xjgVeD7bO6
         ViXfmfRjNXqzq5IsPdGIHGTFBASAVqmvrOiYdIpAqMYx2j18UeXsdQQsyF/XUKVm4LXx
         0qpoEM+Pnb+h0W4UnQT28UE8b+85gwJY534W3V+e+xw25qX0C/kfJdENNkrLv8p8H8hn
         4MRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731006264; x=1731611064;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=307d+oKSDEQceCQxX9m+tC9eleFe8W0Ggi8DlXu2swQ=;
        b=kCd8OQhoxDPkMC2wqKeiiFvGl+yy/MrdlXE6mI4yYkaXJ3LN2JKaY82onAGTceo5sB
         x+tVLrAPIoaJup9z0w3qXgJJrlELcvx1hflM+HtkWLqRpw7DHZ5Ad0VMeS63Dx6KjZMq
         cTAs0IxXegWBTDnTtcjBG079bzUT9cVs68G+6LatfHpx81RzC+4qMhYFZOOcrU03vYBt
         pWaN0i51I/feRQvrosGkh45TspmNhdOymibgkWkfoPNTFahDc+XtsK7LZm9bJohFZxhV
         9sPbdVAVEYGKtithyj2SSBBquQIAc47SigHBL9xfY0m5O62FtuJ53Mgi58IWj4JTlSX3
         OJeQ==
X-Gm-Message-State: AOJu0Yyi8hRmvDtwvfWFAEZwtkOwl24FdSXwRDDi2URJ9Mo6FRrpbhBR
	GsFmDWEmsetboq/C0y5N5jk3CfEVK+P+yUOPI2wAXkkC0dKjcGimbtaCdC/pQd1xo2g2+VSn92N
	paA9xbupGsTedJZN69mQ5Tq4yMxxv0ptuUUeRf8C5FZqWAsY/WZO2dmNf4B/34aELOtem8yKX2i
	wzvZd/rTOdOvCeo5N2GUNY7qkelVNb3IidUJQWxqLCU04Lhgz1a7RdmmQ=
X-Google-Smtp-Source: AGHT+IEEjTpPYQzMBAhybW04MdjW8AF86rC0c7OtK7AUjaSX9oKv312D06txGG3KDB2dLThYbB5SuJMvIMPM40vk7Q==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a05:6e02:1d88:b0:3a6:be9e:fb56 with
 SMTP id e9e14a558f8ab-3a6f1a44701mr21665ab.3.1731006263567; Thu, 07 Nov 2024
 11:04:23 -0800 (PST)
Date: Thu,  7 Nov 2024 19:03:31 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241107190336.2963882-1-coltonlewis@google.com>
Subject: [PATCH v7 0/5] Correct perf sampling with Guest VMs
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

v7:
* Refactor th misc_flags check in patch 4 and 5 for more clarity

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
 arch/x86/events/core.c                       | 48 ++++++++++++--------
 arch/x86/include/asm/perf_event.h            | 12 +++--
 include/linux/perf_event.h                   | 26 +++++++++--
 kernel/events/core.c                         | 27 ++++++++++-
 15 files changed, 96 insertions(+), 99 deletions(-)


base-commit: 59b723cd2adbac2a34fc8e12c74ae26ae45bf230
--
2.47.0.277.g8800431eea-goog

