Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C8D38E6CF
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 14:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhEXMqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 08:46:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46031 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232662AbhEXMqL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 08:46:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621860283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VqPjrRquzS6SEhm5tywCUR7rIaw8mCPwKUYvUEsWTY0=;
        b=LQogIlc5czrbzpNTSP5nKpgBWoUCCMdOS/ulY2p2IN0XrCC0e4e76Gu9GRjSbizdYHgKPZ
        LHu8WJr1LBeG5PY5A140HMvtMAKTyHex5EtJeEnH++z4A413YRBBHVm/xObjDTspaU/Ss9
        UHe7V3QwYPWPQ/sbOvdwx3g18AIxD8g=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-6GpKmGz4OPiMmODZxu3sNw-1; Mon, 24 May 2021 08:44:41 -0400
X-MC-Unique: 6GpKmGz4OPiMmODZxu3sNw-1
Received: by mail-wm1-f71.google.com with SMTP id y193-20020a1c32ca0000b029014cbf30c3f2so5092586wmy.1
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 05:44:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=VqPjrRquzS6SEhm5tywCUR7rIaw8mCPwKUYvUEsWTY0=;
        b=XqSHeXfNc8ZL6y6WNJ8ul/+HYhZCtvnqFFieETgDJNDWDN2cSx+xzciLpuhs8efevd
         sWfRF2Fx9RR5dpmN3VXbXiBh29VIRN6K/IDPwtbTji2/ukO8KEs+rHG1JQ1QutbbIAjI
         g+26bGwXus9r7iDCKfn7KsZCfefWBszLeVfKzVB7gaerzdi8htQIOroblECu/JiwEZZg
         scf3YqSmIJfdRoskudb1C6xfUFx/L2LlCejO+WAjehXc2UrTtehdf35UXmOiB9nPmzY5
         LUx9l6pLdcac5IU9Vf36pUj0qFGr+abV3hKzfTMGP1AaBDygcNYKHS0Ud45x4zVfjDyh
         WZ5A==
X-Gm-Message-State: AOAM532+NSSvSCw9n2OEXNPCqTR7/+yH3zBKytV0ZjAe+6wAlE4p2ckg
        jS9WBG6VqYfFQf2nlR0vF/lrlvK3x1Zc1sEvY22iqvx/pb7H8YuqxQ2JN11eKDE99qW/TOB5vTx
        TcG9d0ZhRKWjt
X-Received: by 2002:adf:ee86:: with SMTP id b6mr14952455wro.53.1621860280661;
        Mon, 24 May 2021 05:44:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyYMu0qQn8o/iGPvg8ujO8B9a5opkhyjyMgdUCeFEv9Fe1wJxb5G3ANl3T0GFa45sKqWynJ9w==
X-Received: by 2002:adf:ee86:: with SMTP id b6mr14952437wro.53.1621860280436;
        Mon, 24 May 2021 05:44:40 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b10sm14473569wrr.27.2021.05.24.05.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 05:44:39 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 0/7] KVM: nVMX: Fixes for nested state migration when
 eVMCS is in use
In-Reply-To: <ea9a392d018ced61478482763f7a59472110104c.camel@redhat.com>
References: <20210517135054.1914802-1-vkuznets@redhat.com>
 <ea9a392d018ced61478482763f7a59472110104c.camel@redhat.com>
