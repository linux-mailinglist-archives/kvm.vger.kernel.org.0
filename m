Return-Path: <kvm+bounces-30323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ED879B94FE
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 17:11:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 451201F20FA3
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 16:11:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D40021C9EB0;
	Fri,  1 Nov 2024 16:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t+7ZZb8Q"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2181C9B65
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 16:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730477506; cv=none; b=Hl/10hMEH21FbScu2PVWfRvskHMqhz9bbAoeoLU7bhWOd0Ay03RFZuJfVWeNtQ0r8IP45JQrLQKZWM4l6gCySqqMSQPqAI4i8rsPsc0+S38VzIOcF3kwUvCQ4HGPGXixvcpYfea6T/gyh5KQT+K20CHfgPIe4WF6i6W/Xf6cRU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730477506; c=relaxed/simple;
	bh=id8OVgJgAMs247VB55MtiU8AC4vmdW1ZedyeKlhQlFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TW5uR6NWnqc5jVBMahIoLbEMg/BExgOBjFBU0/N0kJsyiBOOVZaVwVGAaaRhp+jwEbA4FG0SH8eCuwoQKyf24EKK9oum8TSCTl9k5WOzrvM9JrUaPCgyj+EKUR6Ix1eSNiOiDcZ7x2i8gM/FezcRJ6rZmKwJ2oBWzbwvBNn1frc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t+7ZZb8Q; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 1 Nov 2024 09:11:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730477501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tyTpg0lhlDGimy0ZvEFKhDPpfFFUWK/X72leUPUldo0=;
	b=t+7ZZb8QkkiZMjWQXqf/2w9UWEZZ80XpBkF5UWSotFyMMCpQvxO+Ol6L1m097f5XvORbXi
	K4+CWGnk3tCVvjVR5h+fGMU59MESJ99/eJkLZYySXFlBVyIvx6MCcONQ29QfpCQsZtEPzB
	PjqX2uKrHQb2zbKSykrFjXm9JtGxBbA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	Andrew Jones <ajones@ventanamicro.com>,
	James Houghton <jthoughton@google.com>,
	David Woodhouse <dwmw@amazon.co.uk>, linux-next@vger.kernel.org
Subject: Re: [PATCH v3 03/14] KVM: selftests: Return a value from
 vcpu_get_reg() instead of using an out-param
Message-ID: <ZyT9rSnLcDWkWoL_@linux.dev>
References: <20241009154953.1073471-1-seanjc@google.com>
 <20241009154953.1073471-4-seanjc@google.com>
 <39ea24d8-9dae-447a-ae37-e65878c3806f@sirena.org.uk>
 <ZyTpwwm0s89iU9Pk@google.com>
 <ZyT2CB6zodtbWEI9@linux.dev>
 <ZyT61FF0-g8gKZfc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyT61FF0-g8gKZfc@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Nov 01, 2024 at 08:59:16AM -0700, Sean Christopherson wrote:
> > Can you instead just push out a topic branch and let the affected
> > maintainers deal with it? This is the usual way we handle conflicts
> > between trees...
> 
> That'd work too, but as you note below, doing that now throws a wrench in things
> because essentially all arch maintainers would need merge that topic branch,
> otherwise linux-next would end up in the same state.

TBH, I'm quite happy with that. Recent history has not been particularly
convinincing to me that folks are actually testing arm64, let alone
compiling for it when applying selftests patches.

Otherwise, the alternative of respinning the global change for every -next
breakage adds a decent amount of toil and gives the wrong impression of how
long our patches have actually been baking in -next.

> > > That would be a good oppurtunity to do the $(ARCH) directory switch[*] too, e.g.
> > > have a "selftests_late" or whatever topic branch.
> > 
> > The right time to do KVM-wide changes (even selftests) is *early* in the
> > development cycle, not last minute. It gives us plenty of time to iron out
> > the wrinkles.
> 
> Yeah, that was the original plan, then the stupid strict aliasing bug happened,
> and I honestly forgot the vcpu_get_reg() changes would need to be consumed by
> other architectures.
> 
> Other than letting me forget about this mess a few weeks earlier, there's no
> good reason to force this into 6.13.  So, I'll drop the series from 6.13, post
> new versions of the this and the $(ARCH) series just before the merge window,
> and then either send a pull request to Paolo for 6.14 as soon as the 6.13 merge
> window closes, or ask/bribe Paolo to apply everything directly.

Sounds good, punting to 6.14 seems reasonable.

-- 
Thanks,
Oliver

