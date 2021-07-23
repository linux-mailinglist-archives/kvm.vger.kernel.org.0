Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D5A3D34E5
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 08:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbhGWGSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 02:18:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44140 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234004AbhGWGSE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Jul 2021 02:18:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627023517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HnC1b6TYPKR0qc8BZCeS9n9yti0/AcEzG2nRNrYmKqg=;
        b=IUNIY93PLeriogQDSxRhwTTh2HImUBciOLQtr8yRSG/Gy6NnpS0NkuPI96kjLPM6jKSaMt
        XK1/dHAsz32jO/HNbl+ly5fFugTewORT6/P8+7WplfUx0pDJ1Ug2afnTJnq93UhLAZrDqV
        wbWWNLTaynmt/++ZluHj7CbPy0LA8jI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-tV3L2JDXNba9LCEuEGcoTA-1; Fri, 23 Jul 2021 02:58:36 -0400
X-MC-Unique: tV3L2JDXNba9LCEuEGcoTA-1
Received: by mail-wr1-f72.google.com with SMTP id d13-20020adfc3cd0000b02901531b0b7c89so82946wrg.23
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 23:58:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=HnC1b6TYPKR0qc8BZCeS9n9yti0/AcEzG2nRNrYmKqg=;
        b=PE/2suyyuH0+/DX4yrtyCR6nzUxsnGaoLTCk62wAshcTOnn4EM0HiTruT0WjK1nuz/
         6IGzS0cofDYr0clq86txBG+DKQ43uwUH/nyi32wOrdSCXz0XXqJdOKMyQtXltp7Eo0Mf
         xrEWc6pE7ae1znlp5XpwzhBlCIx0+3ALqRw0mQrUlm0QwnJQwynYn4b6YhVHM5XzYAqp
         4xXLBjGm5+Lf1oZlswmKyglD62TZaoXeN8V0PXcMLpiCiNG9T0kRMcZvQjDSuoMHcRdI
         6+Usy6No6B3BDmgyfilTM7HSVOGdWxDzo0Guij49bbwZslYHzwdVfkJG1R+pwK0AkexA
         kGxw==
X-Gm-Message-State: AOAM532PpEMMXk9DoiFCZotxbepTDPcJ2ecx0jGmqUBEtfA/AJFp0/+d
        8jq3hz1Cxlbo1tBWHG39UOrrsb/eiNvuWW+rSbth4yYbzBBLzDE3gwltVhGy5M10x327tlrihyM
        Cjjwv4rjXimu5
X-Received: by 2002:a05:600c:1c0d:: with SMTP id j13mr3009517wms.34.1627023515138;
        Thu, 22 Jul 2021 23:58:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyUpiKl0DzQ+iQ26fJyr+DpAUhUYZqt3I+7NwnHorU0HeWW1m8fYG0k6AXj5SQ3niD7L5lKJQ==
X-Received: by 2002:a05:600c:1c0d:: with SMTP id j13mr3009507wms.34.1627023514964;
        Thu, 22 Jul 2021 23:58:34 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v21sm4296580wml.5.2021.07.22.23.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 23:58:34 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Check the right feature bit for
 MSR_KVM_ASYNC_PF_ACK access
In-Reply-To: <YPmopoGY4hwuVHAp@google.com>
References: <20210722123018.260035-1-vkuznets@redhat.com>
 <YPmopoGY4hwuVHAp@google.com>
Date:   Fri, 23 Jul 2021 08:58:33 +0200
Message-ID: <87lf5x7bza.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Jul 22, 2021, Vitaly Kuznetsov wrote:
>> MSR_KVM_ASYNC_PF_ACK MSR is part of interrupt based asynchronous page fault
>> interface and not the original (deprecated) KVM_FEATURE_ASYNC_PF. This is
>> stated in Documentation/virt/kvm/msr.rst.
>> 
>> Fixes: 66570e966dd9 ("kvm: x86: only provide PV features if enabled in guest's CPUID")
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/x86.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index d715ae9f9108..88ff7a1af198 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -3406,7 +3406,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>  			return 1;
>>  		break;
>>  	case MSR_KVM_ASYNC_PF_ACK:
>> -		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
>> +		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
>
> Do we want to require both, or do we want to let userspace be stupid?
>

It's OK to be stupid :-)

Thinking more about it, I'd suggest we go the other way around: allow
access to MSR_KVM_ASYNC_PF_EN when either KVM_FEATURE_ASYNC_PF or
KVM_FEATURE_ASYNC_PF_INT are present. This will allow to eventually
deprecate KVM_FEATURE_ASYNC_PF completely and switch to
KVM_FEATURE_ASYNC_PF_INT exclusively.

>>  			return 1;
>>  		if (data & 0x1) {
>>  			vcpu->arch.apf.pageready_pending = false;
>> @@ -3745,7 +3745,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>  		msr_info->data = vcpu->arch.apf.msr_int_val;
>>  		break;
>>  	case MSR_KVM_ASYNC_PF_ACK:
>> -		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
>> +		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
>>  			return 1;
>>  
>>  		msr_info->data = 0;
>> -- 
>> 2.31.1
>> 
>

-- 
Vitaly

