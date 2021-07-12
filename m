Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C133C5430
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 12:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347733AbhGLH5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 03:57:21 -0400
Received: from mga05.intel.com ([192.55.52.43]:50708 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240994AbhGLHzS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 03:55:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10042"; a="295581498"
X-IronPort-AV: E=Sophos;i="5.84,232,1620716400"; 
   d="scan'208";a="295581498"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 00:52:29 -0700
X-IronPort-AV: E=Sophos;i="5.84,232,1620716400"; 
   d="scan'208";a="491930905"
Received: from chenhan1-mobl2.ccr.corp.intel.com (HELO localhost) ([10.249.172.167])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 00:52:26 -0700
Date:   Mon, 12 Jul 2021 15:52:23 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "KVM: x86: WARN and reject loading KVM if NX is
 supported but not enabled"
Message-ID: <20210712075223.hqqoi4yp4fkkhrt5@linux.intel.com>
References: <20210625001853.318148-1-seanjc@google.com>
 <28ec9d07-756b-f546-dad1-0af751167838@redhat.com>
 <YOiFsB9vZgMcpJZu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOiFsB9vZgMcpJZu@google.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 09, 2021 at 05:21:52PM +0000, Sean Christopherson wrote:
> On Thu, Jul 08, 2021, Paolo Bonzini wrote:
> > On 25/06/21 02:18, Sean Christopherson wrote:
> > > Let KVM load if EFER.NX=0 even if NX is supported, the analysis and
> > > testing (or lack thereof) for the non-PAE host case was garbage.
> > > 
> > > If the kernel won't be using PAE paging, .Ldefault_entry in head_32.S
> > > skips over the entire EFER sequence.  Hopefully that can be changed in
> > > the future to allow KVM to require EFER.NX, but the motivation behind
> > > KVM's requirement isn't yet merged.  Reverting and revisiting the mess
> > > at a later date is by far the safest approach.
> > > 
> > > This reverts commit 8bbed95d2cb6e5de8a342d761a89b0a04faed7be.
> > > 
> > > Fixes: 8bbed95d2cb6 ("KVM: x86: WARN and reject loading KVM if NX is supported but not enabled")
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > > 
> > > Hopefully it's not too late to just drop the original patch...
> > > 
> > >   arch/x86/kvm/x86.c | 3 ---
> > >   1 file changed, 3 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 4a597aafe637..1cc02a3685d0 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -10981,9 +10981,6 @@ int kvm_arch_hardware_setup(void *opaque)
> > >   	int r;
> > >   	rdmsrl_safe(MSR_EFER, &host_efer);
> > > -	if (WARN_ON_ONCE(boot_cpu_has(X86_FEATURE_NX) &&
> > > -			 !(host_efer & EFER_NX)))
> > > -		return -EIO;
> > >   	if (boot_cpu_has(X86_FEATURE_XSAVES))
> > >   		rdmsrl(MSR_IA32_XSS, host_xss);
> > > 
> > 
> > So do we want this or "depends on X86_64 || X86_PAE"?
> 
> Hmm, I'm leaning towards keeping !PAE support purely for testing the !PAE<->PAE
> MMU transitions for nested virtualization.  It's not much coverage, and the !PAE

May I ask what "!PAE<->PAE MMU transition for nested virtualization" means?
Running L1 KVM with !PAE and L0 in PAE? I had thought KVM can only function
with PAE set(though I did not see any check of CR4 in kvm_arch_init()). Did
I miss something?

> NPT horror is a much bigger testing gap (because KVM doesn't support it), but on
> the other hand setting EFER.NX for !PAE kernels appears to be trivial, e.g.
> 
> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> index 67f590425d90..bfbea25a9fe8 100644
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -214,12 +214,6 @@ SYM_FUNC_START(startup_32_smp)
>         andl $~1,%edx                   # Ignore CPUID.FPU
>         jz .Lenable_paging              # No flags or only CPUID.FPU = no CR4
> 
> -       movl pa(mmu_cr4_features),%eax
> -       movl %eax,%cr4
> -
> -       testb $X86_CR4_PAE, %al         # check if PAE is enabled
> -       jz .Lenable_paging
> -
>         /* Check if extended functions are implemented */
>         movl $0x80000000, %eax
>         cpuid
> 
> My only hesitation is the risk of somehow breaking ancient CPUs by falling into
> the NX path.  Maybe try forcing EFER.NX=1 for !PAE, and fall back to requiring
> PAE if that gets NAK'd or needs to be reverted for whatever reason?
> 

One more dumb question: are you planning to set NX for linux with !PAE? Why do
we need EFER in that case? Thanks! :)


B.R.
Yu

