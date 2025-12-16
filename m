Return-Path: <kvm+bounces-66064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 04109CC20A7
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 11:58:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7201E30321FD
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 10:56:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D6BB33A6F4;
	Tue, 16 Dec 2025 10:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Z7kqwmrv";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Z7kqwmrv"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012055.outbound.protection.outlook.com [52.101.66.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D91B30F53B
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 10:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.55
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765882607; cv=fail; b=LZFg5ume4Pz1Kj+rb2zyXyGkD4JCF7MLJQitmqqJqaBBnbcInFr+OhUeiu7gM7gD9a7xmMuSIj0M4Oo6u3WZqdveKcvsgkrf9Vk8cqiRM1ixPqNp7iRxboa2rxSnjsQNIQNH1d3E7jJBxPqI0z9v/CqEdxflSW6WUtkfpvXAMsc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765882607; c=relaxed/simple;
	bh=cVyqi58s1Ng0k5PMqSAfiG7Y5qRr/ZrVHCI17cdw7cE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FrzLIrO/kWM6cAeWAdjWdP1vI+t+eyAKI1p2pizeebpZuXlRmH8203/GDOQannKcZQY9tzhOdmOAiP530YL2a48/1t/uzUHoNpOT8KA5D0Yu+wYBLeu9T8fUB3vvW4I8T7Cf2oDu80+6JqVCFt7IUlg9FyBrtMFN5RmnTSuFwfM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Z7kqwmrv; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Z7kqwmrv; arc=fail smtp.client-ip=52.101.66.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=SQS6mBNmiDrOC8S8nh8ONdHpyuBVfHJ/f5aTaS0a0at39re2z1nBPwyDA3lbZjp1GWN2ukLuMF7/C0wWg2Y4rKonWaAoLNFnbHgNtMpsUDfgc4m0mhea3TdhaIK6zXTlxQm3Lk+Og6uG4yEWigmVMbFHhPui8rWWWQLzDvb/8kpvb3Mm36vZDs03geJm5rxC4OM7ghXHS9ECsiMZll8I4LxjaGJHg+FlYbcBv8/pVCNp3FIj+dDOK1XY5mQ72uMVBUiwkYM6/8qLVuJ5534gfGPMBOoV3/G3a4jT5Jd54utTLoWULbHl+E2UlKuRO/96VFoGGVfyZzdZD0ofz2Jryg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cVyqi58s1Ng0k5PMqSAfiG7Y5qRr/ZrVHCI17cdw7cE=;
 b=enhLXC9U1SL89g/+BoKRZUogq/V8c6eArUxF0ZppJLNOersYDAJzX0SLDaGDGgAcamNEzI0GkgKiGjj4Zdu/WIhWmS4cIRmxFhvRzgFkpcXY0upkcaMC5Wbl9gNGuPpHgf2J2hNvPcp91DHFPX9jt1kBwH6Txa60G3V5LN83b0pphq6BDgxKu0P0gfYecS2OzqDUqJ7KKNqqIwvSKWh9u+ZHqXXid2eoMmkwtGviImIcmlFa7+ZYfnSqrKTbTAbIGBZCjoov9UCjaFPzoiOTtHBOAeFCtgkFw6c9IKcYTkzk9IKC6A6syFhE+1Tg5vI6SRBDvXUtyho6vZXRhxGl3g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cVyqi58s1Ng0k5PMqSAfiG7Y5qRr/ZrVHCI17cdw7cE=;
 b=Z7kqwmrvG1SFQzRg871tup6754O+Y2pVOagjBIsDLl8+gxisErxlg51bd1Y+PY1Ho0xXWBff0tV3B9gDTHeaVvi4uG+tf6Egz53aTpR07IBO7DbnMUCUw3xkMYEJzjR8wbvDSZTkk7siFH+lPUgdNWph3IBcqH2Xk0u3ZKBadhw=
Received: from DUZPR01CA0005.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c3::9) by DB8PR08MB5354.eurprd08.prod.outlook.com
 (2603:10a6:10:114::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 10:56:41 +0000
Received: from DB5PEPF00014B9E.eurprd02.prod.outlook.com
 (2603:10a6:10:3c3:cafe::5b) by DUZPR01CA0005.outlook.office365.com
 (2603:10a6:10:3c3::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via Frontend Transport; Tue,
 16 Dec 2025 10:56:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B9E.mail.protection.outlook.com (10.167.8.171) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Tue, 16 Dec 2025 10:56:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nQb4bqUf3JD3fIEc20TMG+Y3jFnF+7/viMaWjTqXjdj4EbywDzxKZnFK6/nJ54RgQ4H4ouP19uV6BRDmKfMNSWUgGsOrOgtwVAHTQnO5CUBcFwKtgz6bgV8LL9YMiIZmVdZgOh/IccILayyVGBz8kniXsMMEFz5ZkCcr8HRpxk9s8ZaOCKmDvspia1jHJltBVTxk1YFgfSeFU8hqPogEmY2j3hMaMpLLZb1UPK80t5f9qOAG1kCCbHXruaJiEK3fH2X+IZAj4H+BfvUSOVfC2B/oVKPXecQnBSVA5cFl/UeMoaX5jemb7Pb4tsrJixbldAPvJKqmbO2A8wCOzkSVoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cVyqi58s1Ng0k5PMqSAfiG7Y5qRr/ZrVHCI17cdw7cE=;
 b=CJQD553sMIXtL9T45Bc8Pg8gKJONwNwX/vXBZPiiFKD9nyFPnBFXJCNmVF+2JpbOfJ8x4ngsPKZ+epa+MsTM4u5em5E80Z88AilIOne19pzbMp0yw9m0kIhz3fspmfVr8vW5yDGSfBvZXfpS4pLbYAiaUjk8jvm/RLzS4FxezlCqWTrv58Ip3bLN4j4U9YmpiRFivOZHKC3oO/cLHLSE4r0i5G+hgtyzkVBbNShboEo72L+T2QFkUJD7EQJF3L6VRBQv5h8oy/0abnz+ZSo/YMkX4gHAjUtr3vLyDqKDvGaFjfnOI+c+/KG8lUnd4AP3NcFlbCuLTQMFZnr+LFAtsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cVyqi58s1Ng0k5PMqSAfiG7Y5qRr/ZrVHCI17cdw7cE=;
 b=Z7kqwmrvG1SFQzRg871tup6754O+Y2pVOagjBIsDLl8+gxisErxlg51bd1Y+PY1Ho0xXWBff0tV3B9gDTHeaVvi4uG+tf6Egz53aTpR07IBO7DbnMUCUw3xkMYEJzjR8wbvDSZTkk7siFH+lPUgdNWph3IBcqH2Xk0u3ZKBadhw=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AM8PR08MB6468.eurprd08.prod.outlook.com (2603:10a6:20b:360::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 10:55:38 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 10:55:38 +0000
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
Subject: Re: [PATCH 23/32] KVM: arm64: gic-v5: Bump arch timer for GICv5
Thread-Topic: [PATCH 23/32] KVM: arm64: gic-v5: Bump arch timer for GICv5
Thread-Index: AQHca3spYNl0WGlNZUmPJyki2EbHPLUi3fwAgAFAEoA=
Date: Tue, 16 Dec 2025 10:55:37 +0000
Message-ID: <03acbb1d276e47d263caffd169c4789b504b59d8.camel@arm.com>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
	 <20251212152215.675767-24-sascha.bischoff@arm.com>
	 <86fr9boic5.wl-maz@kernel.org>
In-Reply-To: <86fr9boic5.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|AM8PR08MB6468:EE_|DB5PEPF00014B9E:EE_|DB8PR08MB5354:EE_
X-MS-Office365-Filtering-Correlation-Id: d702a04c-465f-4c9b-6d20-08de3c91cb0d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?Wk1UN1ZrQkx2WVJIcDk1dE5SeFNCZ2Z1Nkt4cjJqOTdBUmRxWkdMNGJKbHdo?=
 =?utf-8?B?VGdMdlVGaVFrcnl2bi9SYVpPYit6Y2JhQU9IMmpCUGFKRE5TdWJGZzA3ZXo1?=
 =?utf-8?B?ZkNxSFlpS1Z1a3JQL0pzaVBZdFRxNGI3SW54Ti8wS0tZNW1xcE1QN2gwM1pk?=
 =?utf-8?B?RXNTejQ1UzVqMG5PdkFST2g2aUlaTlpTYVd0WjdEZlY2OFBBckxldVZRVGd0?=
 =?utf-8?B?dnAzUDdTMVVWY3FVUXdVQXFyTFl3aERWSXozcUdob0hyZjVweWdVajNTa0pz?=
 =?utf-8?B?a1Y3bTlnbzBrRjhLUjBHaGd5K0ZlQnVLNklJdUJBeUVzS0xiNi9zME9qTlZH?=
 =?utf-8?B?NmRack8yNHpYbmVOaGNETk5HUUxqaGVWQnNHVWdTbnlFMHdid3p6alF3MHQ2?=
 =?utf-8?B?Q1FkTFhFUGplNzN4OWpET09GbDV6cVJiSW5tSlpnek1jbjFyV0xHcko4eXpK?=
 =?utf-8?B?R0NNdHNPd1htWThDd0Rwbjl4ZklGekFjai9VN0V0OFF2NmpHRUo0YTFNai8r?=
 =?utf-8?B?b3hWRzFNbGVqVzVjK2cyTEtJK1d5dlVxTys2NHprTXMyN1drNDJ5YWJiQ2ZV?=
 =?utf-8?B?eXM4Q0lDVVdqQng4RWN6aHJkd25adldvNEg4dnZUQzNBOUpjSGU5VllzU3JC?=
 =?utf-8?B?NjRaRityL1hmM3R0Z3JXR25jdjRSbUtpYTNEdktvd1VpMHExYUpHNW5pbHlR?=
 =?utf-8?B?Ym1KMjNacHdLOERGam1Rck9qQ1RSUmJUWDkxd3FaOCtMemNsUnBmT2FMN2RW?=
 =?utf-8?B?VEsrUE8wWEFjVVBzamVKc2lSMXNLTCtjQlgxWnZoNnNXVGRwT0kxZ2U1dmEv?=
 =?utf-8?B?YVZIY2E3ZW44Nm9XaE1JMFFPRVBUSUxOeXlTa1VyeHBiSzNHY1hjRXdMY3ZU?=
 =?utf-8?B?YlFxcExDN1FFVm9zMkdOSVcxUlhTVGsyOEF6Z04wQnlNN1NyWGZ4QWpHT1NB?=
 =?utf-8?B?QUhBZDZsM29heVVvNHVBYVN2VTdUd28zUS9GRDZxdktoTFQzY3EwNUNFMzFs?=
 =?utf-8?B?OWc4NzUwSlVSeWtPZXAwdmNMMnVyanV1aHFnUXEwdTEyU2tlQ3Q5UE1PZERo?=
 =?utf-8?B?RHZhamxvTWYxbTZJV2k0ZjF5NFQ2WHdQeDVDcHJVQ3RLWFRGZ3pINkRpRWh1?=
 =?utf-8?B?dEhhUG01UzBJZ0ozV1diTC9jRU9TQVdQdnlQeVhnN0pTMVcyYlZnc2hEZFAw?=
 =?utf-8?B?WlJPV2piYUFjSGFjL2VVU0RieWdWMnB3OGN5K2pYVW5DQ2VjenhkaEo2RGk3?=
 =?utf-8?B?WE5FcERvYUkyck4yTENCZVhaWHNnOHhaVkt6d252Z0VPaTNyWWJic2wxZFFq?=
 =?utf-8?B?QUJuZ2NkdVJadWxPbHVXRk9ySHkvQnplTVRlUUtVUC8xd0FBOFc0MVhSdVJl?=
 =?utf-8?B?WlFxZi9vb2Z1ZUtmT0x3TGFVN08zcjlCK3RCS21EMVlUUHhiR3JES1hVbnZw?=
 =?utf-8?B?WE5IN2FrOW5uUmlDeWs0WTk0dTVodld0WFE2QzkxNXN3WlV2WUY3VHhEK2pl?=
 =?utf-8?B?RldyUzV4eGhZSlptZE4xOGdPM2d2MzBPalQ2RkxSUUxxZmdOOTBCR2ttU3dm?=
 =?utf-8?B?Umo2c2lsdFc2ekdza2VrVzBQYU1ZRWxPMmY0cWt6emRnWWdBc2h2ZVAydEFC?=
 =?utf-8?B?a2hpNFRlUkRBUmhKNnpKVWFub3gzTEpVS1poamNaVXNlYlhSaDhNK0ZKL29s?=
 =?utf-8?B?VnBGejMyUWdFOHc2Zk1OdnhyZ0ZPN2JoTitPbEVtVW56NERZNnhhejNoNFVn?=
 =?utf-8?B?UlJ4WFBteDAzS1ltNVZKTWtPZklXOC9TVXk4QjFCdDRsNm9lajVZTFIzdG5r?=
 =?utf-8?B?MllaaFBLN3BFVWpTQ1JkaTZ0WEp4SFQza29kdUpBanR6UTN0Rkx0QzVVc2Rk?=
 =?utf-8?B?aUZWRm1YNnhMa2JLcnZWNWVlWGgzTWEvWjJDd3B6S096bGp2RzdiQzlCS0Iy?=
 =?utf-8?B?cW9ybVN0cEJQK3A4dzZMMDhIQUdjL2ZtZnEyWUZCYW55QzlUbnpERFQvZUlN?=
 =?utf-8?B?MnR5bFRDUUtNTnRnaDNVT0orbUM3S0RJNFJCTm13T2lWS2ZpVklHbnQ1cFNo?=
 =?utf-8?Q?dDQfz1?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <08D367591BC366409D8D6BF71DE66D90@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6468
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B9E.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e63719ee-2f9c-458f-feb9-08de3c91a58a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|14060799003|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aE15c2dFYzRRbWhnOTRCcHZEQmpma1N6cHp4YlI5TGtaTG5RNGpQNWRtcXpr?=
 =?utf-8?B?WmZkTnAzbHVpbms5Y1kwdnNyY0RaSU90aGY5aXdlQUtMaHhnOFRIcG5DRURB?=
 =?utf-8?B?cDhmZmlGbWxFdEZuRGx5OVUvMDhEbVdpdWRUbm5oRFh5WW1DRlZKWThicVZF?=
 =?utf-8?B?Wk4wRnk3NzJoVHBPd0Y5TjJ3dHE0N3dMZmZHVEhxM3EwV0MzWE15VmtCcWgr?=
 =?utf-8?B?RkU1S3Y2cmtkWUR4NkRWRVYyYVMyeHQvWG41OG1TcUZBSm41RFBEZ0NCVnB1?=
 =?utf-8?B?UDBoM2Z4T1R0VXN2T1B3NkJkNGNKTUtZNzc3eVZRbDh5QW9GcVhrMTRVS2t0?=
 =?utf-8?B?MUV4MGx0eVFHMXZFck83djZMRHhnS2hITXlxelFEZjVUUXVpcGZyd3RQanlD?=
 =?utf-8?B?M056cjViQTZNdS9Ed2U1OHk4d2o2cTNvNjBybVgwQVE4U3RpK2JoZ21zSE1x?=
 =?utf-8?B?Zm5zYWVTVVF3WjJXdWRCUHZ6SGVHZk1uRDh0YmRzOHJ3WkN6MythMmdCTUN6?=
 =?utf-8?B?bjhrdTh5T2FjN04zVWt3WXpQTXhJWmRkN0xXc293ZDJ3WlREQklsNUhSM3FW?=
 =?utf-8?B?M3puZXBPN0tldktpUmZRdGU0eDJvUU9yL0ZFOEJ4QVlLa1AyYVRsYlcweFVz?=
 =?utf-8?B?a1VXTGpWQzdWNWlVY1BTTHBCRzRxMmt4OU1DTllQTmZDUXRoaDY2REdvOEl2?=
 =?utf-8?B?anlFTGFNVEpyMTZlcC9xVnlESC9ma29WeWJSdk1lL0xkbTdMR3VLNEphT2xu?=
 =?utf-8?B?NWFQZnJQYUtJS2VvcUxUbTBHM2Y1a2QzOVBNOUs4L1dtUHZJeTJtdTVNZUlx?=
 =?utf-8?B?SUJicDZYTzRBeS82cnIzM3g3K0Q5VktkYnhlVmdqRE5ocm0wekhzM3dmZmxr?=
 =?utf-8?B?VHhpeVRCTlBtdDVDeldMSGJJRmFNUUNZcHFZcFk2dlRVcmkrQVVxMk9JMFpr?=
 =?utf-8?B?c1UxZE9XNWx2L3BIOWo1cVlpK1ZiK2oyNVVKbUZBYjVzekxPRVB1bWgvU3dy?=
 =?utf-8?B?bHJsQXd3ZmpNa3QxMzlZK2hGcEYvN1A0bmc2STlDbWFBd2tYUGxkMndYeUlH?=
 =?utf-8?B?Z2N4bTl1QmJ3RHhUS0pzbnRwc2FDcnBHU3YyWURNYXQ1Y3lZbTVwdzgrZFFn?=
 =?utf-8?B?UjgyM1BUWEM3eGU3SC9xNHVoODlmcjIwa1pGU2UrVlByd1E3NkprNlUxYmZL?=
 =?utf-8?B?SlVQY2hLb2lUUFpGVHk5ZDkzZWpFeGgvWmd0VVZRTURBN21veE9IK0c4VnZO?=
 =?utf-8?B?em5sM1AwWnhRQVc3Z2ZHNHZNWGk1akloTk9hTkx4bHAyQlJ3dnhUQUVKajcr?=
 =?utf-8?B?clQ4MmNybms3VjlNbGRYMENXZFNSSEVMZDZiQTVtd2FYNm1oeUNObXFZSzVz?=
 =?utf-8?B?djRKQlJSM2M3UWFnemloNXlBU2NOcnlLNUJuc0cyME96NGtNdHBUeWhOWkh2?=
 =?utf-8?B?aDJjRUFLaUpFLzRTeXJPNWVRWUdBRnhuRStjR29EOElZUzlITkpia3ZVWm1P?=
 =?utf-8?B?TVloYmtQc3RtM3FTaHRGWWVETk8ybnN2b2wyUDB0YVE3TlRNWWFwdFk3a2gz?=
 =?utf-8?B?Y0Y1YmNBUGRqM0h0U3RMdm5TeS94MXgzL2huZXFXcHRueU9pZHdwY1ptSCtS?=
 =?utf-8?B?SXJrUkM0cE9hSnphbWQvTHNZVmFOTlV3V1FnL3lQNEpNTzRpUlRLT3JRd1JI?=
 =?utf-8?B?MFVxb2htdTJOQUNvd2tDQXZVMjVoSWpqdkhaNmR1L0U1eFl4YlplOUpadVdH?=
 =?utf-8?B?VEpBU2xrZ2tJWUFkWGl2NEVYL1lCRFlZWVM5WnIyemdKbWsveWJ3ZDhWY243?=
 =?utf-8?B?cVEraDhkZU5mbWhVSlpObjQwZnVHSnNCMFBtVTcyS1lYWkdsc0VVRjRRNVpX?=
 =?utf-8?B?dWJHVWdrZUNRYWwxQm1QM3RQUWUwOU5lcTRiR0lKR1d6eTRGOXZSQXMwb2Fy?=
 =?utf-8?B?ckhKUUN0QVJwQkdOVEt1ZndVUHhmRWNUTS9zQnZ6cklRNmRiY2ZScUF5VzhF?=
 =?utf-8?B?MXk0ZlQ0VVo4bGtPelA0SUorcGFpM1drWnlJcHUzRDh3Y0c3a2JreEEzMmZu?=
 =?utf-8?B?VHhyNGJybHN3c2dOK09vK3R6ZzY5blQwdzU5TjNiSnRhUndZSVI2SXBrSlFU?=
 =?utf-8?Q?HqEs=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(14060799003)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 10:56:40.6661
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d702a04c-465f-4c9b-6d20-08de3c91cb0d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9E.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5354

T24gTW9uLCAyMDI1LTEyLTE1IGF0IDE1OjUwICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIEZyaSwgMTIgRGVjIDIwMjUgMTU6MjI6NDMgKzAwMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE5vdyB0aGF0IEdJQ3Y1
IGhhcyBhcnJpdmVkLCB0aGUgYXJjaCB0aW1lciByZXF1aXJlcyBzb21lIFRMQyB0bw0KPiA+IGFk
ZHJlc3Mgc29tZSBvZiB0aGUga2V5IGRpZmZlcmVuY2VzIGludHJvZHVjZWQgd2l0aCBHSUN2NS4N
Cj4gPiANCj4gPiBGb3IgUFBJcyBvbiBHSUN2NSwgdGhlIHNldF9wZW5kaW5nX3N0YXRlIGFuZCBx
dWV1ZV9pcnFfdW5sb2NrDQo+ID4gaXJxX29wcw0KPiA+IGFyZSB1c2VkIGFzIEFQIGxpc3RzIGFy
ZSBub3QgcmVxdWlyZWQgYXQgYWxsIGZvciBHSUN2NS4gVGhlIGFyY2gNCj4gPiB0aW1lcg0KPiA+
IGFsc28gaW50cm9kdWNlcyBhbiBpcnFfb3AgLSBnZXRfaW5wdXRfbGV2ZWwuIEV4dGVuZCB0aGUN
Cj4gPiBhcmNoLXRpbWVyLXByb3ZpZGVkIGlycV9vcHMgdG8gaW5jbHVkZSB0aGUgdHdvIFBQSSBv
cHMgZm9yIHZnaWNfdjUNCj4gPiBndWVzdHMuDQo+ID4gDQo+ID4gV2hlbiBwb3NzaWJsZSwgRFZJ
IChEaXJlY3QgVmlydHVhbCBJbnRlcnJ1cHQpIGlzIHNldCBmb3IgUFBJcyB3aGVuDQo+ID4gdXNp
bmcgYSB2Z2ljX3Y1LCB3aGljaCBkaXJlY3RseSBpbmplY3QgdGhlIHBlbmRpbmcgc3RhdGUgaW4g
dG8gdGhlDQo+ID4gZ3Vlc3QuIFRoaXMgbWVhbnMgdGhhdCB0aGUgaG9zdCBuZXZlciBzZWVzIHRo
ZSBpbnRlcnJ1cHQgZm9yIHRoZQ0KPiA+IGd1ZXN0DQo+ID4gZm9yIHRoZXNlIGludGVycnVwdHMu
IFRoaXMgaGFzIHR3byBpbXBhY3RzLg0KPiA+IA0KPiA+ICogRmlyc3Qgb2YgYWxsLCB0aGUga3Zt
X2NwdV9oYXNfcGVuZGluZ190aW1lciBjaGVjayBpcyB1cGRhdGVkIHRvDQo+ID4gwqAgZXhwbGlj
aXRseSBjaGVjayBpZiB0aGUgdGltZXJzIGFyZSBleHBlY3RlZCB0byBmaXJlLg0KPiA+IA0KPiA+
ICogU2Vjb25kbHksIGZvciBtYXBwZWQgdGltZXJzICh3aGljaCB1c2UgRFZJKSB0aGV5IG11c3Qg
YmUgbWFza2VkDQo+ID4gb24NCj4gPiDCoCB0aGUgaG9zdCBwcmlvciB0byBlbnRlcmluZyBhIEdJ
Q3Y1IGd1ZXN0LCBhbmQgdW5tYXNrZWQgb24gdGhlDQo+ID4gcmV0dXJuDQo+ID4gwqAgcGF0aC4g
VGhpcyBpcyBoYW5kbGVkIGluIHNldF90aW1lcl9pcnFfcGh5c19tYXNrZWQuDQo+ID4gDQo+ID4g
VGhlIGZpbmFsLCBidXQgcmF0aGVyIGltcG9ydGFudCwgY2hhbmdlIGlzIHRoYXQgdGhlIGFyY2hp
dGVjdGVkDQo+ID4gUFBJcw0KPiA+IGZvciB0aGUgdGltZXJzIGFyZSBtYWRlIG1hbmRhdG9yeSBm
b3IgYSBHSUN2NSBndWVzdC4gQXR0ZW1wdHMgdG8NCj4gPiBzZXQNCj4gPiB0aGVtIHRvIGFueXRo
aW5nIGVsc2UgYXJlIGFjdGl2ZWx5IHJlamVjdGVkLiBPbmNlIGEgdmdpY192NSBpcw0KPiA+IGlu
aXRpYWxpc2VkLCB0aGUgYXJjaCB0aW1lciBQUElzIGFyZSBhbHNvIGV4cGxpY2l0bHkgcmVpbml0
aWFsaXNlZA0KPiA+IHRvDQo+ID4gZW5zdXJlIHRoZSBjb3JyZWN0IEdJQ3Y1LWNvbXBhdGlibGUg
UFBJcyBhcmUgdXNlZCAtIHRoaXMgYWxzbyBhZGRzDQo+ID4gaW4NCj4gPiB0aGUgR0lDdjUgUFBJ
IHR5cGUgdG8gdGhlIGludGlkLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhc2NoYSBCaXNj
aG9mZiA8c2FzY2hhLmJpc2Nob2ZmQGFybS5jb20+DQo+ID4gLS0tDQo+ID4gwqBhcmNoL2FybTY0
L2t2bS9hcmNoX3RpbWVyLmPCoMKgwqDCoCB8IDExNCArKysrKysrKysrKysrKysrKysrKysrKysr
KystDQo+ID4gLS0tLQ0KPiA+IMKgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWluaXQuYyB8wqDC
oCA5ICsrKw0KPiA+IMKgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmPCoMKgIHzCoMKgIDYg
Ky0NCj4gPiDCoGluY2x1ZGUva3ZtL2FybV9hcmNoX3RpbWVyLmjCoMKgwqAgfMKgwqAgNyArLQ0K
PiA+IMKgaW5jbHVkZS9rdm0vYXJtX3ZnaWMuaMKgwqDCoMKgwqDCoMKgwqDCoCB8wqDCoCA1ICsr
DQo+ID4gwqA1IGZpbGVzIGNoYW5nZWQsIDExOSBpbnNlcnRpb25zKCspLCAyMiBkZWxldGlvbnMo
LSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vYXJjaF90aW1lci5jDQo+
ID4gYi9hcmNoL2FybTY0L2t2bS9hcmNoX3RpbWVyLmMNCj4gPiBpbmRleCA2ZjAzM2Y2NjQ0MjE5
Li5iMGE1YTZjNmJmOGRhIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL2FyY2hfdGlt
ZXIuYw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL2FyY2hfdGltZXIuYw0KPiA+IEBAIC01Niw2
ICs1NiwxNyBAQCBzdGF0aWMgc3RydWN0IGlycV9vcHMgYXJjaF90aW1lcl9pcnFfb3BzID0gew0K
PiA+IMKgCS5nZXRfaW5wdXRfbGV2ZWwgPSBrdm1fYXJjaF90aW1lcl9nZXRfaW5wdXRfbGV2ZWws
DQo+ID4gwqB9Ow0KPiA+IMKgDQo+ID4gK3N0YXRpYyBzdHJ1Y3QgaXJxX29wcyBhcmNoX3RpbWVy
X2lycV9vcHNfdmdpY192NSA9IHsNCj4gPiArCS5nZXRfaW5wdXRfbGV2ZWwgPSBrdm1fYXJjaF90
aW1lcl9nZXRfaW5wdXRfbGV2ZWwsDQo+ID4gKwkuc2V0X3BlbmRpbmdfc3RhdGUgPSB2Z2ljX3Y1
X3BwaV9zZXRfcGVuZGluZ19zdGF0ZSwNCj4gPiArCS5xdWV1ZV9pcnFfdW5sb2NrID0gdmdpY192
NV9wcGlfcXVldWVfaXJxX3VubG9jaywNCj4gPiArfTsNCj4gPiArDQo+ID4gK3N0YXRpYyBib29s
IHZnaWNfaXNfdjUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+ICt7DQo+ID4gKwlyZXR1cm4g
dmNwdS0+a3ZtLT5hcmNoLnZnaWMudmdpY19tb2RlbCA9PQ0KPiA+IEtWTV9ERVZfVFlQRV9BUk1f
VkdJQ19WNTsNCj4gPiArfQ0KPiA+ICsNCj4gDQo+IERyaXZlLWJ5IGNvbW1lbnQ6IHlvdSBhbHNv
IGhhdmUNCj4gDQo+IGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5oOnN0YXRpYyBpbmxpbmUgYm9v
bCB2Z2ljX2lzX3Y1KHN0cnVjdCBrdm0NCj4gKmt2bSkNCj4gaW5jbHVkZS9rdm0vYXJtX3ZnaWMu
aDojZGVmaW5lIGdpY19pc192NShrKSAoKGspLQ0KPiA+YXJjaC52Z2ljLnZnaWNfbW9kZWwgPT0g
S1ZNX0RFVl9UWVBFX0FSTV9WR0lDX1Y1KQ0KPiANCj4gQXQgbGVhc3QgdHdvIG9mIHRoZW0gaGF2
ZSB0byBkaWUuDQo+IA0KPiAJTS4NCj4gDQpBZ3JlZWQuIFRoaXMgaGFzIGJlZW4gYWRkcmVzc2Vk
IGluIGNvbmp1bmN0aW9uIHdpdGggeW91ciBpbnQgdHlwZQ0KaGVscGVyIHN1Z2dlc3Rpb25zLiBX
ZSdyZSBub3cgYmFjayB0byBoYXZpbmcgT05FIHdheSBvZiBjaGVja2luZyBpZiB0aGUNCnZnaWMg
aXMgdjUuDQoNClRoYW5rcywNClNhc2NoYQ0K

