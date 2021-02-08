Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E474313500
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 15:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbhBHOWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 09:22:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46342 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232771AbhBHOUC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 09:20:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612793892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dcxAr2wsCSua+b6NS9u+BDve4GiN8GPuVPhopnFUwt0=;
        b=VO9+ZBi3BFCbZ4rbgfvmQtRtK+DF4I7P5INZW0cQHXGSV5p3AAqv3ELfkab/XUfzUIT/16
        z1Y/cH+/kZo4QhQrMzQY6+izxZsH961MeSQ9DFt8pYfX+6/101k4Xc21x8OvuMgk6RcRVY
        YLstVd8j44c93FSS+doRcMSvHaSLJOc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-ywTall7RPcag7TOji4p4ug-1; Mon, 08 Feb 2021 09:18:11 -0500
X-MC-Unique: ywTall7RPcag7TOji4p4ug-1
Received: by mail-ej1-f69.google.com with SMTP id w16so11663031ejk.7
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 06:18:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dcxAr2wsCSua+b6NS9u+BDve4GiN8GPuVPhopnFUwt0=;
        b=XX40YOHig8V528GY1Co232XOVsgdXBSnD24pb1+Fg6t2YoRe8Raa0fdx8ux51NVR4X
         qMOzwkwecE5AWbQz1nVXPaszu3OrzpSQmcL91YqFGGxQgcVrJZUfIyY0Xlt4+aBIjb1P
         DS/pqLTTfwj1PF6tw0ytOeal8TO/PTF10t6b3u00PIcbFMMOzSdWZ+wnuMLqrPjCBHul
         49MYk7ePS6UhNcsoWU8M7u3m3aYTY4idIb9d+VKsKh7qinJF3W9Gb5KFhWY60SMNH3CN
         T2h7sT4UBUwpdn+tua//hAoOqNnWC5eEF/h0/UPva2NZCHRHFEENgjEAwbYcLs2w30M/
         38VA==
X-Gm-Message-State: AOAM532ftJD9xgLZOeBsiwo23l8N4OJpMRKdO+E5T0HWdDy+9UPCLWG+
        zeB/6F7+JnCiAtHmUj1yTxWFipiPKfF4YlQL5LOGgedCWZeqRFDVThRGz2wdTLANAOwswinkpSO
        SeVME+NgXtX3M
X-Received: by 2002:a17:906:f0d0:: with SMTP id dk16mr17101711ejb.533.1612793890001;
        Mon, 08 Feb 2021 06:18:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzX/cXdVgaTG3BBzsDdbdaHDTYsr7pysuaEgMkU50eTT6J2giJKBe1GGLjjTA112cWsT+5Cqw==
X-Received: by 2002:a17:906:f0d0:: with SMTP id dk16mr17101663ejb.533.1612793889376;
        Mon, 08 Feb 2021 06:18:09 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id hb38sm2670775ejc.75.2021.02.08.06.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 06:18:08 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 00/15] KVM: x86: Conditional Hyper-V emulation
 enablement
In-Reply-To: <b88c62a9-2c64-4de9-b27e-dce969bf8c07@redhat.com>
References: <20210126134816.1880136-1-vkuznets@redhat.com>
 <b88c62a9-2c64-4de9-b27e-dce969bf8c07@redhat.com>
Date:   Mon, 08 Feb 2021 15:18:08 +0100
Message-ID: <87czxaod7j.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 26/01/21 14:48, Vitaly Kuznetsov wrote:
>> Changes since v1 [Sean]:
>> - Add a few cleanup patches ("Rename vcpu_to_hv_vcpu() to to_hv_vcpu()",
>>    "Rename vcpu_to_synic()/synic_to_vcpu()", ...)
>> - Drop unused kvm_hv_vapic_assist_page_enabled()
>> - Stop shadowing global 'current_vcpu' variable in kvm_hv_flush_tlb()/
>>    kvm_hv_send_ipi()
>> 
>> Original description:
>> 
>> Hyper-V emulation is enabled in KVM unconditionally even for Linux guests.
>> This is bad at least from security standpoint as it is an extra attack
>> surface. Ideally, there should be a per-VM capability explicitly enabled by
>> VMM but currently it is not the case and we can't mandate one without
>> breaking backwards compatibility. We can, however, check guest visible CPUIDs
>> and only enable Hyper-V emulation when "Hv#1" interface was exposed in
>> HYPERV_CPUID_INTERFACE.
>> 
>> Also (and while on it) per-vcpu Hyper-V context ('struct kvm_vcpu_hv') is
>> currently part of 'struct kvm_vcpu_arch' and thus allocated unconditionally
>> for each vCPU. The context, however, quite big and accounts for more than
>> 1/4 of 'struct kvm_vcpu_arch' (e.g. 2912/9512 bytes). Switch to allocating
>> it dynamically. This may come handy if we ever decide to raise KVM_MAX_VCPUS
>> (and rumor has it some downstream distributions already have more than '288')
>> 
>> Vitaly Kuznetsov (15):
>>    selftests: kvm: Move kvm_get_supported_hv_cpuid() to common code
>>    selftests: kvm: Properly set Hyper-V CPUIDs in evmcs_test
>>    KVM: x86: hyper-v: Drop unused kvm_hv_vapic_assist_page_enabled()
>>    KVM: x86: hyper-v: Rename vcpu_to_hv_vcpu() to to_hv_vcpu()
>>    KVM: x86: hyper-v: Rename vcpu_to_synic()/synic_to_vcpu()
>>    KVM: x86: hyper-v: Rename vcpu_to_stimer()/stimer_to_vcpu()
>>    KVM: x86: hyper-v: Rename vcpu_to_hv_syndbg() to to_hv_syndbg()
>>    KVM: x86: hyper-v: Introduce to_kvm_hv() helper
>>    KVM: x86: hyper-v: Stop shadowing global 'current_vcpu' variable
>>    KVM: x86: hyper-v: Always use to_hv_vcpu() accessor to get to 'struct
>>      kvm_vcpu_hv'
>>    KVM: x86: hyper-v: Prepare to meet unallocated Hyper-V context
>>    KVM: x86: hyper-v: Allocate 'struct kvm_vcpu_hv' dynamically
>>    KVM: x86: hyper-v: Make Hyper-V emulation enablement conditional
>>    KVM: x86: hyper-v: Allocate Hyper-V context lazily
>>    KVM: x86: hyper-v: Drop hv_vcpu_to_vcpu() helper
>> 
...
>> 
>
> Queued, thanks.

I was expecting it to appear in kvm/queue but it didn't happen so just
wanted to double-check what happened to these patches. Thanks!

-- 
Vitaly

