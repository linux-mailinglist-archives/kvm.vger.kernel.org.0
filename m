Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA927204E69
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 11:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732155AbgFWJuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 05:50:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33774 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731996AbgFWJuO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 05:50:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592905813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YUWKpAA/Hhk4UI8s/nEYBc1/Nwq36zCGzOCK051Tg9w=;
        b=Lb6jeYSkvpeUL2skWQyWgQ3AmbIgCM2pzyYm1OxtHOmuc6KMGZvpwWXLdkg4IHtbgA2Iac
        o7MJ2MNAXfBDRt6JKQyKM/ZqKT2HTixhnqInpWBkFQB6/OahYSOxpi6WG5v7A98RkHquxv
        nXc8sPt2mdAA8HidYt8IemuJZergvPc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-15kkmHBUPYS4nVU4d1PuAw-1; Tue, 23 Jun 2020 05:50:11 -0400
X-MC-Unique: 15kkmHBUPYS4nVU4d1PuAw-1
Received: by mail-wr1-f71.google.com with SMTP id o25so12794143wro.16
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 02:50:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YUWKpAA/Hhk4UI8s/nEYBc1/Nwq36zCGzOCK051Tg9w=;
        b=PI8c84m9W7oXDP16seRo3B4IVqLYz9pqzT3LSWfxGFZ28t7VDXtxxVEefmpJ0FBaBe
         u+iTD2LPW0RLZe10k8CdDIKPAgzawNocP/Lba76TB2RpunYA3LtFTt9jOiCk2zA2ohXD
         jS0fcDMdZCnn6KtyMjPY7f4Fo9paBhWMMExShRNp0cT7lRj+qXRD2d5hoLWssEDTT74L
         sCR41JTFM1Nne2rldjfqT+wdBlqAkR5u4u/mt8oLB+EN9eJz/HRpmLQ3wst23jd6Ancd
         +Rh/eV/D7QKrqJItuwNFpAlKRKBFWf8DikjR49vsZrdoPvzXCaUUf9XzQHSheisNrBWe
         lfAQ==
X-Gm-Message-State: AOAM530TEf7aXN5N1e6SJO7TBP5iXf1lnWpf5kGMzm+ZHC9euO0eBlQ/
        DYumJ4elG2pRB11wL9y/BVVptRvenV2GyLkigr/cCY6qVKoaWbOugw//NA2CfJg906kpUcbsJOX
        L6AUraRDpOopn
X-Received: by 2002:a05:6000:18c:: with SMTP id p12mr25626928wrx.66.1592905810047;
        Tue, 23 Jun 2020 02:50:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxekMM2DbqF5WADhrGxqod6OIVEnPVOq+j2KwNGmFCSXAEV4K6MeVmfhgj8xr0dwyao5yUbmA==
X-Received: by 2002:a05:6000:18c:: with SMTP id p12mr25626902wrx.66.1592905809756;
        Tue, 23 Jun 2020 02:50:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:24f5:23b:4085:b879? ([2001:b07:6468:f312:24f5:23b:4085:b879])
        by smtp.gmail.com with ESMTPSA id 67sm22498925wrk.49.2020.06.23.02.50.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 02:50:09 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Fix MSR range of APIC registers in X2APIC mode
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200616073307.16440-1-xiaoyao.li@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <daf1fe8b-dcaf-5008-aa3f-ab8b1b538414@redhat.com>
Date:   Tue, 23 Jun 2020 11:50:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200616073307.16440-1-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/06/20 09:33, Xiaoyao Li wrote:
> Only MSR address range 0x800 through 0x8ff is architecturally reserved
> and dedicated for accessing APIC registers in x2APIC mode.
> 
> Fixes: 0105d1a52640 ("KVM: x2apic interface to lapic")
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 00c88c2f34e4..29d9b078ce69 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2856,7 +2856,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		return kvm_mtrr_set_msr(vcpu, msr, data);
>  	case MSR_IA32_APICBASE:
>  		return kvm_set_apic_base(vcpu, msr_info);
> -	case APIC_BASE_MSR ... APIC_BASE_MSR + 0x3ff:
> +	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
>  		return kvm_x2apic_msr_write(vcpu, msr, data);
>  	case MSR_IA32_TSCDEADLINE:
>  		kvm_set_lapic_tscdeadline_msr(vcpu, data);
> @@ -3196,7 +3196,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_IA32_APICBASE:
>  		msr_info->data = kvm_get_apic_base(vcpu);
>  		break;
> -	case APIC_BASE_MSR ... APIC_BASE_MSR + 0x3ff:
> +	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
>  		return kvm_x2apic_msr_read(vcpu, msr_info->index, &msr_info->data);
>  	case MSR_IA32_TSCDEADLINE:
>  		msr_info->data = kvm_get_lapic_tscdeadline_msr(vcpu);
> 

Queued, thanks (with Cc to stable).

Paolo

