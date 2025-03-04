Return-Path: <kvm+bounces-39958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DBFCEA4D27A
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 05:18:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA0871623C6
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 04:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 495E41F4607;
	Tue,  4 Mar 2025 04:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="G/T2MRfH"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazolkn19012042.outbound.protection.outlook.com [52.103.7.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24921DB13E;
	Tue,  4 Mar 2025 04:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.7.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741061879; cv=fail; b=PCjxjNX1Xt065oXVEtBcB/Ow7nRi97PIjAA+1NSoPzfpjJ45md8K30d0F2Pnl166RJGm9dtOzYv8ilkZEv1ysXttbYxKZ2tqlpJY5u/KsVnC6XD5k8u8Blpdg9P1kfZpml0xm6htVHtJ6QlFfLUcucMlB6LIr9db0qFqVNPaFIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741061879; c=relaxed/simple;
	bh=HKxrgjQ4hn7cGk6YrTpXaf6mYC14qbG/wGSXJNMCtz4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DfiOvdQ5Nh6ign9QTts2qafcUDoLoZM1l4/OslnEBj8pQj3tXbOsw+2iiqVphiMqPkqHSWsDkjhFHf5MxRc+qf4U6v2jYXyCfeIr/XwG8SZJBZKeugR2ZdDkrbHk1RpiGG0lMM22Q3cwWvF+IJPpnrzuwYCxdltk8Ho6FO8mhLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=G/T2MRfH; arc=fail smtp.client-ip=52.103.7.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Em0WDMvIIEIufN7f7BO8EO2lcpc+livjdi5hqYEbOzK84olBKwpAkFqd4+p5l/bCEHeItcDx3rjzDGICANTplvVJWNp7/3PfAUFudexQ71f1FrgCvsA36hGRVNn3Qi5I50IEqHaqu7j2BmMev0BrPMUqOTQX4Zryndp9pmtW70kJKhhsPNhzEiedqQgjvxVlgSUWdVD+o1ycaFl/uW9vjuR6J6bKuOeCgzOsitcEsPkbAbVXYqNXJ1BbTsT2g8wPFA1ZmiUSJEjuZAB8a5kPPwwHal+fy8Cl5iujxEQD+/Av3CpHflMKwKKhIIvZh9Tnk0gKBs1HekjaBwZ6k09sJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aRY2u48hNF8943kkZ/nzPw+PrftWdoQ8WgggsH7dEKw=;
 b=hHNHRjeeaNI7Le6t2wUjUq9U5xXB06or+NlEbWwmtgI9ha+4drdAKV7EvG4MCPrzMyPy9CmcKWQkVnBxdi3gVtWePRvWvzKs4p2BZc28kR31NMYWCTyeUNz4u8ubXbK9ey5v9GH/oi6pi3XAFPcmzOonoHxk4M9Uz3zWnBYdUcwp+jMg9huAG66HhfoGezsB7D924bKT/osHC9yR7V/22CvMjFC4u52CBPefo+yT3x3OC5xFsZZZOgDptueyceBbWPoeCl6IO2S6FL524hJ4zmhYPXBafY4qnpCDJBI1YNrEVQ4VwgdVd0iDvFKPCdEOh5i85No4uD8XakCCl3ZbkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRY2u48hNF8943kkZ/nzPw+PrftWdoQ8WgggsH7dEKw=;
 b=G/T2MRfHBvTnE/vbaxTzcWsunL3JVJnX+BVjkJAFF6lPNtuUSDUMo4jthEgOcjUcO55UJlkQ1gBo9UZHUhyssmXhX6G5s1kALOZPwQbrEKILryDgYSZb+voTRorFkR2aG0qFJnO0mB50hmmMW0vp30Ua1/cVDOKXgwz5qDtfw1w2hHW7YlmNRunKe7yqICdOeKSY0ObMJut/UnvnAhLS71behl1XHGjvUq9YtqA2tiv3kZZrp260RJ3+kqWAoh1uBPX8sPNJvbr2K4nMblHKWKWyteLKy/RKe9f57x98nETv8G9UHyRGfVJdaKD+O/4d7z6+yukU+1G/eKzJB5+sRw==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by PH8PR02MB10184.namprd02.prod.outlook.com (2603:10b6:510:224::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.26; Tue, 4 Mar
 2025 04:17:54 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%3]) with mapi id 15.20.8489.025; Tue, 4 Mar 2025
 04:17:54 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Juergen Gross <jgross@suse.com>, "K. Y.
 Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei
 Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Ajay Kaher
	<ajay.kaher@broadcom.com>, Jan Kiszka <jan.kiszka@siemens.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Daniel
 Lezcano <daniel.lezcano@linaro.org>, John Stultz <jstultz@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "xen-devel@lists.xenproject.org"
	<xen-devel@lists.xenproject.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>
