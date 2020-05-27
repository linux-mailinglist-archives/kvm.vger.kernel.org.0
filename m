Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3081E3CD0
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 10:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388363AbgE0I6Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 04:58:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43074 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388338AbgE0I6Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 04:58:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590569901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vhojjmzOCSpWEhTvAINn8bBz+Qn4bawejoe8LlZ0M90=;
        b=fO8d8vkxvfiwPoB/yKWQdGdMF88yq94Z8T/Maer5Jes2FGBxw6yz373cE1L4Q6+8yrY4w9
        ZBme/auKD91zsbjOnnKxBd+LgCiZzaSlw5EmR5VxK4UlYt9auQlSYMPCsxGX/Ppu0ua9Mb
        ielPxgD4Z5TWRRaKhfFS2XpVKATkXZs=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-9PvPKN-TMsy6-9g97O4CUw-1; Wed, 27 May 2020 04:58:19 -0400
X-MC-Unique: 9PvPKN-TMsy6-9g97O4CUw-1
Received: by mail-ej1-f71.google.com with SMTP id nw19so8563351ejb.10
        for <kvm@vger.kernel.org>; Wed, 27 May 2020 01:58:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=vhojjmzOCSpWEhTvAINn8bBz+Qn4bawejoe8LlZ0M90=;
        b=PibXeXvlq0+7174ZcZw3zy3VDnWKz6yYixjo7FBFrB0jkwdKOlm6dj5r3Ak8wF82NH
         DZUdC0K7PWx73CJue52qS0drN5bPmWPn0kTFZ4t/VnhoGFI+hjg7lKpcvd82q6ir3UQo
         39UjvJkJpoTsuehoWlGCyAx1Fw8UisoQSI27o1YP3fbZ8PuQrT1CHywfwGPDB+FuKzmX
         T4t0d1lPWB+4oMwemwCF0p6ZYHFvs/AQKckzIBwFMfRHFm3YoFFcv2CoILzGmP+mmTc/
         2+J/nMckySdvz+GIZCMj3Vvqec+y68R0QzfOQbOhaYEhAmHAT3u3isiNmiwe64hUoQzk
         F/ig==
X-Gm-Message-State: AOAM530dfDbYEx4JLqQYFZHm2CjbzUp73b7Ba5JxNaz5wmXEtYDG5IgH
        v2cFOQOlSlEsxoVr5IEG+LrsH4FeTzc3rwvefXHBIW7phMP0RhD1c5NcrW3y59LO3AgYlrzDSsj
        PD3FOTPN+Zt0V
X-Received: by 2002:a17:906:aad8:: with SMTP id kt24mr5208428ejb.54.1590569896582;
        Wed, 27 May 2020 01:58:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8wrGosLrGmDoueklqlxGwUWDf516tpbD/XDWAVII7nTchhEAxiWRKsLfju0z8ZJQs6bPhSg==
X-Received: by 2002:a17:906:aad8:: with SMTP id kt24mr5208416ejb.54.1590569896332;
        Wed, 27 May 2020 01:58:16 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id bq23sm2154761ejb.47.2020.05.27.01.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 01:58:15 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Cathy Avery <cavery@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH] KVM: nVMX: Preserve registers modifications done before nested_svm_vmexit()
In-Reply-To: <20200527084835.GO31696@linux.intel.com>
References: <20200527082921.218601-1-vkuznets@redhat.com> <20200527084835.GO31696@linux.intel.com>
Date:   Wed, 27 May 2020 10:58:14 +0200
Message-ID: <878shd69g9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Shortlog says nVMX, code says nSVM :-)
>

My brain is tainted, you know :-) Also, saying *VMX* always helps to get
your review so I may use the trick again :-)

> On Wed, May 27, 2020 at 10:29:21AM +0200, Vitaly Kuznetsov wrote:
>> L2 guest hang is observed after 'exit_required' was dropped and nSVM
>> switched to check_nested_events() completely. The hang is a busy loop when
>> e.g. KVM is emulating an instruction (e.g. L2 is accessing MMIO space and
>> we drop to userspace). After nested_svm_vmexit() and when L1 is doing VMRUN
>> nested guest's RIP is not advanced so KVM goes into emulating the same
>> instruction which cased nested_svm_vmexit() and the loop continues.
>
> s/cased/caused?
>

Yep.

>> nested_svm_vmexit() is not new, however, with check_nested_events() we're
>> now calling it later than before. In case by that time KVM has modified
>> register state we may pick stale values from VMCS when trying to save
>
> s/VMCS/VMCB
>

Yep.

>> nested guest state to nested VMCB.
>> 
>> VMX code handles this case correctly: sync_vmcs02_to_vmcs12() called from
>> nested_vmx_vmexit() does 'vmcs12->guest_rip = kvm_rip_read(vcpu)' and this
>> ensures KVM-made modifications are preserved. Do the same for nVMX.
>
> s/nVMX/nSVM
>

Yep.

I'll do v2 to avoid the confusion.

>> 
>> Generally, nested_vmx_vmexit()/nested_svm_vmexit() need to pick up all
>> nested guest state modifications done by KVM after vmexit. It would be
>> great to find a way to express this in a way which would not require to
>> manually track these changes, e.g. nested_{vmcb,vmcs}_get_field().
>> 
>> Co-debugged-with: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>> - To certain extent we're fixing currently-pending 'KVM: SVM: immediately
>>  inject INTR vmexit' commit but I'm not certain about that. We had so many
>>  problems with nested events before switching to check_nested_events() that
>>  what worked before could just be treated as a miracle. Miracles tend to
>>  appear and disappear all of a sudden.
>> ---
>>  arch/x86/kvm/svm/nested.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index 0f02521550b9..6b1049148c1b 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -537,9 +537,9 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>>  	nested_vmcb->save.cr2    = vmcb->save.cr2;
>>  	nested_vmcb->save.cr4    = svm->vcpu.arch.cr4;
>>  	nested_vmcb->save.rflags = kvm_get_rflags(&svm->vcpu);
>> -	nested_vmcb->save.rip    = vmcb->save.rip;
>> -	nested_vmcb->save.rsp    = vmcb->save.rsp;
>> -	nested_vmcb->save.rax    = vmcb->save.rax;
>> +	nested_vmcb->save.rip    = kvm_rip_read(&svm->vcpu);
>> +	nested_vmcb->save.rsp    = kvm_rsp_read(&svm->vcpu);
>> +	nested_vmcb->save.rax    = kvm_rax_read(&svm->vcpu);
>>  	nested_vmcb->save.dr7    = vmcb->save.dr7;
>>  	nested_vmcb->save.dr6    = svm->vcpu.arch.dr6;
>>  	nested_vmcb->save.cpl    = vmcb->save.cpl;
>> -- 
>> 2.25.4
>> 
>

-- 
Vitaly

