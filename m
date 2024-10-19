Return-Path: <kvm+bounces-29191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CB70A9A4B40
	for <lists+kvm@lfdr.de>; Sat, 19 Oct 2024 07:11:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E96E1F22F22
	for <lists+kvm@lfdr.de>; Sat, 19 Oct 2024 05:11:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41FB01D61B5;
	Sat, 19 Oct 2024 05:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="cNdaZ/U6"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazolkn19010016.outbound.protection.outlook.com [52.103.2.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE7818872A;
	Sat, 19 Oct 2024 05:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.2.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729314682; cv=fail; b=XdaZ8ubTDxnbWmHTSq81Jpr5qRLTwq9EoZIUeX1DfWxwcg5MACKQGf1JupRwszmmJqImGhC9VBcHcISDk52J59EK1p+rkPA/MRY/3T247P7aftgYZsbdiCUaYiNCixuzcOO8BdtTvfVe1WGZet+e8h3lKBNMGe5TSyP2sYB1lvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729314682; c=relaxed/simple;
	bh=N1NCsCQq/a2UuLlDV7NAxwk+2iQGe0OFfpL5J7MIph8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S6yhhIzNwwk5kvMkMak2h7n5gms0uWlOouQlKjR9xLR0N7DO4i11EglOg1Z1RIS3mvkuCDoFOme4/sLYDEuO5Ol+Xi+VAC9xW3Li/k321xgLIKK4v77hzTr0jnRHGrEZ4p31VyX8uFHtVQuSLMxgtdT7JlIelGVpIoRRmsNP7XY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=cNdaZ/U6; arc=fail smtp.client-ip=52.103.2.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yag//04gAqOpfmxdKVj/HTqSZDrv96reG9dnjPnmbl8DlYGkZ4wNR8PaU+wmk6rTHaUwXuv97mUVEQGS5nHRIzfgr0XqeaslAoJlDq0w7FTdGDZ3m77SV8kW/BDdnpBEQrD1v0+qsPRHT6pKxa69OgoruD7XyLVvREMJ2AaiIrpplko3c9QuFjAEcMwDd9g6L4DrMCXadvLD+KX6ldvGeKWLZv1IQIjES0+HuzqZATdnX0or012Eg37XeOAbodwEL/ff8NevherWXsP+a2A0KJgPPi7TZ/CmRSxNCcDUMP0GH25+A6trd8+kTXM10GItxTxQlNEsH44tPdAWb7P0BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=llm5civONHWGtFjuGCu8jsP/ljZTLecaUgeevi0V1eM=;
 b=wbze2gSglj1UokBZ04wrTa3y1HN6rLXPaQKaMlRFf1UkWOfUdtwcizzXia47BNZ6Q2NugzsWcnkCqBA0eiDCk1anpQfF4gf1R4a3nQCstYHi75UuzNRp1OZ10y5rAfXqvWWSd4ap4DBbFJkFz2YKAFcFVcln7AtLImzSFPmi/QuyXn4ohqj1tEj1CdQa6VPG9FfRKSivE0lvWuh6xHBFGSBowdIcTcKdITmOFvRsNAw+1JRG5skP7WVazmC8LOREyAzK5qiDTgUTy8Bz217dAbTvdPXu+6kCEHMrdhFDStonUN4rdLQYpsi5ciUAOGsleu9RgN0rJPJkGrcg8Zfevg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=llm5civONHWGtFjuGCu8jsP/ljZTLecaUgeevi0V1eM=;
 b=cNdaZ/U60VFIAuDMWFbWg0DlGvA7PCjBzM6GDiVJFd6zm5k+WiSKrQTKWIELSvz41sq73C770pwH00Xg8tYbQdtDuJ8wO0DzpxBde5nruYzUbg0VUAOPQaJRMC6m8lRvU9pDNWdrh/02NWpbcx2dlOE7aY+ZLl3WBhaus8lbiFXLpNbM85w9lCRMTcQOlm7TScr2EYF1qVNx4DZOplLVRhC0XWBp18BaVTWW3L52rsVe1K5HXTYYRuj29N7IevELvnpcKV8a784pxS980eWY917kTCsBAM6s31d7uYo+sBMJd4OOyev7Ao2CohDsZPgkN2f489b4Glw/o9hF6pnnAQ==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by CY8PR02MB9425.namprd02.prod.outlook.com (2603:10b6:930:73::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18; Sat, 19 Oct
 2024 05:11:16 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%3]) with mapi id 15.20.8069.016; Sat, 19 Oct 2024
 05:11:16 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>
