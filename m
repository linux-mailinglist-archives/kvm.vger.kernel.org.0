Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09591CBB4E
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 01:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgEHXhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 19:37:24 -0400
Received: from mga03.intel.com ([134.134.136.65]:30475 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728326AbgEHXhY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 19:37:24 -0400
IronPort-SDR: hjRljdP1dIYM6N1fQjEkcf4BBzEy3FEDv7ypUPcUweg9PhBqNHMe/5qdLGuttZj1cdAhWrznYv
 54xZZL9ELkug==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 16:37:23 -0700
IronPort-SDR: mDu59PUD3Xz8fPlv7B3ug2MFvPj6an5eHH9YiBTYLWQvMwwAZWyDTauvc60FO7ngQI4pl6mt/V
 u6YNVCkPa8qA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,369,1583222400"; 
   d="scan'208";a="249898446"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga007.jf.intel.com with ESMTP; 08 May 2020 16:37:23 -0700
Date:   Fri, 8 May 2020 16:37:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] nVMX: Check EXIT_QUALIFICATION on
 VM-Enter failures due to bad guest state
Message-ID: <20200508233723.GW27052@linux.intel.com>
References: <20200424174025.1379-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424174025.1379-1-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 10:40:25AM -0700, Sean Christopherson wrote:
> Assert that vmcs.EXIT_QUALIFICATION contains the correct failure code on
> failed VM-Enter due to invalid guest state.  Hardcode the expected code
> to the default code, '0', rather than passing in the expected code to
> minimize churn and boilerplate code, which works for all existing tests.
                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

...except for atomic_switch_overflow_msrs_test.  I'll get a fix sent out
next week.

> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  x86/vmx.h       | 7 +++++++
>  x86/vmx_tests.c | 3 ++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/x86/vmx.h b/x86/vmx.h
> index 2e28ecb..08b354d 100644
> --- a/x86/vmx.h
> +++ b/x86/vmx.h
> @@ -521,6 +521,13 @@ enum vm_instruction_error_number {
>  	VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID = 28,
>  };
>  
> +enum vm_entry_failure_code {
> +	ENTRY_FAIL_DEFAULT		= 0,
> +	ENTRY_FAIL_PDPTE		= 2,
> +	ENTRY_FAIL_NMI			= 3,
> +	ENTRY_FAIL_VMCS_LINK_PTR	= 4,
> +};
> +
>  #define SAVE_GPR				\
>  	"xchg %rax, regs\n\t"			\
>  	"xchg %rcx, regs+0x8\n\t"		\
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 4a3c56b..f5a646f 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -5255,7 +5255,8 @@ static void test_guest_state(const char *test, bool xfail, u64 field,
>  
>  	report(result.exit_reason.failed_vmentry == xfail &&
>  	       ((xfail && result.exit_reason.basic == VMX_FAIL_STATE) ||
> -	        (!xfail && result.exit_reason.basic == VMX_VMCALL)),
> +	        (!xfail && result.exit_reason.basic == VMX_VMCALL)) &&
> +		(!xfail || vmcs_read(EXI_QUALIFICATION) == ENTRY_FAIL_DEFAULT),
>  	        "%s, %s %lx", test, field_name, field);
>  
>  	if (!result.exit_reason.failed_vmentry)
> -- 
> 2.26.0
> 
