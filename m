Return-Path: <kvm+bounces-17894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A8458CB6C1
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 02:29:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C57A9287588
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 00:29:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CD0C2594;
	Wed, 22 May 2024 00:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4mOiNu4K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2427DA50
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 00:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716337767; cv=none; b=Xv63WlYvclYtmlntPfY6fccaQFn7VS5KLaz8fA9lJ521F1vSLrj+0XIXz5zTPpy39P53pMV40MpPN6CL0nJgdTRx+LKwQ6p8S9CtkOgtNMzEg6wAMW1HJsMAec5QQzsbJ8aYeHrekKWejNlHTpHuO1DPvh8ULwpZ2jlNQIDkQIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716337767; c=relaxed/simple;
	bh=065QhzrCX5JnH9ZKTv2IFHSh5FtfZPJhHSRgyW+FA9U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AKe//4lGAbgompDgh/eTRCLHGqPWpurXcskeELsn/Vu/XByui90fxV9tj124qNX2YnWytI3NvoOi7V3EWXtGoLTk84bpKcjADKm/K9/jZjbxm7srNjBDlKuq1gR49MZNMUZIwD/uZz7w4fXsuxTwg/Av3af0XE5kPd+Nd+JgLRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4mOiNu4K; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61c9e36888bso235370817b3.2
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 17:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716337765; x=1716942565; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bsmUPMzcjEYNnjrV6jC+TNo24OkPNWzkgU8xknZy10s=;
        b=4mOiNu4Kqjfq2oql5wAyt2FDB5CNt9/bKO6987/RdVX7wHqcXDc3kUmEv0AooIqrbd
         0I/kArKwOC2tSUfMBAH3JYuZX+WGIo9aPlohw4weFlbQIztOF1A0rRaWg1aUyLzwj6f5
         k0bZm7nqmkMoMVdnKBBQm+PviYe7HTNlfYyZfWHBzzJ/yeS07ZquiFJVj0ZwIE2kPeko
         DPaCJWtxD4UWcpzO1Yy6VdMM+jSKMnHg+37aHOJYTaTNBkNjg+mXy+loKfmMAV3I8azp
         hq9QoqgO+5aEnBQl2JsLb5MlB3AZIejv3O1ppz5WA0aRUc27kVSOrmPzHzndWZNS/4gm
         Awxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716337765; x=1716942565;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bsmUPMzcjEYNnjrV6jC+TNo24OkPNWzkgU8xknZy10s=;
        b=ePCcnVz6Mfid8mHaP7j0ZoKE1cvDmTiv9C98RvZ7Xxfn+LgR4pRGUphATfq8TUhJGE
         UbxkoJLfFxOZp2JN5mCSABN52a/7Ua/QZ2Kf7PWBPWBPBf2LIoW8FYudsD1TbDjEz9wy
         CEfZAaRELTYZnEQFz7KGLyOV0TDwI/4Bkme/5eJlwRYMBjkGRTnoH+FA3m1NGT8qujzZ
         dIzOgs7AwFbNOuCIpbT5III1Sz68T2VLORje20XGkXiYRFlTCAsZF1+znYQQdh7QNn8f
         9u87advK+Zoy8n9LHIir2ezW5zyyZCuk50ADNEDRw21HmGngOWlJLh4L52eQfNxawco/
         VwdA==
X-Gm-Message-State: AOJu0YyqZtjrVc0unXIXAP/IaPMjocslpvMt9F1gemogJ9nDD0UrEsDu
	bMYtsWP1hGUU02OFQzNIa7ForcdPuR39ZjoYQxYckEX0erekmD9J7qOoR8djhRq60COS2TV1mLz
	saQ==
X-Google-Smtp-Source: AGHT+IEZipaeLScBQ/yOVEF8019w+MhUQ4ANsEg/GlvCWrMAuAj/zYEgGqBNu9cWSRQU67UME9vy9poNbb8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:cad6:0:b0:61a:dcd0:5a61 with SMTP id
 00721157ae682-627e48a40camr1499797b3.7.1716337765200; Tue, 21 May 2024
 17:29:25 -0700 (PDT)
