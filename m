Return-Path: <kvm+bounces-72437-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iNVDJysZpmmeKQAAu9opvQ
	(envelope-from <kvm+bounces-72437-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 00:11:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F29B11E661E
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 00:11:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2520A307A572
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 23:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30CA2328243;
	Mon,  2 Mar 2026 23:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JGugvCD9"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012022.outbound.protection.outlook.com [40.93.195.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448D73909A7;
	Mon,  2 Mar 2026 23:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772492960; cv=fail; b=i60DtTw118EUD+oo7MfxA+XjxLAT9bMVUO2iWpixDPeDw6IsohMXL34K3ohh7iql43OxWlf5s/2Oz2geXhrNYzmHr7veQik33/jP98zWVZG/8TpAY2h2LbhLX++vGCf1fGvfGFGPeqvujA+AsFG57BTm6UI6xzuY+ogrgPclxtY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772492960; c=relaxed/simple;
	bh=2bxvAiKZBjrVEkA3NS2z+AlgYPcjtfUVM2UqHttCbgA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PYqrCkYmpV1Y1v82vYr4w8nGCP0sWfAmYCYALT8MVKzXYUYkB5apIeoC5v1D+cYTYImrzg+AqXG7TkHoNjmW/0+xfYU7xD6cWE5OKc7UpWwyvYxj5IAMa5uig1cJ7hSA7MgJp4GARi/RAsquLljRNojO08UhjO+NVv1+PFrxW58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JGugvCD9; arc=fail smtp.client-ip=40.93.195.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SJ5eepwm2ApDONNkb5AlhgoqCH0nuOrjsnojK/KabZ3IJ0WIy1im4m60AgijC1SXWH2OXDdDayNC5AO2xSnTQ4zWZH4CyvOVMgsZhwdy1boHervXWc06NtKED1Xpjbay9wPZ0wIajb7eGK1FVxsXZAXu12XyNWoNSPSYxodlzemgJuUcmmu7YhGWDSEH6lj/MiMKMSBxY2Q9NdYU7mmEuDV6J6jsxltiO3REgpVXVmDQ59lvklur5a27HmLoWFyPyGrIOEYS6MiGW7559lNufcLEVW/e0vsGgs8xpw8IO6WS+XB1FN/7rIN575KOQhfciO342ZZVNWbqRfGWVogQqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fkRVPlXOcDaxKDEZLvHLvkfwuE3rljJsRgOGSwq+kV4=;
 b=fJGA2UArTgUnPA6GDZO7HEmCl2tyZys6x3fAfyspKy09dHjS42YKsljYMEU5JurHgQzFDDpMQZ9tNdlp+PGK+D5sUL8nCYr1mgd5WF17XB+E4MkKdjukL4ve9c/lEVd8ME3zNc1oql9zyLzdtqDuvk1ve/HHyOdRKCUkPYzQoNlFd7lZ1H48xRMBp5cWCbJNSV5m3D266H2PIEVxT9W994Gad7dDSCIHzmncm3exg9tWu8cn3yPjRFd9k/0AYrXhX5OqwZoSRcjOiZ9JzizbWzOFpL6S6VGEajPRKrloMyTD8gtTpl+Wfy8LbN1oiU02+lfBIC9oPvbxZVuAKEPFjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fkRVPlXOcDaxKDEZLvHLvkfwuE3rljJsRgOGSwq+kV4=;
 b=JGugvCD9K1jmhpdOO4AN0S920IFyJB/jwuFFCb/uAfxpIqeGIpkJuS+TzPC5LmZl6085Bp1P3B+bWBX0IS2HsJhEzl9OCVLhlyJp7f89TvaLKbO2EEV63naaHF68jmUNpQeQpknWiN8SsA13ucFiJAULg7i0XXxKdCJ6D3+rIs8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by BL1PR12MB5923.namprd12.prod.outlook.com (2603:10b6:208:39a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.19; Mon, 2 Mar
 2026 23:09:15 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%5]) with mapi id 15.20.9654.022; Mon, 2 Mar 2026
 23:09:15 +0000
Message-ID: <5e857228-4c1f-41aa-a03b-21ec401da434@amd.com>
Date: Mon, 2 Mar 2026 17:09:10 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/7] x86/sev: add support for RMPOPT instruction
To: Dave Hansen <dave.hansen@intel.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1772486459.git.ashish.kalra@amd.com>
 <8dc0198f1261f5ae4b16388fc1ffad5ddb3895f9.1772486459.git.ashish.kalra@amd.com>
 <a1701ab4-d80f-496c-bdb3-5d94d2d2f673@intel.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <a1701ab4-d80f-496c-bdb3-5d94d2d2f673@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR14CA0022.namprd14.prod.outlook.com
 (2603:10b6:610:60::32) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|BL1PR12MB5923:EE_
