Return-Path: <kvm+bounces-41313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C8B88A660E4
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 22:45:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7AE86189D543
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 21:45:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E378E2046BB;
	Mon, 17 Mar 2025 21:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hRtTTPjB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBB91FFC44
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 21:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742247910; cv=none; b=pw6cQTGvp+7v81fyYL6E55E4XN1tBxwLPjp6X9SarMpm/QLqRIJA4+VmBztDPsTDzt7rRiSbXdk03anr5EVkG2+pv/3oyZOI0sGgIRxwFVKrU2aksahlm6TFUiWIh/Zi/xvKTviIam9FPhzleN3QUqgUKRQ61DeGp8OjRy3qE8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742247910; c=relaxed/simple;
	bh=qGuBMwUgYPCFmiSnkIp468ARzujFQwB/axZPZKSz35M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hJpW88yLmfR1zdcrwSpT92S7NXT/rNA+bI66VWYMagCX6dUxq7HpCVu4UalfcP7+n9j0BR0IXZEMVJDFv3recJ3C7QZihKYtgG86yU5j4buw/pBSaif6YPySC7D+zfKjZ5l6T850geaY13rgMllOaUBGEHelRI46qHAM3RuZsgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hRtTTPjB; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5e5cbd8b19bso554a12.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 14:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742247906; x=1742852706; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e+UlSbDa+iWfloAv4POenZq5+jJKOwBMLDrwYGGtfog=;
        b=hRtTTPjB7p28G9snofO+7W4e/TxlzfxXNhbxafImFHVJNXj6bF7k2SAg/5racsqrld
         wfBhGEyQa58dsNnLvrf5K4LZPmy5tS3cZSODjAHZWHrtffpxR+IM8y+B/jsCLNRqVJSm
         uYbxHRKWBzzt+ytVJkm3TEvYfzjGkcw00eqe3AcGtpdGub+WY4rEAbDM50bb2psAzowf
         eEjEQaZtfBSonUrWtAroGH+uWCcnNrDybbbCiUSnyG2RuPDLs5KRsxJzmHB5gqwq8raC
         9dFQqzE+xDcX4ohhvgQZC5NlR2fin00Rz3Qfjn9mTUbTtbJB0ooPZQcfgBNsH7xwc2Tg
         /Pvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742247906; x=1742852706;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e+UlSbDa+iWfloAv4POenZq5+jJKOwBMLDrwYGGtfog=;
        b=BUN0EQZiAg+7esFieQ6++D4xsxYnkGvygxMKLVoFHv6Xgafr1L/gTb2fM5cNNyWEip
         BvN45yp+TXwSVslo7Tz6sSCCyEXGebkVg4Z72n60wnXTuzmkJcuXPi1EqL8iECi60pIP
         gOqenyoZfiJlDP4EgxzHkWxsNqUVVgaRuAbqfBysOnSXItQsPNcPmOHEC0fuBtQc3k6m
         4p9TPQecbruglNgXH7e+TKCBE7gEftCLza4zmM/a3n2GhEcd0QWpQ5wlxCme2jx55JAr
         liy2WUpHLVPU3RAvmmye7nwah1fCFCL1SgpxlXVbMCAlmpUeJDQO2ultJ6qgqZO9b85e
         08fw==
X-Forwarded-Encrypted: i=1; AJvYcCX/uNvQeRDx7DZ05LAQr49T+zzcOBAYqY+2dJPIP3A/eWB7fVoHiiwMEhiVGl5EUVMYIBk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1OAiriTbNK+uYRM56JY4b3m/+VbRJiXEfqQQSlDxx/DORKjfI
	0tqZteJ0awl667CDOjhm6LjIZaolS8+1nTleE9A/eO7qerQ66KMqftFlp0de1QfZkCOA13JmD+n
	yy/Lb8LnoWwghpvxF58HsvdYrxbMu16Bl6395
X-Gm-Gg: ASbGncvenOkCvThSSjlSCen8M/32Mcz2kmHaChm9YRFLeKXILumBiDqB11KK7roydDw
	Ba2PH9RVCDq9t0ZKdawsjAjzVGfzyDn43/OgaCokWiFLfjgsXv4oTIw12kkEo+EEfRLSg7I8uKW
	kfS82z/bPS4VuFkcKawyd7uXe+lN36uPQJHIWSSPwBc/zwM53Ee4ixXA==
