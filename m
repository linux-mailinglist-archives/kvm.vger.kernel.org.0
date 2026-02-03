Return-Path: <kvm+bounces-69975-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mFN5OwalgWktIQMAu9opvQ
	(envelope-from <kvm+bounces-69975-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 08:34:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 670AED5C3C
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 08:34:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 32F5E30292F0
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 07:34:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD62C392806;
	Tue,  3 Feb 2026 07:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q8qQJWg8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D252321146C
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 07:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770104064; cv=none; b=oISzeq1EWghgWT1i3lQy2yirV1L8BSC7EO0jrHWe+tYiVk+/4aW0LUj7xB6gKL054YO09m+ZuaDqUahGyKKRA2U+OMnhvIMDJH01u1t8NzJzvaeU7EKUx2SEOpOhwiVoTKQStHZ11n9VmsEZEBOcPFllN7CEHMMiNJFJ/9dsjmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770104064; c=relaxed/simple;
	bh=t4EXw+exNpHzistUDIlWw1s+/sgx1+A8UHfKMAIqASA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=blgcLq8q+d384Yx0rVKwVIXQGUrUC9TykyCnhK6RAFVxge7Xct6byqr40+nQPLoye+9z6pmxFN+ag88YBvCSleW/a0m1h0FeUr+UZwFO8D0xpJYq0+i3b1HeiOKWoxubi991Wz98NVrJsOh/m3HcNEvoBvICR5uFDKj89z9Rtq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q8qQJWg8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B45EC19425
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 07:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770104064;
	bh=t4EXw+exNpHzistUDIlWw1s+/sgx1+A8UHfKMAIqASA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Q8qQJWg8X7ACojtln6Rx9OqGuk7KOmF67LPIP0riUMPqb8/YLcvfBf1mQJ7HU81FN
	 iabAbxShrRhrw6VOPPZLQEnbjKowwjpsEqFDjZRMybBzx19zJK6jEs57VhCW+99v7c
	 j9in1yfooayPqWuiBUiFOpoZxGni16QohtjL94R5RjmTvqm0OIppkRtVIxtCyn3S/R
	 npmcCvLOrSNqHun1DDnkHBm7Xz6der0tv8kgYHTs/N4oSdzWhH15QAlmyep96pe4f4
	 UlG8POkj95pRvhSr5aj+DLIl2NqFnKvjQH/8f5xuGQ+iloVCOn4Y+ldBjYQp52XuKt
	 6JyncchNnaP0A==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-65808bb859cso7910246a12.2
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 23:34:24 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVULwsRihgGcxDcexU748frlabtAcYbEusxzYTTrn444SFbg0iJWU5/MOI7YTfl2iiTWgw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzsej9ZlWE7etx14vhZHKzxLArHcV8fPvcJyK5pXf5OCMThJ+/o
	AQ9ozbGm1m2EzwDVp5vAXE+YS9bEcVDiU4ap3YRsO1MepFGhzhJjNcb8wJToSzBJcj9JoGX9GE1
	oit7pqxG/EfvxbQK4mXt5DzYEDEMlwxg=
X-Received: by 2002:a17:906:4783:b0:b87:9f87:7511 with SMTP id
 a640c23a62f3a-b8dff7a351dmr985972266b.55.1770104063082; Mon, 02 Feb 2026
 23:34:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260203033131.3372834-1-maobibo@loongson.cn> <20260203033131.3372834-5-maobibo@loongson.cn>
 <CAAhV-H7Y-m2wfV2YZ7J_nU0Zc198jroP6o8m0C+qSZ-8S79kwg@mail.gmail.com> <b9f311be-88f6-ffca-fc8e-70bec2cf7a75@loongson.cn>
In-Reply-To: <b9f311be-88f6-ffca-fc8e-70bec2cf7a75@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 3 Feb 2026 15:34:13 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6v2oVe38HX7k_wvysUx4nyz6pbfUOU7wiaJO+1A3ASJw@mail.gmail.com>
X-Gm-Features: AZwV_QifT5CQul5Te4AnGAKREbuTQi8KPLWBxtlFlwZbpoCsjnXkERn3Tm0f7LA
Message-ID: <CAAhV-H6v2oVe38HX7k_wvysUx4nyz6pbfUOU7wiaJO+1A3ASJw@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] LoongArch: KVM: Add FPU delay load support
To: Bibo Mao <maobibo@loongson.cn>
Cc: WANG Xuerui <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69975-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chenhuacai@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 670AED5C3C
X-Rspamd-Action: no action

