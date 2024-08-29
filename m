Return-Path: <kvm+bounces-25339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CE2A96410F
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 12:15:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 000C1B21839
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 10:15:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6324118E35D;
	Thu, 29 Aug 2024 10:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FIt/zQ5o"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8514718E050;
	Thu, 29 Aug 2024 10:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724926506; cv=none; b=t5rAsCpUJ9Y6JKi/rWwvwbzZrRY3CvmbqewpCbeHjR+bDwg3TkiHrYX9uorjb1sq0iduGNyX9skBhvhl3imPZoLzO80Mm0+ZhQ6YdkOleb787FlE+BTIvroUSJvSxqru7U/WObPypgQZ6c8AveAhFpjJ3XqBp6amn5APGwjwhlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724926506; c=relaxed/simple;
	bh=ja3k5hFICUQ46VNR/0UCHIUMXdkpQSTHbdMOS3QfItE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A5W215LmtIfmcsDvA29SL9JWXlYyBazC4xHMUzLZJfngDW/H3hNgecm60uhvv4zOKRQ2/tkgy3ba+9EIr/NXQhE04l1CqTdc7aUSTdh8vjB4DTqJ861yVf7u953m0Qb02j5ClfjtsFwgbf/OPqnRrHbGWALv3vLZWyhItcKV11g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FIt/zQ5o; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F355C4CEC5;
	Thu, 29 Aug 2024 10:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724926506;
	bh=ja3k5hFICUQ46VNR/0UCHIUMXdkpQSTHbdMOS3QfItE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=FIt/zQ5okD2OnX/3U8XS7YxcRyv/6TQL2fIHw3oVa+7i9XNpDlvrTH6MJhhynFpvA
	 8kQj4SB3cztOUNZa9JRRw9gh2PvNEEQVDOB8oDh05o1XOmsEP55g9YUaqG5iy3dBSB
	 ZoGkskxApKAmbm0Y+27J6zH6yHBa/OskT7ad6O6EMZWc77Ydr4uV6nqGIaTCclDI4X
	 qikL6ijv4YNUUNOuqxc0uyzD2dIiK5mfuK7Tqu2A1V+abeDFJor45fFHYrZGbKFgAv
	 twQaALgBV/m8ekSYddGfXGC6igdrgEY75bTlSYZYtGv4pmBbcRjLRAMGRgO+cjskev
	 VjTgrjgzVojTA==
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-5dc93fa5639so258799eaf.1;
        Thu, 29 Aug 2024 03:15:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUIsEvYjSxcoRWdyGL9+3sfvkgcEHKKkIBiC9kAhFBEFp8fZ2qPQGVtCG1dFtZCFJF57xo=@vger.kernel.org, AJvYcCUdjj7oV4gpnLXiKHqoj+xp6tdrPIC606RzGoXKeRZHDDx0PXhyfjuWknoMTHNQMmcEniswQOY6d7fYKA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxHuUv7ia/A7TsHDEtr0Aov8VFQaefUJTpNfFdvGPTXYzp84vBK
	aWW7aUo7/bLxsxQVvz0jvAPsP1deLowhrlF6ZbsgPI4PQAvgsTQGVIItr+5tpXRqK+1Ahhyy0JC
	m/AZRC7jCSENl0UBs6kpH9K7ssYM=
X-Google-Smtp-Source: AGHT+IH1iV6L1TGRMqY7jf4E7+LOi1yBY1y43SdO+ovsqtu6sddWwnbpbj08nm5SY9sGMdOM9bStbW37+fCJJzH/H0k=
X-Received: by 2002:a05:6820:1610:b0:5da:a462:6a30 with SMTP id
 006d021491bc7-5df97ebd7bdmr2719698eaf.1.1724926505401; Thu, 29 Aug 2024
 03:15:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com> <3-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <3-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Thu, 29 Aug 2024 12:14:54 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0hZKs8QkjA=JMYwaXpPm8kQM91WnyMNP2Mcyk7s51NfyQ@mail.gmail.com>
Message-ID: <CAJZ5v0hZKs8QkjA=JMYwaXpPm8kQM91WnyMNP2Mcyk7s51NfyQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] ACPICA: IORT: Update for revision E.f
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>, 
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>, 
	kvm@vger.kernel.org, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Robert Moore <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, 
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, 
	Alex Williamson <alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer <mdf@kernel.org>, 
	Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2024 at 5:51=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> From: Nicolin Chen <nicolinc@nvidia.com>
>
> ACPICA commit c4f5c083d24df9ddd71d5782c0988408cf0fc1ab
>
> The IORT spec, Issue E.f (April 2024), adds a new CANWBS bit to the Memor=
y
> Access Flag field in the Memory Access Properties table, mainly for a PCI
> Root Complex.
>
> This CANWBS defines the coherency of memory accesses to be not marked IOW=
B
> cacheable/shareable. Its value further implies the coherency impact from =
a
> pair of mismatched memory attributes (e.g. in a nested translation case):
>   0x0: Use of mismatched memory attributes for accesses made by this
>        device may lead to a loss of coherency.
>   0x1: Coherency of accesses made by this device to locations in
>        Conventional memory are ensured as follows, even if the memory
>        attributes for the accesses presented by the device or provided by
>        the SMMU are different from Inner and Outer Write-back cacheable,
>        Shareable.
>
> Link: https://github.com/acpica/acpica/commit/c4f5c083
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  include/acpi/actbl2.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
> index e27958ef82642f..9a7acf403ed3c8 100644
> --- a/include/acpi/actbl2.h
> +++ b/include/acpi/actbl2.h
> @@ -453,7 +453,7 @@ struct acpi_table_ccel {
>   * IORT - IO Remapping Table
>   *
>   * Conforms to "IO Remapping Table System Software on ARM Platforms",
> - * Document number: ARM DEN 0049E.e, Sep 2022
> + * Document number: ARM DEN 0049E.f, Apr 2024
>   *
>   ***********************************************************************=
*******/
>
> @@ -524,6 +524,7 @@ struct acpi_iort_memory_access {
>
>  #define ACPI_IORT_MF_COHERENCY          (1)
>  #define ACPI_IORT_MF_ATTRIBUTES         (1<<1)
> +#define ACPI_IORT_MF_CANWBS             (1<<2)
>
>  /*
>   * IORT node specific subtables
> --
> 2.46.0
>
>

