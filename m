Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E893233296
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 15:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgG3NFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 09:05:34 -0400
Received: from 8bytes.org ([81.169.241.247]:34040 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbgG3NFe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 09:05:34 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id F3B893C8; Thu, 30 Jul 2020 15:05:32 +0200 (CEST)
Date:   Thu, 30 Jul 2020 15:05:31 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 3/4] KVM: SVM: Add GHCB Accessor functions
Message-ID: <20200730130531.GC3257@8bytes.org>
References: <20200729132234.2346-1-joro@8bytes.org>
 <20200729132234.2346-4-joro@8bytes.org>
 <20200729154328.GC27751@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729154328.GC27751@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 29, 2020 at 08:43:28AM -0700, Sean Christopherson wrote:
> Rather than manually calculate the byte/bit indices just use __set_bit()
> and test_bit().  That will also solve the variable declaration issue.
> 
> E.g.
> 
> #define GHB_BITMAP_IDX(field)		\
> 	(offsetof(struct vmcb_save_area, (field)) / sizeof(u64))
> 
> #define GHCB_SET_VALID(ghcb, field)	\
> 	__set_bit(GHCB_BITMAP_IDX(field), (unsigned long *)&ghcb->save.valid_bitmap)
> 
> Or alternatively drop GHCB_SET_VALID() and just open code the two users.

Thanks for your suggestions, I updated the patch and will do some
testing before re-posting.

Regards,

	Joerg

> 
> > +	}
> > +
> > +#define DEFINE_GHCB_SETTER(field)					\
> > +	static inline void						\
> > +	ghcb_set_##field(struct ghcb *ghcb, u64 value)			\
> > +	{								\
> > +		GHCB_SET_VALID(ghcb, field)				\
> > +		(ghcb)->save.field = value;				\
> 
> 
> The ghcb doesn't need to be wrapped in (), it's a parameter to a function.
> Same comment for the below usage.
> 
> > +	}
> > +
> > +#define DEFINE_GHCB_ACCESSORS(field)					\
> > +	static inline bool ghcb_is_valid_##field(const struct ghcb *ghcb)	\
> 
> I'd prefer to follow the naming of the arch reg accessors, i.e.
> 
> 	static inline bool ghcb_##field##_is_valid(...)
> 
> to pair with
> 
> 	kvm_##lname##_read
> 	kvm_##lname##_write
> 
> And because ghcb_is_valid_rip() reads a bit weird, e.g. IMO is more likely
> to be read as "does the RIP in the GHCB hold a valid (canonical) value",
> versus ghcb_rip_is_valid() reading as "is RIP valid in the GHCB".
> 
> > +	{								\
> > +		DEFINE_GHCB_INDICES(field)				\
> > +		return !!((ghcb)->save.valid_bitmap[byte_idx]		\
> > +						& BIT(bit_idx));	\
> > +	}								\
> > +									\
> > +	static inline void						\
> > +	ghcb_set_##field(struct ghcb *ghcb, u64 value)			\
> > +	{								\
> > +		GHCB_SET_VALID(ghcb, field)				\
> > +		(ghcb)->save.field = value;				\
> 
> > +	}
> > +
> > +DEFINE_GHCB_ACCESSORS(cpl)
> > +DEFINE_GHCB_ACCESSORS(rip)
> > +DEFINE_GHCB_ACCESSORS(rsp)
> > +DEFINE_GHCB_ACCESSORS(rax)
> > +DEFINE_GHCB_ACCESSORS(rcx)
> > +DEFINE_GHCB_ACCESSORS(rdx)
> > +DEFINE_GHCB_ACCESSORS(rbx)
> > +DEFINE_GHCB_ACCESSORS(rbp)
> > +DEFINE_GHCB_ACCESSORS(rsi)
> > +DEFINE_GHCB_ACCESSORS(rdi)
> > +DEFINE_GHCB_ACCESSORS(r8)
> > +DEFINE_GHCB_ACCESSORS(r9)
> > +DEFINE_GHCB_ACCESSORS(r10)
> > +DEFINE_GHCB_ACCESSORS(r11)
> > +DEFINE_GHCB_ACCESSORS(r12)
> > +DEFINE_GHCB_ACCESSORS(r13)
> > +DEFINE_GHCB_ACCESSORS(r14)
> > +DEFINE_GHCB_ACCESSORS(r15)
> > +DEFINE_GHCB_ACCESSORS(sw_exit_code)
> > +DEFINE_GHCB_ACCESSORS(sw_exit_info_1)
> > +DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
> > +DEFINE_GHCB_ACCESSORS(sw_scratch)
> > +DEFINE_GHCB_ACCESSORS(xcr0)
> > +
> >  #endif
> > -- 
> > 2.17.1
> > 
