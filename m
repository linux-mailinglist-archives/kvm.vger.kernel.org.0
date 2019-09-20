Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B18DCB99EE
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2019 01:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407045AbfITXGY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 19:06:24 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37087 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392315AbfITXGY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 19:06:24 -0400
Received: by mail-wr1-f68.google.com with SMTP id i1so8301984wro.4
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2019 16:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RZTT5IlU3wluSa45SV/fuR1fBaHtRcVgqplKmV/xKOs=;
        b=L/L7l7C7HfAivkrayC9uPOVFDyAGWXTLLSfOQSMapE0ej0fLKy9Kc9Xve6D64mEdmV
         Mai1GwS4V3T0B1WSJKJcyx8sVKfkewogUrfn/1JBFdc3XRGrl7itrJ4sI50Sn50IiQPn
         Hj7i0yPB6oZz1VuiG/ihOOMyeGRhR3raXvi4f+WMn5C3RIH82fNFfIrOnKixHcrT8Wz4
         A6SZiFoM/auCJL42HFqgpsikhxvw7jzjm3MnHChtl1j1ESP3tW+gEJK/HC+FkfwhiZis
         kdPM27usoCqe+wf4krtmrCxCT18HzbRTDhX2Pu4slSJRn8uHJfCZCWSrWSeCz8OaUZgj
         T/hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RZTT5IlU3wluSa45SV/fuR1fBaHtRcVgqplKmV/xKOs=;
        b=twTMa+qZftJhSeOa/NgeNUr7WEMfPQx7mWwOMOelOjJ0OxZOppGxRbLqlet+CQJUFJ
         a9rF5sn3K35Y4Z82z/QpAxzjx3E4r3xleAY3/mMtVtZsOVWEiniPTcEg5H06Dm2f/nKs
         sLDZr8oF/9hbNxMzlVeoH/9jEgftEvIHhGhoHQBdEPRYYk0GcPduFRHxfoVzlR+eVI1z
         90icmBhaKk/G23BrJ3ox7rGLHMnnYx49fcYwZWuOB2Bk7mh6ackPFt4ffMp958rGfbtB
         oNcwRG8fZ/iiZ8wK3Jhf6YAisveP2eMIkaiRwuw1oI0U5WViNX5SRnNoWJlttxgKcPMj
         1kuQ==
X-Gm-Message-State: APjAAAXzdKuVtV3wE2sulVrldhDB+9n3sUwDaDeF3Kmgyz0XwpyLxLcX
        m9MQdLS4D19qOSxCbaioGC9nXBq7XlyZ0WAMckbHnA==
X-Google-Smtp-Source: APXvYqygYEkNnvwha6Mef7gPQ5vJc7T35ES7k+0cuJjffa+mDP8ylPoyOmvlCSdzMyCCJEAJK+7IZw5xkusv76g4Jm0=
X-Received: by 2002:adf:dc4b:: with SMTP id m11mr14470339wrj.269.1569020780696;
 Fri, 20 Sep 2019 16:06:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190917185057.224221-1-marcorr@google.com> <2dce168f-edab-8c56-6d29-dc73aace8b63@oracle.com>
