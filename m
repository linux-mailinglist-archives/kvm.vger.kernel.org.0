Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D5E392929
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 10:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235250AbhE0IDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 04:03:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33232 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234865AbhE0IDM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 04:03:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622102494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xoDODitHzPFniCdWYgKL23i/M0QDFnJ8IY5fp7VUoLE=;
        b=aiquNv8oAqp+VqFqAdCmqOz2Qey3f5EZN4CggcG51ozaNsdldZh2NHSqxHb2N2VnMyj9ht
        5LU5dumNppfUo+XqEKTsKq40OzxxyA1FzltfNexD/sbNm5WFCqHuQEECq4XR8q6HZje3qm
        BjljYM/j/hEjUIL9s68PGHMoC4DeR5k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-Fo6Hck4wNmKmDD1rFR2fUg-1; Thu, 27 May 2021 04:01:23 -0400
X-MC-Unique: Fo6Hck4wNmKmDD1rFR2fUg-1
Received: by mail-wm1-f72.google.com with SMTP id b68-20020a1c80470000b02901846052c7a7so1052038wmd.2
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 01:01:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xoDODitHzPFniCdWYgKL23i/M0QDFnJ8IY5fp7VUoLE=;
        b=jUAq1UH0uCXMAGfpl9HP4gYRbfPV9QF0qpcmWbGGBvlSlxbcLRgCcuk+Wzt8STprIY
         XWGP5NUQP5aFr2WUSKPYlZFuGSSvjQkpcR/YRA099ZET3KhqHu7928mUrKYar3A9mKwR
         v2snNyv8l1VLpp4OsWbW5JZbC/iHz/7cid1KO7duhxXonmLoMQzV7hNiXKwlC0tndjyn
         viDzqVgs8F6d2Aq/ZA7V9dpFOHt9aCE3rrBn3C7DUlQNT2K6etNI1H1gPnjIBDh0xJCO
         DnJxdVXTSS7AIKmIJtrPmuCITx724Ah88jCiTArngdD2M1Ii+zums+hK/V+SXd1P9VGX
         NIww==
X-Gm-Message-State: AOAM530lqzbaEOdUH/XLTLZfh1Y/Y/EVIXBCOK+7I5tjevLp1Rnji8B5
        oPRmuBzCxOKSl0xmbfCtIs2iqOKDlqHDs3qjiDRd8AGUD4mPK+9EYL1e+4M3kUDx6o8xJkri6i4
        JWj9WMATzZ0N1
X-Received: by 2002:a5d:6484:: with SMTP id o4mr1899444wri.8.1622102482124;
        Thu, 27 May 2021 01:01:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzroZnDP3c30CzWt95Kb7cZSjkFDLdIValTkLLWuRdunNmvtk2w5xcuSJkXqs9lh4LXHXKPNg==
X-Received: by 2002:a5d:6484:: with SMTP id o4mr1899419wri.8.1622102481845;
        Thu, 27 May 2021 01:01:21 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id d131sm5096451wmd.4.2021.05.27.01.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 01:01:21 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 0/7] KVM: nVMX: Fixes for nested state migration when
 eVMCS is in use
In-Reply-To: <5a6314ff3c7b9cc8e6bdf452008ad1b264c95608.camel@redhat.com>
References: <20210517135054.1914802-1-vkuznets@redhat.com>
 <ea9a392d018ced61478482763f7a59472110104c.camel@redhat.com>
 <8735uc713d.fsf@vitty.brq.redhat.com>
 <5a6314ff3c7b9cc8e6bdf452008ad1b264c95608.camel@redhat.com>
