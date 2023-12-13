Return-Path: <kvm+bounces-4352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F35881155F
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 15:57:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A211528228F
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 14:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C3CE2F52A;
	Wed, 13 Dec 2023 14:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rn6QFcWN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A43BE3
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 06:57:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSMtdmNWlC2Y6yKwD2e5Lym8KX3o4vNvxgxgCkevYm52M9qhzaef5w4tlEjdsZXHFjrCe5RuvXLG55jIvNLFyIlE5hT3SIzPU/H5fBuqHhe8mZ5s2R8JmOTeOKJ1+uS2rZJ/tvQkzWOQTK5/9+8UXb5B2oHaVRcuIkW+THroc1oG6WPs/cLdWIHN36z1nij6H7y+gmOC3H1HuXJwJGwJwg3qfwg2rj+9e3m5vyD+MwVRUByi41mRz20ZabckzKZ6MWiLdAfSFbAjqj5Goqeupg9mjfFVZrlW1uGWzn0ikQibhJbA3+PJ579DnFPQDJFVD7HraDjxoXH06I08LEHBJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vva8EZox2LwGsBqdhGkUQODDWi/LQ/nWCINiiK7ViD0=;
 b=CKx3Ndvsxy+Bku0splDVjXlJnFvkWgK5edb65/SkYTq9CuCHILvfAzp57KVpDckd61vCVk7CWvWEzPsWrwoZzXHtD9V80hSiuepQdtBImVzgdxk7E+MTj/aU/0A997GcSezOdtbrq1GN6z+GUDgX31vReABE9TjY3mUMF4g4vaLDgVxC0/FW0YzTJXm4giMWK4DJyO2zT7ws9Nd6gZCyn8m5FkKW+y5ops08rrP1QZ4pX3mRdMxvls+WVF15PSh5AjYyDAWU220tGe9sRw0l3ITc7kEEMZbKZSn51z3mJ70x3MQGAxgL5NGgeOc0+dkSoc8BIXDE5NvTEdQp36CMPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vva8EZox2LwGsBqdhGkUQODDWi/LQ/nWCINiiK7ViD0=;
 b=rn6QFcWNTDkVEp9SDp0WHurkfPVmHhMEh7rI+tgTlsfYWd6veAQwuztfKryTr8Snqb9Jla2XfKorgyaQBUSKfe/8FvAf5nyN35mEdlXFsHkeE90wGJac/ev4Ncb7nJRtBXeLhcf9c8U6Iv6zZndw08dasu4bmSgF5o70JFHTa3w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by DM6PR12MB4388.namprd12.prod.outlook.com (2603:10b6:5:2a9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26; Wed, 13 Dec
 2023 14:57:30 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::1549:8c93:8585:ca1b]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::1549:8c93:8585:ca1b%5]) with mapi id 15.20.7091.022; Wed, 13 Dec 2023
 14:57:29 +0000
