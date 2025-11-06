Return-Path: <kvm+bounces-62234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BC438C3CFD8
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 19:02:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B85BD4E5554
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 18:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E462232F753;
	Thu,  6 Nov 2025 18:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IbxB/F35"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F1A26FA6E
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 18:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762452057; cv=none; b=tWYIbkt9oWYEqL44kh557H7VPAFIUX4Q04C0Fuu+3QS1IiIMYavmzGrYGL5HeqVHcZm19+IyByMHZ/JU3NhIrnztScRNjOuSDo/71RexDRUjPuIdE25+9r8ZtPQpdPfw+S0m9Xgu6u2Pk4oq4DEQPU+MsxTreNtGyccDlGsFd2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762452057; c=relaxed/simple;
	bh=RDbOBh66JjfFuihq973fOzGY3o9zf2l1zRXPEVekqzE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N9LeUAfYSNefvcP1ctkDxbQ6Khr2mm/qIREDorZnwb/dNo7SC7cp6pkqP5+i5t2hVyXhBRpijJkzSMUPXBR65XCiuQJ5opZKHZQJV3ojmAZiDa6z5c2mB9fpynEUEfRoCVqdxtNjBA+lEdKMDxZjOhQ4d5AXFIK6+9R0xFDwhBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IbxB/F35; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-640b1d0496aso492a12.0
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 10:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762452054; x=1763056854; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ECxc40/29Z32hQLab5xgI0WYbyB6Uam5SiKdMQt43ew=;
        b=IbxB/F35JSeMuUWgL7ZzMS4I35FMAoE3bkr6uWDqgUkDaL0Y7tBeih0zJZaGbzc7Xn
         W6gitdVahiT1WoTZjqYw6hBdoo4u/EUtPavbBWADM/Q19eeyM9mvK9wPgtPWh6ZXPne+
         8fSa3zCE2CdKuTChCvgrfyq8mSZZ9DiBtyikjJm/hPFfOUYGmRxE/BwKXEhR/MhHptoc
         w2r+nQ/e8jiVXUWmAXfwU6UlbZ0igVWvcQn00f/eSGQL/IDYkld6z8Zi99H2uio2StsI
         wsrJnVxreJQ9iSAbh5sruzlhBSS0CgawIvT96lUnyf1LYch2op1i5XuS8x5JtGUJ5mm7
         MW1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762452054; x=1763056854;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ECxc40/29Z32hQLab5xgI0WYbyB6Uam5SiKdMQt43ew=;
        b=FoBbdv6pF2buSGxMQ1Ch5ccRw2K55Rly17a9xBBEVKSOnXfdil34c0dVxPUzFKhxDF
         ZXdMyhfbjbV9sjPIzUWt/MdnbIwm0PLYIdRZbmLPoeXaFg7Y7WrvhvwASPQIQcLDnc6C
         P6r1QFoNHKyRIzgdlShtU9nSCgUvOAkQY/uU1CTB3+Ci2ECLELJbFw7GU5J/ikepbqlq
         9y1jV1CWQUF6kxZPf6DfSHhN1/hKTGr+gs9RGrP3DFqmT4yYJQD/O1QlnuW4SS2x47MW
         8CQr+lTRi2Milbhi/nWwPAoGBD5GVJSstXdW/uDk1wEEg64qnG+xHVZr7COt1+SUknHn
         Pq7w==
X-Forwarded-Encrypted: i=1; AJvYcCVk3aYb4jjqbDen0c7CpJAcSsEAD8jn9UBnG72+k3ZmDyGXfz3gOWpHtDivuHx1rKCIqkk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKdqA4D0bvXzrL97ByTCWfciwWR1kPwfl11lwhWELHaOEwAHb9
	Q+/nyw6ZAgSo20XvvygJgrev0luFUbhNbKMBZamOoEsuyh01D8FphNCkgs3p8PLe3YKgkNsk9iI
	useZfvuFd+Zw+hvwxOB6MBEncDnJWxAoRbWUtU0OV
