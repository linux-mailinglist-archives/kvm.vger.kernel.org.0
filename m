Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F540114913
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 23:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbfLEWLe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 17:11:34 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:44314 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729154AbfLEWLe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 17:11:34 -0500
Received: by mail-io1-f68.google.com with SMTP id z23so5239160iog.11
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2019 14:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ruv23O+bQB67ouXLf42+p6UV2bAoLhd+7la64E8sl0I=;
        b=hiBiY16WovJ2b6ZWyNDJiFTeGXWm8nv2lFsbIdWXPGPRPJ+8QQKAYGRYUJe6E6O8gf
         9Gmd8L6KVxbHfZCGLu6UHVfZVharT4LplBWTFylJeJ0GJ2EFI2tp072wEOa/Ain6S+7+
         kiahM8sMWf2sXb1sf3cF7QHPjWzV+SkZVfpa7t6WDVHHh7NUAnjY/IKz+0UHMemu292W
         R7LWslvrON74+Vksg+THa2UOzfCpAuFBUhMeFP/jLuzdmnxTK4JdnOb7WPPb8+AcfxT1
         TpG/8OcFMrCLENZb5nConYG/pBy0uoTd7SpfqSSz4E3i619Ok1s8aJNoqbl6oWbb1CpX
         nd+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ruv23O+bQB67ouXLf42+p6UV2bAoLhd+7la64E8sl0I=;
        b=Gen2LOFzLmzR38ZN9226obL557K/y5xhtIeCzbdaMNlhWjnAR2Ueb5Nk2jf5SITlue
         Zn/JqkWBh78VlEXG40op04Pl+TvL5oREs0x6qNoklOZTEBpM8Gma2CTE/maJzTFsmylX
         BFcs8tU7LGKiV2Sdd7q/3znXTjf+BnOtQUrpEJDfHlt30uh6+VnoNM8fPljSDOAi+Ktl
         kRrqcEIJ0fEGzBXbrYRZ67KcCytlN3ucqSi+JfMNg9lVHx95NsYLcLzhEUTNnhQwZPzE
         Ef645v3jpSzNpFJgoEyISW1w2nBTpaq/xVSZLnxbkPZmCo5yWMGtsiNIyLDStYQ+a2wD
         fjNA==
X-Gm-Message-State: APjAAAX7lCPPQRg7sAMjR63KNcd/QLSePZm/8pkkVPRbMluGquArtc4D
        ke5NHSYl2PuxKtmf1CJXr3kYMjETY9Hfa2ZUEPmwVy2H8tU=
X-Google-Smtp-Source: APXvYqy65VeLJtvwast17qga6qzV3PXQ8SI9i77Tr7+y4rcTYQYNrCMsAhlaeCBo67GPDB1VLqTGEgzCHfJDHxjefMg=
X-Received: by 2002:a02:40c6:: with SMTP id n189mr10743814jaa.18.1575583892713;
 Thu, 05 Dec 2019 14:11:32 -0800 (PST)
MIME-Version: 1.0
References: <20191204214027.85958-1-jmattson@google.com> <b9067562-bbba-7904-84f0-593f90577fca@redhat.com>
 <CALMp9eRbiKnH15NBFk0hrh8udcqZvu6RHm0Nrfh4TikQ3xF6OA@mail.gmail.com>
 <CALMp9eTyhRwqsriLGg1xoO2sOPkgnKK1hV1U3C733xCjW7+VCA@mail.gmail.com> <C2F9C5D9-F106-4B89-BEFA-B3CCC0B004DE@oracle.com>
