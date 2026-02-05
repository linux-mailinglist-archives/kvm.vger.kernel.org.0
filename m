Return-Path: <kvm+bounces-70301-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SMFQKKY0hGnH0wMAu9opvQ
	(envelope-from <kvm+bounces-70301-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 07:11:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0361CEEF3F
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 07:11:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 69E8C3031CF1
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 06:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7655B3346AB;
	Thu,  5 Feb 2026 06:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="P/KxQNBz"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013041.outbound.protection.outlook.com [40.107.201.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D739338904;
	Thu,  5 Feb 2026 06:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770271826; cv=fail; b=O7EUKH+hY2EkNOJOXYjYHc/Ulr1MnJH0vSN/QvApwBiF29r1ooJxcU8kwcqP2DshyxYdpW0EUA1xI0ErBNLQgVAuZuHrB3OSnZ2kIHO38uOqqBsZ2RJpy4S/zS9WH30h932JemaUyjZfAXfGOnaxcuCSomgkTYLJ6mjsMqkXLAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770271826; c=relaxed/simple;
	bh=PieWIvyYBAxFRG2cS7HP/P5Tu3ksP8CgWXKZwP7QLKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Ikfewr+cbvFm3rCvLYYCUL7wVgeRFs82oV3cpXGYtAlwAuWv5/mnXP5ytQzG96Ri0k7p0nzMpJAb9uT1fGV0poFeBM6wBEESKdBUU4YGfxq550YcrhGY7yDsA+/C+Zg+fIHsN2jDL3Tvsyk0gTAeyt8Re7keq/xI5s9U7NMAcls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=P/KxQNBz; arc=fail smtp.client-ip=40.107.201.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AswGK79mkVKExtDxuyPsjl9QjMlRzxYzB5gW3yZ3ZAF41zyPMtwZ6kur0g+4Wkda8X/a4pIIQRLGTebwKcXjbU2d8KaRY4aNyj8yYyqcKCj6W66Ck2j0GeBoZaQDT4eXsy9PPzTsqhg/fQMsb/BdilgmHgN3flRRGXNiZ4WEpORz0oQCqZrOOsgzQOmluRj+UIt8W2b9Qsy3/i7daTP4pq1Db/OBDU+zcRCI7TTVZzyUNTB9bAmGdBC1iozy8nYn+ClmORrgYyopfgbaW7efRn3V3T2N8bz9WvdD4g/UWqH+oRpBza+J9aIl3Z+egaTVkG0UsuATut3atC+LjnbM4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UFkRX/6fgih4Gm79HvJUBnTnevhl/k34ffUdvyNdjL8=;
 b=BE8ikvq6a0Mx4MIqMKDA4HofLZuZqZ1vwxYx8l9Cj3rG0uthUQ1Sxqoq2kh09a+g5ZwRYQBsYGk2TnSYHM4WQF2KrTMHIgxr/jVLw9HvOqSMnLBWPb0twKwY0alSDK+95IQ9bynp9XJpKKl3wPdtFwAqTHWSLN4UaVTXqrDUfX0STffrTLTFLfySLLyUVZ6uzkTxMJP8/m4NJOBV3mBBbZwYWh5GYVh6nnv6+xDLjU3QiqlRd88LzgU9cwnySucc3fJvVIyIm90aZOHl6r9BKVUjxUv0kdne1bIkvu7ekKSC+r0gagaV2ysBP705KEGkUhSnmASElDEMhQ/8LzyJ/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UFkRX/6fgih4Gm79HvJUBnTnevhl/k34ffUdvyNdjL8=;
 b=P/KxQNBzuXa8Ltm4I4xDa1vHTlzSwtTkuPywR+R2GnH2Zet0c1hnktILENQ9ToflUfLPp3K5jkAStXoPusylXG1IX/xd3np/JMA5Kvymrtos7NmzNhO02Di48MN3K4T3prgpN/zaZrrt8NH9xZ4V48YTa3OBvloDARgkO7KhoP4=
Received: from DS7P220CA0006.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:1ca::10) by
 SA3PR12MB7903.namprd12.prod.outlook.com (2603:10b6:806:307::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Thu, 5 Feb
 2026 06:10:17 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:8:1ca:cafe::9) by DS7P220CA0006.outlook.office365.com
 (2603:10b6:8:1ca::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.14 via Frontend Transport; Thu,
 5 Feb 2026 06:10:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Thu, 5 Feb 2026 06:10:16 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 5 Feb
 2026 00:10:16 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 5 Feb
 2026 00:10:16 -0600
Received: from [172.31.177.37] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 5 Feb 2026 00:10:12 -0600
Message-ID: <59781811-a98b-4289-89e4-58e8247241f8@amd.com>
Date: Thu, 5 Feb 2026 11:40:11 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <bp@alien8.de>,
	<thomas.lendacky@amd.com>, <tglx@kernel.org>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <xin@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <x86@kernel.org>,
	<jon.grimm@amd.com>, <stable@vger.kernel.org>
References: <20260205051030.1225975-1-nikunj@amd.com>
 <2026020559-igloo-revolver-1442@gregkh>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <2026020559-igloo-revolver-1442@gregkh>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|SA3PR12MB7903:EE_
X-MS-Office365-Filtering-Correlation-Id: 726e7c6b-459d-4e0c-9804-08de647d3bbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dEgxR1N1elhMOVNIdDVxNW9IRHU5dFVvbUphNHFTa1ltNFJDSDZPdlpSTk9a?=
 =?utf-8?B?K0s1b3JnQnE0dE5vR3huRnBCVmhTKzJoRHhBRklZTVB4a2ZnUktsdFBDM0JD?=
 =?utf-8?B?c3I4VTNIYzFJUStCdTZDc2dkeEpxRnBzc3ErQ0Z1cXZOK1FqbDQ3KzI2V1Y3?=
 =?utf-8?B?UU5OTWRoS0JWYUZ2dlpCKzdiY2FuaDZNNkVmbnl3dWVSbm05Z3V3Y2xldTJp?=
 =?utf-8?B?VEUwMU93TjB1eWZFT1ZSdExvN242SnJnaDN5cFJSRklldWY4R0d5RU1IczhS?=
 =?utf-8?B?SU5QMnhnWnBJNjA4Vi9DeG1GLzhqT2xjcWtETi9KdjNwSGN6L0tKMW55V1JJ?=
 =?utf-8?B?UW9DRzVEeTR4NSt5eHpHYS9hZ2R0WXM5NXFHcnNUL0hiSUt6OWlqRUl5TWdI?=
 =?utf-8?B?clVJd1M1NU5uK2tsTmhyK2dZaExhYUlPTnRhdW9LSkNzSTZpUGkrQmY2amZM?=
 =?utf-8?B?Tzk4Q2VrVGVNTUdseDhZblZFY1FxRXg4bVNDOHhtNWtNK2dnRzd6ck5kR3Vi?=
 =?utf-8?B?M3pvWGU2SjE3d0NYQXZ3elBkRXRhTHVwTWs3WG1Ka1hub3Fjcjk3NE14VGFB?=
 =?utf-8?B?S1E2VUs5bE1jTHI3Vlp1T2loVW5kWW40c2I5TCtoUmhFb2RXSHpnZ2MwU1lD?=
 =?utf-8?B?aWljVlVhRFBZKy9KSSsza09EUzhkUmUvL210d3NiWlYwSTlEM2hjUEVYNmVC?=
 =?utf-8?B?T2tqT0Q1MmxnalBVQktacnNZYmpPMDZjVGdVK1lvSHlKbmNtelFRazNkUnNN?=
 =?utf-8?B?VmZaa1I5RGNqNG5saGhIVnd2emkwQTVvU2IzVmZLM0UweDdEbWJ0K3k5REtu?=
 =?utf-8?B?bkZNVFR6dzcvdWcreXk1WCs0R0ZUVHRtY3daOGpiT2xZVktqaEJ1N01wcE8z?=
 =?utf-8?B?QUlQUXVWUFc3Rks2em1sVE9qK05uUEZrbVJERkpLcXFmUWNOM2Vxa2dLMjh1?=
 =?utf-8?B?dWVxQkQzQytxWU5Pc3B5VmFIMEF1RjhmdWtSL2ozL0l4dUxhZkt1VUtvODFK?=
 =?utf-8?B?UkpwZTNLeEVoS1JhV1h6SEp1b3gwcVBOWlVPcmYrcWVCaHlMOERXMXZYZFo4?=
 =?utf-8?B?YjBoSE0zd0pXMW1BYlFCQWtkd0c1c2wzMGtDVHhoOWlpSWRMZkFoUXRxNkxF?=
 =?utf-8?B?bTd5N3JOR0V5R3dmWHVqNzIyVFdiT05IWklBSEFtRVd1TncwZDJja1dIQmk2?=
 =?utf-8?B?SjcrQXdzWXMzNnM1U3lDYmhrR0JSMHErc04zdDk2REYwWkdFbkhsMFZmWmN3?=
 =?utf-8?B?Q01SWkdmUHB6SmhpZ3pUQ3Bzd05kbXgrZmR4T1FIbEhGMEM4QjBXMlhBZHBu?=
 =?utf-8?B?b0dVa0VUeE1LSW14U1NMdVYxaUtRZ1FFUy8wUGpGYnhQSlpxYWR4cHY1NDBS?=
 =?utf-8?B?WlNUMWlPSnVpa3NtT0FSZzYyRUU5RWtEZTBKQ0tvK3R6S2krQ2NLSTJsTVdi?=
 =?utf-8?B?R3M2ZHFJM1lvd2h3UGgyb09KUVRuVVVOeGdPYUM1TkpheFdpV2tETDVNaXdz?=
 =?utf-8?B?OU54MEppblJpZS9WbFB6Mm1RTm5nak9INEhDK0xPRXBibHVHUFdkbzMxV0tS?=
 =?utf-8?B?NFdZa3ZJYmNNNkRuNllydXdMUy9WOExhRVNlQWtEOWgrL2VxbUFRaXFVeFVy?=
 =?utf-8?B?MXVvNWNidGpkTmd2aE9jMmZPRi9LczMyV1JPWDZVYmZ0dktTMEV1aE1qUmFz?=
 =?utf-8?B?eTN6UDllR25zOVgzOVZkQTNXSnlNMHFTOFc1V21ReHJ1RG41ZnA5ZDlvOWF1?=
 =?utf-8?B?Z29UaWl0Q0NWVjFtOW5PR0dDNEVmMnFydmRjVlZHRnFEU0pMbWRWQzNFOEo0?=
 =?utf-8?B?VjQ5ZElMdGZKUUFuUHBXYmEyc0RiK2NpSHh4R2Q1UytTRE1aeHB3d0VBVlE2?=
 =?utf-8?B?R3ZCZ2FGNGMxL2c4VHZxZXl1VkhJVGluVHhoUEluTmpyOTFYdjVQY3BYMFVP?=
 =?utf-8?B?R3hNVFFUdDV4Z1hPZWs0ODRweDI3WTJZZndhYnhZQUN4MHc2blpvdS82Uks1?=
 =?utf-8?B?RjdSOHlVdk0vL28wYUo0aGk2SkFJVXgwSXJnWEFkMi96c2RWSkkrZ2Q0Y3dC?=
 =?utf-8?B?dTdZY1lJSHplWW1xbk95VkNzRm5pRHdPaTV5S3piZTB0dDZZMlU4Yi8xUmNk?=
 =?utf-8?B?MVNvaHovNGQ0SDRBU0tRU2U1RUtZS0lXZ2h1R01kU1Q5aUR0d2FjbGwzY2xO?=
 =?utf-8?B?M3RlcGNvbE9UeEhoOVJTZE5lMnFISGVOL1VMYnprcHdTalpJNzdPU2hHMTBn?=
 =?utf-8?B?aFFEczZtM0FpbVNXK1JWaTNMQWF3PT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	C/gnirPmwcwvU80CvUNK8bjPMvDSpXt1YOSO9YD4suM6xght/6ScicjMjeaeTJDOUJmrG+kBF4Dv8eTCfrUmI7rLPH9UGDbiBcLvEo7FIC1YD2KsMN+qHtQqe1OPY4gszkeMMHmLXzzPmkcBKswU6sg9U9Eah+LbYTZMrirHXsG1q5rss5c9pM9PEzTO7ohvn6jazWkAjLWt813jPUtbZQvh93fv07yZwZ/SJJ4Zvmua46T0KCAWN65qxrpO8hbdDrG4byrpz/rrjffcfreq8oIJ8XWlK8xg3yGWf/lSBdkyoxmR9ugymh4kyAKVfHZrXPJMbzMS3G9VTpXVwEwbP8NG271CYzcbLrjbGS09QMKG92RFqlOnrpeGGhPPmQOmOYVg4wa6LFrSaWmBR6ROMaNa/wycjELlhEcO0Kv371udSENfIesjKbvO/wjhK6L/
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 06:10:16.8196
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 726e7c6b-459d-4e0c-9804-08de647d3bbc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7903
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70301-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nikunj@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 0361CEEF3F
X-Rspamd-Action: no action



On 2/5/2026 11:25 AM, Greg KH wrote:
> On Thu, Feb 05, 2026 at 05:10:30AM +0000, Nikunj A Dadhania wrote:
>> FRED enabled SEV-ES and SNP guests fail to boot due to the following
>> issues in the early boot sequence:
>>
>> * FRED does not have a #VC exception handler in the dispatch logic
>>
>> * For secondary CPUs, FRED is enabled before setting up the FRED MSRs, and
>>   console output triggers a #VC which cannot be handled
>>
>> * Early FRED #VC exceptions should use boot_ghcb until per-CPU GHCBs are
>>   initialized
>>
>> Fix these issues to ensure SEV-ES/SNP guests can handle #VC exceptions
>> correctly during early boot when FRED is enabled.
>>
>> Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code")
>> Cc: stable@vger.kernel.org # 6.9+
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>
>> Reason to add stable tag:
>>
>> With FRED support for SVM here 
>> https://lore.kernel.org/kvm/20260129063653.3553076-1-shivansh.dhiman@amd.com,
>> SVM and SEV guests running 6.9 and later kernels will support FRED.
>> However, *SEV-ES and SNP guests cannot support FRED* and will fail to boot
>> with the following error:
>>
>>     [    0.005144] Using GB pages for direct mapping
>>     [    0.008402] Initialize FRED on CPU0
>>     qemu-system-x86_64: cpus are not resettable, terminating
>>
>> Three problems were identified as detailed in the commit message above and
>> is fixed with this patch.
>>
>> I would like the patch to be backported to the LTS kernels (6.12 and 6.18) to
>> ensure SEV-ES and SNP guests running these stable kernel versions can boot
>> with FRED enabled on FRED-enabled hypervisors.
> 
> That sounds like new hardware support, if you really want that, why not
> just use newer kernel versions with this fix in it?  Obviously no one is
> running those kernels on that hardware today, so this isn't a regression :)

Fair point.

However, the situation is a bit nuanced: FRED hardware is available now, and
users running current stable kernels as guests will encounter boot
failures when the hypervisor is updated to support FRED. While not a traditional
regression, it creates a compatibility gap where stable guest kernels cannot run
on updated hypervisors.

Other option would be to disable FRED for SEV-ES and SNP guest in stable kernel.

Regards
Nikunj

