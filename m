Return-Path: <kvm+bounces-4532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1012813A1C
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 19:38:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95F0FB218CF
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 18:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE1D968B6A;
	Thu, 14 Dec 2023 18:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fPgjXQ0r"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BAA10E
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 10:38:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lOfnyxwTh88FlS0SYYiWVQk/79UGZmz1H/CBXPRessvdTZF4yVd3gycPCQ2l9oHzVnE73zIaOThMiDmjwUz2Cdhi/4bGtw/fggnBv0+trRUaPyRSh7WyUaSrOmrRA2mXuOKNn5PMcRNWg0EwQajuFAy99+72dgxvXZT0K0dkUnStT9UYTYx3E+aMOVoXdZ2qBovhrdZQyZ9P4lK2fHHa1eelvVFElI8M0zbYhQ2fAiJrNGaFmK02HN+tV9ClCZqvfKHingZ+OxuzZluDwlQNWg6AFFXoh5eZDXT5TX/gdB7qwj/gjlfWNJReVU7PmqRihOTA26TbgKFa636sKqo4cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7kyh0zRlSgBBrvmpE92iZAelmK+jEEBhKeoPrhm+2aY=;
 b=kbIpNE8cbm2kxWQ8T0Nl+aPEL0XES1MFozSIoAB/u7bSGgiER4I+3tpi+Ls+U0xGR6vLsHs/zsqhN9si7y0xr7tKgcdUlfhszko0IeuIjoB7fiFxqE4Pk1zzbItNSGwwLNFGwdsK2cgZNs8ECeu1LXqKYVkTdx30KSoTkDcDejZm0cQZiAKOm/b7plgvBzlJ9O5vKP7jVV+Gdv4PwQc5oZ++3wY3sA7qriEJeocx9APVQwycXY7Lrd5vcDFZ9aID2Clp4qeot67p/nARkgiAjB88d9J7Upisx7YI8XoPpRpJEXqLjSj4pj5XbmEK1IDqbXAu9hzFtv/hkJiIxwqxMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kyh0zRlSgBBrvmpE92iZAelmK+jEEBhKeoPrhm+2aY=;
 b=fPgjXQ0r1d9BIrxzTDEFg1IqTkWpSuMfApuolLjryVJkivRsSq0Vl6o8jfTQBNGptphU0CqIybkvSG+fbP6qKABID4O9GHnY4/fQM/GLcIx/xGjDt6BC8DQsg+i6jlX9RvCspj70+saWKVSmHWFfYgEhDS5H0afyqtOOHXhdZb0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by PH8PR12MB7327.namprd12.prod.outlook.com (2603:10b6:510:215::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28; Thu, 14 Dec
 2023 18:38:01 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::1549:8c93:8585:ca1b]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::1549:8c93:8585:ca1b%5]) with mapi id 15.20.7091.028; Thu, 14 Dec 2023
 18:38:01 +0000
Message-ID: <625cad09-ace2-dec5-520a-6a96ed16da89@amd.com>
Date: Thu, 14 Dec 2023 12:37:57 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH] target/i386: Fix CPUID encoding of Fn8000001E_ECX
Content-Language: en-US
To: Zhao Liu <zhao1.liu@intel.com>, Babu Moger <babu.moger@amd.com>
Cc: pbonzini@redhat.com, richard.henderson@linaro.org, eduardo@habkost.net,
 mst@redhat.com, marcel.apfelbaum@gmail.com, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Michael.Roth@amd.com, nikunj.dadhania@amd.com
References: <20231110170806.70962-1-babu.moger@amd.com>
 <ZXsMYtEg+p86tawB@intel.com>
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <ZXsMYtEg+p86tawB@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR12CA0030.namprd12.prod.outlook.com
 (2603:10b6:806:6f::35) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|PH8PR12MB7327:EE_
