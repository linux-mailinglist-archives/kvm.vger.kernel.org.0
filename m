Return-Path: <kvm+bounces-66403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DBFF6CD0F02
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:42:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A9BAF3062E73
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:36:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 422D1392FF2;
	Fri, 19 Dec 2025 16:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oHTYe1nc";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oHTYe1nc"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013039.outbound.protection.outlook.com [40.107.162.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C804390DDE
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 16:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.39
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766161146; cv=fail; b=JhhxBy2F0cwz+u7b7mOesejM7RXdd/4qHCe+4qc1edk5spV2nruuwzJkH2s72B7ZD6vO72isWkk6uRzB3i/o3CPz+t2lqYsPlhjbob1XQcHH1ueAq1JzTCUPfgPPvX94gd2IKvJOyHjiTkRTsUIaQ6357GKfQTq4fqlIySOXi0U=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766161146; c=relaxed/simple;
	bh=MCQllPDbqRH/kjKQztqj7xTtAgNyrrywMJbh8OmJvGY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GJKsfmI2sB4h1jyV5MqXmmmalqMrIkYq2SEp4DfXbhhdc5o0senrkPJcxWWZhxTjhotpGjWxRFhSsRWDeHTAy1QCujrnaZKgX6WxIZryOvwgm52oYbTXJZ1OwQtO46YCTVTlpv1FWLel03jDT1z44phwAHkq36G2cdZ6ZVQmDHw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oHTYe1nc; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oHTYe1nc; arc=fail smtp.client-ip=40.107.162.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=i+HjEHFEYsz6zVNX/JrTGfc3WjYNnSv08ZjxZqlenIbDVrfGJN49Q4sATOf8u2MRc+Js5m5o1+/w6nHjNH9qPlOosv2HEfyv5RfyRxTWgTLZhbbrtlVzea5bACHsEz+QIxTd4kVghTyfjsb6Y0EPLqM3VbMaWyxmBN/4tt8LrwBGtoGFSlHBauo9HGWtvgw8r571gt0hMQ0a8UNoq1W6e2adcJuXFtBfyojp5/1gcMj7W5S37GiuXcVJ4R/crz4qQ7KHRl1iWkQ6TVtdCEf63lvK3j5SOdj+s39ZUp1D9P+h5TUg70rC9J53tBfuld/W04Z6m3DldHyUOhwUWIygTA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MCQllPDbqRH/kjKQztqj7xTtAgNyrrywMJbh8OmJvGY=;
 b=VYbW+3XJBUf7cosJz1iBa0d13m0LdVe5Ab6nBeCHrRXF1cWb2T2nEvtMyMRalg8MYwJGCHB5XZl+jL7Dur8+u2yCGpzuRULbhqLCdPRNchvYEdWOjGKBFB1fvV14TNeXFAv5yKEdQKoSUy8Fx7w0pwZBgnQk2MRIXogsgK8oO3EFSyjKpszkrQU+ccyTKqMj4bs4Azd95rcQtrTkjizLjaW8RZfdlSmHNXAijx1M581iiButMVAovcD91ZOz5ikZdcUuvBvoChaAsbjTgdV7D+tgR3B1EDL0RiAnPcvtS9UcqjYJFZvj0xjlZmqYKhEshQUfnnnzkjaLhAr4gvtARw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MCQllPDbqRH/kjKQztqj7xTtAgNyrrywMJbh8OmJvGY=;
 b=oHTYe1ncz9NKrrAKBlrQELlc2gSALUTTUU8kTHtOUCUoE0c2p0lipxFaTUiva35E6zJf+MGnVLzU5Gth1pzax1s5ZXMFL9+aPRpgHsZaE9VUtcMWDspbSBW+UqQRQpllwrZFnZAdseAhFaGgqwNoISdK80KztfVvZu0Ysiif4+I=
Received: from DUZPR01CA0080.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::9) by AS4PR08MB8095.eurprd08.prod.outlook.com
 (2603:10a6:20b:58a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Fri, 19 Dec
 2025 16:19:00 +0000
Received: from DB3PEPF00008860.eurprd02.prod.outlook.com
 (2603:10a6:10:46a:cafe::c7) by DUZPR01CA0080.outlook.office365.com
 (2603:10a6:10:46a::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Fri,
 19 Dec 2025 16:19:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF00008860.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 16:19:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YHQzcBjtISSUSNl6nOXlrRqT198uK6vq6Ztc0216ggDT6F/kbP99AoNpGzmhjg6JI/XXmWTFQw9kV+GeE8CToWKxLLhtxBQDVQWepON0dWKtozBUliItVwGQD6s8blj5gsEBp6si9Ma6tPABcNkSAMe7wl/9lh1tigR6nyA4V2Qm1sZzUFuCJ5f3Sj8c3FStQ9LZ+buNQRj6YDABbaJ6YgkHDCHdlq1jsC7zrka75z6jE8QC04k3sPi4Yu39pGIAd6R+dFUZ9+cCbFMOLp3K7zaqIeuRe8q/+MADfeVtxEEJcx5QPPK+fMRCGr3JyvDoc7osY7D56TogOnKqeV9jSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MCQllPDbqRH/kjKQztqj7xTtAgNyrrywMJbh8OmJvGY=;
 b=Gq41iIBqrKPAYXCvkP2PzoaBgl/snVYhpxQncKohvfA3Sw/cW3IjVE18maotHBeCBwDRXMob00maUVh92GvbAzalsNxntG+9LDRB4EUmM/oEBwsA1ibR6ou3zyq8l9xTspSWzHGhpFPK63jp0LMFuJp7b3/4+NHnoDNOEQzCFwt1s25M2MjC46ieGgRgiOsIXpDjUsvKsuvlaAE5Md73qPXqbIOoMezsIADClFbjq8Bp9DuGFT6dk4+OwTdtgVYDKfmhnETwxh+mPuJipLQvZDFAQi/b+eHdSEWh48VpWQhcnm9FXloJPDW9rQcrfIX84uiIywg+XfYK07qOJWVFhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MCQllPDbqRH/kjKQztqj7xTtAgNyrrywMJbh8OmJvGY=;
 b=oHTYe1ncz9NKrrAKBlrQELlc2gSALUTTUU8kTHtOUCUoE0c2p0lipxFaTUiva35E6zJf+MGnVLzU5Gth1pzax1s5ZXMFL9+aPRpgHsZaE9VUtcMWDspbSBW+UqQRQpllwrZFnZAdseAhFaGgqwNoISdK80KztfVvZu0Ysiif4+I=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by GVXPR08MB10452.eurprd08.prod.outlook.com (2603:10a6:150:149::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 16:17:57 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 16:17:57 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, nd <nd@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>
Subject: Re: [PATCH v2 00/36] KVM: arm64: Introduce vGIC-v5 with PPI support
Thread-Topic: [PATCH v2 00/36] KVM: arm64: Introduce vGIC-v5 with PPI support
Thread-Index: AQHccP9+BmxsDh9kfUiQTKgHtflD/LUpJBIA
Date: Fri, 19 Dec 2025 16:17:57 +0000
Message-ID: <b2eac7bfb03b112ee5ea917cfe7f7be725408bd4.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
In-Reply-To: <20251219155222.1383109-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|GVXPR08MB10452:EE_|DB3PEPF00008860:EE_|AS4PR08MB8095:EE_
X-MS-Office365-Filtering-Correlation-Id: 65abcf17-bf9e-45fc-696d-08de3f1a5196
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?Q0VVMkM3d1VIajRCMUU1Rnd0dnhZQ1d2WGtDZUlnbmNCcEw3ZmFXSnVUSG5P?=
 =?utf-8?B?Y1BRUFVEU0hCdjE1clZTZTI3S3E1U3JvY2hCc3YyRjBxbEhVWjZzVVM2bFE2?=
 =?utf-8?B?WGJPYkRMNjdLWjc1c04rWGFVanlaMm1sUXVNbmFmc2gyMGxIMHJTdGZNcFJU?=
 =?utf-8?B?endBR082RXVPaVFXbXY5ZUhLRmI5dEF3NmF2NSt0NVVQd3Q2V281RGlMMUhJ?=
 =?utf-8?B?R0QvL3RSczdyYkFRVEY3dnNqV2h6S1F2enR0ZytpVGllUXA1TUN3RVl0ejBC?=
 =?utf-8?B?MUNJWjNCN0ZVRGpXTDgveUE0TEtIYXVHWENLc2JQeVN0cWYzS29JUjhuNXFP?=
 =?utf-8?B?ZExUY3MrSUUzNTl5Z2d2TjZpcnp0aXNDcUJmOE8zWCt6NGlZQi9yQWp2VUIr?=
 =?utf-8?B?cnptakRZN1RQS2txUGhCZEZHemlpWFovMmYrbE1NdDR6LzhDL2lwQXIzQjZF?=
 =?utf-8?B?Vm5LOVhuZm9IaWlpWThTWWVRV3hDbDRRY253ckk3RkNkME5Tbzk0U2JsRC9T?=
 =?utf-8?B?bWFlcjlnaEFEN3ZHcjA1NGtVYU9DKzk1NE1XcmFXREgrVGlodktRY09ab2J2?=
 =?utf-8?B?TE9NalAyWXR4ZGd1WnZ0Zm96bk9KQVpWYlBHMDVvN21pSDdMeVNzYjFhVDRI?=
 =?utf-8?B?SWNhN3dDZzF5MndWejAzV0oxdUxUaWI5cnc0SW1aYlI3dFVtdkNaeS9PZlFP?=
 =?utf-8?B?WFpQYVhXT2xVOTdneUFiejBhc1h4VXVxQ1ZPcE1VdWxMdVZVM0FNRDU0cTd6?=
 =?utf-8?B?cllGdzhFay82TlFGL1FHT2JBMFVhMFNLNlE1c0paQU1BWllvS1NJU1UrV2k3?=
 =?utf-8?B?Z3NNUm94R3B6TjlBUEJ6SVFUMit6UlRHdllsbjlRSHR2YUVyZTZaVmFVbHRa?=
 =?utf-8?B?N1VHcEpjeTMyUnYxQUJ6UmFENU8vRjZtV3U4Nmg2Z3BMaStxcWtKODI3d1pS?=
 =?utf-8?B?WWV3N2ZjbzV2S0dCajZscS8zbnlRSDlXblRleFpkR05tQjRBOTZLTXFrRytW?=
 =?utf-8?B?MHFMUnRRQXlBODdpVENmbzBiRWtGY1RhSHh5Wlp0L1hvSUNicENxYWtMRTF3?=
 =?utf-8?B?Y20zdmxCZ2JmK0x1bU5GM0JCdTNvYmIxMWh6STNMcVMxeHlaSE9Nb3RhaWVm?=
 =?utf-8?B?dkJVcmRENUhXRGJsUXhjT1M4MWROSGgzb1c5V0QyL1hGc3JFajUyWG9vVXVL?=
 =?utf-8?B?Y3h0TlVYbnd2RUtkNGZ0WDZ3azlWYnBkbWJlVFBmS1FqcmMxZWxycFdUeTBi?=
 =?utf-8?B?cEtGRVdHQTNORXV6TEJiRVh0b1NJZnZxdmZYeGZheHFYdElsSEtZejJxNmE4?=
 =?utf-8?B?cTBDSzRja1cya3FXaHZWczhlQjNwOHk1dklYVzgrS0pYK3ZlcVp3L28zTUpL?=
 =?utf-8?B?ZnVGNWczVW8zRmMrZ2lGSTgzVk8xVElZRDdxOFdFd1hNRE83L1JlRFhISytC?=
 =?utf-8?B?U1VUbXV0ZG9ZMGxXUGFFU3VXOExXUDVnVlNGb09YTGRoMFA2ekl6U0EwWlI2?=
 =?utf-8?B?cmZueUQ2NkdpaVlpcFFHeG04ejJxSmNtWjhEQTFsdjR0N3lleFJ3QTA4cmVM?=
 =?utf-8?B?ZzQ1VzFYYTNZZ2orT0UzYUZoRmI1MUJXR0lyMzJ6a1dmZ3pJd0xWOGxKaDdS?=
 =?utf-8?B?ZUw5V2thd2UvQ1J1R2VUZWVBS21wRVpRSVcyZXA0SVYyUHZUZnczL3NVUzYv?=
 =?utf-8?B?aVBlWUN5R2U0cFVtZVdyZ2xDUUlBOUlCZUNRVUNrd1lhVGxtS0M3UTJSdFZX?=
 =?utf-8?B?TjZTaHhSdG9vOTdUbEE0WHprRGZMaVZoZzJnQ0lTbmVUam94bHA1QlFib2hE?=
 =?utf-8?B?TmVDU1hmUFQxZEpLa253R2VnTnZQOVduUGJvaGRsczdER2d5SzdOK0ZCazFY?=
 =?utf-8?B?TmpnblRxRGtMNWVFY2pvUUI3ZVV0NTZicjRlWk80TklrQ2sveUxFRG42Wlhn?=
 =?utf-8?B?VGk1YjFmRVB0OEE3QXZCZC95MGVXWFAreTk1SzEvRDhUSkFmNDBEQW5qajdM?=
 =?utf-8?B?b09hMmhTU0E0K0x6aVk2Wlpod0MyN1NTYlZLTmpsTm02UExua2hTU0UwZDZv?=
 =?utf-8?B?bS9jSUxoYU54L3dYYU1uR0RVYWhJODJ2MVJOUT09?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <0D203C8ECE1B6E4A8028EF9011C36CFC@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10452
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF00008860.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b40d4fe6-1541-4483-5b55-08de3f1a2c2d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|35042699022|14060799003|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?LzR3MTYvZkNjRXNnOGhGV3ZBTnJibmwzRURGcmMrWmY0US9ZZHVubktHbHY4?=
 =?utf-8?B?bXRyaExydkI1bTZNRGNIcm1LTjU2YTYyRW1wVUFSRVpPcFVNb1hnWmV2Ym5Z?=
 =?utf-8?B?V0tNYTNWTXB1ZmI1ZllYVXV6a05Mang4Tkl3VUVXQU8wVld3TVdBbk5qSEl1?=
 =?utf-8?B?UXBZbDZLV1UxQXhxYU9oRW41R3pHU0xydlBOMTFrOGhXSXNlTTN6aUVwWjRD?=
 =?utf-8?B?d1lHdS95SklSQm01S29mNlhXVTIyS3ZlamZZc1ZzckJXVWEvTU5FVm9oeTVV?=
 =?utf-8?B?V3ZWamdKTXNPVm5XbmRpaGtoS2dWbWZYdXRoV3gxMldUT0JOd0RsSTVwTGZP?=
 =?utf-8?B?Q0hydmJZQ2JCMEQ0MnIwZ09VTlB1OEx3eE9HU0sydDlSd3kwcFlOTnpxOUJK?=
 =?utf-8?B?dWM5eCt2S2RTR1N5Y0dZTzJHR3h1dFpjQlZLbWhEMnNidENaYzl4UE95QlFN?=
 =?utf-8?B?aTJ3QTg4dm5nNzAwTWcwN3hqamZKZ2hMaUJXZHhFT1lXYmo5VkFOR0R0ay92?=
 =?utf-8?B?U1BpL2ZNVHAzMWF4c2ZIUklScEJvMUNuTDRRekNpMUNXT0ZybFM4K0JyWUpG?=
 =?utf-8?B?NWJoM0dSRGFzMHJYdTN4a0lRWlplc3lNelNDSURhQXRkbHAzTW1UVXlRbkZO?=
 =?utf-8?B?WmMxZ0lJWTdyL0VOUjBVUTVYT0RPZ3hodHM0WW5ydGM3NEVYM3FTVUlleUhO?=
 =?utf-8?B?bUZsTVY5Z0xKNjV3STlPVUJCSDFCbmZmdmNkZXNVY1p6ajhlbGpPZW9peno4?=
 =?utf-8?B?MnVRVFp4U2pwWElLVVlSc2NpZ1UxVGFvaUZpamtuRWN3SUpFb3dSaXBWaVlp?=
 =?utf-8?B?TUNtS1pUcDhkdFJEa1Awbm1jR01HN3RmejdvSDVraFdUT0pKUitBM3U1VmtI?=
 =?utf-8?B?OVV1YWFBZXJuckc3am9FUTF5VHk3dTZsMkk2MjMyYnBCRTJEcWJxYlU2aWla?=
 =?utf-8?B?NVRpZ3hqckM4ejBoSEVLUWdBWFZrZ1RvbWlTelNKMUxmdUtJb2pLcGx6NlpP?=
 =?utf-8?B?Tm1lTjMxN0txWDNrMzU0cGpTYnM0Y3NPVDNnZWJBYXIySVMvczdaeU1QVU9s?=
 =?utf-8?B?a2lFZlpOeE5McEptdnBNdTZWaU40TlBINVA5L2RFc05IS2lhS25wK3VCL2V1?=
 =?utf-8?B?OEl1bTVMeVNpSnkwQ0YzdTRTdTI3a2dPNUhmNWpEZ0dydS92L3FuVzN3bDBp?=
 =?utf-8?B?U3FYajIxRU9RaGdPTkM1elM0QTNWOWJmR2paRlJadWJIeDlSTlBDSGgrQzht?=
 =?utf-8?B?Z2NIeitQdEZLYU1vUlZKZ0hUbWJxNWtIbmpJZGF3aDNtWXBVaVdWUXlaZzMx?=
 =?utf-8?B?ZWk1eFlzaHZUemdrekdHVXJ4eWp4WlRieUZlU0RSaEYwTnV5OGxkcmJ5VmZF?=
 =?utf-8?B?VU1NVlczbDhmVlVsZjdSaitXK0c3enhkRDVEWjd4eFRkSzZVV3dLQUtZME5q?=
 =?utf-8?B?SjhPaHJVQjRpUVZBSTM1cGVPTFUydTdwQUIraG1SejNIV3VzcEhqMWFHeHdZ?=
 =?utf-8?B?aEpkczJNRysyNi9zWFhWeGQ5UVhZSW5sVEVoNGsvY3ZSMEQwb3ZrVjk0QXJL?=
 =?utf-8?B?emhaQXRnSFVmMFZrdlg2ZUgxZER1eVdTcFpnK3dkUzFDbXVreXU1M29iMVBH?=
 =?utf-8?B?d3FmRitRSmJZUkhMVUlrQkJHdWNmekFzVTRYcVBKclJpd2lac25mUEFpRWJz?=
 =?utf-8?B?eHlWejNQTG1WS2VoWm50TU82QWhGL3BTcHNKU2x2MUZNTHJicXpyS0lLbUtl?=
 =?utf-8?B?Z2doTzA0MXJTdktQY2NaTVJ3REMrdFQ4Z2pWMW9mZEtVS01CYzFhMEJ4dHFS?=
 =?utf-8?B?NDJycytmSm14UkV6T251K2tQSGVLWHJwR0JSTitiRGx6ck8xN3VWYW9hQmZR?=
 =?utf-8?B?TUVwaHA3VXFFT3VqTkZndnF0QUFwMExrTHpmUXorV25lMzJRSW8wUEFkZU9C?=
 =?utf-8?B?ZmxFYmRWSmNsV0k0VmI0Qm5TbXRjT0k5RmgyV0kzcThRMTVxeTF4NjVVdVFr?=
 =?utf-8?B?d3FPRUNpQ2VYcWlKNWdENitEQWk5bk5RMlcwcjFvZEZ1N1VIMW5OaEZrd0JT?=
 =?utf-8?B?ZExaVGxHamp5VWNpQlFjYUpuTEl6M0NxeXlVOUVrUmg2citjMEdJeU9qb3cy?=
 =?utf-8?Q?+OpglJqj0zZAFLAVPUdBzDxT1?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(35042699022)(14060799003)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 16:19:00.2629
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65abcf17-bf9e-45fc-696d-08de3f1a5196
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF00008860.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB8095

T24gRnJpLCAyMDI1LTEyLTE5IGF0IDE1OjUxICswMDAwLCBTYXNjaGEgQmlzY2hvZmYgd3JvdGU6
DQo+IFRoaXMgaXMgdGhlIHNlY29uZCB2ZXJzaW9uIG9mIHRoZSBwYXRjaCBzZXJpZXMgdG8gYWRk
IHRoZSB2aXJ0dWFsDQo+IEdJQ3Y1IFsxXSBkZXZpY2UgKHZnaWNfdjUpLiBPbmx5IFBQSXMgYXJl
IHN1cHBvcnRlZCBieSB0aGlzIGluaXRpYWwNCj4gc2VyaWVzLCBhbmQgdGhlIHZnaWNfdjUgaW1w
bGVtZW50YXRpb24gaXMgcmVzdHJpY3RlZCB0byB0aGUgQ1BVDQo+IGludGVyZmFjZSwgb25seS4g
RnVydGhlciBwYXRjaCBzZXJpZXMgYXJlIHRvIGZvbGxvdyBpbiBkdWUgY291cnNlLA0KPiBhbmQN
Cj4gd2lsbCBhZGQgc3VwcG9ydCBmb3IgU1BJcywgTFBJcywgdGhlIEdJQ3Y1IElSUywgYW5kIHRo
ZSBHSUN2NSBJVFMuDQo+IA0KPiBUaGUgZmlyc3QgdmVyc2lvbiBvZiB0aGlzIHNlcmllcyBjYW4g
YmUgZm91bmQgYXQgWzJdLg0KPiANCj4gVGhlIG5vdGV3b3J0aHkgY2hhbmdlcyBzaW5jZSBWMSBv
ZiB0aGlzIHNlcmllcyBhcmU6DQo+IA0KPiAxLiBBZGRlZCBkZXRlY3Rpb24gb2YgaW1wbGVtZW50
ZWQgUFBJcyBvbiBhIEdJQ3Y1IGhvc3QgYXQgYm9vdCB0aW1lLg0KPiAyLiBBZGRlZCBtYXNraW5n
IGZvciBQUElzIHRoYXQgYXJlIHByZXNlbnRlZCB0byBndWVzdHMuIE9ubHkgUFBJcw0KPiB3aXRo
DQo+IMKgwqAgb3duZXJzIGFuZCB0aGUgU1dfUFBJIChpZiBwcmVzZW50KSBhcmUgZXhwb3NlZC4N
Cj4gMy4gQWRkZWQgdHJhcHBpbmcgYW5kIG1hc2tpbmcgZm9yIGFsbCBndWVzdCB3cml0ZXMgdG8g
dGhlIHdyaXRhYmxlDQo+IMKgwqAgSUNDX1BQSV94X0VMMSByZWdpc3RlcnMuIFRoZSB3cml0ZXMg
YXJlIG1hc2tlZCB3aXRoIHRoZSBzdWJzZXQgb2YNCj4gwqDCoCBQUElzIGV4cG9zZWQgdG8gdGhl
IGd1ZXN0LiBUaGlzIGVuc3VyZXMgdGhhdCB0aGUgZ3Vlc3QgY2Fubm90DQo+IMKgwqAgZGlzY292
ZXIgUFBJcyB0aGF0IGFyZSBub3QgaW50ZW50aW9uYWxseSBleHBvc2VkIHRvIGl0Lg0KPiA0LiBB
ZGRlZCBhbiBuZXcgVUFQSSB0byBhbGxvdyB1c2Vyc3BhY2UgdG8gcXVlcnkgd2hpY2ggUFBJcyBj
YW4gYmUNCj4gwqDCoCBkcml2ZW4gdmlhIEtWTV9JUlFfTElORS4gRm9yIHRoZSB0aW1lIGJlaW5n
LCBvbmx5IHRoZSBTV18gUFBJIGlzDQo+IMKgwqAgZXhwb3NlZCBmb3IgZ3Vlc3QgY29udHJvbC4N
Cj4gNS4gSW50ZXJydXB0IHR5cGUgY2hlY2tzIGFyZSBub3cgcmUtd29ya2VkIHRvIGJlIG1vcmUg
cmVhZGFibGUgYW5kDQo+IMKgwqAgc2NhbGFibGUuIFRoYW5rcywgTWFyYy4NCj4gDQo+IEkgaGF2
ZSBhZGRyZXNzZWQgc29tZSwgYnV0IGFsYXMgbm90IGFsbCAoc2VlIGJlbG93KSwgcmV2aWV3IGNv
bW1lbnRzDQo+IGFnYWluc3QgdjEgb2YgdGhlIHNlcmllcy4gVGhhbmtzIGEgbG90IE1hcmMsIEpv
ZXksIGFuZCBMb3JlbnpvIQ0KPiANCj4gSSdtIHBvc3RpbmcgVjIgZXZlbiB0aG91Z2ggSSd2ZSB5
ZXQgdG8gYWRkcmVzcyBhbGwgcmV2aWV3IGNvbW1lbnRzIGFzDQo+IEkgc2hhbGwgYmUgb3V0IG9m
IG9mZmljZSBmb3IgdGhlIG5leHQgMiB3ZWVrcy4gVGhlcmVmb3JlLCBJIHdhbnRlZCB0bw0KPiBt
YWtlIHN1cmUgdGhhdCB0aGUgbGF0ZXN0IHZlcnNpb24gd2FzIGF2YWlsYWJsZSBmb3IgYW55b25l
IHRvIHRha2UgYQ0KPiBsb29rLiBBbnkgb3V0c3RhbmRpbmcgYW5kIG5ldyBjb21tZW50cyB3aWxs
IGJlIGFkZHJlc3NlZCBvbiBteQ0KPiByZXR1cm4uDQo+IA0KPiBUaGUgbWFpbiBvdXRzdGFuZGlu
ZyBjaGFuZ2VzIGFyZToNCj4gDQo+IDEuIFJld29yayB0aGUgUFBJIHNhdmUvcmVzdG9yZSBtZWNo
YW5pc21zIHRvIHJlbW92ZSB0aGUgX2VudHJ5L19leGl0DQo+IMKgwqAgZnJvbSB0aGUgdmNwdSwg
YW5kIGluc3RlYWQgdXNlIHBlci1jcHUgZGF0YSBzdHJ1Y3R1cmVzLg0KPiAyLiBQUEkgaW5qZWN0
aW9uIG5lZWRzIGNsZWFuIHVwIGFyb3VuZCBzaGFkb3cgc3RhdGUgdHJhY2tpbmcgYW4NCj4gwqDC
oCBtYW5pcHVsYXRpb24uDQo+IDMuIFBQSSBzdGF0ZSB0cmFja2luZyBuZWVkcyB0byBiZSBoZWF2
aWxpeSBvcHRpbWlzZWQgdG8gcmVkdWNlIHRoZQ0KPiDCoMKgIG51bWJlciBvZiBsb2NrcyB0YWtl
biBhbmQgUFBJcyBpdGVyYXRlZCBvdmVyLiBUaGlzIGlzIG5vdyBwb3NzaWJsZQ0KPiDCoMKgIHdp
dGggdGhlIGludHJvZHVjdGlvbiBvZiB0aGUgbWFza3MsIGJ1dCByZW1haW5zIHRvIGJlIGltcGxl
bWVudGVkLg0KPiA0LiBBbGxvdyBmb3Igc3BhcnNlIFBQSSBzdGF0ZSBzdG9yYWdlLiBHaXZlbiB0
aGF0IG1vc3Qgb2YgdGhlIDEyOA0KPiDCoMKgIHBvdGVudGlhbCBQUElzIHdpbGwgbmV2ZXIgYmUg
dXNlZCB3aXRoIGEgZ3Vlc3QsIGl0IGlzIGV4dHJlbWVseQ0KPiDCoMKgIHdhc3RlZnVsIHRvIGFs
bG9jYXRlIHN0b3JhZ2UgZm9yIHRoZW0uDQo+IA0KPiBUaGVzZSBjaGFuZ2VzIGFyZSBiYXNlZCBv
biB2Ni4xOS1yYzEuIEFzIGJlZm9yZSwgdGhlIGZpcnN0IGNvbW1pdCBoYXMNCj4gYmVlbiBjaGVy
cnktcGlja2VkIGZyb20gTWFyYydzIFZUQ1Igc2FuaXRpc2F0aW9uIHNlcmllcyBbM10uDQo+IA0K
PiBGb3IgdGhvc2UgdGhhdCBhcmUgaW50ZXJlc3RlZCBpbiB0aGUgb3ZlcmFsbCBkaXJlY3Rpb24g
b2YgdGhlIEdJQ3Y1DQo+IEtWTSBzdXBwb3J0LCBNYXJjIFp5bmdpZXIgaGFzIHZlcnkga2luZGx5
IGFncmVlZCB0byBob3N0IHRoZSBmdWxsDQo+ICpXSVAqIHNldCBvZiBHSUN2NSBLVk0gcGF0Y2hl
cyB3aGljaCBjYW4gYmUgZm91bmQgYXQgWzRdLiBUaGVzZSBhcmUNCj4gbm90IGludGVuZGVkIGZv
ciByZXZpZXcsIGFuZCByZXF1aXJlIHNvbWUgc2VyaW91cyBjbGVhbiB1cCwgYnV0DQo+IHNob3Vs
ZA0KPiBnaXZlIGEgcm91Z2ggaWRlYSBvZiB3aGF0IGlzIHN0aWxsIHRvIGNvbWUuDQo+IA0KPiBU
aGFua3MgYWxsIGZvciB0aGUgZmVlZGJhY2sgc28gZmFyIGFuZCBhbnkgbW9yZSB5b3UgaGF2ZSwN
Cj4gU2FzY2hhDQo+IA0KPiBbMV0gaHR0cHM6Ly9kZXZlbG9wZXIuYXJtLmNvbS9kb2N1bWVudGF0
aW9uL2FlczAwNzAvbGF0ZXN0DQo+IFsyXQ0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwv
MjAyNTEyMTIxNTIyMTUuNjc1NzY3LTEtc2FzY2hhLmJpc2Nob2ZmQGFybS5jb20vDQo+IFszXQ0K
PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNTEyMTAxNzMwMjQuNTYxMTYwLTEtbWF6
QGtlcm5lbC5vcmcvDQo+IFs0XQ0KPiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGlu
dXgva2VybmVsL2dpdC9tYXovYXJtLXBsYXRmb3Jtcy5naXQvbG9nLz9oPWt2bS1hcm02NC9naWN2
NS1mdWxsDQo+IA0KDQpBcyBhbiBGWUksIEkndmUganVzdCBwb3N0ZWQgdGhlIEdJQ3Y1IGt2bXRv
b2wgc3VwcG9ydCBmb3IgcmV2aWV3IGhlcmU6DQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2Fs
bC8yMDI1MTIxOTE2MTI0MC4xMzg1MDM0LTEtc2FzY2hhLmJpc2Nob2ZmQGFybS5jb20NCg0KVGhh
bmtzLA0KU2FzY2hhDQo=

