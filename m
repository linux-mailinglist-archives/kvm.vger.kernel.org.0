Return-Path: <kvm+bounces-57120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C7001B50459
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 19:20:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8B1427AFC16
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 17:19:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FB803570C5;
	Tue,  9 Sep 2025 17:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rWNA+SZ7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574132D3A98;
	Tue,  9 Sep 2025 17:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757438436; cv=none; b=G8EVKlvJg4HpscHN4F2hMTK+p3EjEaJQ7dtLUnHNhkwHBA0ErwgjsO+CHRGv83rEEJoJbjtO0z4bQi9//NgP4uWgF0mI/CJQfA/0IsMNxazwm395BktFcx6cWraTOBQpaptnE+R6g5MQE4EjXRDZfeGMlCxbQ1/9ScjDEO9PpyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757438436; c=relaxed/simple;
	bh=aDtO0EP2Luwblw7wXBa/S0nm/bbd84Amf4RIFEa0YMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rOu7s5EO5pcY6yvB5luIoFuWha6+GE6iNzpLOnCFaM1pMlZHDc4SqD0SzbX/J5KaUIqB8uHa9JZUwiwzhJFIGFFQnpY95iUxwb1/RTKw4DyZ6IxZ5R0jbA6RD+xnTMaCg0+VWKJPpn0e2WFjeFVg62xhivLqT1lh+XFVPjhYc1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rWNA+SZ7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B305C4CEF4;
	Tue,  9 Sep 2025 17:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757438435;
	bh=aDtO0EP2Luwblw7wXBa/S0nm/bbd84Amf4RIFEa0YMU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rWNA+SZ7P7XMqvonOPAEdmtY55rXaIKEEzU9HK+ppzMNafCHRqDvkVmEoUduHt/rT
	 aa5OZZx3ilY519/VHWj4+vwbhsuG88pY0+u24AUMR9OeOT4pFbgJb7ecQe/x2pWO4E
	 vcn4jx2aGZ2e8t05J44ouMyfLu5WoVzT4hxN53UWANQ6M/G517uScWAOMTyKqRmi5V
	 diqflVnydGhyAkUdxMQ6Bnquv1D4Xk2wLalfluyanQAMUeNCL713BGUmRtcdXk2oSb
	 +eCWCY1ISYJlrL6GLeiTkLfqGaoEYVf8wOe7r+TdNoqrDDp/wKG1ImILx8nFyAfEJN
	 RYEyJmVbovIiA==
Date: Tue, 9 Sep 2025 17:20:34 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Wei Liu <wei.liu@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Dexuan Cui <decui@microsoft.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-hyperv@vger.kernel.org, rcu@vger.kernel.org,
	Nuno Das Neves <nunodasneves@linux.microsoft.com>,
	Mukesh R <mrathor@linux.microsoft.com>
Subject: Re: [PATCH v2 0/7] Drivers: hv: Fix NEED_RESCHED_LAZY and use common
 APIs
Message-ID: <aMBh4kPNOEUKvxpV@liuwe-devbox-ubuntu-v2.lamzopl0uupeniq2etz1fddiyg.xx.internal.cloudapp.net>
References: <20250828000156.23389-1-seanjc@google.com>
 <aLojpyTwAMdb1z6D@liuwe-devbox-ubuntu-v2.lamzopl0uupeniq2etz1fddiyg.xx.internal.cloudapp.net>
 <aLp3makY6FzuUwor@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLp3makY6FzuUwor@google.com>

On Thu, Sep 04, 2025 at 10:39:37PM -0700, Sean Christopherson wrote:
> On Thu, Sep 04, 2025, Wei Liu wrote:
> > On Wed, Aug 27, 2025 at 05:01:49PM -0700, Sean Christopherson wrote:
> > > Fix a bug where MSHV root partitions (and upper-level VTL code) don't honor
> > > NEED_RESCHED_LAZY, and then deduplicate the TIF related MSHV code by turning
> > > the "kvm" entry APIs into more generic "virt" APIs.
> > > 
> > > This version is based on
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/hyperv/linux.git hyperv-next
> > > 
> > > in order to pickup the VTL changes that are queued for 6.18.  I also
> > > squashed the NEED_RESCHED_LAZY fixes for root and VTL modes into a single
> > > patch, as it should be easy/straightforward to drop the VTL change as needed
> > > if we want this in 6.17 or earlier.
> > > 
> > > That effectively means the full series is dependent on the VTL changes being
> > > fully merged for 6.18.  But I think that's ok as it's really only the MSHV
> > > changes that have any urgency whatsoever, and I assume that Microsoft is
> > > the only user that truly cares about the MSHV root fix.  I.e. if the whole
> > > thing gets delayed, I think it's only the Hyper-V folks that are impacted.
> > > 
> > > I have no preference what tree this goes through, or when, and can respin
> > > and/or split as needed.
> > > 
> > > As with v1, the Hyper-V stuff and non-x86 architectures are compile-tested
> > > only.
> > > 
> > > v2:
> > >  - Rebase on hyperv-next.
> > >  - Fix and converge the VTL code as well. [Peter, Nuno]
> > > 
> > > v1: https://lore.kernel.org/all/20250825200622.3759571-1-seanjc@google.com
> > > 
> > 
> > I dropped the mshv_vtl changes in this series and applied the rest
> > (including the KVM changes) to hyperv-next.
> 
> mshv_do_pre_guest_mode_work() ended up getting left behind since its removal was
> in the last mshv_vtl patch.
> 
>   $ git grep mshv_do_pre_guest_mode_work
>   drivers/hv/mshv.h:int mshv_do_pre_guest_mode_work(ulong th_flags);
>   drivers/hv/mshv_common.c:int mshv_do_pre_guest_mode_work(ulong th_flags)
>   drivers/hv/mshv_common.c:EXPORT_SYMBOL_GPL(mshv_do_pre_guest_mode_work);
> 
> Want to squash this into 3786d7d6b3c0 ("mshv: Use common "entry virt" APIs to do
> work in root before running guest")?
> 

It's done. Thanks for pointing it out.

Wei

