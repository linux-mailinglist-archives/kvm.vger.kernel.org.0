Return-Path: <kvm+bounces-50119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 296B3AE1FD0
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 18:09:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 42E0418954AD
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 16:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 994272E8E17;
	Fri, 20 Jun 2025 16:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MUKJn7hP";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MUKJn7hP"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011008.outbound.protection.outlook.com [52.101.65.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFF42C374E;
	Fri, 20 Jun 2025 16:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.8
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750435712; cv=fail; b=qt47aKsOmQepxyxts279BwFNJTVdBHn6viShY+z5Q+NySKvRPCexjtlozzf8q7NLr4TulNEkr9B7L9heEJLswOSO5Kk2r7T1Cp7fKmCG1Al0DnHUx0M0OzH9iq1kTDosGVOE/fWhR50jayZJGcP7ZoT5+DYGn8WWhpx0XJ2kCrM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750435712; c=relaxed/simple;
	bh=QLiOaKQhMI38mB1PXT0nVpQXT1er7Q3KRgNuP7THpHI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iPQSv5YMXojN9le0zmeKXlD4vqw3VR3T+8MaMxTgbRaFfV2bswrJj+C4wEcpS1jqQUo/8BHpsy8uuniFD0cPChUNmBqG02gsCBidT0SQ03n5M9UnAZxIhyTVqBf42VKCS+tIkZsY+3bL1A0RyQOjU/h7juEi4+oALjV/1iHdUOc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MUKJn7hP; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MUKJn7hP; arc=fail smtp.client-ip=52.101.65.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=GWeO5co3BmP+ZEmPr99UWlSqfoTQgi2MlyzzNwAVBZuBWx95CG8Yz5QkVFRtE+U6y8aSd9RGnMFW9vLixYzTM9Yg+kc9yYdfhaQUyEjkwZhh7f5zsNql0ibtHVcPaO9R0RKwyZ5VtOm+s/oSQHR6hvb5T0PSnOTLwImb+cD/QHt59IuAiOqK+JEH5Fsdbuq2+H1cV+MY/CPA7m+QVFPmFYrTqD9D0ndfBDyR/EIJAEIuiLTcjnOujCpL86kzp1UaoYQSNrhwVI7pQJOdAVf0Q0O5ois87HQvZMDjcIiB1OJW2kZxwPgfn4yfWVY3oDjCcALVyPihDeGfJFQplXhoFQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=obSZLw5eq6WxRYT6t2gERvLIR51H/KUSze+8+KEGtY8=;
 b=UwGFn07kE6J88+lWuuxybHyTaRX3hfzHQw+gTaxxqnmKu2xy4dBnhW2GFbcjAEOwclv8ZOzomk454X+hlb5wSVhCwHduhdUqi5dqhNvOzFifH9NNv6sSxh4ipwo9ES+2YzhSU/bWPx3BiTs2pbegB+PPVMTGMdWJTuUgId5Pja1UzLVJTKlDOfY6NPcucSJRA7FyglpHIvnGYkEvG4RdB4oljxEMQfvl2SQAoyhfUjxWR+LPPqw76peLDAzlMUvbpkUggKZ6jsgyAQuYCzm+f6uFaLAKwmyyLusTBcDbNE4N4XVQrB4z9ta04zk3Mx30HufKzwbSUCUCS13WKvurOw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=obSZLw5eq6WxRYT6t2gERvLIR51H/KUSze+8+KEGtY8=;
 b=MUKJn7hPzwv1nQZ4CLNsV+TNmmuaC4AiC+KgFIlR3xacmHO0LFpEwrvn6JfbQLq5s+vSFKXgyR+aTEDVGe52K3VnUwcNYa7CL3dZ+Hh0kTZgnS/NRMBe3fbOvT4XTX7Kmgc9sp8AXSPCXnaqBqutM8t/twezVIY5/QCHP7HivRo=
Received: from DU7PR01CA0021.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50f::9) by AS8PR08MB10271.eurprd08.prod.outlook.com
 (2603:10a6:20b:629::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.22; Fri, 20 Jun
 2025 16:08:26 +0000
Received: from DB5PEPF00014B8B.eurprd02.prod.outlook.com
 (2603:10a6:10:50f:cafe::d2) by DU7PR01CA0021.outlook.office365.com
 (2603:10a6:10:50f::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.25 via Frontend Transport; Fri,
 20 Jun 2025 16:08:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8B.mail.protection.outlook.com (10.167.8.199) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.21
 via Frontend Transport; Fri, 20 Jun 2025 16:08:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iQ48tUe37Ut72CTpMCCO0lt8WdAqko+sfranj2G6MvLQwUOaxBwfUC3QYEwodL5bixzXeIEf9A0o+ZMXbTMD9ePPxIxc9WAnzl9eKyzGt6V9Bw424R/C5JDr/4OU6a2iGaS57NnE9KKQNwSrUY8ost3SbKkc+F9U4sw9x1AmUB7s6QovUBxxZbErNW6/AOx+9ghDcrtpyTogBzTvnY7WrTWjOv+8YeJZrBgVczFeoSGaSdedNWmBqZuEqURR8amUOYbdS2HnCKPJhG8ACBsl2tKH1+I6/TcwOrmcJ16trtxC4gsisb9+Pnz6uXsufxahlkmQkgplmHV3kiQSso89kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=obSZLw5eq6WxRYT6t2gERvLIR51H/KUSze+8+KEGtY8=;
 b=AMjFI3wmBCK40YxXiKcqGAoP/2+MZn5DlU+hSeHYq32iPwFHaCsAUXBIi/03H651CczNIRG+Gj8fCkylPKtd1Q8LCZhxTfD36D2bZAYuTbVehLlqgSNe+GdMY/MOjajgwixToj1OPVRPMXECT9yOJJKBcDZX3rsE9529wcjcP1zUM98AVZnNtKFq7myH8bYMf0Vk0IWCj2TzPb8djL6ym52AIKf6eAqefNRAkWr/ljKA+ah+utZ255MwgONxADSRBcBUBuL9SoVLMmYYyWbK7jkYmYX1WFlJ7SfeQ9Gto6Hv7XQYCII91gtAE366Yw1eU525C4IaxPYPtKLoJFzSAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=obSZLw5eq6WxRYT6t2gERvLIR51H/KUSze+8+KEGtY8=;
 b=MUKJn7hPzwv1nQZ4CLNsV+TNmmuaC4AiC+KgFIlR3xacmHO0LFpEwrvn6JfbQLq5s+vSFKXgyR+aTEDVGe52K3VnUwcNYa7CL3dZ+Hh0kTZgnS/NRMBe3fbOvT4XTX7Kmgc9sp8AXSPCXnaqBqutM8t/twezVIY5/QCHP7HivRo=
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com (2603:10a6:10:46e::5)
 by AS2PR08MB9474.eurprd08.prod.outlook.com (2603:10a6:20b:5e9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.23; Fri, 20 Jun
 2025 16:07:51 +0000
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31]) by DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31%3]) with mapi id 15.20.8835.027; Fri, 20 Jun 2025
 16:07:51 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org"
	<will@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes
	<Timothy.Hayes@arm.com>
