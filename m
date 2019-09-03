Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8FEA71A2
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 19:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbfICR2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 13:28:41 -0400
Received: from mga07.intel.com ([134.134.136.100]:21969 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728571AbfICR2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 13:28:40 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 10:28:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,463,1559545200"; 
   d="scan'208";a="184830312"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 03 Sep 2019 10:28:40 -0700
Date:   Tue, 3 Sep 2019 10:28:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nadav Amit <namit@vmware.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] x86: nVMX: Do not use test_skip()
 when multiple tests are run
Message-ID: <20190903172840.GJ10768@linux.intel.com>
References: <20190830204031.3100-1-namit@vmware.com>
 <20190830204031.3100-2-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830204031.3100-2-namit@vmware.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 30, 2019 at 01:40:30PM -0700, Nadav Amit wrote:
> Using test_skip() when multiple tests are run causes all the following
> tests to be skipped. Instead, just print a message and return.
> 
> Fixes: 47cc3d85c2fe ("nVMX x86: Check PML and EPT on vmentry of L2 guests")
> Fixes: 7fd449f2ed2e ("nVMX x86: Check VPID value on vmentry of L2 guests")
> Fixes: 181219bfd76b ("x86: Add test for checking NMI controls on vmentry of L2 guests")
> Fixes: 1d70eb823e12 ("nVMX x86: Check EPTP on vmentry of L2 guests")
> Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Nadav Amit <namit@vmware.com>

invvpid_test_v2() also has a bunch of bad calls to test_skip().

What about removing test_skip() entirely?  The code for in_guest looks
suspect, e.g. at a glance it should use HYPERCALL_VMSKIP instead of
HYPERCALL_VMABORT.  The only somewhat legit usage is the ept tests, and
only then because the ept tests are all at the end of the array.
Returning success/failure from ept_access_test_setup() seems like a
better solution than test_skip.

> ---
>  x86/vmx_tests.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index f035f24..4ff1570 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -4040,7 +4040,7 @@ static void test_vpid(void)
>  
>  	if (!((ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
>  	    (ctrl_cpu_rev[1].clr & CPU_VPID))) {
> -		test_skip("Secondary controls and/or VPID not supported");
> +		printf("Secondary controls and/or VPID not supported\n");
>  		return;
>  	}
>  
> @@ -4544,7 +4544,7 @@ static void test_nmi_ctrls(void)
>  
>  	if ((ctrl_pin_rev.clr & (PIN_NMI | PIN_VIRT_NMI)) !=
>  	    (PIN_NMI | PIN_VIRT_NMI)) {
> -		test_skip("NMI exiting and Virtual NMIs are not supported !");
> +		printf("NMI exiting and Virtual NMIs are not supported !\n");
>  		return;
>  	}
>  
> @@ -4657,7 +4657,7 @@ static void test_ept_eptp(void)
>  
>  	if (!((ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
>  	    (ctrl_cpu_rev[1].clr & CPU_EPT))) {
> -		test_skip("\"CPU secondary\" and/or \"enable EPT\" execution controls are not supported !");
> +		printf("\"CPU secondary\" and/or \"enable EPT\" execution controls are not supported !\n");
>  		return;
>  	}
>  
> @@ -4844,7 +4844,7 @@ static void test_pml(void)
>  
>  	if (!((ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
>  	    (ctrl_cpu_rev[1].clr & CPU_EPT) && (ctrl_cpu_rev[1].clr & CPU_PML))) {
> -		test_skip("\"Secondary execution\" control or \"enable EPT\" control or \"enable PML\" control is not supported !");
> +		printf("\"Secondary execution\" control or \"enable EPT\" control or \"enable PML\" control is not supported !\n");
>  		return;
>  	}
>  
> -- 
> 2.17.1
> 
