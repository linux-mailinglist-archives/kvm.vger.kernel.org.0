Return-Path: <kvm+bounces-46931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D78ACABA899
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 09:02:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 756EF4A6B6C
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 07:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 964BE1C54A2;
	Sat, 17 May 2025 07:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T3gCiwps"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1EA23CB;
	Sat, 17 May 2025 07:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747465316; cv=none; b=DzaaFlE5OFgMcAH/dayUpTV70lKz1bg5q+DONCBD5idCBJrq3ItumWP31mmLhEWmMMCdq9L4XmYqBBPXnyqLhhwVPTgemlPkhQR5abe3MR6mHYLrIsMClMlIurKvNxXsK/aopnmfoBWI73p/hk47hTT2fqhiEgu/p3Qu82d6wKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747465316; c=relaxed/simple;
	bh=0TGH3Z2yqnXd+NhMwwLuh0QscC/jqHB7HMFZA3nImdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SrPLefkoCyDctU6AYF+VYB3/HAlOUkp7StyvfE+a2FcIKxzZ51Spup+XYZ6FRV15dY6san1Jlj8ac3mkXO72CdLkph1nVMpKyyDVr7HS8wRiJ5W8NCpIL5tLozjIlm1uOTnzgJXIv5Lx9ZhX8QqH6rU2SQNrj/cNICDpxOLE1Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T3gCiwps; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47667C4CEE3;
	Sat, 17 May 2025 07:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747465316;
	bh=0TGH3Z2yqnXd+NhMwwLuh0QscC/jqHB7HMFZA3nImdI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T3gCiwps+bvCo+e2c9WBsfA/DZdpcVi0pSLY4U1iOcbEjzWma91+nmTJfCQUuMiSI
	 cDmEpnVUfXy+AFICgsKGty6tXCR2VfIMEjJQYfa9MuYlf+qEJlnOXPc31Q5RPzDkRT
	 qco3VLd+egOpUy7gqCIR4iZgTdDtRjEPlUmNSHcfENC6t2n0QaxzudjXqcDhy/BnJ6
	 dVufvXuNto/E+fDHK/yiguqhQgiULiKstVBsDTVd9EPeCWd9vpNuyu/HDV1ddF0BVE
	 xDTwD7ZZsIQv0D0b6WK1kkqmdskguE4Z50oiawIrjOL6IlzhvX9ViktANk6RuXt8QK
	 7UAR9rHg9I7tQ==
Date: Sat, 17 May 2025 09:01:49 +0200
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
Message-ID: <aCg0Xc9fEB2Qn5Th@gmail.com>
References: <20250516212833.2544737-1-seanjc@google.com>
 <20250516212833.2544737-8-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250516212833.2544737-8-seanjc@google.com>


* Sean Christopherson <seanjc@google.com> wrote:

> From: Zheyun Shen <szy0127@sjtu.edu.cn>
> 
> Extract KVM's open-coded calls to do writeback caches on multiple CPUs to
> common library helpers for both WBINVD and WBNOINVD (KVM will use both).
> Put the onus on the caller to check for a non-empty mask to simplify the
> SMP=n implementation, e.g. so that it doesn't need to check that the one
> and only CPU in the system is present in the mask.
> 
> Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Link: https://lore.kernel.org/r/20250128015345.7929-2-szy0127@sjtu.edu.cn
> [sean: move to lib, add SMP=n helpers, clarify usage]
> Acked-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/smp.h | 12 ++++++++++++
>  arch/x86/kvm/x86.c         |  8 +-------
>  arch/x86/lib/cache-smp.c   | 12 ++++++++++++
>  3 files changed, 25 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> index e08f1ae25401..fe98e021f7f8 100644
> --- a/arch/x86/include/asm/smp.h
> +++ b/arch/x86/include/asm/smp.h
> @@ -113,7 +113,9 @@ void native_play_dead(void);
>  void play_dead_common(void);
>  void wbinvd_on_cpu(int cpu);
>  void wbinvd_on_all_cpus(void);
> +void wbinvd_on_many_cpus(struct cpumask *cpus);
>  void wbnoinvd_on_all_cpus(void);
> +void wbnoinvd_on_many_cpus(struct cpumask *cpus);

Let's go with the _on_cpumask() suffix:

    void wbinvd_on_cpu(int cpu);
   +void wbinvd_on_cpumask(struct cpumask *cpus);
    void wbinvd_on_all_cpus(void);

And the wb*invd_all_cpus() methods should probably be inlined wrappers 
with -1 as the cpumask, or so - not two separate functions?

In fact it would be nice to have the DRM preparatory patch and all the 
x86 patches at the beginning of the next version of the series, so 
those 4 patches can be applied to the x86 tree. Can make it a separate 
permanent branch based on v6.15-rc6/rc7.

Thanks,

	Ingo

