Return-Path: <kvm+bounces-20884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A4503924FF4
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 05:52:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E592EB2175C
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 03:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DF8C17C79;
	Wed,  3 Jul 2024 03:52:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CBF524C
	for <kvm@vger.kernel.org>; Wed,  3 Jul 2024 03:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719978733; cv=none; b=KdAWOeJIaif28NZaaPauj6zRh1G19A95FP20RCB/r3cIp+vsSW0Y+HPRi8KMjXmUymXXtRATfDQ0V/Qmliv4GZxMyRQT3n7Yg0xEghWq+02AEwHi6xrCluR8UZtIqy4c7eHHA/BmYuBG2PMpOvAZb1L/+GA/0F7Rln5eTNGOOT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719978733; c=relaxed/simple;
	bh=a1S8CeAk/2o6s5YwxLfhQi8giPnvxapLai7bGOVjZeo=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=HFVeY424iTbcRJ1Zlya6pwldnqCErfVpjFujdX0HguSnhl9xytJVnItz21b83+NairUjWfJLUW8ySFAl6o+g22FcNFMhOAtHTSoR5knNEm/M2y0UvaKOr86RBi3NRKkUaOaoGzhLtmjinoiPU1YioWc9VjCGQh8bsbttxgDxg9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WDQm63WvWzdg6V;
	Wed,  3 Jul 2024 11:50:30 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 7B56F140417;
	Wed,  3 Jul 2024 11:52:07 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 3 Jul 2024 11:52:06 +0800
Subject: Re: [kvm-unit-tests PATCH v1 2/2] arm/mmu: widen the page size check
 to account for LPA2
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
CC: <pbonzini@redhat.com>, <drjones@redhat.com>, <thuth@redhat.com>,
	<kvm@vger.kernel.org>, <qemu-arm@nongnu.org>,
	<linux-arm-kernel@lists.infradead.org>, <christoffer.dall@arm.com>,
	<maz@kernel.org>, Anders Roxell <anders.roxell@linaro.org>, Andrew Jones
	<andrew.jones@linux.dev>, Alexandru Elisei <alexandru.elisei@arm.com>, Eric
 Auger <eric.auger@redhat.com>, "open list:ARM" <kvmarm@lists.linux.dev>
References: <20240702163515.1964784-1-alex.bennee@linaro.org>
 <20240702163515.1964784-3-alex.bennee@linaro.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <28936f0c-5745-14b3-1ecf-ae1e01c5b28f@huawei.com>
Date: Wed, 3 Jul 2024 11:52:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240702163515.1964784-3-alex.bennee@linaro.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600007.china.huawei.com (7.193.23.208)

Hi Alex,

[ Please don't send patches to the old kvmarm@lists.cs.columbia.edu as
it had been dropped since early 2023. [1] ]

On 2024/7/3 0:35, Alex Bennée wrote:
> If FEAT_LPA2 is enabled there are different valid TGran values
> possible to indicate the granule is supported for 52 bit addressing.
> This will cause most tests to abort on QEMU's -cpu max with the error:
> 
>   lib/arm/mmu.c:216: assert failed: system_supports_granule(PAGE_SIZE): Unsupported translation granule 4096
> 
> Expand the test to tale this into account.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Cc: Anders Roxell <anders.roxell@linaro.org>

There's a similar patch on the list [2], haven't been merged in master
though.

[1] https://git.kernel.org/torvalds/c/960c3028a1d5
[2] 
https://lore.kernel.org/all/20240402132739.201939-6-andrew.jones@linux.dev

