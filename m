Return-Path: <kvm+bounces-33574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 31A1F9EE684
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 13:20:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1DEF0188254B
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 12:19:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6758212D99;
	Thu, 12 Dec 2024 12:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="CWw+m96j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EBB212B26
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 12:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734005990; cv=none; b=oFPJXgt389OJdE3jn9ODRJAaYqHvM0VaZ6dM/u8tz8xNrqnOQgfJY75Ofg8d/zqFkAXP0FLJvGjElvfvFW0gs94zfzIBEzeRy+Xw2yh98FzxMvqbgdI7iTeaWPN6IqshgGs0c6nGPlxBDFc9Pc5maVTadWnK6Rp+1EB44XY9RFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734005990; c=relaxed/simple;
	bh=VKBQIzStgllWG7ueGDaONoR1vHAbjm+ukTlPYa+H8xs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t15W8TJf3D7wgbhbUrwXVxICHeJtO3l727di1VHnC4aiUePbFI5kvWHYYxvdKc63+X1cT9VRo2MZx4vjdxFzMSTUvW3YIBNfX/4JElK81xF/MsL701xqC+XFJHg2U/ml3ashyXjTF666lTkxh8x2J/i0YDhg4slYZu8mXYPzwGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=CWw+m96j; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aa6997f33e4so75463066b.3
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 04:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1734005987; x=1734610787; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t/cxRM0Ij2WEG5z2uOS+HsShhYoyfFvbZEEd1iFJwRA=;
        b=CWw+m96jeM/gLgqfJy4ufGDKAsvmi0geXzlCezwdUtxE+u71MgQE2Kws539aEKC8cZ
         J8MdrSIqSCTCNYUI9Mkr1JWXfOFJaDKeUBWkAUGGPOKjgchNv7aoAbn00byXMr3meoR7
         hLj9EL28VHOgu/WBVrTkfn7gva0x2VYGKCYj8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734005987; x=1734610787;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t/cxRM0Ij2WEG5z2uOS+HsShhYoyfFvbZEEd1iFJwRA=;
        b=jL3wyO9+/1vw3iA0Swa/UQ2Kf/9ZSQ9CZfgdxOmp293NVSOrz8lHXA+NfRu0Kolubv
         jsXSglmnYK1hu2iYZmyL8GIvCACpUFKzaEAvPoXOhFvpoxoxGBkG1Ch9euSU2TjmOXVr
         fbxwNk9GeluDmP5JLQPLQ8isLp+fSQtoOIiEb0MLQ0yrFlvV1BMFeIVniCANTBAR4mpy
         P0aDvN8ZjEFOiBPH0bEdLOjLhdVJffvb4idhftX1xaaM+1vjfSKPMduOIOyNxN51Sbiq
         J9JVcH5djIz7WhvGKn9Vbnqkd7jLhQ+aLxi4tWNR+F+ilNYDTovJ5bpPT0g4OVcZ4QwB
         iNeQ==
X-Forwarded-Encrypted: i=1; AJvYcCWN1XzyMlTA1FY+ucXujvCjp1Q4lkDMyVfEQ+jN8WzW2j+ik9/Un15ERWQ236EuXSoghD0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiflLndF2vJs5H/ZA80puyeRFDszB4IWDroprn/2KCtUTN3knd
	TEtWCJyAwA4SxosbvItQoNAE7XGwWpKai5Oq6dxamujnDf2V0H9ZZfBrGdzMeXh1fcbmx+ntKOi
	3RarPPzkCASuG4Hr6vZdgXjDnRcdVl/vF17XupEfVnGVq99QyVxgolvQVLmJPkCs2nO8ioHJk9o
	Lh4tBXlPtqEX/9ow==
X-Gm-Gg: ASbGncv7TX+wLtLTadbZcx+naJSFr02yj/130ftqxC+SUG9ZJEUe59JWXjaezoLZX/h
	8j3SqSnXJrwoIIVgPDve98i2rweJ5yHHkgxk2JA==
