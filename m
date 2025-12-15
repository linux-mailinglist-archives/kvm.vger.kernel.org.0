Return-Path: <kvm+bounces-65968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 432F7CBE499
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 15:30:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 60DED305F67A
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 14:25:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0E5F328613;
	Mon, 15 Dec 2025 14:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="efk6rJmQ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="efk6rJmQ"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011059.outbound.protection.outlook.com [52.101.70.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2A33126AC
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 14:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.59
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765808179; cv=fail; b=KqzTmVOGd0TVexpVSNDV0RpFAWWQcYcVQ90yJw3QD++YndFhxweoM3GTyZoSd1uQtFu5KwLvuCvuoFMN7M//oQx/OMzfQ/05d9ZvM9k8G/yIeUw1bCeUA2PksPBHOEL+CE+MG7yOwpYJ5ZQ+g4VWPLkMCFC9LCNlmClaA+aJA2c=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765808179; c=relaxed/simple;
	bh=iq/OEAJwK/tiL4jZiA8DrSquKTgwlypSxFR9F4vh33M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T4EazD4d/VobnZ+/jx/+zUEnWw5O5eNePUDEwC61bUcFdMWeJB7VO0hxEBtDmVcZSbUeAKNFUHDKmZFVww1SADLNFqjekFbhMOD507GDcxyGfQx9YPezPI0zDfn5t/6ATc9i0rLDff6r66EITBgvf0uO2YDjKhXzrWUKaKXg1Yk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=efk6rJmQ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=efk6rJmQ; arc=fail smtp.client-ip=52.101.70.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=h3Im0YvqwJ5hgc36w0FkfXI3INmNjhJv2DZ0UaSRvmMFQ6GTQvtSi91WbZLOGyBIRrzwEz83IQ092q/Jm11dovy0ikVlYgXqsZ9H6n5ZWFJWL7BIMuEhEoZ8nBeKBtLTTSdAhpHGOxnSVb6Gnux1ops0tKZ0eMMy095I1IaVlwVbmqc4NICEx8n58SY6m3mYsqSKD6+D+oLCWClQJttSvKGVr9ARYD1PSEX20oH/AB2hU1EQ4tTr19LygD6zSFVtU6HpWxI7QtBLW57U/ULXrDhwlbERbZKM5TMSvRO4icqz44MMndNq24Sk/rC3xxWFZZdIJ/Rl+sv/FhWqV77Kmw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iq/OEAJwK/tiL4jZiA8DrSquKTgwlypSxFR9F4vh33M=;
 b=v8jgz+94lP9S86hmeHMia8YIa4m5zXL3++Lg9bImY/pl43BWi9Phc+euKYi0kNgd7I1Q/H72x2/pHGv0+XwSGHg1ihHpAOUnILBc4EvlbZ9urC903IdI+zcNcz1ZoNfUwkZAhCPf6p6w/r+qIbH2xlb9gsFct90OyTWTwF4oxRj26Ev+ULDcY98le2LgiubfCtQFU6kdKKuXpXM+MQN0dIcd6OQkYyYU/t4XGrffdxR1a2M4Pc3mNjN9GamrgOxkrP0sjSqnmg+gQKaxVsDJHfmNdZboNMtSZKOGYvy6fRLgB1KEDnhZ3qbmR0R0/hJXfX45GWvXLcmXFEMvth/JMg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iq/OEAJwK/tiL4jZiA8DrSquKTgwlypSxFR9F4vh33M=;
 b=efk6rJmQq5OPFavSVmFdaySZTsbZfzQMGj2ZvS4W8m6Ix+hmG/QFlU0JkoJu0SXvZWIxeYYqyloQwWMX53avI5q0syQTSkwpLC/E7t5Yrd0M1WsIBohCa3gNIQXmJM2nELQoqM22EZCVVnFk5OK5efZaQjcYvQ1w0hQPETXfsO4=
