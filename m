Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332B3422806
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 15:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbhJENhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 09:37:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53681 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234170AbhJENhL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 09:37:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633440920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KfaTPPXNWS5AUY7/4WlVqX2CS7teeff8sBrzhkV3hmE=;
        b=MUUtykAeU8iMVrXx3Eq5r6+lHOI4GboXbmfsI68Cz9zZy+3pTWyzaFniOAevhK7UG9cEV+
        7rdr0omPcF12XsBibPMA+ssnDvJRZ/0jrhCzZDVVIBccO+Adr/UrZP7uWl62ZMrOy1Mldm
        LFxKEPjwlGIfq1MxgqMrEJoEs2gCPOo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-bRYac1RaPlK31qnHFuM2BA-1; Tue, 05 Oct 2021 09:35:19 -0400
X-MC-Unique: bRYac1RaPlK31qnHFuM2BA-1
Received: by mail-ed1-f72.google.com with SMTP id d11-20020a50cd4b000000b003da63711a8aso20581853edj.20
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 06:35:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KfaTPPXNWS5AUY7/4WlVqX2CS7teeff8sBrzhkV3hmE=;
        b=j0zUPhgaXRNDcwVwrEn1Z7i53koKs9FvRdPbeE2JtLa8Ej3tI4vds24i/jVQ5Y2XDw
         wsO/ySxDh7xC9aI3TkACr2nLHg36FO3qkc8AX7i1MmTMx0UJOYrjH+06vNcdFW0zGcTw
         XFd/DLD7iVt+BbOfXf69HaooBmHMDk8bu9q8XrKImDsKOD5PDIyWukAE/76cndYSqsBV
         Dtc8pG3EUW6W9wc8kmls2cxRL3XbODZwLoLQDdqPhuA+r0C9LroIYDGAISnRHQD8uHN8
         rubl2R62/LhgreSd02N+z+ULTB4DZXtCpxm8Jlbxe5CLgrArGHGcSDDmvgJbc9YCT2No
         qztw==
X-Gm-Message-State: AOAM533SQ7GYcyOiblv47HGXaghC6ER1OxCwPqpVBwcROKMc9pp2VGJ9
        TmOJeuFTq5qvVMapp+jrJcIH4F0hYNDAYEfcuGRo2b4Fi5TVDg3BgTDWtUDFDehvLpz55epBPbP
        6tfttDsLDr1wP
X-Received: by 2002:aa7:d7d2:: with SMTP id e18mr4790232eds.126.1633440918087;
        Tue, 05 Oct 2021 06:35:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxP127jOwYiacxXnSzlc5ipHSpvkJtRpDUiBKA4dWOl5i+2EpfWMjN92eHE+tejZxGKeqgIA==
X-Received: by 2002:aa7:d7d2:: with SMTP id e18mr4790205eds.126.1633440917888;
        Tue, 05 Oct 2021 06:35:17 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id q23sm3690738ejr.0.2021.10.05.06.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 06:35:17 -0700 (PDT)
Date:   Tue, 5 Oct 2021 15:35:15 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 03/11] KVM: arm64: Encapsulate reset request logic in
 a helper function
Message-ID: <20211005133515.nj6erqoct65esbb6@gator.home>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-4-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923191610.3814698-4-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 07:16:02PM +0000, Oliver Upton wrote:
> In its implementation of the PSCI function, KVM needs to request that a
> target vCPU resets before its next entry into the guest. Wrap the logic
> for requesting a reset in a function for later use by other implemented
> PSCI calls.
> 
> No functional change intended.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/psci.c | 59 +++++++++++++++++++++++++------------------
>  1 file changed, 35 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 310b9cb2b32b..bb59b692998b 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -64,9 +64,40 @@ static inline bool kvm_psci_valid_affinity(unsigned long affinity)
>  	return !(affinity & ~MPIDR_HWID_BITMASK);
>  }
>  
> -static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> +static void kvm_psci_vcpu_request_reset(struct kvm_vcpu *vcpu,
> +					unsigned long entry_addr,
> +					unsigned long context_id,
> +					bool big_endian)
>  {
>  	struct vcpu_reset_state *reset_state;
> +
> +	lockdep_assert_held(&vcpu->kvm->lock);
> +
> +	reset_state = &vcpu->arch.reset_state;
> +	reset_state->pc = entry_addr;
> +
> +	/* Propagate caller endianness */
> +	reset_state->be = big_endian;
> +
> +	/*
> +	 * NOTE: We always update r0 (or x0) because for PSCI v0.1
> +	 * the general purpose registers are undefined upon CPU_ON.
> +	 */
> +	reset_state->r0 = context_id;
> +
> +	WRITE_ONCE(reset_state->reset, true);
> +	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> +
> +	/*
> +	 * Make sure the reset request is observed if the change to
> +	 * power_state is observed.
> +	 */
> +	smp_wmb();
> +	vcpu->arch.power_off = false;
> +}
> +
> +static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> +{
>  	struct kvm *kvm = source_vcpu->kvm;
>  	struct kvm_vcpu *vcpu = NULL;
>  	unsigned long cpu_id;
> @@ -90,29 +121,9 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>  			return PSCI_RET_INVALID_PARAMS;
>  	}
>  
> -	reset_state = &vcpu->arch.reset_state;
> -
> -	reset_state->pc = smccc_get_arg2(source_vcpu);
> -
> -	/* Propagate caller endianness */
> -	reset_state->be = kvm_vcpu_is_be(source_vcpu);
> -
> -	/*
> -	 * NOTE: We always update r0 (or x0) because for PSCI v0.1
> -	 * the general purpose registers are undefined upon CPU_ON.
> -	 */
> -	reset_state->r0 = smccc_get_arg3(source_vcpu);
> -
> -	WRITE_ONCE(reset_state->reset, true);
> -	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> -
> -	/*
> -	 * Make sure the reset request is observed if the change to
> -	 * power_state is observed.
> -	 */
> -	smp_wmb();
> -
> -	vcpu->arch.power_off = false;
> +	kvm_psci_vcpu_request_reset(vcpu, smccc_get_arg2(source_vcpu),
> +				    smccc_get_arg3(source_vcpu),
> +				    kvm_vcpu_is_be(source_vcpu));
>  	kvm_vcpu_wake_up(vcpu);
>  
>  	return PSCI_RET_SUCCESS;
> -- 
> 2.33.0.685.g46640cef36-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