In-Reply-To: <2dce168f-edab-8c56-6d29-dc73aace8b63@oracle.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 20 Sep 2019 16:06:09 -0700
Message-ID: <CAA03e5GjxP1MXXq15mUuU1trqLrEjv_arNEQxp+QfHqCCb2X9g@mail.gmail.com>
Subject: Re: [PATCH v3] kvm: nvmx: limit atomic switch MSRs
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 17, 2019 at 4:05 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
>
> On 09/17/2019 11:50 AM, Marc Orr wrote:
> > Allowing an unlimited number of MSRs to be specified via the VMX
> > load/store MSR lists (e.g., vm-entry MSR load list) is bad for two
> > reasons. First, a guest can specify an unreasonable number of MSRs,
> > forcing KVM to process all of them in software. Second, the SDM bounds
> > the number of MSRs allowed to be packed into the atomic switch MSR list=
s.
> > Quoting the "Miscellaneous Data" section in the "VMX Capability
> > Reporting Facility" appendix:
> >
> > "Bits 27:25 is used to compute the recommended maximum number of MSRs
> > that should appear in the VM-exit MSR-store list, the VM-exit MSR-load
> > list, or the VM-entry MSR-load list. Specifically, if the value bits
> > 27:25 of IA32_VMX_MISC is N, then 512 * (N + 1) is the recommended
> > maximum number of MSRs to be included in each list. If the limit is
> > exceeded, undefined processor behavior may result (including a machine
> > check during the VMX transition)."
> >
> > Because KVM needs to protect itself and can't model "undefined processo=
r
> > behavior", arbitrarily force a VM-entry to fail due to MSR loading when
> > the MSR load list is too large. Similarly, trigger an abort during a VM
> > exit that encounters an MSR load list or MSR store list that is too lar=
ge.
> >
> > The MSR list size is intentionally not pre-checked so as to maintain
> > compatibility with hardware inasmuch as possible.
> >
> > Test these new checks with the kvm-unit-test "x86: nvmx: test max atomi=
c
> > switch MSRs".
> >
> > Suggested-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Peter Shier <pshier@google.com>
> > Signed-off-by: Marc Orr <marcorr@google.com>
> > ---
> > v2 -> v3
> > * Updated commit message.
> > * Removed superflous function declaration.
> > * Expanded in-line comment.
> >
> >   arch/x86/include/asm/vmx.h |  1 +
> >   arch/x86/kvm/vmx/nested.c  | 44 ++++++++++++++++++++++++++++---------=
-
> >   2 files changed, 34 insertions(+), 11 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> > index a39136b0d509..a1f6ed187ccd 100644
> > --- a/arch/x86/include/asm/vmx.h
> > +++ b/arch/x86/include/asm/vmx.h
> > @@ -110,6 +110,7 @@
> >   #define VMX_MISC_SAVE_EFER_LMA                      0x00000020
> >   #define VMX_MISC_ACTIVITY_HLT                       0x00000040
> >   #define VMX_MISC_ZERO_LEN_INS                       0x40000000
> > +#define VMX_MISC_MSR_LIST_MULTIPLIER         512
> >
> >   /* VMFUNC functions */
> >   #define VMX_VMFUNC_EPTP_SWITCHING               0x00000001
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index ced9fba32598..0e29882bb45f 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -190,6 +190,16 @@ static void nested_vmx_abort(struct kvm_vcpu *vcpu=
, u32 indicator)
> >       pr_debug_ratelimited("kvm: nested vmx abort, indicator %d\n", ind=
icator);
> >   }
> >
> > +static inline bool vmx_control_verify(u32 control, u32 low, u32 high)
> > +{
> > +     return fixed_bits_valid(control, low, high);
> > +}
> > +
> > +static inline u64 vmx_control_msr(u32 low, u32 high)
> > +{
> > +     return low | ((u64)high << 32);
> > +}
> > +
> >   static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
> >   {
> >       secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_SHADOW_VMCS)=
;
> > @@ -856,18 +866,36 @@ static int nested_vmx_store_msr_check(struct kvm_=
vcpu *vcpu,
> >       return 0;
> >   }
> >
> > +static u32 nested_vmx_max_atomic_switch_msrs(struct kvm_vcpu *vcpu)
> > +{
> > +     struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> > +     u64 vmx_misc =3D vmx_control_msr(vmx->nested.msrs.misc_low,
> > +                                    vmx->nested.msrs.misc_high);
> > +
> > +     return (vmx_misc_max_msr(vmx_misc) + 1) * VMX_MISC_MSR_LIST_MULTI=
PLIER;
> > +}
> > +
> >   /*
> >    * Load guest's/host's msr at nested entry/exit.
> >    * return 0 for success, entry index for failure.
> > + *
> > + * One of the failure modes for MSR load/store is when a list exceeds =
the
> > + * virtual hardware's capacity. To maintain compatibility with hardwar=
e inasmuch
> > + * as possible, process all valid entries before failing rather than p=
recheck
> > + * for a capacity violation.
> >    */
> >   static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 co=
unt)
> >   {
> >       u32 i;
> >       struct vmx_msr_entry e;
> >       struct msr_data msr;
> > +     u32 max_msr_list_size =3D nested_vmx_max_atomic_switch_msrs(vcpu)=
;
> >
> >       msr.host_initiated =3D false;
> >       for (i =3D 0; i < count; i++) {
> > +             if (unlikely(i >=3D max_msr_list_size))
> > +                     goto fail;
> > +
> >               if (kvm_vcpu_read_guest(vcpu, gpa + i * sizeof(e),
> >                                       &e, sizeof(e))) {
> >                       pr_debug_ratelimited(
> > @@ -899,9 +927,14 @@ static int nested_vmx_store_msr(struct kvm_vcpu *v=
cpu, u64 gpa, u32 count)
> >   {
> >       u32 i;
> >       struct vmx_msr_entry e;
> > +     u32 max_msr_list_size =3D nested_vmx_max_atomic_switch_msrs(vcpu)=
;
> >
> >       for (i =3D 0; i < count; i++) {
> >               struct msr_data msr_info;
> > +
> > +             if (unlikely(i >=3D max_msr_list_size))
> > +                     return -EINVAL;
> > +
> >               if (kvm_vcpu_read_guest(vcpu,
> >                                       gpa + i * sizeof(e),
> >                                       &e, 2 * sizeof(u32))) {
> > @@ -1009,17 +1042,6 @@ static u16 nested_get_vpid02(struct kvm_vcpu *vc=
pu)
> >       return vmx->nested.vpid02 ? vmx->nested.vpid02 : vmx->vpid;
> >   }
> >
> > -
> > -static inline bool vmx_control_verify(u32 control, u32 low, u32 high)
> > -{
> > -     return fixed_bits_valid(control, low, high);
> > -}
> > -
> > -static inline u64 vmx_control_msr(u32 low, u32 high)
> > -{
> > -     return low | ((u64)high << 32);
> > -}
> > -
> >   static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
> >   {
> >       superset &=3D mask;
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

+Paolo Bonzini +Radim Kr=C4=8Dm=C3=A1=C5=99

Ping. Thanks.
