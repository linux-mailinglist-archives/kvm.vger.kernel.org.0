Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5057C8FFD
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 19:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbfJBRcu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 13:32:50 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:38465 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbfJBRcu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 13:32:50 -0400
Received: by mail-io1-f68.google.com with SMTP id u8so58813697iom.5
        for <kvm@vger.kernel.org>; Wed, 02 Oct 2019 10:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ATbaP9ym2FZ4o318n4QbM7zZEyOraU0JVCLO9UUxxzk=;
        b=BVH1Rc6i8TR1zgdwTms6mz7vkvcbtDXZKKg08uSRbr7jx9lC7+s3MDdrpj0edz8Upu
         +qW2cQ0rYfeGfqATLkSK0wx1tMlgkjDc4qvjwninGD9oT9999U4AErzqL4Zp4GjjlP9t
         otJwbr1bAW5Dvfg7mty2qTnHDTvXnAIHvN72hxfrugF2FaCpFFWujrFElh+e36rldvmk
         d9w4nyRUxMIEZdUU/Y8tCUguwA8z/Km09HT8nacNFW91OcQv2T6CS24fgiL0uYHmsGYT
         WTqtuFAA9bkd5A/9Ae+EVuhCPzkDUcI65JMxUAggUq7mpkcS63Y1kgOUNFsB9bvKcDla
         kb0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ATbaP9ym2FZ4o318n4QbM7zZEyOraU0JVCLO9UUxxzk=;
        b=DM+SQyzdcHDSWULqQhvjtqO3iyjS2bK2H85YUKAqNlAXCCF+c7zg+PaubgP8JXA+oa
         I6UhVu6sHqRyQ56y8Q5VY2v/9RlMJcx3a0UMdtv6P1ZrDXDGnqRW6BUakEiAwfKqBDqk
         HdOIVNeUxVj/t1GXefZKewPShBMoRId7/gkeqCww38UaDTBLhxyp8pKICzife4Ij4aPL
         CEuQyu5dt8uHfZuyU3Oval8z85gr61GJW/IKFE8s+/IbXT4vnRXd+h5bKYhDOgRmCYJm
         3eYv5VN+E46uRkyQjtPyaJmEv0vM+sGSKBLPamN3ghMdgR4rV1Ot3Ph+zB4Eu4zdLQHm
         MRjg==
X-Gm-Message-State: APjAAAWEHeLcjDePOZ+Vst0pee3Lc239uJvA8kfjG7IRwQyRqoaPxMZa
        iWhmu2QbaOJ1km2yd6IY834lMNo3KnZvTipAmU02iQ==
X-Google-Smtp-Source: APXvYqw+/F4AHw6boRI6NsxBlbPtePa1RAcZZT2g4gMVxp3ZaO0AkCph0u66H3gvShYUZOUjtdgntSOH1yEfa+Y0wM4=
X-Received: by 2002:a5e:8a43:: with SMTP id o3mr4416333iom.296.1570037568341;
 Wed, 02 Oct 2019 10:32:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190930233626.22852-1-krish.sadhukhan@oracle.com>
 <20190930233626.22852-2-krish.sadhukhan@oracle.com> <CALMp9eRq+oib=S5X8rxJNxwqQUYRnLrSYcxKxWaxSKid69WJ=w@mail.gmail.com>
 <8d2a861d-cd7f-13c7-87e9-7a1e21b63e2b@oracle.com> <CALMp9eTcXVo73JCKyxLzWz9s_VZ52UV3y_XJtyhC-MnkYRJCbQ@mail.gmail.com>
 <9b881861-260d-fbf8-c740-20ca93aa2ae9@oracle.com>
