Return-Path: <kvm+bounces-47831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 89706AC5D9E
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 01:05:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34C0C1889A9D
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 23:05:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE6A321771A;
	Tue, 27 May 2025 23:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SmBEXbMm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECF1D531
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 23:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748387123; cv=none; b=b/kqM/4Klt3QX2tHtdD1Ex5BgEld0+w3Cw+CSP/u16INaH+DZDJjIrRJ9mIdacsleoKlSyZVtxCCnulkcFRwjifI0GbQ7XyQg7Nc3hIa/+TnpDuy4dubcq1X43PJzw8OKjU7GSv16XotECsj4VAVXqJNBX7wjZzWbuEsIQqfeiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748387123; c=relaxed/simple;
	bh=XBTb+b+ldsUTYlGfsh2AecYSih2/2OJk4HBDSA25zYU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ACgUA+nS6noulVJ5Dk77DqkHtovwIywUMJwvq8lspRRL0Eds1yb2T68xei8GQueg0S5+5/EsQHpeLLwo3XEMRr3/RpP8gKHZK+5kORwzKdajUZeAYl3ntmd8o8ybzNls5J/k91IBVRwP53GNz94KlplHX2J8LnbCu6Q5sCbooQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SmBEXbMm; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-552206ac67aso4757286e87.2
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 16:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748387119; x=1748991919; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QuHJor9+bQ607wqyxrjYZBMYzKvn8dtESweSPu5Q+fM=;
        b=SmBEXbMmnnVxmKcw+1+EA2VjDE98sw9C7+CjdtK1DwLPI5CiGf3yAkMJwksqFet82o
         5skG5DKAUIWIpEldGYjC5JIIZctjsqvbcfz8Mq47q2MItTNJU/7O3Ls5ba5ZpM7QYvAK
         LusZknIb0rkrzDP6EusXfjmzfEJaOqRirKqelZWnUX6WuGdSEgMktIhbjYphqxpSAJ6c
         /qdGnJoty/eWpL2o3v6SI8kjVkyRvlILV5CaRNv4bivz5yTguFvDoUsOGGuQ6n5JNuZJ
         TdhzPe3YXN/yAU9O/3oV3titT4w7k1u0KEPnIK+Gi5aWTOodEhV+Bc41ZRycJNrtj475
         wNiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748387119; x=1748991919;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QuHJor9+bQ607wqyxrjYZBMYzKvn8dtESweSPu5Q+fM=;
        b=o1p/Or/wfrVlMWAacxDDO86/Okskb4Ke1vDr76PkIKp0i1BWCl6nAMDVqOUBiSqZyf
         ua0d3JkYk3AREa/Z7LXN0sbW0dD6iREJ04OMh+RXXG/bnYS8SssIER/XtzpqfWLnMq8D
         5pGFg2boYUmV2Q+vRQAVK2Ki2hoUxRIseH8hvhxFD7msUyYPJCEcNj7AcCCvjz/kIxez
         iOaHSoJy9mkP/IiJ7QVgfzrnU1REfilPnYgW2+qCqPkfJQBrZ+D3gB1jJRpK2bUaSrf3
         6RdOTIwUoXXF8C2p8TGSN16xTjpsbmhDpLFl82z2GdBOtPwN/tK4si0mkHkq4QxLBVLD
         gcgQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAqSp+8qgpeoCcqUN5kW/U+ZowYmI0B0hdBOG8ChiImgEXJQ1rzg2Lc2dA4d51DJMqsyo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLY2VmFlPGADFmVDsCPi3+kMv+WOKataUc4nxS99uD1Xc0NXXD
	LNC52zkapiYv62lr1jFgTVW/MfKwyL00KbQLbypxufn4RfWUUT+lmE3BBj1ga7JAPsH+JYGGHpu
	jbfsq9Q5w/aQC84MDeXy/kagB/Y3w3scRFOvWFy2c
X-Gm-Gg: ASbGncuEgBQmm6fkSPgQDyTu1tgyxhFh8zn4uknzAxdE92jELYPTUCKApnNBjiTvMSa
	9ZciE4AQmLRzyjYh5vWupL5mXlFmujgLpEtuBZROoT5Y8G1Eyi1cLX1+nc7RX/SrpNdyGzK3K9v
	08cZX7mzYwqUQDEY97e92Y0gY0FLGW1fXLQHSMU6YvS8o=
X-Google-Smtp-Source: AGHT+IGg9ccBEPW/d2OzGTiBOwTcGsKM3NfeE7zC0N6Vbkc6ZP/+f/3gAXRuC5OI0O2p9ds9Q535uewDSijkUqngi+Y=
X-Received: by 2002:a05:6512:3a94:b0:553:252f:adf3 with SMTP id
 2adb3069b0e04-553252faf51mr2393892e87.16.1748387119176; Tue, 27 May 2025
 16:05:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250523233018.1702151-1-dmatlack@google.com> <20250523233018.1702151-9-dmatlack@google.com>
 <20250526171625.GF61950@nvidia.com>
In-Reply-To: <20250526171625.GF61950@nvidia.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 27 May 2025 16:04:51 -0700
X-Gm-Features: AX0GCFtqlx310ZBq_KZXeMWwJ8mS2pCKacGCt2_kuJm07qFDJCZPZO8cRWVe5Zg
Message-ID: <CALzav=ewSn9c3aWTFjvLSenkhwS=fMndLDoF9=L5Bv6kJ+6tLw@mail.gmail.com>
Subject: Re: [RFC PATCH 08/33] vfio: selftests: Validate 2M/1G HugeTLB are
 mapped as 2M/1G in IOMMU
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Vinod Koul <vkoul@kernel.org>, 
	Fenghua Yu <fenghua.yu@intel.com>, "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, Jiri Olsa <jolsa@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Wei Yang <richard.weiyang@gmail.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Takashi Iwai <tiwai@suse.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, WangYuli <wangyuli@uniontech.com>, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Eric Auger <eric.auger@redhat.com>, 
	Josh Hilke <jrhilke@google.com>, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	Kevin Tian <kevin.tian@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Parav Pandit <parav@nvidia.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Vinicius Costa Gomes <vinicius.gomes@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2025 at 10:16=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> w=
rote:
>
> On Fri, May 23, 2025 at 11:29:53PM +0000, David Matlack wrote:
> > From: Josh Hilke <jrhilke@google.com>
> >
> > Update vfio dma mapping test to verify that the IOMMU uses 2M and 1G
> > mappings when 2M and 1G HugeTLB pages are mapped into a device
> > respectively.
> >
> > This validation is done by inspecting the contents of the I/O page
> > tables via /sys/kernel/debug/iommu/intel/. This validation is skipped i=
f
> > that directory is not available (i.e. non-Intel IOMMUs).
> >
> > Signed-off-by: Josh Hilke <jrhilke@google.com>
> > [reword commit message, refactor code]
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  .../selftests/vfio/vfio_dma_mapping_test.c    | 126 +++++++++++++++++-
> >  1 file changed, 119 insertions(+), 7 deletions(-)
>
> FWIW, I'm thinking to add an iommufd ioctl to report back on the # of
> PTEs of each page size within a range. This would be after we get the
> new page table stuff merged.

Thanks for the heads up. We are using Intel DebugFS because it's
available and better than nothing, but a generic way to validate
mappings sizes would be way better.

