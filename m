Return-Path: <kvm+bounces-43121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DF29A85029
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 01:36:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB7414C59A4
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 23:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C18A8214A7B;
	Thu, 10 Apr 2025 23:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YDpnIkLx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8118120C49F
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 23:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744328162; cv=none; b=W5PcptkSrk6CD5SM6nnAGmF8ATzyYIY36At0P7QyFoIukqN3s2DSQsT5xkiYyzMCPC7YMNCExgio39FBs3t0kdhxCDG5cJy5fPoI6wRBKFjQlACp+YJHzok0I8dqfaaxwk245CeRw198vS/4OFfhXLYLN8Tj7UupPejLnbIAXG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744328162; c=relaxed/simple;
	bh=Y0+u2Tdl4n16u1UbrXG08Ik6njjpHJmW+GK3844aEmk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Bao6UawgvLNoOuEVv4bYptbhEtkEeGttzK73VfGLF8SvtfrinYUhxqeUP+m2gtWXAGJTstMOt+BZqgd8hR0jBrlC7pFM3Dk6G1m1JVI0TYdOpLCGrnYo2eI9sGFwFK82hEArvUp6RiWiCm+Z7+vhHWadOzrcGrFIhtHX5U9vxZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YDpnIkLx; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff5296726fso1918615a91.0
        for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 16:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744328160; x=1744932960; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3JXGgQRibMr/qR/hwv4m93TTQ8uk3j62jaLFAdC4/4k=;
        b=YDpnIkLxdNIC6IB3txJSk2edPVPWeahw90aKIzY/PaSGcCbf3OsvUAlPfrrrX85LxW
         8s37sQJIefIixseMAHotptzjUd5MbIvbga784fUXilbwpztSceMhgUrYSmVXlQS4T63b
         EP/L3+Gn4FM5R+SC6lAQROKtfgHC3QtMklFcHBYs/ayEErsGUCcF4Ed14alrd+I7ZWsE
         oJIQhtt7FEUajpV8CKLBc46h6xYUwJv9kaAAwiBep5mWZJVj1bBHepA63d0QDwISAxGF
         EIu0R9vYg6KzZZHnXQ7esOPscp+o9M5MImAfJGqQlR+EhAvgRANrZOe1c+ZkBFqciUba
         DUhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744328160; x=1744932960;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3JXGgQRibMr/qR/hwv4m93TTQ8uk3j62jaLFAdC4/4k=;
        b=AxrW+/mVNOeKYENKSOMWIbItc27ibnPj29ezm95ihnKYDFH+k5D5usTtvISD7mWutc
         Mkdp1zBGi3gQ+4E/eYogAh2hS51vJ/88/wiEnJFSXI5CrM/LBmeGC64svcHlryhseuys
         kH7N/FQDL1cyed4Vurp7ZZ27Mo5gK/g6eZCFwB/fB49uOftcA5F8If4k2b8Txqv4VPZQ
         h7vctg0BvT+y+piCsPlNR3wk5eujOz5kbifo0BQt9AEBNtwVPyH89h5SDYb1tWRe6d9L
         3IkYrlse9/eST/xsGUr1vdyNNoEQXoYvCwgsC7muQrTRjlrJsctZ5Yjf/rdte5bjYRZZ
         p6FQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDrPQ0RMXJP8WDgVdHpNste0DmNOx5CMJEx+b1aDZsskuPcrpy/EfVnPuDKi1aqic0QMA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwMuIUFF9ngVCSp5Nw1/FbZuGUeM/YjvGuI2QfO9aAXV737fFT
	hgXexbvtPrAKldrMIFYp+GcHjO5aWmNLNOYoNWdgmOa+aE5R3Q0yqb38y8jbvLukCXoXKRB2htR
	Bgw==
