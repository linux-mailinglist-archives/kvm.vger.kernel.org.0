Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82FF83C68FA
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 05:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbhGMECl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 00:02:41 -0400
Received: from mga03.intel.com ([134.134.136.65]:22541 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229436AbhGMECk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 00:02:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10043"; a="210135314"
X-IronPort-AV: E=Sophos;i="5.84,235,1620716400"; 
   d="scan'208";a="210135314"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 20:59:50 -0700
X-IronPort-AV: E=Sophos;i="5.84,235,1620716400"; 
   d="scan'208";a="492552884"
Received: from jianye-mobl1.ccr.corp.intel.com (HELO localhost) ([10.249.169.175])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 20:59:46 -0700
Date:   Tue, 13 Jul 2021 11:59:44 +0800
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
Message-ID: <20210713035944.l7qa7q4qsmqywg6u@linux.intel.com>
References: <20210625001853.318148-1-seanjc@google.com>
 <28ec9d07-756b-f546-dad1-0af751167838@redhat.com>
 <YOiFsB9vZgMcpJZu@google.com>
 <20210712075223.hqqoi4yp4fkkhrt5@linux.intel.com>
 <YOxThZrKeyONVe4i@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOxThZrKeyONVe4i@google.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 12, 2021 at 02:36:53PM +0000, Sean Christopherson wrote:
> On Mon, Jul 12, 2021, Yu Zhang wrote:
> > On Fri, Jul 09, 2021 at 05:21:52PM +0000, Sean Christopherson wrote:
> > > On Thu, Jul 08, 2021, Paolo Bonzini wrote:
> > > > So do we want this or "depends on X86_64 || X86_PAE"?
> > > 
> > > Hmm, I'm leaning towards keeping !PAE support purely for testing the !PAE<->PAE
> > > MMU transitions for nested virtualization.  It's not much coverage, and the !PAE
> > 
> > May I ask what "!PAE<->PAE MMU transition for nested virtualization" means?
> > Running L1 KVM with !PAE and L0 in PAE? I had thought KVM can only function
> > with PAE set(though I did not see any check of CR4 in kvm_arch_init()). Did
> > I miss something?
> 
> When L1 uses shadow paging, L0 KVM's uses a single MMU instance for both L1 and
> L2, and relies on the MMU role to differentiate between L1 and L2.  KVM requires
> PAE for shadow paging, but does not require PAE in the host kernel.  So when L1
> KVM uses shadow paging, it can effectively use !PAE paging for L1 and PAE paging
> for L2.  L0 KVM needs to handle that the !PAE<->PAE transitions when switching
> between L1 and L2, e.g. needs to correctly reinitialize the MMU context.

Hah... Actually, I do have a misunderstanding here. The host does not need to be
PAE. Thanks for the explanation! :)

> 
> > > NPT horror is a much bigger testing gap (because KVM doesn't support it), but on
> > > the other hand setting EFER.NX for !PAE kernels appears to be trivial, e.g.
> > > 
> > > diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> > > index 67f590425d90..bfbea25a9fe8 100644
> > > --- a/arch/x86/kernel/head_32.S
> > > +++ b/arch/x86/kernel/head_32.S
> > > @@ -214,12 +214,6 @@ SYM_FUNC_START(startup_32_smp)
> > >         andl $~1,%edx                   # Ignore CPUID.FPU
> > >         jz .Lenable_paging              # No flags or only CPUID.FPU = no CR4
> > > 
> > > -       movl pa(mmu_cr4_features),%eax
> > > -       movl %eax,%cr4
> > > -
> > > -       testb $X86_CR4_PAE, %al         # check if PAE is enabled
> > > -       jz .Lenable_paging
> > > -
> > >         /* Check if extended functions are implemented */
> > >         movl $0x80000000, %eax
> > >         cpuid
> > > 
> > > My only hesitation is the risk of somehow breaking ancient CPUs by falling into
> > > the NX path.  Maybe try forcing EFER.NX=1 for !PAE, and fall back to requiring
> > > PAE if that gets NAK'd or needs to be reverted for whatever reason?
> > > 
> > 
> > One more dumb question: are you planning to set NX for linux with !PAE?
> 
> Yep.
> 
> > Why do we need EFER in that case? Thanks! :)
> 
> Because as you rightly remembered above, KVM always uses PAE paging for the guest,
> even when the host is !PAE.  And KVM also requires EFER.NX=1 for the guest when
> using shadow paging to handle a potential SMEP and !WP case.  
> 

Just saw this in update_transition_efer(), which now enables efer.nx in shadow
unconditionally. But I guess the host kernel still needs to set efer.nx for
!PAE(e.g. in head_32.S), because the guest may not touch efer at all. Is this
correct?

B.R.
Yu
