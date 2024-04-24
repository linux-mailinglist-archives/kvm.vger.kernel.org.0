Return-Path: <kvm+bounces-15804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62F488B0A69
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 15:06:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1EB20281FCC
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 13:06:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5DBD15B550;
	Wed, 24 Apr 2024 13:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="z7L2v9NA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6270C15B137
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 13:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713963985; cv=none; b=WZbmCF2TlMwdWPheqEYnkONBnWwHpCUBAOhcPoptDzEb6a0/dbCPXIPsufgoobUy2+FM2I28FaVWxVV1HN3hLzKHfw/JaFnB1NL+vN06m+jckYf4Z+ePArO62QRt/tKkejnsQ/0EmiqM8kazoYrC1hPA1fA5N4DYf/wnirWRWkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713963985; c=relaxed/simple;
	bh=1X/4OOsHJ1KCbUAws4NmpoimMT/p0DvtpIV8MG8B394=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L1Lw5HDMydvn7F7iIDor77C0NpuC19TIoAw0Ssjv4YWGtqL3C4GXl5/P+pye1IC+AweKjGuZfR7vx4YfEp4E8A8Di5tNQYwwVCLumx3F0wr04LI5BSE+6Ui4GTbKKJvHsMK0dLhWzTOhKBQM6YimInCjQdT/3m1a/eMkTL68pM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=z7L2v9NA; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-51acb95b892so6169215e87.2
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 06:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713963981; x=1714568781; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oXPDyQAT+HitFMuQv0udxwIiXElf7T1dd2oYrE6rTrM=;
        b=z7L2v9NAChHGyNtJtkbm9xJ73l2sZ7/OorIH3YPPwjZozGA9BaZmiVLaHU8tUDd4QP
         djgc6nXigSemjUK80wUoPavrbC6brJHERNVnxu90jPELVO4nFRCgou4Ueg4lWDAdBn0P
         tf5ghtBpELQCh+v0zzmqa1AdDE7iKu7agSBcFQumegh8BqEPhq05/QfVwpibUQDxxAW0
         93JXbc2FB13jvhO63FUOXl7EoURDxFnU1is/U4ArthkQXwld/1TLeZEk/YRl8d6qb3Mx
         +TSN1Y5dUFH+Kq505SI49n80Sf8p5j/+ZgwSdWqK9K+TyyXnl3RQe+1JWqNwzReSeoaI
         y9fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713963981; x=1714568781;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oXPDyQAT+HitFMuQv0udxwIiXElf7T1dd2oYrE6rTrM=;
        b=kiKlBD+2Z2QeBaC3qlkqf0i+I/5OFgl5k0tA5yx6xdadoI996TigU1Skm/LGheRnb2
         ndxucjfc6mqlTRd0VSL9XK1Jptf8Ydf4oELp1ki6H2fpOq7jr3cTPaXqu9y7nhyWeXB2
         GY+nFml9VvF2+58vVJ0lnqN9P7eShoVBcys0Omj0kKHO27nvpeMVh9PnJivrMVo3L1qT
         pqAjp4nmTdcrZxc/itKMGAluEGz/A8c+05sumjnKfrjJzDC8sH3+5qM07Y6kwn8g9jlF
         nbdgm0agv2gHchAEAlzUvEQCnbKnuBKTAQSZ+KC9NHOGF1wEYvHE6IdkCjHLn4gFj+5N
         XDsg==
X-Gm-Message-State: AOJu0Yz+yplrMI+TAcBX1CEtQom86pM8i6KG2Oxfa9XO6qs0V4kFMoRq
	C4PWgv3PVaG6neHju02gCaZIvPEue2mt2pxuA8d0vxaPXEFygO8bAbB9BBI3vhtuJpjvwuD49M1
	PTMXQf/pGHpeMRwzCvDlOWzB+Ie5MSIvfez9Cfg==
X-Google-Smtp-Source: AGHT+IFefKvAYRBqhr8QCesj7hq8WHWt10BLztHIAMclGVcycqHpNCSNgO9jv0EcYEOBsbpQ6CS9FIGy90LZsASyIU0=
X-Received: by 2002:a19:915b:0:b0:51a:f31f:fc6e with SMTP id
 y27-20020a19915b000000b0051af31ffc6emr2425780lfj.14.1713963981412; Wed, 24
 Apr 2024 06:06:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084213.1733764-1-steven.price@arm.com> <20240412084213.1733764-15-steven.price@arm.com>
In-Reply-To: <20240412084213.1733764-15-steven.price@arm.com>
From: Thomas Fossati <thomas.fossati@linaro.org>
Date: Wed, 24 Apr 2024 15:06:04 +0200
Message-ID: <CA+1=6ydMVk4Vcouc2ag8G7tfqZy80VWFxWHSHEKF1JaABd=A7A@mail.gmail.com>
Subject: Re: [PATCH v2 14/14] virt: arm-cca-guest: TSM_REPORT support for realms
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Sami Mujawar <sami.mujawar@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Content-Type: text/plain; charset="UTF-8"

Hi Steven, Sami,

On Fri, 12 Apr 2024 at 10:47, Steven Price <steven.price@arm.com> wrote:
> +/**
> + * arm_cca_report_new - Generate a new attestation token.
> + *
> + * @report: pointer to the TSM report context information.
> + * @data:  pointer to the context specific data for this module.
> + *
> + * Initialise the attestation token generation using the challenge data
> + * passed in the TSM decriptor.

Here, it'd be good to document two interesting facts about challenge data:
1. It must be at least 32 bytes, and
2. If its size is less than 64 bytes, it will be zero-padded.

cheers!

