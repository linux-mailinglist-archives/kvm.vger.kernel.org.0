Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECF881054C1
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 15:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfKUOne (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 09:43:34 -0500
Received: from mga05.intel.com ([192.55.52.43]:62558 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfKUOne (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 09:43:34 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Nov 2019 06:43:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,226,1571727600"; 
   d="scan'208";a="209923902"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga003.jf.intel.com with ESMTP; 21 Nov 2019 06:43:31 -0800
Date:   Thu, 21 Nov 2019 22:45:28 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com, yu.c.zhang@linux.intel.com,
        alazar@bitdefender.com, edwin.zhai@intel.com
Subject: Re: [PATCH v7 4/9] mmu: spp: Add functions to create/destroy SPP
 bitmap block
Message-ID: <20191121144528.GB17169@local-michael-cet-test>
References: <20191119084949.15471-1-weijiang.yang@intel.com>
 <20191119084949.15471-5-weijiang.yang@intel.com>
 <8ad27209-cc28-0503-da0e-bead63b28a83@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ad27209-cc28-0503-da0e-bead63b28a83@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 21, 2019 at 11:43:10AM +0100, Paolo Bonzini wrote:
> On 19/11/19 09:49, Yang Weijiang wrote:
> >  
> > +/*
> > + * all vcpus share the same SPPT, vcpu->arch.mmu->sppt_root points to same
> > + * SPPT root page, so any vcpu will do.
> > + */
> > +static struct kvm_vcpu *kvm_spp_get_vcpu(struct kvm *kvm)
> > +{
> > +	struct kvm_vcpu *vcpu = NULL;
> > +	int idx;
> 
> Is this true?  Perhaps you need one with
> VALID_PAGE(vcpu->arch.mmu->sppt_root) for kvm_spp_set_permission?
>
Yes, I'd like to keep single sppt_root, thank you!

> Also, since vcpu->arch.mmu->sppt_root is the same for all vCPUs, perhaps
> it should be kvm->arch.sppt_root instead?
>
Sure, make sense, will change it.

> If you can get rid of this function, it would be much better (but if you
> cannot, kvm_get_vcpu(kvm, 0) should give the same result).
>
Great, I was not sure if such usage is correct. Thanks.

> > 
> > +	if (npages > SUBPAGE_MAX_BITMAP)
> > +		return -EFAULT;
> 
> This is not needed here, the restriction only applies to the ioctl.
>
OK.
> Paolo