Date:   Mon, 24 May 2021 14:44:38 +0200
Message-ID: <8735uc713d.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Mon, 2021-05-17 at 15:50 +0200, Vitaly Kuznetsov wrote:
>> Changes since v1 (Sean):
>> - Drop now-unneeded curly braces in nested_sync_vmcs12_to_shadow().
>> - Pass 'evmcs->hv_clean_fields' instead of 'bool from_vmentry' to
>>   copy_enlightened_to_vmcs12().
>> 
>> Commit f5c7e8425f18 ("KVM: nVMX: Always make an attempt to map eVMCS after
>> migration") fixed the most obvious reason why Hyper-V on KVM (e.g. Win10
>>  + WSL2) was crashing immediately after migration. It was also reported
>> that we have more issues to fix as, while the failure rate was lowered 
>> signifincatly, it was still possible to observe crashes after several
>> dozens of migration. Turns out, the issue arises when we manage to issue
>> KVM_GET_NESTED_STATE right after L2->L2 VMEXIT but before L1 gets a chance
>> to run. This state is tracked with 'need_vmcs12_to_shadow_sync' flag but
>> the flag itself is not part of saved nested state. A few other less 
>> significant issues are fixed along the way.
>> 
>> While there's no proof this series fixes all eVMCS related problems,
>> Win10+WSL2 was able to survive 3333 (thanks, Max!) migrations without
>> crashing in testing.
>> 
>> Patches are based on the current kvm/next tree.
>> 
>> Vitaly Kuznetsov (7):
>>   KVM: nVMX: Introduce nested_evmcs_is_used()
>>   KVM: nVMX: Release enlightened VMCS on VMCLEAR
>>   KVM: nVMX: Ignore 'hv_clean_fields' data when eVMCS data is copied in
>>     vmx_get_nested_state()
>>   KVM: nVMX: Force enlightened VMCS sync from nested_vmx_failValid()
>>   KVM: nVMX: Reset eVMCS clean fields data from prepare_vmcs02()
>>   KVM: nVMX: Request to sync eVMCS from VMCS12 after migration
>>   KVM: selftests: evmcs_test: Test that KVM_STATE_NESTED_EVMCS is never
>>     lost
>> 
>>  arch/x86/kvm/vmx/nested.c                     | 110 ++++++++++++------
>>  .../testing/selftests/kvm/x86_64/evmcs_test.c |  64 +++++-----
>>  2 files changed, 115 insertions(+), 59 deletions(-)
>> 
>
> Hi Vitaly!
>
> In addition to the review of this patch series,

Thanks by the way!

>  I would like
> to share an idea on how to avoid the hack of mapping the evmcs
> in nested_vmx_vmexit, because I think I found a possible generic
> solution to this and similar issues:
>
> The solution is to always set nested_run_pending after 
> nested migration (which means that we won't really
> need to migrate this flag anymore).
>
> I was thinking a lot about it and I think that there is no downside to this,
> other than sometimes a one extra vmexit after migration.
>
> Otherwise there is always a risk of the following scenario:
>
>   1. We migrate with nested_run_pending=0 (but don't restore all the state
>   yet, like that HV_X64_MSR_VP_ASSIST_PAGE msr,
>   or just the guest memory map is not up to date, guest is in smm or something
>   like that)
>
>   2. Userspace calls some ioctl that causes a nested vmexit
>
>   This can happen today if the userspace calls 
>   kvm_arch_vcpu_ioctl_get_mpstate -> kvm_apic_accept_events -> kvm_check_nested_events
>
>   3. Userspace finally sets correct guest's msrs, correct guest memory map and only
>   then calls KVM_RUN
>
> This means that at (2) we can't map and write the evmcs/vmcs12/vmcb12 even
> if KVM_REQ_GET_NESTED_STATE_PAGES is pending,
> but we have to do so to complete the nested vmexit.

Why do we need to write to eVMCS to complete vmexit? AFAICT, there's
only one place which calls copy_vmcs12_to_enlightened():
nested_sync_vmcs12_to_shadow() which, in its turn, has only 1 caller:
vmx_prepare_switch_to_guest() so unless userspace decided to execute
not-fully-restored guest this should not happen. I'm probably missing
something in your scenario)

>
> To some extent, the entry to the nested mode after a migration is only complete
> when we process the KVM_REQ_GET_NESTED_STATE_PAGES, so we shoudn't interrupt it.
>
> This will allow us to avoid dealing with KVM_REQ_GET_NESTED_STATE_PAGES on
> nested vmexit path at all. 

Remember, we have three possible states when nested state is
transferred:
1) L2 was running
2) L1 was running
3) We're in beetween L2 and L1 (need_vmcs12_to_shadow_sync = true).

Is 'nested_run_pending' suitable for all of them? Could you maybe draft
a patch so we can see how this works (in both 'normal' and 'evmcs'
cases)?

-- 
Vitaly

