Return-Path: <kvm+bounces-36306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90F5EA19BAB
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 01:06:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE2F916BA2D
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 00:06:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 122B22F2E;
	Thu, 23 Jan 2025 00:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eCcTMJpb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97FE19A
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 00:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737590787; cv=none; b=Z+rYfrjki2UpyOa/2oKr7aBv9nrBbtJ1qL/QIy8sOFWoxoZv8Mq+DtdVn03mgVYwXhdYf0XgN+10xkcDXlFnt02u/ADdQfliJ+l7HVxTTiieykVDH9TMQserDh+5anE4DULk4IkQCS8JdD71RjdULzC7CcEIoj8/huAJGzzSYj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737590787; c=relaxed/simple;
	bh=fqXnccqr7GzHnLxN6xF5o2ME1Z6XheZ2oJuSWg5x4kU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i6GGa54+Q0eTLYLQyK4ILi7ZVmV0NKMVZ63wk7JL0QkU4MXIHEGXnj0qXaGxKMJRa+C0rQe4/9mSQkQyXenW+3SdVLY0GU70AL+56bEAfwkOZP8RN6ekx6bTL3xnV8H1pxsfacncGFqbCtB3TS6YP47FikwT0RZcDmypCIPwfkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eCcTMJpb; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-518a52c8b5aso118062e0c.2
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 16:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737590784; x=1738195584; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pzHUXqUuWMaVGfa2BESSpjROuA5tmiqr7BCdFSc8OZI=;
        b=eCcTMJpb2P60KSLYwlQP5baJXsrkf1PAL0k3GhFg9KbNzEIKAxflNVHfigBdAMyXB5
         YJ4tulB62BEJSMIbQ+mPLnV2RwisiyUjy/VcFbyg+Bdg0shvyoRr3CIVlkMxVji+DpjY
         OJUnFmEZgDm+sB8b3OfO09PaVDsncWwNfdIgZQdr8LQT3qRtCnLRCJT7WiI1QqObE34i
         oyxPvGzTcFBjcQmOK+SBJSBGutUN0FttsE2GkqSGRKOwdMfNTgIoUvScBxlMa/VuimAs
         CznIg0P3V8ABCK58bDftxmqJtPw6qz7sNIqwWn7k7XcxoSMbKvn8hF1teJAw+jgXNXE5
         3vwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737590784; x=1738195584;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pzHUXqUuWMaVGfa2BESSpjROuA5tmiqr7BCdFSc8OZI=;
        b=SGhyVuPEzlsvk++jlN+pGff13cIFLjzC6C9NYG92v+G2bqvNu7XLxGAPIcGLnAlakI
         xG2r+OO/GLmcpkJgWnAKa+Yxntvy2us7QksPzCBsaJ6vWE5luiLhqeivrgetEjpMSLbv
         8A6TcC49+408LaE9BcOjfmRdTIwGb8OnvKE9hKz+vv2AioOZ2du/G30WuqPj9gwH1TH3
         0c3eyx2XyfFzHc+fyHWfVu9XA7HC8uAYcGnz0hBOPkDSRtZBr2t0pgCOaPpRnq+MyhIX
         sStdqP/oQ8JzIm8K/pkx3jwcz+Uu46z1+nl9NMNOr1amVkZZQ3U04n8wp+HhTJX1eZ4J
         j/RA==
X-Forwarded-Encrypted: i=1; AJvYcCUS3CV5IKDW0m2tjBnSBV3sJQH8dOxf0dRqui6VO/RJ4zfnZ1gkFtvoqA+73rmDxvesw1I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaakBfxaJikPMVRvGOESihHgFDk0FdDMqZwyFB9yslpaZXD1RH
	/9OnDxxdcNNFciBb10mIKa6gofNPCU691KaCu/jUEX78k4oYInVgh97r624KBdnfL0leHRzKdJQ
	8vvEuS5wIp+dTZOF5YWWHwGOZ2a900Z1ydQse
