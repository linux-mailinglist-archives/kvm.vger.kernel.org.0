Return-Path: <kvm+bounces-56989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C3EEB494DA
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 18:14:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C60763ACFEE
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 16:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87AC030E0CC;
	Mon,  8 Sep 2025 16:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YEjiPNB/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222452B9A5
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 16:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757348080; cv=none; b=VzKozB30G59cUa2ZczGoxqLYm4y6dCXQ6XAblOAIxTiJFhinxir6XeGoSAr2g8PMBAvTHgEG6gO7jNNXtg5jqVxrFCJl5tHPhnP5FvXzGuJes0etjkLlVolyXMcD6uNvRZzn5syLyj+a1x96uUoNMpfeQ2lcgqESFj+54wk3L+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757348080; c=relaxed/simple;
	bh=eELHbab1pARrbClGXme+CovIgP1gERd4crFqe/JFhEU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o2bes/KAmvwBsQbDcg2cWkAY/iCw5Vcm/wi0hGXRNmcveent9radf7gsSmYqC/gTGLSCewOkbwzPSfsLkSqAdTUGyGna5npz7WTGb6HmvNgbIP6bqm7rlSWnapMufjJKlMs0oL9+PaShFFIaVB92QUWlDUVZgfI5CNgKeN/zi6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YEjiPNB/; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-24ae30bd2d0so43983625ad.3
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 09:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757348078; x=1757952878; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8rBFCSqM8yS3/NCAxHSF50velNu8qIwnhk2Bn2P2ZhM=;
        b=YEjiPNB/L8cLSe6u0cEJHAtOVjPeG7rqz3DKeRu33DzCdI302PwkW3tVYl0J1ReZxI
         34722D2XIKPEIOIO2qXbrzAwuaJRnEKRjHoXtir31ltSwHPLx0edaUpO/3+2lSW17phL
         DsiP4RyIsJ6Qi/4vgN5zehcPOq//b+9EK29NRrPlRLJXkBSCmQxEPXI5dYX6zb9/F79D
         7Wwm8Ykv0/6wydaBb3U2Dgs/ttu2ywQriFJpw02vvMULZ9cQzHrE7pdssXUNKRYwVLQB
         Z+qC28WELqAL6kJddaUC1ds6dD4OcfpnrpJ+8rCsHVT+ecqf9nhwTWcZO4vz/hzMkSu/
         T1sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757348078; x=1757952878;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8rBFCSqM8yS3/NCAxHSF50velNu8qIwnhk2Bn2P2ZhM=;
        b=leyrP7HtuhWVziah+qvFLInpxuXuZXTkwIflfsRw4emgiXx7b0CEAwUjMjaHKjDVzJ
         EbJwUlt37EqCt5XyEsoKBZus+vOcbsf4NqANTc9awMiI5xUOeGzIVbrgxnASFx8wqWE0
         a+tfmbtwz/Wo3SvIWMrEQRiMdD4y55XTHcvwthDuH5i7lqfulSDu0pGcKNHCFyt5SxyM
         53oXJstAXZ4u0LfXFv1RDBNFMcPV8Ha0rr4c7k/Xuiu0jWPlR7mf5cd07zgYATVF5gV2
         FuXdT/s0uzrWQx5AIKpSjysSyl/qCEcHi+pwZqT49pIPxIwmLRVRWKhWPVl3tJQR8qbT
         PVWw==
X-Forwarded-Encrypted: i=1; AJvYcCVkCJKCD93+fH5kqRGPEPAAN95sgA05V6e2505TtNm0IWSrNS+Ww2j/zVnOCQsPlEiX8MY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcEorCTYK4T3biBp2nzzKv6Dgyxjj94dcBAJKogGCJZ06ZUCF0
	X+3AkQYy05ijSy0vbGvDes+WTKoncYWbgmhPZ5RyHZUJFCRgxLamdICqin6OW2DCWvKNKIP+dFX
	S/J+6fw==
