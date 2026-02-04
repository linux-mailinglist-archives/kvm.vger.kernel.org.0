Return-Path: <kvm+bounces-70141-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iFWJEa7qgmnqewMAu9opvQ
	(envelope-from <kvm+bounces-70141-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 07:43:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D8418E2609
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 07:43:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AF0613033D32
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 06:43:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 688A238170E;
	Wed,  4 Feb 2026 06:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ck3fElwh"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013023.outbound.protection.outlook.com [40.93.196.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6423806D7
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 06:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770187430; cv=fail; b=bmHhf9GuIOYUuYtaKYR8A/ykUc6cDV61pqDXO+CcNk1cHNpdCFuYAkVgAWOag80s94/VXcsdlBtjfSVea2yoEHyWd3HKFgHVor9Cej+urbIAMJ4/2AAFK8VOAUXwLYWjlm+nsCUd4oLHNDtnRc5+61YwCtTNilFhbiO9LdbYgV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770187430; c=relaxed/simple;
	bh=oG/zhB1eANM/mXuqtzCivfpSZtDfvpkblR/MxXqB+XI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=oUR7D+EElSAiR8avPGU2+KdE0Kiw0raS/PxDRO4alkWjihwRv5a3iEYYW+76W6FqmuxG6haY9RlkgMVfdyLaeVArdO237tZI7/MDO8oT5V7hNGxHmVAJq9D5yI6YMFJ2pIzM6kuv9MA3P7SbZTMP1OzHYxMbyvY63ZH85jvJn1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ck3fElwh; arc=fail smtp.client-ip=40.93.196.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UCQhew36OycbVWEx8jD1kJGn0k3ZuV336bhmw3KdCmTsjaOjWows299nkm97cKaXyHR3W4feBRFktLwQDxlUlLugkm1NXcv9TSDODRcZPsymboE/Rb+yqn2q130HN8jInZHgvaKSX1m+eEaUzCengV4rGQkXlaMHHWSQS3eWhDjsNkUN3yIhMEexPMoKoNV0Sc/2P0JE3uOk0J/9e3T8jxjdbn8LiD8rH1sD+jBvVAZVbasV2fVvMtnihAKbL2EinHNYlPfcTBgGY1F5g30MhiIWKGLw2q8No8vBYVJD3bTAZFpBdU5dUQSx/bz328Kz2u3LErveicVN6mUqSRlyCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q84Dw3TRG0iPQ+PXqZLfz32/Qq+PK3xJ5HSF3IJzhQU=;
 b=JpUpM48esb5B8FIwoAlSa+2Kvt33lQwmmNh+5nsFiDRpVKBBnbdOvlOl47aZd+cZ/hIPpiHmUCQ+gpxlqLq7OtviClVk2Av8pWdB5dpzKk9KlLymyu7mqrWBR1gDZqzyeRxZs3q5dJc1Okbm6BB24sZlQub/S7hJz58Pyv93ySfb3CE1kxkzFuH60eKbPXRTPQ+hVvPt0l7f9uu4cRKNXnOACSu7qnFfOAGYLvAxla4NO7933leBnQZk3S+xWg4QY5uNNq5R14VFia+WNDjxLxfkbLSCElxtSMbTjZnRzf4SEUp1+bc1Mch1Q8LuAH9TgljSO70hHbkTqWPvQW7Lvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q84Dw3TRG0iPQ+PXqZLfz32/Qq+PK3xJ5HSF3IJzhQU=;
 b=Ck3fElwhnrccwfiChIh/aTAsAEuFoP6zoCU0BTE9owUIUFW44f0Pi0FNlHaD0pNW/ofWJUYdbfvHIDC2ZxO9yNkDf2h2mTesbxxZbqhGiQfU7bOZSyOYvJWG3rYObeoYTioh0/1hUG+bwPJ36FBSj2rMzOsaqHj0LWVa+E2zScg=
Received: from MN2PR18CA0012.namprd18.prod.outlook.com (2603:10b6:208:23c::17)
 by DS0PR12MB7559.namprd12.prod.outlook.com (2603:10b6:8:134::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Wed, 4 Feb
 2026 06:43:44 +0000
Received: from BL6PEPF00020E60.namprd04.prod.outlook.com
 (2603:10b6:208:23c:cafe::f8) by MN2PR18CA0012.outlook.office365.com
 (2603:10b6:208:23c::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.13 via Frontend Transport; Wed,
 4 Feb 2026 06:43:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL6PEPF00020E60.mail.protection.outlook.com (10.167.249.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Wed, 4 Feb 2026 06:43:44 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Wed, 4 Feb
 2026 00:43:43 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 4 Feb
 2026 00:43:43 -0600
Received: from [172.31.180.39] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 3 Feb 2026 22:43:40 -0800
Message-ID: <39e9b821-b841-4884-bbee-7f075c2377b1@amd.com>
Date: Wed, 4 Feb 2026 12:13:34 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Shivansh Dhiman <shdhiman@amd.com>
Subject: Re: [PATCH 1/5] i386: Implement CPUID 0x80000026
To: Zhao Liu <zhao1.liu@intel.com>
CC: <pbonzini@redhat.com>, <mtosatti@redhat.com>, <kvm@vger.kernel.org>,
	<qemu-devel@nongnu.org>, <seanjc@google.com>, <santosh.shukla@amd.com>,
	<nikunj.dadhania@amd.com>, <ravi.bangoria@amd.com>, <babu.moger@amd.com>
References: <20251121083452.429261-1-shivansh.dhiman@amd.com>
 <20251121083452.429261-2-shivansh.dhiman@amd.com>
 <aV4KVjjZXZSB5YGw@intel.com> <eb712000-bc67-468a-b691-097688233659@amd.com>
 <aWDEYEfB4va41+Tv@intel.com> <df23391a-599a-495b-a1b2-ed548215e2c5@amd.com>
 <aWSqUylwHmhIeBjq@intel.com>
Content-Language: en-US
In-Reply-To: <aWSqUylwHmhIeBjq@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB04.amd.com: shdhiman@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E60:EE_|DS0PR12MB7559:EE_
X-MS-Office365-Filtering-Correlation-Id: f299010a-c299-4bd7-6485-08de63b8bdb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aUlLeEVnQjl2c1IrTDRRaG1zelk1aWx6bTJid25pT0FBcTNZMVA1TGpUay9k?=
 =?utf-8?B?bkIvWGFDWUhSNUlFWk1ERXdWYWdvZE05bVhtVzVzNm5RS1YzckhmWHhKMUZZ?=
 =?utf-8?B?TSsvMEcxbTFyQjR6RXVFam1OTXZVWFFJMmYwSmZaZ3NaUU83NEdneTlRREpJ?=
 =?utf-8?B?Rm5BTFF1VitWTFJ5RUpacFJiMko5WWhuTjg1ckVXVDVUZTEvaUNKMlozeXpj?=
 =?utf-8?B?d0NlekJ4NkM0SDlRbWczMEx6VHl3bVBUZldTa3c0Uk1rS3ZsU1RhMzJyVERJ?=
 =?utf-8?B?QjhydzJMdVQyMEdDVW9kVFdnMkx2dUg2bExmdkZ1dzRZRVFTQmZra3RhSkQ1?=
 =?utf-8?B?THZkdm1raFZqZDdML3ZWaWtxNHJLM2dEUEhFV2NSTVVpUmFBY2lSN2kwY1VS?=
 =?utf-8?B?dTJ5ckhGOXg3cnJucTBTRmlHU2RzdFlDcDIyOFQ0TFhZemlDVVV6QUJyWUMy?=
 =?utf-8?B?RmNLajhObEFIdlNubVNYRzJOMmhQKzdyWXlUbUFnbDZDL1gvWGNyZEhJeDZz?=
 =?utf-8?B?dGY4RW5UMGJ1TEdVS0ZoeTU1RVpPTWMzakY2TWhnNkZ1WXgyU3JaUzZRanht?=
 =?utf-8?B?NTY4UnJ3aFQ5U2ZBbGc4VkJacDByd01mQmd5alpZVWtOTzhRZHF5d2trNWJy?=
 =?utf-8?B?NkhSU1RWOTFLRXNSUStERGR3aXRzOUFqb2hMWFdEWWMrVEcrM1VMb3RPc2Jy?=
 =?utf-8?B?emIvQjZOYWhiNWp3ZmhVVGVBNnpLVXErV20xS0hycEJ1Y0hSc0VNSGJIbEF1?=
 =?utf-8?B?Si9JSnpQMTlYdWtjdVZ2c2RHZlp2ckZzcHc0dE9keVArc2VqVDVBNmkvZXdT?=
 =?utf-8?B?a01BVWpQMGZYRG5HTTFEZ3pRYmJoajdWOVNFZjZMbC9PZTBJR1V6YW9vWVc4?=
 =?utf-8?B?WTNNRjV0MGRWam02clZ4MXBRNXJ3ekR3SVJKZTMxeWQyYis3Nm0wMC9BQ1Rz?=
 =?utf-8?B?TWJocGdRWTNlQ2Z2bm1sSmpiWk04TzBSbDVZSW9UVHhoS1MwN0pMVTBENkht?=
 =?utf-8?B?ZGZHUTFXWG0wWVEyRXcvTFhpYlVESDE4b0lKVjdqZnY0cWFMYVJQbFhoalZr?=
 =?utf-8?B?aVVMa2NVS3RzYzdKN2dOdVN0bk1uNGhYZnZqM0NubmhjbHJZT25NcVYrbjdN?=
 =?utf-8?B?MWRYcmlINm13SU00ZU9KSHBRQXRUR1RRenB2WlN1N3lOdGpWaEJFRER6WjRN?=
 =?utf-8?B?RnFZamhBOWN2MjRsQW1TelZQZ2N2ZDhBQVBITHBUellQMS9Xdm9IT1dBWG9C?=
 =?utf-8?B?ekFFbzhFLzBzVTN3Tyt3czlLN0MxQURzY2ZVSy92ZUNBZFVwTDZUSjI2Qmhn?=
 =?utf-8?B?Qkl0SU9Fd2tINkljU0J5OHFXREYwL0g0cWdUSlV3SXk5b1NoVDJUN2N4Sm1t?=
 =?utf-8?B?Uy9yeW9kZ1NZRWplNFJlMWxMNnUxMGJXZmJJZnFRanZZWExQR2U3RmNNMlhT?=
 =?utf-8?B?M3d5aVpYbkN0NVl6K1o4UVRuSFBOdmRyMW51L1JRSlNjODZGMENwYVdqbzdP?=
 =?utf-8?B?cWphaGNVOGNMRkVzaWtQRjdTbVQrdkc5elIrOU0rdis2TTUybkUweHpSQW5W?=
 =?utf-8?B?c3FlT3Q3cmlPR0RjeDZrb1ZJRnBTV3NJYlFDQU8zYWlyeXI4MmFEUnIvcFVi?=
 =?utf-8?B?cGZYdXE5R3l0Sk45NHdBQVdpcTdUaEttRVJBY0dQZFl2dVJGb1FuSzZIT2gz?=
 =?utf-8?B?b1RKeENuUEhaTm8xdzRsYUZ0TGRVZ1VTV2ZmdGZuUHBpRWwwVzNBb0JMRjhj?=
 =?utf-8?B?dzdSajhXOGhvOEZHM08yRFlqWExOTDRlcmZ0L1lWY2l6d1k4UVFrcERaQlli?=
 =?utf-8?B?QlVGazcwNDhEek9nR0tZZ21wdDhhT0VJQ0tCNC91ZVVkSGtBUmVXaGF3b1lj?=
 =?utf-8?B?WDQvVzdHUCtmQ1Rsa20yOUxsUFlYZ2xjK2txd0l5YzZDbmhtbGVkQmJRaFdY?=
 =?utf-8?B?VUpoNXIzNUZmSXQ4OUxaVEpDcGlJbXBYQjVQOHBaaVUzaHFwdXV0YWliWEJQ?=
 =?utf-8?B?Lzd5VVM3S1lpaDByd1ZrWmppekEvU21qVVNxWWxSN2lWU2hiazh2SEJ6ZnZY?=
 =?utf-8?B?N3Bxd2NEaHRON2paZS9acnRQNVh5Y280Z29oUVNnZ1JUNGtBb3RCVmprSEpP?=
 =?utf-8?B?K1lmSFFtSHNhRktEQkpVVGZkbUN3NHd5QWVmZEZteDhqdTJZeVZITmdYakJp?=
 =?utf-8?B?MnhSYlQ0K2hyR1BmczF3TVRzL2VtaEZNNWtaRksvaU5vQ1RydU9pc1psQXM2?=
 =?utf-8?B?Y3UySG9ZcGFSTXp0THQ2S3YrTXhnPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DniogoP3UDHyEJ2D/hppXuP2L0V0uIufnCoOnIS92HZ4VA3keoSFFpR92QhxzqpKh6mYhX5b0LSujJXQw3eoZG2jVrrzg8mlL7JQfYabiBjejs80Ur62FcWp8O2cCgVu6fIGmF2GGK88lDSpKxAFMARHJogdC72pYn7e6LANwMVmihAfYYd6fZG11BHNtITU+E9W7dv3B14kQV7NZVBYv7MKkBVbOoTqxOoFr0+kJkxGFpbQz9TxPY/Suw9QdcGiXtsFBREgAYrdwAC7FX/CraMthdcUBPDx9lB6gl02PHF5vTYOdgQj7KKVJ9L7FKFwtMFHsCKOFQDFWoB6n4ThTaoYLmU4Mt1+Gg9+05nOVoARl2FuGveU2wjaBvNqQNC0j2VwYwo6oU0l6pZXTvRq4nwmbcufd4rj5DJ5hw30od1fmz4J9TnCtg/zCY+JfQOw
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 06:43:44.0719
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f299010a-c299-4bd7-6485-08de63b8bdb6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E60.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7559
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70141-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[amd.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shdhiman@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: D8418E2609
X-Rspamd-Action: no action



On 12-01-2026 13:31, Zhao Liu wrote:
>>>> The current kernel doesn't have sensitivity to a level between L3 boundary and
>>>> socket. Also, most production systems in current AMD CPU landscape have CCD=CCX.
>>>> Only a handful of models feature CCD=2CCX, so this isn't an immediate pressing need.
>>>>
>>>> In QEMU's terminology, socket represents an actual socket and die represents the
>>>> L3 cache boundary. There is no intermediate level between them. Looking ahead,
>>>> when more granular topology information (like CCD) becomes necessary for VMs,
>>>> introducing a "diegroup" level would be the logical approach. This level would
>>>> fit naturally between die and socket, as its role cannot be fulfilled by
>>>> existing topology levels.
>>>
>>> With your nice clarification, I think this problem has become a bit easier.
>>>
>>> In fact, we can consider that CCD=CCX=die is currently the default
>>> assumption in QEMU. When future implementations require distinguishing between
>>> these CCD/CCX concepts, we can simply introduce an additional "smp.tiles" and
>>> map CCX to it. This may need a documentation or a compatibility option, but I
>>> believe these extra efforts are worthwhile.
>>>
>>> And "smp.tiles" means "how many tiles in a die", so I feel it's perfect
>>> to describe CCX.
>>
>> That indeed looks like a cleaner solution. However, I'm concerned about
>> retaining compatibility with existing "dies". But yeah, that's a task for a
>> later time.
> 
> Yes, it may be necessary to address some compatibility issues. But I think
> this way could align with the topology mapping of the Linux kernel as much
> as possible.

This sounds like a good idea. Thanks.

> 
> Thanks,
> Zhao



