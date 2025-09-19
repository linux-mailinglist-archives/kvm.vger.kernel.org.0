Return-Path: <kvm+bounces-58143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DDDEB8928E
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 12:54:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42A11581C80
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 10:54:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7C1530B515;
	Fri, 19 Sep 2025 10:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="j6AUy+sj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E584D244668
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 10:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758279246; cv=none; b=ILldeAuAneIl1NqLsFTByf/FAqbykjyyNEwBa8ZWqd9UmjOrzx0fyUXgPCSbe+FsdEHn3buGKjmuYTLXTx67+kcqXvXKknRnQ9YImtFgnhlR4Jp6dD3MkQJIQTR6xn91FGTq2hTG7qVGjQfCEDf6CnoIq8FgLZkcDTo/WPvdUeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758279246; c=relaxed/simple;
	bh=dlBqN6s2KaMTj78q1hAYaCO2jqx4CfAlVXMMxWBVwRg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tKvu9ZjAw4AzXpNSQIQ8AshpV3bNTx7lfZv76apHHKkHjmbKn9xwtVnGa7BsQRJig+2qqiP6atiEZmw+uprZbkFTQuzqKn2l8lRDYek5lo8cSMPg1WItvhh/tbM67kSv+wAka7NYI3jcKAkNGlyc7BxPP27kMK4ib9176CWqRks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=j6AUy+sj; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-330631e534eso1682938a91.0
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 03:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758279243; x=1758884043; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VwXF4nj9Ctk9ENZA1Gy7QLttXCNWXb5F14RFISsUWAo=;
        b=j6AUy+sjsf5jch97JcB6QIfaCndwK06Zlj1lIXlmhCFXw92DHL+/v/r+QY3Ss+EZ5r
         wALy7WeyOsgFytV8M+iElL98Y64CHt/3FBvavJQbfBapoLudetClyRWABv+9lOAkbjxV
         6mmfaZrB1AtGNxA3o9TMga+a/7fvQavYjCG9iOajkq4F63GG4gFDRqYT7jEiV1fCloez
         LPm+Bb+0njjIdBWN3Xt0c0v6oIRTAaE9ArBZPIfG4u8Z2kjOzG+xbaahKTaDx2AQyKT4
         hIPBUSI/9A2EJhtTbdUW/oix1ZWhLRZdw08g/U0Lwqmnigg2yvkgKPvmWuPuI9/32Vcs
         5n8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758279243; x=1758884043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VwXF4nj9Ctk9ENZA1Gy7QLttXCNWXb5F14RFISsUWAo=;
        b=fm19MUW1E7y+GdvtgeJ6QOCIjN/oChCN7+Z+4lKBmeHc2D6PLn6v21I7Ls8JwIAoTN
         dyHKfwqPVuVosmTJj64/mTStI2j89A0pXSJSxV5zgl6Ej6RI0+u6b2cai9iXCi3ijRxC
         +VkKw4eBrNOPZahbxxbeXIydK802oSmocObHj7M2Gjc3UYZWlu+U4RNlc1SCN7bC2IRx
         f1jOxYhwkphisTMmwBBWNvHIdO/NQ1/m4jJzuEZdzT4uEQH5+uPi8ftPeOjCbg/IzjRu
         8P8iL/w0PpCubsbV/BgxVPSeFXgXKB4O5HX7kvFONAAOHmt2xncozvSJKBZvXGix64v4
         oNog==
X-Forwarded-Encrypted: i=1; AJvYcCUOPDCq8sq31c29q7xST56prkpO85HKzx5+XUm2zmAqnNoJP6j4FC/EL8InelGXKWuTlDA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvCfaLq12g7OUhp96KQ1kNr3+jWC5rN+J1EF1Fp8oFjxjQhJuP
	2Z4QZK5YLLo0UxeU4xPcya3IWA7R1OzENyzSOmi3+59wGWRUt6l6RafQGhF1EA7RPtszW1id86b
	AAU8uN2qNC4CHSZVq6BfwprxeYuRDAO8+/l5KH/fGvg==
