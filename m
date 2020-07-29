Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD872321C1
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 17:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgG2Pnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 11:43:31 -0400
Received: from mga17.intel.com ([192.55.52.151]:13603 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbgG2Pnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 11:43:31 -0400
IronPort-SDR: jV++8P81WKSBHh6HivO1ISI4wy7UJb9FQPqK6qWf1QV2ind6JPAlfyfwIYOMzWN6wgnw+PzU1x
 J5iuVf9C53HQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="131506505"
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="131506505"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 08:43:29 -0700
IronPort-SDR: 4tiCkFH6jrL3naXMpZNC6yZ2li25w2kDxZDy+RU4W+F4CylMRZ4uwwrNvtgXnTIu/dxfMkx6ze
 p/yfMlTdzFQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="290571942"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 29 Jul 2020 08:43:28 -0700
Date:   Wed, 29 Jul 2020 08:43:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 3/4] KVM: SVM: Add GHCB Accessor functions
Message-ID: <20200729154328.GC27751@linux.intel.com>
References: <20200729132234.2346-1-joro@8bytes.org>
 <20200729132234.2346-4-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729132234.2346-4-joro@8bytes.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 29, 2020 at 03:22:33PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Building a correct GHCB for the hypervisor requires setting valid bits
> in the GHCB. Simplify that process by providing accessor functions to
> set values and to update the valid bitmap.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/include/asm/svm.h | 61 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 61 insertions(+)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 9a3e0b802716..0420250b008b 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -341,4 +341,65 @@ struct __attribute__ ((__packed__)) vmcb {
>  
>  #define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
>  
> +/* GHCB Accessor functions */
> +
> +#define DEFINE_GHCB_INDICES(field)					\
> +	u16 idx = offsetof(struct vmcb_save_area, field) / 8;		\

Using sizeof(u64) instead of '8' would be helpful here.

> +	u16 byte_idx  = idx / 8;					\
> +	u16 bit_idx   = idx % 8;					\

Oof.  I love macro frameworks as much as the next person, but declaring
local variables in a macro like this is nasty.

> +	BUILD_BUG_ON(byte_idx > ARRAY_SIZE(ghcb->save.valid_bitmap));
> +
> +#define GHCB_SET_VALID(ghcb, field)					\
> +	{								\
> +		DEFINE_GHCB_INDICES(field)				\
> +		(ghcb)->save.valid_bitmap[byte_idx] |= BIT(bit_idx);	\

Rather than manually calculate the byte/bit indices just use __set_bit()
and test_bit().  That will also solve the variable declaration issue.

E.g.

#define GHB_BITMAP_IDX(field)		\
	(offsetof(struct vmcb_save_area, (field)) / sizeof(u64))

#define GHCB_SET_VALID(ghcb, field)	\
	__set_bit(GHCB_BITMAP_IDX(field), (unsigned long *)&ghcb->save.valid_bitmap)

Or alternatively drop GHCB_SET_VALID() and just open code the two users.

> +	}
> +
> +#define DEFINE_GHCB_SETTER(field)					\
> +	static inline void						\
> +	ghcb_set_##field(struct ghcb *ghcb, u64 value)			\
> +	{								\
> +		GHCB_SET_VALID(ghcb, field)				\
> +		(ghcb)->save.field = value;				\


The ghcb doesn't need to be wrapped in (), it's a parameter to a function.
Same comment for the below usage.

> +	}
> +
> +#define DEFINE_GHCB_ACCESSORS(field)					\
> +	static inline bool ghcb_is_valid_##field(const struct ghcb *ghcb)	\

I'd prefer to follow the naming of the arch reg accessors, i.e.

	static inline bool ghcb_##field##_is_valid(...)

to pair with

	kvm_##lname##_read
	kvm_##lname##_write

And because ghcb_is_valid_rip() reads a bit weird, e.g. IMO is more likely
to be read as "does the RIP in the GHCB hold a valid (canonical) value",
versus ghcb_rip_is_valid() reading as "is RIP valid in the GHCB".

> +	{								\
> +		DEFINE_GHCB_INDICES(field)				\
> +		return !!((ghcb)->save.valid_bitmap[byte_idx]		\
> +						& BIT(bit_idx));	\
> +	}								\
> +									\
> +	static inline void						\
> +	ghcb_set_##field(struct ghcb *ghcb, u64 value)			\
> +	{								\
> +		GHCB_SET_VALID(ghcb, field)				\
> +		(ghcb)->save.field = value;				\

> +	}
> +
> +DEFINE_GHCB_ACCESSORS(cpl)
> +DEFINE_GHCB_ACCESSORS(rip)
> +DEFINE_GHCB_ACCESSORS(rsp)
> +DEFINE_GHCB_ACCESSORS(rax)
> +DEFINE_GHCB_ACCESSORS(rcx)
> +DEFINE_GHCB_ACCESSORS(rdx)
> +DEFINE_GHCB_ACCESSORS(rbx)
> +DEFINE_GHCB_ACCESSORS(rbp)
> +DEFINE_GHCB_ACCESSORS(rsi)
> +DEFINE_GHCB_ACCESSORS(rdi)
> +DEFINE_GHCB_ACCESSORS(r8)
> +DEFINE_GHCB_ACCESSORS(r9)
> +DEFINE_GHCB_ACCESSORS(r10)
> +DEFINE_GHCB_ACCESSORS(r11)
> +DEFINE_GHCB_ACCESSORS(r12)
> +DEFINE_GHCB_ACCESSORS(r13)
> +DEFINE_GHCB_ACCESSORS(r14)
> +DEFINE_GHCB_ACCESSORS(r15)
> +DEFINE_GHCB_ACCESSORS(sw_exit_code)
> +DEFINE_GHCB_ACCESSORS(sw_exit_info_1)
> +DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
> +DEFINE_GHCB_ACCESSORS(sw_scratch)
> +DEFINE_GHCB_ACCESSORS(xcr0)
> +
>  #endif
> -- 
> 2.17.1
> 
