Return-Path: <kvm+bounces-69207-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GLc3A+9YeGkNpgEAu9opvQ
	(envelope-from <kvm+bounces-69207-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 07:19:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 241F990579
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 07:19:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id F0E283008C83
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:19:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4851732A3FE;
	Tue, 27 Jan 2026 06:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NycfoDEq"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012042.outbound.protection.outlook.com [52.101.53.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DD21F3FED;
	Tue, 27 Jan 2026 06:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769494759; cv=fail; b=T7HnXdZ13ewUrGrzhWpIEKIqU07OrZDsNeP6LFbqhhqcdhfieqPZaMr/NCPSjR8DjGtTEuu6hPzq9JaO4RHCS08EO/jqwuBaaCjqfHgpwNgvaUOyh1hv1TJL1ZUhO27Can0qMOL/NA0Qx4CwY99jeLxUViRlHMxKV0sl3mCEVs0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769494759; c=relaxed/simple;
	bh=aENSTiRG3EiZHbnJyLc1UeuKFNWImFSDCXkE+dWynFs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=KR/Q3QtFd7gQ8BtlfRE92qXQ9vdvmYyIodZQNqvthYYHFlr7YClSpjiq+lyfIA8P+H91MdCdJFlyq7eEV9+RXY/uXbVsxalA95Hai8+cRGAkMewEyXw+26dJ9HbVYUzfBwDMP06FanQhvl1oR9Q9Vd7kWLTtRxB1Tbz7XnP2UbM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NycfoDEq; arc=fail smtp.client-ip=52.101.53.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kSwB2BACs9ehp/nv/7je/qpw2nfy8jSnVVEfDQZCQJ0/6qqIrqx8FCbcj68PMD0LhIy1o59H3L1YCbgbL6EZ/9wS5GUlKhDzv1cm7qpNJiDG//DZbnfFZ9iK8bGuArmnOfJr/lsRvPJ3x24ZWUd3pC9gbRIvQsa2iAouIGtKWsleSuCF22PEvsNI7FnWZEpY8Ze1LgL4Hdd8JVIQ1FBTMDWAgizmoq2ucHBxCzL6b/aDA2ji6aPFHfkUk64x4r9D80uDJanq99mJ9y6AW1byshzdHUej7AOcQvcG/QRnrUA+aEvLHcU2OPqX+KfG4NLB0ljZAKGQps2WeUihBRdlJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r1cKXjASM+WKk3hsz3ldmrWUWtgtQuc1+08oCDRjS78=;
 b=LHC/47ztyZG67ag1L6W1DJPFZZMNkA1dCcmEBZBx8B37xFntD28MaRltzk4B4UBVPx8fAVEoHUNx2R3k/aF+xDYRCKZsSelIyXbeEqTBiSgnLEnStmDvuFQeoRRrNW+vg+qn+7gUaJ00Cx5PnnKDm6YXiObBVL+uwBfrKy2TFiBxF7M6D88CEldaV7uzXu8id8d9ii13KOO8ORAWm3jq7NRo3lSs/5cGo3MAd9GhHlRvqq8jUBDpTEmXr4zfeAsl+Eyn/Yq1xI05ZQ7J5/0rp75dcgtfDtZmhFjWb5MnxbikVQD0kmGwf3JKe343TR9/8GYjBy7IN3XkjGxhbdEN6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r1cKXjASM+WKk3hsz3ldmrWUWtgtQuc1+08oCDRjS78=;
 b=NycfoDEqi2bLMTSBJao34goOJnj/elaCCkHbuG3NF9mCrnEim8brSTs2ucSKhBbmeCg1U+wcDrXHj5BvezGF5zuKdKGKtxf6vm4YBufhf1778zMeUwZSjfiiJuhMjA6DGRWI4lFaO83gQbaxSZCjcycJKljHXJwseb13jFR31GA=
Received: from BYAPR05CA0008.namprd05.prod.outlook.com (2603:10b6:a03:c0::21)
 by SN7PR12MB6839.namprd12.prod.outlook.com (2603:10b6:806:265::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 06:19:13 +0000
Received: from MWH0EPF000A672E.namprd04.prod.outlook.com
 (2603:10b6:a03:c0:cafe::58) by BYAPR05CA0008.outlook.office365.com
 (2603:10b6:a03:c0::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Tue,
 27 Jan 2026 06:19:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000A672E.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Tue, 27 Jan 2026 06:19:13 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Tue, 27 Jan
 2026 00:19:12 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 27 Jan
 2026 00:19:12 -0600
Received: from [10.136.47.140] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 27 Jan 2026 00:19:08 -0600
Message-ID: <80187820-8e0d-4b3a-87bf-fd7be238dd26@amd.com>
Date: Tue, 27 Jan 2026 11:49:07 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: SEV: IBPB-on-Entry guest support
To: Kim Phillips <kim.phillips@amd.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Borislav
 Petkov" <borislav.petkov@amd.com>, Borislav Petkov <bp@alien8.de>, Naveen Rao
	<naveen.rao@amd.com>, David Kaplan <david.kaplan@amd.com>,
	<stable@kernel.org>
References: <20260126224205.1442196-1-kim.phillips@amd.com>
 <20260126224205.1442196-2-kim.phillips@amd.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20260126224205.1442196-2-kim.phillips@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB04.amd.com: nikunj@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672E:EE_|SN7PR12MB6839:EE_
X-MS-Office365-Filtering-Correlation-Id: 73f3c29d-80e0-48f5-d0a6-08de5d6bfdae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y0V5ZVgyWVhKRCtOckZXVTI2Q2xCVXBWZ05nMk00dkpsVG1Yc0Q3eEhKVXh1?=
 =?utf-8?B?UmdPQ2pzTTZTMU91SlVhNkFMMnVuZkYxTFlCRHBDYjVsRyt1elVsRUFTT2tj?=
 =?utf-8?B?cmIwWTExUUFWaXVFS1RQdGxHL1ZtVGJvZzh2VDFwdGJMLzBZYUpTTFZQd1FH?=
 =?utf-8?B?U3h5QlcycDlxOHlwbXM1SGx6aTl0TDVqeTFEYloyVlZ4Smo2cWJ6bDB3dGZ3?=
 =?utf-8?B?UFZSbFhPaGdLM3dwZ2tqYk8wOU5GMTYrcHRnOWFGWTZIMmlGVkJ6YW10aVlm?=
 =?utf-8?B?RXI0d1djdkkycG5mSkx3ZW1ZdFRUWEVNMUMxbnZCTGY1VjlkSE8rOENPaEZh?=
 =?utf-8?B?TkwxdEhkMHFWTkdRcVhLblgyVDd3elV1RmdrYnprVk5iYTJ0NUV2cEdPc2V6?=
 =?utf-8?B?OHlRZmNYa3JUQ0hEN3BxQThmQ1FjVUdzelV6UkQ2cWNJZmxUdWd5WFFNVWlW?=
 =?utf-8?B?OHZmNjIvYzJUWmRNTXdBbjVDUXlKeXF1MjdhM0IzbzFOMmZBMTNLS2lpeHBL?=
 =?utf-8?B?aFdCQmZoVnpaUW9kS3Z0T3VnWUhNUlpKT1l2dkovVlZ2WE1DRUxNNzFPcVEx?=
 =?utf-8?B?OGJmNStCZG9rR0J4MHZNdWRlL0VhUE5nQktUN09DUkJnZmxyT2RLTVVIUWgz?=
 =?utf-8?B?akFzU3BLNllKK0NiWDY5aUw4MUNMb0N6cTZBcWJOcGQwS1I5UzAxNzFDYXp6?=
 =?utf-8?B?ZmgvWFR6T2NnTTU0RUpMZzV1WlIwUlZhdVpUQ1lRQm1aaUtVcEdhM0lraVBT?=
 =?utf-8?B?eGtzOW5xdWhVd0V6TTVSMWpjdG1xdytyajhJalpRd1JNOGx2bWJkZGtWYThW?=
 =?utf-8?B?TWIrcjlvQ2M4bUZwdjg4TFBQNjRVbWRBYnlSZVRYUFlUbGdsRTR3dlc1ZGhq?=
 =?utf-8?B?RWFrVloxemhUWi9RUSt3RTZSMXBsTHE1RlRpa1ovSGJvNnRieXJxblRZV2dK?=
 =?utf-8?B?UmljRUFZSmRSUzFNeTN5aHB0R2lKd1daU2pnclpGVTVuN1VJMHRYc0g2aFhY?=
 =?utf-8?B?aWV0dnFoMXVJNGRrWVZjZ3NnWnBrYi9LTjkwbkRVVi9YYWozMHVyZ29TSmpt?=
 =?utf-8?B?T1JPNDJuN0pVNTNlamk1N1NrZk5PRkEyRWk0R3crdE5wL1lCd3lienkzQmVI?=
 =?utf-8?B?empQYXJFd3RiSmlVRmJzOUN1ZzFpcTdZZ2c1RU9PLytEOFMvelhmak1DM2Vq?=
 =?utf-8?B?UnM0ZUFEMi9zTnovZjNYM1VPWXpXdXRLaUJwb2JoYmc2cjRrdmowb3l3Q1VX?=
 =?utf-8?B?RlZPbkN3UXJVaGZob0l4Y05uZVJRem9WZVVadDNqT0I5V1RId3hyOGp6WXhR?=
 =?utf-8?B?SUhBRFRybXNHQWxlbjFEU280Y0JxWUt6Y0ZsQ0VyeSsxblBYZE1RRnJidm9C?=
 =?utf-8?B?ZVFLVk9WaGN5UXh6VWcvTm1QNzZRR3R4ZmdIeUlOVmwvbFVOV1AvenNBVGdn?=
 =?utf-8?B?R3R1N3d0My9ySWd4L1doejdoMllhMXVia3RZWkR4OE1ub0Q5VkU3UWNiSlNm?=
 =?utf-8?B?OXg1MEc1eDJ5TjRFQ0txb2hVZmYvZUZPamU1V09JMTZoZ3lxclVVVFNCY25s?=
 =?utf-8?B?Y1E2YVY4NnFFU005NHJIMXRJZEd5TzJMRFRGZlJNUEhac1NtQksyb0ZLK1FX?=
 =?utf-8?B?NFRXeGp3V1JRUFBvVHEwWHVYQ1kwR1hScGtwbjFMQy9BVktaYzU3QTdZaUlK?=
 =?utf-8?B?bmRGWTY3aVRydGpzKzJkN09nR04rbXgxUkNHR2VscXh4T2F6TlJ3aWc1RFU3?=
 =?utf-8?B?NWdnYTBQcFNheWFEMlE4YjJSZzJpbWthOGp4V3craXdCY2UybFhCVENUUjla?=
 =?utf-8?B?MnJXODAxUmRaNDhlVDcrdXlLb2hlMTVXVjR5MXIyeGJaekt3Y2xpTGdmOGlC?=
 =?utf-8?B?Wk91WHZvRDBOSHZwNi9WZzFjZk1iaXBKQk05RnozTk9GOGZsK01BOG5kYS9L?=
 =?utf-8?B?bmM1d1FDMGMrbTFFcFE2T1NvL0l4VTVjU0tMeEY5ekZrTmVFNmV2WU5OaE9O?=
 =?utf-8?B?cThBNndCM3V3V3RrM0hiMUtsZENidzZ5ekRpVEtTZFo3TXpTdVBraytXWnZx?=
 =?utf-8?B?TmhqL0ZlOTRDUXFOTGRLRGt6U2JVbk9zNVM0bDVvdzg3VXJkRnhMVFNsRGQr?=
 =?utf-8?B?TkwwWHBmSUxtb1QveFovbGZDMGdiRmNxTXRhOFkzZmxaREEvMUJFRDBUdlVN?=
 =?utf-8?B?dVlFQVN5S2taZEZRZ0xLaUd5ZTZNU0h4eWszaTBKMk5ycVo5M1V5NjhtMHht?=
 =?utf-8?B?OVBjMk1xR1pETkk5MU5NczN4ZEtnPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 06:19:13.0836
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 73f3c29d-80e0-48f5-d0a6-08de5d6bfdae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6839
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69207-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,amd.com:email,amd.com:dkim,amd.com:mid,alien8.de:email];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nikunj@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 241F990579
X-Rspamd-Action: no action



On 1/27/2026 4:12 AM, Kim Phillips wrote:
>  KVM: SEV: IBPB-on-Entry guest support

The subject line should have the prefix "x86/sev" instead
of "KVM: SEV". The below subject line would be more appropriate:

x86/sev: Allow IBPB-on-Entry feature for SNP guests

> The SEV-SNP IBPB-on-Entry feature does not require a guest-side
> implementation. The feature was added in Zen5 h/w, after the first
> SNP Zen implementation, and thus was not accounted for when the
> initial set of SNP features were added to the kernel.
> 
> In its abundant precaution, commit 8c29f0165405 ("x86/sev: Add SEV-SNP
> guest feature negotiation support") included SEV_STATUS' IBPB-on-Entry
> bit as a reserved bit, thereby masking guests from using the feature.
> 
> Unmask the bit, to allow guests to take advantage of the feature on
> hypervisor kernel versions that support it: Amend the SEV_STATUS MSR
> SNP_RESERVED_MASK to exclude bit 23 (IbpbOnEntry).
> 
> Fixes: 8c29f0165405 ("x86/sev: Add SEV-SNP guest feature negotiation support")> Cc: Nikunj A Dadhania <nikunj@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> CC: Borislav Petkov (AMD) <bp@alien8.de>
> CC: Michael Roth <michael.roth@amd.com>
> Cc: stable@kernel.org
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>

Apart from the above comments:

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>

> ---
>  arch/x86/boot/compressed/sev.c   | 1 +
>  arch/x86/coco/sev/core.c         | 1 +
>  arch/x86/include/asm/msr-index.h | 5 ++++-
>  3 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
> index c8c1464b3a56..2b639703b8dd 100644
> --- a/arch/x86/boot/compressed/sev.c
> +++ b/arch/x86/boot/compressed/sev.c
> @@ -188,6 +188,7 @@ bool sev_es_check_ghcb_fault(unsigned long address)
>  				 MSR_AMD64_SNP_RESERVED_BIT13 |		\
>  				 MSR_AMD64_SNP_RESERVED_BIT15 |		\
>  				 MSR_AMD64_SNP_SECURE_AVIC |		\
> +				 MSR_AMD64_SNP_RESERVED_BITS19_22 |	\
>  				 MSR_AMD64_SNP_RESERVED_MASK)
>  
>  #ifdef CONFIG_AMD_SECURE_AVIC
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index 9ae3b11754e6..13f608117411 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -122,6 +122,7 @@ static const char * const sev_status_feat_names[] = {
>  	[MSR_AMD64_SNP_VMSA_REG_PROT_BIT]	= "VMSARegProt",
>  	[MSR_AMD64_SNP_SMT_PROT_BIT]		= "SMTProt",
>  	[MSR_AMD64_SNP_SECURE_AVIC_BIT]		= "SecureAVIC",
> +	[MSR_AMD64_SNP_IBPB_ON_ENTRY_BIT]	= "IBPBOnEntry",
>  };
>  
>  /*
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 4d3566bb1a93..9016a6b00bc7 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -735,7 +735,10 @@
>  #define MSR_AMD64_SNP_SMT_PROT		BIT_ULL(MSR_AMD64_SNP_SMT_PROT_BIT)
>  #define MSR_AMD64_SNP_SECURE_AVIC_BIT	18
>  #define MSR_AMD64_SNP_SECURE_AVIC	BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
> -#define MSR_AMD64_SNP_RESV_BIT		19
> +#define MSR_AMD64_SNP_RESERVED_BITS19_22 GENMASK_ULL(22, 19)
> +#define MSR_AMD64_SNP_IBPB_ON_ENTRY_BIT	23
> +#define MSR_AMD64_SNP_IBPB_ON_ENTRY	BIT_ULL(MSR_AMD64_SNP_IBPB_ON_ENTRY_BIT)
> +#define MSR_AMD64_SNP_RESV_BIT		24
>  #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
>  #define MSR_AMD64_SAVIC_CONTROL		0xc0010138
>  #define MSR_AMD64_SAVIC_EN_BIT		0


