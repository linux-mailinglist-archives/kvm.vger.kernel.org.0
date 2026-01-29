Return-Path: <kvm+bounces-69447-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UAWOOhGsemmv9AEAu9opvQ
	(envelope-from <kvm+bounces-69447-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:38:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6795BAA46D
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:38:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EE7BB301C946
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 00:38:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 793CE24CEEA;
	Thu, 29 Jan 2026 00:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bt7LIBkS"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010044.outbound.protection.outlook.com [52.101.61.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61990221F1F;
	Thu, 29 Jan 2026 00:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769647116; cv=fail; b=N4gYuPV8TjL/ts0+L1cKMrfo8TtYb35kAGFcub7CiKA5cqL4EQ7LtEykqu/yfxK1FQ/219E1B5QgbHRYpBtq2Bag0hmtpU6ncFpGNbYbXmGe5LBj0kF2EAGwvsmurPCJ0YzqQkCpxauK9+Zc4JCO0ZnCL2s6UpHe0E6Mu7SdGPU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769647116; c=relaxed/simple;
	bh=LJkgNDtEPuNSgZx4yg9XxGYZLTRCJBWDLZ1cx5WEsOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=dYsJ6ad6EE8cn7uJATAM7veUTDoB9riqIO8YbTss7EqIf/xVdO+jsKNvW7xZjkJBGgf5yrggZrw2ZpmVRjx53TmOtkpLxlnwns8T3dA2HfzkZhaN8imf9PcemP1zBA8B+3WJryxbpHDXjyVLWceR0MeijrMZuvpk+zjodLtg+jE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bt7LIBkS; arc=fail smtp.client-ip=52.101.61.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mi5BqwxwwcyxxTNvuLsilXEAvY6q6UZUUCgeh+oqgN9fdgJ+VJJvxOiEB38i1PMHIHFaLbZjS/Lm/DphN+zQuEc7W7CZVnD2nq7FbkcbX/RwxTt822dwLF1UXr4N8jnD/txRo2dvg66+9jK/nCo1kXICjRSLAQqL6ScG2stYHyyN3YpA/Xtrz7rOYae1zu9Kd86mWLtg/2guggc5xomvc8zeQ5SYiXuEqwCtiBT1V+1Mw8gLPOyDr3L+ksfXIWMtHsmGnSF90pBQwRKDXXCX6o2LElPRQhFhz+TOAvTguN2Qb4zInJ65QvYBXk4NPCqiTB/M6VJXDjT0U3RS5xvicw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+XlPEoeuKTVL3gUvX/JR4PAk0/STEHstYaZoxBTRBt0=;
 b=BjTxtQ5Ffg8ENYw/EIF45xe1fe53FtJIKR1N1EPCyxl8k6MsV0+G1jwDGwp6HXauzDqc3QIeMoUHHlicRc4ru0Wn0Cu4/DBrQVs9Y4WNKL3C8DRwpi+0GbOplcvrZBKFbY71hlYr+UTl8UfouOj9XAB2tZ30pazwH3eGmovOKawKhPJR+W71lvAAFe/fUzFIyXljvxHwKr4et/pBlaFASKZP1gCllm6xS91V5kGA6fz1Fyh6NUf1/gt52U1XYNjtyuG3SxlnhuAZMgmKg/Qo2llbNeDfgipqYuYQ2qHsC5orW+3F5TfC1x7v3SaTTq9mRtoVoj4H2jj3QeyREsTufg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+XlPEoeuKTVL3gUvX/JR4PAk0/STEHstYaZoxBTRBt0=;
 b=bt7LIBkSi1BCE2vMMwUxSbBjLwuV0lbLKwfpdffz2Cs2vPKnOKqVWrgD2KC3USRchtcX2z+KQK25yFzedqUDDhjq55zO9p2UzrFMrgGuSlgLzgyULnOOurmQF5Or62I+HVAlEVoW9AMZRFUdjzoQjKzqTJd8dL1YRKifYSOLT1k=
Received: from BY5PR16CA0027.namprd16.prod.outlook.com (2603:10b6:a03:1a0::40)
 by MW3PR12MB4460.namprd12.prod.outlook.com (2603:10b6:303:2f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 00:38:31 +0000
Received: from SJ1PEPF00002319.namprd03.prod.outlook.com
 (2603:10b6:a03:1a0:cafe::97) by BY5PR16CA0027.outlook.office365.com
 (2603:10b6:a03:1a0::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Thu,
 29 Jan 2026 00:38:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002319.mail.protection.outlook.com (10.167.242.229) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 29 Jan 2026 00:38:30 +0000
Received: from [10.236.30.53] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 28 Jan
 2026 18:38:29 -0600
Message-ID: <e7acf7ed-103b-46aa-a1f6-35bb6292d30f@amd.com>
Date: Wed, 28 Jan 2026 18:38:29 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: SEV: IBPB-on-Entry guest support
To: Borislav Petkov <bp@alien8.de>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <x86@kernel.org>, Sean Christopherson
	<seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, K Prateek Nayak
	<kprateek.nayak@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, Naveen Rao
	<naveen.rao@amd.com>, David Kaplan <david.kaplan@amd.com>,
	<stable@kernel.org>
References: <20260126224205.1442196-1-kim.phillips@amd.com>
 <20260126224205.1442196-2-kim.phillips@amd.com>
 <20260128192312.GQaXpiIL4YFmQB2LKL@fat_crate.local>
From: Kim Phillips <kim.phillips@amd.com>
Content-Language: en-US
In-Reply-To: <20260128192312.GQaXpiIL4YFmQB2LKL@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002319:EE_|MW3PR12MB4460:EE_
X-MS-Office365-Filtering-Correlation-Id: bbc3c3af-dfd0-4031-7f91-08de5eceb9fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q0hrdGZESGk2QXBnbHlRaXIrMzRlRDlqSGlUemE0ME5aNjg1UU9rRURYOXBI?=
 =?utf-8?B?N1Jjb2xqTDFuaEU0NnpXVk8wd0tHVWZOK1dKcmpuSWxMUnAxV0dFd2dWQTda?=
 =?utf-8?B?d1FwLzJhS1BwbDBJU1duS2VuZWJvZ1V0Qm8vUnJHdU5mcjRDQ0lrdmNFMHNn?=
 =?utf-8?B?WjNIVk5KMkR1T3FDSUFCb201UEYvVEE1MXJDckJwS0JTUDVFSjd2dTZSaW9q?=
 =?utf-8?B?ejhOTGd0MzQ5RmNyeHhFcHBCbXhMbk1VUGhpOVRoanlMbGFNNXY2cWFvQ2cr?=
 =?utf-8?B?Z3V4dVJ0Tm9pNGVxZGNsN0Z2Y0h3MHI5dGhDL0ZOL0F0dXdXOXRmZ2lKVkky?=
 =?utf-8?B?SG8yTmNyQjBER2h5V3BoMCtiaGZBeHplSDB2anlUNVBpNGFqZXpmSVZmZGE1?=
 =?utf-8?B?YnNkRFdOT1JHemtCNnFpaUkrK0g1cHhTVjlSNll4RzVDQWI1enlLK2xOVmNT?=
 =?utf-8?B?dERMSXBzS3JUMDBjT0xSamZKUDB1K1RmU2lST0MrczJjNkQzaXRJMzI1Y2FC?=
 =?utf-8?B?aFREam1TMWpvUFRsMTBabGRLWHRRcFpxSmNrdGtpUC9qdjhQUFhTUnpSTEJt?=
 =?utf-8?B?VVdLVUNsNmRLMUpOWUFRSFBnVUlSU1JtVEk2aUlBSUdjaTluVjBKOVpKb1h1?=
 =?utf-8?B?TGo0T2F5Nlphd1l2NTlxUjBxWmkvU1h2UUljUjNqeUpKRC9henZIM0xTTktW?=
 =?utf-8?B?RE01VnNrMUFaK3RSVm9RZ09NVDRraTVWZnJpbVh0TmcwdGN6amRyNUxCN3hN?=
 =?utf-8?B?K2VGeFBvSis2a2VNa1dKQnNGaEZGNy9FZGhpMlg1cDU3bFVaa1pTbWgvTk81?=
 =?utf-8?B?Q1Z0bVZiZHhoVTRZcHhqVFgvMXUwNWVoNEJRanVzZG5uWjR1TkxETVcvTWJS?=
 =?utf-8?B?enp0SWFmWW1RdTZXSlVFL1lrRFc3OVI0RWE5RFZKNHdHQmpqVjJsUWpHL2I4?=
 =?utf-8?B?QTh0WDU0TjNJbEdybkQ1RE9Nc3V4SkJqT2F3dXBnNThYT01KTnkxdE40VWFM?=
 =?utf-8?B?YWpSTVNxeXZ4Z0JjWW9RTlJuTWk0cUdvdnV0SnkyT0ZLME5PVkR4YWpvam9y?=
 =?utf-8?B?ZHBQYWlBeGI1b0piVUE1YnRrU0ZralU3Nzl6VFhpbXp6RTdZTDVzNnZHTm9m?=
 =?utf-8?B?YmJuTmhER1ZkVnh3YmMzQkF6K0MyOUJmNm1UR3F6NXBFODNDaUdHbDcwSUgy?=
 =?utf-8?B?bXJzUzI0QkxMOUdKTHJ1TWE0WnpweU9wMGtFNVFuL3BHU0ExU0hWbFZVTDMv?=
 =?utf-8?B?bTBtMXZoSXBFR2FBZFlJdDRoREFkMkJEOVJxaEhZblg1TTEwQk9FVmNqdTlk?=
 =?utf-8?B?NlFLa0ptckcxVm1Ha1B6aGNGSmZrY2Rtak84RjllT3F4dzl2QmhjamQ2UEt3?=
 =?utf-8?B?d3pXUS9XM0FrZ1gxbWdzcEFDRkptcCt5RjIvcWM4TVlHOHNmKytzYmh6OEJN?=
 =?utf-8?B?YThWdjlLd3lmdDNSRVYrRkdIeGpIWUpQWjcrQ0pBaEdoR0hTeWFVSjRpY294?=
 =?utf-8?B?dUxTanFHeDFmRS9sNjZxTUw0UGN0VUpmZ3JCdHJEZXlpaGpCcHcyTWFua1Vy?=
 =?utf-8?B?d25ta2YycjJnY0NVS05yYTdvdWxZZlFoQVEwb1djNDBJL3I2VlpZakZQSzh6?=
 =?utf-8?B?N1J3VFBaNTlMUnlkQXlXbnpDKzNrZ2YrZ0FaZkRCS0JleXFQMjdEYnpScDVs?=
 =?utf-8?B?bXppZkRXYTVaRUVmQkltazJMQVBWaEtoNnNUaDltVExZSzY0QUY3dWFKR3dX?=
 =?utf-8?B?Mm5ZNTVQSWFHUFlIN29ydklyYTFjT3JzUDBJdGFHTTJOZW9DQmljNjNxRHEw?=
 =?utf-8?B?SXJXY3M4a05FeE5taGJQaTNRaHVaYnhUcXZ5Z1RjMDUxVXhuSFBiaGZNalpU?=
 =?utf-8?B?a0lpc01abllrOThSY05uS1dVZVQvM2lzTnhnOEt3SUhIWU1qWVBEeUZBZSt0?=
 =?utf-8?B?QVVNTEE1Z3lOVlhvTFh0ai9ENW5FKzV5YWZFbHR5MFp0ZkcxRzd6TEdDUG1j?=
 =?utf-8?B?bDFhTkhRYm5iMFZmcm1DQzRvbmVQWjdTUFlnUGtBMlh0c2dKclBydDdBTzdy?=
 =?utf-8?B?U3ZsamtyeEpjL1o4QjBOWlYyM01wU3NRSmxZUTRZU0VoR1Jsb05aZVMxT2s0?=
 =?utf-8?B?UHEvZnZHaXV1K2NHNVRlRS9YakJrajNRdWxiN2JiN3E5aDhmZXR5TGp1Z3Iv?=
 =?utf-8?B?THdpUjlMOTRBQXpvYzg4Z05PZmI5bFdFT2dtKzlNZzhRMzJoTVJSWVFJb0ti?=
 =?utf-8?B?MVc2a2ltd0VSLzBubU51RWN6TjZBPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 00:38:30.8320
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bbc3c3af-dfd0-4031-7f91-08de5eceb9fa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002319.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4460
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69447-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,amd.com:dkim,amd.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kim.phillips@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 6795BAA46D
X-Rspamd-Action: no action

Hi Boris,

On 1/28/26 1:23 PM, Borislav Petkov wrote:
> On Mon, Jan 26, 2026 at 04:42:04PM -0600, Kim Phillips wrote:
>> The SEV-SNP IBPB-on-Entry feature does not require a guest-side
>> implementation. The feature was added in Zen5 h/w, after the first
>> SNP Zen implementation, and thus was not accounted for when the
>> initial set of SNP features were added to the kernel.
>>
>> In its abundant precaution, commit 8c29f0165405 ("x86/sev: Add SEV-SNP
>> guest feature negotiation support") included SEV_STATUS' IBPB-on-Entry
>> bit as a reserved bit, thereby masking guests from using the feature.
>>
>> Unmask the bit, to allow guests to take advantage of the feature on
>> hypervisor kernel versions that support it: Amend the SEV_STATUS MSR
>> SNP_RESERVED_MASK to exclude bit 23 (IbpbOnEntry).
> Do not explain what the patch does.

For that last paragraph, how about:

"Allow guests to make use of IBPB-on-Entry when supported by the
hypervisor, as the bit is now architecturally defined and safe to
expose."

?

>> Fixes: 8c29f0165405 ("x86/sev: Add SEV-SNP guest feature negotiation support")
>> Cc: Nikunj A Dadhania <nikunj@amd.com>
>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>> CC: Borislav Petkov (AMD) <bp@alien8.de>
>> CC: Michael Roth <michael.roth@amd.com>
>> Cc: stable@kernel.org
> I guess...

Hopefully a bitfield will be carved out for these
no-explicit-guest-implementation-required bits by hardware such that we
won't need to do this again.

>> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
>> index 4d3566bb1a93..9016a6b00bc7 100644
>> --- a/arch/x86/include/asm/msr-index.h
>> +++ b/arch/x86/include/asm/msr-index.h
>> @@ -735,7 +735,10 @@
>>   #define MSR_AMD64_SNP_SMT_PROT		BIT_ULL(MSR_AMD64_SNP_SMT_PROT_BIT)
>>   #define MSR_AMD64_SNP_SECURE_AVIC_BIT	18
>>   #define MSR_AMD64_SNP_SECURE_AVIC	BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
>> -#define MSR_AMD64_SNP_RESV_BIT		19
>> +#define MSR_AMD64_SNP_RESERVED_BITS19_22 GENMASK_ULL(22, 19)
>> +#define MSR_AMD64_SNP_IBPB_ON_ENTRY_BIT	23
>> +#define MSR_AMD64_SNP_IBPB_ON_ENTRY	BIT_ULL(MSR_AMD64_SNP_IBPB_ON_ENTRY_BIT)
> Why isn't this part of SNP_FEATURES_PRESENT?
>
> If this feature doesn't require guest-side support, then it is trivially
> present, no?

SNP_FEATURES_PRESENT is for the non-trivial variety: Its bits get set as
part of the patchseries that add the explicit guest support *code*.

I believe 'features' like PREVENT_HOST_IBS are similar in this regard.

>> +#define MSR_AMD64_SNP_RESV_BIT		24
>>   #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
>>   #define MSR_AMD64_SAVIC_CONTROL		0xc0010138
>>   #define MSR_AMD64_SAVIC_EN_BIT		0
>> -- 
> I guess this is a fix of sorts and I could take it in now once all review
> comments have been addressed...

Cool, thanks.

Kim

