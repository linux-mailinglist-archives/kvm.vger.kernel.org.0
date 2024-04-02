Return-Path: <kvm+bounces-13346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B8F30894C08
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 09:00:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 47E53B231DD
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 07:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8144833062;
	Tue,  2 Apr 2024 07:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KgJN+PKw"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D724F328A0
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 07:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712041236; cv=none; b=m06oJoM9njSUc5hAote/0OXjNWyqYD56rJkQv4t8SIVhrbmVc8pbb5seO48SWSrFoznCP6Nc9nCIfI8CneitI9hA0YN/OLUcYxHkmvY8JYIYksEFnXF9iLkZpzQ/hL9MU8EhELO+iuxl/5INxwuwBA1j4dmySCUP9spVFqMErC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712041236; c=relaxed/simple;
	bh=DWwpz4wCjpd3OHwoJNho95qF247VTvrYLLaNHUDRIQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IgMPrhEkk7d8U//zGniJQw5g1DP2406iYI5BIAek4UaBOq4klxAA5n1V1slFSh39qw1qAh+V1c4BHkueH6X+LXwtwdZ6Rr7Dr+2Uf0UMmCH8T/ZaE38ZdbjvD1JEgYPBz14hZvQW+vnl7Rc9ICwmkWp3OszZW5OsBwtEdt9L0GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KgJN+PKw; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 2 Apr 2024 00:00:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712041232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jhuzyWXDmRkSGaUwWTpdDkWh7n7iwav7be8n1ReoOqg=;
	b=KgJN+PKwUf4lvMCNNgRHnuy8Gq613K2HNrcIC+CQUk8Sf/7s4Hx+E56N6lZRoCSA0Dlm9q
	gxlbMuDbSrzUHZgC90oQuyB0Kd8gPYgsVUsYB6BOdjK0DzwQ2E0WmDAtMn29DrZYMJC+lr
	+c9QBLLVlmBOcBZkzESUyH9WEo8wfW4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Yu Zhao <yuzhao@google.com>
Cc: James Houghton <jthoughton@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Matlack <dmatlack@google.com>, Marc Zyngier <maz@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Shaoqin Huang <shahuang@redhat.com>, Gavin Shan <gshan@redhat.com>,
	Ricardo Koller <ricarkol@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Rientjes <rientjes@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/7] KVM: arm64: Participate in bitmap-based PTE aging
Message-ID: <Zgus_A_cJ68f6glV@linux.dev>
References: <20240401232946.1837665-1-jthoughton@google.com>
 <20240401232946.1837665-7-jthoughton@google.com>
 <CAOUHufaQ-g6L5roB-3K0GamuS3p9ACpPj9XM-NF67GgrjoTj_A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOUHufaQ-g6L5roB-3K0GamuS3p9ACpPj9XM-NF67GgrjoTj_A@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 02, 2024 at 12:06:56AM -0400, Yu Zhao wrote:
> On Mon, Apr 1, 2024 at 7:30 PM James Houghton <jthoughton@google.com> wrote:
> > Suggested-by: Yu Zhao <yuzhao@google.com>
> 
> Thanks but I did not suggest this.

Entirely up to you, but I would still want to credit everyone who
contributed to a feature even if the underlying implementation has
changed since the original attempt.

> What I have in v2 is RCU based. I hope Oliver or someone else can help
> make that work.

Why? If there's data to show that RCU has a material benefit over taking
the MMU lock for read then I'm all for it. Otherwise, the work required
to support page-table walkers entirely outside of the MMU lock isn't
justified.

In addition to ensuring that page table teardown is always RCU-safe,
we'd need to make sure all of the walkers that take the write lock are
prepared to handle races.

> Otherwise we can just drop this for now and revisit
> later.

I really wouldn't get hung up on the locking as the make-or-break for
whether arm64 supports this MMU notifier.

-- 
Thanks,
Oliver

