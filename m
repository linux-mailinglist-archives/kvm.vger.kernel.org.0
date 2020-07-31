Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA85C23484B
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 17:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbgGaPSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 11:18:05 -0400
Received: from mga05.intel.com ([192.55.52.43]:31636 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbgGaPSF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 11:18:05 -0400
IronPort-SDR: m/lRqeA9buvmMqysv5L0WXyYsa/lss13fEvgHjUJokBrkVxQwAWQrjAh7R3i14hzFiWsE0UYsq
 VZb7ErC05EsQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="236660317"
X-IronPort-AV: E=Sophos;i="5.75,418,1589266800"; 
   d="scan'208";a="236660317"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 08:18:04 -0700
IronPort-SDR: j5afO6+0Al1OxlzUlWnPR1eEpRFeCBJIJnHRooFJfsEoV57xwJr58U8TjL1xN/QCNziE+tGQhn
 fHAfblpALDGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,418,1589266800"; 
   d="scan'208";a="395330974"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga001.fm.intel.com with ESMTP; 31 Jul 2020 08:18:04 -0700
Date:   Fri, 31 Jul 2020 08:18:04 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH v2 3/4] KVM: SVM: Add GHCB Accessor functions
Message-ID: <20200731151804.GA31451@linux.intel.com>
References: <20200730154340.14021-1-joro@8bytes.org>
 <20200730154340.14021-4-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730154340.14021-4-joro@8bytes.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 30, 2020 at 05:43:39PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Building a correct GHCB for the hypervisor requires setting valid bits
> in the GHCB. Simplify that process by providing accessor functions to
> set values and to update the valid bitmap and to check the valid bitmap
> in KVM.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/include/asm/svm.h | 46 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 9a3e0b802716..8744817358bf 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -341,4 +341,50 @@ struct __attribute__ ((__packed__)) vmcb {
>  
>  #define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
>  
> +/* GHCB Accessor functions */
> +
> +#define GHB_BITMAP_IDX(field)								\
> +        (offsetof(struct vmcb_save_area, field) / sizeof(u64))
> +
> +#define GHCB_SET_VALID(ghcb, field)							\
> +	__set_bit(GHB_BITMAP_IDX(field), (unsigned long *)&(ghcb)->save.valid_bitmap);	\
> +
> +#define DEFINE_GHCB_ACCESSORS(field)							\
> +	static inline bool ghcb_##field##_is_valid(const struct ghcb *ghcb)		\
> +	{										\
> +		int idx = offsetof(struct vmcb_save_area, field) / sizeof(u64);		\

This should also use GHB_BITMAP_IDX.

> +		return test_bit(idx, (unsigned long *)&(ghcb)->save.valid_bitmap);	\
> +	}										\
> +											\
> +	static inline void								\
> +	ghcb_set_##field(struct ghcb *ghcb, u64 value)					\
> +	{										\
> +		GHCB_SET_VALID(ghcb, field)						\
> +		ghcb->save.field = value;						\
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
