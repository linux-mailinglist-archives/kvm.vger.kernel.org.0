Return-Path: <kvm+bounces-51398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 77D98AF6DFC
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:59:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 904661882D16
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 08:59:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FDC32D46AB;
	Thu,  3 Jul 2025 08:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eTCJxdlC";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eTCJxdlC"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010020.outbound.protection.outlook.com [52.101.69.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3F02D12F4;
	Thu,  3 Jul 2025 08:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.20
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751533136; cv=fail; b=Ofo1e9BUi4+UzbiPpOOH2ycehLoFVpVbP2A3eYD3YXMyE3lfGYpaiFyn1rEjEITctDBRjydomY1Tn6DTTtcxAwb2VZTxyzNDeJWkWrcVoAc1fn46OABUY1YR3VQUeioyQhsWBP0YWjcBjCRnyTOBcPIFuvB4sm7BET7fUymfM/4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751533136; c=relaxed/simple;
	bh=qYcc1o2FLbAAs3N3AhVZs/yYmA7pnMQDjYXTBQ3N8Eo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q2XUH7dEOH8gSWocGtj3mBUoXixKctujOmiUdw3Wp8U0D1KXd9GT5hHJZznyPUDH8GUWp+9eDbRGlwBAmUHqAell/oF9EEsJNBrZQfUvqOYstMewEv9IfdO7sFAfjQEbZ2jsAlgBYT5ReWkoXT+3OHCNPKvRWyeaieSuTiMnfPQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eTCJxdlC; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eTCJxdlC; arc=fail smtp.client-ip=52.101.69.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=S/XAddw+m80n3rtXBZp03uM8liEXJlMlJZAOtgdQSZU21n7gwm5NJNfbI7AupvaiRCbKQEz5Z5aN4AnSixRyGPnYaPr8GTQOraPtUMwyF8PAA9TIZu/9bTMJVK8QFEeqOMzDij7tfzYc+6zjtPIZxMbVEd42IMoUg7mmh+/+jwe0DXRT68DWrCCJj0F2Y6PAiwUgG8xeO2HtxLU3qPP4k/d5g88bCBPvi4zoZhGrQMGRpsHgFXgoO0DMWPTmh5lR0bdCdwWJS9OeL/jX4vOCuhKb9cNlXOVxMHAQpsz9jGsQkfkhBl7tPwcq9l+bvUMecUJtx9UBpj7CwymysDUflg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qYcc1o2FLbAAs3N3AhVZs/yYmA7pnMQDjYXTBQ3N8Eo=;
 b=rllDrFOwM6n91uVyIJK37pPqQTWeoKmPEDFSM47HsxqkTSll7H3omnInJ8YXVz8sALG2I/NrYN/yJ2AgkA3aQzQU+75aiuxR7rVOHVgBlYp7whPjUJp5PBwfWNm7u03CMp9rICZf/PTg2sd0dOQYPJW9khwRhaF1UtNWFToJrBJuU14yQ7vy89hwuNoPcTXYWickvq8odL1d3aEsj2U1bBcUhHZiuuTYkooRyMGNWDt4WYGUXpNKrtSnIYladcLDZrlNGW6D405mLegVfgJp2NPLoDwaqcPCkWeLo/wbHhDRqPSlgp0X5O1QaQiKe8YhDYoqTJl3Ba/2VWpM91OxMA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qYcc1o2FLbAAs3N3AhVZs/yYmA7pnMQDjYXTBQ3N8Eo=;
 b=eTCJxdlCao9wAnufepx8omyWvDtdbRZgEkipckqXQwh/TVtLKOFVaui1jOL6Nrh8DPIUU1Ml0I7yi8V6CmQlsF8flZlAyUwPEIcqwpB7hxYV7Pt2Pk58aGq5yKEbK0u9rsYsaIp+eA6FFBnZ1iJca76zE9HnsIvGWdiaaSWEFg4=
Received: from AM0PR02CA0195.eurprd02.prod.outlook.com (2603:10a6:20b:28e::32)
 by AM0PR08MB5427.eurprd08.prod.outlook.com (2603:10a6:208:183::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Thu, 3 Jul
 2025 08:58:52 +0000
Received: from AMS0EPF000001A3.eurprd05.prod.outlook.com
 (2603:10a6:20b:28e:cafe::91) by AM0PR02CA0195.outlook.office365.com
 (2603:10a6:20b:28e::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.20 via Frontend Transport; Thu,
 3 Jul 2025 08:58:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A3.mail.protection.outlook.com (10.167.16.228) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.15
 via Frontend Transport; Thu, 3 Jul 2025 08:58:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jz/tIP1PjOQN0GTU/XvYs23YLZdmMmwiJwUj39O+bpaesdnD3Br/ObFtXgqc7draQPEEPqeUSQseV1oVFKmzxAqpNn6ti4OquLjIOJF2hxUHOkD3Jw4j5AsRWAsehtd1kV9K4cLh1VbniYAO3L1BV51QFgpgGDY817j1vv5OVtHu7GzIsqGWq63sUh561r8a9tDCiIyf0MyXn8eSUWZwwdSb3py2ik5uSoPYqkeQ7DC7DtgYJVmrHL2qE6GplfOhn30/Dwn5oveTizdg+JJIBajQEjdSRtEqeM46ZYEOfmW0yFiQve6n17Vu2ysKYA4nSswxz/gSakXESmp7r+6hsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qYcc1o2FLbAAs3N3AhVZs/yYmA7pnMQDjYXTBQ3N8Eo=;
 b=b2IrTJrsSKFfjkp3nbZu9Q6IHqMCx1otQrTF/YZkVDLqOQXjDrJtfj2mmeibMH1TzAt36ECzTYFkWDl8/Pj1qsj2ntXlX50VYzEQK4VyGVRHgNhClqMPhVHLTnvC92g628HM1siFYSv18rAtSZbT/tp7vsskFFTmfBtc+CUR4OyfKNTxN27kU8gOnK59pWjpDtMXR3rIsXO/3LCkx69lPWqWx6wCaW0XnkEDdwKQd7p+YxCm0rzwV9rKZu0L/s+ILGh26jTjRRY4BXnEpUGyBrRhXx+4bgSzHI9M7/symuy7JkdrfZYcGOaRvwTBGPxehoU8S1y5xnazUfcrfs5GMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qYcc1o2FLbAAs3N3AhVZs/yYmA7pnMQDjYXTBQ3N8Eo=;
 b=eTCJxdlCao9wAnufepx8omyWvDtdbRZgEkipckqXQwh/TVtLKOFVaui1jOL6Nrh8DPIUU1Ml0I7yi8V6CmQlsF8flZlAyUwPEIcqwpB7hxYV7Pt2Pk58aGq5yKEbK0u9rsYsaIp+eA6FFBnZ1iJca76zE9HnsIvGWdiaaSWEFg4=
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com (2603:10a6:10:46e::5)
 by DU0PR08MB7485.eurprd08.prod.outlook.com (2603:10a6:10:355::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Thu, 3 Jul
 2025 08:58:17 +0000
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31]) by DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31%3]) with mapi id 15.20.8901.018; Thu, 3 Jul 2025
 08:58:17 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "lpieralisi@kernel.org" <lpieralisi@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, Timothy Hayes <Timothy.Hayes@arm.com>, nd <nd@arm.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, Suzuki Poulose <Suzuki.Poulose@arm.com>, "will@kernel.org"
	<will@kernel.org>
