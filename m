Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648FA1B6441
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 21:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgDWTJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 15:09:43 -0400
Received: from mga04.intel.com ([192.55.52.120]:4228 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgDWTJn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 15:09:43 -0400
IronPort-SDR: 0RCvmSzuKI2YwbBCWdKyFRrWCOfggIztzeuK83YSWnFg+RX9b64mVFuFZrf+O+3sX6xrRUnW8f
 HDS29X16/3pw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 12:09:42 -0700
IronPort-SDR: TR7wH3hsxO3BWN02PQbSjQyrJi4zY4mc0Y/Fods1fzedhxWuWaUx2y8rTDPPZNeIkc8oUMhJZf
 j1t4y05TtyXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,307,1583222400"; 
   d="scan'208";a="430440168"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 23 Apr 2020 12:09:41 -0700
Date:   Thu, 23 Apr 2020 12:09:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] kvm: x86: Rename KVM_DEBUGREG_RELOAD to
 KVM_DEBUGREG_NEED_RELOAD
Message-ID: <20200423190941.GN17824@linux.intel.com>
References: <20200416101509.73526-1-xiaoyao.li@intel.com>
 <20200416101509.73526-2-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416101509.73526-2-xiaoyao.li@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 16, 2020 at 06:15:07PM +0800, Xiaoyao Li wrote:
> To make it more clear that the flag means DRn (except DR7) need to be
> reloaded before vm entry.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 +-
>  arch/x86/kvm/x86.c              | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c7da23aed79a..f465c76e6e5a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -511,7 +511,7 @@ struct kvm_pmu_ops;
>  enum {
>  	KVM_DEBUGREG_BP_ENABLED = 1,
>  	KVM_DEBUGREG_WONT_EXIT = 2,
> -	KVM_DEBUGREG_RELOAD = 4,
> +	KVM_DEBUGREG_NEED_RELOAD = 4,

My vote would be for KVM_DEBUGREG_DIRTY  Any bit that is set switch_db_regs
triggers a reload, whereas I would expect a RELOAD flag to be set _every_
time a load is needed and thus be the only bit that's checked

>  };
>  
>  struct kvm_mtrr_range {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index de77bc9bd0d7..cce926658d10 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1067,7 +1067,7 @@ static void kvm_update_dr0123(struct kvm_vcpu *vcpu)
>  	if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)) {
>  		for (i = 0; i < KVM_NR_DB_REGS; i++)
>  			vcpu->arch.eff_db[i] = vcpu->arch.db[i];
> -		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_RELOAD;
> +		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_NEED_RELOAD;
>  	}
>  }
>  
> @@ -8407,7 +8407,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		set_debugreg(vcpu->arch.eff_db[2], 2);
>  		set_debugreg(vcpu->arch.eff_db[3], 3);
>  		set_debugreg(vcpu->arch.dr6, 6);
> -		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
> +		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_NEED_RELOAD;
>  	}
>  
>  	kvm_x86_ops.run(vcpu);
> @@ -8424,7 +8424,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		kvm_update_dr0123(vcpu);
>  		kvm_update_dr6(vcpu);
>  		kvm_update_dr7(vcpu);
> -		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
> +		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_NEED_RELOAD;

This is the path that I think would really benefit from DIRTY, it took me
several reads to catch that kvm_update_dr0123() will set RELOAD.

>  	}
>  
>  	/*
> -- 
> 2.20.1
> 
