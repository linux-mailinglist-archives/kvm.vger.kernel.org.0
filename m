Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 391E11936C
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 22:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfEIUcm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 16:32:42 -0400
Received: from mga03.intel.com ([134.134.136.65]:43409 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbfEIUcm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 16:32:42 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 May 2019 13:32:41 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga002.jf.intel.com with ESMTP; 09 May 2019 13:32:41 -0700
Date:   Thu, 9 May 2019 13:32:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] x86: nVMX: Set guest as active after
 NMI/INTR-window tests
Message-ID: <20190509203241.GB12810@linux.intel.com>
References: <20190508102715.685-1-namit@vmware.com>
 <20190508102715.685-3-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508102715.685-3-namit@vmware.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 03:27:15AM -0700, Nadav Amit wrote:
> From: Nadav Amit <nadav.amit@gmail.com>
> 
> Intel SDM 26.6.5 says regarding interrupt-window exiting that: "These
> events wake the logical processor if it just entered the HLT state
> because of a VM entry." A similar statement is told about NMI-window
> exiting.
> 
> However, running tests which are similar to verify_nmi_window_exit() and
> verify_intr_window_exit() on bare-metal suggests that real CPUs do not
> wake up. Until someone figures what the correct behavior is, just reset
> the activity state to "active" after each test to prevent the whole
> test-suite from getting stuck.
> 
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  x86/vmx_tests.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index f921286..2d6b12d 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -7063,6 +7063,7 @@ static void verify_nmi_window_exit(u64 rip)
>  	report("Activity state (%ld) is 'ACTIVE'",
>  	       vmcs_read(GUEST_ACTV_STATE) == ACTV_ACTIVE,
>  	       vmcs_read(GUEST_ACTV_STATE));
> +	vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);

Don't you need to remove (or modify) the above report() as well to avoid
failing the current test?

>  }
>  
>  static void vmx_nmi_window_test(void)
> @@ -7199,6 +7200,7 @@ static void verify_intr_window_exit(u64 rip)
>  	report("Activity state (%ld) is 'ACTIVE'",
>  	       vmcs_read(GUEST_ACTV_STATE) == ACTV_ACTIVE,
>  	       vmcs_read(GUEST_ACTV_STATE));
> +	vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
>  }
>  
>  static void vmx_intr_window_test(void)
> -- 
> 2.17.1
> 