Subject: [PATCH 2/5] irqchip/gic-v5: Populate struct gic_kvm_info
Thread-Topic: [PATCH 2/5] irqchip/gic-v5: Populate struct gic_kvm_info
Thread-Index: AQHb4f15DzAi2U03S0y45nxFpD/PTQ==
Date: Fri, 20 Jun 2025 16:07:51 +0000
Message-ID: <20250620160741.3513940-3-sascha.bischoff@arm.com>
References: <20250620160741.3513940-1-sascha.bischoff@arm.com>
In-Reply-To: <20250620160741.3513940-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB10202:EE_|AS2PR08MB9474:EE_|DB5PEPF00014B8B:EE_|AS8PR08MB10271:EE_
X-MS-Office365-Filtering-Correlation-Id: a752a348-cc4b-46ae-0ca8-08ddb014af74
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?MHYyM3Tixf50UG75rs8CVv+Fka2EcfP24BRM0DYMWBbN4wlh5+EY6j8zWO?=
 =?iso-8859-1?Q?5Wj/IY/QZzyMFDIKwZxe4XtdhDFd9h6iIpsUjExKiBMgVULuSTIWeZI5yG?=
 =?iso-8859-1?Q?xmQr9tg0F9/Q8PSTtwACgSRO2IF8jsTYKbryYansZ4jn/RacboiwFN9lG7?=
 =?iso-8859-1?Q?JWyCmpRL+30Q8h2B/ArM/QjOPz03Rkh6qBFf3uNpUFm2bIKgrLn05wQL9B?=
 =?iso-8859-1?Q?sLCfew4FUAdXYhmRe4+1R97Ztupdy6FfKypzxYGALhrSEmIxlgq/cwPL2m?=
 =?iso-8859-1?Q?5s12yxxaGxsmC4uDlnXU02K4tnRidkKshzoX0sfljo5fvAtrPZp1PmsEDW?=
 =?iso-8859-1?Q?5FED+CgOah3Z5ZF8/98tvh9adxO/C7cuKV6htceswTas3zeTEj8vypSWkS?=
 =?iso-8859-1?Q?QG8stvAGZBfrgBjwo0509zEN3opQsIEL4+3FQTICyu6e9Z4Cee36AxOJtU?=
 =?iso-8859-1?Q?4fyE8fR4fQR2ltzWrtlqY5xc73689XBDGIH+nXfA7/yqepkHEs7qWWfg1p?=
 =?iso-8859-1?Q?h9bK1RaXQWh4EabonbadaP1SAOAL5EVOSWEOP3POHGmjFVBDLhHgvM2AX6?=
 =?iso-8859-1?Q?MY7miW2jkLU00kQuAhDcxMDGmuagApClZPEo5r7DxGpRkfz5pM3s+WlU2O?=
 =?iso-8859-1?Q?u7jSWaxOUoBGlrIRH9aR4OxwTD0PkMbltPV/vpMPdw+MNK8NhxJxxJBHWy?=
 =?iso-8859-1?Q?e3YQGSBW/p+kdXV0cNL6gLtyTn16ClQhvQhYVs72L3zTC2WHVofACyPxF3?=
 =?iso-8859-1?Q?4UmqIYIhxtyyvcy6Oay4xoCtt7Q0KLDTCWsYwPsnwmy6jtbKeyL+nqu9RI?=
 =?iso-8859-1?Q?TBuEcWaNcT6RKvHSJWf3ZltYZtP4YzAvSfkfK9nOZ/inpx+kcBI30CKr13?=
 =?iso-8859-1?Q?MFdut0T8CuJCSDKlv+d/odlD50SkyorWMYvAy2XWbLVthB+USLy9duhahi?=
 =?iso-8859-1?Q?UeRBMH9b1Pwm0Xc3PGy5ZL0gkn5lagMoT7cZdoOlHXcR0vjOfLOPQ6iOQw?=
 =?iso-8859-1?Q?xGDbJZkPXa0nxII5cAPflOZ5JZjq+7xlavcAAzfVaQ2tFrUAgX164DSMHx?=
 =?iso-8859-1?Q?XuXMpuyjQOoYQFUaZ6EQroNv/wwkn52VT7u8DfSRJ04IpWT6HXFnEeGCww?=
 =?iso-8859-1?Q?xZUJRkyN3joZDjIrptpbTCUs7UzVQ2bplm47nTNygR4nvnryvXArq1Y2JC?=
 =?iso-8859-1?Q?RMYKD8+QYS+5MZ7RE7lqRPC51kOpr1o4jD4Qd24EABtU64x/8imoS4RqMP?=
 =?iso-8859-1?Q?tIerSxZM1nZ0KTEd4NDTzZi41IHxw5t+KkqwezU7FJ0P7w0bZaaLWH++4K?=
 =?iso-8859-1?Q?bWw52rjXnhaGe506OvlbTJTbdEa70gOZKgcNWWutzPMrO/cexyUvA67vCo?=
 =?iso-8859-1?Q?JqfCNV+w6ZN9SafmIpRC17xFD+CkIvhPc9ipLrO8CwtIm7YwV8Lo0E4lUo?=
 =?iso-8859-1?Q?dmw4tA4weEIRaFgAOpuhBNtVSRF1PJNloJnyVz9/efDDAI7YqaJE0BlNwG?=
 =?iso-8859-1?Q?iua+QbN/UVt1vhPgzvQHEiHH9n8XcXPNfXpP7HodzOMhpl/azT3i9Z0i5N?=
 =?iso-8859-1?Q?2azpq8w=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB10202.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9474
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B8B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a13e415c-138a-43ef-ac85-08ddb0149bdb
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|82310400026|376014|7416014|35042699022|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?LqISiRdyszyXK+IZAv1cdroojDYqG5N5e+1VO5JkWuGNhsCh8PbMvYpu3u?=
 =?iso-8859-1?Q?kY7wCPLCOJpHljd3Z1RzP+JANoxzZZ+uWt88/QWNYqtQRbLJWrzfynmB6m?=
 =?iso-8859-1?Q?ejJZjhgf+1u2cntCr7wxTT2JWHAW5mN+mX0x8IQxjmmd3WEkI1OQPvyauT?=
 =?iso-8859-1?Q?lmWORLLjYli9UTwzg+lDDMADOUM7XWys4sIvMSOVXFOn+sMM8dmo4fjVH3?=
 =?iso-8859-1?Q?EPEF03+fCzkEY/0GPXQahIxicNq3FA7K9/7Xghahcd78uQ3SXOtaHvecEy?=
 =?iso-8859-1?Q?y6KhX/rQm8iHNM9kLESXAAc/MvXZnarvXQcBoEactKX0iWzZDU4ek09xgc?=
 =?iso-8859-1?Q?2jqTjMeaQ8LRm0+gEU3fiCb/cN5qDNy+GVkn7k5GAR790WYVHpM4CdOCqn?=
 =?iso-8859-1?Q?YA8Zsoaxj4IQi2di6uVZo01YD4RH21GOBk5dnuVFI7jBYbLOGNM5BgNEXO?=
 =?iso-8859-1?Q?MmZXqJEDyXgRi7N+wbJGeneCQ4G+5BYScwhRG2qtvW3Rj93AhsUqdfs+qq?=
 =?iso-8859-1?Q?46JcgJ4KDKYuGOp5KSmq8Ly8aFx1TMit9iKVDHWYkD0GytTEjEzFbtvs6b?=
 =?iso-8859-1?Q?1+hfS7viMCAfjBKEwfybGj+vqrJ/9G8uomzXuEliuPQIoxiQAxswnhQxHq?=
 =?iso-8859-1?Q?f3Db/cmXi+qKtXAa5EnW85f+AV1C0x17ZPPCquKLWbwduL2gXf9UArc6s7?=
 =?iso-8859-1?Q?AJqGEB0bOn2D2ppzYmtD7FowiP+NXdu/HtcxuUKX2uh5Rd2TfvxUmMJRnC?=
 =?iso-8859-1?Q?n1nZ0Mqy30ZU+6P9Y56ThWUOpcf4T1Q7h3RtnmQXxukkTDu1iCpDDrWTV3?=
 =?iso-8859-1?Q?8pipnIV4W49L+ll5KULy77kU7Dk9ledHGkaSSkJYvta7dp2FM7WwGqfGft?=
 =?iso-8859-1?Q?2CRfRnneVJmxbQxjvDUug7lYX2TO/zv6czhdc7e63kuCmwvV6tVxAzJpLT?=
 =?iso-8859-1?Q?Kn7s1tMEuqTz0v9psFegWtFMghSNUo/4AIZDJhHb1KfxSvC1rPpGHRgypf?=
 =?iso-8859-1?Q?bYcGdsSF9mhM2siMXOw2IG+AQF9CzV483+z4850+Lc6ShxphvWKQLC6Ao2?=
 =?iso-8859-1?Q?5hYuFikvEHt/tUeWrMq0hjx+NLn1VC2AFfo4FIc7k7XuAnxf9LT/1tycD5?=
 =?iso-8859-1?Q?6zJwZ7vx38qIGfoFoQVq8s7k8thMJfHAk9ZmH9HCgS31UAOMg0EmLHCvS1?=
 =?iso-8859-1?Q?LIl/fhi5QIAEosnHs6azPvV1hw1h09oVNaQGM5glPXfKB0m0WfJk35sJLT?=
 =?iso-8859-1?Q?5ymZH0wwPNVgk0BEY+b9w5NmjbkCdudkhzPmvrUmtoTK7e1s9MqB4by5mb?=
 =?iso-8859-1?Q?ApiJmQaYwDDr11P7bBowl4xNc3li8TF+wRrpPvrO9qT3myvUl4OMKhcZnz?=
 =?iso-8859-1?Q?uQ5Gan+N1NxuS8O7RX/4Nps4gynbaFBNKnWlYn8US2+86g86VWrAuqYYWd?=
 =?iso-8859-1?Q?IpxgWYco/dDHDCgzAX1Y5Z7VGu/8k4DrkziEQYmp7qX7/aW7QgO1udFJeF?=
 =?iso-8859-1?Q?/j14XgSEDsZ5KkqinHmGkbcfNNd+/zzbKR+Ksi8cU12+3E1ddWYsOvU72z?=
 =?iso-8859-1?Q?bL1u60xTGdyNmOVJquTQ0BW0aui8?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(82310400026)(376014)(7416014)(35042699022)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 16:08:24.4971
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a752a348-cc4b-46ae-0ca8-08ddb014af74
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10271

