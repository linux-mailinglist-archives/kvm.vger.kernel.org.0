Return-Path: <kvm+bounces-8942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 622CC858CD9
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 02:41:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 867EB1C21EC0
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 01:41:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C34F81B7F6;
	Sat, 17 Feb 2024 01:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FFvRBMOy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84501149DE8
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 01:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708134055; cv=none; b=WTH0p+XZsIdBnSpNfTZMESYnNHba3nT+G3munSP6QOjNIpNIHst4ehnJoEJ1myWU50IIOtl5w6b06Hr0LM9S4TwwTm+b2fRoYIe7KCrCb8vfs0pGWweduy7cZU5p8LKQK/9vDlxYQvB0ihiG++n3mv5xjt/b6fNvSU1a3RH2Vko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708134055; c=relaxed/simple;
	bh=WZhqQDBeYhNc482c7VxqGDqUzFUPH+/HUWY5cBltVFE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aXNcldt/RbZnmICLhEoAHiBwk2VygLdYpsfcj1ELuei39cjFsPZlIH87I6DZDvZdUrcHNpwoQQdUmiYnH/XMBjXRV7i4BsGGL9hf4OZjBZo5PSBspa/JhvGbzFWwZHqYr7zb1QYL3fIDlrv2fA9BdLiJ6U7TWT6+SfPz3/CRcGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FFvRBMOy; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e0a646ce9bso2849957b3a.0
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 17:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708134053; x=1708738853; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/UyWsHrP5h/aqLoNzYARDniuxeUImZgOEiBo3TmFOEo=;
        b=FFvRBMOyH37i+Ik7zscfIG1imlvJYOg7KJIw0q/xQJWNqUm+ycrh601JRBIsbQRpyX
         OcjlFh32E+OzFGlI77PP6/DdF78ii1CflX39R1O9L0ZVf1jDm3Np33G5tAWvgU+od7D/
         LNcm/VaLwFAV/wyJj8wzCguvfERfmusjF+gN3JMywPnrh+iOjUSAev2fIbHJCaFDaf14
         kFW6Pmy1LrQOBc9rH+p3ZRquL39xCrjomHDbZ1UIcQ9gGWbC/YWjELAaH+WOszTBkfW+
         baQHMEGdH98P+CvimAbN7cHUoHGLhEn/k0lsX6/ToN1ym9hutNxpgSOoOWwJyDiI48Hk
         hYeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708134053; x=1708738853;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/UyWsHrP5h/aqLoNzYARDniuxeUImZgOEiBo3TmFOEo=;
        b=oKV/EGSoO6MJuBzmWGwQIgQtRURUP9rptZnZ1q66J/hs6cDx4H5dkzIF8jFhxel580
         3Id3N7hAOtXDJ7Da0G6IMAtx3xZGJwZ7+dmyI9h9QmXXEeVu0fHmeUIy/Jg6wwdiYj0X
         I+7d1qIHkNIqmzITtlEhiw27+JdnAR2UW5FZVce0fNQO+DqOCg7gNTJ5T8AzFLAoAxAO
         jY8h1xQZeXhe0cuipJi1fFwwiJPxdz2gbBBTw0IoxFgxj5LeGT5CsS7aEiTf9guXST72
         uYYq2CCtdbIXblz0CvvcaWrL6+q5m2El9HYnWb8e+tkP/5iilLbvtYAlCMlPuHBerF4H
         VUPw==
X-Forwarded-Encrypted: i=1; AJvYcCVo6iCQXNBtxYozlBf2EoeCDaeTL41/fJBN72hMuEVLQhknxFjHevyPrBpb9GHQVB9+1s3ZLuehTdave/4JBfHfFag2
X-Gm-Message-State: AOJu0YwCCGFKqvkMYMgAgXRtXwc1FdB8Xj4hVnRnXqFzmhZO1zRZoNE+
	UKJkBQHEKlM+gJnvHSgDgUAADH0z+VtV422ChTrVGpHYZN16OKI4zksHmJu/NmD+jG7x1A7M0qF
	1bg==
