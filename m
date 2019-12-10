Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F215119C47
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 23:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfLJWWo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 17:22:44 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42834 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbfLJWWo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 17:22:44 -0500
Received: by mail-pg1-f194.google.com with SMTP id s64so2861978pgb.9
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 14:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Qch1l8KF90lo9VxFpsbc1dlSY7m9TzYWt7RDlak72I8=;
        b=YLb0KiS8GeV9eb0tVGz7tVYc17VNJjfRnNINSPWd0kxUtM7wf42S5CUGFY4mt6Pp8M
         itgH770s7vVE9bapkr+LaL9vZ1FvwY5jNv7LI423juPjotWKle8/VgrCUFP+pIw0Q4gK
         qTxAH5Ae+VvLINb1R2wIUKOW45lM6u/V7VYe5vgAhfm8GlFlbWAyER3RvK7MYScU3F/n
         tLJJSUQf0zSDedKH1gX5SwkG6d5+zeUI61KU8C0eEvu5OICqShHTj0B42XEWq2tFaLAl
         fTrK+rVaKI5r0tj+5fg2Zaj5f4GHLJCo/lvzWdntKuMUU1JCDSV4BhA3UKKOOcQVeQ2N
         qxnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Qch1l8KF90lo9VxFpsbc1dlSY7m9TzYWt7RDlak72I8=;
        b=bA/74KAwNewyG4v411JvukmH93k4nHgGVs/RAh5CbFmIrXiGFLYTF45HPsdOslz6bd
         6McMECEnfdCOKMIqvBe5IFjlvbvbJozAxCkEhR6CWZt7S+wwSqnSU/3i4sJjjxzlt+Ez
         VxDTmj0ZuWRxlBv1ofv2WdVahiQs+wEQ4PCesDa5ZCZlEAbZrfvtPnxkUKAsBlPeVRV/
         kdzzMEkEsdvfjo+T07D7BfMlcGYznpWXEM3LkKX6DXyqlZdJRqXz4iLGWrV2LAq13GUN
         3fXW9tyVhEr7S+V4uNotcFR8RWiaXUW/oaFdqOH1s2NnEKaM4HNvRQaqo18Ox8k7eqLs
         2q1g==
X-Gm-Message-State: APjAAAUnGhNj54eNUU9WcnRwyw9tXlT4eSLljraIp1ywCB+DbNSKe4RL
        /ZQrgE/Fd3pT7q/5U947zCc=
X-Google-Smtp-Source: APXvYqxrOkwovxdL1hFYex2u7NojsIAf919o5xD2401jGD2XlQ/nwr6+ahaX0hbQnqpt3RdTB63yDw==
X-Received: by 2002:a62:8782:: with SMTP id i124mr236283pfe.22.1576016563126;
        Tue, 10 Dec 2019 14:22:43 -0800 (PST)
Received: from [10.2.144.69] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id x13sm32465pfc.171.2019.12.10.14.22.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Dec 2019 14:22:42 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Subject: Re: [PATCH] kvm: nVMX: VMWRITE checks VMCS-link pointer before VMCS
 field
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <C9182191-EE97-4F1B-A672-010BC160C07D@oracle.com>
Date:   Tue, 10 Dec 2019 14:22:41 -0800
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A29A1722-046B-4EE5-98B9-09D5FB300B96@gmail.com>
References: <20191204214027.85958-1-jmattson@google.com>
 <b9067562-bbba-7904-84f0-593f90577fca@redhat.com>
 <CALMp9eRbiKnH15NBFk0hrh8udcqZvu6RHm0Nrfh4TikQ3xF6OA@mail.gmail.com>
 <CALMp9eTyhRwqsriLGg1xoO2sOPkgnKK1hV1U3C733xCjW7+VCA@mail.gmail.com>
 <C2F9C5D9-F106-4B89-BEFA-B3CCC0B004DE@oracle.com>
 <F709B998-3A28-4BA0-B9DD-0AEF4D6B26C1@gmail.com>
 <C9182191-EE97-4F1B-A672-010BC160C07D@oracle.com>