Subject: Re: [PATCH v2 2/5] irqchip/gic-v5: Populate struct gic_kvm_info
Thread-Topic: [PATCH v2 2/5] irqchip/gic-v5: Populate struct gic_kvm_info
Thread-Index: AQHb50uBQ+TR0rqMf0qls1RTKMQOQ7QdC00AgAMXVgA=
Date: Thu, 3 Jul 2025 08:58:17 +0000
Message-ID: <ce9d030796cbbc5ee7eec15a653d1d360215ee3c.camel@arm.com>
References: <20250627100847.1022515-1-sascha.bischoff@arm.com>
	 <20250627100847.1022515-3-sascha.bischoff@arm.com>
	 <aGOuVhED/SSnzwWU@lpieralisi>
In-Reply-To: <aGOuVhED/SSnzwWU@lpieralisi>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB10202:EE_|DU0PR08MB7485:EE_|AMS0EPF000001A3:EE_|AM0PR08MB5427:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a478695-f3c4-41fe-ee0d-08ddba0fd425
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?Yjl4RVFTWWFoN3JwOTZ2RUtKbGpKZ2I5OTRrdGdVd3BaQXQxTmJla1h6cW1H?=
 =?utf-8?B?cnJ5bWpIVGZGOUhMRTdmS3VVOHltSzNlbi85SElXdzdNL2Q1K2IydEpzWXpN?=
 =?utf-8?B?b0pPYUo5VytWKzZZSVVwbU81SFBQWmFVd3lBd1FxMkswcXhHZzBmdVJIWGpp?=
 =?utf-8?B?dm9waElINmNLbno5UzhGL2JzeW9Ub2lrT0c1cnpRa2lnckVvUFdBL0V4cm5B?=
 =?utf-8?B?S3I5TmxVaUd1WVNJdVJGZGZhQkQra0FnSHpkaFhJbS9nU0VMc2ovUDJlTUxm?=
 =?utf-8?B?dGdJYjBtamZhbzZQNFRXVGRNMWlKV0Rkay9kTUtBVS9BS0dGRlJZekYxdU12?=
 =?utf-8?B?ZjhjZ2w4bWhtdTFMbU1qRTVJZHlnOVg3YVVDNG9WTzJ5M1QwaW05T1JzWDNX?=
 =?utf-8?B?b29KY0VIV2J4WDZqaEpSTVc0UStIMHVBd2VYSEM5Qk5CNGg3QktpWW1NSGZT?=
 =?utf-8?B?Ny9QSXJhNnpFMEovVHRhYUZIT25RU3o2U2VYb1VDNjI4N2hzcFNMTnM0MTZh?=
 =?utf-8?B?clFMQ3VNNkIzUG1rTkowdU92bzFtdFlhdi9ITWtiblJ2ZzVOU2k2ajFGNE5I?=
 =?utf-8?B?OW1WNmdLd0JNQUppbGd6bUNZV2pxN1RvYnYwTFVRZ0Vtam5yTlJuNVNyWWUy?=
 =?utf-8?B?SC92MTRhYjZ3NUNVREFBK2Y3dkF4ZXdRL05yVTBRMnhhRm9LU2ZIVE1hNy9U?=
 =?utf-8?B?MHMyOS9XMnlZczBVS0NzNzVXcFdJZTdrRTJCaWl6cjl3NmlyN2txeFp3cHh3?=
 =?utf-8?B?SmtiVWJJUktTaFFuTEtzVitDdERxR0dGRHBMSFpweE5SYmN4dlNpcklTc0xh?=
 =?utf-8?B?Kyt4ZFp2ZkZZZXFhak5rSnRlWXk1aHA3S0orMXozMkZVZWR4YUdnTkFhM05W?=
 =?utf-8?B?QTVsYzNLSUZaekxuODF6akViQmtXY1dPcUI5cXNkcU85ajlNbzNBa2FnZ2U1?=
 =?utf-8?B?SGoyMDcwRStFUXIyeFBvNHhjVnZDSmlDeVlIMWQ2RGZ1NnhyblM5TFIyYWZG?=
 =?utf-8?B?aUs3REFBMVVFWldBZDZZTkRlelZoSENlMXhzYzR6dytKTy80UW5IY24xTTRX?=
 =?utf-8?B?VkVSczZPcGZKai9uUE9GSlh2UjhTZFJ6Q25vOWxQNElHWnVKYVRHRHAzR2d0?=
 =?utf-8?B?N24rY2duclBtcDR1K3VtbnRoUW9IR3FUV1dscVNqOWF2VUxSdzlmWmFwZGJt?=
 =?utf-8?B?VHUvMGJ5ZW1SRmpJQ2xSbktyaDVPaElibTdBei85MFBtZG9aRURQaGdjQWtE?=
 =?utf-8?B?UmpUZW5BRmdDNU92WDZmaEpKTTQvdDRzTERCUE84WEN2cjYwY2NZWktYNWNj?=
 =?utf-8?B?RG42ZWFWK0VmOFJtTzFXM3R2a1pGUy9IK01tWUFTUHJlS1lSQ24rN3pybVZu?=
 =?utf-8?B?ZFE3U0xwNExyd3JwM1FlODB4YUJWdGJDREJ5Si9QR254cFlSRTFuN1Vvc2x6?=
 =?utf-8?B?MCtUY1ZDQlJocUw4cXMvcThnbjdmc3hCeTdLWGFtWlZJRU5VVkpEd29UbFl0?=
 =?utf-8?B?SktXZEk1MzNmc0lpMDg2UmdpOUZkRUVkaFk3UlA2M01UcWtIclF4YW5QcGFI?=
 =?utf-8?B?RWlZMXc2b25MNmZ1Q203QUhrWThUWmEzbGxXVGw3dklNTEFwbDJFemVwUzFT?=
 =?utf-8?B?SDJXS0MrTGZPamxzdkNTOEswT085TTcyOHRGbExXbmlGc0picktyT0tORTdp?=
 =?utf-8?B?ejZveWtqNWdyTVBmTFpyVE9veVYvL1ludWpoTWhHMzNYM2Y5Nkwrb25ONmdF?=
 =?utf-8?B?MWd1Wk5SMU5ya1hoQ0RMWGFHWGVydFpoNk1RU1F6RzN5bWdmUlRUS3V6NldX?=
 =?utf-8?B?NTNqcWpZclpJRm44NERBcmpoY1M3dE9xeEV0RUlVVDlacXZ1MEZ1U09zWDEw?=
 =?utf-8?B?bHB3QVFkN2h1QUFEbDlLdEZ5c3hQMmgyQXdsNUN2TUN4bVlKZ1hVOW5Wd3o1?=
 =?utf-8?B?M054dDVjcFA2WDk2WlFxUXpHR3ZqeDV1aVRrNlVlbHJJZjBIS3RBcUROR3Q2?=
 =?utf-8?B?cXVOUUhMVUlRPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB10202.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <193F34E8A3865949B37FA44453B8F714@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7485
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A3.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1946813f-e8fe-4ed1-ee24-08ddba0fc090
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|35042699022|14060799003|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eVN4dTU2TDVGZjRyd05VZXJ1RFhjRHB0Qi9JekZpWjVxY2NXMW1Bc3pwQzRx?=
 =?utf-8?B?TkNpakF4QXBzRDhGNGljV2ZYZzJ6V0xnTUxYdjVYcWFlM1I4ZXl0d1NYbFdx?=
 =?utf-8?B?RGZqa1haY29iSVQrc3ZGczFuUFNRWHRMSURPa3k2RHVjQkppRWVSRUQ0RlVY?=
 =?utf-8?B?djdFSlRmdzYwQkc5V3lCTFd3OGVOUnhNUUtyTXYxQlR1dzhFN05GTXcyMWFH?=
 =?utf-8?B?UG4yRkJpSnVhbTVvR05LOFRIa3N1UTBRZVZUSnoxRHdNaFpjNTR0WjNzdGVl?=
 =?utf-8?B?UWxySENQc2hlWUp6Mm9JYTgvalphdlVRSTBiZzVJMitjTVlWTGFuTkdnWnFE?=
 =?utf-8?B?WHY3RzVOejdJb1RFeG1Idm83Z3NHc1FpRjhNdnBNc0phYTFvMmwrcEhSdWFC?=
 =?utf-8?B?YU0zeE91QlBWY3JoemowTHVjWnloTWhyRHBPL1l1TWRQYmc5Sk96RHE0bjl0?=
 =?utf-8?B?QWNFTnJTdnlKRDRLUGFoMDhiakxWMlJQSjF6RkhjRkNIWGhIL09pQXBVa3NF?=
 =?utf-8?B?R00zWkI5ZkhIalB2U3FXSC9sdVZEUFR3THlSRFlQclV2Y0FSQmkwM2cxdkpH?=
 =?utf-8?B?anN6aXBCRDZGNkxlUnZBWDhQd0RDQSsxYStPTVRmRElac0c0eGErR1FHeU5O?=
 =?utf-8?B?SkhLeUNpVFZFcWtvTi82RTJ2YjV2R3ZmME1DaTRPcFlpNjg1NWQ4bEJnUDlL?=
 =?utf-8?B?Q01OUWt2YTZUOVF4Q1VMZzBQbVgyUUw4STMwVjhGV01ucnQwMjh3U1Mzb2tQ?=
 =?utf-8?B?NTNreWpIRzJvaDBNSnl0dTlaQTJrMG52SVFjOVROcjVuRXplTkpmckdjclEy?=
 =?utf-8?B?NkZsbDFWWGMvSUMyNktVckhNZXp3Ny9lU1ZneDV3TVJoUEJRVTlDbm5jVFVQ?=
 =?utf-8?B?SUJFY1lCVmpXaU1nUmFMZlJmV0FNN0dEbEl0TURybXl3VlhHYW9QZnhtanl1?=
 =?utf-8?B?anAxQzFucEZqYzBXT09SWkNaR2ZORUlabVgxdENLc1BIY2JUaHBQWXEvNzcy?=
 =?utf-8?B?ZUIwa0tqRm1Qd0dweVVWZW1GYTFNeVlxdFN5MGtrQ3UrUnY3ZkxhOXBSeVVO?=
 =?utf-8?B?Y0lLWkZHaks1VHJ1aWNjME42cHNlR3VsVkFUalhnZi9Oa3VjV1BOREIxRTM1?=
 =?utf-8?B?dWNoQzJMZ2wrOUxZamZmT0x6Yjh5SktQNk1IQjNMU3A4V21tazVmUmUrRjU2?=
 =?utf-8?B?UmxtMHhyVHJzTkdxcHRxN1B0Nm0wdFBUazR4c0xnN1lHNTFOWUxPeXNoUWpI?=
 =?utf-8?B?NkJWR2FUQjVxRjF3RGpuSHB3KzFhN2tibk1QNVVVRjBxVHZSTGFZSEEvcGZ3?=
 =?utf-8?B?WVRWOThMTVB4ODFiSmdqM2pzRW44TXNwUXdNc1dwemRucUdRc2wyL3g4YklI?=
 =?utf-8?B?djBQN1NNNFhoODdkNDhXRU1rM0w5N1g4dmxrWm14VVBOcmxDR0dLd2QvREc2?=
 =?utf-8?B?MFloeWJLb0lnQzI3ekplQTFYZWFGcXBxTjdxM1ZCbHg4eFYxU3pTOTdPODNR?=
 =?utf-8?B?Zmo1MFNkeFRHYlkxaVVCK0N3bFF4NzhFM1ZxaDJIU1lPSm5wMDdyRXEwK3Q4?=
 =?utf-8?B?K0Zic1NwdFlJaW9tOUxZakQrQUxoa3k2Yk5FN0hNVXQ1bTZMWThmU25oMnFv?=
 =?utf-8?B?T1MyYVcrOHBRZitscmlOQ1JMZUl1TGhaRU1XdWVadGttTG9OS0ZkWVZYUVJX?=
 =?utf-8?B?Ykx5MXJqT3AvdmJ2VTNNZ1pLbi9WUEtjVjN6S0F3Q2VSNE93SVAxN3doOTdm?=
 =?utf-8?B?VmhBVXREbGVsOEJoaXRwSVBvUHpsbTN5WXVOMGdvSEd1R0ZyWXI4cWRkL1pz?=
 =?utf-8?B?Nmk0Z2YxOG4xS0NBTTBNYW1BbzdVTWNCTURVbzdzeS9FaUJITTdhdzRWWjFh?=
 =?utf-8?B?eVcxd0s1eEt1L3FxWWh2emFFR1BPU2VaUHRFKzBpT01BNk4wQWRQOVBmeURy?=
 =?utf-8?B?T1N1clN5MXJUTUZYTktFYWhvRGFFSTlhTHI4ajV6RDc2MGhqSmVTdXZVUUd2?=
 =?utf-8?B?NVpSbU54MEFLWGM0MWE5UjFQSk1Qa1h5bWRVcWF4clEvUklLcTVQaEV6M0ds?=
 =?utf-8?Q?+uLDeL?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(35042699022)(14060799003)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 08:58:50.2055
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a478695-f3c4-41fe-ee0d-08ddba0fd425
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A3.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5427

