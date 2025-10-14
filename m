Return-Path: <kvm+bounces-60039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A1B9BDB91F
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 00:07:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 78693355E88
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 22:07:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B36F30CD88;
	Tue, 14 Oct 2025 22:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z9mE685U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79FE2E7BB5
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 22:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760479633; cv=none; b=I0hK2sE9jAo/ZB0Obe9bJggRyxvgp6Rph07X/lyxET4eETgxt+nkGCfyPDsbVze1wXhu2Vj3SJBh2KlyEYkbXmpXm3d/QtWUZerLlI/YSmsnYuOZcKXgQ/c/5S1TIJD7wjOJIzhThFcr9FFOXscjv6zl+aG3v0W6s6fNDY4DziU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760479633; c=relaxed/simple;
	bh=wnFdZqXYeAXtbdV313BIpvSA6zjC7j+fKfwJsNp0zGA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OMnlTfnOND95TDPD1HHCUUgkCfsK+6h1PHui1yePZSca2ZS6JddYRgTlGDlLsZL5EvPJqIr9ULM5tzDOMnq2kUfAOiPMSZUtYx4sqZneyKfrmfDjkodp5CDVoPkqwTqNtbMD/YqK9rMhJIJ5RUfF5JWESV088sRN+UGBkncFXwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z9mE685U; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-780f914b5a4so8217098b3a.1
        for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 15:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760479631; x=1761084431; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rNX6O4uSRV6iEU2BzMigXWXOKgqDw50DhtKf0yhiqyU=;
        b=Z9mE685US1p2wdXd+WcyJ9iz3V7u9A6OyXhRP4DxPQFTUpq/2FyxThnl/aYgCTTrbx
         q7g+V/e2LZ4GjQU8OcFhDszhOb+ahi+Hc9/WMdn4Tna8cn6bxDU4MtvrQ4tH3OP3bZi+
         PftUgsvJ6pqrA0iTQq0rbPSbKrWFC7FiOgT4xUQ9ouf7W5+i/ACVZyFmbB0xn3dJfmoF
         anxa3/QFvoyvY3fA7w2+XBw4BLxOsSjtZJmOhzKA1UB4QRbZ2GOjzW770fadd+SWXSfU
         uc6rCP1+3tVlHtb1fD7QRAvtt8nguFR5XL5AgX8rgoMekgL2Zt1PMv0yHokjV+NVP1lO
         wS0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760479631; x=1761084431;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rNX6O4uSRV6iEU2BzMigXWXOKgqDw50DhtKf0yhiqyU=;
        b=GAcP/ZYoZwNTm05E2sA/zRCCnas2wBgfkhLPoo2rXbQekTF7aZbjk6Pbzud0VI/Aku
         qdytrZIkwZP2wuerFWM1S6rms9Fhvq3K4BjlpE3m9awc5+7KHX89oGwrUFTfUFiFVOI1
         kiNSi/8Jq8VYnzFBtOPod9KFpgWQgfWCQWpYPlmGTNbUClz0CtIulS0t1FNRGmqtxMXp
         JIWTTtKTEst/ayXDdJXEnwN09RERc/Oyrg9dtvoH3b5LMe/MFqlEjrzP30HLTuFAgaIf
         YK06Mmlx3t+6o4bg2SYroXAlEqk4qCksMAEiTXWAk+zZNT9oBc5g/rE0Ge+dngjj+6tX
         sMSw==
X-Forwarded-Encrypted: i=1; AJvYcCXSLPnrM34UXvWIprYYShldbdye0xmTI0dyaabWuHqyCA4lt8/P6aCgXYoysiarxc0DVzE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyL3JLc0RgSys1Mu1iZ9RixV9gZXe/xdu0wdul3hXTozGcXhsg0
	1N1b4MCr1sMvCInbPXcA74m+9Sa00OL8c4exsKxwH5YHY3Ig1S6hwDDqWfsE4g+UxSm4evK54/r
	4vc1J+w==