To:     Liran Alon <liran.alon@oracle.com>
X-Mailer: Apple Mail (2.3601.0.10)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Dec 9, 2019, at 2:58 PM, Liran Alon <liran.alon@oracle.com> wrote:
>=20
>=20
>=20
>> On 9 Dec 2019, at 17:28, Nadav Amit <nadav.amit@gmail.com> wrote:
>>=20
>>> On Dec 5, 2019, at 1:54 PM, Liran Alon <liran.alon@oracle.com> =
wrote:
>>>=20
>>>=20
>>>=20
>>>> On 5 Dec 2019, at 23:30, Jim Mattson <jmattson@google.com> wrote:
>>>>=20
>>>> On Thu, Dec 5, 2019 at 5:11 AM Jim Mattson <jmattson@google.com> =
wrote:
>>>>> On Thu, Dec 5, 2019 at 3:46 AM Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>>>>>> On 04/12/19 22:40, Jim Mattson wrote:
>>>>>>> According to the SDM, a VMWRITE in VMX non-root operation with =
an
>>>>>>> invalid VMCS-link pointer results in VMfailInvalid before the =
validity
>>>>>>> of the VMCS field in the secondary source operand is checked.
>>>>>>>=20
>>>>>>> Fixes: 6d894f498f5d1 ("KVM: nVMX: vmread/vmwrite: Use shadow =
vmcs12 if running L2")
>>>>>>> Signed-off-by: Jim Mattson <jmattson@google.com>
>>>>>>> Cc: Liran Alon <liran.alon@oracle.com>
>>>>>>> ---
>>>>>>> arch/x86/kvm/vmx/nested.c | 38 =
+++++++++++++++++++-------------------
>>>>>>> 1 file changed, 19 insertions(+), 19 deletions(-)
>>>>>>=20
>>>>>> As Vitaly pointed out, the test must be split in two, like this:
>>>>>=20
>>>>> Right. Odd that no kvm-unit-tests noticed.
>>>>>=20
>>>>>> ---------------- 8< -----------------------
>>>>>> =46rom 3b9d87060e800ffae2bd19da94ede05018066c87 Mon Sep 17 =
00:00:00 2001
>>>>>> From: Paolo Bonzini <pbonzini@redhat.com>
>>>>>> Date: Thu, 5 Dec 2019 12:39:07 +0100
>>>>>> Subject: [PATCH] kvm: nVMX: VMWRITE checks VMCS-link pointer =
before VMCS field
>>>>>>=20
>>>>>> According to the SDM, a VMWRITE in VMX non-root operation with an
>>>>>> invalid VMCS-link pointer results in VMfailInvalid before the =
validity
>>>>>> of the VMCS field in the secondary source operand is checked.
>>>>>>=20
>>>>>> While cleaning up handle_vmwrite, make the code of handle_vmread =
look
>>>>>> the same, too.
>>>>>=20
>>>>> Okay.
>>>>>=20
>>>>>> Fixes: 6d894f498f5d1 ("KVM: nVMX: vmread/vmwrite: Use shadow =
vmcs12 if running L2")
>>>>>> Signed-off-by: Jim Mattson <jmattson@google.com>
>>>>>> Cc: Liran Alon <liran.alon@oracle.com>
>>>>>>=20
>>>>>> diff --git a/arch/x86/kvm/vmx/nested.c =
b/arch/x86/kvm/vmx/nested.c
>>>>>> index 4aea7d304beb..c080a879b95d 100644
>>>>>> --- a/arch/x86/kvm/vmx/nested.c
>>>>>> +++ b/arch/x86/kvm/vmx/nested.c
>>>>>> @@ -4767,14 +4767,13 @@ static int handle_vmread(struct kvm_vcpu =
*vcpu)
>>>>>>     if (to_vmx(vcpu)->nested.current_vmptr =3D=3D -1ull)
>>>>>>             return nested_vmx_failInvalid(vcpu);
>>>>>>=20
>>>>>> -       if (!is_guest_mode(vcpu))
>>>>>> -               vmcs12 =3D get_vmcs12(vcpu);
>>>>>> -       else {
>>>>>> +       vmcs12 =3D get_vmcs12(vcpu);
>>>>>> +       if (is_guest_mode(vcpu)) {
>>>>>>             /*
>>>>>>              * When vmcs->vmcs_link_pointer is -1ull, any VMREAD
>>>>>>              * to shadowed-field sets the ALU flags for =
VMfailInvalid.
>>>>>>              */
>>>>>> -               if (get_vmcs12(vcpu)->vmcs_link_pointer =3D=3D =
-1ull)
>>>>>> +               if (vmcs12->vmcs_link_pointer =3D=3D -1ull)
>>>>>>                     return nested_vmx_failInvalid(vcpu);
>>>>>>             vmcs12 =3D get_shadow_vmcs12(vcpu);
>>>>>>     }
>>>>>> @@ -4878,8 +4877,19 @@ static int handle_vmwrite(struct kvm_vcpu =
*vcpu)
>>>>>>             }
>>>>>>     }
>>>>>>=20
>>>>>> +       vmcs12 =3D get_vmcs12(vcpu);
>>>>>> +       if (is_guest_mode(vcpu)) {
>>>>>> +               /*
>>>>>> +                * When vmcs->vmcs_link_pointer is -1ull, any =
VMWRITE
>>>>>> +                * to shadowed-field sets the ALU flags for =
VMfailInvalid.
>>>>>> +                */
>>>>>> +               if (vmcs12->vmcs_link_pointer =3D=3D -1ull)
>>>>>> +                       return nested_vmx_failInvalid(vcpu);
>>>>>> +               vmcs12 =3D get_shadow_vmcs12(vcpu);
>>>>>> +       }
>>>>>>=20
>>>>>>     field =3D kvm_register_readl(vcpu, (((vmx_instruction_info) =
>> 28) & 0xf));
>>>>>> +
>>>>>>     /*
>>>>>>      * If the vCPU supports "VMWRITE to any supported field in =
the
>>>>>>      * VMCS," then the "read-only" fields are actually =
read/write.
>>>>>> @@ -4889,24 +4899,12 @@ static int handle_vmwrite(struct kvm_vcpu =
*vcpu)
>>>>>>             return nested_vmx_failValid(vcpu,
>>>>>>                     VMXERR_VMWRITE_READ_ONLY_VMCS_COMPONENT);
>>>>>>=20
>>>>>> -       if (!is_guest_mode(vcpu)) {
>>>>>> -               vmcs12 =3D get_vmcs12(vcpu);
>>>>>> -
>>>>>> -               /*
>>>>>> -                * Ensure vmcs12 is up-to-date before any VMWRITE =
that dirties
>>>>>> -                * vmcs12, else we may crush a field or consume a =
stale value.
>>>>>> -                */
>>>>>> -               if (!is_shadow_field_rw(field))
>>>>>> -                       copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
>>>>>> -       } else {
>>>>>> -               /*
>>>>>> -                * When vmcs->vmcs_link_pointer is -1ull, any =
VMWRITE
>>>>>> -                * to shadowed-field sets the ALU flags for =
VMfailInvalid.
>>>>>> -                */
>>>>>> -               if (get_vmcs12(vcpu)->vmcs_link_pointer =3D=3D =
-1ull)
>>>>>> -                       return nested_vmx_failInvalid(vcpu);
>>>>>> -               vmcs12 =3D get_shadow_vmcs12(vcpu);
>>>>>> -       }
>>>>>> +       /*
>>>>>> +        * Ensure vmcs12 is up-to-date before any VMWRITE that =
dirties
>>>>>> +        * vmcs12, else we may crush a field or consume a stale =
value.
>>>>>> +        */
>>>>>> +       if (!is_guest_mode(vcpu) && !is_shadow_field_rw(field))
>>>>>> +               copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
>>>>>>=20
>>>>>>     offset =3D vmcs_field_to_offset(field);
>>>>>>     if (offset < 0)
>>>>>>=20
>>>>>>=20
>>>>>> ... and also, do you have a matching kvm-unit-tests patch?
>>>>>=20
>>>>> I'll put one together, along with a test that shows the current
>>>>> priority inversion between read-only and unsupported VMCS fields.
>>>>=20
>>>> I can't figure out how to clear IA32_VMX_MISC[bit 29] in qemu, so =
I'm
>>>> going to add the test to tools/testing/selftests/kvm instead.
>>>=20
>>> Please don=E2=80=99t.
>>>=20
>>> I wish that we keep clear separation between kvm-unit-tests and =
self-tests.
>>> In the sense that kvm-unit-tests tests for correct CPU behaviour =
semantics
>>> and self-tests tests for correctness of KVM userspace API.
>>>=20
>>> In the future, I wish to change kvm-unit-tests to cpu-unit-tests. As =
there is no
>>> real connection to KVM. It=E2=80=99s a bunch of tests that can be =
run on top of any CPU
>>> Implementation (weather vCPU by some hypervisor or bare-metal CPU) =
and
>>> test for it=E2=80=99s semantics.
>>> I have already used this to find semantic issues on Hyper-V vCPU =
implementation for example.
>>=20
>> Did you use for the matter the =E2=80=9Cinfrastructure=E2=80=9D that =
I added?
>=20
> No. It=E2=80=99s possible to just change QEMU to run with WHPX.
> But it=E2=80=99s true that the =E2=80=9Cinfra=E2=80=9D you added for =
running on Bare-Metal should work as-well.
> This is why I wish to change kvm-unit-tests to cpu-unit-tests. :)

Thanks for the explanation. I may give QEMU+WHPX a try just to see how =
many
bugs it reports.

