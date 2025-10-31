Return-Path: <kvm+bounces-61694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0DD5C25F42
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 17:00:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE99C462FB9
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 15:59:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5D902ECEB9;
	Fri, 31 Oct 2025 15:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JaNkQLUh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF882E8E0B
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 15:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761926317; cv=none; b=INbG+8lMvCMW+m87sPxHDgkxcxG5iJSzai3q43d9k24WvqsrTee31AZ7t1umvHtqEnFKh5UZ8+Hsgnse4xia7mDr55x90Tk54dvrHVTuWvYtJFTKTlqWGeQGrGyeNmX/8zyoolqgN9M5tUOMzMDjTXJ/mylrYw/It3QHA8VD8AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761926317; c=relaxed/simple;
	bh=oDKGrvjYnBjEXA8R0C2lkaQtw6dIbfrYD5uITNwohR4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=six8xO7r1g+p8NAS30b4X33OtzZyaaCB23H7rCpRu8U6X04Ln7NliSWPlcaL5fU/tfwzhAtpdvwB478nIL3/bObq+wd2kB8yJpZpZvrmH0RSyHaAV3B75Ruyjt/z5D5UFdxPmi6xuRlNoieOjewGxuGR74ueqg+kmOGJWoO05PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JaNkQLUh; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ecfafb92bcso381951cf.1
        for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 08:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761926315; x=1762531115; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rkw27FRZDIHiqmRd0S6FvOLN7BP3vKzQBtGVU/uEpmg=;
        b=JaNkQLUhFjYTk10NTvYCHF1Y6yOyWcYlIlPwnw6p9gXbFH0k+k+J9LZ3AfMPLBb1wS
         3wpBBxCus4vopC//PUYvlYLHF4ITl5k8zb6wwxPLKptKYvuP4Y7FBrnn7R55ikT4Dtla
         cqnMutMHpjiCtV6riwuTahJMn8FDqFYmH4sxqKCCFObUC6yAPkX9sKEwcxLQs1QsEsQQ
         J0Rad/waH2mnLU3eu0jZMVPzy8wvCYHPQDmxKrQ+skEUPCtyqkBVFhfpMXqx9ledbM3N
         rQYFAzTKVKa1mhm30OrKYSUOOPL+kae054GZije4RcyzknUpCksr9N8sBrMywiXuhhDS
         lgwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761926315; x=1762531115;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rkw27FRZDIHiqmRd0S6FvOLN7BP3vKzQBtGVU/uEpmg=;
        b=EHkvSgoQUVmCDQvuahAyHCg+/IJqJz915pdP3sKW46DuPU3S9Nl5OrcyE37i5Eiz62
         cIKStxHLS78Reh5TlI2BAgJcPlwjAJ/me3XTuwX3En//ZBY+dgXJD9xJTZk+Kqpv6/iu
         oagFp0J4osymJawm0VNLbMNuDLEWb/JMGTDi+RZ4p5OzNwvamG/KiBkVeWvSCl8hPZY6
         2LweVTrMIPuYYKGM1Uax7RvIe0WtecFO7dAQfiVg4h4oQqt1CY/pXbkLDEq0JHZOnk/H
         zwpjLFiyjW5b6UhMZjIRPWjDwN9tYSyHUhAoEQ7OKDzHk70V8YOFqhPhMEsX8h7Hy8Wt
         KpRg==
X-Forwarded-Encrypted: i=1; AJvYcCWalBhujRMR7Wg3AgVzB4tile8Ef+apQMGpWrvfd2LM/56cwXFsLJSMIfeQW2r1M0+VoZY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywzw4/Iee2kJBaS6HNX4CprxCsXwze78+sbaS0M0YfhTbTgOZbK
	No6g0O9bjVAhYEaOw35GJEnNpA9bC8/UANFsl/zHninDtPxe5NQyEQo9cwQN8l/5Pw93Lklj+LI
	SaFpu/f0z+3BMnzkUUu8zUGbVPGS5QwVHpSQUjKZt
