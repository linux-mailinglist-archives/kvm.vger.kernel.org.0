Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87B0218B06
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 17:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730095AbgGHPSv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 11:18:51 -0400
Received: from mga06.intel.com ([134.134.136.31]:11387 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729022AbgGHPSu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 11:18:50 -0400
IronPort-SDR: z73uPgLersv5Cdg5BARF6cxuNDRnYRox5UsPeNyYWpoh8bPVvFGmVw96iyHcmFys4ls3vH/f9V
 rEKbcXE2zH1Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="209354562"
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="209354562"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 08:18:25 -0700
IronPort-SDR: B0EmdemkkNL93R+ZMLys9ThuGln41bIodaP0X/oBHEdPyFe+7e9L2OXcUcf/vPkP1phGNvtGDS
 GlrQwyrN/ezg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="483918610"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga005.fm.intel.com with ESMTP; 08 Jul 2020 08:18:25 -0700
Date:   Wed, 8 Jul 2020 08:18:25 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM/x86: pmu: Fix #GP condition check for RDPMC emulation
Message-ID: <20200708151824.GA22737@linux.intel.com>
References: <20200708074409.39028-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708074409.39028-1-like.xu@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 08, 2020 at 03:44:09PM +0800, Like Xu wrote:
> in guest protected mode, if the current privilege level
> is not 0 and the pce flag in the cr4 register is cleared,
> we will inject a #gp for rdpmc usage.

Wrapping at ~58 characters is a bit aggressive.  checkpatch enforces 75
chars, something near that would be prefereable.

> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>  arch/x86/kvm/pmu.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index b86346903f2e..d080d475c808 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -372,6 +372,11 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
>  	if (!pmc)
>  		return 1;
>  
> +	if ((kvm_x86_ops.get_cpl(vcpu) != 0) &&
> +	    !(kvm_read_cr4(vcpu) & X86_CR4_PCE) &&
> +	    (kvm_read_cr4(vcpu) & X86_CR0_PE))

This reads CR4 but checks CR0.PE.

And maybe put the X86_CR4_PCE check first so that it's the focus of the
statement?

> +		return 1;
> +
>  	*data = pmc_read_counter(pmc) & mask;
>  	return 0;
>  }
> -- 
> 2.21.3
> 
