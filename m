Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5425F23AC93
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 20:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgHCSpq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 14:45:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:61191 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgHCSpq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 14:45:46 -0400
IronPort-SDR: sjPImZ9FUQ9UMPK7NCbQV/+L5fLXpUbeHmtz3WXAdhtzGkfXu/MRilQNRtkYJEMP0fjZOazQul
 9IJL7hOWssJA==
X-IronPort-AV: E=McAfee;i="6000,8403,9702"; a="149998602"
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="149998602"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2020 11:45:45 -0700
IronPort-SDR: v05y5NyC5nO9ND9wjJpF79nGhbAdMZnU8QKKkq0oUMDCx6hk4UD3LMR8eFrAgIyFC62frEydN1
 T21NlYjhxqtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="322389770"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga008.jf.intel.com with ESMTP; 03 Aug 2020 11:45:45 -0700
Date:   Mon, 3 Aug 2020 11:45:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH v3 3/4] KVM: SVM: Add GHCB Accessor functions
Message-ID: <20200803184545.GG3151@linux.intel.com>
References: <20200803122708.5942-1-joro@8bytes.org>
 <20200803122708.5942-4-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803122708.5942-4-joro@8bytes.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 03, 2020 at 02:27:07PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Building a correct GHCB for the hypervisor requires setting valid bits
> in the GHCB. Simplify that process by providing accessor functions to
> set values and to update the valid bitmap and to check the valid bitmap
> in KVM.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/include/asm/svm.h | 43 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 9a3e0b802716..71a308f1fbc8 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -341,4 +341,47 @@ struct __attribute__ ((__packed__)) vmcb {
>  
>  #define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
>  
> +/* GHCB Accessor functions */
> +
> +#define GHCB_BITMAP_IDX(field)							\
> +        (offsetof(struct vmcb_save_area, field) / sizeof(u64))
> +
> +#define DEFINE_GHCB_ACCESSORS(field)						\
> +	static inline bool ghcb_##field##_is_valid(const struct ghcb *ghcb)	\
> +	{									\
> +		return test_bit(GHCB_BITMAP_IDX(field),				\
> +				(unsigned long *)&(ghcb)->save.valid_bitmap);	\

'ghcb' doesn't need to be wrapped in (), it's a parameter to a function.

> +	}									\
> +										\
> +	static inline void ghcb_set_##field(struct ghcb *ghcb, u64 value)	\
> +	{									\
> +		__set_bit(GHCB_BITMAP_IDX(field),				\
> +			  (unsigned long *)&(ghcb)->save.valid_bitmap);		\

Same comment here.

> +		ghcb->save.field = value;					\
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