CC: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang
	<haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui
	<decui@microsoft.com>, "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Juergen Gross
	<jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Gaosheng Cui
	<cuigaosheng1@huawei.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, Kai Huang
	<kai.huang@intel.com>, Andi Kleen <ak@linux.intel.com>, Sean Christopherson
	<seanjc@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "xen-devel@lists.xenproject.org"
	<xen-devel@lists.xenproject.org>, Dave Hansen <dave.hansen@intel.com>
Subject: RE: [PATCH] x86/mtrr: Rename mtrr_overwrite_state() to
 guest_force_mtrr_state()
Thread-Topic: [PATCH] x86/mtrr: Rename mtrr_overwrite_state() to
 guest_force_mtrr_state()
Thread-Index: AQHbH7lXKN74uyRaU0+LX19wrvgpfbKNiJAw
Date: Sat, 19 Oct 2024 05:11:16 +0000
Message-ID:
 <SN6PR02MB4157C91EE70F4EF4B6EDDE46D4412@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20241015095818.357915-1-kirill.shutemov@linux.intel.com>
 <20241016105048.757081-1-kirill.shutemov@linux.intel.com>
In-Reply-To: <20241016105048.757081-1-kirill.shutemov@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|CY8PR02MB9425:EE_
x-ms-office365-filtering-correlation-id: af00db32-885f-4cac-75fb-08dceffc7573
x-microsoft-antispam:
 BCL:0;ARA:14566002|15080799006|8060799006|461199028|8062599003|19110799003|102099032|440099028|3412199025;
x-microsoft-antispam-message-info:
 lB7isbQS0VOlEiWsmJuxnBKWBpsIbjc5N6hU3ZhsWX/4ObibUllBxSvWodpFVsjYsYGXXN/xKnxGwPkSyQ9ASfjrmI7qOs0VyRHtX9S5mbQ/QCOsh+GpTj1DkzbUxQEqWCAGXCCg33XqW9Bu9iOL2/jxUTmeZgNsZxJ+D8zZNQAyOfJlgcg6+q4gyOgDig6tQ7tIleXweyWIKY3xV0cViUW0QrihB4zvRj/UuQsSh7UVbAv2trxv8ZbWepkoUp5wfQVL8URkhuHAj9Cf+2NrTI0zlFg8qTJT0HjpnLWIHFxme3fEmTHpaRvzJf594nkNPJMTx9VyRmLHYOyNwENgx+OPnvm6z/j7aPYARfilKdXb3HRiw/H8yvP72Yb5hCdPPgnXbDOlV2pgV8xe6XJWxCsMoQId8ZWrTt9PZHhW4IwD4cU/qXePHYGJLaN7PBOqstzlPJTACDwSRxb7f9+oCv6fb807+gASZxwOvLxeOg5oABDnx3G5RL9AoB5AfKN1/V+9PYulS5LBrjntAzq8cNvRIEVly2BwtnBSlKIkoV7+VySScWCeyER4d1ZYsigFBdTuKtPtOMzH/HNDRCO3+xR/9zbZjUkLxw2kUel70Hh+UODLZZs2JzvxcXREJ2ix/ExAfG8FkxsEGIKrM+Ahxck+EJ+49swn+Bviw2qZBdGTQ/ov/HIT8ys1LoE84/1NaYxFRX6RheTw3ediHrjKOA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?WuAQ5V+pUZJdlWkPr1YxbICXRIQwjULl7wH9bxdcIieJW7V1d4L6wj86l2ub?=
 =?us-ascii?Q?sr4XDvNfvFRss7hcmbrKqw9ImTAmzXkYVW+bOUBc8ReFggHceYagWZ2szZBO?=
 =?us-ascii?Q?ryzdY0Ap1fYniDQyuXQ0WfZ2108Em3lVmr+sWxBGL1u4l18zdi4feDjQL81z?=
 =?us-ascii?Q?Cv7TEIqPIhAQbMYeO7BDkAKq1mdCv9R+H1Ym94CYpZgGXlpe5ZPXhvGnKyCX?=
 =?us-ascii?Q?HA1Vzc8kdn8Umn4txDVLsXlmxUKju5B9CNiVE1sKn+SwCWCCwnCxJnhgMRVd?=
 =?us-ascii?Q?Cebo5sZA3/ge7ou99arQAvzWFrP3fW8AmGx2Ue12xDwWXpINmNN9XxHbVC/Y?=
 =?us-ascii?Q?tq2GS5RV48plG29KkBVyImZnqGofCIOiVUIhXPZWXcg5Yk1kxOwbf6I0wFVv?=
 =?us-ascii?Q?6wDDIOmj8tdIAwMRi1opAkSoqydGbkC4CjOaK0VeBUHCYmzvKhcV+eLia3Pj?=
 =?us-ascii?Q?X8Z9l6/jIwpWYCe41zvj3mBC1xsm9Xdddg2hqKRcmsIlyrdVKDb89k/iZreC?=
 =?us-ascii?Q?ZuDL8gUBLITk/uWFJmWuJ3h7eDIhTzLWzAJbrbVRN+ef8GUx3/Skdr75uQYp?=
 =?us-ascii?Q?orqVwwrZrMftQ1WalrSI43VZqdbT+aWGfrU8Bz0BrOgihWbu3AW/lszkOUAG?=
 =?us-ascii?Q?v2mNdHtg5dZJC8yE5EerxQCRB96YbK6BO0OGwPSg0efcWcAGe+eQjJ+XbccK?=
 =?us-ascii?Q?qpvi1or5tcX0mjmIg6sYIQCSMhOwNfWLbXvnKyYs59oFpmy2lThvmJUf7DHP?=
 =?us-ascii?Q?FMJGUOVZcspwehk6/ea3Zk9oTyCZDtS5Im6lrx09+MHhIZ29UFn05k5zD+z+?=
 =?us-ascii?Q?gMqEi14QdIU/ezYVtqcXaMIReiGwUxZ9rNy3vwSuF2dIxDwpExLjgACWoD+3?=
 =?us-ascii?Q?eSjo0/Tl+kC+IOgP9Iw/nQciqdiI729EoFLDl0MhiZG9sa1HG1HteL5M62X3?=
 =?us-ascii?Q?cu1wGwzyZNYXwviB+31TgQcEtShVqAH9yENy5M2cJca3qTBMgzzJjl3v4aoK?=
 =?us-ascii?Q?c8qoUNeZJFsmJqWgnoKVSumFof2m3lTUW1SsJhNemtjp/SnwOizIvncdz6Ex?=
 =?us-ascii?Q?TxCAGJ7czrMnChnzn0af0iONNJuAgZKv2TB3GvX9VSRk67Vq2Antx3kBr5vM?=
 =?us-ascii?Q?NUcjRsN9TCSiEsXl5Rf/xn2IBP0sCVaVg+/ma9iPeqsCT5nTbXTo1iQrl4hc?=
 =?us-ascii?Q?g3FwpFOSgV25ugMqDZxSNMPLWNVs+ydACMfXSJnwq3QqfrJvQF9+JemkUEs?=
 =?us-ascii?Q?=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR02MB4157.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: af00db32-885f-4cac-75fb-08dceffc7573
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2024 05:11:16.0574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR02MB9425

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com> Sent: Wednesday,=
 October 16, 2024 3:51 AM
