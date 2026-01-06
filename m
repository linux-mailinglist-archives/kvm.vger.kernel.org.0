Return-Path: <kvm+bounces-67159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C9F4DCF9D98
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 18:51:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CD4723067209
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 17:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 813992FFDCC;
	Tue,  6 Jan 2026 17:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="wA8AGwnU"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout02.his.huawei.com (sinmsgout02.his.huawei.com [119.8.177.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391F71E4BE
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 17:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721395; cv=none; b=aRNeiyrXr6Xy2EJpxYTaOIkA75NugEwkAncB6d3O3usH0COaWG7lmkkBH6VcOm/UCbgmwty9zZ/F8fsIndeW7qqcdfhr1iHpdw669UvkApzNB4RMTlxVWf1ijtSBc69+jWJSGbysDQ/ZX6z8w8kiaqvmyzKLfLTfMKlDIBtgPEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721395; c=relaxed/simple;
	bh=RF1u3eonBZzegDg1PZuS6BezgVys09l39qBCJ0/zL0U=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bs7UDXveUMcXO8gNY+kbzEXrThDXfczHw/+ABQqkKTkNZaUeYc1qqG1ohtd0JwpAOt3/nbDCCkftap3o4zRFOTn6KhfXOVBTKZpcXJwjBU8oubZStyxuoSCZOymgZQqKZzPq8Qg+9M4Y+jo/ba5GiaejDJvIRK1LkE5aElAw1OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=wA8AGwnU; arc=none smtp.client-ip=119.8.177.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lC/vPrppfWWJLMXtqrkEQhEuGW9UilLVWhfYhsLXqlM=;
	b=wA8AGwnUx1Vq5QigHCn0VYFfK4J5ZNl8Ntb+EC5rG1ToX7ySH9N0CRiIQpm75yRmrrJxMpPRs
	/2H/zmJxLE+C3vnLaJKQQtOfJbYl98JaAprg+qmVkx5lo4yoYhpqh+3KKM4G26tGMTna1y6Zc5T
	56A9cor4yPwLMcOXjD90jVI=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dlycr0KYxz1vp16;
	Wed,  7 Jan 2026 01:21:15 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dlygD270QzJ46Bs;
	Wed,  7 Jan 2026 01:23:20 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 2DFD440086;
	Wed,  7 Jan 2026 01:23:22 +0800 (CST)
Received: from localhost (10.195.245.156) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 6 Jan
 2026 17:23:21 +0000
Date: Tue, 6 Jan 2026 17:23:17 +0000
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
Subject: Re: [PATCH v2 01/36] KVM: arm64: Account for RES1 bits in
 DECLARE_FEAT_MAP() and co
Message-ID: <20260106172317.00001463@huawei.com>
In-Reply-To: <20251219155222.1383109-2-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-2-sascha.bischoff@arm.com>
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

On Fri, 19 Dec 2025 15:52:36 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> From: Marc Zyngier <maz@kernel.org>
> 
> None of the registers we manage in the feature dependency infrastructure
> so far has any RES1 bit. This is about to change, as VTCR_EL2 has
> its bit 31 being RES1.

Oh goody.

> 
> In order to not fail the consistency checks by not describing a bit,
> add RES1 bits to the set of immutable bits. This requires some extra
> surgery for the FGT handling, as we now need to track RES1 bits there
> as well.
> 
> There are no RES1 FGT bits *yet*. Watch this space.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
FWIW it seems correct.  The only thing I wondered about is
the assumption that if there is an error best thing to do is
to assume it was res0 that was wrong and paper over it.
I guess we can't do anything better if that does happen.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

Process thing though: before anyone can merge this, Sasha
please take a look at submitting patches documentation.

When you 'post' a patch that was written by someone else you have
handled the patch and for the Developer Certificate of origin stuff
to work you have to add your Signed-off-by after theirs.

Jonathan

