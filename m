Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2531C791E
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 20:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730336AbgEFSPW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 14:15:22 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29555 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728619AbgEFSPW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 14:15:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588788920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M/zgi2QQ+ixKejHOwxk33Ty4brlBd5cVgSGtrAKnrNI=;
        b=Z82V9aJj1PZP9dOFu4CHTxi2ARKzZOOts3NgzUgomVsJ7yepMRTwYN7nw/l/IO8zWUcVZY
        avwZQ8z/kX+MaSKi7ymOohZWGgnAn53mIgS88VfmmSf/XCFvadtvDpZKJYqrW7rHpNuxxq
        RyxcWqzX75kOxaA2tQyOkQbWL2XFlRs=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-C5aG2zJ6MRKd6phSI6T-Rw-1; Wed, 06 May 2020 14:15:18 -0400
X-MC-Unique: C5aG2zJ6MRKd6phSI6T-Rw-1
Received: by mail-qk1-f197.google.com with SMTP id v6so2710647qkd.9
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 11:15:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M/zgi2QQ+ixKejHOwxk33Ty4brlBd5cVgSGtrAKnrNI=;
        b=Dki90Z7Pc1ovjjrpMZCFuIcjKuPyposa7L6iHOnfz1rrEoqtY9a+Wg2oKk76vt/deB
         R+baBEcUQrvtD5L657240+0yZyiW2y2MI4ibrJlg3h4KMi89k5POsYdfJPndGn8tlqe7
         RP3O4K5jBPnyRNd50giA+pKKtb+jkEgYfqmZfBYvO2LcjDVovn2dbBZXdcvtiu8Kq4KI
         Fy/CNtsMmgThyIlk6/bISIyb73XbGfKm6np5JBzvAyeKS+m3N/CKSVbNgqThJ3ogtzyf
         VWFEtDmQv2s/FQMwmGu8jxqUcvjd2MZJ9sCjAIocPLVDzeWScDcGBEzRdNRxEqH87jmn
         26vg==
X-Gm-Message-State: AGi0PuZ6r74wEI0qqkgnXB3HQJO26BCOGSysqs8lkD37TADU+52CzV2J
        KFWEjeXQq/HXP6wgOyIXO6pprQBsK/zkSOQlyp6E7JlgLXoz8XvPAOtYhDwBNtX/LzbuHCoaGRi
        phl3Fy7/J5YCc
X-Received: by 2002:ac8:4983:: with SMTP id f3mr9597771qtq.343.1588788917689;
        Wed, 06 May 2020 11:15:17 -0700 (PDT)
X-Google-Smtp-Source: APiQypJW1+DqjuH0lrn1uApD5QkOPt/q7xg6r+BNI2dRwnKQ6nFWyQi3Z3A8i4vCstvFOg7FpEJbqQ==
X-Received: by 2002:ac8:4983:: with SMTP id f3mr9597730qtq.343.1588788917372;
        Wed, 06 May 2020 11:15:17 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id n13sm2189987qtf.15.2020.05.06.11.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 11:15:16 -0700 (PDT)
Date:   Wed, 6 May 2020 14:15:15 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 8/9] KVM: x86, SVM: do not clobber guest DR6 on
 KVM_EXIT_DEBUG
Message-ID: <20200506181515.GR6299@xz-x1>
References: <20200506111034.11756-1-pbonzini@redhat.com>
 <20200506111034.11756-9-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200506111034.11756-9-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 06, 2020 at 07:10:33AM -0400, Paolo Bonzini wrote:
> On Intel, #DB exceptions transmit the DR6 value via the exit qualification
> field of the VMCS, and the exit qualification only contains the description
> of the precise event that caused a vmexit.
> 
> On AMD, instead the DR6 field of the VMCB is filled in as if the #DB exception
> was to be injected into the guest.  This has two effects when guest debugging
> is in use:
> 
> * the guest DR6 is clobbered
> 
> * the kvm_run->debug.arch.dr6 field can accumulate more debug events, rather
> than just the last one that happened.
> 
> Fortunately, if guest debugging is in use we debug register reads and writes
> are always intercepted.  Now that the guest DR6 is always synchronized with
> vcpu->arch.dr6, we can just run the guest with an all-zero DR6 while guest
> debugging is enabled, and restore the guest value when it is disabled.  This
> fixes both problems.
> 
> A testcase for the second issue is added in the next patch.

