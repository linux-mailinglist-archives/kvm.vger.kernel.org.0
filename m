Return-Path: <kvm+bounces-44847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF1D1AA4251
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 07:27:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAEFB3B84D7
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 05:26:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AED71E0489;
	Wed, 30 Apr 2025 05:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="ApNtjIBP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC27126BFF
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 05:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745990809; cv=none; b=ayaESorMsqvp9PGTV7v11hByPpdimiONFcqFGN92hPIs0PNxwTw8JMZvmsoyitEYcBgHvRTFwy9yLKsGUIP0C9w8IiC1V6pyXMLgLADngJLJq5swodmV7tGZr4FvuYgMx9vjc/GYXgCIBQq91MEnbMw6dRb0wWeK2BPon4JRkhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745990809; c=relaxed/simple;
	bh=ZIH1Z3Hzw73Uuqca+KcNdPdwXc7XoNqAgpykdeYV08w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l2tryASpqOd6jebfYGKkJ36+K8R7GqqtlZcCU1h1rHhah2PKQSuFBPQZDOtRnEKN2gGU+ktDZD7geiUQxpMkd5pAScaziIX0ICmVZ9I9qBmyZ5NMUb2i+E97KCclckUoANBzejwZUh56CHNdmx+W2jQxp+3ra33dW6Rof6LMVo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=ApNtjIBP; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3d90208e922so33653925ab.3
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 22:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1745990806; x=1746595606; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+MkiPmsG3mkmQZiCwEkz2dzxKv8RnutawwUqQ7pZMPg=;
        b=ApNtjIBPa5/TKmaKxVhAYZix6W6hZsUwQfuIZQX17pWgx9nn9x8m0TbsiuQVudVQbM
         W5WgNF18tmxVUK/JsqrNQPZ73VB1tMhMKmjXF2N9IPGPMPxVsb3LtW5LeQCITrX1hgP4
         PKSEnLU1nsYNgnRDtgVOIhVijJF1kQSYzpCXtIrD6r8lsJzH+Vxvcv7i73fTEY4CrTMI
         LMNMteFI4NccM1PCE3QLzJwO2lDVtjMTXpXXqC2qf77b0+bJMGBD5V2Qtjv3ZqZX76P1
         Fh9cNTjS0jPKAyUjGrdbxd/EgH1g7+fVKSRNqpNiQcMpf/5VLOlPA413wlH1VdliQu1u
         vxbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745990806; x=1746595606;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+MkiPmsG3mkmQZiCwEkz2dzxKv8RnutawwUqQ7pZMPg=;
        b=SUpXSNlSWCKawC3EbXzZvyXOf3wzOzLUslXVZBxtg6G/s4hz7/fQkPJljT4EmyyLmH
         aCKxRP0PvOeB4j98vOh0ELnVfqvYTZFE/esI3jwmcKS5uyfBueQn3Ni4vFxDz66VHxo3
         +59HF4tRiHn3SIDgqcm9W08UO7mijs6zQ055lyySUjls5wnOWRWDY28KiTNlugJOmCX9
         synS74f/r+aGI8OtOrhMeDbEXBzkhcV4jL0peSFrpNe2rXHB0Hq27ihqjZbwrT77dpiY
         76dH7lI70WdUagABPJOosn3Df8R73fDNtQdPDjqFkaLM/tlgFj6ehJdRJsVGA+CcpRof
         RnMg==
X-Forwarded-Encrypted: i=1; AJvYcCXSfL1dRdM9SkUPrFmdrQRrE3vz+9SpexBOTfVLZdnIV1YgtsgpP61rXSz9UPV2XufUq7I=@vger.kernel.org
X-Gm-Message-State: AOJu0YxefJD/5qS9jUHySYN5vZ95excni/z/Sad+LvdC/BDOX50utWL2
	Vhp5AoNEWgP8HSBFSy2ILdhfzgCPT3JCn5iXYx1UE28dA4ZcHAc4H/edD6fospwScnrC7gZghkG
	xsCFtXRgmaVyIeYeagBTfJWlDH6uw6XMheEFqfA==
