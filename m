Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D517D5BBF
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 08:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730035AbfJNG4u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 02:56:50 -0400
Received: from mga12.intel.com ([192.55.52.136]:29821 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbfJNG4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 02:56:50 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Oct 2019 23:56:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,295,1566889200"; 
   d="scan'208";a="207912597"
Received: from zhangyu-optiplex-9020.bj.intel.com (HELO localhost) ([10.238.135.148])
  by fmsmga001.fm.intel.com with ESMTP; 13 Oct 2019 23:56:46 -0700
Date:   Mon, 14 Oct 2019 14:47:53 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@kvack.org, luto@kernel.org, peterz@infradead.org,
        dave.hansen@intel.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, keescook@chromium.org,
        kristen@linux.intel.com, deneen.t.dock@intel.com
Subject: Re: [RFC PATCH 01/13] kvm: Enable MTRR to work with GFNs with perm
 bits
Message-ID: <20191014064753.xv365y6oowmh6ho7@linux.intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
 <20191003212400.31130-2-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003212400.31130-2-rick.p.edgecombe@intel.com>
User-Agent: NeoMutt/20180622-66-b94505
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 03, 2019 at 02:23:48PM -0700, Rick Edgecombe wrote:
> Mask gfn by maxphyaddr in kvm_mtrr_get_guest_memory_type so that the
> guests view of gfn is used when high bits of the physical memory are
> used as extra permissions bits. This supports the KVM XO feature.
> 
> TODO: Since MTRR is emulated using EPT permissions, the XO version of
> the gpa range will not inherrit the MTRR type with this implementation.
> There shouldn't be any legacy use of KVM XO, but hypothetically it could
> interfere with the uncacheable MTRR type.
> 
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
>  arch/x86/kvm/mtrr.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
> index 25ce3edd1872..da38f3b83e51 100644
> --- a/arch/x86/kvm/mtrr.c
> +++ b/arch/x86/kvm/mtrr.c
> @@ -621,6 +621,14 @@ u8 kvm_mtrr_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn)
>  	const int wt_wb_mask = (1 << MTRR_TYPE_WRBACK)
>  			       | (1 << MTRR_TYPE_WRTHROUGH);
>  
> +	/*
> +	 * Handle situations where gfn bits are used as permissions bits by
> +	 * masking KVMs view of the gfn with the guests physical address bits
> +	 * in order to match the guests view of physical address. For normal
> +	 * situations this will have no effect.
> +	 */
> +	gfn &= (1ULL << (cpuid_maxphyaddr(vcpu) - PAGE_SHIFT));
> +

Won't this break the MTRR calculation for normal gfns?
Are you suggesting use the same MTRR value for the XO range as the normal one's?
If so, may be we should use:

	if (guest_cpuid_has(vcpu, X86_FEATURE_KVM_XO))
		gfn &= ~(1ULL << (cpuid_maxphyaddr(vcpu) - PAGE_SHIFT));


>  	start = gfn_to_gpa(gfn);
>  	end = start + PAGE_SIZE;
>  
> -- 
> 2.17.1
> 

B.R.
Yu