Is there supposed to be another test after this one, or the GD test?

> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c |  2 ++
>  arch/x86/kvm/x86.c     | 12 ++++++++----
>  arch/x86/kvm/x86.h     |  2 ++
>  3 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f03bffafd9e6..29dc7311dbb1 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1750,6 +1750,8 @@ static int db_interception(struct vcpu_svm *svm)
>  		kvm_run->exit_reason = KVM_EXIT_DEBUG;
>  		kvm_run->debug.arch.dr6 = svm->vmcb->save.dr6;
>  		kvm_run->debug.arch.dr7 = svm->vmcb->save.dr7;

[1]

> +		/* This restores DR6 to all zeros.  */
> +		kvm_update_dr6(vcpu);

I feel like it won't work as expected for KVM_GUESTDBG_SINGLESTEP, because at
[2] below it'll go to the "else" instead so dr6 seems won't be cleared in that
case.

Another concern I have is that, I mostly read kvm_update_dr6() as "apply the
dr6 memory cache --> VMCB".  I'm worried this might confuse people (at least I
used quite a few minutes to digest...) here because latest data should already
be in the VMCB.

Also, IMHO it would be fine to have invalid dr6 values during
KVM_SET_GUEST_DEBUG.  I'm not sure whether my understanding is correct, but I
see KVM_SET_GUEST_DEBUG needs to override the in-guest debug completely.  If we
worry about dr6 being incorrect after KVM_SET_GUEST_DEBUG is disabled, IMHO we
can reset dr6 in kvm_arch_vcpu_ioctl_set_guest_debug() properly before we
return the debug registers to the guest.

PS. I cannot see above lines [1] in my local tree (which seems to be really a
bugfix...).  I tried to use kvm/queue just in case I missed some patches, but I
still didn't see them.  So am I reading the wrong tree here?

Thanks,

>  		kvm_run->debug.arch.pc =
>  			svm->vmcb->save.cs.base + svm->vmcb->save.rip;
>  		kvm_run->debug.arch.exception = DB_VECTOR;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f4254d716b10..1b5e0fc346bb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -104,7 +104,6 @@ static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
>                                      KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
>  
>  static void update_cr8_intercept(struct kvm_vcpu *vcpu);
> -static void kvm_update_dr6(struct kvm_vcpu *vcpu);
>  static void process_nmi(struct kvm_vcpu *vcpu);
>  static void enter_smm(struct kvm_vcpu *vcpu);
>  static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
> @@ -1048,10 +1047,14 @@ static void kvm_update_dr0123(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> -static void kvm_update_dr6(struct kvm_vcpu *vcpu)
> +void kvm_update_dr6(struct kvm_vcpu *vcpu)
>  {
> -	if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) &&
> -	    kvm_x86_ops.set_dr6)
> +	if (!kvm_x86_ops.set_dr6)
> +		return;
> +
> +	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)

[2]

> +		kvm_x86_ops.set_dr6(vcpu, DR6_FIXED_1 | DR6_RTM);
> +	else
>  		kvm_x86_ops.set_dr6(vcpu, vcpu->arch.dr6);
>  }
>  
> @@ -9154,6 +9157,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  		for (i = 0; i < KVM_NR_DB_REGS; i++)
>  			vcpu->arch.eff_db[i] = vcpu->arch.db[i];
>  	}
> +	kvm_update_dr6(vcpu);
>  	kvm_update_dr7(vcpu);
>  
>  	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index b968acc0516f..a4c950ad4d60 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -240,6 +240,8 @@ static inline bool kvm_vcpu_latch_init(struct kvm_vcpu *vcpu)
>  	return is_smm(vcpu) || kvm_x86_ops.apic_init_signal_blocked(vcpu);
>  }
>  
> +void kvm_update_dr6(struct kvm_vcpu *vcpu);
> +
>  void kvm_set_pending_timer(struct kvm_vcpu *vcpu);
>  void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
>  
> -- 
> 2.18.2
> 
> 

-- 
Peter Xu

