Return-Path: <kvm+bounces-39956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A514BA4D271
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 05:18:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B45373AE035
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 04:17:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B4C71EEA34;
	Tue,  4 Mar 2025 04:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="SM9T+uMz"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazolkn19010003.outbound.protection.outlook.com [52.103.20.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D96937160;
	Tue,  4 Mar 2025 04:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.20.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741061860; cv=fail; b=dduiHFH26FIdmt/mk71mSD56pCdHeQAewosUFzVJb0vzBl4zsl9DwHlAcxi9yypPNUFhNFy8J2fP81OemEEY+AFr5ccONAHOTvSDKoDeO//KOr+4ffkIssvv1YcDmrQimL8TU6hcKOj+mshmdUOoIdARvxQ8Nz2wec2NIhwRXQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741061860; c=relaxed/simple;
	bh=A5wsqwQyb7F5S1mt92IdbNyHyv+jpGGTT2oi3MDRInM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Fnn9Aq9kin7itvQ+M4LQooy82Q21TAvQOvR6LuCpWflMfKfsfF0Hx+RCRHNbkn24YH5/7HcE5s1+Na2apTp+yKxE4Z0sAc0kHxrBgrgv5aqDr3Iutog9G+GI+rLlCGk9SP1AdR3djV75B8SCNKml9rclxc/+992DCVUocthS/Gg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=SM9T+uMz; arc=fail smtp.client-ip=52.103.20.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q+9vSrW6m/jq6Mgmmw3La5w8YI6ug2CcmD7Kxjtj3SSsSb3ZG0HsgXOGVZgx7dEEOyy8QTSXmtogWtlJ5irNj5PkDQ/FRi+J9fyWyTW7hQOvfhVSFMSG3fs1fEq4cBusO1zimfQSUa41E5pA1OPrGdJkHnz6ebvm96Y9T1Pmucx1C6Xr70yxVHo1+AJG2O7VrkLHzA6f1/hUS8xRi0Zpm3vWN1d7kOwNboQPoJhHdPrTV3uEBwig9fGS+mZ5xO0Ukf6PvIuLBfeLEquypR/NOTC3SqH6mYfzz1t60JrfrzAUx9coOH23A+838xIIWXP1YLI40Sk+8X04Zf8vf44xAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LrGoVYrdi7142gbmYXSYWHcV3PqtPgswisv++7BxFlY=;
 b=pdfBLNvhjwTIsSpic8OLtc/SThk5zqywdXoKsR47bSs0JMUuyWsrrF1on8Mh1McNpX7mcP6l3UUm5VtX6C60qJ8vBiJ1SSAsleLOq3ZRjE/9jmEE9P1JWjbzrs6P0qdseHXvdh8YcPG2/9IeatUrqVa8JU9JHVdGZByDNGn//vboGKLjnbnytReIPgoaZfxc+Q33qnElUPoDXCJbxm7TIBgSHcnYbgTZ+3nUQEK/RHwSRjAs3VvIeXhUnV4HC8+HrrQVc0bBZdjIxXRbJUHAl/Xo/TeJC1Uxs6j627Z1q3NQk2inWouVCtg4w9l/BUpv8ussNg8E3o7KKCFcxvy6eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LrGoVYrdi7142gbmYXSYWHcV3PqtPgswisv++7BxFlY=;
 b=SM9T+uMzY6H9naSANfqbM2Dv166hl6Fi06Rg3no06ZT94bxDMD3P13ogcenMDLqAORbzreyTf2Iud+9dVwC+mr3priV9NOpHm0XsgCDu6xa2ypKnOqPIGYF7nIHu3+bMg59S6a15JHnQN4hX2vzUjQtew5TPnf5MPUUNYFmcUP+1TntwOofobSXQsNlql3M47hfml9q9k9A19NuPY6EFQXD7fglkNUw5VM6xdrF/6cbYYJxjwwZ2zXfkGYFNJ/pqYBWdNYU25F+Xehu4S5QIXL+ALYJ6djKfY+8E/XUX8bzsruZ0ozorafDIdYqRnpEaZ5yvrpFibt8+eMy9jQpwtw==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by PH8PR02MB10184.namprd02.prod.outlook.com (2603:10b6:510:224::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.26; Tue, 4 Mar
 2025 04:17:34 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%3]) with mapi id 15.20.8489.025; Tue, 4 Mar 2025
 04:17:34 +0000
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
Subject: RE: [PATCH v2 08/38] clocksource: hyper-v: Register sched_clock
 save/restore iff it's necessary