X-Google-Smtp-Source: AGHT+IFQv+cXEVNVFaLo/8WQQrhr8KPYmu+2J6kQYdBp2nt4RjHirpIEciuXmk1t5dRnW7cYitqVsCefUe2Yg9NRj9k=
X-Received: by 2002:a17:906:4ca:b0:aa6:993a:259f with SMTP id
 a640c23a62f3a-aa6b1396ea0mr722272266b.40.1734005986971; Thu, 12 Dec 2024
 04:19:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241030033514.1728937-1-zack.rusin@broadcom.com>
 <20241030033514.1728937-3-zack.rusin@broadcom.com> <CABgObfaRP6zKNhrO8_atGDLcHs=uvE0aT8cPKnt_vNHHM+8Nxg@mail.gmail.com>
 <CABQX2QMR=Nsn23zojFdhemR7tvGUz6_UM8Rgf6WLsxwDqoFtxg@mail.gmail.com>
 <Zy0__5YB9F5d0eZn@google.com> <CABQX2QNxFDhH1frsGpSQjSs3AWSdTibkxPrjq1QC7FGZC8Go-Q@mail.gmail.com>
 <e3f943a7-a40a-45cb-b0d9-e3ed58344d8b@redhat.com> <CADH9ctD1uf_yBA3NXNQu7TJa_TPhLRN=0YZ3j2gGhgmaFRdCFg@mail.gmail.com>
 <c3026876-8061-4ab2-9321-97cc05bad510@redhat.com> <CADH9ctBivnvP1tNcatLKzd8EDz8Oo6X65660j8ccxYzk3aFzCA@mail.gmail.com>
 <CABgObfZEyCQMiq6CKBOE7pAVzUDkWjqT2cgfbwjW-RseH8VkLw@mail.gmail.com>
 <CADH9ctA_C1dAOus1K+wOH_SOKTb=-X1sVawt5R=dkH1iGt8QUg@mail.gmail.com>
 <CABgObfZrTyft-3vqMz5w0ZiAhp-v6c32brgftynZGJO8OafrdA@mail.gmail.com>
 <CADH9ctBYp-LMbW4hm3+QwNoXvAc5ryVeB0L1jLY0uDWSe3vbag@mail.gmail.com>
 <b1ddb439-9e28-4a58-ba86-0395bfc081e0@redhat.com> <CADH9ctCFYtNfhn3SSp2jp0fzxu6s_X1A+wBNnzvHZVb8qXPk=g@mail.gmail.com>
In-Reply-To: <CADH9ctCFYtNfhn3SSp2jp0fzxu6s_X1A+wBNnzvHZVb8qXPk=g@mail.gmail.com>
From: Doug Covelli <doug.covelli@broadcom.com>
Date: Thu, 12 Dec 2024 07:19:33 -0500
Message-ID: <CADH9ctB0YSYqC_Vj2nP20vMO_gN--KsqOBOu8sfHDrkZJV6pmw@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: x86: Add support for VMware guest specific hypercalls
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Zack Rusin <zack.rusin@broadcom.com>, Sean Christopherson <seanjc@google.com>, 
	kvm <kvm@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "the arch/x86 maintainers" <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Arnaldo Carvalho de Melo <acme@redhat.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Joel Stanley <joel@jms.id.au>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, 
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, 
	linux-kselftest <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 14, 2024 at 10:45=E2=80=AFAM Doug Covelli <doug.covelli@broadco=
