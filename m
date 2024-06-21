Return-Path: <kvm+bounces-20212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2856911DF7
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 10:10:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5D7B1C20384
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 08:10:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 055D716FF37;
	Fri, 21 Jun 2024 08:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="KQyoiFQ/"
X-Original-To: kvm@vger.kernel.org
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146EE16D33D;
	Fri, 21 Jun 2024 08:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.153.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718956911; cv=none; b=KjymtPuCGUJobNvW20GY59/eDzIbzKJz4Vin0hvHUl8PVHThcxyY9+g5COVVkb9Tkb/9cFhLcijB92lRRZuEDDFlktnuyv/52rxdXv7pwDvY5Isfb2G6s9MihTDI1ydoGSkhmHr7Ft/rpHvshyA7Kgztf6vy721dH90Lpj+QA/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718956911; c=relaxed/simple;
	bh=/8U21ieG/xam9mqjZuainYvWT0HJGgXaxs10B0hv06I=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jyex8pUCJt7bILW5w1Syqalrvp1958lnvykQKAJHp2YSbaaWdjFYscTgy/EJZm2cKRDiJzbDaTu4s7umWh6cqPBlUbp57Knrkz2q88cxatWKLlgvHC7uw2057MuZj/S4ZJnPtS5tqGJIhhLJ9+VpGe7RK7SFagvvK7RNB979XWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=KQyoiFQ/; arc=none smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1718956909; x=1750492909;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/8U21ieG/xam9mqjZuainYvWT0HJGgXaxs10B0hv06I=;
  b=KQyoiFQ/7NUlZigpmpOC7tXa4YiVHEh0PNGKz38VA+yux7rtfLy9iqk0
   JCMm1fcV8yDThY2nEcX6PVYMmTSyry48ulX57twiSgxZzs9vs/JbmfrvS
   gT1Q/MYgqntAms0b/O9zSKmLmKxnXbt99vPbcvU3O1wSpK230Yxmg8P4T
   hQ3PUca3SWFeG74l2ZZt6T4XGSGjlRLDcXxaMYc6lCztFPypypTZZeMi8
   QJUO0vao1DfoXaMXZm5rnWs1pcutf4xADLg6YkGfpSOz6UXesBF5LLk4Z
   gT5br5iOlTEnl8aaoDPSXjtc1LlVvhs0xydS1OjxQf5ksk87ibmM4Aiwh
   A==;
X-CSE-ConnectionGUID: OYcrU40nQFmm0LLNhIk6Pw==
X-CSE-MsgGUID: uI1EHhk1Q9y5tyT8v//LiQ==
X-IronPort-AV: E=Sophos;i="6.08,254,1712646000"; 
   d="asc'?scan'208";a="259202488"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Jun 2024 01:01:40 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 21 Jun 2024 01:01:29 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex01.mchp-main.com (10.10.85.143)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Frontend
 Transport; Fri, 21 Jun 2024 01:01:24 -0700
Date: Fri, 21 Jun 2024 09:01:05 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Alexandre Ghiti <alex@ghiti.fr>
CC: Yong-Xuan Wang <yongxuan.wang@sifive.com>, <linux-kernel@vger.kernel.org>,
	<linux-riscv@lists.infradead.org>, <kvm-riscv@lists.infradead.org>,
	<kvm@vger.kernel.org>, <apatel@ventanamicro.com>, <ajones@ventanamicro.com>,
	<greentime.hu@sifive.com>, <vincent.chen@sifive.com>, Jinyu Tang
	<tjytimi@163.com>, Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
	<palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Anup Patel
	<anup@brainfault.org>, Mayuresh Chitale <mchitale@ventanamicro.com>, Atish
 Patra <atishp@rivosinc.com>, wchen <waylingii@gmail.com>, Samuel Ortiz
	<sameo@rivosinc.com>, =?iso-8859-1?Q?Cl=E9ment_L=E9ger?=
	<cleger@rivosinc.com>, Evan Green <evan@rivosinc.com>, Xiao Wang
	<xiao.w.wang@intel.com>, Alexandre Ghiti <alexghiti@rivosinc.com>, Andrew
 Morton <akpm@linux-foundation.org>, "Mike Rapoport (IBM)" <rppt@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>, Samuel Holland
	<samuel.holland@sifive.com>, Jisheng Zhang <jszhang@kernel.org>, Charlie
 Jenkins <charlie@rivosinc.com>, "Matthew Wilcox (Oracle)"
	<willy@infradead.org>, Leonardo Bras <leobras@redhat.com>
Subject: Re: [PATCH v5 1/4] RISC-V: Add Svade and Svadu Extensions Support
Message-ID: <20240621-enchanted-unfasten-6d71b1ecd791@wendy>
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
 <20240605121512.32083-2-yongxuan.wang@sifive.com>
 <09f427cd-74ad-4aa5-81b1-995af2b6e1d1@ghiti.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="5AFAaEg/n/Anupu4"
Content-Disposition: inline
In-Reply-To: <09f427cd-74ad-4aa5-81b1-995af2b6e1d1@ghiti.fr>

--5AFAaEg/n/Anupu4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2024 at 09:52:01AM +0200, Alexandre Ghiti wrote:
> On 05/06/2024 14:15, Yong-Xuan Wang wrote:
> > Svade and Svadu extensions represent two schemes for managing the PTE A=
/D
> > +/*
> > + * Both Svade and Svadu control the hardware behavior when the PTE A/D=
 bits need to be set. By
> > + * default the M-mode firmware enables the hardware updating scheme wh=
en only Svadu is present in
> > + * DT.
> > + */
> > +#define arch_has_hw_pte_young arch_has_hw_pte_young
> > +static inline bool arch_has_hw_pte_young(void)
> > +{
> > +	return riscv_has_extension_unlikely(RISCV_ISA_EXT_SVADU) &&
> > +	       !riscv_has_extension_likely(RISCV_ISA_EXT_SVADE);
> > +}
>=20
>=20
> AFAIK, the riscv_has_extension_*() macros will use the content of the
> riscv,isa string. So this works fine for now with the description you
> provided in the cover letter, as long as we don't have the FWFT SBI
> extension. I'm wondering if we should not make sure it works when FWFT la=
nds
> because I'm pretty sure we will forget about this.
>=20
> So I think we should check the availability of SBI FWFT and use some glob=
al
> variable that tells if svadu is enabled or not instead of this check.

No. If FWFT stuff arrives, it should be plumbed into exactly the same
interface. "Users" should not have to think about where the extension is
probed from and be able to use the same interface regardless.

The interfaces we have have already caused some confusion, we should not
make them worse.

--5AFAaEg/n/Anupu4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZnUzNAAKCRB4tDGHoIJi
0uuGAP9Bm5ygy05cg4wKg5y9lqC76rVPgngZCQO1I648KyMFrwD+M1+iBKLXKdDH
xaTCLonuJOr+ErXPGNikXsfRBCcP5A8=
=HAt6
-----END PGP SIGNATURE-----

--5AFAaEg/n/Anupu4--

