Return-Path: <kvm+bounces-19769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D0C390AB03
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 12:27:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 432071F2144E
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 10:27:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8BCE194140;
	Mon, 17 Jun 2024 10:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="p1xkmjrl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FE1194126
	for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 10:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718620066; cv=none; b=oVSUAASxhRxuxk5V05OweiNa3cwIDC4Jt8QVKhj+GoeiD4VEoQHyVDSKbFP3WWQ4mCdeLq6w0+er2h/Rdzx61UDl7FUTbB8Gbr8DFXZJBvBsPXPOTnF7QPzatH1nI50XNUkH9YKAScd8eJwroxlm/2vJQ8yKc6wkIlbTSyYK1sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718620066; c=relaxed/simple;
	bh=t7JP/HGFJDwk2M/R92BFPhUlm/Hwfwtb8ue0IF8mlwI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NgdXa0Brvc2s2CfVG9I+9fNCrgD0Q57WvyXzLdCgmt7rPpmUtDiebrxf1TK7CLsuDEZnDCurbhdea7N8FAOL46UyUpHKyeEGKt2fvKN7Vp6eeiMcw9CdVyu2TLGVSMXtzqTsIvBLFtlVEWAf/hQq4lO0xl5zFhWmtMoYIZhyTOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=p1xkmjrl; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-57c60b13a56so4939687a12.0
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 03:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718620062; x=1719224862; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uXp/Yz17OzdkV2gV0XI8xrmGqd5+ox1Pqhqcmx8WT9w=;
        b=p1xkmjrldXPj1sZ1DY3G1u3Z+cIdEKGJTnvgTG8q4xTXH0ACKqaFX6ZaDPBSp2O3Ui
         IR97IRhtggjQeh6ODa0ejZLefZPfSLCNL1tkjaWb60r5m+ylgwQwJxXllRAFbydasFAM
         vswpKC4OZwK3vs3w9rkRF5Nt7RZrC3WEhqpeHkFXw7/SvIlUz3h2F2m/kadnkYlIktZC
         cQ9J7Qn4bXPzHEzTPCRXv7wq2cqw6gzaW5pIgnus87AeEKKzfttRfLaZDrshOn7gGKkw
         XPMoLnvEJmXSjFXw2cfR+1vPIIpMlLWSDk6thahGJuQ+aIrg3cONDLowT6V7v/3k46O6
         Ui5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718620062; x=1719224862;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uXp/Yz17OzdkV2gV0XI8xrmGqd5+ox1Pqhqcmx8WT9w=;
        b=Gt63bS9sDuXr2JLLDpFNR5rw/xgmXnM/DEhH68NN9XatFdUknDbYP7skyLoyzY2lo9
         5Qsn7bqfNf9WTYdNhWqo7Rkn3wCD1VkKwkU7oQvQDJYMF/Mr/XnluAIoaGMf2vnVvp0a
         AZy5VMBVh7SeYS+NMIQ4O62VPqEjy64cX1dBdaTtuZWUyhwwNmJ0Jxth+Kk5RkplF0ux
         pZJXjk2+6ggU8ws61qY2BuC7PgK4siOQ8kK+HGJ5MlnlwN7yDFEZn7AYCdijwxWi6NVR
         7U1JtVbxVJmSE/Jyds4hWje9FeOBoSbwEGikIlLcPCEMtpy7cGc61U6rqGPrpT/KY1Fj
         2myw==
X-Forwarded-Encrypted: i=1; AJvYcCVnS8kiiayBHcDFo1xJA+imLCKC54LJYAFIszIVIJmDv4OBgmjHVHdP8Iekaj1A78lYHeus4jbBPz8pkjV1jsdcxL0y
X-Gm-Message-State: AOJu0Yzc7PEbcGMsnRgltbiP5FqDk4wFJqZX3l1IoMwePURqXJB932kQ
	+hh0GkxpRFxSPpZ76UzeLNWZtTePRKuEsKJX+UeLmMKQeGTJQIIMyWyedvAUvGMQPxoZXQkj740
	FQRuWV8oprx/U1gXHTd4sZa64hgZNLxVmQa/ZhQ==
