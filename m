Return-Path: <kvm+bounces-24535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FA55956E9B
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 17:20:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF10F282E7C
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 15:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85A5C3CF73;
	Mon, 19 Aug 2024 15:20:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA043AC2B
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 15:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724080846; cv=none; b=meGkwWg6Xdc694Uii2cMUJKkv29+VYlig/iN+YQZ480cJ5p97ZjwziYaLOEU2hhUGfQRRssPTv4DQ6R/6oSL7odykIu3CSjk7nlFeOxVgbhTAzVppi1rpR0ZQZ59Bh2R64AzsjCsgjWFvrIDgece+SWW8XO/Cjf0bnbR5OtPV3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724080846; c=relaxed/simple;
	bh=H/iWQbOFtHgMP/wqC5TO2211vKyUB5vV7KL+6O6khxE=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=HnZCAmHO/0wKw78ACcnad1iwtzkHk9CNRKWvAc+bFHP24vNnl7GdUTzt4dDKOYjSniQ4IN7sq1TVEZEECuIOba1wGhJsW1xCihrwmNSTpsNQMqsPoBkPTMA0CDbVbf85pSYqbifaqLtyaTbeKdLTo6BbL0lmsRED1jqkyiN3Mjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WnblM07hrz20m3K;
	Mon, 19 Aug 2024 23:15:59 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id A88581A0188;
	Mon, 19 Aug 2024 23:20:38 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 19 Aug 2024 23:20:37 +0800
Subject: Re: [PATCH] KVM: arm64: vgic: Don't hold config_lock while
 unregistering redistributors
To: Marc Zyngier <maz@kernel.org>
CC: <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton
	<oliver.upton@linux.dev>
References: <20240819125045.3474845-1-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <b3e2e05b-7ce1-5bf6-f400-c0dff652796c@huawei.com>
Date: Mon, 19 Aug 2024 23:20:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240819125045.3474845-1-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/8/19 20:50, Marc Zyngier wrote:
> We recently moved the teardown of the vgic part of a vcpu inside
> a critical section guarded by the config_lock. This teardown phase
> involves calling into kvm_io_bus_unregister_dev(), which takes the
> kvm->srcu lock.
> 
> However, this violates the established order where kvm->srcu is
> taken on a memory fault (such as an MMIO access), possibly
> followed by taking the config_lock if the GIC emulation requires
> mutual exclusion from the other vcpus.
> 
> It therefore results in a bad lockdep splat, as reported by Zenghui.
> 
> Fix this by moving the call to kvm_io_bus_unregister_dev() outside
> of the config_lock critical section. At this stage, there shouln't
> be any need to hold the config_lock.
> 
> As an additional bonus, document the ordering between kvm->slots_lock,
> kvm->srcu and kvm->arch.config_lock so that I cannot pretend I didn't
> know about those anymore.
> 
> Fixes: 9eb18136af9f ("KVM: arm64: vgic: Hold config_lock while tearing down a CPU interface")
> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Tested-by: Zenghui Yu <yuzenghui@huawei.com>

Thanks,
Zenghui