In-Reply-To: <9b881861-260d-fbf8-c740-20ca93aa2ae9@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 2 Oct 2019 10:32:36 -0700
Message-ID: <CALMp9eTr3Hqe-d7avFksTm+FkTOLv+g30CZEfQazu5z_zw7Jmw@mail.gmail.com>
Subject: Re: [PATCH] nVMX: Defer error from VM-entry MSR-load area to until
 after hardware verifies VMCS guest state-area
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 2, 2019 at 10:16 AM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 10/1/19 3:02 PM, Jim Mattson wrote:
> > On Tue, Oct 1, 2019 at 2:23 PM Krish Sadhukhan
> > <krish.sadhukhan@oracle.com>  wrote:
> >>
> >> On 10/01/2019 10:09 AM, Jim Mattson wrote:
> >>> On Mon, Sep 30, 2019 at 5:12 PM Krish Sadhukhan
> >>> <krish.sadhukhan@oracle.com>  wrote:
> >>>> According to section =E2=80=9CVM Entries=E2=80=9D in Intel SDM vol 3=
C, VM-entry checks are
> >>>> performed in a certain order. Checks on MSRs that are loaded on VM-e=
ntry
> >>>> from VM-entry MSR-load area, should be done after verifying VMCS con=
trols,
> >>>> host-state area and guest-state area. As KVM relies on CPU hardware =
to
> >>>> perform some of these checks, we need to defer VM-exit due to invali=
d
> >>>> VM-entry MSR-load area to until after CPU hardware completes the ear=
lier
> >>>> checks and is ready to do VMLAUNCH/VMRESUME.
> >>>>
> >>>> In order to defer errors arising from invalid VM-entry MSR-load area=
 in
> >>>> vmcs12, we set up a single invalid entry, which is illegal according=
 to
> >>>> section "Loading MSRs in Intel SDM vol 3C, in VM-entry MSR-load area=
 of
> >>>> vmcs02. This will cause the CPU hardware to VM-exit with "VM-entry f=
ailure
> >>>> due to MSR loading" after it completes checks on VMCS controls, host=
-state
> >>>> area and guest-state area. We reflect a synthesized Exit Qualificati=
on to
> >>>> our guest.
> >>> This change addresses the priority inversion, but it still potentiall=
y
> >>> leaves guest MSRs incorrectly loaded with values from the VMCS12
> >>> VM-entry MSR-load area when a higher priority error condition would
> >>> have precluded any processing of the VM-entry MSR-load area.
> >> May be, we should not load any guest MSR until we have checked the
> >> entire vmcs12 MSR-load area in nested_vmx_load_msr()  ?
> > That's not sufficient. We shouldn't load any guest MSR until all of
> > the checks on host state, controls, and guest state have passed. Since
> > we defer the guest state checks to hardware, that makes the proper
> > ordering a bit problematic. Instead, you can try to arrange to undo
> > the guest MSR loads if a higher priority error is discovered. That
> > won't be trivial.
>
>
> We discussed about undoing guest MSR loads in an earlier thread. You
> said that some MSR updates couldn't be rolled back. If we can't rollback
> some MSR updates and if that leads to an undefined guest configuration,
> may be we should return to L0 and mark it as a hardware failure, like
> what we currently do for some VM-entry failures in vmx_handle_exit():

The MSR loads that can't be rolled back are mainly the ones with
side-effects, like IA32_PRED_CMD. I think these are mostly benign
(except, perhaps, from a performance perspective). I think it's worth
investigating rollback as a partial solution to this problem.