X-Google-Smtp-Source: AGHT+IHa1KyYv1IKw590sCplWvhogQlO8OvOBxMlNOdOwgi5TbD9kl95KoZfAoxfCiWfEz/NonSQTv/NuyiSNK1pPCg=
X-Received: by 2002:a50:a458:0:b0:57a:322c:b1a5 with SMTP id
 4fb4d7f45d1cf-57cbd6a6d1dmr5332493a12.38.1718620062388; Mon, 17 Jun 2024
 03:27:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240605093006.145492-1-steven.price@arm.com> <20240605093006.145492-3-steven.price@arm.com>
 <20240612104023.GB4602@myrica> <3301ddd8-f088-48e3-bfac-460891698eac@arm.com> <20240613105107.GC417776@myrica>
In-Reply-To: <20240613105107.GC417776@myrica>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 17 Jun 2024 11:27:31 +0100
Message-ID: <CAFEAcA99bPtEr2OpE45wCgfSArZdtz4tu9rggLNb+=Rujh0ZvQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/14] arm64: Detect if in a realm and set RIPAS RAM
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, Steven Price <steven.price@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 13 Jun 2024 at 11:50, Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:
>
> On Wed, Jun 12, 2024 at 11:59:22AM +0100, Suzuki K Poulose wrote:
> > On 12/06/2024 11:40, Jean-Philippe Brucker wrote:
> > > On Wed, Jun 05, 2024 at 10:29:54AM +0100, Steven Price wrote:
> > > > From: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > >
> > > > Detect that the VM is a realm guest by the presence of the RSI
> > > > interface.
> > > >
> > > > If in a realm then all memory needs to be marked as RIPAS RAM initially,
> > > > the loader may or may not have done this for us. To be sure iterate over
> > > > all RAM and mark it as such. Any failure is fatal as that implies the
> > > > RAM regions passed to Linux are incorrect - which would mean failing
> > > > later when attempting to access non-existent RAM.
> > > >
> > > > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > > Co-developed-by: Steven Price <steven.price@arm.com>
> > > > Signed-off-by: Steven Price <steven.price@arm.com>
> > >
> > > > +static bool rsi_version_matches(void)
> > > > +{
> > > > + unsigned long ver_lower, ver_higher;
> > > > + unsigned long ret = rsi_request_version(RSI_ABI_VERSION,
> > > > +                                         &ver_lower,
> > > > +                                         &ver_higher);
> > >
> > > There is a regression on QEMU TCG (in emulation mode, not running under KVM):
> > >
> > >    qemu-system-aarch64 -M virt -cpu max -kernel Image -nographic
> > >
> > > This doesn't implement EL3 or EL2, so SMC is UNDEFINED (DDI0487J.a R_HMXQS),
> > > and we end up with an undef instruction exception. So this patch would
> > > also break hardware that only implements EL1 (I don't know if it exists).
> >
> > Thanks for the report,  Could we not check ID_AA64PFR0_EL1.EL3 >= 0 ? I
> > think we do this for kvm-unit-tests, we need the same here.
>
> Good point, it also fixes this case and is simpler. It assumes RMM doesn't
> hide this field, but I can't think of a reason it would.
>
> This command won't work anymore:
>
>   qemu-system-aarch64 -M virt,secure=on -cpu max -kernel Image -nographic
>
> implements EL3 and SMC still treated as undef. QEMU has a special case for
> starting at EL2 in this case, but I couldn't find what this is for.

That's a bit of an odd config, because it says "emulate EL3 but
never use it". QEMU's boot loader starts the kernel at EL2 because
the kernel boot protocol requires that (this is more relevant on
boards other than virt where EL3 is not command-line disableable).
I have a feeling we've occasionally found that somebody's had some
corner case reason to use it, though. (eg
https://gitlab.com/qemu-project/qemu/-/issues/1899
is from somebody who says they use this when booting Windows 11 because
it asserts at boot time that EL3 is present and won't boot otherwise.)

Your underlying problem here seems to be that you don't have
a way for the firmware to say "hey, SMC works, you can use it" ?

-- PMM

