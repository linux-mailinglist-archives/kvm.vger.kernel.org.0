Return-Path: <kvm+bounces-63213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C53FC5DD57
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 16:24:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5F2142607E
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 15:14:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3E5A1917ED;
	Fri, 14 Nov 2025 15:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SKcMGlNC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE274329E5A;
	Fri, 14 Nov 2025 15:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763132653; cv=none; b=DYYDmCO6/XRCbZJ+ch9fcCKid93huTcdCAw2ISi7Uwj8jobMMoPcLhces7pc1s3hIh/d3no4KAPl4jFvFp/yJZp8oLhogGmJnVrUIcIls1TI2KnF8gdj3MxNAlRlyQz7LxJvDN7xPPZxE3oWWTnxjOMzIDvdb8+x7yNHifYbN0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763132653; c=relaxed/simple;
	bh=X9A/K6dKrZp8FkgbUJFa3jX79Fg/hAsn2lwnVXty5Ho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jYjsmBBKfBpDtfBSP3kVfA6Jpmc4NYPY32gWdhKIfCH2vsiVUdCDH6DrKV2N3+x6b4ygViiV40skDSRm9OuGbyLZH8ioZDrXOta1kGsoYhdVARurV6Iyb9mte8LF/xRCRD2dySabueu8Pq8Ia9f3UsR8F1x9m1J1jq+Zp7BlVRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SKcMGlNC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF98C4CEF5;
	Fri, 14 Nov 2025 15:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763132652;
	bh=X9A/K6dKrZp8FkgbUJFa3jX79Fg/hAsn2lwnVXty5Ho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SKcMGlNC5EasQqA2aQ06uHY04EwwrJUfNbGLfMuvlqRNghpeGKPzYhtwWmHjM3SYG
	 Rf4F0jl9VRffgS+KoHA6rkMObv07QUUiehz0Gr1/sTUO1uyrUd2OVKuk/Ll/cqg1eG
	 O1sHK6g5FNLB9HfqUqWyPD0fWF8i7bwkiTAiIO1jAUXGbeQfeR3i5PCyYx36PXaStQ
	 fHxBuLgqtN7QIgCH2bmGg84C/qbCgoDxJtIPhF7w2/9pPUoF3lAyHHjEEaxyhLTBAs
	 zXg1CQXXkHkMNio8CKVBNVptNT4L9OfNW+zrdhR6RLQMRNojWPtZv9qQw0iY6JHNoG
	 OMPL5X7kjSRRg==
Date: Fri, 14 Nov 2025 15:04:07 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: GICv3: Don't advertise ICH_HCR_EL2.En==1
 when no vgic is configured
Message-ID: <75b712d8-030a-4057-a5d6-2073c8e7e578@sirena.org.uk>
References: <20251114093541.3216162-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="48cgQx1hYaY+83gr"
Content-Disposition: inline
In-Reply-To: <20251114093541.3216162-1-maz@kernel.org>
X-Cookie: Causes moderate eye irritation.


--48cgQx1hYaY+83gr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2025 at 09:35:41AM +0000, Marc Zyngier wrote:
> Configuring GICv3 to deal with the lack of GIC in the guest relies
> on not setting ICH_HCR_EL2.En in the shadow register, as this is
> an indication of the fact that we want to trap all system registers
> to report an UNDEF in the guest.
>=20
> Make sure we leave vgic_hcr untouched in this case.

This resolves the issues I was seeing with no-vgic-v3:

Tested-by: Mark Brown <broonie@kernel.org>

--48cgQx1hYaY+83gr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkXROYACgkQJNaLcl1U
h9DT7gf/W7DZ3+p8X2O9PnECN0VPqSjHD71nxD3K3NF/ptDa9PK+/yoAmvrBlkqf
d4fHDxMDlThAP25QE3xeBTgwjwCYnYZyzNLIyZLiJ9aD9e1mvAYUehM90q3UuyBe
DjXe6ZB2HPmbF0utvjx6Jtctg1yo2lMC/Qll+KjoV+l5GVN/GnbFSSOjVmeiPmKJ
yXHsiK6KgvNj/4Lei9Cv4oIemkbevie2YUazVw3zrfRrWuoNNr+s6Ov4uBsllGcZ
SSDnOzaDD2WNT31yj565NWFW7RF4B3Rw3mtOlBEnTthQIeTZxUQd6lwee9PGrYH5
wLKfIQFTQLso1vTPQz6EgSVbRmJCjA==
=R8ng
-----END PGP SIGNATURE-----

--48cgQx1hYaY+83gr--

