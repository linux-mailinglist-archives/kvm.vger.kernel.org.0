Return-Path: <kvm+bounces-3055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4690800270
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 05:18:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F9FF2816D2
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 04:18:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A76F28483;
	Fri,  1 Dec 2023 04:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="spv8qDn3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4C6171B
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 20:18:32 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-548ae9a5eeaso4792a12.1
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 20:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701404311; x=1702009111; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YZqvo4x8iXRWvdlWCCwPUoFZxsdTCLZYZNCKhWWJF24=;
        b=spv8qDn3QJEVIP3CjErjfMPVMbNoQZ0k/JYs35TH5JUhAqbOpABvni98MtvDNib+WT
         IwyPnzSJbdftRyjYo/jqHetZosZGTy+XUXWCGIqp1AB3tWzmoqUmWUAUIlXhwph0rCbt
         wK8muv9ig8UANjGLIrUWGLWP6ynAaCpTV6N99748pSr09pfCOeUE2LW2TLztc2jo2L7p
         exhwxOo5KT9wkYBAA70UXRE32Z6hOyC1MSCnQmMTpXehYMr2tpdcraGUIRKJ3sLIrI8M
         xPskD+c6t0ryYMyrcCvR3pE5WebqG5PINl5DpRRM+rDHOjalYQaBJ6NpYNQWUjnaNrTk
         XZ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701404311; x=1702009111;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YZqvo4x8iXRWvdlWCCwPUoFZxsdTCLZYZNCKhWWJF24=;
        b=XtwaWLffbpIoZVBuQNlK6u9rmXLUzrpal4WjE98EovPjGmQ9yZpqf6kohNeRquuwUV
         BT4+0dOd229gqQloJAcFeOGK3QtGzMQ2Bg59xQRY8wMwbEw+mZf5/Lz9IdO5S+Mfrfk+
         d/NWlzLyk9aIZCjBrRl99CdU3uI0m1dqyvQN7jl01byUoPs0jcyUBrIJAa/z9VCE5h6i
         Hi/GARfThvNtLNafblZB8slWd7xKm8gabjEl7OleDRaj5X0qMGpdXXA4sVuor1TiQKtV
         4dOLab0EuGKGRmJUXS6Ry300Yx7VixZQqxf8ZuwbB0ktsiy9bYO0TmeBqKhItqGYkKN0
         4AmQ==
X-Gm-Message-State: AOJu0Yy3WkbcKgcoA8JXMi27ba9y4IlMACZjNPF8kKcTzwvqZ7Phn/hz
	eqwt59TzqVtD6vhKKL1j56a+Gt5o/+aY9DbvOr5i4Q==
X-Google-Smtp-Source: AGHT+IGapZ/OnjAJsQiGEb22LvTvAz9POLEgdFXGy4wqfYX6TsUfAFHVFhNm6/qZmkkcb8zYCV89hhhYT4jmU+6P7wE=
X-Received: by 2002:a50:9f42:0:b0:54b:c986:2bc8 with SMTP id
 b60-20020a509f42000000b0054bc9862bc8mr33798edf.7.1701404311177; Thu, 30 Nov
 2023 20:18:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231024001636.890236-1-jmattson@google.com> <170137622057.658898.161602473001495929.b4-ty@google.com>
In-Reply-To: <170137622057.658898.161602473001495929.b4-ty@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 30 Nov 2023 20:18:19 -0800
Message-ID: <CALMp9eT2YiD=q3QwV5o7cWt+iBH-CUM5LNmhREcX7PJ1F_HhBw@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86: Advertise CPUID.(EAX=7,ECX=2):EDX[5:0] to userspace
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 30, 2023 at 5:54=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, 23 Oct 2023 17:16:35 -0700, Jim Mattson wrote:
> > The low five bits {INTEL_PSFD, IPRED_CTRL, RRSBA_CTRL, DDPD_U, BHI_CTRL=
}
> > advertise the availability of specific bits in IA32_SPEC_CTRL. Since KV=
M
> > dynamically determines the legal IA32_SPEC_CTRL bits for the underlying
> > hardware, the hard work has already been done. Just let userspace know
> > that a guest can use these IA32_SPEC_CTRL bits.
> >
> > The sixth bit (MCDT_NO) states that the processor does not exhibit MXCS=
R
> > Configuration Dependent Timing (MCDT) behavior. This is an inherent
> > property of the physical processor that is inherited by the virtual
> > CPU. Pass that information on to userspace.
> >
> > [...]
>
> Applied to kvm-x86 misc, with macros to make Jim queasy (but they really =
do
> guard against copy+paste errors).

They are also quite effective at guarding against code search. :)

> [1/2] KVM: x86: Advertise CPUID.(EAX=3D7,ECX=3D2):EDX[5:0] to userspace
>       https://github.com/kvm-x86/linux/commit/eefe5e668209
> [2/2] KVM: x86: Use a switch statement and macros in __feature_translate(=
)
>       https://github.com/kvm-x86/linux/commit/80c883db87d9
>
> --
> https://github.com/kvm-x86/linux/tree/next

