Return-Path: <kvm+bounces-47095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 30DCFABD3A8
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 11:42:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33D341B64C36
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 09:42:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6F2B268C42;
	Tue, 20 May 2025 09:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YocNn9Ui"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB1021ABB2;
	Tue, 20 May 2025 09:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747734148; cv=none; b=SJ3aB/CGcADAD8Br4uv52ly7JAgLd2gOkmDfr1AWcda61upJKda0uI3QGnWu6RhoKkI/kY8S/cw1Lg20UIaym/WlxFmxHEnaCVFLxtE8vVeS6qTCUBiFIRgFuSnqsiNJFRrCjCLVDRaOkJkfcz8UK2/r231KAPa18nWUKsaXX6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747734148; c=relaxed/simple;
	bh=P2lXjR5FEwM/E5SDxoI52GRNlN0blP98CFC+wmmNYJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mAjGXposTwTuwyNxLEMNnU8LqAbo1dcQsqw6iuCcPAVAyoteUNyU1WiYqah7EQ6bTCcgSgZoo3wCqV5aQpOiY591gOG/8AuAMjX3Sl3xDMMye2/4V7w9qIpTwrQpn69W7pCIUySMWGGAmQFXwFGY9hgMeChxPhuI7tMjZTyKc8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YocNn9Ui; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E427AC4CEE9;
	Tue, 20 May 2025 09:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747734147;
	bh=P2lXjR5FEwM/E5SDxoI52GRNlN0blP98CFC+wmmNYJE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YocNn9UiAuJhZnt6NBpkhkjIHqg4sjhhumWmN9LAPV5VjzZqPtfuDBox2I783H7Cc
	 VqZh/z5vTj5uOmlYTVojQS3ezLzQcKcJTgAUtlXKLTn7CGKPqoUjd6rVHUb4sMrfUv
	 chgHpeh6iEjJuGmZ+Ftd2hTpsplWI40BqnLOFYMiQg5dCPT6ASNlFFxqtXFGw2Hroz
	 EPksLfrM9kUSfvilGCylSeQjD+ckre9RQguW6C0uYKYyF8CJHyUSNVC6wfFb5fEV3C
	 Kcl/+gwqNOL0i0I2xAlJ01noW9P7ESOPGLuQin1R+3cYx1xywa+0BPsDMf7D093Hb6
	 Mm402XHl0mhWg==
Date: Tue, 20 May 2025 11:42:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org, Zheyun Shen <szy0127@sjtu.edu.cn>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Kevin Loughlin <kevinloughlin@google.com>,
	Kai Huang <kai.huang@intel.com>, Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v2 7/8] x86, lib: Add wbinvd and wbnoinvd helpers to
 target multiple CPUs
Message-ID: <aCxOfFSSkHYm-rYS@gmail.com>
References: <20250516212833.2544737-1-seanjc@google.com>
 <20250516212833.2544737-8-seanjc@google.com>
 <aCg0Xc9fEB2Qn5Th@gmail.com>
 <aCtdnqqvIbHr-ed5@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCtdnqqvIbHr-ed5@google.com>


* Sean Christopherson <seanjc@google.com> wrote:

> On Sat, May 17, 2025, Ingo Molnar wrote:
> > 
> > * Sean Christopherson <seanjc@google.com> wrote:
> > 
> > > From: Zheyun Shen <szy0127@sjtu.edu.cn>
> > > 
> > > Extract KVM's open-coded calls to do writeback caches on multiple CPUs to
> > > common library helpers for both WBINVD and WBNOINVD (KVM will use both).
> > > Put the onus on the caller to check for a non-empty mask to simplify the
> > > SMP=n implementation, e.g. so that it doesn't need to check that the one
> > > and only CPU in the system is present in the mask.
> > > 
> > > Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
> > > Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> > > Link: https://lore.kernel.org/r/20250128015345.7929-2-szy0127@sjtu.edu.cn
> > > [sean: move to lib, add SMP=n helpers, clarify usage]
> > > Acked-by: Kai Huang <kai.huang@intel.com>
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/include/asm/smp.h | 12 ++++++++++++
> > >  arch/x86/kvm/x86.c         |  8 +-------
> > >  arch/x86/lib/cache-smp.c   | 12 ++++++++++++
> > >  3 files changed, 25 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> > > index e08f1ae25401..fe98e021f7f8 100644
> > > --- a/arch/x86/include/asm/smp.h
> > > +++ b/arch/x86/include/asm/smp.h
> > > @@ -113,7 +113,9 @@ void native_play_dead(void);
> > >  void play_dead_common(void);
> > >  void wbinvd_on_cpu(int cpu);
> > >  void wbinvd_on_all_cpus(void);
> > > +void wbinvd_on_many_cpus(struct cpumask *cpus);
> > >  void wbnoinvd_on_all_cpus(void);
> > > +void wbnoinvd_on_many_cpus(struct cpumask *cpus);
> > 
> > Let's go with the _on_cpumask() suffix:
> > 
> >     void wbinvd_on_cpu(int cpu);
> >    +void wbinvd_on_cpumask(struct cpumask *cpus);
> >     void wbinvd_on_all_cpus(void);
> 
> How about wbinvd_on_cpus_mask(), to make it more obvious that it operates on
> multiple CPUs?  At a glance, wbinvd_on_cpumask() could be mistaken for a masked
> version of wbinvd_on_cpu().

Works for me!

Thanks,

	Ingo

