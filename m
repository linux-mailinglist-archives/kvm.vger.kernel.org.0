Return-Path: <kvm+bounces-27984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FDEE99085F
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 18:02:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BAB741F2193E
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 16:02:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EE151C82E1;
	Fri,  4 Oct 2024 15:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yvIB5SB4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79971C3023
	for <kvm@vger.kernel.org>; Fri,  4 Oct 2024 15:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728057491; cv=none; b=Gdx6dx0GYvgqvrLFsU5KTvB576JC+G/0m8y/YXP3AAnlgKQk/plpGwQ+8sohJbqgvxd27lN/Np+UtEOJLKWTcbvmvtImy4mLXxq1uh9BVJ3XTQnhKGWhJzLf5uKghox6OUAA/e4pHgh9ADuXSsBQ891wXYfxc0e+mUhMcaUfOhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728057491; c=relaxed/simple;
	bh=HWGViDOQRtvE03XV98m1bwgXILGc5l07x+W+qORtMAQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JNA045RDDwknpSHClCCkOGHj52uPPnNMwKjMMlbjAdXowakzvOZGMJk3WBrFPByXrA1odcDtCgeQ3bnYhCCN7oRP0C/ab+/5EsTmoc9oeAd4bX+1Kk/huFLdVgHvJyivw3kQpiV4wRWfd+dsU1sXBYIGQD+67lxN85d0/ixTxws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yvIB5SB4; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2fadc95ccfcso27020491fa.1
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2024 08:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728057488; x=1728662288; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HWGViDOQRtvE03XV98m1bwgXILGc5l07x+W+qORtMAQ=;
        b=yvIB5SB4KT8ijBpySPm3WIx+51XuySIu9KMvFgJ6ZRsm2conth3qRoarocARCxMWGO
         Rs76YzYdRPxX+YmQBy0o2uOs80yS6BGk5pUAy8/04ebnagYwzK/zVuJ/O21/7r69Ajze
         WaV0LWbpHpvTz+mzSKzKW11+8ksjolTdX1lQ7Xa8oPSZTQl21byasVKXxJP3lLxolM5D
         Gh3Y2LHBpSRYK82wwexZmB3JFm+AGKTs4qY4a/kFQX+ItGm1wvbGFuMxKrNGZ1/I+aSe
         MmmHjXsxP45tN356yeahZa3jZANNwlSOzfmA4Hj1fD5Kv8jG2j7UcF1zdzyzr8VKlV05
         Bhuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728057488; x=1728662288;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HWGViDOQRtvE03XV98m1bwgXILGc5l07x+W+qORtMAQ=;
        b=jHDLzBmFVlTgwbcPmOX0eIJOlRBCDKAjHNYZ81naHfLoXw/3JgsMr68eWSTyE0DPei
         HNeWoZIYTqllaADjBp6X2QR6ICfS1EHiaLtMsqrfIrVCHZ7saMOXxbfJlmMHS1Tw1KU8
         0MZLX1PdU7M82OK0RYSUiESJebWOfi3qOEyWrZudl/QfkrxCKAYGx3TQ1fmgKndtuuvB
         7jyAy5qHu26BfjRpim3uJx/Hs0WfvhaCMNYGY3tG8c6QUpuv5+rBeinoJnEsAkM/9YRe
         Qvw9FIUJX6GC+hRo2uFH+5X4DXk0qPAux+D255fujDQPj9Dm6DpOrXkEHE4/B/GS0fsO
         Haxg==
X-Forwarded-Encrypted: i=1; AJvYcCUE2eUhJuiLbKap09d389rI1qQLNNwrKucjzrW0tQoz4ru4ujMHfAe+kd1abbOosf6mHIE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoRqlwQt7VXLsZpEA7Gz7hrgK6f5IcjEIZf6/CEfkxidWEAzXW
	0LueroKDAoPqcrGFMvQwTEEgUQRT1sP/zHx4iuIY8z+lh011PSM8JFDNcsdR/bn29qdQmsw92u5
	FP9mxxlUp2E2ycT72YixQYu30k2Ki3yWoIIM6ug==
X-Google-Smtp-Source: AGHT+IE6D/ytJI1XEuL5RjuLmHf7kTMpHr2stdM6cvQcL3VbC95ix/TXwe9hvfiPDKge6XKhF4GO1QqzUMMpBNOmpEg=
X-Received: by 2002:a2e:e1a:0:b0:2fa:c57a:3b1c with SMTP id
 38308e7fff4ca-2faf3c63ed4mr17625661fa.17.1728057487436; Fri, 04 Oct 2024
 08:58:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <89f184d6-5b61-4c77-9f3b-c0a8f6a75d60@pengutronix.de>
 <CAFEAcA_Yv2a=XCKw80y9iyBRoC27UL6Sfzgy4KwFDkC1gbzK7w@mail.gmail.com>
 <a4c06f55-28ec-4620-b594-b7ff0bb1e162@pengutronix.de> <CAFEAcA9F3AR-0OCKDy__eVBJRMi80G7bWNfANGZRR2W8iMhfJA@mail.gmail.com>
 <ZwAPWc-v9GhMbERF@linux.dev>
In-Reply-To: <ZwAPWc-v9GhMbERF@linux.dev>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 4 Oct 2024 16:57:56 +0100
Message-ID: <CAFEAcA9bnJR__3v2ixjjEyQD+Kwz4oR9+HO=w8u6JsVjgnXE2w@mail.gmail.com>
Subject: Re: [BUG] ARM64 KVM: Data abort executing post-indexed LDR on MMIO address
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Ahmad Fatoum <a.fatoum@pengutronix.de>, qemu-arm@nongnu.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, Pengutronix Kernel Team <kernel@pengutronix.de>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Enrico Joerns <ejo@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"

On Fri, 4 Oct 2024 at 16:53, Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Fri, Oct 04, 2024 at 01:10:48PM +0100, Peter Maydell wrote:
> > On Fri, 4 Oct 2024 at 12:51, Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
> > > > Strictly speaking this is a missing feature in KVM (in an
> > > > ideal world it would let you do MMIO with any instruction
> > > > that you could use on real hardware).
> > >
> > > I assume that's because KVM doesn't want to handle interruptions
> > > in the middle of such "composite" instructions?
> >
> > It's because with the ISV=1 information in the ESR_EL2,
> > KVM has everything it needs to emulate the load/store:
> > it has the affected register number, the data width, etc. When
> > ISV is 0, simulating the load/store would require KVM
> > to load the actual instruction word, decode it to figure
> > out what kind of load/store it was, and then emulate
> > its behaviour. The instruction decode would be complicated
> > and if done in the kernel would increase the attack surface
> > exposed to the guest.
>
> On top of that, the only way to 'safely' fetch the instruction would be
> to pause all vCPUs in the VM to prevent the guest from remapping the
> address space behind either KVM or the VMM's back.

Do we actually care about that, though? If the guest does
that isn't it equivalent to a hardware CPU happening to
fetch the insn just-after a remapping rather than just-before?
If you decode the insn and it's not a store you could just
restart the guest...

thanks
-- PMM

