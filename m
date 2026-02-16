Return-Path: <kvm+bounces-71116-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KIeDGEuokmkNwQEAu9opvQ
	(envelope-from <kvm+bounces-71116-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 06:16:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F359140F21
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 06:16:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2120A3002B58
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 05:16:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6507D2DA757;
	Mon, 16 Feb 2026 05:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qjdm6/SR"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011067.outbound.protection.outlook.com [52.101.62.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB6363CB;
	Mon, 16 Feb 2026 05:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771219012; cv=fail; b=RPkhJCjDt2btL7AL6tLbH0+nX2qiqXRw87rWb6tjh2W9d2Onib2QaL8hxjL9vehC3tZDMbOTFpICGG6pzOPpVKVlRxO5lvLWZQY2Rc249r0q9pkDfPUnJ1ZfU5YOMNBdnlXfhUDv5XHLBXFDtGfI2aE29aACWZjc3YhRoPVbsng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771219012; c=relaxed/simple;
	bh=fR/oKsbaHQtMcJiaJIhvq6tjsYwr/8KgqlKsqOlqx3U=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=mUTFkaT8fDq+Gzt8zytEsb+wNCRoXzjgGY4x71cyMa829xfx28KYBXiKNgNYmTv2501E4tc6JYCNCzCWrRQ700QqT64TU3XdXxrX/z42WEudLnAXVv8LHacrgyvsk9LMP9Ehg5Zjd/Z3OmgrbC//UMdtKwJIf6kWLv6UTBRRVWM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qjdm6/SR; arc=fail smtp.client-ip=52.101.62.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sh8FwLFja1ESv5trrzIhPYzQt1i7RraIh+mKPFyi5hbjmhvk0VWT8RaRb91kQd+X7lhOeS7SSqUh4E1Jjzgk2uGZlgpMt9X8GE0l079JnMuI8WqHL8HPcnyr4qsxvbQsloKBujNpGpScrUmTNAOtxbWBYv2Vs6CR9vKhlmEfKbXt7+dHuN512r77zWSdEZePrMUaVqA008Bs725EvscNkvwDyHDSCh7Z8XmrafM2Nr8Uy423j1Ca7K30EzeLboefr/0fXe3vt8sG55vTLGdpYY+519TMP8sH27V6NWa6Gk5uAe7X9YioAeRQV3yvh+Ssd+BZgQn4CRqjR60IWoDLVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u2euYI6rCvL6Isqm+YANrh6yHpq3PEwi0ov+4CzkzmQ=;
 b=CZBtYwlQQbc6zpRHNSMqmIZbLCTZUeW2UJKdSteW8JouJv4goNHUXZz5BdpyKLcCDH9uWszEnhwbfJPT/+j9Ew9bdV7JpnbRatd7QArpKulPy21SQOBWI2wyUL7EsRZHjmgX+NnxRYIGilvk2yjIoPg6ID1VwSoQEsbo4Gb/iZP+B7D1COw8pLJ0fXO5fRK2M8KIbvEBkOANlyAAgiH8NslaOSs+LM9CwF+87nn4OD6/fzDbTglL5RNCLQWkH6y7KZ/BiL10mrj9efTubSnJb/f/Kidup8d7IPR6NOfUMBFJQPvlTNbvxhU0w2jT6B0iZcYtF0qS3ycAkaT+9JcgAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u2euYI6rCvL6Isqm+YANrh6yHpq3PEwi0ov+4CzkzmQ=;
 b=qjdm6/SRyKlXYsIkNgAGJYozeUFlVIU77Up62U1fCfWZywiB96x9tGqNI3MoN38akn90qwvmn0BRErQ5eZjD9SaXlQpQpXySsX8CXaZ8YVYkcpNRP7i4BrWTJj+FNp+OQAxmohmYOpFBlCM/gYDaF277omDiP0B8+40vNdYUK/E=
Received: from BYAPR03CA0012.namprd03.prod.outlook.com (2603:10b6:a02:a8::25)
 by LV3PR12MB9259.namprd12.prod.outlook.com (2603:10b6:408:1b0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.15; Mon, 16 Feb
 2026 05:16:47 +0000
Received: from SJ5PEPF000001D3.namprd05.prod.outlook.com
 (2603:10b6:a02:a8:cafe::55) by BYAPR03CA0012.outlook.office365.com
 (2603:10b6:a02:a8::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.16 via Frontend Transport; Mon,
 16 Feb 2026 05:16:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001D3.mail.protection.outlook.com (10.167.242.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 16 Feb 2026 05:16:46 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Sun, 15 Feb
 2026 23:16:45 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 15 Feb
 2026 23:16:44 -0600
Received: from [10.252.210.85] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Sun, 15 Feb 2026 23:16:40 -0600
Message-ID: <317f7def-9ac7-41e1-8754-808cd08f88cb@amd.com>
Date: Mon, 16 Feb 2026 10:46:39 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests
From: "Nikunj A. Dadhania" <nikunj@amd.com>
To: Dave Hansen <dave.hansen@intel.com>, <bp@alien8.de>
CC: <tglx@kernel.org>, <mingo@redhat.com>, <kvm@vger.kernel.org>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <xin@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <x86@kernel.org>,
	<jon.grimm@amd.com>, <stable@vger.kernel.org>, Tom Lendacky
	<thomas.lendacky@amd.com>, <linux-kernel@vger.kernel.org>,
	<sohil.mehta@intel.com>, <andrew.cooper3@citrix.com>
References: <20260205051030.1225975-1-nikunj@amd.com>
 <9c8c2d69-5434-4416-ba37-897ce00e2b11@intel.com>
 <02df7890-83c2-4047-8c88-46fbc6e0a892@intel.com>
 <103bc1df-4caf-430a-9c8b-fcee78b3dd1d@amd.com>
 <5cf9358a-a5c3-4d4b-b82f-16d69fa30f3e@amd.com>
Content-Language: en-US
In-Reply-To: <5cf9358a-a5c3-4d4b-b82f-16d69fa30f3e@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB04.amd.com: nikunj@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D3:EE_|LV3PR12MB9259:EE_
X-MS-Office365-Filtering-Correlation-Id: 0751c09d-e5a6-4281-362d-08de6d1a94ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WVJ6TUlUWnhNVlhCVmd1OUY5UlBZUHJyQ3pZaGpOK2JrSXpYajZkWmxkNGlD?=
 =?utf-8?B?QVVGM2pLNUllTUFPZDN3Mzlrc01ncnZYUm5hT3JRVmo0MjdhekdvNW8rem1W?=
 =?utf-8?B?QUZERGc4WDJZNXRIbmNwdGlCbUxHZEZpMnNWMjhGNmFYaFlvVjJ1UDBLMU9k?=
 =?utf-8?B?S0dSeXhwRDdhRU9zMkp3MmIrb3MvVDUxcGtlRXU3UjA0WmpTZnZVTkVPL2hq?=
 =?utf-8?B?TWtSbFlMOTIrUFB0Q3F2dEVid1YyeVAyU0UzYXZwdHI3SE1FYjBkYXV2MWtj?=
 =?utf-8?B?NDFmN1hjbW9Kc0poVzdvOTF6YlhrQ1E4VDJ2ZEtRbG1lZnJWei9mb0JLOEsx?=
 =?utf-8?B?SDUxQmRnV1g4R2sxQU9qNjhhSGdveTdXOGMyUEhneFZpOERSa3haMkNJWjJX?=
 =?utf-8?B?YVF3VXBFT1I0VXpDTjRzMkpDUCtrVnR2WlA1eHRIWFBwOEs5TlRwN3JvS0hG?=
 =?utf-8?B?NHFCdGoxd2NOREpIV2lwZEluRm94T2VqSzRPU3dkbG00OWJCR0ZaUjlQYmhK?=
 =?utf-8?B?enQrRlRBU3R6WFBBRjNHU2kzL0phVnA0UjBhNW10SjBHeGRUNHVzQTJiMlFn?=
 =?utf-8?B?ZVRnZGx2M3ZySjRzUUJ3aURHdjJJS05EV2ROVVp4cmV0Yzd3b1QxMzB1bEQx?=
 =?utf-8?B?UXZWMWxEMjJMcEI1U0hWdmJSdHMyMXhJaXlyN2psVWh3Wi9hcjd2QS9Gd1ZV?=
 =?utf-8?B?U2kyaVhsQmUwYkhIckkvSnJHdGJZM0JVTVo3cjl0Z0IrMDRzZzlMSUdpTzR4?=
 =?utf-8?B?UVc1d1g2d2Fmd1A2L3F4dFVndlR5ZmtiZnBiZGRNVFprWTh6MnZwZTZmWXlH?=
 =?utf-8?B?QjRzTDhXNytEa25CK3ZYNlMyMXUyWDhLOGNXeHFma2x4R0J5eVdQWXpKT0pi?=
 =?utf-8?B?UW5sN0trY2NLY2tubGowek9lenpMZlljRjk0RS90M2ovUHZoQ2VqVDJaano2?=
 =?utf-8?B?MHdpVXhuTklSY2VUTEQ4ZkVESTFMbHZCb0RSQkY2VWpHRTlPaWFFbklONUF0?=
 =?utf-8?B?N3VhcHUrTGR2NzB5VEVaSmRiZm9NYUpyUEFkQW1yemVlTjIrUTJhOHFmbklU?=
 =?utf-8?B?NUwzQ2haQVRoZFAwRmNqM0JtV2NrSDgxakFJNm1tVWdFZlV5MXI0c2Jwejk5?=
 =?utf-8?B?bTdVZEhYVjFCSlBGY2pOTFdIU09CTFhEMDlDVW9rTHErRHpkb2JMeU82WENk?=
 =?utf-8?B?Tm94MnNsSmpFL0lIQzNBMnE0NkdNK1VkWFFLVExvaElrNEVKdXJaM0htSEc1?=
 =?utf-8?B?amlnMCs4K3Q2YkNYVWxmYnZGR0cvRStqWDZXWTYyNFZrejg2NThHT1EwQ0hL?=
 =?utf-8?B?U09MODdzbXVNZVR4dWpIYmJBYzEreVFLKy9jNzdKaTlkQ1AwME16T2lqSnh1?=
 =?utf-8?B?bXpyZWVNYXRiOFZwREY1TDVFVi9hU0g5eWVpYVRDekliWXBjVHl0dGhySDhm?=
 =?utf-8?B?akduT1VMNHBBRVhhbFJLR2xLbGIzVDYxOThxSGdpaFBmY1NBWjhwK29qaGls?=
 =?utf-8?B?anZobHR5MG1KNnJycjFybmFWY3hxWGdaY0tQcHpLYkRidkNUR0VHeTRNWUlw?=
 =?utf-8?B?aU5aRUhBTmtoeDlKNkhrRGFVaU9YV1ZFQWNGb2FTWFlrcXhLVHpmYWduOGhj?=
 =?utf-8?B?WENISXhkRGJLT0tHWno4NnV1NFQ5WDRvZEt3bFpzREJLUld6cEpqU052UUtY?=
 =?utf-8?B?aXZZTlFnU2FZcjd1THd5SkFPN0pTeno5NklWbER0NmhqcnZyS3I4OVI5TmNq?=
 =?utf-8?B?eGxPUFhaOHpndjBmLzAyRng2VXdqM2NoRVZIeGJZVHhvS3B2WlZJZy9nRWRm?=
 =?utf-8?B?T24zNlRqZHFWbmlkRHFlZWtOaURDRFlxZUVSM2d4YnhSSEJRanlaTHdNc1J1?=
 =?utf-8?B?bmFsVC82Qmx1UEVFNS9sSERqVGt5NjZ5S0tud00vdStsU3pvUlU2ZnFYS1Vm?=
 =?utf-8?B?Q0xZZjFpVVk0czVsRWlhR0Y2RDFlTEZIeEZ2Wko2TmRXQVFDOEdsZG4yNDdn?=
 =?utf-8?B?MjZaeFVPZ3NOOWZUYkJuaVRvTGFpcDd6VElFdlhMMytod0o2T2JnMlA4b1I4?=
 =?utf-8?B?cHM5RThQQzlzdWZwMVZERWVsemEzbFhGMFp3K1ZYdnNEenBrcGsvZGZSMk5h?=
 =?utf-8?B?cjRrbklGUm9WSWZ1SU9lNmlBaTRVdUNML3kvU3dyZVp1a2pmOSs3TUdIaEgx?=
 =?utf-8?B?N1BHV2phcUQvNHk4ZVQ5S0kvNExxTWRld0Y1cDd2MW9TSE1CWVdtTTc3ejRU?=
 =?utf-8?Q?Ww/2ODUv4+JbULSu2hwj3cd5SoKYvUzJFWC2VVKIVk=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	0nQ2SWRSJa9L9HyJQK3ARG7dFB9izHGVj+nqPn1eHxKHxYRjozaUmXDLEblaBeE9d6TQk0Yll0eCHb/GuV6ayAjGUzwQjkvL9g1CRaXs3VStmendUad8qOQnPD/TRrPq/ac5/qWmbVVvfPKzU2Ac45iT5OGwtGyCgUi9N9ci7fY6TwPOlEWV0ermQ4z4Rkqsrewzxx4dTYDn+Km47IU0WcDG4ir9NbP8DPu+naTX3HBqlufr1ypBE8P222dq4hGXr6YJRgbNaGCXvXuT2zsJApEjnBzBR2KfnzVcJWB26/hI3JLUNZNuRZoiZhJPukUAnEQzM4XJAQ7d4+OKWBY4RohXvAj9j5j8kGLAbvmYcHVT/ywcySf6m/2AWzgYB6CFo1zNw1QDgAeXAJepCn/3YKhjzosjYRhW05is2EweljfCFBwRKtwxCNHRkpo2VJHa
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2026 05:16:46.8429
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0751c09d-e5a6-4281-362d-08de6d1a94ff
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9259
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nikunj@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:email,amd.com:mid,amd.com:dkim,amd.com:email];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71116-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: 6F359140F21
X-Rspamd-Action: no action



On 2/6/2026 6:08 PM, Nikunj A. Dadhania wrote:
> 
> 
> On 2/5/2026 11:09 PM, Tom Lendacky wrote:
>> On 2/5/26 11:20, Dave Hansen wrote:
>>> On 2/5/26 08:10, Dave Hansen wrote:
>>>> Shouldn't we flip the FRED CR4 bit _last_, once all the MSRs are set up?
>>>> Why is it backwards in the first place? Why can't it be fixed?
>>>
>>> Ahhh, it was done by CR4 pinning. It's the first thing in C code for
>>> booting secondaries:
>>>
>>> static void notrace __noendbr start_secondary(void *unused)
>>> {
>>>         cr4_init();
>>>
>>> Since FRED is set in 'cr4_pinned_mask', cr4_init() sets the FRED bit far
>>> before the FRED MSRs are ready. Anyone else doing native_write_cr4()
>>> will do the same thing. That's obviously not what was intended from the
>>> pinning code or the FRED init code.
>>>
>>> Shouldn't we fix this properly rather than moving printk()'s around?
>>
>> I believe that is what this part of the thread decided on:
>>
>> https://lore.kernel.org/kvm/02df7890-83c2-4047-8c88-46fbc6e0a892@intel.com/T/#m3e44c2c53aca3bcd872de4ce1e50a14500e62e4e
>>
>> Thanks,
>> Tom
>>
>>>
>>> One idea is just to turn off all the CR-pinning logic while bringing
>>> CPUs up. That way, nothing before:
>>>
>>> 	set_cpu_online(smp_processor_id(), true);
>>>
>>> can get tripped up by CR pinning. I've attached a completely untested
>>> patch to do that.
> 
> Yes, this works as well. And Xin Li's patch also resolves the issue by
> moving the cr4_init() later after initializing FRED MSRs.

Hi Dave,

This is what I have in my patch queue, Can I include your authorship and SOB?

Only change I made in your patch is s/cr4_pinning/cr_pinning.

From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH] x86/cpu: Disable CR pinning during CPU bringup

CR pinning can prematurely enable features during secondary CPU bringup
before their supporting infrastructure is initialized. Specifically, when
FRED is enabled, cr4_init() sets CR4.FRED via the pinned mask early in
start_secondary(), long before cpu_init_fred_exceptions() configures the
required FRED MSRs. This creates a window where exceptions cannot be
properly handled.

For SEV-ES/SNP and TDX guests, any console output during this window
triggers #VC or #VE exceptions that result in triple faults because the
exception handlers rely on FRED MSRs that aren't yet configured.

Disable CR pinning for offline CPUs by checking cpu_online() in the pinning
enforcement path. This allows features like FRED to be enabled in CR4 only
after their supporting MSRs and handlers are fully configured.

Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code")
Reported-by: Nikunj A Dadhania <nikunj@amd.com>
Not-yet-Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
[ Function renamed and added commit message]
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Cc: stable@vger.kernel.org # 6.9+
---
 arch/x86/kernel/cpu/common.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 1c3261cae40c..934ca3f139d3 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -434,6 +434,21 @@ static const unsigned long cr4_pinned_mask = X86_CR4_SMEP | X86_CR4_SMAP | X86_C
 static DEFINE_STATIC_KEY_FALSE_RO(cr_pinning);
 static unsigned long cr4_pinned_bits __ro_after_init;
 
+static bool cr_pinning_enabled(void)
+{
+	if (!static_branch_likely(&cr_pinning))
+		return false;
+
+	/*
+	 * Do not enforce pinning during CPU bringup. It might
+	 * turn on features that are not set up yet, like FRED.
+	 */
+	if (!cpu_online(smp_processor_id()))
+		return false;
+
+	return true;
+}
+
 void native_write_cr0(unsigned long val)
 {
 	unsigned long bits_missing = 0;
@@ -441,7 +456,7 @@ void native_write_cr0(unsigned long val)
 set_register:
 	asm volatile("mov %0,%%cr0": "+r" (val) : : "memory");
 
-	if (static_branch_likely(&cr_pinning)) {
+	if (cr_pinning_enabled()) {
 		if (unlikely((val & X86_CR0_WP) != X86_CR0_WP)) {
 			bits_missing = X86_CR0_WP;
 			val |= bits_missing;
@@ -460,7 +475,7 @@ void __no_profile native_write_cr4(unsigned long val)
 set_register:
 	asm volatile("mov %0,%%cr4": "+r" (val) : : "memory");
 
-	if (static_branch_likely(&cr_pinning)) {
+	if (cr_pinning_enabled()) {
 		if (unlikely((val & cr4_pinned_mask) != cr4_pinned_bits)) {
 			bits_changed = (val & cr4_pinned_mask) ^ cr4_pinned_bits;
 			val = (val & ~cr4_pinned_mask) | cr4_pinned_bits;
@@ -502,7 +517,7 @@ void cr4_init(void)
 
 	if (boot_cpu_has(X86_FEATURE_PCID))
 		cr4 |= X86_CR4_PCIDE;
-	if (static_branch_likely(&cr_pinning))
+	if (cr_pinning_enabled())
 		cr4 = (cr4 & ~cr4_pinned_mask) | cr4_pinned_bits;
 
 	__write_cr4(cr4);
-- 
2.48.1