X-Gm-Gg: ASbGncuDzIYcM+lvBFaDXO4iY8liEQ3RVy4HGs56U4rq/ZBXvzY9/gZUtpMJj77u214
	Tyj6D29g7QI06zY+k0jfLhc1A2Z6e94ExUckXpfook/NvanbtHYlZPRbSJ/Q8mRm1vQ5PgPueIp
	2KHz5/IQRnjwD2ZOEOctd/5DN7k7sb/bRQlrUJwgZyHpZMA3uMzUS8dT7n48/oCUPzGFny/Fr4q
	BZQikiLF2HxkquvyHFyBKrC52qCzwnbaObBIkWpUQf/H3ieCrgVpcU54xlT
X-Google-Smtp-Source: AGHT+IE7GjLCqbggaJQz0UO9QtVJXndW650mkFQiyDlLAyMAbdE71393iphWqqs4UlmzxKitL9AYC90ViRjQuJU6m/Q=
X-Received: by 2002:aa7:cf93:0:b0:640:fa3c:da93 with SMTP id
 4fb4d7f45d1cf-6413f4f7c98mr6926a12.4.1762452053454; Thu, 06 Nov 2025 10:00:53
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251101000241.3764458-1-jmattson@google.com> <6f749888-28ef-419b-bc0a-5a82b6b58787@amd.com>
In-Reply-To: <6f749888-28ef-419b-bc0a-5a82b6b58787@amd.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 6 Nov 2025 10:00:40 -0800
X-Gm-Features: AWmQ_bmLFtgDgGCdP9lS_QlaeE1Am88tZ8dhTXJnTRlEz705U-E3EMSXmDVBmHI
Message-ID: <CALMp9eQJ69euqBs2NF6fQtb-Vf_0XqSiXs07h29Gr57-cvdGJg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: SVM: Mark VMCB_LBR dirty when L1 sets DebugCtl[LBR]
To: Shivansh Dhiman <shivansh.dhiman@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, nikunj.dadhania@amd.com, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Matteo Rizzo <matteorizzo@google.com>, evn@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 6, 2025 at 8:09=E2=80=AFAM Shivansh Dhiman <shivansh.dhiman@amd=
.com> wrote:
>
> On 01-11-2025 05:32, Jim Mattson wrote:
> > With the VMCB's LBR_VIRTUALIZATION_ENABLE bit set, the CPU will load
> > the DebugCtl MSR from the VMCB's DBGCTL field at VMRUN. To ensure that
> > it does not load a stale cached value, clear the VMCB's LBR clean bit
> > when L1 is running and bit 0 (LBR) of the DBGCTL field is changed from
> > 0 to 1. (Note that this is already handled correctly when L2 is
> > running.)
> >
> > There is no need to clear the clean bit in the other direction,
> > because when the VMCB's DBGCTL.LBR is 0, the VMCB's
> > LBR_VIRTUALIZATION_ENABLE bit will be clear, and the CPU will not
> > consult the VMCB's DBGCTL field at VMRUN.
> >
> > Fixes: 1d5a1b5860ed ("KVM: x86: nSVM: correctly virtualize LBR msrs whe=
n L2 is running")
> > Reported-by: Matteo Rizzo <matteorizzo@google.com>
> > Reported-by: evn@google.com
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 153c12dbf3eb..b4e5a0684f57 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -816,6 +816,8 @@ void svm_enable_lbrv(struct kvm_vcpu *vcpu)
> >       /* Move the LBR msrs to the vmcb02 so that the guest can see them=
. */
> >       if (is_guest_mode(vcpu))
> >               svm_copy_lbrs(svm->vmcb, svm->vmcb01.ptr);
> > +     else
> > +             vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
> >  }
> >
> >  static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
>
> Hi Jim,
> I am thinking, is it possible to add a test in KVM Unit Tests that
> covers this? Something where the stale cached value is loaded instead of
> the correct one, without your patch.

Though permitted by the architectural specification, I don't know if
there is any hardware that caches the DBGCTL field when LBR
virtualization is disabled.

