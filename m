Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E579A3DE91D
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 11:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbhHCJBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 05:01:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52812 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234831AbhHCJB3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 05:01:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627981278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pKHXn9wnTp9qRrDvUqHWpePjL7Y3hrbra/6xW/dla90=;
        b=i2GmHkTtKvwab5yr2VLy8d3OzP5Yu5366PdB8wBfuniNBbF4CcJWFwIpRHdD6Pi7HLI3Lw
        9QX5OAndZVmBFvEF3JeYfzatWiy57KkI7odUZ0yv+TEH+mmOmxjWYh2W2rz41rTPwXvdVx
        /cA5ikfkzWGKKLwbz1JAukXGJTixZME=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-3dIh2y_ONwqW3_Pe_WhmBQ-1; Tue, 03 Aug 2021 05:01:14 -0400
X-MC-Unique: 3dIh2y_ONwqW3_Pe_WhmBQ-1
Received: by mail-wr1-f69.google.com with SMTP id d7-20020adffd870000b02901544ea2018fso4229395wrr.10
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 02:01:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pKHXn9wnTp9qRrDvUqHWpePjL7Y3hrbra/6xW/dla90=;
        b=ENVYlfW0kggbSnP03Ea3uXmjl7zaCLGlZLvewmm2HwrbI+QJqkqaiTvq8v9xnIcJgr
         5xtsbOEHtvynE6x3pMxUP9e6RtncxgpDzOjFte7QJA5cph63w21txBNpL072dgIeG2ra
         3xXX/YWSgEM26DF246PWrBuo6I0tlbLs4O2m5wfyDqQ/g8D3RMxFox+24gNE5fcEVnA9
         xKkhlKTXCNi55uT4J+eRmDn1H92Gegrf99j9smOGdhEnEsFpAZybZpxfCTGkchFQSZ3L
         T8cqhXQIeUSRQLC/yaM/iGq0y1IRB5qeFWg7t8u8umUxIGSV0loP6Ck0Nm29/QNOveTJ
         +9ng==
X-Gm-Message-State: AOAM530LPVocrsHsKsJgTaHOC9sGiK0kUpZLA2tSuCch+ArG9cDmJ4jJ
        y8XuHz7ftq0NdrIxPzwqij8QwPFTNMG0mBrddcok7fary/ToUG3gDgMWBP+85cVkk636NySzjUF
        RxgD+nx6hw8EP
X-Received: by 2002:a1c:46c4:: with SMTP id t187mr3244030wma.64.1627981273321;
        Tue, 03 Aug 2021 02:01:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSMW8XDmM6IKA3v4gzcbw7RQQimpJW2BqmCZ8OTl1PXZEjUdI1YetIiIV7wNFHI9aSeYjXEg==
X-Received: by 2002:a1c:46c4:: with SMTP id t187mr3244005wma.64.1627981273140;
        Tue, 03 Aug 2021 02:01:13 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id a16sm14072483wrx.7.2021.08.03.02.01.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 02:01:12 -0700 (PDT)
Subject: Re: [PATCH v3 09/12] KVM: x86: hyper-v: Deactivate APICv only when
 AutoEOI feature is in use
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20210802183329.2309921-1-mlevitsk@redhat.com>
 <20210802183329.2309921-10-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4209384b-68f3-a0d2-24da-3b047422f114@redhat.com>
Date:   Tue, 3 Aug 2021 11:01:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210802183329.2309921-10-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/21 20:33, Maxim Levitsky wrote:
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> APICV_INHIBIT_REASON_HYPERV is currently unconditionally forced upon
> SynIC activation as SynIC's AutoEOI is incompatible with APICv/AVIC. It is,
> however, possible to track whether the feature was actually used by the
> guest and only inhibit APICv/AVIC when needed.
> 
> TLFS suggests a dedicated 'HV_DEPRECATING_AEOI_RECOMMENDED' flag to let
> Windows know that AutoEOI feature should be avoided. While it's up to
> KVM userspace to set the flag, KVM can help a bit by exposing global
> APICv/AVIC enablement.
> 
> Maxim:
>     - always set HV_DEPRECATING_AEOI_RECOMMENDED in kvm_get_hv_cpuid,
>       since this feature can be used regardless of AVIC
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  3 +++
>   arch/x86/kvm/hyperv.c           | 27 +++++++++++++++++++++------
>   2 files changed, 24 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 80323b5fb20a..55b1f79d9c43 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -988,6 +988,9 @@ struct kvm_hv {
>   	/* How many vCPUs have VP index != vCPU index */
>   	atomic_t num_mismatched_vp_indexes;
>   
> +	/* How many SynICs use 'AutoEOI' feature */
> +	atomic_t synic_auto_eoi_used;
> +
>   	struct hv_partition_assist_pg *hv_pa_pg;
>   	struct kvm_hv_syndbg hv_syndbg;
>   };
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index b07592ca92f0..638f3c559623 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -88,6 +88,10 @@ static bool synic_has_vector_auto_eoi(struct kvm_vcpu_hv_synic *synic,
>   static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
>   				int vector)
>   {
> +	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
> +	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
> +	int auto_eoi_old, auto_eoi_new;
> +
>   	if (vector < HV_SYNIC_FIRST_VALID_VECTOR)
>   		return;
>   
> @@ -96,10 +100,25 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
>   	else
>   		__clear_bit(vector, synic->vec_bitmap);
>   
> +	auto_eoi_old = bitmap_weight(synic->auto_eoi_bitmap, 256);
> +
>   	if (synic_has_vector_auto_eoi(synic, vector))
>   		__set_bit(vector, synic->auto_eoi_bitmap);
>   	else
>   		__clear_bit(vector, synic->auto_eoi_bitmap);
> +
> +	auto_eoi_new = bitmap_weight(synic->auto_eoi_bitmap, 256);
> +
> +	/* Hyper-V SynIC auto EOI SINTs are not compatible with APICV */
> +	if (!auto_eoi_old && auto_eoi_new) {
> +		if (atomic_inc_return(&hv->synic_auto_eoi_used) == 1)
> +			kvm_request_apicv_update(vcpu->kvm, false,
> +						APICV_INHIBIT_REASON_HYPERV);
> +	} else if (!auto_eoi_new && auto_eoi_old) {
> +		if (atomic_dec_return(&hv->synic_auto_eoi_used) == 0)
> +			kvm_request_apicv_update(vcpu->kvm, true,
> +						APICV_INHIBIT_REASON_HYPERV);
> +	}
>   }
>   
>   static int synic_set_sint(struct kvm_vcpu_hv_synic *synic, int sint,
> @@ -933,12 +952,6 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
>   
>   	synic = to_hv_synic(vcpu);
>   
> -	/*
> -	 * Hyper-V SynIC auto EOI SINT's are
> -	 * not compatible with APICV, so request
> -	 * to deactivate APICV permanently.
> -	 */
> -	kvm_request_apicv_update(vcpu->kvm, false, APICV_INHIBIT_REASON_HYPERV);
>   	synic->active = true;
>   	synic->dont_zero_synic_pages = dont_zero_synic_pages;
>   	synic->control = HV_SYNIC_CONTROL_ENABLE;
> @@ -2466,6 +2479,8 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>   				ent->eax |= HV_X64_ENLIGHTENED_VMCS_RECOMMENDED;
>   			if (!cpu_smt_possible())
>   				ent->eax |= HV_X64_NO_NONARCH_CORESHARING;
> +
> +			ent->eax |= HV_DEPRECATING_AEOI_RECOMMENDED;
>   			/*
>   			 * Default number of spinlock retry attempts, matches
>   			 * HyperV 2016.
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

