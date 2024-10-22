Return-Path: <kvm+bounces-29381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A35719AA0D1
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 13:07:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 655E32849FC
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 11:07:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 764DA19AD8D;
	Tue, 22 Oct 2024 11:06:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEA518BBA9;
	Tue, 22 Oct 2024 11:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729595216; cv=none; b=pF/iH4blcxs5ndKJTF2sv7r088cepVIB3WH+x8YziILGE1AbJjES+ngSm6swi5PNi+oE2EDraI6U96Wdeg4jjHBXBqiz+eXRt9HUIkrvRleSzw1eH0y//hlxM+Wt2jlWhBc/yW9zEiJDWt9bt85blpzgefKtVTZxXTTLjB1GzQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729595216; c=relaxed/simple;
	bh=v7P5/7qk7UApYxhUS6nF0cmNQ91ZhvIbcS2flDvVIFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W1j4F/NH6AGBSJDoXoHYqLMaM9y40kUEmpDzju/1cyP3rvnqGhzac4A+5gIwbwdeFmDayKflwOdQcD62eHzInUBFY8/B5jGN5yTFbthcnjuUpJE5XYX18kc1nYhs1FOztC8iTMmnZerzi7wdcagzG2XT9QmADpo3/w5XarxDF+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4C3C4CEC3;
	Tue, 22 Oct 2024 11:06:51 +0000 (UTC)
Date: Tue, 22 Oct 2024 12:06:49 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>, Gavin Shan <gshan@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Sami Mujawar <sami.mujawar@arm.com>, Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	Dan Williams <dan.j.williams@intel.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: Re: [PATCH v7 10/11] virt: arm-cca-guest: TSM_REPORT support for
 realms
Message-ID: <ZxeHSdpxocFA-SrO@arm.com>
References: <20241017131434.40935-1-steven.price@arm.com>
 <20241017131434.40935-11-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017131434.40935-11-steven.price@arm.com>

On Thu, Oct 17, 2024 at 02:14:33PM +0100, Steven Price wrote:
> From: Sami Mujawar <sami.mujawar@arm.com>
> 
> Introduce an arm-cca-guest driver that registers with
> the configfs-tsm module to provide user interfaces for
> retrieving an attestation token.
> 
> When a new report is requested the arm-cca-guest driver
> invokes the appropriate RSI interfaces to query an
> attestation token.
> 
> The steps to retrieve an attestation token are as follows:
>   1. Mount the configfs filesystem if not already mounted
>      mount -t configfs none /sys/kernel/config
>   2. Generate an attestation token
>      report=/sys/kernel/config/tsm/report/report0
>      mkdir $report
>      dd if=/dev/urandom bs=64 count=1 > $report/inblob
>      hexdump -C $report/outblob
>      rmdir $report
> 
> Signed-off-by: Sami Mujawar <sami.mujawar@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v6:
>  * Avoid get_cpu() and instead make the init attestation call using
>    smp_call_function_single(). Improve comments to explain the logic.
>  * Minor code reorgnisation and comment cleanup following Gavin's review
>    (thanks!)

Gavin, since most changes in v7 are based on your feedback, do you have
any more comments on this patch? I plan to push this series into -next
fairly soon.

Thanks.

-- 
Catalin

