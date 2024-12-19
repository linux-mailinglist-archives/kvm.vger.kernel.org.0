Return-Path: <kvm+bounces-34114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE9D69F741D
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 06:44:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD1D7161EE2
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 05:44:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8238216E07;
	Thu, 19 Dec 2024 05:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BjVfWvvv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC531F8928;
	Thu, 19 Dec 2024 05:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734587062; cv=none; b=BOZDODb7STDjcss003CDkTgfCGiKfMdBnRiCc1WyFcE+sPNQ2B4oz1jJuVWDbcwykAx9heqD3vOWMeFo5KcFQfKJwXESoHaSnojhffGgH8OgfXThoDmcuuFqrY9NgaGbllTGnwpetag7pRDhiTti0qjSB62Rp3LBfoA88wA2Hgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734587062; c=relaxed/simple;
	bh=m7ocr98t3oyh92KXRsmsznyxYlJ215FpJvwh6l7erm8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=CLcciJOYCz1M4Jhyq+vvc/UeSf/thtRQigo11gvrAcHF9triVvpA76v3arXOJKHZTk1EzkmjV5S3r2Cb+BQOIUY+TIAf94Ue8Uy72zhmtaeyM4LQQAv/67MlKTgU2oYBFlozSOAlSHd2nAD8v4MiTY2wrm6k3lanEjM2CLbS2ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BjVfWvvv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB43C4CECE;
	Thu, 19 Dec 2024 05:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734587061;
	bh=m7ocr98t3oyh92KXRsmsznyxYlJ215FpJvwh6l7erm8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=BjVfWvvvHa+/pGTdjhx/7ve8T3J8fdMlct7OCGrv3VjwPDZo882AEfCsyyn9KLT5F
	 VwUE0TB2yFK/xZ7IYv0ccsYQyvejLAYSTPimBgiU3SuPJeoijUmEofqwcOsturJ1xj
	 lY88i7BWB4zlhL1kZ+ITFJO6D0Ch4O/8AmyoFDtLhVDwUuUlvypQybmHvDHNAsR3C6
	 xz+WjeZ8pTeo3rGMvX6MaB17Z3dgkQma5OI58hRmyBjYPLPAzOEC73U7E/j8DRNIYg
	 0PPAAIcy/qD2IeGlowkWjY6i9hdeG627xLVCyU/GfGSWtUqmxIliYQIL3Sot/eicie
	 coNTBnvDIBDSA==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v6 06/43] arm64: RME: Check for RME support at KVM init
In-Reply-To: <20241212155610.76522-7-steven.price@arm.com>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-7-steven.price@arm.com>
Date: Thu, 19 Dec 2024 11:14:09 +0530
Message-ID: <yq5amsgsrzva.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

> +static int rmi_check_version(void)
> +{
> +	struct arm_smccc_res res;
> +	int version_major, version_minor;
> +	unsigned long host_version = RMI_ABI_VERSION(RMI_ABI_MAJOR_VERSION,
> +						     RMI_ABI_MINOR_VERSION);
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_VERSION, host_version, &res);
> +
> +	if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
> +		return -ENXIO;
> +
> +	version_major = RMI_ABI_VERSION_GET_MAJOR(res.a1);
> +	version_minor = RMI_ABI_VERSION_GET_MINOR(res.a1);
> +
> +	if (res.a0 != RMI_SUCCESS) {
> +		kvm_err("Unsupported RMI ABI (v%d.%d) we want v%d.%d\n",
> +			version_major, version_minor,
> +			RMI_ABI_MAJOR_VERSION,
> +			RMI_ABI_MINOR_VERSION);
> +		return -ENXIO;
> +	}
> +
> +	kvm_info("RMI ABI version %d.%d\n", version_major, version_minor);
> +
> +	return 0;
> +}
> +

Should we include both high and low version numbers in the kvm_err
message on error? ie,

	high_version_major = RMI_ABI_VERSION_GET_MAJOR(res.a2);
	high_version_minor = RMI_ABI_VERSION_GET_MINOR(res.a2);

-aneesh