X-Gm-Gg: ASbGncsAX8Vx2LESFeRTyPgx4TgXpm3Oiav8IWBxeiEiEfCD9SdqjMk6ZPoHXk0vVbD
	114nkkQwHQWrZXnFHBz0amBYFFTaW1nqPyPpRFg7Szl2M1w/5z0smskbFgnJ5m7TWqvS61/XlIA
	tDx7Qdi5nS
X-Google-Smtp-Source: AGHT+IFeBvwA2PTNCZbfLnBUtTDSyBKDGYPFY9qg/nuZEafFZ3RHrWZAKwMPNZoXOuYqJP03796FrUGA2WNpCpfnkps=
X-Received: by 2002:a05:6122:2396:b0:518:78c7:9b4f with SMTP id
 71dfb90a1353d-51d59d54caamr20153139e0c.3.1737590784280; Wed, 22 Jan 2025
 16:06:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250122001329.647970-1-kevinloughlin@google.com>
 <20250122013438.731416-1-kevinloughlin@google.com> <20250122013438.731416-2-kevinloughlin@google.com>
 <aomvugehkmfj6oi7bwmtiqfbdyet7zyd2llri3c5rgcmgqjkfz@tslxstgihjb5>
 <d2dce9d8-b79e-7d83-15a5-68889b140229@amd.com> <f98160b0-4f8b-41ab-b555-8e9de83c8552@intel.com>
In-Reply-To: <f98160b0-4f8b-41ab-b555-8e9de83c8552@intel.com>
From: Kevin Loughlin <kevinloughlin@google.com>
Date: Wed, 22 Jan 2025 16:06:13 -0800
X-Gm-Features: AWEUYZkpx3jj1dof8y_DjobooWZnZFZSw3JU3LrASrA1b2rSvYRdGfyN8X1nkaU
Message-ID: <CAGdbjm+syon_W0W_oEiDJBKu4s5q9JS9cKyPmPoqDAzeyMJf3Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] x86, lib: Add WBNOINVD helper functions
To: Dave Hansen <dave.hansen@intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, seanjc@google.com, 
	pbonzini@redhat.com, kai.huang@intel.com, ubizjak@gmail.com, jgross@suse.com, 
	kvm@vger.kernel.org, pgonda@google.com, sidtelang@google.com, 
	mizhang@google.com, rientjes@google.com, manalinandan@google.com, 
	szy0127@sjtu.edu.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 22, 2025 at 3:16=E2=80=AFPM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 1/22/25 11:39, Tom Lendacky wrote:
> >> I think you need to do something like.
> >>
> >>      alternative("wbinvd", ".byte 0xf3; wbinvd", X86_FEATURE_WBNOINVD)=
;
> > I think "rep; wbinvd" would work as well.
>
> I don't want to bike shed this too much.
>
> But, please, no.
>
> The fact that wbnoinvd can be expressed as "rep; wbinvd" is a
> implementation detail. Exposing how it's encoded in the ISA is only
> going to add confusion. This:
>
> static __always_inline void wbnoinvd(void)
> {
>         asm volatile(".byte 0xf3,0x0f,0x09\n\t": : :"memory");
> }
>
> is perfectly fine and a billion times less confusing than:
>
>         asm volatile(".byte 0xf3; wbinvd\n\t": : :"memory");
> or
>         asm volatile("rep; wbinvd\n\t": : :"memory");
>
> It only gets worse if it's mixed in an alternative() with the _actual_
> wbinvd.

Works for me. I will explicitly use 0xf3,0x0f,0x09 in v5, which I will
send shortly.

> BTW, I don't think you should be compelled to use alternative() as
> opposed to a good old:
>
>         if (cpu_feature_enabled(X86_FEATURE_WBNOINVD))
>                 ...

Agreed, though I'm leaving as alternative() for now (both because it
results in fewer checks and because that's what is used in the rest of
the file); please holler if you prefer otherwise. If so, my slight
preference in that case would be to update the whole file
stylistically in a separate commit.

