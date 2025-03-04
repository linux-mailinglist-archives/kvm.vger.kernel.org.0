Return-Path: <kvm+bounces-39957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 905C8A4D27B
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 05:18:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 839937A9135
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 04:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BC621F419A;
	Tue,  4 Mar 2025 04:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="ieWKOV3i"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazolkn19012061.outbound.protection.outlook.com [52.103.2.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692E61F37C3;
	Tue,  4 Mar 2025 04:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.2.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741061869; cv=fail; b=T3efL2A3qJ/1U0Q4lZqz9nf7EpXUA8GyFUk3g+hpH7ptpqGlcM6OgHJMeMrd+ykd7GXtuxfFWwiuJRz4o6zHSo7pHvqLY1ExsCRoKMjB+kqgfERiBcRF/9qDTJsNxZYPEnpLIufXN2TLIawATeWDsTYOx0ARiEKqcetQLYBLVkE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741061869; c=relaxed/simple;
	bh=qiY6FEk4NSS03V21mltN6++yPMNvrGBAgB/6ej1eYVI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rMkNAz+CgLTG8QFqqJhkeariZBcXN+PbUxe7ceIX5PUCqttcxcwGdQ0jwEbRllcqmNou2zvI/i5z67vrPfWeTBteDtfdWogAaZoZ2t5FiuIBXU+3Bbo80AV/ItxUJh4djMwxhd5JpFI/ExsU/wzL7Q2dDXuEAb5W1Sczs/+hf44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=ieWKOV3i; arc=fail smtp.client-ip=52.103.2.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WDdx1EybfDls8xXCnPTmD4Fbz/WbTsZKIG+xZtHVIbaMLP/wwWYJF35qdA8dE+tEcXqxsgBVCpk6iVfCvxhSSzxD4cuwRCjqoCR12hrJMVGf2QAPY11OltgfBiRh8R18gdSAzLIVZkTQlGLUrtIxQVXIEEeFcmXicSLNetq2j9Wa7usqnhsxuGS1qZubcOG1ZwjLoDUKpJaqBkpg2h/uExLK/4l6L2ZFw1f/wWJYApFh9+mAALW1Jiq1wL+oTK1vC273FWq4B9HTzH9KoDe3C4v3/fRkgxAlNo2g15DjfUrGWsE0RyVJ6qBG/rI6ha1urDzBWyfg2mqPkaqy+fXsCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NnbmzQtwxWaXauuYu03NCwHr8OAzWgd5jc3assWJuGU=;
 b=Cs2hjbXi2PHOJpc/w/nip4mCrB87v3G0/a+bsTMD+UUa798HMvvo8EIQxaLIdp+IbU17uYBhJ9aPaHjS9tK63cXZBxXSTig7SstVhxLaNirH7YDafOHqMUPrn+i+T0cTRTgRemopYfW1J+1IvgDL+WFwt0I8u1Il8O77c7OmYfkkAA0QNIQiaSskHaBbHZZ2d129Yu66nIHNeX3MoGnLlp9uUqoBSTjEFfAQy2R2qwySLnluv0h8iSNaZ+1SecfRQ83q8uH7l5DE01HkE3hYLQ/3A9qRZL8hBGVkEeOdgSXRjjZRrbIBU8pTMctpSNsjmmyLXiT77E7MHJRZW11WiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NnbmzQtwxWaXauuYu03NCwHr8OAzWgd5jc3assWJuGU=;
 b=ieWKOV3iq3FSPhWsLbSZ2JCj2MpJ1QghVoT+yimVWG10KpG2IWXRKAmnYe6s33++YjbAxQth1F756Q5u4ky910lYipZZhJKJ2W4UgYENHUSd+m3VxlNAyzrXoEo/XeX/98gmqGfXYGsaWB91zw66yzcRw7CytXoWPVmomUnjoJZuOmZNpw6TN6Lt4BfCAvQmo9iKZ90fDoj1+SmtTPLR+qVht2vnMm4b8Fh73qNyqXuV7HNUrkMLGc0dl+FKyQBJca7slgOJa8lHxytYfz0uOfv9dIUX690tB6R285TV79Krnyz2NDRmD53e+mmNQDxU0H7xwhodNUJfvs7OAKgabQ==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by PH8PR02MB10184.namprd02.prod.outlook.com (2603:10b6:510:224::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.26; Tue, 4 Mar
 2025 04:17:44 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%3]) with mapi id 15.20.8489.025; Tue, 4 Mar 2025
 04:17:44 +0000
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
Subject: RE: [PATCH v2 09/38] clocksource: hyper-v: Drop wrappers to
 sched_clock save/restore helpers