Message-ID: <5d1ff42d-60a3-30d3-1599-65503b523895@amd.com>
Date: Wed, 13 Dec 2023 08:57:27 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From: "Moger, Babu" <babu.moger@amd.com>
Subject: Re: [PATCH] target/i386: Fix CPUID encoding of Fn8000001E_ECX
Reply-To: babu.moger@amd.com
To: pbonzini@redhat.com, richard.henderson@linaro.org, eduardo@habkost.net
Cc: mst@redhat.com, marcel.apfelbaum@gmail.com, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Michael.Roth@amd.com, nikunj.dadhania@amd.com
References: <20231110170806.70962-1-babu.moger@amd.com>
Content-Language: en-US
In-Reply-To: <20231110170806.70962-1-babu.moger@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0155.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c3::25) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|DM6PR12MB4388:EE_
X-MS-Office365-Filtering-Correlation-Id: e7e4bcfe-801f-4aa4-727a-08dbfbebd3f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/zZ+4lwolPUEDEQt/mjEfZGjq4CyCE+Ps316zp8AVs0Fk1c5nQC5KtW44m5yuW3xKlCllBQontMFNaX5AjuWILGf+IJoPcVpI0ZBi6w0AjFG9PHNr2m34ceIV7hwjlvEuggTsuMHviq/t1TpWTOCgE6C7su2+Vf4gxAJjb9i6eBOq68botAnzaBkkj6EqMNiHmHQIvwJW/1mbsrajxVRneydQX7fqaE+l+lsanO/HHTNjp4uRTzHjXkSKC9k2/PmzILhkE5bVewq3cNB6JtQvhGTtBXkYWy8eLk6GKAzJ6STFu/iJNahLlSM7rzw19OBnsklIhkF1yI40poADWKSr/vzhZS0Qjq0CAmyWUMX1inVgRZiulrrEVrvKscxPv9Nhjfg5FwfCzUEr4pHNWM6IKq3w6c3RLCfq0utpPAbpEC8SxRcS6LWF/XOSKfn1MvUEhGlN0vJN8vkZJqgxSt1fiXgScriSNJxw/cHmSCRUbc6Ky2zjfsel1fgHnUK36fiuMU+Fgth+7WIcuvlmOfW7UI9WEZKS674H1iviPK2u//P37FMx5+y8gXXP5v4QEvz/kNuOpOZrnbds2K/c+giIeRaUdxRPzNfMwwlHn7LBNvUxC9zZsvyFO2lF5SdLz6w2CyL+QvTdswW2HS+K2M7hQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(136003)(396003)(346002)(366004)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(83380400001)(41300700001)(38100700002)(2616005)(8936002)(316002)(8676002)(3450700001)(2906002)(4326008)(5660300002)(66556008)(478600001)(53546011)(6506007)(66476007)(6512007)(66946007)(6486002)(966005)(36756003)(31696002)(86362001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RzBVdEhxcU1aRC9ma0MwYUNtS0loZGZtQ0s1SmhyMTZkV0k0Lzd1eFlQVHo1?=
 =?utf-8?B?MmFXcm9CMFFZM2NzejE3NVFmUDZZZlZ3QmJHL2YzMStuZEFYWnJxQXJtemNJ?=
 =?utf-8?B?OC8zMXBXNzJUZFEyTjZwU1FSOXNXQ1lraXViNDBub01BWVF6b05GNU9KS2Fo?=
 =?utf-8?B?Q1hMVDIxVXhZbmprMDltUGFQcm1Ea3V1cGpvc3BCakt5WTRGV1V3dVdYQit3?=
 =?utf-8?B?OVV2QU90K1JYalMzRnhxQnVxa1A0QVc0VkpGTVRSNVJXaDI0K3hLWFZoTHRa?=
 =?utf-8?B?MWZsMjMvT3JkNlNtSXhQOXhRcFU0c3pJa3NZbzdmaDVNQzFSWHhKOC9rQm52?=
 =?utf-8?B?MTdpckVhdjBZcnBNaFVvN01qcjdTU3ZxenVFTDZCY3QyNFlIVDAwLy95RWs3?=
 =?utf-8?B?a1NDcllTTVVsbDgvYVB0NXJ3VHpwSFZoTk55amRJU0NQY0FRZXM0SitxTkJj?=
 =?utf-8?B?QmJveXNHbHN3NWFEMnVTWDB4RzJPWi9ubXU3b1JOTWJ3dU4wQzdhTEJqdUU0?=
 =?utf-8?B?cmZhRFRvaUp5ZW1vRG4xTDByM0RYSkg1eWU1Y09zTTdQVWR0c0tvcVg0WlI2?=
 =?utf-8?B?RHdRL0J6NzNFQUNHNkpLdHl2eGd1U3JnK2tQWDBOWVo2UXN4dGg3cmprWjhN?=
 =?utf-8?B?ZHZDQlRMMzA5Q3MzLzdERUplYXB3NHg2YlRrTUVQMzl0cWVpaHlzZ3VpWVRQ?=
 =?utf-8?B?ZUZjVEEwdnVYakt5M1E5NUxpUERwYlRPWjZIYUlNcVdxV2dESXJLem5kTFRS?=
 =?utf-8?B?dVJ1Y1VDc3d0ZTNUaXZIeWtjYXdZejZJaUZCK1BGZW1ad1BVZUUwZ3o1RkpO?=
 =?utf-8?B?RzRac0s1U25UcklqMEIyRWVCYUpJNWR0T2hMN2dBeTh6TUliNEdPUkJxL2x6?=
 =?utf-8?B?MUxVc3p4T29TbFcrTTYwMmpWSmtlSlBYZkdZTkYwWi94cUpwZVZsQTBSN1hD?=
 =?utf-8?B?Z2hJd1dyUVhRTHVYRkxtSzRid2ttWWR6NDdhWDBrUDIxbG8xYWVSdVMzY1F3?=
 =?utf-8?B?MktxelUrWWoxNXNYb29FaGFEMlZYb1hBVXZhZldHcjZQTmQ2OFM1blZUaTVi?=
 =?utf-8?B?dkRjRk1NWkZOR0NNT2RxK1Bnb2dlYXJsaVpSQTNXMlNqNDVvVEdlYmFJdVZs?=
 =?utf-8?B?NGhKaGplU0MySDFNRWtYZUxKU2ZnQnl5YVBMRklLU0pKNGxTYWFMU0VGeWtU?=
 =?utf-8?B?bTJXS01ZRS91QkRxZUVQL25tLzVPdXEvZXgrK0xxYTl2NTVybkg2a2JIYkU0?=
 =?utf-8?B?TFNzYkZtSU5HNWN6S1FHSU1OUk9KR3FqL1ltajEwL2hYaWtEZHp0V20rVWhT?=
 =?utf-8?B?ZjU4aW8rQjQzejBxOERqOHd2dHhrbmthTzI3R3hoYnRFdXZ6TWFiUVhKbm9H?=
 =?utf-8?B?aVo3OVR5WmFTWUpLUUw4dnRBVS91R1JlNlZGa3lhSnhzTTJ1SXJCVXpKUHFJ?=
 =?utf-8?B?YXpzN0Vxc0lNVmpmRzVzUGNWL2FDbmlYR2haT0RPYXNqYXJjMGEyRzhSd2I2?=
 =?utf-8?B?dEd5Q29JUlBTNS8vYncrV21UakJnanBwWGJicW8xNzlUNWFtSkorOTF6dFZP?=
 =?utf-8?B?U0JHaXF5KzEwY0JYakwwRmdmSVBzV3Zrcm1Udnk4c2JDZG1GT2dTRmNVdThX?=
 =?utf-8?B?T0ZPMzlNTlpJeGZ1ZjdGY0dPazFvbytsOHNISTZGY1VsczFQRzl2V0dlaEpI?=
 =?utf-8?B?clMrWWxWMHlQV3FHc0pEZzRHZVlXYjh3TWtXL0l3N2hyWE1lUHJ3UmdHcG5C?=
 =?utf-8?B?eUZwRDlyNTN6ZStRamNWeEpCb3ZKbzFTeHlGS1BwbmI4c1BmaFYxN0dEeVJN?=
 =?utf-8?B?Z0xmSkEwUG1KRGE2M2NpWnRNRGVQMktJTXVKM3pqRkhjVEgxeCt5WVByajNl?=
 =?utf-8?B?SFBQTjNJTi9VbENXbTl6OW1OdnFZR2l2dkZ3YkR3THV0Z1o1SEJjWEtVT0p3?=
 =?utf-8?B?MUo1ZUNKYXdUYlRMTElJSmQ4S1F3WFVYMjZPZjJydkhaZGNobHNEMWdUZWNQ?=
 =?utf-8?B?aUVlaG82TGF4eTA3TXcvazlaMmZUT1VLeCtDRGxlY3E4SjByOUNPRmVFMklz?=
 =?utf-8?B?a1Z3S2dKaEVqbXdaQlZkZ2pUVEZSNEM0SlNJYTZBS3I2Q2kwYituYzNCK3RK?=
 =?utf-8?B?YnlPNGFPQ1hZS3FudUthdk5jdHd1ak5ON3ZkUG5hZHZQc3RnYTVZS1FjUnov?=
 =?utf-8?Q?kqHVQVqvBlzezkXifYxEmm+CnPeK78LGytzGXpJTd8FA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7e4bcfe-801f-4aa4-727a-08dbfbebd3f8
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2023 14:57:29.6757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5BUQVNFoPRLCiKwahBmfJg31krPGPWkzh0sNS/EyTqcmwV4CcTU7LDm4XFFPwAEl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4388