m.com> wrote:
>
> On Wed, Nov 13, 2024 at 12:59=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.c=
om> wrote:
> >
> > On 11/13/24 17:24, Doug Covelli wrote:
> > >> No worries, you're not hijacking :) The only reason is that it would
> > >> be more code for a seldom used feature and anyway with worse perform=
ance.
> > >> (To be clear, CR8 based accesses are allowed, but stores cause an ex=
it
> > >> in order to check the new TPR against IRR. That's because KVM's API
> > >> does not have an equivalent of the TPR threshold as you point out be=
low).
> > >
> > > I have not really looked at the code but it seems like it could also
> > > simplify things as CR8 would be handled more uniformly regardless of
> > > who is virtualizing the local APIC.
> >
> > Not much because CR8 basically does not exist at all (it's just a byte
> > in memory) with userspace APIC.  So it's not easy to make it simpler, e=
ven
> > though it's less uniform.
> >
> > That said, there is an optimization: you only get KVM_EXIT_SET_TPR if
> > CR8 decreases.
> >
> > >>> Also I could not find these documented anywhere but with MSFT's API=
C our monitor
> > >>> relies on extensions for trapping certain events such as INIT/SIPI =
plus LINT0
> > >>> and SVR writes:
> > >>>
> > >>> UINT64 X64ApicInitSipiExitTrap    : 1; // WHvRunVpExitReasonX64Apic=
InitSipiTrap
> > >>> UINT64 X64ApicWriteLint0ExitTrap  : 1; // WHvRunVpExitReasonX64Apic=
WriteTrap
> > >>> UINT64 X64ApicWriteLint1ExitTrap  : 1; // WHvRunVpExitReasonX64Apic=
WriteTrap
> > >>> UINT64 X64ApicWriteSvrExitTrap    : 1; // WHvRunVpExitReasonX64Apic=
WriteTrap
> > >>
> > >> There's no need for this in KVM's in-kernel APIC model. INIT and
> > >> SIPI are handled in the hypervisor and you can get the current
> > >> state of APs via KVM_GET_MPSTATE. LINT0 and LINT1 are injected
> > >> with KVM_INTERRUPT and KVM_NMI respectively, and they obey IF/PPR
> > >> and NMI blocking respectively, plus the interrupt shadow; so
> > >> there's no need for userspace to know when LINT0/LINT1 themselves
> > >> change. The spurious interrupt vector register is also handled
> > >> completely in kernel.
> > >
> > > I realize that KVM can handle LINT0/SVR updates themselves but our
> > > interrupt subsystem relies on knowing the current values of these
> > > registers even when not virtualizing the local APIC.  I suppose we
> > > could use KVM_GET_LAPIC to sync things up on demand but that seems
> > > like it might nor be great from a performance point of view.
> >
> > Ah no, you're right---you want to track the CPU that has ExtINT enabled
> > and send KVM_INTERRUPT to that one, I guess?  And you need the spurious
> > vector registers because writes can set the mask bit in LINTx, but
> > essentially you want to trap LINT0 changes.
> >
> > Something like this (missing the KVM_ENABLE_CAP and KVM_CHECK_EXTENSION
> > code) is good, feel free to include it in your v2 (Co-developed-by
> > and Signed-off-by me):
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index 5fb29ca3263b..b7dd89c99613 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -122,6 +122,7 @@
> >   #define KVM_REQ_HV_TLB_FLUSH \
> >         KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP=
)
> >   #define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE  KVM_ARCH_REQ(34)
> > +#define KVM_REQ_REPORT_LINT0_ACCESS    KVM_ARCH_REQ(35)
> >
> >   #define CR0_RESERVED_BITS                                            =
   \
