Return-Path: <kvm+bounces-65963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DFA99CBDEEC
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 14:03:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id AA0F630120F2
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 13:03:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C73CB299924;
	Mon, 15 Dec 2025 13:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="G6oud31D";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="G6oud31D"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013051.outbound.protection.outlook.com [52.101.83.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAF7267B07
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 13:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.51
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765803794; cv=fail; b=VKNHwFZmu6bMYUKH5+BOFwzmoZo2PZqRkw/dBs0zk9snfG2ZUSKQTxITyO4kqn5O5yj2G6i334nT4rJiRgNAgAfPRG7I5cGhyQJt4TGHayFoRX37xztYnE6KTHgYnbGes/puRgK+SONOahfSjrkEQ89bzxMvyXoLNNoG6/uPNj4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765803794; c=relaxed/simple;
	bh=0uPmXKs1vB93lrNJCn9BAgEx3q8nouXmBL2xswaQk70=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XVl2BwZToh15mrqQmS+gIA2qktRot79blUtuUYFwIXrBbFfghRL4TfjIflCfeThw7Ez4/8IXuIFidNy2a6nVniEyx3PDMtMSj8iew8W77ZVNcRn6SMWXxIRP1PqR+bJxNUxTPkinVi644icQcp7n/dFrqTc/zEShHkPXwtvUn4o=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=G6oud31D; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=G6oud31D; arc=fail smtp.client-ip=52.101.83.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=XdDauFEUQRALYB3cAH1Zd+ydmZ9iGakY1PgCH73BI2EzteJm6LpWe0YBNStehHEUHRJ1UAYNkQvj0VbLq6O33locVTMj+0guVMoobCm2NvyvRKzqwN/xXVpRN3SCg1pfCRMh+WdBiJCZ1pJc83yIEdjS7wZDff3Fhso/b/mm//jdEn2rHfXwM6Yj0tNo7jErF57eXdmwQwI3/KqHXyRbo9KHKvFDEgQPaS5yNAf1FHb6RCgvHOJamTuv8/JJ0hL6+Il9tNgmwnCoEL0W1MZxpds6r/z9YeKA5MsEpk7Z5AySIu1hEA+yGWyP9yoaI+xC9yRFIiRKP8txl4UYLN21ng==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0uPmXKs1vB93lrNJCn9BAgEx3q8nouXmBL2xswaQk70=;
 b=EnuwsUbhHmIKIW/Xe0XL8oweXDfzymLiNHUrpq6ayCKSQkPry6Ym/IA45Hzgpdw+HHmLPpb9wpe2/Is97f98gxOT5JYqbIQIQmPMYPaKfHZDd4f4tg3uoF31vfz1HKVb03OVxxUYGE2BWwdbGqQQkTmKDcz6awT/eWQEcRRUlO7wOD2lCcmIv3wscXjcfNIwmwn/wZ5i0en5ekp/rbCPblEKE7XRitT70W0nyyiSdQc6GuRe12JarEJFyYVJRPWzTvURz3Ei05v1Iy1Mh7hWGkpvmOzb+cP+E3KOuovmgrvOX254mPnRJ4B8U25OBos7DDiVE1FFJiIf4OZpfL0xXQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linaro.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0uPmXKs1vB93lrNJCn9BAgEx3q8nouXmBL2xswaQk70=;
 b=G6oud31DQfsVhfkxCX4F4opzaD7k03cjFec4h0+jTdFz4IJD2hw3NdZQ1akqOI4EWmv9oXzEJRnIaMoXnpFQpv4iUa3rNu8eSHXNpf4gaMNfebMDuWGQgRSWcAuAzeU56PLSxReY+WyWO9yl25Cv0OYiW3gPhT9JtD3AClNyaOo=
Received: from AS4P195CA0006.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:5e2::11)
 by DU0PR08MB8663.eurprd08.prod.outlook.com (2603:10a6:10:401::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 13:03:04 +0000
Received: from AMS0EPF000001A7.eurprd05.prod.outlook.com
 (2603:10a6:20b:5e2:cafe::34) by AS4P195CA0006.outlook.office365.com
 (2603:10a6:20b:5e2::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Mon,
 15 Dec 2025 13:02:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A7.mail.protection.outlook.com (10.167.16.234) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Mon, 15 Dec 2025 13:03:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h486gtXpGnmdE04w0BMYltsJ3obP9B44LbUb+KNiNkuBLJ0W4HmF6n9JlBJtfeBxtn0VcyxAEYp6nsCWSWewBbMKfRIF4BRLNLn3yydlKpeALUlxmSxD6Zy65IroowKK6m6GI+Jlx8/mZq94lDs4uzN2sdt2BlBgMzPz33QYP+Gre59UZyX3p5k8P+6pP4PfQwUf/sbNPAJhTK2NbFckYjCRQ6fjbEgxi5wISi91ULTpgOD4CMoTUqOo73rt/9ztGVqM45qVTvG4qA2WB6DKxI66iBQRRJv0N3MIdIOizMFFg5WsqYUAPNECItkTIkUXF/8YNsHZUmXUVz3mRraXYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0uPmXKs1vB93lrNJCn9BAgEx3q8nouXmBL2xswaQk70=;
 b=kMn5vRaIiQ/c43oNq52WxrDbiQGBxZsyNALQLfWIV5gst5/GIacPSAoCzBFjHR5YZCBI02w7reFp/Z6B6ZoN7L6VJnZosV/MDki27EEyfjl3qCg1HmIo24cYQl5odz+AKDUyebQ6k0MbXlTPnrOP9TqgzEkP5qUiqp+AqyMxPQSTVk/iLn2PUC0GiCvt/lNqe66bJRcs8FgOFeZZ/iRsKb7nTvkimBDYBgBlLLveMa44+QLRH5ufdM6H3DPOubUS4EpBXsJ8UAJDAYvffrApTWPzaXVt2rphQxDZ8dEKYm397Dumz0X2L5xmlTK0LgaiQU/k43++l7rfu+dQm3+1KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0uPmXKs1vB93lrNJCn9BAgEx3q8nouXmBL2xswaQk70=;
 b=G6oud31DQfsVhfkxCX4F4opzaD7k03cjFec4h0+jTdFz4IJD2hw3NdZQ1akqOI4EWmv9oXzEJRnIaMoXnpFQpv4iUa3rNu8eSHXNpf4gaMNfebMDuWGQgRSWcAuAzeU56PLSxReY+WyWO9yl25Cv0OYiW3gPhT9JtD3AClNyaOo=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AM7PR08MB5477.eurprd08.prod.outlook.com (2603:10a6:20b:10f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 13:02:00 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 13:01:59 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "peter.maydell@linaro.org" <peter.maydell@linaro.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH 31/32] Documentation: KVM: Introduce documentation for
 VGICv5
Thread-Topic: [PATCH 31/32] Documentation: KVM: Introduce documentation for
 VGICv5
Thread-Index: AQHca3srU85q+1+8HkCPlW7uCaDOibUie0eAgAAzwAA=
Date: Mon, 15 Dec 2025 13:01:59 +0000
Message-ID: <44e57b5d9192569128aada07e27e5ca4005bc6a7.camel@arm.com>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
	 <20251212152215.675767-32-sascha.bischoff@arm.com>
	 <CAFEAcA-fgWOUu7yWfGNGyy0BwTPxH1ht+E5SQ4tjJf3U=w7e6w@mail.gmail.com>
In-Reply-To:
 <CAFEAcA-fgWOUu7yWfGNGyy0BwTPxH1ht+E5SQ4tjJf3U=w7e6w@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|AM7PR08MB5477:EE_|AMS0EPF000001A7:EE_|DU0PR08MB8663:EE_
X-MS-Office365-Filtering-Correlation-Id: 02b05d11-a710-40bc-f84e-08de3bda4867
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?bVgxMEFRL0x4cHZWQmhYc0JuSWxkVnE4S2lYb0ozQ1Q0SHlkL1NaYUhOVjZi?=
 =?utf-8?B?UEFhY0phb2dZRmRsRVFCeFNTcUN6aWlqQlNJdkwvZm5McGxJTEs3Qk8xZ2VV?=
 =?utf-8?B?c3FRblpTNk5BSVFzREtmV0NPNi94aGJBSzJoV1NCVi9tc0FXMGdpMXVqeWk1?=
 =?utf-8?B?RE4zaFdEYkxnOGs3VnlYTlZTVmRlempmUjE4dFROTzJaWjNxVlFFUWFEZWlm?=
 =?utf-8?B?cnpUV245ZzJKZHZUK0tBak5VOUhLRXArNTVXZGplMjRnS0lqd3d3TTlIdENH?=
 =?utf-8?B?cGZHL3Z2MlV5ZHppOTJ5MytuVVNCdVNLQytuVHhFYi9ZbXhINHR5alhiaElG?=
 =?utf-8?B?U0Q4TGdieVRvNjZFYXNHMFFCRkswS043YVNJMy9ubDFlUjlWcHNyOXVYV3ZT?=
 =?utf-8?B?NFNPaGdYTmRjalJ1SnBwRFdHV3dRN09kWWpHUDRmWVRaL3hOWWF4bWJyeFFL?=
 =?utf-8?B?dFB4d0ZTSmxGTy9ZUVJFcnhhZWttSTV5WUxvTHFyZnB3cTZuOWdWakdydHJ3?=
 =?utf-8?B?d0Nnanl5dktiNklDUFR1b3dnOEY1SUpjM0ZSKzJ6M2xQZTlGeFhDdEZyWll0?=
 =?utf-8?B?QVFrZG5kbHg1TUJvbkE1QzlKa3cvTVBDb2R4UU1OZHQzTlJaRFZSV3o5U2Yy?=
 =?utf-8?B?V2p0a3UyZGsrakRnMllTWlR0ZXlBb0l2MVVldVg1KzFzekxheCtNZGpDK2d1?=
 =?utf-8?B?OVNPR2NORGxTTFVDSklxc0xqMXlPMFp3SFltSkZBVDc1RWJDWmxXVHc4UVFm?=
 =?utf-8?B?dDJqem1SQVlCdmUvaldKQVFUVWlBbDJRbmRFZUFkelhrdUpYbnp3SWhNVGtj?=
 =?utf-8?B?V0tzQi9FcUVBSzZMbmZOcFUvR3puc3N4OEZ0bXJpVWRUalZkRGFXeXdwd01n?=
 =?utf-8?B?dkFsUW11TERzZDhDV01VRTdPem90dEJWUlYrUUZITnZtNzZ6NzBaREVoejU4?=
 =?utf-8?B?bTQvUHR1eVdtMG5QSXc5WW9iNldKQ2IrVjkzWFBCUnR2VUZISUIwSlZyU05Q?=
 =?utf-8?B?dFk3bzhHM1Zrd1U1ZCszR1FTMGJuR25uUjlVWVVEVkdEdDNoYTY0RS9RR0d4?=
 =?utf-8?B?TkZhZHZDUU9KRERyZldwb3AzR1lVNEg2NUw3YUg3cjEvVmkvc0kyc1dseTA3?=
 =?utf-8?B?OWE5WVlFalY2MUkxZVplYVFqVzdDNzhHNlBSbVNNSkVSRVoxYUhmNG5qY2FB?=
 =?utf-8?B?M1F3M1dwVSt5TnI0bjY2ZGFCUGJDMjJTSXUwNkEyZ09uZVNsUENLZ1IwNWl4?=
 =?utf-8?B?Y2dac3BpREQ0N3J0MEswRHVKYVI1bDBTbFdGc2lBQmROWjlydXc4Y3h6ZldN?=
 =?utf-8?B?NUxYSE1CK3RheWZkY0NZT3pwM0xOYTRVZzBFMzJZcHM3aUhPYVZnYVR1cXZr?=
 =?utf-8?B?Z3NVanpNVzJHNFQ4eUJoSXlONlMxdmNFa2FsSzNtY3liN29GSjFMam4vNzRR?=
 =?utf-8?B?eEdHN3A4WEEwQUtJY3U5Qmw1YUFuK2NNa3JPK1BNblRTeHMyL0R4SW9KU2w0?=
 =?utf-8?B?YnpUS05JNVB1VlQ1bHBhUHVrZGxrSjBEOU5pWFhsYUFyM3ZDcFJLUkxjcERC?=
 =?utf-8?B?NldwUzhYdThMeTVPVnVmZjd4bWF1TTlXYlErMkUyclNrYzhUUmZJejdiekNY?=
 =?utf-8?B?RUVNRCtweUZ1dit2UTNlOFJCb0JGdGNkYXZyOXFBcmh2SXp5L3Q5eUFMK20y?=
 =?utf-8?B?c2t2NkVOS3F0VWFFdUdWb3NFQXd3WDlOemlYVmNad3VMNlltYmxzRHJ4QWU5?=
 =?utf-8?B?aGRHdm5rbERoUVh0bGZUQ0tyaWhqLy9qRk5DSVE0Zi9PWW0yWE5JeE1GRENE?=
 =?utf-8?B?dUo0dnFsM1hJQ25sand6eEtUUTdhc2N3TUsxVlVCVFV2RkZlQ2lqRHIrZm9v?=
 =?utf-8?B?bit3VnoyR2Fyb1ducUxWdzh5cDFtRnVVZ2NxdlVRVVlIREFDKzFRQ2FONHdw?=
 =?utf-8?B?NldXZjUwUjc3Ujgyc1U1NVdEYVFJWXNUcUh0SXFGQUlBRXhiNkZlOHZ5SkJv?=
 =?utf-8?B?ZEJTOTBqdmdzVVJPYVJnVFJNVEtKQkhKaUFzQUZySkp6VE8rNWhaWmpuQUE5?=
 =?utf-8?Q?8el6He?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <AA3D7E9AA724EC4FAB72582E76655597@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5477
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A7.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b8c8f58f-2136-443b-c195-08de3bda2235
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700013|14060799003|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UzFVYWZ2SDNjWFlJemo2R2JLYTFjRFB3WnhqNUZtbm9aZXBvYlJCenFDVjR0?=
 =?utf-8?B?WVJPT0M3VkQ0anFISGtWbjBBVGV2b3hvamJ3WGYyL0ttb1ZyU3hFRXhYQjBj?=
 =?utf-8?B?c25rOFFQRjJVUTN0Q3lOR21oVVFsZUVGQm1qdEd2SjlVdG1WeW1KRUVUUlR4?=
 =?utf-8?B?VFREaFRVbU91SVNwMGpjaDNacDgwNnVSeHA4cDRXdkFDaldMV21BRG5FY3Q3?=
 =?utf-8?B?MDZUSUZ2dm9uVXpiWXE0VVQyWENaMXRmTndrcUxFNzd6cjVCSEJ5c3hPWWJv?=
 =?utf-8?B?eUlMSFVjTlpVMDIrRUtWWXVVL1diSUVPdHhSczNOR1F2aDE4N1BGY2NSVVQw?=
 =?utf-8?B?elF6SnpvTTR0Y0p4VUFMemNxaklObFpvS01wUm82K2NtWFRMdnlMa09DMndB?=
 =?utf-8?B?Q0ZGSnY4bzFWWjJmc1hySklYN2hyVktDU0Q5U01wYU8yUktSSlJlMmpRZFVy?=
 =?utf-8?B?d2dhc1IyS3FFdWt6ZkMxYmdrQy9tYytYOGdOcm4rcGMvakFvZ3duVnhFb1BD?=
 =?utf-8?B?ODRiVXJtZjF1V25DNE53a3V4b3VVQ04rWmlhV01hVXJMZVROSnNZZVBsKzdk?=
 =?utf-8?B?OGc0eGhvc1VFRXlPa2pMYlovYjhhVXNZSldDR0E2M3QvZnBhcGFTbTZvZzF5?=
 =?utf-8?B?alBaMXJFRzk1MWlyK2huVjE2amlDSlJzUmcxZk1YRlBRay9PTzU1QmRpL0hZ?=
 =?utf-8?B?THZPREZKWGpKYm1vSEhlbjJkL0pJYzZhUXdrc0c3WTNjd2RzNUdHMjVGWU5w?=
 =?utf-8?B?M3hzQnRBb1ZmOFB5Y204VC9ZWVR2eHhtTTljaUwwbVk5UmJwbE9HVkszQ0ds?=
 =?utf-8?B?TTNMMWhndkhSWjM0eDZTZTF2OTJTYUZ1Z0NKb3dMVklHZW1CL2ozWnViU1p3?=
 =?utf-8?B?ajN3RUFud0xUZ0FuRG53WEswaXNHWk8yZ3VLL1hrMEJtUnRrUS9EYlRRMGpY?=
 =?utf-8?B?T0pqU1ZhMFRLMWlGMElGdnBUZnZmTm5WakNRaDN1RHRibDVZLy9YMWlMVTVY?=
 =?utf-8?B?ZlpCOVpaNnNBQlQ5djJpQ3ZnTVUwUjZLNldJY1hFOWZDYVlSckFJS3JDVE5n?=
 =?utf-8?B?cGlHbXowb0NGeWphZmdCdVhud1N5eTdDZEdtQzQyMWc1Wm1GMVdGZUxvYWlH?=
 =?utf-8?B?VjBsS05JQWIrVXpiRnk5S3BMZmd5M0hoak9xUjRySHNSQitENUtDYzU5VXMr?=
 =?utf-8?B?d0ptaXFDNTY3TUJuMDd0RG5mRGUvODJyTnR2RHEwc3BhQm9WNVNBaWFGVEZQ?=
 =?utf-8?B?QWNMdWVoMWtQOVUxUFNSM2hDWm1MWmcyTmZMQzZqQm4vSkd5MWVWMTI4ZWwr?=
 =?utf-8?B?Y3Rua2pseW9jSDNQVVB5WndLZkZ6b0ZxM3V6ZjJETDRQWDNEQytEZHlVWXZ4?=
 =?utf-8?B?UjlhUDFZT0djK3N3emRNS0NINVF6WG5BcDlYd09jTm5WcXNYak5IWEVCako0?=
 =?utf-8?B?K3EyYWt2dnVYZFJFSzg4elJzYkxqYVNuVys4QXdGckRVY3dmSVFpVFc3cHF5?=
 =?utf-8?B?MEJVaXdkNFo2Yzg3UXBIRlpzZExZdTFuSTZEQjh4c0NrYjZXT3NJcXFhbjMz?=
 =?utf-8?B?NmtKR3FVYkhsTkhXZmFsTVhxOWRZWW12VkluQlJKVEpONkFlUzVicjdvMUxz?=
 =?utf-8?B?TXZBWlFNdDVLRis0TmtlTVI2TE9RTXZBOTJNZ0ovTW8rdytGd0FJSVhQTmhH?=
 =?utf-8?B?cStNOFJPcGNoMFg5YWx2ZXc2YW9UaDBFUmhWc1dzS1U3NWNlbXZKV3VkZWpL?=
 =?utf-8?B?RmpRRnNRSEsxbXBZZnBjZ0JPRm0yT2lWNzBZQndWWmZVaUprREJ6RUxOOTRs?=
 =?utf-8?B?VEtaSDkxaW5oNTdNY04zQm9HVXJqeVUyK01OM1VPVnYzZkt6Q1BxTDlXY1oy?=
 =?utf-8?B?RURQOEJQVXBHdno5RXFyRU53QWU0U3FuZGI3QnhwZSs2RThobHc1US9JeXJi?=
 =?utf-8?B?NCs5dk5EQ291QUozUHdwc0lvVHpabmFaLzdBdTlNMWxLZDUyZGhKejZRS2ZR?=
 =?utf-8?B?cDdiSHJmRHN0d1M4MDl2TnBIT0p2czVGdTY5S2swYlMyUTgxdEV5QTN3TDdl?=
 =?utf-8?B?Uk5vWDA5Z01KUGo1ekZpSnh3UWRScVdRL3ZHOWpEMHpzcW5FVjVmNnRmWldW?=
 =?utf-8?Q?oj7Y=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700013)(14060799003)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 13:03:03.6026
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b05d11-a710-40bc-f84e-08de3bda4867
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A7.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8663

T24gTW9uLCAyMDI1LTEyLTE1IGF0IDA5OjU2ICswMDAwLCBQZXRlciBNYXlkZWxsIHdyb3RlOg0K
PiBPbiBGcmksIDEyIERlYyAyMDI1IGF0IDE1OjI0LCBTYXNjaGEgQmlzY2hvZmYNCj4gPFNhc2No
YS5CaXNjaG9mZkBhcm0uY29tPiB3cm90ZToNCj4gPiANCj4gPiBOb3cgdGhhdCBpdCBpcyBwb3Nz
aWJsZSB0byBjcmVhdGUgYSBWR0lDdjUgZGV2aWNlLCBwcm92aWRlIGluaXRpYWwNCj4gPiBkb2N1
bWVudGF0aW9uIGZvciBpdC4gQXQgdGhpcyBzdGFnZSwgdGhlcmUgaXMgbGl0dGxlIHRvIGRvY3Vt
ZW50Lg0KPiANCj4gSXMgdXNlcnNwYWNlIGFjY2VzcyB0byByZWFkL3dyaXRlIHRoZSBHSUN2NSBy
ZWdpc3RlciBzdGF0ZSBhbHNvDQo+IGluIHRoZSAid2lsbCBiZSBhZGRlZCBhIGluIGZ1dHVyZSBw
YXRjaHNlcmllcyIgY2F0ZWdvcnkgPw0KPiANCj4gdGhhbmtzDQo+IC0tIFBNTQ0KDQpIaSBQZXRl
ciwNCg0KVGhhdCB3YXMgdGhlIGludGVudCBmb3Igbm93LiBHaXZlbiB0aGF0IHRoZSBvcmRlciBp
biB3aGljaCBzdGF0ZSBpcw0KcmVhZC93cml0dGVuIGFzIHBhcnQgb2YsIGUuZy4sIHNhdmluZyBv
ciByZXN0b3JpbmcgYSBndWVzdCBtYXR0ZXJzDQpncmVhdGx5LCBJIGFtIHJlbHVjdGFudCB0byBw
b3N0IHRoZSB1c2Vyc3BhY2UgYWNjZXNzIHBhdGNoZXMgcGllY2VtZWFsDQooc3lzIHJlZ3MsIElS
UyBNTUlPIHJlZ2lvbiwgSVJTIFNQSSBJU1QsIElSUyBMUEkgSVNULCBJVFMgTU1JTyByZWdpb24p
Lg0KQWxzbywgdGhpcyBzZXJpZXMgaXMgYWxyZWFkeSByYXRoZXIgbGVuZ3RoeSwgc28gSSBkb24n
dCBwYXJ0aWN1bGFybHkNCndhbnQgdG8gZHJhZyBtb3JlIHRoaW5ncyBpbi4NCg0KRldJVywgdGhl
IGN1cnJlbnQgZGVzaWduIGZvciB1c2Vyc3BhY2UgYWNjZXNzIHRvIHRoZSBHSUN2NSBzeXN0ZW0N
CnJlZ2lzdGVycyBsb29rcyBwcmVjaXNlbHkgbGlrZSB3aGF0IGN1cnJlbnRseSBleGlzdHMgZm9y
IEdJQ3YzIHVzaW5nDQpLVk1fREVWX0FSTV9WR0lDX0dSUF9DUFVfU1lTUkVHUywgYW5kIHJldXNl
cyB0aGlzIHNhbWUgaW9jdGwuDQoNClRoYW5rcywNClNhc2NoYQ0K

