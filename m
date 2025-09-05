Return-Path: <kvm+bounces-56864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69307B45089
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 09:57:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B1B35401E1
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 07:57:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 171A22F7456;
	Fri,  5 Sep 2025 07:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vSyMFCjo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0462F39D0
	for <kvm@vger.kernel.org>; Fri,  5 Sep 2025 07:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757059046; cv=none; b=kV3/9hIyyQtwDFh1U4mz9opaeTcd+CJkU8xrQaHrMPolJztMtCirQT7Z9VOuTXqvXUBy7ufVLVZM65MHEoGP6zkLkXQS6i2E00FEQHJ9b4HE/uC1C8OJ9BaolWE+S7rTl2/2pTKvn6HtKdPsf4pA99KzlJtcCZtW+9uhkSfogVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757059046; c=relaxed/simple;
	bh=taJPAeAG+2Zan+gki5TcDy/2fEVopYdaZ3wK1NDP3ys=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eqeqsxYj3gOj2t8n3AcU40Bfrf58mZo9PgBuTxg9OYi+BPGV9UUjLK/cvsO/0bHNy/bdb+W6bxifE8VR1qHyRBIg6HjN+8yqQtsAj+TREf8goU1pW808r4CFpZY8xyYfn+OKF5jp/Eac+E6Vl4xGtsKJlT8NmVsCIKINgDRhUO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vSyMFCjo; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-329745d6960so1849344a91.0
        for <kvm@vger.kernel.org>; Fri, 05 Sep 2025 00:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757059044; x=1757663844; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o1p4RNecGHbuiyzLdGgu+/L6P6vwBjZh1dqH7jZHHi0=;
        b=vSyMFCjoPB+rD1vi2yTABZY6T+9blwto1/CEWd2zqPF7Zfk+jeRdhkaYn3QJwmKcn2
         YSWhRI9jFHoKiEhE+jwfUgfmuTUAs76ntO8/f4PJFBmeUZGA/jyN5DWpHKxBbozgUNNZ
         lY9Ho6whc5Fkdgb0ba8/zAzhVnjO5IOOguYfcpsBL7Irt8KwlD90+4yiP425A/8M/zcg
         +pAJhmj+ZhMl4pitsUgrBpTLq01cdULR0ugagopYExajIAtmoGyzjRO7KlNc4q0GEpT6
         mKNH+UXHFMtJ6DsBELtcFF6bi9pos34CkLhorAoYaCxQ3agVsehJ/XJlX1oYKYNI0OjX
         E5DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757059044; x=1757663844;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=o1p4RNecGHbuiyzLdGgu+/L6P6vwBjZh1dqH7jZHHi0=;
        b=RJn53uU1oZnWbbFfhdFix/vK3N9/6dF4SftQL0QANDjf2qg8OkGjKS455DvZf9z/fj
         bLlamVUvXqDnSheSmD+8MtL/uAXimiOU2ZT4YlA0qG9zb5sc++gYPDZX4CTgY2G+6qlZ
         vOn9sSkeGqD9izZLwKWDN7n8b4OK2SMdgWAxH0Wx75FEd5P99MRpIzx5+pRjkUD65rXX
         D4WWiPvE26WvvJz/fizpMfQz9aYj0idOvfDxRguTIlP8fmoiIL3rdYefiEAofS6YDHW1
         Bb2QMmB92OaDjmqIKyhBJfAIqMBo3qYZKujVe2nHACEkox6jlnXAB7VNnBjXSXqX7fFz
         IbiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUz6UuR1PS64p3J+HojQ3iQ0GA6Hi+o7m8svztQHwxLxM67vh5x6c0k/WYinmz/D43Q+hs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvsrT4xscPU3OyBmKAuqhQ8nBuOEgaAnzwA7XROmcHR7vbhIJN
	7yJsOeIsWlfFy17HhIiXAM4WH90aiGqXhD75pOY539ZObXCz8okyTlqIn1T6IIfQUAOIf0/VHXF
	IPs4gxw==
X-Google-Smtp-Source: AGHT+IElsE4xl0K6N1F4A7p04K+uccLu+aOxepEYOmrdsvIE1VqRxT8W9nlwBhTx39jAmxfTvyceCLWwNwc=
X-Received: from pji16.prod.google.com ([2002:a17:90b:3fd0:b0:329:8c4b:3891])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:57e7:b0:327:9345:7097
 with SMTP id 98e67ed59e1d1-32815437431mr31005228a91.10.1757059044131; Fri, 05
 Sep 2025 00:57:24 -0700 (PDT)