X-Google-Smtp-Source: AGHT+IFhCoMDskUyqvuwtmIcUjCarpAt7yZHb1V7xOBAbWZPbw6AP9KRnGSHyLKvsbRNWNF5SFAEXyQxmDU=
X-Received: from pjbqn13.prod.google.com ([2002:a17:90b:3d4d:b0:2ff:5752:a78f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:524f:b0:2ee:d024:e4fc
 with SMTP id 98e67ed59e1d1-3082367f7b5mr1300011a91.33.1744328159844; Thu, 10
 Apr 2025 16:35:59 -0700 (PDT)
Date: Thu, 10 Apr 2025 16:35:58 -0700
In-Reply-To: <20250410221345.ewyagu7coscpr3l7@desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250410-mmio-rename-v1-1-fd4b2e7fc04e@linux.intel.com>
 <Z_gsgHzgGWqnNwKv@google.com> <20250410221345.ewyagu7coscpr3l7@desk>
Message-ID: <Z_hV3pbpM2Y2qq6k@google.com>
Subject: Re: [PATCH] x86/bugs/mmio: Rename mmio_stale_data_clear to cpu_buf_vm_clear
From: Sean Christopherson <seanjc@google.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 10, 2025, Pawan Gupta wrote:
> On Thu, Apr 10, 2025 at 01:39:28PM -0700, Sean Christopherson wrote:
> > On Thu, Apr 10, 2025, Pawan Gupta wrote:
> > > The static key mmio_stale_data_clear controls the KVM-only mitigation for
> > > MMIO Stale Data vulnerability. Rename it to reflect its purpose.
> > > 
> > > No functional change.
> > > 
> > > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > > ---
> > >  arch/x86/include/asm/nospec-branch.h |  2 +-
> > >  arch/x86/kernel/cpu/bugs.c           | 16 ++++++++++------
> > >  arch/x86/kvm/vmx/vmx.c               |  2 +-
> > >  3 files changed, 12 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> > > index 8a5cc8e70439e10aab4eeb5b0f5e116cf635b43d..c0474e2b741737dad129159adf3b5fc056b6097c 100644
> > > --- a/arch/x86/include/asm/nospec-branch.h
> > > +++ b/arch/x86/include/asm/nospec-branch.h
> > > @@ -561,7 +561,7 @@ DECLARE_STATIC_KEY_FALSE(mds_idle_clear);
> > >  
> > >  DECLARE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
> > >  
> > > -DECLARE_STATIC_KEY_FALSE(mmio_stale_data_clear);
> > > +DECLARE_STATIC_KEY_FALSE(cpu_buf_vm_clear);
> > 
> > Could we tack on "if_mmio" or something?  E.g. cpu_buf_vm_clear_if_mmio.  FWIW,
> > I don't love that name, so if anyone can come up with something better...
> 
> Keeping it generic has an advantage that it plays nicely with "Attack vector
> controls" series:
> 
>   https://lore.kernel.org/lkml/20250310164023.779191-1-david.kaplan@amd.com/
> 
> The idea being to allow mitigations to be enabled/disabled based on
> user-defined threat model. MDS/TAA mitigations may be able to take
> advantage this KVM-only control.
> 
> > I like the idea of tying the static key back to X86_FEATURE_CLEAR_CPU_BUF, but
> > when looking at just the usage in KVM, "cpu_buf_vm_clear" doesn't provide any
> > hints as to when/why KVM needs to clear buffers.
> 
> Thats fair, can we cover that with a comment like below:
> 
> ---
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c79720aad3df..cddad4a6eb46 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7358,6 +7358,10 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>  	 * mitigation for MDS is done late in VMentry and is still
>  	 * executed in spite of L1D Flush. This is because an extra VERW
>  	 * should not matter much after the big hammer L1D Flush.
> +	 *
> +	 * cpu_buf_vm_clear is used when system is not vulnerable to MDS/TAA,
> +	 * but is affected by MMIO Stale Data that only needs mitigation
> +	 * against a rogue guest.

Would this be accurate?

	 * Clear CPU buffers if the vCPU has access to host MMIO, and the CPU
	 * is NOT vulnerable to MSD/TAA but is affected by MMIO Stale Data, as
	 * indicated by cpu_buf_vm_clear.  If the CPU is vulnerable to MDS/TAA,
	 * CPU buffers will be cleared just before every VM-Entry.

>  	 */
>  	if (static_branch_unlikely(&vmx_l1d_should_flush))
>  		vmx_l1d_flush(vcpu);

