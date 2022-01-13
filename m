Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EBB48D4FA
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 10:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbiAMJ1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 04:27:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60202 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230094AbiAMJ1f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 04:27:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642066054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9u4mM8xpzGhQTXqNOSpCIuqLOs+p1DjaP1wP5fvTV0U=;
        b=IGTl/4ydkniQ6wNVIR+8qXrh4DokGBwHBSjS/Z8O7IWEezsanFv/U42DXxbHDHdfqLJSbS
        6jsH7jv+KV0POTu5D/aBgStNfZDfa4hqeZ28nG0nB6Yncu+C/PKrNcGKjl4KlEe9IreKn3
        FspqY313LyvosI2DmIZx0LAfrPQ3pjk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260-sCUn2xi-Msm3V8E4KL-4xw-1; Thu, 13 Jan 2022 04:27:33 -0500
X-MC-Unique: sCUn2xi-Msm3V8E4KL-4xw-1
Received: by mail-ed1-f72.google.com with SMTP id c8-20020a05640227c800b003fdc1684cdeso4826417ede.12
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 01:27:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9u4mM8xpzGhQTXqNOSpCIuqLOs+p1DjaP1wP5fvTV0U=;
        b=G122pEgQOzbI0leehErVsflJTOwSXwL6tOxVXVC5tMloSEcm2PtjXPEm0sAEKhtqsB
         BaaKZbyAmBMIHQn4XLbq2pQBxjhMYoCqH88c52gk24Zh3qoCqXtpUbSk3FyRjv3mebkz
         nqT7qxX215rguI5OTgK7jzRCUM7l/XJffUTj6VoONcY0SfUhfcXGu/1blbK4KMS4J8tz
         5LYV609lft/kLdhL3NlI31kL3LBaVCJpWDxKNSpqgEw6fX5StgynOWOaUq3i48TfWAER
         yHVLuvG5rLaaqYEg99na49SstI+9kQhlcT7pQI97xraBaDYM15p63iany+iWQ92+RX2V
         Lp+Q==
X-Gm-Message-State: AOAM5335Vrxnf8UGG+IYB0/DvRVCsZ4W3QRGtD0K3Hh4DQNo+VNvDWlM
        ief2868AWxhi1y/53vSZ36vOaE3AvkGh7366o0uG/HHUUCr8jaFqVwAGeSuD9+6VvPvnJSh6/Op
        wY0K1FRM/m+fK
X-Received: by 2002:a50:d74e:: with SMTP id i14mr3257719edj.243.1642066052534;
        Thu, 13 Jan 2022 01:27:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxknbT0PRuA/sllWl1GxiPU1rPaJrzQ/P32/YPeYZnMkI87/uDO/WsTaCwyYZr8gCuLccFgA==
X-Received: by 2002:a50:d74e:: with SMTP id i14mr3257708edj.243.1642066052360;
        Thu, 13 Jan 2022 01:27:32 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id oz31sm671867ejc.35.2022.01.13.01.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 01:27:31 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
In-Reply-To: <50136685-706e-fc6a-0a77-97e584e74f93@redhat.com>
References: <20211122175818.608220-1-vkuznets@redhat.com>
 <20211122175818.608220-3-vkuznets@redhat.com>
 <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
 <20211227183253.45a03ca2@redhat.com>
 <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com>
 <87mtkdqm7m.fsf@redhat.com> <20220103104057.4dcf7948@redhat.com>
 <875yr1q8oa.fsf@redhat.com>
 <ceb63787-b057-13db-4624-b430c51625f1@redhat.com>
 <87o84qpk7d.fsf@redhat.com> <877dbbq5om.fsf@redhat.com>
 <5505d731-cf87-9662-33f3-08844d92877c@redhat.com>
 <20220111090022.1125ffb5@redhat.com> <87fsptnjic.fsf@redhat.com>
 <50136685-706e-fc6a-0a77-97e584e74f93@redhat.com>
Date:   Thu, 13 Jan 2022 10:27:30 +0100
Message-ID: <87bl0gnfy5.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 1/12/22 14:58, Vitaly Kuznetsov wrote:
>> -	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
>> +	best = cpuid_entry2_find(entries, nent, 0xD, 1);
>>   	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
>>   		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>>   		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>>   
>> -	best = kvm_find_kvm_cpuid_features(vcpu);
>> +	best = __kvm_find_kvm_cpuid_features(vcpu, vcpu->arch.cpuid_entries,
>> +					     vcpu->arch.cpuid_nent);
>>   	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
>
> I think this should be __kvm_find_kvm_cpuid_features(vcpu, entries, nent).
>

Of course.

>> 
>> +		case 0x1:
>> +			/* Only initial LAPIC id is allowed to change */
>> +			if (e->eax ^ best->eax || ((e->ebx ^ best->ebx) >> 24) ||
>> +			    e->ecx ^ best->ecx || e->edx ^ best->edx)
>> +				return -EINVAL;
>> +			break;
>
> This XOR is a bit weird.  In addition the EBX test is checking the wrong 
> bits (it checks whether 31:24 change and ignores changes to 23:0).

Indeed, however, I've tested CPU hotplug with QEMU trying different
CPUs in random order and surprisingly othing blew up, feels like QEMU
was smart enough to re-use the right fd)

>
> You can write just "(e->ebx & ~0xff000000u) != (best->ebx ~0xff000000u)".
>
>> 
>> +		default:
>> +			if (e->eax ^ best->eax || e->ebx ^ best->ebx ||
>> +			    e->ecx ^ best->ecx || e->edx ^ best->edx)
>> +				return -EINVAL;
>
> This one even more so.

Thanks for the early review, I'm going to prepare a selftest and send
this out.

-- 
Vitaly

