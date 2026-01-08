Return-Path: <kvm+bounces-67410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7963FD04E3D
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 18:21:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 97DBC30313E7
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 16:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80A6027C866;
	Thu,  8 Jan 2026 16:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Fl5xA3A/";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Fl5xA3A/"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012001.outbound.protection.outlook.com [52.101.66.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95857274FF5
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 16:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.1
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767889338; cv=fail; b=ArRPrkzQkyH5a+O5m1h/rsbvI/Pizi1FfobSOpbpQI3P4/vZsEHwqPWMJoL19YPZN859KUJzwHZWWVmN0oqyMG4ZzBxoRMFTeij86eWK1OuSgGJQr+TqnpoW/IGDvc8VMa8jYVyLG643DSXhiQ2X44/UlXcXgiPJxmbohzo31Wg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767889338; c=relaxed/simple;
	bh=rYo2CTtrUAnHawepbouy/mBArdzAgq1xSi7JIkOKzfE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D/dR0tmyc1Ik9mXKo4DNEhQh9KvKTOieVMAMsXs6QofFBut9N1qAsseVBjVQjK9p9a+3JV8sgoEYoGf+F0ua89vPw4bopeF/WK22cReEsZt3Uorn8m42NTNc6wHZGABbQ8ZIOyfgROwjILvhJFw22JoN+0SgyVA/2Fm2bGjZj38=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Fl5xA3A/; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Fl5xA3A/; arc=fail smtp.client-ip=52.101.66.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=VJWTiZFKZmscjDjRH9wGfrqzJReStZ/RFXJIaPRdXK1sCvCjxIokRXbzYL61daADLKjquLV9+WNRVUgmMoAq26CYhnhin6rfszOTPodG8hnlaVMdGooJulFMTJU1v8iEWtxFjCAGAhObLwYQO2QVfdqn/kc/9wikhL+vo0aDeCNiyd8MomwgIxD7SxMZEgFuu3U9DDilyglMD3sp+nmXitHVu2PxZdDTQsQ5qxm81+yDrhvPLBQLHpsC+j0H8VIzcazKNdFK56IeiH4Lr9hr9QEp+IXC/8hWWq8hvY9ldOGi+DdKwxBGnrbUBnuGBvY93h1OFtOg6ELUzzb/Ggy4KQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rYo2CTtrUAnHawepbouy/mBArdzAgq1xSi7JIkOKzfE=;
 b=JK6deU+Hig/hEw533XfmUUF12mIkUgkYALnS1BaOavOERpP5qbFDXYu1kdbyUveOYLHhpRe5OjBMmbvqNl6Fs0MVknWEb3L2lrHK7x2HJQLg2MZ3tj2tlZC7RxYSNpiWnY/UszaRpJ+cqbAZNLm168DLwWy96hoFSWOAm9bZo4h3cLBOOFObzzAWXgMrJajogwcF7hxpsnGW7m6nU7E9bbRy8VMbwAAmklRFgMyHOioFxslHXgUuPSB2O0Pt5yb+mR5DkPHw0uFm/7vw7HstmqqwxihbgAl3PN/xbMBZzh+KVEmtBBsM/IB2R3nkZXcZ/kWLRJkTa4OHTkblgyJW1w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rYo2CTtrUAnHawepbouy/mBArdzAgq1xSi7JIkOKzfE=;
 b=Fl5xA3A/Lzu4N5l0jpvsHx8j9XYJCRtImTiHac/SYEosUOhTEBFywnEeuVf6M2GqEsiDfd7MuHB2ZudX1Fu6RsV1VDvM/yt5dSiAHwpPVUUPAmCKIgsgb7T2QC7mg6OX2L6vtYnWK0M9lF4Qwd0JLpoPem8ZYwT72iLt+OJclMM=
Received: from DU7P195CA0017.EURP195.PROD.OUTLOOK.COM (2603:10a6:10:54d::27)
 by DU5PR08MB10550.eurprd08.prod.outlook.com (2603:10a6:10:528::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 16:22:11 +0000
Received: from DU2PEPF00028D13.eurprd03.prod.outlook.com
 (2603:10a6:10:54d:cafe::de) by DU7P195CA0017.outlook.office365.com
 (2603:10a6:10:54d::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.3 via Frontend Transport; Thu, 8
 Jan 2026 16:22:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D13.mail.protection.outlook.com (10.167.242.27) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Thu, 8 Jan 2026 16:22:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fB+ZmHuYcpgpd/370v2qqlHGxb1N1BzgsnyFZnEWLZRecbnrz/Wxph+z4Ks0RPcyfdExubMYztUztijVSdBT90nIuFrkvDVqr7LM/jE5kCw9Bj2cjJrna37A88icPVmW2pPHvQlSnBCGykAU62en4HJ7HNA0wS0xYRZ9PqObzu/pasG/gJFMLvPlXGvFk3gwPBrNWjk3S1NmYZEByxHtFNtOLIqeNlD1k557EYzAHpCbEScvI+iyG9BRkK1/ckoPqWubn0KOq7jQMUz9UfzCoQjIbE22NVrZd7EOsFTsVL87Jb/8p0uzLkHPHnaO1jKUGgXoAsxfdBhHpJ1C+gEJGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rYo2CTtrUAnHawepbouy/mBArdzAgq1xSi7JIkOKzfE=;
 b=huE8Yj4HVg0hm6rCjUMPiX7NQFjM0Hi8s4hCvbXkdfYruJz29mWEmvf2OlhJ6ztl4EWiahA6iGMYnx/HM+2X+KdA5yytk1aA3/XAshwBesnLQ6V18PHs8MqywCjLlX8Li6wLKElZdTwPNuTaSzWAD3z+9UxsFJG61O6n3UkU+g1/TvWyAzZwXpWvlaHsDpX0qgeXntUPLbcnpC74Rm90lkptlZxuxgg80EwLEH+GHfWUUrYz1T9zVUEmmdbE7A4WheFNWO7xi5IgnMMHxr3WBYm++IOAY0ACGn8NlGBpVNFGqXo7gmRL9ylGTdDeGBNwOT8Jxve0kLWMxlNCmAS/hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rYo2CTtrUAnHawepbouy/mBArdzAgq1xSi7JIkOKzfE=;
 b=Fl5xA3A/Lzu4N5l0jpvsHx8j9XYJCRtImTiHac/SYEosUOhTEBFywnEeuVf6M2GqEsiDfd7MuHB2ZudX1Fu6RsV1VDvM/yt5dSiAHwpPVUUPAmCKIgsgb7T2QC7mg6OX2L6vtYnWK0M9lF4Qwd0JLpoPem8ZYwT72iLt+OJclMM=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AM8PR08MB6595.eurprd08.prod.outlook.com (2603:10a6:20b:365::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.5; Thu, 8 Jan
 2026 16:21:09 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 16:21:09 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: Joey Gouly <Joey.Gouly@arm.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH v2 19/36] KVM: arm64: gic-v5: Check for pending PPIs
Thread-Topic: [PATCH v2 19/36] KVM: arm64: gic-v5: Check for pending PPIs
Thread-Index: AQHccP+CYg5kbO2rxk6vK6+w3RGKYLVIkKCAgAAC9wA=
Date: Thu, 8 Jan 2026 16:21:09 +0000
Message-ID: <f69493f4034b63c85eebcd0dcd6df06b834cc19c.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	 <20251219155222.1383109-20-sascha.bischoff@arm.com>
	 <20260108161031.GA223579@e124191.cambridge.arm.com>
In-Reply-To: <20260108161031.GA223579@e124191.cambridge.arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|AM8PR08MB6595:EE_|DU2PEPF00028D13:EE_|DU5PR08MB10550:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a6a7802-1275-4293-0276-08de4ed213a4
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?UjAwNVRla1BsekFyS0hOcmhvU3ZKejlON2h2QXhTcCtIdkRPcklOeCtsZFJD?=
 =?utf-8?B?c2hjSnphQXZKMFVoaGpnMXNMcGpOZS9HeitzdWp5Ym5zYmd6SEpMTUFGR1hY?=
 =?utf-8?B?VWxrc1Z0VWwwUFRCT2ltUXp4RGtSZEdoZy9tK1pIVnZJL3hoamxVc0xiVFQv?=
 =?utf-8?B?WHF0ekNHTzJZRnMyTjFjZlBaSmZHWnR2UUF6a09yUFpVRDNWK3k0UC9YbVRJ?=
 =?utf-8?B?Z1RoUXQ3b3B3TU5RK1BGWXdVKzBYTlVGUmJtaXRBTnozNjZuVy9iU2pvbGUv?=
 =?utf-8?B?eDluUlpLb0NhT255dVdpM0xGT0NWTUdYakZKeWRSMFJnVG1OeDBaSjlBeUhy?=
 =?utf-8?B?SU1xMDFGNVRWN0dCM3VrSE1hVHNWRGdvNjc5V3lwVWxGVE5sdnR5NXREQko1?=
 =?utf-8?B?dUZrYVFUbkhjVW95WjVSYmcxZWxFZzVrQ0V3L01LaXFWWFJzQUI2RG9wRGJa?=
 =?utf-8?B?VVhONHhKcm12RU5BNHJqais1cnFtRzJFc3B5VWJkUTNpM0dNT3BxOEVTNUJB?=
 =?utf-8?B?Y2dFclNvUmIyNFBUSEEzQTFxQ09OYXVVK0JDYnZBVnQ3Ym82WkFFejVYdkwv?=
 =?utf-8?B?WFA5Tm1hcEIzOTNrMmZhMDF2aTdadHBjMjJmWmZDRXdOQWZxeWZFMEZQYllo?=
 =?utf-8?B?VTFwS3gyWVFsL25Jck16OE9XMGhiL1lVeStjd1hqVTkyUTZEbzhGOGpCdEhQ?=
 =?utf-8?B?YmdZV0t4NUozR2NnZGU2RUtkOE1kVFRmRlM0bmNGZFhzcFF5d2NwdW0xSTBC?=
 =?utf-8?B?Q2RFdEgxK0FrU3dwOHg0ZExkaTNUbStwU3o1SDVsbC9obmQwd21YUDZGNzNN?=
 =?utf-8?B?OUw3dmxldHpuNHEvdUdtTllRL3htbGFMdyt2SGJtQ3NZcXlTYzZ0aFZWY1Fj?=
 =?utf-8?B?Y0VtOVYwbG93cEtFT3dQTFdxS1hrM2J3cTdrZ05XOHNzaGFkTGxEQ0JRMlhE?=
 =?utf-8?B?cmJERVphbEtKSW9EZXlJamZoTmVDVHhzbG0ySUNJeU9mdmp2Uy9BQXVLTkNE?=
 =?utf-8?B?d2xOS2JvOSt1L2dHVWs1ZmZZZTBRVDdlOVVjdjFqR2pjbHVoSUV2WEduZGpu?=
 =?utf-8?B?K2svdEhja1VacTF0aHZzOFNMdjRRaW0zN1VxT0gwZFhwbU5aTVZ6VmFBc0Vq?=
 =?utf-8?B?cjcyTTRob1k0cERIZE9lVXBFRTRMbnY5cUwwSklwbWRVNkhITi9HN0lEbnA3?=
 =?utf-8?B?elBlR3A1dUFtSlhCQnExR2Z1T2o2em5HTEROWlNJRnY4TjM0blBsT0RNUG9i?=
 =?utf-8?B?cXp3ZVJmcGR1NFV5TVBuT20wRFk2YzN3M25OcG1IUEhHTDZ0MGFJODNrU1hN?=
 =?utf-8?B?S3lzeTk1TUhjWXo5WXh6Y1l3T3YyUU1ocHowbUNXNWxWYWlNSnUrUWpkZGhT?=
 =?utf-8?B?MTlzT1ROMEVwL1VXZzRsdExPTStKZG54ZGpiVVMvdmdod1Z6MS9UUWJoY3li?=
 =?utf-8?B?QTR2Z0xKby8wWXVCQm9ndEZ3VmFnd1VVbUw3N0QrbHJQdHpEZ2VzZU1VSCtx?=
 =?utf-8?B?Z1ZkSWpBd09HcWMvVmE1N3hWVytqOGVtbXZpdExDRVFBdjRqcmZ6WWVGdlZV?=
 =?utf-8?B?Sml1eXRmbko1dEhDT0FrQUZIZGtUbWtsWWcxZXJyWVJ5NjVoc0wyNHNHMWgw?=
 =?utf-8?B?RndteU0rVWordkdEdUZLTnkzWEFrY2w1akpXT0ZvZzF2c3pEVjN1QmN3c3FD?=
 =?utf-8?B?QzJyWWtMY21WY3NaSGNNUzJVMEo0VnZkdmRWK2VWNG9yZm9Ib0VNalk5UVI4?=
 =?utf-8?B?MnA1UEdMRDRrWWFjemY2QlFLak1lWnBsTVNaK2hIT09ubGxPUld5Q3M5a0c0?=
 =?utf-8?B?ZlVnZVpxSmpwdWo2Q3BVZm1NSFlDQ2dMbVdUVG9yUnlDU3p4SElsekRBZ0VV?=
 =?utf-8?B?dTJva1YvTmVsSmJVMHlwYUlZelhHL1BhS01KUGpUMWgrb0lPMnFiWFhKTjBC?=
 =?utf-8?B?TlVSWWlUYzRPVklvdDlEb2lpMjdjcjVCMk1TRXp6SHZlM0RjTXErRkQzQW14?=
 =?utf-8?B?VGtzSXk2bldPMlF3dlVmcDEyVGJjMFlzUC9VK1lIWnI5YVBYQkg2ZjJQNG5O?=
 =?utf-8?Q?gxteGp?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <A6A97D9829C7644487FD664299C8E1CE@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6595
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D13.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	03097a31-bcd5-4113-b5b5-08de4ed1ee95
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|1800799024|82310400026|36860700013|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Um4xai85VkxwTmVoUTgrMmh3YkVrV21BUUczNnJLVUpEZUVHdC9JdEVKbWVT?=
 =?utf-8?B?NmxJdUxIRW5OZTV5MlNKY1JFK3UzSUNrcmZGQWFFZnFEcFNYR3lReUNHdCtn?=
 =?utf-8?B?cENVRkphRHdUZTJxc1hvVE1QdFhSZ2twc2NLREdGeDNnTGx6TFZuWXozajF0?=
 =?utf-8?B?Lzg4SUR5dVpNbjdFek5mUllzWlRsTEVSbWljQkE3cW0rWFY0OHFGMGhLV2hQ?=
 =?utf-8?B?djYrUklIZVJOMWhqVzJDUHZ4amg3QmMvTFBzbDdyaWR1NllObUVzd0NjYjZp?=
 =?utf-8?B?cllIWDVkWEVublh2SGZKd2E2azFhNW5kL1RmSDlYUFBhcmV2TUVyMDdHSlpv?=
 =?utf-8?B?ZzFGZHpwQTZUSjIvbUVmbVd6Wjlpd3BiL2JwLzdHTFlyTk1kVEhhOHFKR21Q?=
 =?utf-8?B?WTd3RnFjWU11cXEvekFlMWJrTi9CN1VxQWRrSnB4SlNlaTZQN0hnM3RuamJB?=
 =?utf-8?B?YXY5OCtsNE9WdDN1b0YxRHo0L05oNTUrNG80QmJoMVBWdk5Iby9jTmFMR1JM?=
 =?utf-8?B?c1VWWGU5UXo5YVJ4Q2NEOFcxRGYxZzhnTCsxOGluZXlxYTQweDZBRnBmcDVK?=
 =?utf-8?B?Zm9jaGt1VklPV2JTczZVYmNFVUUwc2o1VjFMYnBtb1dFb3JUakp0dFhpTE43?=
 =?utf-8?B?UFFYbCtYTTAvQnZBd1lNdHE3MldzRUNZTWpqMVhmaituV215RlhhdGRHaW8r?=
 =?utf-8?B?L0wrZGZmbUlaSWJXelBxOWY3SC9xeWF5elRzRE5OaUdhRlZHYlJURFdxcngv?=
 =?utf-8?B?VDFSN3ptYTIyR3o1OHN5V3pwbG1OOGlWQks5N0RhWi9XUG43OTR6R2FlcWZn?=
 =?utf-8?B?ZS9RYi9FYzV3bEFiRjNuUXhIV3lJaVVhMG0yZXkwMXl3cDhYZnErbCtDNWVl?=
 =?utf-8?B?bVREbCtqelpiV3ZTVExWTDFjZHJLVWgwYTN6WDRXcjlFZkJISGRFWVlZQ1Zu?=
 =?utf-8?B?U1JOVTRCYzJuRG5RZytZWTZxMlppaEt6dDV3Wi9CNWxENlVDZjVZVWZKS0xC?=
 =?utf-8?B?MmpEcGNwYU9PMkhNSmNuQWs2eWZadEtsb24xYVVncVpIK2VVbVl5Rm9MdzFm?=
 =?utf-8?B?RlY2aFVDckt5QWt0OVM4M1BNaU9sZ2JzcjIzeWNiWTJxMW4zMTF6TSs5eVhv?=
 =?utf-8?B?ZVFIb3FOWHpDekpjSFRWMWJ6UWZOZ0o4Z1YxZThwSHVaS29NQW1uUEFGQjBy?=
 =?utf-8?B?akhXNkh0d2l0bU41R2FxWis3SEJIOVVycWdDV1hhMkEvOWRIa3dCaHFtSGZU?=
 =?utf-8?B?NTZmOEs3aEFaazZ0N2pkQmNNbnlreStKYzNpVTlvLytjczY5M3daTnJqa2JW?=
 =?utf-8?B?Snk3NkJ1L1NpUmZVZ1E2Ynk3VmZlZUFPS0pmSnRPcHZ2eFJ4ekZWSkYzL3Jk?=
 =?utf-8?B?K3R1U3VnUDZ1MVlVUkxWd2dCSURZZzBET0lkKzcxMXNuTHFDNlZuZFBvUm1D?=
 =?utf-8?B?a2ljMjk1d3ZIZnNaVkZIUVRoVFQzckZTY3pzNlJJUkp6cHFWdEFJU0g1YzZM?=
 =?utf-8?B?RGppaS9UUHJPN1JOeXY4d0hNSWY4K3E3VU90Y1B1dEtnNzIxVVZJdjdSQXBh?=
 =?utf-8?B?SUQwOXI3S2VtQlRTOXdRQm4rRlZsaFhJcmVySHIzNHNHeFRZcXZXVHdjWTRi?=
 =?utf-8?B?V0J1RmdkNWp6L1BUbDc2dHNvSVlJOUFZY0lITFNHTk5pYkhtRWlnbEtrbEI2?=
 =?utf-8?B?TnkyRFNQUzdlL1JtcmZ5alZjUVZjWGVWL3BqTEtDTXpxYWcyemRSQWJKQWd4?=
 =?utf-8?B?T2VKK1pDMi9tLzNXWHJmUEYzNEx6aWNINXJGZ3I1Z2Z1Q2lIa0pldDRDTmF6?=
 =?utf-8?B?d1ZkNVY0N3RubjJuOEVnYzZJWC9BLy94Sng4bkkvZGhoZXFFUUl2V216cHdm?=
 =?utf-8?B?Yk1tZ0ZKR2RQcW5Ua2RIb0gzUUxIZy9JZ1hBU0MvOWFLVm00ZnFiY0VqaW5w?=
 =?utf-8?B?MmlxdW8zMjJaNjVqa3BQTDB0eHlkcWJPY3Fnc3ZUbWpyNWQwVkNOZFBhMGtD?=
 =?utf-8?B?bE9CdkZWclpKaXVGQTZablR1V1Y4ZlV2YnFTL0FUVEJKd0tJQ3l5YzhBTFJ5?=
 =?utf-8?B?UldoZmJuQmJLM0FCY3BsTXVYbkIrUW9COE5WMWlLWTVLNXlPVFpwcFJLRVdR?=
 =?utf-8?Q?bKO8=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(1800799024)(82310400026)(36860700013)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 16:22:11.1675
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a6a7802-1275-4293-0276-08de4ed213a4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D13.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10550

T24gVGh1LCAyMDI2LTAxLTA4IGF0IDE2OjEwICswMDAwLCBKb2V5IEdvdWx5IHdyb3RlOg0KPiBT
bWFsbCBuaXQsDQo+IA0KPiBPbiBGcmksIERlYyAxOSwgMjAyNSBhdCAwMzo1Mjo0MlBNICswMDAw
LCBTYXNjaGEgQmlzY2hvZmYgd3JvdGU6DQo+ID4gVGhpcyBjaGFuZ2UgYWxsb3dzIEtWTSB0byBj
aGVjayBmb3IgcGVuZGluZyBQUEkgaW50ZXJydXB0cy4gVGhpcw0KPiA+IGhhcw0KPiA+IHR3byBt
YWluIGNvbXBvbmVudHM6DQo+ID4gDQo+ID4gRmlyc3Qgb2YgYWxsLCB0aGUgZWZmZWN0aXZlIHBy
aW9yaXR5IG1hc2sgaXMgY2FsY3VsYXRlZC7CoCBUaGlzIGlzIGENCj4gPiBjb21iaW5hdGlvbiBv
ZiB0aGUgcHJpb3JpdHkgbWFzayBpbiB0aGUgVlBFcyBJQ0NfUENSX0VMMS5QUklPUklUWQ0KPiA+
IGFuZA0KPiA+IHRoZSBjdXJyZW50bHkgcnVubmluZyBwcmlvcml0eSBhcyBkZXRlcm1pbmVkIGZy
b20gdGhlIFZQRSdzDQo+ID4gSUNIX0FQUl9FTDEuIElmIGFuIGludGVycnVwdCdzIHByaW9pcml0
eSBpcyBncmVhdGVyIHRoYW4gb3IgZXF1YWwNCj4gPiB0bw0KPiA+IHRoZSBlZmZlY3RpdmUgcHJp
b3JpdHkgbWFzaywgaXQgY2FuIGJlIHNpZ25hbGxlZC4gT3RoZXJ3aXNlLCBpdA0KPiA+IGNhbm5v
dC4NCj4gPiANCj4gPiBTZWNvbmRseSwgYW55IEVuYWJsZWQgYW5kIFBlbmRpbmcgUFBJcyBtdXN0
IGJlIGNoZWNrZWQgYWdhaW5zdCB0aGlzDQo+ID4gY29tcG91bmQgcHJpb3JpdHkgbWFzay4gVGhl
IHJlcWlyZXMgdGhlIFBQSSBwcmlvcml0aWVzIHRvIGJ5IHN5bmNlZA0KPiA+IGJhY2sgdG8gdGhl
IEtWTSBzaGFkb3cgc3RhdGUgLSB0aGlzIGlzIHNraXBwZWQgaW4gZ2VuZXJhbCBvcGVyYXRpb24N
Cj4gPiBhcw0KPiA+IGl0IGlzbid0IHJlcXVpcmVkIGFuZCBpcyByYXRoZXIgZXhwZW5zaXZlLiBJ
ZiBhbnkgRW5hYmxlZCBhbmQNCj4gPiBQZW5kaW5nDQo+ID4gUFBJcyBhcmUgb2Ygc3VmZmljaWVu
dCBwcmlvcml0eSB0byBiZSBzaWduYWxsZWQsIHRoZW4gdGhlcmUgYXJlDQo+ID4gcGVuZGluZyBQ
UElzLiBFbHNlLCB0aGVyZSBhcmUgbm90LsKgIFRoaXMgZW5zdXJlcyB0aGF0IGEgVlBFIGlzIG5v
dA0KPiA+IHdva2VuIHdoZW4gaXQgY2Fubm90IGFjdHVhbGx5IHByb2Nlc3MgdGhlIHBlbmRpbmcg
aW50ZXJydXB0cy4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBTYXNjaGEgQmlzY2hvZmYgPHNh
c2NoYS5iaXNjaG9mZkBhcm0uY29tPg0KPiA+IC0tLQ0KPiA+IMKgYXJjaC9hcm02NC9rdm0vdmdp
Yy92Z2ljLXY1LmMgfCAxMjENCj4gPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
DQo+ID4gwqBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuY8KgwqDCoCB8wqDCoCA1ICstDQo+ID4g
wqBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuaMKgwqDCoCB8wqDCoCAxICsNCj4gPiDCoDMgZmls
ZXMgY2hhbmdlZCwgMTI2IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPiANCj4gPiBk
aWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBiL2FyY2gvYXJt
NjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gaW5kZXggY2IzZGQ4NzJkMTZhNi4uYzdlY2M0ZjQw
YjFlNSAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+
ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gQEAgLTU2LDYgKzU2LDMx
IEBAIGludCB2Z2ljX3Y1X3Byb2JlKGNvbnN0IHN0cnVjdCBnaWNfa3ZtX2luZm8NCj4gPiAqaW5m
bykNCj4gPiDCoAlyZXR1cm4gMDsNCj4gPiDCoH0NCj4gPiDCoA0KPiA+ICtzdGF0aWMgdTMyIHZn
aWNfdjVfZ2V0X2VmZmVjdGl2ZV9wcmlvcml0eV9tYXNrKHN0cnVjdCBrdm1fdmNwdQ0KPiA+ICp2
Y3B1KQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3QgdmdpY192NV9jcHVfaWYgKmNwdV9pZiA9ICZ2Y3B1
LQ0KPiA+ID5hcmNoLnZnaWNfY3B1LnZnaWNfdjU7DQo+ID4gKwl1MzIgaGlnaGVzdF9hcCwgcHJp
b3JpdHlfbWFzazsNCj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJICogQ291bnRpbmcgdGhlIG51bWJl
ciBvZiB0cmFpbGluZyB6ZXJvcyBnaXZlcyB0aGUgY3VycmVudA0KPiA+ICsJICogYWN0aXZlIHBy
aW9yaXR5LiBFeHBsaWNpdGx5IHVzZSB0aGUgMzItYml0IHZlcnNpb24gaGVyZQ0KPiA+IGFzDQo+
ID4gKwkgKiB3ZSBoYXZlIDMyIHByaW9yaXRpZXMuIDB4MjAgdGhlbiBtZWFucyB0aGF0IHRoZXJl
IGFyZQ0KPiA+IG5vDQo+ID4gKwkgKiBhY3RpdmUgcHJpb3JpdGllcy4NCj4gPiArCSAqLw0KPiA+
ICsJaGlnaGVzdF9hcCA9IGNwdV9pZi0+dmdpY19hcHIgPyBfX2J1aWx0aW5fY3R6KGNwdV9pZi0N
Cj4gPiA+dmdpY19hcHIpIDogMzI7DQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAqIEFuIGludGVy
cnVwdCBpcyBvZiBzdWZmaWNpZW50IHByaW9yaXR5IGlmIGl0IGlzIGVxdWFsDQo+ID4gdG8gb3IN
Cj4gPiArCSAqIGdyZWF0ZXIgdGhhbiB0aGUgcHJpb3JpdHkgbWFzay4gQWRkIDEgdG8gdGhlIHBy
aW9yaXR5DQo+ID4gbWFzaw0KPiA+ICsJICogKGkuZS4sIGxvd2VyIHByaW9yaXR5KSB0byBtYXRj
aCB0aGUgQVBSIGxvZ2ljIGJlZm9yZQ0KPiA+IHRha2luZw0KPiA+ICsJICogdGhlIG1pbi4gVGhp
cyBnaXZlcyB1cyB0aGUgbG93ZXN0IHByaW9yaXR5IHRoYXQgaXMNCj4gPiBtYXNrZWQuDQo+ID4g
KwkgKi8NCj4gPiArCXByaW9yaXR5X21hc2sgPSBGSUVMRF9HRVQoRkVBVF9HQ0lFX0lDSF9WTUNS
X0VMMl9WUE1SLA0KPiA+IGNwdV9pZi0+dmdpY192bWNyKTsNCj4gPiArCXByaW9yaXR5X21hc2sg
PSBtaW4oaGlnaGVzdF9hcCwgcHJpb3JpdHlfbWFzayArIDEpOw0KPiA+ICsNCj4gPiArCXJldHVy
biBwcmlvcml0eV9tYXNrOw0KPiA+ICt9DQo+ID4gKw0KPiA+IMKgc3RhdGljIGJvb2wgdmdpY192
NV9wcGlfc2V0X3BlbmRpbmdfc3RhdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LA0KPiA+IMKgCQkJ
CQnCoCBzdHJ1Y3QgdmdpY19pcnEgKmlycSkNCj4gPiDCoHsNCj4gPiBAQCAtMTMxLDYgKzE1Niwx
MDIgQEAgdm9pZCB2Z2ljX3Y1X3NldF9wcGlfb3BzKHN0cnVjdCB2Z2ljX2lycQ0KPiA+ICppcnEp
DQo+ID4gwqAJfQ0KPiA+IMKgfQ0KPiA+IMKgDQo+ID4gKw0KPiA+ICsvKg0KPiA+ICsgKiBTeW5j
IGJhY2sgdGhlIFBQSSBwcmlvcml0aWVzIHRvIHRoZSB2Z2ljX2lycSBzaGFkb3cgc3RhdGUNCj4g
PiArICovDQo+ID4gK3N0YXRpYyB2b2lkIHZnaWNfdjVfc3luY19wcGlfcHJpb3JpdGllcyhzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCB2Z2ljX3Y1X2NwdV9pZiAq
Y3B1X2lmID0gJnZjcHUtDQo+ID4gPmFyY2gudmdpY19jcHUudmdpY192NTsNCj4gPiArCWludCBp
LCByZWc7DQo+ID4gKw0KPiA+ICsJLyogV2UgaGF2ZSAxNiBQUEkgUHJpb3JpdHkgcmVncyAqLw0K
PiA+ICsJZm9yIChyZWcgPSAwOyByZWcgPCAxNjsgcmVnKyspIHsNCj4gPiArCQljb25zdCB1bnNp
Z25lZCBsb25nIHByaW9yaXR5ciA9IGNwdV9pZi0NCj4gPiA+dmdpY19wcGlfcHJpb3JpdHlyW3Jl
Z107DQo+ID4gKw0KPiA+ICsJCWZvciAoaSA9IDA7IGkgPCA4OyArK2kpIHsNCj4gPiArCQkJc3Ry
dWN0IHZnaWNfaXJxICppcnE7DQo+ID4gKwkJCXUzMiBpbnRpZDsNCj4gPiArCQkJdTggcHJpb3Jp
dHk7DQo+ID4gKw0KPiA+ICsJCQlwcmlvcml0eSA9IChwcmlvcml0eXIgPj4gKGkgKiA4KSkgJiAw
eDFmOw0KPiA+ICsNCj4gPiArCQkJaW50aWQgPSBGSUVMRF9QUkVQKEdJQ1Y1X0hXSVJRX1RZUEUs
DQo+ID4gR0lDVjVfSFdJUlFfVFlQRV9QUEkpOw0KPiA+ICsJCQlpbnRpZCB8PSBGSUVMRF9QUkVQ
KEdJQ1Y1X0hXSVJRX0lELCByZWcgKg0KPiA+IDggKyBpKTsNCj4gPiArDQo+ID4gKwkJCWlycSA9
IHZnaWNfZ2V0X3ZjcHVfaXJxKHZjcHUsIGludGlkKTsNCj4gPiArDQo+ID4gKwkJCXNjb3BlZF9n
dWFyZChyYXdfc3BpbmxvY2ssICZpcnEtPmlycV9sb2NrKQ0KPiA+ICsJCQkJaXJxLT5wcmlvcml0
eSA9IHByaW9yaXR5Ow0KPiA+ICsNCj4gPiArCQkJdmdpY19wdXRfaXJxKHZjcHUtPmt2bSwgaXJx
KTsNCj4gPiArCQl9DQo+ID4gKwl9DQo+ID4gK30NCj4gPiArDQo+ID4gK2Jvb2wgdmdpY192NV9o
YXNfcGVuZGluZ19wcGkoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+ICt7DQo+ID4gKwlzdHJ1
Y3QgdmdpY192NV9jcHVfaWYgKmNwdV9pZiA9ICZ2Y3B1LQ0KPiA+ID5hcmNoLnZnaWNfY3B1LnZn
aWNfdjU7DQo+ID4gKwlpbnQgaSwgcmVnOw0KPiA+ICsJdW5zaWduZWQgaW50IHByaW9yaXR5X21h
c2s7DQo+ID4gKw0KPiA+ICsJLyogSWYgbm8gcGVuZGluZyBiaXRzIGFyZSBzZXQsIGV4aXQgZWFy
bHkgKi8NCj4gPiArCWlmIChsaWtlbHkoIWNwdV9pZi0+dmdpY19wcGlfcGVuZHJbMF0gJiYgIWNw
dV9pZi0NCj4gPiA+dmdpY19wcGlfcGVuZHJbMV0pKQ0KPiA+ICsJCXJldHVybiBmYWxzZTsNCj4g
PiArDQo+ID4gKwlwcmlvcml0eV9tYXNrID0gdmdpY192NV9nZXRfZWZmZWN0aXZlX3ByaW9yaXR5
X21hc2sodmNwdSk7DQo+ID4gKw0KPiA+ICsJLyogSWYgdGhlIGNvbWJpbmVkIHByaW9yaXR5IG1h
c2sgaXMgMCwgbm90aGluZyBjYW4gYmUNCj4gPiBzaWduYWxsZWQhICovDQo+ID4gKwlpZiAoIXBy
aW9yaXR5X21hc2spDQo+ID4gKwkJcmV0dXJuIGZhbHNlOw0KPiA+ICsNCj4gPiArCS8qIFRoZSBz
aGFkb3cgcHJpb3JpdHkgaXMgb25seSB1cGRhdGVkIG9uIGRlbWFuZCwgc3luYyBpdA0KPiA+IGFj
cm9zcyBmaXJzdCAqLw0KPiA+ICsJdmdpY192NV9zeW5jX3BwaV9wcmlvcml0aWVzKHZjcHUpOw0K
PiA+ICsNCj4gPiArCWZvciAocmVnID0gMDsgcmVnIDwgMjsgcmVnKyspIHsNCj4gPiArCQl1bnNp
Z25lZCBsb25nIHBvc3NpYmxlX2JpdHM7DQo+ID4gKwkJY29uc3QgdW5zaWduZWQgbG9uZyBlbmFi
bGVyID0gY3B1X2lmLQ0KPiA+ID52Z2ljX2ljaF9wcGlfZW5hYmxlcl9leGl0W3JlZ107DQo+ID4g
KwkJY29uc3QgdW5zaWduZWQgbG9uZyBwZW5kciA9IGNwdV9pZi0NCj4gPiA+dmdpY19wcGlfcGVu
ZHJfZXhpdFtyZWddOw0KPiA+ICsJCWJvb2wgaGFzX3BlbmRpbmcgPSBmYWxzZTsNCj4gPiArDQo+
ID4gKwkJLyogQ2hlY2sgYWxsIGludGVycnVwdHMgdGhhdCBhcmUgZW5hYmxlZCBhbmQNCj4gPiBw
ZW5kaW5nICovDQo+ID4gKwkJcG9zc2libGVfYml0cyA9IGVuYWJsZXIgJiBwZW5kcjsNCj4gPiAr
DQo+ID4gKwkJLyoNCj4gPiArCQkgKiBPcHRpbWlzYXRpb246IHBlbmRpbmcgYW5kIGVuYWJsZWQg
d2l0aCBubw0KPiA+IGFjdGl2ZSBwcmlvcml0aWVzDQo+ID4gKwkJICovDQo+ID4gKwkJaWYgKHBv
c3NpYmxlX2JpdHMgJiYgcHJpb3JpdHlfbWFzayA+IDB4MWYpDQo+ID4gKwkJCXJldHVybiB0cnVl
Ow0KPiA+ICsNCj4gPiArCQlmb3JfZWFjaF9zZXRfYml0KGksICZwb3NzaWJsZV9iaXRzLCA2NCkg
ew0KPiA+ICsJCQlzdHJ1Y3QgdmdpY19pcnEgKmlycTsNCj4gPiArCQkJdTMyIGludGlkOw0KPiA+
ICsNCj4gPiArCQkJaW50aWQgPSBGSUVMRF9QUkVQKEdJQ1Y1X0hXSVJRX1RZUEUsDQo+ID4gR0lD
VjVfSFdJUlFfVFlQRV9QUEkpOw0KPiA+ICsJCQlpbnRpZCB8PSBGSUVMRF9QUkVQKEdJQ1Y1X0hX
SVJRX0lELCByZWcgKg0KPiA+IDY0ICsgaSk7DQo+ID4gKw0KPiA+ICsJCQlpcnEgPSB2Z2ljX2dl
dF92Y3B1X2lycSh2Y3B1LCBpbnRpZCk7DQo+ID4gKw0KPiA+ICsJCQlzY29wZWRfZ3VhcmQocmF3
X3NwaW5sb2NrLCAmaXJxLT5pcnFfbG9jaykNCj4gPiB7DQo+ID4gKwkJCQkvKg0KPiA+ICsJCQkJ
ICogV2Uga25vdyB0aGF0IHRoZSBpbnRlcnJ1cHQgaXMNCj4gPiArCQkJCSAqIGVuYWJsZWQgYW5k
IHBlbmRpbmcsIHNvIG9ubHkNCj4gPiBjaGVjaw0KPiA+ICsJCQkJICogdGhlIHByaW9yaXR5Lg0K
PiA+ICsJCQkJICovDQo+ID4gKwkJCQlpZiAoaXJxLT5wcmlvcml0eSA8PQ0KPiA+IHByaW9yaXR5
X21hc2spDQo+ID4gKwkJCQkJaGFzX3BlbmRpbmcgPSB0cnVlOw0KPiA+ICsJCQl9DQo+ID4gKw0K
PiA+ICsJCQl2Z2ljX3B1dF9pcnEodmNwdS0+a3ZtLCBpcnEpOw0KPiA+ICsNCj4gPiArCQkJaWYg
KGhhc19wZW5kaW5nKQ0KPiA+ICsJCQkJcmV0dXJuIHRydWU7DQo+ID4gKwkJfQ0KPiA+ICsJfQ0K
PiA+ICsNCj4gPiArCXJldHVybiBmYWxzZTsNCj4gPiArfQ0KPiA+ICsNCj4gPiDCoC8qDQo+ID4g
wqAgKiBEZXRlY3QgYW55IFBQSXMgc3RhdGUgY2hhbmdlcywgYW5kIHByb3BhZ2F0ZSB0aGUgc3Rh
dGUgd2l0aA0KPiA+IEtWTSdzDQo+ID4gwqAgKiBzaGFkb3cgc3RydWN0dXJlcy4NCj4gPiBkaWZm
IC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmMNCj4gPiBiL2FyY2gvYXJtNjQva3Zt
L3ZnaWMvdmdpYy5jDQo+ID4gaW5kZXggY2I1ZDQzYjM0NDYyYi4uZGZlYzZlZDc5MzZlZCAxMDA2
NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuYw0KPiA+ICsrKyBiL2FyY2gv
YXJtNjQva3ZtL3ZnaWMvdmdpYy5jDQo+ID4gQEAgLTExODAsOSArMTE4MCwxMiBAQCBpbnQga3Zt
X3ZnaWNfdmNwdV9wZW5kaW5nX2lycShzdHJ1Y3QNCj4gPiBrdm1fdmNwdSAqdmNwdSkNCj4gPiDC
oAl1bnNpZ25lZCBsb25nIGZsYWdzOw0KPiA+IMKgCXN0cnVjdCB2Z2ljX3ZtY3Igdm1jcjsNCj4g
PiDCoA0KPiA+IC0JaWYgKCF2Y3B1LT5rdm0tPmFyY2gudmdpYy5lbmFibGVkKQ0KPiA+ICsJaWYg
KCF2Y3B1LT5rdm0tPmFyY2gudmdpYy5lbmFibGVkICYmICF2Z2ljX2lzX3Y1KHZjcHUtDQo+ID4g
Pmt2bSkpDQo+ID4gwqAJCXJldHVybiBmYWxzZTsNCj4gPiDCoA0KPiA+ICsJaWYgKHZjcHUtPmt2
bS0+YXJjaC52Z2ljLnZnaWNfbW9kZWwgPT0NCj4gPiBLVk1fREVWX1RZUEVfQVJNX1ZHSUNfVjUp
DQo+IA0KPiDCoMKgwqDCoMKgwqDCoCBpZiAodmdpY19pc192NSh2Y3B1LT5rdm0pKQ0KPiANCg0K
QWgsIHllcy4gQ2hlZXJzIQ0KDQo+IE90aGVyd2lzZToNCj4gDQo+IFJldmlld2VkLWJ5OiBKb2V5
IEdvdWx5IDxqb2V5LmdvdWx5QGFybS5jb20+DQoNClRoYW5rcywNClNhc2NoYQ0KDQo+IA0KPiA+
ICsJCXJldHVybiB2Z2ljX3Y1X2hhc19wZW5kaW5nX3BwaSh2Y3B1KTsNCj4gPiArDQo+ID4gwqAJ
aWYgKHZjcHUtPmFyY2gudmdpY19jcHUudmdpY192My5pdHNfdnBlLnBlbmRpbmdfbGFzdCkNCj4g
PiDCoAkJcmV0dXJuIHRydWU7DQo+ID4gwqANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9r
dm0vdmdpYy92Z2ljLmgNCj4gPiBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5oDQo+ID4gaW5k
ZXggOTc4ZDdmODQyNjM2MS4uNjVjMDMxZGE4M2U3OCAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL2Fy
bTY0L2t2bS92Z2ljL3ZnaWMuaA0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5o
DQo+ID4gQEAgLTM4OCw2ICszODgsNyBAQCBpbnQgdmdpY192NV9wcm9iZShjb25zdCBzdHJ1Y3Qg
Z2ljX2t2bV9pbmZvDQo+ID4gKmluZm8pOw0KPiA+IMKgdm9pZCB2Z2ljX3Y1X2dldF9pbXBsZW1l
bnRlZF9wcGlzKHZvaWQpOw0KPiA+IMKgdm9pZCB2Z2ljX3Y1X3NldF9wcGlfb3BzKHN0cnVjdCB2
Z2ljX2lycSAqaXJxKTsNCj4gPiDCoGludCB2Z2ljX3Y1X3NldF9wcGlfZHZpKHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSwgdTMyIGlycSwgYm9vbCBkdmkpOw0KPiA+ICtib29sIHZnaWNfdjVfaGFzX3Bl
bmRpbmdfcHBpKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQo+ID4gwqB2b2lkIHZnaWNfdjVfZmx1
c2hfcHBpX3N0YXRlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQo+ID4gwqB2b2lkIHZnaWNfdjVf
Zm9sZF9wcGlfc3RhdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsNCj4gPiDCoHZvaWQgdmdpY192
NV9sb2FkKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQo+ID4gLS0gDQo+ID4gMi4zNC4xDQoNCg==

