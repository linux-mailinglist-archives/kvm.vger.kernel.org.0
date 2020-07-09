Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08AE21A5C2
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 19:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgGIR0M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 13:26:12 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34854 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727768AbgGIR0M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 13:26:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594315571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uFc/trZcRn6id+2Jodje/4+rCQG3ueaY+h99MJwSJZU=;
        b=AaB0h4jTYmIESMyrOZulC0fkN6w/g8lw5S/bdjFqNR+gti9pGlx/FoGrFcZMgwhi6SKwXF
        E46zgLnr2pBCL4bP4AXA+NQtO3ECntklTAfmKJ4tvHP5etSLQz3o2N4Oj0DKhioHn50I4d
        tY10c9OkZa35pG1jkDcJoZlx2m6iuVQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-jbwNDTG2OnSeRG5JVxigQQ-1; Thu, 09 Jul 2020 13:26:09 -0400
X-MC-Unique: jbwNDTG2OnSeRG5JVxigQQ-1
Received: by mail-wm1-f71.google.com with SMTP id b13so2821576wme.9
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 10:26:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uFc/trZcRn6id+2Jodje/4+rCQG3ueaY+h99MJwSJZU=;
        b=mXMB1K9MakbjcbiHd/4JxQCevdUp970BEZW/PVJESEBPK9fz+pC37YoPgfO1s8lDVA
         NrI8+HXHt6EDYIkqBPeSae22a/22omWXj4UETjr9BMxBDfCd+CUKDhDMbiYMD0Zu5cpe
         ke6+Bff7IGVgzhiZfWpQYlsakCG7gXMfa6ubTeq4d9C8YEIOe8WmEpzbgOphXutHPu8e
         fyTrckEQaK3g+HduOx/5Prr1nXETcWdbRoOnTXYlsZgYpJwmM/VzQt1KbvVRs7kxzTA6
         uZWw7rze9S9zWshuZbeVeX7Wqv3mbS48+uELHVQZ1Nvr5Gvkc9at98XAjyGUe83Hql6o
         mRZA==
X-Gm-Message-State: AOAM532hvUavB0k1DDKwesMJ9aF2TVbHIfoHVm0I+H4W6xDKAKz5rYE7
        Tr6hvqnZen+tp7cayTwRMIdO1YSypKuSCf9nn38tPLOAFGWvCfUr+85duE/R9G9PN6Pxi9Ue2Md
        LZUH1vk6vpQbz
X-Received: by 2002:a7b:c84d:: with SMTP id c13mr1051780wml.170.1594315567632;
        Thu, 09 Jul 2020 10:26:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKr2j3I2+uMuU511bYBwA2TJY/994OQCwPs1wf2qQXfyG7QJ0FqlNIMtL3R5clnqi7mEo/uA==
X-Received: by 2002:a7b:c84d:: with SMTP id c13mr1051757wml.170.1594315567351;
        Thu, 09 Jul 2020 10:26:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id 26sm5364447wmj.25.2020.07.09.10.26.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 10:26:06 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: fixes for preemption timer migration
To:     Jim Mattson <jmattson@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Bandan Das <bsd@redhat.com>,
        Makarand Sonare <makarandsonare@google.com>
References: <20200709171507.1819-1-pbonzini@redhat.com>
 <CALMp9eQPqUUDzzkdHbq05VPFfgm=fP4O6=47ZV7q5eOEVNFPXQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <19db6c02-4835-55ba-410f-a85cc4875c71@redhat.com>
Date:   Thu, 9 Jul 2020 19:26:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQPqUUDzzkdHbq05VPFfgm=fP4O6=47ZV7q5eOEVNFPXQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/07/20 19:23, Jim Mattson wrote:
> On Thu, Jul 9, 2020 at 10:15 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> Commit 850448f35aaf ("KVM: nVMX: Fix VMX preemption timer migration",
>> 2020-06-01) accidentally broke nVMX live migration from older version
>> by changing the userspace ABI.  Restore it and, while at it, ensure
>> that vmx->nested.has_preemption_timer_deadline is always initialized
>> according to the KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE flag.
>>
>> Cc: Makarand Sonare <makarandsonare@google.com>
>> Fixes: 850448f35aaf ("KVM: nVMX: Fix VMX preemption timer migration")
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  arch/x86/include/uapi/asm/kvm.h | 5 +++--
>>  arch/x86/kvm/vmx/nested.c       | 3 ++-
>>  2 files changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
>> index 17c5a038f42d..0780f97c1850 100644
>> --- a/arch/x86/include/uapi/asm/kvm.h
>> +++ b/arch/x86/include/uapi/asm/kvm.h
>> @@ -408,14 +408,15 @@ struct kvm_vmx_nested_state_data {
>>  };
>>
>>  struct kvm_vmx_nested_state_hdr {
>> -       __u32 flags;
>>         __u64 vmxon_pa;
>>         __u64 vmcs12_pa;
>> -       __u64 preemption_timer_deadline;
>>
>>         struct {
>>                 __u16 flags;
>>         } smm;
>> +
>> +       __u32 flags;
>> +       __u64 preemption_timer_deadline;
>>  };
>>
>>  struct kvm_svm_nested_state_data {
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index b26655104d4a..3fc2411edc92 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -6180,7 +6180,8 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>>                 vmx->nested.has_preemption_timer_deadline = true;
>>                 vmx->nested.preemption_timer_deadline =
>>                         kvm_state->hdr.vmx.preemption_timer_deadline;
>> -       }
>> +       } else
>> +               vmx->nested.has_preemption_timer_deadline = false;
> 
> Doesn't the coding standard require braces around the else clause?

Yes, indeed.

Paolo

> Reviewed-by: Jim Mattson <jmattson@google.com>
> 

