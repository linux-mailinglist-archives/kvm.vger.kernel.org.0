Return-Path: <kvm+bounces-60036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AA2DBDB6AF
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 23:31:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4FDB54EE0DA
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 21:31:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 647E9298CC4;
	Tue, 14 Oct 2025 21:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QTLkkq5R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37D21FC3
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 21:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760477476; cv=none; b=CCVRfm5Ld6xs9FhN6+c+PBufN+8nAIzTruItHPm0RHRFgL0d1Z6sHIXeoUtxzyTi8Lt8hAd0MSo2DY2R2XH0wqEolTbSZM40se5bbC9tGQawl7cV4CRip+S5yYbda42FJTR5hJIl3NTjlh16fxAIf52Vvsp2/cLee9RfkRa8KA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760477476; c=relaxed/simple;
	bh=LrZmi01dJi1077qM19aTvuOPrv0uFtTh2h5BEbeAeC0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dWnCVk1enQgZYz9haUYOtfrJZpHK+ro8laZuvQ6xKvQCS1I2mLt4ZCLAIgqbzs4z9LEJmiHDf0tFdig61AZWrVhVhycV6Pe/PBK+zNkKf+/bmXtGLBIeykZOI1LZL7C8W9WDerridFtaD/O/Rdq228Tx3v0wMtS6dnKIlzijNWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QTLkkq5R; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-634cc96ccaeso1190a12.1
        for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 14:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760477473; x=1761082273; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5/FvDDP5WuOibRVeq731Je4IWJQ6E0o70WTzZ9BRRjc=;
        b=QTLkkq5RqCHmZEpB1uYbVBAu04VYBLO5N9KVAKJMIngJRF4DY1Bcx28PCLW1r7N4wr
         RalQpKae5tc48amqxVAmIS5kLSDva6wP6jDtTuMqq9M0ieVVHLDJC6OfgWAydZZiIBgx
         JsOZJONHODizvHncFBt11+fmsTuqCGHMjAw6b1330JpV21K1GsGE2sGvn8b9xjnt7n4/
         RH8USYo1qgIWSTKJJshqbIniny/X15Zl8cd/7N2JuSn74CnAl2jUCqlAYHj7l4D+Qi4C
         9MaLlzWs7Nxdv7mWfp7NKwMswr/zgb5u3kfBBaacq9Jk88yVbaAftRjCcWikwlueNSIu
         VJgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760477473; x=1761082273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5/FvDDP5WuOibRVeq731Je4IWJQ6E0o70WTzZ9BRRjc=;
        b=M1b/Yfo2Rap4EwSITL8ZzroLHcwxDH4i6rotM0qOrMw2l1djRuhJ2bB2VRVEYo1vL6
         gAXkwJdrDO3+Ro0VGF0LFZaJeOx1T0g6fUinTXb8AVFCRIr9mlvEBinb+dLLpE5ydCxE
         OXHM6HslB6HqYVXdQHfTPM99ZCIr24L61ORzalqn77xXKC/fsb+XgZnMe9kKKbCbabw5
         Lq3q8CDbguY+VY8AlCVOKacArsfkqsGZUkVx7jfsDGB8GifiWt9szjkCStdC8wlP1bgU
         v+X+qHlEu+2fTL2cLuwDkNFIrqjI0ms0/RXpiwIrfnFXyH/nhuvau3DG9xjSDKwlhRul
         217g==
X-Forwarded-Encrypted: i=1; AJvYcCUzcD4Oyw8Q7VzFBiGIWmvEBh9eC54mZYbJ2eRRI4aXiQI+/xTAdBWHmW1p420pVSi3c1M=@vger.kernel.org
X-Gm-Message-State: AOJu0YzH7vq+qQcikJq/ZWgRhubHnltVRhVIptRZ0QjXepohyRixbnfc
	rDRET+FfTDKAfwo46w91eFsI7tjfggLvKe/STjN+sf1IMrIjWdrgLkhJl2f1rTWUQ39do6u5joU
	rmejkBtRSYyOhmPaUFmQ5xqOW4MmaJhC8lvfzIwot