X-Gm-Gg: ASbGncvisJWQWbMHu2a2BwhKF80FJkhp/5/8zMDwADkVTUvndgJSl7W/5PMK4MEHhgh
	SpL355K2DW6Ew3PRcxfhnVQ6D2Nj0zRUWG9YiCJb62YuCqsL2uIGJn3x806TVZAhRTddamYNrBD
	OgdZdQ9YkA2C9hlcJ1q9wds80=
X-Google-Smtp-Source: AGHT+IFZXzEtB0jjiXgliNkkiqNIuGyeeDc3qDfkSFq+9z1O8GmQc8xybVNFjrpWzvpB0eOCh9/oTUiRVJ2osAasNws=
X-Received: by 2002:a05:6e02:270a:b0:3d8:20fb:f060 with SMTP id
 e9e14a558f8ab-3d967fa3a4dmr10494115ab.4.1745990806280; Tue, 29 Apr 2025
 22:26:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
 <20250403112522.1566629-7-rkrcmar@ventanamicro.com> <CAAhSdy0e3HVN6pX-hcX2N+kpwsupsCf6BqrYq=bvtwtFOuEVhA@mail.gmail.com>
 <D9IGJR9DGFAM.1PVHVOOTVRFZW@ventanamicro.com> <CAK9=C2Woc5MtrJeqNtaVkMXWEsGeZPsmUgtFQET=OKLHLwRbPA@mail.gmail.com>
 <D9J1TBKYC8YH.1OPUI289U0O2C@ventanamicro.com> <CAAhSdy01yBBfJwdTn90WeXFR85=1zTxuebFhi4CQJuOujVTHXg@mail.gmail.com>
 <D9J9DW53Q2GD.1PB647ISOCXRX@ventanamicro.com> <CAAhSdy0B-pF-jHmTXNYE7NXwdCWJepDtGR__S+P4MhZ1bfUERQ@mail.gmail.com>
