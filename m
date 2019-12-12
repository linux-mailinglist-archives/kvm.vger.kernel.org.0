Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 765EE11C154
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 01:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfLLA3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 19:29:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:50208 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727193AbfLLA3C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 19:29:02 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 16:29:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,303,1571727600"; 
   d="scan'208";a="388118644"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 11 Dec 2019 16:29:02 -0800
Date:   Wed, 11 Dec 2019 16:29:02 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: assign two bits to track SPTE kinds
Message-ID: <20191212002902.GM5044@linux.intel.com>
References: <1569582943-13476-1-git-send-email-pbonzini@redhat.com>
 <1569582943-13476-2-git-send-email-pbonzini@redhat.com>
 <CANgfPd8G194y1Bo-6HR-jP8wh4DvdAsaijue_pnhetjduyzn4A@mail.gmail.com>
 <20191211191327.GI5044@linux.intel.com>
 <4e850c10-ff14-d95e-df22-0d0fd7427509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e850c10-ff14-d95e-df22-0d0fd7427509@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 12, 2019 at 12:28:27AM +0100, Paolo Bonzini wrote:
> On 11/12/19 20:13, Sean Christopherson wrote:
> > Assuming we haven't missed something, the easiest fix would be to reduce
> > the MMIO generation by one bit and use bits 62:54 for the MMIO generation.
> 
> Yes, and I mistakenly thought it would be done just by adjusting 
> PT64_SECOND_AVAIL_BITS_SHIFT.
> 
> I will test and send formally something like this:
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6f92b40d798c..aa2d86f42b9a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -405,11 +405,13 @@ static inline bool is_access_track_spte(u64 spte)
>  }
>  
>  /*
> - * Due to limited space in PTEs, the MMIO generation is a 19 bit subset of
> + * Due to limited space in PTEs, the MMIO generation is a 18 bit subset of
>   * the memslots generation and is derived as follows:
>   *
>   * Bits 0-8 of the MMIO generation are propagated to spte bits 3-11
> - * Bits 9-18 of the MMIO generation are propagated to spte bits 52-61
> + * Bits 9-17 of the MMIO generation are propagated to spte bits 54-62
>   *
> + * We don't use bit 63 to avoid conflicting with the SVE bit in EPT PTEs.
> + *
>   * The KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS flag is intentionally not included in
>   * the MMIO generation number, as doing so would require stealing a bit from
> @@ -418,15 +418,16 @@ static inline bool is_access_track_spte(u64 spte)
>   * requires a full MMU zap).  The flag is instead explicitly queried when
>   * checking for MMIO spte cache hits.
>   */
> -#define MMIO_SPTE_GEN_MASK		GENMASK_ULL(18, 0)
> +#define MMIO_SPTE_GEN_MASK		GENMASK_ULL(17, 0)
>  
>  #define MMIO_SPTE_GEN_LOW_START		3
>  #define MMIO_SPTE_GEN_LOW_END		11
>  #define MMIO_SPTE_GEN_LOW_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
>  						    MMIO_SPTE_GEN_LOW_START)
>  
> -#define MMIO_SPTE_GEN_HIGH_START	52
> -#define MMIO_SPTE_GEN_HIGH_END		61
> +/* Leave room for SPTE_SPECIAL_MASK.  */
> +#define MMIO_SPTE_GEN_HIGH_START	PT64_SECOND_AVAIL_BITS_SHIFT

I'd rather have GEN_HIGH_START be an explicit bit number and then add
a BUILD_BUG_ON(GEN_HIGH_START < PT64_SECOND_AVAIL_BITS_SHIFT) to ensure
the MMIO gen doesn't overlap other stuff.  That way we get a build error
if someone changes PT64_SECOND_AVAIL_BITS_SHIFT, otherwise the MMIO gen
will end up who knows where and probably overwrite NX or EPT.SUPPRESS_VE.

> +#define MMIO_SPTE_GEN_HIGH_END		62
>  #define MMIO_SPTE_GEN_HIGH_MASK		GENMASK_ULL(MMIO_SPTE_GEN_HIGH_END, \
>  						    MMIO_SPTE_GEN_HIGH_START)
>  static u64 generation_mmio_spte_mask(u64 gen)
> 
> 
> Paolo
> 
