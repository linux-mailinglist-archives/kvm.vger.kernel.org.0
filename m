Return-Path: <kvm+bounces-70312-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cBmSNPxbhGmn2gMAu9opvQ
	(envelope-from <kvm+bounces-70312-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 09:59:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 75884F02F1
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 09:59:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2EF6D3041BD7
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 08:54:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EDD436C5B7;
	Thu,  5 Feb 2026 08:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UHaiYIT+"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012031.outbound.protection.outlook.com [52.101.53.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF0E2BE053;
	Thu,  5 Feb 2026 08:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770281679; cv=fail; b=ucVGE6vibXN0qRWe6sfZucbIiJjq+MVijDNPC1EUpLSj2lMsUgJGolzv9pV2rCTWhszPw4DkUJFNAmR2uOz4XJNgs+1ThYq3xQfED9iojU7AuYdVjkKcK9ljbQDWZBOvUZ9aIQDYm/kto19YRKaTJfprzemi+qXXh00j6tLvj4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770281679; c=relaxed/simple;
	bh=WU0SFTY5hxSi3bnXL2XzOqkrO/g641ba3nFLowfZGSY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ZlnGjAUNoglBmUhiu7c0qmViPy0oSPODUgtDi1v4XP71a8OhPynzzSOo84Y/p55fYeHW0pUQT6yfv9pQ8Woy10wxoNuMVeubdOm3GNUrUJ+U5fo6YbHlE4VvGTF5evQqDtkRhLXQ7+y8u14E9ZSbOMnCUw1aXz4qUP780lkxF8A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UHaiYIT+; arc=fail smtp.client-ip=52.101.53.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EziKp4RvIvzj87RwLEX079WxsgVWTnWyJsx4BzZaUsuJgS8cTQeKUpfc9Jbt3W+0cnqnKLjrTmBVJmfOKfkPRvulgJ5eQuTdRqOzS7VZMwT/oQ+F6MrnUYuWtUhj9XQHbSeQ05EhkcFEzlc4G+5ZY5a6Ir946llzHelB/l7Dc52MdBkHp2bg9jU41+GYo25J9vmT/uRAxlsSHh5oQieMQ2YE3rfUCgSLgN+jil0QLWRoSh3zxCFtizYzlCZh9nnuQUiHRNgXL6vDfWY7qI1YpS0K+uDzUGsdrWUVFED9T3U4xBQoeKa5J1w8o/YHWhoj3kIyZTR41xAXp13fA/p0Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bP0pEK9KgIrPtKnPqcEhLwFL28sc/lGXmYaszFGx2Ps=;
 b=eOxtLc//bTGUtobXCXp6iuVC3cgNfHvY99Nupqq5vtib6j6x+tVL3Q0VwKPwdW/lKfFcMahJN8hbRvyIjxxGF6HaZS+Vx4mJFSuLE5mvDoONoRF4aghWdulSwwl9OuRv8wQEOPThPnXHTvGhmXRkFRFUa6VgIQ1ojYmEBwXXiz20qB2K8eNqoQ01oEqWdPlfmu2TLgH91Z9zybOPnCka+HKibWjoc1rcUG/9xoPilTURswBFI546nNLgYmZ0DdBt9GnR6IkG9/xufbjaU0KOnVnPWN0u6KByri389skrrV+Z0qgH7iptOhRYOhJdhtGe9FS+cDK8/ghOqrXMtRw8bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=zytor.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bP0pEK9KgIrPtKnPqcEhLwFL28sc/lGXmYaszFGx2Ps=;
 b=UHaiYIT+TBbY6rcR83HYd7jWKe/x7tu+iX7fhnMdauMFsLgIE2F6ms0WNxwdSVPN2DaEM1seuY4wOryZssfcQ6iKT28RWtXTF8XZqwJ/R1kxL5+RWr5jLfkHK+2hTgNkWbDe+LzgfohoCkL+HO/oPfBXhu3QErAK9/D3ZXtnAzw=
Received: from PH7PR17CA0032.namprd17.prod.outlook.com (2603:10b6:510:323::22)
 by BN7PPFED9549B84.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6e7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Thu, 5 Feb
 2026 08:54:34 +0000
Received: from SJ1PEPF000023D6.namprd21.prod.outlook.com
 (2603:10b6:510:323:cafe::74) by PH7PR17CA0032.outlook.office365.com
 (2603:10b6:510:323::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.16 via Frontend Transport; Thu,
 5 Feb 2026 08:54:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ1PEPF000023D6.mail.protection.outlook.com (10.167.244.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.0 via Frontend Transport; Thu, 5 Feb 2026 08:54:34 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 5 Feb
 2026 02:54:33 -0600
Received: from [172.31.177.37] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 5 Feb 2026 02:54:30 -0600
Message-ID: <41a68344-e2e1-42f3-82a9-1b88cd4ba4d7@amd.com>
Date: Thu, 5 Feb 2026 14:24:24 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests
To: Xin Li <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <bp@alien8.de>,
	<thomas.lendacky@amd.com>, <tglx@kernel.org>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <x86@kernel.org>, <jon.grimm@amd.com>,
	<stable@vger.kernel.org>
References: <20260205051030.1225975-1-nikunj@amd.com>
 <D313F34B-8463-4D48-B09C-07322D6808B0@zytor.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <D313F34B-8463-4D48-B09C-07322D6808B0@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D6:EE_|BN7PPFED9549B84:EE_
X-MS-Office365-Filtering-Correlation-Id: e2f446f5-f42b-4bf0-77c4-08de64942f6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RGxGb2FVcms1d3p5OWF6RnVIM3Z0WDQwQkFZdWlXZnVHNDU3eWkvVW51QU5y?=
 =?utf-8?B?OEljRm5vYkhheGFvWmUxMm1salBQWHREY1VlUkE1b1R6MjRtd05wUXBEOUdq?=
 =?utf-8?B?M29NVDBJOEJ2bjNZZ2ZpdWlUc0ZTUWo5OVY4ME9iV3lGNXdHT1NDVTJDQ1ZX?=
 =?utf-8?B?dXFXd05iNi9kWktEZ0xxbUhhV0FudW10eU50aGRxTEJiaGV0b0tKUElLZldF?=
 =?utf-8?B?WWVXUVo4VUNWL0ZQVWNSMkxia1ZZdmRpNTVwbmttMUw5OGlTampjRTZyMGlj?=
 =?utf-8?B?UC9Ud2w0cEhmVzZGVXZKbGFlUC9oVG5hYTRLay9mbDhyMTFzVlJaNkg5V2lx?=
 =?utf-8?B?a3VyRlhBUk8vTGx6dmg4ZHlaRXhXK0ZmNmEzUHlrRDh2MWw2ZERZNGkwWCs1?=
 =?utf-8?B?dnI3RDFNMFpvWVRjU2ZWWmVDSUdlK05RTS9pREx1YkU2aDZHcGY5VjBFTFRh?=
 =?utf-8?B?S2FsWjlYa3hvRGhZTSsxRnJJMWZNdUhiZ3ptMDRGNS96VTNXNERKZ2RYeW5k?=
 =?utf-8?B?aTFIZ0dtc3VNOUdMQ1hWak5XRjk1Tnk5dmtMZzVzMlVndDZuNXNjVWV5M05E?=
 =?utf-8?B?WGw0NStIZ2FFTi8zS2lVZ25Qa2FJM0hxVkM1ZnFVTkVpRHRCK0JIZ0lsaDR2?=
 =?utf-8?B?WHRtL015dXZuejBnMUltc3ZlWlJDV21Vb0lTeko3UnlYRDVoS2JZeHMrcE9w?=
 =?utf-8?B?eFp6dmtLOHQ3c3NrL29PeU4xajBxRVRzZDA3M09sb0hxc081OElWd2JCZmVZ?=
 =?utf-8?B?bEtkVXlPR0d0ek90by9jY0t2dW5yNHFoTjcvVW9GN2JsUTNzcFBsTlRRdTVw?=
 =?utf-8?B?YnFXeENTbm1LZ2tielVjb1ZEemFIOGFuL3FRS1MydS8vS1pFMFRWU0RTcnhy?=
 =?utf-8?B?SGJxRGUwbHNSaGN0M2NRd0M4K0oxZFR4TzVuSkFTREpnTHBvMXg1TGhTTFNn?=
 =?utf-8?B?RXNOZUhmSzc4Q0tyQnZiS3ZMaitPOG5UcDRmb2hGRVpPUElQcGJSUk43dHAw?=
 =?utf-8?B?d1h2Y05GeFIxdkdQa0VhOFhFRnc2alFVUXJyaFhnMkVTWjFhVDhkK0tmQlhD?=
 =?utf-8?B?d01xd1BpbWFwb0w1WFpvRUcyVWtVVERtYzQwK0JnUTdoOWhLUXhXKzgya2dh?=
 =?utf-8?B?YVVmeWRmaTVUT2JVR2x1OHhuOUJUU24rT0ZlTlJYQjNHTG1UL3BPWU1FRDJs?=
 =?utf-8?B?SkZVeS9zbERqTW9BbGRNR1hjc01ISDFTRmo5ZS9vN3RSR2hCSG5SQTl5cE1I?=
 =?utf-8?B?MHlEeU91Z0hjQlNtZzlwUnZEeHhFL0RDdmRubFhoVmJpMUJodmYwd09GMThn?=
 =?utf-8?B?R056dG9BZTdKaFJBTEtTOTBlUEpBcUhlcisrUHZrSHF2N1FvR3FYOU5rMHF2?=
 =?utf-8?B?cXpwVHBSR1l0YzkxdG9vU1grSWZjU3hsOS96b3ZqVDFydG5UbnQ5anhsU1gz?=
 =?utf-8?B?QmZuUnpoblV1THNKTmlIaWl4Z0pydkRzeS9kS0xHR2pGU1NzVHF5N0p2OUl1?=
 =?utf-8?B?bnlYMHM3czN5YW5mRWFpQzVSVTB3LzZMYmhjc0EyMElwMWRPeW1CaXVmYVU3?=
 =?utf-8?B?R3NwRXpCSVh5VnRadEp0KzdVN2I3ZysxamlxQzR6eGhnSzdxcDBTSG8wNExJ?=
 =?utf-8?B?Y0NpdG5IdGlMVmgweDdnSlV4S2VYY2hCZXQzeklXZzRvdTZPQ2h6c1M2aUVW?=
 =?utf-8?B?VVIxYnp3OGkvdW52UGljaGZtdWYyQ1hSOThxTnFsOHpPRWlmSHY4eXErSXFX?=
 =?utf-8?B?cG1ySDMwQ3dZRis4R3piZnV2MDVNVEVPVFgvdGtWVGRCcjJralYxU1k3WW05?=
 =?utf-8?B?aXNSNG85MXB3VlB5ZkRaU2NrWlNRd2NTM0RzZm1vam9HSnhEcFE0R1lwOHAr?=
 =?utf-8?B?RkhUOTRjSW1VSWdDUkQ2TEhOdW1MSEgxU1ZVK1dGNis1c0EyclBxVUd3am1U?=
 =?utf-8?B?WmZKNHFZQ2pXOFpDWWZrWDNEdXhDQUNzV1IxVVg3bGhVS0hyS2MwQUp1SC81?=
 =?utf-8?B?dGhHNWl5ZFpzdDBnd1pkeWVJcURwTG9GVlhrNllwbTRwdnlJWTJBT3lZeHh4?=
 =?utf-8?B?anBtWkFGY0MrcFB1eEdKeFhXaWg2aHZFZGNGMFE3TXZBanF0Zm1RNEQ2M3ZD?=
 =?utf-8?B?QzE5VGZNV3FFaGFkSVU5Zzh6Q0R0WDlwN3REbE5wUEd0R2grOFdoejhYaS8y?=
 =?utf-8?B?Zy9MbGEvdUhzQ1NJMUc4V2RRVFpKV3FnUStzcXBiK05ZMHBLRGRHc0lKRm5V?=
 =?utf-8?B?QVpxRHVlbXVIMTV1bU5aWjh3L1NRPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZBkpCgp5RUWsiqYeitZWA2Ur/tr7CImO6l8tkHH4EYG9CbsIsel0nGGInaqW2r6EC0p9R3Lv6GVHy4zQSiDvIGQz1AHSGO+qIohkNiWT+neJSw5VUpquNxIxtbHg8uFJyl/1ojF/h1lvzacOaFstl9zvbsa2USA8D0w3ksiFpyTLqIhtHlb2ZdIpUINklY2nBSTnOPLMY01enrVZy64B6RhVsNYbniwcXymuYjmnTTTlH0ICwwg1i32gDle+rtlm5ji7qoyN234sOxwyF4X3mhMJX8vwv9xQlbuv9tFFPDNM6js7lv3OI/4rxRFt1pfXuIPI6lcWc/tOXQ7Kzxk5lXLZs3g4mFoVsj/ZSi+7M+Ad5wLhXLOxea9QS5oUOZH5WZdx82qxkzxdHKC1e0p0XlIF/AYhaYvLUWbmnzMrm5kgJXiYmV2Ouokcu5ln7260
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 08:54:34.5525
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2f446f5-f42b-4bf0-77c4-08de64942f6a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D6.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPFED9549B84
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nikunj@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70312-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: 75884F02F1
X-Rspamd-Action: no action



On 2/5/2026 12:41 PM, Xin Li wrote:
>> On Feb 4, 2026, at 9:10 PM, Nikunj A Dadhania <nikunj@amd.com> wrote:

>>
>> * For secondary CPUs, FRED is enabled before setting up the FRED MSRs, and
>>  console output triggers a #VC which cannot be handled
> 
> Yes, this is a problem.  I ever looked into it for TDX, and had the following patch:
> 
> Can you please check if it works for you (#VC handler is set in the bringup IDT on AMD)?

Yes, this works as well. With your change that moves cr4_init(), I no longer
need my arch/x86/kernel/fred.c modification (moving pr_info() to avoid the #VC).
SEV-ES / SEV-SNP guests boot successfully with FRED enabled.

Are you planning to post this for inclusion?

Regards
Nikunj
 I 
> 
> 
>     x86/smp: Set up exception handling before cr4_init()
>     
>     The current AP boot sequence initializes CR4 before setting up
>     exception handling.  With FRED enabled, however, CR4.FRED is set
>     prior to initializing the FRED configuration MSRs, introducing a
>     brief window where a triple fault could occur.  This isn't
>     considered a problem, as the early boot code is carefully designed
>     to avoid triggering exceptions.  Moreover, if an exception does
>     occur at this stage, it's preferable for the CPU to triple fault
>     rather than risk a potential exploit.
>     
>     However, under TDX, printk() triggers a #VE, so any logging during
>     this small window results in a triple fault.
>     
>     Swap the order of cr4_init() and cpu_init_exception_handling(),
>     since cr4_init() only involves reading from and writing to CR4,
>     and setting up exception handling does not depend on any specific
>     CR4 bits being set (Arguably CR4.PAE, CR4.PSE and CR4.PGE are
>     related but they are already set before start_secondary() anyway).
>     
>     Notably, this triple fault can still occur before FRED is enabled,
>     while the bringup IDT is in use, since it lacks a #VE handler.
>     
>     BTW, on 32-bit systems, loading CR3 with swapper_pg_dir is moved
>     ahead of cr4_init(), which appears to be harmless.
>     
>     Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index eb289abece23..24497258c16b 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -231,13 +231,6 @@ static void ap_calibrate_delay(void)
>   */
>  static void notrace __noendbr start_secondary(void *unused)
>  {
> -	/*
> -	 * Don't put *anything* except direct CPU state initialization
> -	 * before cpu_init(), SMP booting is too fragile that we want to
> -	 * limit the things done here to the most necessary things.
> -	 */
> -	cr4_init();
> -
>  	/*
>  	 * 32-bit specific. 64-bit reaches this code with the correct page
>  	 * table established. Yet another historical divergence.
> @@ -248,8 +241,37 @@ static void notrace __noendbr start_secondary(void *unused)
>  		__flush_tlb_all();
>  	}
>  
> +	/*
> +	 * AP startup assembly code has setup the following before calling
> +	 * start_secondary() on 64-bit:
> +	 *
> +	 * 1) CS set to __KERNEL_CS.
> +	 * 2) CR3 switched to the init_top_pgt.
> +	 * 3) CR4.PAE, CR4.PSE and CR4.PGE are set.
> +	 * 4) GDT set to per-CPU gdt_page.
> +	 * 5) ALL data segments set to the NULL descriptor.
> +	 * 6) MSR_GS_BASE set to per-CPU offset.
> +	 * 7) IDT set to bringup IDT.
> +	 * 8) CR0 set to CR0_STATE.
> +	 *
> +	 * So it's ready to setup exception handling.
> +	 */
>  	cpu_init_exception_handling(false);
>  
> +	/*
> +	 * Ensure bits set in cr4_pinned_bits are set in CR4.
> +	 *
> +	 * cr4_pinned_bits is a subset of cr4_pinned_mask, which includes
> +	 * the following bits:
> +	 *         X86_CR4_SMEP
> +	 *         X86_CR4_SMAP
> +	 *         X86_CR4_UMIP
> +	 *         X86_CR4_FSGSBASE
> +	 *         X86_CR4_CET
> +	 *         X86_CR4_FRED
> +	 */
> +	cr4_init();
> +
>  	/*
>  	 * Load the microcode before reaching the AP alive synchronization
>  	 * point below so it is not part of the full per CPU serialized
> @@ -275,6 +297,11 @@ static void notrace __noendbr start_secondary(void *unused)
>  	 */
>  	cpuhp_ap_sync_alive();
>  
> +	/*
> +	 * Don't put *anything* except direct CPU state initialization
> +	 * before cpu_init(), SMP booting is too fragile that we want to
> +	 * limit the things done here to the most necessary things.
> +	 */
>  	cpu_init();
>  	fpu__init_cpu();
>  	rcutree_report_cpu_starting(raw_smp_processor_id());
> 


