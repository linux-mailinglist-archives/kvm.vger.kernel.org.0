Return-Path: <kvm+bounces-66193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 882D4CC9913
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 22:21:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A21DF300C530
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 21:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E9B530F922;
	Wed, 17 Dec 2025 21:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="psG1iGSZ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="psG1iGSZ"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013049.outbound.protection.outlook.com [40.107.162.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F05718AE3
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 21:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.49
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006455; cv=fail; b=dynmOfgEbzH3kD9BVew6d/XTC8msbkbcSehwI5VPvaoPyPgIEv8kgq6Z1Y7bWuB0YWPUTJUU4qAMG0KYDdQoxeKx0GRA2cBx3P6fXfNEW6pOaEuF2IZR76zmLAJQ5esycp76e3zCWgWQJ3XQk943kFrzovvjUyzxLpOCVrFDA0s=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006455; c=relaxed/simple;
	bh=rJVIFc9AMAqsAGq+g0em7vMAImnl4NIVRxjxVXfVhng=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JJQVkK7zSJ7iALKSbG7nqoP6M3AIuVrCDL4N8FKzaSmjqyeech0u3K1LO71HN+B8h+Q+gz3YCcWSNL/zJbVYKjRqCSokkZTxjq1z4yk0bW/Ra9mIWCQXaZZAjZVonr0AxKVHgpDlH8tD8mJNb55LaCPG2IaCnlzY/xf6FVE3tuQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=psG1iGSZ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=psG1iGSZ; arc=fail smtp.client-ip=40.107.162.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dPiRvw68YKD3OTh7tWLGGEKzMdn7kp1fdrK6iKZEkCyZlECmCdLLlubNbJeiIGB+frY1qqiOxE+EKHknB0a2T8iZhVLxvnq5uOvDCm97Zvqelgi9t8DFrDVDp6j6GAAehy7ufqnZZC4WCVNmmn/jkqTtGVjjoNAxhmHE9YP4trUA8cVhluJSUaCEmPlm7TW2XZXOKKpkUg5ou4p1jB5lGAn/8t+Tot8jUjfhOcamKH8EgZGdc3TSq4jTCHrsqg4l8vrTezxoNCiO2+M41k1Lr3ed7mmWARUFMM1DNIN/2ux/LVZBfwg6oRsUv06KPIsM4m5hFJA4qAeHjhu/4yfzVA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rJVIFc9AMAqsAGq+g0em7vMAImnl4NIVRxjxVXfVhng=;
 b=ZX3P5vCOBGohBdaScIcPQpIKk/podNowhmyn6enqHGExZoQLQJC6B/BmJwXn9tNb7VyZ6StuNoT5RjcUYypSx6e6eyGmodbEHR28U8Z2x9sqTm4nWVjs1wgK+nbbonN2Qcz5uD+fW3jCCuOAS5zLTb2VdS5jXNFpEfxc1t2Yeijax9LKyXs1vDByzBqteniwUiOnovwFzNL6gBLUVjnsHB2zGklO/Ggdw0qdGUqiCum8WJ4wKf8GatZQaRT9BF+0RCGIC57USY29y9DDX0+d/jAtUuAbYemtugu9b7UM2cY+y2+1v6Omp23EfYLFQq2fIxu+QpyS50oYhLZ3L8zu9w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJVIFc9AMAqsAGq+g0em7vMAImnl4NIVRxjxVXfVhng=;
 b=psG1iGSZNJ7Vrv7QxmLHZ1t+LMlEjWMFeFydrIM7wzTlJiN2rJ8pA83Xr7DSSp0LqIAPtyHTgjvjt3pT00DwCT9NSPmxwBRacIDCGO6uChIaPsGg9QHmGl50JkK9TdImXalmy0psqUO4qXXJQseY0HpkVcZtX21BLkK26bVUV8U=
