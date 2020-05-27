Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3124F1E37CD
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 07:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgE0FRU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 01:17:20 -0400
Received: from mga18.intel.com ([134.134.136.126]:57658 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgE0FRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 01:17:20 -0400
IronPort-SDR: sQMDONUQJGVyT50eRmESRavrTKtgzjVbvLcoJidFTfsaIQ+qddUTLPvp8IABdVS4lwJz3WaIJN
 5KmBaNasRBnA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 22:17:19 -0700
IronPort-SDR: 5X3dWGjasYSWKRTKWOoZ7lKskkHS6V0V6sQ8plLRmjNJWuGdCOK/8GFlhaWgVuChPZSo2WoRLa
 TF8xQvpXStfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,440,1583222400"; 
   d="scan'208";a="266715387"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga003.jf.intel.com with ESMTP; 26 May 2020 22:17:19 -0700
Date:   Tue, 26 May 2020 22:17:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 1/3] kvm-unit-tests: nVMX: Test GUEST_BASE_GDTR and
 GUEST_BASE_IDTR on vmentry of nested guests
Message-ID: <20200527051719.GM31696@linux.intel.com>
References: <20200523002603.32450-1-krish.sadhukhan@oracle.com>
 <20200523002603.32450-2-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523002603.32450-2-krish.sadhukhan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 22, 2020 at 08:26:01PM -0400, Krish Sadhukhan wrote:
> According to section "Checks on Guest Descriptor-Table Registers" in Intel
> SDM vol 3C, the following check is performed on the Guest Descriptor-Table
> Registers on vmentry of nested guests:
> 
>     - On processors that support Intel 64 architecture, the base-address
>       fields must contain canonical addresses.
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>  x86/vmx_tests.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 68f93d3..fa27d99 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -7827,6 +7827,11 @@ static void vmx_guest_state_area_test(void)
>  	test_load_guest_perf_global_ctrl();
>  	test_load_guest_bndcfgs();
>  
> +#ifdef __x86_64__

Aren't the VMX tests 64-bit only?

> +	test_canonical(GUEST_BASE_GDTR, "GUEST_BASE_GDTR", false);
> +	test_canonical(GUEST_BASE_IDTR, "GUEST_BASE_IDTR", false);
> +#endif
> +
>  	/*
>  	 * Let the guest finish execution
>  	 */
> -- 
> 1.8.3.1
> 
