Return-Path: <kvm+bounces-65174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BA0E1C9D10D
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 22:21:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E968C343C8A
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 21:21:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C22982F9DA5;
	Tue,  2 Dec 2025 21:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DID1k7Tv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E068C2D47E1
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 21:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764710456; cv=none; b=jhg/a7w6G2bKzoHeuo2fDglMC0MupaXph5JQvUFk2jdjVlOiOASD5R6fb11edobfNNeajelfP2pX39f8q0LJaHmB3wlF1N2GY7vUMzrfGT9abR+NsDPt8sHJtFoKbYLMAeTDAY8C5qbzWVJZK9NDUzqIGEwDcirUqTVnmiOK5v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764710456; c=relaxed/simple;
	bh=RagZc9tkE1owikse07dj0ABgQH9MJD4ApwZha2okJgE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D1kfOMXnGspNKB8jdsK/0dUd+43W5fQtAFC38HuHInfmqzZaKrLwdy5DogBpMuzQuxEZE3Ym+/X1E3MiImmJkPQXF7i4GlW6qwiY7nQyYnXQNzfifi2DTyD3ZqXHlcuqaQcWu+VL+NtdrMpKR/sTYwqRhnl7p2JoZhdcEdm2TRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DID1k7Tv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1227C2BCB2
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 21:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764710455;
	bh=RagZc9tkE1owikse07dj0ABgQH9MJD4ApwZha2okJgE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DID1k7TvkX6dxVqpcPKxm30F6tN6QiLczkN1Umm8FaGfWnWMI+t23X4j/3KyxT0Hz
	 slw0AuW1kcLeli9CyFRsqiVhWS7/uhlUl/pL7VchB2/dQdU8qfmsbT7a42Yq54WoJa
	 R2P2MXHHWAQIpJlZ8CEBNOl4fhGc16bKoxMsyhBRaRw5qmag/cOMtQlaG6kb454sLx
	 0EHfTLJMA+QCVVbsfAZfxCqv54e0EnYhuL318Ho22OiUAeGTfoQdqH+7tZxMiXr6Pk
	 dxh90PJyZ/5rYKmamp/3QepavJlv6BXlN7hEdCyTPaicMZI4d4bRbDWbvxBZcVlYxG
	 LoVVbIC2D/IRg==
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-6430834244aso4958020d50.2
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 13:20:55 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX3TBmTnKRKzYqoaqavWHEY5Nmt71XARt+pxYKThpO4kY9K52ScMlJeHscAS4VwQ+tJl50=@vger.kernel.org
X-Gm-Message-State: AOJu0YwX+ZhIq2/Lr82HpcfMzjjS9BighL49RTF2KF0xT0ec0KqM3gQ1
	Kh+VHY0vLgZszpASygTmWuqdC0P+jfxi4a1bl8oBPyM4lW+cHMYM7BGfu0qkM6lqCuORHaEusgf
	1cdu8cmPYD9YHAc+3NvIRU/PZ9dC4g5tlDrsVvP0I8w==
X-Google-Smtp-Source: AGHT+IGeVegJbnbcxMokO/4tzPx6hfftjvmsjbssHsXtb0MWSZghQPn9mBotsEquaBQ4WWH9ewbS1R3BbyNo64wixE0=
X-Received: by 2002:a05:690c:6982:b0:784:92a3:68b3 with SMTP id
 00721157ae682-78c0bed40c1mr99577b3.12.1764710455003; Tue, 02 Dec 2025
 13:20:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251126193608.2678510-1-dmatlack@google.com> <20251126193608.2678510-3-dmatlack@google.com>
 <aSrMSRd8RJn2IKF4@wunner.de> <20251130005113.GB760268@nvidia.com>
 <CA+CK2bB0V9jdmrcNjgsmWHmSFQpSpxdVahf1pb3Bz2WA3rKcng@mail.gmail.com>
 <20251201132934.GA1075897@nvidia.com> <aS3kUwlVV_WGT66w@google.com>
 <aS6FJz0725VRLF00@wunner.de> <20251202145925.GC1075897@nvidia.com>
 <CACePvbVDqc+DN+=9m1qScw6vYEMYbLvfBPwFVsZwMhd71Db2=A@mail.gmail.com> <20251202181923.GB1109247@nvidia.com>
In-Reply-To: <20251202181923.GB1109247@nvidia.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 3 Dec 2025 01:20:44 +0400
X-Gmail-Original-Message-ID: <CACePvbUnY_0HXmfBH5Y2fASZTw1aBLQhxCMXKCNOEKHTf4NnyQ@mail.gmail.com>
X-Gm-Features: AWmQ_bnfRbn0_i7txAStVixQnfWzzZaB25DkDNbFdz6FVjEnJEmpmv2roWbmiDI
Message-ID: <CACePvbUnY_0HXmfBH5Y2fASZTw1aBLQhxCMXKCNOEKHTf4NnyQ@mail.gmail.com>
Subject: Re: [PATCH 02/21] PCI: Add API to track PCI devices preserved across
 Live Update
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Lukas Wunner <lukas@wunner.de>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alex Williamson <alex@shazbot.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Philipp Stanner <pstanner@redhat.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <shuah@kernel.org>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, 
	Yi Liu <yi.l.liu@intel.com>, Yunxiang Li <Yunxiang.Li@amd.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>, =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 2, 2025 at 10:19=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Tue, Dec 02, 2025 at 08:36:53PM +0400, Chris Li wrote:
>
> > Jason, please correct me if I am wrong. My understanding is that not
> > only the device that is actively doing the DMA requires the bus number
> > to stay the same, I think all the parent bridge, all the way to the
> > root PCI host bridge, bus number must remain the same. After all, the
> > DMA will need to route through the parent bridges.
>
> The completions need to route back through the parent bridges, so yes
> you cannot do anything to disturb RID based routing in the active
> fabric either, with also means few changes to the subordinate bus
> range of any bridge are possible.

Thank you Jason for the confirmation.

Lukas, that means if we are using the path, we will need to save the
bus number along each path node. Different liveupdate devices might
share the parent bridges, we might want to de-duplicate that. Then you
end up with something very similar to the BDF design, where the path
part is just redundant if you have BDF.

That is what I mean previously, using the BDF has the same protections
as path design, just simpler.

Chris

