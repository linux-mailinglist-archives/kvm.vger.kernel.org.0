Return-Path: <kvm+bounces-20190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B9969116F7
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 01:42:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E5721C20E8F
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 23:42:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A800214E2E4;
	Thu, 20 Jun 2024 23:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kY6xJHMY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD4F43ABC;
	Thu, 20 Jun 2024 23:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718926922; cv=none; b=nPnhpXPbk6RBV90qAjVe6fcd8UAE/9JvlN8G0oC8OScQLaB2QlZF5VW9LfipadVcJhd5uBFOSrMBUDev80L91YfNCDyztVXPpM1xNS9n5QtqzVmu3o9DsxJhk1j1JljdRey44Ps8uvnO+Z6Tcl1mG+xdo6B/dtSeFzEZwa5cl9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718926922; c=relaxed/simple;
	bh=tKagk+Ry0Xq7y1gXPupJbJ8JJufaVprFCQxwG+QH9Do=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K5vHU6EB19qRj5d6Gcv6Qk5IUQT/mGO87VQQXQ59qOm3Mb6m16/4nLxMbP0LhK8UeS6i3PGAzuiQWz+dNww16MNimipjV3bbVdo1Z8PLeNKEWoIhv8/aJAIpNyez0Nc/spB1aJ1VvuBAq4UYLMdZzY1mSrUellL8Xae1Sxl19mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kY6xJHMY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9EBC2BD10;
	Thu, 20 Jun 2024 23:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718926922;
	bh=tKagk+Ry0Xq7y1gXPupJbJ8JJufaVprFCQxwG+QH9Do=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=kY6xJHMYYjrm7A43Jv1pB3VNhB8nuGh9pa3ZQ2aZO/YfsbfHNuXNsBa2K/w0qGZ0M
	 oTKSG4sefxW08qbFrgSCI1qH4fTG2N6b8UFE1GYYEvSxGM2BERZuU7CdE/xNoI4Boz
	 C6IWhvV3etDXLDINWbwoxfM5OxLZyE7ePmLa3Budko+LfUIoLpVk0q0OGSqEOmg0rD
	 WdekJt0+yFokykcMA6qhhDBXvLEeozDzVuQdiFkolRoDx7XUYvfLTc09rlKDw1EI/T
	 PbhlN4ElUTaDGLyTEG2nj5kTb9qDHWfFqU0cvzd/nKtpDl74PhiWd36iVD2UuEy4Gh
	 X2akEb2Gw9Wmw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id CECCDCE0973; Thu, 20 Jun 2024 16:42:01 -0700 (PDT)
Date: Thu, 20 Jun 2024 16:42:01 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Josh Triplett <josh@joshtriplett.org>, kvm@vger.kernel.org,
	rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kevin Tian <kevin.tian@intel.com>, Yan Zhao <yan.y.zhao@intel.com>,
	Yiwei Zhang <zzyiwei@google.com>
Subject: Re: [PATCH 4/5] KVM: x86: Ensure a full memory barrier is emitted in
 the VM-Exit path
Message-ID: <b6d6e576-92dd-4708-93d1-372559b39818@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20240309010929.1403984-1-seanjc@google.com>
 <20240309010929.1403984-5-seanjc@google.com>
 <45dade46-c45f-47f0-bfae-ae526d02651a@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45dade46-c45f-47f0-bfae-ae526d02651a@redhat.com>

On Fri, Jun 21, 2024 at 12:38:21AM +0200, Paolo Bonzini wrote:
> On 3/9/24 02:09, Sean Christopherson wrote:
> > From: Yan Zhao <yan.y.zhao@intel.com>
> > 
> > Ensure a full memory barrier is emitted in the VM-Exit path, as a full
> > barrier is required on Intel CPUs to evict WC buffers.  This will allow
> > unconditionally honoring guest PAT on Intel CPUs that support self-snoop.
> > 
> > As srcu_read_lock() is always called in the VM-Exit path and it internally
> > has a smp_mb(), call smp_mb__after_srcu_read_lock() to avoid adding a
> > second fence and make sure smp_mb() is called without dependency on
> > implementation details of srcu_read_lock().
> 
> Do you really need mfence or is a locked operation enough?  mfence is mb(),
> not smp_mb().

We only need smp_mb(), which is supplied by the srcu_read_lock()
function.  For now, anyway.  If we ever figure out how to get by with
lighter-weight ordering for srcu_read_lock(), then we will add an smp_mb()
to smp_mb__after_srcu_read_lock() to compensate.

							Thanx, Paul

> Paolo
> 
> > +	/*
> > +	 * Call this to ensure WC buffers in guest are evicted after each VM
> > +	 * Exit, so that the evicted WC writes can be snooped across all cpus
> > +	 */
> > +	smp_mb__after_srcu_read_lock();
> 

