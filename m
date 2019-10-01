Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23849C4368
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 00:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbfJAWCq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 18:02:46 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43044 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728239AbfJAWCp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 18:02:45 -0400
Received: by mail-io1-f68.google.com with SMTP id v2so52025771iob.10
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2019 15:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=H4pXN/jkmvRe1kHMFOqtfPACj49B2tInLyE90cS8zjw=;
        b=SWQ8/ZzA5X0SA5kQgqrq9g0yzlxTHr/HxzkJbngbrm7/QaKgLuleaeuqWQyeNDMfwb
         /wpz5o6aknaan37HVhTFqAh9IflgpgtB4fkU5Fr7IRSC/hP0Djztf7vvyfGM+/XJkBZN
         SMCC8pY45swV0rkOu8RN27nQxFGWxKlQ5rhfdWjze83omzbfsdGnVK7mQmKZ71euTASw
         pUYPkmhzm67hnjqBlv60R0OXu+diS+UGWhUBliu8chAEI7CdVU8vSJKcaBMOHpmNGun/
         FMzUV8QHWn24otRiMVXeg19xvo96LdyYudPK0JZv4Nzc3zQ/Py/vava2qqT68HzOIYOx
         P7TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=H4pXN/jkmvRe1kHMFOqtfPACj49B2tInLyE90cS8zjw=;
        b=bgxOSMLtnnL8FeSqmqO000GSeP77f87zvIZaTNLDpy5rPwF/zzh4L12zSrR26XERtV
         VQQ8Hy5SjuBA9gi2o99zGvLe++D75IbTcXLHBHpgldcIkxqOjkFxyduebXS9KqwsN5gR
         yk72aMDaLD4F9oM4ryN0C+cZzp/NUH7ocMsBTavGF2MMWUKOd3jKy1snlic3oX14klZz
         rwvV4RsDnZ+1Tu4/LJuwpbFg0j7sPgJbpgOGBRqAsHo/T3jmU09/gcNpsC+GSZiOuZBT
         YM0FcJiC/+y0vnP3cs33L++yFnthcknEQtP5RtXa9WWa94tq96i2Kdm3wJuZwUKT8bFL
         Dqpg==
X-Gm-Message-State: APjAAAUJFedyMKJFtXfQLRuH1kZ+HKaxW0y5hpGZ1V+wQV3l5UC47lIf
        STO4+UA/bxA4vuvjii5jFjEGdElKyPEcLEXKXsRQHByWTL4=
X-Google-Smtp-Source: APXvYqxefky/Cxy+xtZgFI8CVZX9FB6jnKmoXyNOVUwRWcco3MjJX5tysC3kU4YXmMPy+XhVm9jjSWFqCaVV0f5Gu5U=
X-Received: by 2002:a02:b782:: with SMTP id f2mr640487jam.48.1569967363086;
 Tue, 01 Oct 2019 15:02:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190930233626.22852-1-krish.sadhukhan@oracle.com>
 <20190930233626.22852-2-krish.sadhukhan@oracle.com> <CALMp9eRq+oib=S5X8rxJNxwqQUYRnLrSYcxKxWaxSKid69WJ=w@mail.gmail.com>
 <8d2a861d-cd7f-13c7-87e9-7a1e21b63e2b@oracle.com>
In-Reply-To: <8d2a861d-cd7f-13c7-87e9-7a1e21b63e2b@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 1 Oct 2019 15:02:31 -0700
Message-ID: <CALMp9eTcXVo73JCKyxLzWz9s_VZ52UV3y_XJtyhC-MnkYRJCbQ@mail.gmail.com>
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

On Tue, Oct 1, 2019 at 2:23 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
>
> On 10/01/2019 10:09 AM, Jim Mattson wrote:
> > On Mon, Sep 30, 2019 at 5:12 PM Krish Sadhukhan
> > <krish.sadhukhan@oracle.com> wrote:
> >> According to section =E2=80=9CVM Entries=E2=80=9D in Intel SDM vol 3C,=
 VM-entry checks are
