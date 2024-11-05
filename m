Return-Path: <kvm+bounces-30807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 236159BD640
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 20:56:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A84051F23F76
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5049F215C6E;
	Tue,  5 Nov 2024 19:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CpOwXO6/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F63213EEF
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 19:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730836592; cv=none; b=SfUfNenSPv1D2sOh0FDgXLCN5BIlYmnvfVhF59rFWkV7Cp8zWTfskWGQkd4/C6nR3OTfOnLcpdEQIh64US58hxMxewgmS/R1i26F6E6yoRcSckAxBssLkH747KLtvgLjVeADks8PDgHkZUFlCWnUXgLHgQ2T4PS070LwL887Gfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730836592; c=relaxed/simple;
	bh=sAKKgucoI4QTRhj9J+f6y3dNEk0UUb1jSv7yTfaZEHk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=J3DhuxtaVeY1Ey0ISC7/zwOv3iQ6f3X+i0Mp9uEU+88RFE+MTKaTBvt9asiZ/XjRdOFX7W1B0HxrMAO3V1zc7rLy7tCNC69hQr+j2X2bOBFtmvOTG1/JZFqTXtxV4EnGAfnlCGHLd7kHPdF2ni27S5grJWWnEMgENva9NBvQ1Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CpOwXO6/; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e3313b47a95so8037223276.3
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 11:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730836590; x=1731441390; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hzMiS31Q99SH+ivi/H+fLjhfNr8W/1ENyadMPU3uzYk=;
        b=CpOwXO6/T1OJLj+V+zxTM5S40VZK73u0z+JDZmZRZu+Qkb1ZkeRk8oyp8CVDzNpwV5
         JUnSP6YNepbqtf921rLtYfHzA25xh/PKSB+btR0NqcvqRWPvBTOnh+sYqbIBjYO83Jvq
         TThPyihb8OzQNoxKjptTXdW7uG68D5+Xo+Ikp94/nSmsF5eiKYm/8qyw5LiSeGAAZew9
         L5RiQBGrwjQL3CZexzyxVa+a0EH1ICWLbN698GSplZ+CPA+IFRLttinVa0PL8F/J2RLu
         tsZC7pH7Ob6y1M0yr+PzWf1Ji1m5O3ZM2/ajRD3elAfKtXoviduoPTSpHJr8IFFFIJOV
         41tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730836590; x=1731441390;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hzMiS31Q99SH+ivi/H+fLjhfNr8W/1ENyadMPU3uzYk=;
        b=I+osm8rn+vSOw+iTaryKk9FZO41APrIyQf3eGhiYKtr7d8Da/mbcfJ2zcWTgnvryge
         8uAybyLF8uuqRMN5FRgRaZUJwKoRcpbhB9u9SpXpvbI0nNxYs/K1q6b34c3lTG241KCw
         weZCwMogVQ+XOKamXNHUOeDa7+dHKeZwnOHFddpd89NaX9rfe/GstZloO9GFcPpP02CL
         zKs+tWwanjLmzglIrVQuw4ZujIu9T30Tc+jpxGM59nnUXpFr4RM4IWvjZ4ww9kGA9zgJ
         06qDL9B5NYH+b1QNA0wmTsNFJ1+o0xfdZQxeJhyVi2kt5JCdSqbXkj6LaLqlQUpk/29w
         dysQ==
X-Gm-Message-State: AOJu0Yx/jbsFGDsw36qzrqbxfnAdqMb691cOsCIj3go1rp9oOYJOpcxJ
	6Sudl6p24ju8RCV/9vl2alIkAkK8cwXtrMnpj3hX/5tZBdTy2JIK/hd4TxHxv+mWB9Pd2VJPpAY
	wNwU+QoG7M3m5JQ4f7RYvc3SYxLdU3yCW200CZgiaKQNzv8pEl64KewBbeQuUWWlKYY9+lj+xyN
	+S6N8ML2+AKaKQeEY6z+5/VVqvFgcQMJaxoovY6VgMvE6Z5b2Zqp1VDBs=
X-Google-Smtp-Source: AGHT+IGCeubudBZvDHKVyK9hoysogwq8Oy8BphtTGtN9ESDHF0Oe45MlIu4/byZXs6BbgdCbpbF4nba1Gh+JSm/9sQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a25:b28e:0:b0:e29:6df8:ef58 with SMTP
 id 3f1490d57ef6-e3087a5bd64mr143088276.4.1730836589136; Tue, 05 Nov 2024
 11:56:29 -0800 (PST)
Date: Tue,  5 Nov 2024 19:55:57 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <20241105195603.2317483-1-coltonlewis@google.com>
Subject: [PATCH v6 0/5] Correct perf sampling with Guest VMs
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

v6:
* Apply all Reviewed-by and Acked-by trailers from previous versions
* Rebase to v6.12-rc6

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
 arch/x86/events/core.c                       | 47 +++++++++++---------
 arch/x86/include/asm/perf_event.h            | 12 ++---
 include/linux/perf_event.h                   | 26 +++++++++--
 kernel/events/core.c                         | 27 ++++++++++-
 15 files changed, 95 insertions(+), 99 deletions(-)


base-commit: 59b723cd2adbac2a34fc8e12c74ae26ae45bf230
--
2.47.0.199.ga7371fff76-goog

