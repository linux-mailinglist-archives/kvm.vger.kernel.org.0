Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C665A3DC8
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 20:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbfH3ShF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Aug 2019 14:37:05 -0400
Received: from mga14.intel.com ([192.55.52.115]:52021 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727914AbfH3ShE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Aug 2019 14:37:04 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Aug 2019 11:37:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,447,1559545200"; 
   d="scan'208";a="382100406"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 30 Aug 2019 11:37:04 -0700
Date:   Fri, 30 Aug 2019 11:37:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 4/7] KVM: nVMX: check GUEST_IA32_PERF_GLOBAL_CTRL on
 VM-Entry
Message-ID: <20190830183703.GG15405@linux.intel.com>
References: <20190828234134.132704-1-oupton@google.com>
 <20190828234134.132704-5-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828234134.132704-5-oupton@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 04:41:31PM -0700, Oliver Upton wrote:
> According to the SDM 26.3.1.1, "If the "load IA32_PERF_GLOBAL_CTRL" VM-entry
> control is 1, bits reserved in the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the
> field for that register".
> 
> Adding condition to nested_vmx_check_guest_state() to check the validity of
> GUEST_IA32_PERF_GLOBAL_CTRL if the "load IA32_PERF_GLOBAL_CTRL" bit is
> set on the VM-entry control.

Same comment on mood.  And for this case, it's probably overkill to
give a play-by-play of the code, just state that you're adding a check
as described in the SDM, e.g.:

Add a nested VM-Enter consistency check when loading the guest's
IA32_PERF_GLOBAL_CTRL MSR from vmcs12.  Per Intel's SDM:

  If the "load IA32_PERF_GLOBAL_CTRL" VM-entry control is 1, bits
  reserved in the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the field for
  that register.

> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 9ba90b38d74b..8d6f0144b1bd 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -10,6 +10,7 @@
>  #include "hyperv.h"
>  #include "mmu.h"
>  #include "nested.h"
> +#include "pmu.h"
>  #include "trace.h"
>  #include "x86.h"
>  
> @@ -2748,6 +2749,11 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>  		return -EINVAL;
>  	}
>  
> +	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL &&
> +	    !kvm_is_valid_perf_global_ctrl(vcpu,
> +					   vmcs12->guest_ia32_perf_global_ctrl))
> +		return -EINVAL;
> +
>  	/*
>  	 * If the load IA32_EFER VM-entry control is 1, the following checks
>  	 * are performed on the field for the IA32_EFER MSR:
> -- 
> 2.23.0.187.g17f5b7556c-goog
> 
