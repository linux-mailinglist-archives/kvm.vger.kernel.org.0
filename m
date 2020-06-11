Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A331F6B4A
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 17:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbgFKPoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 11:44:00 -0400
Received: from mga03.intel.com ([134.134.136.65]:40538 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728496AbgFKPn7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 11:43:59 -0400
IronPort-SDR: zVbYBjCm+9L7CvMejLIsQdTToMqnSAR/RHJ4NnfDXDmHKrJaHs392+3+drFf0F4Cv2P1+NSZnB
 los2p04MIFKQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 08:43:59 -0700
IronPort-SDR: +Ydw/4Fg05XSUVeVdaVnYwXl169Eie8ePVgfFpQAiQZ2NUmXKZaRvV2IeZsKgMR2pcPAaKpDpn
 +n8lSwG3SLOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,499,1583222400"; 
   d="scan'208";a="419144435"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga004.jf.intel.com with ESMTP; 11 Jun 2020 08:43:59 -0700
Date:   Thu, 11 Jun 2020 08:43:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 17/21] KVM: arm64: Use common code's approach for
 __GFP_ZERO with memory caches
Message-ID: <20200611154359.GF29918@linux.intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-18-sean.j.christopherson@intel.com>
 <6cc08074c289cbea7b9c1deeaf18c63f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cc08074c289cbea7b9c1deeaf18c63f@kernel.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 11, 2020 at 08:59:05AM +0100, Marc Zyngier wrote:
> >diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> >index 9398b66f8a87..688213ef34f0 100644
> >--- a/arch/arm64/kvm/mmu.c
> >+++ b/arch/arm64/kvm/mmu.c
> >@@ -131,7 +131,8 @@ static int mmu_topup_memory_cache(struct
> >kvm_mmu_memory_cache *cache, int min)
> > 	if (cache->nobjs >= min)
> > 		return 0;
> > 	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
> >-		page = (void *)__get_free_page(GFP_PGTABLE_USER);
> >+		page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT |
> 
> This is definitely a change in the way we account for guest
> page tables allocation, although I find it bizarre that not
> all architectures account for it the same way.

It's not intended to be a functional change, i.e. the allocations should
still be accounted:

  #define GFP_PGTABLE_USER  (GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
  |
  -> #define GFP_PGTABLE_KERNEL        (GFP_KERNEL | __GFP_ZERO)

  == GFP_KERNEL | __GFP_ACCOUNT | __GFP_ZERO

versus 

  #define GFP_KERNEL_ACCOUNT (GFP_KERNEL | __GFP_ACCOUNT)

    with __GFP_ZERO explicitly OR'd in

  == GFP_KERNEL | __GFP_ACCOUNT | __GFP_ZERO

I can put the above in the changelog, unless of course it's wrong and I've
missed something.

> It seems logical to me that nested page tables would be accounted
> against userspace, but I'm willing to be educated on the matter.
> 
> Another possibility is that depending on the context, some allocations
> should be accounted on either the kernel or userspace (NV on arm64
> could definitely do something like that). If that was the case,
> maybe moving most of the GFP_* flags into the per-cache flags,
> and have the renaming that Ben suggested earlier.
> 
> Thanks,
> 
>         M.
> -- 
> Jazz is not dead. It just smells funny...
