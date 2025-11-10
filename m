Return-Path: <kvm+bounces-62506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D479C46B3E
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 13:52:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 850701885CA1
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 12:52:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B72AB30FC08;
	Mon, 10 Nov 2025 12:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kItflAEG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DA430F54C;
	Mon, 10 Nov 2025 12:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762779118; cv=none; b=g0/2c+POfh8+Or8vsTK6tuQw2Dus0i5zUgsGgLH0MPZaWBkShb5uhHrnwfQWVBD36EQUlusKi1K/UN0oSsl0OBE8cAXpg4AeFKZ1OCMjY8JX9huSOVhWEH8Il+BiJjupT2QQj4nqKhyi4PX+9/V7ZIjRTUcCBNj1beDK4nWjOOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762779118; c=relaxed/simple;
	bh=UqW2OohnniAD+Yd1sr8oqOdX5uTV9aKQiK82zm9RGbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oV609rnJTu0YdxyqSeDjZL1fNfpNraPSKX9DADpZ8oUxU7RTyIn+JLZGzqPy5mKTjeZnR+7qVkTXJOBG5GXAVr8u3AX0s0m2B1skBAMk7HtzQ9sW9Giz/5uLQ4jYaDOBMiHy37gYRyEgoahNOI1eiaiC1OINau1Gwez7Nyl0Nws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kItflAEG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D469AC19425;
	Mon, 10 Nov 2025 12:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762779118;
	bh=UqW2OohnniAD+Yd1sr8oqOdX5uTV9aKQiK82zm9RGbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kItflAEG4RnvNZ1douPLoBIBdZf0SSz4ldNv5BGnaIYNub7DVpytctSLEEF+b2aLb
	 2RNojiiK3OnS/Xu84kwFx3HYTZC/h9KecDieE+a0+5HVsP9ZU9G9egmXic1hC0bum+
	 5TtoVPTOdQnp4z2DjbnlB/RKIWJKMPGVMTlF1z5ipfT1oS0ct0yfcPf2vGjBiLMPcM
	 f4ejV4Hv1NOoJ6wOMUFfq0miKVGToFTQh2vv5VqR54r2ZIusgXqgJWORRWOp4zxX+t
	 35PDbEp+SXjjpLMGl59EwzKVqVsj5IgQDis7wwwp8SAx3/GhJ2Km6AR0ClYp/4Dnkg
	 QNuK67ymQI48w==
Date: Mon, 10 Nov 2025 12:51:55 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v2 3/3] KVM: arm64: Limit clearing of
 ID_{AA64PFR0,PFR1}_EL1.GIC to userspace irqchip
Message-ID: <aRHf6x5umkTYhYJ3@finisterre.sirena.org.uk>
References: <20251030122707.2033690-1-maz@kernel.org>
 <20251030122707.2033690-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nRXSjGhbC5T2SNGb"
Content-Disposition: inline
In-Reply-To: <20251030122707.2033690-4-maz@kernel.org>
X-Cookie: You are lost in the Swamps of Despair.


--nRXSjGhbC5T2SNGb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2025 at 12:27:07PM +0000, Marc Zyngier wrote:
> Now that the idreg's GIC field is in sync with the irqchip, limit
> the runtime clearing of these fields to the pathological case where
> we do not have an in-kernel GIC.
>=20
> While we're at it, use the existing API instead of open-coded
> accessors to access the ID regs.

Today's next/pending-fixes is showing regressions on a range of physical
arm64 platforms (including at least a bunch of A53 systems, an A55 one
and an A72 one) in the steal_time selftest which bisect to this patch.
We get asserts in the kernel on ID register sets:

[  150.872407] WARNING: CPU: 0 PID: 2865 at arch/arm64/kvm/sys_regs.c:2353 =
kvm_set_vm_id_reg+0x9c/0xf4

=2E..

[  151.045312] Call trace:
[  151.047780]  kvm_set_vm_id_reg+0x9c/0xf4 (P)
[  151.052098]  kvm_finalize_sys_regs+0x88/0x240
[  151.056504]  kvm_arch_vcpu_run_pid_change+0xb4/0x438
[  151.061527]  kvm_vcpu_ioctl+0x92c/0x9d0

which generate errors to userspace, causing the test to fail.  Full log
=66rom one of the failing runs:

   https://lava.sirena.org.uk/scheduler/job/2065669#L2863

Bisect log:

# bad: [55f97faf872612ac604ae72eb1968e6619cc41be] Merge branch 'for-linux-n=
ext-fixes' of https://gitlab.freedesktop.org/drm/misc/kernel.git
# good: [f850568efe3a7a9ec4df357cfad1f997f0058924] Merge tag 'i2c-for-6.18-=
rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
# good: [636f4618b1cd96f6b5a2b8c7c4f665c8533ecf13] regulator: fixed: fix GP=
IO descriptor leak on register failure
# good: [86d57d9c07d54e8cb385ffe800930816ccdba0c1] spi: imx: keep dma reque=
st disabled before dma transfer setup
# good: [939edfaa10f1d22e6af6a84bf4bd96dc49c67302] spi: xilinx: increase nu=
mber of retries before declaring stall
# good: [3cd2018e15b3d66d2187d92867e265f45ad79e6f] spi: Try to get ACPI GPI=
O IRQ earlier
# good: [29528c8e643bb0c54da01237a35010c6438423d2] ASoC: tas2781: fix getti=
ng the wrong device number
# good: [3dc8c73365d3ca25c99e7e1a0f493039d7291df5] ASoC: codecs: va-macro: =
fix resource leak in probe error path
# good: [84f5526e4dce0a44d050ceb1b1bf21d43016d91b] ASoC: tas2783A: Fix issu=
es in firmware parsing
# good: [8da0efc3da9312b65f5cbf06e57d284f69222b2e] ASoC: doc: cs35l56: Upda=
te firmware filename description for B0 silicon
# good: [249d96b492efb7a773296ab2c62179918301c146] ASoC: da7213: Use compon=
ent driver suspend/resume
git bisect start '55f97faf872612ac604ae72eb1968e6619cc41be' 'f850568efe3a7a=
9ec4df357cfad1f997f0058924' '636f4618b1cd96f6b5a2b8c7c4f665c8533ecf13' '86d=
57d9c07d54e8cb385ffe800930816ccdba0c1' '939edfaa10f1d22e6af6a84bf4bd96dc49c=
67302' '3cd2018e15b3d66d2187d92867e265f45ad79e6f' '29528c8e643bb0c54da01237=
a35010c6438423d2' '3dc8c73365d3ca25c99e7e1a0f493039d7291df5' '84f5526e4dce0=
a44d050ceb1b1bf21d43016d91b' '8da0efc3da9312b65f5cbf06e57d284f69222b2e' '24=
9d96b492efb7a773296ab2c62179918301c146'
# test job: [636f4618b1cd96f6b5a2b8c7c4f665c8533ecf13] https://lava.sirena.=
org.uk/scheduler/job/2048731
# test job: [86d57d9c07d54e8cb385ffe800930816ccdba0c1] https://lava.sirena.=
org.uk/scheduler/job/2053555
# test job: [939edfaa10f1d22e6af6a84bf4bd96dc49c67302] https://lava.sirena.=
org.uk/scheduler/job/2057909
# test job: [3cd2018e15b3d66d2187d92867e265f45ad79e6f] https://lava.sirena.=
org.uk/scheduler/job/2049140
# test job: [29528c8e643bb0c54da01237a35010c6438423d2] https://lava.sirena.=
org.uk/scheduler/job/2057927
# test job: [3dc8c73365d3ca25c99e7e1a0f493039d7291df5] https://lava.sirena.=
org.uk/scheduler/job/2054782
# test job: [84f5526e4dce0a44d050ceb1b1bf21d43016d91b] https://lava.sirena.=
org.uk/scheduler/job/2053642
# test job: [8da0efc3da9312b65f5cbf06e57d284f69222b2e] https://lava.sirena.=
org.uk/scheduler/job/2038272
# test job: [249d96b492efb7a773296ab2c62179918301c146] https://lava.sirena.=
org.uk/scheduler/job/2043898
# test job: [55f97faf872612ac604ae72eb1968e6619cc41be] https://lava.sirena.=
org.uk/scheduler/job/2065669
# bad: [55f97faf872612ac604ae72eb1968e6619cc41be] Merge branch 'for-linux-n=
ext-fixes' of https://gitlab.freedesktop.org/drm/misc/kernel.git
git bisect bad 55f97faf872612ac604ae72eb1968e6619cc41be
# test job: [1f007059d445f5a1904328b3d34ad462329ba314] https://lava.sirena.=
org.uk/scheduler/job/2065857
# good: [1f007059d445f5a1904328b3d34ad462329ba314] Merge branch 'usb-linus'=
 of https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