X-Gm-Gg: ASbGncu0VbyZS1FZQqJxSfqnOcPeKU85HvbCGlyDbadv18vm2geyjCCIevPXhrjexvU
	rgzDv+zsURGC1I2ZXydm5yDw9HrpMx7AvUBxw8qHl/LGbys4DFUnFNbINEdsS6VUfduRJssY0lR
	1dhpKgfGNRMQYiE2j/8ih9tfOz1O3p82Ohgi+u5srECOWKPbJ3+TP9Au0yNWngsmVgUmIj4bb3H
	HewEe2XgiHpPJKYAjlOO778MPVU33MX
X-Google-Smtp-Source: AGHT+IFubOLyGfccp18VZ2iaf0m+asVedjW2o/+sCbHyBLQervH8mVm0W9qfdbV6tz5CEk3AQlyqFoxyixCHo65zN5Q=
X-Received: by 2002:a05:6402:2791:b0:62f:a20d:5a92 with SMTP id
 4fb4d7f45d1cf-63bebfe10cemr33165a12.4.1760477472887; Tue, 14 Oct 2025
 14:31:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251009223153.3344555-1-jmattson@google.com> <20251009223153.3344555-3-jmattson@google.com>
 <aO1-IV-R6XX7RIlv@google.com> <CALMp9eRQZuDy8-H3b8tbdZVQSznUK9=yhuBV9vBFAQz3UP+iRg@mail.gmail.com>
 <aO6-CbTRPp1ZNIWq@google.com>
In-Reply-To: <aO6-CbTRPp1ZNIWq@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 14 Oct 2025 14:31:00 -0700
X-Gm-Features: AS18NWD-jYwuNGiS5wI0FbvoxP7Ig0Kad9858TMaa3GVHF-gmRGAKkG6XV-DCyY
Message-ID: <CALMp9eRJaO9z=u5y0e+D44_U_FH1ye2s+cHNHmtERxEe+k2Dsw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: SVM: Don't set GIF when clearing EFER.SVME
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 14, 2025 at 2:18=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Oct 14, 2025, Jim Mattson wrote:
> > On Mon, Oct 13, 2025 at 3:33=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Thu, Oct 09, 2025, Jim Mattson wrote:
> > > > Clearing EFER.SVME is not architected to set GIF.
> > >
> > > But it's also not architected to leave GIF set when the guest is runn=
ing, which
> > > was the basic gist of the Fixes commit.  I suspect that forcing GIF=
=3D1 was
> > > intentional, e.g. so that the guest doesn't end up with GIF=3D0 after=
 stuffing the
> > > vCPU into SMM mode, which might actually be invalid.
> > >
> > > I think what we actually want is to to set GIF when force-leaving nes=
ted.  The
> > > only path where it's not obvious that's "safe" is toggling SMM in
> > > kvm_vcpu_ioctl_x86_set_vcpu_events().  In every other path, setting G=
IF is either
> > > correct/desirable, or irrelevant because the caller immediately and u=
nconditionally
> > > sets/clears GIF.
> > >
> > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > index a6443feab252..3392c7e22cae 100644
> > > --- a/arch/x86/kvm/svm/nested.c
> > > +++ b/arch/x86/kvm/svm/nested.c
> > > @@ -1367,6 +1367,8 @@ void svm_leave_nested(struct kvm_vcpu *vcpu)
> > >                 nested_svm_uninit_mmu_context(vcpu);
> > >                 vmcb_mark_all_dirty(svm->vmcb);
> > >
> > > +               svm_set_gif(svm, true);
> > > +
> > >                 if (kvm_apicv_activated(vcpu->kvm))
> > >                         kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
> > >         }
> > >
> >
> > This seems dangerously close to KVM making up "hardware" behavior, but
> > I'm okay with that if you are.
>
> Regardless of what KVM does, we're defining hardware behavior, i.e. keepi=
ng GIF
> unchanged defines behavior just as much as setting GIF.  The only way to =
truly
> avoid defining behavior would be to terminate the VM and completely preve=
nt
> userspace from accessing its state.

This can't be the only instance of "undefined behavior" that KVM deals
with. What about, say, misaligned accesses to xAPIC memory?

