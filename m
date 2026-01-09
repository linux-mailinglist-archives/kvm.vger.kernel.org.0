Return-Path: <kvm+bounces-67584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D9D23D0B6D3
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 17:58:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8B3E1305E281
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 16:57:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 078F13644A5;
	Fri,  9 Jan 2026 16:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="N/NWndM3";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="N/NWndM3"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013020.outbound.protection.outlook.com [52.101.83.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A53E35A939
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 16:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.20
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767977863; cv=fail; b=mfldUT2H4KGf/2E+tblgE8KGrbFEB/Tg+VFWAAJaFuKkgat+foduD5e3JWZKFz46VxrFd5dJzvkqvy3PIvY0ZXnjik6AJBqfgOlnv+XkBclzxF6xKIMRtZGxTIFpVp6CDZoE4Fp6VyUcH3P7D3HDbRHZ46j4qPLeEn1OWHCqoiM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767977863; c=relaxed/simple;
	bh=ixWdh8uOuKqs6jLaN+KOiSJUw/Un5M6n5K8+ot82bfc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PMpuK8h+8x8WiBYuFjEfH4roXMtujTVz4V55M/1BVOmDjfPPeI0lYeu4Kdd7NxXw1HK+dU7Ad4b76ekRRy9HIlQ2DeSdpW9ipAQq0Hnl9BC3F58WcsmVS+x1s75+d3vVF/zxQghs0Bz86qBBRQNLyLI/wu6WLZhqJ2oAKRBnTi0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=N/NWndM3; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=N/NWndM3; arc=fail smtp.client-ip=52.101.83.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=pLUq494yKIDYkW4Y39xru2QIFwtdco45BpSQSfRBK4sb7dgpzbR3D6LRHJ86BlQibMtRX13f1hpM+3/nZlaRqv8pPDSoPazYcPBIWyjZgDurHtk6K6sfSpgigHQnEtKoZ9xSqlX5lAt44k9gcWBEEZ1HYqIkPxc8oWbEf94cAyY0WJ4Jo27si5USL8ugxElnPCO/v33650WVFIIJOrlectjmZM+FPEZXZGSfR1kM7e2JrmiCYY/uS24DmwloJtsBGCRkkINXumGAKGX2D5Pr8O3kHM5SNoepaYcIL7JBGgqSVobsAGwbJIqJ4aHXQS1JgP52R3HMCW4C7x3zJtLaFQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ixWdh8uOuKqs6jLaN+KOiSJUw/Un5M6n5K8+ot82bfc=;
 b=L9RPgnugc5iazP2CMC7BsYgeDS6N7tkYVpH9p4MvxKAT5gvpcqlcjCNCVeVRFk3LF+5rkPVMsNL6BRCD8w37n5PevvZ1Np6uPWC/ia/IskaeQVUffrcFyuTEnj7iTD0jrTLhS4jsxq/rZVBQIrk/qCINwi8X5T0NMgEzq+JRsY94nzLP0fKrqU/dM5voTly6+rCp50tj5wc/+7xkyfRc5+cDOesY+rzlYIC4X/74EEANHMq9uXcm1HgGIxnHa2cM+gGAaaDdoFefjYd5t+tj9ukurXzNeHzUOhKXvRVl0GvG08Q1oLU9GCxGtKx/l2D36O2/VJsTcfw4AUxJSLg7XA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ixWdh8uOuKqs6jLaN+KOiSJUw/Un5M6n5K8+ot82bfc=;
 b=N/NWndM3X95h+KolIcjktFxreIa+MP/p33tUxbmwiGkyoc45yoI4LcRxbp+0ELYFV81On+MrHj4UflqMEHq44kQRS75NHonlRDX2NHgGXXCaUgURIb28vHLVrmPt/RrvqlJRQUjTSucciPx+VjhrWNIokDFNVO9fo+vjpT3pX6c=
Received: from AS4P190CA0022.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:5d0::14)
 by DU0PR08MB9797.eurprd08.prod.outlook.com (2603:10a6:10:446::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 16:57:35 +0000
Received: from AM4PEPF00027A68.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d0:cafe::c4) by AS4P190CA0022.outlook.office365.com
 (2603:10a6:20b:5d0::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.5 via Frontend Transport; Fri, 9
 Jan 2026 16:57:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A68.mail.protection.outlook.com (10.167.16.85) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 16:57:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uyMF5R/R60JJA9JTG1g+ia3U63u98pDIiPVROKQb+6xwrvYeYYjOXXgkb7836aFbJfuslToMaLIeS3WLDVoMzk6VW5rnVVTwVu1al0CCMTqtCEv7gGo8a/lxV1XdSS2wLFC+EMj1CeqYg0Nk7MYM4g+rysMHHR/rjmkansjhgMjE36GhHzki1Iputv46vvwTZVHW6sDJDjqh3Djr2TLHJIXbfVNisI6DYMZoJZ+g+BblmCaIIBO5nTvnZEyiiVs/+S6Fvm7GomstJ8zuvVZ8/DH6yjTQEC0Gy/3ngducqudCgyhOpeZwtykSCRNIpuHSToUBC+g56Iv1w1eCvwLF0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ixWdh8uOuKqs6jLaN+KOiSJUw/Un5M6n5K8+ot82bfc=;
 b=F4O+7w2u0jqRoKbTLgCSCHIbEqoF9bGj95DPz2SClmKwXR8PPPBtEJqwOsun0wdHgDIyVH9V1qz42WDR4IrbI7zuBG3DaZFgCSvjqbvaiG01fh/uwyFFX6sBhaS7TSIJSTInDrUuSQW4tzthsQKe64qsiq/05s1glkh6R5zJh/PaUtzn6qkoalaDKZPypqiFzi7dMl8cATQ79ZJO7ROZGOZdhY4Jj4Pqh2GgIM+N1Y1cnCd4rEQwsJxhfx+hkkmpP0zsk7+KGvLfmUEdDSEmOEHlxv5jzXd66lQRbqWu/Te4CJ4azMkvjqezXqzIA1imPVKUF6qDm6qMfC+KPjk6KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ixWdh8uOuKqs6jLaN+KOiSJUw/Un5M6n5K8+ot82bfc=;
 b=N/NWndM3X95h+KolIcjktFxreIa+MP/p33tUxbmwiGkyoc45yoI4LcRxbp+0ELYFV81On+MrHj4UflqMEHq44kQRS75NHonlRDX2NHgGXXCaUgURIb28vHLVrmPt/RrvqlJRQUjTSucciPx+VjhrWNIokDFNVO9fo+vjpT3pX6c=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DB4PR08MB9333.eurprd08.prod.outlook.com (2603:10a6:10:3f6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Fri, 9 Jan
 2026 16:56:31 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 16:56:31 +0000
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
Subject: Re: [PATCH v2 26/36] KVM: arm64: gic-v5: Bump arch timer for GICv5
Thread-Topic: [PATCH v2 26/36] KVM: arm64: gic-v5: Bump arch timer for GICv5
Thread-Index: AQHccP+ErHYu2ILPq0yuremdrhuns7VG/ckAgAMyBQA=
Date: Fri, 9 Jan 2026 16:56:31 +0000
Message-ID: <61e90c9f9c33204ff2a7917365ceef62370c0950.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	 <20251219155222.1383109-27-sascha.bischoff@arm.com>
	 <20260107160842.00003c8e@huawei.com>
In-Reply-To: <20260107160842.00003c8e@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|DB4PR08MB9333:EE_|AM4PEPF00027A68:EE_|DU0PR08MB9797:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c66e9cb-fd19-4573-ab5e-08de4fa03027
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?akhzUXluSnFWd0pGbnJIK1AyaEtISlg0TVZHSGZRbGNiK1QzeFV4RGR6bUQ2?=
 =?utf-8?B?eXhXbnEzV2k5ZDFtNzVEY0NKY3JYTVFnS0FleEtzTnRiTnN5a3ZMQ203cmlq?=
 =?utf-8?B?dXRjUFZDYzhWSkd3MDBOVWl3MStLSVFsdlJFdWZCVEYxRHVWRlVzclhxaFVT?=
 =?utf-8?B?d1BKazVKdU12NFZrckE3UDV3bnZ5LytTeHNXZ2JIU21tWE9YeFdkNHg0M0Uy?=
 =?utf-8?B?cXFGN1k2ZTlpVWdQWVVnVjBiMGl5N2pTVU85N2RQalBFWmthdWlwT3BRRWJa?=
 =?utf-8?B?ZmV3d29mNGorcFlFVGpjbkpDRjdUZmdHNEtIZ2tnM3pyTy9LZUs1bmpmeWFH?=
 =?utf-8?B?RlBLNWtxazdMbVhYa3FjdHhRTVp0dEpFbUcwNXNoRisxOHZ1a2E1SUlmQysr?=
 =?utf-8?B?L0p2QS9kOWFVYnh3dnZENE9tbFVIK0dHZStKVTNjM1ZuMlMxaGRMWklEK0c3?=
 =?utf-8?B?Ulg5SkNhVkkwN0UzV1I5MWpGL3FMaXFGb0NSTit0WFhMN2tjRkVrVnY5K2lK?=
 =?utf-8?B?cHdPMVdtK2d6SEpRdll4VDJZd3dvdGswbzZSa0NzZjVoN3hBU0Q1QWNiK3ls?=
 =?utf-8?B?aTRrU1dnMlcrSkxWVjBIMGthVTNqNUJ6eEdHY3BVdDJhcHQwQVgwR1NjTGhE?=
 =?utf-8?B?d3dxTGtWSlVYbWpqSHpNdm9LYWkzdWhUZkErZFRiejE3dWNHbDBXVFZNSkox?=
 =?utf-8?B?eUd3YU9wRCs2U0RNNXVuOXRHS01TU0ErWjEwUk9uVUR2THFIMUcvRXpIb21L?=
 =?utf-8?B?cXRxdWZza0NZMHl3endiZmdTQTljU2w5dk82c1FKbklMVGJwOHd3VlJodSto?=
 =?utf-8?B?WVBJaG9FeUlRT2k2aDFwNTN4TDc4SHNFcVN5Uk1xM1VHalZyQXRKUXBzWlhk?=
 =?utf-8?B?NFBJRXU5alFiY1BMQ3VKdFFtZFNON2dnVi9IM0lVWUJ0aUNXditaNlNURmRF?=
 =?utf-8?B?V21obGhwdjUvTU9icHN6UklHRkgza0JTM2VITW9tSGIzRlZHaytLMy9ESVBa?=
 =?utf-8?B?SjdNaGJoVVoxdlMvbkg1dWFiVitlQ3RJVVhBTWFncElIbmxzeTN1ZW52VWc0?=
 =?utf-8?B?RlA0bmpTM0xKTjRqTFVwZzA4bG8rSWRkNS9tdlMyM1dsaTluVG5aUVFxUWJV?=
 =?utf-8?B?TU8zZGNGaURwdG50VUx4Z2RCTEFwRGlJQzRkZDBDazV2NGk4UnJvMURzRTNm?=
 =?utf-8?B?SXpWdW9Xdjd1SU9yZTgrNlNHZVJQWWh5NWQvVW1UVFR2aUtLcXJ3bFBEbVBn?=
 =?utf-8?B?eUUzblZodm02cWdubFJpT0Uya3VoNEpJSGErYUFMNERJcVp6NU4veDh5MC9M?=
 =?utf-8?B?SWMzTVo2MHp5c3F0MHdQZ2M1T1B1Q0huekxESmw5WVp0YUM2eGV2bXRROWNQ?=
 =?utf-8?B?SVVHTW1Ya24zQUphZVpNME4wL0pPMVAwUm1RMUtEUVM1dEZ3eWFoK2lDQ3Vk?=
 =?utf-8?B?ZVQ5NnpWOW5OSWFFaTVFY0dUOWJ1R21DRm5HeG03WVF0aDZ1WkgzZFNFdkoy?=
 =?utf-8?B?TzFOVkRtaiswellKd3A0THlTUWFoU0ZIcG03S1h5UjV1SkNQQ2lVMWtoMkNU?=
 =?utf-8?B?TjRITzBycm9wcHphcVp3aDJiOUVVTVR0R01IMHZDTWRLeHNJbWROdmlYQ2xp?=
 =?utf-8?B?TERTZHBzL1lJdnZzRGsvQkk0WE1PREk3ZXExcktlMGQwajBkOXppQlUwbStn?=
 =?utf-8?B?ZzBtK244UDd3QTFveUhET2Izd253dUFPZEZZZUlxTzM2Qlp1REh3WUZMK2JG?=
 =?utf-8?B?YXU2RlNwdDJTWENMK2dWeEJPUGRNTmJrNVZrd01Xc1dFNFhkeUJCUmhvNWlF?=
 =?utf-8?B?LzA5ZkVDaDZ4RzdQMjJLQlRxSFpEcmdKV1N0MXFqeHQ1eFdrZzhpQ1V3SHUw?=
 =?utf-8?B?ZGFsZno1aDFuWmxJbjA0UlphenN6c2d4aTV0eGcyRloveWlEMTVYdHdYbjhU?=
 =?utf-8?B?MzBGOHNEdU9pZ0xiNysyWEhSZHZlVWFmZVAxZUpGUi9uUlpibmR6b3MvNWJS?=
 =?utf-8?B?MCtSV0pzOER4NHo4VDBRRWJnbTVBOVlWWjh4cHl6c00wWGlIYVovRUMxSTQx?=
 =?utf-8?Q?cIpxJG?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <5AD0475703C92A46A9E97C1FD9C19C0F@eurprd08.prod.outlook.com>
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
 AM4PEPF00027A68.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e909f203-2427-4148-c66f-08de4fa009d6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|14060799003|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aFcwdGdLRzZ4L3VlUUEwVmtSOTU3a1UrVTRXMkdFVGtwYmFtT2lOVzJXcTN5?=
 =?utf-8?B?VS9KZE8xNUJES1dId0dKOGN1ZVRTa2w5OU9GUTZCQXpWYWJCVnYwbXVURHA4?=
 =?utf-8?B?a3VEbDRsM2lTOGluOFUxVlFyS09oeW9GSkVhZCtTUmIwRis0WEFiNW85T0E2?=
 =?utf-8?B?Vjc0M1R4RnNzeFk5dUZwWU5HV2dyN2JWN1RTQ2I2Ni9YdXhJV3BJUDJpdlZJ?=
 =?utf-8?B?dlp1RUUzQnM2dzJKc0E4eFR0TmRjMGZYU2xwVUg4VHpPd1VuQ1NYK3FrSS9E?=
 =?utf-8?B?eHZBdEoxeHhxUG82RVVReEFUQTZzd09KSVNIY0c5a3NCTUJoS2dKWFV6ZkZJ?=
 =?utf-8?B?emNTNERvK2JPS0k4TUt5OStZWGJPYkFZUStpbGFjRWgvN3lRUkFFUkpMKzlL?=
 =?utf-8?B?ZGcxVmszcExjd0RicWNYcDFMZ0d3NEIvdTdJUmF2b2JHanBZVUxQdXV2dFpT?=
 =?utf-8?B?SHR6OEdIR0ZDdUM3RzJwdXNzTFo4dVpEZi9ibGsrTkphTmhTYlo1UHRHeU5E?=
 =?utf-8?B?L0ZxU1RNcjN5LzFMcG8wKzAwTGRwanB5ZWd5THFSTGpIcFhBWG9jZndFRHhu?=
 =?utf-8?B?UFMwTWx4c0p2Z2t2ZW1pbS92emVsNnFtWHduZm1OM2JERW8wU3lUUTdpZTR0?=
 =?utf-8?B?Um1KOG5rTTkwRXlXaElQSUw3SkpaSnhnSGNTRWtaYTdOc2NRRnc1eXdVOFZP?=
 =?utf-8?B?bHVsZEtoQXZXNENESi81cmxoQkpIajJEbFp3STVQaU9vSEpSQUM2ZmRBN0JE?=
 =?utf-8?B?V3U2WWdNUlpvTFU3a1M0VDBHdlUzMXU1NzVRN3NuQzZ4c2RCRDZjUnQzQWFM?=
 =?utf-8?B?UnkwZmt4d2dQOG9YTzE5dWlXaEl1ZFk1ZmFBdjdaQmpHZVBSdDUzenJVRnhi?=
 =?utf-8?B?VU16U3JLNjBqTllmalpHWFpoR2pZT3JJb1JYTEdlZWdnUE9FWHlxNklPOFZk?=
 =?utf-8?B?WkIxN2p6R0RwaXd2SVRQY0RHOHIrOFJxMTBxMUZYNFNmdGkzbk91dkpyYXRU?=
 =?utf-8?B?K3ltK3NFK3dqczBHS1NDa3pTR3hnMitwMXBnOE10cU9td0trS0FDa2hycnFi?=
 =?utf-8?B?Z0tSZFhJNTBTQkVDRFVLRWhkbm5xV1gzdDNVa2tRZld5WDAxTDkxRG9VcE5l?=
 =?utf-8?B?QVFvRytlMUx3V01mbWRmZmE4Z3NVazJoM1FIOTJTRzJjeEo0U0VGMGlmdFZN?=
 =?utf-8?B?VmpIZjkzRjZkVHRJSitFSkRES1JWckxjQVpRbm93alVuMlZmT0h4cG5Tbkg3?=
 =?utf-8?B?UjN6NFlRYktmUXplcC9vZTM0RWdSRGdPKzdQMVBBOWZZVjNGT0k4TWtRbG8z?=
 =?utf-8?B?Um1qZjBIT0tNcDBJaWtKbkg2bzdGK3RGS1Z3T0UzUDFBTzZwNlFaRzROcjN3?=
 =?utf-8?B?bU9yS0w2NE15UGgvdG1TTERzNnFwQ0J3Tk96R1o5MEN0dUV3WXF0ME80UExI?=
 =?utf-8?B?MGZGTGNBb21EdFBQVHRxYUU4cmZpdDhPdndXRlM1Q2Rvc3FMaG40K1lJK2lI?=
 =?utf-8?B?MTFnOE1LNm9xUEkzTXMyYld1Y1ArYXVacmQyaVhzOWdIeWhPSE5rdUc5Z3VR?=
 =?utf-8?B?dmw3RnZCVUVQSkx1bmJXTjdUVUkrYnF1MHFaS2s5UmdUNDNwQk5Vd0ZoQjlO?=
 =?utf-8?B?RGVGZ0Z2Z21NamNFU0lxdWk3TGFheTlNV29IaEFScDBkMFZ2bVdlSXdVcG9Y?=
 =?utf-8?B?d2gvNWY2TW1CRytkUnJJRGNsYUhMalFXLy80aWpxRHFSNThkek1PTGpXMXBw?=
 =?utf-8?B?VXFVQTJYOUpBMk9kSGVzRzhFak5MS1U0Z05FNC9iU2tiN0poT1lJcVBzbnRU?=
 =?utf-8?B?dEhBWHhzQ2p3ZEpaR0orZmMrS1MreHExa1BJNG5TSDE1ZEZHVkp4VUxySEJN?=
 =?utf-8?B?SlFpWU9uUlp4eStUdXkvZmZJUksyc2lBK28xNG9YMUh6RnR6SHp2WHZCeEI4?=
 =?utf-8?B?TEVucjIxL043SGJTNFA5WWs0R3RRRVA1VElpT1dVVVJ0emhZbzdDdEJtMDVB?=
 =?utf-8?B?NGlyYytvT1NER0FneVR3d0dKdHp1T25ob1VVTEJJbzBmWWV1Ukl0MmZIU0NP?=
 =?utf-8?B?WU5WTThmQkEvVTBCNUhRVnhKRUs0THZoVXRjd004WnlhOGVxVkRKT09lbEgy?=
 =?utf-8?Q?FzV4=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(14060799003)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 16:57:35.3520
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c66e9cb-fd19-4573-ab5e-08de4fa03027
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A68.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9797

T24gV2VkLCAyMDI2LTAxLTA3IGF0IDE2OjA4ICswMDAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBGcmksIDE5IERlYyAyMDI1IDE1OjUyOjQ1ICswMDAwDQo+IFNhc2NoYSBCaXNjaG9m
ZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiANCj4gPiBOb3cgdGhhdCBHSUN2
NSBoYXMgYXJyaXZlZCwgdGhlIGFyY2ggdGltZXIgcmVxdWlyZXMgc29tZSBUTEMgdG8NCj4gPiBh
ZGRyZXNzIHNvbWUgb2YgdGhlIGtleSBkaWZmZXJlbmNlcyBpbnRyb2R1Y2VkIHdpdGggR0lDdjUu
DQo+ID4gDQo+ID4gRm9yIFBQSXMgb24gR0lDdjUsIHRoZSBzZXRfcGVuZGluZ19zdGF0ZSBhbmQg
cXVldWVfaXJxX3VubG9jaw0KPiA+IGlycV9vcHMNCj4gPiBhcmUgdXNlZCBhcyBBUCBsaXN0cyBh
cmUgbm90IHJlcXVpcmVkIGF0IGFsbCBmb3IgR0lDdjUuIFRoZSBhcmNoDQo+ID4gdGltZXINCj4g
PiBhbHNvIGludHJvZHVjZXMgYW4gaXJxX29wIC0gZ2V0X2lucHV0X2xldmVsLiBFeHRlbmQgdGhl
DQo+ID4gYXJjaC10aW1lci1wcm92aWRlZCBpcnFfb3BzIHRvIGluY2x1ZGUgdGhlIHR3byBQUEkg
b3BzIGZvciB2Z2ljX3Y1DQo+ID4gZ3Vlc3RzLg0KPiA+IA0KPiA+IFdoZW4gcG9zc2libGUsIERW
SSAoRGlyZWN0IFZpcnR1YWwgSW50ZXJydXB0KSBpcyBzZXQgZm9yIFBQSXMgd2hlbg0KPiA+IHVz
aW5nIGEgdmdpY192NSwgd2hpY2ggZGlyZWN0bHkgaW5qZWN0IHRoZSBwZW5kaW5nIHN0YXRlIGlu
IHRvIHRoZQ0KPiANCj4gaW50byA/DQo+IA0KPiA+IGd1ZXN0LiBUaGlzIG1lYW5zIHRoYXQgdGhl
IGhvc3QgbmV2ZXIgc2VlcyB0aGUgaW50ZXJydXB0IGZvciB0aGUNCj4gPiBndWVzdA0KPiA+IGZv
ciB0aGVzZSBpbnRlcnJ1cHRzLiBUaGlzIGhhcyB0d28gaW1wYWN0cy4NCj4gPiANCj4gPiAqIEZp
cnN0IG9mIGFsbCwgdGhlIGt2bV9jcHVfaGFzX3BlbmRpbmdfdGltZXIgY2hlY2sgaXMgdXBkYXRl
ZCB0bw0KPiA+IMKgIGV4cGxpY2l0bHkgY2hlY2sgaWYgdGhlIHRpbWVycyBhcmUgZXhwZWN0ZWQg
dG8gZmlyZS4NCj4gPiANCj4gPiAqIFNlY29uZGx5LCBmb3IgbWFwcGVkIHRpbWVycyAod2hpY2gg
dXNlIERWSSkgdGhleSBtdXN0IGJlIG1hc2tlZA0KPiA+IG9uDQo+ID4gwqAgdGhlIGhvc3QgcHJp
b3IgdG8gZW50ZXJpbmcgYSBHSUN2NSBndWVzdCwgYW5kIHVubWFza2VkIG9uIHRoZQ0KPiA+IHJl
dHVybg0KPiA+IMKgIHBhdGguIFRoaXMgaXMgaGFuZGxlZCBpbiBzZXRfdGltZXJfaXJxX3BoeXNf
bWFza2VkLg0KPiA+IA0KPiA+IFRoZSBmaW5hbCwgYnV0IHJhdGhlciBpbXBvcnRhbnQsIGNoYW5n
ZSBpcyB0aGF0IHRoZSBhcmNoaXRlY3RlZA0KPiA+IFBQSXMNCj4gPiBmb3IgdGhlIHRpbWVycyBh
cmUgbWFkZSBtYW5kYXRvcnkgZm9yIGEgR0lDdjUgZ3Vlc3QuIEF0dGVtcHRzIHRvDQo+ID4gc2V0
DQo+ID4gdGhlbSB0byBhbnl0aGluZyBlbHNlIGFyZSBhY3RpdmVseSByZWplY3RlZC4gT25jZSBh
IHZnaWNfdjUgaXMNCj4gPiBpbml0aWFsaXNlZCwgdGhlIGFyY2ggdGltZXIgUFBJcyBhcmUgYWxz
byBleHBsaWNpdGx5IHJlaW5pdGlhbGlzZWQNCj4gPiB0bw0KPiA+IGVuc3VyZSB0aGUgY29ycmVj
dCBHSUN2NS1jb21wYXRpYmxlIFBQSXMgYXJlIHVzZWQgLSB0aGlzIGFsc28gYWRkcw0KPiA+IGlu
DQo+ID4gdGhlIEdJQ3Y1IFBQSSB0eXBlIHRvIHRoZSBpbnRpZC4NCj4gPiANCj4gPiBTaWduZWQt
b2ZmLWJ5OiBTYXNjaGEgQmlzY2hvZmYgPHNhc2NoYS5iaXNjaG9mZkBhcm0uY29tPg0KPiBWYXJp
b3VzIGNvbW1lbnRzIGlubGluZS4gDQo+IA0KPiBKDQo+ID4gLS0tDQo+ID4gwqBhcmNoL2FybTY0
L2t2bS9hcmNoX3RpbWVyLmPCoMKgwqDCoCB8IDExMCArKysrKysrKysrKysrKysrKysrKysrKysr
Ky0tDQo+ID4gLS0tLQ0KPiA+IMKgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWluaXQuYyB8wqDC
oCA5ICsrKw0KPiA+IMKgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmPCoMKgIHzCoMKgIDgg
Ky0tDQo+ID4gwqBpbmNsdWRlL2t2bS9hcm1fYXJjaF90aW1lci5owqDCoMKgIHzCoMKgIDcgKy0N
Cj4gPiDCoGluY2x1ZGUva3ZtL2FybV92Z2ljLmjCoMKgwqDCoMKgwqDCoMKgwqAgfMKgwqAgNCAr
Kw0KPiA+IMKgNSBmaWxlcyBjaGFuZ2VkLCAxMTUgaW5zZXJ0aW9ucygrKSwgMjMgZGVsZXRpb25z
KC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2FyY2hfdGltZXIuYw0K
PiA+IGIvYXJjaC9hcm02NC9rdm0vYXJjaF90aW1lci5jDQo+ID4gaW5kZXggNmYwMzNmNjY0NDIx
OS4uNzhkNjZhNjdiMzRhYyAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS9hcmNoX3Rp
bWVyLmMNCj4gPiArKysgYi9hcmNoL2FybTY0L2t2bS9hcmNoX3RpbWVyLmMNCj4gDQo+IA0KPiA+
IMKgdm9pZCBrdm1fdGltZXJfc3luY19uZXN0ZWQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+
IEBAIC0xMDM0LDEyICsxMDc5LDE1IEBAIHZvaWQga3ZtX3RpbWVyX3ZjcHVfcmVzZXQoc3RydWN0
IGt2bV92Y3B1DQo+ID4gKnZjcHUpDQo+ID4gwqAJaWYgKHRpbWVyLT5lbmFibGVkKSB7DQo+ID4g
wqAJCWZvciAoaW50IGkgPSAwOyBpIDwgbnJfdGltZXJzKHZjcHUpOyBpKyspDQo+ID4gwqAJCQlr
dm1fdGltZXJfdXBkYXRlX2lycSh2Y3B1LCBmYWxzZSwNCj4gPiAtCQkJCQnCoMKgwqDCoCB2Y3B1
X2dldF90aW1lcih2Y3B1LA0KPiA+IGkpKTsNCj4gPiArCQkJCQl2Y3B1X2dldF90aW1lcih2Y3B1
LCBpKSk7DQo+IA0KPiBVbnJlbGF0ZWQgY2hhbmdlLCBhbmQgYSBiYWQgb25lIGF0IHRoYXQhDQo+
IA0KPiANCj4gPiDCoA0KPiA+IMKgCQlpZiAoaXJxY2hpcF9pbl9rZXJuZWwodmNwdS0+a3ZtKSkg
ew0KPiA+IC0JCQlrdm1fdmdpY19yZXNldF9tYXBwZWRfaXJxKHZjcHUsDQo+ID4gdGltZXJfaXJx
KG1hcC5kaXJlY3RfdnRpbWVyKSk7DQo+ID4gKwkJCWt2bV92Z2ljX3Jlc2V0X21hcHBlZF9pcnEo
DQo+ID4gKwkJCQl2Y3B1LA0KPiA+IHRpbWVyX2lycShtYXAuZGlyZWN0X3Z0aW1lcikpOw0KPiAN
Cj4gQWxzbyB1bnJlbGF0ZWQgYW5kIG5vdCBhIGdvb2QgY2hhbmdlLg0KPiANCj4gPiDCoAkJCWlm
IChtYXAuZGlyZWN0X3B0aW1lcikNCj4gPiAtCQkJCWt2bV92Z2ljX3Jlc2V0X21hcHBlZF9pcnEo
dmNwdSwNCj4gPiB0aW1lcl9pcnEobWFwLmRpcmVjdF9wdGltZXIpKTsNCj4gPiArCQkJCWt2bV92
Z2ljX3Jlc2V0X21hcHBlZF9pcnEoDQo+ID4gKwkJCQkJdmNwdSwNCj4gPiArCQkJCQl0aW1lcl9p
cnEobWFwLmRpcmVjdF9wdGltZQ0KPiA+IHIpKTsNCj4gDQo+IExlYXZlIGFsbCB0aGVzZSBhbG9u
ZS4NCg0KWWVhaCwgaGF2ZSBkb25lLiBCYWQgcmV2ZXJ0IG9mIGEgY2hhbmdlIGhlcmUgb24gbXkg
cGFydC4NCg0KPiANCj4gPiDCoAkJfQ0KPiA+IMKgCX0NCj4gPiDCoA0KPiA+IEBAIC0xMDkyLDEw
ICsxMTQwLDE5IEBAIHZvaWQga3ZtX3RpbWVyX3ZjcHVfaW5pdChzdHJ1Y3Qga3ZtX3ZjcHUNCj4g
PiAqdmNwdSkNCj4gPiDCoAkJwqDCoMKgwqDCoCBIUlRJTUVSX01PREVfQUJTX0hBUkQpOw0KPiA+
IMKgfQ0KPiA+IMKgDQo+ID4gKy8qDQo+ID4gKyAqIFRoaXMgaXMgYWx3YXlzIGNhbGxlZCBkdXJp
bmcga3ZtX2FyY2hfaW5pdF92bSwgYnV0IHdpbGwgYWxzbyBiZQ0KPiA+ICsgKiBjYWxsZWQgZnJv
bSBrdm1fdmdpY19jcmVhdGUgaWYgd2UgaGF2ZSBhIHZHSUN2NS4NCj4gPiArICovDQo+ID4gwqB2
b2lkIGt2bV90aW1lcl9pbml0X3ZtKHN0cnVjdCBrdm0gKmt2bSkNCj4gPiDCoHsNCj4gPiArCS8q
DQo+ID4gKwkgKiBTZXQgdXAgdGhlIGRlZmF1bHQgUFBJcyAtIG5vdGUgdGhhdCB3ZSBhZGp1c3Qg
dGhlbQ0KPiA+IGJhc2VkIG9uDQo+ID4gKwkgKiB0aGUgbW9kZWwgb2YgdGhlIEdJQyBhcyBHSUN2
NSB1c2VzIGEgZGlmZmVyZW50IHdheSB0bw0KPiA+ICsJICogZGVzY3JpYmluZyBpbnRlcnJ1cHRz
Lg0KPiA+ICsJICovDQo+ID4gwqAJZm9yIChpbnQgaSA9IDA7IGkgPCBOUl9LVk1fVElNRVJTOyBp
KyspDQo+ID4gLQkJa3ZtLT5hcmNoLnRpbWVyX2RhdGEucHBpW2ldID0gZGVmYXVsdF9wcGlbaV07
DQo+ID4gKwkJa3ZtLT5hcmNoLnRpbWVyX2RhdGEucHBpW2ldID0gZ2V0X3ZnaWNfcHBpKGt2bSwN
Cj4gPiBkZWZhdWx0X3BwaVtpXSk7DQo+ID4gwqB9DQo+ID4gwqANCj4gPiDCoHZvaWQga3ZtX3Rp
bWVyX2NwdV91cCh2b2lkKQ0KPiA+IEBAIC0xMzQ3LDYgKzE0MDQsNyBAQCBzdGF0aWMgaW50IGt2
bV9pcnFfaW5pdChzdHJ1Y3QNCj4gPiBhcmNoX3RpbWVyX2t2bV9pbmZvICppbmZvKQ0KPiA+IMKg
CQl9DQo+ID4gwqANCj4gPiDCoAkJYXJjaF90aW1lcl9pcnFfb3BzLmZsYWdzIHw9IFZHSUNfSVJR
X1NXX1JFU0FNUExFOw0KPiA+ICsJCWFyY2hfdGltZXJfaXJxX29wc192Z2ljX3Y1LmZsYWdzIHw9
DQo+ID4gVkdJQ19JUlFfU1dfUkVTQU1QTEU7DQo+ID4gwqAJCVdBUk5fT04oaXJxX2RvbWFpbl9w
dXNoX2lycShkb21haW4sDQo+ID4gaG9zdF92dGltZXJfaXJxLA0KPiA+IMKgCQkJCQnCoMKgwqAg
KHZvaWQNCj4gPiAqKVRJTUVSX1ZUSU1FUikpOw0KPiA+IMKgCX0NCj4gPiBAQCAtMTQ5NywxMCAr
MTU1NSwxMyBAQCBzdGF0aWMgYm9vbCB0aW1lcl9pcnFzX2FyZV92YWxpZChzdHJ1Y3QNCj4gPiBr
dm1fdmNwdSAqdmNwdSkNCj4gPiDCoAkJCWJyZWFrOw0KPiA+IMKgDQo+ID4gwqAJCS8qDQo+ID4g
LQkJICogV2Uga25vdyBieSBjb25zdHJ1Y3Rpb24gdGhhdCB3ZSBvbmx5IGhhdmUgUFBJcywNCj4g
PiBzbw0KPiA+IC0JCSAqIGFsbCB2YWx1ZXMgYXJlIGxlc3MgdGhhbiAzMi4NCj4gPiArCQkgKiBX
ZSBrbm93IGJ5IGNvbnN0cnVjdGlvbiB0aGF0IHdlIG9ubHkgaGF2ZSBQUElzLA0KPiA+IHNvIGFs
bCB2YWx1ZXMNCj4gPiArCQkgKiBhcmUgbGVzcyB0aGFuIDMyIGZvciBub24tR0lDdjUgdmdpY3Mu
IE9uIEdJQ3Y1LA0KPiA+IHRoZXkgYXJlDQo+IA0KPiBWR0lDcyBtYXliZT/CoCBJdCdzIG5vdCBj
b25zaXN0ZW50IGluIGV4aXN0aW5nIGNvbW1lbnRzIGluIHRoaXMgZmlsZQ0KPiB0aG91Z2guDQo+
IA0KPiA+ICsJCSAqIGFyY2hpdGVjdHVyYWxseSBkZWZpbmVkIHRvIGJlIHVuZGVyIDMyIHRvby4N
Cj4gPiBIb3dldmVyLCB3ZSBtYXNrDQo+ID4gKwkJICogb2ZmIG1vc3Qgb2YgdGhlIGJpdHMgYXMg
d2UgbWlnaHQgYmUgcHJlc2VudGVkDQo+ID4gd2l0aCBhIEdJQ3Y1DQo+ID4gKwkJICogc3R5bGUg
UFBJIHdoZXJlIHRoZSB0eXBlIGlzIGVuY29kZWQgaW4gdGhlIHRvcC0NCj4gPiBiaXRzLg0KPiA+
IMKgCQkgKi8NCj4gPiAtCQlwcGlzIHw9IEJJVChpcnEpOw0KPiA+ICsJCXBwaXMgfD0gQklUKGly
cSAmIDB4MWYpOw0KPiA+IMKgCX0NCj4gPiDCoA0KPiA+IMKgCXZhbGlkID0gaHdlaWdodDMyKHBw
aXMpID09IG5yX3RpbWVycyh2Y3B1KTsNCj4gPiBAQCAtMTUzOCw3ICsxNTk5LDkgQEAgaW50IGt2
bV90aW1lcl9lbmFibGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+IMKgew0KPiA+IMKgCXN0
cnVjdCBhcmNoX3RpbWVyX2NwdSAqdGltZXIgPSB2Y3B1X3RpbWVyKHZjcHUpOw0KPiA+IMKgCXN0
cnVjdCB0aW1lcl9tYXAgbWFwOw0KPiA+ICsJc3RydWN0IGlycV9vcHMgKm9wczsNCj4gPiDCoAlp
bnQgcmV0Ow0KPiA+ICsJaW50IGlycTsNCj4gTWlnaHQgYXMgd2VsbCBwdXQgaXJxIG9uIHNhbWUg
bGluZSBhcyByZXQNCj4gDQoNCkFjdHVhbGx5LCB0aGlzIHNob3VsZCByZWFsbHkgYmUgYSB1MzIh
IEhvd2V2ZXIsIEkndmUgZHJvcHBlZCB0aGUgbG9jYWwNCnZhciBhcyB5b3Ugc3VnZ2VzdCBiZWxv
dy4NCg0KPiA+IMKgDQo+ID4gwqAJaWYgKHRpbWVyLT5lbmFibGVkKQ0KPiA+IMKgCQlyZXR1cm4g
MDsNCj4gPiBAQCAtMTU1NiwyMCArMTYxOSwyMiBAQCBpbnQga3ZtX3RpbWVyX2VuYWJsZShzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ID4gwqAJCXJldHVybiAtRUlOVkFMOw0KPiA+IMKgCX0NCj4g
PiDCoA0KPiA+ICsJb3BzID0gdmdpY19pc192NSh2Y3B1LT5rdm0pID8gJmFyY2hfdGltZXJfaXJx
X29wc192Z2ljX3Y1DQo+ID4gOg0KPiA+ICsJCQkJwqDCoMKgwqDCoCAmYXJjaF90aW1lcl9pcnFf
b3BzOw0KPiA+ICsNCj4gPiDCoAlnZXRfdGltZXJfbWFwKHZjcHUsICZtYXApOw0KPiA+IMKgDQo+
ID4gLQlyZXQgPSBrdm1fdmdpY19tYXBfcGh5c19pcnEodmNwdSwNCj4gPiAtCQkJCcKgwqDCoCBt
YXAuZGlyZWN0X3Z0aW1lci0NCj4gPiA+aG9zdF90aW1lcl9pcnEsDQo+ID4gLQkJCQnCoMKgwqAg
dGltZXJfaXJxKG1hcC5kaXJlY3RfdnRpbWVyKSwNCj4gPiAtCQkJCcKgwqDCoCAmYXJjaF90aW1l
cl9pcnFfb3BzKTsNCj4gPiArCWlycSA9IHRpbWVyX2lycShtYXAuZGlyZWN0X3Z0aW1lcik7DQo+
ID4gKwlyZXQgPSBrdm1fdmdpY19tYXBfcGh5c19pcnEodmNwdSwgbWFwLmRpcmVjdF92dGltZXIt
DQo+ID4gPmhvc3RfdGltZXJfaXJxLA0KPiA+ICsJCQkJwqDCoMKgIGlycSwgb3BzKTsNCj4gDQo+
IEFzIGlycSBpcyBvbmx5IHVzZWQgd2l0aCB0aGlzIHZhbHVlIGluIGhlcmUsIEknZCBhdm9pZCBo
YXZpbmcgdGhlDQo+IGxvY2FsIHZhcmlhYmxlDQo+IHRoYXQgY2hhbmdlcyBtZWFuaW5nLg0KDQpB
Z3JlZWQuDQoNCj4gDQo+IAlyZXQgPSBrdm1fdmdpY19tYXBfcGh5c19pcnEodmNwdSwgbWFwLmRp
cmVjdF92dGltZXItDQo+ID5ob3N0X3RpbWVyX2lycSwNCj4gCQkJCcKgwqDCoCB0aW1lcl9pcnEo
bWFwLmRpcmVjdF92dGltZXIpLA0KPiBvcHMpOw0KPiA+IMKgCWlmIChyZXQpDQo+ID4gwqAJCXJl
dHVybiByZXQ7DQo+ID4gwqANCj4gPiDCoAlpZiAobWFwLmRpcmVjdF9wdGltZXIpIHsNCj4gPiAr
CQlpcnEgPSB0aW1lcl9pcnEobWFwLmRpcmVjdF9wdGltZXIpOw0KPiA+IMKgCQlyZXQgPSBrdm1f
dmdpY19tYXBfcGh5c19pcnEodmNwdSwNCj4gPiDCoAkJCQkJwqDCoMKgIG1hcC5kaXJlY3RfcHRp
bWVyLQ0KPiA+ID5ob3N0X3RpbWVyX2lycSwNCj4gPiAtCQkJCQnCoMKgwqANCj4gPiB0aW1lcl9p
cnEobWFwLmRpcmVjdF9wdGltZXIpLA0KPiA+IC0JCQkJCcKgwqDCoCAmYXJjaF90aW1lcl9pcnFf
b3BzKTsNCj4gPiArCQkJCQnCoMKgwqAgaXJxLCBvcHMpOw0KPiBBcyBhYm92ZQ0KPiAJCQkJCcKg
wqDCoA0KPiB0aW1lcl9pcnEobWFwLmRpcmVjdF9wdGltZXIpLCBvcHMpOw0KPiANCj4gRG9lc24n
dCBtYWtlIGl0IG11Y2ggaGFyZGVyIHRvIHJlYWQgYW5kIGF2b2lkcyB0aGUgbG9jYWwgdmFyaWFi
bGUNCj4gYmVpbmcgbmVlZGVkLg0KPiA+IMKgCX0NCj4gPiDCoA0KPiA+IMKgCWlmIChyZXQpDQo+
ID4gQEAgLTE2MjcsNiArMTY5MiwxNSBAQCBpbnQga3ZtX2FybV90aW1lcl9zZXRfYXR0cihzdHJ1
Y3Qga3ZtX3ZjcHUNCj4gPiAqdmNwdSwgc3RydWN0IGt2bV9kZXZpY2VfYXR0ciAqYXR0cikNCj4g
PiDCoAkJZ290byBvdXQ7DQo+ID4gwqAJfQ0KPiA+IMKgDQo+ID4gKwkvKg0KPiA+ICsJICogVGhl
IFBQSXMgZm9yIHRoZSBBcmNoIFRpbWVycyBhcmNoIGFyY2hpdGVjdHVyYWxseQ0KPiA+IGRlZmlu
ZWQgZm9yDQo+ID4gKwkgKiBHSUN2NS4gUmVqZWN0IGFueXRoaW5nIHRoYXQgY2hhbmdlcyB0aGVt
IGZyb20gdGhlDQo+ID4gc3BlY2lmaWVkIHZhbHVlLg0KPiA+ICsJICovDQo+ID4gKwlpZiAodmdp
Y19pc192NSh2Y3B1LT5rdm0pICYmIHZjcHUtPmt2bS0NCj4gPiA+YXJjaC50aW1lcl9kYXRhLnBw
aVtpZHhdICE9IGlycSkgew0KPiA+ICsJCXJldCA9IC1FSU5WQUw7DQo+ID4gKwkJZ290byBvdXQ7
DQo+IA0KPiBXaGlsc3QgeW91IGFyZSBoZXJlLCBtYXliZSB0aHJvdyBzb21lIGd1YXJkKCkgbWFn
aWMgZHVzdCBhdCB0aGlzIGFuZA0KPiBkbyBhIGRpcmVjdCByZXR1cm4/DQo+IE9yIGxlYXZlIGl0
IGZvciBzb21lb25lIGVsc2Ugd2hvIGhhcyBtb3JlIHNwYXJlIHRpbWUgOykNCg0KSSBtaWdodCBh
cyB3ZWxsIGFzIGl0IG1ha2VzIHRoZSBjb2RlIGNsZWFuZXIuDQoNCj4gDQo+ID4gKwl9DQo+ID4g
Kw0KPiA+IMKgCS8qDQo+ID4gwqAJICogV2UgY2Fubm90IHZhbGlkYXRlIHRoZSBJUlEgdW5pY2l0
eSBiZWZvcmUgd2UgcnVuLCBzbw0KPiA+IHRha2UgaXQgYXQNCj4gPiDCoAkgKiBmYWNlIHZhbHVl
LiBUaGUgdmVyZGljdCB3aWxsIGJlIGdpdmVuIG9uIGZpcnN0IHZjcHUNCj4gPiBydW4sIGZvciBl
YWNoDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2t2bS9hcm1fYXJjaF90aW1lci5oDQo+
ID4gYi9pbmNsdWRlL2t2bS9hcm1fYXJjaF90aW1lci5oDQo+ID4gaW5kZXggNzMxMDg0MWY0NTEy
MS4uNmNiOWMyMGY5ZGI2NSAxMDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL2t2bS9hcm1fYXJjaF90
aW1lci5oDQo+ID4gKysrIGIvaW5jbHVkZS9rdm0vYXJtX2FyY2hfdGltZXIuaA0KPiANCj4gPiDC
oA0KPiA+IMKgc3RydWN0IGFyY2hfdGltZXJfY29udGV4dCB7DQo+ID4gQEAgLTEzMCw2ICsxMzIs
OSBAQCB2b2lkIGt2bV90aW1lcl9pbml0X3ZoZSh2b2lkKTsNCj4gPiDCoCNkZWZpbmUNCj4gPiB0
aW1lcl92bV9kYXRhKGN0eCkJCSgmKHRpbWVyX2NvbnRleHRfdG9fdmNwdShjdHgpLT5rdm0tPmFy
Y2gudGltZXJfZGF0YSkpDQo+ID4gwqAjZGVmaW5lIHRpbWVyX2lycShjdHgpCQkJKHRpbWVyX3Zt
X2RhdGEoY3R4KS0NCj4gPiA+cHBpW2FyY2hfdGltZXJfY3R4X2luZGV4KGN0eCldKQ0KPiA+IMKg
DQo+ID4gKyNkZWZpbmUgZ2V0X3ZnaWNfcHBpKGssIGkpICgoKGspLT5hcmNoLnZnaWMudmdpY19t
b2RlbCAhPQ0KPiA+IEtWTV9ERVZfVFlQRV9BUk1fVkdJQ19WNSkgPyBcDQo+ID4gKwkJCQkoaSkg
OiAoKGkpIHwNCj4gPiBGSUVMRF9QUkVQKEdJQ1Y1X0hXSVJRX1RZUEUsIEdJQ1Y1X0hXSVJRX1RZ
UEVfUFBJKSkpDQo+IA0KPiBTaW1pbGFyIHRvIGVhcmxpZXIgY29tbWVudCBJJ2QgdXNlIEZJRUxE
X1BSRVAoKSBmb3IgaSBhcyB3ZWxsIGJ1dCBub3QNCj4gdGhhdCBpbXBvcnRhbnQNCj4gSSdtIGp1
c3QgbGF6eSBhYm91dCByZW1lbWJlcmluZyB3aGVyZSB0aGUgbnVtYmVycyBnby4NCg0KRG9uZSwg
dGhhbmtzLg0KU2FzY2hhDQo=

