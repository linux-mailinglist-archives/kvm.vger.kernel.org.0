Return-Path: <kvm+bounces-16187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B00E68B616B
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 20:50:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6600D28256E
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 18:50:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 130C313AA37;
	Mon, 29 Apr 2024 18:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I8MQPreS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3723A127E20;
	Mon, 29 Apr 2024 18:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714416638; cv=none; b=tcBsUKQ7B7np2TVBvI9qXjDg9sC52AFTk3G/gexvPBNdNiIxi2Zhvbe4b06BEkjv1r7ItBhi6TpVrOoRWCwOpUbedcgDg2ymfn3PuPvu8AO/YrNFmMNBLBjBJKpFlyJbVetLdfgyS6a+FVkQd2ZErAVTRjut5EKzh7bTIA8OWts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714416638; c=relaxed/simple;
	bh=UUe9Ym8luVvg7SpvhcbVnB1HXHf9DLh6B2dgv/+wHJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=soQv1ZDaKg0uZmrYrw5fPNRweXM5AHIbqFHQ7Mjm9s+6gG7MPy19O1C7X0L61VnEI3J61uzkDGutxtClvX6uH3yI58OVU/cOfOMjZtH+BTK+DubW2IorAzkOON5lodt40EOJ4C6abN4NKMlTL9s1RKt254k9UroQbjLJaLnx7IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I8MQPreS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D637C113CD;
	Mon, 29 Apr 2024 18:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714416637;
	bh=UUe9Ym8luVvg7SpvhcbVnB1HXHf9DLh6B2dgv/+wHJE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I8MQPreSR7WM849pfNTwUgstd2lzMBqaFexD4EpmqXGh2Q62FSCMZz8DogZwRpP0C
	 K1EAG8eB0WhQaqCJL6WhqB/c3CB9lw6Flxq+VXFuKGUyePhaKvpH6HvXK7h/Fie6Q4
	 zsZPAmn7koM6r+592OZ8g6EZxz4Chz4weTo+glzAbjy5Rt+pWW7s1tnT3wY31LekCH
	 UMwakkLVKAvGZjWmX2NxNnrsR1xd6kJELxw0UW6UU73p1b1fioNyc1YnSTXqQxpqCN
	 nnVBIEpm5p8dkXY+ItyNgXmkQGhx7pHQcNWR6pnyqwr60McMhu5aOia9XYu4KZa31i
	 CYMeaihsj2PIQ==
Date: Mon, 29 Apr 2024 15:50:34 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Shenlin Liang <liangshenlin@eswincomputing.com>
Cc: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com,
	palmer@dabbelt.com, aou@eecs.berkeley.edu, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, peterz@infradead.org,
	mingo@redhat.com, namhyung@kernel.org, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v3 0/2] perf kvm: Add kvm stat support on riscv
Message-ID: <Zi_r-oe_u7NkV7sa@x1>
References: <20240422080833.8745-1-liangshenlin@eswincomputing.com>
 <5e830d33.45c7.18f287c8f73.Coremail.liangshenlin@eswincomputing.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e830d33.45c7.18f287c8f73.Coremail.liangshenlin@eswincomputing.com>

On Mon, Apr 29, 2024 at 02:13:22PM +0800, Shenlin Liang wrote:
> Gentle ping...

It would be great to have people with such boards testing your patchkit
and providing Tested-by tags.

Also the patch set has both kernel and tooling support, thus needs to
find a RiscV kernel maintainer to pick the kernel bits and then, when
that was merged, I would look at reports of tests for the tooling side
to then merge it.

Hope this clarifies the process,

- Arnaldo

> > 'perf kvm stat report/record' generates a statistical analysis of KVM
> > events and can be used to analyze guest exit reasons. This patch tries
> > to add stat support on riscv.
> > 
> > Map the return value of trace_kvm_exit() to the specific cause of the 
> > exception, and export it to userspace.
> > 
> > It records on two available KVM tracepoints for riscv: "kvm:kvm_entry"
> > and "kvm:kvm_exit", and reports statistical data which includes events
> > handles time, samples, and so on.
> > 
> > Cross compiling perf in X86 environment may encounter issues with missing
> > libraries and tools. Suggest compiling nativly in RISC-V environment
> > 
> > Simple tests go below:
> > 
> > # ./perf kvm record -e "kvm:kvm_entry" -e "kvm:kvm_exit"
> > Lowering default frequency rate from 4000 to 2500.
> > Please consider tweaking /proc/sys/kernel/perf_event_max_sample_rate.
> > [ perf record: Woken up 18 times to write data ]
> > [ perf record: Captured and wrote 5.433 MB perf.data.guest (62519 samples) 
> > 
> > # ./perf kvm report
> > 31K kvm:kvm_entry
> > 31K kvm:kvm_exit
> > 
> > # ./perf kvm stat record -a
> > [ perf record: Woken up 3 times to write data ]
> > [ perf record: Captured and wrote 8.502 MB perf.data.guest (99338 samples) ]
> > 
> > # ./perf kvm stat report --event=vmexit
> > Event name                Samples   Sample%    Time (ns)     Time%   Max Time (ns)   Min Time (ns)  Mean Time (ns)
> > STORE_GUEST_PAGE_FAULT     26968     54.00%    2003031800    40.00%     3361400         27600          74274
> > LOAD_GUEST_PAGE_FAULT      17645     35.00%    1153338100    23.00%     2513400         30800          65363
> > VIRTUAL_INST_FAULT         1247      2.00%     340820800     6.00%      1190800         43300          273312
> > INST_GUEST_PAGE_FAULT      1128      2.00%     340645800     6.00%      2123200         30200          301990
> > SUPERVISOR_SYSCALL         1019      2.00%     245989900     4.00%      1851500         29300          241403
> > LOAD_ACCESS                986       1.00%     671556200     13.00%     4180200         100700         681091
> > INST_ACCESS                655       1.00%     170054800     3.00%      1808300         54600          259625
> > HYPERVISOR_SYSCALL         21        0.00%     4276400       0.00%      716500          116000         203638 
> > 
> > Changes from v1->v2:
> > - Rebased on Linux 6.9-rc3.
> > 
> > Changes from v2->v3:
> > - Add the missing assignment for 'vcpu_id_str' in patch 2.
> > - Remove parentheses that cause compilation errors
> > 
> > Shenlin Liang (2):
> >   RISCV: KVM: add tracepoints for entry and exit events
> >   perf kvm/riscv: Port perf kvm stat to RISC-V
> > 
> >  arch/riscv/kvm/trace.h                        | 67 ++++++++++++++++
> >  arch/riscv/kvm/vcpu.c                         |  7 ++
> >  tools/perf/arch/riscv/Makefile                |  1 +
> >  tools/perf/arch/riscv/util/Build              |  1 +
> >  tools/perf/arch/riscv/util/kvm-stat.c         | 79 +++++++++++++++++++
> >  .../arch/riscv/util/riscv_exception_types.h   | 35 ++++++++
> >  6 files changed, 190 insertions(+)
> >  create mode 100644 arch/riscv/kvm/trace.h
> >  create mode 100644 tools/perf/arch/riscv/util/kvm-stat.c
> >  create mode 100644 tools/perf/arch/riscv/util/riscv_exception_types.h
> > 
> > -- 
> > 2.37.2

