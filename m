Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B59818F8D9
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 16:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbgCWPmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 11:42:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:30555 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727389AbgCWPmS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 11:42:18 -0400
IronPort-SDR: NM4VjdK2iMCWrP2Fsi3492YkWv83ukvKmKYbb+peY/nOS/4BdY1i1L7f112k7S1c2Rm3blIDEZ
 Aby48UkdxAPg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 08:42:17 -0700
IronPort-SDR: +ids7V//oUP2Cg9ZK/lGG9GXZcBrYFVISXehY99PjtBSEXzqTBFsjQ0F/0+Ygpc5YdPQeMHIuM
 uc5K0RM/INug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,296,1580803200"; 
   d="scan'208";a="445854315"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 23 Mar 2020 08:42:16 -0700
Date:   Mon, 23 Mar 2020 08:42:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 03/14] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20200323154216.GG28711@linux.intel.com>
References: <20200318163720.93929-1-peterx@redhat.com>
 <20200318163720.93929-4-peterx@redhat.com>
 <20200321192211.GC13851@linux.intel.com>
 <20200323145824.GI127076@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323145824.GI127076@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 23, 2020 at 10:58:24AM -0400, Peter Xu wrote:
> On Sat, Mar 21, 2020 at 12:22:11PM -0700, Sean Christopherson wrote:
> > On Wed, Mar 18, 2020 at 12:37:09PM -0400, Peter Xu wrote:
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index e54c6ad628a8..a5123a0aa7d6 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -9786,7 +9786,34 @@ void kvm_arch_sync_events(struct kvm *kvm)
> > >  	kvm_free_pit(kvm);
> > >  }
> > >  
> > > -int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> > > +#define  ERR_PTR_USR(e)  ((void __user *)ERR_PTR(e))
> > > +
> > > +/**
> > > + * __x86_set_memory_region: Setup KVM internal memory slot
> > > + *
> > > + * @kvm: the kvm pointer to the VM.
> > > + * @id: the slot ID to setup.
> > > + * @gpa: the GPA to install the slot (unused when @size == 0).
> > > + * @size: the size of the slot. Set to zero to uninstall a slot.
> > > + *
> > > + * This function helps to setup a KVM internal memory slot.  Specify
> > > + * @size > 0 to install a new slot, while @size == 0 to uninstall a
> > > + * slot.  The return code can be one of the following:
> > > + *
> > > + *   HVA:           on success (uninstall will return a bogus HVA)
> > > + *   -errno:        on error
> > > + *
> > > + * The caller should always use IS_ERR() to check the return value
> > > + * before use.  NOTE: KVM internal memory slots are guaranteed and
> > 
> > "are guaranteed" to ...
> > 
> > > + * won't change until the VM is destroyed. This is also true to the
> > > + * returned HVA when installing a new memory slot.  The HVA can be
> > > + * invalidated by either an errornous userspace program or a VM under
> > > + * destruction, however as long as we use __copy_{to|from}_user()
> > > + * properly upon the HVAs and handle the failure paths always then
> > > + * we're safe.
> > 
> > Regarding the HVA, it's a bit confusing saying that it's guaranteed to be
> > valid, and then contradicting that in the second clause.  Maybe something
> > like this to explain the GPA->HVA is guaranteed to be valid, but the
> > HVA->HPA is not.
> >  
> > /*
> >  * before use.  Note, KVM internal memory slots are guaranteed to remain valid
> >  * and unchanged until the VM is destroyed, i.e. the GPA->HVA translation will
> >  * not change.  However, the HVA is a user address, i.e. its accessibility is
> >  * not guaranteed, and must be accessed via __copy_{to,from}_user().
> >  */
> 
> Sure I can switch to this, though note that I still think the GPA->HVA
> is not guaranteed logically because the userspace can unmap any HVA it
> wants..

You're conflating the GPA->HVA translation with the validity of the HVA,
i.e. the HVA->HPA and/or HVA->VMA translation/association.  GPA->HVA is
guaranteed because userspace doesn't have access to the memslot which
defines that transation.

> However I agree that shouldn't be important from kvm's perspective as long as
> we always emphasize on using legal HVA accessors.

The fact that GPA->HVA can't change _is_ important, otherwise KVM would
need to take steps to ensure that whatever can change GPA->HVA can't run
concurrently with consuming the HVA. 
