Return-Path: <kvm+bounces-60670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B3FB2BF6F39
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 16:04:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E90AA465280
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 14:02:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F143D33B957;
	Tue, 21 Oct 2025 14:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XK574YGT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09004339708;
	Tue, 21 Oct 2025 14:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761055271; cv=none; b=PtHnbE2AThJNPoyemT8LoC+LEJk6WvLxbXiPFmXf0UM3GbuPCOb8IUUBTz95i2Z/5XEuKh3U82RfMMOhVFp7M542JExKOp1Oo9gwpek8oRyHAgCNstSwdNs9+yUqQhZ498iHKQgsSZjP65J8cBEEvJ52rV9+KZ2LCXSjTeJFFeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761055271; c=relaxed/simple;
	bh=2ehypxs6NqIrfQOZ7K1xfSYPtdTxoYI5fqmOmDSbLgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rSJLfhIFC1dkE/hl8KuVTuvV06Oj29/69UVNvXQRNZgYFh9x1ggFRAQLmqRHasqoRhjKcxhCubGDrrorsm1xktHotOo+MftsiZ1ygMfoHsuHSSf0jESuiCQIfPRjCklWd6Ft/6dEKxXf1tCaEdjIcMa02jOdBl9jsYaf2z1Bx58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XK574YGT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EA9C4CEF1;
	Tue, 21 Oct 2025 14:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761055270;
	bh=2ehypxs6NqIrfQOZ7K1xfSYPtdTxoYI5fqmOmDSbLgo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XK574YGTNZ1ED6z+iqXzh/soXQPQY9IJy1rszRDAxB4RykMozZdqB04ZGQSr1aDGx
	 Xam2bP9jq1weICQx2XXGsceGbI+u8S5kptMQvsy3kQAGV926bWxD4OUmgk4XYUyuPS
	 dELjAvRFryKhscR4HxFo8mi9PiRLoFiBElOcRKwPjbq01amVPSExVDB5N7D+JDH/0X
	 byMRJQz2wuReFrtJ9XHxzaFX9r6wTb/GbIh9DTkwYJCfsS9BmAiXT3YDTd4FD/HbhX
	 SeK2TZuwOwfJsFqk/BjPWBRYp/lCQMKPYGS7TmPm6fqz8OVhkTJhgQmNyCpdi4cM39
	 J6lnBGLxU0tRA==
Date: Tue, 21 Oct 2025 15:01:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: vgic-v3: Trap all if no in-kernel irqchip
Message-ID: <ca8e9756-6fef-423a-bbaf-3b4dd2105beb@sirena.org.uk>
References: <20251021094358.1963807-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="IrhBdm47gVnop6o3"
Content-Disposition: inline
In-Reply-To: <20251021094358.1963807-1-sascha.bischoff@arm.com>
X-Cookie: Accordion, n.:


--IrhBdm47gVnop6o3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 21, 2025 at 09:44:09AM +0000, Sascha Bischoff wrote:
> If there is no in-kernel irqchip for a GICv3 host set all of the trap
> bits to block all accesses. This fixes the no-vgic-v3 selftest again.

Tested-by: Mark Brown <broonie@kernel.org>

--IrhBdm47gVnop6o3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmj3kh4ACgkQJNaLcl1U
h9DUqAf/QEERGOisXRAq9CnwcS80G6M2khAIySPsnBn8KAxqewg/FUc6Nov1YqoA
UtpaWCV7P+z4WVv91UrkiElDSnZ3uvesUAMwPA4pdLXyJmWakNE19j59kHkngDPj
62NO90HobyTNCHvjoghR0XLFJekpv6J6G3ZfJNtxcrTXgAfpKvbbWKh1JBuevJhx
PizWl2nm9xc8PY/5jzjOTu//nOOgvCswkKP4L7Ted1y1JS6mcX/uOs34p6RfSyEq
ndayWTYUAcs9O1C08j8UMz6LYwUsj/9eqLXqrTnDnNbqgYRi/zkTH2MDVEN7xdOY
oNmByRdx66CWu3g5L1Iv8aduzyXHHQ==
=ToAD
-----END PGP SIGNATURE-----

--IrhBdm47gVnop6o3--

