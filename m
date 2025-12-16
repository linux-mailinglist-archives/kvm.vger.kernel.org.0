Return-Path: <kvm+bounces-66065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ECB80CC20BD
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 12:00:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C7C72305D38E
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 10:58:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35F0C339B58;
	Tue, 16 Dec 2025 10:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oH8+67hw";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oH8+67hw"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013058.outbound.protection.outlook.com [52.101.72.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB5C33509B
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 10:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.58
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765882726; cv=fail; b=DJvaF2kCl2UI78QcYK4jwJIbLyyOBphw2HX3N4w/JB4Z4M2a4U83D8y6py1JJbg0Znyp4hE3Eeb8WrbrE2QPDixZxi0N+uRNZtS+Rb1xGiJJ3Ro/mAjE2Y9VXZ8dqRErAYjxm0w6ea4AiIn+reG3IJcpnaDlrIDfs5w43c2Kils=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765882726; c=relaxed/simple;
	bh=w/BRXCL6ms5qUVMeMb16Eoz0+Bn6/HaJQSYOIPeRluA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fH/DwUUZwMcYlCZycyt1PHrLUdzazl2KokxdAU7zjJ20xhgJIUxR6RjgYCNZ0XuPsSNOGnEh40IzRjOQPZQq5DeUIox1LwYuCbudU9vvT/SfdW5DLabE+8ykkCMvi/Umgp7pSmM+ZvSWZcpqGwaBuJ1mSS2UpCjimf0ZRpbezGU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oH8+67hw; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oH8+67hw; arc=fail smtp.client-ip=52.101.72.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=lKPktz5avmAD8nIA+WRLeTwEI10GBypHqpZTp7yUGsI8l/Fkq6+Taq6u3zk2dr0IjpdYnPsVHKZC1SsErhDbxEFdPVRpMCX+6+7dhXOBFguRyqgE7KF5vjOWYjudTgVbxGbJu01VFY96dTzktl32n4BAc1BT7hcZuaKnbdKcA+yBraBNlG8ZP2vkpYfGGzeLbub2Q94vlyGiii8a+zQrKDf1UCe3MKyWo+x+wvr2KCGJaNdOMhyUcQxqnGvjUxVPuY/zqBa+UMeg0vn/ehn7zBAz3KUECFpbCwW/2/4zGtsF0DFpXdQvhveyPyV2/5F/uVgNHUh64bGZCJ836aLkJQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w/BRXCL6ms5qUVMeMb16Eoz0+Bn6/HaJQSYOIPeRluA=;
 b=Eer86z4ME7HHdYEDcXSfVcWHM7jSMuDEwPc0fZ9Do5dK7Oqc3YtDkc5zrfYWf8g1Mwq186NZS+B/AF1dCq2XhvJ4XLqWpZUsVfobXnZh6Jyyp3UjLxqX9jkI8eNO5Ae3zcC87+FXEG+NvLvpYVPgfk/5Lew1Z2mLv7mqtsgQ23dl7+1IE30T7ysjXHnXKZCHp+DfVA2lvzuPKIT224wpnVz224TuumoGDsjdQfDwF0zDCy+1o5OYYDtyUgurs2bC3YdJu1Ds2wbZrWLkZ1BftYMrId8iXVrL8lYF8fenOYwQMq7ALUkL08UVB0l70GfwMP0aH/uJNbPPnptZXfCjWA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/BRXCL6ms5qUVMeMb16Eoz0+Bn6/HaJQSYOIPeRluA=;
 b=oH8+67hwTM0u2M5E46OI27OqGEml2JICRhojLSP5lhcN/U4zQ4Hqqapx9E2yors55INiL7xEV3ZOYmBxsuw/M8CXzP6VycR5bAOrAkdhneKJiV6J6KTbv2B6m1u4NSpo1U6MW4kUvSVJ+SYlgBTM+M//UR1X2P3bEvI7kf9ZXXs=
Received: from AS4P192CA0018.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:5e1::7)
 by VI1PR08MB5390.eurprd08.prod.outlook.com (2603:10a6:803:13d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 10:58:39 +0000
Received: from AMS0EPF0000019B.eurprd05.prod.outlook.com
 (2603:10a6:20b:5e1:cafe::8d) by AS4P192CA0018.outlook.office365.com
 (2603:10a6:20b:5e1::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via Frontend Transport; Tue,
 16 Dec 2025 10:58:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF0000019B.mail.protection.outlook.com (10.167.16.247) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Tue, 16 Dec 2025 10:58:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q6/FE2YSTxH+q5jtcTHoICUCvvMNErXubhYeDpAQiGOpl6AnjKz13acFPh+o6eb6hHrsAE7U79jbhoxx2B61gk044dnpT3Q6uRg8r/jUIOCxCGvLd+sGGCbALF/sClkIDKGV4yPSJuP3pkOJfPnfs3uFBzGBYMut3hz4Ts2JeFUbVzvgE2kANyh4Y0iSY6W1yIkrVso5/Gufcxf4mzXF9TJCTGza11fLpLyPdxb5im/5M5ruq59sw3vZgTsdx8b9UBFc5tp296Ayd8vphHPMZOxS2aVUKykh5tUAJS+6aUnNU5RvhPeqnlONgVcXxtVNZdzgTMY8+zVwkziwqJVR5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w/BRXCL6ms5qUVMeMb16Eoz0+Bn6/HaJQSYOIPeRluA=;
 b=nZ/JHacc5IXjGtUXlyeHxtHE1n9k5gIWO6eC8UbERxwrgss5Rz3Tf4IF5DmCrynq3IK9ir2H5oXJVoJ04784m1YzJt+KbNslZTAAmnTuTFm4n2ltvaco23mM6qpwqzVcb+f2VlpZUyZGJXwR7acmtsOAEnLxWUM33rl8B/bYNcLeRcSC5W723wWY1iYEJq9qUMmPk8Nw2rMXbQ5i9UTbJ3Va2mAQ2Ekgbw6eXL9rNcqZT2yfo+V8w7VRDCm5z6SEcphL2SZB0uJmN0dYsyhKceGCGBFvrbasrk25NJBLOdvaryLO7NhTygaEwUveZDA6ZtEI3bPALP8qw34gAudsew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/BRXCL6ms5qUVMeMb16Eoz0+Bn6/HaJQSYOIPeRluA=;
 b=oH8+67hwTM0u2M5E46OI27OqGEml2JICRhojLSP5lhcN/U4zQ4Hqqapx9E2yors55INiL7xEV3ZOYmBxsuw/M8CXzP6VycR5bAOrAkdhneKJiV6J6KTbv2B6m1u4NSpo1U6MW4kUvSVJ+SYlgBTM+M//UR1X2P3bEvI7kf9ZXXs=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by DU0PR08MB8280.eurprd08.prod.outlook.com (2603:10a6:10:40c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 10:57:34 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 10:57:34 +0000
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
Subject: Re: [PATCH 10/32] KVM: arm64: gic-v5: Add emulation for
 ICC_IAFFID_EL1 accesses
Thread-Topic: [PATCH 10/32] KVM: arm64: gic-v5: Add emulation for
 ICC_IAFFID_EL1 accesses
Thread-Index: AQHca3smxBv9JjzF/kKDD2nLSHnzorUi+jWAgAEkZQA=
Date: Tue, 16 Dec 2025 10:57:34 +0000
Message-ID: <12821001c8dfacdb45e8541b4fc95e0d5fad8739.camel@arm.com>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
	 <20251212152215.675767-11-sascha.bischoff@arm.com>
	 <86cy4fodns.wl-maz@kernel.org>
In-Reply-To: <86cy4fodns.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|DU0PR08MB8280:EE_|AMS0EPF0000019B:EE_|VI1PR08MB5390:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e5704f7-e6ec-4048-f6aa-08de3c921144
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?c0ZVQW1aempDdHpNRW4yNzAyVVFVKzkxa0hIdGhYa3dUMnV4RzBjSXhWUmxx?=
 =?utf-8?B?S0JNZkM1SVl3MXFrbVFVS3B0WVZnek1HLy81OWI4Z3BwN29lQTdqcGF6UGY5?=
 =?utf-8?B?Z1VydldENTJJS0M5c1Jpb0Z2YTYzb3oxQzcvc2tRY0w1ckNLWWV4UVoyditO?=
 =?utf-8?B?YTVBb0U2ZzMrb1ZYdVZEK1k2VjEyT1FoM3gvUVhGRWNRcVRwOHZObnlVSTUw?=
 =?utf-8?B?Rmh3eE1oWjZhOGRPWXIxek5DdlJiV2kzZ2RpQVNtdFhtc2NBbGdSNXRqek90?=
 =?utf-8?B?M3BHak9YQ21EZ0xpTzN0eGF3ZmZUNG43TEhjUVZPRWxpSWZ0RTJiWUI3WnIy?=
 =?utf-8?B?UXVLRUkwRWRHRkhGaGNQYVFtdU9KSUZ5WnE4SzBjYy9BaUFDQjVaRGVSWG9X?=
 =?utf-8?B?VmdDbWsxdFIxdEFHMWt0Y3NFUGcxcTVnSk5iZHFZcUlMZW5pcytHOUdYSm1z?=
 =?utf-8?B?L1ZtbDUxMXQrUW5OV3gyTXhOZFk0S1JEZXRUSWZWYlpzL1dVZ2JUZXljdVQz?=
 =?utf-8?B?STRsaG5JR1poK3cvYmdDOFZha2xXSWV2aHFWV29lbmk0Ri9ZbDloV3B5WmlY?=
 =?utf-8?B?d1ZIZ0ZpTWM1UlcwUi9LZXBEVHVTMHlXNitOZ01Ec1hteUZpQm84bWt3VWl3?=
 =?utf-8?B?eit1SVQ2aWZxVUlSdkR0aC8wMktBSllwekxVK2hmZmRVV20xR0Jjbmk5QldF?=
 =?utf-8?B?UzNsZTVPeW5FQ1lFdVo4bXlOUGQxbGExbVEzOWxLZWtSeWlPaTFBWkpEaTFw?=
 =?utf-8?B?aVZpdlBPUDdodDdxN0EwWDg5UVNSMDJ6ZVRWejV4eXM3VnJYUXFxaUZmYTZP?=
 =?utf-8?B?TkRGdWh0L1ZpZXNiSUhSZlpCYUI3Z1dOd1VjOHhhcktHdzFLeDh1MnhYcnpQ?=
 =?utf-8?B?Vk0xL1E2bDJYYXpUblB4bmZ2NzJZOE5oNUYwa2dabndLOWRzbllxVFM4dWRV?=
 =?utf-8?B?ektFWTJheEJtZC8yWGc5eWVTSStBS2UrYkVtOVl4TG5oeFVlTk9tK0F1dHoy?=
 =?utf-8?B?RmgzM2lVNDBNcnJCRjlLQ3pDL1pEVnZTcC8rTGgyUE0zK3gvV0ZVd1YvUjBR?=
 =?utf-8?B?cXpFdDVBa203NHVhcmJmYlZxTDlBVzB6N3RnZVdQRFhFYkRjRTQraklLcGtJ?=
 =?utf-8?B?Y2pEdDlUdGRDcy9MRmpFaHp6bTNVUk1ZWk9TREhWd0xWVUVZQ0hJOUxsUWNC?=
 =?utf-8?B?ejJtb1hoNXhGL3M4UEdTdUdPTXJraEt1SVpaTkRlV2Rsa2dlelluV1lFcDFM?=
 =?utf-8?B?T2dXdHlYUmI2R1pCQVFVQkRVc1BaVUs3MUxZUjBSaUp5SGY0OUZGaHlHd2hB?=
 =?utf-8?B?Nnl6cDhiWVlyVVZYZ1hIR3NaV2FtOTlhdElFWGduQlFDT25wemk3dTR5YThK?=
 =?utf-8?B?NUZSSVpWT1FEZGdORmdGeXBHV1NsTUFJSUI4akNOT0RnbUZOOHB0VkZIMnQy?=
 =?utf-8?B?MmwrbjRqYjdvblhHeldVWjY0ZE1sRnB1SWRkUkJQSldXeGUvQ2E2WUVBTDY0?=
 =?utf-8?B?c0IyRmtxKy9tQ1FZMVZ6WllueXE0MWk2WlBla3Ztdy9oVHJ4RGVHb0p5dWda?=
 =?utf-8?B?K1FvUzRUK1hJenMzM0VMV0hYYVBCejJvSVJDY2FUQjQvNERIOGQvTjM0TlFS?=
 =?utf-8?B?ZUwzaGwyMkQxWnN6V1VWYlIxZFdlVWdkUElacG1rUVhMcElMcXNaSEJqT0tL?=
 =?utf-8?B?d3lYQW1hSllFN2p5eVdWK0JNcnJQVVo2QVR1b1QvclFYSGZGL0hydjRJOU5W?=
 =?utf-8?B?bGpWTlJ2VUU1T0hsb0Fzb2lieGFMSDNadWFVeFlEMzczK3JFMWdkeEkrQWdD?=
 =?utf-8?B?OEo4TzF5TGJuaFZCWit1akw2VlE5NGJiOW5uVlJmejZoRGY1eFJRY1ZBbWsr?=
 =?utf-8?B?dTdzMU1GQ2NUQnNrMll3OHgzU0p5ejJOQ3BhOCtNMGp4TkwzaHkrV25OK0hu?=
 =?utf-8?B?T1k5VExhZEI3RndRQ1VLRTdQYXAreDBkMUp2c2tsNGFwOWkxRTl2R211TlF1?=
 =?utf-8?B?ajl0OTdUY3VYMnJRTHBSYjhCTTJMa3JISzc4N2Mzb0lYNkJFTlo1d3BZYWxK?=
 =?utf-8?Q?WmBdpv?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <601010FA0215104C99CDD2DEB298E505@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8280
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF0000019B.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a53023ee-5ea3-468b-6878-08de3c91eb37
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|35042699022|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R0pVRndrU25FbnFZUGxGNFhUaGVObnc5N3A1WWJIdE9vSCtUOE9xRWpMNFYv?=
 =?utf-8?B?Um04RThnbXZJL2gwb3Aza2drdkN6SWtlRTdBRnlwaGR1c0swaEo4QUNucFVD?=
 =?utf-8?B?L0cxWWFVdHVXSjZqMWRtT0tGc3MxT1dkTVNaTzlRTHVzTk1EY3h5M1VnNkdM?=
 =?utf-8?B?ei9OOVkzekVBMFA2MDM3Tm80aDdNc1EzWi8rOUtXdmtEVDhQL2dNKzJidEVY?=
 =?utf-8?B?a1BRWGJjcndTUGk5R211VlluL2JFcUp4czNlVXMzbC9rTXdXVklwSlFBd08z?=
 =?utf-8?B?LzJLaGQzdC8zVkVhc0x5bWpDVjJSL3lWU245cjZDcHc2RFdNcWhxdTB0WTBk?=
 =?utf-8?B?aWIyNm1PQkJqSThqc2duRjdyeUk5aUdPY2MvSWJiK0xhWU56V0RIVDZoVkZ0?=
 =?utf-8?B?VnRYdFIrRVZma1loSTd2bU1naGhBZm5Vbi9iUUZHTTBDaVJlMkFTWFowaVMw?=
 =?utf-8?B?aUxBdEZVSjNpaGZjekV4OHRIYkIrRW1Yem5jcko2QmxkdkNMeGZnUVUwMDdY?=
 =?utf-8?B?K0RVamF1cXlyRGZnOVBoTFZ4aFF3R2VUV20xS1RxMFEzZlRPL0pycElwWHI3?=
 =?utf-8?B?ZUZzOHVPMTN0ZjArbFRsZnhxTHZIR0J1WWlHNUdYZlRMdVh1cXBDRVJ4ME5Q?=
 =?utf-8?B?U05PNWxndjRFYVdqR21qWUc1RlFLaHd3Wm5KbTVDOTNPYTRHYVFuMVFaSVY2?=
 =?utf-8?B?M2E3Z0UvUjFLdE1LZmZjSWtiMGlpNlpuWmZ0S1VncEt6akhoY0FXbWszcW02?=
 =?utf-8?B?WmNXa0VEY2FFbTlGVjgrdGY5anJGT0VYZGQrc21FZXlYOVdBRGw0Wk1xN1Ur?=
 =?utf-8?B?SHRhbnpXVnFXb1czREgzYXpTQTk4QkhBYmZIaThQTkM5QnFWNkduM3RRZlk2?=
 =?utf-8?B?Tm1GV0l1L05YTzBQYVZJVENhamRkNHlnZ3RuajJEa2FwUFlCOUFDV3pVYm5S?=
 =?utf-8?B?KzUrZll0RUlXZ1pCMUhua3VHSlQwb0Y2azVnajhoaHZ3cE1xMytNeG9YVncz?=
 =?utf-8?B?TVlDeGJnejFPRlVUR0xqdnpkNWhlR09WZUJ2UzhoaHkxcVhTZ04vSDlDQU9a?=
 =?utf-8?B?Qnl0WVlGTHlUTEMvWUFhTERhOVFjc2pzMGlPVG9zUS9MQUExMEVJbG12dytJ?=
 =?utf-8?B?QWRmRVNNeDZYUW5iN0xYaHd2MVlsRFNQVHlXeWd4dklyeW01V3Q3d25jdjhX?=
 =?utf-8?B?a3BxVk9vaS8xN0s2Q1lLNUJpTzlVZTBJSlR6Q0c1ODBRYjVGR2Q5c29qZjky?=
 =?utf-8?B?MExQV3hDSDl1bWdJbGM2U04ycXZoREsrNGJrbERpc0JmNzVsS3lyS3htOEFX?=
 =?utf-8?B?WDdQdXJzeXpKanRVMkQyWUhkRHp3RjZWWVNsWUxaTkdlTXNMUERObStVcS8w?=
 =?utf-8?B?U1RJNmE4dFRhb3lERzlWSXFUelZNUXNlTmtlVER4byt4aXlZNDhodU9HN05s?=
 =?utf-8?B?ZVpWNXZBSzRuOXBKdkxrbU5QSnB2VXlHallOODhCd1ovSVFCVndYUTdsTDN3?=
 =?utf-8?B?S0g2UWUzSUdYSnFkVXIyNDA5VTQ4dlhFUjBUUUpZNFhJd0JLQzFNSEJ5ZEVV?=
 =?utf-8?B?SVBUNlFNMHFtODdaMW9pYmFLM1pQWXc5SGhwYXg5dXJjZHlUUHhYWmUxMjV4?=
 =?utf-8?B?cTFWVXd4RlpGZitRZ09IUExZd1FtQXl6WDdlZHc4eEkxMUpiZkg3RWdRTjlC?=
 =?utf-8?B?ZHpSRVQwVmhwSE16dE1DYUFsVmxITWZnQkdwWWRrbndtdTh3WWo1UGpSeXRX?=
 =?utf-8?B?Q2RxRmVZcnBTdnpXbmhuY2Y5a0pXeXpIWnVrbVVOdmJIVFcwV3N5TDNrcWFJ?=
 =?utf-8?B?NU5ZVEU5SVA2cVlxYTdWMTlkYmlpTkd5SWtyd2Y3TlBqMEY1Y2s5MGM2akJh?=
 =?utf-8?B?MER0TXVhOU9oT1VRZGVmbFQzR2VUMDcyVk5CY2pyTjFJOWhSZTVMY3pQenBR?=
 =?utf-8?B?aDFERG9lWWxEMnp1cXhJM2F5QlMxNFBBYnc3NmRWZTNlYm5zdlp3SnJCWFFC?=
 =?utf-8?B?T2pPNEJJUk14YnNmMlRZRlppVnFodDNieERkU2JmY3RUWUNVOFFSbzgrMlQz?=
 =?utf-8?B?VUgxektpY21KbmtjMkNJc2JFUVZLeUFZVURhcWMvYnA2cVBQc1ZnWmwzdEJ5?=
 =?utf-8?Q?Kr9g=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(35042699022)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 10:58:38.4773
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e5704f7-e6ec-4048-f6aa-08de3c921144
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF0000019B.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5390

T24gTW9uLCAyMDI1LTEyLTE1IGF0IDE3OjMxICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIEZyaSwgMTIgRGVjIDIwMjUgMTU6MjI6MzggKzAwMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEdJQ3Y1IGRvZXNuJ3Qg
aW5jbHVkZSBhbiBJQ1ZfSUFGRklEUl9FTDEgb3IgSUNIX0lBRkZJRFJfRUwyIGZvcg0KPiA+IHBy
b3ZpZGluZyB0aGUgSUFGRklEIHRvIHRoZSBndWVzdC4gQSBndWVzdCBhY2Nlc3MgdG8gdGhlDQo+
ID4gSUNIX0lBRkZJRFJfRUwxIG11c3QgdGhlcmVmb3JlIGJlIHRyYXBwZWQgYW5kIGVtdWxhdGVk
IHRvIGF2b2lkIHRoZQ0KPiANCj4gbml0OiBJQ0NfSUFGRklEUl9FTDEuIFRoZXJlIGlzIG5vIElD
SF8qX0VMMSByZWdpc3Rlci4NCj4gDQo+ID4gZ3Vlc3QgYWNjZXNzaW5nIHRoZSBob3N0J3MgSUND
X0lBRkZJRFJfRUwxLg0KPiA+IA0KPiA+IEZvciBHSUN2NSwgdGhlIFZQRSBJRCBjb3JyZXNwb25k
cyB0byB0aGUgdmlydHVhbCBJQUZGSUQgZm9yIHRoZQ0KPiA+IHB1cnBvc2VzIG9mIHNwZWNpZnlp
bmcgdGhlIGFmZmluaXR5IG9mIHZpcnR1YWwgaW50ZXJydXB0cy4gVGhlIFZQRQ0KPiA+IElEDQo+
ID4gaXMgdGhlIGluZGV4IGludG8gdGhlIFZQRSBUYWJsZSwgd2hpY2ggd2lsbCBiZSB0aGUgc2Ft
ZSBhcyB0aGUNCj4gPiB2Y3B1LT52Y3B1X2lkIG9uY2UgdGhlIHZhcmlvdXMgR0lDdjUgVk0gdGFi
bGVzIGFyZSBpbnRyb2R1Y2VkLiBBdA0KPiA+IHRoaXMNCj4gPiBzdGFnZSwgc2FpZCBWTSB0YWJs
ZXMgaGF2ZSB5ZXQgdG8gYmUgaW50cm9kdWNlZCBhcyB0aGV5IGFyZSBub3QNCj4gPiByZXF1aXJl
ZCBmb3IgUFBJIHN1cHBvcnQuIE1vcmVvdmVyLCB0aGUgSUFGRklEIHNob3VsZCBnbyBsYXJnZWx5
DQo+ID4gdW51c2VkIGJ5IGFueSBndWVzdCB1c2luZyBqdXN0IFBQSXMgYXMgdGhleSBhcmUgbm90
IHJvdXRhYmxlIHRvIGENCj4gPiBkaWZmZXJlbnQgUEUuIFRoYXQgc2FpZCwgd2Ugc3RpbGwgbmVl
ZCB0byB0cmFwIGFuZCBlbXVsYXRlIHRoZQ0KPiA+IGd1ZXN0J3MNCj4gPiBhY2Nlc3NlcyB0byBh
dm9pZCBsZWFraW5nIGhvc3Qgc3RhdGUgaW50byB0aGUgZ3Vlc3QuDQo+IA0KPiBJIHRoaW5rIHlv
dSBjYW4gdHJpbSBzb21lIG9mIHRoaXMuIEp1c3Qgc3RhdGUgdGhhdCBLVk0gbWFrZXMgdGhlDQo+
IElBRkZJRFIsIFZQRUlEIGFuZCB2Y3B1X2lkIHRoZSBzYW1lIHRoaW5nLCBhbmQgdGhhdCdsbCBi
ZSBnb29kDQo+IGVub3VnaC4NCj4gDQo+ID4gDQo+ID4gVGhlIHZpcnR1YWwgSUFGRklEIGlzIHBy
b3ZpZGVkIHRvIHRoZSBndWVzdCB3aGVuIGl0IHJlYWRzDQo+ID4gSUNDX0lBRkZJRF9FTDEgKHdo
aWNoIGFsd2F5cyB0cmFwcyBiYWNrIHRvIHRoZSBoeXBlcnZpc29yKS4gV3JpdGVzDQo+ID4gYXJl
DQo+ID4gcmlnaHRseSBpZ25vcmVkLg0KPiA+IA0KPiA+IFRoZSB0cmFwcGluZyBmb3IgdGhlIElD
Q19JQUZGSURSX0VMMiBpcyBhbHdheXMgZW5hYmxlZCB3aGVuIGluIGENCj4gPiBndWVzdA0KPiA+
IGNvbnRleHQuDQo+IA0KPiBUaGlzIHJlZ2lzdGVyIGRvZXNuJ3QgZXhpc3QgZWl0aGVyLg0KPiAN
Cg0KWWlrZXMuIEkgcmVhbGx5IHdhc24ndCBoYXZpbmcgYSBnb29kIGRheSB3aXRoIG15IHJlZ2lz
dGVyIG5hbWVzLiBJJ3ZlDQphZGRyZXNzZWQgdGhlc2Ugbm93IGFuZCBoYXZlIGNvbXBhY3RlZCBk
b3duIHRoYXQgcGFyYWdyYXBoLg0KDQo+ID4gDQo+ID4gQ28tYXV0aG9yZWQtYnk6IFRpbW90aHkg
SGF5ZXMgPHRpbW90aHkuaGF5ZXNAYXJtLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBUaW1vdGh5
IEhheWVzIDx0aW1vdGh5LmhheWVzQGFybS5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogU2FzY2hh
IEJpc2Nob2ZmIDxzYXNjaGEuYmlzY2hvZmZAYXJtLmNvbT4NCj4gPiAtLS0NCj4gPiDCoGFyY2gv
YXJtNjQva3ZtL2NvbmZpZy5jwqDCoCB8IDEwICsrKysrKysrKy0NCj4gPiDCoGFyY2gvYXJtNjQv
a3ZtL3N5c19yZWdzLmMgfCAxOSArKysrKysrKysrKysrKysrKysrDQo+ID4gwqAyIGZpbGVzIGNo
YW5nZWQsIDI4IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPiANCj4gPiBkaWZmIC0t
Z2l0IGEvYXJjaC9hcm02NC9rdm0vY29uZmlnLmMgYi9hcmNoL2FybTY0L2t2bS9jb25maWcuYw0K
PiA+IGluZGV4IDU3ZWY2N2Y3MTgxMTMuLmNiZGQ4YWM5MGY0ZDAgMTAwNjQ0DQo+ID4gLS0tIGEv
YXJjaC9hcm02NC9rdm0vY29uZmlnLmMNCj4gPiArKysgYi9hcmNoL2FybTY0L2t2bS9jb25maWcu
Yw0KPiA+IEBAIC0xNTgyLDYgKzE1ODIsMTQgQEAgc3RhdGljIHZvaWQgX19jb21wdXRlX2hkZmd3
dHIoc3RydWN0DQo+ID4ga3ZtX3ZjcHUgKnZjcHUpDQo+ID4gwqAJCSp2Y3B1X2ZndCh2Y3B1LCBI
REZHV1RSX0VMMikgfD0NCj4gPiBIREZHV1RSX0VMMl9NRFNDUl9FTDE7DQo+ID4gwqB9DQo+ID4g
wqANCj4gPiArc3RhdGljIHZvaWQgX19jb21wdXRlX2ljaF9oZmdydHIoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1KQ0KPiA+ICt7DQo+ID4gKwlfX2NvbXB1dGVfZmd0KHZjcHUsIElDSF9IRkdSVFJfRUwy
KTsNCj4gPiArDQo+ID4gKwkvKiBJQ0NfSUFGRklEUl9FTDEgKmFsd2F5cyogbmVlZHMgdG8gYmUg
dHJhcHBlZCB3aGVuDQo+ID4gcnVubmluZyBhIGd1ZXN0ICovDQo+ID4gKwkqdmNwdV9mZ3QodmNw
dSwgSUNIX0hGR1JUUl9FTDIpICY9DQo+ID4gfklDSF9IRkdSVFJfRUwyX0lDQ19JQUZGSURSX0VM
MTsNCj4gDQo+IFNsaWdodGx5IHJlZHVuZGFudCB3aGVuICFHSUN2NSBpbiB0aGUgZ3Vlc3QsIGJ1
dCB0aGF0J3Mgbm90IHJlYWxseSBhDQo+IHByb2JsZW0uDQo+IA0KPiA+ICt9DQo+ID4gKw0KPiA+
IMKgdm9pZCBrdm1fdmNwdV9sb2FkX2ZndChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ID4gwqB7
DQo+ID4gwqAJaWYgKCFjcHVzX2hhdmVfZmluYWxfY2FwKEFSTTY0X0hBU19GR1QpKQ0KPiA+IEBA
IC0xNjA3LDcgKzE2MTUsNyBAQCB2b2lkIGt2bV92Y3B1X2xvYWRfZmd0KHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSkNCj4gPiDCoAlpZiAoIWNwdXNfaGF2ZV9maW5hbF9jYXAoQVJNNjRfSEFTX0dJQ1Y1
X0NQVUlGKSkNCj4gPiDCoAkJcmV0dXJuOw0KPiA+IMKgDQo+ID4gLQlfX2NvbXB1dGVfZmd0KHZj
cHUsIElDSF9IRkdSVFJfRUwyKTsNCj4gPiArCV9fY29tcHV0ZV9pY2hfaGZncnRyKHZjcHUpOw0K
PiA+IMKgCV9fY29tcHV0ZV9mZ3QodmNwdSwgSUNIX0hGR1dUUl9FTDIpOw0KPiA+IMKgCV9fY29t
cHV0ZV9mZ3QodmNwdSwgSUNIX0hGR0lUUl9FTDIpOw0KPiA+IMKgfQ0KPiA+IGRpZmYgLS1naXQg
YS9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jIGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYw0K
PiA+IGluZGV4IGZiYmQ3YjZmZjY1MDcuLjMxYzA4ZmQ1OTFkMDggMTAwNjQ0DQo+ID4gLS0tIGEv
YXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3N5c19y
ZWdzLmMNCj4gPiBAQCAtNjgxLDYgKzY4MSwyNCBAQCBzdGF0aWMgYm9vbCBhY2Nlc3NfZ2ljX2Rp
cihzdHJ1Y3Qga3ZtX3ZjcHUNCj4gPiAqdmNwdSwNCj4gPiDCoAlyZXR1cm4gdHJ1ZTsNCj4gPiDC
oH0NCj4gPiDCoA0KPiA+ICtzdGF0aWMgYm9vbCBhY2Nlc3NfZ2ljdjVfaWFmZmlkKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwgc3RydWN0DQo+ID4gc3lzX3JlZ19wYXJhbXMgKnAsDQo+ID4gKwkJCQlj
b25zdCBzdHJ1Y3Qgc3lzX3JlZ19kZXNjICpyKQ0KPiA+ICt7DQo+ID4gKwlpZiAoIXZnaWNfaXNf
djUodmNwdS0+a3ZtKSkNCj4gPiArCQlyZXR1cm4gdW5kZWZfYWNjZXNzKHZjcHUsIHAsIHIpOw0K
PiANCj4gU2hvdWxkbid0IHRoaXMgYmUgcmVhZGlseSBoYW5kbGVkIGJ5IHRoZSBGR1UgY29uZmln
dXJhdGlvbiBpbiB0aGUNCj4gYWJzZW5jZSBvZiBHSUN2NSBpbiB0aGUgZ3Vlc3Q/DQo+IA0KDQpZ
ZWFoLCBpdCBzaG91bGQgYmUuIFRoaXMgd2FzIHdyaXR0ZW4gYmVmb3JlIEdJQ3Y1IHdhcyBwbHVt
YmVkIGludG8gdGhlDQpGR1VzLiBJJ3ZlIGp1c3QgdGVzdGVkIGl0LCBhbmQgaXQgdW5kZWZzIGNv
cnJlY3RseSB3aXRob3V0IHRoZSBleHBsaWNpdA0KY2hlY2ssIHNvIEkndmUgZHJvcHBlZCB0aGlz
Lg0KDQpUaGFua3MsDQpTYXNjaGENCg0KPiA+ICsNCj4gPiArCWlmIChwLT5pc193cml0ZSkNCj4g
PiArCQlyZXR1cm4gaWdub3JlX3dyaXRlKHZjcHUsIHApOw0KPiA+ICsNCj4gPiArCS8qDQo+ID4g
KwkgKiBGb3IgR0lDdjUgVk1zLCB0aGUgSUFGRklEIHZhbHVlIGlzIHRoZSBzYW1lIGFzIHRoZSBW
UEUNCj4gPiBJRC4gVGhlIFZQRSBJRA0KPiA+ICsJICogaXMgdGhlIHNhbWUgYXMgdGhlIFZDUFUn
cyBJRC4NCj4gPiArCSAqLw0KPiA+ICsJcC0+cmVndmFsID0gRklFTERfUFJFUChJQ0NfSUFGRklE
Ul9FTDFfSUFGRklELCB2Y3B1LQ0KPiA+ID52Y3B1X2lkKTsNCj4gPiArDQo+ID4gKwlyZXR1cm4g
dHJ1ZTsNCj4gPiArfQ0KPiA+ICsNCj4gPiDCoHN0YXRpYyBib29sIHRyYXBfcmF6X3dpKHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSwNCj4gPiDCoAkJCXN0cnVjdCBzeXNfcmVnX3BhcmFtcyAqcCwNCj4g
PiDCoAkJCWNvbnN0IHN0cnVjdCBzeXNfcmVnX2Rlc2MgKnIpDQo+ID4gQEAgLTM0MTEsNiArMzQy
OSw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgc3lzX3JlZ19kZXNjDQo+ID4gc3lzX3JlZ19kZXNj
c1tdID0gew0KPiA+IMKgCXsgU1lTX0RFU0MoU1lTX0lDQ19BUDFSMV9FTDEpLCB1bmRlZl9hY2Nl
c3MgfSwNCj4gPiDCoAl7IFNZU19ERVNDKFNZU19JQ0NfQVAxUjJfRUwxKSwgdW5kZWZfYWNjZXNz
IH0sDQo+ID4gwqAJeyBTWVNfREVTQyhTWVNfSUNDX0FQMVIzX0VMMSksIHVuZGVmX2FjY2VzcyB9
LA0KPiA+ICsJeyBTWVNfREVTQyhTWVNfSUNDX0lBRkZJRFJfRUwxKSwgYWNjZXNzX2dpY3Y1X2lh
ZmZpZCB9LA0KPiA+IMKgCXsgU1lTX0RFU0MoU1lTX0lDQ19ESVJfRUwxKSwgYWNjZXNzX2dpY19k
aXIgfSwNCj4gPiDCoAl7IFNZU19ERVNDKFNZU19JQ0NfUlBSX0VMMSksIHVuZGVmX2FjY2VzcyB9
LA0KPiA+IMKgCXsgU1lTX0RFU0MoU1lTX0lDQ19TR0kxUl9FTDEpLCBhY2Nlc3NfZ2ljX3NnaSB9
LA0KPiANCj4gVGhhbmtzLA0KPiANCj4gCU0uDQo+IA0KDQo=

