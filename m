Return-Path: <kvm+bounces-47118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EEF54ABD874
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 14:48:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D01444A7883
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 12:48:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64B251D7999;
	Tue, 20 May 2025 12:48:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F6341A5BBE;
	Tue, 20 May 2025 12:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747745309; cv=none; b=Tsfps06ByV80Nd2FwGINq9WMFPRPvEfJAq3nYQmtNNA/xGTjwiC0rkBi8WGOyDXK0mHwhp4OFTmciqspa/ZDOlJoigumygoMOH7fAvRBt6w1GPFqEfSxk6ae6EXcN5ytvSWbPxElJoTT8Y6GPxtXhnVFr6muyiMNHRsEH0DNWe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747745309; c=relaxed/simple;
	bh=Q54ESb5TkHZjpeeUYH9Du5AoLX2a+t29iwcjsyIfM9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oFdobfK6ABZpTW0a+kZT7NAEfGgPM+C/lxjHlZOFC7dH7IcZRJkdEOzKFMpmZr3Z2nVWlsVGcYXl9Sa2v78z2cnfAcmt6/8r8pkfjoqjeWanGxHNl/9YEZuxZ2qvgCU1j9tJC39Y+RT9wH9IgKX1F0458yW+nkPdwbbYHt74w0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 272E41516;
	Tue, 20 May 2025 05:48:13 -0700 (PDT)
Received: from [10.1.36.74] (Suzukis-MBP.cambridge.arm.com [10.1.36.74])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 21F103F5A1;
	Tue, 20 May 2025 05:48:22 -0700 (PDT)
Message-ID: <210c6f71-68da-4226-8a60-bbedb014628f@arm.com>
Date: Tue, 20 May 2025 13:48:22 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 35/43] arm64: RME: Set breakpoint parameters through
 SET_ONE_REG
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
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
 <20250416134208.383984-36-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20250416134208.383984-36-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/04/2025 14:41, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> Allow userspace to configure the number of breakpoints and watchpoints
> of a Realm VM through KVM_SET_ONE_REG ID_AA64DFR0_EL1.
> 
> The KVM sys_reg handler checks the user value against the maximum value
> given by RMM (arm64_check_features() gets it from the
> read_sanitised_id_aa64dfr0_el1() reset handler).
> 
> Userspace discovers that it can write these fields by issuing a
> KVM_ARM_GET_REG_WRITABLE_MASKS ioctl.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>