Subject: RE: [PATCH v2 10/38] clocksource: hyper-v: Don't save/restore TSC
 offset when using HV sched_clock
Thread-Topic: [PATCH v2 10/38] clocksource: hyper-v: Don't save/restore TSC
 offset when using HV sched_clock
Thread-Index: AQHbiL6l+0jbz3ovik6J1qTGo+F4UrNiYnmw
Date: Tue, 4 Mar 2025 04:17:54 +0000
Message-ID:
 <SN6PR02MB415743496C3A9937D10E4F4FD4C82@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20250227021855.3257188-1-seanjc@google.com>
 <20250227021855.3257188-11-seanjc@google.com>
In-Reply-To: <20250227021855.3257188-11-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|PH8PR02MB10184:EE_
x-ms-office365-filtering-correlation-id: 43515617-249a-4e0f-7cfb-08dd5ad38927
x-microsoft-antispam:
 BCL:0;ARA:14566002|19110799003|8060799006|15080799006|461199028|8062599003|12091999003|11031999003|102099032|3412199025|440099028;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?5GY4ccFobkTcLOJbOchDsHzGIE/ehhzKFPktUsb3oNqK/uOco+lTE2hl+W0t?=
 =?us-ascii?Q?60IsPMV14h12HXeDPkV4R0hDOBm1HTaAD2/h2ro0SVPWYDwZWdEvNbAikVvc?=
 =?us-ascii?Q?wqYdKt1GIdL8wgWL0LvavN4XQOqpzO9fDLZPOTa83WP9e8qy3fK/+WGuKJHf?=
 =?us-ascii?Q?Lk7/2ethmsu91UDBKgNZedr1v7YJ9TZsRlr/dBCTrejnRl5XJ7N/BW2CZW/w?=
 =?us-ascii?Q?0uWMyE6tIWHRPZusvEiVVdQmg1lOBFxxb5maTmh/G5vzHBv1O2LqA7rNou7F?=
 =?us-ascii?Q?9exXzTbr+1j5TkrNul8n7T8vN2oiW3mN+1rq0KP684xAvCRauevG1lmGI7EF?=
 =?us-ascii?Q?pfW1xqKiCwLicxG3m/qTrqjBFKCKkK0qMxg8BEnJX2HuSSry2Twbzbxg1RFx?=
 =?us-ascii?Q?Jl7MCnTwBHxTxV/F9ExxJOu2ol3LMQPJM+U9kd79O1NCQrhioJ8VvVsO22tm?=
 =?us-ascii?Q?M5r9FbJPmAiyOmoEP/epX6NrU5JXn3y9h/ZZMSmxMr/YPNOBD5Z2gL2II6zr?=
 =?us-ascii?Q?8hZNAosV3ykqZGg4oGCcGAUp6Ed42HxpJh2TarTQfljMxxnqiDWD4iyqguSm?=
 =?us-ascii?Q?YwoJfQkxWvKZvyg2ajQDnGz2Cn4emosrP2rItdZtoAWGGiuFi7dKzooN7UP4?=
 =?us-ascii?Q?CLv3It9l+S1TcVRrevP+5F+NeeGjDu1bHDVuof3FdEXbVtc/471dX08uqIyd?=
 =?us-ascii?Q?8nPl7LMPL05ESM76KQdvo8upR3XGKDAN9XFoy3wY6FMgxURVPCtrXnxRPcq2?=
 =?us-ascii?Q?1W+yRvTDPBLQ8bOvFpde0lWYrugXDZbyjUwSQD3t8Xz2LPE8HtJ8wpD7Dcnc?=
 =?us-ascii?Q?NcnV4Brhv7TjffIfZLb/nt+8+VvDbhSeY/e1PEnZ3jjGO0D+BvtT8LxEWuFr?=
 =?us-ascii?Q?D34FeiTwKMNirweaIFYEnRXirRP9i9Lgtbx3pb+C55lFlPwTGbzDsGN3g6UT?=
 =?us-ascii?Q?6RR7au1aKJQjawv2rfecA6Jy0LyOTwSBJPf+6QNICmAqfu7QLi1TXvJhxV+f?=
 =?us-ascii?Q?hn/eH4I6JO0f4hgF3kwaFCJwv1E5b5akoPlEwmEVxqYH+NysqtaxMwoIjJ9N?=
 =?us-ascii?Q?vQG8Ew15glotYBdodm9OIBs00cYSIbCFAXmM2juQQxmoqmMooQk=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?z9tN/SCc28lB3XJriNDfooJn33XORMnxvjVZQ7Sa5PP7AE66kf1e0nqGFNDV?=
 =?us-ascii?Q?MZ6Wlry7DNykQ6lXVA2XCaS0uxoBjWk354uUGc57JoRlG0c1khmsKEgJ86Vv?=
 =?us-ascii?Q?aMh7iP9fCQKqMHvX2CCANt2cEy3KGa2D815UlgBdztBMRjifYLiQ+bfP7h+U?=
 =?us-ascii?Q?zjTp/DNzvEzuiEJMGlbq4G9Qo9PDX1IGrZxFc99/+OjpR6dI+40JeyQluK/d?=
 =?us-ascii?Q?/YfMiomyLzOwH061WTWbAr6ayn1E7to3GBm2V9rJ85M8XKn3Gcw8I2ntnhr0?=
 =?us-ascii?Q?iKufg97pu/x6qbfWmi7v+sbw9D2fAg363OEO19CUR00PYWqHX/f9UutT0KQO?=
 =?us-ascii?Q?lATlno3Bsg0QAGW4rBzQzduLfWYTM9B8NpZuugGoyTNGeiUXjYUe/q5kpaQ/?=
 =?us-ascii?Q?JIqwBJJXhuwTk7M9XoccEvOurAAujjCjRRqcWHDnJImfvdtzR4IT8LygMAfS?=
 =?us-ascii?Q?nF/Hagw8OQbeYhbSWStTNCy4xhSP032LHzUj0V7cFCqp+jh6u5/p6QIQ0vbr?=
 =?us-ascii?Q?ubSqCLN60EdzNi8hZgCn9BbQlYuT1lWVOi1H7i5l6oyUiKF6OWUZJzvwXkHZ?=
 =?us-ascii?Q?k43EC6YFC/QmWaIL6bIfx1rhuikllwpIZeh7Jh/vhmEjrcT9LKRFu/xobkJ4?=
 =?us-ascii?Q?AaJHTKeO58imVjnysR+8G1Km8zmh7w+1nU8O7GXiRwoNQpbqctNDnxxL1LXT?=
 =?us-ascii?Q?d3WLdLDRlkcApmmovnc9RJPkstfBuEh0jao93DlBY2MsS4pUjaAUlDU5k+J/?=
 =?us-ascii?Q?AVuG1O1BEHx+i69sujihlzKFk6Vg62kOXEG8figl8HmyOwSLYoavwjE26pX2?=
 =?us-ascii?Q?YrmdfOZlPHP2l8ohiT8mLYsULaZ/HViX3mVOUFkstluAaHn3aoyzmhVgZZsl?=
 =?us-ascii?Q?6U9/mx5J+ovVeDjDNOjKHNFwNAMEzhWKXiSFW3SGP/JjkntyAMZqHbeONBdh?=
 =?us-ascii?Q?qpNPzDFXGHjH//H6+b2OdOkgiH17juZP2cRMmufMHHChCwgGkijwqhEBjCgO?=
 =?us-ascii?Q?sQCIz6lN9xaF0H/48nMYgsMbfgMLWZvjneVEZs9OkTeIr91izIHTWkSw4yrm?=
 =?us-ascii?Q?OyMEF+ZsVwMmdXmnEnMfhARIKW/HiZ1xnJcnrnPhslTytkT0ATNv8WzAManV?=
 =?us-ascii?Q?WtKFQxwqdNbVBWuM6AO+WC7CeWrqkJDGoN/1nHAMupW/ONzLQmYE/Ym1iraQ?=
 =?us-ascii?Q?ILiBahziPk9e+ggbARoARGVxmChEOQSPxirxLh6Co0GyZ536qxeokR4OvHQ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 43515617-249a-4e0f-7cfb-08dd5ad38927
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2025 04:17:54.1950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR02MB10184

