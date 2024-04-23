Return-Path: <kvm+bounces-15629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C9378AE12A
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 11:40:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0127C1F228D5
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 09:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FED75A11F;
	Tue, 23 Apr 2024 09:40:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601781E863;
	Tue, 23 Apr 2024 09:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713865232; cv=none; b=C1c5QOJzl37amBvpU3Cgf6giRFe1hiVC5t7UQLKmPwj8gzvnsYxb7Sy6/OfS8fiK9/SGbG5H1q/gyyMy5jL1U9vnZFFhaOQgs37HMvhgj9I8XtbfHVLgseN8yHnCOQq/0nJD9iEicSZctvvLwZqRxbDUhpLHi63pZpcTdvvY10c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713865232; c=relaxed/simple;
	bh=WSHzthjZepAMvwfbEx8NcTiLoGKmflWyRDbqNIWM2rE=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=btXoDEvjr+Pl0+ziyQGir00tXIAv0jZU5NH5TPCzV6xAls9eqCe4jWup7tSI7wHXV1xd3hHuGBG8KnaJUQAbosGp5+H2ztUu2qhdATeqaRkbvqMA1D5kYDBeGADXaU07gq/ZhBoZHMvjSvBUHcRrl4K7UHIw+FPlwA8ssEuCb4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VNxq31Cy8zwTVG;
	Tue, 23 Apr 2024 17:37:19 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id C3AB31403D4;
	Tue, 23 Apr 2024 17:40:28 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 23 Apr 2024 17:40:27 +0800
Subject: Re: [PATCH v4 12/15] KVM: arm64: nv: Add emulation for ERETAx
 instructions
To: Jon Hunter <jonathanh@nvidia.com>
CC: Marc Zyngier <maz@kernel.org>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>, James Morse
	<james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver
 Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, Fuad Tabba
	<tabba@google.com>, Mostafa Saleh <smostafa@google.com>, Will Deacon
	<will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20240419102935.1935571-1-maz@kernel.org>
 <20240419102935.1935571-13-maz@kernel.org>
 <14667111-4ad6-48d2-93ee-742c5075f407@nvidia.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <4c2fd210-fa36-8462-8a4d-70135cc2f040@huawei.com>
Date: Tue, 23 Apr 2024 17:40:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <14667111-4ad6-48d2-93ee-742c5075f407@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/4/23 17:22, Jon Hunter wrote:
> 
> Some of our builders currently have an older version of GCC (v6) and
> after this change I am seeing ...
> 
>    CC      arch/arm64/kvm/pauth.o
> /tmp/ccohst0v.s: Assembler messages:
> /tmp/ccohst0v.s:1177: Error: unknown architectural extension `pauth'
> /tmp/ccohst0v.s:1177: Error: unknown mnemonic `pacga' -- `pacga x21,x22,x0'
> /local/workdir/tegra/mlt-linux_next/kernel/scripts/Makefile.build:244: 
> recipe for target 'arch/arm64/kvm/pauth.o' failed
> make[5]: *** [arch/arm64/kvm/pauth.o] Error 1
> /local/workdir/tegra/mlt-linux_next/kernel/scripts/Makefile.build:485: 
> recipe for target 'arch/arm64/kvm' failed
> make[4]: *** [arch/arm64/kvm] Error 2
> /local/workdir/tegra/mlt-linux_next/kernel/scripts/Makefile.build:485: 
> recipe for target 'arch/arm64' failed
> make[3]: *** [arch/arm64] Error 2
> 
> 
> I know this is pretty old now and I am trying to get these builders
> updated. However, the kernel docs still show that GCC v5.1 is
> supported [0].

Was just looking at the discussion [1] ;-) . FYI there is already a
patch on the list [2] which should be merged soon.

[1] 
https://lore.kernel.org/r/CA+G9fYsCL5j-9JzqNH5X03kikL=O+BaCQQ8Ao3ADQvxDuZvqcg@mail.gmail.com
[2] https://lore.kernel.org/r/20240422224849.2238222-1-maz@kernel.org

Zenghui

