Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4692A3CD63E
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 15:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240855AbhGSNRq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 09:17:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55893 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239491AbhGSNRo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Jul 2021 09:17:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626703103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FSsNgc3FXhuejogM0XmHxCm/t5uymckMKilt3/jtVjE=;
        b=LBJoo111WkdNq4kX+FiyckXeFIfvqZChFcWLKgVpERzohJS+8ESKdQvYGSQGTrZZVLLwuC
        ketZ/srUsoDC4KGGsmkh8RfpgRpdxAbB+cTIG+6xveQpo+byYhyaplbNCYqfo+CDap/1kz
        JUp7F7o2vwMs8QBtM5N+Ju/ygfcTM9M=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-GWzAH96_NfCgC7DdqksnMw-1; Mon, 19 Jul 2021 09:58:21 -0400
X-MC-Unique: GWzAH96_NfCgC7DdqksnMw-1
Received: by mail-ed1-f71.google.com with SMTP id m21-20020a50ef150000b029039c013d5b80so9351393eds.7
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 06:58:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FSsNgc3FXhuejogM0XmHxCm/t5uymckMKilt3/jtVjE=;
        b=dn9kR0QSsxBLiWJ3RyiyfZaDVy5U7NUmgx/wPdIusxOiiuf3C1cjU07DQ+JsDg5xDf
         xlHv0tSHfC2il/I20usSVza0lpZXlwrqWIUHwGcNxGtDOVq/QFa7SslKlFdtWIYlRWtn
         fGxn4lbQqypdAzzNzCxvHdMeBIKxo4SZ3SY6QjAcDnNcT65fHV+18ry3N+/InlWk1xP0
         +MkqXsx/zh7T/yKQR3DPV3ORAn4DiJYA5RPud+pEtX03pXN6gviWFR6mKJNMaJEG/8p0
         w0HFzT8mLSFZRfnsTz+EV0uyx1HsW2zswEy4gBEongM0flKm2uryVhW2XqCFUJEHMkGl
         2mLw==
X-Gm-Message-State: AOAM531RI83oQWnhDNVrEZC1MTJp6Jl09Sz9k0dZ7Ad9Kccc8k9gYJLK
        jm84VJk31qtzmltQg7WiAapX1ZDDNlZogUxahGF7pNprbztD4Nmxkq/TIaYKamhIhkcc/f3I6ks
        9SL9Fbk0K97OW
X-Received: by 2002:a05:6402:2023:: with SMTP id ay3mr34167632edb.383.1626703100290;
        Mon, 19 Jul 2021 06:58:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIiBMkJCG+7kHw1x23QFkhVPEbxFPTSRMNCVaGeZjkxFgUpOTi0ES9PudobYB8AKEiA0gqqw==
X-Received: by 2002:a05:6402:2023:: with SMTP id ay3mr34167600edb.383.1626703100099;
        Mon, 19 Jul 2021 06:58:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id a5sm7793388edj.20.2021.07.19.06.58.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 06:58:19 -0700 (PDT)
Subject: Re: [PATCH 6/6] KVM: VMX: enable IPI virtualization
To:     Zeng Guang <guang.zeng@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
References: <20210716064808.14757-1-guang.zeng@intel.com>
 <20210716064808.14757-7-guang.zeng@intel.com>
 <8aed2541-082d-d115-09ac-e7fcc05f96dc@redhat.com>
 <89f240cb-cb3a-c362-7ded-ee500cc12dc3@intel.com>
 <0d6f7852-95b3-d628-955b-f44d88a86478@redhat.com>
 <949abcb7-5f24-2107-a089-5e6c1bee8cf2@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <223af27a-2412-40f6-f4a6-e0a662041855@redhat.com>
Date:   Mon, 19 Jul 2021 15:58:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <949abcb7-5f24-2107-a089-5e6c1bee8cf2@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/07/21 14:38, Zeng Guang wrote:
>> Understood, but in practice all uses of vmx->ipiv_active are
>> guarded by kvm_vcpu_apicv_active so they are always reached with
>> vmx->ipiv_active == enable_ipiv.
>> 
>> The one above instead seems wrong and should just use enable_ipiv.
> 
> enable_ipiv associate with "IPI virtualization" setting in tertiary
> exec controls and enable_apicv which depends on cpu_has_vmx_apicv().
> kvm_vcpu_apicv_active still can be false even if enable_ipiv is true,
> e.g. in case irqchip not emulated in kernel.

Right, kvm_vcpu_apicv_active *is* set in init_vmcs.  But there's an 
     "if (kvm_vcpu_apicv_active(&vmx->vcpu))" above.  You can just stick

	if (enable_ipicv)
		install_pid(vmx);

inside there.  As to the other occurrences of vmx->ipiv_active, look here:

> +	if (!kvm_vcpu_apicv_active(vcpu))
> +		return;
> +
> +	if ((!kvm_arch_has_assigned_device(vcpu->kvm) ||
> +		!irq_remapping_cap(IRQ_POSTING_CAP)) &&
> +		!to_vmx(vcpu)->ipiv_active)
>  		return;
>  

This one can be enable_ipiv because APICv must be active.

> +	if (!kvm_vcpu_apicv_active(vcpu))
> +		return 0;
> +
> +	/* Put vCPU into a list and set NV to wakeup vector if it is
> +	 * one of the following cases:
> +	 * 1. any assigned device is in use.
> +	 * 2. IPI virtualization is enabled.
> +	 */
> +	if ((!kvm_arch_has_assigned_device(vcpu->kvm) ||
> +		!irq_remapping_cap(IRQ_POSTING_CAP)) && !to_vmx(vcpu)->ipiv_active)
>  		return 0;

This one can be !enable_ipiv because APICv must be active.

> 
> @@ -3870,6 +3877,8 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu, u8 mode)
>  		vmx_enable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_TMCCT), MSR_TYPE_RW);
>  		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
>  		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
> +		vmx_set_intercept_for_msr(vcpu, X2APIC_MSR(APIC_ICR),
> +				MSR_TYPE_RW, !to_vmx(vcpu)->ipiv_active);
>  	}
>  }

Is inside "if (mode & MSR_BITMAP_MODE_X2APIC_APICV)" so APICv must be 
activ; so it can be enable_ipiv as well.

In conclusion, you do not need vmx->ipiv_active.

Paolo

