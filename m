Return-Path: <kvm+bounces-32883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 271189E119E
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 04:12:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B72DB227F7
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 03:12:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E38D156220;
	Tue,  3 Dec 2024 03:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="FnX3m2+1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11olkn2034.outbound.protection.outlook.com [40.92.20.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DF01FC3;
	Tue,  3 Dec 2024 03:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.20.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733195554; cv=fail; b=WIz9d+V+cvu9/JFreiXHPVspH/ZLmdTNOkjVxO/U1Bh9buA12FlPH8IiG7S7q4BiLtZrhY/7LymYNOpJizdiwFzxqA7xDMAoGW/d9B4dFRTZHxKRlyB/xRPP5jBVHbPUE6yVak6Re1DTJRAXuYYUIslEtiohIgUg+WYIeJ2NvZo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733195554; c=relaxed/simple;
	bh=Jeja5E2VvUpTCyLbaLM5VP/3vNjYC48W82vZkSpIJs0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aH37bYsLy2B+x9YsQeE/EAcr821uk4+g62FCIqw8Uc1vgUH+OLswmYmknLjtWHeK6YhaegkVLHT/mbKeGm497VhPPN075yNKFhx2Fie7xwHIKNClQY0JRmmaX9edy6uSMr8vyprDS/sE3raVSuKCKiEfPZz9s/C5xzLOMaDfXCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=FnX3m2+1; arc=fail smtp.client-ip=40.92.20.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JBT437YwG/C/miYaKx+fsN2IP/gddGECJX/eMhPKiO1etVq4QnIp/H+he91SoTmtaW3fw49O8/6+vWkwxVPbdHKBtOlgXXS2Fivg+4pswB4fE3yml8qSOroBjs9sgjMnElwTdzxK12iJoFTEL0FXCsFt/lghATQ6ywFHcB4WcZIpiFEJZ9yUcSuWg0nBsDkIQOJMjv3dOhrb1xvCOMmaBrZWOAaICcc1nJHki6C3sqlqBaJJR665ACtPMF+HUPDrhKa+3Ro91Bmf3ujUfLOQbfAu9ksXWz4L4Hvviw92C2osxhk18dMsnwKB11cM3bWKg9+32YbiotE20NVteeNVMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZplPv3xqGvvwUi46639Brdw+EmoWbKI+XpTmDUaTQeI=;
 b=T9Fun+kCLAU04p2has/qPXY3zh1uvIGZRT0KkHjKXsm++VEVjWSt9Xh1bXjQ0Zu7LBrw35YvaTT2FUlz0m585lzZ8dQSu0lTaj+wAT08PJUYzjK2D39PDMJg8nKvQS2NC9l//R8oDmp/F7LlZfNH8/GTO74+Jb7hr7xf/Zsn3gUQom0JSQ5ccQNTttt6sZ2xzuJN69IxPhcSVAjBXT8x2wguj5n2TALkoTEf2fgnzYsCAJxJG/1Ct3+7tsbYg+HsPHaZ96Zj3OwTVL+KVNzF+iIy43az8TtDzKHlqPo9ExGK4TelOutOb8GxYv5npJ250mNcVbx3m//2pbupbgYzEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZplPv3xqGvvwUi46639Brdw+EmoWbKI+XpTmDUaTQeI=;
 b=FnX3m2+1+Bo7vzKfoD/FbgQnZAIFpH9uWMoeW/wrvYGuwZgxXMKOK+25OH2H7cDP//6CU+bROQ+yIZOSVgtDe3hS0iy0Q/8Pfi1ZGjZMYM3tn7P64XAr2Z7R5+XNjdiNvhjTbdujYkbeS72KL7PoPCwIkD+8ZAG4mNe6WG0o37pOEjdgwNnDExWcUU1rEyeH7qt4QR5hxgVAUBjokJCPBU9Ajl65N2D6vDqGCcydDWCLsdisT+iG+aX0JIs4agm58xmG8NU0ZQvym/2zsb9OTfIMcCepWdXDIT2glamiJ2uilLvyZoPYmnXe8l+BQzt8FTdI9F0S0tyWJ4a6UHeNVA==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by DM3PR02MB10276.namprd02.prod.outlook.com (2603:10b6:0:42::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Tue, 3 Dec
 2024 03:12:29 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%7]) with mapi id 15.20.8182.018; Tue, 3 Dec 2024
 03:12:29 +0000
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
Subject: RE: [PATCH, RESEND] x86/mtrr: Rename mtrr_overwrite_state() to
 guest_force_mtrr_state()
