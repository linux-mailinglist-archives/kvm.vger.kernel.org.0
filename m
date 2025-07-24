Return-Path: <kvm+bounces-53359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BDDDEB109B3
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 13:57:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 156027B4F56
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 11:55:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74B3A2BE7B0;
	Thu, 24 Jul 2025 11:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O+B52w/E"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967642BE642;
	Thu, 24 Jul 2025 11:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753358217; cv=none; b=CI0WMPxfzzCS8gfxzygPy5qYdCo526uo9NuBA+sXLnQzhTQNqNUw3qMBgnRqC0iwGz3BvoN4QL+x89swrWm0icjMkEEcBvjqdAgTDR8aEt38VZLSHY09u2Ag9wLWPcNevCPtv+tQJw95pukqcLqJ9ewsX1gRFIVifGEzFNtEthk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753358217; c=relaxed/simple;
	bh=UbnLPvlzvaF+TASrvQ8CvSyZzrgpblIXwom2xhrfV3w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IekphqaWKxDdjCFSxrhyd74nYunndzwjA5JM1M/cfJPx8TeAGzauSEWVlZxFBtSvILg4Mk09WfHB181d4lOTUZPqggNdo7fde5rR+47Shk6x6624KuipisVvVqa3JGcXX8tktMpIAQzyeNQjTHljUB4/oizKvpKpFslCQQxhipU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O+B52w/E; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B35C4AF0B;
	Thu, 24 Jul 2025 11:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753358217;
	bh=UbnLPvlzvaF+TASrvQ8CvSyZzrgpblIXwom2xhrfV3w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=O+B52w/ETUfu8M3TbhhmtQI4auBK/DIqAXLehkKPeIzJZceUdaIMxnchkcAGo3BCL
	 qyNaX/RK4vJjIepty7runayUuhdbjpnNeVymdMYsgbGFf3wqxVDebd0nnm7z9ndq0H
	 H3QKmjpAaAHZt0a135Uka+4lJqOXO9/K6AoyYKoyCi7TFOBkYdT8rRtV7KMMhoskFO
	 0SCpi/CPt3Yvwq/Ao8W+MQ9oHqoDjD6tLafEiOWB8DhNooTvtb+0HlKJnw1DpWSvI9
	 9hBIFFqvBGxOW4An2DoHrj4ppsSLymhvfa+5St3IUdEs/TmOtZG7sRN3c5PWpGNiPZ
	 0aNa1E7OIUxdQ==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-607cc1a2bd8so1532057a12.2;
        Thu, 24 Jul 2025 04:56:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCURjVHwh7pIp7JcklmC/C31YPZNgy8r5gR39dLhNfACi/FO8iqPQcrOeNw3vfTe6Et6P1xatT6K706610ro@vger.kernel.org, AJvYcCV3WXZFU8ZtIFceeMUNlDwvr1XC1BcEvihisn5YGzKEXtV+qxSSJh06DHxRNkv4LJ5r8soSl92W00JMhEZJWrNUxhJH@vger.kernel.org, AJvYcCW6kLruEJRPR9RiqDaF+bSXOORT4WijT33IxfY9GVeFFmLlFnnFlzGkIaFC0Zf00SeFqEc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyR+IwvK5wjEA+x6KCQEEg05hBtHoVkpRKtfAJE0iKsyhkDOmNZ
	cT1wxYHFiSPvWvOZ/wz+7i/qIdDmdA1Rp2TIbO24v0Av+v3/6WcYaNOgFpTylwPAr047s8YhZoi
	CNN4RMqColZN9iCVk4WsPqvWAib1xryA=
X-Google-Smtp-Source: AGHT+IHyudkQ+ID0bU15SK7aT9+KIcppMZFHtN6CrQ6Dtu9svcp+0ZZ1xB7ZVtW72pZg9dG9fKgoM+SEjXsylHLj50I=
X-Received: by 2002:a05:6402:1d52:b0:5f7:f55a:e5e1 with SMTP id
 4fb4d7f45d1cf-6149b596728mr5451665a12.24.1753358215740; Thu, 24 Jul 2025
 04:56:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250722094734.4920545b@gandalf.local.home> <2c2f5036-c3ae-3904-e940-8a8b71a65957@loongson.cn>
 <20250723214659.064b5d4a@gandalf.local.home> <15e46f69-f270-0520-1ad4-874448439d2b@loongson.cn>
In-Reply-To: <15e46f69-f270-0520-1ad4-874448439d2b@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 24 Jul 2025 19:56:42 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4TGus35B6ONdkSOMwWw+H6NRmHStV-Xu7vUYYrkDGfUQ@mail.gmail.com>
X-Gm-Features: Ac12FXyEIVNP2UDQDr7DKqNUOZbuTtFEVDCtic-VwJB5VQ3JEknFoA6_p-1cdZw
Message-ID: <CAAhV-H4TGus35B6ONdkSOMwWw+H6NRmHStV-Xu7vUYYrkDGfUQ@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Move kvm_iocsr tracepoint out of generic code
To: Bibo Mao <maobibo@loongson.cn>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>, 
	Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Paolo Bonzini <pbonzini@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 24, 2025 at 9:51=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2025/7/24 =E4=B8=8A=E5=8D=889:46, Steven Rostedt wrote:
> > On Thu, 24 Jul 2025 09:39:40 +0800
> > Bibo Mao <maobibo@loongson.cn> wrote:
> >
> >>>    #define kvm_fpu_load_symbol      \
> >>>     {0, "unload"},          \
> >>>     {1, "load"}
> >>>
> >> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> >
> > Thanks,
> >
> > Should this go through the loongarch tree or should I take it?
> Huacai,
>
> What is your point about this?
I will take it, thanks.

Huacai

>
> Regards
> Bibo Mao
> >
> > Either way works for me.
> >
> > -- Steve
> >
>

