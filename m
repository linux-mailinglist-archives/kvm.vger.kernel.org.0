Return-Path: <kvm+bounces-40288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5169A55A8F
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 00:05:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1E343B295A
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 23:04:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 903C927CCFA;
	Thu,  6 Mar 2025 23:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Yzh/MFmf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2051.outbound.protection.outlook.com [40.107.244.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DF527EC87;
	Thu,  6 Mar 2025 23:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741302253; cv=fail; b=cA3v1S+wLZTcOXP/VBjEaGHhvkDXjMhIUR/iNuoM3b6CYl1L6gosvNfm92CdMOY/NfqLlQBskPnyEd0Vc6tFyA15FP5xX+vo5klqN1xLTA9QgTUGKsPOCPyazhqW4rfwnh2slyD5HA6Px2EtJ0ieqnC2aDMQuk8/nNNvWpW5dzY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741302253; c=relaxed/simple;
	bh=Lr1B3mjAh5CGHZt84FC9VEzwL1WforPJklRlVpRbl4E=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=etImPL3TlUHl4RhEGNQukpQIHpeG9KcGIzIyC7tJWFfPXBZKVOa9m9+OvXUK3AGAoeQKjO+ucv+LMkNnSzRJfHX6XQ1u5ubJaii1pIq0H5qb4l4jk/aH4V/86AgdnYfnEKcFQUQG4VxJ7Me4NStvIyzpl0L9rI0vQkmCM6YaG+M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Yzh/MFmf; arc=fail smtp.client-ip=40.107.244.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G1ZmlZGMxs1oyUez5kHaj8VVWiBf0m1LAUgg0p6c/EaXVP52+Bx/VLNQKX3O1W7bxM4olZk/ytzhjOX0vK2SEzZfPUkQ3kRMbvCV0XUPlOBZfnvw1XOzVeA3HhTY5krMSyEDPJ1Atb/FLpP3D0bybPv41DkGWe+yp49F84fMUx3kunmlBMSeFsG9Y7LRdqr7LA8lzdgOp6WmTHEpyQQCKmUDLxnXx7ZNhyrGiEu7tvqCiyYEhm4bKsboTz4PJ3wPN73TPyNgcgvw1mluETg+CZfIHV1D7RWeEd6ImaUDD4mJVN5wYJxfXxXi8iTFONMLErK9Q/iQilH7d0QQmbj2yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zmy7HHwPnYdTgmqCLxLq6IF8CuVKHcRW/uN7Srz9eeY=;
 b=HhOBoGna1Vbx33BPAXoiTQfmfeY8aXIJ8h9KtEXFlZHsCZe5tcrFvQPvzhaxdyqP27H3qGlO8Y91kGQ6Vfyc1iIFzO/uIuJ6r8zjP6MJWMtLytlIJKGktAOX5pl8NBu8kS6jCCoZZay+7R2KMEVq2h5+nOkomnFnC0PoRodkinwXdHzSKa33NlXVop0CpYxudCJDsgqradQcXzZNxbeaTxbJfaCcg3VQkVDvpewHorZhUMwP53BHEkuK3XkVKXFpAHJ7FwSXNzc4TtsIiU7vS1Ev7VUaNCKeKSjlH9PK/3zfE6H0Inu13ZKNwDocpAae5TKkSgZ7ZHeWq1zDsyLXqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zmy7HHwPnYdTgmqCLxLq6IF8CuVKHcRW/uN7Srz9eeY=;
 b=Yzh/MFmfODYzc4mG6+7oLMH9tEhsY6qM88tGVAGX2Wu0wyC9Xv2CZBCZhpnEqO9naWCVtba1KrYBhoQSR6ZQM2vUcQXTdcErLZyIXC/wuRW7V8f+CRsZKQcJLfmK3vYQMa95b7iYraeKco0oBBobz0G5IBcw8cX/9fckB76HJfE=
Received: from BYAPR07CA0002.namprd07.prod.outlook.com (2603:10b6:a02:bc::15)
 by SJ1PR12MB6217.namprd12.prod.outlook.com (2603:10b6:a03:458::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.18; Thu, 6 Mar
 2025 23:04:06 +0000
Received: from SJ5PEPF000001E8.namprd05.prod.outlook.com
 (2603:10b6:a02:bc:cafe::42) by BYAPR07CA0002.outlook.office365.com
 (2603:10b6:a02:bc::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.19 via Frontend Transport; Thu,
 6 Mar 2025 23:04:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001E8.mail.protection.outlook.com (10.167.242.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8511.15 via Frontend Transport; Thu, 6 Mar 2025 23:04:06 +0000
Received: from [10.236.30.53] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 6 Mar
 2025 17:04:04 -0600
Message-ID: <19388b93-c311-4671-902c-096ad1b04650@amd.com>
Date: Thu, 6 Mar 2025 17:04:03 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB
 Field
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth
	<michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, "Nikunj A .
 Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Sean Christopherson <seanjc@google.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, "Kishon
 Vijay Abraham I" <kvijayab@amd.com>
References: <20250306003806.1048517-1-kim.phillips@amd.com>
 <20250306003806.1048517-3-kim.phillips@amd.com>
 <85d324ff-a1d3-4d7c-ae2c-68588b12deb3@amd.com>
From: Kim Phillips <kim.phillips@amd.com>
Content-Language: en-US
In-Reply-To: <85d324ff-a1d3-4d7c-ae2c-68588b12deb3@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001E8:EE_|SJ1PR12MB6217:EE_
X-MS-Office365-Filtering-Correlation-Id: dbd05e4c-826e-4142-1cdd-08dd5d033258
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?azhpT1NMUS9JZTlMZVA4bDI4TVBxZk1yaHMyTHUwYTl6RlZJWFhYSjV2VStC?=
 =?utf-8?B?cVVwVnFqNFVFd1dVd3FxQ1NlTmhCS3dQK0FRZHlMRnhoOFhsdWtYb0t0ZjJK?=
 =?utf-8?B?NFR0cU9XOHhNTHVXYnJCZURRNFNJbXFXanFkcG5XMk5YRWNzMk9ESCtOdkt6?=
 =?utf-8?B?SGttemNlaEdSODNwb3F4K21sTmZVUnY4MTcwc3RPVmdnZEtxdGlPYllXMUd0?=
 =?utf-8?B?TFNzc2hNN0RGUjNMMzByTGJvSXBTTE5nWC9kRmUrZ1RFdjZHeWp5YllnTWxn?=
 =?utf-8?B?Mmt1a3h2YWZIYWRmaWJ1RnpjRkl2M3VsUnl0aSsxbTk2Y203S01sK241bDZx?=
 =?utf-8?B?UHRhMi9VSGg5RFZzQXN2bGtVU2ZocStrbHlzZWNQMkRWd3RwcCtEMGJLZmlx?=
 =?utf-8?B?UHVNd2o0MXp6ZElLSkNNOUtGR3N0YkJRUzdtaC9LNFJaeTVVc25ucFZUMVdV?=
 =?utf-8?B?b0l5S1licU51c1ordzVrQ2l0S2ZEdnNPaWhPUFpsY0o0eWFjTDhQVDJwVUd2?=
 =?utf-8?B?Z3NqbEI4WW9oQ3pIaVVQRk9oRS9DeWhhWGJ1Y05KWEJuQ0I5aEZSS0FkVmM0?=
 =?utf-8?B?YXhwdkw5QmdlVzlsbStvK3MrRnpsRncvdU1DRGFCL1p2U0FYT2lYU3ozWmwx?=
 =?utf-8?B?S0lIT3g0UjlqLzkvTDcwa3BQRENlMWU5Z0QwTVF0Sk1TeUtDOU1jWUY2NW42?=
 =?utf-8?B?a2hTZFQxL1pVOVhmQ2YzbXBPVU5xSDhFdVd2eUYrN25qZWd3Uk9WcW5MS2I5?=
 =?utf-8?B?L3g4aFZUVStSb25ZMWJFQmVOSzlTV2R5WjRaK1dsRDRqVzlqSUdPWDBpdzVm?=
 =?utf-8?B?VUFIQURueGpsWXNYbmdWeTlhd080cHVhRHBDVlVnVko5TVhUaFFCVlJCVE5o?=
 =?utf-8?B?dkZwSmx4aVJINXdzTnJoc05pYjczanNnbVd4L2tnRzFSMVR4d1NZM0w3ZmlK?=
 =?utf-8?B?bHE0NE1TbkMwTzJ6eXAzVjZ4ZDIzUitrSVIzWVA0YjJXYml4RDFTNUQyMVJQ?=
 =?utf-8?B?LzRSRGU1bFlTVnpIbXd5VUt2aVJtOEhvY0k1M1VVbEhlVU5OWU1oTkN2VG5B?=
 =?utf-8?B?em9DUTIzQjlEaC9KTkhvNTQvYU9wWW5IcTF5MFZwMUdvMjVVR1MzNEYzcWxj?=
 =?utf-8?B?eFVwdzh1c0J4RWFjajFEd1ZaeDViQXZkRm1SbnZXcitzaG5paVlBWCtQa2tF?=
 =?utf-8?B?bmZ2eE9MZkhQVVZTenB5UXhLRmFjMHcyN0x3VXRFM3IzUDY4K2p6TENXbzB6?=
 =?utf-8?B?cEIrbWpYRUllQUU5TU5Nc2FVWDFkTHE1NFQwWUgyZUtmVmEvSC8yMjhrb0FP?=
 =?utf-8?B?TjRXK2VjTzl4ZHphUFJ3aTJVTVVLY3BuUTg1Z1dmRGZzYWlDWFZtek5FMTN3?=
 =?utf-8?B?NERHemJxaTNtOXZFS1VOb2VTc2pJdW5DQXNVUTcwNWNDNDNLTFJxLzRDL2V2?=
 =?utf-8?B?VGtMWStpWTlYWk9DTW0wOVY1L1VoaXJXMk4vVTA1UFF3NGpoOWlGempJWE0y?=
 =?utf-8?B?UWZ0MXVHaTZVSHZPY1h2TmN5bWFSZFh6MnNFaFdaSEhwVlJoWHdJK3FZRVgr?=
 =?utf-8?B?SndRcndEM0FycUtRQjNaM2grSW9VcWhEaWY4WE5lelFUaXpLeDdJQXc5V090?=
 =?utf-8?B?cjZ1VklQODlPTnNtT2JGRXI2aTFaRHlPQy9YeTYvMXVyaThQN3BMV0NqR1lE?=
 =?utf-8?B?TGlHb09qcEZWd0ZsWUJZUXNOZG1YRjZUR0FlWHQ5QysvV0ZiRUxxZURoNFZY?=
 =?utf-8?B?eS9RZUpZMXlOSjVKZFBNNTBjRWNteS8veWlGM1BuNFg3dFpqK1pNQWxkTlN0?=
 =?utf-8?B?aUVPNkNTMU54TW92aGRGcERaK1pEQmg0bzBkMm9ZZkQ4Rll4c0JRd0tBNFVQ?=
 =?utf-8?B?U0VtRHMzVVFDOGt6VzJ4SmpXOFB6RVhmdHF2dVJnQTRhSXY1QUpLTmM3Y01G?=
 =?utf-8?B?Z0MzZ1dLaDc2dDc0enhZdlJzVVRkSW1Kd3BJbzRqbkMxS0xHL0dnNlk5STA1?=
 =?utf-8?Q?/+WfilcCP6C1lU9LJRMNpLiJ+Xbaxc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 23:04:06.5680
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dbd05e4c-826e-4142-1cdd-08dd5d033258
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6217

On 3/5/25 11:28 PM, Gupta, Pankaj wrote:
> On 3/6/2025 1:38 AM, Kim Phillips wrote:
>> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
>> index 9b7fa99ae951..b382fd251e5b 100644
>> --- a/arch/x86/include/asm/svm.h
>> +++ b/arch/x86/include/asm/svm.h
>> @@ -159,7 +159,10 @@ struct __attribute__ ((__packed__)) 
>> vmcb_control_area {
>>       u64 avic_physical_id;    /* Offset 0xf8 */
>>       u8 reserved_7[8];
>>       u64 vmsa_pa;        /* Used for an SEV-ES guest */
>> -    u8 reserved_8[720];
>> +    u8 reserved_8[40];
>> +    u64 allowed_sev_features;    /* Offset 0x138 */
>> +    u64 guest_sev_features;        /* Offset 0x140 */
> 
> Just thinking, if dumping error in logs would be
> useful for Admin in case of failure Or maybe we
> want to leave this to userspace?

Agreed.  I'll add the following in the next version:

[  435.580838] kvm_amd: allowed_sev_features:8000000000000001
[  435.587738] kvm_amd: guest_sev_features: 0000000000000081

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8abeab91d329..bff6e9c34586 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3435,6 +3435,8 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
         pr_err("%-20s%016llx\n", "avic_logical_id:", control->avic_logical_id);
         pr_err("%-20s%016llx\n", "avic_physical_id:", control->avic_physical_id);
         pr_err("%-20s%016llx\n", "vmsa_pa:", control->vmsa_pa);
+       pr_err("%-20s%016llx\n", "allowed_sev_features:", control->allowed_sev_features);
+       pr_err("%-20s%016llx\n", "guest_sev_features:", control->guest_sev_features);
         pr_err("VMCB State Save Area:\n");
         pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
                "es:",

Thank you for your review!

Kim

