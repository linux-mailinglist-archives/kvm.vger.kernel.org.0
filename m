Return-Path: <kvm+bounces-60402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B1555BEBDF1
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 23:57:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 49AD11AE21CE
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 21:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5751E3328E0;
	Fri, 17 Oct 2025 21:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HlWhebB9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4A82E0938
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 21:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760738222; cv=none; b=m/lc5Fia5pPUSskRsfF7ybT8Pv3ZZQ/x4+gntEcEEuYCEnGrc4+pstmioHDBsaeSOxXxTdxDh8+fP4nppeKODo8U1VDUmdQpNyeYM1nl/f2p3fjgPNit4QEuNaafdRfTTQG3hRZjenMk0N8hmPGL7c4+vXIvEkATZkhtkEeY3ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760738222; c=relaxed/simple;
	bh=4daT32qE+1S0C9usnIwJKvKUX0uxiLOyRkF3CT/5mtE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SPYQwa1Gx78bTrz920QVwEUBkBcP/5o0kt639CDsUmYlkDoqnFfYzi+EofpGfWq+Z69MkGuvYb+9R3Zm2Rzw0ZyRk+NZ+x5ji4epeX4cBWgbGkQAMDOK4wYl3Xw5ObEHP3+HBOtZCqPX/9NR0/x7p9mB1UBXW+nf1+eqa71ldQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HlWhebB9; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-339ee7532b9so5352461a91.3
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 14:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760738220; x=1761343020; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MvqjTwkA+9MGUzD3s5qogag6sVzTQL35wEzEARE3CmU=;
        b=HlWhebB9CvqjFRZvDGGQPnJANd3C69q4aRK0LTMqhICyHuLb/zVQC3Z85/lPld0Fx3
         C+1zkhG+Qqe6cDUr4bbbzN/bueOostxKlHTfyk6ctVJrIhs/VB1jGyZTlHGNbjs8Lwjg
         ryfjcZizaICHLikIsEkGIfKgyVZdkiuj0K6y/UT7giJnHOKFmkKHqlwkHe/8LGWk1JL5
         cPATLXg73ZODdvrRWWKBc/dMWIV4hlAO0pDFmOUpFaloIZTuNmqsfL9uExxUEXSUsVWU
         B0GxwHxYf+PRzJyX2PrjGeAFfxWehE/nmf6PnddPRJr6bLcfia50HLiOicpcRyfCVbkm
         ZTeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760738220; x=1761343020;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MvqjTwkA+9MGUzD3s5qogag6sVzTQL35wEzEARE3CmU=;
        b=mYxPB1nlToBECAqiBBaoK++wJS1HpMPInp2+7jsL47djfR943VpnhKk1sjjFbb9+r3
         85j6SX6gNx0pKTPVQQodupj2hIq99zx2Cdvdy2+aQwx30dVYoOzsdXGturoF+onxGevq
         qrND1s1W2zbGF+d3C8peX4BTUIOpLJ3peeCFQ6tdytd+M9QurCCDkZdqD5Eo6C2mas3E
         f80nSgh4t8WBfz9i5onBabaBxELvruqIRxzEJFHwm23xsu73ysFr6VdF7AF2QXC612GL
         pYcGy/g6aogXjg1HvWt1Mmxcb/bUaTYTFoxGhHQVDG3v2mejbJGmMdyQ2hwAhu3dUNlq
         /77Q==
X-Forwarded-Encrypted: i=1; AJvYcCX9Vgs39uIDf+P6ny4DUhJ+FZHNT8F6e5qABS2hNPDhAqdy5FhknWCi7gil2XslXnFCpQQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yynncw3RiGxy6vRFo0RzAIAYt6e822jcV7YcLpj+GwnJ29o4ocy
	ZHNSSErUxtjslgTLySzfGlY6Xc/u9OiHclPXVwEa5RceVLl81KuNvEfJwOxC/jk/xkcMG8SB9PO
	hCCL74w==
X-Google-Smtp-Source: AGHT+IEeqQkjGCUvHwE3Zbz/x+1DGgWs82bZUkFVrP+dus815wDSUbemt2s4DNQEDSZu5MKLsihmgTuZoik=
X-Received: from pjbse5.prod.google.com ([2002:a17:90b:5185:b0:33b:51fe:1a88])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f10:b0:31e:cc6b:320f
 with SMTP id 98e67ed59e1d1-33bcf84d70fmr6219197a91.5.1760738219874; Fri, 17
 Oct 2025 14:56:59 -0700 (PDT)
