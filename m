Return-Path: <kvm+bounces-18796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 750808FB809
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 17:53:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12B6D1F23387
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 15:53:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C943E144D23;
	Tue,  4 Jun 2024 15:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DF5e+nXx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D84213A25B
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 15:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717516327; cv=none; b=HLq2IGSbvXM43JP1vctcVSSOr1kIxOLGKuCoPcb8C4WAhE8qY2GBkw9X7ZszWEFnuB1txjohMqCb9xOwtBe4VRNnV2r2sdVP6LUFIs6Kge/9GXpY+pKTZTim/PzTDsyePvwVNzKkMbgQrOFOMjDxu+D+CVPdPuvW6fMQkc5u5jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717516327; c=relaxed/simple;
	bh=qHT2E9JXlk7ttnLty3NOuDY9aR5M7vuQyAQ1ZVNDrjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sL+/V8uI5CXUt5hs0NnChGDZ+U3DIdc6ih+yDwUNyeR6KMsYyrzWxVfq7lsJAdUVCpYLjSgyIiSYsgYGshkVdxcTahiday0d3ybW+3w5XD1Q05d8eQ2hx6ScrQGDyqMOHuoUO1xlDxbbj1b5SdZgozgyNL0VpufWelFlqGiN+cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DF5e+nXx; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a690161d3ccso249664766b.2
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 08:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717516323; x=1718121123; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2gcc4iBvvKpaM1N8hUMKIuorK0dH13+qzLOax+XEG0o=;
        b=DF5e+nXxau4Tomb0PbP/WD2I1QGM3nqXy2flb6QFkWRscj/+ErV65aJvSXwFVDMjkE
         ED3QFcJ00yxmgLIIcybPGRa95PFDd/zLLgRdCJ8tQg5t1bNzGPujBoa5jpBTgl1glMyP
         94P1eGhtVJ6lbCzaOdDBb7XvpVXUPO0/Vhk/4vvra/D+i/9a9Y7E1ZOnTr8ki5QkGqH4
         Z5AMf5uVmnGJmbmgubdHGsUFxGig/N/vjxpGTK9lUCzplpt+dzf2BWhb4VCPjVrQFDjY
         /avkXxivqxdufGe0CDk8qXyKr4kkpVJLVpr6SMU2OpJuYazFgrvJzT9Yz330IvSiwk7C
         WE0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717516323; x=1718121123;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2gcc4iBvvKpaM1N8hUMKIuorK0dH13+qzLOax+XEG0o=;
        b=mSByLnGiLdUUsgM6TlxbV9jYIzJ3Qx74YV+v+4zxW7fKKOZXVXTdc8kG+jwESu2jPV
         reGkU0kuJe/Da2z6LdX1jfdhREEg3gwgX3euYsgirNzzsrMkYk1tM2geaOI6vRlKUbSc
         kPb0OqL4SmGngneb+CQpdNV1gR8f2JuQuvubyBliXa32jVPGBgtHdKsCvrGo27uONrlZ
         OpDj9/6dh79/4/HtzryGsPjCGe8SvRUSJ372gTo7BFi3Sm39y4434t4oqmxPT8iZUxyC
         pgDgFYxunNLZN1ma0CbavanD5nShNUcR7DX+UO3e6w9OoGykq4EECtgqbWb+DRzWQX27
         /J9A==
X-Forwarded-Encrypted: i=1; AJvYcCUhY+aunvjB5iniptqFkz6W7cMhvf7+eRxCiMwK4L4Jr9nCpzQdQsThg3wQX/iA3OGu71Gple1+2mbHBd3OGRfJZbA0
X-Gm-Message-State: AOJu0YwizWwaiaKpXBW7hqekDB6tPvGxY8tPOuyB0Usvl0y7oNauQCkC
	CxZbS6apZS1qr+8rgVTRimkpVveISc9nWapnmdAJztvkPnf+/5brp71HQLmoaQ==
X-Google-Smtp-Source: AGHT+IGfAzZJvUYrriUlHKJNvDU27Rn35hs0ZzZeAmqXl6qtysMyyKnUKZDq6C0qJc0XLrKnJiGBjQ==
X-Received: by 2002:a17:906:c0ce:b0:a68:b3e9:b364 with SMTP id a640c23a62f3a-a68b3e9b466mr587701166b.75.1717516322613;
        Tue, 04 Jun 2024 08:52:02 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a68f39b9294sm391487466b.180.2024.06.04.08.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 08:52:01 -0700 (PDT)
Date: Tue, 4 Jun 2024 16:51:58 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 05/13] KVM: arm64: Rename __guest_exit_panic
 __hyp_panic
Message-ID: <42h74rlklrenekak6dzl6mpi2b37peir6o55tnawvvf3kt6idn@53svu2uxcxk5>
References: <20240529121251.1993135-1-ptosi@google.com>
 <20240529121251.1993135-6-ptosi@google.com>
 <20240603143424.GF19151@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240603143424.GF19151@willie-the-truck>

On Mon, Jun 03, 2024 at 03:34:24PM +0100, Will Deacon wrote:
> On Wed, May 29, 2024 at 01:12:11PM +0100, Pierre-Clément Tosi wrote:
> > Use a name that expresses the fact that the routine might not exit
> > through the guest but will always (directly or indirectly) end up
> > executing hyp_panic().
> > 
> > Use CPU_LR_OFFSET to clarify that the routine returns to hyp_panic().
> > 
> > Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> > ---
> >  arch/arm64/kvm/hyp/entry.S              | 6 +++---
> >  arch/arm64/kvm/hyp/hyp-entry.S          | 2 +-
> >  arch/arm64/kvm/hyp/include/hyp/switch.h | 4 ++--
> >  arch/arm64/kvm/hyp/nvhe/host.S          | 4 ++--
> >  4 files changed, 8 insertions(+), 8 deletions(-)
> 
> Hmm, I'm not sure about this. When is __guest_exit_panic() called outside
> of guest context?

AFAICT, it is also called from

- the early __kvm_hyp_host_vector, installed by cpu_hyp_init_context()
- the flavors of __kvm_hyp_vector, installed by cpu_hyp_init_features()

which start handling exceptions long before the first guest can even be spawned.
Hence __guest_exit_panic() needing to validate the context on entry.

I don't get why those handlers didn't branch directly to hyp_panic() (perhaps to
have a more robust flow?) but, as mentioned in [1], it is convenient for kCFI to
be able to intercept all panic paths for sync exception from a single place.

[1]: https://lore.kernel.org/kvm/qob5gnca2nte4ggkrnn4uil5mfbkz3p55lmk3egpxstnumixfr@lq7xomrhf6za/

