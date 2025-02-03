Return-Path: <kvm+bounces-37131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DEADA26032
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 17:34:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FB1D3A3D04
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 16:34:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6C9A20B202;
	Mon,  3 Feb 2025 16:34:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76E6720A5F3;
	Mon,  3 Feb 2025 16:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738600452; cv=none; b=gj0rWEwziBBQLKsB30E5Vh+PXfwTiTNdoPSJOAVmYvp/eIM5G55RjW674wpwdA/6MgiM0blLgMoxeIDyhLGGlQIncEdX60H9SBfWFcWxuSnNnzctvekxXn0ELfcaKniwI6FRDv/OKJmrMGw41NYdm3phHkqVr8rO/fbSGefPecs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738600452; c=relaxed/simple;
	bh=xmTlJAf6RcgxqGdekD+r6mqJGPLK+9Tws4cnQWJfuF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AbDxn5vbaOyLWhqUGby3+A+jFXJHyBKyr5OsdD2YbrAt54ZtUd5EFU71LKcMstQsL1LhmSAfwvqOqM7EIb3PyonWuhIIcoFDgjNNMPaN9bzWGPGNlUEA27R1GTksCWvAOzZMeXm55WkD4h2eIfyPCO4RHyYw9Wpb88ME/nbsW8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DDD3D11FB;
	Mon,  3 Feb 2025 08:34:33 -0800 (PST)
Received: from [10.1.34.25] (e122027.cambridge.arm.com [10.1.34.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 71D883F63F;
	Mon,  3 Feb 2025 08:34:05 -0800 (PST)
Message-ID: <38e5705c-5a78-48cc-8af5-b7c5491283af@arm.com>
Date: Mon, 3 Feb 2025 16:34:03 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 17/43] arm64: RME: Handle realm enter/exit
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-18-steven.price@arm.com>
 <18faf27b-f430-4e68-9122-28f439d3bbbd@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <18faf27b-f430-4e68-9122-28f439d3bbbd@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 29/01/2025 23:41, Gavin Shan wrote:
> On 12/13/24 1:55 AM, Steven Price wrote:
[...]
>> +
>> +    kvm_pr_unimpl("Unsupported exit reason: %u\n",
>> +              rec->run->exit.exit_reason);
> 
> s/kvm_pr_unimpl/vcpu_pr_unimpl

It's vcpu_unimpl(), but sadly that attempts to print 'RIP' which is x86
specific (and would be nonsense for a realm guest anyway).

The other s/kvm_err/vcpu_err/ changes all make sense.

Thanks,
Steve