Thread-Topic: [PATCH v2 08/38] clocksource: hyper-v: Register sched_clock
 save/restore iff it's necessary
Thread-Index: AQHbiL6AMb8zjFoj30eFPeRrju6/drNiX0lQ
Date: Tue, 4 Mar 2025 04:17:34 +0000
Message-ID:
 <SN6PR02MB41576973AC66F8515F6C81F0D4C82@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20250227021855.3257188-1-seanjc@google.com>
 <20250227021855.3257188-9-seanjc@google.com>
In-Reply-To: <20250227021855.3257188-9-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|PH8PR02MB10184:EE_
x-ms-office365-filtering-correlation-id: 8a00d464-a659-48c9-d777-08dd5ad37d61
x-microsoft-antispam:
 BCL:0;ARA:14566002|19110799003|8060799006|15080799006|12121999004|461199028|8062599003|41001999003|12091999003|11031999003|102099032|3412199025|440099028;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?UXxQzQu1Ppaciv70DUxod7xJrhQOk30qWkRXdHaoVHxXGEFxEW3Itor4+Gu5?=
 =?us-ascii?Q?+40GKv2UYBO27oPufjRVWc4llVEumKqRxov/VD7e2k3x9pTL16/anoEDhC4y?=
 =?us-ascii?Q?ybuP0TbORr+p31KG/rQbxHGjF1CcWJdsJzT3Z9MCf3t4oKaInyfCCGf3Ol7D?=
 =?us-ascii?Q?UG6ZfdkLrwhoZDPbMDciOPGf9wUgS7K7O8e8Ayxr+SlBnaUAuMxbvJI6vQf9?=
 =?us-ascii?Q?l5aCiVBu2ZcUOSKyWsaCRWllGzOVSROvAquwXIsIfWGzFBnJiI4lC3W+nR8t?=
 =?us-ascii?Q?jR+utHZQmomJD0jAwQ0H9R6kE7iciNtDoHURt0+XvGaMk3Rz6/iD36mKqcve?=
 =?us-ascii?Q?/tL0iU+h+jWXtaKBdyQFXc3JgjOv38hQMhpeqHggQK1LcqH9H4sYMWZjTF/Q?=
 =?us-ascii?Q?EU4zLx0zzj/5paCAliKrVEtQ1VZAzAW+sVDVCRrFJDXhrxUOH+LZGnbZKqhI?=
 =?us-ascii?Q?lhbOOw/47ZrrXpOOKqu0+F0xntbnZJWvNCLfzZu9NvZVJmS10XffsQ6ksUdN?=
 =?us-ascii?Q?5UuK8gYDWsg2aLa2RowWwMKW7gYRjLoVQcCAwZfxUNxi0GUa0DAzsAiKKM4H?=
 =?us-ascii?Q?z/TGTgmR2TRD80YFcX1AkDCLHAKWPnMfAcB9p/GyFf8gG0IeyP5w70+t6dDH?=
 =?us-ascii?Q?cM1gMNhMxLmQUki+X4FbTPf83JjB9LizUMjO8unYSZd56jjq+1+PgbScrwl9?=
 =?us-ascii?Q?lo6ZQLReuFNm7Hpzbi/pGCM5RGG/qcX4QcddrHpzQ3sOhRjWnC/slCU6pycz?=
 =?us-ascii?Q?rvKBrMGHH0D8FaDidZGIrZ969o4qVOWjys74zRQ5a54CS1L9N/aQt2Bkk33c?=
 =?us-ascii?Q?QQey75d/rjgP0TXhqyPGOgxAhwXL3Qwso1hDHtH1c9Si/brF9CX/TsRop4TY?=
 =?us-ascii?Q?xH1Qch6rOQjfHCF6a+4hOkNTTH7qez0bkmtMFN+VY/LkG/34PiNc/1aRXY0q?=
 =?us-ascii?Q?4U1nksEOKg96/otMkO0pkvWqmCoPG7rbhkwg749cPfZU6NU9Fh4rZc0CbVXw?=
 =?us-ascii?Q?T8RF8/2YlNSlmJsQU2wxmcfngf9gv65Hq/fsqP2utIfoNq5ssiBIXZLdeDrk?=
 =?us-ascii?Q?my3of+8XwfSxjNQpEVca3plq5m8+Pugk6Ep82JqN0KgD2+AEu6JeJuY4o4N+?=
 =?us-ascii?Q?mZ8o0XLfdg9uQ0bgLDx+y73rdqC01o36ZQtJdZ/Q11Y/7q7PUvlZoVU=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?+PVSgNAnAPstqaZlNv4HpYFOJVXTxr9Uhfv/qOvrtlxf/8mPwrNxQXQQE+Ld?=
 =?us-ascii?Q?+gjDdR9tpAkGPLp42rzeTkb3aXs95HdxS2vln4OVDUhkaR3OpOZ4YMSQT2Fl?=
 =?us-ascii?Q?NV8p+2Ejhzll5aH/BsgBq3ow8G5wGtNDNNzdrbxfJ/SP7g/44xwi4ukvMVdF?=
 =?us-ascii?Q?ciXMFqzfLH+Giwya+PjMit1zQEMnE60ZtIhphb3EAElbO+fK9NVzaXqQtbZC?=
 =?us-ascii?Q?+T1LssVVd5aZydawILWdLLPnbPQ/kVarLbxRBZcdZj/ioiA6m6taxR5iPs9z?=
 =?us-ascii?Q?ybJw+kg7tf9ZeVaiB0/dSoV851cMFlVc/LXg3gqGpUOas3LkH+gi+tHwXRBU?=
 =?us-ascii?Q?SJ6bxN2gnTBRiahOHa/JPTfAK5kxxhuBlHBnkW4r0JHcYy6Fe/1XV9fnDW33?=
 =?us-ascii?Q?JIj9zoHgtCjgZ7VYkUBmnIKYh18QKMkBrEiBi/lW5vti9PdO9QJr0mtQSqcB?=
 =?us-ascii?Q?aBmVmCsZGXsiOmutv8qotzGL/nuHkHma97ZqRR0W0SetTxAC0tVavvlnwvbU?=
 =?us-ascii?Q?OZg1o/QFsqdLK9eyHQrgfUAmOHOyFDe1UC8gw4WUbjeVg6KoHtgIheFqQ9cY?=
 =?us-ascii?Q?1T0lTm5lqKTaWfX9Fjitul+uRyiWRalYjNFqmKMpqHDOBGMWwE22meGRhZtw?=
 =?us-ascii?Q?uwTtYalHdhnq6BphNMtrlYSHCpmQSvd7x2pX2n9CAippKRn3sifP8Sp+04Tv?=
 =?us-ascii?Q?6ysrvDucXr+79QJnzi7fcjTOpK68SU6VLBJcz84pmclJi6uSMOp51E8Lq1F2?=
 =?us-ascii?Q?O4F5hqUU6xjogo+l0gISD0jgx0lGdc8o+tNf7NwAQIZ9G0t1O1owqdg+CHYx?=
 =?us-ascii?Q?PjLQbcc5PzcyAXjVZQvTWb6v0lJm1ZdeNGq8YjUID0ykB1A1f+Uzb735IhAm?=
 =?us-ascii?Q?HTV1T8HfaaqTj7ztry9QOQguI10tEroPkN6ol5sKVpt9RkJKHV5/D6PZtrj9?=
 =?us-ascii?Q?Ojpw4jBG1SObKHN901ssOpBHZBI0d/N260+6rKyeKOGUwMftbgPTvSNB2TD1?=
 =?us-ascii?Q?sOsiAio5yD70fQPW5cn+SXbkX2qe3pHE3sGMyM3p4MfaySmO8/zUi2HJKqFK?=
 =?us-ascii?Q?PCVs1kZFbD+ezLLDxAVYrJTbWt/G9UDa/ihWPCHPH0UmkGOYAohejEVTnX0G?=
 =?us-ascii?Q?wHXptv29y5qqtqkv0o2BYBSARsrhHFXF5V2SNjcLePBOmy68QukAon4fpnwh?=
 =?us-ascii?Q?dMf5mDo0sKX02CCaHdIFyXPCBsB+wjFNrFy1NbtJDKDQzQA3Q6cIAUf+drw?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a00d464-a659-48c9-d777-08dd5ad37d61
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2025 04:17:34.4122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR02MB10184