X-Gm-Gg: ASbGncsfWk07yLkQWu9Um9JLUjMF+bdxn8xU2V0YhMQ6M6fPd5Za75Ju1vNeq56CXpN
	VANr7HqHZ4o2wKq49r8uT7Y79CDo3iLObaxqqYrVeB/suooyAM6j1bO6U4/LKxU6TvAAJY8VU0J
	2YUrTglTD6csHzy1flgs6Np2frefFwfYM30YftHzUe5mmdwqLVMQrUuECHnW8aVbJ8OwfvRSfT5
	CWcWYozjUh9VXhQB0NTq+LNyxEiPYwUCBNAo75LJb/g1hSbFGD7
X-Google-Smtp-Source: AGHT+IFxeJMPLYhVopFZ/wMGe4/MLpf50j7fyW/JSos7YqNV48KuEAenh3nTAVS5vu18B3CE2dLqvQk2LQK3xveldfU=
X-Received: by 2002:a17:90b:3fcf:b0:330:6f16:c4d8 with SMTP id
 98e67ed59e1d1-33097fd4e41mr3511663a91.7.1758279243172; Fri, 19 Sep 2025
 03:54:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250919073714.83063-1-luxu.kernel@bytedance.com>
 <aM0qlTNPiaQRY2Nv@andrea> <CAPYmKFsP+=S56Cj2XT0DjdvBT_SY84moM4LVeqxHTVWbtq4EVw@mail.gmail.com>
In-Reply-To: <CAPYmKFsP+=S56Cj2XT0DjdvBT_SY84moM4LVeqxHTVWbtq4EVw@mail.gmail.com>
From: Xu Lu <luxu.kernel@bytedance.com>
Date: Fri, 19 Sep 2025 18:53:52 +0800
X-Gm-Features: AS18NWDkb7q9MGkDnErZbfpP4LgF33f4wEnUX8H6rIWl06tQwmVParxSdVieQQ4
Message-ID: <CAPYmKFsV_ZPifJBtvPOdqM6_Mzhac9A4-PH9zt8TirOqAwKGhw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v3 0/8] riscv: Add Zalasr ISA extension support
To: Andrea Parri <parri.andrea@gmail.com>
Cc: corbet@lwn.net, robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	alex@ghiti.fr, will@kernel.org, peterz@infradead.org, boqun.feng@gmail.com, 
	mark.rutland@arm.com, ajones@ventanamicro.com, brs@rivosinc.com, 
	anup@brainfault.org, atish.patra@linux.dev, pbonzini@redhat.com, 
	shuah@kernel.org, devicetree@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, apw@canonical.com, joe@perches.com, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 19, 2025 at 6:39=E2=80=AFPM Xu Lu <luxu.kernel@bytedance.com> w=
rote:
>
> Hi Andrea,
>
> On Fri, Sep 19, 2025 at 6:04=E2=80=AFPM Andrea Parri <parri.andrea@gmail.=
com> wrote:
> >
> > On Fri, Sep 19, 2025 at 03:37:06PM +0800, Xu Lu wrote:
> > > This patch adds support for the Zalasr ISA extension, which supplies =
the
> > > real load acquire/store release instructions.
> > >
> > > The specification can be found here:
> > > https://github.com/riscv/riscv-zalasr/blob/main/chapter2.adoc
> > >
> > > This patch seires has been tested with ltp on Qemu with Brensan's zal=
asr
> > > support patch[1].
> > >
> > > Some false positive spacing error happens during patch checking. Thus=
 I
