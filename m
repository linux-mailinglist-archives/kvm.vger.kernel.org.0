Return-Path: <kvm+bounces-72557-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2PplA0Yhp2mMegAAu9opvQ
	(envelope-from <kvm+bounces-72557-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 18:58:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 781631F4E07
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 18:58:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A8F003054CAD
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 17:58:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 643FF3DA5AC;
	Tue,  3 Mar 2026 17:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="s8ePtdwy"
X-Original-To: kvm@vger.kernel.org
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011052.outbound.protection.outlook.com [52.101.57.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD74366577;
	Tue,  3 Mar 2026 17:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772560704; cv=fail; b=d/wa7SoezaSOqkO7hcnfFAmVxXQVvXBqzr2X/kMzbvTkvERD2O0K/7TmRSQ+mEFO9n5uWCnZQz4kA1Yhoo5N/Ed0E3Y6bl/JbDvgrozOpdMC3WaN6COJM3aFy6w1AqIBNwMmX43YGfS1yxyf1gRyqW4taPiO5DXLs36SIZX4m0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772560704; c=relaxed/simple;
	bh=QQi85/5YBrZLkzcY1MaYnLERlpTgRB5TpuDJjQ4tHto=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=tbx8AvoJi5siBGnt4t70r4axPtWT+uoXlnm7ECNxhASmt+3Xv5OYRrAXZVpZQZCcUmqSZeEvDkwBf9n39x2usIpmy3jO1Csp0QC2DadxbO169w0PJm68O3l8/Usc8CmdeqfqupjN7Y1+P5HT02ch7x2CYneorMBXne6RUWG107Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=s8ePtdwy; arc=fail smtp.client-ip=52.101.57.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KupgiNds0z2A53xlXBwPQSxAWsij3W0A5YBuDQrK5f+w2Xw0J55qCf5ezmpWqGjjKbRjNlHa32cwfWVTWMy+JdQEjMBKPgscXaQDKUH02ykLLRDMTNDmNt9l7qp8ACdMLHlF9xAlNx+sSEKIgOrhTJAOz4igNC7A4oYuYSkiIpjMnUviip7+otQf9FF4LcrIMkKfHk9EDFpIBDIQjT8ao/kkhRb3N45wYtDROxNC2XgxuWGsvefSr/xUeE7U11n8FxYe8OUALiCjS1/FKeeSv7WwV8MraCmFBoJ+CfpwubEz4J4Pe3+0rOob9+nxLJcvRO3mwlZKziz8t0yPnWUP/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kKkj4nfxIjaraB4Gwy22VWv8JxWjbGufiVM2AgRKUY8=;
 b=v0RFv5npe7A97W2RLu+XadgAUEtdjNTYlkqNnNpdASAAD2F+W96W+AlRDclRDdWMugUtsApNf9FQsNVFdgnY3kWG1jhq3tPP0RkX789FpaH+NI05upfHz/4yyInqLGYaEOj++fjK+RHDxLCAuRm5H7lx3RnmyDDyyLVggBsGZS5A9rKVHjxKjIGgnbW7QSZiI6IuI00AjcJL4mFGA0K/ifm+2nwQJ46sPdGlrE8hXUqxURq1nZURbXGLqTDp38yFLDnK+JyyAU2y209BIZQGZ/jVmZIRQyvKoDvVMIdFanQUrPxHkKFMNQHjF5mC5dwjAmois9b+y7Kff5YpvdIzHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKkj4nfxIjaraB4Gwy22VWv8JxWjbGufiVM2AgRKUY8=;
 b=s8ePtdwyCQl02DjqxOCguovRfM0bvwarKEe0IAaVx01yk2CKRJBZ2LIGMYNPWTkDMYzRIO7msXAmA6TACDHRewfw97FkdFC50Mkvuux2gAdpCnI6MW4Bar4iQmWOYtfFPCP5IFoY4w3wyCg7l8OUw++Cdv9UBJe/KjeHTEm4Cg8=
Received: from SJ0PR05CA0112.namprd05.prod.outlook.com (2603:10b6:a03:334::27)
 by SA1PR12MB6822.namprd12.prod.outlook.com (2603:10b6:806:25d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 17:58:17 +0000
Received: from SJ5PEPF000001ED.namprd05.prod.outlook.com
 (2603:10b6:a03:334:cafe::74) by SJ0PR05CA0112.outlook.office365.com
 (2603:10b6:a03:334::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.16 via Frontend Transport; Tue,
 3 Mar 2026 17:57:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001ED.mail.protection.outlook.com (10.167.242.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Tue, 3 Mar 2026 17:58:17 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 3 Mar
 2026 11:58:15 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 3 Mar
 2026 09:58:15 -0800
Received: from [10.143.199.149] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 3 Mar 2026 11:58:10 -0600
Message-ID: <53026eb8-3510-4bd4-8eaa-ec822ee28087@amd.com>
Date: Tue, 3 Mar 2026 23:28:09 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] KVM: SVM: Enable FRED support
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<xin@zytor.com>, <nikunj.dadhania@amd.com>, <santosh.shukla@amd.com>
References: <20260129063653.3553076-1-shivansh.dhiman@amd.com>
Content-Language: en-US
In-Reply-To: <20260129063653.3553076-1-shivansh.dhiman@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001ED:EE_|SA1PR12MB6822:EE_
X-MS-Office365-Filtering-Correlation-Id: f0b13811-64a9-4263-f762-08de794e72f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	aZ5eJn7kp3ba+w6Aq7epaeR1nINEEQddo9TwRzggni+awrWH5VHPsmat9fqKu3FtDFgUMUuL3QOnVNqsNFE11k/a5PQz18BB4u1p1XRLNz+I5P8ikUOphqKV6CpfA0Is4eFuLPTp8tLNSk+Q1ymobeCRmUDGQNhqbD3h7qovhpLlLXU3pOxjKV4JKH7IRUixkCNhWfFPm7w5erved3KKxnJbBXiTdJHayTAzgxyFdXjZixyzX6ogAMDkVlNwd47AkBE619kK2KD5jNPihkJkVPryUYxfLB8dTLpJHOLWusKo2KfT/atSPnA8XB81F0W4cHJeSyEWxHH5soALtY1DHqdh+5UXUnG8t2Kuk+w2sIXjMBHt1LSLJKjjAnOfKJFIdq5eQDo8buuQxtpKZ1GkyWIx8MeZ4W2F19Nqa3rZVwciKO6O3KxNF9BB1mbAwZHPM8vDkzjUPh0V5f8Zz4JkjLcq8uwfz10ZCtH+ofZ6Uy5jkTrhAlry693EXufKcx8kklpQmN+YbA9u8DaWEHqETIxSUuWBiGra2HMxA3Ge58tSatP7BNuXq7jX0V5TvxpCiW6UrOZ2liUUhGJKJis9korPoWe86sXpzbyEYb1aZ2OWRcoihBlUnM1nC+ksYPZ0W0u7Ndwc2eE9pgKCH15JKrDEATPMQ6gseum9vG8/Oq3S14FYHSISjHQYljxzsVnSgJxYY1+C4WW2EDfzkrOGGKdPXcsAXtcCRkpSX92HuMhC/sRSYxXUJLf6UWQhs1mqzqHtg+jVttVlHQ+ZInhr4egox9U+YkDYpodIEMtacXYGV2FPZOeyCrL6VTYec1VH3ptJbl/KG9vYYzgaX004Rw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	aC6i3Mt+YOxB46mUZyVjm6W9z0L5t4MBIHoeJulPdzVHES0N3pXzi4Eh++ARBo3T7ZlfsTz739TCHEzRVYs96I3ExPGMs7BMoFDH64YPPAveZx8gqzXqzu9p7dpcX00gKQc5wVV7Ix8sC0jNkuc/M7jCjixKURd4B66WdWknNgYKQzO/51sMBM+zX1G4khaAIgl00Z4Wb+M7Ma8y173/A1EfRTM/rf+W5rSq0TlgxvlqJt8KZwS0z7mW9BxVAWZzB2OraYtoY47+85VvdW5BDz8qj2GVe+hRXUNllyqOnSXH4WXp1BNceUZJIgUDEzVIcxqPMv0YLOVPyoiCqWdWWSk6o2RMkiOetZ55mWRLHB3yUltACxaf0xaiBIuE7gXvot1r+P2Zq3yvyZz1aUR3lWXgvLEGicC9PU8FdHxCJ6R6IRGFSdP0mzpNMULD/J8m
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 17:58:17.5498
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0b13811-64a9-4263-f762-08de794e72f3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001ED.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6822
X-Rspamd-Queue-Id: 781631F4E07
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_RCPT(0.00)[kvm];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[amd.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shivansh.dhiman@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-72557-lists,kvm=lfdr.de];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Action: no action

Hi everyone,

Gentle ping for reviewing patches on SVM support for FRED in this series.
Would appreciate any feedback or guidance on next steps.

Thanks,
Shivansh

On 29-01-2026 12:06, Shivansh Dhiman wrote:
> This series adds SVM support for FRED (Flexible Return and Event Delivery)
> virtualization in KVM.
> 
> FRED introduces simplified privilege level transitions to replace IDT-based
> event delivery and IRET returns, providing lower latency event handling while
> ensuring complete supervisor context on delivery and full user context on
> return. FRED defines event delivery for both ring 3->0 and ring 0->0
> transitions, and introduces ERETU for returning to ring 3 and ERETS for
> remaining in ring 0.
> 
> AMD hardware extends the VMCB to support FRED virtualization with dedicated
> save area fields for FRED MSRs (RSP0-3, SSP1-3, STKLVLS, CONFIG) and control
> fields for event injection data (EXITINTDATA, EVENTINJDATA).
> 
> The implementation spans seven patches. The important changes are:
> 
> 1) Extend VMCB structures with FRED fields mentioned above and disable MSR
>    interception for FRED-enabled guests to avoid unnecessary VM exits.
> 
> 2) Support for nested exceptions where we populate event injection data
>    when delivering exceptions like page faults and debug traps. 
> 
> This series is based on top of FRED support for VMX patchset [1],
> patches 1-17. The VMX patchset was rebased on top of v6.18.0 kernel.
> 
> [1] https://lore.kernel.org/kvm/20251026201911.505204-1-xin@zytor.com
> 
> Regards,
> Shivansh
> ---
> Neeraj Upadhyay (5):
>   KVM: SVM: Initialize FRED VMCB fields
>   KVM: SVM: Disable interception of FRED MSRs for FRED supported guests
>   KVM: SVM: Save restore FRED_RSP0 for FRED supported guests
>   KVM: SVM: Populate FRED event data on event injection
>   KVM: SVM: Support FRED nested exception injection
> 
> Shivansh Dhiman (2):
>   KVM: SVM: Dump FRED context in dump_vmcb()
>   KVM: SVM: Enable save/restore of FRED MSRs
> 
>  arch/x86/include/asm/svm.h |  35 ++++++++++-
>  arch/x86/kvm/svm/svm.c     | 116 +++++++++++++++++++++++++++++++++++--
>  2 files changed, 144 insertions(+), 7 deletions(-)
> 
> 
> base-commit: f76e83ecf6bce6d3793f828d92170b69e636f3c9