Date: Fri, 5 Sep 2025 00:57:07 -0700
In-Reply-To: <62d1231571c44b166a18181d724b32da33b38efb.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <54BCC060-1C9B-4BE4-8057-0161E816A9A3@amazon.co.uk>
 <caf7b1ea18eb25e817af5ea907b2f6ea31ecc3e1.camel@infradead.org>
 <aLIPPxLt0acZJxYF@google.com> <d74ff3c1c70f815a10b8743647008bd4081e7625.camel@infradead.org>
 <aLcuHHfxOlaF5htL@google.com> <3268e953e14004d1786bf07c76ae52d98d0f8259.camel@infradead.org>
 <aLl_MAk9AT5hRuoS@google.com> <4a3be390fe559de0bd5c61d24853d88f96a6ab6a.camel@infradead.org>
 <aLmTXb6PO02idqeM@google.com> <62d1231571c44b166a18181d724b32da33b38efb.camel@infradead.org>
Message-ID: <aLqX035O0lQEVPrl@google.com>
Subject: Re: [PATCH v2 0/3] Support "generic" CPUID timing leaf as KVM guest
 and host
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paul Durrant <pdurrant@amazon.co.uk>, Fred Griffoul <fgriffo@amazon.co.uk>, 
	Colin Percival <cperciva@tarsnap.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Graf (AWS), Alexander" <graf@amazon.de>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 04, 2025, David Woodhouse wrote:
> On Thu, 2025-09-04 at 06:25 -0700, Sean Christopherson wrote:
> > Anyways, I'm a-ok reporting that information in KVM_GET_SUPPORTED_CPUID=
 (again,
> > only with constant TSC and scaling).=C2=A0 Reporting the effective freq=
uency would be
> > useful for the host too, e.g. for sanity checks.=C2=A0 What I specifica=
lly want to
> > avoid is modifying guest CPUID at runtime.
>=20
> Hm, in some cases I thought KVM had deliberately moved *to* doing CPUID
> updates at runtime, so that its doesn't have to exempt the changable
> leaves from the sanity checks which prevent userspace from updating
> CPUID for a CPU which has already been run.

Ah, I shouldn't have qualified my statement with "runtime".  I don't want K=
VM
modifying incoming CPUID at all, as KVM's attempts to "help" userspace have
backfired more often than not.  The only scenarios where modifying CPUID is=
 ok
is for cases where a change in state architectural affects CPUID output, e.=
g. on
CR4 or MSR changes.

Moving the Xen CPUID fixup to runtime was essentially the least awful way t=
o deal
with KVM disallowing post-run CPUID changes, the underlying problem is that=
 KVM
was filling Xen CPUID in the first place.

> It's not just the existing Xen TSC leaf which is updated at runtime in
> kvm_cpuid().
>=20
> But I don't mind too much. If we give userspace a way to *know* the
> effective frequency, I'm OK with requiring that userspace do so and
> populate the corresponding CPUID leaves for itself, for Xen and KVM
> alike. We'd need to expose the FSB frequency too, not just TSC.
>=20
> I was only going with the runtime update because we are literally
> already *doing* it this way in KVM.
>=20
> > Hmm, the only wrinkle is that, if there is slop, KVM could report diffe=
rent
> > information when run on different platforms, e.g. after live migration.=
=C2=A0 But so
> > long as that possibility is documented, I don't think it's truly proble=
matic.
> > And it's another argument for not modifying guest CPUID directly; I'd r=
ather let
> > userspace figure out whether or not they care about the divergence than=
 silently
> > change things from the guest's perspective.
> >=20
> > Alternatively (or in addition to), part of me wants to stealtily update
> > KVM_GET_TSC_KHZ to report back the effective frequency, but I can see t=
hat being
> > problematic, e.g. if a naive VMM reads KVM_GET_TSC_KHZ when saving vCPU=
 state for
> > live migration and after enough migrations, the slop ends up drasticall=
y skewing
> > the guest's frequency.
>=20
> Indeed. And I also want to tell userspace the precise *ratio* being
> applied by hardware scaling, for the VMClock case where userspace
> definitely knows *better* about what the host TSC frequency is at this
> precise moment, and has to tell the guest what *its* TSC frequency is,
> with the same precision.

Maybe add the scaled/effective frequency and the ratio information as read-=
only
TSC attributes, e.g.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7ba2cdfdac44..4ba4c88f3d33 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5788,6 +5788,18 @@ static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vc=
pu,
                        break;
                r =3D 0;
                break;
+       case KVM_VCPU_TSC_SCALED_KHZ:
+               r =3D -EFAULT;
+               if (put_user(vcpu->arch.hw_tsc_khz, uaddr))
+                       break;
+               r =3D 0;
+               break;
+       case KVM_VCPU_TSC_SCALED_RATIO:
+               r =3D -EFAULT;
+               if (put_user(<math>, uaddr))
+                       break;
+               r =3D 0;
+               break;
        default:
                r =3D -ENXIO;
        }