X-Google-Smtp-Source: AGHT+IEWAzA8mTwC3tCgvZzD5LQvveK/68x7NMUTFfM4rJzeR2Wz0YuzOB9GFrf9zLgodQ76Jjl9ikWAVBo=
X-Received: from plbjw17.prod.google.com ([2002:a17:903:2791:b0:24c:863e:86a3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e943:b0:24c:9309:587d
 with SMTP id d9443c01a7336-251714fa774mr120638105ad.29.1757348078384; Mon, 08
 Sep 2025 09:14:38 -0700 (PDT)
Date: Mon, 8 Sep 2025 09:14:37 -0700
In-Reply-To: <c2979c40-0cf9-4238-9fb5-5cef6dd9f411@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827152754.12481-1-lifei.shirley@bytedance.com>
 <aK8r11trXDjBnRON@google.com> <CABgObfYqVTK3uB00pAyZAdX=Vx1Xx_M0MOwUzm+D1C04mrVfig@mail.gmail.com>
 <f904b674-98ba-4e13-a64c-fd30b6ac4a2e@bytedance.com> <CABgObfb4ocYcaZixoPD_VZL5Z_SieTGJW3GBCFB-_LuOH5Ut2g@mail.gmail.com>
 <d686f056-180c-4a22-a359-81eadb062629@bytedance.com> <c2979c40-0cf9-4238-9fb5-5cef6dd9f411@bytedance.com>
Message-ID: <aL8A7WKHfAsAkPlh@google.com>
Subject: Re: [External] Re: [PATCH] KVM: x86: Latch INITs only in specific CPU
 states in KVM_SET_VCPU_EVENTS
From: Sean Christopherson <seanjc@google.com>
To: Fei Li <lifei.shirley@bytedance.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, liran.alon@oracle.com, hpa@zytor.com, 
	wanpeng.li@hotmail.com, kvm@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 08, 2025, Fei Li wrote:
>=20
> On 9/5/25 10:59 PM, Fei Li wrote:
> >=20
> > On 8/29/25 12:44 AM, Paolo Bonzini wrote:
> > > On Thu, Aug 28, 2025 at 5:13=E2=80=AFPM Fei Li <lifei.shirley@bytedan=
ce.com>
> > > wrote:
> > > > Actually this is a bug triggered by one monitor tool in our product=
ion
> > > > environment. This monitor executes 'info registers -a' hmp at a fix=
ed
> > > > frequency, even during VM startup process, which makes some AP stay=
 in
> > > > KVM_MP_STATE_UNINITIALIZED forever. But this race only occurs with
> > > > extremely low probability, about 1~2 VM hangs per week.
> > > >=20
> > > > Considering other emulators, like cloud-hypervisor and
> > > > firecracker maybe
> > > > also have similar potential race issues, I think KVM had better do =
some
> > > > handling. But anyway, I will check Qemu code to avoid such race. Th=
anks
> > > > for both of your comments. =F0=9F=99=82
> > > If you can check whether other emulators invoke KVM_SET_VCPU_EVENTS i=
n
> > > similar cases, that of course would help understanding the situation
> > > better.
> > >=20
> > > In QEMU, it is possible to delay KVM_GET_VCPU_EVENTS until after all
> > > vCPUs have halted.
> > >=20
> > > Paolo
> > >=20

Replacing the original message with a decently formatted version.  Please t=
ry to
format your emails for plain text, I assume something in your mail system i=
nserted
a pile of line wraps and made the entire thing all but unreadable.

> > `info registers -a` hmp per 2ms[1]
> >                AP(vcpu1) thread[2]
> >       BSP(vcpu0) send INIT/SIPI[3]
> >=20
> > [1] for each cpu: cpu_synchronize_state
> >     if !qemu_thread_is_self()
> >         1. insert to cpu->work_list, and handle asynchronously
> >         2. then kick the AP(vcpu1) by sending SIG_IPI/SIGUSR1 signal
> >=20
> > [2] KVM: KVM_RUN and then schedule() in kvm_vcpu_block() loop
> >          KVM: checks signal_pending, breaks loop and  returns -EINTR
> >     Qemu: break kvm_cpu_exec loop, run
> >        1. qemu_wait_io_event()
> >           =3D> process_queued_cpu_work =3D> cpu->work_list.func()
> >              e.i. do_kvm_cpu_synchronize_state() callback
> >           =3D> kvm_arch_get_registers
> >              =3D> kvm_get_mp_state
> >                 /* KVM: get_mpstate also calls kvm_apic_accept_events()=
 to handle INIT and SIPI */
> >                 =3D> cpu->vcpu_dirty =3D true;
> >           // end of qemu_wait_io_event
> >=20
> > [3] SeaBIOS: BSP enters non-root mode and runs reset_vector() in SeaBIO=
S.
> >     send INIT and then SIPI by writing APIC_ICR during smp_scan
> >     KVM: BSP(vcpu0) exits, then=20
> >     =3D> handle_apic_write
> >        =3D> kvm_lapic_reg_write
> >           =3D> kvm_apic_send_ipi to all APs
> >              =3D> for each AP: __apic_accept_irq, e.g. for AP(vcpu1)
> >                 =3D> case APIC_DM_INIT:
> >                    apic->pending_events =3D (1UL << KVM_APIC_INIT) (not=
 kick the AP yet)
> >                 =3D> case APIC_DM_STARTUP:
> >                    set_bit(KVM_APIC_SIPI, &apic->pending_events) (not k=
ick the AP yet)
> >=20
> > [2] 2. kvm_cpu_exec()
> >        =3D> if (cpu->vcpu_dirty):
> >           =3D> kvm_arch_put_registers
> >              =3D> kvm_put_vcpu_events
> >                 KVM: kvm_vcpu_ioctl_x86_set_vcpu_events
> >                 =3D> clear_bit(KVM_APIC_INIT, &vcpu->arch.apic->pending=
_events);
> >                    e.i. pending_events changes from 11b to 10b
> >                 // end of kvm_vcpu_ioctl_x86_set_vcpu_events

Qemu is clearly "putting" stale data here.

> >     Qemu: =3D> after put_registers, cpu->vcpu_dirty =3D false;
> >           =3D> kvm_vcpu_ioctl(cpu, KVM_RUN, 0)
> >              KVM: KVM_RUN
> >              =3D> schedule() in kvm_vcpu_block() until Qemu's next SIG_=
IPI/SIGUSR1 signal
> >              /* But AP(vcpu1)'s mp_state will never change from KVM_MP_=
STATE_UNINITIALIZED
> >                 to KVM_MP_STATE_INIT_RECEIVED, even then to KVM_MP_STAT=
E_RUNNABLE without
> >                 handling INIT inside kvm_apic_accept_events(), consider=
ing BSP will never
> >                 send INIT/SIPI again during smp_scan. Then AP(vcpu1) wi=
ll never enter
> >                 non-root mode */
> >=20
> > [3] SeaBIOS: waits CountCPUs =3D=3D expected_cpus_count and loops forev=
er
> >     e.i. the AP(vcpu1) stays: EIP=3D0000fff0 && CS =3Df000 ffff0000
> >     and BSP(vcpu0) appears 100%  utilized as it is in a while loop.

> By the way, this doesn't seem to be a Qemu bug, since calling "info
> registers -a" is allowed regardless of the vcpu state (including when the=
 VM
> is in the bootloader). Thus the INIT should not be latched in this case.

No, this is a Qemu bug.  It is the VMM's responsibility to ensure it doesn'=
t load
stale data into a vCPU.  There is simply no way for KVM to do the right thi=
ng,
because KVM can't know if userspace _wants_ to clobber events versus when u=
serspace
is racing, as in this case.

E.g. the exact same race exists with NMIs.

  1. kvm_vcpu_ioctl_x86_get_vcpu_events()=20
       vcpu->arch.nmi_queued   =3D 0
       vcpu->arch.nmi_pending  =3D 0
       kvm_vcpu_events.pending =3D 0

  2. kvm_inject_nmi()
       vcpu->arch.nmi_queued   =3D 1
       vcpu->arch.nmi_pending  =3D 0
       kvm_vcpu_events.pending =3D 0

  3. kvm_vcpu_ioctl_x86_set_vcpu_events()
       vcpu->arch.nmi_queued   =3D 0 // Moved to nmi_pending by process_nmi=
()
       vcpu->arch.nmi_pending  =3D 0 // Explicitly cleared after process_nm=
i() when KVM_VCPUEVENT_VALID_NMI_PENDING
       kvm_vcpu_events.pending =3D 0 // Stale data

But for NMI, Qemu avoids clobbering state thinks to a 15+ year old commit t=
hat
specifically avoids clobbering NMI *and SIPI* when not putting "reset" stat=
e:

  commit ea64305139357e89f58fc05ff5d48dc233d44d87
  Author:     Jan Kiszka <jan.kiszka@siemens.com>
  AuthorDate: Mon Mar 1 19:10:31 2010 +0100
  Commit:     Marcelo Tosatti <mtosatti@redhat.com>
  CommitDate: Thu Mar 4 00:29:30 2010 -0300

    KVM: x86: Restrict writeback of VCPU state
   =20
    Do not write nmi_pending, sipi_vector, and mpstate unless we at least g=
o
    through a reset. And TSC as well as KVM wallclocks should only be
    written on full sync, otherwise we risk to drop some time on state
    read-modify-write.

    if (level >=3D KVM_PUT_RESET_STATE) {  <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
        events.flags |=3D KVM_VCPUEVENT_VALID_NMI_PENDING;
        if (env->mp_state =3D=3D KVM_MP_STATE_SIPI_RECEIVED) {
            events.flags |=3D KVM_VCPUEVENT_VALID_SIPI_VECTOR;
        }
    }

Presumably "SMIs" need the same treatment, e.g.

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 6c749d4ee8..f5bc0f9327 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5033,7 +5033,7 @@ static int kvm_put_vcpu_events(X86CPU *cpu, int level=
)
=20
     events.sipi_vector =3D env->sipi_vector;
=20
-    if (has_msr_smbase) {
+    if (has_msr_smbase && level >=3D KVM_PUT_RESET_STATE) {
         events.flags |=3D KVM_VCPUEVENT_VALID_SMM;
         events.smi.smm =3D !!(env->hflags & HF_SMM_MASK);
         events.smi.smm_inside_nmi =3D !!(env->hflags2 & HF2_SMM_INSIDE_NMI=
_MASK);

