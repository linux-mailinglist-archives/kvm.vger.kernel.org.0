Return-Path: <kvm+bounces-15376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 439048AB736
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 00:24:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE610282341
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 22:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA46713D2AF;
	Fri, 19 Apr 2024 22:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="P8isnNkf"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CFE139583
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 22:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713565435; cv=none; b=JIzP6yBXFwpsqDLReQmvppMKmzOqtNIdCbvI+/RT5AMhejqFEHpbIsFgD9QgQtfB6tcvA7LRuisxi3FeBdxQ5Q/sDGx6Tjfesw0diKzsgzGQWRAg0z8X7IvDrKQZtzLBYYth4pxi/4DLVn8GEMr/uCycved1CF6fC9FXXbzB7nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713565435; c=relaxed/simple;
	bh=VD6QFxX1Xd3DNVIOsaev//o7h4mZlv5eWXjCnxaWhik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RIWnAhOqAqQuFeJLiddMhB5jRGHDhk4MICws/69LPiYiIV7slrK4WhAhIj+RWftB9YCupS2rgpOnzGrqvKW3FSCa/RPjuZYF0ZQb0tw6izdDlVj0DHNsVE8c0a3yeKGPUkeWnQdM63x7iPO+pKF7cJV+ijyCqTyAjKq9bSk9OK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=P8isnNkf; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 19 Apr 2024 22:23:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713565432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mthBWOOhcNSWoMZhMTAfzR7XGep2Qks53Rpg12wvEhs=;
	b=P8isnNkfBYXWB0pGZ4e76KozKbuIPo6rHG7Ox+d9b31tlskAlwzX5Fiy922x3848sQHdds
	2boqaE4bF1mMbPeod2X267+67KV2A02qKBDa6v3fbd7lZbgPblznjJvZe8hzyomSxDd6nH
	88u9gjkSLzKAR6O3WgIDpbW6x4ZMNao=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Houghton <jthoughton@google.com>
Cc: David Matlack <dmatlack@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Yu Zhao <yuzhao@google.com>,
	Marc Zyngier <maz@kernel.org>,
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
Subject: Re: [PATCH v3 0/7] mm/kvm: Improve parallelism for access bit
 harvesting
Message-ID: <ZiLu72SZ3tl_Cdvm@linux.dev>
References: <20240401232946.1837665-1-jthoughton@google.com>
 <ZhmAR1akBHjvZ9_4@google.com>
 <CADrL8HW+4Yq-wBr1+DzJvSwRRL_hqt5RaCCLgOQndPGUqoX+Rg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADrL8HW+4Yq-wBr1+DzJvSwRRL_hqt5RaCCLgOQndPGUqoX+Rg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 19, 2024 at 01:57:03PM -0700, James Houghton wrote:
> On Fri, Apr 12, 2024 at 11:41 AM David Matlack <dmatlack@google.com> wrote:
> >
> > On 2024-04-01 11:29 PM, James Houghton wrote:
> > > This patchset adds a fast path in KVM to test and clear access bits on
> > > sptes without taking the mmu_lock. It also adds support for using a
> > > bitmap to (1) test the access bits for many sptes in a single call to
> > > mmu_notifier_test_young, and to (2) clear the access bits for many ptes
> > > in a single call to mmu_notifier_clear_young.
> >
> > How much improvement would we get if we _just_ made test/clear_young
> > lockless on x86 and hold the read-lock on arm64? And then how much
> > benefit does the bitmap look-around add on top of that?

Thanks David for providing the suggestion.

> I don't have these results right now. For the next version I will (1)
> separate the series into the locking change and the bitmap change, and
> I will (2) have performance data for each change separately. It is
> conceivable that the bitmap change should just be considered as a
> completely separate patchset.

That'd be great. Having the performance numbers will make it even more
compelling, but I'd be tempted to go for the lock improvement just
because it doesn't add any new complexity and leverages existing patterns
in the architectures that people seem to want improvements for.

The bitmap interface, OTOH, is rather complex. At least the current
implementation breaks some of the isolation we have between the MMU code
and the page table walker library on arm64, which I'm not ecstatic about.
It _could_ be justified by a massive performance uplift over locking, but
it'd have to be a sizable win.

-- 
Thanks,
Oliver