> >         (~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR=
0_TS \
> > @@ -775,6 +776,7 @@ struct kvm_vcpu_arch {
> >         u64 smi_count;
> >         bool at_instruction_boundary;
> >         bool tpr_access_reporting;
> > +       bool lint0_access_reporting;
> >         bool xfd_no_write_intercept;
> >         u64 ia32_xss;
> >         u64 microcode_version;
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 88dc43660d23..0e070f447aa2 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -1561,6 +1561,21 @@ static u32 apic_get_tmcct(struct kvm_lapic *apic=
)
> >                               apic->divide_count));
> >   }
> >
> > +static void __report_lint0_access(struct kvm_lapic *apic, u32 value)
> > +{
> > +       struct kvm_vcpu *vcpu =3D apic->vcpu;
> > +       struct kvm_run *run =3D vcpu->run;
> > +
> > +       kvm_make_request(KVM_REQ_REPORT_LINT0_ACCESS, vcpu);
> > +       run->lint0_access.value =3D value;
> > +}
> > +
> > +static inline void report_lint0_access(struct kvm_lapic *apic, u32 val=
ue)
> > +{
> > +       if (apic->vcpu->arch.lint0_access_reporting)
> > +               __report_lint0_access(apic, value);
> > +}
> > +
> >   static void __report_tpr_access(struct kvm_lapic *apic, bool write)
> >   {
> >         struct kvm_vcpu *vcpu =3D apic->vcpu;
> > @@ -2312,8 +2327,10 @@ static int kvm_lapic_reg_write(struct kvm_lapic =
*apic, u32 reg, u32 val)
> >                         int i;
> >
> >                         for (i =3D 0; i < apic->nr_lvt_entries; i++) {
> > -                               kvm_lapic_set_reg(apic, APIC_LVTx(i),
> > -                                       kvm_lapic_get_reg(apic, APIC_LV=
Tx(i)) | APIC_LVT_MASKED);
> > +                               u32 old =3D kvm_lapic_get_reg(apic, API=
C_LVTx(i));
> > +                               kvm_lapic_set_reg(apic, APIC_LVTx(i), o=
ld | APIC_LVT_MASKED);
> > +                               if (i =3D=3D 0 && !(old & APIC_LVT_MASK=
ED))
> > +                                       report_lint0_access(apic, old |=
 APIC_LVT_MASKED);
> >                         }
> >                         apic_update_lvtt(apic);
> >                         atomic_set(&apic->lapic_timer.pending, 0);
> > @@ -2352,6 +2369,8 @@ static int kvm_lapic_reg_write(struct kvm_lapic *=
apic, u32 reg, u32 val)
> >                 if (!kvm_apic_sw_enabled(apic))
> >                         val |=3D APIC_LVT_MASKED;
> >                 val &=3D apic_lvt_mask[index];
> > +               if (index =3D=3D 0 && val !=3D kvm_lapic_get_reg(apic, =
reg))
> > +                       report_lint0_access(apic, val);
> >                 kvm_lapic_set_reg(apic, reg, val);
> >                 break;
> >         }
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index d0d3dc3b7ef6..2b039b372c3f 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10879,6 +10879,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *v=
cpu)
> >                         kvm_vcpu_flush_tlb_guest(vcpu);
> >   #endif
> >
> > +               if (kvm_check_request(KVM_REQ_REPORT_LINT0_ACCESS, vcpu=
)) {
> > +                       vcpu->run->exit_reason =3D KVM_EXIT_LINT0_ACCES=
S;
> > +                       r =3D 0;
> > +                       goto out;
> > +               }
> >                 if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu))=
 {
> >                         vcpu->run->exit_reason =3D KVM_EXIT_TPR_ACCESS;
> >                         r =3D 0;
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 637efc055145..ec97727f9de4 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -178,6 +178,7 @@ struct kvm_xen_exit {
> >   #define KVM_EXIT_NOTIFY           37
> >   #define KVM_EXIT_LOONGARCH_IOCSR  38
> >   #define KVM_EXIT_MEMORY_FAULT     39
> > +#define KVM_EXIT_LINT0_ACCESS     40
> >
> >   /* For KVM_EXIT_INTERNAL_ERROR */
> >   /* Emulate instruction failed. */
> > @@ -283,6 +284,10 @@ struct kvm_run {
> >                                 __u64 flags;
> >                         };
> >                 } hypercall;
> > +               /* KVM_EXIT_LINT0_ACCESS */
> > +               struct {
> > +                       __u32 value;
> > +               } lint0_access;
> >                 /* KVM_EXIT_TPR_ACCESS */
> >                 struct {
> >                         __u64 rip;
> >
> >
> > For LINT1, it should be less performance critical; if it's possible
> > to just go through all vCPUs, and do KVM_GET_LAPIC to check who you
> > should send a KVM_NMI to, then I'd do that.  I'd also accept a patch
> > that adds a VM-wide KVM_NMI ioctl that does the same in the hypervisor
> > if it's useful for you.
>
> Thanks for the patch - I'll get it a try but it might not be right away.
>
> > And since I've been proven wrong already, what do you need INIT/SIPI fo=
r?
>
> I don't think this one is as critical.  I believe the reason it was
> added was so that we can synchronize startup of the APs with execution
> of the BSP for guests that do not do a good job of that (Windows).
>
> Doug

We were able to get the in-kernel APIC working with our code using the spli=
t
IRQ chip option with our virtual EFI FW even w/o the traps for SVR and LVT0
writes.  Performance of Windows VMs is greatly improved as expected.
Unfortunately our ancient legacy BIOS will not work with > 1 VCPU due to la=
ck
of support for IPIs with an archaic delivery mode of remote read which it u=
ses
to discover APs by attempting to read their APIC ID register.  MSFT WHP sup=
ports
this functionality via an option, WHvPartitionPropertyCodeApicRemoteReadSup=
port.

Changing our legacy BIOS is not an option so in order to support Windows VM=
s
with the legacy BIOS with decent performance we would either need to add su=
pport
for remote reads of the APIC ID register to KVM or support CR8 accesses w/o
exiting w/o the in-kernel APIC in order.  Do you have a preference?

Thanks,
Doug

--=20
This electronic communication and the information and any files transmitted=
=20
with it, or attached to it, are confidential and are intended solely for=20
the use of the individual or entity to whom it is addressed and may contain=
=20
information that is confidential, legally privileged, protected by privacy=
=20
laws, or otherwise restricted from disclosure to anyone else. If you are=20
not the intended recipient or the person responsible for delivering the=20
e-mail to the intended recipient, you are hereby notified that any use,=20
copying, distributing, dissemination, forwarding, printing, or copying of=
=20
this e-mail is strictly prohibited. If you received this e-mail in error,=
=20
please return the e-mail to the sender, delete it from your computer, and=
=20
destroy any printed copy of it.

