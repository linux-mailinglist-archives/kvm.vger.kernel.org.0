Return-Path: <kvm+bounces-65506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D10A5CAD96D
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 16:29:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6D38630074A7
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 15:29:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50A372E9757;
	Mon,  8 Dec 2025 15:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="k/6gScVY";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="k/6gScVY"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013065.outbound.protection.outlook.com [40.107.159.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA532797BE;
	Mon,  8 Dec 2025 15:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.65
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765207774; cv=fail; b=uyEnqDdVq7p2S8xNwD2PlWu2TunRpy6EkMwtxvfXHNDu43MYfGRtE3gcnQYwgbBkdCNQvKSULOHyYobSspTkHwGrkWuadmM3tTqMzbrYhSwMSqvY8fwn80AaFLqt7nFXQxEvep6YXsE4HtYdBPo6fOB1cqdte1GyU49G2sO7DXQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765207774; c=relaxed/simple;
	bh=dPnQy5UrvTDme/Mrro2V3I7BdtmYtyaUlLDTKW39V1E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r/+ymgV8kbfYu8zsfPTOu16NKhPygpdu9yQCybdUrJR/9SasHI43baQy3vR53cYxnTQKJIcwr+MXxMsoTSLaRI/tDc7S8UpktZqncpSseAXbTCHS72F7ClmQzny0RcWhwHPzR5bIA1Qf7lfcl4u7ZZWdmjsNwzSeeNOIb0VqQXA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=k/6gScVY; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=k/6gScVY; arc=fail smtp.client-ip=40.107.159.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Wyl4BU9uQ4+wYfiH0O2um0zpXjsPkxYGl9fSSiv8iqTEFG8NrNRI5xmoAGLLmidjy6s4qtgRa9PrJqM4j9RHkbWlaEXpjm3GRH73BOyIqe9BBMROZWWbSiNEpMDALDe+V3F9wA2Ju4AOFiJ+ipnrg2vNDigYhVefSvMO4cEgU7T9rikP4VNvqUVqQmKXAmvEzDXtygxEDZUvVp9xQSN5dzbDb6N321Nt/O1Lw+vAOkV0oyM2XO7b5B60e2hMTmaiyUnNUzA+3mYeViSuxWDvszrIw/2JYeelviFqeWegRNOU6100+kMqNSoZIz5rHbmKB8C1c4q7vpf22dx5hGD08g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=453gfe3ZroED0CULKnFxRwYFjQkPP7+rwf0QOu0aG7o=;
 b=kwc2GdexJh1w131McS9Wh0+2UwepuI1flqD/u6YB2FiWNrK4EN7SYnAwQLJZv43TTAk011HX+EoNavn53G5dA14766KOkEgat9+YWIfhh/N7zf6KkTM6B0P4Nxo9xzo4Rh17it0YjJUmL+YlLQ5D1c7v50bOfoulLWutnN7OtPgPhK2xrY6v6eCNTH2m2sDoQfyYAzl7RAcvmi+xL2o/wxwkUffkCvVM2gpnowpeJUftlBPT2aj1UQXDXCfov758cB1HarUaYwE0STuAx2n7Wso1VbfAcO1VQ3Tm0GcxdU/Qth27o09xg4I5ifbYEeOGSEHW1qTfHXOrmRFpBOCLcg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=googlemail.com smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=453gfe3ZroED0CULKnFxRwYFjQkPP7+rwf0QOu0aG7o=;
 b=k/6gScVY739U+BfNEWGorg1JdftQgFbU4teXeaSy3ciY6+H4m0NYR7uIaQKiNCzlpyDv2REDCJ48VA23PZcJejxRy22FUnRi//0mUSId3Lpg2vCvcoYokPcpCHK6jHNdgYbx/e2LSOVzTKrLDn1903b1miVjjBp93stxPRd7pL0=
Received: from DB9PR06CA0025.eurprd06.prod.outlook.com (2603:10a6:10:1db::30)
 by DB9PR08MB6460.eurprd08.prod.outlook.com (2603:10a6:10:254::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Mon, 8 Dec
 2025 15:29:28 +0000
Received: from DB3PEPF0000885D.eurprd02.prod.outlook.com
 (2603:10a6:10:1db:cafe::52) by DB9PR06CA0025.outlook.office365.com
 (2603:10a6:10:1db::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.14 via Frontend Transport; Mon,
 8 Dec 2025 15:29:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885D.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.8
 via Frontend Transport; Mon, 8 Dec 2025 15:29:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MrTozsKaJCYQmxTLSTWQWXusF5O0LGee7TP2ZRXp0rIQXXewthlzirvx0TDFhxHMvem+yV6kuH6AfrbpPi475G0nmRKMUwoBCTyX3MltQQTv4DAQJjEsVrgqtqN5zwKG0cOee3Dm3YFkpj/Bn8Nsh80ERdD7i1PMRDWLaz93DtBytxa7tk/IvM4vdc/gnUUgpJT6E3DZYVR0F0zhCb5m5meq/GUpME4EA7GRRFwBReJIy783YX8RwZ6jOTjWCmlK2xoqUGhdXuxqsSJgd+2mBd4Elo2gd0EQ81l3GHwYZwYdoYFa7D6g37lJc9kVor63/OBw5ERH3xcwWFhX2Oz6bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=453gfe3ZroED0CULKnFxRwYFjQkPP7+rwf0QOu0aG7o=;
 b=ZQeFCntwySBrXncrhv4e4NBs/e3gvDZmCNn0jOATjv002x1bVXwtLxfE018T35dsWSCm6LKK5sj2RpX4JuTI/IT9yUyruqquh/IY5xUsNMW8bnH6nnowCBTfPgs/ZQ5sg/+VmtHPR1ZlAw4gczz2TKUFq3iBUPdN2IJzXqGKZpRfGtXtMs5iwNTIijpUpPCBEufrkWTNHA1EF2ivW+UenwNhkqpf/cwzHszJXMvyqGlOdd8uzkKJioVk4lr6tEBEKZ0NnggnL9zy5DseRjfL8EuqSFmga9oFAHHVaIkltoTWrObx+2ITC2/e2CrXZdPKqMfhor/stwUgDpQGgI0THg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=453gfe3ZroED0CULKnFxRwYFjQkPP7+rwf0QOu0aG7o=;
 b=k/6gScVY739U+BfNEWGorg1JdftQgFbU4teXeaSy3ciY6+H4m0NYR7uIaQKiNCzlpyDv2REDCJ48VA23PZcJejxRy22FUnRi//0mUSId3Lpg2vCvcoYokPcpCHK6jHNdgYbx/e2LSOVzTKrLDn1903b1miVjjBp93stxPRd7pL0=
Received: from PAVPR08MB8821.eurprd08.prod.outlook.com (2603:10a6:102:2fc::17)
 by AS8PR08MB9573.eurprd08.prod.outlook.com (2603:10a6:20b:61b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Mon, 8 Dec
 2025 15:28:23 +0000
Received: from PAVPR08MB8821.eurprd08.prod.outlook.com
 ([fe80::32ad:60b4:63d4:3b8f]) by PAVPR08MB8821.eurprd08.prod.outlook.com
 ([fe80::32ad:60b4:63d4:3b8f%4]) with mapi id 15.20.9388.013; Mon, 8 Dec 2025
 15:28:23 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sascha.bischoff@googlemail.com" <sascha.bischoff@googlemail.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org"
	<will@kernel.org>
Subject: [PATCH 2/2] KVM: arm64: Correct test for ICH_HCR_EL2_TDIR cap for
 GICv5 hosts
Thread-Topic: [PATCH 2/2] KVM: arm64: Correct test for ICH_HCR_EL2_TDIR cap
 for GICv5 hosts
Thread-Index: AQHcaFdKRDE3If8Bv0OrrZ4/qcOIsg==
Date: Mon, 8 Dec 2025 15:28:23 +0000
Message-ID: <20251208152724.3637157-4-sascha.bischoff@arm.com>
References: <20251208152724.3637157-1-sascha.bischoff@arm.com>
In-Reply-To: <20251208152724.3637157-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PAVPR08MB8821:EE_|AS8PR08MB9573:EE_|DB3PEPF0000885D:EE_|DB9PR08MB6460:EE_
X-MS-Office365-Filtering-Correlation-Id: 69f5cbbe-db8e-4a8f-9d54-08de366e9395
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?y+cAXKcYpNGQBmhhsEBIORwkWlJf4NJyHaVEy880VCaUz4KvDC1Nlh7Wjg?=
 =?iso-8859-1?Q?xFA4kXxRUxbnax9mm+T9/wBlWwoTrokSdeqp5kxjaVuMQofW1TEKUNWoGy?=
 =?iso-8859-1?Q?rpRhYocxYmNLqUKAtOpx8596/ZvXjN5tTpFZks/Y3HDujx9e+EKLteyVEC?=
 =?iso-8859-1?Q?aGOJzwfrTTZ8VUj5q4pDL6e/3pqudw/6fC4cTl6qz3xvWnmrrjHcaHB9u9?=
 =?iso-8859-1?Q?EWlYxIzGgJOm8heFcYzwn6bec/rGWZr7XXCEI8bF0bzVVJp1p8Q2AJURL1?=
 =?iso-8859-1?Q?k7Nj6VDj4ZH1PKoYiObt3HbM6x909UX/4YzI0g9zpq8RhOdkrPjcf2v+gF?=
 =?iso-8859-1?Q?1MMurNAUninvzGmxG6C6nHfj4GEsy6ELX+j3n8sm+huV9FUEtH9ScGc1hM?=
 =?iso-8859-1?Q?WIe1PtbVM2wTY0U1XVijSMJJB1Mn8itiysDMpC3Rabg8mFh3wmiyeUi9Zp?=
 =?iso-8859-1?Q?jbbp3NncDrz02iQ3jDJxEQZ9Wz9y6vRKEXtYX3I0+HBI2xKwDyRlfarP8C?=
 =?iso-8859-1?Q?KS3GUGar8k8FruC56jgiavmMclJCfO7mrspMaMsCLUZHyJGupxoGrITAKt?=
 =?iso-8859-1?Q?+9M8gLutnBtL+FWoQoaVFOaGifOWTa/ZPwN1g2ZSNVpm6SFyxes98r4Af4?=
 =?iso-8859-1?Q?bCi6J0X6okyD77+sS9XDDs9wlV4fPOy9z9IR9LRc54D0dIjXxQNLEsMplb?=
 =?iso-8859-1?Q?SSlEBgFXUb5McZZE5Uk4L8Z/Yx+gnLCo1ev2lGmAP2R0DmNIRUDeYh9Pzu?=
 =?iso-8859-1?Q?8EEC5CnexmFFbNX188jQYx8HwSr4bJBk4Jon3mQ4xDwVob0ZbmSs4GvLDP?=
 =?iso-8859-1?Q?TpCHJQudngkVcVcAft9YNng63Oe5kN+cfLvCv3me7+EM6EdmzAt5gsG694?=
 =?iso-8859-1?Q?LUzwO98S006vK0HV0SOpmJz56M0O+EhwNz84yqUmpDWwFXW5HLIV+D7ggI?=
 =?iso-8859-1?Q?JdfyT7q05HlOYjSi9VIVgq4lDX1vC1BpLTNVKgDphefNtYoBuYc86Vn+37?=
 =?iso-8859-1?Q?wp7N8yddhTG1Fc9/QNWkfpFSBO5WN3ODjM1ZlmdxZQ4x6S9CtglUM/G1GV?=
 =?iso-8859-1?Q?qXs44RazfTdN/klW9tuGr67WB/8ENgBghthDWQe1tGwe0O9hMj4Zba+wNE?=
 =?iso-8859-1?Q?bNZrwnNxxEaPiux81NyPkkf5wGt9fLsZifFpK5EFc2N0PiTpjcWsbUMcpk?=
 =?iso-8859-1?Q?ntnKlva+HYq8DnR+n0PnIF1z4T2+04pBcZcFtW3fIeMbs/Gu876n01yW6j?=
 =?iso-8859-1?Q?RVU4alcFm64kGaz8QBG7G/uvGipAE1nh38eldVjBKyTix6Cn7vNRiRhlVw?=
 =?iso-8859-1?Q?hy6oU46Us404rCjXs2GyHrBSi58qqR++LBVP6Wz40kR8h8xWGbHuwK5bxG?=
 =?iso-8859-1?Q?s9cbQlrThk9P/lfgIHnOihCUqR3G/phGSiPo8vnxO+cXKfOD/X4gyupUeR?=
 =?iso-8859-1?Q?8Dys78ACWWFZmhtVT9paJGUJeiF7CvzGLX3TLN5O8Lm0pMoOl+KCbmTqny?=
 =?iso-8859-1?Q?FcnAY+biJecd8oZlk2wCh+0sM7AG81h/BQ7LfXkuTkfXwc06X+CAL5h7+G?=
 =?iso-8859-1?Q?Y7yS/Cj6TO9g+BWuByDogDUw9W+u?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAVPR08MB8821.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9573
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885D.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	12bbf633-3c41-4842-a83d-08de366e6ced
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?RMyvv1hYnn51glPsQPyCR02AD+4DxksEOpH+rYCkFmk2pzMkokhLmuMr6Z?=
 =?iso-8859-1?Q?jNQIAzAbGtBqGb2U7xCpf/DAoN1/WixQaXHkSZXySYHv8jGyf6u5QNBzNi?=
 =?iso-8859-1?Q?VIv/stK5Kax0YPfxnuS4ssU3ugpvYHvbX031sBRgxCt4e97qC0bwT0dJ2J?=
 =?iso-8859-1?Q?NkmmPDcHfYyT867xsYL4/EKBuDgnXskzGOMWw3cf11vAQCD42T5BrLbyTE?=
 =?iso-8859-1?Q?V/NexLS9skK5MLgXQYHveqPd23o0NQpZoysVWr/4cTpKq7J1iO//D7Uv/4?=
 =?iso-8859-1?Q?WJZ/GbR5K7whjfrBfX/BSr/1Xqh/h2HG3MgM9TlxhC9rWkCYW6SY7M2tWl?=
 =?iso-8859-1?Q?SWH319BO0hl2XIgVTygjGwPNe4xrl2V95FAIsOZcICnqaVaF8Jozl1hJTo?=
 =?iso-8859-1?Q?u969ZL2mMgg9zzWdbikfJ1JpgWH42TQLJKNMbsq4fpuHF5aT4smZw691hA?=
 =?iso-8859-1?Q?LDeXqT/TZ9Nu/vc/g10N0HUvkuD+XNvMD1o3rl4PfgkhYHZiRRYX/hXq3n?=
 =?iso-8859-1?Q?4jslQNX6AcoI6RudBg86oCJeMDBHlLjA9nQejBu5TWJ5+9Aw7JqdqS48Hm?=
 =?iso-8859-1?Q?/mDxUgtZDM+HTbZoa8Sdix3zhPFTy+yAaWC/7icRStzObpK1gR4H4zFC/Z?=
 =?iso-8859-1?Q?13lgAXyga9Vfs9wkUC5rzMZ2c/CGClndT0QIOyqgQNVwjRSmUUjBOpeMZ3?=
 =?iso-8859-1?Q?C1NA62hsi/FQWTc2OCoMW8KkhPTj+mha3WnvxltpO04wZnHGkiJReDKzMi?=
 =?iso-8859-1?Q?b1oT6lcdyJIeQpP22B1WBCIVq/9o+F8IpUWyRNfUQBl9qzvxpqtulSCzwa?=
 =?iso-8859-1?Q?VMb8SUi5FkM92qc0AWTRLwRNvA83VGn/i0ouuj2sIzI9JCJD8o4KYwKY09?=
 =?iso-8859-1?Q?EGY5GZTA5zicVZdcq67Gy/tqdo5Bb8SrxQhPFdRKySqvnoz3wbsddOFkyT?=
 =?iso-8859-1?Q?KGoVGSYeGDJS9hnXj62yVtJlKU8rj5xOJnt3p4zy7alwDoU1AI5NyjaYbC?=
 =?iso-8859-1?Q?k2CD+qfGw3m5j1HyCUZS0sygYTMpJV5adpeLswNDPn5Et6UZKl/0zMkFT9?=
 =?iso-8859-1?Q?0I1qmmcjm5TupVCmEY4z48CQW3LxGc1VkDu9tNLlaCxR0tcs9ItAaBHalC?=
 =?iso-8859-1?Q?/hj1TVkx3LJUpwFxsG6TQgYGyeE6tfDh4zQJHLVpTl22x5XDToz/L5tr/m?=
 =?iso-8859-1?Q?sKraPLw9SpHkBwJHMpU7X2cMxkMRGDhy15wFPab4DMxR8zCpx1bcApr9MV?=
 =?iso-8859-1?Q?FFKYJBGorGyCmB8JUGmNcvcR4tXWPLnWIxrWPWS3py0CENsBmzo6YNhu7k?=
 =?iso-8859-1?Q?Q1YhVgEw07ZLUeCSGA7E3RV2RsIKgJQMT/pWTrXBKKFj1Zmx7bskc6ONmw?=
 =?iso-8859-1?Q?n0i0+w2h6m0WDhvOScNyHq0SfH4W9b4XmdB+t3HMeeajF/CDrZiqcCm8il?=
 =?iso-8859-1?Q?yOd2hiHMHt5HzhlU/VbeHC5k09bSDu3u6T3xubPto4xy8gU2/peC8bd6TY?=
 =?iso-8859-1?Q?VbwN4w0trNv5s1XLJRnxntsNECtNRPLcqKf2Hhh/wdzJXEuCnFF0VASTf2?=
 =?iso-8859-1?Q?NCX2lR7WTICbFPdnI0LXf/NWGykQ/uKSA368McyfEZyRdZclSJyESfDykF?=
 =?iso-8859-1?Q?1Hnn0aCcJuffE=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2025 15:29:28.2526
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 69f5cbbe-db8e-4a8f-9d54-08de366e9395
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885D.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6460

The original order of checks in the ICH_HCR_EL2_TDIR test returned
with false early in the case where the native GICv3 CPUIF was not
present. The result was that on GICv5 hosts with legacy support -
which do not have the GICv3 CPUIF - the test always returned false.

Reshuffle the checks such that support for GICv5 legacy is checked
prior to checking for the native GICv3 CPUIF.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Fixes: 2a28810cbb8b2 ("KVM: arm64: GICv3: Detect and work around the lack o=
f ICV_DIR_EL1 trapping")
---
 arch/arm64/kernel/cpufeature.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.=
c
index d34dcc5630865..fb5665c6cea01 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2325,16 +2325,16 @@ static bool can_trap_icv_dir_el1(const struct arm64=
_cpu_capabilities *entry,
=20
 	BUILD_BUG_ON(ARM64_HAS_ICH_HCR_EL2_TDIR <=3D ARM64_HAS_GICV3_CPUIF);
 	BUILD_BUG_ON(ARM64_HAS_ICH_HCR_EL2_TDIR <=3D ARM64_HAS_GICV5_LEGACY);
-	if (!this_cpu_has_cap(ARM64_HAS_GICV3_CPUIF) &&
-	    !is_midr_in_range_list(has_vgic_v3))
-		return false;
-
 	if (!is_hyp_mode_available())
 		return false;
=20
 	if (this_cpu_has_cap(ARM64_HAS_GICV5_LEGACY))
 		return true;
=20
+	if (!this_cpu_has_cap(ARM64_HAS_GICV3_CPUIF) &&
+	    !is_midr_in_range_list(has_vgic_v3))
+		return false;
+
 	if (is_kernel_in_hyp_mode())
 		res.a1 =3D read_sysreg_s(SYS_ICH_VTR_EL2);
 	else
--=20
2.34.1