Received: from CWXP123CA0021.GBRP123.PROD.OUTLOOK.COM (2603:10a6:401:73::33)
 by GV2PR08MB11540.eurprd08.prod.outlook.com (2603:10a6:150:2c9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 14:16:06 +0000
Received: from AMS1EPF00000044.eurprd04.prod.outlook.com
 (2603:10a6:401:73:cafe::20) by CWXP123CA0021.outlook.office365.com
 (2603:10a6:401:73::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Mon,
 15 Dec 2025 14:16:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000044.mail.protection.outlook.com (10.167.16.41) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Mon, 15 Dec 2025 14:16:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ehD59Mq3mnCQnO7p0Mg6dPifCLU94fkJ/c6b253XPoxqmksV0EWHiPybszYq7eiqm4rLsLDpbOccUwOOdFciNyyoU7VrfshGCE2BLjxppVbjWhDaFzuBi8EOaYYinYMYDNrSckj/gJqwVr6qPpKBuL9274OKSpSP+1V5uu4W14IiwhOhFjp5CoGVUCotgL95p1cGNdB3+G/0Ta1Os3fnSHeOtMpDYXKYS8ZGfH6AY1ZdWlUmepPefpgf7QIH62XcGJvRKKAzskrpSwtW6PUiHUQ/mVq/HAonE4PPGrmunEOPIhxIXmbf8RphnxIwNU9DbmGBPzTu0v7vxJ/Cz6ouZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iq/OEAJwK/tiL4jZiA8DrSquKTgwlypSxFR9F4vh33M=;
 b=moHt+kIziXW5eGy/bfiR+/QtdLh0KrSbW5oJCweC22QEPV6sZEZ/k5jp/aZL/tRYikXh7wHL15fdelkhCNnCiy/90ityFgyB9RfjGOXTRVxmCA56lQkbmwNckAZxvZAlOtK5rxCjTvR/P8cElMGisc9Ge53iYWxcBnvJqs9twH1KzwjSBp3wK5MteMrTEhuc/8V1UU2eG/y3gD6J1KSyH1fxnKZ3TB0U427dX8wFNHSZJ/9J/3WscEJP/TRkK8IdsGo7rgBc1YS2vFH1fb7bnhITwkCL1bPUDXxkpOAR9KNV6xPLOXkd18U4lcRFy4SrDoRExShez1jpojUTIwi58g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iq/OEAJwK/tiL4jZiA8DrSquKTgwlypSxFR9F4vh33M=;
 b=efk6rJmQq5OPFavSVmFdaySZTsbZfzQMGj2ZvS4W8m6Ix+hmG/QFlU0JkoJu0SXvZWIxeYYqyloQwWMX53avI5q0syQTSkwpLC/E7t5Yrd0M1WsIBohCa3gNIQXmJM2nELQoqM22EZCVVnFk5OK5efZaQjcYvQ1w0hQPETXfsO4=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by VI0PR08MB11382.eurprd08.prod.outlook.com (2603:10a6:800:2fd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 14:15:03 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 14:15:03 +0000
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
Subject: Re: [PATCH 02/32] KVM: arm64: gic-v3: Switch vGIC-v3 to use generated
 ICH_VMCR_EL2
Thread-Topic: [PATCH 02/32] KVM: arm64: gic-v3: Switch vGIC-v3 to use
 generated ICH_VMCR_EL2
Thread-Index: AQHca3skmTnBmPvFJEucTVfSTrklLbUim3oAgAAn9wA=
Date: Mon, 15 Dec 2025 14:15:03 +0000
Message-ID: <ece413c8b70e30f39052fb29371e9a75c239ff9e.camel@arm.com>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
	 <20251212152215.675767-3-sascha.bischoff@arm.com>
	 <86ldj4nesf.wl-maz@kernel.org>
In-Reply-To: <86ldj4nesf.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|VI0PR08MB11382:EE_|AMS1EPF00000044:EE_|GV2PR08MB11540:EE_
X-MS-Office365-Filtering-Correlation-Id: 6be11043-2bb5-4e4a-f63b-08de3be47cbb
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?VndsRzlqZmlCakNyaEtHNDE4UVR3S0xjLzRseEMzd2FOOHlqeWo4Q2czUCtt?=
 =?utf-8?B?MFkzYTVKVXV5T0JnblVKdkx0UDVWQ3BrRzBGTlEvWHoyMXc5a2s1cXNqSlRx?=
 =?utf-8?B?Z1Y1blNoUWppZEsyY056MEVEYkVYWXZaMDB5YVBycUhKeWtXQ2pwWWhRWHdH?=
 =?utf-8?B?dVdQT0ZKSWFoVHlpeXRkQTlmRm9oRDMrYXVMZzNxSmZOMHFWM0JtVVVhMTdp?=
 =?utf-8?B?N1BKeTZ3VTBVbjk2emYyOXBqYTRhNlVVdGRabHFYRDN3OGxsc1QrSGFzY0NL?=
 =?utf-8?B?bUIxTzJ6ZG0rRGp6Q2JIcDI0eUt0R0hXTEF0aHJIRnBlSm5zQ0lkVGIvekZD?=
 =?utf-8?B?L1orNklNeWM3N3N6NUUzR3JhdVhFRFMrWEtDMlBQTEdNSkNPOE0vdzZjNUZW?=
 =?utf-8?B?dmZaU3BiUjVZZkJPak1KNEliRFRDZERBTUp2dWk1MEQyZm5lRW10SGxzTytk?=
 =?utf-8?B?a2ZmcU8yaklFNmkvQ283MHVZK3lLeG5hcEUvTW94Z0lCQlBLbS9EU0xaT3Js?=
 =?utf-8?B?ODM0WDIyNTYxc1NaWTBOckd3YkgzcU1nK29kejVaNWNVK2t1Qi85RkNlRkpT?=
 =?utf-8?B?eHIya1JycDJlaEc1SFpiY0lkK2s4Y2FPNDN4ZkNrcG5XVllOemtyNjd0VlFj?=
 =?utf-8?B?WEd4N2MzSzRMRE5ib0R2ZmJFMzgrd3E5WW5DMDM1ekVUUFY5LzdlR0tKcG5h?=
 =?utf-8?B?cHBFd21Qc0lhT29JekIvY3ZCUmdRTVExS2R0SldNYWE5RzAvRXpJREVLeVY0?=
 =?utf-8?B?RGZmSEhEZkcyQVcxSjhwSTBOTGp4RU9hb1FxSHVkajNuQ1RWUVozdVNGcytu?=
 =?utf-8?B?d1l0ME1mN21vWk4vcVYyTkJNaWpBKzhMVEdvUWV2YzBRT3IzSXYyemF0VkZa?=
 =?utf-8?B?S2dHVXRYQ09wcWdBSE1VV2VsYzdoSnp3ZXE5UDV4QmdxZE0vbHJjcTBSUnJy?=
 =?utf-8?B?T2kzb3Z5VklUdmkrTTNXRU9oZkMzU3ltb0VFc3ROK1NqeHF0ZjVQaUZCeXht?=
 =?utf-8?B?bGdHWkJDenZjbFFibER0RmVLcTZNMC96QnhSYVZmYmM3SEpMYVlYajRpQkRF?=
 =?utf-8?B?M1o5VGJBd2JZUHNIbjJsLzVRa0FaQ0dEVFUrYUpPeks3YWwxWUd0RFNMTFBn?=
 =?utf-8?B?WFIxeW55c2xkZW5OOVNlcTh5SzE1WWVEWmd6ankxc2NObkg5Z1BJcCt5dHMz?=
 =?utf-8?B?aDlCelJ2azBDT05NYzZHZXdLdDhNSkRFNXRjeFU4YW1NYkZrQ0RoWGhIa1hv?=
 =?utf-8?B?Qm0ySW1nQnc4djAxZ1A5YWx6ajFZYTVMQzIrQ1JkSTFKWFBYRFNQRWw5Y2dl?=
 =?utf-8?B?QXRBNDZRSnNjend6N3FTMjBMOWRDaWRUcmlGRmZzbjg4c0ZwUjI5YlQzRmxJ?=
 =?utf-8?B?Ri9vWG12OStjSzJ6dU1BMU9GWVFYR0hvVUpucXMvMVo3MXNNWnNsQzhKT2pi?=
 =?utf-8?B?Y3pnVEJ5amZMeDNXN1F3NTA0aVV1VlE2MXFsTkExT2xBajBiYk5CU21Ed045?=
 =?utf-8?B?MVdVZUlxNDlpdkROMU8zL2N5bE1VOS9WRXJqYitOZ1RBZ1haWjREWHRvaC9a?=
 =?utf-8?B?akszWDhVTVI4QzRVMkxZSzEwY0FPbDZJVWZROXVZM2w0cU9WU1dEOWJwa2RX?=
 =?utf-8?B?a1Zzd2kvUzVzQVhEYWtkQ0pCQXowQ1AzNkIrNUpvZmY4cXBBWUh6SXk2OHBq?=
 =?utf-8?B?aXJyVDF4bGE0Nnh4WnhNUHFZdDB2cDJIMTFDbzFYQTlQem1KSnhtM3RvcFNM?=
 =?utf-8?B?R3kwaUFWM0RBQkh5OXpsRFBKWkdYOHlJZk1KQkJ0MlFxTWZUVEJ5enMyRTFD?=
 =?utf-8?B?VDJ4V0pZYTB0eVlZVlNnZVQ3Q3ZGc3dSTHdQdVZYSlpaaU9qQkJOWDRrQ0V6?=
 =?utf-8?B?bEM3SUhSTkdvMWFFaFo4UUxEd3Rab0RCZFdqdDB3MTVqWFREbmJaMkQyWm5U?=
 =?utf-8?B?ZGltaHMrWkx2RTI2REVlV3dBa0k1MGhidnZSSGlpSWpBVzA0WmRlMUx6RCtn?=
 =?utf-8?B?SlBQaFc2RmVCS2VxRWFNTXoxRjBMWTRaYm81cWZYR2NnY2dnaTVGa3hzcXla?=
 =?utf-8?Q?EUhziv?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <D16DD501C42881479A1BD13DD1AEF7DE@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11382
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000044.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c68986cb-eb6a-4a2d-74c6-08de3be45701
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|82310400026|1800799024|36860700013|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SWF5MnlsZmh3ZlYvWmo0TlRRbEZ5MUJGWCtUNzZWdmRrVGphYk5UMXpYRVdD?=
 =?utf-8?B?V3lCN3NmOEhZazBjbCtGZ21uU1lIakFET3hGUWpsZzg5MTJhTkxKR0hEVGRv?=
 =?utf-8?B?YzdxSW5tSUNFQmVXSUlzNkZ0c005cmFKNTdsSHMxRGY4eWo1U1hDK29YRUNa?=
 =?utf-8?B?eU8yVTI2NnAxSnJZNGZxNm9RSlNGL0pjWW9xNThlS0JHaTdVL3FDSklFeWxu?=
 =?utf-8?B?ZlltcWV2MmtjSEZQMXJhbEpoM1NSbDB5V0EzYWdlWCtGblgwRkdRUDErSnpS?=
 =?utf-8?B?N0l5M3VtV2RnWk1ZT0hDQVRldjAyRUdrYnFKMkE0b0VveFdBNklFSGV2ckRj?=
 =?utf-8?B?Z2ZuQWtpMGEwenlIWUl2dmczYWlyZ1M5Sm9pMWg2TnNOZnVEZU5EV1FZTVpH?=
 =?utf-8?B?ZEN2WXJoQUxMNnEyS242cnB3eVhBRWpNQTBCMUFJeWREV1FSSmpwUU9aUSty?=
 =?utf-8?B?OUNoWTRNTGF3Mk4rWmJJOTF6cUJZZG9kKzB6QTJIaSszaW1uRStBVmRVRXN6?=
 =?utf-8?B?L3N0WmxtSDRIbXlleFFYWlRqWEl2OWxkSTFmUTEySkdnUElub21xSzFncUw3?=
 =?utf-8?B?MjhnRTVrSVVOREJUUG5SR054WVpCRGZIdkFKZitycmdXbEtxQVhDM1FvSGVv?=
 =?utf-8?B?ZkMybGcvR01DUDM3ZzhHUnoxa2VWbkx1UXpqUmxnOE55M0pIVER6TUQ1T2pl?=
 =?utf-8?B?a2NxVHVmQmR6dzZuOUJ5c3JzcndKTWhXaVhxRitjNGZhV0dmNUZqaE8zL1dD?=
 =?utf-8?B?dm81N0pOS0c2QU9ybnY1ZzFZaTlTNEZHRkd6TFhZdGo3MVd2Z0pZZjVwalBT?=
 =?utf-8?B?OVJRQzFPNXk1TXJuR3pJbjBNQjg5SFFJZUNQV2ZBVTA2bmxtRFJqZFpWNUR6?=
 =?utf-8?B?T2pyWVR1NXllR1hmbmg2NkVnZ2xhL09CM05NVSs0UXVIVE9URDFyYlExclB3?=
 =?utf-8?B?Snh5N1JvN1dEeEhHRVVCWmtPTXJnbnlMRUVqNk00cldNd213aUVHcXo1NzUy?=
 =?utf-8?B?ZU1PZThaZEp2MEhGbm1rd1pVaXNHOEZreU1xck0xUWNFSSs3V1p6WVR3aVQ4?=
 =?utf-8?B?aklVVldhQVdPVW5La3lzdk01TXZFNUE1Yk1QT20xMjd4THpDb1pwcm5UTjVa?=
 =?utf-8?B?TW8wQWJUWjR3U2w5Rm9IRTlaQVlzVHZBQUN5VWE5d1RLYStOSXNPcmgrK2Fp?=
 =?utf-8?B?ZXNwZzdkV0dNd0xWbUxOaTZDYk9tTGcyRkNmTFg1b3hlY1F3dHlFQ2RUYXls?=
 =?utf-8?B?eE92K2pqUy9TUFJ3OStvOWcwdmVKZmdzQjFlVTZmQ01BL0RCZkhPeWR3aXhE?=
 =?utf-8?B?Rk5hcW5MYkViOVg3YUtiRXBUVEtOVUpmcnYwRzFBYlA5OElXQThZT3FuT0Qv?=
 =?utf-8?B?UnZ5VngyYW9GdWcxM2JtVWhuTTNRT0ZVRlpFOVpaU0VubEZBS1F4S2hOMytR?=
 =?utf-8?B?NzN3WjhrekE3a3NkeWhKb09zdWV0cnBuVVRYb2RMeS80cW1ZNXM5NWluVmI3?=
 =?utf-8?B?Q1BqM202UUVUWTJsNkRISUYvcnZpRkxkelpHRExOclhzZWxmeTNnekU5TSt4?=
 =?utf-8?B?SjBOYXVDeTJOZDQ3TUVVbUNIblZTWGxwTTRiUGgxZ2tDUDdXQS9iQjF0UWwr?=
 =?utf-8?B?dEFIZVlqbXh3VDFUUlVYaTZjYlJTRkdEcEtISUxIaUF6c09jTGxDWXJITC9Y?=
 =?utf-8?B?Q2taS3hFMDJ3N3Iwa0RsRURxeWpZWFE4S2hCVHFlZXBsamR1azlKTjZEWFht?=
 =?utf-8?B?c1MwQlVBeXo2NDNSTVJQZEhmUEFQL3h6eFVJNDFFdmg2enJ2ZHg5OFRReHBZ?=
 =?utf-8?B?UGNsdWZ4eHowbDNHRnErb0plZytDQ2pmeDAzM3lIZkRzMWJSZlhicHUwM2Zl?=
 =?utf-8?B?QnRVTGk5SkFHQ2NMRmo5c3RZZEtneUUvVDNUd3czRGIxTjJpZnF5UVZoY0tW?=
 =?utf-8?B?K21qeHQ0b2dIYXlqL2l1NU5QVGpMOTlnWGtqYlpVa2Q1dmFCUVZyMW9zUmdB?=
 =?utf-8?B?WCtjNm1aeU45b1BCYW5vL2RkbXlSSDh1emh6eW93bm5idE1aQVZqRnlqOC9L?=
 =?utf-8?B?ZEZzc2pNT2NZWForbU5CMGRZUzNzdWhkYUorcmMvb3lhTklZUjlNaXcvQXBh?=
 =?utf-8?Q?65Y8=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(82310400026)(1800799024)(36860700013)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 14:16:06.3477
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6be11043-2bb5-4e4a-f63b-08de3be47cbb
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000044.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11540

T24gTW9uLCAyMDI1LTEyLTE1IGF0IDExOjUyICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIEZyaSwgMTIgRGVjIDIwMjUgMTU6MjI6MzUgKzAwMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEZyb206IFNhc2NoYSBC
aXNjaG9mZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+DQo+ID4gDQo+ID4gwqAJLyogRU9JbW9k
ZSA9PSAwLCBub3RoaW5nIHRvIGJlIGRvbmUgaGVyZSAqLw0KPiA+IC0JaWYgKCEodm1jciAmIElD
SF9WTUNSX0VPSU1fTUFTSykpDQo+ID4gKwlpZiAoIUZJRUxEX0dFVChJQ0hfVk1DUl9FTDJfVkVP
SU1fTUFTSywgdm1jcikpDQo+IA0KPiBuaXQ6IEZJRUxEX0dFVCgpIGRvZXNuJ3QgYnJpbmcgYW55
dGhpbmcgaGVyZS4gU2ltaWxhciBjb21tZW50IGFwcGxpZXMNCj4gdG8gbW9zdCAnaWYgKHZhbCAm
IE1BU0spJyBjb25zdHJ1Y3RzIHRoYXQgZ2V0IGNoYW5nZWQgaGVyZS4NCg0KSSd2ZSByZXZlcnRl
ZCBhbGwgYmFyZSBpbnN0YW5jZXMgb2YgYHZhbCAmIE1BU0tgICh3aXRob3V0IHNoaWZ0cykgdG8N
Cm5vdCB1c2UgRklFTERfR0VUKCkuIEFueXRoaW5nIHdpdGggYW4gYWRkaXRpb25hbCBzaGlmdCBJ
J3ZlIGxlZnQgYXMgYQ0KRklFTERfR0VUKCkuDQrCoA0KPiA+IMKgc3RhdGljIHZvaWQgX192Z2lj
X3YzX3JlYWRfaWdycGVuMChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHUzMg0KPiA+IHZtY3IsIGlu
dCBydCkNCj4gPiDCoHsNCj4gPiAtCXZjcHVfc2V0X3JlZyh2Y3B1LCBydCwgISEodm1jciAmIElD
SF9WTUNSX0VORzBfTUFTSykpOw0KPiA+ICsJdmNwdV9zZXRfcmVnKHZjcHUsIHJ0LA0KPiA+ICEh
RklFTERfR0VUKElDSF9WTUNSX0VMMl9WRU5HMF9NQVNLLCB2bWNyKSk7DQo+IA0KPiBIZXJlLCAh
ISBpcyBhY3R1YWxseSByZWFsbHkgc3VwZXJmbHVvdXMgYW5kIG1ha2VzIGl0IGhhcmRlciB0bw0K
PiB1bmRlcnN0YW5kIHdoYXQgaXMgYmVpbmcgZG9uZS4gU2ltaWxhciB0aGluZyBmb3IgSVJHUEVO
MS4NCg0KRHJvcHBlZCB0aG9zZSAhISBhcyBwYXJ0IG9mIHRoaXMgY2hhbmdlLg0KDQo+IEFwYXJ0
IGZyb20gdGhlc2UgdHdvIHBvaW50cywgdGhpcyBsb29rcyBPSyB0byBtZS4NCj4gDQo+IFRoYW5r
cywNCj4gDQo+IAlNLg0KDQpUaGFua3MsDQpTYXNjaGENCg0K