Date:   Thu, 27 May 2021 10:01:20 +0200
Message-ID: <87a6og7ghb.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Mon, 2021-05-24 at 14:44 +0200, Vitaly Kuznetsov wrote:
>> Maxim Levitsky <mlevitsk@redhat.com> writes:
>> 
>> > On Mon, 2021-05-17 at 15:50 +0200, Vitaly Kuznetsov wrote:
>> > > Changes since v1 (Sean):
>> > > - Drop now-unneeded curly braces in nested_sync_vmcs12_to_shadow().
>> > > - Pass 'evmcs->hv_clean_fields' instead of 'bool from_vmentry' to
>> > >   copy_enlightened_to_vmcs12().
>> > > 
>> > > Commit f5c7e8425f18 ("KVM: nVMX: Always make an attempt to map eVMCS after
>> > > migration") fixed the most obvious reason why Hyper-V on KVM (e.g. Win10
>> > >  + WSL2) was crashing immediately after migration. It was also reported
>> > > that we have more issues to fix as, while the failure rate was lowered 
>> > > signifincatly, it was still possible to observe crashes after several
>> > > dozens of migration. Turns out, the issue arises when we manage to issue
>> > > KVM_GET_NESTED_STATE right after L2->L2 VMEXIT but before L1 gets a chance
>> > > to run. This state is tracked with 'need_vmcs12_to_shadow_sync' flag but
>> > > the flag itself is not part of saved nested state. A few other less 
>> > > significant issues are fixed along the way.
>> > > 
>> > > While there's no proof this series fixes all eVMCS related problems,
>> > > Win10+WSL2 was able to survive 3333 (thanks, Max!) migrations without
>> > > crashing in testing.
>> > > 
>> > > Patches are based on the current kvm/next tree.
>> > > 
>> > > Vitaly Kuznetsov (7):
>> > >   KVM: nVMX: Introduce nested_evmcs_is_used()
>> > >   KVM: nVMX: Release enlightened VMCS on VMCLEAR
>> > >   KVM: nVMX: Ignore 'hv_clean_fields' data when eVMCS data is copied in
>> > >     vmx_get_nested_state()
>> > >   KVM: nVMX: Force enlightened VMCS sync from nested_vmx_failValid()
>> > >   KVM: nVMX: Reset eVMCS clean fields data from prepare_vmcs02()
>> > >   KVM: nVMX: Request to sync eVMCS from VMCS12 after migration
>> > >   KVM: selftests: evmcs_test: Test that KVM_STATE_NESTED_EVMCS is never
>> > >     lost
>> > > 
>> > >  arch/x86/kvm/vmx/nested.c                     | 110 ++++++++++++------
>> > >  .../testing/selftests/kvm/x86_64/evmcs_test.c |  64 +++++-----
>> > >  2 files changed, 115 insertions(+), 59 deletions(-)
>> > > 
>> > 
>> > Hi Vitaly!
>> > 
>> > In addition to the review of this patch series,
>> 
>> Thanks by the way!
> No problem!
>
>> 
>> >  I would like
>> > to share an idea on how to avoid the hack of mapping the evmcs
>> > in nested_vmx_vmexit, because I think I found a possible generic
>> > solution to this and similar issues:
>> > 
>> > The solution is to always set nested_run_pending after 
>> > nested migration (which means that we won't really
>> > need to migrate this flag anymore).
>> > 
>> > I was thinking a lot about it and I think that there is no downside to this,
>> > other than sometimes a one extra vmexit after migration.
>> > 
>> > Otherwise there is always a risk of the following scenario:
>> > 
>> >   1. We migrate with nested_run_pending=0 (but don't restore all the state
>> >   yet, like that HV_X64_MSR_VP_ASSIST_PAGE msr,
>> >   or just the guest memory map is not up to date, guest is in smm or something
>> >   like that)
>> > 
>> >   2. Userspace calls some ioctl that causes a nested vmexit
>> > 
>> >   This can happen today if the userspace calls 
>> >   kvm_arch_vcpu_ioctl_get_mpstate -> kvm_apic_accept_events -> kvm_check_nested_events
>> > 
>> >   3. Userspace finally sets correct guest's msrs, correct guest memory map and only
>> >   then calls KVM_RUN
>> > 
>> > This means that at (2) we can't map and write the evmcs/vmcs12/vmcb12 even
>> > if KVM_REQ_GET_NESTED_STATE_PAGES is pending,
>> > but we have to do so to complete the nested vmexit.
>> 
>> Why do we need to write to eVMCS to complete vmexit? AFAICT, there's
>> only one place which calls copy_vmcs12_to_enlightened():
>> nested_sync_vmcs12_to_shadow() which, in its turn, has only 1 caller:
>> vmx_prepare_switch_to_guest() so unless userspace decided to execute
>> not-fully-restored guest this should not happen. I'm probably missing
>> something in your scenario)
> You are right! 
> The evmcs write is delayed to the next vmentry.
>
> However since we are now mapping the evmcs during nested vmexit,
> and this can fail for example that HV assist msr is not up to date.
>
> For example consider this: 
>
> 1. Userspace first sets nested state
> 2. Userspace calls KVM_GET_MP_STATE.
> 3. Nested vmexit that happened in 2 will end up not be able to map the evmcs,
> since HV_ASSIST msr is not yet loaded.
>
>
> Also the vmcb write (that is for SVM) _is_ done right away on nested vmexit 
> and conceptually has the same issue.
> (if memory map is not up to date, we might not be able to read/write the 
> vmcb12 on nested vmexit)
>

It seems we have one correct way to restore a guest and a number of
incorrect ones :-) It may happen that this is not even a nested-only
thing (think about trying to resore caps, regs, msrs, cpuids, in a
random sequence). I'd vote for documenting the right one somewhere, even
if we'll just be extracting it from QEMU.

>
>> 
>> > To some extent, the entry to the nested mode after a migration is only complete
>> > when we process the KVM_REQ_GET_NESTED_STATE_PAGES, so we shoudn't interrupt it.
>> > 
>> > This will allow us to avoid dealing with KVM_REQ_GET_NESTED_STATE_PAGES on
>> > nested vmexit path at all. 
>> 
>> Remember, we have three possible states when nested state is
>> transferred:
>> 1) L2 was running
>> 2) L1 was running
>> 3) We're in beetween L2 and L1 (need_vmcs12_to_shadow_sync = true).
>
> I understand. This suggestion wasn't meant to fix the case 3, but more to fix
> case 1, where we are in L2, migrate, and then immediately decide to 
> do a nested vmexit before we processed the KVM_REQ_GET_NESTED_STATE_PAGES
> request, and also before potentially before the guest state was fully uploaded
> (see that KVM_GET_MP_STATE thing).
>  
> In a nutshell, I vote for not allowing nested vmexits from the moment
> when we set the nested state and until the moment we enter the nested
> guest once (maybe with request for immediate vmexit),
> because during this time period, the guest state is not fully consistent.
>

Using 'nested_run_pending=1' perhaps? Or, we can get back to 'vm_bugged'
idea and kill the guest immediately if something forces such an exit.

-- 
Vitaly

