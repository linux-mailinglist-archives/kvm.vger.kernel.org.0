Return-Path: <kvm+bounces-67586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 208B8D0B743
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:00:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E45C030185E4
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:00:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AA45364E97;
	Fri,  9 Jan 2026 17:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ahBJ41Xc";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ahBJ41Xc"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011028.outbound.protection.outlook.com [52.101.65.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04D235A939
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.28
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978036; cv=fail; b=nkR+vr/ZHqn3d4SMY+dWtusi7LlQEX7avYKw0pGhOFbWfTTva/LZlYgH35O29JtpW/SBj7lLB2jzBVDGkhdB0J/aImiQbVwV7QMvjqZzQ9AWgEry6OpIGldccWcFUMRQc1qesU8STOx6D/GIH4KLyG8uUKkn8wxKqdyzjrJpeYQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978036; c=relaxed/simple;
	bh=qFjBM6NM5RS9z8Fi5M+l2uq6G7dt3twGVf09vqHTEhU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uGnIKigl8M2hADXVtxTt9b1UaxttdabWqgijgvrhQoN4kdGdD0Sw9+sdijcHsQt2Iz5WJHg1LCPFLX1gSDUzqjN2FdQ1wFH2DPRhldkXXU7CibrhQmbY5AXq9LQelw+jYk+Fx8LRNTVgryqpfGe2DOQc9mfXyGxVP+BM3E802Wo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ahBJ41Xc; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ahBJ41Xc; arc=fail smtp.client-ip=52.101.65.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=FIv0DIblaiADOD9RXrRc6H4GtL8WLOa/gpd+ZePiPONQ4v1nJ6sQrySrOS5RrrIFC/pRzcv3FMXTFLb68/RkAdEI5dypa8LKmVG2HmDvXH18pjkMp6m7RDVoWloBrYzjLeP+PXQ77PJsubIl0UNni4k2Cgw0HjP94G6ipWnpEAmj8tYRi5yaJQBsrJqNCDR9Xt4frwF5OPUO/VmH6OIB2l1U+vVYMUifBfZvrnwFnVhSZ4Bt5hT7d4uYvqfeN01RNR8iymnBm1NvnbTHeLqKIVze1ruGawLFKMossDatZ9NdC/tJWBm+75NWXmP37L61yGubcsDrJLUA6onfwC+13A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qFjBM6NM5RS9z8Fi5M+l2uq6G7dt3twGVf09vqHTEhU=;
 b=PD4uGu5oNxcc9AGNLBVCSG9m2JjlFjKx+tCL8O9qAMb4GLUrgV6a4E8kH6QuW6m/YAcUIxyjjMtfnaaplY8z79AxBq408ZVwajVjpb0lMVAo/sxTehkH64mYVK3S1lIyUmiZjbIDt82NAB4GjXQWc7nOGApABY72BTIX1gMWP0ihrHMKcBd45rNn3VpXqGtQDmNcx1Lcxizu8HGoI51OGDrjOt2U8wMxLUAcOJQviYcRwh7DWs1GBM8ipa4fpqYZSk1MB6+7stCQJQwQxh98xIWUT+GUeI3911CFsWYSiyM/lbrGDRJERR1o0IGsQaX44kKM35j6rKUUfBBgLETW+A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qFjBM6NM5RS9z8Fi5M+l2uq6G7dt3twGVf09vqHTEhU=;
 b=ahBJ41XcNCuqrUM+affagMPq8MRH1txujhBaky31tGE6gYCWE3IEF6HRfD6wXXEAN4pTL4Mm2R6AjXf2QWzE1b2kI9gwj4DSM1pgJoT7DLY76/bKvKrN9Qc6pSkwWQuVGwNHNpRhA5CI35tev2mGgcs6XaoyHIXT31Wh4gzrLok=
Received: from DB3PR06CA0035.eurprd06.prod.outlook.com (2603:10a6:8:1::48) by
 PAWPR08MB9663.eurprd08.prod.outlook.com (2603:10a6:102:2e0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.5; Fri, 9 Jan 2026 17:00:26 +0000
Received: from DU6PEPF00009529.eurprd02.prod.outlook.com
 (2603:10a6:8:1:cafe::98) by DB3PR06CA0035.outlook.office365.com
 (2603:10a6:8:1::48) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.5 via Frontend Transport; Fri, 9
 Jan 2026 17:00:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009529.mail.protection.outlook.com (10.167.8.10) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1 via
 Frontend Transport; Fri, 9 Jan 2026 17:00:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iAHyn3EXfinNn7RjJU8vvxwX7EXv++GJrF0wYfQgcG+mIfiF6ioNmB5s0FXghVQy+dFJ/SDIzakg/qXrt1S3X9ZEJdGFSsfZh3ZjbxTjE6mmALvUN9hN605IsGrm7VQ2sFsl13aahdgC/I9p46FdUNSoT8YYXbw4mGSCIDRV9DPI3+r9Sdc1heLNWZ4Jr+nZBBQ85fBw5DMrSJNrsLl9695HAl/7IBjwy7OKFikXTDd+v554VR0fMNYNz2B2Lf0uY1A/Xv8R572EP8hiLDEib8pwcoZCeOVCHkfHYpF2xR5XawHSXDbNJXx+3oTXOFY+f+LRtQmLYplsfDqe1SaEFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qFjBM6NM5RS9z8Fi5M+l2uq6G7dt3twGVf09vqHTEhU=;
 b=L+fCwUTIJRlbhf8EYgCDnmDULWvOq0N5lboTtyMFxUUzlnVI8Vk8O65wwZ5j4lpmGqzmO7Ch9Z7dWh9ikdOEmguEF5+G/bXzkIUn5++/u9qnig16132Li5hTMYVRniyRxL2Ja+wlI2A3BZpL+zQvp0S/xeXeLs4cMWsfr3GYFcpX2dIn+Ta8qVD0RT8K3j+T1Rw2NLDf/BVM9NO8eEPId54OgItg5FfN1gxsV+xi1wPqs3rbxn8l9pGEDnD+ztEChe4don6MnJo5DfIoBXrvsSUzzhGhufrGP5KXVJLDYmcbSenT/thpiOUs4G7mg6tNNnBsdvWmz7SHcfXrEBpyeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qFjBM6NM5RS9z8Fi5M+l2uq6G7dt3twGVf09vqHTEhU=;
 b=ahBJ41XcNCuqrUM+affagMPq8MRH1txujhBaky31tGE6gYCWE3IEF6HRfD6wXXEAN4pTL4Mm2R6AjXf2QWzE1b2kI9gwj4DSM1pgJoT7DLY76/bKvKrN9Qc6pSkwWQuVGwNHNpRhA5CI35tev2mGgcs6XaoyHIXT31Wh4gzrLok=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DB4PR08MB9333.eurprd08.prod.outlook.com (2603:10a6:10:3f6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Fri, 9 Jan
 2026 16:59:23 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 16:59:23 +0000
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
Subject: Re: [PATCH v2 22/36] KVM: arm64: gic-v5: Trap and mask guest PPI
 register accesses
Thread-Topic: [PATCH v2 22/36] KVM: arm64: gic-v5: Trap and mask guest PPI
 register accesses
Thread-Index: AQHccP+DJ+d1Bl/alUKhapZrPXwVYLVG73+AgANBHYA=
Date: Fri, 9 Jan 2026 16:59:23 +0000
Message-ID: <95c2e5eb3edba62a3cf41f90859018d64ea1ccb1.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	 <20251219155222.1383109-23-sascha.bischoff@arm.com>
	 <20260107151733.00003028@huawei.com>
In-Reply-To: <20260107151733.00003028@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|DB4PR08MB9333:EE_|DU6PEPF00009529:EE_|PAWPR08MB9663:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c48ee5c-5286-4baa-1940-08de4fa09622
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?czcydldSZGkwSmJhQmY3TGhHY2FOOVArMVhCeEJiNUNRRTlHQjF1M1hWU0xC?=
 =?utf-8?B?TXBydnBMdGlla3dDQTRleU1rc1A3L3VaSXZ3RmU3cGhETm5OUXRDZlBINzVj?=
 =?utf-8?B?c2YxRGpwZ1c2ck5zZDhYeFg0SlFlcEw5ZWc0U3dDd0xUN1F1eSs2NHVsWVlh?=
 =?utf-8?B?YTRoc0ZvTkorU2RqTFYzQS9Fd0RzdWZEWDdQOVg0YlVDaytJd1ZheU56NEVn?=
 =?utf-8?B?L1dCaVhZNFMwUnZYQ01EcGExRjhpSmxSZXdRQkhDaGZhc0pjZGpGWWpUa0RN?=
 =?utf-8?B?dWk3QVZGZEFHZzVuWEV5ckg1aE9WQjBWdzROcTdQSUhvQzdvcWJURGtkeW45?=
 =?utf-8?B?cllzcnAveVZsbHh2Qk9tajR0dmxYWTN2U3dsNnBNaVNOL3ltNFp2SG16ZkU4?=
 =?utf-8?B?Qk84ejNYZU41M2thL3EybUJDY2RLVzRhaTY0OW02V0YzNEhmVk0wNFRkLzNP?=
 =?utf-8?B?NmxJNUhqaUd6S3o3clY3V1ROM3dGNmdQZ3UyQkhKWFBkMngwK2ZjbU1xaXYw?=
 =?utf-8?B?TFRnUFJBSGxGblNZQnVQYU5kbmR2eGlWckJyM2oxbGN3UUVsZjloR2NJT1Jk?=
 =?utf-8?B?MjF1dVl3TTl3VktNY2ZmR0hPcHZKMmEvdzZGekhsVDQ4dlVzc1hadm1EL0xa?=
 =?utf-8?B?WFhiVDNWVXdiQ05sUnc0bkd4cUVwQ0tMWEJqbi9tbHhLZUZLR21FY0xpNjhm?=
 =?utf-8?B?UVdzL2JZWXdRT290RVl4a20wQWIrWUMzbDdZaU5rYlg2RlpQNWZWNy9La3I0?=
 =?utf-8?B?Nmc0SVhHWnE4c1dvYklPaDhBWEtRbmpLRWVyNmZ2cGJDNTY3bEN0R1JBT01P?=
 =?utf-8?B?Ny93c21PWDB1TGwvSjJ2d2RwMkxXMEtYYWtiMkU4MXBKY1NWL3c2ZUM1V0Zr?=
 =?utf-8?B?SmIzVkVLRWlXendCc2JQUVVWWFhlSVQyK1RucGVRWVVwakh5dnlGNnNweW5h?=
 =?utf-8?B?c2RGYmpkZFMzNldXU1IrOWlMSHJiTUI0ZzNRWGJiendIQi91QUJaQVAxOENW?=
 =?utf-8?B?eHV3eFNteC90bGUzN09DbHp2YVVldDBXZ0l6ZlZPdzVsb0xDbnkrODA5aHpK?=
 =?utf-8?B?MGNyKzBwTmo2Q1d1RCtvc2dzVHBmQ2dzZEE3bk1pQk5vRVhqZEgwLy9vTGZO?=
 =?utf-8?B?RGxWSnlPK3hmUzMySWhIL0JEMHU1c0NZNGI2RFl5WGdxbWFmZ2xSSmI2OWFm?=
 =?utf-8?B?ZzB3UitjTytOdEdQUkJ2WGpCY2ZGVlF1dFlFZHdLMlRuY0Z2NHVzNFlNZkZN?=
 =?utf-8?B?MjN4cHI2TktiS2tmeVFZYVdVQkVCemRYRGdhV2dGK2ZpUFB3MXdoQmhoSUQ2?=
 =?utf-8?B?QnZtUzY5TXdzVFZVSlBWNVRrY2cwTVJlb0RQZTNUMVJkNWhMZkZ2TzNGbDJ0?=
 =?utf-8?B?bDlJdDgxcnN0dko3b08rZGFQUStRNmdQZCs1MFNLRkk5d2Ivd29KK2pBWFV5?=
 =?utf-8?B?VFl1U1d3ZmVUNEJXdVVwQ0dnaE00YUJOZk42cVlOd0p1aEk0UlVsdFNCVVJK?=
 =?utf-8?B?MkNHMFBRSnQ2ZCt3RTN0cXVZUlB0QXNUcUpQeXpFcWpKNnNmSkVFdDVNajEw?=
 =?utf-8?B?ek4rWEhmclJlUzhhTmJFcVhpQTNMWXhCR2p3MHJ3L1VNYVVBaDU2cmFDdWZp?=
 =?utf-8?B?UmQyUGNFUjZ5RVAyZXdjREdhVzdRTVdSL1Z5c0gwampHMXlndTRIU1dFT3ZM?=
 =?utf-8?B?OVcxcGhHQ0FiYTFhemg1V29KZHdrbUsvSDRKUmZRN21GUkEzd1dpNHN2bEV3?=
 =?utf-8?B?ZUk1aGRXK3JYRC9idlRPQThGRUxwTG9GczRQL21meXlIQy9Dai8xNlltL0Nt?=
 =?utf-8?B?bUF0VXVUYURuUCtaTUlmUjZ1cFh5WjFLSUtYbFNNb0NBMkxPS3JoZElmTHhX?=
 =?utf-8?B?RnFXU1MzM1RXRVNkcWMxZ2pVV1NTTURGOVF0NWxyR1ppZzlLb3NmZDhxak1y?=
 =?utf-8?B?SkJBckh3aTFkR0FlbmErL21iWVNTejNjd0J4djlieXR1QmhvWnZFRERVM2lz?=
 =?utf-8?B?b0M0UUVrZFZkcnNlN0trYkNCcXRicWVlbWxNNllibDlvVEpKWDV2ZUZMSjJ1?=
 =?utf-8?Q?LF8IIs?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <2E9E871DDFA8874FA1BDF9B3CE9421E4@eurprd08.prod.outlook.com>
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
 DU6PEPF00009529.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	00e5f1ce-f646-4719-0872-08de4fa070c4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|14060799003|36860700013|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NkcyOG1MbGJiTzRTb2E2TFZPck1kSzd2ZDVHMUpVdmFIemR1NHkyRUw4YlV1?=
 =?utf-8?B?ZzdFcVM5QzVOdFpZVWtiWngreXBNRzQ4aVhlY2l0a2JwYU1oNWxxb1NkbnFP?=
 =?utf-8?B?VzZjenplaENZSStvZHZJUUNUTEZjZk90cmEwQ0pUNEx0TlJQaGdyQitZdXpw?=
 =?utf-8?B?a1oxdjRlVS81WmdBVlFUWlRzcnFlMitQUVVJWHBsbC9RbnpiWjJid1YvQmdC?=
 =?utf-8?B?ZlJBa1lHY2JXVW1YaE5HSXB4a1BXWS90eS9zVW9hUEJrWEM1SXIxUUtsYWhW?=
 =?utf-8?B?NDlha3lWTlFOSysrYVNobTI3ZzlvYzh6YUhmaHNVSDZpbmxPWU5sbzZneEhs?=
 =?utf-8?B?Y3FyNVNHczhRRmVnTTBhakZ5bzB5dk5HWTBrWkVyZ1Y5ZTVNNy9FejhaN1FP?=
 =?utf-8?B?ZE5DUUJiejRvNEE5TW1IV2dSWXJQckRzWG1PQjFrUmxsZ0pJOXNsVnhDcVNQ?=
 =?utf-8?B?NjdNQkhVTFFnUjdwSkMwVjkxdHZ2WXBQQlQ5SWcwd09FTGJhMjhJL1QrWGo5?=
 =?utf-8?B?a2RhNnhtcFZPWEVDYmNCRlplUDZLYXA2MFd3U3p3YjJEVUJKTXZqS1JpRGRY?=
 =?utf-8?B?dEE1a0FZRVB2bXA3K3RCVldENWNsb1VKamhDVzR0VkljMXlMQ00wdHVaaVhY?=
 =?utf-8?B?bFpNTlRrZVBrQ0xRM3ZpMHpTUTZYZEZrTHFFYmIzN2dTOXZ5Y0hTVjVZaUZS?=
 =?utf-8?B?UmZKbXU0NkdSaUhsbWNMdThsK3l4SG9lUkxQeTJMMEdGL2dRd1pjRk12akQ1?=
 =?utf-8?B?UXd0N3R2N2ZBRVFSZVZFTWFtcFFVY3FzUzFhaFMwSVBQdnNvRzRTaE1KdXRV?=
 =?utf-8?B?R1BHVks4RFFyVWpkQTc5QjhZK1lERm1zM2sxanBBcFdkQ0thdmdIYkpxS1kw?=
 =?utf-8?B?S1B2TlUweUpVdXg3WFVIWGM5SjBTZzRGZE5pT3ZKbmRuc0tIcUhrQURKSDJy?=
 =?utf-8?B?eWEvMTg3RFRET3ZIMVBreXFOeXRQTWtoMUhmM25EamZoVnpxRDNWalhoZ2E0?=
 =?utf-8?B?SVo1UG5abzFzUVd1L3hNWmVnRVB2akpKS291czI1Q1RLQWxwR1N3SVhYc1ZJ?=
 =?utf-8?B?Vm9pUXJtUXpvbTFxcjgyN1IvWkhQMldENUZzb0kzQVdmUkljOFpZU2NCWnRz?=
 =?utf-8?B?eW94MC9rUFd6OHAreHFUMEZyeU5yMHdseE5vVXdPc3lReEt1bXVxc0JacnNm?=
 =?utf-8?B?UVUrcTdTUkE3ZTY5T1F2U3ZSSGQxaHcrT1Jmckd1VEkwREJ5bzNTaEdFQ3Bt?=
 =?utf-8?B?L0NYcGRjQmRuK1dzcVFRdlpuK2lhQnMxc0dlK0hUS2UxUUlIeDRjTkdLTmlE?=
 =?utf-8?B?NVR3VVdYN1pWeDR3YUlpWnpEMkwzd2ZTUml6Y0xPMUVXR3RWc1IxNHBrOVpl?=
 =?utf-8?B?a3NZVHZNekFFZmpNZEZ0VEdwY3A4ZG9QNGJzWUlJeWY5VUJEVzFrbXNCQ0Ru?=
 =?utf-8?B?allFMWV0bUJ3WitLaVFHV2pTUVMzaVZKWWE4em1MbXRhNkpNTUd3YzI2YmlV?=
 =?utf-8?B?OGt3aTkvcWxGbkZSbFlqY0VYem9sN3oweDZXNG00aU9MMW1nU2tQeG5rd1ZH?=
 =?utf-8?B?a3RIY2hLbklzUllGUi9iQjZGalFLbFhjU0w4eVJocmN2SXFsV3Z2ZnR3TVN0?=
 =?utf-8?B?VS9Eb1ZScDBKbVNNQUg2VGdYZlczMVBDM3JvL0Z2ZEI3N0FaQmJNN1QrczhS?=
 =?utf-8?B?QlB1MWRqQVdEa0RZNjNDYjYxTndlOU9xajdyZGh5elpFMG9JN3Jnd1kwYnZE?=
 =?utf-8?B?TXVZTHQzNGdyWndobDM4TEVMUHEwSE41aGo1Y3Yzc3RpaVZBc3pXMkJienRU?=
 =?utf-8?B?VlNuRXJKNkJLS0Z5bEV4Z3F6NzVCQ2xuQVlYSTNmaFNYNnFKMnhTam14Um44?=
 =?utf-8?B?OTNKWHNsZlFQTnllY2V5NmFqL0NIcFVXQ3ZISGs3MjVxUXhKN3FDZTluRlNk?=
 =?utf-8?B?NHNsTE9veEpQZ3cxTXAxcXcyME5rWW9RL2thVlV2eXBiWWIzUkhGL2w5bERi?=
 =?utf-8?B?REYyQ2lDSURoOG11Tnh1UDR5dlZMMnlkdjZrMzZEeEZVWStJbzYxMW1KNXNx?=
 =?utf-8?B?Y2hnS0N6aFAvZFdiMUk3cHczcGtFWGhrRHl4MVpCRkZwVk9CZENLWmc3WTAz?=
 =?utf-8?Q?7Rhg=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(14060799003)(36860700013)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:00:26.4239
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c48ee5c-5286-4baa-1940-08de4fa09622
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009529.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9663

T24gV2VkLCAyMDI2LTAxLTA3IGF0IDE1OjE3ICswMDAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBGcmksIDE5IERlYyAyMDI1IDE1OjUyOjQzICswMDAwDQo+IFNhc2NoYSBCaXNjaG9m
ZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiANCj4gPiBBIGd1ZXN0IHNob3Vs
ZCBub3QgYmUgYWJsZSB0byBkZXRlY3QgaWYgYSBQUEkgdGhhdCBpcyBub3QgZXhwb3NlZA0KPiA+
IHRvDQo+ID4gdGhlIGd1ZXN0IGlzIGltcGxlbWVudGVkIG9yIG5vdC4gSWYgdGhlIHdyaXRlcyB0
byB0aGUgUFBJIHJlZ2lzdGVycw0KPiA+IGFyZSBub3QgbWFza2VkLCBpdCBiZWNvbWVzIHBvc3Np
YmxlIGZvciB0aGUgZ3Vlc3QgdG8gZGV0ZWN0IHRoZQ0KPiA+IHByZXNlbmNlIG9mIGFsbCBpbXBs
ZW1lbnRlZCBQUElzIG9uIHRoZSBob3N0Lg0KPiA+IA0KPiA+IEd1ZXN0IHdyaXRlcyB0byB0aGUg
Zm9sbG93aW5nIHJlZ2lzdGVycyBhcmUgbWFza2VkOg0KPiA+IA0KPiA+IElDQ19DQUNUSVZFUnhf
RUwxDQo+ID4gSUNDX1NBQ1RJVkVSeF9FTDENCj4gPiBJQ0NfQ1BFTkRSeF9FTDENCj4gPiBJQ0Nf
U1BFTkRSeF9FTDENCj4gPiBJQ0NfRU5BQkxFUnhfRUwxDQo+ID4gSUNDX1BSSU9SSVRZUnhfRUwx
DQo+ID4gDQo+ID4gV2hlbiBhIGd1ZXN0IHdyaXRlcyB0aGVzZSByZWdpc3RlcnMsIHRoZSB3cml0
ZSBpcyBtYXNrZWQgd2l0aCB0aGUNCj4gPiBzZXQNCj4gPiBvZiBQUElzIGFjdHVhbGx5IGV4cG9z
ZWQgdG8gdGhlIGd1ZXN0LCBhbmQgdGhlIHN0YXRlIGlzIHdyaXR0ZW4NCj4gPiBiYWNrDQo+ID4g
dG8gS1ZNJ3Mgc2hhZG93IHN0YXRlLi4NCj4gDQo+IE9uZSAuIHNlZW1zIGVub3VnaC4NCj4gDQo+
ID4gDQo+ID4gUmVhZHMgZm9yIHRoZSBhYm92ZSByZWdpc3RlcnMgYXJlIG5vdCBtYXNrZWQuIFdo
ZW4gdGhlIGd1ZXN0IGlzDQo+ID4gcnVubmluZyBhbmQgcmVhZHMgZnJvbSB0aGUgYWJvdmUgcmVn
aXN0ZXJzLCBpdCBpcyBwcmVzZW50ZWQgd2l0aA0KPiA+IHdoYXQNCj4gPiBLVk0gcHJvdmlkZXMg
aW4gdGhlIElDSF9QUElfeF9FTDIgcmVnaXN0ZXJzLCB3aGljaCBpcyB0aGUgbWFza2VkDQo+ID4g
dmVyc2lvbiBvZiB3aGF0IHRoZSBndWVzdCBsYXN0IHdyb3RlLg0KPiA+IA0KPiA+IFRoZSBJQ0Nf
UFBJX0hNUnhfRUwxIHJlZ2lzdGVyIGlzIHVzZWQgdG8gZGV0ZXJtaW5lIHdoaWNoIFBQSXMgdXNl
DQo+ID4gTGV2ZWwtc2Vuc2l0aXZlIHNlbWFudGljcywgYW5kIHdoaWNoIHVzZSBFZGdlLiBGb3Ig
YSBHSUN2NSBndWVzdCwNCj4gPiB0aGUNCj4gPiBjb3JyZWN0IHZpZXcgb2YgdGhlIHZpcnR1YWwg
UFBJcyBtdXN0IGJlIHByb3ZpZGVkIHRvIHRoZSBndWVzdCwgYW5kDQo+ID4gaGVuY2UgdGhpcyBt
dXN0IGFsc28gYmUgdHJhcHBlZCwgYnV0IG9ubHkgZm9yIHJlYWRzLiBUaGUgY29udGVudCBvZg0K
PiA+IHRoZSBITVJzIGlzIGNhbGN1bGF0ZWQgYW5kIG1hc2tlZCB3aGVuIGZpbmFsaXNpbmcgdGhl
IFBQSSBzdGF0ZSBmb3INCj4gPiB0aGUgZ3Vlc3QuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTog
U2FzY2hhIEJpc2Nob2ZmIDxzYXNjaGEuYmlzY2hvZmZAYXJtLmNvbT4NCj4gQSBmZXcgYml0cyBp
bmxpbmUgYnV0IG5vdGhpbmcgc2lnbmlmaWNhbnQgc28gSSdsbCBhc3N1bWUgeW91IHRpZHkNCj4g
dGhvc2UgdXANCj4gUmV2aWV3ZWQtYnk6IEpvbmF0aGFuIENhbWVyb24gPGpvbmF0aGFuLmNhbWVy
b25AaHVhd2VpLmNvbT4NCg0KSSd2ZSBsZWZ0IHRoaXMgdGFnIG9mZiBmb3Igbm93IGFzIHRoaXMg
Y29kZSBoYXMgZ29uZSBhIGJpdCBvZiBhIHJld29yaw0KKG1vc3RseSByZWR1Y2luZyB0aGUgc2Nv
cGUpIGFuZCBJIGRvbid0IHRoaW5rIGl0IHJlYWxseSBhcHBsaWVzDQphbnltb3JlLg0KDQpJbnN0
ZWFkIG9mIHRyYXBwaW5nIG1hbnkgb2YgdGhlIHdyaXRlcyB0byB0aGUgUFBJIHJlZ2lzdGVycywg
dGhlIHNldA0KaGFzIGJlZW4gcmVkdWNlZCB0byBqdXN0IHRoZSBJQ0hfUFBJX0VOQUJMRVJ4X0VM
MS4gQnkgdHJhcHBpbmcgYW5kDQptYXNraW5nIHdyaXRlcyB0byB0aGUgUFBJIGVuYWJsZSwgd2Ug
c3RvcCB0aGUgZ3Vlc3QgZnJvbSBldmVyIGVuYWJsaW5nDQphbnkgaW50ZXJydXB0IHRoYXQgaXMg
bm90IGV4cG9zZWQgdG8gaXQsIGFuZCBhcmUgYWJsZSB0byBmb3JnbyB0cmFwcGluZw0KdGhlIHJl
c3Qgb2YgdGhlIHdyaXRlcy4NCg0KVGhhbmtzLA0KU2FzY2hhDQoNCj4gDQo+ID4gLS0tDQo+ID4g
wqBhcmNoL2FybTY0L2t2bS9jb25maWcuY8KgwqAgfMKgIDIyICsrKysrKy0NCj4gPiDCoGFyY2gv
YXJtNjQva3ZtL3N5c19yZWdzLmMgfCAxMzMNCj4gPiArKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKw0KPiA+IMKgMiBmaWxlcyBjaGFuZ2VkLCAxNTMgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vY29u
ZmlnLmMgYi9hcmNoL2FybTY0L2t2bS9jb25maWcuYw0KPiA+IGluZGV4IGViMGM2ZjRkOTViNmQu
LmY4MWJmZGFkZDEyZmIgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9hcm02NC9rdm0vY29uZmlnLmMN
Cj4gPiArKysgYi9hcmNoL2FybTY0L2t2bS9jb25maWcuYw0KPiA+IEBAIC0xNTg2LDggKzE1ODYs
MjYgQEAgc3RhdGljIHZvaWQgX19jb21wdXRlX2ljaF9oZmdydHIoc3RydWN0DQo+ID4ga3ZtX3Zj
cHUgKnZjcHUpDQo+ID4gwqB7DQo+ID4gwqAJX19jb21wdXRlX2ZndCh2Y3B1LCBJQ0hfSEZHUlRS
X0VMMik7DQo+ID4gwqANCj4gPiAtCS8qIElDQ19JQUZGSURSX0VMMSAqYWx3YXlzKiBuZWVkcyB0
byBiZSB0cmFwcGVkIHdoZW4NCj4gPiBydW5uaW5nIGEgZ3Vlc3QgKi8NCj4gPiArCS8qDQo+ID4g
KwkgKiBJQ0NfSUFGRklEUl9FTDEgYW5kIElDSF9QUElfSE1SeF9FTDEgKmFsd2F5cyogbmVlZHMg
dG8NCj4gPiBiZQ0KPiANCj4gbmVlZCB0byBiZQ0KPiANCj4gPiArCSAqIHRyYXBwZWQgd2hlbiBy
dW5uaW5nIGEgZ3Vlc3QuDQo+ID4gKwkgKiovDQo+IA0KPiAqLw0KPiANCj4gPiDCoAkqdmNwdV9m
Z3QodmNwdSwgSUNIX0hGR1JUUl9FTDIpICY9DQo+ID4gfklDSF9IRkdSVFJfRUwyX0lDQ19JQUZG
SURSX0VMMTsNCj4gPiArCSp2Y3B1X2ZndCh2Y3B1LCBJQ0hfSEZHUlRSX0VMMikgJj0NCj4gPiB+
SUNIX0hGR1JUUl9FTDJfSUNDX1BQSV9ITVJuX0VMMTsNCj4gPiArfQ0KPiANCj4gPiBkaWZmIC0t
Z2l0IGEvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYyBiL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdz
LmMNCj4gPiBpbmRleCAzODNhZGEwZDc1OTIyLi5jZWYxM2JmNmJiM2ExIDEwMDY0NA0KPiA+IC0t
LSBhL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMNCj4gPiArKysgYi9hcmNoL2FybTY0L2t2bS9z
eXNfcmVncy5jDQo+ID4gQEAgLTY5Niw2ICs2OTYsMTExIEBAIHN0YXRpYyBib29sIGFjY2Vzc19n
aWN2NV9pYWZmaWQoc3RydWN0DQo+ID4ga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBzeXNfcmVnX3Bh
cmFtcyAqcCwNCj4gPiDCoAlyZXR1cm4gdHJ1ZTsNCj4gPiDCoH0NCj4gPiDCoA0KPiA+ICtzdGF0
aWMgYm9vbCBhY2Nlc3NfZ2ljdjVfcHBpX2htcihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVj
dA0KPiA+IHN5c19yZWdfcGFyYW1zICpwLA0KPiA+ICsJCQkJIGNvbnN0IHN0cnVjdCBzeXNfcmVn
X2Rlc2MgKnIpDQo+ID4gK3sNCj4gPiArCWlmIChwLT5pc193cml0ZSkNCj4gPiArCQlyZXR1cm4g
aWdub3JlX3dyaXRlKHZjcHUsIHApOw0KPiA+ICsNCj4gPiArCWlmIChwLT5PcDIgPT0gMCkgewkv
KiBJQ0NfUFBJX0hNUjBfRUwxICovDQo+ID4gKwkJcC0+cmVndmFsID0gdmNwdS0NCj4gPiA+YXJj
aC52Z2ljX2NwdS52Z2ljX3Y1LnZnaWNfcHBpX2htclswXTsNCj4gPiArCX0gZWxzZSB7CQkvKiBJ
Q0NfUFBJX0hNUjFfRUwxICovDQo+ID4gKwkJcC0+cmVndmFsID0gdmNwdS0NCj4gPiA+YXJjaC52
Z2ljX2NwdS52Z2ljX3Y1LnZnaWNfcHBpX2htclsxXTsNCj4gPiArCX0NCj4gDQo+IE5vIHt9IGFz
IHNpbmdsZSBsaW5lIHN0YXRlbWVudHMgaW4gYWxsIGxlZ3MuDQo+IA0KPiBIb3dldmVyLCBJJ2Qg
YmUgdGVtcHRlZCB0byB1c2UgYSBsb2NhbCB2YXJpYWJsZSBmb3IgdGhlIGluZGV4IGxpa2UNCj4g
eW91J3ZlDQo+IGRvbmUgaW4gbWFueSBvdGhlciBjYXNlcw0KPiAJDQo+IAl1bnNpZ25lZCBpbnQg
aW5kZXg7DQo+IA0KPiAuLi4NCj4gDQo+IAlpbmRleCA9IHAtPk9wMiA9PSAwID8gMCA6IDE7DQo+
IAlwLT5yZWd2YWwgPSB2Y3B1LT5hcmNoLnZnaWNfY3B1LnZnaWNfdjUudmdpY19wcGlfaHJtW2lu
ZGV4XTsNCj4gDQo+IE9yIHVzZSB0aGUgcC0+T3AyICUgMiBhcyB5b3UgZG8gaW4gcHBpX2VuYWJs
ZXIuDQo+IA0KPiANCj4gPiArDQo+ID4gKwlyZXR1cm4gdHJ1ZTsNCj4gPiArfQ0KPiA+ICsNCj4g
PiArc3RhdGljIGJvb2wgYWNjZXNzX2dpY3Y1X3BwaV9lbmFibGVyKHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSwNCj4gPiArCQkJCcKgwqDCoMKgIHN0cnVjdCBzeXNfcmVnX3BhcmFtcyAqcCwNCj4gPiAr
CQkJCcKgwqDCoMKgIGNvbnN0IHN0cnVjdCBzeXNfcmVnX2Rlc2MgKnIpDQo+ID4gK3sNCj4gPiAr
CXN0cnVjdCB2Z2ljX3Y1X2NwdV9pZiAqY3B1X2lmID0gJnZjcHUtDQo+ID4gPmFyY2gudmdpY19j
cHUudmdpY192NTsNCj4gPiArCXU2NCBtYXNrZWRfd3JpdGU7DQo+ID4gKw0KPiA+ICsJLyogV2Ug
bmV2ZXIgZXhwZWN0IHRvIGdldCBoZXJlIHdpdGggYSByZWFkISAqLw0KPiA+ICsJaWYgKFdBUk5f
T05fT05DRSghcC0+aXNfd3JpdGUpKQ0KPiA+ICsJCXJldHVybiB1bmRlZl9hY2Nlc3ModmNwdSwg
cCwgcik7DQo+ID4gKw0KPiA+ICsJbWFza2VkX3dyaXRlID0gcC0+cmVndmFsICYgY3B1X2lmLT52
Z2ljX3BwaV9tYXNrW3AtPk9wMiAlDQo+ID4gMl07DQo+ID4gKwljcHVfaWYtPnZnaWNfaWNoX3Bw
aV9lbmFibGVyX2VudHJ5W3AtPk9wMiAlIDJdID0NCj4gPiBtYXNrZWRfd3JpdGU7DQo+ID4gKw0K
PiA+ICsJcmV0dXJuIHRydWU7DQo+ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyBib29sIGFjY2Vz
c19naWN2NV9wcGlfcGVuZHIoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LA0KPiA+ICsJCQkJwqDCoCBz
dHJ1Y3Qgc3lzX3JlZ19wYXJhbXMgKnAsDQo+ID4gKwkJCQnCoMKgIGNvbnN0IHN0cnVjdCBzeXNf
cmVnX2Rlc2MgKnIpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCB2Z2ljX3Y1X2NwdV9pZiAqY3B1X2lm
ID0gJnZjcHUtDQo+ID4gPmFyY2gudmdpY19jcHUudmdpY192NTsNCj4gPiArCXU2NCBtYXNrZWRf
d3JpdGU7DQo+ID4gKw0KPiA+ICsJLyogV2UgbmV2ZXIgZXhwZWN0IHRvIGdldCBoZXJlIHdpdGgg
YSByZWFkISAqLw0KPiA+ICsJaWYgKFdBUk5fT05fT05DRSghcC0+aXNfd3JpdGUpKQ0KPiA+ICsJ
CXJldHVybiB1bmRlZl9hY2Nlc3ModmNwdSwgcCwgcik7DQo+ID4gKw0KPiA+ICsJbWFza2VkX3dy
aXRlID0gcC0+cmVndmFsICYgY3B1X2lmLT52Z2ljX3BwaV9tYXNrW3AtPk9wMiAlDQo+ID4gMl07
DQo+ID4gKw0KPiA+ICsJaWYgKHAtPk9wMiAmIDB4MikgewkvKiBTUEVORFJ4ICovDQo+ID4gKwkJ
Y3B1X2lmLT52Z2ljX3BwaV9wZW5kcl9lbnRyeVtwLT5PcDIgJSAyXSB8PQ0KPiA+IG1hc2tlZF93
cml0ZTsNCj4gPiArCX0gZWxzZSB7CQkvKiBDUEVORFJ4ICovDQo+ID4gKwkJY3B1X2lmLT52Z2lj
X3BwaV9wZW5kcl9lbnRyeVtwLT5PcDIgJSAyXSAmPQ0KPiA+IH5tYXNrZWRfd3JpdGU7DQo+ID4g
Kwl9DQo+IA0KPiBObyB7fSB3YW50ZWQgaW4ga2VybmVsIHN0eWxlIHdoZW4gYWxsIGxlZ3MgYXJl
IHNpbmdsZSBsaW5lDQo+IHN0YXRlbWVudHMuDQo+IFNhbWUgYXBwbGllcyBpbiBhIGZldyBvdGhl
ciBjYXNlcyB0aGF0IGZvbGxvdy4NCj4gDQo+ID4gKw0KPiA+ICsJcmV0dXJuIHRydWU7DQo+ID4g
K30NCj4gPiArDQo+IA0KDQo=

