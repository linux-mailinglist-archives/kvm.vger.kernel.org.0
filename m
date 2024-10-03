Return-Path: <kvm+bounces-27870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 87B6998F99A
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 00:10:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B6621F23793
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 22:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 072581C9B71;
	Thu,  3 Oct 2024 22:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vLRSU3VW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2051.outbound.protection.outlook.com [40.107.236.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D951C4606;
	Thu,  3 Oct 2024 22:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727993418; cv=fail; b=hq78eAVkGpBPBAweQoVXYx069Dm0eEfOVTvkdGvC1u8niSIUR2KALIzifQZgl9p02U99NXIdkyl6r7JHUObYitmB/wiWAqgchN2M4M4aFLYoXe+OGbDhJPykarDRI6pPXlVl0VVynpSb7BZGlhz1IjaqxgfT8HoG2S3F7LgWdoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727993418; c=relaxed/simple;
	bh=7samLhwa3tWBlDkvtssC7qDm2+AZBO5wifmzwWlynFY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TreSJGKAV3zAgQkwAv7TPE4dg945WMFip1zZvLIiat8jqD4reohDX25N3JhLOpQHdNcIU6tZr1gRL0JcdI8XqJF9o65ZTs+P3oEDEOz6d0Ov3UTrac+4Y69jroDwP//wemhAzOHmVqm9hpeTg6DnMLgJ3QgvzLo793IGj1TLgjQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vLRSU3VW; arc=fail smtp.client-ip=40.107.236.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jad+WZQNRUwXzocFV844y3fH2yEa6qUYxQLSqpQ3OKp3PuO/XQ1pCWtHC+SUxvNbyibiFJRwLegX0L5y8J/+At3YsJUanuu4Oth5uZrfDJw/3mCfmE1AT/Dkn1h+fnVrJusrP2ryz6IAh7lYGaM8Pt7pKZhk/8SX34gmc7Z2/ny2Y4afCuvhEzAMc2XrxAsOEEyWzqnVUJvK04bzdVf72q+rebUb/Ne1vzPGHIYryh8YxRhHJfxEFUhC2ka/pEaysB5n5/sFVOIxlWHKnyGZ/4255QbfEY4pqx9C2ScA1jmp5MyE/QGLX6z/2Miwz6Suitbct90FzSOWOZILLiOLeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6RrAZBcI3xQCF6Fdo9kfENK+y9HlR9QYUnSyM/90idU=;
 b=M9ajVviDEcoxkO7OnjW3w1OPQd+OwBWe5cA7xGqnmAAnu4DaeKwkJe2/xrr8P2U5LxWD99J5Hx0fpRNU2C/6lhE/EEdDkVzJoNIA5AY6tD/p++NGq4s5LWGvVdWdY7txPLos/dkid/95pFxelGImnx1GKy+cIziNbZGewwJoWmj165QfilK/y79o7umKCg6TdxE/Nuctt6ACxfccqBr7boDQjkXolbhV/vrOqDRbE+xWTwl+zGOQgLWuumdyv6JVfH5kQjv6ndoUxLRQWpVY7IvY/qR9KEDy8fHxSS3I/9Q+ulWPBUKgOZmBcJUW9oDqGnYP5AWlimJYjMCt+41vQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6RrAZBcI3xQCF6Fdo9kfENK+y9HlR9QYUnSyM/90idU=;
 b=vLRSU3VW3jksF5KIK5N6p9T2Pt/HMPIAzNmAvELkTabO/M8ZiNgWr+MbfUIOqlSVc5cz+xgTIV8fhjUH+ER84iItPB38QFfsL9LOVjsYXvvvKekZYz0tkzkR2nJULe5sPToUPAJB6ot+/dOPn2pI50Z30LcGuWrJxXD8KZfDze0=
Received: from BN9PR03CA0605.namprd03.prod.outlook.com (2603:10b6:408:106::10)
 by PH8PR12MB6841.namprd12.prod.outlook.com (2603:10b6:510:1c8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Thu, 3 Oct
 2024 22:10:08 +0000
Received: from MN1PEPF0000ECD9.namprd02.prod.outlook.com
 (2603:10b6:408:106:cafe::c7) by BN9PR03CA0605.outlook.office365.com
 (2603:10b6:408:106::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.18 via Frontend
 Transport; Thu, 3 Oct 2024 22:10:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 MN1PEPF0000ECD9.mail.protection.outlook.com (10.167.242.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8026.11 via Frontend Transport; Thu, 3 Oct 2024 22:10:08 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 3 Oct
 2024 17:10:06 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <pgonda@google.com>
CC: <ashish.kalra@amd.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<davem@davemloft.net>, <herbert@gondor.apana.org.au>, <hpa@zytor.com>,
	<john.allen@amd.com>, <kvm@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <michael.roth@amd.com>, <mingo@redhat.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <tglx@linutronix.de>,
	<thomas.lendacky@amd.com>, <x86@kernel.org>
Subject: Re: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
Date: Thu, 3 Oct 2024 22:09:56 +0000
Message-ID: <20241003220956.33381-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAMkAt6qP+kuzsXYtnE4MRDUVx4sVpFoa+YwBtBRArMcnAfadkw@mail.gmail.com>
References: <CAMkAt6qP+kuzsXYtnE4MRDUVx4sVpFoa+YwBtBRArMcnAfadkw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD9:EE_|PH8PR12MB6841:EE_
X-MS-Office365-Filtering-Correlation-Id: 47a79662-d489-4c57-9a4f-08dce3f82456
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K+3p2cqExBB+UL+djild9UkHFSU0/VxoWemYQgR0ZHbLe99xE9nYCkL5CDxK?=
 =?us-ascii?Q?xCP880Q2zqlhpuBErYXCRNIzkUTU+6tkHPBZst3Rg1EMiTsorrGFZa3BeXZz?=
 =?us-ascii?Q?cKRJwp1IETnwobxNmk6zyLJcKnFvHlAGxIkO0/nzGc7ygh9gjLsYWSKy/Miz?=
 =?us-ascii?Q?YwT3UEhUCr26bfeX3bXxassxwnFDxNZPZyBOSz9u9blpLV141J/IqEkL6I9l?=
 =?us-ascii?Q?dFuvGvUdzJ9elfq++ZLa+9L0ugW1Gk5zvTA/5WwY3tozB+C7Gx3QndrT9DdB?=
 =?us-ascii?Q?NVyQFm1uT2nsoQOBY81mnjka0eAWXDdDe31BxCNcNl5NkDWpGRQ5/4yb0xeq?=
 =?us-ascii?Q?uS9YwPFxQCqukK0Lhknp1QWNHm2czDT2e7ZBx+6ATT8L7lQSPMfuabZRWzlp?=
 =?us-ascii?Q?640ENF3tLDajxQ+LL1f9jPHK1nfw6kRFxbfPwbB+ZdeU2afBYk7DZzlGfAGQ?=
 =?us-ascii?Q?Rn1G3wPj2Td1y/TpFCmIzz8t+e4SWLshImYIZfyMwr8xvghfk3l0u736jhKR?=
 =?us-ascii?Q?M0p8MZyltAsye7FeWJcgwO9CLTbYfc0bcLukxqVxKM1R7qQHydaq4zEdkJsb?=
 =?us-ascii?Q?agX25y4nTlAEmbZEuUlW6IQSG3ScSnN5lFMLBX+sY+ZljcY3P+0xxHOLJ5Sm?=
 =?us-ascii?Q?YxDOpS6DPOhXSN2IDh9c0z7/vo25MdudO4xRQj5XOKZ6VAKge0ajy7Sm3del?=
 =?us-ascii?Q?THDaJj/s+0Dmln1fpUBsk5xsN+8S0tu7duTWmv36/biMYiM8ltO2sis1a70e?=
 =?us-ascii?Q?rCqaNwIE8uxEGLPIQz+8mKH+yCt6In3x0YT6Izal8HhybexXAlxvTHuIr2jO?=
 =?us-ascii?Q?ycnv2V5/ajZxk19HbY6mKpf2PpEhByimxfbvEMBNj0Dmtg53wYXxP/U36Ywf?=
 =?us-ascii?Q?4n+/5aP6VjyKcSH0o/oaFAzQYcQvrB0gkE9RW/4gaBAiXzUGbU9YYgK+ujHo?=
 =?us-ascii?Q?KGrtoLhFMfjv9Jhz4fQZejvSVFhcEtSrJc8Y8uQNJlBLzPibINwcOWifnW89?=
 =?us-ascii?Q?O7IAhpoS30+KkjBHFMffayRpUo21YMQiihvIX4bteyKIVN48e173+qVEpH+u?=
 =?us-ascii?Q?0L6ub5NLgpsut/Havc9HHJP4MdMlXSRWdgN7Nt5v7o0h9B9bhYypPXIrBdP+?=
 =?us-ascii?Q?QnXVqaW6OAKjcJYXU9A08KWCK+biYud2x6UlAu81hzzHa6vJJbJlZwtuwBkg?=
 =?us-ascii?Q?j+n7B5Utzc9vBvq9UNi4j++xxLvQcBMR7wlJoIcl7zS/1Ay05OgyJgPDa40Z?=
 =?us-ascii?Q?1TNTGw/lBJQQob+OOxoOl98N02CVroLAEqZjoxM0ff5q7f2yoxBWJTqkr6oJ?=
 =?us-ascii?Q?f50nFoEXGuzQYnXKVcQ+0hmC6UfDmooCYpVSRI4EbOx77qZucfTMC9aVKGEN?=
 =?us-ascii?Q?fSdYw70k/CxVOpibGm6P8CJjnNdk?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2024 22:10:08.0192
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 47a79662-d489-4c57-9a4f-08dce3f82456
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6841

>>>>> +static int max_snp_asid;
>>>> +module_param(max_snp_asid, int, 0444);
>>>> +MODULE_PARM_DESC(max_snp_asid, "  override MAX_SNP_ASID for Cipher Text Hiding");
>>> My read of the spec is if Ciphertext hiding is not enabled there is no
>>> additional split in the ASID space. Am I understanding that correctly?
>> Yes that is correct.
>>> If so, I don't think we want to enable ciphertext hiding by default
>>> because it might break whatever management of ASIDs systems already
>>> have. For instance right now we have to split SEV-ES and SEV ASIDS,
>>> and SNP guests need SEV-ES ASIDS. This change would half the # of SNP
>>> enable ASIDs on a system.
>>
>> My thought here is that we probably want to enable Ciphertext hiding by default as that should fix any security issues and concerns around SNP encryption as .Ciphertext hiding prevents host accesses from reading the ciphertext of SNP guest private memory.
>>
>> This patch does add a new CCP module parameter, max_snp_asid, which can be used to dedicate all SEV-ES ASIDs to SNP guests.
>>
>>>
>>> Also should we move the ASID splitting code to be all in one place?
>>> Right now KVM handles it in sev_hardware_setup().
>>
>> Yes, but there is going to be a separate set of patches to move all ASID handling code to CCP module.
>>
>> This refactoring won't be part of the SNP ciphertext hiding support patches.

>Makes sense. I see Tom has asked you to split this patch into ccp and KVM.

>Maybe add a line to the description so more are aware of the impending
>changes to asids?

Sure, i will do that.

>I tested these patches a bit with the selftests / manually by
>backporting to 6.11-rc7. When you send a V3 I'll redo for a tag. BTW
>for some reason 6.12-rc1 and kvm/queue both fail to init SNP for me,
>then the kernel segfaults. Not sure whats going on there...

I tested with 6.12-rc1 and i don't have any issues with SNP init and running SNP 
VMs on that (with and without CipherTextHiding enabled), but i am getting a lot of 
stack dumps especially during host boot with apparmor, surely something looks
to be broken on apparmor on 6.12-rc1: 

[   33.180836] BUG: kernel NULL pointer dereference, address: 000000000000001c
[   33.180842] #PF: supervisor read access in kernel mode
[   33.180843] #PF: error_code(0x0000) - not-present page
[   33.180846] PGD 16bc1b067 P4D 0 
[   33.180849] Oops: Oops: 0000 [#4] SMP NOPTI
[   33.180853] CPU: 155 UID: 0 PID: 2521 Comm: apparmor_parser Tainted: G      D W          6.12.0-rc1-next-20241003-snp-host-f2a41ff576cc-dirty #19
[   33.632606] RIP: 0010:krealloc_noprof+0x8f/0x300
[   33.632608] Code: 8b 50 08 f6 c2 01 0f 85 14 02 00 00 0f 1f 44 00 00 80 78 33 f5 0f 85 0e 02 00 00 48 85 c0 0f 84 05 02 00 00 48 8b 48 08 66 90 <48> 63 59 1c 41 89 df 4d 39 fd 0f 87 8c 00 00 00 0f 1f 44 00 00 48
[   33.632610] RSP: 0018:ff2e31fe0ad3f848 EFLAGS: 00010202
[   33.632611] RAX: ff9e19414443ec00 RBX: 0000000000000001 RCX: 0000000000000000
[   33.632613] RDX: 0000000000000000 RSI: 0000000000002beb RDI: ff2d8c4410fb0000
[   33.632614] RBP: ff2e31fe0ad3f878 R08: 0000000000002be4 R09: 0000000000000000
[   33.632615] R10: 00000000000093cb R11: ff2d8c4410fb2beb R12: ff2d8c4410fb0000
[   33.632616] R13: 0000000000002beb R14: 0000000000000cc0 R15: ff2d8c446d000000
[   33.632618] FS:  00007ff504a05740(0000) GS:ff2d8c4b2c500000(0000) knlGS:0000000000000000
[   33.632619] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   33.632620] CR2: 000000000000001c CR3: 0000000157f2e001 CR4: 0000000000771ef0
[   33.632622] PKRU: 55555554
[   33.632623] note: apparmor_parser[2522] exited with irqs disabled
[   33.977961] Tainted: [D]=DIE, [W]=WARN
[   33.990019] Hardware name: AMD Corporation PURICO/PURICO, BIOS TPUT0090F 06/05/2024
[   34.006754] RIP: 0010:krealloc_noprof+0x8f/0x300
[   34.020151] Code: 8b 50 08 f6 c2 01 0f 85 14 02 00 00 0f 1f 44 00 00 80 78 33 f5 0f 85 0e 02 00 00 48 85 c0 0f 84 05 02 00 00 48 8b 48 08 66 90 <48> 63 59 1c 41 89 df 4d 39 fd 0f 87 8c 00 00 00 0f 1f 44 00 00 48
[   34.058484] RSP: 0018:ff2e31fe0ad57928 EFLAGS: 00010202
[   34.073095] RAX: ff9e194145b4c400 RBX: 0000000000000001 RCX: 0000000000000000
[   34.089957] RDX: 0000000000000000 RSI: 00000000000057bf RDI: ff2d8c446d310000
[   34.106827] RBP: ff2e31fe0ad57958 R08: 00000000000057b8 R09: 0000000000000000
[   34.123733] R10: 000000000000dac1 R11: ff2d8c446d3157bf R12: ff2d8c446d310000
[   34.140668] R13: 00000000000057bf R14: 0000000000000cc0 R15: ff2d8c446d400000
[   34.157572] FS:  00007ff504a05740(0000) GS:ff2d8c4b2b380000(0000) knlGS:0000000000000000
[   34.175513] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   34.190675] CR2: 000000000000001c CR3: 0000000157f2a004 CR4: 0000000000771ef0
[   34.207373] PKRU: 55555554
[   34.218980] Call Trace:
[   34.230226]  <TASK>
[   34.241043]  ? show_regs+0x6d/0x80
[   34.253389]  ? __die+0x29/0x70
[   34.265311]  ? page_fault_oops+0x15c/0x550
[   34.278341]  ? do_user_addr_fault+0x45e/0x7b0
[   34.291477]  ? ZSTD_compressEnd_public+0x2c/0x170
[   34.304780]  ? exc_page_fault+0x7c/0x170
[   34.316962]  ? asm_exc_page_fault+0x2b/0x30
[   34.329194]  ? krealloc_noprof+0x8f/0x300
[   34.341001]  ? zstd_compress_cctx+0x87/0xa0
[   34.353005]  aa_unpack+0x688/0x700
[   34.364035]  aa_replace_profiles+0x9e/0x1170
[   34.375977]  policy_update+0xd9/0x170
[   34.387225]  profile_replace+0xb0/0x130
[   34.398644]  vfs_write+0xf8/0x3e0
[   34.409463]  ? __x64_sys_openat+0x59/0xa0
[   34.420909]  ksys_write+0x6b/0xf0
[   34.431356]  __x64_sys_write+0x1d/0x30
[   34.442244]  x64_sys_call+0x1685/0x20d0
[   34.453055]  do_syscall_64+0x6f/0x110
[   34.463491]  ? ksys_read+0x6b/0xf0
[   34.473492]  ? syscall_exit_to_user_mode+0x57/0x1b0
[   34.485139]  ? do_syscall_64+0x7b/0x110
[   34.495611]  ? generic_file_read_iter+0xbf/0x110
[   34.506980]  ? apparmor_file_permission+0x6f/0x170
[   34.518530]  ? ext4_file_read_iter+0x5f/0x1e0
[   34.529610]  ? vfs_read+0x25c/0x340
[   34.539607]  ? ksys_read+0x6b/0xf0
[   34.549394]  ? syscall_exit_to_user_mode+0x57/0x1b0
[   34.560829]  ? do_syscall_64+0x7b/0x110
[   34.571009]  ? irqentry_exit_to_user_mode+0x33/0x170
[   34.582461]  ? irqentry_exit+0x21/0x40
[   34.592443]  ? exc_page_fault+0x8d/0x170
[   34.602507]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   34.613786] RIP: 0033:0x7ff504714887
[   34.623229] Code: 10 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
[   34.655533] RSP: 002b:00007ffcb6fbc758 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[   34.669681] RAX: ffffffffffffffda RBX: 000055f36c77bdc0 RCX: 00007ff504714887
[   34.683405] RDX: 000000000000dac1 RSI: 000055f36c7a1680 RDI: 0000000000000007
[   34.697133] RBP: 000000000000dac1 R08: 0000000000000000 R09: 000055f36c7a1680
[   34.710815] R10: 0000000000000000 R11: 0000000000000246 R12: 000055f36c7a1680
[   34.724467] R13: 000000000000dac1 R14: 000055f3654bcc5b R15: 0000000000000007
[   34.738032]  </TASK>
[   34.745917] Modules linked in: nls_iso8859_1 wmi_bmof rapl input_leds joydev ccp(+) k10temp wmi acpi_ipmi ipmi_si ipmi_devintf ipmi_msghandler mac_hid sch_fq_codel dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua msr efi_pstore drm autofs4 btrfs blake2b_generic raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 raid0 crct10dif_pclmul ahci crc32_pclmul tg3 ghash_clmulni_intel libahci i2c_piix4 i2c_smbus hid_generic usbhid hid aesni_intel crypto_simd cryptd
[   34.819993] CR2: 000000000000001c
[   34.830269] ---[ end trace 0000000000000000 ]---


