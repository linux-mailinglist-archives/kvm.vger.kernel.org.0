Return-Path: <kvm+bounces-66225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 60CD1CCAD76
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 09:21:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7E269301A736
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 08:18:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F4FD33373E;
	Thu, 18 Dec 2025 08:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="W27kE8Ih";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="W27kE8Ih"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013014.outbound.protection.outlook.com [40.107.159.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E73E2F25EF
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 08:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.14
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766045919; cv=fail; b=AmNYIo/ozUUzAe1iGX/SyHRNreFffoAwR5rNXTRDxAY/DJWYOU+dt+RtHvWH730LonVMNcDcgHd+vvENcp9I31HXI4cx181geeLF3CPKvoc2vqoicRDHir8jIYimLAJle027Nou1vA2ATr1h72Zr9Pb8yMSs8qhj0jCBMlhYSG4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766045919; c=relaxed/simple;
	bh=F+qI2qdjzyghLu3WNMfKyp2SyIY+RvsTBAL91zjHl90=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pFrVaX+MEA10wKkNG487vLmlAeUSIIWP6IrEUz6LmpLZgDXk6VRjIMc9iw9v7bKNRYBAV7q5mvJexNA83mOqBPyMKieFFBf3EjcsRLxB/pM859uiIDk/SYCgks5SKOQx5bEhnfixfCQGR1SXcFB+QIkxmZxi9zntHQsXS1+T1V0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=W27kE8Ih; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=W27kE8Ih; arc=fail smtp.client-ip=40.107.159.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=PLwJ2p3XgzZr2/lc2vK4dyqmJQJABROUs8RDJ6pYPXngf8Ch5WXxWw9gTD8YkKeuZ2pIybnSeqMpuJVbdAT/m/gT6PzGrSLwJe4csVRse8w3XiJEEg/9r4b40/wFLDFcfOfKNljzBcfVWaIeVoIyUlMrrs4rs2N/5x4pYgFYyUcj+IQgJnecXB0lTJKK/PXAwO+3GG8F4GsNJEDavBiqSV/uXhA6frFZJP+Mo+lfWlc7WWxCSHtX+QEDKeG9j3w6z5LvQ3YbqEdMjyZrhOwHYtaOOZiNX0L7e45Cwjcv61rmHw9mGo4s2/hudP26TzUFiB1/i3aBfmpCJPxGhpYFcw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+qI2qdjzyghLu3WNMfKyp2SyIY+RvsTBAL91zjHl90=;
 b=iO4dDqfaJIaqkmZzK/pepsrBRdy8HN0oYQua/0/lHZlT9IfIsQokxdSen3krpW6KA2mSD9J8M4ez4RxGgp3U8RVZxCzsiCLqoMqoJ/pIBN2DmlpRIdhHKh3jeG1SLR+VOfVaFA836L7wkGj4bJolgtk3Vt99c2ZMvwXBE+QaoTWYDki0yxwFGGabQb9te85G4Z+rlc0ZwxJU2DKUh4CuuDs8POCp3UNIzEAe9xjr86b3jqHX4wDAjJeBsc2AaQHAOjGEQAxaI85dpITY2RTwidim/ZKbLelX3xNKDvYQ1B1yHy0R+drZL4Vrl8nnfCu/Oj+UaPttySKbtdAvLtRXjQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+qI2qdjzyghLu3WNMfKyp2SyIY+RvsTBAL91zjHl90=;
 b=W27kE8IhxpMLuzD2dF8IkQsmLnfBlk407bM0Hlg5kkTVUPcymx8DRC3s+HZOvzOJAN90WTewgBCEkeGgT5GAxzT+MTzuGaLrT+OFth0Q0Mx4oSl8OOyGC2AbNxo4ZiLFTJ7G+Z8W1MczVonnySH6PKxzOwqSReMD4P42Z47lBRA=
Received: from DB8PR06CA0059.eurprd06.prod.outlook.com (2603:10a6:10:120::33)
 by GVXPR08MB11212.eurprd08.prod.outlook.com (2603:10a6:150:1f6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Thu, 18 Dec
 2025 08:18:27 +0000
Received: from DU2PEPF00028D12.eurprd03.prod.outlook.com
 (2603:10a6:10:120:cafe::da) by DB8PR06CA0059.outlook.office365.com
 (2603:10a6:10:120::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via Frontend Transport; Thu,
 18 Dec 2025 08:18:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D12.mail.protection.outlook.com (10.167.242.26) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Thu, 18 Dec 2025 08:18:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uTyavnlmSYCRs5zVaTGuz+HAQUtvn43GekrRZMMXIIValsWe6GVzEGg3xoWP1tFJdm+f8d7MAoWhgL9pnClMlCqSCzA3KgHObiy+ds79cGcqbXw2j8LDrI2trRcuL8vebJiaeqcijnhhGcQ/ryF6Eeq5jtekcWXOLNLg7m2UUi2srstbv+npKDzQjUTrYsmR/BWvua16XkVOtwK/PFDAk6WV6QEEwovEJa7VdVDseOdS3BmwIea4L8fDAlQEbxN2uYaDFrKpPrpiRWvVkpnAO3++Y3l8vIgY28vL/MH4QWlU3AtCWlbCyqMtOVxRFGYVscVqytEiU9U+70lTP+3HqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+qI2qdjzyghLu3WNMfKyp2SyIY+RvsTBAL91zjHl90=;
 b=E8JZ9Fq8TBifnZmim7LBm+p899i5p7Hy3XCpI5EryuzAWY3KdeU9aJYVh9t1fLIb3LvSKz1N5MJCdi7uH2JDMyS3XtptSitCcmJWoJGVl5EvAcMvBgqw9gA5pUDI9Xg3eXcNpXv0h+g+ttn7jRBLIQyvRjBt9Jgmm4+1ivC2wl4OOumPJtwzlaOlB/LfLczVU9ymL+lOvAuJlFIePVspyxmxYAJh38OhDyqtkXudj5hhX57VnD5l90tXejRhh0vLPEmHI3thqkPBnKmwfdPHkbwJwIu6O512rRwa7NE1vMeigZBbg644GAS5Nw/WS5sMyKYVBt/Uy3hkc6Lnyq/2Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+qI2qdjzyghLu3WNMfKyp2SyIY+RvsTBAL91zjHl90=;
 b=W27kE8IhxpMLuzD2dF8IkQsmLnfBlk407bM0Hlg5kkTVUPcymx8DRC3s+HZOvzOJAN90WTewgBCEkeGgT5GAxzT+MTzuGaLrT+OFth0Q0Mx4oSl8OOyGC2AbNxo4ZiLFTJ7G+Z8W1MczVonnySH6PKxzOwqSReMD4P42Z47lBRA=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by DU0PR08MB8301.eurprd08.prod.outlook.com (2603:10a6:10:40f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Thu, 18 Dec
 2025 08:17:20 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 08:17:19 +0000
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
Subject: Re: [PATCH 18/32] KVM: arm64: gic-v5: Check for pending PPIs
Thread-Topic: [PATCH 18/32] KVM: arm64: gic-v5: Check for pending PPIs
Thread-Index: AQHca3soLX+ZjvZJeECiRPwCqFVv3bUlv3QAgAADFoCAAVPxgA==
Date: Thu, 18 Dec 2025 08:17:19 +0000
Message-ID: <20f13c1b0bd1c3954075d29aa099697f0afa6f2f.camel@arm.com>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
	 <20251212152215.675767-19-sascha.bischoff@arm.com>
	 <20251217114932.GA1626516@e124191.cambridge.arm.com>
	 <20251217120035.GA1628893@e124191.cambridge.arm.com>
In-Reply-To: <20251217120035.GA1628893@e124191.cambridge.arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|DU0PR08MB8301:EE_|DU2PEPF00028D12:EE_|GVXPR08MB11212:EE_
X-MS-Office365-Filtering-Correlation-Id: da1e5294-7b66-4864-43f3-08de3e0e0507
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?RUpiTkw4YmhyRzNwQTEyN21aMFovQlZHN3JmOCtHTnJEZFR3Rmt0Sy8vTlhG?=
 =?utf-8?B?eGRZMnJlWkRva0MwOW5UYXZ0Mm5jNExMMG9SalBnTUpFQWx2cjNGOVV1MGV3?=
 =?utf-8?B?VXF2c3pBUmJMc2YrMURqbzBFWit5UUhJMjhJQXFKQ0NnQ0pzOXowV1RPaDFJ?=
 =?utf-8?B?NFVqYlB1aXpuTWtkbTRWVWdqS21jTStETy92VDRNd0ZROENSQWJJNzFDczYr?=
 =?utf-8?B?c1hKUTkzdWMxeFA0YjBFb3RrTEV5NHNtalN6OGY5MDhEZEM3a0VIVzBibS9Y?=
 =?utf-8?B?b2crZndzb1pYSkg4b0tHbzB2SDY2OEJLc0lYNWhXdkVWb2xhMUk2OUM5U1Bs?=
 =?utf-8?B?Ui9xY01MY0tnNjJzYjg4aWRKQ0xXVkttRGFPNnNYV2MzVVhid1VxSDVtS09o?=
 =?utf-8?B?bzExK0EzcnFwVnJrVHBSSXZPSHVKVVFDSFlXejhjeWhCOHloOGZOU3g0NS81?=
 =?utf-8?B?OTNBdkY1bllUWi9yTmhQUkFOdkFUZm1xM1F6NHJSRy91RHZhYVYrWitmVXdM?=
 =?utf-8?B?WEF5Q09YVlo5NGJTNzRZTFRtSnJ0VW0wWUZRWDBkNFExUHZ5MDNqdUZRRC9U?=
 =?utf-8?B?UUZvVG5WM1R0VU5TTEg2L0VHWE90bFBrVTBqbUZlenE0UXh3aUdlZys4bEZT?=
 =?utf-8?B?TnNIY0VmWURGSmxEWnB4YnNIWDFLakVVTHUzekZaZUt4ZlVuVTBqN1R3cTk4?=
 =?utf-8?B?YjJKVHlsOU54R2xqOWRqYW5yRndsYkpEWkNKcllNTWQzWjc3amxkMlkyVlBN?=
 =?utf-8?B?M20rbGtLdlduUjlwQ0tOR1pXZUxXMXROODhCSkNPb0JQYjBaRUxxaDNnL3N0?=
 =?utf-8?B?TlhuL0tra3d1RXYyRFR3WWdNT1R6RFNrL3MrU0taK3VJaXlvajFmYW41S0Zo?=
 =?utf-8?B?MlZ0bDdqVUJKZ3VpNE9IYVFYRUlJU3hXQjJTODQ5R1VyS0h1cEorTFhOVFhr?=
 =?utf-8?B?Z2xoeU5wK045bHhjNllNMHIzMUs0NW50bHh1OHF0Y1VtVFNtOFNYdHR0RFhx?=
 =?utf-8?B?SVZ5ZmdkQXBDMWJjb1VVTVpLVTZOdzEzY1NsRlhXaGNXYlVtUGp2M1NBYVhD?=
 =?utf-8?B?UUhsenYyZUJFSTRSYllISU01d2VCWmltZlRwdHphd3hXb21TMlBEMlVwUlhr?=
 =?utf-8?B?UlRXQVczZzJrYXRON0E5bGlTMTFCZXFMbENLNkVRdGZhU2VobDdrby9XSVR1?=
 =?utf-8?B?VlpwbHRPamxOaVJDMWZ6TFpxaTM5Q1pPT0hWOHpxcWZOanNHVlRBK3NzSE1D?=
 =?utf-8?B?ZW90akJ3RmpTdHFzMit1b0pScXNVc3VkM1U3QTN4Q0RYK1BPV2hXMG9rNTVh?=
 =?utf-8?B?Z3dGOXd6RHBkallMQkErZ1Y5RDFKZGlXV1BUYTdRMTUwc0wza1JCbXA3UlRo?=
 =?utf-8?B?MDR5UFd0ZWJsWk5UVklMVWM5MVNxRjdST3lNYkczRnl5MVVSTmI3UkJxdkFq?=
 =?utf-8?B?OE4wTEd5RHpKTDM0bWhtSnpTZlNqSDZyNDZiNjRMa2NYL2ZvMjlGbTBBN3Rs?=
 =?utf-8?B?b3J0U2wraE5VZ0xvazY1Z1k5cHowTGUwVkpHelU2WGZCYlBGQ3NOb2JLb3NX?=
 =?utf-8?B?ZDBSbjVBU2JoVk5MaUx2ZllCdS84dFhLQ1AvUlJOQVlnQ3g2WTM1eGFNcktz?=
 =?utf-8?B?RmNqY3AySitwVy84NklzRjVvcExqczdLZk1qOGpMbHl0dktwQU5uUFdjd0Zu?=
 =?utf-8?B?eUJPc1hjVDdIUmlJTUhTUlhnTXQxODNyMmh1d3REZWJNTVNJRnBxaEtoN1RS?=
 =?utf-8?B?SnlBOW1NSk01NzRRM29VbVpGVkltTW5VNHJhQ2tQWEErcm5QbWJvR2xjdEVR?=
 =?utf-8?B?VmFoS0M2YlRHYW5QRTRVVlY5aXNlemdmL0JEcGlPUk42WTdhMERaaXA3dmkr?=
 =?utf-8?B?V1d5NEV2S1JsMk5pUGdDeCtTREJEczV4NGk3MHp3Q1FiM2tCWjBVcTVmYUFt?=
 =?utf-8?B?MUVZRHZQTlBFcHlBeXVJRTh1aG9FNHh1VXpkQzVjTm8vZ2NZTlRRU2FRTzAz?=
 =?utf-8?B?LzlFWndhSmFwMFZraWttMzROb0kyUlpaMEVBMjlvT2lwL3ZGZ2NPbFY4S202?=
 =?utf-8?Q?1Y4k8w?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <32E20008423E4C4B861F07F780F7C90D@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8301
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D12.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	46951988-9ab6-4c5e-cf83-08de3e0ddcdd
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|35042699022|14060799003|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S00xZFd0SlFuMlhsNndMRStoTDdKeEp5V200bXJpL0lzcUorZXhpSjBzYVI4?=
 =?utf-8?B?VXZ3aU8xNEJXR3hGK1hUTUdMdTVNMlNlRHZtYngwR2VaR2UxNHg2ei8veTdz?=
 =?utf-8?B?bHhwcTUwZm1yWmo3R2sxZDZxb0RKU0IvNGQvajU0R1F3aUZmdXVwNGNxUFNP?=
 =?utf-8?B?R3RmZkQzS05XRitQOUxyWjZKL0IrVXJWdkp5MnFIL0pVWXlZS2kzYzBLQ2g4?=
 =?utf-8?B?ZHFvSXZDVEFFRERZQkd6bnRENVZUaDhoOVY0TUYwTkVabEZNY1ZjbkJXZlIx?=
 =?utf-8?B?Qy9uK3VLK0xSbDFTZFJMVnpXQjVLczdtQy9aUVY1WXZOVDdiVXVjTHFqd2sz?=
 =?utf-8?B?ZGo2elEwdzAxa2VXL3FiQ01FdWlkR052N01SWGhZa1BkNU9iQnZhWDZvbVAw?=
 =?utf-8?B?ZUMrc1M2MmVLVWJ1bkVJaFlXZ29QaVc3dzBwQldTTk1RMTdxZDBQaGE5dVpG?=
 =?utf-8?B?TDZqamV4Ry9XSW01aHNZUXJnWEdueStRZm9zYXdsdHNyRUpCU3o3V2ZnM1Zy?=
 =?utf-8?B?RU9uNzR5TnlEQU1Icy9zNE8rS3ZORTlGbnorcUNDS3pUSnNDVDRHWWtDZ0RS?=
 =?utf-8?B?RHVka2hqNnRqd3UwckRGU3VBS2ozOHZvSEo0eFJ5aHVXZi9wT0hLSUJIYXBM?=
 =?utf-8?B?allJcld4c0ZNWU80TDB4MW9mR3REdTAvcWJxcWhOSm9mc1pzd2FVbDFlUlI1?=
 =?utf-8?B?d01ORldwQ29HZUFVL3p2dEZvYXBUMmZ5ZCtyV0E5dmp6YVNWZFY0djd3dW5Q?=
 =?utf-8?B?UGtNeHhYYWxKT3VRVXZiMUVjU21QSU1VaDQ4T21qZzN1emVGcy9WTGsrQ3c2?=
 =?utf-8?B?ZHFETi83OGdjY3hkYWE1WitLanFTdHJRMEovcXkrcTdjbGlsYUNpN3FrSHl6?=
 =?utf-8?B?eXZBSlJVbmhJMlJXZTJJd2ZiUDA3bXZLTWsydE0yeU9JdXdOdUxNRzY1bXpQ?=
 =?utf-8?B?cGN5aVVMS056NXp4SkxoZHpld2JkcG9zbVZSUlVwbGNSbkErWVF5Y0lnelRh?=
 =?utf-8?B?RFdLOEkzcXF1VEQxTW9rSDhtOWtpeWExN3lQQlErZE15anRRb1lPOUlQeUNi?=
 =?utf-8?B?b09wUHZsT0JnbDhCT2UxYkwzMktFa0xGTE9UOVg1cDRvK091VzQ5Q3VvT3h4?=
 =?utf-8?B?YU8rWlcyclVzNUsxdlRnS0YvMG1Zem9Ca3hPY1Arcmxrc1VuRnZhczM0YjlS?=
 =?utf-8?B?MUtuam0vNTFvTEw5VURmRFpRUVI1aFY0MGtjYkhPaU9mMHVKUjdhbnJMN0l0?=
 =?utf-8?B?bXlTRWZzRnZaZlA4dU5LdUdDdyt6aTdRMkc3MTcxMnBwdFRMNzRhTlljSXNE?=
 =?utf-8?B?V1k2ZU91NUdDUko2Z3oxQTJWeTNrWUM1NkV3Y00vT0VvU2N6NWxBdFMvWnQ3?=
 =?utf-8?B?YjFrZ001K3ZTa1A2Vy9XYWQySTRFWEFEWTlNU2dqakZRamw3WkpLMnVxRFd1?=
 =?utf-8?B?UWJoYmUxWm5KVHVTY2JRRTZZY1A0N096MGZJUnRXMEtPRWVWTDBGSWRjM3Fs?=
 =?utf-8?B?RkZZd1FLdGlzUUFNQmxRZG5wY3pjdVNNQkh1a1FaVG5XUjc5VzlTNWp6b2RT?=
 =?utf-8?B?SXJ1UDZJck9IM3ZwbFpqSHM0N3ZuaXJFaDcrSExVZUk3NSszREI3UyttQVQy?=
 =?utf-8?B?TEJIcHVnaElJS0RQUStCdGdJbkZ5dTkwTnRJb0lWUXpXT2VnY0Qya3VnUlNv?=
 =?utf-8?B?WlYvUTl6QmRROGFHYUl0Q1F1Z2FuLzhqS21QQnFPSzZBTjRZc1hzU2U1a1U2?=
 =?utf-8?B?QkZpdXVHdHN3anhyMzE0QjJGSEFhQlNOSjY5Z2NOeUNQdWtSRGdMc2Y2MFEz?=
 =?utf-8?B?cEViTS9WOFQyQVpRSkJMUTBsZmtqQXhyUXpiR3B5UVE1SjlvWVpodkZvM09s?=
 =?utf-8?B?VUVmclRMNXdyMTFvLzgxSnlQT05FSTUrcWIrcUtGWXBxK21IWjVsSWdlNEo1?=
 =?utf-8?B?SkZraWdsbVFoVEZ6N2dFUTRkcUR0a254TTJsMjFvOVpwbnl6c3VDWFpHeVgx?=
 =?utf-8?B?WW40b25reVp1VVIzbkZaeDZXL0UyWlNseld2TVpXUTJvbnZQa1NlbEJ4aGJH?=
 =?utf-8?B?bGgySHhtU2JnQUVJclNpU3FQTytOdXhqK0dMaGl6WGpDSlJqajJFaWE4UGdF?=
 =?utf-8?Q?jAx0UhZG6nrnhdM5D++uBmLs9?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(35042699022)(14060799003)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 08:18:26.6929
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da1e5294-7b66-4864-43f3-08de3e0e0507
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D12.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11212

T24gV2VkLCAyMDI1LTEyLTE3IGF0IDEyOjAwICswMDAwLCBKb2V5IEdvdWx5IHdyb3RlOg0KPiBP
biBXZWQsIERlYyAxNywgMjAyNSBhdCAxMTo0OTozMkFNICswMDAwLCBKb2V5IEdvdWx5IHdyb3Rl
Og0KPiA+IEhpIFNhc2NoYSwNCj4gPiANCj4gPiBPbiBGcmksIERlYyAxMiwgMjAyNSBhdCAwMzoy
Mjo0MVBNICswMDAwLCBTYXNjaGEgQmlzY2hvZmYgd3JvdGU6DQo+ID4gPiBUaGlzIGNoYW5nZSBh
bGxvd3MgS1ZNIHRvIGNoZWNrIGZvciBwZW5kaW5nIFBQSSBpbnRlcnJ1cHRzLiBUaGlzDQo+ID4g
PiBoYXMNCj4gPiA+IHR3byBtYWluIGNvbXBvbmVudHM6DQo+ID4gPiANCj4gPiA+IEZpcnN0IG9m
IGFsbCwgdGhlIGVmZmVjdGl2ZSBwcmlvcml0eSBtYXNrIGlzIGNhbGN1bGF0ZWQuwqAgVGhpcyBp
cw0KPiA+ID4gYQ0KPiA+ID4gY29tYmluYXRpb24gb2YgdGhlIHByaW9yaXR5IG1hc2sgaW4gdGhl
IFZQRXMgSUNDX1BDUl9FTDEuUFJJT1JJVFkNCj4gPiA+IGFuZA0KPiA+ID4gdGhlIGN1cnJlbnRs
eSBydW5uaW5nIHByaW9yaXR5IGFzIGRldGVybWluZWQgZnJvbSB0aGUgVlBFJ3MNCj4gPiA+IElD
SF9BUFJfRUwxLiBJZiBhbiBpbnRlcnJ1cHQncyBwcmlvaXJpdHkgaXMgZ3JlYXRlciB0aGFuIG9y
IGVxdWFsDQo+ID4gPiB0bw0KPiA+ID4gdGhlIGVmZmVjdGl2ZSBwcmlvcml0eSBtYXNrLCBpdCBj
YW4gYmUgc2lnbmFsbGVkLiBPdGhlcndpc2UsIGl0DQo+ID4gPiBjYW5ub3QuDQo+ID4gPiANCj4g
PiA+IFNlY29uZGx5LCBhbnkgRW5hYmxlZCBhbmQgUGVuZGluZyBQUElzIG11c3QgYmUgY2hlY2tl
ZCBhZ2FpbnN0DQo+ID4gPiB0aGlzDQo+ID4gPiBjb21wb3VuZCBwcmlvcml0eSBtYXNrLiBUaGUg
cmVxaXJlcyB0aGUgUFBJIHByaW9yaXRpZXMgdG8gYnkNCj4gPiA+IHN5bmNlZA0KPiA+ID4gYmFj
ayB0byB0aGUgS1ZNIHNoYWRvdyBzdGF0ZSAtIHRoaXMgaXMgc2tpcHBlZCBpbiBnZW5lcmFsDQo+
ID4gPiBvcGVyYXRpb24gYXMNCj4gPiA+IGl0IGlzbid0IHJlcXVpcmVkIGFuZCBpcyByYXRoZXIg
ZXhwZW5zaXZlLiBJZiBhbnkgRW5hYmxlZCBhbmQNCj4gPiA+IFBlbmRpbmcNCj4gPiA+IFBQSXMg
YXJlIG9mIHN1ZmZpY2llbnQgcHJpb3JpdHkgdG8gYmUgc2lnbmFsbGVkLCB0aGVuIHRoZXJlIGFy
ZQ0KPiA+ID4gcGVuZGluZyBQUElzLiBFbHNlLCB0aGVyZSBhcmUgbm90LsKgIFRoaXMgZW5zdXJl
cyB0aGF0IGEgVlBFIGlzDQo+ID4gPiBub3QNCj4gPiA+IHdva2VuIHdoZW4gaXQgY2Fubm90IGFj
dHVhbGx5IHByb2Nlc3MgdGhlIHBlbmRpbmcgaW50ZXJydXB0cy4NCj4gPiA+IA0KPiA+ID4gU2ln
bmVkLW9mZi1ieTogU2FzY2hhIEJpc2Nob2ZmIDxzYXNjaGEuYmlzY2hvZmZAYXJtLmNvbT4NCj4g
PiA+IC0tLQ0KPiA+ID4gwqBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYyB8IDEyMw0KPiA+
ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ID4gwqBhcmNoL2FybTY0
L2t2bS92Z2ljL3ZnaWMuY8KgwqDCoCB8wqAgMTAgKystDQo+ID4gPiDCoGFyY2gvYXJtNjQva3Zt
L3ZnaWMvdmdpYy5owqDCoMKgIHzCoMKgIDEgKw0KPiA+ID4gwqAzIGZpbGVzIGNoYW5nZWQsIDEz
MSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiA+ID4gDQo+ID4gPiBkaWZmIC0tZ2l0
IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiA+IGIvYXJjaC9hcm02NC9rdm0v
dmdpYy92Z2ljLXY1LmMNCj4gPiA+IGluZGV4IGQ1NDU5NWZiZjQ1ODYuLjM1NzQwZTg4YjM1OTEg
MTAwNjQ0DQo+ID4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+ID4g
KysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiA+IEBAIC01NCw2ICs1NCwz
MSBAQCBpbnQgdmdpY192NV9wcm9iZShjb25zdCBzdHJ1Y3QgZ2ljX2t2bV9pbmZvDQo+ID4gPiAq
aW5mbykNCj4gPiA+IMKgCXJldHVybiAwOw0KPiA+ID4gwqB9DQo+ID4gPiDCoA0KPiA+ID4gK3N0
YXRpYyB1MzIgdmdpY192NV9nZXRfZWZmZWN0aXZlX3ByaW9yaXR5X21hc2soc3RydWN0IGt2bV92
Y3B1DQo+ID4gPiAqdmNwdSkNCj4gPiA+ICt7DQo+ID4gPiArCXN0cnVjdCB2Z2ljX3Y1X2NwdV9p
ZiAqY3B1X2lmID0gJnZjcHUtDQo+ID4gPiA+YXJjaC52Z2ljX2NwdS52Z2ljX3Y1Ow0KPiA+ID4g
Kwl1bnNpZ25lZCBoaWdoZXN0X2FwLCBwcmlvcml0eV9tYXNrOw0KPiA+ID4gKw0KPiA+ID4gKwkv
Kg0KPiA+ID4gKwkgKiBDb3VudGluZyB0aGUgbnVtYmVyIG9mIHRyYWlsaW5nIHplcm9zIGdpdmVz
IHRoZQ0KPiA+ID4gY3VycmVudA0KPiA+ID4gKwkgKiBhY3RpdmUgcHJpb3JpdHkuIEV4cGxpY2l0
bHkgdXNlIHRoZSAzMi1iaXQgdmVyc2lvbg0KPiA+ID4gaGVyZSBhcw0KPiA+ID4gKwkgKiB3ZSBo
YXZlIDMyIHByaW9yaXRpZXMuIDB4MjAgdGhlbiBtZWFucyB0aGF0IHRoZXJlIGFyZQ0KPiA+ID4g
bm8NCj4gPiA+ICsJICogYWN0aXZlIHByaW9yaXRpZXMuDQo+ID4gPiArCSAqLw0KPiA+ID4gKwlo
aWdoZXN0X2FwID0gX19idWlsdGluX2N0eihjcHVfaWYtPnZnaWNfYXByKTsNCj4gPiANCj4gPiBf
X2J1aWx0aW5fY3R6KDApIGlzIHVuZGVmaW5lZA0KPiA+IChodHRwczovL2djYy5nbnUub3JnL29u
bGluZWRvY3MvZ2NjL0JpdC1PcGVyYXRpb24tQnVpbHRpbnMuaHRtbCkNCj4gPiANCj4gPiBMb29r
aW5nIGF0IF9fdmdpY192M19jbGVhcl9oaWdoZXN0X2FjdGl2ZV9wcmlvcml0eSgpLCBpdCBoYW5k
bGVzDQo+ID4gdGhhdCBsaWtlIHRoaXM6DQo+ID4gDQo+ID4gCWMwID0gYXAwID8gX19mZnMoYXAw
KSA6IDMyOw0KPiANCj4gU29ycnkgZm9yZ290IGZmcygpIHdhcyAxLWJhc2VkLCBzbzoNCj4gDQo+
IAloaWdoZXN0X2FwID0gY3B1X2lmLT52Z2ljX2FwciA/IF9fYnVpbHRpbl9jdHooY3B1X2lmLQ0K
PiA+dmdpY19hcHIpIDogMzI7DQo+IA0KPiBUaGFua3MsDQo+IEpvZXkNCg0KVGhhbmtzLiBIYXZl
IG1hZGUgdGhpcyBjaGFuZ2UgYXMgSSB0aGluayBpdCBhZGRyZXNzZXMgTWFyYydzIGNvbmNlcm4N
CnRvbyENCg0KU2FzY2hhDQoNCj4gDQo+ID4gDQo+ID4gVGhhbmtzLA0KPiA+IEpvZXkNCj4gPiAN
Cj4gPiA+ICsNCj4gPiA+ICsJLyoNCj4gPiA+ICsJICogQW4gaW50ZXJydXB0IGlzIG9mIHN1ZmZp
Y2llbnQgcHJpb3JpdHkgaWYgaXQgaXMgZXF1YWwNCj4gPiA+IHRvIG9yDQo+ID4gPiArCSAqIGdy
ZWF0ZXIgdGhhbiB0aGUgcHJpb3JpdHkgbWFzay4gQWRkIDEgdG8gdGhlIHByaW9yaXR5DQo+ID4g
PiBtYXNrDQo+ID4gPiArCSAqIChpLmUuLCBsb3dlciBwcmlvcml0eSkgdG8gbWF0Y2ggdGhlIEFQ
UiBsb2dpYyBiZWZvcmUNCj4gPiA+IHRha2luZw0KPiA+ID4gKwkgKiB0aGUgbWluLiBUaGlzIGdp
dmVzIHVzIHRoZSBsb3dlc3QgcHJpb3JpdHkgdGhhdCBpcw0KPiA+ID4gbWFza2VkLg0KPiA+ID4g
KwkgKi8NCj4gPiA+ICsJcHJpb3JpdHlfbWFzayA9IEZJRUxEX0dFVChGRUFUX0dDSUVfSUNIX1ZN
Q1JfRUwyX1ZQTVIsDQo+ID4gPiBjcHVfaWYtPnZnaWNfdm1jcik7DQo+ID4gPiArCXByaW9yaXR5
X21hc2sgPSBtaW4oaGlnaGVzdF9hcCwgcHJpb3JpdHlfbWFzayArIDEpOw0KPiA+ID4gKw0KPiA+
ID4gKwlyZXR1cm4gcHJpb3JpdHlfbWFzazsNCj4gPiA+ICt9DQo+ID4gPiArDQo+ID4gPiDCoHN0
YXRpYyBib29sIHZnaWNfdjVfcHBpX3NldF9wZW5kaW5nX3N0YXRlKHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSwNCj4gPiA+IMKgCQkJCQnCoCBzdHJ1Y3QgdmdpY19pcnEgKmlycSkNCj4gPiA+IMKgew0K
PiA+ID4gQEAgLTEyMSw2ICsxNDYsMTA0IEBAIHZvaWQgdmdpY192NV9zZXRfcHBpX29wcyhzdHJ1
Y3QgdmdpY19pcnENCj4gPiA+ICppcnEpDQo+ID4gPiDCoAlpcnEtPm9wcyA9ICZ2Z2ljX3Y1X3Bw
aV9pcnFfb3BzOw0KPiA+ID4gwqB9DQo+ID4gPiDCoA0KPiA+ID4gKw0KPiA+ID4gKy8qDQo+ID4g
PiArICogU3luYyBiYWNrIHRoZSBQUEkgcHJpb3JpdGllcyB0byB0aGUgdmdpY19pcnEgc2hhZG93
IHN0YXRlDQo+ID4gPiArICovDQo+ID4gPiArc3RhdGljIHZvaWQgdmdpY192NV9zeW5jX3BwaV9w
cmlvcml0aWVzKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gPiA+ICt7DQo+ID4gPiArCXN0cnVj
dCB2Z2ljX3Y1X2NwdV9pZiAqY3B1X2lmID0gJnZjcHUtDQo+ID4gPiA+YXJjaC52Z2ljX2NwdS52
Z2ljX3Y1Ow0KPiA+ID4gKwl1bnNpZ25lZCBsb25nIGZsYWdzOw0KPiA+ID4gKwlpbnQgaSwgcmVn
Ow0KPiA+ID4gKw0KPiA+ID4gKwkvKiBXZSBoYXZlIDE2IFBQSSBQcmlvcml0eSByZWdzICovDQo+
ID4gPiArCWZvciAocmVnID0gMDsgcmVnIDwgMTY7IHJlZysrKSB7DQo+ID4gPiArCQljb25zdCB1
bnNpZ25lZCBsb25nIHByaW9yaXR5ciA9IGNwdV9pZi0NCj4gPiA+ID52Z2ljX3BwaV9wcmlvcml0
eXJbcmVnXTsNCj4gPiA+ICsNCj4gPiA+ICsJCWZvciAoaSA9IDA7IGkgPCA4OyArK2kpIHsNCj4g
PiA+ICsJCQlzdHJ1Y3QgdmdpY19pcnEgKmlycTsNCj4gPiA+ICsJCQl1MzIgaW50aWQ7DQo+ID4g
PiArCQkJdTggcHJpb3JpdHk7DQo+ID4gPiArDQo+ID4gPiArCQkJcHJpb3JpdHkgPSAocHJpb3Jp
dHlyID4+IChpICogOCkpICYNCj4gPiA+IDB4MWY7DQo+ID4gPiArDQo+ID4gPiArCQkJaW50aWQg
PSBGSUVMRF9QUkVQKEdJQ1Y1X0hXSVJRX1RZUEUsDQo+ID4gPiBHSUNWNV9IV0lSUV9UWVBFX1BQ
SSk7DQo+ID4gPiArCQkJaW50aWQgfD0gRklFTERfUFJFUChHSUNWNV9IV0lSUV9JRCwgcmVnDQo+
ID4gPiAqIDggKyBpKTsNCj4gPiA+ICsNCj4gPiA+ICsJCQlpcnEgPSB2Z2ljX2dldF92Y3B1X2ly
cSh2Y3B1LCBpbnRpZCk7DQo+ID4gPiArCQkJcmF3X3NwaW5fbG9ja19pcnFzYXZlKCZpcnEtPmly
cV9sb2NrLA0KPiA+ID4gZmxhZ3MpOw0KPiA+ID4gKw0KPiA+ID4gKwkJCWlycS0+cHJpb3JpdHkg
PSBwcmlvcml0eTsNCj4gPiA+ICsNCj4gPiA+ICsJCQlyYXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9y
ZSgmaXJxLQ0KPiA+ID4gPmlycV9sb2NrLCBmbGFncyk7DQo+ID4gPiArCQkJdmdpY19wdXRfaXJx
KHZjcHUtPmt2bSwgaXJxKTsNCj4gPiA+ICsJCX0NCj4gPiA+ICsJfQ0KPiA+ID4gK30NCj4gPiA+
ICsNCj4gPiA+ICtib29sIHZnaWNfdjVfaGFzX3BlbmRpbmdfcHBpKHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSkNCj4gPiA+ICt7DQo+ID4gPiArCXN0cnVjdCB2Z2ljX3Y1X2NwdV9pZiAqY3B1X2lmID0g
JnZjcHUtDQo+ID4gPiA+YXJjaC52Z2ljX2NwdS52Z2ljX3Y1Ow0KPiA+ID4gKwl1bnNpZ25lZCBs
b25nIGZsYWdzOw0KPiA+ID4gKwlpbnQgaSwgcmVnOw0KPiA+ID4gKwl1bnNpZ25lZCBpbnQgcHJp
b3JpdHlfbWFzazsNCj4gPiA+ICsNCj4gPiA+ICsJLyogSWYgbm8gcGVuZGluZyBiaXRzIGFyZSBz
ZXQsIGV4aXQgZWFybHkgKi8NCj4gPiA+ICsJaWYgKGxpa2VseSghY3B1X2lmLT52Z2ljX3BwaV9w
ZW5kclswXSAmJiAhY3B1X2lmLQ0KPiA+ID4gPnZnaWNfcHBpX3BlbmRyWzFdKSkNCj4gPiA+ICsJ
CXJldHVybiBmYWxzZTsNCj4gPiA+ICsNCj4gPiA+ICsJcHJpb3JpdHlfbWFzayA9DQo+ID4gPiB2
Z2ljX3Y1X2dldF9lZmZlY3RpdmVfcHJpb3JpdHlfbWFzayh2Y3B1KTsNCj4gPiA+ICsNCj4gPiA+
ICsJLyogSWYgdGhlIGNvbWJpbmVkIHByaW9yaXR5IG1hc2sgaXMgMCwgbm90aGluZyBjYW4gYmUN
Cj4gPiA+IHNpZ25hbGxlZCEgKi8NCj4gPiA+ICsJaWYgKCFwcmlvcml0eV9tYXNrKQ0KPiA+ID4g
KwkJcmV0dXJuIGZhbHNlOw0KPiA+ID4gKw0KPiA+ID4gKwkvKiBUaGUgc2hhZG93IHByaW9yaXR5
IGlzIG9ubHkgdXBkYXRlZCBvbiBkZW1hbmQsIHN5bmMNCj4gPiA+IGl0IGFjcm9zcyBmaXJzdCAq
Lw0KPiA+ID4gKwl2Z2ljX3Y1X3N5bmNfcHBpX3ByaW9yaXRpZXModmNwdSk7DQo+ID4gPiArDQo+
ID4gPiArCWZvciAocmVnID0gMDsgcmVnIDwgMjsgcmVnKyspIHsNCj4gPiA+ICsJCXVuc2lnbmVk
IGxvbmcgcG9zc2libGVfYml0czsNCj4gPiA+ICsJCWNvbnN0IHVuc2lnbmVkIGxvbmcgZW5hYmxl
ciA9IGNwdV9pZi0NCj4gPiA+ID52Z2ljX2ljaF9wcGlfZW5hYmxlcl9leGl0W3JlZ107DQo+ID4g
PiArCQljb25zdCB1bnNpZ25lZCBsb25nIHBlbmRyID0gY3B1X2lmLQ0KPiA+ID4gPnZnaWNfcHBp
X3BlbmRyX2V4aXRbcmVnXTsNCj4gPiA+ICsJCWJvb2wgaGFzX3BlbmRpbmcgPSBmYWxzZTsNCj4g
PiA+ICsNCj4gPiA+ICsJCS8qIENoZWNrIGFsbCBpbnRlcnJ1cHRzIHRoYXQgYXJlIGVuYWJsZWQg
YW5kDQo+ID4gPiBwZW5kaW5nICovDQo+ID4gPiArCQlwb3NzaWJsZV9iaXRzID0gZW5hYmxlciAm
IHBlbmRyOw0KPiA+ID4gKw0KPiA+ID4gKwkJLyoNCj4gPiA+ICsJCSAqIE9wdGltaXNhdGlvbjog
cGVuZGluZyBhbmQgZW5hYmxlZCB3aXRoIG5vDQo+ID4gPiBhY3RpdmUgcHJpb3JpdGllcw0KPiA+
ID4gKwkJICovDQo+ID4gPiArCQlpZiAocG9zc2libGVfYml0cyAmJiBwcmlvcml0eV9tYXNrID4g
MHgxZikNCj4gPiA+ICsJCQlyZXR1cm4gdHJ1ZTsNCj4gPiA+ICsNCj4gPiA+ICsJCWZvcl9lYWNo
X3NldF9iaXQoaSwgJnBvc3NpYmxlX2JpdHMsIDY0KSB7DQo+ID4gPiArCQkJc3RydWN0IHZnaWNf
aXJxICppcnE7DQo+ID4gPiArCQkJdTMyIGludGlkOw0KPiA+ID4gKw0KPiA+ID4gKwkJCWludGlk
ID0gRklFTERfUFJFUChHSUNWNV9IV0lSUV9UWVBFLA0KPiA+ID4gR0lDVjVfSFdJUlFfVFlQRV9Q
UEkpOw0KPiA+ID4gKwkJCWludGlkIHw9IEZJRUxEX1BSRVAoR0lDVjVfSFdJUlFfSUQsIHJlZw0K
PiA+ID4gKiA2NCArIGkpOw0KPiA+ID4gKw0KPiA+ID4gKwkJCWlycSA9IHZnaWNfZ2V0X3ZjcHVf
aXJxKHZjcHUsIGludGlkKTsNCj4gPiA+ICsJCQlyYXdfc3Bpbl9sb2NrX2lycXNhdmUoJmlycS0+
aXJxX2xvY2ssDQo+ID4gPiBmbGFncyk7DQo+ID4gPiArDQo+ID4gPiArCQkJLyoNCj4gPiA+ICsJ
CQkgKiBXZSBrbm93IHRoYXQgdGhlIGludGVycnVwdCBpcyBlbmFibGVkDQo+ID4gPiBhbmQgcGVu
ZGluZywgc28NCj4gPiA+ICsJCQkgKiBvbmx5IGNoZWNrIHRoZSBwcmlvcml0eS4NCj4gPiA+ICsJ
CQkgKi8NCj4gPiA+ICsJCQlpZiAoaXJxLT5wcmlvcml0eSA8PSBwcmlvcml0eV9tYXNrKQ0KPiA+
ID4gKwkJCQloYXNfcGVuZGluZyA9IHRydWU7DQo+ID4gPiArDQo+ID4gPiArCQkJcmF3X3NwaW5f
dW5sb2NrX2lycXJlc3RvcmUoJmlycS0NCj4gPiA+ID5pcnFfbG9jaywgZmxhZ3MpOw0KPiA+ID4g
KwkJCXZnaWNfcHV0X2lycSh2Y3B1LT5rdm0sIGlycSk7DQo+ID4gPiArDQo+ID4gPiArCQkJaWYg
KGhhc19wZW5kaW5nKQ0KPiA+ID4gKwkJCQlyZXR1cm4gdHJ1ZTsNCj4gPiA+ICsJCX0NCj4gPiA+
ICsJfQ0KPiA+ID4gKw0KPiA+ID4gKwlyZXR1cm4gZmFsc2U7DQo+ID4gPiArfQ0KPiA+ID4gKw0K
PiA+ID4gwqAvKg0KPiA+ID4gwqAgKiBEZXRlY3QgYW55IFBQSXMgc3RhdGUgY2hhbmdlcywgYW5k
IHByb3BhZ2F0ZSB0aGUgc3RhdGUgd2l0aA0KPiA+ID4gS1ZNJ3MNCj4gPiA+IMKgICogc2hhZG93
IHN0cnVjdHVyZXMuDQo+ID4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2lj
LmMNCj4gPiA+IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmMNCj4gPiA+IGluZGV4IGU1MzQ4
NzY2NTZjYTcuLjVkMThhMDNjYzExZDUgMTAwNjQ0DQo+ID4gPiAtLS0gYS9hcmNoL2FybTY0L2t2
bS92Z2ljL3ZnaWMuYw0KPiA+ID4gKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmMNCj4g
PiA+IEBAIC0xMTc0LDExICsxMTc0LDE1IEBAIGludCBrdm1fdmdpY192Y3B1X3BlbmRpbmdfaXJx
KHN0cnVjdA0KPiA+ID4ga3ZtX3ZjcHUgKnZjcHUpDQo+ID4gPiDCoAl1bnNpZ25lZCBsb25nIGZs
YWdzOw0KPiA+ID4gwqAJc3RydWN0IHZnaWNfdm1jciB2bWNyOw0KPiA+ID4gwqANCj4gPiA+IC0J
aWYgKCF2Y3B1LT5rdm0tPmFyY2gudmdpYy5lbmFibGVkKQ0KPiA+ID4gKwlpZiAoIXZjcHUtPmt2
bS0+YXJjaC52Z2ljLmVuYWJsZWQgJiYgIXZnaWNfaXNfdjUodmNwdS0NCj4gPiA+ID5rdm0pKQ0K
PiA+ID4gwqAJCXJldHVybiBmYWxzZTsNCj4gPiA+IMKgDQo+ID4gPiAtCWlmICh2Y3B1LT5hcmNo
LnZnaWNfY3B1LnZnaWNfdjMuaXRzX3ZwZS5wZW5kaW5nX2xhc3QpDQo+ID4gPiAtCQlyZXR1cm4g
dHJ1ZTsNCj4gPiA+ICsJaWYgKHZjcHUtPmt2bS0+YXJjaC52Z2ljLnZnaWNfbW9kZWwgPT0NCj4g
PiA+IEtWTV9ERVZfVFlQRV9BUk1fVkdJQ19WNSkgew0KPiA+ID4gKwkJcmV0dXJuIHZnaWNfdjVf
aGFzX3BlbmRpbmdfcHBpKHZjcHUpOw0KPiA+ID4gKwl9IGVsc2Ugew0KPiA+ID4gKwkJaWYgKHZj
cHUtDQo+ID4gPiA+YXJjaC52Z2ljX2NwdS52Z2ljX3YzLml0c192cGUucGVuZGluZ19sYXN0KQ0K
PiA+ID4gKwkJCXJldHVybiB0cnVlOw0KPiA+ID4gKwl9DQo+ID4gPiDCoA0KPiA+ID4gwqAJdmdp
Y19nZXRfdm1jcih2Y3B1LCAmdm1jcik7DQo+ID4gPiDCoA0KPiA+ID4gZGlmZiAtLWdpdCBhL2Fy
Y2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5oDQo+ID4gPiBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdp
Yy5oDQo+ID4gPiBpbmRleCA1YTc3MzE4ZGRiODdhLi40YjNhMWU3Y2EzZmI0IDEwMDY0NA0KPiA+
ID4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmgNCj4gPiA+ICsrKyBiL2FyY2gvYXJt
NjQva3ZtL3ZnaWMvdmdpYy5oDQo+ID4gPiBAQCAtMzg3LDYgKzM4Nyw3IEBAIHZvaWQgdmdpY19k
ZWJ1Z19kZXN0cm95KHN0cnVjdCBrdm0gKmt2bSk7DQo+ID4gPiDCoGludCB2Z2ljX3Y1X3Byb2Jl
KGNvbnN0IHN0cnVjdCBnaWNfa3ZtX2luZm8gKmluZm8pOw0KPiA+ID4gwqB2b2lkIHZnaWNfdjVf
c2V0X3BwaV9vcHMoc3RydWN0IHZnaWNfaXJxICppcnEpOw0KPiA+ID4gwqBpbnQgdmdpY192NV9z
ZXRfcHBpX2R2aShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHUzMiBpcnEsIGJvb2wNCj4gPiA+IGR2
aSk7DQo+ID4gPiArYm9vbCB2Z2ljX3Y1X2hhc19wZW5kaW5nX3BwaShzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUpOw0KPiA+ID4gwqB2b2lkIHZnaWNfdjVfZmx1c2hfcHBpX3N0YXRlKHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSk7DQo+ID4gPiDCoHZvaWQgdmdpY192NV9mb2xkX2lycV9zdGF0ZShzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUpOw0KPiA+ID4gwqB2b2lkIHZnaWNfdjVfbG9hZChzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUpOw0KPiA+ID4gLS0gDQo+ID4gPiAyLjM0LjENCg0K