X-MS-Office365-Filtering-Correlation-Id: bf2c10a7-f4b3-4894-c51a-08de78b0b91a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	QhpQQ+Jl7TjBzHoWCRtHcefCLV3C2IRBdh774mWjE+j+dVgeKmcbULy0o9mg0GmJapiyV+MS5OQC5sFpvJ7FMqvyOjP20LbdvAuX1KxWVdni758l1R04Xbn48OuEvMwnlAax/OfD4K/ao6X7/jFao+KbqtUTlWSGE1L6DwOgcninTMFwk+1LBmGarU6YhVL+0ITsWyTFjKVywV/42ApbKh3OzNsm/nKD07CqRJSfSzVvlFBYCQYLJu6bOXz6hm6vBdH8HS3vPCh+8M9PnQl2eqWfQpezG4sTDI5mYl5Cg3BisrfRgagfYouXNShFBx6yHAe90nFdAgzgamtCQrtfdhbuNmBqrLQ/frOHk+JUqBD+G3BmDkI6CC1ihcDpchrnY20+n7iSOScspmi7Nkgdj6+0vm3tFCgT0+ncC58tDfehodZuVmEgmj6EWckShFcfWotCUeYYTtIeJ6dhuXTs5NuwClVfPoQcOQ1lwIbWP37Kv7Xs3yByyUTosrgI9Z7spRLhk4Jd/OPHPWSJCnbLE0l46kVC5++WKv5x1jf5SRFikWDsJRHccGL6HYyw0cVqBjuSwt3llSw/NPVmewdgYq0KwyCLcKoGL5StnbparKDleR4tms7kSTqA+yKsNiX+QoDkOJYPygQ8WlWFWNMh/udgkbZsxBOE4abrgT0g46YkACWWW8w0ruxlxzN511VHx+6sLnryyJGD5lxh02jzrg4R5FNjfEBnsuOxYP+73rUOExNbjUtZP4rzpowu1Svokf9vBnh50I3zFJNKCGMTUg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dGtka2J0RUZQSHJjcGlmYU5ucEVISGJxNko2N3ZEbTZmaUxMMVF5ZTZBSkRT?=
 =?utf-8?B?THVzVEFYNEQvK05WL1JaM2Q4VVR3SVhubWlQM0t4ZDlDUDNOL1dNamZoKzdz?=
 =?utf-8?B?U3VUZlRtZTNZY04vS0RhTGNtSVB2ZjF3SGwxS0VMNXFmc1M2NUJYb1UzWEhF?=
 =?utf-8?B?aWluM0I2Tkh4Q1RJTnRpbXF4MFY4SzZyS0lZQndyWW9POUtrMUdGQXpQaStF?=
 =?utf-8?B?VFYxN2pnQU54dGxpaDZPb012b1pzS0czdjcyNlNDTjI1d0x4L3BxaFZ3MjNo?=
 =?utf-8?B?VUZEVFZnNlltQzFUbXhrRUdBaGkzMVo3WEFlY2xHTGNmR3I0V3NndThpQXRB?=
 =?utf-8?B?T2hrRlBqS09ZUXovdSt1VFhLQkpYbzcxbFpQWE5xZjZuWG44ejNidzliaUdx?=
 =?utf-8?B?NnVVK2k5NEhZTmxMQjZUbWhvS213MXI1VUNRdDBsWEI2Q042N05vSURGNHNP?=
 =?utf-8?B?T096VGZWRURnejRLZDV5ZGZBQXovSnpNQ1VRWFVGODBlL2ZON2w1dGlFRXk1?=
 =?utf-8?B?Q2lpTHV5K25EeWZVbERXZ1FkZm4yVkd1Wlp0U3ZjSnRHNEp2VE95U293aWpn?=
 =?utf-8?B?MTZBV1hHbkZCam1NOTh5bEUyMFU5Rnd0WDd4R1JERGpDVWpZVm1hSDVpU20x?=
 =?utf-8?B?TTM1L2pWTll0ZHh0ZmhaNWZBQzdWV0JreDUyVFhCMzJaTUFwRDdiblpZck1h?=
 =?utf-8?B?RHRscmtvcUNEN0lwRHluUUwwb3JVdHFIL3FpeTM4aHRsSkpMVkNOQmtadUln?=
 =?utf-8?B?SG9LRGVaenRNbUVOYWlFTmpLcXNRSmF2TFlaVlZzRnFMaUZCMkxtSmlIRmt2?=
 =?utf-8?B?WGN4WTBQQ2puYitoV0pDNVV1TlpISXdCMGtjNjZvelFQOGVpSlYyRndkOUlu?=
 =?utf-8?B?UG5rVGFNL3Fma3QwMUtMaUR4b3VRNG44VlFwV0ZIbTlBUlNwWlg4MFRHKzZq?=
 =?utf-8?B?bFRDWlF4a1NUc3RvSnFBYjRWcEI5WklrTXhJb1BIMC9ZZ1BUMEJEUk5PWmJa?=
 =?utf-8?B?U2d5RTN0WXFhZlRjRTNqNzhVdUlSaWd6dTF0aVhUblFlbVpycXVDTERwdVhG?=
 =?utf-8?B?Z3JqczRqd0k2eHFGUnJ1U3JRUUZaZG5ONmtZN2RjaEJkcldTUXFBY0h0ZHRB?=
 =?utf-8?B?QlAyNm9RY0RHMEdXREtWbDNGMjdlZE4zK1FMa1lJdFFsZTVQR0pLMmpUQXJk?=
 =?utf-8?B?ODk5cGQ3ZWorMEN4cFA4bzVwZkx0SUxvT0phcDhaZEdjT1R0SVJSY3lIekZT?=
 =?utf-8?B?TklFcFEzSVhlWXp2V1VnbnFKVzhoQ0pXVThFSHk1KzFMT0NDZDNLQW0zTHpK?=
 =?utf-8?B?RzNacllMMVpwWlJ1bTNFUEpIRTNmTUR1T2dCMlo3R1J0cTNPQjcxRENQKzlu?=
 =?utf-8?B?TmNJRTJBNlpucjUrekcxVlFqcU5CNDVxY1R1RUpGcytVOU1XS1RwNlZOVFNw?=
 =?utf-8?B?ejNnbkJBdDlmaXpBRVZ5WWx1VncwczNFY2hNZ2N2TDV6VUMwMXdxRWxpUitT?=
 =?utf-8?B?L0FFQi9Ub2krWk5qZnQrT3QzcVRZamNPY2Fldy9FUkZCM0VJa0xmMGRJSExm?=
 =?utf-8?B?WFJOT0hpTytaYU5vRTFyNU9ORXFRZ1lBdUZJdUwzUUNlMU9STTdlNTF4c2xU?=
 =?utf-8?B?OTJQbG4xOXBvWENsUUJ6WDhSL0Fidk1KaGZ6TmpwajBRdHp6bmM1ZmNPSVgw?=
 =?utf-8?B?dGtKR0lEUWM4dCtQaWZWT2kyRnVDU2RQbnpuUkJoUWZNL3Ywcm45ZUlFQ2tx?=
 =?utf-8?B?VFBNNzhRVGg0VEVGaEY3MHhWRGU0dGxNQkpHbEJuTlB3VEI3Y3R6djQ5ZFhv?=
 =?utf-8?B?aXptR1RoT3A4bVJ4VlNReEJHMVBCMU5nY0tWZmNnNDlaeWNqT24rWnY1K2lT?=
 =?utf-8?B?aitwcUl3WGw3Q2xwTE1CY25wUXpEZkNreVNZOUVWc05manZRcVVLMElIaTRG?=
 =?utf-8?B?V05KMUQ3NW5TYW1ueGpnVlYyNkRjN3VpU01qSzViNC9Vd3dwdGg5UllFYjd3?=
 =?utf-8?B?SjVqRUpyRk5LcndxSVByYmpMZElkeXF6VWk3Y21yZjM4Zm81QUFjMUN5Rkdh?=
 =?utf-8?B?OURHN2dFaVgrREFMUVNpWnowRENCVDI2YzR2MjAvL0puZDk4ejNNeHVmUTBj?=
 =?utf-8?B?eS9GK1l1NzVieEYxNGo3UUtJelhVSVg5V3VBeExtUlhSUnNSWVRnK2xuOFVW?=
 =?utf-8?B?SGgvR2ttOGtZOHlVcENJVWZkZHExNlcyaXhCcnhuNmRjemMwZk1OOURZMGRy?=
 =?utf-8?B?K2dPUjJqZWw4TlZNUzBxRHA1WW96S1N0UmxDSWJiTS9ibGQwQW9La1ZHTUVu?=
 =?utf-8?B?aFZHZElnSDZYeWo3S3ZOVEpRNUZnR1NRczhZeVowRkp4b29FbHY3dz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf2c10a7-f4b3-4894-c51a-08de78b0b91a
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 23:09:15.1297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +hJThJy0hDfpkk7KBgpX50XuATzXhjbweBszkK8C/XT6+w388tDwOLAc0CluQrpp385keMWOhjBQi/gBnYH8kA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5923
X-Rspamd-Queue-Id: F29B11E661E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72437-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ashish.kalra@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:dkim,amd.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

Hello Dave,

On 3/2/2026 4:57 PM, Dave Hansen wrote:

>> +		set_current_state(TASK_INTERRUPTIBLE);
>> +		schedule();
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void rmpopt_all_physmem(void)
>> +{
>> +	if (rmpopt_task)
>> +		wake_up_process(rmpopt_task);
>> +}
> 
> Wait a sec, doesn't this just run all the time? It'll be doing an RMPOPT
> on some forever.

The rmpopt_kthread will be sleeping, till it is woken explicitly by wake_up_process() here.

When the schedule() function is called with the state as TASK_INTERRUPTIBLE or TASK_UNINTERRUPTIBLE,
an additional step is performed: the currently executing process is moved off the run queue before
another process is scheduled. The effect of this is the executing process goes to sleep,
as it no longer is on the run queue. Hence, it never is scheduled by the scheduler.

The thread would then be woken up by calling wake_up_process().

I believe, this is probably the simplest way of sleeping and waking in the kernel.

Thanks,
Ashish

