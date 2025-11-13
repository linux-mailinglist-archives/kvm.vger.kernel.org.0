Return-Path: <kvm+bounces-63012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A587CC57BA2
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 14:40:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 05EE2349376
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 13:37:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33CA5212B31;
	Thu, 13 Nov 2025 13:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T5r1Qgto"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2091C32FF
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 13:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763041023; cv=none; b=LmFyC9ruxkfXfKR0X4J902mql08Md3Wnhj1e4U6ztRqP/tcxrxwYZ9GZFyNHtvJmvipWnG0SDjtQAgzLVPI/VM9lN/yMCWLKvQgh9r0Wot44TPQveKPtH/OtHmgDaGIEEqhmobZvL5o7aHV9v4sFBAfp+ZFqjZbURa8ZjDR46tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763041023; c=relaxed/simple;
	bh=a0fXOPvSK/odPMM+7mQmmudqNo2P8UQWfaofKLWzgAs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sE5pYIXqJx7S9qrK2MNxwrjj5M+kYfsqqsyU9EIvrURzfUgA/biyUCQVyzi7ww6KjPrUTVB+CvamCWgkWypdcDBxq5f9d/HMArAkwlU2pQ3f+4pnAA5xldxPWM685bGCloV0g7Jsfurd/ajUJ6EkwJM5Cwb4YlmX1wYSxpdj5Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T5r1Qgto; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-34374febdefso786778a91.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 05:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763041020; x=1763645820; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QSJ2L4MT2I2gCHEpg9vmTrs2bYH5rDeQpfubY+Hgw5c=;
        b=T5r1Qgtor88LJV3CrH/cKFxoZU35zEZw2QvswMfpf9RaDOE5Bu0vEwGnxePdBr0KJ/
         6bJlB1r/LpM91X/A1YJ6chPcfKibK1wIjZ3/NtrmagmbXCLwUnQNnEmU3ZtFSWw3JWTK
         VsMop/AdYd9ql+clM37Bj3qSzn8y2wDuqyLgtxIAoARDypQ1eYeurwRIbWJDS2jtrc9f
         ISevUWMvlJjXJD9djkVhvEcX0sk7tanK9XBIDu/aDUNakQJ9Iws6y0k0rGVdOOoQ5dGT
         NQ2v+PuG1LAaoOGs0ImGo0hmsG9+NG2bi0nHPGhZRz+I/QHQvMZmpVflfv1sWTDGUCgJ
         QHfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763041020; x=1763645820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QSJ2L4MT2I2gCHEpg9vmTrs2bYH5rDeQpfubY+Hgw5c=;
        b=uIg5JY9B6odwDW7H1nK2xG1r/q3SMqHu8vqh11X1RbrWLxTHBuZWRm+rmMX64ebVG1
         FAQ3HTgXC7+Om6dxtY6Uwr0Q2lZ7ADqHGPdwSQSiPD8gaFI+J+/aWenIerElQrPy6iov
         Aa371/RXbTVndflMOJOSvI2vLUmE2hgAPt+gZZ9ye3D5sIulZRd7I3z4ys5wh/YOBJ9e
         fyiwJyMphP5TlTqydlaqU/pP/jqNjE3By2kXxSn7bPeau8sPamQcbAGDV4Nbv2kPvfuu
         0eYsE6m/CUhx8by1I5Acw6ifOIBHJJA2nCGfi01vUKy3s4zZD6/j9dAkfc6w7EcXXHRP
         EvmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAmnYwUrdFcle2jSHp2dSXGqoXdonHsUh6JabqUIaFvUz+UTI5T0+H8uYjHyARxpfy6aQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDpg8ustOkpbya61VgEMxu3FeDRY+4M99loXvgWIkHJ4q1+sHZ
	RLa2ozzB9oP0Kum5UXGWXL8TmhGRlbev0X5u537Cyd/0vJSwOIo95PBts8LpU5jtWI54TktRGMN
	VpZMM9DBZwVLJi0s6U2TACeCwhW2S9nw/OTPYXZs=
X-Gm-Gg: ASbGnct1JN5ZuLtzXiTwltn8KfQ+Zy1AcJ9C7j1MH3fop7Zx715uTWOqmNFEYmf4aj2
	+toDtAhseGTQL1XQAW3l0AePYA/DCYdYtd+hLs00V5mgWvro78xfqMQ9U2G/4GMlXd6m5CDA+ox
	oS16UBAy5Ppcgk2xMZERqnz8DVolkJfAoICECiedRiXx5uMepG799aYDOgWTsNx92SAPdbVnKZD
	bIQRxgoa9BWcrBEDmpZBJAnw7G0ft3daUI370162nEXNh7SBWfeYYjyguJf
X-Google-Smtp-Source: AGHT+IFMnnQX/hQFlma8t33w+3/sb1UazZlXFWzIBjAqm32zUEfsFdbDtvFTFKlaO1GUq9wj4UcYLSywqtKSaChulzY=
X-Received: by 2002:a17:90b:384c:b0:33b:8ac4:1ac4 with SMTP id
 98e67ed59e1d1-343ddf0cf3fmr8549056a91.35.1763041019969; Thu, 13 Nov 2025
 05:36:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251110033232.12538-1-kernellwp@gmail.com> <20251110033232.12538-3-kernellwp@gmail.com>
 <015bfa4d-d89c-4d4e-be06-d6e46aec28cb@amd.com> <b56f1c06-b935-4018-adb9-3702d8ff57cd@amd.com>
In-Reply-To: <b56f1c06-b935-4018-adb9-3702d8ff57cd@amd.com>
From: Wanpeng Li <kernellwp@gmail.com>
Date: Thu, 13 Nov 2025 21:36:48 +0800
X-Gm-Features: AWmQ_blAqyZ_N_z0MX2ESexsnzeWazvrKVLEJqauvim1Aci9-8mofKdR-zuB1Xc
Message-ID: <CANRm+CzOPieLG6bg=2XJ3jkEw268ua4DFZyubL5jT6Pu7nfk7A@mail.gmail.com>
Subject: Re: [PATCH 02/10] sched/fair: Add rate-limiting and validation helpers
To: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Juri Lelli <juri.lelli@redhat.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Prateek=EF=BC=8C

On Wed, 12 Nov 2025 at 14:44, K Prateek Nayak <kprateek.nayak@amd.com> wrot=
e:
>
> On 11/12/2025 12:10 PM, K Prateek Nayak wrote:
> >> +    if (task_rq(p_yielding) !=3D rq || task_rq(p_target) !=3D rq)
> >
> > yield_to() has already checked for this under double_rq_lock()
> > so this too should be unnecessary.
>
> nvm! We only check if the task_rq(p_target) is stable under the
> rq_lock or not. Just checking "task_rq(p_target) !=3D rq" should
> be sufficient here.

You're right! Since yield_to() passes rq =3D this_rq() , the yielding
task is guaranteed on rq . But p_target may be on a different CPU
(yield_to supports cross-CPU). Our deboost only works for same-rq
tasks, so checking only task_rq(p_target) !=3D rq is sufficient. I'll
remove the redundant task_rq(p_yielding) !=3D rq check. Thanks!

Regards,
Wanpeng

