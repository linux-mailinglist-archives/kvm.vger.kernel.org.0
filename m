Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 118C8128015
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 16:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbfLTPxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 10:53:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:27731 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727359AbfLTPxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 10:53:31 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 07:53:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,336,1571727600"; 
   d="scan'208";a="222513815"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 20 Dec 2019 07:53:30 -0800
Date:   Fri, 20 Dec 2019 07:53:30 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kurz <groug@kaod.org>
Subject: Re: [PATCH v2 30/45] KVM: Move vcpu alloc and init invocation to
 common code
Message-ID: <20191220155330.GA21021@linux.intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-31-sean.j.christopherson@intel.com>
 <20191220103325.34fc2bf0.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220103325.34fc2bf0.cohuck@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 20, 2019 at 10:33:25AM +0100, Cornelia Huck wrote:
> On Wed, 18 Dec 2019 13:55:15 -0800
> Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > +int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >  {
> > -	struct kvm_vcpu *vcpu;
> >  	struct sie_page *sie_page;
> >  	int rc;
> >  
> > -	rc = -ENOMEM;
> > -
> > -	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
> > -	if (!vcpu)
> > -		goto out;
> > -
> > -	rc = kvm_vcpu_init(vcpu, kvm, id);
> > -	if (rc)
> > -		goto out_free_cpu;
> > -
> > -	rc = -ENOMEM;
> > -
> >  	BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
> >  	sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL);
> >  	if (!sie_page)
> > -		goto out_uninit_vcpu;
> > +		return -ENOMEM;
> >  
> >  	vcpu->arch.sie_block = &sie_page->sie_block;
> >  	vcpu->arch.sie_block->itdba = (unsigned long) &sie_page->itdb;
> > @@ -3087,15 +3070,11 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
> >  		 vcpu->arch.sie_block);
> >  	trace_kvm_s390_create_vcpu(id, vcpu, vcpu->arch.sie_block);
> >  
> > -	return vcpu;
> > +	return 0;
> > +
> >  out_free_sie_block:
> >  	free_page((unsigned long)(vcpu->arch.sie_block));
> > -out_uninit_vcpu:
> > -	kvm_vcpu_uninit(vcpu);
> > -out_free_cpu:
> > -	kmem_cache_free(kvm_vcpu_cache, vcpu);
> > -out:
> > -	return ERR_PTR(rc);
> > +	return rc;
> 
> This is getting a bit hard to follow across the patches, but I think rc
> is now only set for ucontrol guests. So this looks correct right now,
> but feels a bit brittle... should we maybe init rc to 0 and always
> return rc instead?

Yes, but only for a few patches until kvm_s390_vcpu_setup() is introduced,
at which point @rc is unconditionally set at the end.

        rc = kvm_s390_vcpu_setup(vcpu);
        if (rc)
                goto out_free_ucontrol_gmap;
        return 0;

My personal preference is to use "return 0;" when the return is known to
be zero as it makes the success path obvious at a glance.  I also didn't
want to intialize @rc at he beginning because then the sie_page allocation
would look a bit funky:

	int rc = 0;

        BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
        sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL);
        if (!sie_page)
                return -ENOMEM;


An alternative would be to init @rc to -ENOMEM:

        int rc = -ENOMEM;

        BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
        sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL);
        if (!sie_page)
                return rc;

This would be my preference if you'd prefer to init @rc right away,
especially if  __kvm_ucontrol_vcpu_init() is open coded here (discussion
in patch 35, "KVM: s390: Manually invoke vcpu setup during 
kvm_arch_vcpu_create()", e.g.:

        int rc = -ENOMEM;

        BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
        sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL);
        if (!sie_page)
                return rc;

	...

        if (kvm_is_ucontrol(vcpu->kvm)) {
                vcpu->arch.gmap = gmap_create(current->mm, -1UL);
                if (!vcpu->arch.gmap)
                        goto out_free_sie_block;
                vcpu->arch.gmap->private = vcpu->kvm;
        }

        VM_EVENT(kvm, 3, "create cpu %d at 0x%pK, sie block at 0x%pK", id, vcpu,
                 vcpu->arch.sie_block);
        trace_kvm_s390_create_vcpu(id, vcpu, vcpu->arch.sie_block);

        rc = kvm_s390_vcpu_setup(vcpu);
        if (rc)
                goto out_free_ucontrol_gmap;
        return 0;

out_free_ucontrol_gmap:
        if (kvm_is_ucontrol(vcpu->kvm))
                gmap_remove(vcpu->arch.gmap);
out_free_sie_block:
        free_page((unsigned long)(vcpu->arch.sie_block));
        return rc;
