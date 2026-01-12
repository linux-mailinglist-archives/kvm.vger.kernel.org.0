Return-Path: <kvm+bounces-67776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EFDCD13F16
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:20:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AD34F30319B3
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 16:16:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55CC4364EB2;
	Mon, 12 Jan 2026 16:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="rBoRs0VN"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF21306B12
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768234615; cv=none; b=ZAIQ4RMnNGb4n1fb+YX0VSflJ0L+BZ+w4b/oLTKe6D9fRYmd5nLFKyW/lblVINGBjMYsGWUUIlyRFBCzucYD2oQ++RzXQiSRLoIoY1gBUTarx039Xb9a0F+bC4eln4i+8FIXIoVsbqfnColRGuNbLcbMW/doe7S/Qm9s6cIMaBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768234615; c=relaxed/simple;
	bh=iaHCY2UlM1lm13PaQomInbdjCO1PmQnxFL0+szNxy9Y=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NmIZp04T1tuO6MlW2htKonKnhg1jM7K/YCLKNMn3ej9o1aAzM222EPjsbpTfG2LQFAlYbg6tTCSV9jNDKq8vDFyIq11/k4oTq/ShS4IedIGCdtdLBB+T92Kb3Atsq9/OBPYRUVuSExCrI0XPKCUjjDohipEBf0phnIOSJx0i+Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=rBoRs0VN; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=hvao/Mc/KX8gqqLCEFSct91Cw25CNVSIk9+88TFlij0=;
	b=rBoRs0VNcKTLbi6JCEHjAPC0JZfyoiQ6rBbq0IC1CqiFp1R47Z702FYMa8D5cijAq+qTYnJYg
	l/tXQAhlLYdd0MXC0It4WhzkcY92FTc5ew2pmxTExnPXH+8K3mlDWql2GNQlxP72oVHoK17CIXU
	Jt8+S92JW8zN3W8khA6kvNM=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dqcrv1PK2z1P7cV;
	Tue, 13 Jan 2026 00:14:23 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dqcvR4gvPzJ46Dm;
	Tue, 13 Jan 2026 00:16:35 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 4600240569;
	Tue, 13 Jan 2026 00:16:47 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 12 Jan
 2026 16:16:46 +0000
Date: Mon, 12 Jan 2026 16:16:45 +0000
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
Subject: Re: [PATCH v3 22/36] KVM: arm64: gic-v5: Trap and mask guest
 ICC_PPI_ENABLERx_EL1 writes
Message-ID: <20260112161645.00001c17@huawei.com>
In-Reply-To: <20260109170400.1585048-23-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
	<20260109170400.1585048-23-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 9 Jan 2026 17:04:46 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> A guest should not be able to detect if a PPI that is not exposed to
> the guest is implemented or not. Avoid the guest enabling any PPIs
> that are not implemented as far as the guest is concerned by trapping
> and masking writes to the two ICC_PPI_ENABLERx_EL1 regisers.

registers

> 
> When a guest writes these registers, the write is masked with the set
> of PPIs actually exposed to the guest, and the state is written back
> to KVM's shadow state. As there is now no way for the guest to change
> the PPI enable state without it being trapped, saving of the PPI
> Enable state is dropped from guest exit.
> 
> Reads for the above registers are not masked. When the guest is
> running and reads from the above registers, it is presented with what
> KVM provides in the ICH_PPI_ENABLERx_EL2 registers, which is the
> masked version of what the guest last wrote.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>

Seems fine to me.
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>



