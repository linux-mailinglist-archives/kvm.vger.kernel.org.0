Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4424463F71
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 21:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343778AbhK3Ums (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 15:42:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234307AbhK3Ums (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 15:42:48 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A60DC061574
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 12:39:28 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 200so21138107pga.1
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 12:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fBpsUP5CKk7s0uj08S+UkM336obzKaZtMzyYiDf1hEY=;
        b=OfFDrf4VmCwLGLX2gfKWZDsNVEmSiSQJW8psXUnnxekGgpVN3NVbBDC+/kjNIT7/fP
         zSyPRIyayrzypfNcKKp4uZ+GnGzUQG5Q9S1aqNOfyWAWGX0q6IUQbY2E9YiZRLL0HWSs
         qLHJg/GzdAseFQEh9A8bpnRYCXrS+n7RJ0O3O6C+eSmgNT+5FY2ZkXPO7Tdv2CRiyIph
         Zx+OmKK+0cwXSJ5Oe47OnrDznManNTHHRZF8rFPvebPLD3MY5FNW58zsLBSdgwOsVH54
         5+30l/opb53A+3huptbU+5KNYNzlM7wZwF46yQyEBUfD+q5043eOBCDP5pdJPUnogjIl
         C8Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fBpsUP5CKk7s0uj08S+UkM336obzKaZtMzyYiDf1hEY=;
        b=0S72uKguJyfTAHhdd6FJVLOGloOmQ2LJkM2BrrkR6dwn3PZKyrdKLBce7XuMesIbdA
         hGZfcr/c7/uUH5loYD89/jii9kTUt7siREbWAE+qNdZ1UNjESb+dFJGx+G1UpGSPtiuV
         o2f5pi7b8iiPzW6l6+QpDcTiJ+IJSitnP0YAyThgeSnpqpD8JBUVpwbogDtwZIpGHAHt
         EggEUbkpUo1exbM6PUybdIKPdbjIUdiyDOEoCTbC1SILqx00QHk5BC9HVFaAxnOpz3i5
         c1k3J1K1lcaqnybvlNlpOA9uW+FlW37WFH49pp64rWD+NneUlI9V2k7IqBzecO4Ipaec
         Lo1g==
X-Gm-Message-State: AOAM533qUCABtRRDAsOSd2MGYJgva+RclLNfrfmsToN4OQxYCKjeCRUV
        0n8r3QdwFhZ0521Bo2l+8EeutQ==
X-Google-Smtp-Source: ABdhPJydBiJCdW+yjKkga6Nv7oxbzoVSFw2vGl/utAzNzOHiJc4lwvgc1LQyopdl0zVEHZDgS6CbPw==
X-Received: by 2002:a63:78c:: with SMTP id 134mr1179791pgh.373.1638304767990;
        Tue, 30 Nov 2021 12:39:27 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e10sm22543608pfv.140.2021.11.30.12.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 12:39:27 -0800 (PST)
Date:   Tue, 30 Nov 2021 20:39:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ignat Korchagin <ignat@cloudflare.com>
Subject: Re: [PATCH] KVM: ensure APICv is considered inactive if there is no
 APIC
Message-ID: <YaaL/Hh5pz3pydDY@google.com>
References: <20211130123746.293379-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211130123746.293379-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021, Paolo Bonzini wrote:
> kvm_vcpu_apicv_active() returns false if a virtual machine has no in-kernel
> local APIC, however kvm_apicv_activated might still be true if there are
> no reasons to disable APICv; in fact it is quite likely that there is none
> because APICv is inhibited by specific configurations of the local APIC
> and those configurations cannot be programmed.  This triggers a WARN:
> 
>    WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm) != kvm_vcpu_apicv_active(vcpu));
> 
> To avoid this, introduce another cause for APICv inhibition, namely the
> absence of an in-kernel local APIC.  This cause is enabled by default,
> and is dropped by either KVM_CREATE_IRQCHIP or the enabling of
> KVM_CAP_IRQCHIP_SPLIT.
> 
> Reported-by: Ignat Korchagin <ignat@cloudflare.com>
> Fixes: ee49a8932971 ("KVM: x86: Move SVM's APICv sanity check to common x86", 2021-10-22)
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0ee1a039b490..e0aa4dd53c7f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5740,6 +5740,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		smp_wmb();
>  		kvm->arch.irqchip_mode = KVM_IRQCHIP_SPLIT;
>  		kvm->arch.nr_reserved_ioapic_pins = cap->args[0];
> +		kvm_request_apicv_update(kvm, true, APICV_INHIBIT_REASON_ABSENT);
>  		r = 0;
>  split_irqchip_unlock:
>  		mutex_unlock(&kvm->lock);
> @@ -6120,6 +6121,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  		/* Write kvm->irq_routing before enabling irqchip_in_kernel. */
>  		smp_wmb();
>  		kvm->arch.irqchip_mode = KVM_IRQCHIP_KERNEL;
> +		kvm_request_apicv_update(kvm, true, APICV_INHIBIT_REASON_ABSENT);

Blech, kvm_request_apicv_update() is very counter-intuitive, true == clear. :-/
Wrappers along the lines of kvm_{set,clear}_apicv_inhibit() would help a lot, and
would likely avoid a handful of newlines as well.  I'll send a patch on top of this,
unless you want to do it while pushing this one out.

>  	create_irqchip_unlock:
>  		mutex_unlock(&kvm->lock);
>  		break;
> @@ -8818,10 +8820,9 @@ static void kvm_apicv_init(struct kvm *kvm)
>  {
>  	init_rwsem(&kvm->arch.apicv_update_lock);
>  
> -	if (enable_apicv)
> -		clear_bit(APICV_INHIBIT_REASON_DISABLE,
> -			  &kvm->arch.apicv_inhibit_reasons);
> -	else
> +	set_bit(APICV_INHIBIT_REASON_ABSENT,
> +		&kvm->arch.apicv_inhibit_reasons);

Nit, this one fits on a single line.

> +	if (!enable_apicv)
>  		set_bit(APICV_INHIBIT_REASON_DISABLE,
>  			&kvm->arch.apicv_inhibit_reasons);
>  }
> -- 
> 2.31.1
> 