> > > CCed maintainers of checkpatch.pl as well.
> > >
> > > [1] https://lore.kernel.org/all/CAGPSXwJEdtqW=3Dnx71oufZp64nK6tK=3D0r=
ytVEcz4F-gfvCOXk2w@mail.gmail.com/
> > >
> > > v3:
> > >  - Apply acquire/release semantics to arch_xchg/arch_cmpxchg operatio=
ns
> > >  so as to ensure FENCE.TSO ordering between operations which precede =
the
> > >  UNLOCK+LOCK sequence and operations which follow the sequence. Thank=
s
> > >  to Andrea.
> > >  - Support hwprobe of Zalasr.
> > >  - Allow Zalasr extensions for Guest/VM.
> > >
> > > v2:
> > >  - Adjust the order of Zalasr and Zalrsc in dt-bindings. Thanks to
> > >  Conor.
> > >
> > > Xu Lu (8):
> > >   riscv: add ISA extension parsing for Zalasr
> > >   dt-bindings: riscv: Add Zalasr ISA extension description
> > >   riscv: hwprobe: Export Zalasr extension
> > >   riscv: Introduce Zalasr instructions
> > >   riscv: Use Zalasr for smp_load_acquire/smp_store_release
> > >   riscv: Apply acquire/release semantics to arch_xchg/arch_cmpxchg
> > >     operations
> > >   RISC-V: KVM: Allow Zalasr extensions for Guest/VM
> > >   KVM: riscv: selftests: Add Zalasr extensions to get-reg-list test
> > >
> > >  Documentation/arch/riscv/hwprobe.rst          |   5 +-
> > >  .../devicetree/bindings/riscv/extensions.yaml |   5 +
> > >  arch/riscv/include/asm/atomic.h               |   6 -
> > >  arch/riscv/include/asm/barrier.h              |  91 ++++++++++--
> > >  arch/riscv/include/asm/cmpxchg.h              | 136 ++++++++--------=
--
> > >  arch/riscv/include/asm/hwcap.h                |   1 +
> > >  arch/riscv/include/asm/insn-def.h             |  79 ++++++++++
> > >  arch/riscv/include/uapi/asm/hwprobe.h         |   1 +
> > >  arch/riscv/include/uapi/asm/kvm.h             |   1 +
> > >  arch/riscv/kernel/cpufeature.c                |   1 +
> > >  arch/riscv/kernel/sys_hwprobe.c               |   1 +
> > >  arch/riscv/kvm/vcpu_onereg.c                  |   2 +
> > >  .../selftests/kvm/riscv/get-reg-list.c        |   4 +
> > >  13 files changed, 242 insertions(+), 91 deletions(-)
> >
> > I wouldn't have rushed this submission while the discussion on v2 seems
> > so much alive;  IAC, to add and link to that discussion, this version
>
> Thanks. This version is sent out to show my solution to the FENCE.TSO
> problem you pointed out before. I will continue to improve it. Look
> forward to more suggestions from you.
>
> > (not a review, just looking at this diff stat) is changing the fastpath
> >
> >   read_unlock()
> >   read_lock()
> >
> > from something like
> >
> >   fence rw,w
> >   amodadd.w
> >   amoadd.w
> >   fence r,rw
> >
> > to
> >
> >   fence rw,rw
> >   amoadd.w
> >   amoadd.w
> >   fence rw,rw
> >
> > no matter Zalasr or !Zalasr.  Similarly for other atomic operations wit=
h
> > release or acquire semantics.  I guess the change was not intentional?
> > If it was intentional, it should be properly mentioned in the changelog=
.
>
> Sorry about that. It is intended. The atomic operation before
> __atomic_acquire_fence or operation after __atomic_release_fence can
> be just a single ld or sd instruction instead of amocas or amoswap. In
> such cases, when the store release operation becomes 'sd.rl', the
> __atomic_acquire_fence via 'fence r, rw' can not ensure FENCE.TSO
> anymore. Thus I replace it with 'fence rw, rw'.

This is also the common implementation on other architectures who use
aq/rl instructions like ARM. And you certainly already knew it~

>
> I will make it a separate commit and provide more messages in the
> changelog. Maybe alternative mechanism can be applied to accelerate
> it.
>
> Best Regards,
> Xu Lu
>
> >
> >   Andrea

