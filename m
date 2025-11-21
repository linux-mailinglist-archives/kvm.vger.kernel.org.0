Return-Path: <kvm+bounces-64107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 43093C78E6A
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 12:49:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C4BF64E9816
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 11:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55DA22FF17D;
	Fri, 21 Nov 2025 11:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DPkiuCMi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714783081B9
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 11:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763725579; cv=none; b=kteYjYSOhBmQobGc3sEfFtGRc4we+DCx/7Jw00SGHnTPlGY20lQffgkaOxyPpsOQu0xh4DeW4VG0prqtzdaFIw3/uzBrPLJv0povJ6yRH0AR74egiRsWMCkF8NrJPrh+niojiZObW1mxeoz0kSS0Zcjpqq1YgtuuaE/wIb2p9Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763725579; c=relaxed/simple;
	bh=3qaVjGsnlQhpFQQRtILh7H3V4a7Yra2/+xzfnkZV40c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IwZexuK0ZE4uej+dlvGvMDytMv3wcgZsDEKlDi7RQgZ1YaLacVx0/x0/09E9vh8EUUoChl4HlnMEgz40GwqJvs8uNkHn9mL9EjTMW+pgH/JlLSQewp2itF1dzlIQ8NWXdYgkW8FGglGQLKpYIjKYsNlRYRn43viAu+aIddafebE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DPkiuCMi; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-297e264528aso22372195ad.2
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 03:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763725574; x=1764330374; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kjDqVqTwk2r7eCk0rkCo36KA72Rh6D0VMi7VIxvc9+Q=;
        b=DPkiuCMiReIFbCY6uPrj5M1BcUFNRKlQhb4fnH/DXehql5G0PoQmIYiuvw/21ukLpX
         V27IbaD8OeKXuu0S2XpbydHggdrsZfPmXbHEvKtzqpLUqHnYBFii4B3UgTaCuXNyIrD0
         SOxXy+s7wP1a5WYcSCjokejqmTotvO/Iyg3bhrC6SsQsJ3zljx/fGTpgQdKoXglnmBos
         mqZd4DblV4J8gWZG54ENoJs0EY5J8wBmd0W8dl6WIYrqrz54Fp48kjAsSUCg8cq+njc/
         B0WgQQwtUyIYGGViZOS9Px/Wsjnp+Vb9EhJnqDGz97iLyfS3hLUbLE+uaTvLOpzq96Qj
         Kruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763725574; x=1764330374;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kjDqVqTwk2r7eCk0rkCo36KA72Rh6D0VMi7VIxvc9+Q=;
        b=aeZcUUMm8duVdCfEHywStzFpYkppdtuTpqIE1xJ/ssZWAhI9GsKFI8wxx7e+2cbdNf
         opHPAqks5ylDjIz/PhCepbOa+lrLMfz4QxZSIPU7B+QRYln2imPYnmgdnCZvv4liCyZA
         fU948WZuTyKhCFUBki8KvMIAtXJpHlrbBXNO7gCfL4VNw/RvIeaLk8sP1OUhM/ShNiN5
         ymG5Y7S+0ndMKsYjKqx+J1z/XUBAXsJPrJsDnCBGQIYS2OR7hrSqAwV5raq88+dZO8Ds
         YYdKTaA63sxFb9MUu2NqTlf1vL1SZvqCuATMdk8AMMpBB4cxw3dQRMoQzs4/FIDTsIOl
         vAJA==
X-Forwarded-Encrypted: i=1; AJvYcCVz+83c7BqgFGmxWjnuRI51/jnadrLfV1w5DdrYNAgLjnDWxe2RGOvVbwvrI1qIRqGSozM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+oamX9DLnuq29d/lfDtJh9jTAdD7xwifFTx5eVXygY+Ygxg2x
	IRkKGdANt4MCHR+qy1xZqFR2kUgf5wAiCmpOBOK2mrD9nqdwhpHnxCexwPc2rMKKxTcPY8aQmzr
	ZbUdzDrU1K3Po/yHvH8osITsm+vO4XWzgGjeR9qM=
