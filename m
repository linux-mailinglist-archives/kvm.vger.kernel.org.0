Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A82CE240D0
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 21:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfETTB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 15:01:59 -0400
Received: from mga05.intel.com ([192.55.52.43]:65229 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbfETTB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 15:01:58 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 May 2019 12:01:58 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by FMSMGA003.fm.intel.com with ESMTP; 20 May 2019 12:01:58 -0700
Date:   Mon, 20 May 2019 12:01:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86/pmu: do not mask the value that is written
 to fixed PMUs
Message-ID: <20190520190158.GE28482@linux.intel.com>
References: <1558366951-19259-1-git-send-email-pbonzini@redhat.com>
 <1558366951-19259-3-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558366951-19259-3-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 20, 2019 at 05:42:31PM +0200, Paolo Bonzini wrote:
> According to the SDM, for MSR_IA32_PERFCTR0/1 "the lower-order 32 bits of
> each MSR may be written with any value, and the high-order 8 bits are
> sign-extended according to the value of bit 31", but the fixed counters
> in real hardware appear to be limited to the width of the fixed counters.
> Fix KVM to do the same.

The section of the SDM you're quoting relates to P6 behavior, which
predates the architectural perfmons.  Section 18.2.1.1 "Architectural
Performance Monitoring Version 1 Facilities" has a more relevant blurb
for the MSR_IA32_PERFCTRx change (slightly modified to eliminate
embarassing typos in the SDM):

  The bit width of an IA32_PMCx MSR is reported using CPUID.0AH:EAXH[23:16].
  This is the number of valid bits for read operation.  On write operations,
  the lower-order 32-bits of the MSR may be written with any value, and the
  high-order bits are sign-extended from the value of bit 31.

And for the fixed counters, section 18.2.2 "Architectural Performance
Monitoring Version 2":

  The facilities provided by architectural performance monitoring version 2
  can be queried from CPUID leaf 0AH by examinng the content of register EDX:

    - Bits 5 through 12 of CPUID.0AH.EDX indicates the bit-width of fixed-
      function performance counters.  Bits beyond the width of the fixed-
      function counter are reserved and must be written as zeros.

> 
> Reported-by: Nadav Amit <nadav.amit@gmail.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index b6f5157445fe..a99613a060dd 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -240,11 +240,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		}
>  		break;
>  	default:
> -		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
> -		    (pmc = get_fixed_pmc(pmu, msr))) {
> -			if (!msr_info->host_initiated)
> -				data = (s64)(s32)data;
> -			pmc->counter += data - pmc_read_counter(pmc);
> +		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
> +			if (msr_info->host_initiated)
> +				pmc->counter = data;
> +			else
> +				pmc->counter = (s32)data;
> +			return 0;
> +		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
> +			pmc->counter = data;

Would it make sense to inject a #GP if the guest attempts to set bits that
are reserved to be zero, e.g. based on guest CPUID?

>  			return 0;
>  		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
>  			if (data == pmc->eventsel)
> -- 
> 1.8.3.1
> 
