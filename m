Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB9034AD69
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 18:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhCZRcm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 13:32:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29389 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230239AbhCZRck (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 13:32:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616779959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R+aYrtsBqouThjH8W30TkibYfcdzDF4qsG1Hxwshnus=;
        b=FSTSrytx/w1Mbyhr6cQVum0jeXf6UbwbdC11wGpe7MluqAhPaFMnUI6ibdeuJO4Jn1RWD5
        8KPBcXthEH9T7YrpNr1mOzR27HntnUqS1x6UKgi8VW97juajoGV7yY6lWjtjYA+PtZllIw
        vngHO6AxXOts+gctT8Buv73bzQ8jySU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-PF-WIE9aOcilOrELeelN3g-1; Fri, 26 Mar 2021 13:32:37 -0400
X-MC-Unique: PF-WIE9aOcilOrELeelN3g-1
Received: by mail-ed1-f69.google.com with SMTP id p6so4762779edq.21
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 10:32:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R+aYrtsBqouThjH8W30TkibYfcdzDF4qsG1Hxwshnus=;
        b=YHatwc8M4+38bUgMKcisknowAp+YzWQZ0nmOD37SqRIwXtMitRT8G9QczdSqjpE10S
         HWDyPLx/ydg/+mdEAz8PcoZi2w/88bKPy+bYo8qLI3+joKKox5UZi63WfIBln/vmgMbb
         8LZQRdDufv05wWtILRzo/NGflLk5iVl0DwUphiCb17uc4g84CF350Ey3MVjpQIOrz9gx
         vJOK4HELAHd6KCSHmyFu6+EzavAMMzDxb2RuQsBL5fK/FePHB40ZSlreQbL2cSOrJncG
         ZcSkcQt+uq9/NDHufhFwHsyG0FQiw92rb9iOwlFzyVQRrKTbt3GtBQ0I/0JS7oVzMjvs
         2wMA==
X-Gm-Message-State: AOAM533NI8tPmQzYK5qmTBrMew8zGCZAqGyKezlqS7FigY3GXAVUS+nK
        hiTCSJAH3IQkuU1r4I6Bj4o4bqDZ2achRtc7A6BILa3Ia9VpA8z0/qnSp4Qnv8mxsGny+kj9oMV
        tPJwl1PK4HXqb
X-Received: by 2002:a05:6402:1d1a:: with SMTP id dg26mr16279938edb.266.1616779956293;
        Fri, 26 Mar 2021 10:32:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzp28xj1Sz9Vde2POZ3KLPQP2Ts9I3q9Ole7R+V/xujKPvZwc1QlNVd9+x+ip+ydD3eim4HZQ==
X-Received: by 2002:a05:6402:1d1a:: with SMTP id dg26mr16279928edb.266.1616779956161;
        Fri, 26 Mar 2021 10:32:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s6sm4072834ejx.83.2021.03.26.10.32.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 10:32:35 -0700 (PDT)
Subject: Re: [PATCH 1/4 v5] KVM: nSVM: If VMRUN is single-stepped, queue the
 #DB intercept in nested_svm_vmexit()
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20210323175006.73249-1-krish.sadhukhan@oracle.com>
 <20210323175006.73249-2-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fca2f20e-5be1-701f-32a7-33e262b90edb@redhat.com>
Date:   Fri, 26 Mar 2021 18:32:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210323175006.73249-2-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/03/21 18:50, Krish Sadhukhan wrote:
> According to APM, the #DB intercept for a single-stepped VMRUN must happen
> after the completion of that instruction, when the guest does #VMEXIT to
> the host. However, in the current implementation of KVM, the #DB intercept
> for a single-stepped VMRUN happens after the completion of the instruction
> that follows the VMRUN instruction. When the #DB intercept handler is
> invoked, it shows the RIP of the instruction that follows VMRUN, instead of
> of VMRUN itself. This is an incorrect RIP as far as single-stepping VMRUN
> is concerned.
> 
> This patch fixes the problem by checking, in nested_svm_vmexit(), for the
> condition that the VMRUN instruction is being single-stepped and if so,
> queues the pending #DB intercept so that the #DB is accounted for before
> we execute L1's next instruction.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oraacle.com>
> ---
>   arch/x86/kvm/svm/nested.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 35891d9a1099..713ce5cfb0db 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -720,6 +720,16 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>   	kvm_clear_exception_queue(&svm->vcpu);
>   	kvm_clear_interrupt_queue(&svm->vcpu);
>   
> +	/*
> +	 * If we are here following the completion of a VMRUN that
> +	 * is being single-stepped, queue the pending #DB intercept
> +	 * right now so that it an be accounted for before we execute
> +	 * L1's next instruction.
> +	 */
> +	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_VMRUN &&
> +	    svm->vmcb->save.rflags & X86_EFLAGS_TF))
> +		kvm_queue_exception(&(svm->vcpu), DB_VECTOR);
> +
>   	return 0;
>   }

Wouldn't the exit code always be SVM_EXIT_VMRUN after the vmcb01/vmcb02 
split?  I can take care of adding a WARN_ON myself, but I wouldn't mind 
if you checked that my reasoning is true. :)

Paolo

