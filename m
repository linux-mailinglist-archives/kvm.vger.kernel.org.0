Return-Path: <kvm+bounces-67587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 08C5CD0B83F
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:08:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B3AA130CE2E6
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:02:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F7EC364EB6;
	Fri,  9 Jan 2026 17:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HHEV5L35";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HHEV5L35"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013023.outbound.protection.outlook.com [52.101.83.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2956F35E551
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.23
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978120; cv=fail; b=a11GKjFbAnEbtRvon5zoVzxFog9rHDDG0tQrpAuCoN6CYOA4pI5jqB6DAeMtWZbnO9X7h/yLAWS7dHHzDjA/OmbYQ4CUI0l+AB9DPRkjuGKGBekIlbSYWqv/usfUXkYVVNrmVIIrMwGbkVT07f+/y1Ue9MrAbz6l9A7RIVHR0lk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978120; c=relaxed/simple;
	bh=7tNV8kXFyTRqVSIz4uHIGUNPd/2Ex7IzC63Bmo0Li0A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e+zr0U8OSE1kiJ7EeCMK8SCdIPgSQOTclbfno+wVaBgPNYZ1YT5WBSf8uvNRiCjYonf4SENA0g6BsegJIEqPG21qgmBoM/eti3aU8Eb2uGiNPHMLAQZ+6IrUvZSQChD4OOCS9loUQ58e4LHGiNG3/YU64FtfLMwxX9FhMRUbIHE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HHEV5L35; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HHEV5L35; arc=fail smtp.client-ip=52.101.83.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=CqEPWnB+t2Vp042R+vWKnaOg1zUUGrPzLq6U87v7vFraC1WjiNn1BZEx6xGuuewOr1CVWZ6ZVfxQtGvMrN0SgDF/TzUu7zaT0O/11PB4eqpbPf6i355x98kpZ8lvr5wIXbAdjTLuPqZ2IyVWt+Qw7gFAl2Z1wAZxHfv/umBEqKVKZni/9LMTBMqM8Hskp1jk5Y2b58zy17j84KDRr1HRs1Lnvtmc6KTECfa2c+KUPLufTCOzQCvox8qWBDEzKDWW8WVA9Jdw8XxrhSEfroaWcEoS8d9ahyCke+7n3wrG8yN6NzfXHUS07PFLA4LTT584SOgyhkfSP6PmdGfbGNgyRA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7tNV8kXFyTRqVSIz4uHIGUNPd/2Ex7IzC63Bmo0Li0A=;
 b=Lh5EsHFLCq/acN3G0k1pgqKm9glJDZo2KrSRxlboxgODkGf9+rHHqkiNivyRnTYo/EG/x/Tjo28f7SwHOtGDf8Mz9YJI/55oru1jeu1HLqaKxZB26k4YjieTW+1xUKTt/Gpzd3vNiM4Im5+m0hVSlld/xxtruXmnPeNjii1S6n+LprAKUU1c94NyF3ZNU++LhWBvwlaEsL+oKtA8FE5Zrqwa4HgVXdEG1m5blg0qwaHVEi46RmUX9QN7Ump7vyWYUSKJq39vubdnU26OkDR3oMoBnDiVTheWvnjfvIbhw04E+16fb4KbUvLqRR/nbKwJyuCsibziqbWBrR3kj+kj4w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7tNV8kXFyTRqVSIz4uHIGUNPd/2Ex7IzC63Bmo0Li0A=;
 b=HHEV5L35wkmtp3QLsf2bl87DLqea7gX1CxRsD+Vrh7sZtvrSW5gF3GpbpdKP/vg6vPQGH+uKbd4s8FO01ikKfAXgT8ztrSeTnAJTdcAGSq+owCreeKL4Ehc8kuLPSQ24MfzsdGbDpxo6uhrLuUMgPO5FSDZCiLzWMkv6sCqSGM8=
Received: from DU7P191CA0006.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:54e::34)
 by VI0PR08MB11480.eurprd08.prod.outlook.com (2603:10a6:800:2fb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:01:49 +0000
Received: from DU2PEPF00028D0F.eurprd03.prod.outlook.com
 (2603:10a6:10:54e:cafe::89) by DU7P191CA0006.outlook.office365.com
 (2603:10a6:10:54e::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.4 via Frontend Transport; Fri, 9
 Jan 2026 17:01:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0F.mail.protection.outlook.com (10.167.242.23) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:01:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZKgwg2UXjyP7004kob9n9DjwZurqxMaMHpTXEWCgt5AlyXp2dBf3CUuzd5vM+MMA4VNbBUMoPQJhCS3Y1vMMlQqNPoAvrCE3/cO+yoqa2H7ZNj3qGviE9vEgduw0fUaL5pFasRlEbOdaJ6/xyCs1tsJvVZiOfnfXqFefs5LjZzaUYUkT5ImSxUOLE+V0Gr5kyVmQOTz0lKyy6Wuo7P7IbjvP9KH5pqegzs0Z6WFhCgR6OU+xYzj04fC1pq2AMoq2PDEg/XTMGq+fKIYh9UcK5ZzvV07TBlQPGog2v8jAvDNn45DdLcj3qV/RvBjJaISCushmvoi6vxJqRLokENyWKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7tNV8kXFyTRqVSIz4uHIGUNPd/2Ex7IzC63Bmo0Li0A=;
 b=n9Y1pJmWu01jeFWKC3ZmJaAYbaKqI6+prYUgSK/tqVWV/8476DHHGE6MuaoDfba6Q33b3ykiUHD5du1Pum/ypSy0Nwrub+SbWNMTDG1qNdRsrtPPs8ywx4fTz9/+jCZUMeCPkle5bteaHLcZpXHhgTZRN2zI02zuc3hg2O3pc7lJMeyKcsm6bBHD97+jEH7Di+y6QqtPcosG/gz8CuQiGzTRoXyxMlyjJLjSlf3MqfRiMjZ86IdYnKb71tWHV4ZLRyrDFHg/w0DjiteKq6WC+Ick0jVfBcitcugRmP6b8CX2b3k6UT7dk7jzdkGpfuXlVd2kw0vf11VMTNFCOdcz0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7tNV8kXFyTRqVSIz4uHIGUNPd/2Ex7IzC63Bmo0Li0A=;
 b=HHEV5L35wkmtp3QLsf2bl87DLqea7gX1CxRsD+Vrh7sZtvrSW5gF3GpbpdKP/vg6vPQGH+uKbd4s8FO01ikKfAXgT8ztrSeTnAJTdcAGSq+owCreeKL4Ehc8kuLPSQ24MfzsdGbDpxo6uhrLuUMgPO5FSDZCiLzWMkv6sCqSGM8=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DB4PR08MB9333.eurprd08.prod.outlook.com (2603:10a6:10:3f6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Fri, 9 Jan
 2026 17:00:43 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:00:43 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, Suzuki
 Poulose <Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 36/36] KVM: arm64: gic-v5: Communicate
 userspace-drivable PPIs via a UAPI
Thread-Topic: [PATCH v2 36/36] KVM: arm64: gic-v5: Communicate
 userspace-drivable PPIs via a UAPI
Thread-Index: AQHccP+GtSwTW7EH5EC9df/dn1cNgrVHCacAgAMnVIA=
Date: Fri, 9 Jan 2026 17:00:43 +0000
Message-ID: <db4936327522c99b6b6673a00c3406f937b5f410.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	 <20251219155222.1383109-37-sascha.bischoff@arm.com>
	 <20260107165110.0000638d@huawei.com>
In-Reply-To: <20260107165110.0000638d@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|DB4PR08MB9333:EE_|DU2PEPF00028D0F:EE_|VI0PR08MB11480:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a88083b-597b-4966-8477-08de4fa0c722
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?TEdFTnNkSE5KZmtQV2dNYUlETkVIU0F2QXBiUG1ENXVRM3loc09Va043SFdD?=
 =?utf-8?B?eWdQY20xTTJVT01OVkRkSFI0ZmVzWEJPNWZmUDVDRG5RSk16cWNCN2pPMmNT?=
 =?utf-8?B?NitQaWZaUGVCMXlxQUVNamtiY241YUxMdExLcWxQdnFqVFlpOGgzWXNwMlRu?=
 =?utf-8?B?enppTmFLZmlIcEdLS2dvTkR3cVZheklzWHROL2tsY2NjbC9BYWFJekQ4Tmsr?=
 =?utf-8?B?Rnl0dnA0QnFqSGpzak5vOUhNdlBLQ2MrNWtIenZSM1ZwaERLeXIyUkFOc0tv?=
 =?utf-8?B?THgrUzZ3ZVBRUzVnc2FvYjRON096SHJqSWVFN2IzUWpGT09ScmdTN1pGRnhr?=
 =?utf-8?B?cEdEVGRmeTBUSUNWKytpcW93YktSUU1xdTJrYi96QzdRbnM3c2hCMXFIQXRR?=
 =?utf-8?B?YWJzazA1VG9zeFBITzZqcWNGcmR1c0k5aStEVFVRcGlkZWVWaENoUEx5UkVj?=
 =?utf-8?B?OTJMUjRBZlh1bVhEcitSVEo0VVU3TWtRbTArWW9INkFMc0RodUI1dWthaTRw?=
 =?utf-8?B?L2x4Vm42VW1pZVRIL3hLVzlyaTZISTB2Uzg2RFBWa1ExWTRZWmNNQm1ZVkUy?=
 =?utf-8?B?ZHhyei8zc2YzVEo3NE4xRDIrQ1FmaWNFeVhMUW0wcHpLTE12MER4Mjd2dDBp?=
 =?utf-8?B?OWdUZDBMTDJHbnlrNFh2SzU4MmsxRExBdFRmdldvZzIrTDRDSzlXMWlIKy9G?=
 =?utf-8?B?a0p3eWpWeDNxWnFoTG53bGxhQ1FLcEtwZjcyelQvak54UW5aNWMzK0dIZUo1?=
 =?utf-8?B?eEtLNFR0TjRhcGlsaWtVa2x1V1Z1S0JPNC91N0tqUGJKbDhLSUV6QzF1ekt0?=
 =?utf-8?B?cU9PN29nclNmU2pjUGxtSkZaWmlMVWUrMk5wQUtpRDNTbTRiZkhtT3hvcVp1?=
 =?utf-8?B?bk1SZjNSQTlDcUlmU25ub0IzZ2YxMzVjODRyWDgySjV1aDlzNXNaT0J3Wjli?=
 =?utf-8?B?a2RaQWRWMnE5bDRBVEM5Sm55aGpMSGEzUC9aVEJ2YUlSL1FEN0d0K1FENG9O?=
 =?utf-8?B?UWRLOXZkbDN3OTFmVmduU1JJb1NOa2l6VExVMWdNRzk5YWR3bXZaRWZpRGM1?=
 =?utf-8?B?V25iYTF0YkE2UnRCQndUTHNRbVRxSDdERmdnYXZRaklvcTlDWXZvTjI0V0lC?=
 =?utf-8?B?bWpocjFVVk5xdk9weFJIcUZaMU9ySkVhVTJoWE9ZSmQvYmdYcFRTZnhiSW5H?=
 =?utf-8?B?NUZXd0dqd2N5VnZQc2QyTmtxcEIwOWpiV2l0UUJSYWttbDc1ajZOUE1QdnZo?=
 =?utf-8?B?Z2xRK2ZDZWJFSmJ3T2MvS3dmcnd4NlRFY1FiNEwreUhHamo1YWJPa2c5cCs1?=
 =?utf-8?B?ZlBHbzBIOU5ISDB5a2xFTWd1WGdzRWtNd05ETnFkZkcwMnNReU9kWVVuS3VL?=
 =?utf-8?B?WkZNUE0rakpURWd1TU9xdThubEN3MjU4bUNXSDBwS2xPTWtma09FcW5pS1lP?=
 =?utf-8?B?QkIrY2dBWXZEd2JBSzl0bzJtdVllc2lyZXhEUkFBTE1QSGN4azFyOGlEdUZJ?=
 =?utf-8?B?bDJXeU4zRTQ1S0lERTZTekVBelNpaU1ia0JpSzlHS2pGRnZ1anVpNk8yVitX?=
 =?utf-8?B?NDFSRy96SW5JKytmYXhUUHBicm5tazNLTDZnOFEySlI0RzJWVFNCczBhVTQy?=
 =?utf-8?B?SUVCK3QrWEd2ZnZycVl0L3VOM3laNkhmblplMENCSzYrS3Jpb3JRc3h0LzVj?=
 =?utf-8?B?bmwxenN1TU9zZmJMOVNVaHN2REE0UTNxWGZPa211ckFCWEJ4enBoSnV6Q0E4?=
 =?utf-8?B?eDZtQnVWbVZOcEVUYk5WSEl3YU8zajU0ZjgwdDBZOXc1RDk4bG5rNk1zaURG?=
 =?utf-8?B?YjNTUEVZTUd5SG16SXdsWHZnN2tsVTJYUVRRQzRmSFcvb2hwWGxSc1BZQnIw?=
 =?utf-8?B?Q0RlTHZTd0dNSFc4ZU9qTVlWbjVDVEpzc0puUUtNU3B5OWJXbHQrS1RkN2Nh?=
 =?utf-8?B?c2FhTURZOEQrZndZdDdLdUtRL0RpMkRYL2ppQUJCQUUrQjIvQWd1VEtYaWky?=
 =?utf-8?B?alNKcHNDYS8xcGZSc0NKT2Erd1hoL2VVOFhuell4OWFRSlNGa3BhL3pLVkta?=
 =?utf-8?Q?jBkI4X?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <586FE057786B464A8FFB9DB8036EC7BD@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB9333
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0F.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	377908a7-ae84-4504-0864-08de4fa0a069
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|14060799003|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cE1EajBISUJGbWcwNG5KeVFXY2ZqejQvTXR5VER4MDFtL0k4MUdKL0syQlVv?=
 =?utf-8?B?bVBpNS9mZXJPWlA5ZUtyZms4U2wzeGdMellZd0lQQzByNDhyUE50ckNBOHo4?=
 =?utf-8?B?cGNiRk9wNVdhM3ZBa3FJZGsyNENWMWtLNXVPWW4rUGRlN3pNcnlCWDVnRVJY?=
 =?utf-8?B?OTc2NTZKQVBlWHdHVEdhbGoxZ3VLa3k2Kzg5bjVTZCtzMXNwcUZTSUUzdWlx?=
 =?utf-8?B?MHZrTTlyeSs0K2FsbmUwY2hJMHdFbm9lUGFJUysrTTNDSE0xeE1XUnFlRElW?=
 =?utf-8?B?d2F2RUl2QmdBNmFEQkRtUmVWREFkWTU5YnBRWVFoNlhjUTJSSVozMERsWWZN?=
 =?utf-8?B?eXNTYlk2TUxwYXZkVnhSS2dlNlJnMFRWeG1wNDZiakpTK3pRbW1DcHV4SkNV?=
 =?utf-8?B?blk3aXp6K1RDWW44aEpTaUZwbXV2azFOU2JyV2FPNXROZEtSMHo1c3M5aEFt?=
 =?utf-8?B?V0J6SDg1Zis5eHdqWW1POXpKaXZaT1N2dU5UWkwvd2g2dk9Xdk5MNjUwaXdr?=
 =?utf-8?B?b3lTYzZYakRQZXYxTmN2MUQ2bUJETllGcU1sMFAyOE9pNVl0dEdIZEFFZFlD?=
 =?utf-8?B?NHBnT3RrbFJob1dVREx5Y1NoQllzdGVjVStnZk5TSDdvbE9hZ0dlUWdvRGpt?=
 =?utf-8?B?VnZVSlZXQjlFQlhuRGR4SDhBQWFwOEJWSXdjeWg4d25uVS9xeE8zeHJsTGFN?=
 =?utf-8?B?Z0Z2MjBIUVBzbUdDelphazZSVG9KNlZyeFFYUEUzNTFoYzNyd0NjWkVLcXdZ?=
 =?utf-8?B?clFXempRR0EvNHhNTC8xekE0QzZiMHllcmZXaFBqM3RGd24yRmc2TFNrNm9h?=
 =?utf-8?B?UFZ0S3FscUFkbHdCeUNTWnZiQmxGSy8vT3V3V0d4d2ZQWTRFSGRib2cvdGt0?=
 =?utf-8?B?NkpBV2lqTm94Z3FKL1Y4YzRPZStGZjhwKzBudU9TR1ozYk0vZ2VMdnlyVkxx?=
 =?utf-8?B?blVPSkxZNjdHdDJKb25kTW5iUUYxdTZzS2QvbGNJdjBSbHh1RXVETmg4ZFpC?=
 =?utf-8?B?WEVtRjZ4dmJYZThBamZ0aWNzSWN1dnhMOHpQZ2R1MUttZnVpaGRXNXJ4VVRY?=
 =?utf-8?B?eGFCZlU5QjYwK0FxTGU2elBaa0pzclY3UG9sR1hjdTI5OTduQ014V094VXIx?=
 =?utf-8?B?Y2RIUXdieEFFdktmbXJpYnZ0L2xiVkZHdFNxQlFqVXZtZkVJYmk5a1Y3d2xx?=
 =?utf-8?B?OWJ3RGVCM3loYmVTSzRlQ1NUcWpYVDI4WHlkcjZwQ1FZQnFOa09Rc0l6cm9G?=
 =?utf-8?B?L2hGWTdSODlOQmJMZStiTWRobmcrZHMvWkZGeWlLUU9ERkZoYW5EZlE1WVNU?=
 =?utf-8?B?TVkzb3dpbXkrR2M2eWwxNnpQWCs2NlFxM2FSSmttSVJob3UxNHhTWkxqZE9S?=
 =?utf-8?B?K3VtZ3B6VzB2bndjNUhzNk03bFNFZGcyVFpDY2ZLcDMvdEVqdHdiMk5EdmZH?=
 =?utf-8?B?bHFxWTgvdUcwUlFWQ3BzZUl1RkJIbGFlcWdoOVZNT3IzWkpSZ3Z2RW9XSmpU?=
 =?utf-8?B?eXM4eEs4V3YwOGJwdTZqRDFoZHFhZEc4M0ovL2xhdjJkS1FJbk4yWlhVZVoy?=
 =?utf-8?B?K001RFV3ejZuU25zaXFUSXpTTUd0UmxXSHI1R3NSQThyMkRRNmNoL3Z4TWlu?=
 =?utf-8?B?K0VUZDgxZjJ2VWtXeFB6L3dMaUJjL1c5NEp6dlI1MHVyTE1YdGNoclJMSGE1?=
 =?utf-8?B?UGVmcjcxZkhIQlNzWUwzS2g2NnZ2bzFid0lNeXJxcncybjUzaS9QUDJWeXpr?=
 =?utf-8?B?RURBd2JkSVl2dkZNY00vOVFRcjIxYlVELzU0RE9qZHNwZjBEbDNYM2orUEVi?=
 =?utf-8?B?T3NBUTFkQ2dlbDNLYkdWbHIvZTErUDBzaVpKK2NKSTl6ZzI4WkFJYncvdzQ1?=
 =?utf-8?B?VXRtZUMrcnZWS250UndmL1NySjU2dlNPNG9rL1pDeGV0ODBCQ05nWko1NHh1?=
 =?utf-8?B?Q1Vtc29KWS9WZitnY1hiYUZ3a1B3RHRhSHBLTVZQY0dadW5hb21ERUIzUEh5?=
 =?utf-8?B?YkZFaS9PNXhLUzVkNEZvVm1ud3FibkRaQ2xSS0pxZk84clBLTzlGbndFajRP?=
 =?utf-8?B?bThxL1dSQ095Y2E2Z2h4alhjQzdSeU10dVFMMm1jUUFiWjU4ZWVqRlgyVVZW?=
 =?utf-8?Q?lU5c=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(14060799003)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:01:48.6356
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a88083b-597b-4966-8477-08de4fa0c722
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0F.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11480

T24gV2VkLCAyMDI2LTAxLTA3IGF0IDE2OjUxICswMDAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBGcmksIDE5IERlYyAyMDI1IDE1OjUyOjQ4ICswMDAwDQo+IFNhc2NoYSBCaXNjaG9m
ZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiANCj4gPiBHSUN2NSBzeXN0ZW1z
IHdpbGwgbGlrZWx5IG5vdCBzdXBwb3J0IHRoZSBmdWxsIHNldCBvZiBQUElzLiBUaGUNCj4gPiBw
cmVzZW5jZSBvZiBhbnkgdmlydHVhbCBQUEkgaXMgdGllZCB0byB0aGUgcHJlc2VuY2Ugb2YgdGhl
IHBoeXNpY2FsDQo+ID4gUFBJLiBUaGVyZWZvcmUsIHRoZSBhdmFpbGFibGUgUFBJcyB3aWxsIGJl
IGxpbWl0ZWQgYnkgdGhlIHBoeXNpY2FsDQo+ID4gaG9zdC4gVXNlcnNwYWNlIGNhbm5vdCBkcml2
ZSBhbnkgUFBJcyB0aGF0IGFyZSBub3QgaW1wbGVtZW50ZWQuDQo+ID4gDQo+ID4gTW9yZW92ZXIs
IGl0IGlzIG5vdCBkZXNpcmFibGUgdG8gZXhwb3NlIGFsbCBQUElzIHRvIHRoZSBndWVzdCBpbg0K
PiA+IHRoZQ0KPiA+IGZpcnN0IHBsYWNlLCBldmVuIGlmIHRoZXkgYXJlIHN1cHBvcnRlZCBpbiBo
YXJkd2FyZS4gU29tZSBkZXZpY2VzLA0KPiA+IHN1Y2ggYXMgdGhlIGFyY2ggdGltZXIsIGFyZSBp
bXBsZW1lbnRlZCBpbiBLVk0sIGFuZCBoZW5jZSB0aG9zZQ0KPiA+IFBQSXMNCj4gPiBzaG91bGRu
J3QgYmUgZHJpdmVuIGJ5IHVzZXJzcGFjZSwgZWl0aGVyLg0KPiA+IA0KPiA+IFByb3ZpZGVkIGEg
bmV3IFVBUEk6DQo+ID4gwqAgS1ZNX0RFVl9BUk1fVkdJQ19HUlBfQ1RSTCA9PiBLVk1fREVWX0FS
TV9WR0lDX1VTRVJQU1BBQ0VfUFBJcw0KPiA+IA0KPiA+IFRoaXMgYWxsb3dzIHVzZXJzcGFjZSB0
byBxdWVyeSB3aGljaCBQUElzIGl0IGlzIGFibGUgdG8gZHJpdmUgdmlhDQo+ID4gS1ZNX0lSUV9M
SU5FLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhc2NoYSBCaXNjaG9mZiA8c2FzY2hhLmJp
c2Nob2ZmQGFybS5jb20+DQo+IA0KPiBBIGNvdXBsZSBvZiB0cml2aWFsIGNvbW1lbnRzIG9uIHRo
aXMgcGF0Y2guDQo+IA0KPiBPdmVyYWxsLCB0byBtZSBhcyBhIGRlZmluaXRlIG5vbiBleHBlcnQg
aW4ga3ZtIEdJQyBlbXVsYXRpb24gdGhpcw0KPiBzZXJpZXMgbG9va3MgdG8gYmUgaW4gYSBwcmV0
dHkgZ29vZCBzdGF0ZS4NCj4gDQo+IFRoYW5rcywNCj4gDQo+IEpvbmF0aGFuDQoNClRoaXMgc2Vl
bXMgbGlrZSBhcyBnb29kIGEgcGxhY2UgYXMgYW55IHRvIHRoYW5rIHlvdSBmb3IgYWxsIG9mIHRo
ZQ0KcmV2aWV3cy4gVGhleSBoYXZlIGJlZW4gcmVhbGx5IGhlbHBmdWwgaW4gZ2V0dGluZyBpcyBz
ZXJpZXMgdG8gYSBiZXR0ZXINCnN0YXRlLiBUaGFua3MgYSBsb3QgZm9yIHRha2luZyB0aGUgdGlt
ZSENCg0KKCsgc29tZSByZXNwb25zZXMgaW5saW5lKQ0KDQpTYXNjaGENCg0KPiA+IC0tLQ0KPiA+
IMKgLi4uL3ZpcnQva3ZtL2RldmljZXMvYXJtLXZnaWMtdjUucnN0wqDCoMKgwqDCoMKgwqDCoMKg
IHwgMTMgKysrKysrKysrKw0KPiA+IMKgYXJjaC9hcm02NC9pbmNsdWRlL3VhcGkvYXNtL2t2bS5o
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAxICsNCj4gPiDCoGFyY2gvYXJtNjQva3ZtL3Zn
aWMvdmdpYy1rdm0tZGV2aWNlLmPCoMKgwqDCoMKgwqDCoMKgIHwgMjUNCj4gPiArKysrKysrKysr
KysrKysrKysrDQo+ID4gwqBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuY8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCA4ICsrKysrKw0KPiA+IMKgaW5jbHVkZS9rdm0vYXJt
X3ZnaWMuaMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKg
IDUgKysrKw0KPiA+IMKgaW5jbHVkZS9saW51eC9pcnFjaGlwL2FybS1naWMtdjUuaMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgfMKgIDQgKysrDQo+ID4gwqB0b29scy9hcmNoL2FybTY0L2luY2x1ZGUv
dWFwaS9hc20va3ZtLmjCoMKgwqDCoMKgwqAgfMKgIDEgKw0KPiA+IMKgNyBmaWxlcyBjaGFuZ2Vk
LCA1NyBpbnNlcnRpb25zKCspDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24v
dmlydC9rdm0vZGV2aWNlcy9hcm0tdmdpYy12NS5yc3QNCj4gPiBiL0RvY3VtZW50YXRpb24vdmly
dC9rdm0vZGV2aWNlcy9hcm0tdmdpYy12NS5yc3QNCj4gPiBpbmRleCA5OTA0Y2I4ODgyNzdkLi5k
OWYyOTE3YjYwOWM1IDEwMDY0NA0KPiA+IC0tLSBhL0RvY3VtZW50YXRpb24vdmlydC9rdm0vZGV2
aWNlcy9hcm0tdmdpYy12NS5yc3QNCj4gPiArKysgYi9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2Rl
dmljZXMvYXJtLXZnaWMtdjUucnN0DQo+ID4gQEAgLTI1LDYgKzI1LDE5IEBAIEdyb3VwczoNCj4g
PiDCoMKgwqDCoMKgwqAgcmVxdWVzdCB0aGUgaW5pdGlhbGl6YXRpb24gb2YgdGhlIFZHSUMsIG5v
IGFkZGl0aW9uYWwNCj4gPiBwYXJhbWV0ZXIgaW4NCj4gPiDCoMKgwqDCoMKgwqAga3ZtX2Rldmlj
ZV9hdHRyLmFkZHIuIE11c3QgYmUgY2FsbGVkIGFmdGVyIGFsbCBWQ1BVcyBoYXZlDQo+ID4gYmVl
biBjcmVhdGVkLg0KPiA+IMKgDQo+ID4gK8KgwqAgS1ZNX0RFVl9BUk1fVkdJQ19VU0VSUFNQQUNF
X1BQSXMNCj4gPiArwqDCoMKgwqDCoCByZXF1ZXN0IHRoZSBtYXNrIG9mIHVzZXJzcGFjZS1kcml2
YWJsZSBQUElzLiBPbmx5IGEgc3Vic2V0DQo+ID4gb2YgdGhlIFBQSXMgY2FuDQo+ID4gK8KgwqDC
oMKgwqAgYmUgZGlyZWN0bHkgZHJpdmVuIGZyb20gdXNlcnNwYWNlIHdpdGggR0lDdjUsIGFuZCB0
aGUNCj4gPiByZXR1cm5lZCBtYXNrDQo+ID4gK8KgwqDCoMKgwqAgaW5mb3JtcyB1c2Vyc3BhY2Ug
b2Ygd2hpY2ggaXQgaXMgYWxsb3dlZCB0byBkcml2ZSB2aWENCj4gPiBLVk1fSVJRX0xJTkUuDQo+
ID4gKw0KPiA+ICvCoMKgwqDCoMKgIFVzZXJzcGFjZSBtdXN0IGFsbG9jYXRlIGFuZCBwb2ludCB0
byBfX3U2NFsyXSB3aXRoIG9mIGRhdGENCj4gPiBpbg0KPiANCj4gd2l0aCBvZj8NCg0KRml4ZWQg
KCJ3aXRoIiB3YXMgbWVhbnQgdG8gYmUgIndvcnRoIiwgYnV0IEkganVzdCBkcm9wcGVkIHRoYXQg
YW5kIHdlbnQNCndpdGggIm9mIikuDQoNCj4gDQo+ID4gK8KgwqDCoMKgwqAga3ZtX2RldmljZV9h
dHRyLmFkZHIuIFdoZW4gdGhpcyBjYWxsIHJldHVybnMsIHRoZSBwcm92aWRlZA0KPiA+IG1lbW9y
eSB3aWxsIGJlDQo+ID4gK8KgwqDCoMKgwqAgcG9wdWxhdGVkIHdpdGggdGhlIHVzZXJzcGFjZSBQ
UEkgbWFzay4gVGhlIGxvd2VyIF9fdTY0DQo+ID4gY29udGFpbnMgdGhlIG1hc2sNCj4gPiArwqDC
oMKgwqDCoCBmb3IgdGhlIGxvd2VyIDY0IFBQSVMsIHdpdGggdGhlIHJlbWFpbmluZyA2NCBiZWlu
ZyBpbiB0aGUNCj4gPiBzZWNvbmQgX191NjQuDQo+ID4gKw0KPiA+ICvCoMKgwqDCoMKgIFRoaXMg
aXMgYSByZWFkLW9ubHkgYXR0cmlidXRlLCBhbmQgY2Fubm90IGJlIHNldC4gQXR0ZW1wdHMNCj4g
PiB0byBzZXQgaXQgYXJlDQo+ID4gK8KgwqDCoMKgwqAgcmVqZWN0ZWQuDQo+ID4gKw0KPiA+IMKg
wqAgRXJyb3JzOg0KPiA+IMKgDQo+ID4gwqDCoMKgwqAgPT09PT09PcKgDQo+ID4gPT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCj4gDQo+ID4g
ZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1rdm0tZGV2aWNlLmMNCj4gPiBi
L2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1rdm0tZGV2aWNlLmMNCj4gPiBpbmRleCA3ODkwMzE4
MmJiYTA4Li4zNjBjNzhlZDRmMTA0IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3Zn
aWMvdmdpYy1rdm0tZGV2aWNlLmMNCj4gPiArKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMt
a3ZtLWRldmljZS5jDQo+ID4gQEAgLTcxOSw2ICs3MTksMjUgQEAgc3RydWN0IGt2bV9kZXZpY2Vf
b3BzIGt2bV9hcm1fdmdpY192M19vcHMgPSB7DQo+ID4gwqAJLmhhc19hdHRyID0gdmdpY192M19o
YXNfYXR0ciwNCj4gPiDCoH07DQo+ID4gwqANCj4gPiArc3RhdGljIGludCB2Z2ljX3Y1X2dldF91
c2Vyc3BhY2VfcHBpcyhzdHJ1Y3Qga3ZtX2RldmljZSAqZGV2LA0KPiA+ICsJCQkJwqDCoMKgwqDC
oCBzdHJ1Y3Qga3ZtX2RldmljZV9hdHRyDQo+ID4gKmF0dHIpDQo+ID4gK3sNCj4gPiArCXU2NCBf
X3VzZXIgKnVhZGRyID0gKHU2NCBfX3VzZXIgKikobG9uZylhdHRyLT5hZGRyOw0KPiA+ICsJc3Ry
dWN0IGdpY3Y1X3ZtICpnaWN2NV92bSA9ICZkZXYtPmt2bS0+YXJjaC52Z2ljLmdpY3Y1X3ZtOw0K
PiA+ICsJaW50IGksIHJldDsNCj4gPiArDQo+ID4gKwlndWFyZChtdXRleCkoJmRldi0+a3ZtLT5h
cmNoLmNvbmZpZ19sb2NrKTsNCj4gPiArDQo+ID4gKwlmb3IgKGkgPSAwOyBpIDwgMjsgKytpKSB7
DQo+IA0KPiBDYW4gZHJhZyBkZWNsYXJhdGlvbiBvZiBpIGludG8gbG9vcCBpbml0Lg0KDQpEb25l
Lg0KDQo+IEFsc28gSSBqdXN0IG5vdGljZWQgdGhlIHNlcmllcyBpcyByYXRoZXIgcmFuZG9tIHdy
dCB0byBwcmUgb3IgcG9zdA0KPiBpbmNyZW1lbnQNCj4gaW4gY2FzZXMgd2hlcmUgaXQgZG9lc24n
dCBtYXR0ZXIuIEknZCBnbyB3aXRoIHBvc3QgaW5jcmVtZW50IGZvciBmb3INCj4gbG9vcHMuDQo+
IEkgdG9vayBhIHF1aWNrIGxvb2sgYXQgYSByYW5kb20gZmlsZSBpbiB0aGlzIGRpcmVjdG9yeSBh
bmQgdGhhdCdzDQo+IHdoYXQgaXMgdXNlZCB0aGVyZS4NCg0KSSd2ZSBnb25lIHRocm91Z2ggYW5k
IG1hZGUgdGhlbSBjb25zaXN0ZW50Lg0KDQo+IA0KPiANCj4gPiArCQlyZXQgPSBwdXRfdXNlcihn
aWN2NV92bS0+dXNlcnNwYWNlX3BwaXNbaV0sDQo+ID4gdWFkZHIpOw0KPiA+ICsJCWlmIChyZXQp
DQo+ID4gKwkJCXJldHVybiByZXQ7DQo+ID4gKwkJdWFkZHIrKzsNCj4gPiArCX0NCj4gPiArDQo+
ID4gKwlyZXR1cm4gMDsNCj4gPiArfQ0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9r
dm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+
ID4gaW5kZXggYmY3Mjk4MmQ2YTJlOC4uMDQzMDA5MjY2ODNiNiAxMDA2NDQNCj4gPiAtLS0gYS9h
cmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3Zn
aWMvdmdpYy12NS5jDQo+ID4gQEAgLTEyMiw2ICsxMjIsMTQgQEAgaW50IHZnaWNfdjVfaW5pdChz
dHJ1Y3Qga3ZtICprdm0pDQo+ID4gwqAJCX0NCj4gPiDCoAl9DQo+ID4gwqANCj4gPiArCS8qDQo+
ID4gKwkgKiBXZSBvbmx5IGFsbG93IHVzZXJzcGFjZSB0byBkcml2ZSB0aGUgU1dfUFBJLCBpZiBp
dCBpcw0KPiA+ICsJICogaW1wbGVtZW50ZWQuDQo+ID4gKwkgKi8NCj4gDQo+IAkvKiBXZSBvbmx5
IGFsbG93IHVzZXJzcGFjZSB0byBkcml2ZSB0aGUgU1dfUFBJLCBpZiBpdCBpcw0KPiBpbXBsZW1l
bnRlZC4gKi8NCj4gDQo+IElzIHVuZGVyIDgwIGNoYXJzIChqdXN0KSBzbyBnbyB3aXRoIHRoYXQu
DQoNCkRvbmUuDQoNCj4gDQo+IA0KPiA+ICsJa3ZtLT5hcmNoLnZnaWMuZ2ljdjVfdm0udXNlcnNw
YWNlX3BwaXNbMF0gPSBHSUNWNV9TV19QUEkgJg0KPiA+IEdJQ1Y1X0hXSVJRX0lEOw0KPiA+ICsJ
a3ZtLT5hcmNoLnZnaWMuZ2ljdjVfdm0udXNlcnNwYWNlX3BwaXNbMF0gJj0gcHBpX2NhcHMtDQo+
ID4gPmltcGxfcHBpX21hc2tbMF07DQo+ID4gKwlrdm0tPmFyY2gudmdpYy5naWN2NV92bS51c2Vy
c3BhY2VfcHBpc1sxXSA9IDA7DQo+ID4gKw0KPiA+IMKgCXJldHVybiAwOw0KPiA+IMKgfQ0KPiAN
Cj4gDQoNCg==

