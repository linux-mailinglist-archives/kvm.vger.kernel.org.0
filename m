Return-Path: <kvm+bounces-30305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D0CE9B9186
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 14:08:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B84A21C21C80
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 13:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FCCD19F464;
	Fri,  1 Nov 2024 13:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ylc6i+PX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88932487A7;
	Fri,  1 Nov 2024 13:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730466484; cv=none; b=Hx4saZqQ7RfizsqGNdkBrndK+5XQq6zQ3b6slJb0Lk9tPp31DCXYp4yUSH1bLWP5dWQxzwuQ1MaG9Re/QXm5YMURTkSGv3oZ1qdZPFdC67Em6A9kiw1IDaXdtKvIuiuBzlkiI2wSaQUu0lXThXYpv2gTWcVvk95Vi42NqGsnh3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730466484; c=relaxed/simple;
	bh=2SzPN9eZ9YXTCtIfY58EFEEvjtP/SDawY1JwxmDF++I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uZ4mHE7LU0F4QbugdjkP1e/zqWgqh3lj2xmdEJSgbupXZggFpVOfHtRrTqA4wGBz07zlCxsEUKPGYHZnDdl01NUOzkYbrX7Uiirri5+Jj5f8+S+lpqLD+su3tBqaQC6NF5p5Y/0PqB7AzUXJ1go1zHM0qYgM7Nr2KTpmR7X9tSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ylc6i+PX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B02C4CECD;
	Fri,  1 Nov 2024 13:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730466484;
	bh=2SzPN9eZ9YXTCtIfY58EFEEvjtP/SDawY1JwxmDF++I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ylc6i+PXadApsTrC1+EHUyKZIZnnbtk5yPisr6xCT1pFwE9gK/CLFWiHQNRuQI799
	 kCBO4RxaczMABJO8tQBCqq3YL0ahawM9dTOEu4HAWN5LKPmb7YR2IWZ0jwQk1pw0XW
	 fSuGXY62Kc12y34/wRKzjUhAHqaGgwCWSHv+8qZG7DO6PHZgTUO6TJQ1XH+Lfb6uQx
	 iZteyzfKIG8FHUKZz8O690Vi+yn0jR1aQChsU5dqlPHjGkdNYRiCEYHrqO4V6wlO2c
	 1G7j9vKxDIIR23W/3UhX4PfTe8XXv/4M+wNQtB9QHIteKOd8v86sXg2riL9PpYdU82
	 Fa14lZg2mx2/w==
Date: Fri, 1 Nov 2024 13:07:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	Andrew Jones <ajones@ventanamicro.com>,
	James Houghton <jthoughton@google.com>,
	David Woodhouse <dwmw@amazon.co.uk>, linux-next@vger.kernel.org
Subject: Re: [PATCH v3 03/14] KVM: selftests: Return a value from
 vcpu_get_reg() instead of using an out-param
Message-ID: <39ea24d8-9dae-447a-ae37-e65878c3806f@sirena.org.uk>
References: <20241009154953.1073471-1-seanjc@google.com>
 <20241009154953.1073471-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YtZ2j2bWyKb0/r3q"
Content-Disposition: inline
In-Reply-To: <20241009154953.1073471-4-seanjc@google.com>
X-Cookie: Sales tax applies.


--YtZ2j2bWyKb0/r3q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 09, 2024 at 08:49:42AM -0700, Sean Christopherson wrote:
> Return a uint64_t from vcpu_get_reg() instead of having the caller provide
> a pointer to storage, as none of the vcpu_get_reg() usage in KVM selftests
> accesses a register larger than 64 bits, and vcpu_set_reg() only accepts a
> 64-bit value.  If a use case comes along that needs to get a register that
> is larger than 64 bits, then a utility can be added to assert success and
> take a void pointer, but until then, forcing an out param yields ugly code
> and prevents feeding the output of vcpu_get_reg() into vcpu_set_reg().

This commit, which is in today's -next as 5c6c7b71a45c9c, breaks the
build on arm64:

aarch64/psci_test.c: In function =E2=80=98host_test_system_off2=E2=80=99:
aarch64/psci_test.c:247:9: error: too many arguments to function =E2=80=98v=
cpu_get_reg=E2=80=99
  247 |         vcpu_get_reg(target, KVM_REG_ARM_PSCI_VERSION, &psci_versio=
n);
      |         ^~~~~~~~~~~~
In file included from aarch64/psci_test.c:18:
include/kvm_util.h:705:24: note: declared here
  705 | static inline uint64_t vcpu_get_reg(struct kvm_vcpu *vcpu, uint64_t=
 id)
      |                        ^~~~~~~~~~~~
At top level:
cc1: note: unrecognized command-line option =E2=80=98-Wno-gnu-variable-size=
d-type-not-at
-end=E2=80=99 may have been intended to silence earlier diagnostics

since the updates done to that file did not take account of 72be5aa6be4
("KVM: selftests: Add test for PSCI SYSTEM_OFF2") which has been merged
in the kvm-arm64 tree.

--YtZ2j2bWyKb0/r3q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmck0qwACgkQJNaLcl1U
h9DFvAf+NFZ+z1aCylPPLFa+zTDz5MmqEcjVpfhQkyHhNKHUjHoiGTKMUmWyQMUR
zuLXQxeTLLfX2TUAY8iDXERwVa3DJcXBSA8OkTxEQ8duTVgasxJrEH5e9hapL4yw
qi35won+snSoVC5aal8C4cR5rAV8QUTyUdDDLCrdVGOdxfeeRc2oXXDUgy25kAO4
qC9GygserSiAkTN4RndpjwI1P1izwqrfOByxZ5gCJhTcODN24/DiVMd5ilqSvEBg
r0nYU+tZo+ELvY6B+hRDZVbLnfRK15iiJrig9duhfHWMiApgcOywYRahbDV+p6ph
UabPeoJZ1JqGF4etWEfaIQLkyg6QTg==
=5qTN
-----END PGP SIGNATURE-----

--YtZ2j2bWyKb0/r3q--

