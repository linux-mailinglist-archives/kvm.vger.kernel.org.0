Return-Path: <kvm+bounces-45215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D2B40AA71A4
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 14:22:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3037B18963E4
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 12:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1371722578C;
	Fri,  2 May 2025 12:22:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B09126ACD;
	Fri,  2 May 2025 12:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746188533; cv=none; b=ZwwAAj/OwOCrTrRRo4wS6/j8KM2l8PvDlKhXkMnrvdIw/lArmjF33lffWuhfHECOGVCgn3JGZMMoEDg82wD/c/xU9wKume5xEz8E+1keRoUsUpHIcRbZ7mVJrXxNXTy6Ii2r3Fa9a83Trd0F1kXkaXYRnNhwuiWaUiXD7zfKB3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746188533; c=relaxed/simple;
	bh=O4Gi99HUOZW7VlZDDoVEwefLFLqL+5EO0IaEpxAND0g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iGEFAoKmnHoPMMO2DzgT9tTOVxJxoGQbn2m/LgiCRfgHThOMITiC/239TYnBLT55DDgmer7DVgetMxNp4J1T55B5agOpT7rMUUAxG5JZhrkQcylqFfTMKY5H6AhPyKHkFPQF7TT6uylAJJG1AAwWfsGhWLcMbL8UadryXlAmiVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9F1011688;
	Fri,  2 May 2025 05:22:01 -0700 (PDT)
Received: from [10.57.43.85] (unknown [10.57.43.85])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 05DD23F673;
	Fri,  2 May 2025 05:22:05 -0700 (PDT)
Message-ID: <6e46b358-5be9-4bbd-b66c-4a911db655f8@arm.com>
Date: Fri, 2 May 2025 13:22:04 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 14/43] KVM: arm64: Support timers in realm RECs
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-15-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20250416134208.383984-15-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/04/2025 14:41, Steven Price wrote:
> The RMM keeps track of the timer while the realm REC is running, but on
> exit to the normal world KVM is responsible for handling the timers.
> 
> The RMM doesn't provide a mechanism to set the counter offset, so don't
> expose KVM_CAP_COUNTER_OFFSET for a realm VM.
> 
> A later patch adds the support for propagating the timer values from the
> exit data structure and calling kvm_realm_timers_update().
> 
> Signed-off-by: Steven Price <steven.price@arm.com>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

