Return-Path: <kvm+bounces-67360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D55A5D02342
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 11:51:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 504BB30D8C77
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 10:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA3F83A0EAA;
	Thu,  8 Jan 2026 09:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LE+D5H05";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LE+D5H05"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011035.outbound.protection.outlook.com [40.107.130.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8858B3A0E9C
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 09:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.35
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767865802; cv=fail; b=PnizuaYUOE0dMfXZYEx9r3URvYYNIWcsLpixubdfBXuthZDgbQupwpRzj+KyD6HdbWc/GJuwuVlw5rWBcwIenyeWZxN89Q/qpbxwx1k3WFeX1GggadIJyVAtb+HSm7n8wSz0kM3BF1pgj2HotiDFoTDriuj/tRT2sKpFV25DUiE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767865802; c=relaxed/simple;
	bh=3ucKtfcyOQeA8RD7utoh+A2yRxrg9TxIpcd79gnhYck=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bl/s70UJhDkCd52fi1XR1xBLrMZEF63I4fzCzUmO4GtP2EHIRB0QqTr34l15i9qa6vFEgX6rQTHvxm5BhsyEnlrFNN9kmmuFNdCaeTr7wlPURF/0QVBhFMnEKLGuvKN4N9ILzGaGc5QUfkgmh57WbDccEiGmMhRtZQyTTONm2bY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LE+D5H05; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LE+D5H05; arc=fail smtp.client-ip=40.107.130.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=KOPxZhtpkNJhaoqgFy18AYYyVQDO1cFXMrklWdvi2lw+Dl8qt6Uh87yfrD9mN7K9K4f4nqXUHvL+UINc1g8sUKMZL25TxPyvYOTCxIaTbtaEbsNNsj4WULc4srMAVuyc/M6bcqhTL+CMxf+MuPvJa659WYpKIxOgYk1BYx35ewPUiFHia8OM3hxsdU1bdcCbH+i1sEoG9BHKgWtyg3rCaVFdlLZqEZiYQ9Hsi/6K8p2I7gxJDbVJh6DYGxovIe8sYhVsYiUOX75Jo82LbtHtb2bkgP6gKnIovRU3D8pygQ3AeWC9RhKZ81fg2UoCDXMK8LIlYWGXmHUc+2FgbW0wEA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ucKtfcyOQeA8RD7utoh+A2yRxrg9TxIpcd79gnhYck=;
 b=XUc4cPZx3LpYEwKQFvqPL3Qh35wewfvkut5LjU3J4uPTO445z5cKaYMppuhQQQJx50jV6rmndQKAUgC4ArExUgjirnm4gMQuRq9lYKKp2uTcPOTocX9rD0dj+G8YaFBP5hrP/JhPT/WUYpywzBTQBX9FGjXP0LqjrWHv3E2vI6H0M3egKg0DKTQAWpniPEdESkZ3uOdVfQFZq6ASTq6OEesSM+QVlFPqPHTbsZtPkTxI5UmSJCVPjjmIP/Y7txTNgbH+1chVj1dwZpuYCD0v+AfgqVQ1ddofRucPZSdJEMWzxbjhzk9pLRnlWHsxLpe6hxLMy6fB7NY12Na3gQxXBA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ucKtfcyOQeA8RD7utoh+A2yRxrg9TxIpcd79gnhYck=;
 b=LE+D5H05UmEncCrkmBa7b1b8BjyuXoI77AvguQzLS6JKebrPoGBsJ8q41sNkJF19buabzpuey6R82oMGy+49I/I7iTGzYLQ2vj06f08BRqFyMD4nkdUaXnBTXaVQBrdREyzpQCBgVN8I+nOkZ97BPlyIfXXakrAIMopVy7citQ8=
Received: from DUZPR01CA0123.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bc::8) by AS8PR08MB9645.eurprd08.prod.outlook.com
 (2603:10a6:20b:61a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 09:49:43 +0000
Received: from DU6PEPF00009526.eurprd02.prod.outlook.com
 (2603:10a6:10:4bc:cafe::4f) by DUZPR01CA0123.outlook.office365.com
 (2603:10a6:10:4bc::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.3 via Frontend Transport; Thu, 8
 Jan 2026 09:50:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009526.mail.protection.outlook.com (10.167.8.7) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1 via
 Frontend Transport; Thu, 8 Jan 2026 09:49:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SeMqDAolbC4+6CvuajE19cS9jd+7N5EkKLH8aIrt8jVolBbZD9JabV5jI1QZxz5Z3MU0iqreJGoxHFKUW9k+lPRxI1e934Qlaal13/+cSBS4+C7E+NOZjxktQQw5P3o6UTri/d/tsr4EpAqfySicP3SDVL8oNQIZjQfyc2C266vdrqSuMBmU0cI6ByB0he+rUO4FMW+0y7QzEzWRXOy1sl4uZpJnjScOOtjs5qBnkEmmC7VZJ2fWXh0Ycs6jrLFICFOwHNtkk4Z+2+YCgv1/cHqa6RsIm5M0PmhugHOmA77lP8LAyqahL/NmQQaNRv99Z8ViT9sEd4HQaIkYbH/csQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ucKtfcyOQeA8RD7utoh+A2yRxrg9TxIpcd79gnhYck=;
 b=TYAN1Z5/5NKtP0nPOJBtjr/G1SNHEWUO+78G7UGOm+bYXeWrSmapZ8GcmJpn6h8bYZMh8Ibrk4dHVRemF2USn11Kq/DGrUvDEcMPJNEurTcVSxMUiyqJjzV2ibST7N0cp7TT+y4p5mrsIK5MR+S08SRYFprVIHoDgqSder+ytUqzupHBt+WjriAfzAcgrYNaIaV71/5/dFvuYuZBRX/5dDXsswJotW3zj891RPQa5vTnHMzX9XbKuRbXSeRElhjr0kQuBP/1AiZZhVR/cFm5lP5CNW4SUaIZu/xxPMMTw2/HDjTz/V43Tu3bumOHvsD9vfrbuNgWcnuP8Q3WQ2r2bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ucKtfcyOQeA8RD7utoh+A2yRxrg9TxIpcd79gnhYck=;
 b=LE+D5H05UmEncCrkmBa7b1b8BjyuXoI77AvguQzLS6JKebrPoGBsJ8q41sNkJF19buabzpuey6R82oMGy+49I/I7iTGzYLQ2vj06f08BRqFyMD4nkdUaXnBTXaVQBrdREyzpQCBgVN8I+nOkZ97BPlyIfXXakrAIMopVy7citQ8=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AM7PR08MB5415.eurprd08.prod.outlook.com (2603:10a6:20b:10d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 09:48:39 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 09:48:39 +0000
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
Subject: Re: [PATCH v2 08/36] KVM: arm64: Introduce kvm_call_hyp_nvhe_res()
Thread-Topic: [PATCH v2 08/36] KVM: arm64: Introduce kvm_call_hyp_nvhe_res()
Thread-Index: AQHccP+AuO5u84edkE+pcGHcNBr/E7VGn1wAgAGGkIA=
Date: Thu, 8 Jan 2026 09:48:39 +0000
Message-ID: <5ef0d810c4619b941d5c74e79401ce584193604d.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	 <20251219155222.1383109-9-sascha.bischoff@arm.com>
	 <20260107103044.00000df0@huawei.com>
In-Reply-To: <20260107103044.00000df0@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|AM7PR08MB5415:EE_|DU6PEPF00009526:EE_|AS8PR08MB9645:EE_
X-MS-Office365-Filtering-Correlation-Id: 99e42e0c-e48a-4ba9-131a-08de4e9b3f51
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?TXkzZXNFTDk2TzVkYkpSNDVkYXl4V1FqK1J2TEdLT3ZvNzFzSVRMM0pTeVFB?=
 =?utf-8?B?M21pWW1Fc0lPT0E3TDRIeHlySmFmZXBRdVVpUjlRRXdVZDF5WnUyV0xqNXgx?=
 =?utf-8?B?RlR0Y3VNM3ZNNjFhZGVOL3NoVjZaT3UyMjUrdkpBNVNzMnFoSmtMcVRwcUNs?=
 =?utf-8?B?c1JCR1FxUTlEM3pSQ0VNMWlTMXQ0ZVpKbnpPMVN3TUhuSWxadmJLWXF1TTRm?=
 =?utf-8?B?OW9kYTllSDZiNXM2emtuMStFdGRzalk0V0tBeDJsdnFiR3lxenBrN2F4YkE3?=
 =?utf-8?B?Q1JTR29RVnRuMWZucy9zanFnclVyMUFrUlJlOHFzaVprT1QwNXcrZ2EvZkFr?=
 =?utf-8?B?OUpoSkxBeElPVCtVUFozL0hqYS9CeDN2dEtJeVk1cG53ZHg2cVZBWXF0L1FW?=
 =?utf-8?B?elg0MDVUYmFQQ2xkU2tyL1ptcG1jOW5SMXFKdVlsK0hpWkpoZ3h2eG1VR2xl?=
 =?utf-8?B?R3N1UnE1NkNFc05yR3V6ZVZGV2pKdDNneXZSMU9IL1ZYM0ZCUlVpWkh5OHFh?=
 =?utf-8?B?cnl2S2tDTEhmREtxdHkwZTFPWkJ6OHhXVkNscTRFZmJrZXUrZEkydjdXTW9S?=
 =?utf-8?B?ZllCMEs5QXhzZjJVS0dvWlU2UWJvK0NRSk53MEt2UlVUR0dsSWxhcTdxNU9z?=
 =?utf-8?B?T2V5ZEl6QmhtQzN5eTF4MmhnSWFzWUhLT1Qzc3Bhc1RUNFAvcExXUkZuYkp3?=
 =?utf-8?B?Z2Y0Y1VSbGk3d1VaNWo4cHlHZEJMcks0WjM3WGRMYnhyQ2M5MHlZMEFyZjRM?=
 =?utf-8?B?VnR2eFR6aGd5OGNhd0VtZWRaa3ZzaFkycldaNDhsa0NVMVdGY3JDdmkzc29j?=
 =?utf-8?B?UW00R2RMNml5V2FEVmMrelRLMjFJM2lHR0V3cHpTU0xRNm1kMjlPdFQwUUR4?=
 =?utf-8?B?azZwU2l0NDk3RTVVcFdpd0djNmYreXo1WkRTVHJnV3BEK0tldHpyU1pReXZo?=
 =?utf-8?B?d3dzbXBLMlNCVCszYWxTS1UzU1BOSFBCTjFPVEFoM3FKZXFzUllmMWpham1F?=
 =?utf-8?B?Y3ZmUGxnN0dOU3J4VHVxR0VOcUloWTZMWXN2OHFTYXNvTlRDaG52M1l4Y1Z5?=
 =?utf-8?B?UWh3ZCttRWNxaDRndDhSdlhYMU9BcXpVSEh6anlKaFhTOXBIQUUvUGMzNFdu?=
 =?utf-8?B?VHFCTGhDRWpYOTc1ZCt1SHl2VEF6Qnhlbm92c2M1WWpNWVRoaHJtTlVlcDkv?=
 =?utf-8?B?bUo2RlpUNm56Vk53TmM1UWJ6SWNpVWxMSWFzWWlFSWkrb0x1eTMzWm56VW1W?=
 =?utf-8?B?c2ZmNGh2cG13c0NXZXBGcnpiRm5KR2ZKT1llQ05JZ2ZaaWNza09JajE4TmFL?=
 =?utf-8?B?aHNHVjIxYW1MNlJodzI0blptWUdNcm1YajdBNXZDaXRzTTFJN3JFdFJHUzcw?=
 =?utf-8?B?bU9KNHgzSnRCUEdPd0FVMFd1bFQ0MjRDYmFYYkd1QTkzMGNVNXh1UG03TWJo?=
 =?utf-8?B?MnlhVlZ2a1Q4TUZlVUpKQXUrNDhxdW4wYzhLR2pwY3NYQWlzQ2UyNDBSSUdR?=
 =?utf-8?B?aS9Ec0grZElQbkFWQ0RUL2ViMEVjL1NnbFRaZE9KQlpzM1hKc2dzWWg1a2RK?=
 =?utf-8?B?eDlxSkFEbngrbGtiQTZNTlg1aW9HWVllQkhpSzZlUFpqb0lRcHlCMEk2a28v?=
 =?utf-8?B?bHFKd0dRdStvVloyemxlTXdMSnpJWDJpQXpGS1RrT1Z3L29uT0ViTFN2THhH?=
 =?utf-8?B?Sk1xMlB5Q3Y5eDM5bVVDNlo5TFJoRTFQOVpSMnM4VGJ3cUFHVzUwVkx0T2tY?=
 =?utf-8?B?Z2tvL0lueFB6dUZsaUJWMC94eFg5QmlnUEdUV01LWUYvUEcwREIycXdYNnlp?=
 =?utf-8?B?RzJkUlJPRlZiNDNycTNsUzNucEx3MVQraEc5Z0crV3pVWEUwM2xuQ2poblRy?=
 =?utf-8?B?VlJLakZESjcySHV5UXR0WERGeVdJUi9JcWdVTm92L1dHU1pmU0tiUVQrbjBv?=
 =?utf-8?B?L0taeXlRU3EvMnI1aGdrbzlkVis0UWNEUFFyVzhIN3pwa09xM08rOGh1OFBu?=
 =?utf-8?B?SzZUVXV4S3dQOEU3Ri8zL09qbC9pakxCbmhuejN2amd6Ty9OUGhJbGsxb1Rt?=
 =?utf-8?Q?hR8z/x?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <08AE12C81A91C54E98516FF5AB5DB477@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5415
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009526.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c59b8dd0-c12b-485a-13b8-08de4e9b19b7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|14060799003|36860700013|35042699022|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bC9kY1VHcm9zUHowN2xGbnU4aEhXYTdNNlNqbXRhLzhWZWF0cVlxYXVIU1l5?=
 =?utf-8?B?eXdNUVl1OFJuR2N6aG5XeWlRV3JXcFllZ2o5SWFwaFMrZ0o4WlJpMENNYnpv?=
 =?utf-8?B?cDBPRVdpL1dQcXhmZXQ3enhmdUI0amo1OFg4cmpISFgyb3c3NWI1dUlYYk02?=
 =?utf-8?B?MkRJbWRMOHpjQm9yTGRFMHpGcXU0WWZCZWxsOWIreVZNaUtYbnVNN1BDVFNS?=
 =?utf-8?B?c29QeEx0NjJodTcvRkZYeGZydWhpaVUyTmlnZ1pZcnNWZlNxSVBQWGRxanZm?=
 =?utf-8?B?YmxwZm1NVERmUDQ3dDJldFNwTVdkNCtXZWVvbGpFQVZRMnlYZHdoSHdGbmUr?=
 =?utf-8?B?aTVFdUI0MUFZNGlpUyt0TW45aDRQRzY3S3czTDRLaXpIOW5VSWhyb3pYVWZs?=
 =?utf-8?B?WSs3VHpScXJDTksreDlCUlpOQ3FDazdEbkxNelg4UVMxMzErMlZQOHpoc3JN?=
 =?utf-8?B?cnBjbEd2bnZnazgwbnJXWFRvcHV1N1ZnYXRZQmxqVi9OS3BvZ0tOZDc5UjZ2?=
 =?utf-8?B?OUpFRjU1TVpmUm5XZ0hqc3BoUG1LajUyWjd4UVZFQlhPTGowVUVvM2NrZSs5?=
 =?utf-8?B?dWkyVmhtSy9ac2RNaW1ibkpPUWVBbmw2NW1wd0k1eWl2UGlpQWtlTEFlcmly?=
 =?utf-8?B?eGFHOThBMklsMklTelJ0cWZKcklzVXRXT1dTU1NQeFNqSS8yOXNlTFRyWVFB?=
 =?utf-8?B?LzNOSjJrTlBEYzdDbkt6OXRYRjdFSkkyZllUbGdneWdEK3p4Qm0wQ1hlbFJj?=
 =?utf-8?B?b2lPY0laSWcwYWZZQTZiWlY2cit6eXdONlUveDFtQWw0QWxlMVlQS3FJRmUy?=
 =?utf-8?B?RHpOb0hyYUszcXJUcFhOTnFNc2JOc0lnNzdSTk5QbW5QVHcyMVlheFZGUjAr?=
 =?utf-8?B?RTJyMXBiMTJ4NllsK3NVYWRvWEduR2xobEhrT3FlM1UzWnlHa0tVRmU0VWJ2?=
 =?utf-8?B?YjZWMUlkdk1sYk9BVkx4Y2NReHFLdmZaNWJNQkIzQklPZ04ySlU1Tkc5OXph?=
 =?utf-8?B?TXNNMkxJd3FHdmJwaUdabHl4bU11WTdZYmFSR1ZBbnNqRkg3ODZaMDdZRnpV?=
 =?utf-8?B?SFZFMGJVcUdDY0g5UVljalQ0YkprWmxKTCtHcGV0VEFEcHd1NEFzL3dFb1lt?=
 =?utf-8?B?ZVZXU2lGQWxlYlMxR3dzNFV1SXpxekhuQy80ekZQUFI0eEZGeTlaVUFsWmVR?=
 =?utf-8?B?QWhaeWYrSk1MNkJ0NWFZRHZ4ejNpdWhmSlVlRzVKc0V6VVgyWll0aS84M25v?=
 =?utf-8?B?bFRON3FIYkt4c2JMOGtGdDQ1clllaGwyVHFUbmdWd0d5Q2dweTNnaDViaTVI?=
 =?utf-8?B?QjV0Vm9JZVlxR1dua1ZwS1VvNVhlZXRKckZuK3ZHd0tJVTFkNXVqcmlSWVFM?=
 =?utf-8?B?aXRsOE1CeHN6T2hjVWZqdHBWZkVLZzhVOXAvaVNZVG5lV1lTM0RQS2x5NGdQ?=
 =?utf-8?B?MWpKWWlSSEhsbU9wNmV1STEvT3B5czRuS0xvWktBY2dtQVBLdWtFMGYzdzlv?=
 =?utf-8?B?RHBQeVZ4eEVQM3RQRG9RZkYxZEp6b2ZMcTc5NzhuOThudWR6RHQ1OXpyV0dX?=
 =?utf-8?B?SVRjbnFxTG02NjVha3Z3T1RJd3g5ZWhsbmtEUVdHNWdEcFNDeHQ1NmVqeFUx?=
 =?utf-8?B?cStUa0h5K2xGWHhsbUVOTWsyMk9uSmVVM2dPTU9qL3FJS2JKYkk0M0wyaGRT?=
 =?utf-8?B?alE0aHRnSHorQUJ1cjhGeEI2MnRYUjQ2K2pOWisyK0JXQmkzMmtFTmxFTUlD?=
 =?utf-8?B?eS9vNm5EdU1MUnpLSE5pa25iVWFFTURLcjFhZHZER3N4YU1MVHBkZ0Rjalhs?=
 =?utf-8?B?LytYcWVmTGZVdWlZZlF3OEVaOFhYaTBRdE5UYTJmMDM4YkxWRHk5VHlEREN1?=
 =?utf-8?B?TnBGQkdxV0ttKzlQbmZSR3ZERHBiMGxMUytCZU5zMVBPamV6TzNNWGcrTFFI?=
 =?utf-8?B?eTFMdEh1T1A0aU5wRXJCc2dWMlRRRmhieVhoUFl2TE9rdHg4MnEzUlpHTlhx?=
 =?utf-8?B?eDVmcllzMlplTWttT2Q5Wk9PWkUzUVA3akF4dlJWWnU0aWt6aHBHcUFwNHRJ?=
 =?utf-8?B?azRQU3IzblliS2RweDRwWW1mRlQ3eU9mWTMxbWx1a0FxVmVxTHpRSXFpbFFu?=
 =?utf-8?Q?1398=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(14060799003)(36860700013)(35042699022)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 09:49:42.1280
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99e42e0c-e48a-4ba9-131a-08de4e9b3f51
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009526.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9645

T24gV2VkLCAyMDI2LTAxLTA3IGF0IDEwOjMwICswMDAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBGcmksIDE5IERlYyAyMDI1IDE1OjUyOjM4ICswMDAwDQo+IFNhc2NoYSBCaXNjaG9m
ZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiANCj4gPiBUaGVyZSBhcmUgdGlt
ZXMgd2hlbiBpdCBpcyBkZXNpcmFibGUgdG8gaGF2ZSBtb3JlIHRoYW4gb25lIHJldHVybg0KPiA+
IHZhbHVlIGZvciBhIGh5cCBjYWxsLiBTcGxpdCBvdXQga3ZtX2NhbGxfaHlwX252aGVfcmVzIGZy
b20NCj4gPiBrdm1fY2FsbF9oeXBfbnZoZSBzdWNoIHRoYXQgaXQgaXMgcG9zc2libGUgdG8gZGly
ZWN0bHkgcHJvdmlkZQ0KPiA+IHN0cnVjdA0KPiA+IGFybV9zbWNjY19yZXMgZnJvbSB0aGUgY2Fs
bGluZyBjb2RlLiBUaGVyZWJ5LCBhZGRpdGlvbmFsIHJldHVybg0KPiA+IHZhbHVlcw0KPiA+IGNh
biBiZSBzdG9yZWQgaW4gcmVzLmEyLCBldGMuDQo+ID4gDQo+ID4gU3VnZ2VzdGVkLWJ5OiBNYXJj
IFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhc2NoYSBCaXNj
aG9mZiA8c2FzY2hhLmJpc2Nob2ZmQGFybS5jb20+DQo+IE9uZSBxdWVzdGlvbiBpbmxpbmUsIG1v
c3RseSBiZWNhdXNlIEknbSBjdXJpb3VzIHJhdGhlciB0aGFuIGENCj4gc3VnZ2VzdGlvbg0KPiB0
byBjaGFuZ2UgYW55dGhpbmcNCj4gDQo+IFJldmlld2VkLWJ5OiBKb25hdGhhbiBDYW1lcm9uIDxq
b25hdGhhbi5jYW1lcm9uQGh1YXdlaS5jb20+DQo+IA0KPiA+IC0tLQ0KPiA+IMKgYXJjaC9hcm02
NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIHwgMTUgKysrKysrKysrKy0tLS0tDQo+ID4gwqAxIGZp
bGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBk
aWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+ID4gYi9hcmNo
L2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgNCj4gPiBpbmRleCBiNTUyYTFlMDM4NDhjLi45
NzFiMTUzYjBhM2ZhIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3Zt
X2hvc3QuaA0KPiA+ICsrKyBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPiA+
IEBAIC0xMjA4LDE0ICsxMjA4LDE5IEBAIHZvaWQga3ZtX2FybV9yZXN1bWVfZ3Vlc3Qoc3RydWN0
IGt2bSAqa3ZtKTsNCj4gPiDCoCNkZWZpbmUgdmNwdV9oYXNfcnVuX29uY2UodmNwdSkJKCEhUkVB
RF9PTkNFKCh2Y3B1KS0+cGlkKSkNCj4gPiDCoA0KPiA+IMKgI2lmbmRlZiBfX0tWTV9OVkhFX0hZ
UEVSVklTT1JfXw0KPiA+IC0jZGVmaW5lIGt2bV9jYWxsX2h5cF9udmhlKGYsDQo+ID4gLi4uKQkJ
CQkJCVwNCj4gPiArI2RlZmluZSBrdm1fY2FsbF9oeXBfbnZoZV9yZXMocmVzLCBmLA0KPiA+IC4u
LikJCQkJXA0KPiA+IMKgCSh7CQkJCQkJCQ0KPiA+IAlcDQo+ID4gLQkJc3RydWN0IGFybV9zbWNj
Y19yZXMNCj4gPiByZXM7CQkJCVwNCj4gPiAtDQo+ID4gCQkJCQkJCQkJXA0KPiA+ICsJCXN0cnVj
dCBhcm1fc21jY2NfcmVzICpfX3JlcyA9DQo+ID4gcmVzOwkJCVwNCj4gDQo+IFdoYXQncyB0aGUg
cHVycG9zZSBvZiB0aGUgbG9jYWwgdmFyaWFibGU/IFR5cGUgc2FuaXR5IGNoZWNrPw0KPiBGZWVs
cyBsaWtlIHR5cGVjaGVjaygpIHdvdWxkIG1ha2UgdGhlIGludGVudCBjbGVhcmVyLg0KPiBNZWgu
IE5vdCB1c2VkIGFueXdoZXJlIGluIGFyY2gvYXJtNjQgc28gbWF5YmUgbm90Lg0KDQpGYXIgbGVz
cyBleGNpdGluZywgSSdtIGFmcmFpZC4NCg0KSXQgaXMgYmVjYXVzZSBvZiB0aGUgdGV4dCBzdWJz
dGl0dXRpb24gdGhhdCBoYXBwZW5zLiBUaGUgcmVzIGhlcmUgaXMNCnJlcGxhY2VkIHdpdGggJnJl
cyBmcm9tIGt2bV9jYWxsX2h5cF9udmhlKCkgYW5kIHdlIGVuZCB1cCB3aXRoICZyZXMtDQo+YTAu
IEdpdmVuIHRoYXQgLT4gYmluZHMgbW9yZSB0aWdodGx5IHRoYW4gJiwgd2UgZW5kIHVwIHdpdGgg
dGhlIHdyb25nDQp0aGluZywgYW5kIHRoZSBjb21waWxlciBiYXJmcy4NCg0KQW4gYWx0ZXJuYXRp
dmUgd291bGQgYmUgdG8gZG86DQoNCglXQVJOX09OKChyZXMpLT5hMCAhPSBTTUNDQ19SRVRfU1VD
Q0VTUyk7DQoNClRoaXMgcmVtb3ZlcyB0aGUgbmVlZCBmb3IgdGhlIGxvY2FsIHZhcmlhYmxlLiBJ
J3ZlIGdvdCBubyBwcmVmZXJlbmNlDQpmb3Igd2hpY2ggdmVyc2lvbiB3ZSBnbyB3aXRoLg0KDQpT
YXNjaGENCg0KPiANCj4gDQo+IA0KPiA+IMKgCQlhcm1fc21jY2NfMV8xX2h2YyhLVk1fSE9TVF9T
TUNDQ19GVU5DKGYpLAkNCj4gPiAJXA0KPiA+IC0JCQkJwqAgIyNfX1ZBX0FSR1NfXywNCj4gPiAm
cmVzKTsJCQlcDQo+ID4gLQkJV0FSTl9PTihyZXMuYTAgIT0NCj4gPiBTTUNDQ19SRVRfU1VDQ0VT
Uyk7CQkJXA0KPiA+ICsJCQkJwqAgIyNfX1ZBX0FSR1NfXywNCj4gPiBfX3Jlcyk7CQlcDQo+ID4g
KwkJV0FSTl9PTihfX3Jlcy0+YTAgIT0NCj4gPiBTTUNDQ19SRVRfU1VDQ0VTUyk7CQlcDQo+ID4g
Kwl9KQ0KPiA+ICsNCj4gPiArI2RlZmluZSBrdm1fY2FsbF9oeXBfbnZoZShmLA0KPiA+IC4uLikJ
CQkJCVwNCj4gPiArCSh7CQkJCQkJCQ0KPiA+IAlcDQo+ID4gKwkJc3RydWN0IGFybV9zbWNjY19y
ZXMNCj4gPiByZXM7CQkJCVwNCj4gPiDCoAkJCQkJCQkJDQo+ID4gCVwNCj4gPiArCQlrdm1fY2Fs
bF9oeXBfbnZoZV9yZXMoJnJlcywgZiwNCj4gPiAjI19fVkFfQVJHU19fKTsJCVwNCj4gPiDCoAkJ
cmVzLmExOwkJCQkJDQo+ID4gCQlcDQo+ID4gwqAJfSkNCj4gPiDCoA0KPiANCg0K