X-Google-Smtp-Source: AGHT+IFOuI8zBzdz5P9mZCjAcJ0PGcKiZJJsRoliq8EtccrTzjpgSm8p9NyjvGmxzsx0+qDR8xfeGqrfTkN2y/tRMqY=
X-Received: by 2002:a05:6402:c88:b0:5dc:5ae8:7e1 with SMTP id
 4fb4d7f45d1cf-5eb28167071mr6002a12.6.1742247906374; Mon, 17 Mar 2025 14:45:06
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250313215540.4171762-1-yosry.ahmed@linux.dev>
 <20250313215540.4171762-7-yosry.ahmed@linux.dev> <Z9iQEV9SQYjtLT8V@google.com>
In-Reply-To: <Z9iQEV9SQYjtLT8V@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 17 Mar 2025 14:44:54 -0700
X-Gm-Features: AQ5f1JpC_Kh2J8nyxlOGHvLujsQp6Fk5jpTE6vjZbph6alUiBCWj5yMX41GaXXo
Message-ID: <CALMp9eT5ur+g4W60JAwBxYRfBqa4t0w_6OdrAGOha3s+fyhbaA@mail.gmail.com>
Subject: Re: [PATCH 6/7] KVM: SVM: Use a single ASID per VM
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 17, 2025 at 2:12=E2=80=AFPM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> On Thu, Mar 13, 2025 at 09:55:39PM +0000, Yosry Ahmed wrote:
> > The ASID generation and dynamic ASID allocation logic is now only used
> > by initialization the generation to 0 to trigger a new ASID allocation
> > per-vCPU on the first VMRUN, so the ASID is more-or-less static
> > per-vCPU.
> >
> > Moreover, having a unique ASID per-vCPU is not required. ASIDs are loca=
l
> > to each physical CPU, and the ASID is flushed when a vCPU is migrated t=
o
> > a new physical CPU anyway. SEV VMs have been using a single ASID per VM
> > already for other reasons.
> >
> > Use a static ASID per VM and drop the dynamic ASID allocation logic. Th=
e
> > ASID is allocated during vCPU reset (SEV allocates its own ASID), and
> > the ASID is always flushed on first use in case it was used by another
> > VM previously.
> >
> > On VMRUN, WARN if the ASID in the VMCB does not match the VM's ASID, an=
d
> > update it accordingly. Also, flush the ASID on every VMRUN if the VM
> > failed to allocate a unique ASID. This would probably wreck performance
> > if it happens, but it should be an edge case as most AMD CPUs have over
> > 32k ASIDs.
> >
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> [..]
> > @@ -3622,7 +3613,7 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu,=
 fastpath_t exit_fastpath)
> >
> >  static int pre_svm_run(struct kvm_vcpu *vcpu)
> >  {
> > -     struct svm_cpu_data *sd =3D per_cpu_ptr(&svm_data, vcpu->cpu);
> > +     struct kvm_svm *kvm_svm =3D to_kvm_svm(vcpu->kvm);
> >       struct vcpu_svm *svm =3D to_svm(vcpu);
> >
> >       /*
> > @@ -3639,9 +3630,15 @@ static int pre_svm_run(struct kvm_vcpu *vcpu)
> >       if (sev_guest(vcpu->kvm))
> >               return pre_sev_run(svm, vcpu->cpu);
> >
> > -     /* FIXME: handle wraparound of asid_generation */
> > -     if (svm->current_vmcb->asid_generation !=3D sd->asid_generation)
> > -             new_asid(svm, sd);
> > +     /* Flush the ASID on every VMRUN if kvm_svm->asid allocation fail=
ed */
> > +     if (unlikely(!kvm_svm->asid))
> > +             svm_vmcb_set_flush_asid(svm->vmcb);
>
> This is wrong. I thought we can handle ASID allocation failures by just
> reusing ASID=3D0 and flushing it on every VMRUN, but using ASID=3D0 is
> illegal according to the APM. Also, in this case we also need to flush
> the ASID on every VM-exit, which I failed to do here.
>
> There are two ways to handle running out of ASIDs:
>
> (a) Failing to create the VM. This will impose a virtual limit on the
> number of VMs that can be run concurrently. The number of ASIDs was
> quite high on the CPUs I checked (2^15 IIRC), so it's probably not
> an issue, but I am not sure if this is considered breaking userspace.

I'm pretty sure AMD had only 6 bits of ASID through at least Family
12H. At some point, VMCB ASID bits must have become decoupled from
physical TLB tag bits. 15 TLB tag bits is inconceivable!

> (b) Designating a specific ASID value as the "fallback ASID". This value
> would be used by any VMs created after running out of ASIDs, and we
> flush it on every VMRUN, similar to what I am trying to do here for
> ASID=3D0.
>
> Any thoughts on which way we should take? (a) is simpler if we can get
> away with it and all AMD CPUs have a sufficiently large number of ASIDs.
>