From: Sean Christopherson <seanjc@google.com> Sent: Wednesday, February 26,=
 2025 6:18 PM
>=20
> Register the Hyper-V timer callbacks or saving/restoring its PV sched_clo=
ck

s/or/for/

> if and only if the timer is actually being used for sched_clock.
> Currently, Hyper-V overrides the save/restore hooks if the reference TSC
> available, whereas the Hyper-V timer code only overrides sched_clock if
> the reference TSC is available *and* it's not invariant.  The flaw is
> effectively papered over by invoking the "old" save/restore callbacks as
> part of save/restore, but that's unnecessary and fragile.

The Hyper-V specific terminology here isn't quite right.  There is a
PV "Hyper-V timer", but it is loaded by the guest OS with a specific value
and generates an interrupt when that value is reached.  In Linux, it is use=
d
for clockevents, but it's not a clocksource and is not used for sched_clock=
.
The correct Hyper-V term is "Hyper-V reference counter" (or "refcounter"
for short).  The refcounter behaves like the TSC -- it's a monotonically
increasing value that is read-only, and can serve as the sched_clock.

And yes, both the Hyper-V timer and Hyper-V refcounter code is in a
source file with a name containing "timer" but not "refcounter". But
that seems to be the pattern for many of the drivers in
drivers/clocksource. :-)

