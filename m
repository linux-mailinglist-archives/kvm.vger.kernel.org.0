Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760D639152F
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 12:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbhEZKmO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 06:42:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21562 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234143AbhEZKmF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 06:42:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622025629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XF/BazKXiXNlgziMQgx/Dti3zDbwJ16butXV+pnXF2s=;
        b=U13pTRVphmp+b1PupPNUPbaPaHEGywjn5PSBhRGaZU/lLYBWBuPxlwpu1OeV/MJb6vjA5s
        tZrg5cI0T7WGebscfDfTsPbWuolUaJczh9uMT5f48EcrjnILaKXzDgzUJFIsp1cDXQjdXs
        zWsG0xe6E1pYyQsF0NMH3iqL5pC+P3U=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-q159QY_pNKeznIla3IaEjw-1; Wed, 26 May 2021 06:40:27 -0400
X-MC-Unique: q159QY_pNKeznIla3IaEjw-1
Received: by mail-wr1-f70.google.com with SMTP id h104-20020adf90710000b029010de8455a3aso196514wrh.12
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 03:40:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=XF/BazKXiXNlgziMQgx/Dti3zDbwJ16butXV+pnXF2s=;
        b=KHJfyW24oNmSFOi03GpmbQXbmmHWaUwMCdoo2kUg3fi5dkMvx6PBSJvv4cWbyp1m87
         cn44zbi5FeQtzg9e8Hw0oxq/Vt1t9gAHj/r68dtgP4qGko3OhSu5FR/DyqiIkvora2+7
         GJeshWVY3IjybNyJ4jOvJLbGAIa350tuZ0CDzRxDOtqZ2LLPJchKqLtW/G7IGQKJfdyi
         7SHDP7/2rXD/AoQTiVx4tNLUiGSO74W+Hi4RgtMMRyw29lym3HNB8ZV2PJFVoM58KN8b
         H5P4g07Zl02Sd10fYOoINHeOEK4kMG2XWd8cvTrwUSYC6n1FQcplge/gfrv2UKW39W5p
         lGDA==
X-Gm-Message-State: AOAM533dLgHLCpHRjvCitygh2kB+16w5vPnCqEn66/OAWAa/z+Z1kswb
        wCdgQ+S35EyLbjS1kRKSDiNrvvd+JD3+PGbTnFNT5MiwH0CUBpflMQtQ3r7KmRB23pRYSX7OdCV
        R7iFxZ2c5of1/
X-Received: by 2002:a7b:c459:: with SMTP id l25mr27400208wmi.15.1622025626528;
        Wed, 26 May 2021 03:40:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJRDY+7pBJWWZ+LhgHL1/a13+iXUSEXsQRMJ2uzJBWgC0yaDRORJtPQbbw49SP0TH8qWwo8w==
X-Received: by 2002:a7b:c459:: with SMTP id l25mr27400191wmi.15.1622025626343;
        Wed, 26 May 2021 03:40:26 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v18sm23469437wro.18.2021.05.26.03.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 03:40:25 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Kechen Lu <kechenl@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/5] KVM: x86: Invert APICv/AVIC enablement check
In-Reply-To: <69697643ea2b5756fac99e7d87ef09c32c76f930.camel@redhat.com>
References: <20210518144339.1987982-1-vkuznets@redhat.com>
 <20210518144339.1987982-5-vkuznets@redhat.com>
 <69697643ea2b5756fac99e7d87ef09c32c76f930.camel@redhat.com>
Date:   Wed, 26 May 2021 12:40:24 +0200
Message-ID: <87zgwh7p7r.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Tue, 2021-05-18 at 16:43 +0200, Vitaly Kuznetsov wrote:
>> Now that APICv/AVIC enablement is kept in common 'enable_apicv' variable,
>> there's no need to call kvm_apicv_init() from vendor specific code.
>> 
>> No functional change intended.
>
> Minor nitpick: I don't see any invert here, but rather
> a unification of SVM/VMX virtual apic enablement code.
> Maybe update the subject a bit?

It is a bit umbiguous in v2, I agree (v1 used hooks in vendor-specific
code so instead of calling to vendor-neutral kvm_apicv_init() from
vendor-specific svm_vm_init()/vmx_vm_init(), we were calling
vendor-specific hooks from vendor-neutral kvm_apicv_init(), thus
'invert'. We can update the subject to something like

"KVM: x86: Drop vendor specific functions for APICv/AVIC enablement"

or something like that.

>
> For the code:
>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>

Thanks!

> Best regards,
> 	Maxim Levitsky
>
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h | 1 -
>>  arch/x86/kvm/svm/svm.c          | 1 -
>>  arch/x86/kvm/vmx/vmx.c          | 1 -
>>  arch/x86/kvm/x86.c              | 6 +++---
>>  4 files changed, 3 insertions(+), 6 deletions(-)
>> 
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index a2197fcf0e7c..bf5807d35339 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1662,7 +1662,6 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
>>  				struct x86_exception *exception);
>>  
>>  bool kvm_apicv_activated(struct kvm *kvm);
>> -void kvm_apicv_init(struct kvm *kvm, bool enable);
>>  void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
>>  void kvm_request_apicv_update(struct kvm *kvm, bool activate,
>>  			      unsigned long bit);
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 0d6ec34d1e4b..84f58e8b2f49 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -4438,7 +4438,6 @@ static int svm_vm_init(struct kvm *kvm)
>>  			return ret;
>>  	}
>>  
>> -	kvm_apicv_init(kvm, enable_apicv);
>>  	return 0;
>>  }
>>  
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 5e9ba10e9c2d..697dd54c7df8 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7000,7 +7000,6 @@ static int vmx_vm_init(struct kvm *kvm)
>>  			break;
>>  		}
>>  	}
>> -	kvm_apicv_init(kvm, enable_apicv);
>>  	return 0;
>>  }
>>  
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 23fdbba6b394..22a1e2b438c3 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -8345,16 +8345,15 @@ bool kvm_apicv_activated(struct kvm *kvm)
>>  }
>>  EXPORT_SYMBOL_GPL(kvm_apicv_activated);
>>  
>> -void kvm_apicv_init(struct kvm *kvm, bool enable)
>> +static void kvm_apicv_init(struct kvm *kvm)
>>  {
>> -	if (enable)
>> +	if (enable_apicv)
>>  		clear_bit(APICV_INHIBIT_REASON_DISABLE,
>>  			  &kvm->arch.apicv_inhibit_reasons);
>>  	else
>>  		set_bit(APICV_INHIBIT_REASON_DISABLE,
>>  			&kvm->arch.apicv_inhibit_reasons);
>>  }
>> -EXPORT_SYMBOL_GPL(kvm_apicv_init);
>>  
>>  static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
>>  {
>> @@ -10739,6 +10738,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>  	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
>>  	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
>>  
>> +	kvm_apicv_init(kvm);
>>  	kvm_hv_init_vm(kvm);
>>  	kvm_page_track_init(kvm);
>>  	kvm_mmu_init_vm(kvm);
>
>

-- 
Vitaly