> >> performed in a certain order. Checks on MSRs that are loaded on VM-ent=
ry
> >> from VM-entry MSR-load area, should be done after verifying VMCS contr=
ols,
> >> host-state area and guest-state area. As KVM relies on CPU hardware to
> >> perform some of these checks, we need to defer VM-exit due to invalid
> >> VM-entry MSR-load area to until after CPU hardware completes the earli=
er
> >> checks and is ready to do VMLAUNCH/VMRESUME.
> >>
> >> In order to defer errors arising from invalid VM-entry MSR-load area i=
n
> >> vmcs12, we set up a single invalid entry, which is illegal according t=
o
> >> section "Loading MSRs in Intel SDM vol 3C, in VM-entry MSR-load area o=
f
> >> vmcs02. This will cause the CPU hardware to VM-exit with "VM-entry fai=
lure
> >> due to MSR loading" after it completes checks on VMCS controls, host-s=
tate
> >> area and guest-state area. We reflect a synthesized Exit Qualification=
 to
> >> our guest.
> > This change addresses the priority inversion, but it still potentially
> > leaves guest MSRs incorrectly loaded with values from the VMCS12
> > VM-entry MSR-load area when a higher priority error condition would
> > have precluded any processing of the VM-entry MSR-load area.
>
> May be, we should not load any guest MSR until we have checked the
> entire vmcs12 MSR-load area in nested_vmx_load_msr()  ?

That's not sufficient. We shouldn't load any guest MSR until all of
the checks on host state, controls, and guest state have passed. Since
we defer the guest state checks to hardware, that makes the proper
ordering a bit problematic. Instead, you can try to arrange to undo
the guest MSR loads if a higher priority error is discovered. That
won't be trivial.