X-Gm-Gg: ASbGncv1hxC0kA5yH5giLIFVj0AJO37bg42vJR/Zqofo0Yu51AHY1vqW0TAelxFFhv6
	UEoYLXZb5JtYj0owbZ2kqB+ymsNXNSO6Lr5g1Gf6L0rfuA3AeGMY3kj/OALgSL0/WXzx2BNwSMU
	puojOR0+BWYVRpgrwxdjzJl58ybGRwziJuSiBfV1q/TD/DXWqxTVNcSH8laAvOt4Sh2buxcEH+I
	Dx7W/k20UozKRf73vpmNdSC6KuOhiiH99ehLtut9SMdd5O6JAvHq2Gx0mUZpEHDOXW4zaMuwLsG
	Y4fing==
X-Google-Smtp-Source: AGHT+IFoPzb2SVgD/COpL5gB8aUWLH4DdvUJvdFg7BI8VeTFdNlaAp3NjbwbrdW76PbuGe3pGc7DTztobcF5u5R7KYk=
X-Received: by 2002:a17:90b:4c0f:b0:32e:9da9:3e60 with SMTP id
 98e67ed59e1d1-34733f54393mr2514481a91.36.1763725573765; Fri, 21 Nov 2025
 03:46:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251110033232.12538-1-kernellwp@gmail.com> <20251110033232.12538-7-kernellwp@gmail.com>
 <aR-zxrYATZ4rZZjn@google.com>
In-Reply-To: <aR-zxrYATZ4rZZjn@google.com>
From: Wanpeng Li <kernellwp@gmail.com>
Date: Fri, 21 Nov 2025 19:46:01 +0800
X-Gm-Features: AWmQ_bm4pfGHBHiBWWyTyY6CMI9qnOJ05t-mI5pRzvSHayhT4G9zIxDnstGvDUY
Message-ID: <CANRm+CwaMf64=vAaFdr0hJabtV0CALNBKJgrkooiYQPVuv2UGw@mail.gmail.com>
Subject: Re: [PATCH 06/10] KVM: Fix last_boosted_vcpu index assignment bug
To: Sean Christopherson <seanjc@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Paolo Bonzini <pbonzini@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Juri Lelli <juri.lelli@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Nov 2025 at 08:35, Sean Christopherson <seanjc@google.com> wrote=
:
>
> On Mon, Nov 10, 2025, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > From: Wanpeng Li <wanpengli@tencent.com>
>
> Something might be off in your email scripts.  Speaking of email, mostly =
as an
> FYI, your @tencent email was bouncing as of last year, and prompted commi=
t
> b018589013d6 ("MAINTAINERS: Drop Wanpeng Li as a Reviewer for KVM Paravir=
t support").

Hi Paolo and Sean,

Regarding commit b018589013d6 =E2=80=94 I'm back to active KVM development =
and
ready to resume reviewing. Please update my entry to Wanpeng Li
<kernellwp@gmail.com>. My recent patch series reflects the level of
engagement you can expect going forward.

>
> > In kvm_vcpu_on_spin(), the loop counter 'i' is incorrectly written to
> > last_boosted_vcpu instead of the actual vCPU index 'idx'. This causes
> > last_boosted_vcpu to store the loop iteration count rather than the
> > vCPU index, leading to incorrect round-robin behavior in subsequent
> > directed yield operations.
> >
> > Fix this by using 'idx' instead of 'i' in the assignment.
>
> Fixes: 7e513617da71 ("KVM: Rework core loop of kvm_vcpu_on_spin() to use =
a single for-loop")
> Cc: stable@vger.kernel.org
> Reviewed-by: Sean Christopherson <seanjc@google.com>
>
> Please, please don't bury fixes like this in a large-ish series, especial=
ly in a
> series that's going to be quite contentious and thus likely to linger on-=
list for
> quite some time.  It's pretty much dumb luck on my end that I saw this.

Good point about fixed visibility =E2=80=94 it makes sense to keep them sep=
arate.

>
> That said, thank you for fixing my goof :-)

:)

Regards,
Wanpeng