>=20
> To avoid introducing more complexity, and to allow for additional cleanup=
s
> of the PV sched_clock code, move the save/restore hooks and logic into
> hyperv_timer.c and simply wire up the hooks when overriding sched_clock
> itself.
>=20
> Note, while the Hyper-V timer code is intended to be architecture neutral=
,
> CONFIG_PARAVIRT is firmly x86-only, i.e. adding a small amount of x86
> specific code (which will be reduced in future cleanups) doesn't
> meaningfully pollute generic code.

I'm good with this approach.

>=20
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Modulo the terminology used in the commit message,

Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Tested-by: Michael Kelley <mhklinux@outlook.com>

> ---
>  arch/x86/kernel/cpu/mshyperv.c     | 58 ------------------------------
>  drivers/clocksource/hyperv_timer.c | 50 ++++++++++++++++++++++++++
>  2 files changed, 50 insertions(+), 58 deletions(-)
>=20
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyper=
v.c
> index aa60491bf738..174f6a71c899 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -223,63 +223,6 @@ static void hv_machine_crash_shutdown(struct pt_regs=
 *regs)
>  	hyperv_cleanup();
>  }
>  #endif /* CONFIG_CRASH_DUMP */
> -
> -static u64 hv_ref_counter_at_suspend;
> -static void (*old_save_sched_clock_state)(void);
> -static void (*old_restore_sched_clock_state)(void);
> -
> -/*
> - * Hyper-V clock counter resets during hibernation. Save and restore clo=
ck
> - * offset during suspend/resume, while also considering the time passed
> - * before suspend. This is to make sure that sched_clock using hv tsc pa=
ge
> - * based clocksource, proceeds from where it left off during suspend and
> - * it shows correct time for the timestamps of kernel messages after res=
ume.
> - */
> -static void save_hv_clock_tsc_state(void)
> -{
> -	hv_ref_counter_at_suspend =3D hv_read_reference_counter();
> -}
> -
> -static void restore_hv_clock_tsc_state(void)
> -{
> -	/*
> -	 * Adjust the offsets used by hv tsc clocksource to
> -	 * account for the time spent before hibernation.
> -	 * adjusted value =3D reference counter (time) at suspend
> -	 *                - reference counter (time) now.
> -	 */
> -	hv_adj_sched_clock_offset(hv_ref_counter_at_suspend -
> hv_read_reference_counter());
> -}
> -
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
> -
> -static void hv_restore_sched_clock_state(void)
> -{
> -	restore_hv_clock_tsc_state();
> -	old_restore_sched_clock_state();
> -}
> -
> -static void __init x86_setup_ops_for_tsc_pg_clock(void)
> -{
> -	if (!(ms_hyperv.features & HV_MSR_REFERENCE_TSC_AVAILABLE))
> -		return;
> -
> -	old_save_sched_clock_state =3D x86_platform.save_sched_clock_state;
> -	x86_platform.save_sched_clock_state =3D hv_save_sched_clock_state;
> -
> -	old_restore_sched_clock_state =3D x86_platform.restore_sched_clock_stat=
e;
> -	x86_platform.restore_sched_clock_state =3D hv_restore_sched_clock_state=
;
> -}
>  #endif /* CONFIG_HYPERV */
>=20
>  static uint32_t  __init ms_hyperv_platform(void)
> @@ -635,7 +578,6 @@ static void __init ms_hyperv_init_platform(void)
>=20
>  	/* Register Hyper-V specific clocksource */
>  	hv_init_clocksource();
> -	x86_setup_ops_for_tsc_pg_clock();
>  	hv_vtl_init_platform();
>  #endif
>  	/*
> diff --git a/drivers/clocksource/hyperv_timer.c b/drivers/clocksource/hyp=
erv_timer.c
> index f00019b078a7..86a55167bf5d 100644
> --- a/drivers/clocksource/hyperv_timer.c
> +++ b/drivers/clocksource/hyperv_timer.c
> @@ -534,10 +534,60 @@ static __always_inline void hv_setup_sched_clock(vo=
id
> *sched_clock)
>  	sched_clock_register(sched_clock, 64, NSEC_PER_SEC);
>  }
>  #elif defined CONFIG_PARAVIRT
> +static u64 hv_ref_counter_at_suspend;
> +static void (*old_save_sched_clock_state)(void);
> +static void (*old_restore_sched_clock_state)(void);
> +
> +/*
> + * Hyper-V clock counter resets during hibernation. Save and restore clo=
ck
> + * offset during suspend/resume, while also considering the time passed
> + * before suspend. This is to make sure that sched_clock using hv tsc pa=
ge
> + * based clocksource, proceeds from where it left off during suspend and
> + * it shows correct time for the timestamps of kernel messages after res=
ume.
> + */
> +static void save_hv_clock_tsc_state(void)
> +{
> +	hv_ref_counter_at_suspend =3D hv_read_reference_counter();
> +}
> +
> +static void restore_hv_clock_tsc_state(void)
> +{
> +	/*
> +	 * Adjust the offsets used by hv tsc clocksource to
> +	 * account for the time spent before hibernation.
> +	 * adjusted value =3D reference counter (time) at suspend
> +	 *                - reference counter (time) now.
> +	 */
> +	hv_adj_sched_clock_offset(hv_ref_counter_at_suspend -
> hv_read_reference_counter());
> +}
> +/*
> + * Functions to override save_sched_clock_state and restore_sched_clock_=
state
> + * functions of x86_platform. The Hyper-V clock counter is reset during
> + * suspend-resume and the offset used to measure time needs to be
> + * corrected, post resume.
> + */
> +static void hv_save_sched_clock_state(void)
> +{
> +	old_save_sched_clock_state();
> +	save_hv_clock_tsc_state();
> +}
> +
> +static void hv_restore_sched_clock_state(void)
> +{
> +	restore_hv_clock_tsc_state();
> +	old_restore_sched_clock_state();
> +}
> +
>  static __always_inline void hv_setup_sched_clock(void *sched_clock)
>  {
>  	/* We're on x86/x64 *and* using PV ops */
>  	paravirt_set_sched_clock(sched_clock);
> +
> +	old_save_sched_clock_state =3D x86_platform.save_sched_clock_state;
> +	x86_platform.save_sched_clock_state =3D hv_save_sched_clock_state;
> +
> +	old_restore_sched_clock_state =3D x86_platform.restore_sched_clock_stat=
e;
> +	x86_platform.restore_sched_clock_state =3D hv_restore_sched_clock_state=
;
>  }
>  #else /* !CONFIG_GENERIC_SCHED_CLOCK && !CONFIG_PARAVIRT */
>  static __always_inline void hv_setup_sched_clock(void *sched_clock) {}
> --
> 2.48.1.711.g2feabab25a-goog
>=20


