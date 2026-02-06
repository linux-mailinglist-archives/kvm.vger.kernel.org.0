Return-Path: <kvm+bounces-70437-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oP3oLc7ahWnfHQQAu9opvQ
	(envelope-from <kvm+bounces-70437-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 13:13:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 519FAFD7D8
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 13:13:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0FD6530338AD
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 12:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9034A3A640D;
	Fri,  6 Feb 2026 12:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QojIvC5/"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013061.outbound.protection.outlook.com [40.107.201.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83866309EE7;
	Fri,  6 Feb 2026 12:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770379932; cv=fail; b=udJkYBKKdWG5yN5aacrXJVKmFjhEfBgqQWZhwrZt1c6ODKJ8EonVCvSPGloX/xVlfehpxfN8k0RVj6pw0z5ubn0Mwhp04DP57aXs5WrEhp0GFI5lc5xk65UMQ9LbP5Zc9HbPn4zttYAMZwPSaOGZN8QMZ9e4g5CGYOvzPKMMgwA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770379932; c=relaxed/simple;
	bh=cxIwc/pbG4GTo0jl0c5om8PXGNuLwABfMbUy9rPf/Ho=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=lP3rBxai+7OQ8Nkc4Pl7iTyM3IvpoeG0WWXt/0C0MgPCYJtRQ4PBVy+vdKHLrUcS7JnGG8Hn17qOwSKTmtyIADZs01rX7vX7cr7ZIoI/v6V3XHPfnwdeJzydjELjA6N3KD3aiFEt239vsmXnq3jsegx+1KnCeCt6hbM65pkJ/kA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QojIvC5/; arc=fail smtp.client-ip=40.107.201.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M310aXfvv2J3scFkFXL3K4Ar4zwihejPm1KLVxvz3yD0sLlWwONcwhGd0InGbBc5FtZtqr28lbGt9AcGTgJFbkP3stfP8gtgdNFKO5OtVYqh8J+1AeFfpTPpaasFFPbnetH9yySMX4dVN16Gr58Z75g3didf3VyVtHsgVTP0mx66YZJ8OeOBCOOj95TNAtAIKTS8f79fv9FJUayX7OucfVdALXWOF7igSKaObJwzWeZoihlz20pf2KbhS1tjF+8olhHJgYa+ijlbm1aeqSGPYyKpubAhk5SUvDeKoUqPiKDU9u2j90MQedJfBjeYhU8Z1AGPbJZYD2wSD3fA6vcfSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kKmiaud5QvDCLJZ+xI/a2T7p7f2Fzy+IE5mceyUR4j8=;
 b=Ro3Ga4xx4wNeN7OexJ8jEZvd6Ky4UC840SizGj3RRdygtANFHDuk0GwFbls/UKYDZAhWmVc4dK+q1un2Yo453XGPeUlapWvfpICRpkO4/0CknJjZA6i3qdwa/E++2wXTiNV7Sus2iT3yTjr7fY2Vpoj5j+bL75ZzGghPBdSYNyQRPzQhdC+8x406Y8TNiZ84xSX7zP1S24u+Wr5+3i/Sg38qFtw18skn/SPkpNnwbTe1TCvfjwzbBvS8TL078kqrorZLR2MYogXVDkFqg8w74D+ZbiIkgCFP9KI/wktZvqZVlNXmweV0l7yZERVf7xPWFJ3/xh7HsFphzP09n4+yfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKmiaud5QvDCLJZ+xI/a2T7p7f2Fzy+IE5mceyUR4j8=;
 b=QojIvC5/K34R0Y0VsQJsLJoB4xBgQeNDNJ4V6kE/SfBUlxgCC/Jd/4bUTXchHeg0EmcpkaVBSnoEOljLSXPgCiJShdtpOoCZ/w/INtLApnI3gB0OG5XXO6qNzAhiykWE52Jeh6r+kHn5kYg0m1oumf/t4B1/L7solMuaIZjiyDE=
Received: from SA1P222CA0151.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c3::21)
 by SA3PR12MB8023.namprd12.prod.outlook.com (2603:10b6:806:320::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.16; Fri, 6 Feb
 2026 12:12:08 +0000
Received: from SA2PEPF00001508.namprd04.prod.outlook.com
 (2603:10b6:806:3c3:cafe::34) by SA1P222CA0151.outlook.office365.com
 (2603:10b6:806:3c3::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.15 via Frontend Transport; Fri,
 6 Feb 2026 12:12:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00001508.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Fri, 6 Feb 2026 12:12:07 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Fri, 6 Feb
 2026 06:12:05 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 6 Feb
 2026 06:12:05 -0600
Received: from [172.31.177.76] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Fri, 6 Feb 2026 06:12:01 -0600
Message-ID: <119df613-9138-4e90-8758-3142b4025fea@amd.com>
Date: Fri, 6 Feb 2026 17:42:00 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests
To: Dave Hansen <dave.hansen@intel.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <bp@alien8.de>, <thomas.lendacky@amd.com>
CC: <tglx@kernel.org>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <xin@zytor.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<x86@kernel.org>, <jon.grimm@amd.com>, <stable@vger.kernel.org>
References: <20260205051030.1225975-1-nikunj@amd.com>
 <9c8c2d69-5434-4416-ba37-897ce00e2b11@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <9c8c2d69-5434-4416-ba37-897ce00e2b11@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB04.amd.com: nikunj@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001508:EE_|SA3PR12MB8023:EE_
X-MS-Office365-Filtering-Correlation-Id: 20824e9b-ca76-4056-b7c3-08de6578f2c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MG4rWENTVnhHRmpZbWxsZE10U2I3eDdERTR4a2dYUkFUbC9Uem5GenFrWjla?=
 =?utf-8?B?ODNQMmxrRjd3WitnQ2Y2b0tIN2J4K2NDWFk3a2xoaktJWFdxMFJsa3gxTFZx?=
 =?utf-8?B?U0hXN3FPbzlNZnBmcDY1QzZDM2RXR3JPb3JFWVBZOURpYjc4ay9VMnhxVVRG?=
 =?utf-8?B?RURJRjllbDdYMlc0Uy9pQnBmNk5iYnhHN2VaVStpdHVVUkJ5ZHpRa3FxdUxn?=
 =?utf-8?B?RVByc1F1NWg4ZmxrUWxrWi91azdLUStiRVRmQm95T1FRbHZKRjkra3RIYVRy?=
 =?utf-8?B?OVduUW1kUjFMd3VoejhseHkzSk0vdTFLWmRFVnJiR1NCSWZuUWxuZ2NJVnBJ?=
 =?utf-8?B?U29qTnFxWlZuNENJM2ZxLzBISmZINmJZUXQxdjJKVE1KeVUrVS83cktibDBW?=
 =?utf-8?B?VjNsY1BaZE9sZEhycjlkemxwLy9OZ0hGa2ZLYjhlaENUMG9RU3U1MVBRdUJC?=
 =?utf-8?B?elA4ZjhpMEZGRnZYRzd4WjJsaDZFRi9ob0Z0WjBGbHRKdThjT2RKdzAvQzZy?=
 =?utf-8?B?cVQ5M3NZbmJtMXFUNWdkSWM5UkdjYVY5dGdKaDV0bmRyLzJPOWZiRzJmQmZK?=
 =?utf-8?B?S2R4aGVjMzI4SUwxeVc4VTVZVmd6Y0RlYUMydlhlWkRNZjRDeHc3bzlPaHEz?=
 =?utf-8?B?U0ZDN3FHa0xIYnU1WmxBMlpRaGZ4WG5xODZ1OEZlYkVtMlAvSEpyaHJMTGZP?=
 =?utf-8?B?NXV2TXNRNEdpRlUwRlhPb251UGVIUE1uSVBUZjhtZVBNTHNXY1JVSFVZY01B?=
 =?utf-8?B?bEszQXBjbWUxSWZXaVRxVUNGTjJEeVlyTmNlOTBZUjIxSDc5T2J4cGl3eUdq?=
 =?utf-8?B?NCtaaXlIbk5veE1pVU9uN3RxVTIyWHZyWERjQWlyR1ZsVnVPRnhxZ3hjQW5s?=
 =?utf-8?B?alpTd2RwbFJvdmVVc1JsSWpzVFdtb2gxeDhyQXVYOWpqZmpaTDBINXc3ai9X?=
 =?utf-8?B?NloyZy9DbzRLdE1kTkFaSTFUdGs4dndYWXhwS28zSWlhMjdaaEpPbHlybm9O?=
 =?utf-8?B?YUt3SkZrR0h1MWovUmVtUFo1YitUMWZHSVVYeitxbjloQmF4SUFSbElRajg2?=
 =?utf-8?B?eUpaNVdrOWExMkh4cEdUcGtSaVBIRlpqbTl1UUk3WnNSNWEyTnZ4ZDMyMEVp?=
 =?utf-8?B?RW5haEgyWWMvazl0YW9LdVZJL2kxaXZZVnhGVTFUa3JFcGJ0QmtwWCtHblhX?=
 =?utf-8?B?bExhTXJOMnVhbjdZMlAzeVA0NFFsYjVsT01Pb0tJUEoyT25YNG1tckpxSlcv?=
 =?utf-8?B?ZEozOHZ1M1Vqbk1DSW85Y0owL1BWam1hSXp2aXBYT1A1VWNQZlphUVhlUjdR?=
 =?utf-8?B?ajhQaE1sOGhuckxXaVZpTWJKRHREeVpiSkgreU84ejd5NjUzZDNlaUovZzZQ?=
 =?utf-8?B?S1RkV3FsUVVrb25GMGRXRU9VazR2N09ubXdNa0VBNmJ4ajJQR1R1cUFCdGdi?=
 =?utf-8?B?UHVEV3grMWlyQ0NFeGNGbEdlWEhyNy9FaHpsUGpVdm5STTA4dzhHenFGUWQy?=
 =?utf-8?B?VWtxZStNaFBaSEZtRFhCSDJDRmNTMVpWTGFRdlppUng5V0tqbDIwcmppVk9J?=
 =?utf-8?B?U2MyUUltanRSOEFDOGRjbW8wN2hYU3dvZE1UY1RVbjlzTUJ0aG9RYy9sQmtj?=
 =?utf-8?B?Rnd4S3J5R2VjaHNpaEMwRUVLYUo0bC8yZjlUNFRTcjY4dDZ5YVYvSC81bjd5?=
 =?utf-8?B?bm0yRnVYYXpBWUY1bi8wMlllQXBKN0JubnJLQi9NVFhyQWNUTzJ5SjFvWUM4?=
 =?utf-8?B?VXl6QTJXRExBN2o3bXluTzlTRHEzUXR5aHZqb2pab1hqOVZ5c0p0NGswSHRH?=
 =?utf-8?B?ZDh6bXVDV3RMMWs3Y2h4aVBCQWxVMjN1U282UThxd3pYM0ZRRUtUY05lUysz?=
 =?utf-8?B?QVBsNmZvcVFwcTB1aUFkaFhpT1ZYRE5Wbk1uMml0eG9vaTA5NTkzQW1nVXlw?=
 =?utf-8?B?NHFjeEREeVRxVS8zZW9UbjNxR1R1c2tmOXdER0hsMGVlek5BYmY2WHQyNmZh?=
 =?utf-8?B?dkQxYmIvQ1BJQlRPdWtoVnVwYmlFYjlMY2NRQytrR3AwZW14U3FHR1ZTb0JO?=
 =?utf-8?B?d2x3bG1nbWpjc2VyMTVobmJTdTNDSXF6RE1oNmpLTEEwVlZtWUdkVlk1SWNq?=
 =?utf-8?B?TXUvNzVNYWY2ejRTSkY3WXRRQm1LVk1NbGR1QmZKR2w3TU5nVlQ1ZDl6bDlh?=
 =?utf-8?B?b25LYzJlOGZvY0lSck10QTl2MU1XWERZSFk2YTlFa1hKVktSWFN5QytSMDRu?=
 =?utf-8?B?WFpzVmhEVUxtRlM5eGVma044enpBPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1V9Rk7vqkC+baOuwgV5uBfRMc3Gg2ctOdRyZAgj+ddr3lPLxoolODkkGSoXtTwcoxBTM5fBKAF+uB6MqItNknEpZRbpDwcZUQSegBr3BKr+UtkQxUJ99ejwyeaGTn3eWs9vQ5P5Fz+0LKKVxnuSLm3VKO4JteV3AtiXuNddHnTDXff6am2zpajZbSXB9kVf0DOTUYipH7KVh6VNUj4T0+u3dtGQabzDhOQYnsurHzckWMpQ7deOevfODj5LFHcUesHgiMCcJzeUdp46EVD9WYQV+7YMQQPhyd/Dv/qDtWwbUYCSDY8+P6voSDt9jowg9bQu6LUZGpTD4iSuXodj5BQpm13LLs+gYyvagM0b0BtixDvx4S32UX/DZkOfZGkPnvwg6JtWVY4emK6e3ae19lP1BL7wQCXQLbUZmm+9lGjnF7CtwBRtodXEySilupZ+h
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 12:12:07.6252
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20824e9b-ca76-4056-b7c3-08de6578f2c7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001508.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8023
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70437-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nikunj@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 519FAFD7D8
X-Rspamd-Action: no action



On 2/5/2026 9:40 PM, Dave Hansen wrote:
> On 2/4/26 21:10, Nikunj A Dadhania wrote:
> ...
>> --- a/arch/x86/entry/entry_fred.c
>> +++ b/arch/x86/entry/entry_fred.c
>> @@ -208,6 +208,11 @@ static noinstr void fred_hwexc(struct pt_regs *regs, unsigned long error_code)
>>  #ifdef CONFIG_X86_CET
>>  	case X86_TRAP_CP: return exc_control_protection(regs, error_code);
>>  #endif
>> +	case X86_TRAP_VC:
>> +		if (user_mode(regs))
>> +			return user_exc_vmm_communication(regs, error_code);
>> +		else
>> +			return kernel_exc_vmm_communication(regs, error_code);
>>  	default: return fred_bad_type(regs, error_code);
>>  	}
> 
> Please look at the code in the ~20 lines above this hunk. It has a nice,
> consistent form of:
> 
> 	case X86_TRAP_FOO: return exc_foo_action(...);
> 
> Could we keep that going, please?

There are couple of options, I will test and get back.

> Second, these functions are defined in arch/x86/coco/sev/vc-handle.c.
> That looks suspiciously like CONFIG_AMD_MEM_ENCRYPT code and not
> something that will compile everywhere. Also note the other features in
> the switch() block. See all the #ifdefs on those?
> 
> Have you compiled this?

Compiled and tested. I missed testing without CONFIG_AMD_MEM_ENCRYPT, will add.

Regards,
Nikunj