In-Reply-To: <C2F9C5D9-F106-4B89-BEFA-B3CCC0B004DE@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 5 Dec 2019 14:11:21 -0800
Message-ID: <CALMp9eQAHyn6WMwisnScFiFu4qK6mPibmm3zHSZQ=updNf72Pw@mail.gmail.com>
Subject: Re: [PATCH] kvm: nVMX: VMWRITE checks VMCS-link pointer before VMCS field
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 5, 2019 at 1:54 PM Liran Alon <liran.alon@oracle.com> wrote:
>
>
>
> > On 5 Dec 2019, at 23:30, Jim Mattson <jmattson@google.com> wrote:
> >
> > On Thu, Dec 5, 2019 at 5:11 AM Jim Mattson <jmattson@google.com> wrote:
> >>
> >> On Thu, Dec 5, 2019 at 3:46 AM Paolo Bonzini <pbonzini@redhat.com> wro=
te:
> >>>
> >>> On 04/12/19 22:40, Jim Mattson wrote:
> >>>> According to the SDM, a VMWRITE in VMX non-root operation with an
> >>>> invalid VMCS-link pointer results in VMfailInvalid before the validi=
ty
> >>>> of the VMCS field in the secondary source operand is checked.
> >>>>
> >>>> Fixes: 6d894f498f5d1 ("KVM: nVMX: vmread/vmwrite: Use shadow vmcs12 =
if running L2")
> >>>> Signed-off-by: Jim Mattson <jmattson@google.com>
> >>>> Cc: Liran Alon <liran.alon@oracle.com>
> >>>> ---
> >>>> arch/x86/kvm/vmx/nested.c | 38 +++++++++++++++++++------------------=
-
> >>>> 1 file changed, 19 insertions(+), 19 deletions(-)
> >>>
> >>> As Vitaly pointed out, the test must be split in two, like this:
> >>
> >> Right. Odd that no kvm-unit-tests noticed.
> >>
> >>> ---------------- 8< -----------------------
> >>> From 3b9d87060e800ffae2bd19da94ede05018066c87 Mon Sep 17 00:00:00 200=
1
> >>> From: Paolo Bonzini <pbonzini@redhat.com>
> >>> Date: Thu, 5 Dec 2019 12:39:07 +0100
> >>> Subject: [PATCH] kvm: nVMX: VMWRITE checks VMCS-link pointer before V=
MCS field
> >>>
> >>> According to the SDM, a VMWRITE in VMX non-root operation with an
> >>> invalid VMCS-link pointer results in VMfailInvalid before the validit=
y
> >>> of the VMCS field in the secondary source operand is checked.
> >>>
> >>> While cleaning up handle_vmwrite, make the code of handle_vmread look
> >>> the same, too.
> >>
> >> Okay.
> >>
> >>> Fixes: 6d894f498f5d1 ("KVM: nVMX: vmread/vmwrite: Use shadow vmcs12 i=
f running L2")
> >>> Signed-off-by: Jim Mattson <jmattson@google.com>
> >>> Cc: Liran Alon <liran.alon@oracle.com>
> >>>
> >>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> >>> index 4aea7d304beb..c080a879b95d 100644
> >>> --- a/arch/x86/kvm/vmx/nested.c
> >>> +++ b/arch/x86/kvm/vmx/nested.c
> >>> @@ -4767,14 +4767,13 @@ static int handle_vmread(struct kvm_vcpu *vcp=
u)
> >>>        if (to_vmx(vcpu)->nested.current_vmptr =3D=3D -1ull)
> >>>                return nested_vmx_failInvalid(vcpu);
> >>>
> >>> -       if (!is_guest_mode(vcpu))
> >>> -               vmcs12 =3D get_vmcs12(vcpu);
> >>> -       else {
> >>> +       vmcs12 =3D get_vmcs12(vcpu);
> >>> +       if (is_guest_mode(vcpu)) {
> >>>                /*
> >>>                 * When vmcs->vmcs_link_pointer is -1ull, any VMREAD
> >>>                 * to shadowed-field sets the ALU flags for VMfailInva=
lid.
> >>>                 */
> >>> -               if (get_vmcs12(vcpu)->vmcs_link_pointer =3D=3D -1ull)
> >>> +               if (vmcs12->vmcs_link_pointer =3D=3D -1ull)
> >>>                        return nested_vmx_failInvalid(vcpu);
> >>>                vmcs12 =3D get_shadow_vmcs12(vcpu);
> >>>        }
> >>> @@ -4878,8 +4877,19 @@ static int handle_vmwrite(struct kvm_vcpu *vcp=
u)
> >>>                }
> >>>        }
> >>>
> >>> +       vmcs12 =3D get_vmcs12(vcpu);
> >>> +       if (is_guest_mode(vcpu)) {
> >>> +               /*
> >>> +                * When vmcs->vmcs_link_pointer is -1ull, any VMWRITE
> >>> +                * to shadowed-field sets the ALU flags for VMfailInv=
alid.
> >>> +                */
> >>> +               if (vmcs12->vmcs_link_pointer =3D=3D -1ull)
> >>> +                       return nested_vmx_failInvalid(vcpu);
> >>> +               vmcs12 =3D get_shadow_vmcs12(vcpu);
> >>> +       }
> >>>
> >>>        field =3D kvm_register_readl(vcpu, (((vmx_instruction_info) >>=
 28) & 0xf));
> >>> +
> >>>        /*
> >>>         * If the vCPU supports "VMWRITE to any supported field in the
> >>>         * VMCS," then the "read-only" fields are actually read/write.
> >>> @@ -4889,24 +4899,12 @@ static int handle_vmwrite(struct kvm_vcpu *vc=
pu)
> >>>                return nested_vmx_failValid(vcpu,
> >>>                        VMXERR_VMWRITE_READ_ONLY_VMCS_COMPONENT);
> >>>
> >>> -       if (!is_guest_mode(vcpu)) {
> >>> -               vmcs12 =3D get_vmcs12(vcpu);
> >>> -
> >>> -               /*
> >>> -                * Ensure vmcs12 is up-to-date before any VMWRITE tha=
t dirties
> >>> -                * vmcs12, else we may crush a field or consume a sta=
le value.
> >>> -                */
> >>> -               if (!is_shadow_field_rw(field))
> >>> -                       copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
> >>> -       } else {
> >>> -               /*
> >>> -                * When vmcs->vmcs_link_pointer is -1ull, any VMWRITE
> >>> -                * to shadowed-field sets the ALU flags for VMfailInv=
alid.
> >>> -                */
> >>> -               if (get_vmcs12(vcpu)->vmcs_link_pointer =3D=3D -1ull)
> >>> -                       return nested_vmx_failInvalid(vcpu);
> >>> -               vmcs12 =3D get_shadow_vmcs12(vcpu);
> >>> -       }
> >>> +       /*
> >>> +        * Ensure vmcs12 is up-to-date before any VMWRITE that dirtie=
s
> >>> +        * vmcs12, else we may crush a field or consume a stale value=
.
> >>> +        */
> >>> +       if (!is_guest_mode(vcpu) && !is_shadow_field_rw(field))
> >>> +               copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
> >>>
> >>>        offset =3D vmcs_field_to_offset(field);
> >>>        if (offset < 0)
> >>>
> >>>
> >>> ... and also, do you have a matching kvm-unit-tests patch?
> >>
> >> I'll put one together, along with a test that shows the current
> >> priority inversion between read-only and unsupported VMCS fields.
> >
> > I can't figure out how to clear IA32_VMX_MISC[bit 29] in qemu, so I'm
> > going to add the test to tools/testing/selftests/kvm instead.
>
> Please don=E2=80=99t.
>
> I wish that we keep clear separation between kvm-unit-tests and self-test=
s.
> In the sense that kvm-unit-tests tests for correct CPU behaviour semantic=
s
> and self-tests tests for correctness of KVM userspace API.
>
> In the future, I wish to change kvm-unit-tests to cpu-unit-tests. As ther=
e is no
> real connection to KVM. It=E2=80=99s a bunch of tests that can be run on =
top of any CPU
> Implementation (weather vCPU by some hypervisor or bare-metal CPU) and
> test for it=E2=80=99s semantics.
> I have already used this to find semantic issues on Hyper-V vCPU implemen=
tation for example.
>
> Regarding your question on how to disable IA32_VMX_MISC in QEMU:
> Paolo have recently created a patch-series for QEMU that can be used to d=
o this.
> (Aimed for QEMU nVMX Live-Migration support)
> See: https://lists.gnu.org/archive/html/qemu-devel/2019-07/msg00711.html
> (You should search for final patch-series version=E2=80=A6)
>
> -Liran

Okay. Given the high barrier to entry, I will not be providing a test
at this time.
