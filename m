Return-Path: <kvm+bounces-16292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 750578B83B5
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 02:28:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A24501C221C5
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 00:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 364B5610D;
	Wed,  1 May 2024 00:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jt/Q3cVC"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31953D71
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 00:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714523307; cv=none; b=sFEQzMQTk/05zyv8jZ9INy4MBd3HHmduyZyXifdpNXCEQ4BIwXs8y7igwM7yUTqA3KPy9Wxc8LkK/8oXI4gP7l3KrYzPQ9Ugf00P5Y8mhkrFAG06JFZAwOC5DT6naOKRCkkxJc83QipHHrNv3TJLlqEQqps7q2Zlfw3+0ipz0KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714523307; c=relaxed/simple;
	bh=DpFUUK9f7pvRbaNn+oUsZkhipSX9ZbK/PMBvjjKew0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kQ5C6AQqiaOzN+XDqQu/FjePw4vriUzJnx5mz7fLpJXYELYdAOfb5UjECNzuulsESXgyswy4w/GbbrQgzkD1vuQIoedtpTiVO2D95P4pYvcOmoud6Fij0TKheslJhtvG6Q3UpPRa3Bua7fZednZiDt49Ng0OdO1+MbrHDCT9ehU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jt/Q3cVC; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 1 May 2024 00:28:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714523303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ioXgnZIoOxV6Gom6pZgkz9FqddFwrAkScDhYF7eexw0=;
	b=jt/Q3cVCB5txoE/zQITpY+KTWb0keYgIpc0qkzhVQFsJAZZR5RjRVVdyLf1AD37xVVVKy5
	AjuiDAvL2nLBEHIqEzLFqT7OazbzMr6NRwDmnhYgDnVnteqZKpKfa3eZfPYr7Wncyk+0Tk
	iJCFdMrcVNqaWoqklmPV1Wqci3CPJlw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: Fold kvm_arch_sched_in() into
 kvm_arch_vcpu_load()
Message-ID: <ZjGMn5tlq8edKZYv@linux.dev>
References: <20240430193157.419425-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430193157.419425-1-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 30, 2024 at 12:31:53PM -0700, Sean Christopherson wrote:
> Drop kvm_arch_sched_in() and instead pass a @sched_in boolean to
> kvm_arch_vcpu_load().
> 
> While fiddling with an idea for optimizing state management on AMD CPUs,
> I wanted to skip re-saving certain host state when a vCPU is scheduled back
> in, as the state (theoretically) shouldn't change for the task while it's
> scheduled out.  Actually doing that was annoying and unnecessarily brittle
> due to having a separate API for the kvm_sched_in() case (the state save
> needed to be in kvm_arch_vcpu_load() for the common path).
> 
> E.g. I could have set a "temporary"-ish flag somewhere in kvm_vcpu, but (a)
> that's gross and (b) it would rely on the arbitrary ordering between
> sched_in() and vcpu_load() staying the same.

Another option would be to change the rules around kvm_arch_sched_in()
where the callee is expected to load the vCPU context.

The default implementation could just call kvm_arch_vcpu_load() directly
and the x86 implementation can order things the way it wants before
kvm_arch_vcpu_load().

I say this because ...

> The only real downside I see is that arm64 and riscv end up having to pass
> "false" for their direct usage of kvm_arch_vcpu_load(), and passing boolean
> literals isn't ideal.  But that can be solved by adding an inner helper that
> omits the @sched_in param (I almost added a patch to do that, but I couldn't
> convince myself it was necessary).

Needing to pass @sched_in for other usage of kvm_arch_vcpu_load() hurts
readability, especially when no other architecture besides x86 cares
about it.

-- 
Thanks,
Oliver