>=20
> Rename the helper to better reflect its function.
>=20
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Suggested-by: Dave Hansen <dave.hansen@intel.com>
> ---
>  arch/x86/hyperv/ivm.c              |  2 +-
>  arch/x86/include/asm/mtrr.h        | 10 +++++-----
>  arch/x86/kernel/cpu/mtrr/generic.c |  6 +++---
>  arch/x86/kernel/cpu/mtrr/mtrr.c    |  2 +-
>  arch/x86/kernel/kvm.c              |  2 +-
>  arch/x86/xen/enlighten_pv.c        |  4 ++--
>  6 files changed, 13 insertions(+), 13 deletions(-)
>=20
> diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
> index 60fc3ed72830..90aabe1fd3b6 100644
> --- a/arch/x86/hyperv/ivm.c
> +++ b/arch/x86/hyperv/ivm.c
> @@ -664,7 +664,7 @@ void __init hv_vtom_init(void)
>  	x86_platform.guest.enc_status_change_finish =3D hv_vtom_set_host_visibi=
lity;
>=20
>  	/* Set WB as the default cache mode. */
> -	mtrr_overwrite_state(NULL, 0, MTRR_TYPE_WRBACK);
> +	guest_force_mtrr_state(NULL, 0, MTRR_TYPE_WRBACK);
>  }
>=20
>  #endif /* defined(CONFIG_AMD_MEM_ENCRYPT) ||
> defined(CONFIG_INTEL_TDX_GUEST) */
> diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
> index 4218248083d9..c69e269937c5 100644
> --- a/arch/x86/include/asm/mtrr.h
> +++ b/arch/x86/include/asm/mtrr.h
> @@ -58,8 +58,8 @@ struct mtrr_state_type {
>   */
>  # ifdef CONFIG_MTRR
>  void mtrr_bp_init(void);
> -void mtrr_overwrite_state(struct mtrr_var_range *var, unsigned int num_v=
ar,
> -			  mtrr_type def_type);
> +void guest_force_mtrr_state(struct mtrr_var_range *var, unsigned int num=
_var,
> +			    mtrr_type def_type);
>  extern u8 mtrr_type_lookup(u64 addr, u64 end, u8 *uniform);
>  extern void mtrr_save_fixed_ranges(void *);
>  extern void mtrr_save_state(void);
> @@ -75,9 +75,9 @@ void mtrr_disable(void);
>  void mtrr_enable(void);
>  void mtrr_generic_set_state(void);
>  #  else
> -static inline void mtrr_overwrite_state(struct mtrr_var_range *var,
> -					unsigned int num_var,
> -					mtrr_type def_type)
> +static inline void guest_force_mtrr_state(struct mtrr_var_range *var,
> +					  unsigned int num_var,
> +					  mtrr_type def_type)
>  {
>  }
>=20
> diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtr=
r/generic.c
> index 7b29ebda024f..2fdfda2b60e4 100644
> --- a/arch/x86/kernel/cpu/mtrr/generic.c
> +++ b/arch/x86/kernel/cpu/mtrr/generic.c
> @@ -423,7 +423,7 @@ void __init mtrr_copy_map(void)
>  }
>=20
>  /**
> - * mtrr_overwrite_state - set static MTRR state
> + * guest_force_mtrr_state - set static MTRR state for a guest
>   *
>   * Used to set MTRR state via different means (e.g. with data obtained f=
rom
>   * a hypervisor).
> @@ -436,8 +436,8 @@ void __init mtrr_copy_map(void)
>   * @num_var: length of the @var array
>   * @def_type: default caching type
>   */
> -void mtrr_overwrite_state(struct mtrr_var_range *var, unsigned int num_v=
ar,
> -			  mtrr_type def_type)
> +void guest_force_mtrr_state(struct mtrr_var_range *var, unsigned int num=
_var,
> +			    mtrr_type def_type)
>  {
>  	unsigned int i;
>=20
> diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.c b/arch/x86/kernel/cpu/mtrr/m=
trr.c
> index 989d368be04f..ecbda0341a8a 100644
> --- a/arch/x86/kernel/cpu/mtrr/mtrr.c
> +++ b/arch/x86/kernel/cpu/mtrr/mtrr.c
> @@ -625,7 +625,7 @@ void mtrr_save_state(void)
>  static int __init mtrr_init_finalize(void)
>  {
>  	/*
> -	 * Map might exist if mtrr_overwrite_state() has been called or if
> +	 * Map might exist if guest_force_mtrr_state() has been called or if
>  	 * mtrr_enabled() returns true.
>  	 */
>  	mtrr_copy_map();
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 21e9e4845354..7a422a6c5983 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -983,7 +983,7 @@ static void __init kvm_init_platform(void)
>  	x86_platform.apic_post_init =3D kvm_apic_init;
>=20
>  	/* Set WB as the default cache mode for SEV-SNP and TDX */
> -	mtrr_overwrite_state(NULL, 0, MTRR_TYPE_WRBACK);
> +	guest_force_mtrr_state(NULL, 0, MTRR_TYPE_WRBACK);
>  }
>=20
>  #if defined(CONFIG_AMD_MEM_ENCRYPT)
> diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
> index d6818c6cafda..633469fab536 100644
> --- a/arch/x86/xen/enlighten_pv.c
> +++ b/arch/x86/xen/enlighten_pv.c
> @@ -171,7 +171,7 @@ static void __init xen_set_mtrr_data(void)
>=20
>  	/* Only overwrite MTRR state if any MTRR could be got from Xen. */
>  	if (reg)
> -		mtrr_overwrite_state(var, reg, MTRR_TYPE_UNCACHABLE);
> +		guest_force_mtrr_state(var, reg, MTRR_TYPE_UNCACHABLE);
>  #endif
>  }
>=20
> @@ -195,7 +195,7 @@ static void __init xen_pv_init_platform(void)
>  	if (xen_initial_domain())
>  		xen_set_mtrr_data();
>  	else
> -		mtrr_overwrite_state(NULL, 0, MTRR_TYPE_WRBACK);
> +		guest_force_mtrr_state(NULL, 0, MTRR_TYPE_WRBACK);
>=20
>  	/* Adjust nr_cpu_ids before "enumeration" happens */
>  	xen_smp_count_cpus();
> --
> 2.45.2
>=20

LGTM
Reviewed-by: Michael Kelley <mhklinux@outlook.com>