Thread-Topic: [PATCH v2 09/38] clocksource: hyper-v: Drop wrappers to
 sched_clock save/restore helpers
Thread-Index: AQHbiL6NEBnuOVASRUeGjQZiFuc7YrNiYO4w
Date: Tue, 4 Mar 2025 04:17:43 +0000
Message-ID:
 <SN6PR02MB41578BB5ACCB9370E2D31EA4D4C82@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20250227021855.3257188-1-seanjc@google.com>
 <20250227021855.3257188-10-seanjc@google.com>
In-Reply-To: <20250227021855.3257188-10-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|PH8PR02MB10184:EE_
x-ms-office365-filtering-correlation-id: e51e694c-fb3c-4bd2-7323-08dd5ad3830b
x-microsoft-antispam:
 BCL:0;ARA:14566002|19110799003|8060799006|15080799006|12121999004|461199028|8062599003|12091999003|11031999003|102099032|3412199025|440099028;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?Attvru50E2On2cgXL8bCLE8XNoXcAPJgkv1tgH+XMfQzJnMbfLqn21v27Dho?=
 =?us-ascii?Q?0qVBmhwHMSnuSe8u3+2QlrPSm0M6k87iZBGW40EK4U5yU2ocbye9Cp54fe+Q?=
 =?us-ascii?Q?SPxKnxcRyl9OPnOLY37ec/g6sKIik6eZLzBqeegf0/wIcn8wmwd4q8FtG/Zp?=
 =?us-ascii?Q?sv5d5eY0QFBv8/eVDLuKR4hDcHC172GICxz+y9m6ULcnY5MSZb4kjTl1rYMd?=
 =?us-ascii?Q?8dPpKco93mQaBBLcutEAVxh+zVqRFsrCsMgsoC0/SByzEOje/2Nl2e6ZEGCM?=
 =?us-ascii?Q?ImNpk89v4KwKmTsN3rJGaa79nhegmdPdQrxO+Ey+Posq0U1PAK8g+LpqwCMf?=
 =?us-ascii?Q?W71vNwzW/BXzXc1/IcWvzsog/bjUQkeNPbGePtkwoQ+e4mlge66Ou/tbdxjq?=
 =?us-ascii?Q?UMA0eT3Ih6oEPhtmeJFooOwQpGZ4sHTu1T9uisfr8RIhkvXgiztRZkOLp+Jk?=
 =?us-ascii?Q?RExr9qwUDEYvq6jcPvCKyWeFbFbQ39gWpPM8UjvCusrL9/3/mtoS8pgvmpdh?=
 =?us-ascii?Q?p+sxMaTnklwsfr8dGaZ/J++NJFaf3xIfMAoFI3n1F9mKKyWn6CnJ6ia71EPB?=
 =?us-ascii?Q?4sKri8eAFAEpaScUptyoTb+fmYwmwGke1wSzvKCGapZ7ZD0ZI78pkN41bVUD?=
 =?us-ascii?Q?YUD9ZJ/C4xTms3I0Lms9s1SB6ttQOJCK3XCgZ7dgb1etyYVALnhqglnshFn+?=
 =?us-ascii?Q?dJAi69UBh7MEFlphJKq1pvv9J0vokLQCQRnxH7QwAEOBG4XsYRh5pI5cs+4m?=
 =?us-ascii?Q?7La+Rf5h7clUQ0YmqqcSGnAh7iMDkuxsFBW5MCioXkXaWVc3FLLpnEMcUB+E?=
 =?us-ascii?Q?2RpgX07GBq782lSiMN8SV2vWDsSAu+GWP4AWej6q7xnqDBEXDDy7xQy0TEuH?=
 =?us-ascii?Q?HOOUoCnj6pDtnAV+LnxDcGuFvd0s5z3vmynJKKRq8lGpAnVPZuUXw4OTa6TB?=
 =?us-ascii?Q?egX5+QR9uC9wHgHBBXC+A5lv3LUoJN5y9sUkNInL6hK8gNK+R7Hwf44XYCcx?=
 =?us-ascii?Q?P5vIfsAXmTdAY6wGM07xE7c3YBZ0Tu5Ts8KjHbN/1fHEa+z/Vr2c4P4q/NNP?=
 =?us-ascii?Q?vD0zgmYSuiPKa4aofGJn+OD7dPW+cw/15DVY9sq0/ZLERB+Jjza7QLeu+7ss?=
 =?us-ascii?Q?FPyCGd3X1JB0VmR0Z7PKHm43unswrNMToQ=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?em5ySggkszJx6T4jxj8gNGQ/cfQY3i8vWIoc3CnxwU2CfxsEcIcOWoKTCsZt?=
 =?us-ascii?Q?NPDiiv6RsPwcNFhz81aNuDEVZc2BRAJFqoDpjy2MmzjjSc1F7CYbVo3YIiJN?=
 =?us-ascii?Q?J95mTkUe6HYBKQJGjHNNYP7g/HG9ggt/4ea8M5QhuD80xr/4RLq+rjrZyHIo?=
 =?us-ascii?Q?A/kKz1aiDeu4eBK5pOFkX7dRULzozHtqUFsd4vgZD2PHYjvmhx+eAu8u+uO3?=
 =?us-ascii?Q?ikf9SKBBi+c4grz/JQp/eZJbieVW2NqTpM0EX1z98kjmxSRCQdgi567Kd/Py?=
 =?us-ascii?Q?bsUiTOZdcCcoMJPzaPKwKk7/cck0z4Kga3HCqxlgiB7REt1X6nSPYaBmVcho?=
 =?us-ascii?Q?xxM006b5w3gc2P4ZD4H2lfuSG+Y5YMgEtlldUf17sD3Pay0DbUdMynd+GTgf?=
 =?us-ascii?Q?QvZzuutJZGzz8PtBt43Q/MAYO9uVklgUkLUWGJrDJQYFoUYF6tXklIFfzEoc?=
 =?us-ascii?Q?hiLFDYuKc3ANpwloy8C4fFAXQx+yFt5qToCSbFCifuLTp/dzeDf1JV85SHk9?=
 =?us-ascii?Q?b5GjZljwWl19AZtGsj/PBNf6FZI7wDWPoUEqZM691O4kcIj4DHGoKNlyhMfS?=
 =?us-ascii?Q?wNkumqhmCl8R2Z367s0jM//itboTSD+l7u/CX+HFuY1eTF/gfLRfVn+Dk8ad?=
 =?us-ascii?Q?Z8U8BfjnU0ASKHj/OvVr3aBKwd+iWzcqbNv09sWMiF0osTor6gdhcncM271/?=
 =?us-ascii?Q?qNCh50qveTORwOdLcxxLaJxrY7onJvBNjcPuMdLly9wS/JRvWS2RLu8Tb55g?=
 =?us-ascii?Q?U1z+DgLM0cRKXllAD3iv4AsoFzhIGsaT6hK6/vRQtrxgzGqYsYQ/A1hRbvOh?=
 =?us-ascii?Q?rUnKUfxWE8U7mdfnIFv2NE2S2LY8zzu6Imdd/jHkYDy9Pka5Ihxf4tSAYxZL?=
 =?us-ascii?Q?pq3TkVpT38Il3cX7g1N4oPVXLdfNonlBKb/OHF1Gcwi1pRNGwyGr9H/9FEje?=
 =?us-ascii?Q?06qfVzVed+KlwXBZAtXsJosTkBGtQ1FdlAMfoWZQzKvwdJZ66VVAdJ7jbOoL?=
 =?us-ascii?Q?Hm2A9f+VHERt8RmqIUgklV8iF3bSS8YO0jyG3XppqKwyzJS7bHHpo+aG/LNM?=
 =?us-ascii?Q?YAQT7SFbTAomfowihLZRPY97Pm14W6K0bpzdLMKkJd2EusSAjiywgEF4JB61?=
 =?us-ascii?Q?ZzqjlMrZ/an1RXoNIVbQyZBlIRVAXqjzbYMj4ZChf9O3QUqxwVmxmv7EZYNB?=
 =?us-ascii?Q?LHVvhEUriwX7J492bUeQYMzjXCdYK0s+aOvnEGtgGtvqatEgy0x9UVzINwY?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e51e694c-fb3c-4bd2-7323-08dd5ad3830b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2025 04:17:43.9329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR02MB10184

