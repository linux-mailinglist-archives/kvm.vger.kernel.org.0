Return-Path: <kvm+bounces-35841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7794EA155A0
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 18:22:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87C41188D43F
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66AF11A0BCF;
	Fri, 17 Jan 2025 17:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bV8/BurP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EE419E979
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 17:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737134546; cv=none; b=P652Fp6vKXvrZ2mViEZ06lKG4MAM/dewuQ+RcYD+tijEjZSnWHIYz3ssX7/pIYYEaMOtA/u4/Mk1EEQQMwqLxU+X83FWy5hxnF8avI4yIIyIz/QcbB9O1CbaCxlV29jJUhZ/iQCTEOekt9ZwFGuyoudHiGoPsNsh/W7/BJREMUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737134546; c=relaxed/simple;
	bh=ko9hCfsTSFb2WHMPF+cKB91E3qzU/D2w3rNbjhFfpKM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CjKIsm31JHA31/xJAPbL+Cm1yBfnbCY8V1Qg2LhirHOQlzuR6W/NU03wf/5Rjz7+Nm9P7mcHSnHCAXQ82XTgSwJoSaWMPXIDyeUILHvMth2wWxrUQmyUoxMlOvOnZa4WQdp9/6AQBRG4XneUWbA3gtWDXQxXt1veBxmJZdseJNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bV8/BurP; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef909597d9so6490713a91.3
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 09:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737134544; x=1737739344; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y5yk6XYlrmxggOwgGYss86c4m0CiH1dj4p5ycYrzVkE=;
        b=bV8/BurPZrCL3AWjCubHzQP1njEqjENqILQeP3qlZal4+FZzVzv5zLzeTvOs/RHmN6
         mJX18+00FCTs/l3P43/JtBjsak6/ngaABFz/pqtWnsjsO/oFF3t/esliUv3XzLY9IHNZ
         +EGagopIjg7sbqs7/nzF7q4izAabMNc9Ve55tYs0qT3sW21x+tsEMnGPDEEVfKCGGz9h
         cE04v+wN8xXqBMHi9oZ9fAaXE9p8ThRPR4lJ5tjCTTtFabm3JqSz2PhRGn22UF26ttz+
         mxg4XN4wCcJ+RU3H5zCKf3a02zo/Ae7T3+15xswzRmQZaFdL2x2vrEkGHfu20xBpv7Wi
         BxCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737134544; x=1737739344;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=y5yk6XYlrmxggOwgGYss86c4m0CiH1dj4p5ycYrzVkE=;
        b=eKBaiSbEHe8eI1ev/A6Uvz01pVnTv6zqwgeWtnCLB3GoTl7cBb26T2V1j+wEXwSd4h
         I5pbczt1yhJIEpOG/vw3uRQMxLsOLyHqdfVwooY8Nh06LRraPpuFnXwBVKf++lXU0g8Y
         n2oelXt8sIl7QpTIsqqaW2UggAcT/z/tpzgl0kClJLoW/e47RDvJGpKmlDHAhAJHgkVJ
         JTIFjRz6KYgxjK98873e+XPYMD70lwwStjaAGT/yJYwsnD4AwtRNoZOicqEv5Ge2yaCf
         pTxsBcHNN2L9CSzk9R4j/TMYWh4q1gQFHMRUasHZ3cmM1H669xF4bs8roweyRtk33ztm
         UqzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUh8gVHJk6iaUiSuIVbvWKT8Y2/fr7te/hNnVutZ8dLVtQ4ZLHGsU6Pv4BoXpYk1b7vuC0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyc8gRXLcNL5USy+ymK9+JmP9ZIyq91BWVIDvCR48UnxkL3rxxm
	h4OJLqXT8ez0NDrewxRWsIyMQ168mY9pVpOQ4Fu+A6AL0vBoE5IN0HeS98kOaNREZLPZEjQREd4
	XDA==
X-Google-Smtp-Source: AGHT+IEj4uiPctq7slvj0cP2L7ciHNWjI6UojppWmGeB2efD/NJZSfjTA0khj4pTOu7zfYI+CZA6d69DOVM=
X-Received: from pjuw16.prod.google.com ([2002:a17:90a:d610:b0:2ef:eb2f:ebe])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f50:b0:2ee:fdf3:38ea
 with SMTP id 98e67ed59e1d1-2f782d32c45mr4116213a91.23.1737134544351; Fri, 17
 Jan 2025 09:22:24 -0800 (PST)
Date: Fri, 17 Jan 2025 09:22:22 -0800
In-Reply-To: <CAFtZq1F1x5+pXjgUvy=iDMZgY2mPyW+Rq6DKtfD+Msw=-nBaZw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAFtZq1FwJOtxmbf_NPgYP_ZH=PkXJfF0=cXo0xbGkT5TGv66-A@mail.gmail.com>
 <CAHk-=whnVemumt5AJ1f=rsGdLz4Fk95nZfoBchGmMWCGG63foQ@mail.gmail.com>
 <CAFtZq1FpLfbnJzqc_s=j9TBLyGxe9D_ZYZU2qiES5dgsBAWv+g@mail.gmail.com>
 <2025011646-chariot-revision-5753@gregkh> <E5C85B8E-D8F8-408F-B00B-A3650C9320EA@gmail.com>
 <Z4kkuaY_mJ6z0sa2@google.com> <CAFtZq1F1x5+pXjgUvy=iDMZgY2mPyW+Rq6DKtfD+Msw=-nBaZw@mail.gmail.com>
Message-ID: <Z4qRzuL3cDbzVTUS@google.com>
Subject: Re: Potential Denial-of-Service Vulnerability in KVM When Emulating
 'hlt' Instruction in L2 Guests
From: Sean Christopherson <seanjc@google.com>
To: C CHI <chichen241@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Dropping Non-KVM folks/lists.

On Fri, Jan 17, 2025, C CHI wrote:
> I roughly understand the above content.

Heh, you top posted, so it's below.

https://people.kernel.org/tglx/notes-about-netiquette

> The main reason for this phenomenon seems to be the chaotic VM memory lay=
out
> caused by the syzkaller template settings. In fact, it=E2=80=99s even obs=
ervable that
> the IDT region in the code doesn=E2=80=99t actually contain any exception=
 handling
> code, very amusing :)
>=20
> Additionally, I would like to ask about the previously mentioned point
> where the IDT is set in the emulated MMIO space. How can I verify
> this, and where can I find the relevant code for setting the MMIO
> region?

In KVM, any guest address that isn't covered by a memslot, a.k.a. a user me=
mory
region, is treated as emulated MMIO.

>     The guest loops because the the guest's IDT is located in emulated
> MMIO space,
>     and as suspected above, KVM refuses to emulates HLT for L2.
>=20
>=20
> Also, I'm curious as to what technique is used to get the following
> type of logging information, and I'd like to be able to get each ENTRY
> and EXIT info on the run

The below comes from KVM's tracepoints.  E.g. if tracefs is mounted at
/sys/kernel/debug/trace, all KVM tracepoints can be enabled via:

  /sys/kernel/debug/tracing/events/kvm/enable

See Documentation/trace/tracepoints.rst for details on using tracepoints (o=
r the
same info in the web version https://docs.kernel.org/trace/tracepoints.html=
).

