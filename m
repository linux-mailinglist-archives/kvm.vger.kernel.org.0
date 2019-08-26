Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFDA9D3C0
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 18:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731521AbfHZQLd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 12:11:33 -0400
Received: from mga18.intel.com ([134.134.136.126]:26357 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729338AbfHZQLd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 12:11:33 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 09:11:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,433,1559545200"; 
   d="scan'208";a="185002631"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 26 Aug 2019 09:11:32 -0700
Date:   Mon, 26 Aug 2019 09:11:32 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     =?utf-8?B?SmnFmcOtIFBhbGXEjWVr?= <jpalecek@web.de>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] kvm: Nested KVM MMUs need PAE root too
Message-ID: <20190826161132.GD19381@linux.intel.com>
References: <87lfvl5f28.fsf@debian>
 <87lfvgm8a9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87lfvgm8a9.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 26, 2019 at 02:16:14PM +0200, Vitaly Kuznetsov wrote:
> Jiří Paleček <jpalecek@web.de> writes:
> > @@ -5646,7 +5647,19 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
> >  		vcpu->arch.guest_mmu.prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
> >
> >  	vcpu->arch.nested_mmu.translate_gpa = translate_nested_gpa;
> > -	return alloc_mmu_pages(vcpu);
> > +
> > +	ret = alloc_mmu_pages(vcpu, &vcpu->arch.guest_mmu);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = alloc_mmu_pages(vcpu, &vcpu->arch.root_mmu);
> > +	if (ret)
> > +		goto fail_allocate_root;
> 
> (personal preference) here you're just jumping over 'return' so I'd
> prefer this to be written as:
> 
>         ret = alloc_mmu_pages(vcpu, &vcpu->arch.root_mmu);
>         if (!ret)
>             return 0;
>  
>         free_mmu_pages(&vcpu->arch.guest_mmu);
>         return ret;
> 
> and no label/goto required.

Or alternatively:

	ret = alloc_mmu_pages(vcpu, &vcpu->arch.root_mmu);
	if (ret)
		free_mmu_pages(&vcpu->arch.guest_mmu);

	return ret;

since error handling is usually *not* the fall through path.

> > +
> > +	return ret;
> > + fail_allocate_root:
> > +	free_mmu_pages(&vcpu->arch.guest_mmu);
> > +	return ret;
> >  }
> >
> >  static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
> > @@ -6102,7 +6115,8 @@ unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm)
> >  void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
> >  {
> >  	kvm_mmu_unload(vcpu);
> > -	free_mmu_pages(vcpu);
> > +	free_mmu_pages(&vcpu->arch.root_mmu);
> > +	free_mmu_pages(&vcpu->arch.guest_mmu);
> >  	mmu_free_memory_caches(vcpu);
> >  }
> >
> > --
> > 2.23.0.rc1
> >
> 
> -- 
> Vitaly