From: Sean Christopherson <seanjc@google.com> Sent: Wednesday, February 26,=
 2025 6:18 PM
>=20
> Now that all of the Hyper-V timer sched_clock code is located in a single

Again, "Hyper-V refcounter", not "Hyper-V timer".

> file, drop the superfluous wrappers for the save/restore flows.
>=20
> No functional change intended.
>=20
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Modulo the terminology in the commit message,

Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Tested-by: Michael Kelley <mhklinux@outlook.com>

> ---
>  drivers/clocksource/hyperv_timer.c | 34 +++++-------------------------
>  include/clocksource/hyperv_timer.h |  2 --
>  2 files changed, 5 insertions(+), 31 deletions(-)
>=20
> diff --git a/drivers/clocksource/hyperv_timer.c b/drivers/clocksource/hyp=
erv_timer.c
> index 86a55167bf5d..5a52d0acf31f 100644
> --- a/drivers/clocksource/hyperv_timer.c
> +++ b/drivers/clocksource/hyperv_timer.c
> @@ -471,17 +471,6 @@ static void resume_hv_clock_tsc(struct clocksource *=
arg)
>  	hv_set_msr(HV_MSR_REFERENCE_TSC, tsc_msr.as_uint64);
>  }
>=20
> -/*
> - * Called during resume from hibernation, from overridden
> - * x86_platform.restore_sched_clock_state routine. This is to adjust off=
sets
> - * used to calculate time for hv tsc page based sched_clock, to account =
for
> - * time spent before hibernation.
> - */
> -void hv_adj_sched_clock_offset(u64 offset)
> -{
> -	hv_sched_clock_offset -=3D offset;
> -}
> -
>  #ifdef HAVE_VDSO_CLOCKMODE_HVCLOCK
>  static int hv_cs_enable(struct clocksource *cs)
>  {
> @@ -545,12 +534,14 @@ static void (*old_restore_sched_clock_state)(void);
>   * based clocksource, proceeds from where it left off during suspend and
>   * it shows correct time for the timestamps of kernel messages after res=
ume.
>   */
> -static void save_hv_clock_tsc_state(void)
> +static void hv_save_sched_clock_state(void)
>  {
> +	old_save_sched_clock_state();
> +
>  	hv_ref_counter_at_suspend =3D hv_read_reference_counter();
>  }
>=20
> -static void restore_hv_clock_tsc_state(void)
> +static void hv_restore_sched_clock_state(void)
>  {
>  	/*
>  	 * Adjust the offsets used by hv tsc clocksource to
> @@ -558,23 +549,8 @@ static void restore_hv_clock_tsc_state(void)
>  	 * adjusted value =3D reference counter (time) at suspend
>  	 *                - reference counter (time) now.
>  	 */
> -	hv_adj_sched_clock_offset(hv_ref_counter_at_suspend -
> hv_read_reference_counter());
> -}
> -/*
> - * Functions to override save_sched_clock_state and restore_sched_clock_=
state
> - * functions of x86_platform. The Hyper-V clock counter is reset during
> - * suspend-resume and the offset used to measure time needs to be
> - * corrected, post resume.
> - */
> -static void hv_save_sched_clock_state(void)
> -{
> -	old_save_sched_clock_state();
> -	save_hv_clock_tsc_state();
> -}
> +	hv_sched_clock_offset -=3D (hv_ref_counter_at_suspend -
> hv_read_reference_counter());
>=20
> -static void hv_restore_sched_clock_state(void)
> -{
> -	restore_hv_clock_tsc_state();
>  	old_restore_sched_clock_state();
>  }
>=20
> diff --git a/include/clocksource/hyperv_timer.h b/include/clocksource/hyp=
erv_timer.h
> index d48dd4176fd3..a4c81a60f53d 100644
> --- a/include/clocksource/hyperv_timer.h
> +++ b/include/clocksource/hyperv_timer.h
> @@ -38,8 +38,6 @@ extern void hv_remap_tsc_clocksource(void);
>  extern unsigned long hv_get_tsc_pfn(void);
>  extern struct ms_hyperv_tsc_page *hv_get_tsc_page(void);
>=20
> -extern void hv_adj_sched_clock_offset(u64 offset);
> -
>  static __always_inline bool
>  hv_read_tsc_page_tsc(const struct ms_hyperv_tsc_page *tsc_pg,
>  		     u64 *cur_tsc, u64 *time)
> --
> 2.48.1.711.g2feabab25a-goog
>=20


