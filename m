Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EB33D8DFD
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 14:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234847AbhG1MjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 08:39:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20242 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236209AbhG1MjN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 08:39:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627475951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HXNFbdahmDX+c177h6RZhsPMzBfLmavkz0YVrNVerOg=;
        b=g5C1ZfeiNil7yRL1bXQSEeloeWzM20/Hbg4Oo9JNKYAQ/yAWTF4PAZrJCj4LM4bF1VXQSJ
        aj0gRZqbli6nm5K5Sauohtl+v5xJnR+vvDAW+Ws+T6tOX3pXO4ots5t79oDz8RUbkv5q0K
        +ifHreUxPqC4jb1mQLGtq6F4vfkykZ4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-iS222AAtMWaFgykdZIMphA-1; Wed, 28 Jul 2021 08:39:10 -0400
X-MC-Unique: iS222AAtMWaFgykdZIMphA-1
Received: by mail-ed1-f70.google.com with SMTP id u25-20020aa7d8990000b02903bb6a903d90so1173045edq.17
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 05:39:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=HXNFbdahmDX+c177h6RZhsPMzBfLmavkz0YVrNVerOg=;
        b=qSfYjFY1KEiUbZ8LD9IfLI4LPXFak8PT1mnjHH7Xam55T/6saf8eFYMbXpLfgNMAXJ
         3wH+Sg0/2F2b/Q15Oe3qEo4yvczEjrh8Lc/CgtEM/UvZGsKUz8deJfKQGwPnDBEyM3W7
         Q69Pr1QoEQKP4rGPB1HNik2ZFWuf0wG/2mXuEmSInkW7xluRxOyAjnNbZADTMSFJosse
         CnzsrLX6rk4/XG/y+NBtHAayG/Yhza+Ji0fqI8qg5/eRMiPssANPNaLHuag/9Kxol77/
         TCKrveZqWggDk8yc2sxSx15Q0r+n6fe98EGOnKRBXpI2yOe4UM3Hjai9r6xsNurlsRAD
         gZAQ==
X-Gm-Message-State: AOAM530TwlyHKRI9HXwfj00onHwWx8qpxurTyrmfnCUibsPsnKMCqet0
        Rarga3vsFjGbVm52qodiySkmLKS6OWF+ddOmKe6ABozVSALQcojWB0se2+2+iPlQ1N02pp57ExP
        tFkS/c1PHx60rOD4aXuNVsbIZ3G2s7ujzIgX9Qlver5Y5G5Sz6erFGKs8qTXaUXmh
X-Received: by 2002:a17:906:a202:: with SMTP id r2mr26237803ejy.398.1627475949061;
        Wed, 28 Jul 2021 05:39:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzbqVneuxxswCi/3+V6VHw0Hz+FgePPtgokiB+Yl7UkLButBeC6ycb5jAkK2F0/tUIERx3kQ==
X-Received: by 2002:a17:906:a202:: with SMTP id r2mr26237779ejy.398.1627475948807;
        Wed, 28 Jul 2021 05:39:08 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t11sm1987292ejr.89.2021.07.28.05.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 05:39:08 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Exit to userspace when
 kvm_check_nested_events fails
In-Reply-To: <20210728115317.1930332-1-pbonzini@redhat.com>
References: <20210728115317.1930332-1-pbonzini@redhat.com>
Date:   Wed, 28 Jul 2021 14:39:07 +0200
Message-ID: <87o8am62ac.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> From: Jim Mattson <jmattson@google.com>
>
> If kvm_check_nested_events fails due to raising an
> EXIT_REASON_INTERNAL_ERROR, propagate it to userspace
> immediately, even if the vCPU would otherwise be sleeping.
> This happens for example when the posted interrupt descriptor
> points outside guest memory.
>
> Reported-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 348452bb16bc..916c976e99ab 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9752,10 +9752,14 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> -static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
> +static inline int kvm_vcpu_running(struct kvm_vcpu *vcpu)
>  {
> -	if (is_guest_mode(vcpu))
> -		kvm_check_nested_events(vcpu);
> +	int r;
> +	if (is_guest_mode(vcpu)) {
> +		r = kvm_check_nested_events(vcpu);
> +		if (r < 0 && r != -EBUSY)
> +			return r;
> +	}
>  
>  	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
>  		!vcpu->arch.apf.halted);
> @@ -9770,12 +9774,16 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
>  	vcpu->arch.l1tf_flush_l1d = true;
>  
>  	for (;;) {
> -		if (kvm_vcpu_running(vcpu)) {
> -			r = vcpu_enter_guest(vcpu);
> -		} else {
> -			r = vcpu_block(kvm, vcpu);
> +		r = kvm_vcpu_running(vcpu);
> +		if (r < 0) {
> +			r = 0;
> +			break;
>  		}
>  
> +		if (r)
> +			r = vcpu_enter_guest(vcpu);
> +		else
> +			r = vcpu_block(kvm, vcpu);
>  		if (r <= 0)
>  			break;

Shouldn't we also change kvm_arch_vcpu_runnable() and check
'kvm_vcpu_running() > 0' now?

-- 
Vitaly

