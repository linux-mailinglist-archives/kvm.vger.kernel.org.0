Return-Path: <kvm+bounces-68309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 31010D317B9
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 14:04:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 53CC03019E14
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 13:03:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5751D23ABA7;
	Fri, 16 Jan 2026 13:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="24REOR4r"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011040.outbound.protection.outlook.com [52.101.52.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A694238C0B
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 13:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768568598; cv=fail; b=Yy5hOCCOHyKORQ6IgMMCgjOJZQLZk7xtDCAIekCougVS1CKi9pNiXAB1/KdOJAGNcJriUk0m9rGsF2gRAwkdZb2n9svBNovkCWs4DZwQU4CkZmlCyHc05h2ZChgc/ChxaYOnSUrjK5EisE2MFPvNcW5GiuJnFPqT+aMfr2gdIp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768568598; c=relaxed/simple;
	bh=3A6awEmbCn5h7LdBIaBBRw2JNGvUjbsLgcWtJsepH2g=;
	h=MIME-Version:Content-Type:Date:Message-ID:CC:Subject:From:To:
	 References:In-Reply-To; b=SNYC5WCdRE6ND3ErNnjAGg6K+mcXsJI0i8Ol4XYJcWJfJQFMiszsQgwgxpEEtRV/SlSzFBxIQmToy9oom4hoGUVcF4oHCngJ/OWQe2LDzVBn4HGn3LxQWuaq0ajmEqAug2OTuNzlENzEF8WZCSHP4NO4ctxqTJqL2utMI8s9Hp8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=24REOR4r; arc=fail smtp.client-ip=52.101.52.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yHLTjSmHaLxe9Ezixlnenz7Mslqz7273rqeOs6i5DdX919vmPRvI8YfSuIeZzcdpLJlF5O7/zlfDtteEwkLJMfCnTxcOdMruu7quabsDzC/pa/gR/Qfxo+WngmaaxgchMRGvsXa4e+kaIVs6uLQVrUqD6+XkBeNov2ecvkQCPE3OVbgj+/j7AGa6BRyiKgIgy7nUbOCGf4Poel0vFKOVZSNBDWa8jRGJoi+1giRBwK7zBJCy3aTJPBEwX3VTka7mJMA07G+shiyeZ1gXK2iT8aBpYicJbIP0GLQ5eCW0tE+imIpSM8PDvudO6P3oziudMNM4HtwpQMtRI87vXLwglA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M7OTW3equF0VdtYQekl8p1NZeTDsJk7ItruNev2HoKY=;
 b=FTXPjnusWIzhXow2iX2mTc0zcMxS+m3JQdek3/dWvHXWDypvREtXl0pYJtgl7+GegAZM2Bwm8JOmwO4eW9+JmI0nP+l87gYWUxp7sdsn/iX+C8xr6FEaahx9hyTxKHsHteum9bP86ZAVLWBnbxC5SHIP7fVSurQQ7xatRJhEe8hME9V5iGfh90Tba1gqbkCEm+6t1khYhXQ5O6Lz7N8B8yeDJ/7XcOzNpiV4bIJSvXuROnyU6FiCQLSNdlr6pQ/99BPr6NpxkZGlO0Mu8bpT6QSL9F79LOLZwkGB1FA5tAL6TJcr9j1RoIkCMjDWVyV70WqwAAnoNNFFu+/IL+Tk4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M7OTW3equF0VdtYQekl8p1NZeTDsJk7ItruNev2HoKY=;
 b=24REOR4rZg5eUAuEjozWJDwCZ5rPtW7KZG/dE4CutJLlS/9pSICAvUOvR/FyodAzjs/drcfmq4WA9ga40GRnqwa/yqiVbc4zDUAMdGab2zkd8oKjoJh6sTPGGmbtYRs6nEEocD5TENEl761Dp5gyAlvaMZj9v94lK5/u6blhQhw=
Received: from BN0PR04CA0136.namprd04.prod.outlook.com (2603:10b6:408:ed::21)
 by CH2PR12MB9544.namprd12.prod.outlook.com (2603:10b6:610:280::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 13:03:12 +0000
Received: from BN1PEPF0000468C.namprd05.prod.outlook.com
 (2603:10b6:408:ed:cafe::a9) by BN0PR04CA0136.outlook.office365.com
 (2603:10b6:408:ed::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.7 via Frontend Transport; Fri,
 16 Jan 2026 13:03:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BN1PEPF0000468C.mail.protection.outlook.com (10.167.243.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Fri, 16 Jan 2026 13:03:11 +0000
Received: from localhost (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 16 Jan
 2026 07:03:10 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Jan 2026 14:03:02 +0100
Message-ID: <DFQ18MBL2M9G.24B0TSFEU8NZ1@amd.com>
CC: <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Yosry Ahmed
	<yosry.ahmed@linux.dev>, Kevin Cheng <chengkev@google.com>
Subject: Re: [kvm-unit-tests] x86: Add #PF test case for the SVM
 DecodeAssists feature
From: Alejandro Vallejo <alejandro.garciavallejo@amd.com>
To: Alejandro Vallejo <alejandro.garciavallejo@amd.com>, Sean Christopherson
	<seanjc@google.com>
X-Mailer: aerc 0.20.1
References: <20260115131739.25362-1-alejandro.garciavallejo@amd.com>
 <20260115164342.27736-1-alejandro.garciavallejo@amd.com>
 <aWky0xn4sG2dNryK@google.com> <DFQ160CKADCU.1FURW65OWRT1E@amd.com>
In-Reply-To: <DFQ160CKADCU.1FURW65OWRT1E@amd.com>
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb08.amd.com
 (10.181.42.217)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468C:EE_|CH2PR12MB9544:EE_
X-MS-Office365-Filtering-Correlation-Id: ec3a3aba-7c31-4160-6a8c-08de54ff9a59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Qzd0Sll2WHVQUURqcU9nTWVYM1J5WVBOTWNrbVJsdXNnV3hTME5tM3hBVW52?=
 =?utf-8?B?c2poQUZmRkQ4dVVPeWVsQ0hqRXkzTGxnYld1NmRnWk5sWE1tQklLTWFjUDlB?=
 =?utf-8?B?TTNVbGljZXdVR21RVWt6MGVjaUcraWw2V1ZsNDJtSUJTWWFlUlVLWDl5eFlS?=
 =?utf-8?B?Rk1sUER0UVJCT3JxOEFhVmNJaGM2NS9RK1FIZDNxMVFOeHVWVzlHZXkyTlJG?=
 =?utf-8?B?Vmc5T1M0czhEektsRHNGaEt5Z2QzNkVaaktQaEl3QWlOcUN5OWZYQ1BNQnJW?=
 =?utf-8?B?V1h1cEZPa21sbkFkT0xmbGtaVlR0TEllTDFhdm44dXoyQzNBWUJSSXRvQVN6?=
 =?utf-8?B?Z3ZKeVZkQXNBODgzSGl6Rjk5bHpzSTBZZGY1eGlHZXhiVm4wTkcrbjlCekgr?=
 =?utf-8?B?TG15VUVUWnpmb1ljcGZnd28vZ0M0dFRHT0dsSXhqME1tR2FyMzJESnJaVmFH?=
 =?utf-8?B?SUQ3QjNBb094cUN1eXhVMlArQ3hvaUw0cWxQU0FIN2hWRkc0R3Z1QU1yUTk5?=
 =?utf-8?B?RklLU0xEc1N2cjdGcm5lK29qcnlMVGx3UVpJczRDRm12VWp0RWdOV2pqVzhq?=
 =?utf-8?B?bXJGclZKc0ZjZVkzeWRtYTF6Ni9qbzhiMFB2a1VFaU1saHg2L1Q2TTdYZElF?=
 =?utf-8?B?RXZoTWNtR0VWcHZYaHZFaVJjczNrUXZTb0xiUHJ0U283cU5XcXFvcGtRS2Fp?=
 =?utf-8?B?SUU5UVhmZk4wWWJnVFEvalkzS2prYkhyWFVYZUZrTnNsdStQR3FEbkNNZDE5?=
 =?utf-8?B?SktoM0NrcGV5SnVqWloxOXpvN2lXYjJ5V0tLY0tYemJOVDJVSHdEV0ZpbU1p?=
 =?utf-8?B?QWhGeXRnNXM0UWVJb0xIcThWanFMQ04zQ0pPQVNtZFpPTyt0ZDM4RXhXZVIr?=
 =?utf-8?B?M2JEeThsQUQrNng2VEpwazU4ekN6YXVIbE5DdGtkaDNvOEY4TEttMTJGeXhh?=
 =?utf-8?B?WGhIUHpDTVJ2VE8xYnBnMFdyWkZlL1B0UVRzT3hRVUw4NHcwKzlwd21yUjBw?=
 =?utf-8?B?ei8rZW4ycWFxMHlEdm9HRFZNZEFZTTVncmpsVm1DZjdrQW5CSVhnN21pYkQ1?=
 =?utf-8?B?TWgxYUNDRXVmSE1nQ3hOMERNOEcvS212RjgrclVKWHNONjZpRFo5SmNxcEcw?=
 =?utf-8?B?a3R5RmZDNGRzaVRKWEFzNitUc3dKV0VMMnlmMmM0QTVsSmJ4Y3RwYU1IaVh1?=
 =?utf-8?B?VTl1em85M1dDTDJIZzJaR3A4OHV5QmpMUmlseWZDZDcwT2Fodlh3WVNuTjYx?=
 =?utf-8?B?a2ZNMW9XLzlIeWdEVzZUMlZVcEZTd0NzTmhqblpPc2FpdTI5amVUWDhTampa?=
 =?utf-8?B?WWpoTDRxMDNXY21YQmhEZGJWUU1TVGl3VEhMWWFQZHcvcGFPMGtuTXJNMGJv?=
 =?utf-8?B?M09FNStjWkdHdzBBa2UvUDFWSHdNbitYa09FMUc0NmxFNEtwaUlSeTl3TUM5?=
 =?utf-8?B?WTlwS2U4TGxnYzRJa25hSmMvZStleVNIbHM1QzRtYnpXNmNBZGdEODI5SnMz?=
 =?utf-8?B?MllBUjQxemJCV25sUU1EYjBUeTZMdWozdGNnRzUrdUVKeTdha1NGVEJVK3Qw?=
 =?utf-8?B?S25aTzF2U2c5NDZmL2tlU3Z1VjhhaXlrRWczK05KRk0zK29mSU41ZGcwbXA3?=
 =?utf-8?B?ZjVpTHJ1RlU5ZmR5M1BGMFlYdGNFYnp5OFMrRC9IaEkrRkhKQ00wS3hOWEM4?=
 =?utf-8?B?dXh0eUxjdjU1V0V2Y2VYZFZkc3FwUTRMSXNTdjE5RWhGYUpaV0l5V3c5dTBT?=
 =?utf-8?B?U0JwZWUvOXpybFBkRTNDTElMNnNKaFRZTVd4OXRGTVdxb1ZaV1dQU25ZNUtm?=
 =?utf-8?B?cjZqdnFtL1MwSXAxRlgvMHVENFBEUUNnRW9IWGpaVFBiYzN5ZWRDZEZ6Nlhy?=
 =?utf-8?B?aVRiNEtBaW5BZzR6d1Ywc0gxYVJIRldHQmNPQlRPTVU1dklvN3Rlak9JSlpa?=
 =?utf-8?B?cXM1RXJ6M1cwN2I2YWFXbnlhOU9uWkkxRE05c2JiRkg4ZUQ3N2JjSjE4cXFz?=
 =?utf-8?B?Z1RkbFEzRGJ0eDNtSDMzbGk2SjVxQTROSG9yZ3loQVlnMEQ2NDlCWDBoWGxJ?=
 =?utf-8?B?ZzBEL2NGNEMzUm1VbTRYN0paSTJXeVVUbWZ3WU1aU0ZWamRITHF3QjJXd3BB?=
 =?utf-8?B?WFg0NmJ1N0hINVVnajc5WlJ2VmhTZHRrVTQyUmhkY0duWlEvQWs4NXFxV0t2?=
 =?utf-8?B?UERmYmp5MURjeWo5K2RJKzZvLzhkcjFXZUMrWDJTREkzMGFkVzQwOUpkRnlG?=
 =?utf-8?B?K3FoSGh2YUhCUXVDYjBsa3BaT2NnPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 13:03:11.5697
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec3a3aba-7c31-4160-6a8c-08de54ff9a59
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9544

On Fri Jan 16, 2026 at 1:59 PM CET, Alejandro Vallejo wrote:
> I didn't mean fetch as in faulted instruction, but rather the CPU hitting=
 a
> missing PT as it fetches the 15 bytes of the codestream including and fol=
lowing
> the faulting instruction. That'd be...
>
>   opcode_pre:
>   mov ($not_present), %al /* #PF! */
>   not_present: /* page boundary */
>   int3; /* unmapped in the NPT */

self-correction: NPT or PT.

Cheers,
Alejandro