Gentle reminder. Please let me know if there are any concerns or please
pull these patches for next update.
Thanks Babu

On 11/10/23 11:08, Babu Moger wrote:
> Observed the following failure while booting the SEV-SNP guest and the
> guest fails to boot with the smp parameters:
> "-smp 192,sockets=1,dies=12,cores=8,threads=2".
> 
> qemu-system-x86_64: sev_snp_launch_update: SNP_LAUNCH_UPDATE ret=-5 fw_error=22 'Invalid parameter'
> qemu-system-x86_64: SEV-SNP: CPUID validation failed for function 0x8000001e, index: 0x0.
> provided: eax:0x00000000, ebx: 0x00000100, ecx: 0x00000b00, edx: 0x00000000
> expected: eax:0x00000000, ebx: 0x00000100, ecx: 0x00000300, edx: 0x00000000
> qemu-system-x86_64: SEV-SNP: failed update CPUID page
> 
> Reason for the failure is due to overflowing of bits used for "Node per
> processor" in CPUID Fn8000001E_ECX. This field's width is 3 bits wide and
> can hold maximum value 0x7. With dies=12 (0xB), it overflows and spills
> over into the reserved bits. In the case of SEV-SNP, this causes CPUID
> enforcement failure and guest fails to boot.
> 
> The PPR documentation for CPUID_Fn8000001E_ECX [Node Identifiers]
> =================================================================
> Bits    Description
> 31:11   Reserved.
> 
> 10:8    NodesPerProcessor: Node per processor. Read-only.
>         ValidValues:
>         Value   Description
>         0h      1 node per processor.
>         7h-1h   Reserved.
> 
> 7:0     NodeId: Node ID. Read-only. Reset: Fixed,XXh.
> =================================================================
> 
> As in the spec, the valid value for "node per processor" is 0 and rest
> are reserved.
> 
> Looking back at the history of decoding of CPUID_Fn8000001E_ECX, noticed
> that there were cases where "node per processor" can be more than 1. It
> is valid only for pre-F17h (pre-EPYC) architectures. For EPYC or later
> CPUs, the linux kernel does not use this information to build the L3
> topology.
> 
> Also noted that the CPUID Function 0x8000001E_ECX is available only when
> TOPOEXT feature is enabled. This feature is enabled only for EPYC(F17h)
> or later processors. So, previous generation of processors do not not
> enumerate 0x8000001E_ECX leaf.
> 
> There could be some corner cases where the older guests could enable the
> TOPOEXT feature by running with -cpu host, in which case legacy guests
> might notice the topology change. To address those cases introduced a
> new CPU property "legacy-multi-node". It will be true for older machine
> types to maintain compatibility. By default, it will be false, so new
> decoding will be used going forward.
> 
> The documentation is taken from Preliminary Processor Programming
> Reference (PPR) for AMD Family 19h Model 11h, Revision B1 Processors 55901
> Rev 0.25 - Oct 6, 2022.
> 
> Cc: qemu-stable@nongnu.org
> Fixes: 31ada106d891 ("Simplify CPUID_8000_001E for AMD")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
>  hw/i386/pc.c      |  4 +++-
>  target/i386/cpu.c | 18 ++++++++++--------
>  target/i386/cpu.h |  1 +
>  3 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index 188bc9d0f8..624d5da146 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -77,7 +77,9 @@
>      { "qemu64-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v, },\
>      { "athlon-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v, },
>  
> -GlobalProperty pc_compat_8_1[] = {};
> +GlobalProperty pc_compat_8_1[] = {
> +    { TYPE_X86_CPU, "legacy-multi-node", "on" },
> +};
>  const size_t pc_compat_8_1_len = G_N_ELEMENTS(pc_compat_8_1);
>  
>  GlobalProperty pc_compat_8_0[] = {
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 358d9c0a65..baee9394a1 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -398,12 +398,9 @@ static void encode_topo_cpuid8000001e(X86CPU *cpu, X86CPUTopoInfo *topo_info,
>       * 31:11 Reserved.
>       * 10:8 NodesPerProcessor: Node per processor. Read-only. Reset: XXXb.
>       *      ValidValues:
> -     *      Value Description
> -     *      000b  1 node per processor.
> -     *      001b  2 nodes per processor.
> -     *      010b Reserved.
> -     *      011b 4 nodes per processor.
> -     *      111b-100b Reserved.
> +     *      Value   Description
> +     *      0h      1 node per processor.
> +     *      7h-1h   Reserved.
>       *  7:0 NodeId: Node ID. Read-only. Reset: XXh.
>       *
>       * NOTE: Hardware reserves 3 bits for number of nodes per processor.
> @@ -412,8 +409,12 @@ static void encode_topo_cpuid8000001e(X86CPU *cpu, X86CPUTopoInfo *topo_info,
>       * NodeId is combination of node and socket_id which is already decoded
>       * in apic_id. Just use it by shifting.
>       */
> -    *ecx = ((topo_info->dies_per_pkg - 1) << 8) |
> -           ((cpu->apic_id >> apicid_die_offset(topo_info)) & 0xFF);
> +    if (cpu->legacy_multi_node) {
> +        *ecx = ((topo_info->dies_per_pkg - 1) << 8) |
> +               ((cpu->apic_id >> apicid_die_offset(topo_info)) & 0xFF);
> +    } else {
> +        *ecx = (cpu->apic_id >> apicid_pkg_offset(topo_info)) & 0xFF;
> +    }
>  
>      *edx = 0;
>  }
> @@ -7894,6 +7895,7 @@ static Property x86_cpu_properties[] = {
>       * own cache information (see x86_cpu_load_def()).
>       */
>      DEFINE_PROP_BOOL("legacy-cache", X86CPU, legacy_cache, true),
> +    DEFINE_PROP_BOOL("legacy-multi-node", X86CPU, legacy_multi_node, false),
>      DEFINE_PROP_BOOL("xen-vapic", X86CPU, xen_vapic, false),
>  
>      /*
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index cd2e295bd6..7b855924d6 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1988,6 +1988,7 @@ struct ArchCPU {
>       * If true present the old cache topology information
>       */
>      bool legacy_cache;
> +    bool legacy_multi_node;
>  
>      /* Compatibility bits for old machine types: */
>      bool enable_cpuid_0xb;

-- 
Thanks
Babu Moger

