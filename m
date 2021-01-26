Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393FE30418C
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 16:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406058AbhAZPHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 10:07:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54374 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406113AbhAZPGz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 10:06:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611673528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xs14Pz1Mq5FTHwPzuFvyU/rHvTdWdEjaMGXPw3VcyzI=;
        b=fhG3+E2auH56bXTf0tWNx8b5Lnkq4ob+fx51ba/sOwHkUiMiW719/kiElyhFiGbNvsKcOI
        1GhCUeQaThAMOAEiRrgQvisYR750NLK/WZgm15ZdTuHpn3+L/DSJgy8MjgjsqWLpQpMMmv
        j3S9X1KKuHsUgxSEDFA1FlCDCVPKNbA=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-gXhaxydqNCKD3x9-Orr8OQ-1; Tue, 26 Jan 2021 10:05:26 -0500
X-MC-Unique: gXhaxydqNCKD3x9-Orr8OQ-1
Received: by mail-oi1-f199.google.com with SMTP id b124so4104598oif.15
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 07:05:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xs14Pz1Mq5FTHwPzuFvyU/rHvTdWdEjaMGXPw3VcyzI=;
        b=dtX8Sp+kSAoYouU50GJ6vxeSkIdwGhswMKvRPk1isAsdh8e8Qrb54rr43JURq8SoNV
         TZ59yCxqu1WqA+54ZU0GJ/pWtp/pQ/hn21PaR5KriNMguG19BbEwMera151RQNX9MAlC
         e3uijXlUkxKp4hGfHNiiKlqAgJW2QKnzAtDdbeqcZjSFMt27EIeV3AEsc6duU9iiVHuC
         hI4GyMx8c5xNbvKUH9V8LDh12YUw5YNS0goRXALsQD6c/AVH2bUqe+NRQ8xall+qHZJ/
         H7XqkItv2yezHZbZ1icvOohUZU8K+vK7o/oU9SrtNxks0QwkK7THcryf1ePkFiFEVMVZ
         U4Yg==
X-Gm-Message-State: AOAM533oRIQ6DadZE2VNOK1NiqmGUoRsQPQmQoDgN0b/r+kYXmJ9YESM
        cRnY9+gef81xzfpAYs8c0zi84ueHRKTCyrleac1onKaxqvRfWEOHaBtqjfmXuKaKMiONaU68Vuc
        xU8on/GSm/quQ
X-Received: by 2002:a05:6808:a09:: with SMTP id n9mr75648oij.26.1611673525915;
        Tue, 26 Jan 2021 07:05:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyamxSOGkosVTZAPozfdk59s0vMHPoPqsvHNSyOUyLqzfFV2cKUPpAWmmkZ2dYRfOBx0JV2Og==
X-Received: by 2002:a05:6808:a09:: with SMTP id n9mr75621oij.26.1611673525705;
        Tue, 26 Jan 2021 07:05:25 -0800 (PST)
Received: from [192.168.1.38] (cpe-70-113-46-183.austin.res.rr.com. [70.113.46.183])
        by smtp.gmail.com with ESMTPSA id f6sm691379ote.28.2021.01.26.07.05.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 07:05:24 -0800 (PST)
From:   Wei Huang <wehuang@redhat.com>
X-Google-Original-From: Wei Huang <wei.huang2@amd.com>
Subject: Re: [PATCH v3 0/4] Handle #GP for SVM execution instructions
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        mlevitsk@redhat.com, seanjc@google.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, luto@amacapital.net
References: <20210126081831.570253-1-wei.huang2@amd.com>
 <3349e153-83ae-3c55-ee88-2036b2ce38d8@redhat.com>
Message-ID: <4b72ebd1-ace8-f03c-2e53-1c4ece0b17d8@amd.com>
Date:   Tue, 26 Jan 2021 09:05:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <3349e153-83ae-3c55-ee88-2036b2ce38d8@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/26/21 5:39 AM, Paolo Bonzini wrote:
> On 26/01/21 09:18, Wei Huang wrote:
>> While running SVM related instructions (VMRUN/VMSAVE/VMLOAD), some AMD
>> CPUs check EAX against reserved memory regions (e.g. SMM memory on host)
>> before checking VMCB's instruction intercept. If EAX falls into such
>> memory areas, #GP is triggered before #VMEXIT. This causes unexpected #GP
>> under nested virtualization. To solve this problem, this patchset makes
>> KVM trap #GP and emulate these SVM instuctions accordingly.
>>
>> Also newer AMD CPUs will change this behavior by triggering #VMEXIT
>> before #GP. This change is indicated by CPUID_0x8000000A_EDX[28]. Under
>> this circumstance, #GP interception is not required. This patchset 
>> supports
>> the new feature.
>>
>> This patchset has been verified with vmrun_errata_test and 
>> vmware_backdoor
>> tests of kvm_unit_test on the following configs. Also it was verified 
>> that
>> vmware_backdoor can be turned on under nested on nested.
>>    * Current CPU: nested, nested on nested
>>    * New CPU with X86_FEATURE_SVME_ADDR_CHK: nested, nested on nested
>>
>> v2->v3:
>>    * Change the decode function name to x86_decode_emulated_instruction()
>>    * Add a new variable, svm_gp_erratum_intercept, to control 
>> interception
>>    * Turn on VM's X86_FEATURE_SVME_ADDR_CHK feature in svm_set_cpu_caps()
>>    * Fix instruction emulation for vmware_backdoor under nested-on-nested
>>    * Minor comment fixes
>>
>> v1->v2:
>>    * Factor out instruction decode for sharing
>>    * Re-org gp_interception() handling for both #GP and vmware_backdoor
>>    * Use kvm_cpu_cap for X86_FEATURE_SVME_ADDR_CHK feature support
>>    * Add nested on nested support
>>
>> Thanks,
>> -Wei
>>
>> Wei Huang (4):
>>    KVM: x86: Factor out x86 instruction emulation with decoding
>>    KVM: SVM: Add emulation support for #GP triggered by SVM instructions
>>    KVM: SVM: Add support for SVM instruction address check change
>>    KVM: SVM: Support #GP handling for the case of nested on nested
>>
>>   arch/x86/include/asm/cpufeatures.h |   1 +
>>   arch/x86/kvm/svm/svm.c             | 128 +++++++++++++++++++++++++----
>>   arch/x86/kvm/x86.c                 |  62 ++++++++------
>>   arch/x86/kvm/x86.h                 |   2 +
>>   4 files changed, 152 insertions(+), 41 deletions(-)
>>
> 
> Queued, thanks.

Thanks. BTW because we use kvm_cpu_cap_set() in svm_set_cpu_caps(). This 
will be reflected into the CPUID received by QEMU. QEMU needs a one-line 
patch to declare the new feature. I will send it out this morning.

-Wei

> 
> Paolo
> 

