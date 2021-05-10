Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15FEE379069
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 16:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbhEJORL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 10:17:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35264 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236647AbhEJOND (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 10:13:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620655916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=af5r9u3qqZ9G/EkGOxZhfoFUt25ySsbb0dW7quZCUNk=;
        b=MACKYQ582AGjNO7gNRZ1vDl4G7+57kkB8zDHFpUggtAezcI1AC8gE1W3ld3nHy8JbG0czU
        aknQjWvzd+jKHg33vuNpCcI/CK1RXXYz7n4VA18loH6bBHDlmTVcWCEZQGwzeAFp+tmyRc
        U0x+rRniEjXdECKEubLdNK+7+c6il7g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-L_hInLbpPtGi1jvx_E6gKw-1; Mon, 10 May 2021 10:11:54 -0400
X-MC-Unique: L_hInLbpPtGi1jvx_E6gKw-1
Received: by mail-wm1-f70.google.com with SMTP id g67-20020a1cb6460000b029014297bda128so2064475wmf.1
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 07:11:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=af5r9u3qqZ9G/EkGOxZhfoFUt25ySsbb0dW7quZCUNk=;
        b=QRXxSbObQQ9BK/cQ3WBV39xFpm51GrITNAj/0eMiT6ayDSQW2DH6DfbbVw+OcACuXo
         TejUKsWs4HZc1hETRH9IgkLUV/WDLG12opPR+N5wysSKPx3Rf2E509Y1VEj1ZEFPvBR3
         TmUjYo3aEyLk4paDK6QFCcvfahgJi7gNd4PUuvVrwewu65ujt7Y/+Jl1FpJdLPzFFEwW
         WQImqYPm+U2EXkYhr/0cMfwE047T2bUyFlxyfKPJPgvAxBQ0rXCXTi8yEU5zEkXhYHLE
         MwkIbNxEudWxaVHNetwJgbVRvxO76wZ/jsC3NpNROpZZDLg/DooMhYe/12qyEhBYESiF
         wBjw==
X-Gm-Message-State: AOAM531/0JjVQ5+wDH44ugc9u072JK5q3KO6C+1KYoTN1qkffrmuoq0w
        eMcFiBqSb8wXuUTY5dFKgG0tjrLDzii77CwJXbtF1d7Z1oyPY3vjRzrpq/Ox82L3sLgw1KPuz+Y
        zSNSpdZE7WlyI
X-Received: by 2002:a05:600c:4f48:: with SMTP id m8mr29832354wmq.169.1620655913357;
        Mon, 10 May 2021 07:11:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyIVLNk31dZvAQl7t4iAvD7xEAaktItzWZGK1tv1d3hqXxusFE5ZnDBKEklD2/Rdcs4H11hw==
X-Received: by 2002:a05:600c:4f48:: with SMTP id m8mr29832324wmq.169.1620655913120;
        Mon, 10 May 2021 07:11:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f22sm19346400wmj.42.2021.05.10.07.11.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 07:11:52 -0700 (PDT)
Subject: Re: [PATCH 4/8] KVM: VMX: Adjust the TSC-related VMCS fields on L2
 entry and exit
To:     "Stamatis, Ilias" <ilstam@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "ilstam@mailbox.org" <ilstam@mailbox.org>
Cc:     "jmattson@google.com" <jmattson@google.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "haozhong.zhang@intel.com" <haozhong.zhang@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "dplotnikov@virtuozzo.com" <dplotnikov@virtuozzo.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
References: <20210506103228.67864-1-ilstam@mailbox.org>
 <20210506103228.67864-5-ilstam@mailbox.org>
 <50f86951-1cea-b7aa-7236-f28edd5eca8d@redhat.com>
 <8ebf2b17f339bf21b69bba41575e62f98ec87105.camel@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9506c826-face-e816-d88a-3797872f26d2@redhat.com>
Date:   Mon, 10 May 2021 16:11:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <8ebf2b17f339bf21b69bba41575e62f98ec87105.camel@amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/05/21 19:35, Stamatis, Ilias wrote:
> On Thu, 2021-05-06 at 13:32 +0200, Paolo Bonzini wrote:
>> On 06/05/21 12:32, ilstam@mailbox.org wrote:
>>> +     if (vmcs12->cpu_based_vm_exec_control &
>>> CPU_BASED_USE_TSC_OFFSETTING) {
>>> +             if (vmcs12->secondary_vm_exec_control &
>>> SECONDARY_EXEC_TSC_SCALING) {
>>> +                     vcpu->arch.tsc_offset =
>>> kvm_compute_02_tsc_offset(
>>> +                                     vcpu->arch.l1_tsc_offset,
>>> +                                     vmcs12->tsc_multiplier,
>>> +                                     vmcs12->tsc_offset);
>>> +
>>> +                     vcpu->arch.tsc_scaling_ratio =
>>> mul_u64_u64_shr(
>>> +                                     vcpu->arch.tsc_scaling_ratio,
>>> +                                     vmcs12->tsc_multiplier,
>>> +                                     kvm_tsc_scaling_ratio_frac_bit
>>> s);
>>> +             } else {
>>> +                     vcpu->arch.tsc_offset += vmcs12->tsc_offset;
>>> +             }
>>
>> The computation of vcpu->arch.tsc_offset is (not coincidentially) the
>> same that appears in patch 6
>>
>> +           (vmcs12->cpu_based_vm_exec_control &
>> CPU_BASED_USE_TSC_OFFSETTING)) {
>> +               if (vmcs12->secondary_vm_exec_control &
>> SECONDARY_EXEC_TSC_SCALING) {
>> +                       cur_offset = kvm_compute_02_tsc_offset(
>> +                                       l1_offset,
>> +                                       vmcs12->tsc_multiplier,
>> +                                       vmcs12->tsc_offset);
>> +               } else {
>> +                       cur_offset = l1_offset + vmcs12->tsc_offset;
>>
>> So I think you should just pass vmcs12 and the L1 offset to
>> kvm_compute_02_tsc_offset, and let it handle both cases (and possibly
>> even set vcpu->arch.tsc_scaling_ratio in the same function).
> 
> That was my thinking initially too. However, kvm_compute_02_tsc_offset
> is defined in x86.c which is vmx-agnostic and hence 'struct vmcs12' is
> not defined there.

Good point.  Yeah, it's trading one comde duplication for another. 
Right now there's already code duplication in write_l1_tsc_offset, so it 
makes some sense to limit duplication _within_ the file and lose in 
duplicated code across vmx/svm, but either is okay.

Paolo

