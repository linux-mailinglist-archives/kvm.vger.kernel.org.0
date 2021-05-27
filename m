Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5100339307F
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 16:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236487AbhE0OMx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 10:12:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50187 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236388AbhE0OMv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 10:12:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622124678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UHy0LI7U8IKp62R8ShBRcerq/nVjfJ85NAZGyeEqU8w=;
        b=YkkKGXN4zRy8D4rokilUS0iKaJHNrtMALhZGGJTrMOLwp8KeG8aDCdYfnowKqEgaOoYmep
        JCy2JF8bSA5jL/9QjQADvONEGOpH7OU5r5zUOKh9wSz+o1hz/yyc7JLE/DJ8PQQjLzWxsP
        dopZsnV8SpiwBKHi7yeENRUosu83n8o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-pMidVeclOD2JA0N2JS7f4Q-1; Thu, 27 May 2021 10:11:14 -0400
X-MC-Unique: pMidVeclOD2JA0N2JS7f4Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8853781CAF1;
        Thu, 27 May 2021 14:11:12 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F0F75C3E4;
        Thu, 27 May 2021 14:11:07 +0000 (UTC)
Message-ID: <3b76c3da7af87c576862fa6a538505fe89a47702.camel@redhat.com>
Subject: Re: [PATCH v2 0/7] KVM: nVMX: Fixes for nested state migration when
 eVMCS is in use
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 27 May 2021 17:11:06 +0300
In-Reply-To: <87a6og7ghb.fsf@vitty.brq.redhat.com>
References: <20210517135054.1914802-1-vkuznets@redhat.com>
         <ea9a392d018ced61478482763f7a59472110104c.camel@redhat.com>
         <8735uc713d.fsf@vitty.brq.redhat.com>
         <5a6314ff3c7b9cc8e6bdf452008ad1b264c95608.camel@redhat.com>
         <87a6og7ghb.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-05-27 at 10:01 +0200, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > On Mon, 2021-05-24 at 14:44 +0200, Vitaly Kuznetsov wrote:
> > > Maxim Levitsky <mlevitsk@redhat.com> writes:
> > > 
> > > > On Mon, 2021-05-17 at 15:50 +0200, Vitaly Kuznetsov wrote:
> > > > > Changes since v1 (Sean):
> > > > > - Drop now-unneeded curly braces in nested_sync_vmcs12_to_shadow().
> > > > > - Pass 'evmcs->hv_clean_fields' instead of 'bool from_vmentry' to
> > > > >   copy_enlightened_to_vmcs12().
> > > > > 
> > > > > Commit f5c7e8425f18 ("KVM: nVMX: Always make an attempt to map eVMCS after
> > > > > migration") fixed the most obvious reason why Hyper-V on KVM (e.g. Win10
> > > > >  + WSL2) was crashing immediately after migration. It was also reported
> > > > > that we have more issues to fix as, while the failure rate was lowered 
> > > > > signifincatly, it was still possible to observe crashes after several
> > > > > dozens of migration. Turns out, the issue arises when we manage to issue
> > > > > KVM_GET_NESTED_STATE right after L2->L2 VMEXIT but before L1 gets a chance
> > > > > to run. This state is tracked with 'need_vmcs12_to_shadow_sync' flag but
> > > > > the flag itself is not part of saved nested state. A few other less 
> > > > > significant issues are fixed along the way.
> > > > > 
> > > > > While there's no proof this series fixes all eVMCS related problems,
> > > > > Win10+WSL2 was able to survive 3333 (thanks, Max!) migrations without
> > > > > crashing in testing.
> > > > > 
> > > > > Patches are based on the current kvm/next tree.
> > > > > 
> > > > > Vitaly Kuznetsov (7):
> > > > >   KVM: nVMX: Introduce nested_evmcs_is_used()
> > > > >   KVM: nVMX: Release enlightened VMCS on VMCLEAR
> > > > >   KVM: nVMX: Ignore 'hv_clean_fields' data when eVMCS data is copied in
> > > > >     vmx_get_nested_state()
> > > > >   KVM: nVMX: Force enlightened VMCS sync from nested_vmx_failValid()
> > > > >   KVM: nVMX: Reset eVMCS clean fields data from prepare_vmcs02()
> > > > >   KVM: nVMX: Request to sync eVMCS from VMCS12 after migration
> > > > >   KVM: selftests: evmcs_test: Test that KVM_STATE_NESTED_EVMCS is never
> > > > >     lost
> > > > > 
> > > > >  arch/x86/kvm/vmx/nested.c                     | 110 ++++++++++++------
> > > > >  .../testing/selftests/kvm/x86_64/evmcs_test.c |  64 +++++-----
> > > > >  2 files changed, 115 insertions(+), 59 deletions(-)
> > > > > 
> > > > 
> > > > Hi Vitaly!
> > > > 
> > > > In addition to the review of this patch series,
> > > 
> > > Thanks by the way!
> > No problem!
> > 
> > > >  I would like
> > > > to share an idea on how to avoid the hack of mapping the evmcs
> > > > in nested_vmx_vmexit, because I think I found a possible generic
> > > > solution to this and similar issues:
> > > > 
> > > > The solution is to always set nested_run_pending after 
> > > > nested migration (which means that we won't really
> > > > need to migrate this flag anymore).
> > > > 
> > > > I was thinking a lot about it and I think that there is no downside to this,
> > > > other than sometimes a one extra vmexit after migration.
> > > > 
> > > > Otherwise there is always a risk of the following scenario:
> > > > 
> > > >   1. We migrate with nested_run_pending=0 (but don't restore all the state
> > > >   yet, like that HV_X64_MSR_VP_ASSIST_PAGE msr,
> > > >   or just the guest memory map is not up to date, guest is in smm or something
> > > >   like that)
> > > > 
> > > >   2. Userspace calls some ioctl that causes a nested vmexit
> > > > 
> > > >   This can happen today if the userspace calls 
> > > >   kvm_arch_vcpu_ioctl_get_mpstate -> kvm_apic_accept_events -> kvm_check_nested_events
> > > > 
> > > >   3. Userspace finally sets correct guest's msrs, correct guest memory map and only
> > > >   then calls KVM_RUN
> > > > 
> > > > This means that at (2) we can't map and write the evmcs/vmcs12/vmcb12 even
> > > > if KVM_REQ_GET_NESTED_STATE_PAGES is pending,
> > > > but we have to do so to complete the nested vmexit.
> > > 
> > > Why do we need to write to eVMCS to complete vmexit? AFAICT, there's
> > > only one place which calls copy_vmcs12_to_enlightened():
> > > nested_sync_vmcs12_to_shadow() which, in its turn, has only 1 caller:
> > > vmx_prepare_switch_to_guest() so unless userspace decided to execute
> > > not-fully-restored guest this should not happen. I'm probably missing
> > > something in your scenario)
> > You are right! 
> > The evmcs write is delayed to the next vmentry.
> > 
> > However since we are now mapping the evmcs during nested vmexit,
> > and this can fail for example that HV assist msr is not up to date.
> > 
> > For example consider this: 
> > 
> > 1. Userspace first sets nested state
> > 2. Userspace calls KVM_GET_MP_STATE.
> > 3. Nested vmexit that happened in 2 will end up not be able to map the evmcs,
> > since HV_ASSIST msr is not yet loaded.
> > 
> > 
> > Also the vmcb write (that is for SVM) _is_ done right away on nested vmexit 
> > and conceptually has the same issue.
> > (if memory map is not up to date, we might not be able to read/write the 
> > vmcb12 on nested vmexit)
> > 
> 
> It seems we have one correct way to restore a guest and a number of
> incorrect ones :-) It may happen that this is not even a nested-only
> thing (think about trying to resore caps, regs, msrs, cpuids, in a
> random sequence). I'd vote for documenting the right one somewhere, even
> if we'll just be extracting it from QEMU.
> 
> > > > To some extent, the entry to the nested mode after a migration is only complete
> > > > when we process the KVM_REQ_GET_NESTED_STATE_PAGES, so we shoudn't interrupt it.
> > > > 
> > > > This will allow us to avoid dealing with KVM_REQ_GET_NESTED_STATE_PAGES on
> > > > nested vmexit path at all. 
> > > 
> > > Remember, we have three possible states when nested state is
> > > transferred:
> > > 1) L2 was running
> > > 2) L1 was running
> > > 3) We're in beetween L2 and L1 (need_vmcs12_to_shadow_sync = true).
> > 
> > I understand. This suggestion wasn't meant to fix the case 3, but more to fix
> > case 1, where we are in L2, migrate, and then immediately decide to 
> > do a nested vmexit before we processed the KVM_REQ_GET_NESTED_STATE_PAGES
> > request, and also before potentially before the guest state was fully uploaded
> > (see that KVM_GET_MP_STATE thing).
> >  
> > In a nutshell, I vote for not allowing nested vmexits from the moment
> > when we set the nested state and until the moment we enter the nested
> > guest once (maybe with request for immediate vmexit),
> > because during this time period, the guest state is not fully consistent.
> > 
> 
> Using 'nested_run_pending=1' perhaps? Or, we can get back to 'vm_bugged'
> idea and kill the guest immediately if something forces such an exit.

Exactly, this is my idea. Set the nested_run_pending=1 always after the migration
It shoudn't cause any issues and it would avoid cases like that.

That variable can then be renamed too to something like 'nested_vmexit_not_allowed'
or something like that.

Paolo, what do you think?

Best regards,
	Maxim Levitsky

> 


