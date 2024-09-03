Return-Path: <kvm+bounces-25730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58730969923
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 11:35:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 27DE0B28D34
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 09:33:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E179A1A3ABA;
	Tue,  3 Sep 2024 09:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B2+DIvPM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2171A0BC9;
	Tue,  3 Sep 2024 09:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725355776; cv=none; b=YmMrn3B89npQS3P6ZylJ0v6ufzgxucSaiffm7R7BjFIadOOX27cKn8on/F6gm97nWgymLQvsUyP1kvdsfPAwkPwEHYn2QX+GCisEN6gcDA5+VxQfrD0CalyjTzDLlkl1RhY/Iw5gSNhMZGzWkxqlbfssE4TDfStGZkO7tfpZ5lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725355776; c=relaxed/simple;
	bh=V6Ts8UeyZzyhtsfr4GKAWGTzPe6MoHhPae1lOHa7ehM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wd3MxDaD5NUEtZDyWZ/5ZVuX+ly24+1oYAlSbhyKjJOx1OFU2SwrjjljBS3M8vCfCbzaliXvOaq00xOy+Yz7S5iNHIiiesN5EKK2c11+OHo4tDJ+A/ZcLrDa16KKZ4e5BnvyRIy1OqIfIng0hnpb+x6YP2Et/2Rcj+a3ahCVzSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B2+DIvPM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78215C4CECA;
	Tue,  3 Sep 2024 09:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725355775;
	bh=V6Ts8UeyZzyhtsfr4GKAWGTzPe6MoHhPae1lOHa7ehM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=B2+DIvPMxoKjhFD7wiF+7h0l/cf/7MYT3BR0Zhx9vp7HBRO4mfIxwB9KqYB/sTeeC
	 1G81qhU92qnFCiE/jliReBCBu6b2qHvBBHBVRrSMDGFA+JwuXas7widUz6aFtvxdkF
	 4tjHzOkHd6/ex/78UYqR6cDfYnFj/Pq5XqY4K3a0iXYisf626Hp7/acc1DOSY/a6cg
	 a2POT1sITjmIyfszLS/XUbkntiO3MqghfOGuiOpgHz9jatyaXxIOGO9cYBAqqbwA/B
	 15wIL94JzUdR+NZ65E3bnzn2/+w0/WyZpdfxs3YRDoguIILWF4YT/rse1cCgfc4OyQ
	 fg09k/DSfw2nw==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-533521cd1c3so5884505e87.1;
        Tue, 03 Sep 2024 02:29:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCURPe1GiCI1KlAHjuWacnN2AggN9fD1gyk1bD+ZwUYG64AxnGRywNGWag5Cn9StVlXS9OnTwbyRVOZAm4jm@vger.kernel.org, AJvYcCUe+kbF+z39BXoQTd00/AVIRb0G9WWgtpHnW+pYMXSePI7rTTfxGkh2z4JVLEKF5AXFYbA=@vger.kernel.org, AJvYcCVJtQsPA9bxFAJhxs7Wqu97RRR1Jd3NMzZhyeH2aMYTYXKFQQSrChZsfPIg0X+2myz/O95kimIAIDVhKrBU@vger.kernel.org, AJvYcCWm8dH+2mGgU1m28iGBHLiPuEDNIMKFLrowQBrxLQDyZpXS89eNlJr39QfhHIua/3u9tXIsOnbovCOfpQ==@vger.kernel.org, AJvYcCXoGibKNA6WBO2Uwc1lWZn0mYCDzk4JoZ/Mq7SW5TZJXyTrJkJq+/jhE3YWkQfhL6WSLXZB@vger.kernel.org
X-Gm-Message-State: AOJu0Yzs1XRcEroX/5U8GXO/VojN2TXwmV2w5zlTNAnY+4OzOIRMtVHJ
	nKotLfvTGm9eLVMTAI+hKwNk0vRQ1SlzpXwAK5klZc51/krXyQqiEtKPF6iYICPoNLPyeZwFdwM
	swD73640W5AAvul2H5uC7GILBnM0=
X-Google-Smtp-Source: AGHT+IHCtdlG38E/0l7FYyhNp/Eh+agXUP/x4m9X1sDISAuGOfE6COrF1RVXR4n+XrSU6Tf+eKwYmtlidm1SXvGzdlM=
X-Received: by 2002:a05:6512:108f:b0:533:4785:82ab with SMTP id
 2adb3069b0e04-53546b223d3mr10683476e87.1.1725355774159; Tue, 03 Sep 2024
 02:29:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240828083605.3093701-1-vegard.nossum@oracle.com>
 <875xrd7h88.fsf@mail.lhotse> <d1bb2638-2e0e-44ef-b8da-9746ed532ed1@oracle.com>
In-Reply-To: <d1bb2638-2e0e-44ef-b8da-9746ed532ed1@oracle.com>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Tue, 3 Sep 2024 18:28:57 +0900
X-Gmail-Original-Message-ID: <CAK7LNAT84K0RgDfLoOOLjtyCqsS19bASXRv43HF8P=C9obJPVA@mail.gmail.com>
Message-ID: <CAK7LNAT84K0RgDfLoOOLjtyCqsS19bASXRv43HF8P=C9obJPVA@mail.gmail.com>
Subject: Re: [PATCH] kbuild: use objcopy to generate asm-offsets
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-omap@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-um@lists.infradead.org, bpf@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 3, 2024 at 4:21=E2=80=AFPM Vegard Nossum <vegard.nossum@oracle.=
com> wrote:
>
>
> On 03/09/2024 01:45, Michael Ellerman wrote:
> > Vegard Nossum <vegard.nossum@oracle.com> writes:
> >> Remove the sed script and compile the C source listing structs and
> >> offsets to an object file (instead of assembly code) that embeds C sou=
rce
> >> directly. Then extract the C source using objcopy.
> >>
> >
> > I threw some builders at this and hit a few errors:
>
> Thanks, I also got the ones from kernel test robot and figured something
> was going a bit wrong.
>
> There are several issues: clang wants - instead of /dev/stdout as an
> argument to objcopy, and then gcc has some bugs that prevent the numbers
> from appearing correctly on some architectures, also I had an extra # in
> the COMMENT() macro which only resulted in an error on some
> architectures. I've attached a tentative v2 that fixes these issues, but
> I'm still trying to figure out why m68k is giving me slightly different
> output for include/generated/asm-offsets.h and why the arc assembler
> fails.
>
> In the end I'm wondering if this patch is really worth it, given all the
> failures and little workarounds :-| If I can sort out the last few
> failures I'll submit it as an RFC.

This patch has zero benefit.

The current way (preprocess + sed) is faster than
your way (preprocess + compile + objcopy) and works
independently of tool quirks.








--
Best Regards
Masahiro Yamada