Date: Fri, 17 Oct 2025 14:56:58 -0700
In-Reply-To: <CALMp9eQ3Ff4pYJgwcyzq-Ttw=Se6f+Q3VK06ROg5FCJe+=kAhg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251009223153.3344555-1-jmattson@google.com> <20251009223153.3344555-3-jmattson@google.com>
 <aO1-IV-R6XX7RIlv@google.com> <CALMp9eRQZuDy8-H3b8tbdZVQSznUK9=yhuBV9vBFAQz3UP+iRg@mail.gmail.com>
 <aO6-CbTRPp1ZNIWq@google.com> <CALMp9eRJaO9z=u5y0e+D44_U_FH1ye2s+cHNHmtERxEe+k2Dsw@mail.gmail.com>
 <aO7JjaymjPMBcjrz@google.com> <CALMp9eQ3Ff4pYJgwcyzq-Ttw=Se6f+Q3VK06ROg5FCJe+=kAhg@mail.gmail.com>
Message-ID: <aPK7qvIeSdzxdzMZ@google.com>
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
> On Tue, Oct 14, 2025 at 3:07=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Tue, Oct 14, 2025, Jim Mattson wrote:
> > > On Tue, Oct 14, 2025 at 2:18=E2=80=AFPM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > > >
> > > > On Tue, Oct 14, 2025, Jim Mattson wrote:
> > > > > On Mon, Oct 13, 2025 at 3:33=E2=80=AFPM Sean Christopherson <sean=
jc@google.com> wrote:
> > > > > >
> > > > > > On Thu, Oct 09, 2025, Jim Mattson wrote:
> > > > > > > Clearing EFER.SVME is not architected to set GIF.
> > > > > >
> > > > > > But it's also not architected to leave GIF set when the guest i=
s running, which
> > > > > > was the basic gist of the Fixes commit.  I suspect that forcing=
 GIF=3D1 was
> > > > > > intentional, e.g. so that the guest doesn't end up with GIF=3D0=
 after stuffing the
> > > > > > vCPU into SMM mode, which might actually be invalid.
> > > > > >
> > > > > > I think what we actually want is to to set GIF when force-leavi=
ng nested.  The
> > > > > > only path where it's not obvious that's "safe" is toggling SMM =
in
> > > > > > kvm_vcpu_ioctl_x86_set_vcpu_events().  In every other path, set=
ting GIF is either
> > > > > > correct/desirable, or irrelevant because the caller immediately=
 and unconditionally
> > > > > > sets/clears GIF.
> > > > > >
> > > > > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/neste=
d.c
> > > > > > index a6443feab252..3392c7e22cae 100644
> > > > > > --- a/arch/x86/kvm/svm/nested.c
> > > > > > +++ b/arch/x86/kvm/svm/nested.c
> > > > > > @@ -1367,6 +1367,8 @@ void svm_leave_nested(struct kvm_vcpu *vc=
pu)
> > > > > >                 nested_svm_uninit_mmu_context(vcpu);
> > > > > >                 vmcb_mark_all_dirty(svm->vmcb);
> > > > > >
> > > > > > +               svm_set_gif(svm, true);
> > > > > > +
> > > > > >                 if (kvm_apicv_activated(vcpu->kvm))
> > > > > >                         kvm_make_request(KVM_REQ_APICV_UPDATE, =
vcpu);
> > > > > >         }
> > > > > >
> > > > >
> > > > > This seems dangerously close to KVM making up "hardware" behavior=
, but
> > > > > I'm okay with that if you are.
> > > >
> > > > Regardless of what KVM does, we're defining hardware behavior, i.e.=
 keeping GIF
> > > > unchanged defines behavior just as much as setting GIF.  The only w=
ay to truly
> > > > avoid defining behavior would be to terminate the VM and completely=
 prevent
> > > > userspace from accessing its state.
> > >
> > > This can't be the only instance of "undefined behavior" that KVM deal=
s
> > > with.
> >
> > Oh, for sure.  But unsurprisingly, people only care about cases that ac=
tually
> > matter in practice.  E.g. the other one that comes to mind is SHUTDOWN =
on AMD:
> >
> >         /*
> >          * VMCB is undefined after a SHUTDOWN intercept.  INIT the vCPU=
 to put
> >          * the VMCB in a known good state.  Unfortuately, KVM doesn't h=
ave
> >          * KVM_MP_STATE_SHUTDOWN and can't add it without potentially b=
reaking
> >          * userspace.  At a platform view, INIT is acceptable behavior =
as
> >          * there exist bare metal platforms that automatically INIT the=
 CPU
> >          * in response to shutdown.
> >          *
>=20
> The behavior of SHUTDOWN while GIF=3D=3D0 is clearly architected:
>=20
> "If the processor enters the shutdown state (due to a triple fault for
> instance) while GIF is clear, it can only be restarted by means of a
> RESET."
>=20
> Doesn't setting GIF in svm_leave_nested() violate this specification?

Probably?  But SHUTDOWN also makes the VMCB undefined, so KVM is caught bet=
ween
a rock and a hard place.  And when using vGIF, I don't see how KVM can do t=
he
right thing, because the state of GIF at the time of SHUTDOWN is unknown.

And FWIW, if userspace does RESET the guest (which KVM can't detect with 10=
0%
accuracy), GIF=3D1 on RESET, so it's kinda sorta right :-)

