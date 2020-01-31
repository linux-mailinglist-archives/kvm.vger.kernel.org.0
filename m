Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 032DE14F26C
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 19:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgAaSxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 13:53:43 -0500
Received: from mga18.intel.com ([134.134.136.126]:30492 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgAaSxn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 13:53:43 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 10:53:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,386,1574150400"; 
   d="scan'208";a="324625965"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 31 Jan 2020 10:53:42 -0800
Date:   Fri, 31 Jan 2020 10:53:42 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@suse.de>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] First batch of KVM changes for 5.6 merge window
Message-ID: <20200131185341.GA18946@linux.intel.com>
References: <1580408442-23916-1-git-send-email-pbonzini@redhat.com>
 <CAHk-=wjZTUq8u0HZUJ1mKZjb-haBFhX+mKcUv3Kdh9LQb8rg4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjZTUq8u0HZUJ1mKZjb-haBFhX+mKcUv3Kdh9LQb8rg4g@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 31, 2020 at 10:01:37AM -0800, Linus Torvalds wrote:
> On Thu, Jan 30, 2020 at 10:20 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > Xiaoyao Li (3):
> >       KVM: VMX: Rename INTERRUPT_PENDING to INTERRUPT_WINDOW
> >       KVM: VMX: Rename NMI_PENDING to NMI_WINDOW
> >       KVM: VMX: Fix the spelling of CPU_BASED_USE_TSC_OFFSETTING
> 
> So in the meantime, on the x86 merge window side, we have this:
> 
>   b39033f504a7 ("KVM: VMX: Use VMX_FEATURE_* flags to define VMCS control bits")
> 
> and while the above results in a conflict, that's not a problem. The
> conflict was trivial to fix up.
> 
> HOWEVER.
> 
> It most definitely shows that the above renaming now means that the
> names don't match. It didn't match 100% before either, but now the
> differences are even bigger. The VMX_FEATURE_xyz bits have different
> names than the CPU_BASED_xyz bits, and that seems a bit questionable.
> 
> So I'm not convinced about the renaming. The spelling fix is good: it
> actually now more closely resembles the VMCS_FEATURE bit that already
> had OFFSETTING with two T's.
> 
> But even that one isn't really the same even then. The CPU_BASED_xyz
> thing has "USE_TSC_OFFSETTING", while the VMCS_FEATURE_xyz bit doesn't
> have the "USE" part.
> 
> And the actual renaming means that now we basically have
> 
>   CPU_BASED_INTR_WINDOW_EXITING
>   VMX_FEATURE_VIRTUAL_INTR_PENDING
> 
> and
> 
>   CPU_BASED_NMI_WINDOW_EXITING
>   VMX_FEATURE_VIRTUAL_NMI_PENDING
> 
> for the same bit definitions (yeah, the VMX_FEATURE bits obviously
> have the offset in them, so it's not the same _value_, but it's a 1:1
> relationship between them).
> 
> There are other (pre-existing) differences, but while fixing up the
> merge conflict I really got the feeling that it's confusing and wrong
> to basically use different naming for these things when they are about
> the same bit.
> 
> I don't care much which way it goes (maybe the VMX_FATURE_xyz bits
> should be renamed instead of the other way around?) and I wonder what
> the official documentation names are? Is there some standard here or
> are people just picking names at random?
> 
> The two commits both came from intel.com addresses, so hopefully there
> can be some intel-sanctioned resolution on the naming? Please?

Hrm.

For *_WINDOW_EXITING versus VIRTUAL_*_PENDING, VMX_FEATURE_* should be
renamed to use *_WINDOW_EXITING, as that's the nomenclature used by the
SDM.  I added the VMX_FEATURE_* names while KVM was still using
VIRTUAL_*_PENDING, and neglected to go back and update the series, probably
because I was in denial after lobbying to keep the non-SDM names[1] and
getting overruled[2] :-).

As for USE_TSC_OFFSETTING vs TSC_OFFSETTING, I'd like to keep the minor
differences.  VMX_FEATURES is intended to reflect the capabilities of the
CPU, whereas the CPU_BASED/EXEC masks are effectively "commands" from
software to hardware, e.g. "CPU has TSC offsetting" vs. "CPU, use TSC
offsetting".

Re-reading vmxfeatures.h, I botched a few names:

  USE_IO_BITMAPS and USE_MSR_BITMAPS shouldn't have the USE_ prefix, by my
  own capability vs. command argument.

  PAGE_MOD_LOGGING should simply be PML.  I have no idea why I chose to
  (partially) expand the acronym.

I assume the easiest thing would be send a cleanup patch for vmxfeatures.h
and route it through the KVM tree?

[1] https://lkml.kernel.org/r/20191206204747.GD5433@linux.intel.com/
[2] https://lkml.kernel.org/r/2beeb1fb-7d3a-d829-38e0-ddf76b65bd3c@redhat.com/