Date: Tue, 21 May 2024 17:29:23 -0700
In-Reply-To: <CABgObfaE+M5QuTfAZ01OjeB87vGmjRgDUH=rnNX8FHzc7t1Oag@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240518000430.1118488-1-seanjc@google.com> <20240518000430.1118488-10-seanjc@google.com>
 <CABgObfYo3jR7b4ZkkuwKWbon-xAAn+Lvfux7ifQUXpDWJds1hg@mail.gmail.com>
 <ZkzldN0SwEhstwEB@google.com> <CABgObfaE+M5QuTfAZ01OjeB87vGmjRgDUH=rnNX8FHzc7t1Oag@mail.gmail.com>
Message-ID: <Zk08Yx-GCBqsIMcL@google.com>
Subject: Re: [PATCH 9/9] KVM: x86: Disable KVM_INTEL_PROVE_VE by default
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 21, 2024, Paolo Bonzini wrote:
> On Tue, May 21, 2024 at 8:18=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > > -          This should never be enabled in a production environment.
> > > +          Note that #VE trapping appears to be buggy on some CPUs.
> >
> > I see where you're coming from, but I don't think "trapping" is much be=
tter,
> > e.g. it suggests there's something broken with the interception of #VEs=
.  Ah,
> > the entire help text is weird.
>=20
> Yeah, I didn't want to say #VE is broken altogether -

Ah, yeah, good call.  The #VE isn't broken per se, just spurious/unexpected=
.

> interception is where we saw issues,

It's not an issue with interception, disabling #VE intercepts results in th=
e #VE
being delivered to the guest.

Test suite: ept_access_test_not_present
PTE[4] @ 109fff8 =3D 9fed0007
PTE[3] @ 9fed0ff0 =3D 9fed1007
PTE[2] @ 9fed1000 =3D 9fed2007
VA PTE @ 9fed2000 =3D 8000000007
Created EPT @ 9feca008 =3D 11d2007
Created EPT @ 11d2000 =3D 11d3007
Created EPT @ 11d3000 =3D 11d4007
L1 hva =3D 40000000, hpa =3D 40000000, L2 gva =3D ffffffff80000000, gpa =3D=
 8000000000
Unhandled exception 8 #DF at ip 0000000000410d39
error_code=3D0000      rflags=3D00010097      cs=3D00000008
rax=3Dffffffff80000000 rcx=3D0000000000000000 rdx=3D0000000000000000 rbx=3D=
0000000000000000
rbp=3D000000009fec6fe0 rsi=3D0000000000000000 rdi=3D0000000000000000
 r8=3D0000000000000000  r9=3D0000000000000000 r10=3D0000000000000000 r11=3D=
0000000000000000
r12=3Dffffffff80000008 r13=3D0000000000000000 r14=3D0000000000000000 r15=3D=
0000000000000000
cr0=3D0000000080010031 cr2=3D0000000000000000 cr3=3D000000000109f000 cr4=3D=
0000000000002020
cr8=3D0000000000000000
	STACK: @410d39 40144a 4002dd

> and #VE is used in production as far as I know (not just by TDX; at least=
 Xen
> and maybe Hyper-V use it for anti-malware purposes?).

Hmm, maybe a spurious #VE is benign?  Or it really is limited to A/D bits b=
eing
disabled?  Not that us speculating is going to change anything :-)

> Maybe "Note: there appear to be bugs in some CPUs that will trigger
> the WARN, in particular with eptad=3D0 and/or nested virtualization"
> covers all bases.

Works for me.  Maybe tweak it slightly to explain why the WARN is triggered=
?

  Note, some CPUs appear to generate spurious EPT Violations #VEs that trig=
ger
  KVM's WARN, in particular with eptad=3D0 and/or nested virtualization.

