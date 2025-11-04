Return-Path: <kvm+bounces-61968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C732C30AF5
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 12:14:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E0A764E4901
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 11:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6B1C2E54B9;
	Tue,  4 Nov 2025 11:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="zbnfA3Re"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741042E426A
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 11:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762254832; cv=none; b=CCk1tcmAZFu9GaT2OKoS4vVzvLLCyahYDbHgQqJwJY4rBg8S7pb24kIhQtkpkqaoKaMgDPpcTvzYZ3tyJ7uxFOqKjf1uabQgVGM3KZRNihuskV20sgKoezM31dCAls3nDs5r3n0Fy/bHq5OMGtc2Q4ecLXF9v+r1xM1gdH9sbsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762254832; c=relaxed/simple;
	bh=4nVBl5r6hmuhvvbq9MpULBbT9ItrCt4YCDr9efMVybE=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ZPbELS4psN+CBYIE0G2l+lfJ389s4Miv8ZIWk5TNbZbT6iISTUwiLGj5vGihIJZG7NVfnBc+xT5O3O1ESzHGAtGjcCTupCRF+mYnjdaLlxifxEeV/p2Cwv6C9f1o818nrB2UNxyqfNOCXSWR1hF33wthmDmR9wp/iqGEvyZ7DRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=zbnfA3Re; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4nVBl5r6hmuhvvbq9MpULBbT9ItrCt4YCDr9efMVybE=;
	b=zbnfA3RezbrDNkzJJdE7pwbmng3YMVGS6Q5geiHWXqZ1ZZAgTPrgHz4KoS+Dys7sTiIwETiE4
	xIrEQ0x0B8NQ7+PNoNfBrnvPUrZXWlbVO/DkP0cZTQW2CKnXduyoyVVCdXp3EIWWfK+cpUfA5UX
	KJyEIVb/fmy0+I0Se2WiMKU=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4d15Q4535HzLlTr;
	Tue,  4 Nov 2025 19:12:12 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id 06F0C1A016C;
	Tue,  4 Nov 2025 19:13:47 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Nov 2025 19:13:46 +0800
Subject: Re: [PATCH 03/33] irqchip/apple-aic: Spit out ICH_MIDR_EL2 value on
 spurious vGIC MI
To: Marc Zyngier <maz@kernel.org>
CC: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<kvm@vger.kernel.org>, Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Christoffer
 Dall <christoffer.dall@arm.com>, Volodymyr Babchuk
	<Volodymyr_Babchuk@epam.com>
References: <20251103165517.2960148-1-maz@kernel.org>
 <20251103165517.2960148-4-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <4dfdc1da-5b5f-26be-f318-4a30ab0db1cc@huawei.com>
Date: Tue, 4 Nov 2025 19:13:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251103165517.2960148-4-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk200017.china.huawei.com (7.202.194.83)

Subject: s/ICH_MIDR_EL2/ICH_MISR_EL2/

Thanks,
Zenghui