X-MS-Office365-Filtering-Correlation-Id: 483d4ef8-1b61-4d68-1243-08dbfcd3ccac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	T6YooGo/8TLG6xX4QO4ZtdNlR0bfQXsl2I4bK03B81sxp6Y6OPgnKNAtNx/vRtmMPUIysK5AYUV34X+u45Ipww8zRJ19dj1ZRLy53VEIjoxWVWz9qjqcF8dY1jtfF9qPFxLOPEKNQh2mhko+nHQlz+piaNE5tHkckznAqltVZhRbnAHIOiOOuptm6W1Z7mrrPp6Q2Ldr4Ng/HXRgJ0Ojcvtk5r8oiyUbi1TvieywrifYn0GGm60ryARnIZgRznrLHoeOuAZY0Zf0Nk7x9O+ykVmujR40cW+2sHa3ntP9BgafHAt907p8vBpSXi/e2YMCiUedLI/0X9FIGQc/NQ/7RSunBaHU6H3/5qzKJranKSs1zaf38Q5WswnmlLogolfwgsDwJmyANl7zffwKPCnM/x5ouSwZcxfL84HNOjbVFTZ/73ckDB5x854GyqiDZyJqdZi15l4sXGnHh0N/UxelZXP8FjJU1Du1ewnQkQekeVNNJbLjeT/PG2Ktunc3p4zNTFDyY7Dc6K8lbcMQpYp1sPp+Zt1Th0/ACw1Jg066PXi8RkqBp3pJW8iehKkd+zwStpyHK3Ah46RywzF7V4921JiIzF+Gna/4IhJfaWQEsI2KUVvuHShfserj6+UgymHQiCHdYISird07ZvOuJHN8PA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(396003)(366004)(39860400002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(316002)(6636002)(6506007)(53546011)(478600001)(110136005)(66946007)(66556008)(66476007)(83380400001)(6512007)(5660300002)(2616005)(966005)(6486002)(6666004)(31686004)(8936002)(8676002)(41300700001)(2906002)(36756003)(26005)(31696002)(4326008)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2RGcXVaZDI1ZkQxaGs3YzVVRzRZeWEvUG1jQjhLOVU4aHlZUWhIZDUvejVQ?=
 =?utf-8?B?WlZ2bEFoa2xkTjhNeWJMc1hVQUlFR1RLaTJ1UTAxSDA0ck1MZXdGMytEVDZn?=
 =?utf-8?B?aXQ2K2RtSG9kdVRvdjJRanAvYmxjVEVwNlBNa250eEpaYlNmMHhuWkpnWGxj?=
 =?utf-8?B?RHpzRTY0ZXVyRU1nMDlldC9vK3JieUFHNXY5ZGlkYlhhRGsxM1ZRWFZraTZo?=
 =?utf-8?B?RUdiaUxKcmtDazhHUUtKUVk4WU1tMkpoazh2ZTNscS90L2FIWHBLZ0hySVpS?=
 =?utf-8?B?bWNUcmhRd3JQNE5qN1YzYlRnM0o3Z1V0dGx6SEZQMk9OU280bjFiUld5V0pJ?=
 =?utf-8?B?MFZJYU9QOG4ycVVwS3F4a203ZTZXelM0R3ZlSFpqMkZKT0xwQVo0RUs1RnlM?=
 =?utf-8?B?Z1VQaHZROXQ1dzFWeDdlZjF3OGEzeWczZUpVMmc5Y2p2Y1pKRkxhK25VY1Jt?=
 =?utf-8?B?NFljM29IVVB4S0cyMFE2aWsyMGI3NWF4Y1ZyMzd0T0FkdTUwQi9aVTVwZW1J?=
 =?utf-8?B?aXV4NFFETHJrUzFYZnQxa2ZxKzJnazBwVmxtV2RnUHlmUHhnNkRvN2k4SzQ2?=
 =?utf-8?B?R0RRc1M3VEMyWk9sQWtkcllPck5BNVpHMk1Fc0R0OE5EamV4WXkvZUJEZndh?=
 =?utf-8?B?cjFRYXZYL3UycHVZcUpQekpJREh1SHFWbGlhdFJ1ZU83V1RrS1pXeHBBdDh2?=
 =?utf-8?B?TWlnZ0FWMytzNGx5RXhmcEtJUzhuUXZrWEZNOVdJWGdyQW1mcmE5SmlmVy94?=
 =?utf-8?B?VXRCVmt1eGJWamdHRk44cU1ENGw1by9MNEI0bXZvVEo3TG1HRHZXTmM1a2ZW?=
 =?utf-8?B?RzhTcVNlU1V2SXNuR2l3VVlnSGdyL3dnYXhWQnJzZ1UvbXdCOW5xc2Yxd0JK?=
 =?utf-8?B?Zjk2YURHT0NSRmpYbWxVL05pSEVaLzhyKzUzKzZOdXNyV3Q0RkkxRDB1Tytt?=
 =?utf-8?B?NWZrRm45MC96NjY0V0tMa1hreFdLbjd2NFJ6bWJsYmFZSUp5dkRRWWtGL3JQ?=
 =?utf-8?B?TXBEVUFxYS9xLzFRclU5N25kSm9qM1k5KysyWkNUQ0twSTZ4bmQwRmt0a3ZO?=
 =?utf-8?B?ajI5L3ZzV05XMC9VTlBnTmdPRUdyb1pIbUMxUTIva3J3MEROOUhCTkplSFNW?=
 =?utf-8?B?L0ZQR3RWdmJmOU5tRkd3R0NPRS9SNlM0dWUyd3BxZDFDZElBMVFIeHRNOHFo?=
 =?utf-8?B?b1VmcllvY0hMejN1dStET2R3eG9jNEpUV2IwTFdvaytwQjEyeDF0K3dEeW9R?=
 =?utf-8?B?NXFFZ0g3L3haQWxrUEtMZGc1ZUIzTFFzNWQ0T2pPNVVtR0FaTnlhYm5KNWQv?=
 =?utf-8?B?VzhleDZSZVgyNEN6aUx4K3pZQjFFZ1VtanNpUGh1c1FLZmVCQzhTUml0bDBM?=
 =?utf-8?B?R0FPSWtUcmUwUDNITVBqRXdNbW9yWnlWSTlHeFhCT1NmZUl2blNuWW5ka1la?=
 =?utf-8?B?bzRvSlpzWWN5ZVFRdGtNRVYzK1RHT3NHOGE0UlVRQ0docG5iMno2aVc2TGMz?=
 =?utf-8?B?cE5xTzI5RExDZmEwaVpMNnVqQmhQREc2SEZyQnh1bDFGZ1FaTFZzcDJnRzJV?=
 =?utf-8?B?V3VvZENhelhjRlk3TlpaOUhpQU02aFk4SzdVU0xadzcxKzVlemFMYjZkM1Bl?=
 =?utf-8?B?bzRlOHdWWUpRdmxibXdxWEMvbHdNU1FPTkUwR2FaMS9iS1FITE41TmhNYyt3?=
 =?utf-8?B?WTdaZERXK2dsZnJGdnVxVE5zSTlVSmNRL3VBTm9PVkMyL0sxUUtUZEFURWhX?=
 =?utf-8?B?RmcwNHR4dXBUTExhQ0RRSytQUU1TcytCWWNoRUV2ZERELzhOZ0x2UkUwS1B6?=
 =?utf-8?B?QWx5Rmh4aEdDNUlGM2ZjWWNENDBuV3FYdmMrNFVXWmVza05CNU1ZV0Nqenh2?=
 =?utf-8?B?QllQWlk1Ykw4SlZDNXpUYW1XaXFuZnpSUnBGVzNHbFFqbHdvUGs2R0MrZmhZ?=
 =?utf-8?B?NTNuWXZsVXc3NmhMdU5DTThQUUJMYS9BWis3L21kQnJOL0FpTlpoK1NPVnRl?=
 =?utf-8?B?SGlCV0JUZHU1NjdLVy9QdWZXTUxJUmFvMncwUWFLaWx4QUhCMnBhbVhQU2FH?=
 =?utf-8?B?cWJVSmthUUozZ3dIUDRsSVVCVUkyWHpmTUs5dWtBclBrQzRRMUd3SHNrck01?=
 =?utf-8?Q?ChsA=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 483d4ef8-1b61-4d68-1243-08dbfcd3ccac
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2023 18:38:01.0611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z3KXuRWVslSyeoARRjs4Emvp6LxVDbzi4YwQwb0d+RVoh5JS9KUQ16MfvQKGy8xe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7327

Hi Zhao,

On 12/14/2023 8:08 AM, Zhao Liu wrote:
> On Fri, Nov 10, 2023 at 11:08:06AM -0600, Babu Moger wrote:
>> Date: Fri, 10 Nov 2023 11:08:06 -0600
>> From: Babu Moger <babu.moger@amd.com>
>> Subject: [PATCH] target/i386: Fix CPUID encoding of Fn8000001E_ECX
>> X-Mailer: git-send-email 2.34.1
>>
>> Observed the following failure while booting the SEV-SNP guest and the
>> guest fails to boot with the smp parameters:
>> "-smp 192,sockets=1,dies=12,cores=8,threads=2".
>>
>> qemu-system-x86_64: sev_snp_launch_update: SNP_LAUNCH_UPDATE ret=-5 fw_error=22 'Invalid parameter'
>> qemu-system-x86_64: SEV-SNP: CPUID validation failed for function 0x8000001e, index: 0x0.
>> provided: eax:0x00000000, ebx: 0x00000100, ecx: 0x00000b00, edx: 0x00000000
>> expected: eax:0x00000000, ebx: 0x00000100, ecx: 0x00000300, edx: 0x00000000
>> qemu-system-x86_64: SEV-SNP: failed update CPUID page
>>
>> Reason for the failure is due to overflowing of bits used for "Node per
>> processor" in CPUID Fn8000001E_ECX. This field's width is 3 bits wide and
>> can hold maximum value 0x7. With dies=12 (0xB), it overflows and spills
>> over into the reserved bits. In the case of SEV-SNP, this causes CPUID
>> enforcement failure and guest fails to boot.
>>
>> The PPR documentation for CPUID_Fn8000001E_ECX [Node Identifiers]
>> =================================================================
>> Bits    Description
>> 31:11   Reserved.
>>
>> 10:8    NodesPerProcessor: Node per processor. Read-only.
>>          ValidValues:
>>          Value   Description
>>          0h      1 node per processor.
>>          7h-1h   Reserved.
>>
>> 7:0     NodeId: Node ID. Read-only. Reset: Fixed,XXh.
>> =================================================================
>>
>> As in the spec, the valid value for "node per processor" is 0 and rest
>> are reserved.
>>
>> Looking back at the history of decoding of CPUID_Fn8000001E_ECX, noticed
>> that there were cases where "node per processor" can be more than 1. It
>> is valid only for pre-F17h (pre-EPYC) architectures. For EPYC or later
>> CPUs, the linux kernel does not use this information to build the L3
>> topology.
>>
>> Also noted that the CPUID Function 0x8000001E_ECX is available only when
>> TOPOEXT feature is enabled.
> One additional query, such dependency relationship is not reflected in
> encode_topo_cpuid8000001e(), should TOPOEXT be checked in
> encode_topo_cpuid8000001e()?
No. We don't need to check in encode_topo_cpuid8000001e. Dependency 
check is done earlier than this is called.
>
>> This feature is enabled only for EPYC(F17h)
>> or later processors. So, previous generation of processors do not not
>> enumerate 0x8000001E_ECX leaf.
>>
>> There could be some corner cases where the older guests could enable the
>> TOPOEXT feature by running with -cpu host, in which case legacy guests
>> might notice the topology change. To address those cases introduced a
>> new CPU property "legacy-multi-node". It will be true for older machine
>> types to maintain compatibility. By default, it will be false, so new
>> decoding will be used going forward.
>>
>> The documentation is taken from Preliminary Processor Programming
>> Reference (PPR) for AMD Family 19h Model 11h, Revision B1 Processors 55901
>> Rev 0.25 - Oct 6, 2022.
>>
>> Cc: qemu-stable@nongnu.org
>> Fixes: 31ada106d891 ("Simplify CPUID_8000_001E for AMD")
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> ---
> [snip]
>
>> +++ b/target/i386/cpu.h
>> @@ -1988,6 +1988,7 @@ struct ArchCPU {
>>        * If true present the old cache topology information
>>        */
>>       bool legacy_cache;
>> +    bool legacy_multi_node;
> This property deserves a comment, as does legacy_cache above.
Sure. Will do.
>
>>   
>>       /* Compatibility bits for old machine types: */
>>       bool enable_cpuid_0xb;
>> -- 
>> 2.34.1
>>
> Just the above nit, otherwise,
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>

Thank you.

Babu

>

