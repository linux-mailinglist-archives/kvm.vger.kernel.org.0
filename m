Return-Path: <kvm+bounces-69210-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wBptCIJdeGljpgEAu9opvQ
	(envelope-from <kvm+bounces-69210-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 07:38:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 79F599072B
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 07:38:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 01ED43023515
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:38:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D815832ABCF;
	Tue, 27 Jan 2026 06:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aUEEQwNo"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011031.outbound.protection.outlook.com [52.101.52.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37A729B78F;
	Tue, 27 Jan 2026 06:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769495923; cv=fail; b=KlAohWTT43lQKgcpU9ByufaQAILX89gq8vusYxlQ1+nIFetS/3fQojHV4UPKtsPKfxFgOpxWbz5142hyo9wAo1JoluBT/6tk4R3xEf24Nw5xWHpjJhhPTG38I/XBzgM6UAUysJlFC+ZXcosCreOA3oroMLocaOGcGIDUYY+cxcE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769495923; c=relaxed/simple;
	bh=V1K0p9Pgigo72O8cUyf/ODP7REOqIhL1E6KOYEd5nk4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=buuAV6UhoUFj3NulXRvRMwyqZbP3biWntIH1flDjGT4FjqL0KjVybAxdl1Ld6tVYRBSt+efne2PYgCUX2PvNjIh4LfFfYmDTf033gsOXhpVYghGf7brBoqesUJcAEV6VFQBfy3mnqOq73xbO97CpusHKQiVREIXcY9ImPzM078o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aUEEQwNo; arc=fail smtp.client-ip=52.101.52.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YmBQnxw+xdOZcL60Z0Ab8NrtMjPnK2AdNswUb6O/4eIMqs6owUghUgfkdfFd5EbOoPmxsTLKg+mymVfdbmkiIANYmnbTizSM1CEZTmhESkekH9SJlnZRHgXJ0xl6mRWUzLdlPhXLV1pfHdtBNtPlEzw4vmV5UV6i3zqpUHAsI/hh6Jh5nWqdMbb8UqrBUVT0S9Wy+AMo8cPwfyZYrW2GhVuj12q/mnMV1oWZin7NiYK2cVY4HDOo60GjGvyFxDygoSxgC434+BLm++gJbydPNegWV0Li+FIFg4VEbvOUrP5wWIWFrpBzy2aVTNbjRCmtP7cPZL6py73ubQGgBoKnrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DxJ90ffQA8ADRYhg2KMWb6eJjaMSkmw/nAnM4il12L8=;
 b=cFwTRhzCzz1xThfZdTrhTUU2GnfhW7arKrk9ej0UnXKqvHIffP9Z3QDNe2Ai/0BZodu4PIESpYGrOh7IM0LwupirsLyVBmPihJgBg83T58zAenMMSsfgqutynvkVbo02M+ym7s5feeAhUrRqIbSsnetRsUrpS+/Pk9R+/HKwZQUySqYsTT2Ipzd63E75M6e+E/3W0aFWbJUWdn67lCcQnT2g0zokoQ9IFknPgCmxnvbUG/bCKTL7X1wiylyFjFf1EWxH+B3H08fH9zgPtCNXc9KI6MZWIjOal30Gb9zRF9AJVRLCQlZsMjM2qlaUvdek59u+5+Nub8U3o3rurODCuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DxJ90ffQA8ADRYhg2KMWb6eJjaMSkmw/nAnM4il12L8=;
 b=aUEEQwNoM+37qMroWAp7lJNBSiT4n7iOa4tthjpHzzgF97LQLxynpIiIu211eC4EyVusavl4t31WobC6wu1VzL82lFW94JIA3LNqp/6h1QAuN9JH78C28B2GKyP2XH7o4EaO8ijOXxxwo6MaVXQSP54TaodYzbw9F6eQ5Ar16xw=
Received: from CH5P220CA0022.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1ef::28)
 by BN5PR12MB9539.namprd12.prod.outlook.com (2603:10b6:408:2aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 06:38:37 +0000
Received: from CH1PEPF0000AD80.namprd04.prod.outlook.com
 (2603:10b6:610:1ef:cafe::f6) by CH5P220CA0022.outlook.office365.com
 (2603:10b6:610:1ef::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Tue,
 27 Jan 2026 06:38:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000AD80.mail.protection.outlook.com (10.167.244.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Tue, 27 Jan 2026 06:38:37 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 27 Jan
 2026 00:38:37 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 27 Jan
 2026 00:38:36 -0600
Received: from [10.136.47.140] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 27 Jan 2026 00:38:33 -0600
Message-ID: <4dea11f9-6034-489b-acaf-9a150818d1a1@amd.com>
Date: Tue, 27 Jan 2026 12:08:27 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: SEV: Add support for IBPB-on-Entry
To: Kim Phillips <kim.phillips@amd.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Borislav
 Petkov" <borislav.petkov@amd.com>, Borislav Petkov <bp@alien8.de>, Naveen Rao
	<naveen.rao@amd.com>, David Kaplan <david.kaplan@amd.com>
References: <20260126224205.1442196-1-kim.phillips@amd.com>
 <20260126224205.1442196-3-kim.phillips@amd.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20260126224205.1442196-3-kim.phillips@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD80:EE_|BN5PR12MB9539:EE_
X-MS-Office365-Filtering-Correlation-Id: e5b15392-39f3-4cfa-8870-08de5d6eb3b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cWVpV1prZHdZbGVzQ1U0eURyV2xGdWpnc3hhYXcxY3dLQjQ0Q2NYSTFiQTJj?=
 =?utf-8?B?Y3BQS1o4OTQ1QXBHV1hDU09hZHpGSnplRmJPSXJSRVpETFdIT01RWWZZOTFr?=
 =?utf-8?B?UXpodXFhQlVBdS9RNnRuZVZsTlFJSWg3OGlidTJkVlVrV1M0WG4weHI0cnRG?=
 =?utf-8?B?cTdIZzRqNktzZEhuU0dnZ05lMVk5NGZYRVNCS1ZHalVZL2M0YVdEUVdTV0ow?=
 =?utf-8?B?amU1Ylh6YmRTV3p5L3RiTkFzYnFFbkI4MnoxMFhPQWgxWUltaEw2VFlNY29W?=
 =?utf-8?B?bVZqQkswTFl2UXB2VHRva3VMWTJrTHZyak5JbC9WT1lDd1E5WW8rMDJsdUF2?=
 =?utf-8?B?S1lkNDltSW1CcUhHaWxJL0pwZFpyOFNDZWkrVDlOUXJENDJ0VENzOFl5SWQz?=
 =?utf-8?B?c0UvVnRBZzlyaEVKOVgzN0h0STFaa2RoQW9PWTA5ZjNnaDdTZEJ2TXl4UlVz?=
 =?utf-8?B?V3lQUnpMMUlmR1dhclIwOW5PWW9OTVBUODFFTnlaR1lxVGNoZU9IalhYQnNN?=
 =?utf-8?B?NmQwRHo4MnpRRk53eldJcE9Mc1crMHBTdjVHTTAzd3gwS04zUUdrRHZyY2Y1?=
 =?utf-8?B?Wkh5QkpLTGdUTjMwNkNaYjhhZStOaGErNTR4VGIrek93UkZFaWJZWVJpVGxv?=
 =?utf-8?B?Qy9aTjdXUEtTZmoxa3d2N0QyZWdyV3BkNUU4ZzFjQjQ2SmZPdmFwcU9uVzAx?=
 =?utf-8?B?bnRIb3RTNkhGd1k4Y2VreGlYWVFKWmxYVmVzcm9JMlVCN3N6amhieU1obGVa?=
 =?utf-8?B?dlpteWVSRWRicVZ5bFhJcW5HRlNocC9VWUo0VDZwSXZlb0UzVVNhOEh3MzhY?=
 =?utf-8?B?MThJZzRIRndkKzVUYlZBVWtTS3phUHBjYkRRUDdzUGYzOGZ0ZHBONHpUSzVS?=
 =?utf-8?B?QXNML2hCUzVzaEVtbnkrOS8zVEhheHBrVUJ0cjJ3NHVtbWR5MGlzaFlheEox?=
 =?utf-8?B?QWV6a25NNkpQRkZNRktiZDJJK25mQ1QxSGt2ajU5SnlFdW9lYWVuMDZPOS9G?=
 =?utf-8?B?UWNZRmJFV29XVStHYXJtbWRCcmh6cHF3UDNmandmNi9sZ3ZSMC9JaGEyOFN2?=
 =?utf-8?B?d3VydGxVQU9WMkZ6OHFZdUxjY1NLRUt5WUExTTI0NW4veDVkQVBYNEZvOENt?=
 =?utf-8?B?SE55Mkp0QThJYTRmZGZ4NTlsY1pUWXRkM29ETldoYnVZRjF3bHFPT3hnK1FH?=
 =?utf-8?B?c1N6cHFGT2Ixa3JlYXAvN3AwOEtkOUNTd0dRZGI2VlNUT0JJRW9iLzYvOEJ2?=
 =?utf-8?B?UW10UWRFUENaRzdYMU1IK2kxcWx5RFFsYXcya1V5b1hmRVZ0Y2dPOW9wdytW?=
 =?utf-8?B?Y3p5WW1Ib2Q5MmtnOXhiQmFhNUlnOHpzdFd5MkpzSnF1b0R5SjlRUTd6Wnhh?=
 =?utf-8?B?WExVYWtRRXhCa2szSUpEQ0dlWFJReHppQ0VLcE81Uk82L3JyYzR1V0c4dTZm?=
 =?utf-8?B?dDdrTFFlZmFBaDhPVVJnWjgyS1FVL2UwRXVDVjZoOUN5YW01S0RyREVEU25X?=
 =?utf-8?B?cjNuYnVtbVNmcWpzREh2NU4xNU5JazI2M0FST1RrMXl5VmY0NFA5bDltMllQ?=
 =?utf-8?B?UnhndjFiUXYvaGFSNDIxWjcwU09VNjhjMlUra1dMV1pnTW5YTStGcHkzZG5m?=
 =?utf-8?B?SDJXeDhRNVRvZ0pjK0ZVdzRNbUFtNnhmYW41YVY1emJld0xOVmgveUJwaDdH?=
 =?utf-8?B?cTlPZm53TDFKK2pERXhkR0RuOTBmbStZQ09JQStZZXhnbGlNMVoza0J6NVY1?=
 =?utf-8?B?Y1FtNnByM3ZiWkg0bngwZHdGRElmN09vaGhWa3kybVJKbkdoMjdYdVcySVlD?=
 =?utf-8?B?dlZCMnRjSlk2NU5aTnNCOUJFWThBOWE2WWZJNHNKRVBoSm9reU9LbFdaZWlx?=
 =?utf-8?B?S1F1bXU4R3ZEOFJpT2tUeXBMQkZtS1RxYzc5UDdUQjR1ejJoa1djNEo3QkVG?=
 =?utf-8?B?NUI0SnozY0gxMVR6c01ldjZ5WHpsWlBVSG56eklVQnNwUStEN0tFRWNmcXl3?=
 =?utf-8?B?a29BMWgraEpDcmFXclhwSUt6VmlQaWFweEJVZytaM1ExbnJNMFBxNjZGbnkz?=
 =?utf-8?B?eE10NWJxS0dXWTdZZzl0dm1wM3FaTTFPZCtvUjJ1RFB3eWFFVVF0MDJOK0Jo?=
 =?utf-8?B?bFY2NHhBWms3SkRnbjl6NFhXRmlXb21zbmVEYXZOTEs1UU1FekozeU1qcXFp?=
 =?utf-8?B?QWJpa0VuYVVNdG1kSmp4dGxvdWo0cmpxQVlBanpBNUo4dnE3cERQVWlpdVRs?=
 =?utf-8?B?NWIrNWRxU1RiVFd2K0dwS0xpOEJ3PT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 06:38:37.5175
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5b15392-39f3-4cfa-8870-08de5d6eb3b1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD80.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9539
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69210-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:email,amd.com:dkim,amd.com:mid];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nikunj@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 79F599072B
X-Rspamd-Action: no action



On 1/27/2026 4:12 AM, Kim Phillips wrote:
> AMD EPYC 5th generation and above processors support IBPB-on-Entry
> for SNP guests.  By invoking an Indirect Branch Prediction Barrier
> (IBPB) on VMRUN, old indirect branch predictions are prevented
> from influencing indirect branches within the guest.
> 
> SNP guests may choose to enable IBPB-on-Entry by setting
> SEV_FEATURES bit 21 (IbpbOnEntry).
> 
> Host support for IBPB on Entry is indicated by CPUID
> Fn8000_001F[IbpbOnEntry], bit 31.
> 
> If supported, indicate support for IBPB on Entry in
> sev_supported_vmsa_features bit 23 (IbpbOnEntry).
> 
> For more info, refer to page 615, Section 15.36.17 "Side-Channel
> Protection", AMD64 Architecture Programmer's Manual Volume 2: System
> Programming Part 2, Pub. 24593 Rev. 3.42 - March 2024 (see Link).
> 
> Link: https://bugzilla.kernel.org/attachment.cgi?id=306250
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/include/asm/svm.h         | 1 +
>  arch/x86/kvm/svm/sev.c             | 9 ++++++++-
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index c01fdde465de..3ce5dff36f78 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -459,6 +459,7 @@
>  #define X86_FEATURE_ALLOWED_SEV_FEATURES (19*32+27) /* Allowed SEV Features */
>  #define X86_FEATURE_SVSM		(19*32+28) /* "svsm" SVSM present */
>  #define X86_FEATURE_HV_INUSE_WR_ALLOWED	(19*32+30) /* Allow Write to in-use hypervisor-owned pages */
> +#define X86_FEATURE_IBPB_ON_ENTRY	(19*32+31) /* SEV-SNP IBPB on VM Entry */
>  
>  /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
>  #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* No Nested Data Breakpoints */
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index edde36097ddc..eebc65ec948f 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -306,6 +306,7 @@ static_assert((X2AVIC_4K_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AV
>  #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
>  #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
>  #define SVM_SEV_FEAT_SECURE_TSC				BIT(9)
> +#define SVM_SEV_FEAT_IBPB_ON_ENTRY			BIT(21)
>  
>  #define VMCB_ALLOWED_SEV_FEATURES_VALID			BIT_ULL(63)
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index ea515cf41168..8a6d25db0c00 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3165,8 +3165,15 @@ void __init sev_hardware_setup(void)
>  	    cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
>  
> -	if (sev_snp_enabled && tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
> +	if (!sev_snp_enabled)
> +		return;
> +	/* the following feature bit checks are SNP specific */
> +

The early return seems to split up the SNP features unnecessarily.

Keeping everything under `if (sev_snp_enabled)` is cleaner IMO - 
it's clear that these features belong together. Plus, when
someone adds the next SNP feature, they won't have to think about
whether it goes before or after the return. The comment about 
"SNP specific" features becomes redundant as well.

> +	if (tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
> +
> +	if (cpu_feature_enabled(X86_FEATURE_IBPB_ON_ENTRY))
> +		sev_supported_vmsa_features |= SVM_SEV_FEAT_IBPB_ON_ENTRY;

Regards,
Nikunj