Received: from AS4P251CA0019.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:5d3::7)
 by DB4PR08MB8032.eurprd08.prod.outlook.com (2603:10a6:10:388::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 20:47:27 +0000
Received: from AM1PEPF000252E1.eurprd07.prod.outlook.com
 (2603:10a6:20b:5d3:cafe::fb) by AS4P251CA0019.outlook.office365.com
 (2603:10a6:20b:5d3::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.7 via Frontend Transport; Wed,
 17 Dec 2025 20:47:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252E1.mail.protection.outlook.com (10.167.16.59) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Wed, 17 Dec 2025 20:47:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eQEctB3VCGbdu2Y7vWdiG1Gni/NxMtSRNpDqHpMikOgN20uIOc/5VjbWxt4dTrzYi8kU13oVWMjC6q0kTiUXhpoN1NSlAzNa5fSaqGhOIcUBJs5Pasd9GzaGA9D66SNnOX6s/lQdMu5tM3Da1CeZJEVd3jB5QjrUtm9wjr6oT05UDpRHA2ZehwVwhVCxzqe8pu8GxVnie/7z7lVzw8/Zo0JeacnMOYltGeTqJ0uQ/wuriopDv+hq4lfK213+hBeL6lYW5JINJhd1eoEVHAkIl4yaYa0ATv0YQMUQsKy+79OJkOVmiLxD4P29iqomhKEhIZZEXs5Z9JCy+qF49zA0Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rJVIFc9AMAqsAGq+g0em7vMAImnl4NIVRxjxVXfVhng=;
 b=OgAJh5Cd3Y6iwC2Ls10oUXIVjrTaNzX76EN8EIBesSh/P5vC1gieJnOxHbn5fpv30hqCTNaXxhuA6iLZzXurDeYU0YigDDSsgBEnH8B0PjFiP6TauP9JSUCPkQQGKxDxgOqXQTOfw+rjHmiDXi3aZOrPY7ixoaa1eomH2O9OxcWcLbDzkjEUyqlOzuWI2LnQl/Cpc3JTMYpN0FGc9KI60keqpsjntPI9slC0sfyUNJC2STvLPpK1t1rVQidOp39NS6nRLy/9cfzpKfyZwQMjBy3FONWy5Tz1Pq+P4Ib/VRLH2scc0ckk5/bMKUTqzB8GRoPLSykv+K2zDDif/SRAbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJVIFc9AMAqsAGq+g0em7vMAImnl4NIVRxjxVXfVhng=;
 b=psG1iGSZNJ7Vrv7QxmLHZ1t+LMlEjWMFeFydrIM7wzTlJiN2rJ8pA83Xr7DSSp0LqIAPtyHTgjvjt3pT00DwCT9NSPmxwBRacIDCGO6uChIaPsGg9QHmGl50JkK9TdImXalmy0psqUO4qXXJQseY0HpkVcZtX21BLkK26bVUV8U=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AS8PR08MB6087.eurprd08.prod.outlook.com (2603:10a6:20b:29c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.7; Wed, 17 Dec
 2025 20:46:22 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.011; Wed, 17 Dec 2025
 20:46:22 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "lpieralisi@kernel.org" <lpieralisi@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH 29/32] irqchip/gic-v5: Check if impl is virt capable
Thread-Topic: [PATCH 29/32] irqchip/gic-v5: Check if impl is virt capable
Thread-Index: AQHca3sqngrJahSBvk+AZkcPoZI69rUkbcWAgAHnqQA=
Date: Wed, 17 Dec 2025 20:46:22 +0000
Message-ID: <759a11630bad887e5cda36aae91d270e2017454b.camel@arm.com>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
	 <20251212152215.675767-30-sascha.bischoff@arm.com>
	 <aUF9hwjBuUKA73U8@lpieralisi>
In-Reply-To: <aUF9hwjBuUKA73U8@lpieralisi>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|AS8PR08MB6087:EE_|AM1PEPF000252E1:EE_|DB4PR08MB8032:EE_
X-MS-Office365-Filtering-Correlation-Id: 7577aea6-bbc5-46bf-46fb-08de3dad7cc3
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?WHV1T09BVVZReEFkY0tRdGxnbzV1YnRIb3NvQVNFSVlQTmIzQmNLK1BpSEll?=
 =?utf-8?B?YkdDK0dHaVI1aXVId2xTN1pUM2Zjc2s1NXBhREdvVk5VN3pic2hBbGFKMGRK?=
 =?utf-8?B?NTFlZnBhTmJ6ZXErSXhlTWVwSDlYVFZhbzE2MExSYjFJaFR0ak9MUWxLRG5Y?=
 =?utf-8?B?UlBoZmdWYWhKWkxPcHZnMEtVVzJhTU5SL1UwNXl4VEY4WkJkT212aXU0YXdT?=
 =?utf-8?B?TXp3anFZMjI3V0QxVkN2VUF5VTNiN21XWEs2cldlaldlMUYxODlwZG1vZ01O?=
 =?utf-8?B?NTM0cm5zOVV0czdlY2J5UWUreTJNV1ExRVVma0EyMUppV0Y3V1JiVmpOQk9P?=
 =?utf-8?B?MUw3VkYyYkd6T210ZkFOb2RGci82MndMNjRMUG9MZzFGYTBwMWhKbjZHUnRx?=
 =?utf-8?B?cnFxRHptYlhkNXhjS01wVnFYRU9oQnNKc1dzNlg5eVlpSGRSbXpCYTNCWnY5?=
 =?utf-8?B?bXZHZnVheGhzNi9pb2IzSGFSdXYyYUVwMWpxd2N0ZVZHZXdHTUJhK1VIaUN3?=
 =?utf-8?B?c25HWU14Y0hvNW5ZcWZuckhkTmtYeDBFYmcvTTgrRnJIZDZMRDFnVXNXSEZa?=
 =?utf-8?B?MWFBcmVTL3R3UTNHT3dYbkN5MlRoYmRPVW1LZDJTWnVYc2xmOE5lZ293dWJV?=
 =?utf-8?B?dWQwMGpycXZIaStmZ1hVcFJkVzUyUElGQ1NIWVhTSnUrWUVrU204Vi9sQkFx?=
 =?utf-8?B?RDY0TUNZK0VZeEY5bWpSOVlLQm5tY0tWZWFSZHd1Tis2Z2gydkRTRUFOUE0r?=
 =?utf-8?B?alhyM3p4a3FkcjFQMkU4bkpZSTRBM0JpZjlnaTlSWU9LRjdwMlIzZ2pyc1E4?=
 =?utf-8?B?emw2eVBFb1JIYW5IWitkd3duKzU5WWRsakxiektERnZvZnF1M1hKM1pSUWFX?=
 =?utf-8?B?WEpzS3k2aXI5dGdRajJWUG5WNDJFRXg4RGdlcWt4NGgyUGRsZytheFMvZENo?=
 =?utf-8?B?YThjTHJGTWlVUXVHQVMyM1o1RmhDQ0EzSXpDbXdXcTZuRml2M1cwMFkweGhQ?=
 =?utf-8?B?eFplSlpQd00rdzZCR3VPSExtcGRXdTFhMHZ4WGVIWGt6SktjNjRORnlZQ1hN?=
 =?utf-8?B?UTFPd1lkSFRteU5oNFlBY3RnT1FSS1BBOTBUNDYzSDQ4aCtNNUNGVmNrd2Ja?=
 =?utf-8?B?cG11VGhUTmkrVXhrNUR2YmpiSHpqbUxTVjlQeFNmQkF3cjBWSjZOU1ArSVBs?=
 =?utf-8?B?K2lwdWgzWGpRVW1NL0c5QkZYeUM1TWR2MTdFNi9OTW8xcTRrWGxDazh2elR1?=
 =?utf-8?B?VnpOYnAzOUxRK1pOYnBzTjVHNXN5bUg0Z3JBK1Y3dUpkdDJ2ZmFGSTMyclJj?=
 =?utf-8?B?Z01hY3dIYnFXaWJpQnVwNS9wamhwU2djWi9Na3NVVyt2NEkxTTV6dUwxdUtP?=
 =?utf-8?B?bEdwMmpJbGhLam1MWXI3TWJxR1RDVTRCcHQ3THlRWWt1ZG9jbDhNYjF0ak5U?=
 =?utf-8?B?b21jQnBGRzk3aHd5cWlQRjBVdXM0eHZJM3pjNWhyWkxaeWZqMTlnVjVNak1U?=
 =?utf-8?B?WkJWaHB2ZERKVTNnZWpyb0dsSlpGdXdveXBiOGVDaHFKU2J2Z0pzL0JNTUFC?=
 =?utf-8?B?c3NXRGh4RWNtU2ZLbTl3d08xcjhJRit2bDJVaE53bHZpQi94ck5ZWFMyMzBw?=
 =?utf-8?B?TjlqUDFFNCtJZ1d0UTVFdFRvVDhpdThINXd3UzdvSDR1UTg1aDNYWnU0UTlh?=
 =?utf-8?B?a1pzeS85M1p6TWs0bE9iQzdoWkhDUWJOY1ZLbEE0dGxCLy82S3B4YmY1dGNC?=
 =?utf-8?B?T2Q0NDJETUwwdXdVd0gxUFRJYnh4L2NuTWd1L2lDQ2xlQ0d4NEpTQkM0STht?=
 =?utf-8?B?Um8ydDZ5eFBzeVFhendIam0zZk5qMGtUVGZUZ3BWU1RlVjFaU1NZUzZWcGJY?=
 =?utf-8?B?QzZuSDNjblVudXRCL3loazZ5MjZQUTBmTlU0OXF3MGdKa2FLY2VyK0thMjFW?=
 =?utf-8?B?UVJsVXpGWHJXcGRHMUlqalF4WWU3YzJmVDhaQ0pnUDRJQ3RjMXFmbk1NVkhh?=
 =?utf-8?B?K0lZZ0tiaTZPRGJVeE9nVklEZllNZ29VUGhwSy9YWW5yUHU3WE53RHcwOFFJ?=
 =?utf-8?Q?/Moxyh?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <BAF6D9628D255144A8A3CF324707F74B@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6087
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252E1.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e056cd71-1243-4012-fa23-08de3dad5699
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|30052699003|1800799024|376014|36860700013|14060799003|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ajBTdDI4VlZNZlkrTHVxVmdQUy9RTyswQ2lCVE03OCt6bkFyOThJMzZ0cGJs?=
 =?utf-8?B?ZEtsM1ZuckFIYXJVVDJna0s0WFpXSnRIbHlQSGpzdHFSMXA3dnp1azVJa0s2?=
 =?utf-8?B?bHlXU3kzYTdNOGdyWFpNVFNqa0h2SzVVdVVHbXBXaElsVzg3TlZLR1QzSE9M?=
 =?utf-8?B?ODBHMit2YVYwOW5BOCtkcWNUNzg4YVVIM0FXWjhVZ1JWMEkrOVJmQWlQRlg3?=
 =?utf-8?B?K29iS052Rm9WNXlucXBnWCtJbUtqUkVhdTZ2NW9qMWQ1aTgwbUFhbXBmMFpG?=
 =?utf-8?B?TG4vYkZTOCtrWW1hZllQQkcrSHhwbEdrQW9PVGZ5TWsxM0V6Sk5lcHAvaTBN?=
 =?utf-8?B?NVBJNzJlSHk4cldyMUdoWVlVYXJzNWZXeUJwcmFiK3ZOeE5yMWRLL3RDK2ln?=
 =?utf-8?B?OEh0UmJweThnWXViMHp2ZEZubE9WR3lMOEVuYUxic0QxbUZkTmNhREFDZnFF?=
 =?utf-8?B?YTAxTlYweWxkSENzOGJhL0JGOFBYWGVCZVBqTkt3UlFrSWtnVUpZdnVIbGNN?=
 =?utf-8?B?MmZHWHVzVHZlN1dmQ3RXaldBYkdUTU1ac0kxb0REK3l5MFdnNFlIMFl0V3pK?=
 =?utf-8?B?Mmc2aDBCUGdQaEN6ODBicm5CZGloeUVsNmVveUlpQXZEeitIZEJOT2x1aDFI?=
 =?utf-8?B?N01ucDRtVlhUM0tKeXJqOXlqb3ZVRWdPNjduN0tWOUtUTDFPVnordzZ4czJW?=
 =?utf-8?B?aENKL1ZnRmpUUEdqMERHcW02dDJ5MVovdlNuSmtEdDBORFVtSDhjNXVzUThv?=
 =?utf-8?B?YkVHNjloOTJXdVVZRHF5TUhvS05GWTdRWW5YaC9mUHNnNGNIR29BMFdONkZr?=
 =?utf-8?B?OXhYYjEwOVJYWHA1bDB6WEYrbVZickVrQVluRXhwa3lIZmZnVHdCRmFjSEZ6?=
 =?utf-8?B?S0k1ZnZFbXo3TDJTU0tacS90MUVPY2UzNlR3ZXpiQ0RSMHRUekF6clhHVm5Y?=
 =?utf-8?B?NnJyWnI0eU5vTmR3ZWhnb0xIa1QvTGV0d3B4Rys2eWpqOEFHSXhBdkVraG1T?=
 =?utf-8?B?QXY3anZtTHF1cjZtanoySFQ3QkFmK1pVeU1rRTE2L3dzMXVSRXpKL2g5SEd2?=
 =?utf-8?B?WTlsT1FQa1pIWmYyQzAwc295c1NhQkdEei94MGxaeXVJKys3RkswTFRpY0Yw?=
 =?utf-8?B?YUkvN1llRFd1NjNHZjRZMS83V2pEc0tsdmFlNmVIV0l5Um1WRUg4dktCMVRK?=
 =?utf-8?B?U3d5U3ozNy9HaDk4eFZTQ05pVEZma2k4STAvTjhoMkpQdWFzcXpFTDdQZmtU?=
 =?utf-8?B?V0NBZmliYjZ1aWE5MEpzc3AwM01JcnFWR1dhU1N2dVk3dlV0U2ZLd3FQR1hV?=
 =?utf-8?B?ek5BVzlRb05sT0k4Y0ErRDliMzBON0h0YUdaeVhyYXRKYU9abUtJTytIeXph?=
 =?utf-8?B?TUwwaSs0aFhRYThZSFJLUDh6aGwrdmZVMU41NmlPVTRBclNHdWpEVjRsUEpH?=
 =?utf-8?B?OVZQanczUENQSytUREU4a1lkbE9HTE1kazZabWRwNktwSTE0aUFhdWNjRVpU?=
 =?utf-8?B?K00xdlhnUE1JRHpNbXQ1dEkrMCtwYXJIQVFBb2pJQjlqdFNDMjFxU25FT0hO?=
 =?utf-8?B?YVJhNnNnNFZqdFBaWEZ2ME5ub1dqandqclhtWVdaTXMweFcvQzA2Uk51Ri8y?=
 =?utf-8?B?bVROcXl1L3pDNmhtc3Z1WFlwTVhlaTN6QjZSb0RTRnpxVFVGa0t2aU9abmpt?=
 =?utf-8?B?YnlsM0JiOWcrMkp3RTFYRlhQdzJqTVdzL0IvM2JJUG51cllMdFVyMkdhcEt6?=
 =?utf-8?B?TWJZbHVlVXo3K3FrVG8yVTBrVXM0US9kSjlISXNXK3VRM2VOYTRyYzNXVER1?=
 =?utf-8?B?d1djMEQrMldFbUZXNXI3UDdBQ1MrS2YzL0w4ek1pck4zdzZFdUtGR0F1Mldo?=
 =?utf-8?B?MFcxVGdpNWVFY3FremxOR2xuOTVsVGUyV0pRL2trRFdXYlVrazRvM1dyenFt?=
 =?utf-8?B?R2paeDhZZGdDQmhjb1dRVVJtYzdnczlXY1NZKzlqYThsUWgvYk5pM29CUXpW?=
 =?utf-8?B?SC8rRU5WSDlwRjJpalBBVmJ1MG9ZUVRwMkhMVWtpNUE5Q2ZFdE1MUE1xdTFQ?=
 =?utf-8?B?cmVkeGdoSW5ENVl1NktLNHZGcXZTWkdzbTFtUFJVb096blI1WS9sUllEamQ4?=
 =?utf-8?Q?u7kk=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(30052699003)(1800799024)(376014)(36860700013)(14060799003)(82310400026)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 20:47:26.4045
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7577aea6-bbc5-46bf-46fb-08de3dad7cc3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252E1.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB8032

T24gVHVlLCAyMDI1LTEyLTE2IGF0IDE2OjQwICswMTAwLCBMb3JlbnpvIFBpZXJhbGlzaSB3cm90
ZToNCj4gT24gRnJpLCBEZWMgMTIsIDIwMjUgYXQgMDM6MjI6NDVQTSArMDAwMCwgU2FzY2hhIEJp
c2Nob2ZmIHdyb3RlOg0KPiA+IE5vdyB0aGF0IHRoZXJlIGlzIHN1cHBvcnQgZm9yIGNyZWF0aW5n
IGEgR0lDdjUtYmFzZWQgZ3Vlc3Qgd2l0aA0KPiA+IEtWTSwNCj4gDQo+IFRoZSBvbmx5IGNvbW1l
bnQgSSBoYXZlIGlzIC0gYXMgZGlzY3Vzc2VkLCB0aGlzIHBhdGNoIGlzIG5vdCByZWFsbHkNCj4g
ZGVwZW5kZW50IG9uIEdJQ3Y1IEtWTSBzdXBwb3J0IC0gaWUsIGlmIElSU19JRFIwLlZJUlQgPT0g
YjAgdGhlcmUNCj4gaXNuJ3QNCj4gYSBjaGFuY2UgR0lDIHYzIGxlZ2FjeSBzdXBwb3J0IGlzIGlt
cGxlbWVudGVkIGVpdGhlciwgbWF5YmUgaXQgaXMNCj4gd29ydGgNCj4gY2xhcmlmeWluZyB0aGF0
Lg0KDQpJJ3ZlIG5vdyBleHBsaWNpdGx5IGNhbGxlZCB0aGF0IG91dC4NCg0KPiBPdGhlcndpc2Ug
TEdUTToNCj4gDQo+IFJldmlld2VkLWJ5OiBMb3JlbnpvIFBpZXJhbGlzaSA8bHBpZXJhbGlzaUBr
ZXJuZWwub3JnPg0KDQpEb25lLCB0aGFua3MhDQoNClNhc2NoYQ0KDQo+IA0KPiA+IGNoZWNrIHRo
YXQgdGhlIGhhcmR3YXJlIGl0c2VsZiBzdXBwb3J0cyB2aXJ0dWFsaXNhdGlvbiwgc2tpcHBpbmcN
Cj4gPiB0aGUNCj4gPiBzZXR0aW5nIG9mIHN0cnVjdCBnaWNfa3ZtX2luZm8gaWYgbm90Lg0KPiA+
IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhc2NoYSBCaXNjaG9mZiA8c2FzY2hhLmJpc2Nob2ZmQGFy
bS5jb20+DQo+ID4gLS0tDQo+ID4gwqBkcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12NS1pcnMuY8Kg
wqAgfCA0ICsrKysNCj4gPiDCoGRyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXY1LmPCoMKgwqDCoMKg
wqAgfCA1ICsrKysrDQo+ID4gwqBpbmNsdWRlL2xpbnV4L2lycWNoaXAvYXJtLWdpYy12NS5oIHwg
NCArKysrDQo+ID4gwqAzIGZpbGVzIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKykNCj4gDQo+IA0K
PiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12NS1pcnMuYw0K
PiA+IGIvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjUtaXJzLmMNCj4gPiBpbmRleCBjZTI3MzJk
NjQ5YTNlLi5lZWJmOWYyMTlhYzhjIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvaXJxY2hpcC9p
cnEtZ2ljLXY1LWlycy5jDQo+ID4gKysrIGIvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjUtaXJz
LmMNCj4gPiBAQCAtNzQ0LDYgKzc0NCwxMCBAQCBzdGF0aWMgaW50IF9faW5pdCBnaWN2NV9pcnNf
aW5pdChzdHJ1Y3QNCj4gPiBkZXZpY2Vfbm9kZSAqbm9kZSkNCj4gPiDCoAkgKi8NCj4gPiDCoAlp
ZiAobGlzdF9lbXB0eSgmaXJzX25vZGVzKSkgew0KPiA+IMKgDQo+ID4gKwkJaWRyID0gaXJzX3Jl
YWRsX3JlbGF4ZWQoaXJzX2RhdGEsIEdJQ1Y1X0lSU19JRFIwKTsNCj4gPiArCQlnaWN2NV9nbG9i
YWxfZGF0YS52aXJ0X2NhcGFibGUgPQ0KPiA+ICsJCQkhIUZJRUxEX0dFVChHSUNWNV9JUlNfSURS
MF9WSVJULCBpZHIpOw0KPiA+ICsNCj4gPiDCoAkJaWRyID0gaXJzX3JlYWRsX3JlbGF4ZWQoaXJz
X2RhdGEsIEdJQ1Y1X0lSU19JRFIxKTsNCj4gPiDCoAkJaXJzX3NldHVwX3ByaV9iaXRzKGlkcik7
DQo+ID4gwqANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjUuYyBi
L2RyaXZlcnMvaXJxY2hpcC9pcnEtDQo+ID4gZ2ljLXY1LmMNCj4gPiBpbmRleCA0MWVmMjg2YzRk
NzgxLi5mNWIxN2EyNTU3YWExIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvaXJxY2hpcC9pcnEt
Z2ljLXY1LmMNCj4gPiArKysgYi9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12NS5jDQo+ID4gQEAg
LTEwNjQsNiArMTA2NCwxMSBAQCBzdGF0aWMgc3RydWN0IGdpY19rdm1faW5mbyBnaWNfdjVfa3Zt
X2luZm8NCj4gPiBfX2luaXRkYXRhOw0KPiA+IMKgDQo+ID4gwqBzdGF0aWMgdm9pZCBfX2luaXQg
Z2ljX29mX3NldHVwX2t2bV9pbmZvKHN0cnVjdCBkZXZpY2Vfbm9kZSAqbm9kZSkNCj4gPiDCoHsN
Cj4gPiArCWlmICghZ2ljdjVfZ2xvYmFsX2RhdGEudmlydF9jYXBhYmxlKSB7DQo+ID4gKwkJcHJf
aW5mbygiR0lDIGltcGxlbWVudGF0aW9uIGlzIG5vdCB2aXJ0dWFsaXphdGlvbg0KPiA+IGNhcGFi
bGVcbiIpOw0KPiA+ICsJCXJldHVybjsNCj4gPiArCX0NCj4gPiArDQo+ID4gwqAJZ2ljX3Y1X2t2
bV9pbmZvLnR5cGUgPSBHSUNfVjU7DQo+ID4gwqANCj4gPiDCoAkvKiBHSUMgVmlydHVhbCBDUFUg
aW50ZXJmYWNlIG1haW50ZW5hbmNlIGludGVycnVwdCAqLw0KPiA+IGRpZmYgLS1naXQgYS9pbmNs
dWRlL2xpbnV4L2lycWNoaXAvYXJtLWdpYy12NS5oDQo+ID4gYi9pbmNsdWRlL2xpbnV4L2lycWNo
aXAvYXJtLWdpYy12NS5oDQo+ID4gaW5kZXggOTYwN2IzNmYwMjFlZS4uMzZmNGMwZThlZjhlOSAx
MDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL2xpbnV4L2lycWNoaXAvYXJtLWdpYy12NS5oDQo+ID4g
KysrIGIvaW5jbHVkZS9saW51eC9pcnFjaGlwL2FybS1naWMtdjUuaA0KPiA+IEBAIC00NSw2ICs0
NSw3IEBADQo+ID4gwqAvKg0KPiA+IMKgICogSVJTIHJlZ2lzdGVycyBhbmQgdGFibGVzIHN0cnVj
dHVyZXMNCj4gPiDCoCAqLw0KPiA+ICsjZGVmaW5lIEdJQ1Y1X0lSU19JRFIwCQkJMHgwMDAwDQo+
ID4gwqAjZGVmaW5lIEdJQ1Y1X0lSU19JRFIxCQkJMHgwMDA0DQo+ID4gwqAjZGVmaW5lIEdJQ1Y1
X0lSU19JRFIyCQkJMHgwMDA4DQo+ID4gwqAjZGVmaW5lIEdJQ1Y1X0lSU19JRFI1CQkJMHgwMDE0
DQo+ID4gQEAgLTY1LDYgKzY2LDggQEANCj4gPiDCoCNkZWZpbmUgR0lDVjVfSVJTX0lTVF9TVEFU
VVNSCQkweDAxOTQNCj4gPiDCoCNkZWZpbmUgR0lDVjVfSVJTX01BUF9MMl9JU1RSCQkweDAxYzAN
Cj4gPiDCoA0KPiA+ICsjZGVmaW5lIEdJQ1Y1X0lSU19JRFIwX1ZJUlQJCUJJVCg2KQ0KPiA+ICsN
Cj4gPiDCoCNkZWZpbmUgR0lDVjVfSVJTX0lEUjFfUFJJT1JJVFlfQklUUwlHRU5NQVNLKDIyLCAy
MCkNCj4gPiDCoCNkZWZpbmUgR0lDVjVfSVJTX0lEUjFfSUFGRklEX0JJVFMJR0VOTUFTSygxOSwg
MTYpDQo+ID4gwqANCj4gPiBAQCAtMjgwLDYgKzI4Myw3IEBAIHN0cnVjdCBnaWN2NV9jaGlwX2Rh
dGEgew0KPiA+IMKgCXU4CQkJY3B1aWZfcHJpX2JpdHM7DQo+ID4gwqAJdTgJCQljcHVpZl9pZF9i
aXRzOw0KPiA+IMKgCXU4CQkJaXJzX3ByaV9iaXRzOw0KPiA+ICsJYm9vbAkJCXZpcnRfY2FwYWJs
ZTsNCj4gPiDCoAlzdHJ1Y3Qgew0KPiA+IMKgCQlfX2xlNjQgKmwxaXN0X2FkZHI7DQo+ID4gwqAJ
CXUzMiBsMl9zaXplOw0KPiA+IC0tIA0KPiA+IDIuMzQuMQ0KDQo=

