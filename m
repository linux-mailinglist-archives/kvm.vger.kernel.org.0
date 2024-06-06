Return-Path: <kvm+bounces-18981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 306E08FDB1F
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 02:03:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C392C283EAF
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 00:03:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EAE72FB2;
	Thu,  6 Jun 2024 00:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oaL+ViSx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7061361;
	Thu,  6 Jun 2024 00:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717632188; cv=none; b=eCPaGW1ZYR65Wz5MJcf9TcBKSbE8ENLQRXBYnr8sYBLKIymBYkf4P0bNNaqHsNtTmek/gjjDCegOQ/1Iwmspp7q5VkFEH3lpdSeeF/oIG+hh1j3dOrk5DOez/g+d1/IPWiKxthSlFt3+/PUaSImQ6YtZhFKciM24R03hYmED5lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717632188; c=relaxed/simple;
	bh=pEb77qEh1YQhDCWDnmGRFn7J+aICZOK+0n9H7O4r2S8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZI0G30ZDt7yMysuWbfe333rybv75ZizPJpCxe1kuRQhLv8LRnjFYmenRG0T527fQDPCHT226tMGVeLBTAROs29Qzys5/3RiEU42wweqhz6pDgCEZ4eyNan6/snfd+ktwkjW9eThPFz10SfmoZk7LL0dT6WxqoUX1dD+gFr/6RJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oaL+ViSx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF706C2BD11;
	Thu,  6 Jun 2024 00:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717632187;
	bh=pEb77qEh1YQhDCWDnmGRFn7J+aICZOK+0n9H7O4r2S8=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=oaL+ViSxcZMZHcfEmvKuOODkduYaZSUGxdnGDKsc8YzN0J30aTv9PjLGVOtfSI1w4
	 hkzGtcAYfxuoj3rb/dK4OJC6xG+bA6tWeiIBtkYARpwxQcrqyneHH9aEPFZAuv3GHF
	 q/dazwJe/ftPfYxLvShiM0FK0ezNLIZDgScJT62B7NXpivT+J9CASJKx0YN1dlJWoA
	 vciYklsYXYzTQJtVkBDjvcb0y3j908VMBgGGigxUDE10hEXL6f+gzv5kBadvjzMIkA
	 rApQ18Ur9VFqrd+B7k7FTCS8p9gFZP9iCyqCUCEKxHoezrJnBWhRTASs/0SzUs35Vw
	 FRM3FNwv+4izg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 7462FCE0A72; Wed,  5 Jun 2024 17:03:07 -0700 (PDT)
Date: Wed, 5 Jun 2024 17:03:07 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Josh Triplett <josh@joshtriplett.org>, kvm@vger.kernel.org,
	rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kevin Tian <kevin.tian@intel.com>, Yan Zhao <yan.y.zhao@intel.com>,
	Yiwei Zhang <zzyiwei@google.com>
Subject: Re: [PATCH 0/5] KVM: VMX: Drop MTRR virtualization, honor guest PAT
Message-ID: <3b56ffd4-cbb4-4e17-89a7-1be537962dec@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20240309010929.1403984-1-seanjc@google.com>
 <171762600665.2901886.14234246510506582276.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171762600665.2901886.14234246510506582276.b4-ty@google.com>

On Wed, Jun 05, 2024 at 04:20:34PM -0700, Sean Christopherson wrote:
> On Fri, 08 Mar 2024 17:09:24 -0800, Sean Christopherson wrote:
> > First, rip out KVM's support for virtualizing guest MTRRs on VMX.  The
> > code is costly to main, a drag on guest boot performance, imperfect, and
> > not required for functional correctness with modern guest kernels.  Many
> > details in patch 1's changelog.
> > 
> > With MTRR virtualization gone, always honor guest PAT on Intel CPUs that
> > support self-snoop, as such CPUs are guaranteed to maintain coherency
> > even if the guest is aliasing memtypes, e.g. if the host is using WB but
> > the guest is using WC.  Honoring guest PAT is desirable for use cases
> > where the guest must use WC when accessing memory that is DMA'd from a
> > non-coherent device that does NOT bounce through VFIO, e.g. for mediated
> > virtual GPUs.
> > 
> > [...]
> 
> Applied to kvm-x86 mtrrs, to get as much testing as possible before a potential
> merge in 6.11.
> 
> Paul, if you can take a gander at patch 3, it would be much appreciated.
> 
> Thanks!
> 
> [1/5] KVM: x86: Remove VMX support for virtualizing guest MTRR memtypes
>       https://github.com/kvm-x86/linux/commit/0a7b73559b39
> [2/5] KVM: VMX: Drop support for forcing UC memory when guest CR0.CD=1
>       https://github.com/kvm-x86/linux/commit/e1548088ff54
> [3/5] srcu: Add an API for a memory barrier after SRCU read lock
>       https://github.com/kvm-x86/linux/commit/fcfe671e0879

Looks straightforward enough.  We could combine this with the existing
smp_mb__after_srcu_read_unlock(), but if we did that, someone would no
doubt come up with some clever optimization that provided a full barrier
in srcu_read_lock() but not in srcu_read_unlock() or vice versa.  So:

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

> [4/5] KVM: x86: Ensure a full memory barrier is emitted in the VM-Exit path
>       https://github.com/kvm-x86/linux/commit/eb8d8fc29286
> [5/5] KVM: VMX: Always honor guest PAT on CPUs that support self-snoop
>       https://github.com/kvm-x86/linux/commit/95200f24b862
> 
> --
> https://github.com/kvm-x86/linux/tree/next

