Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14172D6C2F
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 01:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388556AbgLJXuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 18:50:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:35358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727339AbgLJXuI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 18:50:08 -0500
X-Gm-Message-State: AOAM530F8uhroZBu/ZM8jWWQOTCzjd0MD9e2hxsT0uTYujCpqjmEfFdV
        OHcCd/crrP6jS4F2ql7jKAliKZbQPDvIKs0awtHaJw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607644167;
        bh=MNNMeYO9+guDTInb22HPk68dS0IUQC+Ud3eyI+lT8fA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LnLRBasBY1OnXFrE3zkb89Bd9VCJQX+b6uinZP/zKoFwQ0KbqSQhZ14d1WNp2yydR
         MSL8RoxWtpWRmQKwqKAfKWapb0ncx7C6wCb+DZ2MaOgm4/Ck9+zOx6t8Uu/FO5B/k1
         SlJpmq1yXDVsBuTNW4r88CpGQgrfKjco44GDJzAkcuAd9zLTrT5n75wW1Gfb+KbfMp
         iWI6l5lizZBM9GEHm1plrIwPRKhgkHsBFVdZoYvSffYnEgVD3oiImdTgSWTIuAMenF
         a9pgeHdurrqRH1ccY3v868C0PzaHvql7x8EDo6TVrPrfsNC1ftUb6fMXp221QyWhZ2
         KfEMi2Qc2M6HA==
X-Google-Smtp-Source: ABdhPJyQSI/08f4R+UFh2uQXcgYej8irWAt32vwINXfV4OmsDyhqXFa9TMyzQMtfy4aGyLuDiACHeYjpVHvNzi4D2xo=
X-Received: by 2002:adf:ef51:: with SMTP id c17mr10637732wrp.184.1607644165804;
 Thu, 10 Dec 2020 15:49:25 -0800 (PST)
MIME-Version: 1.0
References: <20201210174814.1122585-1-michael.roth@amd.com>
 <CALCETrXo+2LjUt_ObxV+6u6719gTVaMR4-KCrgsjQVRe=xPo+g@mail.gmail.com> <160763562772.1125101.13951354991725886671@vm0>
In-Reply-To: <160763562772.1125101.13951354991725886671@vm0>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 10 Dec 2020 15:49:14 -0800
X-Gmail-Original-Message-ID: <CALCETrV2-WwV+uz99r2RCJx6OADzwxaLxPUVW22wjHoAAN5cSQ@mail.gmail.com>
Message-ID: <CALCETrV2-WwV+uz99r2RCJx6OADzwxaLxPUVW22wjHoAAN5cSQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: use vmsave/vmload for saving/restoring
 additional host state
To:     Michael Roth <michael.roth@amd.com>
Cc:     Andy Lutomirski <luto@kernel.org>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Dec 10, 2020, at 1:27 PM, Michael Roth <michael.roth@amd.com> wrote:
>
> =EF=BB=BFQuoting Andy Lutomirski (2020-12-10 13:23:19)
>>> On Thu, Dec 10, 2020 at 9:52 AM Michael Roth <michael.roth@amd.com> wro=
te:
>>>  MSR_STAR, MSR_LSTAR, MSR_CSTAR,
>>>  MSR_SYSCALL_MASK, MSR_KERNEL_GS_BASE,
>>>  MSR_IA32_SYSENTER_CS,
>>>  MSR_IA32_SYSENTER_ESP,
>>>  MSR_IA32_SYSENTER_EIP,
>>>  MSR_FS_BASE, MSR_GS_BASE
>>
>> Can you get rid of all the old FS/GS manipulation at the same time?
>>
>>> +       for (i =3D 0; i < NR_HOST_SAVE_USER_MSRS; i++) {
>>> +               rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
>>> +       }
>>> +
>>> +       asm volatile(__ex("vmsave")
>>> +                    : : "a" (page_to_pfn(sd->save_area) << PAGE_SHIFT)
>>> +                    : "memory");
>>> +       /*
>>> +        * Host FS/GS segment registers might be restored soon after
>>> +        * vmexit, prior to vmload of host save area. Even though this
>>> +        * state is now saved in the host's save area, we cannot use
>>> +        * per-cpu accesses until these registers are restored, so we
>>> +        * store a copy in the VCPU struct to make sure they are
>>> +        * accessible.
>>> +        */
>>> #ifdef CONFIG_X86_64
>>> -       rdmsrl(MSR_GS_BASE, to_svm(vcpu)->host.gs_base);
>>> +       svm->host.gs_base =3D hostsa->gs.base;
>>> #endif
>>
>> For example, this comment makes no sense to me.  Just let VMLOAD
>> restore FS/GS and be done with it.  Don't copy those gs_base and
>> gs.base fields -- just delete them please.  (Or are they needed for
>> nested virt for some reason?  If so, please document that.)
>
> Hi Andy,
>
> The main issue is that we restore FS/GS immediately after a vmexit since
> we need them soon-after for things like per-cpu accesses, but the rest
> of the host state only needs to be restored if we're exiting all the way
> out to userspace. That's also why we store a copy of the values, since
> the host can't access the per-cpu save_area beforehand.

>
> In theory I think we probably could use vmload to restore this state
> immediately after vmexit as you're suggesting, but then we will end up
> taking a performance hit for cases where the vmexit can be handled within
> the kernel, which might leave us worse-off than the pre-patch behavior
> for those cases (handling an MMIO for a virtqueue notification when
> vhost_net is enabled, for instance)

Please benchmark this.  WRMSR to MSR_GS_BASE is serializing and may
well be slower than VMLOAD.

>
>>
>>> -       savesegment(fs, svm->host.fs);
>>> -       savesegment(gs, svm->host.gs);
>>> -       svm->host.ldt =3D kvm_read_ldt();
>>> -
>>> -       for (i =3D 0; i < NR_HOST_SAVE_USER_MSRS; i++)
>>> -               rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
>>> +       svm->host.fs =3D hostsa->fs.selector;
>>> +       svm->host.gs =3D hostsa->gs.selector;
>>
>> This too.  Why is the host code thinking about selectors at all?
>>
>>> -       kvm_load_ldt(svm->host.ldt);
>>
>> I have a patch that deletes this, too.  Don't worry about the conflict
>> -- I'll sort it out.
>>
>>> @@ -120,7 +115,6 @@ struct vcpu_svm {
>>>        struct {
>>>                u16 fs;
>>>                u16 gs;
>>> -               u16 ldt;
>>>                u64 gs_base;
>>>        } host;
>>
>> Shouldn't you be about to delete fs, gs, and gs_base too?
>
> For the reasons above it seems like they'd need to be there in some form,
> though we could maybe replace them with a pointer to the per-cpu save_are=
a
> so that they can be accessed directly before GS segment is restored.

I=E2=80=99m confused. Why would you be accessing them before VMLOAD?  These
are host values.

I think there are two reasonable ways to do this:

1. VMLOAD before STGI.  This is obviously correct, and it's quite simple.

2. Save cpu_kernelmode_gs_base(cpu) before VM entry, and restore that
value to MSR_GS_BASE using code like this (or its asm equivalent)
before STGI:

if (static_cpu_has(X86_FEATURE_FSGSBASE))
  wrgsbase(base);
else
  wrmsr...

and then VMLOAD in the vcpu_put() path.

I can't think of any reason to use loadsegment(), load_gs_index(), or
savesegment() at all, nor can I think of any reason to touch
MSR_KERNEL_GS_BASE or MSR_FS_BASE.

--Andy
