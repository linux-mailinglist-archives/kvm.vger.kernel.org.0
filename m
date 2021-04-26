Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC7836B011
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 10:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbhDZI6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 04:58:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48254 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232103AbhDZI6S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 04:58:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619427450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xrtgnm/L0WtusbYF9SuDZ+pYt9hjB7RMvd0KmtVIh7o=;
        b=OtR+TGKCg4S/PVJ8lQwYlY2Sqd4gYCMUQxm7WJ+ReO3P5NMQGDfSjM7r/rP0JM9BpWW6Yp
        hsKn0jxcqVpd0wbBm1x7Aur2UfUQS2b+gmTg8TfDDXo/ucMCYDtrkYGkKImEwLMRMeFyUZ
        MS9kpfEG3Mug2vZzvNIn03UGEintzi8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-lc9phzwHMWSYfjpeuizqxA-1; Mon, 26 Apr 2021 04:57:28 -0400
X-MC-Unique: lc9phzwHMWSYfjpeuizqxA-1
Received: by mail-ej1-f70.google.com with SMTP id q21-20020a170906a095b029038718807866so937989ejy.19
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 01:57:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xrtgnm/L0WtusbYF9SuDZ+pYt9hjB7RMvd0KmtVIh7o=;
        b=lYcvPkqL36/5Ux6j55pOJYtmZbiHN0TCg9NtIz957JAo494TuEIaXGOACUxnPQfYHo
         1wOsQoCet6A0/akX9shxzy7j+pAogkIZ6zzaew1UmOZIGIPinhzY1E1tProobVm8nTuQ
         06QxYE5xfFrSnW51AEh1LusKeGcXEB85tC9+t17ugy2s1QaeZojkd4Bd5JapPELg2XbZ
         j0UkYIym9Eo+YqDFK/NhqSOGAMAN82SR4hUeRV5wtAS12RQVK1+XjecDMxpwDmBIpgaj
         ZzAP5bD7kxUP73QuQHKKv/vpBtvOaKTKWLu3hQ2D6v5H0CLIkMrweYVlQY3VkdJljXhN
         j2gQ==
X-Gm-Message-State: AOAM5336sVSCl18oQ/b8TlB0kyZ02yBpZgm4FJdxOb8wyYlz1mcAZk39
        hAYT6N2lAUda2EiMLHyu+2sbgiR/3rgdIEbWZ/GruTet/OZ/i2vO6Cj45eyTNE3Beo2V0kOic8s
        7brUemCyV8Tic
X-Received: by 2002:aa7:d3c2:: with SMTP id o2mr11080386edr.111.1619427447086;
        Mon, 26 Apr 2021 01:57:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy5MzhdKNnSR2VHJq899bCvKAXx3Od/AUHphWB11TckcK76RF4SdIk9cZ4VNU+wCPmi6XCfvA==
X-Received: by 2002:aa7:d3c2:: with SMTP id o2mr11080371edr.111.1619427446916;
        Mon, 26 Apr 2021 01:57:26 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o8sm10956335ejm.18.2021.04.26.01.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 01:57:26 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v3 2/4] KVM: SVM: Clear MSR_TSC_AUX[63:32] on write
In-Reply-To: <20210423223404.3860547-3-seanjc@google.com>
References: <20210423223404.3860547-1-seanjc@google.com>
 <20210423223404.3860547-3-seanjc@google.com>
Date:   Mon, 26 Apr 2021 10:57:26 +0200
Message-ID: <87k0opfmo9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Force clear bits 63:32 of MSR_TSC_AUX on write to emulate current AMD
> CPUs, which completely ignore the upper 32 bits, including dropping them
> on write.  Emulating AMD hardware will also allow migrating a vCPU from
> AMD hardware to Intel hardware without requiring userspace to manually
> clear the upper bits, which are reserved on Intel hardware.
>
> Presumably, MSR_TSC_AUX[63:32] are intended to be reserved on AMD, but
> sadly the APM doesn't say _anything_ about those bits in the context of
> MSR access.  The RDTSCP entry simply states that RCX contains bits 31:0
> of the MSR, zero extended.  And even worse is that the RDPID description
> implies that it can consume all 64 bits of the MSR:
>
>   RDPID reads the value of TSC_AUX MSR used by the RDTSCP instruction
>   into the specified destination register. Normal operand size prefixes
>   do not apply and the update is either 32 bit or 64 bit based on the
>   current mode.
>
> Emulate current hardware behavior to give KVM the best odds of playing
> nice with whatever the behavior of future AMD CPUs happens to be.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 9ed9c7bd7cfd..71d704f8d569 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2904,8 +2904,17 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		 * direct_access_msrs.  Doing that would require a rdmsr in
>  		 * svm_vcpu_put.
>  		 */
> -		svm->tsc_aux = data;
>  		wrmsrl(MSR_TSC_AUX, svm->tsc_aux);

Hm, shouldn't this be 

wrmsrl(MSR_TSC_AUX, data) or wrmsrl(MSR_TSC_AUX, (u32)data)

then? As svm->tsc_aux wasn't updated yet.

> +
> +		/*
> +		 * Per Intel's SDM, bits 63:32 are reserved, but AMD's APM has
> +		 * incomplete and conflicting architectural behavior.  Current
> +		 * AMD CPUs completely ignore bits 63:32, i.e. they aren't
> +		 * reserved and always read as zeros.  Emulate AMD CPU behavior
> +		 * to avoid explosions if the vCPU is migrated from an AMD host
> +		 * to an Intel host.
> +		 */
> +		svm->tsc_aux = (u32)data;

Actually, shouldn't we just move wrmsrl() here? Assuming we're not sure
how (and if) upper 32 bits are going to be used, it would probably make
sense to not write them to the actual MSR...

>  		break;
>  	case MSR_IA32_DEBUGCTLMSR:
>  		if (!boot_cpu_has(X86_FEATURE_LBRV)) {

-- 
Vitaly

