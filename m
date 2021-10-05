Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129024227FE
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 15:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235078AbhJENgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 09:36:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27346 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234964AbhJENgs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 09:36:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633440898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f66jq9s7AStKUyKZZVEZqhv66J5ngEqYwoHoMEH8w+A=;
        b=RnBytloDoT+kncxdWdaxQGTaQHVmQ/ckG+z1LQ/UO1AUt6mWfBag79FQWjIQjgph2u6Gsc
        YDbPvrXfaJ3sGhpln7NBnJ8ZV749NzqeEsbz4m6tqxps7MsN/L6gNhp08L8XC7dsCeBfEK
        u/fQcDSUBxgEOvfgBV+rNoaC1b9cBPU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-FLY4vVyWOAici4HPVP0_ng-1; Tue, 05 Oct 2021 09:34:57 -0400
X-MC-Unique: FLY4vVyWOAici4HPVP0_ng-1
Received: by mail-ed1-f72.google.com with SMTP id r21-20020a50c015000000b003db1c08edd3so831701edb.15
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 06:34:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f66jq9s7AStKUyKZZVEZqhv66J5ngEqYwoHoMEH8w+A=;
        b=iE5qGclBNc/6U3/QHUu4rSON/aoPHVGX4A//S/ogmCtT8jjDM4wZyQDkzlEC19OYVG
         mcBwNCoQGxs4IZTsPwsbM9lh35q5dvRevZhg4KL97O15Z7x+v2UlsxSG/ai5bJ0ZNL11
         /hcV8/A8fCSlmPtaIoi1Yvt0fWM5gNVUwUnndKzm7O0A26mD4jjwso/TzuMjjPb99rFa
         ugEhNuC8HcH+6A6h8kt41dPwvf60hRdf6BxcBbiNyfV5cXdhB+0YM9dhBYgvv3GIUpfY
         QRP2JwgJIl7TMHU0FJU2U5F85WOyda9quwzWs3fHy7nO8sbHAi1Z8IaaR86dw0IX3KVZ
         CJSA==
X-Gm-Message-State: AOAM533v06oKw1Vq9c+OVuv+4OfFpmEocac5x0i/B1SE+/RPtl4UKBn+
        i/nx4U0JoMKUI6VE9A+hHFVgBCB12yAmJ+gAu2EvPXrSPcM47BYvGGEgCXxDE1Fzs+/4GDtQS69
        ewSWti8H6NCBy
X-Received: by 2002:a05:6402:141:: with SMTP id s1mr26328127edu.317.1633440896158;
        Tue, 05 Oct 2021 06:34:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydXTEJ/zRmP0xlonD8tRFF80Bntkf7CsDT18a72UqthZAFNFgH3eVa2yk0Rf30igZ2SO+7YQ==
X-Received: by 2002:a05:6402:141:: with SMTP id s1mr26328105edu.317.1633440895979;
        Tue, 05 Oct 2021 06:34:55 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id b5sm8729431edu.13.2021.10.05.06.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 06:34:55 -0700 (PDT)
Date:   Tue, 5 Oct 2021 15:34:53 +0200
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
Subject: Re: [PATCH v2 04/11] KVM: arm64: Rename the KVM_REQ_SLEEP handler
Message-ID: <20211005133453.f7h2yrnicaducrbn@gator.home>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-5-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923191610.3814698-5-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 07:16:03PM +0000, Oliver Upton wrote:
> The naming of the kvm_req_sleep function is confusing: the function
> itself sleeps the vCPU, it does not request such an event. Rename the
> function to make its purpose more clear.
> 
> No functional change intended.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/arm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index fe102cd2e518..3d4acd354f94 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -649,7 +649,7 @@ void kvm_arm_resume_guest(struct kvm *kvm)
>  	}
>  }
>  
> -static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
> +static void kvm_vcpu_sleep(struct kvm_vcpu *vcpu)
>  {
>  	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
>  
> @@ -679,7 +679,7 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
>  {
>  	if (kvm_request_pending(vcpu)) {
>  		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
> -			vcpu_req_sleep(vcpu);
> +			kvm_vcpu_sleep(vcpu);
>  
>  		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
>  			kvm_reset_vcpu(vcpu);
> -- 
> 2.33.0.685.g46640cef36-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