>
>      if (exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
>                  dump_vmcs();
>                  vcpu->run->exit_reason =3D KVM_EXIT_FAIL_ENTRY;
> vcpu->run->fail_entry.hardware_entry_failure_reason
>                          =3D exit_reason;
>                  return 0;
>          }
>
>
> >>>> Suggested-by: Jim Mattson<jmattson@google.com>
> >>>> Signed-off-by: Krish Sadhukhan<krish.sadhukhan@oracle.com>
> >>>> Reviewed-by: Mihai Carabas<mihai.carabas@oracle.com>
> >>>> Reviewed-by: Liran Alon<liran.alon@oracle.com>
> >>>> ---
> >>>>    arch/x86/kvm/vmx/nested.c | 34 +++++++++++++++++++++++++++++++---
> >>>>    arch/x86/kvm/vmx/nested.h | 14 ++++++++++++--
> >>>>    arch/x86/kvm/vmx/vmcs.h   |  6 ++++++
> >>>>    3 files changed, 49 insertions(+), 5 deletions(-)
> >>>>
> >>>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> >>>> index ced9fba32598..b74491c04090 100644
> >>>> --- a/arch/x86/kvm/vmx/nested.c
> >>>> +++ b/arch/x86/kvm/vmx/nested.c
> >>>> @@ -3054,12 +3054,40 @@ int nested_vmx_enter_non_root_mode(struct kv=
m_vcpu *vcpu, bool from_vmentry)
> >>>>                   goto vmentry_fail_vmexit_guest_mode;
> >>>>
> >>>>           if (from_vmentry) {
> >>>> -               exit_reason =3D EXIT_REASON_MSR_LOAD_FAIL;
> >>>>                   exit_qual =3D nested_vmx_load_msr(vcpu,
> >>>>                                                   vmcs12->vm_entry_m=
sr_load_addr,
> >>>>                                                   vmcs12->vm_entry_m=
sr_load_count);
> >>>> -               if (exit_qual)
> >>>> -                       goto vmentry_fail_vmexit_guest_mode;
> >>>> +               if (exit_qual) {
> >>>> +                       /*
> >>>> +                        * According to section =E2=80=9CVM Entries=
=E2=80=9D in Intel SDM
> >>>> +                        * vol 3C, VM-entry checks are performed in =
a certain
> >>>> +                        * order. Checks on MSRs that are loaded on =
VM-entry
> >>>> +                        * from VM-entry MSR-load area, should be do=
ne after
> >>>> +                        * verifying VMCS controls, host-state area =
and
> >>>> +                        * guest-state area. As KVM relies on CPU ha=
rdware to
> >>>> +                        * perform some of these checks, we need to =
defer
> >>>> +                        * VM-exit due to invalid VM-entry MSR-load =
area to
> >>>> +                        * until after CPU hardware completes the ea=
rlier
> >>>> +                        * checks and is ready to do VMLAUNCH/VMRESU=
ME.
> >>>> +                        *
> >>>> +                        * In order to defer errors arising from inv=
alid
> >>>> +                        * VM-entry MSR-load area in vmcs12, we set =
up a
> >>>> +                        * single invalid entry, which is illegal ac=
cording
> >>>> +                        * to section "Loading MSRs in Intel SDM vol=
 3C, in
> >>>> +                        * VM-entry MSR-load area of vmcs02. This wi=
ll cause
> >>>> +                        * the CPU hardware to VM-exit with "VM-entr=
y
> >>>> +                        * failure due to MSR loading" after it comp=
letes
> >>>> +                        * checks on VMCS controls, host-state area =
and
> >>>> +                        * guest-state area.
> >>>> +                        */
> >>>> +                       vmx->loaded_vmcs->invalid_msr_load_area.inde=
x =3D
> >>>> +                           MSR_FS_BASE;
> >>> Can this field be statically populated during initialization?
> >> Yes.
> >>
> >>>> +                       vmx->loaded_vmcs->invalid_msr_load_area.valu=
e =3D
> >>>> +                           exit_qual;
> >>> This seems awkward. Why not save 16 bytes per loaded_vmcs by
> >>> allocating one invalid_msr_load_area system-wide and just add a 4 byt=
e
> >>> field to struct nested_vmx to store this value?
> >> OK.
> >>
> >>>> +                       vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, 1);
> >>>> +                       vmcs_write64(VM_ENTRY_MSR_LOAD_ADDR,
> >>>> +                           __pa(&(vmx->loaded_vmcs->invalid_msr_loa=
d_area)));
> >>>> +               }
> >>> Do you need to set vmx->nested.dirty_vmcs12 to ensure that
> >>> prepare_vmcs02_constant_state() will be called at the next emulated
> >>> VM-entry, to undo this change to VM_ENTRY_MSR_LOAD_ADDR?
> >> Yes.
> >>
> >>>>           } else {
> >>>>                   /*
> >>>>                    * The MMU is not initialized to point at the righ=
t entities yet and
> >>>> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> >>>> index 187d39bf0bf1..f3a384235b68 100644
> >>>> --- a/arch/x86/kvm/vmx/nested.h
> >>>> +++ b/arch/x86/kvm/vmx/nested.h
> >>>> @@ -64,7 +64,9 @@ static inline bool nested_ept_ad_enabled(struct kv=
m_vcpu *vcpu)
> >>>>    static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu=
,
> >>>>                                               u32 exit_reason)
> >>>>    {
> >>>> +       u32 exit_qual;
> >>>>           u32 exit_intr_info =3D vmcs_read32(VM_EXIT_INTR_INFO);
> >>>> +       struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> >>>>
> >>>>           /*
> >>>>            * At this point, the exit interruption info in exit_intr_=
info
> >>>> @@ -81,8 +83,16 @@ static inline int nested_vmx_reflect_vmexit(struc=
t kvm_vcpu *vcpu,
> >>>>                           vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
> >>>>           }
> >>>>
> >>>> -       nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info,
> >>>> -                         vmcs_readl(EXIT_QUALIFICATION));
> >>>> +       exit_qual =3D vmcs_readl(EXIT_QUALIFICATION);
> >>>> +
> >>>> +       if (vmx->loaded_vmcs->invalid_msr_load_area.index =3D=3D MSR=
_FS_BASE &&
> >>>> +           (exit_reason =3D=3D (VMX_EXIT_REASONS_FAILED_VMENTRY |
> >>>> +                           EXIT_REASON_MSR_LOAD_FAIL))) {
> >>> Is the second conjunct sufficient? i.e. Isn't there a bug in kvm if
> >>> the second conjunct is true and the first is not?
> >> If the first conjunct isn't true and the second one is, it means it's =
a
> >> hardware-detected MSR-load error. Right ? So won't that be handled the
> >> same way it is handled currently in KVM ?
> > I believe that KVM will currently forward such an error to L1, which
> > is wrong, since L1 has no control over vmcs02's VM-entry MSR-load
> > area.
>
>
> You are right. I hadn't noticed it until you mentioned.
>
>
> >   The assumption is that this will never happen, because L0 is too
> > careful.
> >>>> +               exit_qual =3D vmx->loaded_vmcs->invalid_msr_load_are=
a.value;
> >>>> +       }
> >>>> +
> >>>> +       nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info, exit_qu=
al);
> >>>> +
> >>>>           return 1;
> >>>>    }
> >>>>
> >>>> diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
> >>>> index 481ad879197b..e272788bd4b8 100644
> >>>> --- a/arch/x86/kvm/vmx/vmcs.h
> >>>> +++ b/arch/x86/kvm/vmx/vmcs.h
> >>>> @@ -70,6 +70,12 @@ struct loaded_vmcs {
> >>>>           struct list_head loaded_vmcss_on_cpu_link;
> >>>>           struct vmcs_host_state host_state;
> >>>>           struct vmcs_controls_shadow controls_shadow;
> >>>> +       /*
> >>>> +        * This field is used to set up an invalid VM-entry MSR-load=
 area
> >>>> +        * for vmcs02 if an error is detected while processing the e=
ntries
> >>>> +        * in VM-entry MSR-load area of vmcs12.
> >>>> +        */
> >>>> +       struct vmx_msr_entry invalid_msr_load_area;
> >>>>    };
> >>> I'd suggest allocating just one invalid_msr_load_area system-wide, as
> >>> mentioned above.
> >>>
> >>>>    static inline bool is_exception_n(u32 intr_info, u8 vector)
> >>>> --
> >>>> 2.20.1
> >>>>