git bisect good 1f007059d445f5a1904328b3d34ad462329ba314
# test job: [0319e334a50bdc96486bca1f44828c55ea9d3008] https://lava.sirena.=
org.uk/scheduler/job/2066320
# good: [0319e334a50bdc96486bca1f44828c55ea9d3008] Merge branch 'reset/fixe=
s' of https://git.pengutronix.de/git/pza/linux
git bisect good 0319e334a50bdc96486bca1f44828c55ea9d3008
# test job: [4fc9ec35871028dc4db558d1bb74f18075544a61] https://lava.sirena.=
org.uk/scheduler/job/2066361
# bad: [4fc9ec35871028dc4db558d1bb74f18075544a61] Merge branch 'dma-mapping=
-fixes' of https://git.kernel.org/pub/scm/linux/kernel/git/mszyprowski/linu=
x.git
git bisect bad 4fc9ec35871028dc4db558d1bb74f18075544a61
# test job: [0e5ba55750c1f7fb194a0022b8c887e6413da9b1] https://lava.sirena.=
org.uk/scheduler/job/2066403
# good: [0e5ba55750c1f7fb194a0022b8c887e6413da9b1] Merge tag 'kvm-x86-fixes=
-6.18-rc5' of https://github.com/kvm-x86/linux into HEAD
git bisect good 0e5ba55750c1f7fb194a0022b8c887e6413da9b1
# test job: [ca00c3af8ede65d16097d322be330146d9231bd2] https://lava.sirena.=
org.uk/scheduler/job/2066412
# bad: [ca00c3af8ede65d16097d322be330146d9231bd2] Merge tag 'kvmarm-fixes-6=
=2E18-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm int=
o HEAD
git bisect bad ca00c3af8ede65d16097d322be330146d9231bd2
# test job: [103e17aac09cdd358133f9e00998b75d6c1f1518] https://lava.sirena.=
org.uk/scheduler/job/2066443
# good: [103e17aac09cdd358133f9e00998b75d6c1f1518] KVM: arm64: Check the un=
trusted offset in FF-A memory share
git bisect good 103e17aac09cdd358133f9e00998b75d6c1f1518
# test job: [50e7cce81b9b2fbd6f0104c1698959d45ce3cf58] https://lava.sirena.=
org.uk/scheduler/job/2066695
# bad: [50e7cce81b9b2fbd6f0104c1698959d45ce3cf58] KVM: arm64: Limit clearin=
g of ID_{AA64PFR0,PFR1}_EL1.GIC to userspace irqchip
git bisect bad 50e7cce81b9b2fbd6f0104c1698959d45ce3cf58
# test job: [8a9866ff860052efc5f9766f3f87fae30c983156] https://lava.sirena.=
org.uk/scheduler/job/2067273
# good: [8a9866ff860052efc5f9766f3f87fae30c983156] KVM: arm64: Set ID_{AA64=
PFR0,PFR1}_EL1.GIC when GICv3 is configured
git bisect good 8a9866ff860052efc5f9766f3f87fae30c983156
# first bad commit: [50e7cce81b9b2fbd6f0104c1698959d45ce3cf58] KVM: arm64: =
Limit clearing of ID_{AA64PFR0,PFR1}_EL1.GIC to userspace irqchip

--nRXSjGhbC5T2SNGb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkR3+cACgkQJNaLcl1U
h9C6NQf/QpXxlBL+dOCgyvN7uHqPNfyP+iIy22iJJo96x+lyS1mqROYi/Hm7HQIz
oCjo3Cr+evfFmVqaIChBKwl8+uZIhxw8afASOxYydgrq9+vjFJ6XlEQ5HIbskd4h
d7nJpW2RjJrpcPEGg9qnWWuvqkNfWo/BZKwvwu/7DlkWKMOklYaXqLianYM5vZyg
MVjIB8ot3dN5oQ7pRbT9I1ayFxUbFAMr/lZjwiDU9UAbUV3H9tVJCc7ZUrcP+Pw/
6oKDpbE2F8yauT4e3nzeTt5/Dw6xDjDao6MjAxSR+V8VDNbMjYf6xCbn0OKF6ui6
ZxQuN+pbxUOm7TVwAtirRPCCX7ruZQ==
=yEKR
-----END PGP SIGNATURE-----

--nRXSjGhbC5T2SNGb--

