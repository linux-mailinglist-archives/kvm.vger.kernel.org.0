Return-Path: <kvm+bounces-44251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 917CFA9BF7C
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 09:15:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09A594A2C01
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 07:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7D692367A7;
	Fri, 25 Apr 2025 07:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qw+6HPRA"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9362356D9;
	Fri, 25 Apr 2025 07:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745565141; cv=none; b=rdEf51y4XLVbSjws7iS//a1rs3UsVytgwaKSdxksWsCMNsl2ehcE8oXdq9JsoZDqaOXPWC1+Z6S7IFwJ6fZTMAwtiXZbHhtFtG0Xgy5lKFy2j/53JcXjZNM7yS4V6mQEYgKBMPdyWaGwRoy2JIcfUQo65iVQBOkcQ1nASDGKCgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745565141; c=relaxed/simple;
	bh=OWCgD4c53AWzLHmGkJc92XOEsxdbIrlrlIzldWXKc9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eMEJ03S67yG/8dxLqUPgWwAK44aMYEAu+MiKPOV4SJrRD0yFA4Km8F/oNk6s1QuZoBKlfrOK3nqTAYJIv9ahzCCz2QsD2pWOzRWLBVhaBiXYjvJ/DdO8aKHMZDYQJEUqTfg+SEIj0dmm4VW5GUEhdaaUjMvpIjBMMhH8EzLj0mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Qw+6HPRA; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/gz49BzCJiWld7uM47beLEzscI0nDdN8PKFhZbH8k1o=; b=Qw+6HPRAw2GLZXmgq20QS8wt0C
	txn/mVTO91ykn5tuFL/uuYfAuUYz48Q+lrxxQKWB2g9D74CKa+ah99c2oA9gm4GaeNVuoBaXtLVTE
	EIQdRwY5DRRXVVw52ts12pvJLUE9HqBbfk09qveKUwveCLkKx6mpx/Pt92hCzjodDWEFS+AyI99lE
	XynTiM71ri22QAuhPkA1dOyMyrvoIpydTtDNIbY90QgKhPVFKkLiMxiJwtrCmY2XuUv18oexVkyGa
	K2Yz5b9lN+AeV19kdukXXE8nn2xl4BF0X2TDbsW+JRVY+YdM++E1hfKHpu8kf3a1t1S5TXUufej/G
	ZpKgJFCw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u8DE6-0000000BzpF-0oO3;
	Fri, 25 Apr 2025 07:11:58 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 9C8B63003C4; Fri, 25 Apr 2025 09:11:57 +0200 (CEST)
Date: Fri, 25 Apr 2025 09:11:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
Cc: "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
	linux-pm@vger.kernel.org, linux-edac@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-acpi@vger.kernel.org,
	linux-hwmon@vger.kernel.org, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, acme@kernel.org,
	andrew.cooper3@citrix.com, namhyung@kernel.org,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, wei.liu@kernel.org,
	ajay.kaher@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
	tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com,
	seanjc@google.com, luto@kernel.org, boris.ostrovsky@oracle.com,
	kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com
Subject: Re: [RFC PATCH v2 21/34] x86/msr: Utilize the alternatives mechanism
 to write MSR
Message-ID: <20250425071157.GI18306@noisy.programming.kicks-ass.net>
References: <20250422082216.1954310-1-xin@zytor.com>
 <20250422082216.1954310-22-xin@zytor.com>
 <b2624e84-6fab-44a3-affc-ce0847cd3da4@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xy1v71s9LdcW622N"
Content-Disposition: inline
In-Reply-To: <b2624e84-6fab-44a3-affc-ce0847cd3da4@suse.com>


--xy1v71s9LdcW622N
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2025 at 11:57:01AM +0200, J=FCrgen Gro=DF wrote:
> On 22.04.25 10:22, Xin Li (Intel) wrote:

> >    This becomes even more silly for trivial instructions like STI/CLI
> >    or in the worst case paravirt_nop().
>=20
> This is nonsense.

What Jurgen says. Someone hasn't done their homework.

static __always_inline void arch_local_irq_disable(void)
{
        PVOP_ALT_VCALLEE0(irq.irq_disable, "cli;", ALT_NOT_XEN);
}

static __always_inline void arch_local_irq_enable(void)
{
        PVOP_ALT_VCALLEE0(irq.irq_enable, "sti;", ALT_NOT_XEN);
}

That very much patches in STI/CLI directly when not Xen.


--xy1v71s9LdcW622N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEv3OU3/byMaA0LqWJdkfhpEvA5LoFAmgLNbQACgkQdkfhpEvA
5LoeWg/8D6ZI5w51DgwY+CTaX5PthgVGKgELCKDw5kBtAe3UxeF/H12T6L6a4XhK
iSGZ9nZg17P5b2kv9cfXnslz/BqlOUjFfT+cuY64cIDvGXPqjbEcWxhHp/O7e34u
L1wOXvlh5ZnWkVUPbeIFgLxCqPqOnGBpsq0LrQwaCxbEzkB5wKqS57h2ooqsrloQ
V4WBwabMJ/lp704zpEgcqzWhM8zWydjPgfGuCZUTbVlvc4pgAGAwktnRd7ot+D4x
n9UbVvBHSzW53t3RpsrzcQkVDGirtlcIipDUbPeIyTs+ArR+xfBiEl7QvXz1liAg
GiJ7aNB/6PybXktHZBkEoRd/3sPBavWiOc1TMriCjWit/pNE+GJjUUozds3kRe/v
pwMTYEbXlPYsgYv121YZpFaaz1ihVlIpnDj/6aqMTe+KQhAziId4CtU8pfSHYZi3
EgC+1PUUySs0LV4TkieDsk1zmfG1lDvWNe5UKyuFYKQ/A99Kg3BacBJHc+PrZDMq
X7MfWZLRG++yhbcBPfHasl6Vg++GagMpoJLKp5zC9QaTUjRdvYm36SR0NvOC+BAt
NPIq3H7qbBLYR0JBaJrgNSqe+1rPgJooo5PYg1Ozmv4q50Umlai3coKqls3pnTIe
zwUVnBTjAszAW1zI3BcSrm5Ol912qJXA7AzxV+FRiKDC+kIRaU4=
=t7cf
-----END PGP SIGNATURE-----

--xy1v71s9LdcW622N--

