Return-Path: <kvm+bounces-67369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 85FBBD024C9
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 12:07:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 29CC030FF486
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 10:55:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 919913DA7E2;
	Thu,  8 Jan 2026 10:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MAX2v8Ht";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MAX2v8Ht"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011024.outbound.protection.outlook.com [40.107.130.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6183C39E198
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 10:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.24
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767868671; cv=fail; b=eeoxqU7N8YSeMf1zBcU/gpYGNNiMpjossTMvJ0McvPX8N5E7GBJbyKmrg6Ju0X9Z46oWDHIdVG2QjLDQwmZvohp/+MRpsPpGuxFK3FxaxEZIbcbGFHqIhqFGkkdhfCINb8pDz+fG4a6VERUnaVb2E6DwZXwfB4drGdwPKMdJ/uA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767868671; c=relaxed/simple;
	bh=AUPklDA11BWPuQbQfIPOd36eI68HnRZbkbZoA4EwHuw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bki4fkCTEF1Gf5eIfZDQDdhL+CptnEx4LmvfaheMgOmBYMrILTsS5j2bQnjPY7f5VBxZjmVmgBqQN1JLqKfHhWXrtNVUTmHT8mE7foxo26YX6Wy06pCJyVCLjHD9W2Eqjthh41SEWWmLcIqBDvAqq4rIAwo4xhto1TStS1u2LS0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MAX2v8Ht; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MAX2v8Ht; arc=fail smtp.client-ip=40.107.130.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=aujLbe3hGtW1eE6Jg2lpoQe4IHT8rMWlQrd49yowMM3apDEr/AmJ+Mlh+Yv0OXHplR8948lZD8RB08x+cZRX3m4KqCALHGupBtmXzMiD0TNdm8CbiGANM+OSPXkKC9qMNbekeIvMtu/srDPVEqHunKE/wD44vvYmhNl55fYcJ9J1MuQ815Qt3oHnKMnbVmS03fbegNH4sQGaq+RXBNqJp/BJgzErGxZWhu3N8EkvqodieExKiUHzrrqN92IF9nOOdfBB5GNdcI45b6SJiovkQvoAig5Kt7LvIFk/k+3LL0dGZTdXRFG3eaM8lQHA8A9PwjB7pdGpsOW3w6JReBd+RA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AUPklDA11BWPuQbQfIPOd36eI68HnRZbkbZoA4EwHuw=;
 b=nQiVghza//ipxb9TDVE84Q4CqkmEKRsu7NZEm2ntR3tfhHsqurktVE63Gug9/Fh2IEQfeHKBde4dmQATxy2+cnD2cUg3r5Zu9TGLq65sNJxQVBreId8GRJubIjXCkOHbhABZT+kk4ZvEDtOiDDH1kq9bsI1tq9fUywaF1hyg3MlqphEcPHru/qwWXNXopPh5asQS4v8fX1ngeUvkx/PWm8csdPCejyxkwMneGYVoSLG+CwrEQfcNNMpTF2/YkfO+bk5PVuyCa6VViATPTUfA82SrXGV43oGxssZNJ5r9X/iAlZml3oUmX3hcsHpuWPS96UNXLIL/gp8FRUQCCpW1ZA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUPklDA11BWPuQbQfIPOd36eI68HnRZbkbZoA4EwHuw=;
 b=MAX2v8HtzO5qsqAsRoUCQsTcFtoZJfPMUSSXZ/QcxljnyUktoeGIBhRwEehD4I3b6xGFbFRFgLzScByWNzVlVK50VLyAFES2UOZO8NWWHt5CbcQFHCwuwpVUiW5AyxK2062qqFMyw7CmeGJxx2FRalrH1lNYO1Pn8OQvhZfsjpU=
Received: from AS4P190CA0042.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:5d1::19)
 by AM8PR08MB6546.eurprd08.prod.outlook.com (2603:10a6:20b:355::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 10:37:36 +0000
Received: from AMS1EPF0000004D.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d1:cafe::36) by AS4P190CA0042.outlook.office365.com
 (2603:10a6:20b:5d1::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.3 via Frontend Transport; Thu, 8
 Jan 2026 10:37:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004D.mail.protection.outlook.com (10.167.16.138) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Thu, 8 Jan 2026 10:37:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wRcbC1Hc+ApvFpQ/ZEU4HDUe1dwmkRZ0aFdNPf4taP6KIusTTtsHGvEsTbq7yYZPx/C0b8awvevbi1JmlURYcgXeP7NkPPNBAJyuyttXvPItV7T3hmSEZe5+ysONQ35AzVMnkxmd1/um71A4aw2j4ameCM3H/y4WOZ/ax25WJRw+ego4sOECovX/gLCD/DWSX/PWGfLpbq7CzhZkMUbXaTmMpVjaKlOqYuIWS2msRuu2mmry1J1tT1LUfZyAE0ClVWVJK98TLOXtiE2z/uKqiG37yvkmUD82ShZFtPblsy/gJeHFzPBvBMBCWZN1rJPht/UwmxQtoCU0eE/OcsCsqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AUPklDA11BWPuQbQfIPOd36eI68HnRZbkbZoA4EwHuw=;
 b=GkUTCM0cRvP7yh8scn6V1jf3vewnovDCYBeIFzII4ouGHQoFGSO472CHTt8mXOH30HSn/DKIk6W8tpGoQsrApig5DFOvOZ1fWmzx2jacBUPGzO4y//TJrvTHJ/Z5HXlAwSJ5T6oxVgDVkh/7k2LVp2VZ/Ji8DaUqXRFK/bzPyEgMhyiXI9CkODfVur2qK75OU4Yv+Ew/F/A9apFMoxCBdzpeAq9MGu23WAXMjXT8sFIWzjllRGA6NkSzKiF6WYAvq1a+aCqgKNQs1Dgo975iStrri2boerypjQ0qiLEv3svShSHAQ6RTa2jnC+jIV6X+YMSBzVntxLbKXIYn/eJe9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUPklDA11BWPuQbQfIPOd36eI68HnRZbkbZoA4EwHuw=;
 b=MAX2v8HtzO5qsqAsRoUCQsTcFtoZJfPMUSSXZ/QcxljnyUktoeGIBhRwEehD4I3b6xGFbFRFgLzScByWNzVlVK50VLyAFES2UOZO8NWWHt5CbcQFHCwuwpVUiW5AyxK2062qqFMyw7CmeGJxx2FRalrH1lNYO1Pn8OQvhZfsjpU=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VE1PR08MB5775.eurprd08.prod.outlook.com (2603:10a6:800:1a0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 10:36:30 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 10:36:30 +0000
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
Subject: Re: [PATCH v2 11/36] KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
Thread-Topic: [PATCH v2 11/36] KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
Thread-Index: AQHccP+APzwlx8MbOUCYBmzg2uKwhbVGrO4AgAGGXoA=
Date: Thu, 8 Jan 2026 10:36:30 +0000
Message-ID: <a47c3ece94122361d14d81cfad3ea21dae36e9fd.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	 <20251219155222.1383109-12-sascha.bischoff@arm.com>
	 <20260107111918.000037f7@huawei.com>
In-Reply-To: <20260107111918.000037f7@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|VE1PR08MB5775:EE_|AMS1EPF0000004D:EE_|AM8PR08MB6546:EE_
X-MS-Office365-Filtering-Correlation-Id: 90b15363-9375-4a92-99d3-08de4ea1efb7
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?eFIzNWpROHZIN3FyRTVLWC9uRDlDbHdzaVFtNFo0ay9mUG5MOXlzYjFYVWRO?=
 =?utf-8?B?VW1oY3BST0VLd0NFV1FsNmtiVlJQbkwzK3o5QXk0Si8wc0hBamttaUJZVE0w?=
 =?utf-8?B?YXptaU0zUllVaHNIY1NiUHRMN290aGpxUUlwZVFJZG05QVYxamxlb1dEV3J4?=
 =?utf-8?B?RC8xbWlnb1lVWnZoS1ZIQTBsVU0zT3VvNm5KdTBjOU5pVmQvN09OTTE2d0FN?=
 =?utf-8?B?WG1DNDgzU1pPdUJic28rOUd0M3dleXdhTDZpVXR6VWxQb291UVk3WWRlNTNJ?=
 =?utf-8?B?eDRMSkYwZnMzT2NxRENibnduSVV1K0M0ZEVYNi9LMzNXYUZkbFR2RDJaekYy?=
 =?utf-8?B?TCtHUEZWQ0YxSFBKTWZDdjRLMXFHeHZ2aklWallvb01UK0UyVGowSHN5azRV?=
 =?utf-8?B?aFkvbDJiWUtrM0Y4clI2UnQxciswL0owZ2kwQWxuQTBCK3BOdUtKYm9aV3dT?=
 =?utf-8?B?YTNSWmtqRmJ3eVlONCtObEJvdTBIMXRpZ3NpdGVCeTlGY3UxYTBJbDBDK0RT?=
 =?utf-8?B?UGlvbVUwRUt1SjdyNUhGWmE4TUtaYXlCRUx6ZnpYYktRdWV4c1R2Szd5elBQ?=
 =?utf-8?B?d2lENnFmMlNQVHdqNGVVcUZKWHEwaDlVaVVreVBMSlFSUDVTa21WU1U4ZjZI?=
 =?utf-8?B?ZVNsZkRMKzRXYnA4dFBwWnVrRCs2UHhGbXFDL1M2aisvakplbGtDR25HaVZH?=
 =?utf-8?B?ZUlKV3NmcStGZFI3Vy9SUmxmQ2pZMU9lWkRxaVRzODJPZGo3ZmJMSlVHb3hl?=
 =?utf-8?B?cmRGYWh4b2ZVZUU4YjJtNzVJb3FVY0psaTlnSnh3Q0tOc0NhREJsSXZEVE9H?=
 =?utf-8?B?cXFqZDZLOGd4ZmxUOHRMNjZWRTIxY0d2Zi9HcUY5UjRQVTdNaE13cFIwVTAx?=
 =?utf-8?B?TVVxdGIvS2JnVUZHSlpFQnBGWVNINkl4OVM2bmVMdGNTL3FLV3pQVWkzeEo4?=
 =?utf-8?B?UTk3VGRSTzhXdTNHRzV5aUh2TUJHOFU0dk1iQ0RMQ1RJbmdxWThzRFcrMXZC?=
 =?utf-8?B?UUg3V0laTEtLV1RHUXNkWmk0VlZyVlBuZFQ1SnY3VjlPVnNFbHYxWkgyQ2s5?=
 =?utf-8?B?SngyY3E4NDVLYkZWTk5PdExmTmp1L1UyN2syNDN0b3A4TlVHWkVnSXdnY251?=
 =?utf-8?B?bTNQMmxwZGxhdXZOcGQzcVN0Z0V1RGFVZHl2M1pxaWRLaHJpUFptZkEveTdE?=
 =?utf-8?B?aWo0L2g5aWdjdHNFVC9xZDZRZURDU2gweitSc202MFQwRTBvZWJ1TC80U2Zt?=
 =?utf-8?B?dzlHalFCRFJYWlo1b2k3MmlLTGJQbCtaV2haYVNpMHJQOWRyamJCT1pkR3pp?=
 =?utf-8?B?eDk1RnNFdDN6U3l4MFpYRDN5WFk1aWluQWJUaUNaQVo0bW9iK3lSaVFrbTRD?=
 =?utf-8?B?eHhQTTBoTFhlRlZxdkU4L3JvSktDaXlRT3M0aWVnMWxWWnBWcnVzdDMxTjJi?=
 =?utf-8?B?MlBhWGdVVk1OUitEZWxTRlRHc2NZTGlqM3FZemdqenJHT1phdlNTQXcwczdT?=
 =?utf-8?B?VmZuc0NraVZ0c0hWNHhvSmJEU2R0a2dITTUvcmtDL3FmZjBldkxtdEZweHpv?=
 =?utf-8?B?dWo2djVDbFU5WHVDL0tIZXlqanhyUHNuQy9QRWtaZWpwaE1qNkNkRVdMOXB0?=
 =?utf-8?B?OVVBRWNPT1FRVmgrM01zWDhXTUVwblVFQWZ3VEErTU82N3JTSHdqUmNiMSt0?=
 =?utf-8?B?QWhoOXdhQzU2ZEcxQTZyaXNZanN5QXZ5Nlg5bTgwSVZGU1IrSkhXNVFWaWRG?=
 =?utf-8?B?anJHd0o2MWtuMkNkd0Y2UHJkZ3Nad3lSdEdBc2dJNy9kZWI2YzlRV3FRTndu?=
 =?utf-8?B?WC93SzBSMUdxWnZXakRTbXptMmJkV3RRLytxcXZPVWtKdmFwRjNoY21jWVdU?=
 =?utf-8?B?Y0QycW9NanBCaVZxTkE0dWhOcUxtZC9lbUZ1cnUxa2FoREcrK3VNaXJBWnJy?=
 =?utf-8?B?RmRQSjJXdVhpc1RIVG1SbWQ3Z3lROEtlY2JGcDVGcjBTUUp1OWxLMnJna1ZK?=
 =?utf-8?B?WlZCdFl3UVFNMWJzQ3Y1U04xMHcxMG5yYW5ncVFLZXJ6UXArWkNCNkRDZGdw?=
 =?utf-8?Q?hPqSXu?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <BED77BE8704A9A4DA4DB5A612D11FBEC@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5775
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000004D.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	90b212b6-1246-435e-b06f-08de4ea1c945
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|35042699022|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M0doc29sV0VjMDVBeXVoQjJaKy95MFYxaDZrL1M1SThRaDdJRjBMSWswcjJn?=
 =?utf-8?B?OUlPRHU1SG9NYVlNNTNiWis2eGRaR25GY1dmaVd6eVVlcmFQdDdCSlhlc01w?=
 =?utf-8?B?bmhRSnNUZU8vcFhnTSs5ZTV1WVk5b2Y2dHdkajB0U283ci9lNWNlQnVoQm85?=
 =?utf-8?B?RDA3RGhZRDRSL3I3VWgvZ1RxNm9KUkNKYk42MlE5WldHM04ya0hmZVJoZ1Z0?=
 =?utf-8?B?MEV6eTFRWmMxcmx3eGJ2dzJXTlVrYXlLdTVLbTREYjZIMlBIOUNaSWdSazJl?=
 =?utf-8?B?S1p1cTNLRlRRS1BYd3NYY2t5TjhqbXY1UWdWczEya29wRDhIQTgxVU0xUGNC?=
 =?utf-8?B?STFMRGcxYVBwZGIyU09haFFhazIwUC9sbVhycVl6SExqM1BrbnN3b3lQdm5L?=
 =?utf-8?B?ZWRIOWc1WHZFaU9lRzJvK2c2NzZIcXRGMU9MczdJR1djKzVDVlh6L0JqQVZC?=
 =?utf-8?B?WWNsUDRhcEhKNktIZzladFRScVJXYXMvd2N1K1F1d212WENpWXY3T2NPMjUx?=
 =?utf-8?B?cUg2MzV0bFNyY0t2WTVPTWZ3dU5vOHFZTVVOMi9RcFBoeWdqL0tDNzhJMkY5?=
 =?utf-8?B?NzhqRGRSdWhCS0J3eEJrbi9OeDZDMXdJVFppbUZUMHZaUmFyR1ZxTkV6VTRG?=
 =?utf-8?B?bHJqQVBOcFRuQmJJOGFMdmxlVXp2NkRTcGxIdHU4eUVhQVpQVGZTaDliWXBK?=
 =?utf-8?B?Ykkwd0ZaQVliVDlLeEtTeWZERnZUSSswcUZDUDRicVV1UE9aRmFNL2VYNHI4?=
 =?utf-8?B?dnlHVmpLckdHbFpCRmhDYXpDSFNEVmRFVDlOMkdSRXRFTWN2enhIY0FpMGg5?=
 =?utf-8?B?YkwyeWhQbUoyaHhlcFBPWG9uaVNSMmdLYlhEMkJQRjhVRXdLWWxBRzg2Y1E5?=
 =?utf-8?B?dG5DMk1oTldOVmhGUm4zMUNoVEh0aFJmLzRKQU8zZzFsTWhoWGdaYXZBbit1?=
 =?utf-8?B?SHBPUUs3RTBOb1p1bWt4djJKOW5CS0N4RUJtajRDNXI5S0R3Q0Vzd3IxUGVm?=
 =?utf-8?B?V2xhNHBzcEwvRDZtVDIzd1VsZmJIeDZ2THV1MzdrQlNyMzRuZFpDbkZaYndz?=
 =?utf-8?B?V1BrOEdIUDBrVjdJSU9FM1ovVGNqT3VRSExJbjFsL1lIT2txenpoeFpZNDNL?=
 =?utf-8?B?cG1RZ0QxS0hWVjR1VDJwcHJWNTEwdmhpUE1NN21MOVZKNlVxRk9EQnFOODRj?=
 =?utf-8?B?T3A4c25TOHYzRWdySEhNOE5pc3dXamM3MWpEa3lCSHhtM1NjWmRhVWw4T003?=
 =?utf-8?B?S09EcFFINHR4OUJFWmlNOGcxdGRzY0luZG9iZG5vNlYrUzliV3l0eXJqZnZC?=
 =?utf-8?B?NTU1a1k5dG9zK3gwa2llQ2V1UUw1b3E0SWNNNWtTbXhPZ2FLdWVhOGdZTUcr?=
 =?utf-8?B?cERkdXZCL0RvQVRVM2FxekppNDZobUN5Z3N3Y2dwelN6a242dFJzK2VhZTBO?=
 =?utf-8?B?NFdHVSsxKzVyQkRQZTVpd3FsSkJSdnJ4Ri8wd1hONDU1U3hjYldNdVJaeDBM?=
 =?utf-8?B?M1RxNXhac3dLMkE3QmJYa2tnRkkrUGF2cForMWl0NytxNXlSZGp1dW04NlNI?=
 =?utf-8?B?TVVmZjdCaGdxMUdQcktPcWt5NTNBTmE4RlVkRVRrUE10cDBNa2RmVjBWcm1j?=
 =?utf-8?B?VjR0N0hmYmdPVFhDbDBpYytGa2pKNW8xbXRQZ3h5UUV3V1EzUk10c0VoSE0x?=
 =?utf-8?B?cEJvOGNmcFRvRUVsWDErYjNEZlhUeGtBdWszSkdaVE5qUTVBZUNnTm84bVRG?=
 =?utf-8?B?cWxKOE5GVlVzUXVVRmFwOUc1aW4ySVFUVUQreEtjeXlJSE0waTJqaktReHhO?=
 =?utf-8?B?c1B3cVFZbHdPVGp2cFhxcDh4L3REMnhzRkZlR2liQVBZMXBWRTFjZjExMXN3?=
 =?utf-8?B?VWVTeE8zZnp1TjZ3d0JYRHo0dkVBOHkrNTBKWVZaSUd0YWw4bzZLVGtUcEty?=
 =?utf-8?B?YytBdFBRNi9PSjNMeVc1REFsbHN4MXlydk1aSGZ2TWlaSnFScVNRSitKN1Rh?=
 =?utf-8?B?TEt6SEUyL2NrUzV1ZThJTGZJeC9uZCt6T3pvd0VYMkRFMldvdHplcTVDY3FJ?=
 =?utf-8?B?U202b3U2djMxWUQxN0dIYmlPdDQ0a09va0ZiSk9QNUNXQ0Q5N0oydzhBNVFR?=
 =?utf-8?Q?X5Qw=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(35042699022)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 10:37:35.0622
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90b15363-9375-4a92-99d3-08de4ea1efb7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6546

T24gV2VkLCAyMDI2LTAxLTA3IGF0IDExOjE5ICswMDAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBGcmksIDE5IERlYyAyMDI1IDE1OjUyOjM5ICswMDAwDQo+IFNhc2NoYSBCaXNjaG9m
ZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiANCj4gPiBFeHRlbmQgdGhlIGV4
aXN0aW5nIEZHVC9GR1UgaW5mcmFzdHJ1Y3R1cmUgdG8gaW5jbHVkZSB0aGUgR0lDdjUNCj4gPiB0
cmFwDQo+ID4gcmVnaXN0ZXJzIChJQ0hfSEZHUlRSX0VMMiwgSUNIX0hGR1dUUl9FTDIsIElDSF9I
RkdJVFJfRUwyKS4gVGhpcw0KPiA+IGludm9sdmVzIG1hcHBpbmcgdGhlIHRyYXAgcmVnaXN0ZXJz
IGFuZCB0aGVpciBiaXRzIHRvIHRoZQ0KPiA+IGNvcnJlc3BvbmRpbmcgZmVhdHVyZSB0aGF0IGlu
dHJvZHVjZXMgdGhlbSAoRkVBVF9HQ0lFIGZvciBhbGwsIGluDQo+ID4gdGhpcw0KPiA+IGNhc2Up
LCBhbmQgbWFwcGluZyBlYWNoIHRyYXAgYml0IHRvIHRoZSBzeXN0ZW0gcmVnaXN0ZXIvaW5zdHJ1
Y3Rpb24NCj4gPiBjb250cm9sbGVkIGJ5IGl0Lg0KPiA+IA0KPiA+IEFzIG9mIHRoaXMgY2hhbmdl
LCBub25lIG9mIHRoZSBHSUN2NSBpbnN0cnVjdGlvbnMgb3IgcmVnaXN0ZXINCj4gPiBhY2Nlc3Nl
cw0KPiA+IGFyZSBiZWluZyB0cmFwcGVkLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhc2No
YSBCaXNjaG9mZiA8c2FzY2hhLmJpc2Nob2ZmQGFybS5jb20+DQo+IEhpIFNhc2NoYSwNCj4gDQo+
IFN1cGVyZmljaWFsIHN0dWZmIG9ubHkgb24gY29kZSBmbG93IHRvIG1ha2UgaXQgZWFzaWVyIHRv
IGV4dGVuZCBuZXh0DQo+IHRpbWUuDQo+IA0KPiBKb25hdGhhbg0KPiANCj4gDQo+ID4gZGlmZiAt
LWdpdCBhL2FyY2gvYXJtNjQva3ZtL2NvbmZpZy5jIGIvYXJjaC9hcm02NC9rdm0vY29uZmlnLmMN
Cj4gPiBpbmRleCAzODQ1YjE4ODU1MWI2Li41ZjU3ZGMwN2NjNDgyIDEwMDY0NA0KPiA+IC0tLSBh
L2FyY2gvYXJtNjQva3ZtL2NvbmZpZy5jDQo+ID4gKysrIGIvYXJjaC9hcm02NC9rdm0vY29uZmln
LmMNCj4gDQo+ID4gQEAgLTE1MTEsMTEgKzE1OTUsMTkgQEAgdm9pZCBrdm1fdmNwdV9sb2FkX2Zn
dChzdHJ1Y3Qga3ZtX3ZjcHUNCj4gPiAqdmNwdSkNCj4gPiDCoAlfX2NvbXB1dGVfZmd0KHZjcHUs
IEhBRkdSVFJfRUwyKTsNCj4gPiDCoA0KPiA+IMKgCWlmICghY3B1c19oYXZlX2ZpbmFsX2NhcChB
Uk02NF9IQVNfRkdUMikpDQo+ID4gLQkJcmV0dXJuOw0KPiA+ICsJCWdvdG8gc2tpcF9mZ3QyOw0K
PiANCj4gTmljZXIgdG8gYXZvaWQgbW9yZSBjb21wbGV4IGNvZGUgZmxvdyBhbmQganVzdCBtYWtl
IHRoZSBuZXh0DQo+IGJsb2NrIGFuIGlmLg0KPiANCj4gCWlmIChjcHVzX2hhdmVfZmluYWxfY2Fw
KEFSTTY0X0hBU19GR1QyKSkgew0KPiAJCV9fY29tcHV0ZV9mZ3QodmNwdSwgSEZHUlRSMl9FTDIp
Ow0KPiAJCV9fY29tcHV0ZV9mZ3QodmNwdSwgSEZHV1RSMl9FTDIpOw0KPiAJCV9fY29tcHV0ZV9m
Z3QodmNwdSwgSEZHSVRSMl9FTDIpOw0KPiAJCV9fY29tcHV0ZV9mZ3QodmNwdSwgSERGR1JUUjJf
RUwyKTsNCj4gCQlfX2NvbXB1dGVfZmd0KHZjcHUsIEhERkdXVFIyX0VMMik7DQo+IAl9DQo+ID4g
wqANCj4gPiDCoAlfX2NvbXB1dGVfZmd0KHZjcHUsIEhGR1JUUjJfRUwyKTsNCj4gPiDCoAlfX2Nv
bXB1dGVfZmd0KHZjcHUsIEhGR1dUUjJfRUwyKTsNCj4gPiDCoAlfX2NvbXB1dGVfZmd0KHZjcHUs
IEhGR0lUUjJfRUwyKTsNCj4gPiDCoAlfX2NvbXB1dGVfZmd0KHZjcHUsIEhERkdSVFIyX0VMMik7
DQo+ID4gwqAJX19jb21wdXRlX2ZndCh2Y3B1LCBIREZHV1RSMl9FTDIpOw0KPiA+ICsNCj4gPiAr
c2tpcF9mZ3QyOg0KPiA+ICsJaWYgKCFjcHVzX2hhdmVfZmluYWxfY2FwKEFSTTY0X0hBU19HSUNW
NV9DUFVJRikpDQo+IEdpdmVuIHRoZSBhYm92ZSBzaG93cyB0aGlzIGNvZGUgc29tZXRpbWVzIGdl
dHMgZXh0ZW5kZWQgSSdkDQo+IGJlIHRlbXB0ZWQgdG8ganVzdCBnbyB3aXRoDQo+IAlpZiAoY3B1
c19oYXZlX2ZpbmFsX2NhcChBUk02NF9IQVNfR0lDVjVfQ1BVSUYpKSB7DQo+IAkJX19jb21wdXRl
X2ZndCh2Y3B1LCBJQ0hfSEZHUlRSX0VMMik7DQo+IAkJX19jb21wdXRlX2ZndCh2Y3B1LCBJQ0hf
SEZHV1RSX0VMMik7DQo+IAkJX19jb21wdXRlX2ZndCh2Y3B1LCBJQ0hfSEZHSVRSX0VMMik7DQo+
IAl9DQo+IA0KPiBGcm9tIHRoZSBzdGFydCBhbmQgYXZvaWQgZnV0dXJlIGNodXJuIG9yIGdvdG8g
bmFzdGllcy4NCg0KWWVhaCwgeW91J3JlIHByb2JhYmx5IHJpZ2h0LiBEb25lLg0KDQpUaGFua3Ms
DQpTYXNjaGENCg0KPiANCj4gPiAJDQo+ID4gKwkJcmV0dXJuOw0KPiA+ICsNCj4gPiArCV9fY29t
cHV0ZV9mZ3QodmNwdSwgSUNIX0hGR1JUUl9FTDIpOw0KPiA+ICsJX19jb21wdXRlX2ZndCh2Y3B1
LCBJQ0hfSEZHV1RSX0VMMik7DQo+ID4gKwlfX2NvbXB1dGVfZmd0KHZjcHUsIElDSF9IRkdJVFJf
RUwyKTsNCj4gPiDCoH0NCj4gDQo+IA0KPiANCg0K