In-Reply-To: <CAAhSdy0B-pF-jHmTXNYE7NXwdCWJepDtGR__S+P4MhZ1bfUERQ@mail.gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 30 Apr 2025 10:56:35 +0530
X-Gm-Features: ATxdqUHMr06hEKP8GQXfBn7GSUhZ6lL6J079d1eMtsJ6wy9n373VxHCy_r3EKdg
Message-ID: <CAAhSdy20pq3KvbCeST=h+O5PWfs2E4uXpX9BbbzE7GJzn+pzkA@mail.gmail.com>
Subject: Re: [PATCH 4/5] KVM: RISC-V: reset VCPU state when becoming runnable
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: Anup Patel <apatel@ventanamicro.com>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Jones <ajones@ventanamicro.com>, Mayuresh Chitale <mchitale@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2025 at 9:52=E2=80=AFAM Anup Patel <anup@brainfault.org> wr=
ote:
>
> On Tue, Apr 29, 2025 at 9:51=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrc=
mar@ventanamicro.com> wrote:
> >
> > 2025-04-29T20:31:18+05:30, Anup Patel <anup@brainfault.org>:
> > > On Tue, Apr 29, 2025 at 3:55=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <=
rkrcmar@ventanamicro.com> wrote:
> > >>
> > >> 2025-04-29T11:25:35+05:30, Anup Patel <apatel@ventanamicro.com>:
> > >> > On Mon, Apr 28, 2025 at 11:15=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=
=99 <rkrcmar@ventanamicro.com> wrote:
> > >> >>
> > >> >> 2025-04-28T17:52:25+05:30, Anup Patel <anup@brainfault.org>:
> > >> >> > On Thu, Apr 3, 2025 at 5:02=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=
=99 <rkrcmar@ventanamicro.com> wrote:
> > >> >> >> For a cleaner solution, we should add interfaces to perform th=
e KVM-SBI
> > >> >> >> reset request on userspace demand.  I think it would also be m=
uch better
> > >> >> >> if userspace was in control of the post-reset state.
> > >> >> >
> > >> >> > Apart from breaking KVM user-space, this patch is incorrect and
> > >> >> > does not align with the:
> > >> >> > 1) SBI spec
> > >> >> > 2) OS boot protocol.
> > >> >> >
> > >> >> > The SBI spec only defines the entry state of certain CPU regist=
ers
> > >> >> > (namely, PC, A0, and A1) when CPU enters S-mode:
> > >> >> > 1) Upon SBI HSM start call from some other CPU
> > >> >> > 2) Upon resuming from non-retentive SBI HSM suspend or
> > >> >> >     SBI system suspend
> > >> >> >
> > >> >> > The S-mode entry state of the boot CPU is defined by the
> > >> >> > OS boot protocol and not by the SBI spec. Due to this, reason
> > >> >> > KVM RISC-V expects user-space to set up the S-mode entry
> > >> >> > state of the boot CPU upon system reset.
> > >> >>
> > >> >> We can handle the initial state consistency in other patches.
> > >> >> What needs addressing is a way to trigger the KVM reset from user=
space,
> > >> >> even if only to clear the internal KVM state.
> > >> >>
> > >> >> I think mp_state is currently the best signalization that KVM sho=
uld
> > >> >> reset, so I added it there.
> > >> >>
> > >> >> What would be your preferred interface for that?
> > >> >>
> > >> >
> > >> > Instead of creating a new interface, I would prefer that VCPU
> > >> > which initiates SBI System Reset should be resetted immediately
> > >> > in-kernel space before forwarding the system reset request to
> > >> > user space.
> > >>
> > >> The initiating VCPU might not be the boot VCPU.
> > >> It would be safer to reset all of them.
> > >
> > > I meant initiating VCPU and not the boot VCPU. Currently, the
> > > non-initiating VCPUs are already resetted by VCPU requests
> > > so nothing special needs to be done.
>
> There is no designated boot VCPU for KVM so let us only use the
> term "initiating" or "non-initiating" VCPUs in context of system reset.
>
> >
> > Currently, we make the request only for VCPUs brought up by HSM -- the
> > non-boot VCPUs.  There is a single VCPU not being reset and resetting
> > the reset initiating VCPU changes nothing. e.g.
> >
> >   1) VCPU 1 initiates the reset through an ecall.
> >   2) All VCPUs are stopped and return to userspace.
>
> When all VCPUs are stopped, all VCPUs except VCPU1
> (in this example) will SLEEP because we do
> "kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP)"
> so none of the VCPUs except VCPU1 (in this case) will
> return to userspace.
>
> >   3) Userspace prepares VCPU 0 as the boot VCPU.
> >   4) VCPU 0 executes without going through KVM reset paths.
>
> Userspace will see a system reset event exit for the
> initiating VCPU by that time all other VCPUs are already
> sleeping with mp_state =3D=3D KVM_MP_STATE_STOPPED.
>
> >
> > The point of this patch is to reset the boot VCPU, so we reset the VCPU
> > that is made runnable by the KVM_SET_MP_STATE IOCTL.
>
> Like I said before, we don't need to do this. The initiating VCPU
> can be resetted just before exiting to user space for system reset
> event exit.
>

Below is what I am suggesting. This change completely removes
dependency of kvm_sbi_hsm_vcpu_start() on "reset" structures.

diff --git a/arch/riscv/include/asm/kvm_host.h
b/arch/riscv/include/asm/kvm_host.h
index 0e9c2fab6378..6bd12469852d 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -396,6 +396,7 @@ int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
 int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
                const struct kvm_one_reg *reg);

+void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu);
 int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
 int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq=
);
 void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu);
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 02635bac91f1..801c6a1a1aef 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -51,7 +51,7 @@ const struct kvm_stats_header kvm_vcpu_stats_header =3D {
                sizeof(kvm_vcpu_stats_desc),
 };

