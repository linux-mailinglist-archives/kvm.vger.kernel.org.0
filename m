Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B0D4084FD
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 08:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237481AbhIMGyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 02:54:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32191 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237470AbhIMGyu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Sep 2021 02:54:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631516014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FeM9VbeOZW6Q8YpmpSes2OU2n8QPVYH3Vzvp3bUiPm4=;
        b=U99SUxXSMyZJDX54jD9mo5zGDCZD2M9Q2ZPVhuFJj3IRT/hG8GBURHy7cZuadUhaH5S+Tm
        QP+aSFH7xMD0flKN+LrOTr88I2pc5T3FrzczgjJy9hD5p9k7q06kKJfeGC3GqxZxN5lHiW
        sWMdYA18cW6pdnIi+4WAcLs3V/Nir8I=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-i0aEninbNxOWq00q6Ase3A-1; Mon, 13 Sep 2021 02:53:33 -0400
X-MC-Unique: i0aEninbNxOWq00q6Ase3A-1
Received: by mail-ej1-f71.google.com with SMTP id ar17-20020a170907265100b005eff65b9184so1055737ejc.21
        for <kvm@vger.kernel.org>; Sun, 12 Sep 2021 23:53:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=FeM9VbeOZW6Q8YpmpSes2OU2n8QPVYH3Vzvp3bUiPm4=;
        b=gOrG/JxIjAgUNztna1x7nsTOmp5EjdNIxqSgRx2GYytUif4zjEot2WLQBlLoD38Nxn
         HrZIyrKC8uylpZZb27u/1Qsca4rXF/ZveAOvy1Tm0c/0qx+c/uW2M1d5iHZXyflBLg3s
         blvU/zO97PDjwOxHhU7p/dNf/TxBNPtzoSuAO7tJccNiwG4AsgLkmMF+xyux+pvMYbF/
         NkcwRt7FsD5fEVFC3eKNQ97KJEF6kjvar7bO5r0RplTk/2CeFwOHMOeOZQ7HdDHcWmU3
         SvftFsKkrhwcKQYJCDBZhOG1vLR/CZfrD9qBPGHx4UVEPrJy3r0WMCSNR9lSS6M/thq4
         HYIA==
X-Gm-Message-State: AOAM5335SXl5dyNDuDfOE53BN7Uen4/ASFMhQN2imegrODIr9b+1u23c
        vJPOFEsJ1BLwumN9xb0trcoXZ828HxuB5Bi/mOjOH9wnsEGFjsI0JgisTvIb++2E7jcwpdv5++C
        mEkdmmZWpHycj
X-Received: by 2002:aa7:c3cb:: with SMTP id l11mr11609227edr.310.1631516012329;
        Sun, 12 Sep 2021 23:53:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUGigNc+sq3gVdCwC4TFvas+vjbm9v+f5pAbfSRWMoSLIan1K0j0zN3DtoLbuM+ZVuamppSw==
X-Received: by 2002:aa7:c3cb:: with SMTP id l11mr11609214edr.310.1631516012101;
        Sun, 12 Sep 2021 23:53:32 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id eg14sm3418082edb.64.2021.09.12.23.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 23:53:31 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
In-Reply-To: <6424b309216b276e46a66573320b3eed8209a0ed.camel@redhat.com>
References: <20210910160633.451250-1-vkuznets@redhat.com>
 <20210910160633.451250-2-vkuznets@redhat.com>
 <6424b309216b276e46a66573320b3eed8209a0ed.camel@redhat.com>
