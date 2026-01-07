Return-Path: <kvm+bounces-67210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F1F8FCFCFA2
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 10:50:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A70B33014116
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 09:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B342D32C94A;
	Wed,  7 Jan 2026 09:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mg0Fk33c";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mg0Fk33c"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010069.outbound.protection.outlook.com [52.101.69.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECED32C926
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 09:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.69
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767779416; cv=fail; b=jGMnRlbm5v3aaKADz5OEZIL8vc0/8VaGXNcZVniVq5GnReKQzm3Lq+xkvkcO92rZFIYRomAKdgmDyi5zSzXnoqA6lemEJttKBPyovzl933YZWNV8q+fr6O9bvDbQzqA1VDNniBOors6NIo/uftZQ8ohbUlfpvgl25afaqe9qgig=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767779416; c=relaxed/simple;
	bh=NEcwjfUIcwHuZjEObgbRK91TIznoJrUEtmbwjSwwH+I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kAy4N8x425nFqh8g8tGU2Pi4a3qx4dRV3kgmlBjNOkc3d9OBhomsBVda8tkY24yJbAoBR7LbsEp8y1lxSRmDi+Sspmezs/zx+8YYTtz+r0zNGTT2JlMN5qnp8ApOp6WlCTqKB89Yj+4nvpjZBpZWIPmtv2zS1dQKhvlAH10sxlA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mg0Fk33c; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mg0Fk33c; arc=fail smtp.client-ip=52.101.69.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=gg/BkimUalqjGDCv+mUKl6UHlQRYQhECJskIui1A2S4ntmifRlEFTQp82NdVtxH8HIrFdVSx73w2QKMgE2EyC86qXEoVVD9oJtxn5JiWwteXjQwi1kU/6RmGAvAVf+bYM0aYhq6WvA+4gfRlli7YSUfwBizr5aynAopc1joHNCCVNyiICaw6xVzt59KmzV7K929lYJhzxzGagOVEMbAKx6rgMMncAhs46hqo5KraABB0dYFNe1xW+Sdzw6OSAMcwloayac+wbAXe3rW+MHGRIXIVVxzwhMBojUCO6QZHvcRuY9FNjuoS7lk4cyAfkZ2IcO9kl2Y72cBce74/0R0WZw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NEcwjfUIcwHuZjEObgbRK91TIznoJrUEtmbwjSwwH+I=;
 b=KrTIQlJNV4v8OAXFGhCzRNhK0HtRXKQnwyPIt8uHMTVBYsr6ix1+x4Fy3S8O4IIrywzXhnNjsZQWsNJOG97l09QWSXOLgdtUWEl/BDVMwN5UOyRiwHrfpuRUtDgn+Mqb+B4deMWY8MXjrXdJ9nsxiMe5IBUSHdTaGFruBITw9/T3YQXubBzjNX991Q9iKYnQVLo3xk4BjaCuK/PFauYOdPPbAwY8AM5QPFDVOYjeFycIb5Bib3OyBjnl4Fk8NnRfZg1runo0v68KWiTD517lVSYw3T5a/4wXdsYRs5CTSRh8vQT4fGD4UHR02c4VcetJ3858wL26jAgIZgq6RO9eKQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEcwjfUIcwHuZjEObgbRK91TIznoJrUEtmbwjSwwH+I=;
 b=mg0Fk33cWMQJphFTvarV3eo6FQnMMOnaESimr6VetoyT/nl60slx5tDEPCM+F28EUBX9vdiv0KMua3uiQhzcA1Vn7QlskePEi9pGPxG05tVkCDFfRefa8PbroWX4g0xUFPX7rkJjDQkwvAkDyIHpMv5lu8MwCYjNra/ZjVpnCQU=
Received: from DU2PR04CA0227.eurprd04.prod.outlook.com (2603:10a6:10:2b1::22)
 by AM8PR08MB6593.eurprd08.prod.outlook.com (2603:10a6:20b:364::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.5; Wed, 7 Jan
 2026 09:50:08 +0000
Received: from DU6PEPF0000A7E2.eurprd02.prod.outlook.com
 (2603:10a6:10:2b1:cafe::5a) by DU2PR04CA0227.outlook.office365.com
 (2603:10a6:10:2b1::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.2 via Frontend Transport; Wed, 7
 Jan 2026 09:50:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7E2.mail.protection.outlook.com (10.167.8.42) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.1 via
 Frontend Transport; Wed, 7 Jan 2026 09:50:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vlWX8DSEWz4KtAP26XbvO5Fnwrv4o1LDouLExXuWER+4HSdpxy8DTEdn4ZpfsyGSPOdF/MFcyx4CJf9tmb8rdDFlj/FYTTPRiU5w+0U3eFj5Hljj7ntXWw0e+PYOha6xrmeVjPEPKSyseCRBsi3TEFx0cz4/iL2YIyhjzqSdoYtiZE3OTbaY4xCmFC7i9B42m6bfo2XhuVX4ttdwp7XkMlwmh/VjFO3K9mgNrRZKOpoiFQKfZmA0lt0vumD/ffR/3bTVCKRePQpYa7Y+opWtkRroMoEx8Ze21d2l0i9MprFcD81UOCPaoRa/mQM5i5rlj5G9CU9TWF72NmvIuKHr7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NEcwjfUIcwHuZjEObgbRK91TIznoJrUEtmbwjSwwH+I=;
 b=QkAqJ45amBWsj/Ob9Aoyhon7E++X4mXxBoaXmAyyiuF9dw1pPkdihNHSaj5QAF86ylBh8/rITFAzU2zYS14igd3b4a2Dl90DDKso+qvMoAHMhHSwbPRukfgE2CdBnUE9+rlqwPzS/xwdwrroPqRjbi91ZZyi1JBelK6liqiLbFiBHTko39RGtFLCPkY4jaTLIO0oHasc3Uxz8YiXQEIs4qzoEhZBUZko9lWcXXeR+U3LrZEYTU+6y+Bh1zkgQaHGuPnACD+vo+VZa+1oE7EsEa8Bjnim/3iwFWB2N0Aos9TLEXcUigBoyfIjB9x+gMahEjNLQ2f+9HJMvLZUstE2cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEcwjfUIcwHuZjEObgbRK91TIznoJrUEtmbwjSwwH+I=;
 b=mg0Fk33cWMQJphFTvarV3eo6FQnMMOnaESimr6VetoyT/nl60slx5tDEPCM+F28EUBX9vdiv0KMua3uiQhzcA1Vn7QlskePEi9pGPxG05tVkCDFfRefa8PbroWX4g0xUFPX7rkJjDQkwvAkDyIHpMv5lu8MwCYjNra/ZjVpnCQU=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS8PR08MB8611.eurprd08.prod.outlook.com (2603:10a6:20b:563::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 09:48:59 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 09:48:59 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: Joey Gouly <Joey.Gouly@arm.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH v2 27/36] KVM: arm64: gic-v5: Mandate architected PPI for
 PMU emulation on GICv5
Thread-Topic: [PATCH v2 27/36] KVM: arm64: gic-v5: Mandate architected PPI for
 PMU emulation on GICv5
Thread-Index: AQHccP+EO8ljQOSF00aJPJpJBfjFS7VFWf4AgAE5swA=
Date: Wed, 7 Jan 2026 09:48:59 +0000
Message-ID: <4278ecdbb1413e460cce8c7abfbdd70ad6c80ade.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	 <20251219155222.1383109-28-sascha.bischoff@arm.com>
	 <20260106150612.GB1982@e124191.cambridge.arm.com>
In-Reply-To: <20260106150612.GB1982@e124191.cambridge.arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|AS8PR08MB8611:EE_|DU6PEPF0000A7E2:EE_|AM8PR08MB6593:EE_
X-MS-Office365-Filtering-Correlation-Id: 83b9103b-24a8-45bb-5054-08de4dd223be
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?NEpvNXNkYXFScFVRUTVtMzRuN1k2STBvMHlURWs5UE9wbWJ6SFpUYytacmNu?=
 =?utf-8?B?NjBEZzVyWkZGcVh3SHRlWm5tVkVZb0ZUL0c2SElEcXpPaEQxdXBOT3VHYzMx?=
 =?utf-8?B?N0RtWUY5TzFmWEI1UHJRczZvblpsZmw3S1hpWllEZlVpdS9CeFFULzNxQ2xP?=
 =?utf-8?B?TVJ3bnRnM3JicHdZbWJLZWZQUFREaEVyRmxOTDR0ekRwd21HTjMxTGlhUGZP?=
 =?utf-8?B?K1VicnVQaXpVQmkwOHpoV25OeHF6OXlBRjFLM2g2b3dXMFE5d3NoU0VXK2Qw?=
 =?utf-8?B?dXRPTE0wZTlQUEZldEgzblY3YzBkcmtNTzRDRkdRWkpObDlTanRNc1ZoYmdm?=
 =?utf-8?B?Y3E2bXFTTjFhbFRMSFJiSlhIemR4SlNwQ2Fsdy9HSzFmb0l2M1ZJdncvSXZi?=
 =?utf-8?B?ZnU1RkF3dDAvNTVQc3RZZXF5ZS9lbUllZHlqd2VyTjdjOGJFc21GM3pxWjUy?=
 =?utf-8?B?alR0UW9sZDZwMHJqZ3hvbFdhRVdaODgrVFJ1Sis2d0JEZ3VRUzRVdTVnUDly?=
 =?utf-8?B?eGE1aDV6c3JsWGh3QkhCMFliVTg1dkZTUHhQbktXRVFGTGZ1bHp6SHRsL3h6?=
 =?utf-8?B?eXR4UHdTa041T1ZFKzRCL3lMeWkyb2NFb2M1c3Jhd3pITHZ6RmFHK055QVcy?=
 =?utf-8?B?N2sxU0JldkFPc0o0R3FuWTNtQkFGeTNvNnRlSGMwWmVMYStxMWZYUy91Y1hS?=
 =?utf-8?B?SS8xcTVoejg2RUJHK0FzR3dSTjlFNG5NZHllUWcrZm5tVUZTZW1oZDJXTEg5?=
 =?utf-8?B?b0VWdnE0dUlXYVU5Y1JJT09mTys3Rmg2VngwZHJXd05JQUd2U1hmRDFvRGFr?=
 =?utf-8?B?enk0UDJnNExGaWZYV1lzWGxEZG1SVkJYWDEyYU0xOFJ5Uk1EcmhsV3BDeGNq?=
 =?utf-8?B?ZmIzSzM0SnBDalF5cDJzYVlWellQQnFQL2lMWFJOUUJuU0ptV05xeGhha3Zn?=
 =?utf-8?B?VDlhRDh2dnU1UnlJWHFkZEZBOWhRYXZhK1UrWjdMaUNlZzRwb1c3VVMxZFRh?=
 =?utf-8?B?YUV2ZDhXbWV6VFlMbGc5NmVyMUxZaTZEa1V3OXZwRVU0RVFOYk4xcURYSk1S?=
 =?utf-8?B?cC96OTY5QklIb0pwdFd3UENuc3ZjcHFoVU44ellaV3QxYTRqOUZNYmc1ZWRE?=
 =?utf-8?B?NzJINXVQZnBFMFV1YnY5VFFoTDZEVjZYc1FMOHRpSGtSV25kSE1ZaW1zaXVX?=
 =?utf-8?B?QjNBaXQrbXFFdk5KOXRYNXA4bUhNeXlROFJtalFaUk5mZEVGQWZQak5BZnpS?=
 =?utf-8?B?WDBBc0xZNkNROUdEUkZKUHg3TzhFaHpoNHJ6Rm91NjVPbzdnV3FEbk5GcWNZ?=
 =?utf-8?B?WFZHV25mMFY5WnVwbVRFQjhVSjIvNlkrTFMyMWx2NnNSWi9ZcTFGMy9RTDJk?=
 =?utf-8?B?V0lPRXpzNDN4QVd4QVpiWEtYbVRsY0tTZXVzZS84L3dqYlR1cDZ0SzIyaERq?=
 =?utf-8?B?am5SdUMvVVVHMXVJc3RlMDZUNmp5K2VyU0YwYllmdkE1cW9kMFRLaEhPOWRB?=
 =?utf-8?B?NDg0V2gyT1dNcHdGTWc2WVNqWTVES2xKNU93VFZML2dxTUpjMDUzdEtYMkxj?=
 =?utf-8?B?OVRseEpna3dvQnUrOVkvckxCN3BheXI0UmhrNEJaZHBwUEVweGdzRko5U2Y4?=
 =?utf-8?B?aWUra3dIUzdxa1NUUXlXd3pRUXRqcmovcm1oSFA1R0cvUEVuRUhtV3B1ZkFk?=
 =?utf-8?B?bkxmK0Fwc2dwMFNUc2tRNXVJU0dvcHRJK2M1dXNMcDF6YXR5bHFLa1gyVzA2?=
 =?utf-8?B?OUxjaHdiZGtJVnZjRzdQUTd5TWNrbjVHb1pYeHZrTlJmSm54blNJcFJvaEhJ?=
 =?utf-8?B?ZXlzK2kvV0VEZ3NvTW1wWGNPcGVCcy94MWdVYUkrS2VvSVAxbGs5R2Q2K0Jz?=
 =?utf-8?B?RWNMYjE3ZlFIVmxKZHZiM1VaTE5SVE1pVmRYQ1Q0VEQ2a2lXRFBLakJ3TVhY?=
 =?utf-8?B?NFFtMTlZUTBIV1R0cnBQTlFjM1B2SHNrM1YybVZJZWZZQlEyeW9QOGFlR0I0?=
 =?utf-8?B?eWVKU0RyMXl6cUlCRXhzWDVPNHROMFd6NWpQcEJzUUFLZzZOaVJTWDRHcmpZ?=
 =?utf-8?Q?x2FwLK?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <3C93A8679978CB478F1DF3CF8D7DB64B@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8611
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7E2.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	42eab895-ab9a-4074-e3f5-08de4dd1fb90
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700013|82310400026|1800799024|376014|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S3IzMzVWL1ZjT0tkR1hSY3ZrOXNJWldUL0d3aXYwdmJ1REQ1MFJQaFdIeGJ0?=
 =?utf-8?B?b3ZEQUhpQlRndmQzUHp1b2dRbWNzNG9ZVm40R1luaERISUR4QWhuQlpGR3Yr?=
 =?utf-8?B?Yzk4UkxJd1JnNElUMmlJcGNWd2pwQXMwZlJ6aGhZaERRSUZVOWF6VGpKU0tK?=
 =?utf-8?B?LzFaM2VOVXc5RzBWWFhrQUZkZEJTQnJTTFBWM2ltUE0zYllxcG1OYUNJZ0hQ?=
 =?utf-8?B?alYrUjNJMnRwci9uK0wxTEExa0sweFZyR0t5Y1BHbWl0NFpIWi81bkNDS1U1?=
 =?utf-8?B?Y0hVakVJYk93enBCNy9XWjhZVEJxT1hpUkRPMzRVN2xJWlZoTFdqRWFyZjhl?=
 =?utf-8?B?VTdTNDFWWitFOENNMzEyWkRXa3hZWUowK3VDWXN6UnVCay9BT29vb0VlZDlS?=
 =?utf-8?B?eXpBNnNISHNPbVoxSnRyWWd2eElaSTNkMUJSRUNHY3JFckRRYnFuS3lLR1Vs?=
 =?utf-8?B?RE8ybDkyRER0Yk1SUDVDZXI4dkx5Vyt0am5obGloWVU0aTlYWHlEb0tHMFZT?=
 =?utf-8?B?cUtJaDZ5eWRoNE5UVVpvWC80Vzh3R0s2WWVNNWg4blZkUDJhVXZlVWQzSEFZ?=
 =?utf-8?B?SEMyWnlGd1ZCdlN1TDFlNDZMTjVzaE84WERKQkxYQjJUR29UKy9Sa2dvemRh?=
 =?utf-8?B?ZHR2b09zbVBPY29PL1BtbVRtTlVUTUs2VVE4enRiTnlHcGc4N1JzbXVGNzVK?=
 =?utf-8?B?Y0FqOWpkbFFTRFQyME9aNUpwTnhQUmg4ZnAyTmZOZUlBR0w1MlVBK2d3Tmdn?=
 =?utf-8?B?MHpkMUtTTnBMbjV4NFVMWlVNZk9rOUtMSmYwZ3c3M3dIOEFQTTUrbVkwOUVJ?=
 =?utf-8?B?dTJBT0h2SGxuaXcycElRMHRQYXZ6d0FUQ3BmRjJlRDJueXl4bDZlWnhjZ3Rn?=
 =?utf-8?B?aEE1SGMwREYvUzVyVCtCazhNcEhXeHVSdU5IdEJZUDZrYnFhZ0czVXpzS2V6?=
 =?utf-8?B?eVgrbFp1VnlJRFV6LytuNklibkh2SGk2QlEwcGh5alJPUGpQQ0ZTSWMxNnM5?=
 =?utf-8?B?SmQzZnltdEZWcXh2VktZZnNwSnhJM3JGZFprdjZScDdkQjZFcHJSYXZuMEd5?=
 =?utf-8?B?YmZOS1hrNHJjTEtNb2tEUmxtYkswejd5eHg3MldIQlZmWWs4UzNuRGZJNnlx?=
 =?utf-8?B?aEEvTkd2RVROQW55Zm5QbTMrMUpjbnhwNW10NnAxZlcrVndzRHdvejZrdWt6?=
 =?utf-8?B?NUVvNnhxTHNTRklEYk8wU1p2MHBWUVZjT3FkMTRWUGd3U2VIUlUxY2U2L0Y4?=
 =?utf-8?B?SFZDVjd1bGRwanRNMSsrYXZIbFRnTlRnS1BWL0tCeDUxYWNWWGw4bUwzQkZp?=
 =?utf-8?B?ZFJFeDA1R0N4R3NZNXVoWHNiSEw5YndIRnY0djRWanBNMmFHRW9XYWk3TVpo?=
 =?utf-8?B?a3VRbTd1a3BQc0tucG5sbG1vcnhjNkw0T3NJSEtRcnJTZlFTMHlIWG82YVpa?=
 =?utf-8?B?UVN6OHVSRE5BMm9EUVFwdER3ZjdyTkFjSGU5dUJBcVpRc1BKR0ZycDk2b1RC?=
 =?utf-8?B?dzlndWh3d3QySnpsWWhSazVLaTlQbXNGOWFHekpqWjhWazR1YlVjZXc4T2tS?=
 =?utf-8?B?RW9nRkcwa05PTkphVjcwR2d3UDZ6S2tuWVdLTW12L0Q1MXVlNWNwRU9mYmtF?=
 =?utf-8?B?NHlYZW53Y3c1aDdoSUxLUGRKVU1PZUJVNFpwejNvaEUvYXBLN0NEckE4M2t4?=
 =?utf-8?B?ckJIRFZaZkpGNVlGdno0eHFoWEFib1VhNEpPeXU2bys1bzM4MzVkcGtnZW9m?=
 =?utf-8?B?OTVUZm5obG51bjMrS2Qrd0QybjlicFk2aUZ3MDU2WC9IMTRoQWR1bnlLRGR6?=
 =?utf-8?B?T0EvS2lDTzlkRGFsTkdzUThtWjRBdjROVkhCdEl4bUtBN0tVa2V5WURMeWNp?=
 =?utf-8?B?YmIyeFVJUGw2UXZwOVdWSzVJMDduZUwzVzVieENITWVZNm9CbG5DODZWYWVm?=
 =?utf-8?B?U1BOR05IQ3dlT1hFZCt5aWZaU2FFdDdGSHEwNUdiOGg3Yi8zV0lHN21IaEJm?=
 =?utf-8?B?ZTRkckVDMldXa29SREdzMnlHeXQzZ09mbC9LZ1I4QmJYOTdDR3p6YzNPdFI3?=
 =?utf-8?B?ekRHdHY5UnlyMUx0a09NK2F3UUdGbUN1d1ZwZGw3RkwxYWlFQkxsU3JOUzNP?=
 =?utf-8?Q?5WP4=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700013)(82310400026)(1800799024)(376014)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 09:50:07.0115
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83b9103b-24a8-45bb-5054-08de4dd223be
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7E2.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6593

T24gVHVlLCAyMDI2LTAxLTA2IGF0IDE1OjA2ICswMDAwLCBKb2V5IEdvdWx5IHdyb3RlOg0KPiBR
dWVzdGlvbiwNCj4gDQo+IE9uIEZyaSwgRGVjIDE5LCAyMDI1IGF0IDAzOjUyOjQ1UE0gKzAwMDAs
IFNhc2NoYSBCaXNjaG9mZiB3cm90ZToNCj4gPiBNYWtlIGl0IG1hbmRhdG9yeSB0byB1c2UgdGhl
IGFyY2hpdGVjdGVkIFBQSSB3aGVuIHJ1bm5pbmcgYSBHSUN2NQ0KPiA+IGd1ZXN0LiBBdHRlbXB0
cyB0byBzZXQgYW55dGhpbmcgb3RoZXIgdGhhbiB0aGUgYXJjaGl0ZWN0ZWQgUFBJICgyMykNCj4g
PiBhcmUgcmVqZWN0ZWQuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogU2FzY2hhIEJpc2Nob2Zm
IDxzYXNjaGEuYmlzY2hvZmZAYXJtLmNvbT4NCj4gPiAtLS0NCj4gPiDCoGFyY2gvYXJtNjQva3Zt
L3BtdS1lbXVsLmMgfCAxNCArKysrKysrKysrKystLQ0KPiA+IMKgaW5jbHVkZS9rdm0vYXJtX3Bt
dS5owqDCoMKgwqAgfMKgIDUgKysrKy0NCj4gPiDCoDIgZmlsZXMgY2hhbmdlZCwgMTYgaW5zZXJ0
aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02
NC9rdm0vcG11LWVtdWwuYyBiL2FyY2gvYXJtNjQva3ZtL3BtdS1lbXVsLmMNCj4gPiBpbmRleCBh
ZmM4MzhlYTI1MDNlLi4yZDNiNTBkZWM2YzVkIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQv
a3ZtL3BtdS1lbXVsLmMNCj4gPiArKysgYi9hcmNoL2FybTY0L2t2bS9wbXUtZW11bC5jDQo+ID4g
QEAgLTk2Miw4ICs5NjIsMTMgQEAgc3RhdGljIGludCBrdm1fYXJtX3BtdV92M19pbml0KHN0cnVj
dCBrdm1fdmNwdQ0KPiA+ICp2Y3B1KQ0KPiA+IMKgCQlpZiAoIXZnaWNfaW5pdGlhbGl6ZWQodmNw
dS0+a3ZtKSkNCj4gPiDCoAkJCXJldHVybiAtRU5PREVWOw0KPiA+IMKgDQo+ID4gLQkJaWYgKCFr
dm1fYXJtX3BtdV9pcnFfaW5pdGlhbGl6ZWQodmNwdSkpDQo+ID4gLQkJCXJldHVybiAtRU5YSU87
DQo+ID4gKwkJaWYgKCFrdm1fYXJtX3BtdV9pcnFfaW5pdGlhbGl6ZWQodmNwdSkpIHsNCj4gPiAr
CQkJLyogVXNlIHRoZSBhcmNoaXRlY3RlZCBpcnEgbnVtYmVyIGZvcg0KPiA+IEdJQ3Y1LiAqLw0K
PiA+ICsJCQlpZiAodmNwdS0+a3ZtLT5hcmNoLnZnaWMudmdpY19tb2RlbCA9PQ0KPiA+IEtWTV9E
RVZfVFlQRV9BUk1fVkdJQ19WNSkNCj4gPiArCQkJCXZjcHUtPmFyY2gucG11LmlycV9udW0gPQ0K
PiA+IEtWTV9BUk1WOF9QTVVfR0lDVjVfSVJROw0KPiA+ICsJCQllbHNlDQo+ID4gKwkJCQlyZXR1
cm4gLUVOWElPOw0KPiA+ICsJCX0NCj4gDQo+IFRoaXMgcmVsYXhlcyB0aGUgS1ZNX0FSTV9WQ1BV
X1BNVV9WM19JTklUIHVBUEkgdG8gbm90IG5lZWQNCj4gS1ZNX0FSTV9WQ1BVX1BNVV9WM19JUlEg
dG8gYmUgY2FsbGVkIGZpcnN0IGZvciBnaWMtdjUsIHJpZ2h0Pw0KPiANCj4gTWF5YmUgdGhhdCdz
IGludGVudGlvbmFsLCBidXQgaXQgc2hvdWxkIGJlIG1lbnRpb25lZCBpbiB0aGUgY29tbWl0DQo+
IGFuZCBtYXliZQ0KPiBldmVuIGluIHRoZSBkb2NzIChEb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2Rl
dmljZXMvdmNwdS5yc3QpPw0KPiANCj4gVGhhbmtzLA0KPiBKb2V5DQoNCkhpIEpvZXksDQoNClRo
YXQncyBhIGdvb2QgcG9pbnQgLSBpdCBkb2VzIHJlbGF4IHRoYXQuDQoNCkknbGwgZ28gYW5kIGJ1
bXAgdGhhdCBkb2N1bWVudGF0aW9uLiBJbiBhZGRpdGlvbiwgaXQgc2hvdWxkIGJlDQpkb2N1bWVu
dGVkIHRoYXQgR0lDdjUgcmVxdWlyZXMgdGhlIGFyY2hpdGVjdGVkIFBQSSB0byBiZSB1c2VkDQpp
cnJlc3BlY3RpdmUgb2YgbWFraW5nIHRoZSBJUlEgaW5pdCBvcHRpb25hbCwgc28gd2lsbCBjYWxs
IHRoYXQgb3V0DQp0b28uDQoNClRoYW5rcywNClNhc2NoYQ0KDQo+IA0KPiA+IMKgDQo+ID4gwqAJ
CXJldCA9IGt2bV92Z2ljX3NldF9vd25lcih2Y3B1LCB2Y3B1LQ0KPiA+ID5hcmNoLnBtdS5pcnFf
bnVtLA0KPiA+IMKgCQkJCQkgJnZjcHUtPmFyY2gucG11KTsNCj4gPiBAQCAtOTg4LDYgKzk5Mywx
MSBAQCBzdGF0aWMgYm9vbCBwbXVfaXJxX2lzX3ZhbGlkKHN0cnVjdCBrdm0gKmt2bSwNCj4gPiBp
bnQgaXJxKQ0KPiA+IMKgCXVuc2lnbmVkIGxvbmcgaTsNCj4gPiDCoAlzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHU7DQo+ID4gwqANCj4gPiArCS8qIE9uIEdJQ3Y1LCB0aGUgUE1VSVJRIGlzIGFyY2hpdGVj
dHVyYWxseSBtYW5kYXRlZCB0byBiZQ0KPiA+IFBQSSAyMyAqLw0KPiA+ICsJaWYgKGt2bS0+YXJj
aC52Z2ljLnZnaWNfbW9kZWwgPT0gS1ZNX0RFVl9UWVBFX0FSTV9WR0lDX1Y1DQo+ID4gJiYNCj4g
PiArCcKgwqDCoCBpcnEgIT0gS1ZNX0FSTVY4X1BNVV9HSUNWNV9JUlEpDQo+ID4gKwkJcmV0dXJu
IGZhbHNlOw0KPiA+ICsNCj4gPiDCoAlrdm1fZm9yX2VhY2hfdmNwdShpLCB2Y3B1LCBrdm0pIHsN
Cj4gPiDCoAkJaWYgKCFrdm1fYXJtX3BtdV9pcnFfaW5pdGlhbGl6ZWQodmNwdSkpDQo+ID4gwqAJ
CQljb250aW51ZTsNCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9rdm0vYXJtX3BtdS5oIGIvaW5j
bHVkZS9rdm0vYXJtX3BtdS5oDQo+ID4gaW5kZXggOTY3NTRiNTFiNDExNi4uMGEzNmEzZDVjODk0
NCAxMDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL2t2bS9hcm1fcG11LmgNCj4gPiArKysgYi9pbmNs
dWRlL2t2bS9hcm1fcG11LmgNCj4gPiBAQCAtMTIsNiArMTIsOSBAQA0KPiA+IMKgDQo+ID4gwqAj
ZGVmaW5lIEtWTV9BUk1WOF9QTVVfTUFYX0NPVU5URVJTCTMyDQo+ID4gwqANCj4gPiArLyogUFBJ
ICMyMyAtIGFyY2hpdGVjdHVyYWxseSBzcGVjaWZpZWQgZm9yIEdJQ3Y1ICovDQo+ID4gKyNkZWZp
bmUgS1ZNX0FSTVY4X1BNVV9HSUNWNV9JUlEJCTB4MjAwMDAwMTcNCj4gPiArDQo+ID4gwqAjaWYg
SVNfRU5BQkxFRChDT05GSUdfSFdfUEVSRl9FVkVOVFMpICYmIElTX0VOQUJMRUQoQ09ORklHX0tW
TSkNCj4gPiDCoHN0cnVjdCBrdm1fcG1jIHsNCj4gPiDCoAl1OCBpZHg7CS8qIGluZGV4IGludG8g
dGhlIHBtdS0+cG1jIGFycmF5ICovDQo+ID4gQEAgLTM4LDcgKzQxLDcgQEAgc3RydWN0IGFybV9w
bXVfZW50cnkgew0KPiA+IMKgfTsNCj4gPiDCoA0KPiA+IMKgYm9vbCBrdm1fc3VwcG9ydHNfZ3Vl
c3RfcG11djModm9pZCk7DQo+ID4gLSNkZWZpbmUga3ZtX2FybV9wbXVfaXJxX2luaXRpYWxpemVk
KHYpCSgodiktPmFyY2gucG11LmlycV9udW0gPj0NCj4gPiBWR0lDX05SX1NHSVMpDQo+ID4gKyNk
ZWZpbmUga3ZtX2FybV9wbXVfaXJxX2luaXRpYWxpemVkKHYpCSgodiktPmFyY2gucG11LmlycV9u
dW0gIT0NCj4gPiAwKQ0KPiA+IMKgdTY0IGt2bV9wbXVfZ2V0X2NvdW50ZXJfdmFsdWUoc3RydWN0
IGt2bV92Y3B1ICp2Y3B1LCB1NjQNCj4gPiBzZWxlY3RfaWR4KTsNCj4gPiDCoHZvaWQga3ZtX3Bt
dV9zZXRfY291bnRlcl92YWx1ZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2NA0KPiA+IHNlbGVj
dF9pZHgsIHU2NCB2YWwpOw0KPiA+IMKgdm9pZCBrdm1fcG11X3NldF9jb3VudGVyX3ZhbHVlX3Vz
ZXIoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1NjQNCj4gPiBzZWxlY3RfaWR4LCB1NjQgdmFsKTsN
Cj4gPiAtLSANCj4gPiAyLjM0LjENCg0K

