Return-Path: <kvm+bounces-68364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 08054D3840C
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:14:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DA93730E5A76
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:14:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 444D5395DAC;
	Fri, 16 Jan 2026 18:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XWKSliRz";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XWKSliRz"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013018.outbound.protection.outlook.com [52.101.83.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF0B36B046
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 18:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768587264; cv=fail; b=rSvwlKPX7nb00fNaRUzpUdKnKcwdgwQmg8MKmo8NlU3ZxqmoR8RL3+kCszs7666th3w7kZD0DA9NBSTbOV0YnZZMWAuJDu3P8b4aI8lPpVUkxzZawFq+9P8xofqXrFRlb5/KdhU2XVif2pW1x9YwZHF9//c1UN8JoxqSIMeK+KQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768587264; c=relaxed/simple;
	bh=J+TwfqER2YPbaClSJT55hMJfZ/aDQlKhyqIrNzd4hZ0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MBeV7x2Dw920MDidrKlE7sbIL1GnZED4zaoM8F+4+B5aZeJ04vOW0c3i9zbMO5026DLP9ev79XRY766bSfjsfK8xbfsgjLSWf5p2QJR4J0X6c1naVdGMAXnqY+jPeftmy1VQWp2xttZOyZrQhpTmmlmupuC4qmZMGO0o1Iyttzo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XWKSliRz; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XWKSliRz; arc=fail smtp.client-ip=52.101.83.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=wAOCd5O36YwZbjo52TbAgA3m48Y3ogr9ACOUWHqd6QcOISmemW0pD4LbcXkoUfvp+PlbtWW8KOn+yX72MnYaMnFF6zWWNAVITxsTmoVNY5xnRd2eoUljojLAWaHVYoCgkBWHIgbdirTpncqBmuT/7PjPyqq3EhTHCNPJZCXhNHM1Bxv90/183mVlArKTj7upG7VYSJ1JUPeTZrw+laUrydvN39nwWpGR+tJVRfgxvmkXzCb7Gh1WI3ijc2eppeeTUiRbOPhzSV7dqYzUCh0aG6pY5Af6sUCyf/EojyR7QK5EsZ/GM17tonrAwlfCjjWJjvO2UdsoBOmx+R2T+23ftA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J+TwfqER2YPbaClSJT55hMJfZ/aDQlKhyqIrNzd4hZ0=;
 b=DO0jkmzpl21u3g/XqBm9mvBnOmj0wSKWEGyqdcW7sd45L3O75DLAhc8HRQ+N5uihsDcJMyMDAhWA0YfOLwUrbJDqxt/r9TBUyPNYZqYzHUJ7Ldgg+3Z1EkyU2ingGjld7tCYOBMz8MkraZEF0UR3ThFrKqiM+UWmIKehamzW4/DCRlS43qtPge70zBkb9scI93SnCH6KSQsfpN96oPoCuYNXHsqaLZtV8r+n82/2ueawp+Ru272qzGTq0ijvsBsVo5PGcFqEpncsdEhQs46IG5jPiJtyUAauyt33fQE80LuB4OrMaEJGOLP13ie+Fjp6gntxH9yQUXcoTmJRPEOJVg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+TwfqER2YPbaClSJT55hMJfZ/aDQlKhyqIrNzd4hZ0=;
 b=XWKSliRzkDMm5uiBCMAZIlVrUiW0o8AeJoUHZCfXQ1JdbfUJcUNPF7H6pkYi2XMYlBZ7vn7el6t1+py07Tq2iNLBOzUC4T03ydXlPB3TZ+JkkeddHv15T+QVMCfsi2uoq8T+al7IVJ13YxecHQn8aUAwtMfcZUJCYBd8SAbdz4U=
Received: from AS4P191CA0003.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:5d5::18)
 by AS1PR08MB7499.eurprd08.prod.outlook.com (2603:10a6:20b:4dc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Fri, 16 Jan
 2026 18:14:18 +0000
Received: from AMS1EPF0000003F.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d5:cafe::31) by AS4P191CA0003.outlook.office365.com
 (2603:10a6:20b:5d5::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.9 via Frontend Transport; Fri,
 16 Jan 2026 18:14:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000003F.mail.protection.outlook.com (10.167.16.36) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.4
 via Frontend Transport; Fri, 16 Jan 2026 18:14:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V2db1x4Gfy+n0gDeIP+AHVDoHi+Y/VqGABZ8SSPG0t8l6g1tVlpD/4vxl+zsB59767Bs0ePopbTy+eWOzyGl4aEim1CyNWd4R14Fm5c5uz7F/0+4yPpH/jPJc2HhAR7jXqFxRTrK3jzHVdAKdTLjHTlVSGSSv6PECTzX6PhcFp+s2Mu5mfHrRZHCFmp/Hxge1c6Wpj0xEsbDU0l806BgHYgF/lZivHen/rkFYaPotcBcVo8x1BuAIuf8sXpYdIY734ARbKLP2JW6/uIGidbKLD+j7wOkc0R+Po4mrZY0htjFLbPb/kYZFl8Jq9SVoLl88t/p3pJORVXhJKoLFFZSJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J+TwfqER2YPbaClSJT55hMJfZ/aDQlKhyqIrNzd4hZ0=;
 b=ZWVz4tWo5/aj2jMhKzovMYZ+2kJTID3BbB3nYCA3vwVI6QiIVrK0Tz6KvZHGMrBQCHbUV7QBaaLkVm5gRCp7rA9e7hje1LsY8WMUkzkMudB8/bWr/7x89o9g/zWyx7xYsZ9RBC7bVmhmhxJCmDrxdU/8/7IsxRU7ldrDRMHae+lhHmtlA0rzHxGCNwQCgQU2BYrLaF0BTF8ms6+KsQDGuj+95bq7aaUV/D1jTfgCdKqd15bPzerelq5e01BjixAM6qh8Cc4oIoD9ZEEtP7ei+zZZIar1g7IV706byPu3IJiopka7A13W69IW6Mo0MnBGWl2eL1fcLYZtq4tTDuigEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+TwfqER2YPbaClSJT55hMJfZ/aDQlKhyqIrNzd4hZ0=;
 b=XWKSliRzkDMm5uiBCMAZIlVrUiW0o8AeJoUHZCfXQ1JdbfUJcUNPF7H6pkYi2XMYlBZ7vn7el6t1+py07Tq2iNLBOzUC4T03ydXlPB3TZ+JkkeddHv15T+QVMCfsi2uoq8T+al7IVJ13YxecHQn8aUAwtMfcZUJCYBd8SAbdz4U=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DB9PR08MB7652.eurprd08.prod.outlook.com (2603:10a6:10:30f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 18:13:16 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:13:15 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: Andre Przywara <Andre.Przywara@arm.com>, "will@kernel.org"
	<will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Alexandru Elisei <Alexandru.Elisei@arm.com>, nd <nd@arm.com>
Subject: Re: [PATCH kvmtool v4 4/7] arm64: Add counter offset control
Thread-Topic: [PATCH kvmtool v4 4/7] arm64: Add counter offset control
Thread-Index: AQHcg6rl1nUnvfmGq0uTkb0Ve6Hj/7VVIDqA
Date: Fri, 16 Jan 2026 18:13:15 +0000
Message-ID: <0279705e86429bd6889fe23cbbe1a2aeff77ade3.camel@arm.com>
References: <20250924134511.4109935-1-andre.przywara@arm.com>
	 <20250924134511.4109935-5-andre.przywara@arm.com>
In-Reply-To: <20250924134511.4109935-5-andre.przywara@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|DB9PR08MB7652:EE_|AMS1EPF0000003F:EE_|AS1PR08MB7499:EE_
X-MS-Office365-Filtering-Correlation-Id: a2bc4135-3791-4619-bc45-08de552b1084
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?Nk9Vak9MSE82d0t4dTE1Y2NEZzJRMmZ4TUlZWHl0OXJIbG1ndW4zUEtOa3B1?=
 =?utf-8?B?QytCVVZoK2JuOFdJOU82aitRa01neFpKVEQwR0E1aUVhZ2VVMGtCeDB4TVRD?=
 =?utf-8?B?ajBsaTdnWndPcjZROGM1ODN2U3hDVFJpdGZqczNZM3A0eUYvTTlQcHZ1ejA1?=
 =?utf-8?B?eklmL1BTNWpEZjZJdkNsZDZ4NmtJM2lHNW43RTVjUGptWjIyUElzV1cxZGs4?=
 =?utf-8?B?OFp4RU04ODZ2cXZrS0dvdjFVOWFjclhFdmNhT2w5YUg1Wjd1VGNyUCt1bitO?=
 =?utf-8?B?QU01dkhrdC9SZVQ0eXVPZlB4bEhNRFZkV2JMeU4zUmw5VXhsbVVVVmVtTy82?=
 =?utf-8?B?MTI3ZFlBNzdUNDNFeTBvS2dFUDRQbFV5MTRzM1pmRlZHbHV6REVybU5qam8r?=
 =?utf-8?B?SUt4TjgvcGZNWU5aNDJ4T0U5eTFVQXdYWWxzL2d1UmFKeUpyUTZKblR6U1lw?=
 =?utf-8?B?ZGo5SGJGVFVScmFwb0xhRjRydm9CZjI4aXhTdVNYUzdac1grMklNdEJvbmdr?=
 =?utf-8?B?TjF6YmFaV05PMVVNRDd2SWpqWjVsTER0K0o3Z3Mxb3VKNm5wMkJPYW5jVFR2?=
 =?utf-8?B?RjNaRitOZGJLSHJnd2hnS1lKcUFNNlRhQlVqT25TdG5HYys3YUZJaVJyRWc2?=
 =?utf-8?B?emRlaUZ1OEFkUG82ajlNdjJndnVReVkwZktKS2dJZWd0VVgrNlpvbXE1TC9Z?=
 =?utf-8?B?WkgybXFGa00rUWdUSlZrMFNWRE8yb3d5bndmQ2UzWiszTlZ5RHgvcWZMT1NF?=
 =?utf-8?B?WEExNTNVWXJsc3dFdzhBdCs1NjBtM0FpdFU1OGROZENyaHpEYjJOblYzTk1D?=
 =?utf-8?B?N0UzZFUyLzZDKzRIaWoxeGpJdUFSSE9rZldqblFFZlhpZE5Qay9KRGM5OEYz?=
 =?utf-8?B?NmZuUGtOYUJxK3M0V1VIc3Fxd2FjUCs2alpHaWxGUXZ2UFhKR3JMZHhHOXVG?=
 =?utf-8?B?aFB2V294ZTZDWFhqc1RSaW1IdlVGc2h2ZllMeEQ4dUxSMlVMWEZYZ1Ztc01z?=
 =?utf-8?B?R29RLzRtdTI5cm5sOWdKbUk5MUxsOThnK2gvWUk4U1pDNlRCaGdoNG5qWmhS?=
 =?utf-8?B?OVg3bG1kV2FYWGc5OTZ1Z3ppYUFCVVZLelQyVzdWZ1ZjcWZTblRROW5oNzhU?=
 =?utf-8?B?UFRtbFRSR3hPWFhQRGN1WFkwMVRDRXF4MElMZCtwOW43dHZRcE1wNDZGdFhB?=
 =?utf-8?B?TUIvWjRrWXVNTVdNV0psMFFKd0JxYlA3VGZuaXdMYjBQUUY3ajR6TWhmaTRr?=
 =?utf-8?B?TTVaZmR3bFhzNDJ5TWc2d0ZZNm12eEpzSkF0UW40MnFVa3dFUUNtdkx2SnZr?=
 =?utf-8?B?VlZ1Vm5ybWl1WGFCTXJBMTI5ZlgwQ2FxSVAvTHBvNDhpSjQ2VlZyZVlNaHFY?=
 =?utf-8?B?REFsVm1KODk3MUxjQTB6TDFZT3BJamFDZmpsOHd2TFpYc3F4U1BhNUhkYVZ4?=
 =?utf-8?B?c0FyMWNscWJ0cnNDUUk0R1pmd3lvaTZUdm9qLzQ3bTlTUFl3Njk1b01aWVk1?=
 =?utf-8?B?TVVsSVdZNjIxcUQ5dE1nV1JSL1gvbWpocEpOZ0NnRGhWNzljTEV1THpKdlRo?=
 =?utf-8?B?ZkZuR0ZNTTdiNW5wOXBBdWlRK0hJMk16d2RDcWZRU0ZmQUp3MmNDY3NPSGlr?=
 =?utf-8?B?OWhUUEJ4aklKaGJUQmc3MlNxbldZYTU4aUdmVTYxYnZhN0lPQ2YzWUxqWU5H?=
 =?utf-8?B?R0orSEIwS3Y0a1EyamY1YXFOZCs3dmxyRWZldW5uRXAxUnYyakdlUXlMMjBO?=
 =?utf-8?B?MCtCeXV4SVRWU1NyNG1KMVRjbFZCUmIzQjUxdXAySVBTeis2ZlZZTHlOcWdC?=
 =?utf-8?B?cFp1Zk1mL201YkdoS3NkSFRnL0lHUm5jdG80dkpJaTQ3MFFNb2xuVGtEN2I3?=
 =?utf-8?B?RDB4NWgxdWF6WHFHekl0ZW9scHpEY2JoMlRnRVZEVGhGVlpXODI5YWRDemow?=
 =?utf-8?B?WWZsTDhVQmUwREVUY2hldUxOUDJHVTNkZXNEbXh4MVBuY3YwNDVFd2JySUVo?=
 =?utf-8?B?dHQwZTh5T2NJcW1EK2h4MjNvMW42MWh0WnFaT053bDgvQy9QRmNHc0M1T293?=
 =?utf-8?B?SW16K3lDQnU5cGdCUUR1a2JoclZPbldzUXpVdDZpL09MVDRDV2I2ZGpoeENN?=
 =?utf-8?B?WWhRQ0t3VW1keldLaFFmSWFxSHBYRFFORDV4UzRRUmlyLzgvOGI4QUN2REN2?=
 =?utf-8?Q?qXcOLBsCrF4tWCnG4YoTNXE=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <4EF74241F9E5AE44800BA09739E5FF64@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7652
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000003F.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3443ceb8-f299-4709-5a02-08de552aeb67
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|376014|35042699022|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SExaMHNnM2MwQW94clRHUm9OWHExV2dMS3RYSXRGWEFmQ1lXejVOVmU2VkR6?=
 =?utf-8?B?OTQ3aXUydVFFMVFkNFN2cDgzQmJ4T3pHYTZhMks1UWdWRk9ZV0pVRWhPR3VQ?=
 =?utf-8?B?bFRpNytiY0ZmVE5jL2lOOXIvSTB5Nm1ncVRXKzFxS3p3dG5hdVo0NXZSK0dP?=
 =?utf-8?B?UzlBU2o4NEs5d3BJSkdUK0xkRnREUlZzWnFnV21oeWRnb3J0RmZTaCs0VERK?=
 =?utf-8?B?VFZBSmQxcUsrb0NFaXZSVldIQXFINThHaXVnVlhqcERJbXVPZUJwSVJtZTA4?=
 =?utf-8?B?cHo0RzRaL1NsdmxLaXRMN0FLcldXOUZ4WWtudFJlV25YZm1uTExRcXlYeEgw?=
 =?utf-8?B?b0ROMUlYaTgzRHFRUjc4VHEwUVZTbG9BRFZsWm9sZDNGMDdvWlFpNW1EeFlO?=
 =?utf-8?B?OHVJaUxsY3pucEoxdC9UQy82bGR1RngxVUUrTDN1SEZkQzc3blpiZ0FOOWxl?=
 =?utf-8?B?UzE1YVovd3JtSG1XcEZmRVhCS2c2aHBxeEtlTFcvUHh0T1FaUXhYaExMdm5I?=
 =?utf-8?B?QlozTzdzTVBiUjhOWm41U0Y3RGFqWU1WZXpnY3ErdnFYanVFSE9oY2lsYzJK?=
 =?utf-8?B?Um9uUEpKWTJkSWYvQlk4UEFwSTVnK29TN2FHU1ltakY2OFF6L2svSmZxVDNU?=
 =?utf-8?B?amtCbTlNQ28vU1FBM3NobUNFYzhaRG5nd2dhcndFSzI2eUhZNGtFc01uM2t4?=
 =?utf-8?B?azk3TExFVm1adWNoeWhQcEJxZnA4S2NjMVR0TVRILzFFazN5Nmt4b1cyL2U4?=
 =?utf-8?B?dGdkNjdmTVlMVzBMNDE3T0FQUzBKRFVaYmoxbDNNNmVWRko5Qys4VlJrYnJL?=
 =?utf-8?B?Ti9UcVBnSFVHYUVhckJtL3VZYWpJMmVGdDcwRUZPTGJaUDAxdEttbmFSY1Y3?=
 =?utf-8?B?ak9CTDNaMmwwcmV1aUFtSmtPWVJ0b0FKUm9yaVdNc0NDNjlVWGFMdHNlNTZN?=
 =?utf-8?B?ODd3RUVKcmRVdSttSHZuTEFFTGJEdUl1OFU4cDV6MlNaMW5ZM0pEdXVGSEs1?=
 =?utf-8?B?M0NSamoyayt3UVJnM0tUdXJXd00xTUFZd1YvRFpROFA5QVI0U2VWT0tKUW5u?=
 =?utf-8?B?ckJVRlB1TVdmK1pTRWt3Z2JjWkJ0b25kY09UZXpTMGlSSlNXSWdoeDcvM2c3?=
 =?utf-8?B?eHhQQ0xtNkhhMVN5UFdLT1RONkNIZGt3dE5SWFlHeTZKTUY2SlJ0ck1MUGJ5?=
 =?utf-8?B?Rm01TUhpZE1QMXduVVFCZDg5bnYzVmlzd2JxZEI2VEtGRkhRKzV2dlFKb0Rq?=
 =?utf-8?B?TzVFTUFaRVFwSlMrcEc3bUFFUi9FeWZ3OFhvM2o3OWRzYjlTcmNYdExEVy9X?=
 =?utf-8?B?cUNWRS9OVmtKSld1UWFYM0FRSk1wWUE3SVNseFFXT00xNS9ML3Rhcmw1TTEx?=
 =?utf-8?B?QUJKMEpFa1lBKzk2dXVKL2lpUWdERnYvWjVuM1AwWDdianpKUmZ1QlBiK2Ro?=
 =?utf-8?B?aVB5ZUlOQ2FxK1Q4b0luajNlQnJPOEZabFVHRFZPbGVCNFdTbk1aUTQrSUVW?=
 =?utf-8?B?SStRUTZYelI1VEhRRzdLa1RTRmYrY0tVR0I3S0VFSUhlWVpQRDQxN1NvQ1ZB?=
 =?utf-8?B?RXJ4ekM5dDdtS3ovam5oUEE2V2NzcEszWlIvRy9sd21vWTh5cmpkSmR0NjU5?=
 =?utf-8?B?WjBrN2Q4eVhZS3NFSEJCcHpzRXJiaXlKUXdyVkEySmdwTEl5bytXbWhTZkJq?=
 =?utf-8?B?UTIrRGJWaytRY1NZUWNWTlk1UitESHMzeVBDVG5idzI0WC9KbFdMWVFQZS9V?=
 =?utf-8?B?eS9HZDdQaGNTSEZLYU1nTG83MFYzejU2Znh6MW1zckRHcitFcEE1Y3BYZ3RY?=
 =?utf-8?B?cEdsK2pVWG9ITXZKbUkvUGJWRUZnb3JUL05kd3o5bVZMdzNFWGQrQVlPcnc4?=
 =?utf-8?B?WkxRTzFpaEtBUmZKaEREaVUrU0NkK1NUNi9PMXZVclUwK1ZCVnJmcnBQT2hu?=
 =?utf-8?B?c0Y0TXl3YUQwRkVxMkQ1cGpzVUVRR0dsSkFhVmdEMkJOME12dDdyNWtseVBC?=
 =?utf-8?B?Y0NvSjhvZUt6R1Zucmk4S2w2ai9TUzNPU0pLUm9DQ2MrWXA3UGg2UHk1SDlx?=
 =?utf-8?B?N3k2dmRiNDhIMmc0K1BFcFFwOEZzeTdpVDhhaWdkY01EVElNYnJ6ZUs4V1l4?=
 =?utf-8?B?VXppY0QxdWlaV2pxSHg2M1o1Vk9aQXNSZXNmZmZjZFBQZ09adkh2dWpTYlZq?=
 =?utf-8?Q?FThndBde5xj1t0xIgJr3bRt2vxNZdUo6xAJViiXFeDmi?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(376014)(35042699022)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:14:18.1369
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2bc4135-3791-4619-bc45-08de552b1084
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000003F.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7499

T24gV2VkLCAyMDI1LTA5LTI0IGF0IDE0OjQ1ICswMTAwLCBBbmRyZSBQcnp5d2FyYSB3cm90ZToN
Cj4gRnJvbTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4NCj4gDQo+IEtWTSBhbGxvd3Mg
dGhlIG9mZnNldHRpbmcgb2YgdGhlIGdsb2JhbCBjb3VudGVyIGluIG9yZGVyIHRvIGhlbHAgd2l0
aA0KPiBtaWdyYXRpb24gb2YgYSBWTS4gVGhpcyBvZmZzZXQgYXBwbGllcyBjdW11bGF0aXZlbHkg
d2l0aCB0aGUgb2Zmc2V0cw0KPiBwcm92aWRlZCBieSB0aGUgYXJjaGl0ZWN0dXJlLg0KPiANCj4g
QWx0aG91Z2gga3ZtdG9vbCBkb2Vzbid0IHByb3ZpZGUgYSB3YXkgdG8gbWlncmF0ZSBhIFZNLCBj
b250cm9sbGluZw0KPiB0aGlzIG9mZnNldCBpcyB1c2VmdWwgdG8gdGVzdCB0aGUgdGltZXIgc3Vi
c3lzdGVtLg0KPiANCj4gQWRkIHRoZSBjb21tYW5kIGxpbmUgb3B0aW9uIC0tY291bnRlci1vZmZz
ZXQgdG8gYWxsb3cgc2V0dGluZyB0aGlzDQo+IHZhbHVlDQo+IHdoZW4gY3JlYXRpbmcgYSBWTS4N
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+DQo+IFNp
Z25lZC1vZmYtYnk6IEFuZHJlIFByenl3YXJhIDxhbmRyZS5wcnp5d2FyYUBhcm0uY29tPg0KDQpS
ZXZpZXdlZC1ieTogU2FzY2hhIEJpc2Nob2ZmIDxzYXNjaGEuYmlzY2hvZmZAYXJtLmNvbT4NCg0K
VGhhbmtzLA0KU2FzY2hhDQoNCj4gLS0tDQo+IMKgYXJtNjQvaW5jbHVkZS9rdm0va3ZtLWNvbmZp
Zy1hcmNoLmggfMKgIDMgKysrDQo+IMKgYXJtNjQva3ZtLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfCAxNyArKysrKysrKysrKysrKysrKw0KPiDCoDIg
ZmlsZXMgY2hhbmdlZCwgMjAgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FybTY0
L2luY2x1ZGUva3ZtL2t2bS1jb25maWctYXJjaC5oDQo+IGIvYXJtNjQvaW5jbHVkZS9rdm0va3Zt
LWNvbmZpZy1hcmNoLmgNCj4gaW5kZXggYTFkYWMyOGU2Li40NGM0MzM2N2IgMTAwNjQ0DQo+IC0t
LSBhL2FybTY0L2luY2x1ZGUva3ZtL2t2bS1jb25maWctYXJjaC5oDQo+ICsrKyBiL2FybTY0L2lu
Y2x1ZGUva3ZtL2t2bS1jb25maWctYXJjaC5oDQo+IEBAIC0xNCw2ICsxNCw3IEBAIHN0cnVjdCBr
dm1fY29uZmlnX2FyY2ggew0KPiDCoAl1NjQJCWthc2xyX3NlZWQ7DQo+IMKgCWVudW0gaXJxY2hp
cF90eXBlIGlycWNoaXA7DQo+IMKgCXU2NAkJZndfYWRkcjsNCj4gKwl1NjQJCWNvdW50ZXJfb2Zm
c2V0Ow0KPiDCoAl1bnNpZ25lZCBpbnQJc3ZlX21heF92cTsNCj4gwqAJYm9vbAkJbm9fcHZ0aW1l
Ow0KPiDCoH07DQo+IEBAIC01OSw2ICs2MCw4IEBAIGludCBzdmVfdmxfcGFyc2VyKGNvbnN0IHN0
cnVjdCBvcHRpb24gKm9wdCwgY29uc3QNCj4gY2hhciAqYXJnLCBpbnQgdW5zZXQpOw0KPiDCoAkJ
wqDCoMKgwqAgaXJxY2hpcF9wYXJzZXIsDQo+IE5VTEwpLAkJCQkJXA0KPiDCoAlPUFRfVTY0KCdc
MCcsICJmaXJtd2FyZS1hZGRyZXNzIiwgJihjZmcpLQ0KPiA+ZndfYWRkciwJCQlcDQo+IMKgCQki
QWRkcmVzcyB3aGVyZSBmaXJtd2FyZSBzaG91bGQgYmUNCj4gbG9hZGVkIiksCQkJXA0KPiArCU9Q
VF9VNjQoJ1wwJywgImNvdW50ZXItb2Zmc2V0IiwgJihjZmcpLQ0KPiA+Y291bnRlcl9vZmZzZXQs
CQkJXA0KPiArCQkiU3BlY2lmeSB0aGUgY291bnRlciBvZmZzZXQsIGRlZmF1bHRpbmcgdG8NCj4g
MCIpLAkJCVwNCj4gwqAJT1BUX0JPT0xFQU4oJ1wwJywgIm5lc3RlZCIsICYoY2ZnKS0NCj4gPm5l
c3RlZF92aXJ0LAkJCVwNCj4gwqAJCcKgwqDCoCAiU3RhcnQgVkNQVXMgaW4gRUwyIChmb3IgbmVz
dGVkIHZpcnQpIiksDQo+IMKgDQo+IGRpZmYgLS1naXQgYS9hcm02NC9rdm0uYyBiL2FybTY0L2t2
bS5jDQo+IGluZGV4IDIzYjRkYWIxZi4uNmU5NzFkZDc4IDEwMDY0NA0KPiAtLS0gYS9hcm02NC9r
dm0uYw0KPiArKysgYi9hcm02NC9rdm0uYw0KPiBAQCAtMTE5LDYgKzExOSwyMiBAQCBzdGF0aWMg
dm9pZCBrdm1fX2FyY2hfZW5hYmxlX210ZShzdHJ1Y3Qga3ZtDQo+ICprdm0pDQo+IMKgCXByX2Rl
YnVnKCJNVEUgY2FwYWJpbGl0eSBlbmFibGVkIik7DQo+IMKgfQ0KPiDCoA0KPiArc3RhdGljIHZv
aWQga3ZtX19hcmNoX3NldF9jb3VudGVyX29mZnNldChzdHJ1Y3Qga3ZtICprdm0pDQo+ICt7DQo+
ICsJc3RydWN0IGt2bV9hcm1fY291bnRlcl9vZmZzZXQgb2Zmc2V0ID0gew0KPiArCQkuY291bnRl
cl9vZmZzZXQgPSBrdm0tPmNmZy5hcmNoLmNvdW50ZXJfb2Zmc2V0LA0KPiArCX07DQo+ICsNCj4g
KwlpZiAoIWt2bS0+Y2ZnLmFyY2guY291bnRlcl9vZmZzZXQpDQo+ICsJCXJldHVybjsNCj4gKw0K
PiArCWlmICgha3ZtX19zdXBwb3J0c19leHRlbnNpb24oa3ZtLCBLVk1fQ0FQX0NPVU5URVJfT0ZG
U0VUKSkNCj4gKwkJZGllKCJObyBzdXBwb3J0IGZvciBnbG9iYWwgY291bnRlciBvZmZzZXQiKTsN
Cj4gKw0KPiArCWlmIChpb2N0bChrdm0tPnZtX2ZkLCBLVk1fQVJNX1NFVF9DT1VOVEVSX09GRlNF
VCwgJm9mZnNldCkpDQo+ICsJCWRpZV9wZXJyb3IoIktWTV9BUk1fU0VUX0NPVU5URVJfT0ZGU0VU
Iik7DQo+ICt9DQo+ICsNCj4gwqB2b2lkIGt2bV9fYXJjaF9pbml0KHN0cnVjdCBrdm0gKmt2bSkN
Cj4gwqB7DQo+IMKgCS8qIENyZWF0ZSB0aGUgdmlydHVhbCBHSUMuICovDQo+IEBAIC0xMjYsNiAr
MTQyLDcgQEAgdm9pZCBrdm1fX2FyY2hfaW5pdChzdHJ1Y3Qga3ZtICprdm0pDQo+IMKgCQlkaWUo
IkZhaWxlZCB0byBjcmVhdGUgdmlydHVhbCBHSUMiKTsNCj4gwqANCj4gwqAJa3ZtX19hcmNoX2Vu
YWJsZV9tdGUoa3ZtKTsNCj4gKwlrdm1fX2FyY2hfc2V0X2NvdW50ZXJfb2Zmc2V0KGt2bSk7DQo+
IMKgfQ0KPiDCoA0KPiDCoHN0YXRpYyB1NjQga3ZtX19hcmNoX2dldF9wYXlsb2FkX3JlZ2lvbl9z
aXplKHN0cnVjdCBrdm0gKmt2bSkNCg0K

