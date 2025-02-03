Return-Path: <kvm+bounces-37132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D61AA26034
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 17:34:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F66C1885377
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 16:34:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7983320B7FC;
	Mon,  3 Feb 2025 16:34:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F05120AF99;
	Mon,  3 Feb 2025 16:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738600456; cv=none; b=iwlwfI5Fa0q5Y7ysjsqOWIk3Dg3rl29g8z3TILGxvEqL2s57TOhqaFbefYXRPXtDncStnhnEajEFNK+jOpHrLQZz805M3VCEJU37IbN9mrTh5s80h0V/wHFhO7BPIARmJ1OdLFlNgmxIECqnQITtQa3TxtGbNE1leWsHzv2fTK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738600456; c=relaxed/simple;
	bh=7SACX3zlcvRVcG4Azpho0nkzzpP1y3XRPlNeBocU8p0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OqiuJcOm4MJYG+F3Q0JRYbAAvTuENt2H23W9X4twSXYdZ1kpD5GsAN1fLzczo4VbTD2j6ZqGkJXWAXufjgpUAKny6SS7w/BQLBJuUo3d12TYrRF05pf9BuS/ZCYdZCRZtLr9xmBO+UUBCGxFyffdrbqp0uCuxYtuSKW6l5FUlqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C22371595;
	Mon,  3 Feb 2025 08:34:37 -0800 (PST)
Received: from [10.1.34.25] (e122027.cambridge.arm.com [10.1.34.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD43B3F63F;
	Mon,  3 Feb 2025 08:34:09 -0800 (PST)
Message-ID: <9d9bfaca-1cba-4e33-9aa6-b840f5c1da2c@arm.com>
Date: Mon, 3 Feb 2025 16:34:04 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 12/43] arm64: RME: Allocate/free RECs to match vCPUs
To: Suzuki K Poulose <suzuki.poulose@arm.com>, Gavin Shan <gshan@redhat.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-13-steven.price@arm.com>
 <9a543b6f-5487-4159-89fb-73d9b6749a01@redhat.com>
 <9174bc24-6217-4663-a370-291d4790a212@arm.com>
 <d499c3e7-cc0f-467a-8401-bc53b70259f7@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <d499c3e7-cc0f-467a-8401-bc53b70259f7@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 03/02/2025 11:18, Suzuki K Poulose wrote:
> On 30/01/2025 16:40, Steven Price wrote:
>> On 29/01/2025 04:50, Gavin Shan wrote:
[...]
>>> One corner case seems missed in kvm_vcpu_init_check_features(). It's
>>> allowed to
>>> initialize a vCPU with REC feature even kvm_is_realm(kvm) is false.
>>> Hopefully,
>>> I didn't miss something.
>>
>> Ah, yes good point. I'll pass a kvm pointer to
>> kvm_vcpu_init_check_features() and use kvm_is_realm() in there.
> 
> nit: kvm is available from the VCPU via vcpu->kvm

Absolutely correct, and what I wrote was nonsense ;)

What I meant was to pass a kvm pointer *from*
kvm_vcpu_init_check_features() *to* system_supported_vcpu_features() and
use kvm_is_realm() in there!

Thanks,
Steve


