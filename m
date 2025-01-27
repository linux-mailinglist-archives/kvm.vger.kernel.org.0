Return-Path: <kvm+bounces-36677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FEB4A1DBFD
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 19:22:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE8671631B4
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 18:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB10D18DF6B;
	Mon, 27 Jan 2025 18:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZOSJmfm0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9751F60A;
	Mon, 27 Jan 2025 18:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738002153; cv=none; b=cT2hzJ3mJxEGocDarfdQRaPH+ZUXLeutbUnwFJMtPuGSM7uuIqXpI6uZqV+zlVgeBLKxLmVQTuPz7P3vzzHHFpHFKUfe7EsrL7eXu0yB2LpnspxB8fDwn2sTbLBIsncJ+6izS2jgEPurnfG7SehDjM5UFb/lMrdHD3gLdx0D2zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738002153; c=relaxed/simple;
	bh=MtrQDhOIOeUcceKCselZCQ2zKyEeShB/948ZM2dIgd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cL555jpC+VpNC8XkbWq8AtdMmPVWCM568gwJ2oajL4VhSnkKzIieZDbmEm+ibDq/s4hhy39y8G6IwY8rOJdETrkAqp+hArVilEhnvPGSyrvdTNY6eGdNNneRG/Fnfq2ZI0da9+IYG3PX/wHFmIDkCnsO8y+A2xzyfentVklh2b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZOSJmfm0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5CEC4CED2;
	Mon, 27 Jan 2025 18:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738002152;
	bh=MtrQDhOIOeUcceKCselZCQ2zKyEeShB/948ZM2dIgd0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZOSJmfm0oFYmTDvRGEakNnOfafYHqsQCJcZYxYLVZybiLMEqV5W3131SqVzHok8Us
	 IB2M6qGz6ljsbKlVuexVifzDiv0ec0IQDWQDtV/8eWa2uXjyu8BVaE9ysT0kNxJUuJ
	 1OBRBRRNJ+6un+JmDKblvX3QKrClvQ00H2wzbtowzOfSs7T72FytJc34sv88E9Ut4F
	 yK7rpzcAjsLRGmMVEdjCUT4igo+5pi680oLPGegpKZ9R8F+umXM046F+8g7Z5HrBel
	 T9ye07gFLUEmBNk/7uT7vRsXCV3XkESb+Bsa3T0KoA1WEWssAFiKDJdn9tSdORIvbr
	 2zUN8yEjtJjPQ==
Date: Mon, 27 Jan 2025 11:22:29 -0700
From: Keith Busch <kbusch@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Ensure NX huge page recovery thread is
 alive before waking
Message-ID: <Z5fO5bac8ohqUH1D@kbusch-mbp>
References: <20250124234623.3609069-1-seanjc@google.com>
 <Z5RkcB_wf5Y74BUM@kbusch-mbp>
 <Z5e4w7IlEEk2cpH-@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5e4w7IlEEk2cpH-@google.com>

On Mon, Jan 27, 2025 at 08:48:03AM -0800, Sean Christopherson wrote:
> > > -		vhost_task_start(kvm->arch.nx_huge_page_recovery_thread);
> > > +	if (!nx_thread)
> > > +		return;
> > > +
> > > +	vhost_task_start(nx_thread);
> > > +
> > > +	/* Make the task visible only once it is fully started. */
> > > +	WRITE_ONCE(kvm->arch.nx_huge_page_recovery_thread, nx_thread);
> > 
> > I believe the WRITE_ONCE needs to happen before the vhost_task_start to
> > ensure the parameter update callback can see it before it's started.
> 
> It's not clear to me that calling vhost_task_wake() before vhost_task_start() is
> allowed, which is why I deliberately waited until the task was started to make it
> visible.  Though FWIW, doing "vhost_task_wake(nx_thread)" before vhost_task_start()
> doesn't explode.

Hm, it does look questionable to try to wake a process that hadn't been
started yet, but I think it may be okay: task state will be TASK_NEW
before vhost_task_start(), which looks like will cause wake_up_process()
to do nothing.

