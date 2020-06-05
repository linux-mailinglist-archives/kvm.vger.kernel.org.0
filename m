Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673051F00A6
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 21:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgFET6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 15:58:22 -0400
Received: from mga06.intel.com ([134.134.136.31]:28831 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727863AbgFET6V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 15:58:21 -0400
IronPort-SDR: XXxau54WxiSGvRwQsI0k066WSZ95czY2mDyrcVvg9nVLFtrCXWDRERBny2PbqkScF5aqVhJ8vt
 Z5o4JUAuOg7g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2020 12:58:21 -0700
IronPort-SDR: vr4CS/RULSt0vKsP19ZcdnKZQLwixP9OFuv9mIbr5Qsf0/OwiDyhRt+zC5uF2DkKoVzH7Jd7hS
 MRBXJ2Eff9Ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,477,1583222400"; 
   d="scan'208";a="472021301"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga005.fm.intel.com with ESMTP; 05 Jun 2020 12:58:20 -0700
Date:   Fri, 5 Jun 2020 12:58:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 2/3 v2] kvm-unit-tests: nVMX: Optimize test_guest_dr7()
 by factoring out the loops into a macro
Message-ID: <20200605195820.GB11449@linux.intel.com>
References: <1591384822-71784-1-git-send-email-krish.sadhukhan@oracle.com>
 <1591384822-71784-3-git-send-email-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1591384822-71784-3-git-send-email-krish.sadhukhan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I don't think "optimize" is the word you're looking for.  Moving code into
a macro doesn't optimize anything, the only thing it does is consolidate
code.

On Fri, Jun 05, 2020 at 07:20:21PM +0000, Krish Sadhukhan wrote:
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>  x86/vmx_tests.c | 36 ++++++++++++++++++++----------------
>  1 file changed, 20 insertions(+), 16 deletions(-)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 4308ef3..7dd8bfb 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -7704,6 +7704,19 @@ static void vmx_host_state_area_test(void)
>  	test_load_host_perf_global_ctrl();
>  }
>  
> +#define TEST_GUEST_VMCS_FIELD_RESERVED_BITS(start, end, inc, fld, str_name,\
> +					    val, msg, xfail)		\
> +{									\
> +	u64 tmp;							\
> +	int i;								\
> +									\
> +	for (i = start; i <= end; i = i + inc) {			\

The "i = i + inc" is weird, not to mention a functional change as the callers
are passing in '4', i.e. this only checks every fourth bit.

IMO this whole macro is overkill and doesn't help readability in the callers,
there are too many parameters to cross reference.  What about adding a more
simple helper to iterate over every bit, e.g. 

	for_each_bit(0, 63, val) {
		vmcs_write(GUEST_DR7, val);
		test_guest_state("ENT_LOAD_DBGCTLS disabled", false,
				 val, "GUEST_DR7");
	}

and

        for_each_bit(0, 63, val) {
                vmcs_write(GUEST_DR7, val);
                test_guest_state("ENT_LOAD_DBGCTLS enabled", val >> 32,
                                 val, "GUEST_DR7");
        }


I'm guessing the for_each_bit() thing can be reused in other flows besides
guest state checks.

> +		tmp = val | (1ull << i);				\
> +		vmcs_write(fld, tmp);					\
> +		test_guest_state(msg, xfail, val, str_name);		\
> +	}								\
> +}
> +
>  /*
>   * If the "load debug controls" VM-entry control is 1, bits 63:32 in
>   * the DR7 field must be 0.
> @@ -7714,26 +7727,17 @@ static void test_guest_dr7(void)
>  {
>  	u32 ent_saved = vmcs_read(ENT_CONTROLS);
>  	u64 dr7_saved = vmcs_read(GUEST_DR7);
> -	u64 val;
> -	int i;
>  
>  	if (ctrl_enter_rev.set & ENT_LOAD_DBGCTLS) {
> -		vmcs_clear_bits(ENT_CONTROLS, ENT_LOAD_DBGCTLS);
> -		for (i = 0; i < 64; i++) {
> -			val = 1ull << i;
> -			vmcs_write(GUEST_DR7, val);
> -			test_guest_state("ENT_LOAD_DBGCTLS disabled", false,
> -					 val, "GUEST_DR7");
> -		}
> +		vmcs_write(ENT_CONTROLS, ent_saved & ~ENT_LOAD_DBGCTLS);
> +		TEST_GUEST_VMCS_FIELD_RESERVED_BITS(0, 63, 4, GUEST_DR7,
> +		    "GUEST_DR7", dr7_saved, "ENT_LOAD_DBGCTLS disabled", false);
>  	}
>  	if (ctrl_enter_rev.clr & ENT_LOAD_DBGCTLS) {
> -		vmcs_set_bits(ENT_CONTROLS, ENT_LOAD_DBGCTLS);
> -		for (i = 0; i < 64; i++) {
> -			val = 1ull << i;
> -			vmcs_write(GUEST_DR7, val);
> -			test_guest_state("ENT_LOAD_DBGCTLS enabled", i >= 32,
> -					 val, "GUEST_DR7");
> -		}
> +		vmcs_write(ENT_CONTROLS, ent_saved | ENT_LOAD_DBGCTLS);
> +		TEST_GUEST_VMCS_FIELD_RESERVED_BITS(0, 63, 4, GUEST_DR7,
> +		    "GUEST_DR7", dr7_saved, "ENT_LOAD_DBGCTLS enabled",
> +		    i >= 32);
>  	}
>  	vmcs_write(GUEST_DR7, dr7_saved);
>  	vmcs_write(ENT_CONTROLS, ent_saved);
> -- 
> 1.8.3.1
> 
