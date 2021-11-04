Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1BF445A8E
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 20:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhKDT3I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 15:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbhKDT3D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 15:29:03 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C04C061203
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 12:26:25 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id p18so8871767plf.13
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 12:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iFvVeSw9/fNfFhF8w5RW8u1ZTOCr6KgIVUquXNVljmQ=;
        b=MBwtJQ8asknVhP2+o1B5c3yheNnRFKD+wjpfslR3BsI6hFURrv3JQdtk+X8YoPbPz5
         iJtKniC9k6k89FF8h8zeU0xGPD6nyhcdMNu6gur03prppcjUnTsO1UNI4OR+OK0LfhJi
         HVU9t1WlpSNK0i2K1s40bFL7aQHi4Us0pQjAXgQhLFHsiBAxd7/TghyalxC9Yf8ibnLJ
         ql34Cp2+/sYkD4inR71yVK/fvFDUzUBfoNPKFda5jM04/YHzWcLN+KrMgWf2MVXien34
         i0tQzegACcgsfPv6TcrMJk1PLCPNaY/FXEvcex01oarXyKO8G75IjFQeuvJBWJlRqznH
         oh0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iFvVeSw9/fNfFhF8w5RW8u1ZTOCr6KgIVUquXNVljmQ=;
        b=dDjQJRrzOhGG4A+DyZlhw3+by2s3AKk7BQ1HcOXIpOW8YRnEcbKrJIXdATtLFaKbiy
         RjTTx1MImCfBAlCJsnKdb1SsuuEatYRPUUzfeDmqGZrVe0UQ8bGOZH7gK9JXTjWM+tQ9
         FWBNnJC0mnZ7KIAHLEs+tstImg2n4EJVJWKXKH4umDAZIzF5s6cEX2sgL025utidjzJc
         9VMks5Pbbp2WiWnzhT4bHBvKt6xpLc/T9+sR0uTgFYK+5JFnq06lzoAF/QOhCcXGeEnX
         70lypJ8LD31umceTnhr6vlR9ijTut9SSOdO0Am1Keet0cqp3QHKHNFSRVfLmJOBeM6+E
         tUpA==
X-Gm-Message-State: AOAM5326zd9KHompW/+yWx5H/VPNOc2BZvpfpUDYDoaTxAXvwhRI9uSp
        CEYjvA1Yzj4J8TKaOa1qQ9/Kvg==
X-Google-Smtp-Source: ABdhPJyL3j/EOk+u0py3awzqsb0atapF72NUEteR3hVzCzrUy5Xj9dvRsAPhGEPoblaXMDqUKX1MbQ==
X-Received: by 2002:a17:90b:4b46:: with SMTP id mi6mr24236208pjb.168.1636053984901;
        Thu, 04 Nov 2021 12:26:24 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x9sm4374244pga.28.2021.11.04.12.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 12:26:24 -0700 (PDT)
Date:   Thu, 4 Nov 2021 19:26:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v3] KVM: x86: inhibit APICv when KVM_GUESTDBG_BLOCKIRQ
 active
Message-ID: <YYQz3E/eNxdnNwBj@google.com>
References: <20211103143929.15264-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103143929.15264-1-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 03, 2021, Maxim Levitsky wrote:
> KVM_GUESTDBG_BLOCKIRQ relies on interrupts being injected using
> standard kvm's inject_pending_event, and not via APICv/AVIC.
> 
> Since this is a debug feature, just inhibit APICv/AVIC while
> KVM_GUESTDBG_BLOCKIRQ is in use on at least one vCPU.

Very clever!

> Fixes: 61e5f69ef0837 ("KVM: x86: implement KVM_GUESTDBG_BLOCKIRQ")
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---

With the below nits resolved (tested on Intel w/ APICv):

Reviewed-and-tested-by: Sean Christopherson <seanjc@google.com>

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ac83d873d65b0..5d30cea58182e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10703,6 +10703,25 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
>  	return ret;
>  }
>  
> +static void kvm_arch_vcpu_guestdbg_update_apicv_inhibit(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu = NULL;

vcpu doesn't need to be initialized.

> +	int i;

Nit, I'd prefer we use reverse fir tree when it's convenient, i.e.

	bool block_irq_used = false;
	struct kvm_vcpu *vcpu;
	int i;

> +	bool block_irq_used = false;
> +
> +	down_write(&kvm->arch.apicv_update_lock);
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (vcpu->guest_debug & KVM_GUESTDBG_BLOCKIRQ) {
> +			block_irq_used = true;
> +			break;
> +		}
> +	}
> +	__kvm_request_apicv_update(kvm, !block_irq_used,
> +					       APICV_INHIBIT_REASON_BLOCKIRQ);

Heh, this indentation is still messed up, I think you need to change your

	if (r == -ENOCOFFEE)
		maxim_get_coffee();

to

	while (r == -ENOCOFFEE)
		r = maxim_get_coffee();

> +	up_write(&kvm->arch.apicv_update_lock);
> +}
> +
>  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  					struct kvm_guest_debug *dbg)
>  {
> @@ -10755,6 +10774,8 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  
>  	static_call(kvm_x86_update_exception_bitmap)(vcpu);
>  
> +	kvm_arch_vcpu_guestdbg_update_apicv_inhibit(vcpu->kvm);
> +
>  	r = 0;
>  
>  out:
> -- 
> 2.26.3
> 