Date:   Mon, 13 Sep 2021 08:53:33 +0200
Message-ID: <87lf412cgi.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Fri, 2021-09-10 at 18:06 +0200, Vitaly Kuznetsov wrote:
>> When KVM runs as a nested hypervisor on top of Hyper-V it uses Enlightened
>> VMCS and enables Enlightened MSR Bitmap feature for its L1s and L2s (which
>> are actually L2s and L3s from Hyper-V's perspective). When MSR bitmap is
>> updated, KVM has to reset HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP from
>> clean fields to make Hyper-V aware of the change. For KVM's L1s, this is
>> done in vmx_disable_intercept_for_msr()/vmx_enable_intercept_for_msr().
>> MSR bitmap for L2 is build in nested_vmx_prepare_msr_bitmap() by blending
>> MSR bitmap for L1 and L1's idea of MSR bitmap for L2. KVM, however, doesn't
>> check if the resulting bitmap is different and never cleans
>> HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP in eVMCS02. This is incorrect and
>> may result in Hyper-V missing the update.
>> 
>> The issue could've been solved by calling evmcs_touch_msr_bitmap() for
>> eVMCS02 from nested_vmx_prepare_msr_bitmap() unconditionally but doing so
>> would not give any performance benefits (compared to not using Enlightened
>> MSR Bitmap at all). 3-level nesting is also not a very common setup
>> nowadays.
>> 
>> Don't enable 'Enlightened MSR Bitmap' feature for KVM's L2s (real L3s) for
>> now.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/vmx/vmx.c | 22 +++++++++++++---------
>>  1 file changed, 13 insertions(+), 9 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 0c2c0d5ae873..ae470afcb699 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -2654,15 +2654,6 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
>>  		if (!loaded_vmcs->msr_bitmap)
>>  			goto out_vmcs;
>>  		memset(loaded_vmcs->msr_bitmap, 0xff, PAGE_SIZE);
>> -
>> -		if (IS_ENABLED(CONFIG_HYPERV) &&
>> -		    static_branch_unlikely(&enable_evmcs) &&
>> -		    (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {
>> -			struct hv_enlightened_vmcs *evmcs =
>> -				(struct hv_enlightened_vmcs *)loaded_vmcs->vmcs;
>> -
>> -			evmcs->hv_enlightenments_control.msr_bitmap = 1;
>> -		}
>>  	}
>>  
>>  	memset(&loaded_vmcs->host_state, 0, sizeof(struct vmcs_host_state));
>> @@ -6861,6 +6852,19 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>>  	}
>>  
>>  	vmx->loaded_vmcs = &vmx->vmcs01;
>> +
>> +	/*
>> +	 * Use Hyper-V 'Enlightened MSR Bitmap' feature when KVM runs as a
>> +	 * nested (L1) hypervisor and Hyper-V in L0 supports it.
>> +	 */
>> +	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs)
>> +	    && (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {
>> +		struct hv_enlightened_vmcs *evmcs =
>> +			(struct hv_enlightened_vmcs *)vmx->loaded_vmcs->vmcs;
>> +
>> +		evmcs->hv_enlightenments_control.msr_bitmap = 1;
>> +	}
>> +
>>  	cpu = get_cpu();
>>  	vmx_vcpu_load(vcpu, cpu);
>>  	vcpu->cpu = cpu;
>
> Makes sense.
>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>
>
> However, just a note that it is very very confusing that KVM can use eVMCS in both ways.
>  
>  
> 'Client': It can both run under HyperV, and thus take advantage of eVMCS when it runs its guests (with
> help of
> HyperV)
>  
> 'Server' KVM can emulate some HyperV features, and one of these is eVMCS, thus a windows guest running
> under KVM, can use KVM's eVMCS implementation to run nested guests.
>  
> This patch fails under
> 'Client', while the other patches in the series fall under the 'Server' category,
> and even more confusing, the patch 2 moves 'Client' code around, but it is intended for following patches
> 3,4 which are
> for Server.
>  

All this is confusing indeed, KVM-on-Hyper-V and Hyper-V-on-KVM are two
different beasts but it's not always clear from patch subject. I was
thinking about adding this to patch prexes:

"KVM: VMX: KVM-on-Hyper-V: ... " 
"KVM: nVMX: Hyper-V-on-KVM ..."

or something similar.

>
> Thus this patch probably should be a separate patch, just to avoid confusion.
>

This patch is a weird one. We actually fix

Hyper-V-on-KVM-on-Hyper-V case.

Don't get confused! :-)


> However, since this patch series is already posted, and I figured that out, and hopefully explained it here,
> no need to do anything though!
>
>
> Best regards,
> 	Maxim Levitsky
>
>
>

-- 
Vitaly

