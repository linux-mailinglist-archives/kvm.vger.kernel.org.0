Return-Path: <kvm+bounces-67422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 32B67D05355
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 18:53:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 16DE7332A035
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 16:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AD392E88BD;
	Thu,  8 Jan 2026 16:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="WeCWOz6V"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout02.his.huawei.com (sinmsgout02.his.huawei.com [119.8.177.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586CF2DECB1
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 16:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767891468; cv=none; b=FO8fuwnQbx3DTSG7qhONL/ehwOWHfp/MKsS1lTVhXUJ3CbO9UctNGnoxtKkSBU/C1vFdAMXzvNzGtswPgX2H3awX4qUdlB7B/0BLn05HYgCUNowP34tkDMK5VUz0JggDAcPPTO6Xl/4NAziICWzX3N2h8V9NDTKMFBPvuB+guUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767891468; c=relaxed/simple;
	bh=wbU4fkpkOOSXQwSp10NRbg+E3BjPYUuFytg8j8m19zE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i610iqseDKkKk/6+FtKQvRYj5CldrE4TlLTeIbX/WsjKunKom3/1Wrf8+X/++4mnCrksWpLeOtvL33SkrnJtnkDUWO1sREEikzfu7cIlfYU3xCc/drulJ38KAaqv1nB50IH03G8sSt3tA4uzU69wHC6xdJ11uCqmk7MOwfjBiZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=WeCWOz6V; arc=none smtp.client-ip=119.8.177.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=wbU4fkpkOOSXQwSp10NRbg+E3BjPYUuFytg8j8m19zE=;
	b=WeCWOz6VnYjpLolBIyuz7dR9docT6AbY8hEl1QjtHpOFFWAx0xJnBwOddeJxQSMFtvagHzBQf
	iat4eRHpSsmDSZEUZaaIWuSzVqTh0Mt3WNjjXoY2AgT258tYE1My5NhTZXoEu7AYXr5Da4zAmrl
	eYlq6LpGk4uwcGYNJIZJYwQ=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dn9y33L8gz1vnM8;
	Fri,  9 Jan 2026 00:55:23 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dnB0Q4NbvzJ468V;
	Fri,  9 Jan 2026 00:57:26 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id B861F40539;
	Fri,  9 Jan 2026 00:57:31 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 8 Jan
 2026 16:57:30 +0000
Date: Thu, 8 Jan 2026 16:57:29 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, "Suzuki
 Poulose" <Suzuki.Poulose@arm.com>, nd <nd@arm.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 19/36] KVM: arm64: gic-v5: Check for pending PPIs
Message-ID: <20260108165729.0000290f@huawei.com>
In-Reply-To: <0f8b393f8c9e557ba081a75757f1140c0da75a76.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-20-sascha.bischoff@arm.com>
	<20260107150012.0000336b@huawei.com>
	<0f8b393f8c9e557ba081a75757f1140c0da75a76.camel@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml100005.china.huawei.com (7.214.146.113)


> > > Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com> =20
> > Hi Sascha,
> >=20
> > One thing I notice in here is the use of unsigned long vs u64 is a
> > bit
> > inconsistent.=A0 When it's a register or something we just read from a
> > register
> > I'd always use u64. =20
>=20
> Yeah, I'd like to do the same. The issue is that the for_each_set_bit()
> loop construct only works with unsigned long, and not u64. I'll rework
> the code to use u64 wherever possible.

Whilst is a bit silly with a single u64, there is bitmap_from_arr64()
The compiler should be able to see enough to flatten that to an assignment
so it's pretty cheap and ends up documenting why types are different.

