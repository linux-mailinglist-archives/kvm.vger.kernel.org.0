Return-Path: <kvm+bounces-65986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A740DCBED3D
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 17:07:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6B9383038F74
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 16:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9D47334C3E;
	Mon, 15 Dec 2025 16:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Wnl+YsUn";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Wnl+YsUn"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013056.outbound.protection.outlook.com [40.107.162.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951EC330B31
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 16:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.56
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765814580; cv=fail; b=QC/3EnDzKgGL9EITh1d068QOUk02HHJevEOWBA2/cgN1TWAYuvdRoR3OglFvcYmBzDKqw7YFPH9v3Z+hCf4x4b4bZSh6SSD6xGfJvdFZX0ZeGa3z9cj/+Gbm1yASfbIstfmY2yB1OKDeG4djvrRikQwTiZUJBBcCzvRHWiLPZ24=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765814580; c=relaxed/simple;
	bh=jTiRRaNQ4dQuV8UdUElBAMHOWNj2h3HK/zE6q2deowc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GaPr+GP53DyzTrkEna+v2OH4/SIfzcROuBKRfmvhR5ATWO+Et0UNkG+vNYToe2cvUyzF35IsB4XxZGeHqrHgJCE/SQBhb30v3pYcr67wewadG+RevMSapxy28F04Yvy6Z+4sXbGEYfx5Upcw+iXL3sxPkdi33nz85TlnlbyZJvk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Wnl+YsUn; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Wnl+YsUn; arc=fail smtp.client-ip=40.107.162.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=xhOuvNNF1M6J5zrbnb4OUXapIYC/emzwAy/JaMOHeEHSASv5Vb1HaCnwsxY8T5WGMReU1FGoAC+KcZBCLb5Uu/U5HlpTlRq9Fwz5ADrvPg3zdGMsJT/SfsYZwvVwJIz+w/Pb8VNhBBfC6nK0SIC4hFb/ObL1o7mPlS6+/+Fg4qkAAQU/AwcI3bEMl2tJYY4Bu4aW0nUzgP0KsNnE/vt0i0Jfvkiy1EQDPJEA93BkYjsJZZ/g5KYhNIogue1S+b1RG7mdBMe/PO62Za8n8vhAII1RsjOsiiGJgFaB5wNBJQJ7qXUeuNLr7M4YpVZfVOat3p6/9i7ghzcfB3VVV2f4/A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jTiRRaNQ4dQuV8UdUElBAMHOWNj2h3HK/zE6q2deowc=;
 b=qbM7waYGLfVf8zW07zz7u3Zwkh9fyj6WQ2PoixRh0n2Aealc4AcSBTydKIdqZgC4HLIdpBMkFhucP18yboiRktIaQkOcE9WOMVbgzEiFrhvQK8Jt0dKYnHtb+JZvhPPHshH2whcKXccdlv4BZvBarOba0R9j+1ObYLlQTBaWfpZlaSgWuFUnCMiekdqw/LpyBJuMgoW6Xo2qL/w/gJljmli2qKhvfmjFrHfPMieWWiZDeDWj1t4WrhrobRt9g0TThrXYWYaeDoNtSXvZnF847fR/DO+ALie0pgvkll7ZoExflyF8cdhSQLRFB13pFYO9yiPVa2woffThX4c5/nYlpQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jTiRRaNQ4dQuV8UdUElBAMHOWNj2h3HK/zE6q2deowc=;
 b=Wnl+YsUnGHk9+sdrp6EzRAHi202Z2usuR85suImp5XDdxjlJIkMrOkYzn7dtXc5snaUIQ25ZJRkVqj6TI9OO4Kb5kTvAdV3one8OlO0NHDNuPqDFtQLVTOXdNXTurDcmpPcx7a4dei/xizSHt2MJfylSt7esAliEfnJDFFtwdL8=
Received: from AS4PR10CA0008.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5dc::10)
 by AM9PR08MB6099.eurprd08.prod.outlook.com (2603:10a6:20b:286::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 16:02:50 +0000
Received: from AMS0EPF000001AF.eurprd05.prod.outlook.com
 (2603:10a6:20b:5dc:cafe::78) by AS4PR10CA0008.outlook.office365.com
 (2603:10a6:20b:5dc::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Mon,
 15 Dec 2025 16:02:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001AF.mail.protection.outlook.com (10.167.16.155) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Mon, 15 Dec 2025 16:02:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F1kBxjZEjwPOmSC2cHH2d4IN5U2xI80OLV+GWYmaBgxG3lJfZXN/RRo/lxjt6kMwaX27XlAsTpSv3WqrBRORKu9gP0rjJrPGTrpt7mG90AC5mkAjCNBt+stfKeR00ALDh858Etupq8Rk2diauF9GReP+61dNfXKjUC5cpKBzIrlKtTMGxqZyWSRgRfH8b2ZhFpPYmH7M4o3PmXCBCNPhqn/4HCAj+lqhE5qdkAfGqyExYO+iYPEKFgWN6uqlBh/fRo9OGKEctgfXeEi82A+m0sjp3fjZYBnCZWLnZo04b32s6Hamj/z9McDoWpbx9gkmKFkAPKOzRGkkUnE8R6PXiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jTiRRaNQ4dQuV8UdUElBAMHOWNj2h3HK/zE6q2deowc=;
 b=kYCMRSqmfavG6VMmz+7RFgZnHYzB4BODEvkKo3dcQKvt3smkiQNoC4gApn/3PRrhl1QDoSHFiAuwv8rdkLK4Tdg5RbAW9KkLtT2xxMlFanPA8XPQzABB372vT/DU2vDZYZ4emsjWEpXMhlzucgtJ3/Td34hGcO3p7pmIivdYZvatcBlXRTYCAr9Kb4wJMaS3PcIUNFDzAlMizWO493gEExUjo8iHMgdgV1a0LaxnoHKjT01MCPfGVETWXQ+gK/gMFNgmISS+wrDt3AU8KP6b7+OjIg0KBv3KL3gZxEwgCxiyyJrfAerYV6uGE/IWt69zZCjoJgmjOv1uaaLTyx9kbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jTiRRaNQ4dQuV8UdUElBAMHOWNj2h3HK/zE6q2deowc=;
 b=Wnl+YsUnGHk9+sdrp6EzRAHi202Z2usuR85suImp5XDdxjlJIkMrOkYzn7dtXc5snaUIQ25ZJRkVqj6TI9OO4Kb5kTvAdV3one8OlO0NHDNuPqDFtQLVTOXdNXTurDcmpPcx7a4dei/xizSHt2MJfylSt7esAliEfnJDFFtwdL8=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by GV1PR08MB9913.eurprd08.prod.outlook.com (2603:10a6:150:86::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 16:01:47 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 16:01:47 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH 07/32] KVM: arm64: gic: Introduce interrupt type helpers
Thread-Topic: [PATCH 07/32] KVM: arm64: gic: Introduce interrupt type helpers
Thread-Index: AQHca3slbeKJlkPOlUaF8+aOc+XY6rUit3AAgAAp0wA=
Date: Mon, 15 Dec 2025 16:01:47 +0000
Message-ID: <38b8e14630a16d74ab7c0ce07ceda2e572d8a01f.camel@arm.com>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
	 <20251212152215.675767-8-sascha.bischoff@arm.com>
	 <86jyynooq3.wl-maz@kernel.org>
In-Reply-To: <86jyynooq3.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|GV1PR08MB9913:EE_|AMS0EPF000001AF:EE_|AM9PR08MB6099:EE_
X-MS-Office365-Filtering-Correlation-Id: dc17f8c9-43a6-4852-24ea-08de3bf365df
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?a2tYVjFlU1RXS2x5dDVhbGxNN3lGY0lwSUtVQkNOamxCdlBVcUtFbHh4dEQx?=
 =?utf-8?B?RXJBLzBtdGpqTDBSaDcvM0NMaGZTODljVlJnMmlWUUwzVEpiM2VTQlczajNQ?=
 =?utf-8?B?RXFCVTU5NXlLbUJjakhYTjNXZGlPbVZDajQxbEsxRnByQVJjbitQSUdJYkd0?=
 =?utf-8?B?UXJ5amZiNTVqWVc3dVNyZGV6aUNodXZHYmNLSjZwK3FETmNUNlRkb20rWHVn?=
 =?utf-8?B?bUpkZEp4TmhEWDBtUjlQM2hSeE9UalZDbncvSlFNcnU3cDIxKzE4OVhpTjNa?=
 =?utf-8?B?NmliY0VXdTlNZjcraDNxMit3OTQxd3lVbkhUUFJ3SjYxeGIyM1N6L21KcDI4?=
 =?utf-8?B?QUJUT252VnhFQ2pPYmNSdTN3dTQ0cnFWVFZUWDE2Z25pU0ZYWm5VYkMvTEQz?=
 =?utf-8?B?QUdnMWhHcEF1K290T201TnlXYVFoR0p0M3ZqT2F3cWtpK1pBNUpTeDNicDhq?=
 =?utf-8?B?N1A0U2ZWVkc4ODVxUVBNTG9nNnFzLzE0RVNzZzdhNDFmVUJhSzFqY1VMdUhN?=
 =?utf-8?B?ODZ1aDVOVk5ldlFzby9YT1pnQXdxd0NVRXU5eTZDK0oxV0ZxQmp4YXFHTk0y?=
 =?utf-8?B?bVJjOG9hY2JsSVhvZjkwY3JDblpoZzBFYS8yeGhqd0hTaUhLNDdRdkxnMmI1?=
 =?utf-8?B?ZTcvVTZMeXlHQlJJMHVuQjRNa0ppZ3JtaktKdjVVa1pGSkh1RXZRZFE4alhP?=
 =?utf-8?B?SlpheUJnWGMzd0o4M21zSElFZkdCeHdPQ0w0WjJpbnJUMitTTXNIMVU5QVNL?=
 =?utf-8?B?WU9aSmUrOFdaRE1rSCtwVWNueXdsZDY3ejFKc1JJT3BTMWdZeG9MMWpwLytD?=
 =?utf-8?B?RU5DVnZMNWwxR2RvM2ZlNUpLME9aUmhZWTIyZFF4MjVpKzYxQ3U5MHhCK2l1?=
 =?utf-8?B?S21VbHJsbHgrUWp2Q1JiUHkxem1MM2t1ZTZkdkZEUlJqT1laYXBneXMyU1pT?=
 =?utf-8?B?U3ZUdjlzeHRUZnJyWnlEaU41aHBMZzU0cU9uYTVCazJCTGVxUndlYUNWNUgv?=
 =?utf-8?B?djhtZFpuNGVRdGNSd3BJOEJ3V2xwZHNiNjk2OUgvaU94T0ZVektYZXpnMnQx?=
 =?utf-8?B?cU1sd3E4cFcvWWZMbkg0VnJ0NUp3UmxBSlhXV2ZkaUF5K2FSUTJlRHA0WnRM?=
 =?utf-8?B?dGhRTUo1eG1Cb1ZOUkVpc2tpaDRNbEVuaDZsUjkvU2F6R3N6dFBQd2wzeXJP?=
 =?utf-8?B?S3RlOEloN2E5Wkl6Mi9sVWRlSURkYys0YkRUS0hhT3BSVXByMEVVNCtuUjVT?=
 =?utf-8?B?UGdHOGtIZUxqa2RBb0d1QkwyYUJMaGJ6YkNSN1QxeDVESkFnWGpzeVI4d0dS?=
 =?utf-8?B?NFRGejErVjhVZmZSRmYxeHpudW93bGJ1czNGNWJ1Zktxd21yWUJtSjkwZ25y?=
 =?utf-8?B?ZFE2NWQvRFBuNlVmVUNIK1RCL2VHZDBRRWYvVE9TVDNteEE2dmIxL1I4OFJJ?=
 =?utf-8?B?dlpPMFlyNGU2K0Yzb29SbW1XWVc2RmJkakNnZS9KZEMzZnZsdjlpcEQwc3Vz?=
 =?utf-8?B?aGtDM3lmZStwZjN2VkNDeGF3Vng4NDVpSE02M1F4b1I4K3QrOHh3Vi90MU56?=
 =?utf-8?B?Y3VsV2JMMlBvN2R2WXV1dk5MOEovQjJiY2ZUMXN5OFZxM0RxaUpEMUpvQlRU?=
 =?utf-8?B?OExkY2JjUGNrbVMwV00yMGd0L2dUclBBWkJtMTBqY21oTkpkZFo3czVkdmZL?=
 =?utf-8?B?b2srUWpsUGZhOElML1YrdXl0alZhcDdLaDBYVEpWQ2JsUlFFN2MrcmJ4VkhN?=
 =?utf-8?B?aDJ2Y1B2ZURtUzA4SjY2RVhmOXRpdmRxQkM3dk93Y2ZObmlVQklDVjNKaENr?=
 =?utf-8?B?UDJZaTNkV1FtbXAyTE5yRTJIekdUQ0NDQy85MUdCWEwrdlZNMS9FNDZwYjVB?=
 =?utf-8?B?Y2hLOVIwUHRpNWFsRW8rVEhyTnpFNVlFQlo5cnBWWU1uS3lJZ0J5c1NEU1Nz?=
 =?utf-8?B?Q2x5OTJyNmE0V3J1VGpRMk1MZUxDZmRnZzdoTDhxWkxmemU1UG1zUE82S202?=
 =?utf-8?B?MitvSDdkVzlJdnkxdGhnZ01HbXBwS3dNUU1VYVRiVjh2R2ZwdTI1NjFoYkpO?=
 =?utf-8?Q?w4a/OR?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD35FD66F3046E4B867DBEB63AFA0BD6@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB9913
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001AF.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a53fb949-6821-407a-8d51-08de3bf34024
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|14060799003|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WlhPbVEwbnRJR1Y4ZWtSbTU4Ry9TWFZ3dStGYlNWV24wSjlvcDVscTRzNThk?=
 =?utf-8?B?Uk04eUVyMkh2OEZZQ3FHYi9yK0NSc2xaTUpxZVhUeGZMTHI5ZnRjWi9iMC9W?=
 =?utf-8?B?QlhLWm9xSTdWTk8rY2g2QmFQWmZYMlZPTk5mRFVTVVZvUVQvU2lLTWo5MDVX?=
 =?utf-8?B?azI4NU5CNEZ5MVJKR2FRbU9SclVtWHBrRHhKcmlqS1h6Sk9kZTJiYVplTURv?=
 =?utf-8?B?RlRwQ3JKcmxtaGFxaTRkTDJTdlN0OUFpbWtRMUtXWXkrTzBRRWNBVHNOcGhz?=
 =?utf-8?B?eW9PRW1vWVYraW1PL1FvMUx0alZRUEFOOGJNMTMwaTczdmczWVgrSFp2QThZ?=
 =?utf-8?B?QVpXcmZOS3g5dlU4MG50RnBNcW1JVEVBTWduQ0pZWE5NbjNydzkrbHdKa1ZM?=
 =?utf-8?B?K2YrMVU0cTF4dlNaNWZuajE0L2lScE90SDRXeWRlSnU2dlk1Y0t2bmcrVksz?=
 =?utf-8?B?STVGTjhXTjlRaGVaY3lIOU00dG1yV0NnVTcyblpNTUg1WXFWUGxQRDR1TXh2?=
 =?utf-8?B?cGRlU29VS3BqYzcvVzVXcE16ODVsMlJVS0pqZWJKM2JPSnBOaVU0ZXliQXBT?=
 =?utf-8?B?MndkOWpRMURQOGdMQzJWWVpmeVVwSWpkNkNqa0R0a1Rkc1ZHT2FvaFMxRzB1?=
 =?utf-8?B?RXV3NTFRRFc4TS9qWjRUdndpYzRyVU92Zy9IdlpER29EdlN1azNpUUZybXRs?=
 =?utf-8?B?NnQzZUZidTZTaWxBMkhuZGwwb0Iralg4NVhxYUsvODViWFVteEtjcXh3ejhr?=
 =?utf-8?B?UDhSQXk5MmxjWndKSnZMNEw4MWI3bFMxaU5BeGJxaEg5MGNMVUxHVjlQS3F0?=
 =?utf-8?B?Tm55b1VKUXREYzExY1U2cEV5b1ZySFVXNFJ6am10MjV3cWVZN1V0ejVHc0pF?=
 =?utf-8?B?N2k2c2ZiYWlNV0ZQclp6enl5U0dRZTZFSFpVZ1VxVWl1K2VTaXRoWVBoN0ov?=
 =?utf-8?B?ZXpBNXY2RUVLc3VpQmxLR0F5NjZPbzJnaDNFWGo2dW8wQlc1WVFwSnpFVExm?=
 =?utf-8?B?K2MxV3p6ZzlqdXdkQzM2dGwwby9TSkN6WmNDWHJCRmppWG85aE9KNHFscTNH?=
 =?utf-8?B?MTFtdFZuaElXeEFWOE5rUEhNSVJ6Mjh4ZitwUytnWGpNUHQ3MXk5dEN5TFhs?=
 =?utf-8?B?NStvNEtmWEYwcGRwZmthYnF4TXBGaXhtaFVMenhRM3M3TzNEV09ERmNQSWhX?=
 =?utf-8?B?T0tZempjRGttWlFWL2NWU2FhWlFoZUN1WXY0MXYyODNLZVEwbkoxQmUva2pj?=
 =?utf-8?B?ZmZsbmVQV2V5SWdEOUZSVkdFNTFoR2o5VGgwTHdEeTVxNWtnVFZDamE0c3hl?=
 =?utf-8?B?SFRxNVJUMU1rc1V5ekhaQVRUVzd3SE9GVnFtMnc2eGZybEtKTDZyTWFJaC9q?=
 =?utf-8?B?eTRkWGxVbHFFZStRdTU3Y1N6eTczNytrMXF3ajR5VGNjbzNXdXl4bGJzVnhp?=
 =?utf-8?B?bDlZSW8rVWZiWTZ0SnkvYkt6c20rSkNSWW5Zb3g2eEw2amQ5clpJZ2hSZCtV?=
 =?utf-8?B?OUR3NUROZFY3clVseG10V1BqYXNudCtqZHBSV1RBd1RjSmlZTXJpdG9CVDFO?=
 =?utf-8?B?aGx4bFk3MzhKckovR0RPVVBJVVdoejQ2ekVPUEpGZWxldS9rWmtnbnFVUi9h?=
 =?utf-8?B?WEMzeFd1MWpGazVQSjU1RHVGTXNrM0hFV3FSWERUdGdLdU9FTEkyaHZMN3Q1?=
 =?utf-8?B?V1Y5RVJNRmlFZnhFQTFhVW5UNi9EZ09wTUdWbHRranVpbGkwdVY2VXRKd0pi?=
 =?utf-8?B?U1ZacHNPSEltTVNFTFFKZE1UZ3kwV1J5dldVYklxRDF4V2xtNk5TTHltWk80?=
 =?utf-8?B?OVMyZWFXUkd3eEpjYmVUK1hOaVlqVmpnMHNwZFJQMHJ3Q0drc1c2alVhMEp6?=
 =?utf-8?B?Z2ZTV2xoSGx6YXpONnF0TVpnZ3RGZis0dXZnSkNSaVMveTI1OFgva2ZrRjFu?=
 =?utf-8?B?QTM3cEx4SEVxN3dQTi9UT0FQbWZ2Nk93aWlSNmhIYXgxVCtXL2xPRVJoS1Zr?=
 =?utf-8?B?V0xNUWdrSWltU2ZZVzRlcnk0U0g0M09PcjJaOS8zRUV6VHNXOWFwSUh3VjBR?=
 =?utf-8?B?WFhuck14UHNySGpJRVRBSXU5aEtJdUM5aURxMjlraW5aQlAyVEVoeVZpRWJD?=
 =?utf-8?Q?56w8=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(14060799003)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 16:02:50.4482
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc17f8c9-43a6-4852-24ea-08de3bf365df
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001AF.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6099

T24gTW9uLCAyMDI1LTEyLTE1IGF0IDEzOjMyICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIEZyaSwgMTIgRGVjIDIwMjUgMTU6MjI6MzcgKzAwMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IMKgDQo+ID4gLQlpZiAoIShpcnFf
aXNfcHBpKGlycSkpKQ0KPiA+ICsJaWYgKCEoaXJxX2lzX3BwaSh2Y3B1LT5rdm0sIGlycSkpKQ0K
PiANCj4gbml0OiBGcm9tIGEgaGlnaC1sZXZlbCBwZXJzcGVjdGl2ZSwgSSdkIGZpbmQgaXQgbWVu
dGFsbHkgbW9yZQ0KPiBzYXRpc2Z5aW5nIHRvIHBhc3MgYSB2Y3B1IHRvIHRoZSBtYWNybyByYXRo
ZXIgdGhhbiBhIHZtIHBvaW50ZXIgd2hlbg0KPiBkZWFsaW5nIHdpdGggUFBJcy4gSXQgd291bGQg
YWxzbyBrZWVwIHRoZSBkZXJlZmVyZW5jZSBoaWRkZW4gYXdheS4NCj4gQnV0DQo+IG1heWJlIGkg
anVzdCBuZWVkIHRvIGdvIHdpdGggdGhlIGZsb3cgaGVyZS4NCg0KTm8sIEkgdGhpbmsgeW91J3Jl
IHJpZ2h0LiBJdCBiZXR0ZXIgYWxpZ25zIHdpdGggdGhlIHNlbWFudGljcw0KdW5kZXJseWluZyBw
cml2YXRlIElSUXMsIGFuZCBkb2VzIG1ha2UgdGhlIGNvZGUgYSBiaXQgbmVhdGVyLiBJZiB3ZSdy
ZQ0KZXZlciBnZW5lcmljYWxseSBjaGVja2luZyAoZS5nLiwgbm90IHVzaW5nIHRoZSBfdjUgdmFy
aWFudCkgYW5kIGRvbid0DQpoYXZlIGEgdmNwdSBwb2ludGVyIGluIHRoYXQgY29udGV4dCB0aGVu
IHNvbWV0aGluZyBpcyBsaWtlbHkgYXdyeS4NCg0KSXQgZG9lcyBtYWtlIGlycV9pc19wcml2YXRl
KGssIGkpIGEgYml0IHN0cmFuZ2UgdGhvdWdoIGFzIHRoYXQgaXMgdXNlZA0KZm9yIHRoaW5ncyBs
aWtlDQoNCglpZiAoIXZjcHUgJiYgaXJxX2lzX3ByaXZhdGUoa3ZtLCBpbnRpZCkpDQoNCmluIGxh
dGVyIGNvbW1pdHMuIFRoYXQgbmVlZHMgdG8gdGFrZSBzdHJ1Y3Qga3ZtIGlmIHdlIHdhbnQgdG8g
ZG8gdGhlDQpzYW1lIHNvcnQgb2YgY2hlY2suIEVsc2UsIHdlIG1pZ2h0IGFzIHdlbGwgbm90IGhh
dmUgaXQuDQoNCj4gPiArI2RlZmluZSBpcnFfaXNfbHBpX2xlZ2FjeShpcnEpICgoaXJxKSA+IFZH
SUNfTUFYX1NQSSkNCj4gDQo+IFRoaXMgbGFzdCBsaW5lIGlzIHdyb25nLiB2MyBMUElzIHN0YXJ0
IGF0IDgxOTIsIHdoaWxlIFZHSUNfTUFYX1NQSSBpcw0KPiAxMDE5LiBBbHNvLCAibGVnYWN5IiBp
cyByZW1hcmthYmx5IGFtYmlndW91cy4gdjIgaXMgbGVnYWN5IGZvciB2MywgdjMNCj4gZm9yIHY0
Li4uwqAgWW91IHNlZSB3aGVyZSB0aGlzIGlzIGdvaW5nLg0KPiANCj4gSSdkIHJhdGhlciB5b3Ug
aGF2ZSBzb21ldGhpbmcgdGhhdCBkZW5vdGVzIHRoZSBub24tR0lDdjUtbmVzcyBvZiB0aGUNCj4g
aW1wbGVtZW50YXRpb24uIGlycV9pc19udjVfcHBpKCk/DQoNCllvdSBhcmUgYWJzb2x1dGVseSBj
b3JyZWN0OyB0aGF0IGxhc3QgbGluZSBpcyB3cm9uZy4gRml4ZWQsIHRoYW5rcyENCg0KQW5kIHll
YWgsIG5hbWluZyBpcyBoYXJkLiBGcm9tIG15ICh1bmlxdWUpIHBvaW50IG9mIHZpZXcsIGV2ZXJ5
dGhpbmcNCnRoYXQgaXNuJ3QgR0lDdjUgaXMgbGVnYWN5LCBidXQgdGhhdCdzIG5vdCBleGFjdGx5
IGhlbHBmdWwgZm9yIGFueW9uZQ0KZWxzZS4NCg0KSU1PLCBudjUgaXMgYSBiaXQgdG9vIGNsb3Nl
IHRvIE5WICYgTlYyLiBJJ2QgcHJlZmVyIHNvbWV0aGluZyBtb3JlIGxpa2UNCmlycV9pc19ub25f
djVfcHBpIGZvciB0aGUgbmFtaW5nLCBidXQgZGVmaW5pdGVseSBkb24ndCBoZWVsIHN0cm9uZ2x5
Lg0KSGFwcHkgZm9yIHN1Z2dlc3Rpb25zIGhlcmUsIGJ1dCBmb3IgdGhlIHRpbWUgYmVpbmcgSSd2
ZSBsb2NhbGx5IGNoYW5nZWQNCnRvIHVzaW5nIG52NSBpbiB0aGUgcGxhY2Ugb2YgbGVnYWN5Lg0K
DQo+ID4gwqAjZGVmaW5lIGlycWNoaXBfaW5fa2VybmVsKGspCSghISgoayktPmFyY2gudmdpYy5p
bl9rZXJuZWwpKQ0KPiA+IMKgI2RlZmluZSB2Z2ljX2luaXRpYWxpemVkKGspCSgoayktPmFyY2gu
dmdpYy5pbml0aWFsaXplZCkNCj4gPiAtI2RlZmluZSB2Z2ljX3ZhbGlkX3NwaShrLCBpKQkoKChp
KSA+PSBWR0lDX05SX1BSSVZBVEVfSVJRUykgJiYNCj4gPiBcDQo+ID4gKyNkZWZpbmUgdmdpY19y
ZWFkeShrKQkJKChrKS0+YXJjaC52Z2ljLnJlYWR5KQ0KPiANCj4gV2hhdCBpcyB0aGlzIGZvcj8g
Tm90aGluZyBzZWVtIHRvIGJlIHVzaW5nIGl0IHlldC4gSG93IGRpZmZlcmVudCBpcw0KPiBpdA0K
PiBmcm9tIHRoZSAnaW5pdGlhbGl6ZWQnIGZpZWxkPw0KDQpUaGlzIGlzIGZvciBub3RoaW5nLCBh
bmQgd2Fzbid0IG1lYW50IHRvIGJlIGhlcmUgYXQgYWxsLiBTZWVtcyBpdCBjcmVwdA0KaW4gZnJv
bSB0aGUgcHJvdG90eXBpbmcsIGFuZCBzbGlwcGVkIHRocm91Z2ggdGhlIGNyYWNrcyB3aGVuIHBy
ZXBhcmluZw0KdGhpcyBzZXJpZXMuIEhhdmUgZHJvcHBlZCBpdC4gQXBvbG9naWVzIQ0KDQo+ID4g
KyNkZWZpbmUgdmdpY192YWxpZF9zcGlfbGVnYWN5KGssIGkpCSgoKGkpID49DQo+ID4gVkdJQ19O
Ul9QUklWQVRFX0lSUVMpICYmIFwNCj4gPiDCoAkJCSgoaSkgPCAoayktPmFyY2gudmdpYy5ucl9z
cGlzICsNCj4gPiBWR0lDX05SX1BSSVZBVEVfSVJRUykpDQo+ID4gKyNkZWZpbmUgdmdpY192YWxp
ZF9zcGlfdjUoaywgaSkJKGlycV9pc19zcGkoaywgaSkgJiYgXA0KPiA+ICsJCQkJIChGSUVMRF9H
RVQoR0lDVjVfSFdJUlFfSUQsIGkpIDwNCj4gPiAoayktPmFyY2gudmdpYy5ucl9zcGlzKSkNCj4g
PiArI2RlZmluZSB2Z2ljX3ZhbGlkX3NwaShrLCBpKSAoKChrKS0+YXJjaC52Z2ljLnZnaWNfbW9k
ZWwgIT0NCj4gPiBLVk1fREVWX1RZUEVfQVJNX1ZHSUNfVjUpID8gXA0KPiA+ICsJCQkJdmdpY192
YWxpZF9zcGlfbGVnYWN5KGssIGkpIDoNCj4gPiB2Z2ljX3ZhbGlkX3NwaV92NShrLCBpKSkNCj4g
PiANCj4gDQo+IFRoaXMgbWFjcm8gaGFzIGl0cyB2NS9udjUgc3RhdGVtZW50cyBpbiB0aGUgb3Bw
b3NpdGUgb3JkZXIgb2YgYWxsIHRoZQ0KPiBvdGhlcnMuIFNvbWUgY29uc2lzdGVuY3kgd291bGQg
YmUgd2VsY29tZS4NCg0KSGF2ZSByZS1vcmRlcmVkIHRvIG1hdGNoIHRoZSBvcmRlciBhYm92ZS4N
Cg0KPiANCj4gVGhhbmtzLA0KPiANCj4gCU0uDQo+IA0KDQpUaGFua3MsDQpTYXNjaGENCg0K