T24gVHVlLCAyMDI1LTA3LTAxIGF0IDExOjQ1ICswMjAwLCBMb3JlbnpvIFBpZXJhbGlzaSB3cm90
ZToNCj4gT24gRnJpLCBKdW4gMjcsIDIwMjUgYXQgMTA6MDk6MDFBTSArMDAwMCwgU2FzY2hhIEJp
c2Nob2ZmIHdyb3RlOg0KPiA+IFBvcHVsYXRlIHRoZSBnaWNfa3ZtX2luZm8gc3RydWN0IGJhc2Vk
IG9uIHN1cHBvcnQgZm9yDQo+ID4gRkVBVF9HQ0lFX0xFR0FDWS7CoCBUaGUgc3RydWN0IGlzIHVz
ZWQgYnkgS1ZNIHRvIHByb2JlIGZvciBhDQo+ID4gY29tcGF0aWJsZQ0KPiA+IEdJQy4NCj4gPiAN
Cj4gPiBDby1hdXRob3JlZC1ieTogVGltb3RoeSBIYXllcyA8dGltb3RoeS5oYXllc0Bhcm0uY29t
Pg0KPiA+IFNpZ25lZC1vZmYtYnk6IFRpbW90aHkgSGF5ZXMgPHRpbW90aHkuaGF5ZXNAYXJtLmNv
bT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBTYXNjaGEgQmlzY2hvZmYgPHNhc2NoYS5iaXNjaG9mZkBh
cm0uY29tPg0KPiA+IC0tLQ0KPiA+IMKgZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjUuY8KgwqDC
oMKgwqDCoMKgwqDCoCB8IDMzDQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4g
wqBpbmNsdWRlL2xpbnV4L2lycWNoaXAvYXJtLXZnaWMtaW5mby5oIHzCoCA0ICsrKysNCj4gPiDC
oDIgZmlsZXMgY2hhbmdlZCwgMzcgaW5zZXJ0aW9ucygrKQ0KPiANCj4gUmV2aWV3ZWQtYnk6IExv
cmVuem8gUGllcmFsaXNpIDxscGllcmFsaXNpQGtlcm5lbC5vcmc+DQoNCkRvbmUsIHRoYW5rcyEN
Cg0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjUuYyBiL2Ry
aXZlcnMvaXJxY2hpcC9pcnEtDQo+ID4gZ2ljLXY1LmMNCj4gPiBpbmRleCA2YjQyYzRhZjVjNzku
LjliYTQzZWM5MzE4YiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12
NS5jDQo+ID4gKysrIGIvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjUuYw0KPiA+IEBAIC0xMyw2
ICsxMyw3IEBADQo+ID4gwqANCj4gPiDCoCNpbmNsdWRlIDxsaW51eC9pcnFjaGlwLmg+DQo+ID4g
wqAjaW5jbHVkZSA8bGludXgvaXJxY2hpcC9hcm0tZ2ljLXY1Lmg+DQo+ID4gKyNpbmNsdWRlIDxs
aW51eC9pcnFjaGlwL2FybS12Z2ljLWluZm8uaD4NCj4gPiDCoA0KPiA+IMKgI2luY2x1ZGUgPGFz
bS9jcHVmZWF0dXJlLmg+DQo+ID4gwqAjaW5jbHVkZSA8YXNtL2V4Y2VwdGlvbi5oPg0KPiA+IEBA
IC0xMDQ5LDYgKzEwNTAsMzYgQEAgc3RhdGljIHZvaWQgZ2ljdjVfc2V0X2NwdWlmX2lkYml0cyh2
b2lkKQ0KPiA+IMKgCX0NCj4gPiDCoH0NCj4gPiDCoA0KPiA+ICsjaWZkZWYgQ09ORklHX0tWTQ0K
PiA+ICtzdGF0aWMgc3RydWN0IGdpY19rdm1faW5mbyBnaWNfdjVfa3ZtX2luZm8gX19pbml0ZGF0
YTsNCj4gPiArDQo+ID4gK3N0YXRpYyBib29sIF9faW5pdCBnaWN2NV9jcHVpZl9oYXNfZ2NpZV9s
ZWdhY3kodm9pZCkNCj4gPiArew0KPiA+ICsJdTY0IGlkcjAgPSByZWFkX3N5c3JlZ19zKFNZU19J
Q0NfSURSMF9FTDEpOw0KPiA+ICsJcmV0dXJuICEhRklFTERfR0VUKElDQ19JRFIwX0VMMV9HQ0lF
X0xFR0FDWSwgaWRyMCk7DQo+ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyB2b2lkIF9faW5pdCBn
aWNfb2Zfc2V0dXBfa3ZtX2luZm8oc3RydWN0IGRldmljZV9ub2RlICpub2RlKQ0KPiA+ICt7DQo+
ID4gKwlnaWNfdjVfa3ZtX2luZm8udHlwZSA9IEdJQ19WNTsNCj4gPiArCWdpY192NV9rdm1faW5m
by5oYXNfZ2NpZV92M19jb21wYXQgPQ0KPiA+IGdpY3Y1X2NwdWlmX2hhc19nY2llX2xlZ2FjeSgp
Ow0KPiA+ICsNCj4gPiArCS8qIEdJQyBWaXJ0dWFsIENQVSBpbnRlcmZhY2UgbWFpbnRlbmFuY2Ug
aW50ZXJydXB0ICovDQo+ID4gKwlnaWNfdjVfa3ZtX2luZm8ubm9fbWFpbnRfaXJxX21hc2sgPSBm
YWxzZTsNCj4gPiArCWdpY192NV9rdm1faW5mby5tYWludF9pcnEgPSBpcnFfb2ZfcGFyc2VfYW5k
X21hcChub2RlLCAwKTsNCj4gPiArCWlmICghZ2ljX3Y1X2t2bV9pbmZvLm1haW50X2lycSkgew0K
PiA+ICsJCXByX3dhcm4oImNhbm5vdCBmaW5kIEdJQ3Y1IHZpcnR1YWwgQ1BVIGludGVyZmFjZQ0K
PiA+IG1haW50ZW5hbmNlIGludGVycnVwdFxuIik7DQo+ID4gKwkJcmV0dXJuOw0KPiA+ICsJfQ0K
PiA+ICsNCj4gPiArCXZnaWNfc2V0X2t2bV9pbmZvKCZnaWNfdjVfa3ZtX2luZm8pOw0KPiA+ICt9
DQo+ID4gKyNlbHNlDQo+ID4gK3N0YXRpYyBpbmxpbmUgdm9pZCBfX2luaXQgZ2ljX29mX3NldHVw
X2t2bV9pbmZvKHN0cnVjdCBkZXZpY2Vfbm9kZQ0KPiA+ICpub2RlKQ0KPiA+ICt7DQo+ID4gK30N
Cj4gPiArI2VuZGlmIC8vIENPTkZJR19LVk0NCj4gPiArDQo+ID4gwqBzdGF0aWMgaW50IF9faW5p
dCBnaWN2NV9vZl9pbml0KHN0cnVjdCBkZXZpY2Vfbm9kZSAqbm9kZSwgc3RydWN0DQo+ID4gZGV2
aWNlX25vZGUgKnBhcmVudCkNCj4gPiDCoHsNCj4gPiDCoAlpbnQgcmV0ID0gZ2ljdjVfaXJzX29m
X3Byb2JlKG5vZGUpOw0KPiA+IEBAIC0xMDgxLDYgKzExMTIsOCBAQCBzdGF0aWMgaW50IF9faW5p
dCBnaWN2NV9vZl9pbml0KHN0cnVjdA0KPiA+IGRldmljZV9ub2RlICpub2RlLCBzdHJ1Y3QgZGV2
aWNlX25vZGUgKnBhDQo+ID4gwqANCj4gPiDCoAlnaWN2NV9pcnNfaXRzX3Byb2JlKCk7DQo+ID4g
wqANCj4gPiArCWdpY19vZl9zZXR1cF9rdm1faW5mbyhub2RlKTsNCj4gPiArDQo+ID4gwqAJcmV0
dXJuIDA7DQo+ID4gwqANCj4gPiDCoG91dF9pbnQ6DQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUv
bGludXgvaXJxY2hpcC9hcm0tdmdpYy1pbmZvLmgNCj4gPiBiL2luY2x1ZGUvbGludXgvaXJxY2hp
cC9hcm0tdmdpYy1pbmZvLmgNCj4gPiBpbmRleCBhNzViMmM3ZGU2OWQuLmNhMTcxM2ZhYzZlMyAx
MDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL2xpbnV4L2lycWNoaXAvYXJtLXZnaWMtaW5mby5oDQo+
ID4gKysrIGIvaW5jbHVkZS9saW51eC9pcnFjaGlwL2FybS12Z2ljLWluZm8uaA0KPiA+IEBAIC0x
NSw2ICsxNSw4IEBAIGVudW0gZ2ljX3R5cGUgew0KPiA+IMKgCUdJQ19WMiwNCj4gPiDCoAkvKiBG
dWxsIEdJQ3YzLCBvcHRpb25hbGx5IHdpdGggdjIgY29tcGF0ICovDQo+ID4gwqAJR0lDX1YzLA0K
PiA+ICsJLyogRnVsbCBHSUN2NSwgb3B0aW9uYWxseSB3aXRoIHYzIGNvbXBhdCAqLw0KPiA+ICsJ
R0lDX1Y1LA0KPiA+IMKgfTsNCj4gPiDCoA0KPiA+IMKgc3RydWN0IGdpY19rdm1faW5mbyB7DQo+
ID4gQEAgLTM0LDYgKzM2LDggQEAgc3RydWN0IGdpY19rdm1faW5mbyB7DQo+ID4gwqAJYm9vbAkJ
aGFzX3Y0XzE7DQo+ID4gwqAJLyogRGVhY3RpdmF0aW9uIGltcGFyZWQsIHN1YnBhciBzdHVmZiAq
Lw0KPiA+IMKgCWJvb2wJCW5vX2h3X2RlYWN0aXZhdGlvbjsNCj4gPiArCS8qIHYzIGNvbXBhdCBz
dXBwb3J0IChHSUN2NSBob3N0cywgb25seSkgKi8NCj4gPiArCWJvb2wJCWhhc19nY2llX3YzX2Nv
bXBhdDsNCj4gPiDCoH07DQo+ID4gwqANCj4gPiDCoCNpZmRlZiBDT05GSUdfS1ZNDQo+ID4gLS0g
DQo+ID4gMi4zNC4xDQoNCg==

