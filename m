Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5467E138BF5
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 07:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbgAMGpy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 01:45:54 -0500
Received: from mga12.intel.com ([192.55.52.136]:4214 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725954AbgAMGpy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 01:45:54 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jan 2020 22:45:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,428,1571727600"; 
   d="scan'208";a="397069155"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga005.jf.intel.com with ESMTP; 12 Jan 2020 22:45:51 -0800
Date:   Mon, 13 Jan 2020 14:50:13 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com,
        alazar@bitdefender.com, edwin.zhai@intel.com
Subject: Re: [RESEND PATCH v10 06/10] vmx: spp: Set up SPP paging table at
 vmentry/vmexit
Message-ID: <20200113065012.GE12253@local-michael-cet-test.sh.intel.com>
References: <20200102061319.10077-1-weijiang.yang@intel.com>
 <20200102061319.10077-7-weijiang.yang@intel.com>
 <20200110175537.GF21485@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110175537.GF21485@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 10, 2020 at 09:55:37AM -0800, Sean Christopherson wrote:
> On Thu, Jan 02, 2020 at 02:13:15PM +0800, Yang Weijiang wrote:
> > If write to subpage is not allowed, EPT violation generates
> > and it's handled in fast_page_fault().
> > 
> > In current implementation, SPPT setup is only handled in handle_spp()
> > vmexit handler, it's triggered when SPP bit is set in EPT leaf
> > entry while SPPT entries are not ready.
> > 
> > A SPP specific bit(11) is added to exit_qualification and a new
> > exit reason(66) is introduced for SPP.
> 
> ...
> 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 6f92b40d798c..c41791ebee65 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -6372,6 +6427,8 @@ unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm)
> >  	return nr_mmu_pages;
> >  }
> >  
> > +#include "spp.c"
> > +
> 
> Unless there is a *very* good reason for these shenanigans, spp.c needs
> to built via the Makefile like any other source.  If this is justified
> for whatever reason, then that justification needs to be very clearly
> stated in the changelog.

Yes, it looks odd. When extracted the SPP code from mmu.c, I found a lot
of functions in mmu.c should be exposed so that spp.c can see them, I
took them as unnecessary modification to mmu.c, so just add the spp.c file back
to mmu.c, if you suggest change it with a seperate object file, I'll do it.

> 
> In general, the code organization of this entire series likely needs to
> be overhauled.  There are gobs exports which are either completely
> unnecessary or completely backswards.
> 
> E.g. exporting VMX-only functions from spp.c, which presumably are only
> callbed by VMX.
> 
> 	EXPORT_SYMBOL_GPL(vmx_spp_flush_sppt);
> 	EXPORT_SYMBOL_GPL(vmx_spp_init);
> 
> Exporting ioctl helpers from the same file, which are presumably called
> only from x86.c.
> 
> 	EXPORT_SYMBOL_GPL(kvm_vm_ioctl_get_subpages);
> 	EXPORT_SYMBOL_GPL(kvm_vm_ioctl_set_subpages);

Thanks for the suggestion, I'll go over the patches and or-organize them.