X-Gm-Gg: ASbGnctSqq3hCptOw/wKshL25rh0+H2eR7UzlWj2EA4yGFOLWyZexKfQGgsb1lN0O98
	i7koXiWKsLro5jcDIybfDB1AGrRVv17i36n3AONa75kHk8LGhzdLPE0iBWdrvavtnOVJ15GIstf
	1Qn8yIOL9IDEoVc9bV3HlHQKQdrNer8R1k/5wGDkGBborGsOinL3N8PsL5R9AGU1etGGG+vDOt1
	rLVdiliQmJrq3r789RRDghe3Q6jN9EqLA74VBca8iDi2LAfRgR5CMSmXcM0BI32iNu2uVLiBMMA
	o53Ak9QIgWY4CXC7
X-Google-Smtp-Source: AGHT+IHuBEQ4C6LGIJ18XN67FySiWSpAD97SDd92ywKvQu9sDaUIIZUhyKPAaQ6ktSg9chHPwL02QhOMVEV1HSeUbVI=
X-Received: by 2002:a05:622a:1a0a:b0:4b7:8de4:52d6 with SMTP id
 d75a77b69052e-4ed31cf1cadmr7618141cf.2.1761926314668; Fri, 31 Oct 2025
 08:58:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251028212052.200523-1-sagis@google.com> <20251028212052.200523-21-sagis@google.com>
 <6904c3834e3c0_231474100ca@iweiny-mobl.notmuch> <aQTSdk3JtFu1qOMj@google.com>
In-Reply-To: <aQTSdk3JtFu1qOMj@google.com>
From: Sagi Shahar <sagis@google.com>
Date: Fri, 31 Oct 2025 10:58:23 -0500
X-Gm-Features: AWmQ_blm8gbISb3ne8XkBDdtLBv49t1w6bnbUq8ELG_MNHSxeZDbZP8wGqvmnAo
Message-ID: <CAAhR5DHidvrzdkugdL-UNDugYUd9zypbbu1131GexbZpTPzB3g@mail.gmail.com>
Subject: Re: [PATCH v12 20/23] KVM: selftests: Add support for TDX TDCALL from guest
To: Sean Christopherson <seanjc@google.com>
Cc: Ira Weiny <ira.weiny@intel.com>, linux-kselftest@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Roger Wang <runanwang@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Oliver Upton <oliver.upton@linux.dev>, "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 31, 2025 at 10:15=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Fri, Oct 31, 2025, Ira Weiny wrote:
> > Sagi Shahar wrote:
> > > From: Erdem Aktas <erdemaktas@google.com>
> > >
> > > Add support for TDX guests to issue TDCALLs to the TDX module.
> >
> > Generally it is nice to have more details.  As someone new to TDX I
> > have to remind myself what a TDCALL is.  And any random kernel develope=
r
> > reading this in the future will likely have even less clue than me.
> >
> > Paraphrased from the spec:
> >
> > TDCALL is the instruction used by the guest TD software (in TDX non-roo=
t
> > mode) to invoke guest-side TDX functions.  TDG.VP.VMCALL helps invoke
> > services from the host VMM.
> >
> > Add support for TDX guests to invoke services from the host VMM.
>
> Eh, at some point a baseline amount of knowledge is required.  I highly d=
oubt
> regurgitating the spec is going to make a huge difference
>
> I also dislike the above wording, because it doesn't help understand _why=
_ KVM
> selftests need to support TDCALL, or _how_ the functionality will be util=
ized.
> E.g. strictly speaking, we could write KVM selftests without ever doing a=
 single
> TDG.VP.VMCALL, because we control both sides (guest and VMM).  And I have=
 a hard
> time belive name-dropping TDG.VP.VMCALL is going to connect the dots betw=
een
> TDCALL and the "tunneling" scheme defined by the GHCI for requesting emul=
ation
> of "legacy" functionality".
>
> What I would like to know is why selftests are copy-pasting the kernel's =
scheme
> for marshalling data to/from the registers used by TDCALL, how selftests =
are
> expected to utilize TDCALL, etc.  I'm confident that if someone actually =
took the
> time to write a changelog explaining those details, then what TDCALL "is"=
 will
> be fairly clear, even if the reader doesn't know exactly what it is.
>
> E.g. IMO this is ugly and lazy on multiple fronts:

To give some context to why this was done this way: Part of the reason
for the selftests is to test the GHCI protocol itself. Some of the
selftests will issue calls with purposely invalid arguments to ensure
KVM handles these cases properly. For example, issuing a port IO calls
with sizes other than 1,2 or 4 and ensure we get an error on the guest
side.