Populate the gic_kvm_info struct based on support for
FEAT_GCIE_LEGACY.  The struct is used by KVM to probe for a compatible
GIC.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5.c          | 34 +++++++++++++++++++++++++++
 include/linux/irqchip/arm-vgic-info.h |  4 ++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index 28853d51a2ea..6aecd2343fee 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -13,6 +13,7 @@
=20
 #include <linux/irqchip.h>
 #include <linux/irqchip/arm-gic-v5.h>
+#include <linux/irqchip/arm-vgic-info.h>
=20
 #include <asm/cpufeature.h>
 #include <asm/exception.h>
@@ -1049,6 +1050,37 @@ static void gicv5_set_cpuif_idbits(void)
 	}
 }
=20
+#ifdef CONFIG_KVM
+static struct gic_kvm_info gic_v5_kvm_info __initdata;
+
+static bool gicv5_cpuif_has_gcie_legacy(void)
+{
+	u64 idr0 =3D read_sysreg_s(SYS_ICC_IDR0_EL1);
+
+	return !!FIELD_GET(ICC_IDR0_EL1_GCIE_LEGACY, idr0);
+}
+
+static void __init gic_of_setup_kvm_info(struct device_node *node)
+{
+	gic_v5_kvm_info.type =3D GIC_V5;
+	gic_v5_kvm_info.has_gcie_v3_compat =3D gicv5_cpuif_has_gcie_legacy();
+
+	/* GIC Virtual CPU interface maintenance interrupt */
+	gic_v5_kvm_info.no_maint_irq_mask =3D false;
+	gic_v5_kvm_info.maint_irq =3D irq_of_parse_and_map(node, 0);
+	if (!gic_v5_kvm_info.maint_irq) {
+		pr_warn("cannot find GICv5 virtual CPU interface maintenance interrupt\n=
");
+		return;
+	}
+
+	vgic_set_kvm_info(&gic_v5_kvm_info);
+}
+#else
+static void __init gic_of_setup_kvm_info(struct device_node *node)
+{
+}
+#endif // CONFIG_KVM
+
 static int __init gicv5_of_init(struct device_node *node, struct device_no=
de *parent)
 {
 	int ret =3D gicv5_irs_of_probe(node);
@@ -1081,6 +1113,8 @@ static int __init gicv5_of_init(struct device_node *n=
ode, struct device_node *pa
=20
 	gicv5_irs_its_probe();
=20
+	gic_of_setup_kvm_info(node);
+
 	return 0;
 out_int:
 	gicv5_cpu_disable_interrupts();
diff --git a/include/linux/irqchip/arm-vgic-info.h b/include/linux/irqchip/=
arm-vgic-info.h
index a75b2c7de69d..ca1713fac6e3 100644
--- a/include/linux/irqchip/arm-vgic-info.h
+++ b/include/linux/irqchip/arm-vgic-info.h
@@ -15,6 +15,8 @@ enum gic_type {
 	GIC_V2,
 	/* Full GICv3, optionally with v2 compat */
 	GIC_V3,
+	/* Full GICv5, optionally with v3 compat */
+	GIC_V5,
 };
=20
 struct gic_kvm_info {
@@ -34,6 +36,8 @@ struct gic_kvm_info {
 	bool		has_v4_1;
 	/* Deactivation impared, subpar stuff */
 	bool		no_hw_deactivation;
+	/* v3 compat support (GICv5 hosts, only) */
+	bool		has_gcie_v3_compat;
 };
=20
 #ifdef CONFIG_KVM
--=20
2.34.1