From: Sean Christopherson <seanjc@google.com> Sent: Wednesday, February 26,=
 2025 6:18 PM
>=20
> Now that Hyper-V overrides the sched_clock save/restore hooks if and only
> sched_clock itself is set to the Hyper-V timer, drop the invocation of th=
e
> "old" save/restore callbacks.  When the registration of the PV sched_cloc=
k
> was done separate from overriding the save/restore hooks, it was possible
> for Hyper-V to clobber the TSC save/restore callbacks without actually
> switching to the Hyper-V timer.

Terminology again.

>=20
> Enabling a PV sched_clock is a one-way street, i.e. the kernel will never
> revert to using TSC for sched_clock, and so there is no need to invoke th=
e
> TSC save/restore hooks (and if there was, it belongs in common PV code).
>=20
> Signed-off-by: Sean Christopherson <seanjc@google.com>

I've tested the full patch series in a Hyper-V guest on x86 with
and without the Hyper-V TSC_INVARIANT option. In both cases,
the sched_clock is correctly maintained across hibernation and
resume from hibernation, and the "flags" in /proc/cpuinfo are
as expected. I also compiled hyperv_timer.c on arm64, and that is
clean with no errors. So all is good.

Modulo the terminology used in the commit message,

Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Tested-by: Michael Kelley <mhklinux@outlook.com>

