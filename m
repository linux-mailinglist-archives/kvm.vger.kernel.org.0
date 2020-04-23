Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF0A1B64B8
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 21:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgDWTqH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 15:46:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:53665 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbgDWTqH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 15:46:07 -0400
IronPort-SDR: KipybtEhMwdUDg1ZpD3nYEF19hM346MqPY4sJvOsRnGYq06fU5DwupgV2XJ9hPNuFi0pHWj6Sh
 DfWrPo2JzJSg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 12:46:05 -0700
IronPort-SDR: Qz8Jy3ETNZnoFj8xPdm/S1VRuv6zlZYUXaFwaCLgS66IQzQpKZhM8Z+hqoTfxODL23Q7qMJANQ
 3GTqzGVLXGnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,307,1583222400"; 
   d="scan'208";a="430448665"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 23 Apr 2020 12:46:05 -0700
Date:   Thu, 23 Apr 2020 12:46:05 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, wei.huang2@amd.com, cavery@redhat.com
Subject: Re: [PATCH kvm-unit-tests] SVM: move guest past HLT
Message-ID: <20200423194605.GQ17824@linux.intel.com>
References: <20200423170653.191992-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423170653.191992-1-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 01:06:53PM -0400, Paolo Bonzini wrote:
> On AMD, the guest is not woken up from HLT by the interrupt or NMI vmexits.
> Therefore we have to fix up the RIP manually.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  x86/svm_tests.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index c2725af..1f2975c 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -1316,6 +1316,11 @@ static bool interrupt_finished(struct svm_test *test)
>              return true;
>          }
>  
> +        /* The guest is not woken up from HLT, unlike Intel.  Fix that up.  */

The comment about "unlike Intel" isn't correct, or at least it's not always
correct.  Intercept NMIs/interrupts don't affect vmcs.GUEST_ACTIVITY, i.e.
if the guest was in HLT before the exit then that's what will be recorded
in the VMCS.

https://lkml.kernel.org/r/20190509204838.GC12810@linux.intel.com

> +        if (get_test_stage(test) == 3) {
> +            vmcb->save.rip++;
> +        }
> +
>          irq_enable();
>          asm volatile ("nop");
>          irq_disable();
> @@ -1501,6 +1506,9 @@ static bool nmi_hlt_finished(struct svm_test *test)
>              return true;
>          }
>  
> +        /* The guest is not woken up from HLT, unlike Intel.  Fix that up.  */
> +        vmcb->save.rip++;
> +
>          report(true, "NMI intercept while running guest");
>          break;
>  
> -- 
> 2.18.2
> 