> >
> >> Suggested-by: Jim Mattson <jmattson@google.com>
> >> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> >> Reviewed-by: Mihai Carabas <mihai.carabas@oracle.com>
> >> Reviewed-by: Liran Alon <liran.alon@oracle.com>
> >> ---
> >>   arch/x86/kvm/vmx/nested.c | 34 +++++++++++++++++++++++++++++++---
> >>   arch/x86/kvm/vmx/nested.h | 14 ++++++++++++--
> >>   arch/x86/kvm/vmx/vmcs.h   |  6 ++++++
> >>   3 files changed, 49 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> >> index ced9fba32598..b74491c04090 100644
> >> --- a/arch/x86/kvm/vmx/nested.c
> >> +++ b/arch/x86/kvm/vmx/nested.c
> >> @@ -3054,12 +3054,40 @@ int nested_vmx_enter_non_root_mode(struct kvm_=
vcpu *vcpu, bool from_vmentry)
> >>                  goto vmentry_fail_vmexit_guest_mode;
> >>
> >>          if (from_vmentry) {
> >> -               exit_reason =3D EXIT_REASON_MSR_LOAD_FAIL;
> >>                  exit_qual =3D nested_vmx_load_msr(vcpu,
> >>                                                  vmcs12->vm_entry_msr_=
load_addr,
> >>                                                  vmcs12->vm_entry_msr_=
load_count);
> >> -               if (exit_qual)
> >> -                       goto vmentry_fail_vmexit_guest_mode;
> >> +               if (exit_qual) {
> >> +                       /*
> >> +                        * According to section =E2=80=9CVM Entries=E2=
=80=9D in Intel SDM
> >> +                        * vol 3C, VM-entry checks are performed in a =
certain
> >> +                        * order. Checks on MSRs that are loaded on VM=
-entry
> >> +                        * from VM-entry MSR-load area, should be done=
 after
> >> +                        * verifying VMCS controls, host-state area an=
d
> >> +                        * guest-state area. As KVM relies on CPU hard=
ware to
> >> +                        * perform some of these checks, we need to de=
fer
> >> +                        * VM-exit due to invalid VM-entry MSR-load ar=
ea to
> >> +                        * until after CPU hardware completes the earl=
ier
> >> +                        * checks and is ready to do VMLAUNCH/VMRESUME=
.
> >> +                        *
> >> +                        * In order to defer errors arising from inval=
id
> >> +                        * VM-entry MSR-load area in vmcs12, we set up=
 a
> >> +                        * single invalid entry, which is illegal acco=
rding
> >> +                        * to section "Loading MSRs in Intel SDM vol 3=
C, in
> >> +                        * VM-entry MSR-load area of vmcs02. This will=
 cause
> >> +                        * the CPU hardware to VM-exit with "VM-entry
> >> +                        * failure due to MSR loading" after it comple=
tes
> >> +                        * checks on VMCS controls, host-state area an=
d
> >> +                        * guest-state area.
> >> +                        */
> >> +                       vmx->loaded_vmcs->invalid_msr_load_area.index =
=3D
> >> +                           MSR_FS_BASE;
> > Can this field be statically populated during initialization?
>
> Yes.
>
> >
> >> +                       vmx->loaded_vmcs->invalid_msr_load_area.value =
=3D
> >> +                           exit_qual;
> > This seems awkward. Why not save 16 bytes per loaded_vmcs by
> > allocating one invalid_msr_load_area system-wide and just add a 4 byte
> > field to struct nested_vmx to store this value?
>
> OK.
>
> >
> >> +                       vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, 1);
> >> +                       vmcs_write64(VM_ENTRY_MSR_LOAD_ADDR,
> >> +                           __pa(&(vmx->loaded_vmcs->invalid_msr_load_=
area)));
> >> +               }
> > Do you need to set vmx->nested.dirty_vmcs12 to ensure that
> > prepare_vmcs02_constant_state() will be called at the next emulated
> > VM-entry, to undo this change to VM_ENTRY_MSR_LOAD_ADDR?
>
> Yes.
>
> >
> >>          } else {
> >>                  /*
> >>                   * The MMU is not initialized to point at the right e=
ntities yet and
> >> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> >> index 187d39bf0bf1..f3a384235b68 100644
> >> --- a/arch/x86/kvm/vmx/nested.h
> >> +++ b/arch/x86/kvm/vmx/nested.h
> >> @@ -64,7 +64,9 @@ static inline bool nested_ept_ad_enabled(struct kvm_=
vcpu *vcpu)
> >>   static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
> >>                                              u32 exit_reason)
> >>   {
> >> +       u32 exit_qual;
> >>          u32 exit_intr_info =3D vmcs_read32(VM_EXIT_INTR_INFO);
> >> +       struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> >>
> >>          /*
> >>           * At this point, the exit interruption info in exit_intr_inf=
o
> >> @@ -81,8 +83,16 @@ static inline int nested_vmx_reflect_vmexit(struct =
kvm_vcpu *vcpu,
> >>                          vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
> >>          }
> >>
> >> -       nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info,
> >> -                         vmcs_readl(EXIT_QUALIFICATION));
> >> +       exit_qual =3D vmcs_readl(EXIT_QUALIFICATION);
> >> +
> >> +       if (vmx->loaded_vmcs->invalid_msr_load_area.index =3D=3D MSR_F=
S_BASE &&
> >> +           (exit_reason =3D=3D (VMX_EXIT_REASONS_FAILED_VMENTRY |
> >> +                           EXIT_REASON_MSR_LOAD_FAIL))) {
> > Is the second conjunct sufficient? i.e. Isn't there a bug in kvm if
> > the second conjunct is true and the first is not?
>
> If the first conjunct isn't true and the second one is, it means it's a
> hardware-detected MSR-load error. Right ? So won't that be handled the
> same way it is handled currently in KVM ?

I believe that KVM will currently forward such an error to L1, which
is wrong, since L1 has no control over vmcs02's VM-entry MSR-load
area. The assumption is that this will never happen, because L0 is too
careful.

> >
> >> +               exit_qual =3D vmx->loaded_vmcs->invalid_msr_load_area.=
value;
> >> +       }
> >> +
> >> +       nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info, exit_qual=
);
> >> +
> >>          return 1;
> >>   }
> >>
> >> diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
> >> index 481ad879197b..e272788bd4b8 100644
> >> --- a/arch/x86/kvm/vmx/vmcs.h
> >> +++ b/arch/x86/kvm/vmx/vmcs.h
> >> @@ -70,6 +70,12 @@ struct loaded_vmcs {
> >>          struct list_head loaded_vmcss_on_cpu_link;
> >>          struct vmcs_host_state host_state;
> >>          struct vmcs_controls_shadow controls_shadow;
> >> +       /*
> >> +        * This field is used to set up an invalid VM-entry MSR-load a=
rea
> >> +        * for vmcs02 if an error is detected while processing the ent=
ries
> >> +        * in VM-entry MSR-load area of vmcs12.
> >> +        */
> >> +       struct vmx_msr_entry invalid_msr_load_area;
> >>   };
> > I'd suggest allocating just one invalid_msr_load_area system-wide, as
> > mentioned above.
> >
> >>   static inline bool is_exception_n(u32 intr_info, u8 vector)
> >> --
> >> 2.20.1
> >>
>
