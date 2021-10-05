Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E538D421EDB
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 08:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbhJEGcD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 02:32:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46334 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230526AbhJEGcB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 02:32:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633415410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+l1gGm3H8H2kSoCX1EAZuC99ZPIAIAV2RmbV9LINdQc=;
        b=glPBdfZnQo6N+uMDIcuw/hXhI4mzDE223AKHZGGgLwva+VNu1tWT6LqTEbfAgFMGUnt24p
        iz+LBtARvuHgEgDHiLHr1YJ5PW+oD/jl9jY9jocUGRjHHxcYhK9ou6265EiU5Q1+YH3qAg
        QQ4FGOkNjY/CBx9sy+MHakakyUlr5xM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-SZV_opfrNqajyiCtxwAm2w-1; Tue, 05 Oct 2021 02:30:08 -0400
X-MC-Unique: SZV_opfrNqajyiCtxwAm2w-1
Received: by mail-ed1-f69.google.com with SMTP id z6-20020a50cd06000000b003d2c2e38f1fso19612170edi.1
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 23:30:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+l1gGm3H8H2kSoCX1EAZuC99ZPIAIAV2RmbV9LINdQc=;
        b=4jCIJ1BeK4jaUhEgemAsecpOtEn4t2O9+veqpxOpawm+sO9jrehGqHYppE1M1ZEI9z
         iaIBjd3Pm05W7Ek9tm2HUt3qzugaxk8fHcnPq/VfMf0uYgkDIF28/1q2u7D8S728CDyh
         M5pTl2Zqx7YYruZT08g5DSgqidlzCUz5UWFFIwNRK5DpCrvy53lHUzexV1u7eArSBRY5
         G+hQW8D6aPvCvyLGD8tGhCaHM3l8ryWdDTHw2aNN5TgVmKBoR/DTwGPBRJqCyZWgSuYv
         jz+Ea9hF09681/lDCfNRf14qkIVzGc5ZgHwM27vmJYvDg9TDH7b1/spC2u5Yr/rAbLlu
         ZmXw==
X-Gm-Message-State: AOAM531lPC32f6ePK7sQ5fhd17+ZzPZmuMIhMnt/335VJB+D5atL5TXe
        G5tWBm4fCDPAbTEZRpkPJLzX/f3uTk/8lOKhm5MMhAy+m6ySVFDzznS3aWmDD9Kxe894kye6Nk4
        htv6sfMn9op7p
X-Received: by 2002:a17:907:2156:: with SMTP id rk22mr22868976ejb.64.1633415407675;
        Mon, 04 Oct 2021 23:30:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzyRTR0vwdSM5u3b9W2Rc9FvrTaQHxrX9AyFQUvvBAq3qZOvyJNIXpPOQxdXQmRsa2oyC7R2g==
X-Received: by 2002:a17:907:2156:: with SMTP id rk22mr22868953ejb.64.1633415407516;
        Mon, 04 Oct 2021 23:30:07 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id m13sm2156277eda.41.2021.10.04.23.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 23:30:06 -0700 (PDT)
Date:   Tue, 5 Oct 2021 08:30:04 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v8 3/8] KVM: arm64: Make a helper function to get nr of
 timer regs
Message-ID: <20211005063004.i2fwqoggglhdvtdb@gator.home>
References: <20210916181510.963449-1-oupton@google.com>
 <20210916181510.963449-4-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916181510.963449-4-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 16, 2021 at 06:15:05PM +0000, Oliver Upton wrote:
> Presently, the number of timer registers is constant. There may be
> opt-in behavior in KVM that exposes more timer registers to userspace.
> Prepare for the change by switching from a macro to a helper function to
> get the number of timer registers.
> 
> No functional change intended.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/guest.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 5ce26bedf23c..a13a79f5e0e2 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -588,7 +588,10 @@ static unsigned long num_core_regs(const struct kvm_vcpu *vcpu)
>   * ARM64 versions of the TIMER registers, always available on arm64
>   */
>  
> -#define NUM_TIMER_REGS 3
> +static inline unsigned long num_timer_regs(struct kvm_vcpu *vcpu)
> +{
> +	return 3;
> +}
>  
>  static bool is_timer_reg(u64 index)
>  {
> @@ -711,7 +714,7 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
>  	res += num_sve_regs(vcpu);
>  	res += kvm_arm_num_sys_reg_descs(vcpu);
>  	res += kvm_arm_get_fw_num_regs(vcpu);
> -	res += NUM_TIMER_REGS;
> +	res += num_timer_regs(vcpu);
>  
>  	return res;
>  }
> @@ -743,7 +746,7 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>  	ret = copy_timer_indices(vcpu, uindices);
>  	if (ret < 0)
>  		return ret;
> -	uindices += NUM_TIMER_REGS;
> +	uindices += num_timer_regs(vcpu);
>  
>  	return kvm_arm_copy_sys_reg_indices(vcpu, uindices);
>  }
> -- 
> 2.33.0.309.g3052b89438-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