> ---
>  drivers/clocksource/hyperv_timer.c | 10 ----------
>  1 file changed, 10 deletions(-)
>=20
> diff --git a/drivers/clocksource/hyperv_timer.c b/drivers/clocksource/hyp=
erv_timer.c
> index 5a52d0acf31f..4a21874e91b9 100644
> --- a/drivers/clocksource/hyperv_timer.c
> +++ b/drivers/clocksource/hyperv_timer.c
> @@ -524,9 +524,6 @@ static __always_inline void hv_setup_sched_clock(void
> *sched_clock)
>  }
>  #elif defined CONFIG_PARAVIRT
>  static u64 hv_ref_counter_at_suspend;
> -static void (*old_save_sched_clock_state)(void);
> -static void (*old_restore_sched_clock_state)(void);
> -
>  /*
>   * Hyper-V clock counter resets during hibernation. Save and restore clo=
ck
>   * offset during suspend/resume, while also considering the time passed
> @@ -536,8 +533,6 @@ static void (*old_restore_sched_clock_state)(void);
>   */
>  static void hv_save_sched_clock_state(void)
>  {
> -	old_save_sched_clock_state();
> -
>  	hv_ref_counter_at_suspend =3D hv_read_reference_counter();
>  }
>=20
> @@ -550,8 +545,6 @@ static void hv_restore_sched_clock_state(void)
>  	 *                - reference counter (time) now.
>  	 */
>  	hv_sched_clock_offset -=3D (hv_ref_counter_at_suspend - hv_read_referen=
ce_counter());
> -
> -	old_restore_sched_clock_state();
>  }
>=20
>  static __always_inline void hv_setup_sched_clock(void *sched_clock)
> @@ -559,10 +552,7 @@ static __always_inline void hv_setup_sched_clock(voi=
d
> *sched_clock)
>  	/* We're on x86/x64 *and* using PV ops */
>  	paravirt_set_sched_clock(sched_clock);
>=20
> -	old_save_sched_clock_state =3D x86_platform.save_sched_clock_state;
>  	x86_platform.save_sched_clock_state =3D hv_save_sched_clock_state;
> -
> -	old_restore_sched_clock_state =3D x86_platform.restore_sched_clock_stat=
e;
>  	x86_platform.restore_sched_clock_state =3D hv_restore_sched_clock_state=
;
>  }
>  #else /* !CONFIG_GENERIC_SCHED_CLOCK && !CONFIG_PARAVIRT */
> --
> 2.48.1.711.g2feabab25a-goog
>=20


