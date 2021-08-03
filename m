Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4C33DE915
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 11:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbhHCJA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 05:00:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24858 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234539AbhHCJA0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 05:00:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627981215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LVqXIsUVPkAmIEU6PseU80EYvc3WZN9uakwdHdrpR3k=;
        b=i7XT4cgsLYRomXNfV65rgVpZO8MytsHwFAKIRg/Pq7Uaf23gACkwCxpSIkCPOY0OKM2Kci
        0xZqnkcnFd4VXR/fu82JPWmdYKyjjm8xzDDwYNKzK7ktf2ByYWZfCXP4aGBcUPXK/x8k0D
        ITwlcf7nZIz1NqiZSNQaB+qkdIQ3IGY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-xIrXutfjMJuFUXdRp35eqg-1; Tue, 03 Aug 2021 05:00:13 -0400
X-MC-Unique: xIrXutfjMJuFUXdRp35eqg-1
Received: by mail-wm1-f72.google.com with SMTP id f10-20020a7bcc0a0000b0290229a389ceb2so714808wmh.0
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 02:00:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LVqXIsUVPkAmIEU6PseU80EYvc3WZN9uakwdHdrpR3k=;
        b=Vyx9tkjQh30swOMAmsB6VNEhmgIpkjwRl7MhhgkWGADf1b0qcLU4XpEOLVvDj6mCAM
         MhfTHnTRvZy7O8ysb0SIBZL1o0bqbQ/ckqWRIWwUxBpsBjNR8Hx7iuZ3odp1GwlalQxx
         DgRrdz5QG5PAVYGqnX/oxOjMn/AtLJHkvxSe4dGE6DFRftCUob0a5QKtPRaRRcSBEhop
         WtVx2a98osFDGNwRbshSDFiJqOjLCHdqROQmfTw0QCezpBCJ9N6ATfmOcc4Xf94sC159
         aioh0jiKFV25AONZ2FOEBQscSabTsz0bFIUZ7vZ0lOoL2+PGbUgFOgmbHRm6NAKH5PG2
         B10Q==
X-Gm-Message-State: AOAM531X4nq5c8C8mAvLdS4ZZHenDEoroqaidCAW052iOk8QjZ9opSvO
        +k+V7wfEtVRnXrT8YZY/mAjKC9Djs1Tlhap2omKCRcxyfea6pionP+3S45QwmXNHpGo5HRClLWe
        yaAYW4s7lzycA
X-Received: by 2002:adf:c549:: with SMTP id s9mr22004720wrf.344.1627981212678;
        Tue, 03 Aug 2021 02:00:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGSwnssCAwc0Ow6DmuEHV78LU1+wCt8ow9LJryG6A57npdON9sg5XznQMCHAaQ6Yaefyl+BQ==
X-Received: by 2002:adf:c549:: with SMTP id s9mr22004682wrf.344.1627981212415;
        Tue, 03 Aug 2021 02:00:12 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id y66sm12796097wmy.39.2021.08.03.02.00.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 02:00:11 -0700 (PDT)
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
 <20210802183329.2309921-12-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 11/12] KVM: SVM: call avic_vcpu_load/avic_vcpu_put when
 enabling/disabling AVIC
Message-ID: <5a3b940b-7290-ca37-b3a4-bf01b7c4a6bb@redhat.com>
Date:   Tue, 3 Aug 2021 11:00:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210802183329.2309921-12-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/21 20:33, Maxim Levitsky wrote:
> @@ -651,6 +673,7 @@ void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>   	}
>   	vmcb_mark_dirty(vmcb, VMCB_AVIC);
>   
> +	__avic_set_running(vcpu, activated);
>   	svm_set_pi_irte_mode(vcpu, activated);
>   }
>   

I'd rather have calls to avic_vcpu_load/avic_vcpu_put directly inside 
the "if (activated)", and leaving avic_set_running to its current 
implementation.  That way you don't need __avic_set_running (which is a 
confusing name, because it does more than just setting the running bit).

>  void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>  {
> +	bool activate;
> +
>  	if (!lapic_in_kernel(vcpu))
>  		return;
>  
>  	mutex_lock(&vcpu->kvm->arch.apicv_update_lock);
>  
> -	vcpu->arch.apicv_active = kvm_apicv_activated(vcpu->kvm);
> +	activate = kvm_apicv_activated(vcpu->kvm);
> +	if (vcpu->arch.apicv_active == activate)
> +		goto out;
> +
> +	vcpu->arch.apicv_active = activate;
>  	kvm_apic_update_apicv(vcpu);
>  	static_call(kvm_x86_refresh_apicv_exec_ctrl)(vcpu);
>  
> @@ -9257,6 +9263,7 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>  	if (!vcpu->arch.apicv_active)
>  		kvm_make_request(KVM_REQ_EVENT, vcpu);
>  
> +out:
>  	mutex_unlock(&vcpu->kvm->arch.apicv_update_lock);
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);

Should this be a separate patch?

As an aside, we have

static inline bool kvm_vcpu_apicv_active(struct kvm_vcpu *vcpu)
{
         return vcpu->arch.apic && vcpu->arch.apicv_active;
}

but really vcpu->arch.apicv_active should never be true if 
vcpu->arch.apic is.  So it should be possible to change this to "return 
vcpu->arch.apicv_active" with a comment that the serialization between 
apicv_inhibit_reasons and apicv_active happens via apicv_update_lock.

Thanks,

Paolo

