Return-Path: <kvm+bounces-42771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11800A7C6CC
	for <lists+kvm@lfdr.de>; Sat,  5 Apr 2025 02:01:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F71A3B7A72
	for <lists+kvm@lfdr.de>; Sat,  5 Apr 2025 00:01:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30A9B3FC3;
	Sat,  5 Apr 2025 00:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iZcV3Yw+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1291A32
	for <kvm@vger.kernel.org>; Sat,  5 Apr 2025 00:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743811297; cv=none; b=k8D8yehpsOmHTi//IIoX25USdQPgZEv1WFUDu+6lnYMmWn+AWJJK8CXxtypNEeDagtEHzD1ays5s2pzODiU9SDiJm8SsgTtFuB6ZRrxVmfM3cmCgJdTffvNIqht/n+ekd9YKGZTmtErutodtd00g5xzK8F+h+dF91TR5nAlbIcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743811297; c=relaxed/simple;
	bh=bs9njDxfO/UPuD4IumQI6a3fniuB7rskHCC70+8QjJ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tbuEvkRX+eBF2XGzs4a2J6logx8nVcGG5jTdeP78SkDBg+J9YrQZ30ofLjUGyVIzMCrDqeUBsgK2pRjIowOyfUwSHMUKXToZ8+Yy0FcF8PmM9FvCwEB2rd+i2Oi/dmJTz9GPM7YHuifnAMrSyTLox5m0z5OdKvuQ5TuWxMVsSck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iZcV3Yw+; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-47666573242so163771cf.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 17:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743811294; x=1744416094; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bs9njDxfO/UPuD4IumQI6a3fniuB7rskHCC70+8QjJ8=;
        b=iZcV3Yw+X6DIAXnoGjQv9dC3QqpKQetBrP5i6Od8VoBNlUyHdV1iuGLpZ6E/xW4ofK
         JOkhb4uo18RohqPlN+J+Y7XpXYUeESUvhLCDui9rqZ7N2s0xhCb5KpMzTewpbEsVou16
         wRPKiNjXl/vVkjtGr3ecLRzR3IoD8H1oDVVeT7dJgO65sfX/wLRC6t9PP6nfJKvL5mvI
         BAgXEA7e7tqhGdTyLZ7ugZBfDw88ZhLsPPRCvqUbvIz894WzmEpgaJ0s2zurMxhG6ab3
         28MS1s20y0GswpzreVsu9Bm8WTGhjyeO0xd6h2V6ud03/a7O/HdkSz0jpDjl4luowREJ
         IE0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743811294; x=1744416094;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bs9njDxfO/UPuD4IumQI6a3fniuB7rskHCC70+8QjJ8=;
        b=dP/AEvh+qHtNzF6iYOkvgJARmX+whevdydXLe46Vi1vcHD7ft9zefvY0oq517feOgv
         RE7hqRP8WHal5A6zOAXMGehag3id6hGxIwlwG7UO7cX3WVUvt/bGr0y92pj9I4+gBn55
         e3rTWzD+kxDTmgFIZfFqUYTK0D0jbcagw7nKZTN85Mbt1R+fUzLuAr98GcHT2G88QKaz
         MMdxm0gipDpQhvrfAaH1h8KLcnRk9M5kJrTbu7q3JxscWbJIL/LQXG2vCWN2zRLO4edc
         0sVdXa0bOH+vzjlb3mqSPyYUEoE4LEQQsPF82HQ6OefmuGjj23S7FBJIDUHqOy5eZRkB
         eXmg==
X-Forwarded-Encrypted: i=1; AJvYcCVu/EBmQwi8AYDGPznVuEuN7fxnYVXmAn93BkBUd4Sf51X0zNPYuZpDAChAEKNmqi6Fg9w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAlNjJbeZ+Sjrfm9SfYBMETa4CyYXunkpvl0geCxrVb9OtPiy/
	QfbQG8yE8hn25a+zUjI6tBV6Dpl5Mz9x6+CB73XG5BezOY8UklFfvS6cahht3Tlc+smdUM/9huG
	Z6iF1KDL3xJORQtnxlEtufUI2Of0xQVPA8uXB
X-Gm-Gg: ASbGncsiUE2vhf+9iq5CKbyZhMWRiCKYA5IM5sqhkT0Q9tSmrpNUQEgUajqt4V66Qar
	IlxYBE4b+jERnSq6OnzCAQ0ut0x4pgkW5tfh6dlteSKjZxMz7/02iaD8A6PsT1Te1ArD1rJEVvc
	jfuOt/216jMGJIcDJI0I/4LsZaGQqBnQyJ9xCTIn1FfwSmduHE1ZKEg7UJxYM=
X-Google-Smtp-Source: AGHT+IG31MySeEuDpRESn7yDe70KztZLDYHNiWJTHLqTScxeoaWWTA9NWscHpg9wUOdriSga5X/vaYScrXoyeoYYsl4=
X-Received: by 2002:ac8:7e82:0:b0:467:8416:d99e with SMTP id
 d75a77b69052e-479333a2c5bmr745071cf.21.1743811294445; Fri, 04 Apr 2025
 17:01:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250404220659.1312465-1-rananta@google.com> <20250404220659.1312465-3-rananta@google.com>
 <Z_BksUn4JiPPGc4G@linux.dev>
In-Reply-To: <Z_BksUn4JiPPGc4G@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Fri, 4 Apr 2025 17:01:23 -0700
X-Gm-Features: AQ5f1Jq0s70hCQMi54jnhNNYSQm6SIED-nce3BxiWWVuRKa9bdstap1Vc309pC4
Message-ID: <CAJHc60y6pTCS+4qtQmT0ttMK1ZOH36tCXpU+yc2DytgKc=AiPQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: selftests: arm64: Explicitly set the page attrs
 to Inner-Shareable
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver


On Fri, Apr 4, 2025 at 4:01=E2=80=AFPM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> On Fri, Apr 04, 2025 at 10:06:59PM +0000, Raghavendra Rao Ananta wrote:
> > Atomic instructions such as 'ldset' over (global) variables in the gues=
t
> > is observed to cause an EL1 data abort with FSC 0x35 (IMPLEMENTATION
> > DEFINED fault (Unsupported Exclusive or Atomic access)). The observatio=
n
> > was particularly apparent on Neoverse-N3.
> >
> > According to DDI0487L.a C3.2.6 (Single-copy atomic 64-byte load/store),
> > it is implementation defined that a data abort with the mentioned FSC
> > is reported for the first stage of translation that provides an
> > inappropriate memory type. It's likely that the same rule also applies
> > to memory attribute mismatch. When the guest loads the memory location =
of
> > the variable that was already cached during the host userspace's copyin=
g
> > of the ELF into the memory, the core is likely running into a mismatch
> > of memory attrs that's checked in stage-1 itself, and thus causing the
> > abort in EL1.
>
> Sorry, my index of the ARM ARM was trashed when we were discussing this
> before.
>
> DDI0487L.a B2.2.6 describes the exact situation you encountered, where
> atomics are only guaranteed to work on Inner/Outer Shareable MT_NORMAL
> memory.
>
> What's a bit more explicit for other memory attribute aborts (like the
> one you've cited) is whether or not the implementation can generate the
> abort solely on the stage-1 attributes vs. the combined stage-1/stage-2
> attributes at the end of translation.
>
> Either way, let's correct the citation to point at the right section.
>
Ah yes, DDI0487L.a B2.2.6 seems to be very close. OTOH DDI0487L.a
C3.2.6 explains why we see an abort in EL1. I can cite both to get a
full picture.

Thank you.
Raghavendra

> Thanks,
> Oliver

