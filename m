Return-Path: <kvm+bounces-20234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C289912257
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:25:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E0EBDB21219
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 10:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FD39171645;
	Fri, 21 Jun 2024 10:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="YgqBa/Nu"
X-Original-To: kvm@vger.kernel.org
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9387197;
	Fri, 21 Jun 2024 10:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718965496; cv=none; b=sZY/4A9IQctr3mg0oHhgrWOlXLJjwEv/luHxVm4oXRb2P0V7r8Oii8v76gHJwxmXVznADb5LFO2IoXnI+fwMYGJRX6cxhBpHSSyYrX/lOj1XtYTO6AxrwovV8VYunMDPPjbWBvtKYJ7H2oklWv1+fyBqorHCnNGilNkAZyo/8rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718965496; c=relaxed/simple;
	bh=uZ+MY3E/RbmCK3hzLvClaKhQpnThw2y5EurerNSCszs=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TKxjd+6TBMialPboGscQGhKdW9X1XnuJ22/C7vejbeluCAkK79McesCGQgLi09nWQ+NS0aWV25v224tEqYBR5tTAEtnyUCLJ81nW66RujBYjhHmn4CUzk/uDdSELwotv0AEwF9bvZC9hQ7qliOeTmbBYCVljSGzj+XC+3CYFZPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=YgqBa/Nu; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1718965494; x=1750501494;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uZ+MY3E/RbmCK3hzLvClaKhQpnThw2y5EurerNSCszs=;
  b=YgqBa/NuAkwq82zUdFAjQ0F2Ci9LCTuZRhPiQX8BywjXrhFa8lZ0h94k
   Sl4sNuwMJuipKlpMUGKySYv52VCpaEgxnGglU1tUQ94AnFgNvScrM/a0N
   V+xYZKqjhhcsWP5No1dyXo1SW2PsEXLBFQc12lm1zYErJoLCeVaN9oJWn
   aOUC4Jtd0pVESgt4mBsDXrmcwBZMevY4OYD/wpc9JvXKqYIKdBMRKk812
   MSyM8KRxb8qTodH82jb0sJalklM0W7H75ttP6kjfqgzlg+l2BJnX6q5Ha
   oUFmr58GVJAptmeyWSDwWmnZSKKj7nW1o4FcGrZd5ATdMD3wm367SE++s
   A==;
X-CSE-ConnectionGUID: bErWBs7qSkOvRV01FLxzrA==
X-CSE-MsgGUID: KIP2OomJSsaAuQf5fKD3lA==
X-IronPort-AV: E=Sophos;i="6.08,254,1712646000"; 
   d="asc'?scan'208";a="195731658"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Jun 2024 03:24:53 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 21 Jun 2024 03:24:43 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex02.mchp-main.com (10.10.85.144)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Frontend
 Transport; Fri, 21 Jun 2024 03:24:37 -0700
Date: Fri, 21 Jun 2024 11:24:19 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Andrew Jones <ajones@ventanamicro.com>
CC: Yong-Xuan Wang <yongxuan.wang@sifive.com>, <linux-kernel@vger.kernel.org>,
	<linux-riscv@lists.infradead.org>, <kvm-riscv@lists.infradead.org>,
	<kvm@vger.kernel.org>, <apatel@ventanamicro.com>, <alex@ghiti.fr>,
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
Message-ID: <20240621-nutty-penknife-ca541ee5108d@wendy>
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
 <20240605121512.32083-2-yongxuan.wang@sifive.com>
 <20240621-d1b77d43adacaa34337238c2@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="0UoLULy78srbKCqT"
Content-Disposition: inline
In-Reply-To: <20240621-d1b77d43adacaa34337238c2@orel>

