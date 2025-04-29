Return-Path: <kvm+bounces-44768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4F96AA0D05
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 15:10:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA0C27B4401
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 13:08:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E74B52D026B;
	Tue, 29 Apr 2025 13:08:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 184092D027F
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 13:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745932085; cv=none; b=JKmqykHxmveYOFRaAFTT51SEg19klUDMvxuZfxU2H4V0o4A+q9U64OiqbYjbdnwKHiZrrR/9yUIAgu138LQZ498SZBntPrVy3GQUiWjwo1rE8nik6lHoU7NmopeDmbIplHSFw4vtz4+/HvBdYOU5mR2lYi3sn3Xza1SrlY5iNpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745932085; c=relaxed/simple;
	bh=sHSAKLk6vJgYBfs8Wea0jcRR9u54AMZojXLyQS0OGvs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YVvY8W5bVTh96j9/FP1oO0bsXrZHqfVB+Ob3mJCQUPZRmNDLYO+5YcrnLZVttaUVPIGQ7/dqAQCfORHdROHjMuMXses1y8V6OEbqdz4mQTW1uiMzXLLaCriadOtG8gZFmsFQyWUnw36vRDxtWDYirpLYkfYQBTm5mRCcC2FQhQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 985E71515;
	Tue, 29 Apr 2025 06:07:56 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C97793F673;
	Tue, 29 Apr 2025 06:08:01 -0700 (PDT)
Message-ID: <7488567a-804d-4769-8a49-a9170c6ab609@arm.com>
Date: Tue, 29 Apr 2025 14:08:00 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/42] KVM: arm64: Handle trapping of FEAT_LS64*
 instructions
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>,
 Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>
References: <20250426122836.3341523-1-maz@kernel.org>
 <20250426122836.3341523-18-maz@kernel.org>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <20250426122836.3341523-18-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc,

On 4/26/25 13:28, Marc Zyngier wrote:

> +	/*
> +	 * We only trap for two reasons:
> +	 *
> +	 * - the feature is disabled, and the only outcome is to
> +	 *   generate an UNDEF.
> +	 *
> +	 * - the feature is enabled, but a NV guest wants to trap the
> +	 *   feature used my its L2 guest. We forward the exception in
> +	 *   this case.
Nit: my -> by
> +	 *
> +	 * What we don't expect is to end-up here if the guest is
> +	 * expected be be able to directly use the feature, hence the
> +	 * WARN_ON below.
> +	 */


Thanks,

Ben


