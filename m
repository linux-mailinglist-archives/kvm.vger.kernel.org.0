Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28FB417034B
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 16:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbgBZP4m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 10:56:42 -0500
Received: from mga07.intel.com ([134.134.136.100]:36551 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728326AbgBZP4m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 10:56:42 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Feb 2020 07:56:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,488,1574150400"; 
   d="scan'208";a="317457075"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 26 Feb 2020 07:56:41 -0800
Date:   Wed, 26 Feb 2020 07:56:41 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 58/61] KVM: x86/mmu: Configure max page level during
 hardware setup
Message-ID: <20200226155641.GC9940@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-59-sean.j.christopherson@intel.com>
 <87blpmlobr.fsf@vitty.brq.redhat.com>
 <20200225210149.GH9245@linux.intel.com>
 <87k149jt38.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k149jt38.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 26, 2020 at 03:55:55PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > On Tue, Feb 25, 2020 at 03:43:36PM +0100, Vitaly Kuznetsov wrote:
> >> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> >> 
> >> > Configure the max page level during hardware setup to avoid a retpoline
> >> > in the page fault handler.  Drop ->get_lpage_level() as the page fault
> >> > handler was the last user.
> >> > @@ -6064,11 +6064,6 @@ static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
> >> >  	}
> >> >  }
> >> >  
> >> > -static int svm_get_lpage_level(void)
> >> > -{
> >> > -	return PT_PDPE_LEVEL;
> >> > -}
> >> 
> >> I've probably missed something but before the change, get_lpage_level()
> >> on AMD was always returning PT_PDPE_LEVEL, but after the change and when
> >> NPT is disabled, we set max_page_level to either PT_PDPE_LEVEL (when
> >> boot_cpu_has(X86_FEATURE_GBPAGES)) or PT_DIRECTORY_LEVEL
> >> (otherwise). This sounds like a change) unless we think that
> >> boot_cpu_has(X86_FEATURE_GBPAGES) is always true on AMD.
> >
> > It looks like a functional change, but isn't.  kvm_mmu_hugepage_adjust()
> > caps the page size used by KVM's MMU at the minimum of ->get_lpage_level()
> > and the host's mapping level.  Barring an egregious bug in the kernel MMU,
> > the host page tables will max out at PT_DIRECTORY_LEVEL (2mb) unless
> > boot_cpu_has(X86_FEATURE_GBPAGES) is true.
> >
> > In other words, this is effectively a "documentation" change.  I'll figure
> > out a way to explain this in the changelog...
> >
> >         max_level = min(max_level, kvm_x86_ops->get_lpage_level());
> >         for ( ; max_level > PT_PAGE_TABLE_LEVEL; max_level--) {
> >                 linfo = lpage_info_slot(gfn, slot, max_level);
> >                 if (!linfo->disallow_lpage)
> >                         break;
> >         }
> >
> >         if (max_level == PT_PAGE_TABLE_LEVEL)
> >                 return PT_PAGE_TABLE_LEVEL;
> >
> >         level = host_pfn_mapping_level(vcpu, gfn, pfn, slot);
> >         if (level == PT_PAGE_TABLE_LEVEL)
> >                 return level;
> >
> >         level = min(level, max_level); <---------
> 
> Ok, I see (I believe):
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> It would've helped me a bit if kvm_configure_mmu() was written the
> following way:
> 
> void kvm_configure_mmu(bool enable_tdp, int tdp_page_level)
> {
>         tdp_enabled = enable_tdp;
> 
> 	if (boot_cpu_has(X86_FEATURE_GBPAGES))
>                 max_page_level = PT_PDPE_LEVEL;
>         else
>                 max_page_level = PT_DIRECTORY_LEVEL;
> 
>         if (tdp_enabled)
> 		max_page_level = min(tdp_page_level, max_page_level);
> }
> 
> (we can't have cpu_has_vmx_ept_1g_page() and not
> boot_cpu_has(X86_FEATURE_GBPAGES), right?)

Wrong, because VMX.  It could even occur on a real system if the user
disables the feature via kernel param, e.g. "clearcpuid=58".  In the end it
won't actually change anything because KVM caps its page size at the kernel
page size (as above).  Well, unless someone is running a custom kernel that
does funky things.

> But this is certainly just a personal preference, feel free to ignore)

I'm on the fence.  Part of me likes having max_page_level reflect what KVM
is capable of, irrespective of the kernel.