-static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
+void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 {
     struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
     struct kvm_vcpu_csr *reset_csr =3D &vcpu->arch.guest_reset_csr;
@@ -689,6 +689,9 @@ static void kvm_riscv_check_vcpu_requests(struct
kvm_vcpu *vcpu)
     struct rcuwait *wait =3D kvm_arch_vcpu_get_wait(vcpu);

     if (kvm_request_pending(vcpu)) {
+        if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
+            kvm_riscv_reset_vcpu(vcpu);
+
         if (kvm_check_request(KVM_REQ_SLEEP, vcpu)) {
             kvm_vcpu_srcu_read_unlock(vcpu);
             rcuwait_wait_event(wait,
@@ -705,9 +708,6 @@ static void kvm_riscv_check_vcpu_requests(struct
kvm_vcpu *vcpu)
             }
         }

-        if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
-            kvm_riscv_reset_vcpu(vcpu);
-
         if (kvm_check_request(KVM_REQ_UPDATE_HGATP, vcpu))
             kvm_riscv_gstage_update_hgatp(vcpu);

diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index d1c83a77735e..79477e7f240a 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -146,9 +146,15 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *=
vcpu,
         spin_lock(&vcpu->arch.mp_state_lock);
         WRITE_ONCE(tmp->arch.mp_state.mp_state, KVM_MP_STATE_STOPPED);
         spin_unlock(&vcpu->arch.mp_state_lock);
+        if (tmp !=3D vcpu) {
+            kvm_make_request(KVM_REQ_SLEEP | KVM_REQ_VCPU_RESET, vcpu);
+            kvm_vcpu_kick(vcpu);
+        } else {
+            kvm_make_request(KVM_REQ_SLEEP, vcpu);
+        }
     }
-    kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);

+    kvm_riscv_reset_vcpu(vcpu);
     memset(&run->system_event, 0, sizeof(run->system_event));
     run->system_event.type =3D type;
     run->system_event.ndata =3D 1;
diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
index 3070bb31745d..30d7d59db5a5 100644
--- a/arch/riscv/kvm/vcpu_sbi_hsm.c
+++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
@@ -15,15 +15,15 @@

 static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu)
 {
-    struct kvm_cpu_context *reset_cntx;
-    struct kvm_cpu_context *cp =3D &vcpu->arch.guest_context;
-    struct kvm_vcpu *target_vcpu;
+    struct kvm_cpu_context *target_cp, *cp =3D &vcpu->arch.guest_context;
     unsigned long target_vcpuid =3D cp->a0;
+    struct kvm_vcpu *target_vcpu;
     int ret =3D 0;

     target_vcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, target_vcpuid);
     if (!target_vcpu)
         return SBI_ERR_INVALID_PARAM;
+    target_cp =3D &target_vcpu->arch.guest_context;

     spin_lock(&target_vcpu->arch.mp_state_lock);

@@ -32,17 +32,12 @@ static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu=
)
         goto out;
     }

-    spin_lock(&target_vcpu->arch.reset_cntx_lock);
-    reset_cntx =3D &target_vcpu->arch.guest_reset_context;
     /* start address */
-    reset_cntx->sepc =3D cp->a1;
+    target_cp->sepc =3D cp->a1;
     /* target vcpu id to start */
-    reset_cntx->a0 =3D target_vcpuid;
+    target_cp->a0 =3D target_vcpuid;
     /* private data passed from kernel */
-    reset_cntx->a1 =3D cp->a2;
-    spin_unlock(&target_vcpu->arch.reset_cntx_lock);
-
-    kvm_make_request(KVM_REQ_VCPU_RESET, target_vcpu);
+    target_cp->a1 =3D cp->a2;

     __kvm_riscv_vcpu_power_on(target_vcpu);

@@ -63,6 +58,7 @@ static int kvm_sbi_hsm_vcpu_stop(struct kvm_vcpu *vcpu)
         goto out;
     }

+    kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
     __kvm_riscv_vcpu_power_off(vcpu);

 out:

Regards,
Anup