On Tue, Feb 3, 2026 at 2:48=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrote=
:
>
>
>
> On 2026/2/3 =E4=B8=8B=E5=8D=8812:15, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > On Tue, Feb 3, 2026 at 11:31=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >> FPU is lazy enabled with KVM hypervisor. After FPU is enabled and
> >> loaded, vCPU can be preempted and FPU will be lost again, there will
> >> be unnecessary FPU exception, load and store process. Here FPU is
> >> delay load until guest enter entry.
> > Calling LSX/LASX as FPU is a little strange, but somewhat reasonable.
> > Calling LBT as FPU is very strange. So I still like the V1 logic.
> yeap, LBT can use another different BIT and separate with FPU. It is
> actually normal use one bit + fpu type variant to represent different
> different FPU load requirement, such as
> TIF_FOREIGN_FPSTATE/TIF_NEED_FPU_LOAD on other architectures.
>
> I think it is better to put int fpu_load_type in structure loongarch_fpu.
>
> And there will be another optimization to avoid load FPU again if FPU HW
> is owned by current thread/vCPU, that will add last_cpu int type in
> structure loongarch_fpu also.
>
> Regards
> Bibo Mao
> >
> > If you insist on this version, please rename KVM_REQ_FPU_LOAD to
> > KVM_REQ_AUX_LOAD and rename fpu_load_type to aux_type, which is
> > similar to aux_inuse.
Then why not consider this?

Huacai

