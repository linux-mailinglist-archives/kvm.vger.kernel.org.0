Return-Path: <kvm+bounces-15806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 43AE98B0AD4
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 15:28:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D73C61F2278C
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 13:28:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD06315D5C9;
	Wed, 24 Apr 2024 13:27:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F07FB15CD51;
	Wed, 24 Apr 2024 13:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713965267; cv=none; b=NMwjNj9UXuRUDAGkOYfOypAYd3oiu6FCKxX4l5iXvCdvQixS3TE44E78NKMyqcg8QkmO1j9VMQ6DnQqeyUnN6LVQ4/U3yP/Efqih0xwnJ8k3E48dPYHyQ+7y7aTNJAToYpTZbG0DqwWpFDKemKxTFtoGzKJkRsmT9XaqNgeg1yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713965267; c=relaxed/simple;
	bh=RHRNpt1GrdBK2G7+COQrLb3IEKD0I7+HfEEcq1CkGtk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j8x3mLOl7QuABUxWIwIzRbS5UkvAphZNdY5zJkz+DluuJ+7dZYhSQw4zxDj4Uf+NvqKdtHyUuGR2NY57QK5I0r6GOMAjdRaQNlK16QQVebsfFj55iE/xDhhXxEKAhn1/8dAVUI/Qbn3f4ZOyHZ5n52frEkAvAzV6DEM0pQWL0wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 190582F;
	Wed, 24 Apr 2024 06:28:13 -0700 (PDT)
Received: from [10.57.86.198] (unknown [10.57.86.198])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DCF6A3F64C;
	Wed, 24 Apr 2024 06:27:42 -0700 (PDT)
Message-ID: <7c6504dd-ebef-4809-9e1d-7151db647e2a@arm.com>
Date: Wed, 24 Apr 2024 14:27:41 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/14] virt: arm-cca-guest: TSM_REPORT support for
 realms
Content-Language: en-GB
To: Thomas Fossati <thomas.fossati@linaro.org>,
 Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Sami Mujawar <sami.mujawar@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-15-steven.price@arm.com>
 <CA+1=6ydMVk4Vcouc2ag8G7tfqZy80VWFxWHSHEKF1JaABd=A7A@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+1=6ydMVk4Vcouc2ag8G7tfqZy80VWFxWHSHEKF1JaABd=A7A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/04/2024 14:06, Thomas Fossati wrote:
> Hi Steven, Sami,
> 
> On Fri, 12 Apr 2024 at 10:47, Steven Price <steven.price@arm.com> wrote:
>> +/**
>> + * arm_cca_report_new - Generate a new attestation token.
>> + *
>> + * @report: pointer to the TSM report context information.
>> + * @data:  pointer to the context specific data for this module.
>> + *
>> + * Initialise the attestation token generation using the challenge data
>> + * passed in the TSM decriptor.
> 
> Here, it'd be good to document two interesting facts about challenge data:
> 1. It must be at least 32 bytes, and
> 2. If its size is less than 64 bytes, it will be zero-padded.

Agreed !

Suzuki

> 
> cheers!


