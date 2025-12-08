Return-Path: <kvm+bounces-65509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C8B4CAD9D8
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 16:38:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8B937304ACAD
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 15:37:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60BDD2D73BD;
	Mon,  8 Dec 2025 15:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OoWG4ome"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EABB25783A;
	Mon,  8 Dec 2025 15:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765208270; cv=none; b=U43r0aQNADzf7iO2i+o94bY/DNtG8g7tdAVB+SOuYqWkSvfm9ikEJQj4ikAZXvQw9VKUwPAhAqP6B7Mekbevlpgv0GJO6qNS0YOIjLk/IfxLdWo6++C0IEhm5jrVdbeRbOFF33FKf3sT/XG4K8c174v9hx8sh5fsg5CVNrFxO2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765208270; c=relaxed/simple;
	bh=vCpKXfUIiz82eezbrdqJXe2AFXKcg1TqwZvez0QABgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EKwEXRTSePWUUXmevxoM1ZbSgjH+NOTgq7LdIC2dgD78zy9g0Uckzziw0DHUCw7oZLQKQOZS8o1HdEXKfQB2oFX39uhGC+ZDlSmXP7s5UkObgh3455srVJF3PIetjpEP3O9eUZqLdD+1blEiAEY8lti+i22VW9nylWquHpVey+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OoWG4ome; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wLn9Pj1RYBBe/ROihmPM3KswK8Z51Ugeg99R/pQhOhA=; b=OoWG4omeqgaxvUh8FgADNqjaaC
	juvgaLiAq5Ppq+sfIu8suggncnKgHn/WlW24ff8tjGhqnjjN334+IwwvaC920xcolbeImVxUh9kSO
	CyUgYV+zi6CeSG3tfhCi8pp5tjZQJ8Wu4pkseeK7UUuoy0SM3kJDM1L2svoJHUY0EdcDpdx+naGGm
	XrolU+XPp5CzvMG+WRw4XNArwKR6g3xoi8uZ0vGdE28D1RzEXp04ygB8Sd3PimzpthY+PAfkgzS3h
	eg+s9IvZgwFCOaH3wVz9RVWaw3Hwv4+L3Li68zpDe4K2DrcryVF8Qam+F59SRS5lRRfOsSzf3ifOv
	M6PIb97w==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vScRR-0000000AQUo-1xw8;
	Mon, 08 Dec 2025 14:42:21 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 95ACC30301A; Mon, 08 Dec 2025 16:37:38 +0100 (CET)
Date: Mon, 8 Dec 2025 16:37:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	Mingwei Zhang <mizhang@google.com>,
	Xudong Hao <xudong.hao@intel.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Xiong Zhang <xiong.y.zhang@linux.intel.com>,
	Manali Shukla <manali.shukla@amd.com>,
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v6 00/44] KVM: x86: Add support for mediated vPMUs
Message-ID: <20251208153738.GC3707837@noisy.programming.kicks-ass.net>
References: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>

On Fri, Dec 05, 2025 at 04:16:36PM -0800, Sean Christopherson wrote:
> My hope/plan is that the perf changes will go through the tip tree with a
> stable tag/branch, and the KVM changes will go the kvm-x86 tree.

> Kan Liang (7):
>   perf: Skip pmu_ctx based on event_type
>   perf: Add generic exclude_guest support
>   perf: Add APIs to create/release mediated guest vPMUs
>   perf: Clean up perf ctx time
>   perf: Add a EVENT_GUEST flag
>   perf: Add APIs to load/put guest mediated PMU context
>   perf/x86/intel: Support PERF_PMU_CAP_MEDIATED_VPMU
> 
> Mingwei Zhang (3):
>   perf/x86/core: Plumb mediated PMU capability from x86_pmu to
>     x86_pmu_cap
>
> Sandipan Das (3):
>   perf/x86/core: Do not set bit width for unavailable counters
>   perf/x86/amd: Support PERF_PMU_CAP_MEDIATED_VPMU for AMD host
> 
> Sean Christopherson (19):
>   perf: Move security_perf_event_free() call to __free_event()
>   perf/x86/core: Register a new vector for handling mediated guest PMIs
>   perf/x86/core: Add APIs to switch to/from mediated PMI vector (for
>     KVM)

That all looks to be in decent shape; lets go get this merged. There is
the nit on patch 4 and I think a number of the exports want to be
EXPORT_SYMBOL_FOR_KVM() instead, but we can do that on top.

I'll queue these patches after rc1.

