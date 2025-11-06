Return-Path: <kvm+bounces-62236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D472C3D127
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 19:29:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DEDAC4E324F
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 18:29:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9AF634574D;
	Thu,  6 Nov 2025 18:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tt/9nv3l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3F030F931
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 18:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762453786; cv=none; b=fZ2ZSxQtq75G/9VtArZXB+1roy/zdW2oLhwVtDQiUMu4ThE/9JwsLBIY7OXuQXegvu5Y3xhUuKva7tZp9RsMBwJcb7fOCc7PMJs0KcToTEKdFmunM0HkuT8MMkRvUWLqy/2HSXmgCpnLDpTaW3PRmlBsyLRs8rQRlSG4TMA/7AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762453786; c=relaxed/simple;
	bh=Hk2kkkXAIhT7SLFpYPU2qd4ra9YnnoIlTUZDjuxhE60=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sxKYDvlzhuwHIgPX305GJ3WEA9I3gMilWLhxk6UQZHtMd6gnbsgTPGTdfpMdbOrQDXclYSOHEMAGLa3nN8WfdD/I3FGEWa4/HYc3XySBQu33BI+POLlmszfiJIFAj79mCYTLoL7FVPrcHUkrZyDHZ2+eBraxFbKKUOGya66uNBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tt/9nv3l; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-3761e5287c9so12097181fa.2
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 10:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762453783; x=1763058583; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A66ECIPhhDrcdtn9psWFuT8F3KeGTGpZjxoa205S5r8=;
        b=Tt/9nv3lUq5QJzNNzSri/kDy0kaEUZC0TPtpx+vGRjEvyWq1rkJg3dgbON04HCFGfD
         Nl6PdypFngkKZKsSukE0TgFCUnTRE1qwfKByD4wWHv7bpKXBSh8tjKyU/zlvN0tcRdnX
         TMaaFwcQG2gAEBUgITjVyAe0oN6IoUMIc2bDbcIjSVOKIkS+RQVcq0oHelC2trKCarys
         P1CbUUJc5NnGNiGZZdBop4VMDFLRDo0ZnCsaetVKsTK95cgL4MKoMSWjiSRbGrwkkwD0
         ajOgHxrQZjqchViSQijo3ON6VH2VY4FNKkEJP2i2wGTnM8bmcDwdbWTdkqMPmGqHQpxY
         2wOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762453783; x=1763058583;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A66ECIPhhDrcdtn9psWFuT8F3KeGTGpZjxoa205S5r8=;
        b=A0NJGQSSwys7DRlFMjsOP17tjnhgf2ioFU4FxHWAGjRN2ZKl3zfXPJ4+Pt6fMlcmG2
         d+vMn/bsUkd3zCGQVfx9CV//kpX91qZt7PKPM19Nc0U53LcVn8C9HNeNyGeyZo4oPW7H
         nAMSYaty65j0LQfCJXlSDRhfy5syn4T5pCNYiPWfgiW3mOyMuaz+H46w72/S/XXCEcFn
         cODyAZjFMkm6yQonoVGZMHf/P6t5qgXX2RTNRwd3V7XCbh4SwBs/XROECJrcyKAuVUUz
         ZjtZnk/s5aANg1d1irlhNSB9EvJXEXPBf5DHk/v89EkOVbOdMFVX9HBvJO19g76aJP7W
         KEYw==
X-Gm-Message-State: AOJu0YwC8IL+0a8zhM4fHkV/OjaVh8Wyf+wbBKrYBFqK+pkTH2EREXTh
	Qi/K0ZHrEwvoOOwUksFhWlx5PqC7z4/L6hwg6J/vmC/PTAL5ckq+mo3iPRDF7aTpSLFfrxqFMTj
	9IN1NhFzJv9uRBp0nRr/eoy1hCN//jQoDxA/l