Thread-Topic: [PATCH, RESEND] x86/mtrr: Rename mtrr_overwrite_state() to
 guest_force_mtrr_state()
Thread-Index: AQHbRIxOtYAfZHtFM0eAunneB0shz7LT1/sQ
Date: Tue, 3 Dec 2024 03:12:28 +0000
Message-ID:
 <SN6PR02MB4157E858430497AD6687A88CD4362@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20241202073139.448208-1-kirill.shutemov@linux.intel.com>
In-Reply-To: <20241202073139.448208-1-kirill.shutemov@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|DM3PR02MB10276:EE_
x-ms-office365-filtering-correlation-id: 1f260513-a488-4a08-6439-08dd134851f5
x-microsoft-antispam:
 BCL:0;ARA:14566002|15080799006|8060799006|8062599003|19110799003|461199028|4302099013|440099028|3412199025|1602099012|10035399004|102099032;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?oFu6tdQIGfeHVO+F8mWkQ+5p1NMpIZ5/udl0OQ2QA8L/bK0B6QbSvDeLIjF3?=
 =?us-ascii?Q?heA1UvZWm+kfESHkfdzfMBDCO/iEt6+xOqgig672uMv01XA+483VsrLdGfJW?=
 =?us-ascii?Q?9GBZQqutytUCQoQzsjNhViS+Lze7u3GxVjzktKN/28UUf6rmdsR14jq2jWqk?=
 =?us-ascii?Q?K+7KDBuRtvuj8D7xL3pKOMGji2pP1U+6fofl5KXBOzFcS3felnuPfcV+RXAr?=
 =?us-ascii?Q?n4fiujoIkKrGc0FQyeU6MiNh1xmMdS+1YIIR7deunwaFg/AZY6td3NB2EBqM?=
 =?us-ascii?Q?z0ooGD1D52xnQWSGcopfN9uLCJAGHkq71tCSAMpAGAcYnomNbyZxSAeJ75kQ?=
 =?us-ascii?Q?5SZSwZ+0Gc885ivg8ZhFTsIGB4Mts0dXbxdJyakom9aZQDVPDiPZWzTDKQnS?=
 =?us-ascii?Q?NxLWOGqZSMfiiEW4MaO3RDn+BUe1uNZyuVvkKTSMwzZkwtFCnnJ/WijoRpIc?=
 =?us-ascii?Q?V9iZMaZMc6Qc8tRC+EhdyAOUIKlCQxtAeFbYS//vJ2sXmobGAKYE2bclRPp9?=
 =?us-ascii?Q?D0TKDEb6bkkiQb/DCWBmw83h8kRWthDbQmwcABBBLdyRYG7nAxnvIexc1une?=
 =?us-ascii?Q?Tit6euexwLGHGF3m4JeIKmROjHgHi18ZsdYv77okBtdbcQBkmQUv02UaWJcU?=
 =?us-ascii?Q?cTX5NLIeHxUPDZbsEAZz0yh+nuKi18A6In/rvzlJ38zmt+6TbCTzYm93dTTK?=
 =?us-ascii?Q?BHwPei2vLicM4HERNjTPfu6Y9oRoOJiq6XP5BFOcwbgDfpWcvL8lkK6uQGvi?=
 =?us-ascii?Q?h0XmJEF9Mh//y5mG38rlL4d8RnNjNFh9dYBY75FpXDlr5PxeWqecQgzaJVSI?=
 =?us-ascii?Q?sYesVKD72cqjkZAA6dyHReVCLE+og9Iq2yMsJzX51xseYH0aFi31JuI85RTl?=
 =?us-ascii?Q?C2hUk0uvmym1LOw76Z6t0Ax/vI70/+dVnZ8umvMDHR/JuO8FaNhW7wZvilXP?=
 =?us-ascii?Q?YalK5QFPOuPwwYh9aD0D6Ou2cxDLjH4FrGGA1ftIUJJaHSbNPPptGimlhwyo?=
 =?us-ascii?Q?ib/hyvJ6lwBOsFjK76C9nf7lVPUo5Lvk+UjA7kHMVx6cSE/JlfvaTaKs8JEv?=
 =?us-ascii?Q?bRtWW9sKQCNSfjs6PX0hLdRqe13NRGJW9aBVTSFHRpmBUIkjkzUh9HDlLTIH?=
 =?us-ascii?Q?AmSin+yN9sG/ggcVTsoB7MwAtO7fM4OuBGsfTOOdUJ4NrEhgwiCR8uA=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?uIZ0Hx9RVxiHYEwic90WFLW4k0PGWCn9zpPNfR8WdnaENiRu0XHczaaYkXtP?=
 =?us-ascii?Q?2nOtcxOMkGtPKy0/NK5xtUqpTCnFMYCOHBPAK+4avkRPJ94HBpBskN2s3eYU?=
 =?us-ascii?Q?5jJrsaFY3CNcw1Hh7whzOORtjvPp2KzSHBsd6idJBugZcsT0TTCy1hLmt4Mb?=
 =?us-ascii?Q?D5xZnI4wukUVxrVOAp8LMoisJtU/HF4WWrKQsH7WbcKVBqX4WG9KYcOo+am+?=
 =?us-ascii?Q?rX3OMbndrp1lp3lwmiFKEke00/8kMddWkaUYenGuHwRuSKbWIY50A0kTPcrW?=
 =?us-ascii?Q?IieQPyYTjhBL8xH9ojoIGXNTSXrWC9o5+wKymlSSKVNmqMdb7sBVI9PptiLS?=
 =?us-ascii?Q?qkQ2be4OVdZGsqdqMOhl+6iXnO/JxgK7JToJ3Y3F7LWrTpLsW4qkqAPX7fh3?=
 =?us-ascii?Q?qM6xQvBUy1R5ac6aTP/JwZaN0uhoGPH9VRowMxd0ZIYN62yCwc4rWXHnC8jT?=
 =?us-ascii?Q?XBBkSXUJNlbdkFoIUIlavv301X/WrJdaikxef4exEXKX16cCz3+jBhzv+dGf?=
 =?us-ascii?Q?krIhpxFHFuq1xdCVAGJO0HRc9Bmm/KGz2cae2kIFsdpAbI4UPv+5d8Xvi17n?=
 =?us-ascii?Q?QZy6bm4O9nBUXuoEI5XLJ1zAKNqBUPz01OoRgcUtWVEnHJlfQWnafgb9Xaee?=
 =?us-ascii?Q?LAxKF21FnpAZaQbSC4QjkhR/MuOa3EvLDGggdCD/HQ5KJi70XGmqmjiOTxRt?=
 =?us-ascii?Q?5BGaMDro2NgHAp3WZH9nzA3rAHGq+IaXky5BFBt7E+EVl1m29cI/fSM2OiND?=
 =?us-ascii?Q?T9ZqlE6/3lXpSYnqbd+tabOhNAM4ppXysDX4JUBRR96TqMPKlbQDaoM+IKhN?=
 =?us-ascii?Q?LhSCHwmQfHp0GOfeokJzKpTjuXwXyfQrbBuPevvuxaS9BmRSGaPtfKUJrWl0?=
 =?us-ascii?Q?LUGs85yzjvakSVvB2s0gS2v1XVqWmT6aC36uyAQyUhlJadTfGrmBO10iTacW?=
 =?us-ascii?Q?cEneUnqMfTHWsPfnGy5Sr50LXG/h+QQ2fqjQY2/aOfsnubjwr1hcrrLN+8RN?=
 =?us-ascii?Q?RR0jOugbYOCJS6+6X40Yctz156OCyGpH+LrBxf8a0hz0Yr2OJp6iAIg49aFq?=
 =?us-ascii?Q?iEM36nognffg6eHd67aB7TWMdGMH9voFM57cjvRxNlDPX0hJXEor88CXtGzE?=
 =?us-ascii?Q?mUzaiZc7wvuVrtfqbAN2gPVAokE/Zr4JqM637+PAHhfG0uVKCTtjDh6q4J98?=
 =?us-ascii?Q?0ALJLiKVD2t2dpH2Y07sIagok1zwrBMhgwQoLIAK7KtNcrw5oF4XbYrx/i8?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f260513-a488-4a08-6439-08dd134851f5
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2024 03:12:28.9825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR02MB10276

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com> Sent: Sunday, De=
cember 1, 2024 11:32 PM
>=20
> Rename the helper to better reflect its function.
>=20
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Suggested-by: Dave Hansen <dave.hansen@intel.com>
> Acked-by: Dave Hansen <dave.hansen@intel.com>

FWIW, I previously gave my "Reviewed-by" on this patch [1].
I didn't call it out explicitly, but did so for the patch in general
as well as specifically for the Hyper-V related change.

Michael

[1]: https://lore.kernel.org/linux-hyperv/SN6PR02MB4157C91EE70F4EF4B6EDDE46=
D4412@SN6PR02MB4157.namprd02.prod.outlook.com/

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


