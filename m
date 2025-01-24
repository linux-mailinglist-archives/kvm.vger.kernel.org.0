Return-Path: <kvm+bounces-36558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A6C7A1BAEB
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 17:48:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C7033A2658
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 16:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF2C31AA783;
	Fri, 24 Jan 2025 16:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GiY/iFs1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F2F15958A;
	Fri, 24 Jan 2025 16:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737737312; cv=none; b=fwmL0VDfgz73W7KmjwaaOhEm58FXaaK2tlObU5BPkLvpIcgh4qSFgGuhJZCirA4NBZDBAlEDlHI/2pzx6kI3VuhT2Ee3lVqltrEZEA0vEMfIc14gSOHOgEJDUHR4dIw/2JtE7GLjQO8nCIfmlB5W/06Qt6WvAX4o4CjUt13sN6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737737312; c=relaxed/simple;
	bh=JqhAUVCT9yffRD0QNfjQ2WBcg6i1mRcN22fnGVOPIss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eWILBXoDEb+QfDyFVeMFYF0PwF+cNv7Z03qzpgdQsXKOHGEZhN4WbguEaQ86P3bt9KReiPqDqIpFCHA9G7gHXaJI7sd3cQ1eusBSKB2hwKPUg9aMuzTQZxqGL5LOjp42gSR8O6XNRLX5PdeJpZLhzeInP6CYyuLD60Y8i+L/mcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GiY/iFs1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB872C4CED2;
	Fri, 24 Jan 2025 16:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737737311;
	bh=JqhAUVCT9yffRD0QNfjQ2WBcg6i1mRcN22fnGVOPIss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GiY/iFs1XLgo3avmg4kuIVnnd3LY3tudiA4mJvpn5RD2hWRvAxsGhKXXxjdRetQzS
	 gYihvkqcYXbBwato3fRNgLxRaIJf2Z1hmKWJlY+fB2BsQK8QaQswPyA1bG4ln5GRZ6
	 H5qBOl1OQ/KNTGwLee8kNZ57GgfojqvOEhb0tzWSHlQKoNbmGe4gt3r1hkNR8UTIyJ
	 orU+rVX4gS03yPz0UFbMs15PsSwPZpk4Ar91kxChZr9u4wahNfLfTc+q3ZJiFYpJto
	 D7mNoKhIVjYqxB40AfO15RsYYSC+A1dlZsqDIGTz5FH53CS15YKDPOvT5yuwNshFnq
	 6YKFrm/bBeeig==
Date: Fri, 24 Jan 2025 09:48:28 -0700
From: Keith Busch <kbusch@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, Vlad Poenaru <thevlad@meta.com>,
	tj@kernel.org, Sean Christopherson <seanjc@google.com>,
	Alyssa Ross <hi@alyssa.is>
Subject: Re: [PATCH] kvm: defer huge page recovery vhost task to later
Message-ID: <Z5PEXEB9ufzvPMlu@kbusch-mbp>
References: <20250123153543.2769928-1-kbusch@meta.com>
 <20250124152802.93279-2-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250124152802.93279-2-pbonzini@redhat.com>

On Fri, Jan 24, 2025 at 10:28:03AM -0500, Paolo Bonzini wrote:
> > Defer the task to after the first VM_RUN call, which occurs after the
> > parent process has forked all its jailed processes. This needs to happen
> > only once for the kvm instance, so this patch introduces infrastructure
> > to do that (Suggested-by Paolo).
> 
> Queued for 6.13; in the end I moved the new data structure to include/linux,
> since it is generally usable and not limited to KVM.

Thanks! I see that you also added the "Fixes" tag that I forgot to
append in the most recent version, so thank you for that.
 
> >  int kvm_arch_post_init_vm(struct kvm *kvm)
> >  {
> > -	return kvm_mmu_post_init_vm(kvm);
> > +	once_init(&kvm->arch.nx_once);
> > +	return 0;
> >  }
> 
> This could have been in kvm_arch_init_vm(), but then the last user of
> kvm_arch_post_init_vm() goes away and more cleanup is in order.  I'll
> post the obvious patch shortly.

Yes, that makes sense. I had a similiar cleanup in the first version
too.