The code was intentionally written to be specific to TDX so we can
test the TDX GHCI spec itself.

As I understand it, you want the selftests to operate at a higher
level and abstract away the specific GHCI details so that the code can
be shared between TDX and SEV. I can refactor the code to abstract
away implementation details. However, tests that want to exercise the
API at a fine-grained level to test different arguments will need to
define these TDCALLs themselves.

These calls were placed in a header that can be included in the guest
code. I can add higher level wrappers that can be used for common
code.

>
> uint64_t tdg_vp_vmcall_ve_request_mmio_write(uint64_t address, uint64_t s=
ize,
>                                             uint64_t data_in)
> {
>        struct tdx_tdcall_args args =3D {
>                .r10 =3D TDG_VP_VMCALL,
>                .r11 =3D TDG_VP_VMCALL_VE_REQUEST_MMIO,
>                .r12 =3D size,
>                .r13 =3D MMIO_WRITE,
>                .r14 =3D address,
>                .r15 =3D data_in,
>        };
>
>        return __tdx_tdcall(&args, 0);
> }
>
> First, these are KVM selftests, there's no need to provide a super fancy =
namespace
> because we are "competing" with thousands upon thousands of lines of code=
 from
> other components and subsystems.
>
> Similarly, tdg_vp_vmcall_ve_request_mmio_write() is absurdly verbose.  Re=
ferencing
> #VE in any way is also flat out wrong.

This name was taken from the GHCI spec: TDG.VP.VMCALL<#VE.RequestMMIO>
("Intel TDX Guest-Hypervisor Communication Interface v1.5" section 3.7)

>
> It's also far too specific to TDX, which is going to be problematic when =
full
> support for SEV-ES+ selftests comes along.  I.e. calling this from common=
 code
> is going to be a pain in the rear, bordering on unworkable.
>
> And related to your comment about having enums for the sizes, there's abs=
olutely
> zero reason the caller should have to specify the size.
>
> In short, don't simply copy what was done for the kernel.  The kernel is =
operating
> under constraints that do not and should not ever apply to KVM selftests.=
  Except
> for tests like set_memory_region_test.c that delete memslots while a vCPU=
 is running
> and thus _may_ generate MMIO accesses, our selftests should never, ever t=
ake a #VE
> (or #VC) and then request MMIO in the handler.  If a test wants to do MMI=
O, then
> do MMIO.
>
> So, I want to see GUEST_MMIO_WRITE() and GUEST_MMIO_READ(), or probably e=
ven just
> MMIO_WRITE() and MMIO_READ().  And then under the hood, wire up kvm_arch_=
mmio_write()
> and kvm_arch_mmio_read() in kvm_util_arch.h.  And from there have x86 glo=
bally track
> if it's TDX, SEV-ES+, or "normal".  That'd also give us a good reason+way=
 to assert
> on s390 if a test attempts MMIO, as s390 doesn't support emulated MMIO.
>
> One potential hiccup is if/when KVM selftests get access to actual MMIO, =
i.e. don't
> want to trigger emulation, e.g. for VFIO related selftests when accessing=
 BARs.
> Though the answer there is probably to just use WRITE/READ_ONCE() and cal=
l it good.
>
> E.g.
>
> #define MMIO_WRITE(addr, val)                                   \
>         kvm_arch_mmio_write(addr, val);
>
> #define kvm_arch_mmio_write(addr, val)                          \
> ({                                                              \
>         if (guest_needs_tdvmcall)                               \
>                 tdx_mmio_write(addr, val, sizeof(val));         \
>         else if (guest_needs_vmgexit)                           \
>                 sev_mmio_write(addr, val, sizeof(val));         \
>         else                                                    \
>                 WRITE_ONCE(addr, val);                          \
> })
>
> #define MMIO_READ(addr, val)                                    \
>         kvm_arch_mmio_read(addr, val);
>
> #define kvm_arch_mmio_read(addr, val)                           \
> ({                                                              \
>         if (guest_needs_tdvmcall)                               \
>                 tdx_mmio_read(addr, &(val), sizeof(val));       \
>         else if (guest_needs_vmgexit)                           \
>                 sev_mmio_write(addr, &(val), sizeof(val));      \
>         else                                                    \
>                 (val) =3D READ_ONCE(addr);                        \
> })
>