X-Gm-Gg: ASbGncuf4D3jrGpdmEmv0kxXSCtXeVDpV3TntcjHpbD6M3TRqTudmFTUbW0knQ795ip
	c+3J8dqbRlk2SCjO/PIr17FtO4NFPSvwX3Ntn799eDFc1xrTm33mLl/yroPEBZCMEGdnM7CzhRi
	wU+qVH1vdY75Sq5ONLEBiTLhhsnl3faeBTb6aYPSN77DreYuBZPJLTRL7CPXZy1Ie4WaGkHO2zQ
	ycqUCO08dms3IOJQZxiE54296o16AwPV0XVoxAa5m2a7ug62fmYSKhOl6VrQuhBjt5zCQA=
X-Google-Smtp-Source: AGHT+IFxE5CJeoOVNA1k5WhO44qMMlAItFYH7FTjGkRzoWepzYjW/MXRUWMCq/Gb8/8s2KlF+dkeFMMq6bXkYiuXaMY=
X-Received: by 2002:a05:651c:f08:b0:37a:2e63:d4c0 with SMTP id
 38308e7fff4ca-37a73155778mr907001fa.16.1762453783180; Thu, 06 Nov 2025
 10:29:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807063733.6943-1-ubizjak@gmail.com> <aKSRbjgtp7Nk8-sb@google.com>
 <CAFULd4ZOtj7WZkSSKqLjxCJ-yBr20AYrqzCpxj2K_=XmrX1QZg@mail.gmail.com>
 <aKTI1WOJAKDnkRyu@google.com> <CAFULd4ZR6TPVqq5TXToR-0HbX5oM=NEdw126kcDe5LNDdxZ++w@mail.gmail.com>
 <CAFULd4Y6W0hJbA8Ki2yB60537mC8+ohXyUgxD+HuKDQhq7zGmA@mail.gmail.com> <aQv14mmAkUPL-Fap@google.com>
In-Reply-To: <aQv14mmAkUPL-Fap@google.com>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Thu, 6 Nov 2025 19:29:31 +0100
X-Gm-Features: AWmQ_bmgjjm2sj4rYZqaFqFzmhntIXH-7Wb0by4SazycfXC0teZFBBV6Nt2z3SQ
Message-ID: <CAFULd4Zc4-nPLSEeUbOh_A1O9VyC8arHVy=Y4Gg-d_Rjhon1Ow@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Micro-optimize SPEC_CTRL handling in __vmx_vcpu_run()
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 6, 2025 at 2:12=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:

> > VMX patch is at [1]. SVM patch is a bit more involved, because new
> > 32-bit code needs to clobber one additional register. The SVM patch is
> > attached to this message, but while I compile tested it, I have no
> > means of testing it with runtime tests. Can you please put it through
> > your torture tests?

[...]

> > -
> >       /* Now restore the host value of the MSR if different from the gu=
est's.  */
> > -     movl PER_CPU_VAR(x86_spec_ctrl_current), %eax
> > -     cmp SVM_spec_ctrl(%_ASM_DI), %eax
> > +     mov SVM_spec_ctrl(%rdi), %rdx
> > +     cmp PER_CPU_VAR(x86_spec_ctrl_current), %rdx
> >       je 901b
> > -     xor %edx, %edx
> > +     movl %edx, %eax
> > +     shr $32, %rdx
> > +#else
> > +     mov %eax, SVM_spec_ctrl(%edi)
> > +     mov %edx, SVM_spec_ctrl + 4(%edi)
> > +998:
> > +     /* Now restore the host value of the MSR if different from the gu=
est's.  */
> > +     mov SVM_spec_ctrl(%edi), %eax
> > +     mov PER_CPU_VAR(x86_spec_ctrl_current), %esi
> > +     xor %eax, %esi
> > +     mov SVM_spec_ctrl + 4(%edi), %edx
> > +     mov PER_CPU_VAR(x86_spec_ctrl_current + 4), %edi
> > +     xor %edx, %edi
> > +     or %edi, %esi
> > +     je 901b
>
> This particular flow is backwards, in that it loads the guest value into =
EDX:EAX
> instead of the host values.

Yeah, sorry about that, I was really not sure which value is where.
Please just swap

SVM_spec_ctrl(%edi) with PER_CPU_VAR(x86_spec_ctrl_current)

references (and their offseted variants) in the above code, and it
will result in the correct and optimal code.

Thanks,
Uros.

