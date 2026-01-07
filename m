Return-Path: <kvm+bounces-67235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DB7BCFED8C
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 17:24:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B2E4A3004E10
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 16:21:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11886393408;
	Wed,  7 Jan 2026 15:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="0DG0uPab"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout03.his.huawei.com (sinmsgout03.his.huawei.com [119.8.177.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCCF38A2A4
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 15:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767801099; cv=none; b=dEkTOpbJ4D6iDngpovzAOZgCoSxFv98SagLvchBM05b0SCsDBkI9qAqYLmSM+71WbkfkRgJ9VQI2kwTE4UfQk/reqtK6n9eJn0tRbTpRhL33NlJHcAIFc7zx8ZJjfUGysYQm8+yN04wCENmxqPheQMl145S1fXZ/bWyDJTy9RyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767801099; c=relaxed/simple;
	bh=OWerPOUQ2qyMwxUERnEoE85nHva9y8ZjPtMfT8VCHbE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=do2uTRkKisItmly3meiYNXnbCPjW3MxFjCQpz7neVSy35NYzWVJJ9/aj8oPtxngmzpuMNU0l0t8IsvfjDyv8PPJAMwdUnrA8jlLyNUpyBQ+4Phq9wrbBR7QFW3kN5KhUCTHlS9m6ZbrDukhfhRD2OdV9iiw97B+fzGDTgv5TUc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=0DG0uPab; arc=none smtp.client-ip=119.8.177.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3h699r3iIg9ZV2/0qzLto2y8f/0Q/GjzRgr1Ae6rVsA=;
	b=0DG0uPabO7T7KHB5XrTHYqQda7cleLiCOeYDBEqWNYkTa5JMwWXuLYDCJtKnpLKvpdbZl/Wmk
	ZgHeFa3T3BqCSHYy6CLuwy9DZg3IYpZhpNsYRXsaKKuFdTvw+uiW7dXLQfj5+C0CRQ8SWuZiQEq
	k9u8FGQdxBG1LBA2kTpnPtQ=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dmXXC694HzMrcG;
	Wed,  7 Jan 2026 23:49:15 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmXZW6Q4zzHnGg3;
	Wed,  7 Jan 2026 23:51:15 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 4D6B440086;
	Wed,  7 Jan 2026 23:51:22 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 15:51:21 +0000
Date: Wed, 7 Jan 2026 15:51:20 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd
	<nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes
	<Timothy.Hayes@arm.com>
Subject: Re: [PATCH v2 25/36] KVM: arm64: gic-v5: Reset vcpu state
Message-ID: <20260107155120.00000801@huawei.com>
In-Reply-To: <20251219155222.1383109-26-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-26-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 15:52:44 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> Limit the number of ID and priority bits supported based on the
> hardware capabilities when resetting the vcpu state.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

