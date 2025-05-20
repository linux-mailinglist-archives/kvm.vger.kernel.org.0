Return-Path: <kvm+bounces-47124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B2CFABD90E
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 15:13:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF4397AF2A7
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 13:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0870F22DA14;
	Tue, 20 May 2025 13:12:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C6CC22D9E6;
	Tue, 20 May 2025 13:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747746766; cv=none; b=eayDy7ejoSSzu3OJZBGV5XlsWdzkIkwXIw++6BoF7dNEY0kKRwVL8xFyD7CWHWFmnHowieG1S2t6bol0UWUifTUf8iy2eEZP07CXBNqHXSw7opo2wBSGD7EBblHQJ8odl7ESOfQ2oU3oE7uABps8WO+rfXw3Gk2Pa1VM2/L3vm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747746766; c=relaxed/simple;
	bh=nMxrgnRlDfZGHTgmQAG3Jih8BkYeNq8lzmY01Yp3swc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i9O7nCouyzrZ3+vps+Mie6jyFSPLNnthNNRwiFKKy1Z/PnS2Sk07JHjT2hz1W+DKpop51GXziu5iKB5wnzuWFPq2UoDgy9/fl2KsiVEFmjLbvhTe8bW8zihAd+Q6J3L39OyTSeEH77+Lus4aM49WmxPet7qiNdQxn2zWohn2y1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EBEB81516;
	Tue, 20 May 2025 06:12:30 -0700 (PDT)
Received: from [10.1.36.74] (Suzukis-MBP.cambridge.arm.com [10.1.36.74])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1492D3F5A1;
	Tue, 20 May 2025 06:12:40 -0700 (PDT)
Message-ID: <4dc9d854-c941-434a-b736-8d453618d8b6@arm.com>
Date: Tue, 20 May 2025 14:12:40 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 43/43] KVM: arm64: Allow activating realms
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
 <20250416134208.383984-44-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20250416134208.383984-44-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/04/2025 14:42, Steven Price wrote:
> Add the ioctl to activate a realm and set the static branch to enable
> access to the realm functionality if the RMM is detected.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