> >
> > Huacai
> >
> >>
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> ---
> >>   arch/loongarch/include/asm/kvm_host.h |  2 ++
> >>   arch/loongarch/kvm/exit.c             | 21 ++++++++++-----
> >>   arch/loongarch/kvm/vcpu.c             | 37 ++++++++++++++++++-------=
--
> >>   3 files changed, 41 insertions(+), 19 deletions(-)
> >>
> >> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/in=
clude/asm/kvm_host.h
> >> index e4fe5b8e8149..902ff7bc0e35 100644
> >> --- a/arch/loongarch/include/asm/kvm_host.h
> >> +++ b/arch/loongarch/include/asm/kvm_host.h
> >> @@ -37,6 +37,7 @@
> >>   #define KVM_REQ_TLB_FLUSH_GPA          KVM_ARCH_REQ(0)
> >>   #define KVM_REQ_STEAL_UPDATE           KVM_ARCH_REQ(1)
> >>   #define KVM_REQ_PMU                    KVM_ARCH_REQ(2)
> >> +#define KVM_REQ_FPU_LOAD               KVM_ARCH_REQ(3)
> >>
> >>   #define KVM_GUESTDBG_SW_BP_MASK                \
> >>          (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP)
> >> @@ -234,6 +235,7 @@ struct kvm_vcpu_arch {
> >>          u64 vpid;
> >>          gpa_t flush_gpa;
> >>
> >> +       int fpu_load_type;
> >>          /* Frequency of stable timer in Hz */
> >>          u64 timer_mhz;
> >>          ktime_t expire;
> >> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> >> index 65ec10a7245a..62403c7c6f9a 100644
> >> --- a/arch/loongarch/kvm/exit.c
> >> +++ b/arch/loongarch/kvm/exit.c
> >> @@ -754,7 +754,8 @@ static int kvm_handle_fpu_disabled(struct kvm_vcpu=
 *vcpu, int ecode)
> >>                  return RESUME_HOST;
> >>          }
> >>
> >> -       kvm_own_fpu(vcpu);
> >> +       vcpu->arch.fpu_load_type =3D KVM_LARCH_FPU;
> >> +       kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
> >>
> >>          return RESUME_GUEST;
> >>   }
> >> @@ -794,8 +795,10 @@ static int kvm_handle_lsx_disabled(struct kvm_vcp=
u *vcpu, int ecode)
> >>   {
> >>          if (!kvm_guest_has_lsx(&vcpu->arch))
> >>                  kvm_queue_exception(vcpu, EXCCODE_INE, 0);
> >> -       else
> >> -               kvm_own_lsx(vcpu);
> >> +       else {
> >> +               vcpu->arch.fpu_load_type =3D KVM_LARCH_LSX;
> >> +               kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
> >> +       }
> >>
> >>          return RESUME_GUEST;
> >>   }
> >> @@ -812,8 +815,10 @@ static int kvm_handle_lasx_disabled(struct kvm_vc=
pu *vcpu, int ecode)
> >>   {
> >>          if (!kvm_guest_has_lasx(&vcpu->arch))
> >>                  kvm_queue_exception(vcpu, EXCCODE_INE, 0);
> >> -       else
> >> -               kvm_own_lasx(vcpu);
> >> +       else {
> >> +               vcpu->arch.fpu_load_type =3D KVM_LARCH_LASX;
> >> +               kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
> >> +       }
> >>
> >>          return RESUME_GUEST;
> >>   }
> >> @@ -822,8 +827,10 @@ static int kvm_handle_lbt_disabled(struct kvm_vcp=
u *vcpu, int ecode)
> >>   {
> >>          if (!kvm_guest_has_lbt(&vcpu->arch))
> >>                  kvm_queue_exception(vcpu, EXCCODE_INE, 0);
> >> -       else
> >> -               kvm_own_lbt(vcpu);
> >> +       else {
> >> +               vcpu->arch.fpu_load_type =3D KVM_LARCH_LBT;
> >> +               kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
> >> +       }
> >>
> >>          return RESUME_GUEST;
> >>   }
> >> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> >> index 995461d724b5..d05fe6c8f456 100644
> >> --- a/arch/loongarch/kvm/vcpu.c
> >> +++ b/arch/loongarch/kvm/vcpu.c
> >> @@ -232,6 +232,31 @@ static void kvm_late_check_requests(struct kvm_vc=
pu *vcpu)
> >>                          kvm_flush_tlb_gpa(vcpu, vcpu->arch.flush_gpa)=
;
> >>                          vcpu->arch.flush_gpa =3D INVALID_GPA;
> >>                  }
> >> +
> >> +       if (kvm_check_request(KVM_REQ_FPU_LOAD, vcpu)) {
> >> +               switch (vcpu->arch.fpu_load_type) {
> >> +               case KVM_LARCH_FPU:
> >> +                       kvm_own_fpu(vcpu);
> >> +                       break;
> >> +
> >> +               case KVM_LARCH_LSX:
> >> +                       kvm_own_lsx(vcpu);
> >> +                       break;
> >> +
> >> +               case KVM_LARCH_LASX:
> >> +                       kvm_own_lasx(vcpu);
> >> +                       break;
> >> +
> >> +               case KVM_LARCH_LBT:
> >> +                       kvm_own_lbt(vcpu);
> >> +                       break;
> >> +
> >> +               default:
> >> +                       break;
> >> +               }
> >> +
> >> +               vcpu->arch.fpu_load_type =3D 0;
> >> +       }
> >>   }
> >>
> >>   /*
> >> @@ -1286,13 +1311,11 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcp=
u *vcpu, struct kvm_fpu *fpu)
> >>   #ifdef CONFIG_CPU_HAS_LBT
> >>   int kvm_own_lbt(struct kvm_vcpu *vcpu)
> >>   {
> >> -       preempt_disable();
> >>          if (!(vcpu->arch.aux_inuse & KVM_LARCH_LBT)) {
> >>                  set_csr_euen(CSR_EUEN_LBTEN);
> >>                  _restore_lbt(&vcpu->arch.lbt);
> >>                  vcpu->arch.aux_inuse |=3D KVM_LARCH_LBT;
> >>          }
> >> -       preempt_enable();
> >>
> >>          return 0;
> >>   }
> >> @@ -1335,8 +1358,6 @@ static inline void kvm_check_fcsr_alive(struct k=
vm_vcpu *vcpu) { }
> >>   /* Enable FPU and restore context */
> >>   void kvm_own_fpu(struct kvm_vcpu *vcpu)
> >>   {
> >> -       preempt_disable();
> >> -
> >>          /*
> >>           * Enable FPU for guest
> >>           * Set FR and FRE according to guest context
> >> @@ -1347,16 +1368,12 @@ void kvm_own_fpu(struct kvm_vcpu *vcpu)
> >>          kvm_restore_fpu(&vcpu->arch.fpu);
> >>          vcpu->arch.aux_inuse |=3D KVM_LARCH_FPU;
> >>          trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_FPU)=
;
> >> -
> >> -       preempt_enable();
> >>   }
> >>
> >>   #ifdef CONFIG_CPU_HAS_LSX
> >>   /* Enable LSX and restore context */
> >>   int kvm_own_lsx(struct kvm_vcpu *vcpu)
> >>   {
> >> -       preempt_disable();
> >> -
> >>          /* Enable LSX for guest */
> >>          kvm_check_fcsr(vcpu, vcpu->arch.fpu.fcsr);
> >>          set_csr_euen(CSR_EUEN_LSXEN | CSR_EUEN_FPEN);
> >> @@ -1378,7 +1395,6 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
> >>
> >>          trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_LSX)=
;
> >>          vcpu->arch.aux_inuse |=3D KVM_LARCH_LSX | KVM_LARCH_FPU;
> >> -       preempt_enable();
> >>
> >>          return 0;
> >>   }
> >> @@ -1388,8 +1404,6 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
> >>   /* Enable LASX and restore context */
> >>   int kvm_own_lasx(struct kvm_vcpu *vcpu)
> >>   {
> >> -       preempt_disable();
> >> -
> >>          kvm_check_fcsr(vcpu, vcpu->arch.fpu.fcsr);
> >>          set_csr_euen(CSR_EUEN_FPEN | CSR_EUEN_LSXEN | CSR_EUEN_LASXEN=
);
> >>          switch (vcpu->arch.aux_inuse & (KVM_LARCH_FPU | KVM_LARCH_LSX=
)) {
> >> @@ -1411,7 +1425,6 @@ int kvm_own_lasx(struct kvm_vcpu *vcpu)
> >>
> >>          trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_LASX=
);
> >>          vcpu->arch.aux_inuse |=3D KVM_LARCH_LASX | KVM_LARCH_LSX | KV=
M_LARCH_FPU;
> >> -       preempt_enable();
> >>
> >>          return 0;
> >>   }
> >> --
> >> 2.39.3
> >>
> >>
>
>

