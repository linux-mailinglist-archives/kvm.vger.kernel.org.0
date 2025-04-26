Return-Path: <kvm+bounces-44456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 358AAA9DACF
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:50:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A572461AC7
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF442946F;
	Sat, 26 Apr 2025 12:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pvXxrG1d";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pvXxrG1d"
X-Original-To: kvm@vger.kernel.org
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2042.outbound.protection.outlook.com [40.107.247.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9346C182B4;
	Sat, 26 Apr 2025 12:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.247.42
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745671826; cv=fail; b=GuHrPfGixd+UC8BIVW8HQ/f7NExIFpikk4CYBvP3F729D2B8PEU8nuQoBWHa9a30KdYQ5my4ownws3/XeZ2jG0oePmGvVsX/am77JA6E07CwnNE8xb/7JthHvAPMaOstSjv60ML0aUaZkUt2pM4ntf/W+38RSoTQzzEHkX0jJZg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745671826; c=relaxed/simple;
	bh=bEwocbbX/2tiOpdHejF4D6wv0/0a2SbsMOygvwVnVS0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VdXVzjZuWBEKvMa3Hkx1wGcQdXA9h5BGjwk77PaOb9vcU81iaexEoSYzCWUJivSW4bfjR2DlWx0kfy6bNU4aTAVfmDY7678Rw1oH8rJW90iip11AkVKjV+ZRFGp6ku75MZtRZ8fw6QB90Vqa1F2/VkZxfiIjNq1EKUAN27z0pAU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pvXxrG1d; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pvXxrG1d; arc=fail smtp.client-ip=40.107.247.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=eO48fY5Xs1V/6+Lu0mEkKQM0gCiIhk2/h1413CDWkZaTbhMm21dcdTW/lvBJQeAc3ey9CNKpOSxBdT5G2fX70Nm/Z2F7EX57pH3EfRgOdvpbojYoB2Zfc/Dws7+KaE9k7WlOSmhJgvZxa5+Sv3ilw0VW6ISgxvedE9dGd9VoDDxHrH0k2h8J2w4UR3YoSh0OVMFA2zaKJWumHGN4IQ2lH4KYlxU67b60x/SXZFaYgUda1Q/xXWs97RXdvBrmG1R+/k7FJcx5Ro+RHLTzan6kCFmvFyBQ1F+vCxjNA+LgdvOdCW+V+Uot6Gb4La/lZunv1Gsvq+xzX6j0gxHuUMPN4Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bEwocbbX/2tiOpdHejF4D6wv0/0a2SbsMOygvwVnVS0=;
 b=YYvYQzs2u6CVjuChq8skbeW7fGxg5Ic7qJCIpIgNqPqZMFiVlzD1wEY5QrDNsb2sePv4Hv1SP0eRsSc6w7tFgsV4Ok/XUiaRuUBxCgWLY159XIKA6SOWyuyniQE6/wAsBFJk2n7vDYQojw1EsTjN1LUEtvQU8KbyD0ImuNST17sLwzuHufyaMoPc6FW7fNx47igViC664HxkgottdmYHQ2KjdJfepFeh+7ZVwh+t5YI463Gu1asCKy/MN2/jjOktAcY4m/BMUU7WU/HOPDQxb3qnK11SWr0oHiWwK7RadNOfqkf8fIfZ21BflmccrOkxt2o3DFPxLf9/iEgLQRchtQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=redhat.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bEwocbbX/2tiOpdHejF4D6wv0/0a2SbsMOygvwVnVS0=;
 b=pvXxrG1dFDI0PSv7J0zBTTVyoZu4EJ3IAaiYA4jnKg793EswAIosVMBN9r8n5bd5Itm9PmRJpO3wxGF+BXHTwYrfyOWIAtssRT/U9DK+qts9JWqhKM5SFAuhUROehIsacViK4vLjqD/O++m9Ou99T5W3awQmHPNZjT7l5KEVDQ4=
Received: from AS4P190CA0002.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:5de::11)
 by DB4PR08MB9862.eurprd08.prod.outlook.com (2603:10a6:10:3f1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Sat, 26 Apr
 2025 12:50:17 +0000
Received: from AM1PEPF000252E0.eurprd07.prod.outlook.com
 (2603:10a6:20b:5de:cafe::27) by AS4P190CA0002.outlook.office365.com
 (2603:10a6:20b:5de::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.36 via Frontend Transport; Sat,
 26 Apr 2025 12:50:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252E0.mail.protection.outlook.com (10.167.16.58) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.12
 via Frontend Transport; Sat, 26 Apr 2025 12:50:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P9fsnwt+7Ie43bXFsUL4MoGLPm8e4FjECobbmwy2XqJg4zH+CWj80jF39auxIP3R/DzLIa8uIgukko97Wl0n7tjzznPhJX0U7m6xgE4tkrky3gkNWYdWbuf8BdL2B0a4cCPSxQ0GFp3R/tw0F50ghFOxWMOngsiD8iJzha25amAkDnuHb+WIHRXzUT+vuoSzG/I88Aoy3XkYe06MbpcM9UZezP4SbzY2daXzkwPPoUEVFwUR1Rpia7noKaxvzyxb9f0XgsbwOkV5Li3q6bkCBDaYcfWgudsTDKfJZiPTFtGhMUDjadXMrPjRALQBfNQjk2RoJMsdRrBDXnba31qmnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bEwocbbX/2tiOpdHejF4D6wv0/0a2SbsMOygvwVnVS0=;
 b=kj9no+a3VeCQLFAZGW2gn6+YBphRrBYkVSszgTq2cjjJ+TmUKNqJ3vkqX6Cv1s1v/RAd9G+5FJ4wyRaD+h1u38zDu738LtZflxNTEe+e6Pm9EtLCyC1TysLJXVjIsc3QdmV8uxtJFbTRlQQn6HfLphQv2WvylEXwkoPgB6ZO4iiqBgkqtWwkWgOAz5sItNeRQLmd7YESQ/K/B/Pi4bjMq3Z1LPjnnvyWYJOcWuSoYElKkH0FU6rwU0KvpTRVs1wqxDAZZN7Jq8ybq5VM67n6CqDkNMQitqu7EPCcxyMqLW/N8k9kZmn5VlqGHJn0d4aY6mKnWj2uSS/0AjskTHIbMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bEwocbbX/2tiOpdHejF4D6wv0/0a2SbsMOygvwVnVS0=;
 b=pvXxrG1dFDI0PSv7J0zBTTVyoZu4EJ3IAaiYA4jnKg793EswAIosVMBN9r8n5bd5Itm9PmRJpO3wxGF+BXHTwYrfyOWIAtssRT/U9DK+qts9JWqhKM5SFAuhUROehIsacViK4vLjqD/O++m9Ou99T5W3awQmHPNZjT7l5KEVDQ4=
Received: from PAWPR08MB8909.eurprd08.prod.outlook.com (2603:10a6:102:33a::19)
 by DB9PR08MB7423.eurprd08.prod.outlook.com (2603:10a6:10:370::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.28; Sat, 26 Apr
 2025 12:49:42 +0000
Received: from PAWPR08MB8909.eurprd08.prod.outlook.com
 ([fe80::613d:8d51:60e5:d294]) by PAWPR08MB8909.eurprd08.prod.outlook.com
 ([fe80::613d:8d51:60e5:d294%7]) with mapi id 15.20.8678.025; Sat, 26 Apr 2025
 12:49:42 +0000
From: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, nd
	<nd@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian
	<kevin.tian@intel.com>, Philipp Stanner <pstanner@redhat.com>, Yunxiang Li
	<Yunxiang.Li@amd.com>, "Dr. David Alan Gilbert" <linux@treblig.org>, Ankit
 Agrawal <ankita@nvidia.com>, "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
	Jeremy Linton <Jeremy.Linton@arm.com>, Honnappa Nagarahalli
	<Honnappa.Nagarahalli@arm.com>, Dhruv Tripathi <Dhruv.Tripathi@arm.com>
Subject: RE: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Thread-Topic: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Thread-Index: AQHbhLKEApVfqCfEsEO/VXZQklRIvLNdGTmAgAMUiDCAAi90AIBT69aA
Date: Sat, 26 Apr 2025 12:49:42 +0000
Message-ID:
 <PAWPR08MB89096DF4699C5F17F37B17499F872@PAWPR08MB8909.eurprd08.prod.outlook.com>
References: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
	<20250228114809.57a974c7.alex.williamson@redhat.com>
	<PAWPR08MB890947144D61177C7BDD2D669FC92@PAWPR08MB8909.eurprd08.prod.outlook.com>
 <20250303201246.5122beb5.alex.williamson@redhat.com>
In-Reply-To: <20250303201246.5122beb5.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PAWPR08MB8909:EE_|DB9PR08MB7423:EE_|AM1PEPF000252E0:EE_|DB4PR08MB9862:EE_
X-MS-Office365-Filtering-Correlation-Id: 10dfba6b-cdee-47d3-8c2f-08dd84c0e48b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?eHhmZFJjcjBmajdWSEg3MVlQaHRoNVdRd1VjU3ZycGhCVDk0RHpqd2x5RTdB?=
 =?utf-8?B?a0s3SlVEb2VQSkdqTHF3YmxTbVo0OUZkU1JvWHVTVTdzZk9icENybFhRWjVD?=
 =?utf-8?B?L09HVzljb3RTQ2NXc1RkVmhoU2xBcXRBTksyaElXVlZ0dFVDcWh5SEFJdXpi?=
 =?utf-8?B?RGNubFZ2eVFYWkVGTmtPT2t0Yk5yY1BkSEJScGEvR0xwTnVFR280aTZaWGdN?=
 =?utf-8?B?ZGtwT1Y1c1VmOVhMYk5UR3lRcEVvYUlYN1REWCtsckhEeUsyUks4MHpPdCsz?=
 =?utf-8?B?RU9pdkkrQ1BNTk5tbkIzSnhURFNkbWNwa0pBclh2UUJvTGw0dllrQXMwZ3F6?=
 =?utf-8?B?MEk2TVhrazRFSFdQL1NDM2NDMnpjbUZsb1BObk9STVQvem0rU1hNRlM1NHRU?=
 =?utf-8?B?YXluL3YrWGRlY1l4YmVEY3IwNFFkakxWVGlNSGpSeHU3bkthcTRNREVMYU81?=
 =?utf-8?B?cGNKOHhKRzJQbytlWlVBSG9QRVRtbko2eHk2V2FPRytOcXJxeTJsT0MxaHlm?=
 =?utf-8?B?blRZc0VGQ0RLWUordmxZdUpFM1QySFBYU2U2NDFyTHFFZnpxKzBVMUN3djBM?=
 =?utf-8?B?dGIvU1BUZzJCUnNmRmR6dXRKOFYrUDBSdnVROTZuWTR0STUxaWROUjIyQTd1?=
 =?utf-8?B?WEEwSnJ1c3FFN0ZOU0E4RlVtS3I5ZUplV21FeFI5SjZ0TjluR3d3bnBpR2FX?=
 =?utf-8?B?UGNpdHhoK3VZeTdrdjVxMnZyVzVxZFpNRHFWMFhHTmtkSy92WFE0ZUtCeUNv?=
 =?utf-8?B?SEg5bVFqU1RXMlZoRXM0ZGY5VGlmNm1FM1BrRVI1bVhBam0zNXYrNzdKUlBW?=
 =?utf-8?B?cXhlMVBOT2FhdFppUzAwb3BhaklTRFczSTlJMHloNjl4SnM5NEMwMVpUQXI5?=
 =?utf-8?B?NDJaK1JHVkZjdzVoSzJaZ1hWUFhKaytIRC9abFJHS09EdGxPeE1ONzE5M0Vi?=
 =?utf-8?B?L0pyb3FxOW16U0VCL0Q1bVlKZUlaUWN0ZUgvWEpsRVBnVUpJTXE0Tzd1S3J0?=
 =?utf-8?B?dUVYR09ReGVpSHJjcWlZQVFpL1J1TjdaMTVwbWE0VHhlVktKbkVhN2d6L3Nm?=
 =?utf-8?B?VmFEQTNDcjJXK2JEbjlxRHBFdmhlTWpuQzVnYWpHeVVkamdhT2JZdjFPZ0t1?=
 =?utf-8?B?YXZtVndzNzNKVitCOWZJVmlGZzBzN09QMndTVFlkQzl1OVpQWjZxVi9tMC9P?=
 =?utf-8?B?YTZxZEtPb0RENzdiL3g5TVZ3UCtMc1hoT2N2K2Rtc3psMVVyQzA5YmJCRkh6?=
 =?utf-8?B?RlRBbXVmS29FZWN5UlJwQkRBYlJCVEt0ZDFsZ2RHek9lQlpXclF3cUZQS3hV?=
 =?utf-8?B?VHVZUUs1NmxmS1VLaXUrWlRPNGc1cGtMdXJDL0tCWlZ1Zi9KYU9QSVYzMGw5?=
 =?utf-8?B?aDhHQS90TnBEUmZKSUQveU94K1VjcXBqVVlwM2hjYWYxL1VQR09mbzdqMDMz?=
 =?utf-8?B?UmcvQW5lWnl3STNiZlgrRkNHVW5QNUFONDdnWE5iNXNsUjRZL2hBdDliS2x0?=
 =?utf-8?B?OWNsN25ieU9MWUVNODZZbWw0SGdiSnZ2VXBwWE43RnVxZnBvQktFNnJRTW1Y?=
 =?utf-8?B?OWJXU09FUTZkejZCbTNqRXVsbUROdUMxaTJrcmVIeGtkV1piakFtTHBhOG00?=
 =?utf-8?B?NEY4b0dvOVBMRUJsNzhyM2IwYy9Ha0JsTjUrTkRIYjJ2QmlpRllKMWdFWFU5?=
 =?utf-8?B?OVhEbmpOMmdmSDZGYnRuMVI0VFJJcUUvaDF1TGFkemtnTlB6ZW1jZHlFUnJO?=
 =?utf-8?B?WnBreW9TbTdvMDVlSGtTS09rbE9zNnByUmpzOVdCSGdwQ3VvY0VYTDdJcVRE?=
 =?utf-8?B?ajV3bjZFRTM2QmRtN1NudjZVMW5EdDNWSmkza2NVd21VNFZreHpEU2dYcE1R?=
 =?utf-8?B?Nyt3dzUrTDNTcnZGc1I3TnhlOXpsZ3RnT2tJTFA5YWlmTVQrTVAzYWIrMDMv?=
 =?utf-8?B?Ty9HVitDUW5vVUtHMXQzYlFFRDkyTzFtc1VHYXpxVDUwbncwUkI1UDNyRGkz?=
 =?utf-8?Q?t8w1+5UFm2OtsJydnfAVekxgI+2QM8=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB8909.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7423
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252E0.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	061926fe-3114-4b60-124c-08dd84c0d0c0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|35042699022|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aGdUVGhxd3V3cE5DTEg0Z2FXWFY3OFYxNGdjcmxwV20zclVhekdTUHhVWGdM?=
 =?utf-8?B?T1NXZkpsdEVjQkdLS3RBU2xJUHNoSk9UY1F6OG5HZFdWQ0ZrcDB1bUxtVjJB?=
 =?utf-8?B?R0FSVzJRVVhZMEZXYzQrcnNabmt3Q2hPVjlJc0NISGRabVpHR3R4OHpJR1Va?=
 =?utf-8?B?RXpZQWxscVhSck1KYnE0WFRmNElaNkN4SnpGUXZjQldOSzVLemVWOXpSWXBF?=
 =?utf-8?B?K3N2RVZ0T3NEU2R0aFpPbzN0aTYwRXc4TkY0RkorS2p2NExBNWdiYUhQTHZW?=
 =?utf-8?B?Ujl1TysvNXh3amdlSDFva2wvZFlrejVkT0ZpakxpYjQvcCtiYWpiRCs2QXJT?=
 =?utf-8?B?Y0Z6ZEVTQ1p5TnRRbDMvUVBIQy85MTB2Sk8veUttcm5hTzNYN3E5c0JoYWZF?=
 =?utf-8?B?WUR5Q3BlU01EV3dNaDRJTE92RDZGVHUxYVFQUVd3Z0M4MU1YL1Mwb2xyaHUx?=
 =?utf-8?B?M3Z0YkloSWpNb01XR2h0Qm5jUWRyU0h5aWczOS90bFQxTUp0K2JIdzhqZFFx?=
 =?utf-8?B?MVplRHptWlFXOU4vOVNaZHAzLzRZUkZrQXJlK0N0ZC94MHRRT1FpOS91N0dL?=
 =?utf-8?B?UVZEalQ0aklUTmx0b1hXVkduODlpVGw0cUk3VDBZemZ5UHFaRkpVNjFKd0lU?=
 =?utf-8?B?QTRrQi9LOTVQUXRyWWwrZUdJS0pBbjB4WFZsYVE1Y2szVHY2NndoR2lBbEU1?=
 =?utf-8?B?TFNtelplREhJK2JFRjJPbzFvM0lVcjNpeHJ6bWh4UDIwY3IzZjZucnRmRFNE?=
 =?utf-8?B?YnpaMC9QWERjcVV0NkNOY1NDM3A1TjRQSkZtZi9XanFMdWpYUTlVc2ltZnRo?=
 =?utf-8?B?U1hxSFhra2w2SVE5citZK2svVUlvTjlBeWRYc3JyblhwUUp5d1dTSXF2MzRk?=
 =?utf-8?B?eFVROWhoam1JbW56TlBtTFV3N0tlU0dQTmt0L1ZaV1ZaWC9mNEppajhkanpa?=
 =?utf-8?B?MHNyNE5iN1M1RW9xcHlVRFNXVWhZM3VrOHlFOWVNY1lYY21vK01NMEZ1V05Z?=
 =?utf-8?B?VFAwQ0RRUnVhMjkwZDlJV2w3eGUwK0FHSEovL2dPdzNvM3dkSFMzYVcwSGRD?=
 =?utf-8?B?SGpudS9KM3RYakFSU0JnVk0vWjVrQVRiQ1pCenhBNEFtY0ZKcVAwbjZBbHds?=
 =?utf-8?B?OEljeC9qd0xwMnVJc3JUK1NsMEhBUnJsaU9YUzM3MWRNa1BrMXZPV0hKTmhh?=
 =?utf-8?B?L05sODhHbll5WEhhVFYzMC9PSWoxWWMrSDh3QzE0azcxekJwRjkrYnpKV2FH?=
 =?utf-8?B?QVo0MkVrVExjZnJGYlN1QUJtK2xOTXcwZUZGcUFWMGk2QzQ5QnU4K3ZCSHll?=
 =?utf-8?B?UDJ2Ym14TWpTZUh2alkxK0hsYW5vTE1mdmJNdW04MkdsSHZHbUNrSzB6U0Q2?=
 =?utf-8?B?WVJBdVVMbzBHMS83cjdTbDk2cXV3blNmU1MrcElhWUkrVWxCQjVzOTlPcHFF?=
 =?utf-8?B?TW5VRitYSm5nTytnQnBnYVRLS1c1VE91bnZKWDQwbXNrY0JETnFadDhNSWQr?=
 =?utf-8?B?c05vanVzZEJPYWFyekFNNHJKL1FERzF1enhhUlRhczIzL1pkTHNNTlN5ZTZs?=
 =?utf-8?B?VDAvdHN5M2lFcXpXeG1kUnFjUCs4Z2FYcTdRaTJ4amN5NTBhMXBJbi9mOG4z?=
 =?utf-8?B?aVdCK3RzSGZHRDJrSDB2Z0tlbVYrMk52RDNKUE01N2JRTGYwanZBTVI2VDEw?=
 =?utf-8?B?RjVpazNXeEZoams3MVJhQis0M2x3TGU1d091VFptUDhubjRhR3FYV05sMFB5?=
 =?utf-8?B?UVg4Tmw1N0FDOTQ3Y0pYTE1TVzdORHRWVDFZYks3Nkp2VUpCQndzZGFQY0Iw?=
 =?utf-8?B?U1RVanVEUnhSV0xzcERCa0RBQkZWWnpTUElZbWk1Z3ZQUEFoN3R2ekFsSDc4?=
 =?utf-8?B?dzVoNGsyTDdwd2JkTkFZRkQwNjcwSlhWeGhzbGhUT3RSZmpieWEzQWhLeWsr?=
 =?utf-8?B?VWhPNVBRSjVjNU9kcTIyZjEzeVU5S29Nd25ZbnVuWUVnRlpKVFJzVDJ4N3c1?=
 =?utf-8?B?STA5SEE1ZnZKS1lKTHRTWU5Ca09LVGtFVS9MeW1OYTdzNDhIN1pVd3VKN1dj?=
 =?utf-8?Q?DC/M03?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(35042699022)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2025 12:50:15.8478
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10dfba6b-cdee-47d3-8c2f-08dd84c0e48b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252E0.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB9862

PiA+IEZvciBjYXNlcyB3aGVyZSBzdGVlcmluZy10YWcgaXMgbm90IHJlcXVpcmVkIGluIHVzZXIt
c3BhY2UgKFZNTXMpLA0KPiA+IGNhbGxlciBhc2tzIHRoZSBrZXJuZWwgdG8gc2V0IHN0ZWVyaW5n
LXRhZyB0aGF0IGNvcnJlc3BvbmRzIHRoZQ0KPiA+IGNwdS1pZCwgY2FjaGUtbGV2ZWwsIGFuZCBQ
SCBjb21iaW5hdGlvbiBhdCBhIGdpdmVuIE1TSS1YIHZlY3RvciBlbnRyeQ0KPiA+IG9yIFNUIHRh
YmxlIGluIGNvbmZpZyBzcGFjZS4gRm9yIHN1Y2ggY2FzZXMgdG9vLCB0aGUga2VybmVsIHdpbGwg
cmVhZA0KPiA+IHRoZSBzdGVlcmluZy10YWcgZnJvbSB0aGUgX0RTTSBhbmQgc2V0IHRoZSB0YWcg
aW4gdGhlIGNvcnJlc3BvbmRpbmcgTVNJLVggb3INCj4gU1QgdGFibGUgZW50cnkuDQo+IA0KPiBX
ZSBuZWVkIHRvIGNvbnNpZGVyIHRoYXQgdGhlcmUgYXJlIHZmaW8tcGNpIHZhcmlhbnQgZHJpdmVy
cyB0aGF0IHN1cHBvcnQgbWlncmF0aW9uDQo+IGFuZCBtYWtlIHVzZSBvZiB0aGUgdmZpby1wY2kt
Y29yZSBmZWF0dXJlIGludGVyZmFjZS4NCj4gVFBIIHByb2dyYW1taW5nIGFwcGVhcnMgdG8gYmUg
dmVyeSBub24tbWlncmF0aW9uIGZyaWVuZGx5LCB0aGUgYXR0cmlidXRlcyBhcmUNCj4gdmVyeSBz
cGVjaWZpYyB0byB0aGUgY3VycmVudCBob3N0IHN5c3RlbS4gIFNob3VsZCBtaWdyYXRpb24gYW5k
IFRQSCBiZSBtdXR1YWxseQ0KPiBleGNsdXNpdmU/ICBUaGlzIG1heSBiZSBhIGZhY3RvciBpbiB0
aGUgZGVjaXNpb24gdG8gdXNlIGEgZmVhdHVyZSBvciBpb2N0bC4NCj4gDQoNClRQSCBpc24ndCBt
aWdyYXRpb24gZnJpZW5kbHkgYXQgbGVhc3QgZm9yIHRoZSB0aW1lIGJlaW5nLiBUaGVyZWZvcmUs
IHRoaXMgc2hvdWxkIGJlDQppbXBsZW1lbnRlZCBhcyBhbiBpb2N0bC4NCg0KLS13YXRoc2FsYQ0K
DQo=