--0UoLULy78srbKCqT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2024 at 10:43:58AM +0200, Andrew Jones wrote:
> On Wed, Jun 05, 2024 at 08:15:07PM GMT, Yong-Xuan Wang wrote:
> > Svade and Svadu extensions represent two schemes for managing the PTE A=
/D
> > bits. When the PTE A/D bits need to be set, Svade extension intdicates
> > that a related page fault will be raised. In contrast, the Svadu extens=
ion
> > supports hardware updating of PTE A/D bits. Since the Svade extension is
> > mandatory and the Svadu extension is optional in RVA23 profile, by defa=
ult
> > the M-mode firmware will enable the Svadu extension in the menvcfg CSR
> > when only Svadu is present in DT.
> >=20
> > This patch detects Svade and Svadu extensions from DT and adds
> > arch_has_hw_pte_young() to enable optimization in MGLRU and
> > __wp_page_copy_user() when we have the PTE A/D bits hardware updating
> > support.
> >=20
> > Co-developed-by: Jinyu Tang <tjytimi@163.com>
> > Signed-off-by: Jinyu Tang <tjytimi@163.com>
> > Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> > ---
> >  arch/riscv/Kconfig               |  1 +
> >  arch/riscv/include/asm/csr.h     |  1 +
> >  arch/riscv/include/asm/hwcap.h   |  2 ++
> >  arch/riscv/include/asm/pgtable.h | 14 +++++++++++++-
> >  arch/riscv/kernel/cpufeature.c   |  2 ++
> >  5 files changed, 19 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> > index b94176e25be1..dbfe2be99bf9 100644
> > --- a/arch/riscv/Kconfig
> > +++ b/arch/riscv/Kconfig
> > @@ -36,6 +36,7 @@ config RISCV
> >  	select ARCH_HAS_PMEM_API
> >  	select ARCH_HAS_PREPARE_SYNC_CORE_CMD
> >  	select ARCH_HAS_PTE_SPECIAL
> > +	select ARCH_HAS_HW_PTE_YOUNG
> >  	select ARCH_HAS_SET_DIRECT_MAP if MMU
> >  	select ARCH_HAS_SET_MEMORY if MMU
> >  	select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
> > diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> > index 25966995da04..524cd4131c71 100644
> > --- a/arch/riscv/include/asm/csr.h
> > +++ b/arch/riscv/include/asm/csr.h
> > @@ -195,6 +195,7 @@
> >  /* xENVCFG flags */
> >  #define ENVCFG_STCE			(_AC(1, ULL) << 63)
> >  #define ENVCFG_PBMTE			(_AC(1, ULL) << 62)
> > +#define ENVCFG_ADUE			(_AC(1, ULL) << 61)
> >  #define ENVCFG_CBZE			(_AC(1, UL) << 7)
> >  #define ENVCFG_CBCFE			(_AC(1, UL) << 6)
> >  #define ENVCFG_CBIE_SHIFT		4
> > diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hw=
cap.h
> > index e17d0078a651..35d7aa49785d 100644
> > --- a/arch/riscv/include/asm/hwcap.h
> > +++ b/arch/riscv/include/asm/hwcap.h
> > @@ -81,6 +81,8 @@
> >  #define RISCV_ISA_EXT_ZTSO		72
> >  #define RISCV_ISA_EXT_ZACAS		73
> >  #define RISCV_ISA_EXT_XANDESPMU		74
> > +#define RISCV_ISA_EXT_SVADE             75
> > +#define RISCV_ISA_EXT_SVADU		76
> > =20
> >  #define RISCV_ISA_EXT_XLINUXENVCFG	127
> > =20
> > diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/=
pgtable.h
> > index aad8b8ca51f1..7287ea4a6160 100644
> > --- a/arch/riscv/include/asm/pgtable.h
> > +++ b/arch/riscv/include/asm/pgtable.h
> > @@ -120,6 +120,7 @@
> >  #include <asm/tlbflush.h>
> >  #include <linux/mm_types.h>
> >  #include <asm/compat.h>
> > +#include <asm/cpufeature.h>
> > =20
> >  #define __page_val_to_pfn(_val)  (((_val) & _PAGE_PFN_MASK) >> _PAGE_P=
FN_SHIFT)
> > =20
> > @@ -288,7 +289,6 @@ static inline pte_t pud_pte(pud_t pud)
> >  }
> > =20
> >  #ifdef CONFIG_RISCV_ISA_SVNAPOT
> > -#include <asm/cpufeature.h>
> > =20
> >  static __always_inline bool has_svnapot(void)
> >  {
> > @@ -624,6 +624,18 @@ static inline pgprot_t pgprot_writecombine(pgprot_=
t _prot)
> >  	return __pgprot(prot);
> >  }
> > =20
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
>=20
> It's hard to guess what is, or will be, more likely to be the correct
> choice of call between the _unlikely and _likely variants. But, while we
> assume svade is most prevalent right now, it's actually quite unlikely
> that 'svade' will be in the DT, since DTs haven't been putting it there
> yet. Anyway, it doesn't really matter much and maybe the _unlikely vs.
> _likely variants are better for documenting expectations than for
> performance.

binding hat off, and kernel hat on, what do we actually do if there's
neither Svadu or Svade in the firmware's description of the hardware?
Do we just arbitrarily turn on Svade, like we already do for some
extensions:
	/*
	 * These ones were as they were part of the base ISA when the
	 * port & dt-bindings were upstreamed, and so can be set
	 * unconditionally where `i` is in riscv,isa on DT systems.
	 */
	if (acpi_disabled) {
		set_bit(RISCV_ISA_EXT_ZICSR, isainfo->isa);
		set_bit(RISCV_ISA_EXT_ZIFENCEI, isainfo->isa);
		set_bit(RISCV_ISA_EXT_ZICNTR, isainfo->isa);
		set_bit(RISCV_ISA_EXT_ZIHPM, isainfo->isa);
	}


--0UoLULy78srbKCqT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZnVU0wAKCRB4tDGHoIJi
0tO+AP9fSCy8DKEUzhWJLZKCX9bDiwMGYDTUA7ScliHR3a5XqAEA2XsW/dKpr/Rc
Rn7YzOV3QPOW5f7vXy+CiO6Rf2HnEgk=
=8GSV
-----END PGP SIGNATURE-----

--0UoLULy78srbKCqT--