X-Google-Smtp-Source: AGHT+IHD0tqHmqymVNcD8hqYAvtsPSzCGMVrD/Mio+rZshGt1MLStR36lR/TpeQEYFeF/VGOe08XUjNTM8E=
X-Received: from pjro4.prod.google.com ([2002:a17:90a:b884:b0:330:acc9:302e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a125:b0:244:3a85:cd7c
 with SMTP id adf61e73a8af0-32da81394ebmr34974900637.10.1760479630838; Tue, 14
 Oct 2025 15:07:10 -0700 (PDT)
Date: Tue, 14 Oct 2025 15:07:09 -0700
In-Reply-To: <CALMp9eRJaO9z=u5y0e+D44_U_FH1ye2s+cHNHmtERxEe+k2Dsw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251009223153.3344555-1-jmattson@google.com> <20251009223153.3344555-3-jmattson@google.com>
 <aO1-IV-R6XX7RIlv@google.com> <CALMp9eRQZuDy8-H3b8tbdZVQSznUK9=yhuBV9vBFAQz3UP+iRg@mail.gmail.com>
 <aO6-CbTRPp1ZNIWq@google.com> <CALMp9eRJaO9z=u5y0e+D44_U_FH1ye2s+cHNHmtERxEe+k2Dsw@mail.gmail.com>
Message-ID: <aO7JjaymjPMBcjrz@google.com>
Subject: Re: [PATCH v2 2/2] KVM: SVM: Don't set GIF when clearing EFER.SVME
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 14, 2025, Jim Mattson wrote:
> On Tue, Oct 14, 2025 at 2:18=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Tue, Oct 14, 2025, Jim Mattson wrote:
> > > On Mon, Oct 13, 2025 at 3:33=E2=80=AFPM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > > >
> > > > On Thu, Oct 09, 2025, Jim Mattson wrote:
> > > > > Clearing EFER.SVME is not architected to set GIF.
> > > >
> > > > But it's also not architected to leave GIF set when the guest is ru=
nning, which
> > > > was the basic gist of the Fixes commit.  I suspect that forcing GIF=
=3D1 was
> > > > intentional, e.g. so that the guest doesn't end up with GIF=3D0 aft=
er stuffing the
> > > > vCPU into SMM mode, which might actually be invalid.
> > > >
> > > > I think what we actually want is to to set GIF when force-leaving n=
ested.  The
> > > > only path where it's not obvious that's "safe" is toggling SMM in
> > > > kvm_vcpu_ioctl_x86_set_vcpu_events().  In every other path, setting=
 GIF is either
> > > > correct/desirable, or irrelevant because the caller immediately and=
 unconditionally
> > > > sets/clears GIF.
> > > >
> > > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > > index a6443feab252..3392c7e22cae 100644
> > > > --- a/arch/x86/kvm/svm/nested.c
> > > > +++ b/arch/x86/kvm/svm/nested.c
> > > > @@ -1367,6 +1367,8 @@ void svm_leave_nested(struct kvm_vcpu *vcpu)
> > > >                 nested_svm_uninit_mmu_context(vcpu);
> > > >                 vmcb_mark_all_dirty(svm->vmcb);
> > > >
> > > > +               svm_set_gif(svm, true);
> > > > +
> > > >                 if (kvm_apicv_activated(vcpu->kvm))
> > > >                         kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu=
);
> > > >         }
> > > >
> > >
> > > This seems dangerously close to KVM making up "hardware" behavior, bu=
t
> > > I'm okay with that if you are.
> >
> > Regardless of what KVM does, we're defining hardware behavior, i.e. kee=
ping GIF
> > unchanged defines behavior just as much as setting GIF.  The only way t=
o truly
> > avoid defining behavior would be to terminate the VM and completely pre=
vent
> > userspace from accessing its state.
>=20
> This can't be the only instance of "undefined behavior" that KVM deals
> with.

Oh, for sure.  But unsurprisingly, people only care about cases that actual=
ly
matter in practice.  E.g. the other one that comes to mind is SHUTDOWN on A=
MD:

	/*
	 * VMCB is undefined after a SHUTDOWN intercept.  INIT the vCPU to put
	 * the VMCB in a known good state.  Unfortuately, KVM doesn't have
	 * KVM_MP_STATE_SHUTDOWN and can't add it without potentially breaking
	 * userspace.  At a platform view, INIT is acceptable behavior as
	 * there exist bare metal platforms that automatically INIT the CPU
	 * in response to shutdown.
	 *

> What about, say, misaligned accesses to xAPIC memory?

Drops all accesses (doesn't even set the destination on reads).

