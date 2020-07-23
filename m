Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6B622A5D7
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 05:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387735AbgGWDJZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 23:09:25 -0400
Received: from mga17.intel.com ([192.55.52.151]:30525 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733174AbgGWDJZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 23:09:25 -0400
IronPort-SDR: N0Nx5XEwCgD3Har9bFWnSQzoQ7YfZzw4o/boJIehiX2ISM9r/+9WaWkexwAWHA6bEEsdUuKust
 t2s32ZaJV1uA==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="130530024"
X-IronPort-AV: E=Sophos;i="5.75,385,1589266800"; 
   d="scan'208";a="130530024"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 20:09:24 -0700
IronPort-SDR: j8q+kBYfG2WY13W/VoXp9gmaUbgwG4o3eCTc8iqA4iJnIb0J4L9Jk5VARQBEC8MCXE5YVOL4mt
 pBWU25YbCOrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,385,1589266800"; 
   d="scan'208";a="328414111"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.128])
  by orsmga007.jf.intel.com with ESMTP; 22 Jul 2020 20:09:22 -0700
Date:   Thu, 23 Jul 2020 11:17:49 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com
Subject: Re: [RESEND PATCH v13 00/11] Introduce support for guest CET feature
Message-ID: <20200723031749.GA31129@local-michael-cet-test.sh.intel.com>
References: <20200716031627.11492-1-weijiang.yang@intel.com>
 <20200722194805.GB9114@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722194805.GB9114@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 22, 2020 at 12:48:05PM -0700, Sean Christopherson wrote:
> On Thu, Jul 16, 2020 at 11:16:16AM +0800, Yang Weijiang wrote:
> > Control-flow Enforcement Technology (CET) provides protection against
> > Return/Jump-Oriented Programming (ROP/JOP) attack. There're two CET
> > sub-features: Shadow Stack (SHSTK) and Indirect Branch Tracking (IBT).
> > SHSTK is to prevent ROP programming and IBT is to prevent JOP programming.
> > 
> > Several parts in KVM have been updated to provide VM CET support, including:
> > CPUID/XSAVES config, MSR pass-through, user space MSR access interface, 
> > vmentry/vmexit config, nested VM etc. These patches have dependency on CET
> > kernel patches for xsaves support and CET definitions, e.g., MSR and related
> > feature flags.
> > 
> > CET kernel patches are here:
> > https://lkml.kernel.org/r/20200429220732.31602-1-yu-cheng.yu@intel.com
> > 
> > v13:
> > - Added CET definitions as a separate patch to facilitate KVM test.
> 
> What I actually want to do is pull in actual kernel patches themselves so
> that we can upstream KVM support without having to wait for the kernel to
> sort out the ABI, which seems like it's going to drag on.
That's an innovative idea and beyond my imagination, great!:-)
> 
> I was thinking that we'd only need the MSR/CR4/CPUID definitions, but forgot
> that KVM also needs XSAVES context switching, so it's not as simple as I was
> thinking.  It's still relatively simple, but it means there would be
> functional changes in the kernel.
> 
> I'll respond to the main SSP series to pose the question of taking the two
> small-ish kernel patches through the KVM tree.
> 
> >  arch/x86/include/asm/kvm_host.h      |   4 +-
> >  arch/x86/include/asm/vmx.h           |   8 +
> >  arch/x86/include/uapi/asm/kvm.h      |   1 +
> >  arch/x86/include/uapi/asm/kvm_para.h |   7 +-
> >  arch/x86/kvm/cpuid.c                 |  28 ++-
> >  arch/x86/kvm/vmx/capabilities.h      |   5 +
> >  arch/x86/kvm/vmx/nested.c            |  34 ++++
> >  arch/x86/kvm/vmx/vmcs12.c            | 267 ++++++++++++++++-----------
> >  arch/x86/kvm/vmx/vmcs12.h            |  14 +-
> >  arch/x86/kvm/vmx/vmx.c               | 262 +++++++++++++++++++++++++-
> >  arch/x86/kvm/x86.c                   |  53 +++++-
> >  arch/x86/kvm/x86.h                   |   2 +-
> >  include/linux/kvm_host.h             |  32 ++++
> >  13 files changed, 590 insertions(+), 127 deletions(-)
> 
> I have quite a few comments/changes (will respond to individual patches),
> but have done all the updates/rework and, assuming I haven't broken things,
> we're nearing the point where I can carry this and push it past the finish
> line, e.g. get acks from tip/x86 maintainers for the kernel patches and
> send a pull request to Paolo.
> 
> I pushed the result to:
> 
>   https://github.com/sean-jc/linux/releases/tag/kvm-cet-v14-rc1
> 
> can you please review and test?  If everything looks good, I'll post v14.
> If not, I'll work offline with you to get it into shape.
>
Thanks a lot for the efforts! I'll review and test the new patches and
let you know the status.

> Thanks!
