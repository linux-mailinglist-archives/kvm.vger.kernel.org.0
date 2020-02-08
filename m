Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04B4F156203
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2020 01:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgBHArY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 19:47:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:41715 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727048AbgBHArX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 19:47:23 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2020 16:47:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,415,1574150400"; 
   d="scan'208";a="226648860"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 07 Feb 2020 16:47:22 -0800
Date:   Fri, 7 Feb 2020 16:47:22 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] KVM: x86: remove redundant WARN_ON check of an
 unsigned less than zero
Message-ID: <20200208004722.GB15581@linux.intel.com>
References: <20200207231813.786224-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200207231813.786224-1-colin.king@canonical.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 07, 2020 at 11:18:13PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The check cpu->hv_clock.system_time < 0 is redundant since system_time
> is a u64 and hence can never be less than zero. Remove it.
> 
> Addresses-Coverity: ("Macro compares unsigned to 0")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  arch/x86/kvm/x86.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fbabb2f06273..d4967ac47e68 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2448,7 +2448,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
>  	vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
>  	vcpu->last_guest_tsc = tsc_timestamp;
> -	WARN_ON(vcpu->hv_clock.system_time < 0);

Don't know this code well, but @kernel_ns and @v->kvm->arch.kvmclock_offset
are both s64, so maybe this was intended and/or desirable?

	WARN_ON((s64)vcpu->hv_clock.system_time < 0);
	

>  	/* If the host uses TSC clocksource, then it is stable */
>  	pvclock_flags = 0;
> -- 
> 2.24.0
> 