X-Google-Smtp-Source: AGHT+IEy1EPClrFTjgqONbxqfpCoYeMU9NFcYI6rzsv700TT4HDoTIeVV7dg80ZktDfS7qpZgZ/O9tRpD/I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1956:b0:6e0:42e0:5e7e with SMTP id
 s22-20020a056a00195600b006e042e05e7emr411026pfk.5.1708134052897; Fri, 16 Feb
 2024 17:40:52 -0800 (PST)
Date: Fri, 16 Feb 2024 17:40:51 -0800
In-Reply-To: <CABgObfY=aGJNMk4CYb7nvauBWLJVbwVaA69bOK4bLteH7YyBNA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240209183743.22030-1-pbonzini@redhat.com> <ZcZ_m5By49jsKNXn@google.com>
 <CABgObfaum2=MpXE2kJsETe31RqWnXJQWBQ2iCMvFUoJXJkhF+w@mail.gmail.com>
 <ZcrX_4vbXNxiQYtM@google.com> <CABgObfY=aGJNMk4CYb7nvauBWLJVbwVaA69bOK4bLteH7YyBNA@mail.gmail.com>
Message-ID: <ZdAOo2AAm_NrTdOe@google.com>
Subject: Re: [PATCH 00/10] KVM: SEV: allow customizing VMSA features
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	aik@amd.com, isaku.yamahata@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 13, 2024, Paolo Bonzini wrote:
> On Tue, Feb 13, 2024 at 3:46=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >   __u32 flags;
> >   __u32 vm_type;
> >   union {
> >         struct tdx;
> >         struct sev;
> >         struct sev_es;
> >         struct sev_snp;
> >         __u8 pad[<big size>]
> >   };
> >
> > Rinse and repeat for APIs that have a common purpose, but different pay=
loads.
> >
> > Similar to KVM_{SET,GET}_NESTED_STATE, where the data is wildly differe=
nt, and
> > there's very little overlap between {svm,vmx}_set_nested_state(), I fin=
d it quite
> > valuable to have a single set of APIs.  E.g. I don't have to translate =
between
> > VMX and SVM terminology when thinking about the APIs, when discussing t=
hem, etc.
> >
> > That's especially true for all this CoCo goo, where the names are ridic=
ulously
> > divergent, and often not exactly intuitive.  E.g. LAUNCH_MEASURE reads =
like
> > "measure the launch", but surprise, it's "get the measurement".
>=20
> I agree, but then you'd have to do things like "CPUID data is passed
> via UPDATE_DATA for SEV and INIT_VM for TDX (and probably not at all
> for pKVM)". And in one case the firmware may prefer to encrypt in
> place, in the other you cannot do that at all.
>=20
> There was a reason why SVM support was not added from the beginning.
> Before adding nested get/set support for SVM, the whole nested
> virtualization was made as similar as possible in design and
> functionality to VMX. Of course it cannot be entirely the same, but
> for example they share the overall idea that pending events and L2
> state are taken from vCPU state; kvm_nested_state only stores global
> processor state (VMXON/VMCS pointers on VMX, and GIF on SVM) and,
> while in guest mode, L1 state and control bits. This ensures that the
> same userspace flow can work for both VMX and SVM. However, in this
> case we can't really control what is done in firmware.
>=20
> > The effort doesn't seem huge, so long as we don't try to make the param=
eters
> > common across vendor code.  The list of APIs doesn't seem insurmountabl=
e (note,
> > I'm not entirely sure these are correct mappings):
>=20
> While the effort isn't huge, the benefit is also pretty small, which
> comes to a second big difference with GET/SET_NESTED_STATE: because
> there is a GET ioctl, we have the possibility of retrieving the "black
> box" and passing it back. With CoCo it's anyway userspace's task to
> fill in the parameter structs. I just don't see the possibility of
> sharing any code except the final ioctl, which to be honest is not
> much to show. And the higher price might be in re-reviewing code that
> has already been reviewed, both in KVM and in userspace.

Yeah, I realize I'm probably grasping at straws.  *sigh*

