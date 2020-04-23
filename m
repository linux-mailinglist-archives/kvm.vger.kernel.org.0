Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C601B6472
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 21:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgDWT3v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 15:29:51 -0400
Received: from mga06.intel.com ([134.134.136.31]:25783 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726060AbgDWT3u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 15:29:50 -0400
IronPort-SDR: Nj8NgsSRhingzpTN1eOvUtCOj6qbSsjTFMxUJm75sA3vW0UY7Cg6Jlyuz1mYNEtdAgCEStcuOj
 v3RPSeE7gqPA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 12:29:49 -0700
IronPort-SDR: KzWojmJAkf/lkpLHYRt7XLtZwsTxIm8RHEbrgOSD59bodrbmiQU9aeYoGu/27ygUoUVkQwTTJk
 Fumy4Jk7pgnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,307,1583222400"; 
   d="scan'208";a="430444528"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 23 Apr 2020 12:29:49 -0700
Date:   Thu, 23 Apr 2020 12:29:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] kvm: x86: Use KVM_DEBUGREG_NEED_RELOAD instead
 of KVM_DEBUGREG_BP_ENABLED
Message-ID: <20200423192949.GO17824@linux.intel.com>
References: <20200416101509.73526-1-xiaoyao.li@intel.com>
 <20200416101509.73526-3-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416101509.73526-3-xiaoyao.li@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 16, 2020 at 06:15:08PM +0800, Xiaoyao Li wrote:
> Once any #BP enabled in DR7, it will set KVM_DEBUGREG_BP_ENABLED, which
> leads to reload DRn before every VM entry even if none of DRn changed.
> 
> Drop KVM_DEBUGREG_BP_ENABLED flag and set KVM_DEBUGREG_NEED_RELOAD flag
> for the cases that DRn need to be reloaded instead, to avoid unnecessary
> DRn reload.

Loading DRs on every VM-Enter _is_ necessary if there are breakpoints
enabled for the guest.  The hardware DR values are not "stable", e.g. they
are loaded with the host's values immediately after saving the guest's
value (if DR_EXITING is disabled) in vcpu_enter_guest(), notably iff the
host has an active/enabled breakpoint.  My bet is that DRs can be changed
from interrupt context as well.

Loading DRs for the guest (not necessarily the same as the guest's DRs) is
necessary if a breakpoint is enabled so that the #DB is actually hit in
guest.  It's a similar concept to instructions that consume MSR values,
e.g. SYSCALL, RDTSCP, etc..., even if KVM intercepts the MSR/DR, hardware
still needs the correct value so that the guest behavior is correct.

> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 3 +--
>  arch/x86/kvm/x86.c              | 4 ++--
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f465c76e6e5a..87e2d020351e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -509,9 +509,8 @@ struct kvm_pmu {
>  struct kvm_pmu_ops;
>  
>  enum {
> -	KVM_DEBUGREG_BP_ENABLED = 1,
> +	KVM_DEBUGREG_NEED_RELOAD = 1,
>  	KVM_DEBUGREG_WONT_EXIT = 2,
> -	KVM_DEBUGREG_NEED_RELOAD = 4,
>  };
>  
>  struct kvm_mtrr_range {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cce926658d10..71264df64001 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1086,9 +1086,8 @@ static void kvm_update_dr7(struct kvm_vcpu *vcpu)
>  	else
>  		dr7 = vcpu->arch.dr7;
>  	kvm_x86_ops.set_dr7(vcpu, dr7);
> -	vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_BP_ENABLED;
>  	if (dr7 & DR7_BP_EN_MASK)
> -		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_BP_ENABLED;
> +		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_NEED_RELOAD;
>  }
>  
>  static u64 kvm_dr6_fixed(struct kvm_vcpu *vcpu)
> @@ -1128,6 +1127,7 @@ static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
>  		break;
>  	}
>  
> +	vcpu->arch.switch_db_regs |= KVM_DEBUGREG_NEED_RELOAD;
>  	return 0;
>  }
>  
> -- 
> 2.20.1
> 
