Return-Path: <kvm+bounces-12525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04C5D8873BB
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 20:18:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27E7C1C228BC
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 19:18:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48E3178B41;
	Fri, 22 Mar 2024 19:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4uVqGxeL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2083.outbound.protection.outlook.com [40.107.95.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58AC74C11
	for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 19:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711135094; cv=fail; b=DStqeK1S42MLRj7o6vNAPHg7Ttusz4EYy4vvVUB0xvRKjelTrNlFKie3daHTpqXCj18qvF/olsOx9g8K9GtJ+lgwK6CuRrMjzqIfc8lf2DBgwo1ddKlRpxJHSUk+4cUL5X453km6BeyyRcACt10HfXRzxRd7gEjoxQxDfwRI3GU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711135094; c=relaxed/simple;
	bh=bJFZMqYLEbDtBZgLw5RILTQZ/Ve6syjd3a1HikziDXc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h5VpKsD52ghmUHrzHNcX4Hr9ibZcIV87HXOc2xUlMJodleu0SVgEkXRptfWZURBxxiDtTN1Fz5g5WE/wxWROSZLY+Kfflfs0UOFDMVApAx7MU90/8FmzMU1M4LfQo2sEYQHagKN7J12EO+ktWwlUakIDndDZjFzOlpXk7NWbF7M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4uVqGxeL; arc=fail smtp.client-ip=40.107.95.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Esmgd5qWa1VGSy1ovalh6wEZiMzkyf7FJF8tMrWgFAbwKsuq4k9lJ9FVRUgVUdiqQd0ERDWYGUPJl1otgzSL4ckbnqg88Og+4gwbqTmgLxh/1oB+AtaI+bPDJKEQaU7XKXGfpfLtCHaSZfs5bfqWnfnwOIgCuEoyVbOyA4hpeBjdoyjORTkW6uncXK2NKr65GseKzlj3UAKF00NxMge/CcYvLzElZX659NAL2mAfeyku8ZNIGU6+lhV8Q/un6NfsPadJ8hS3QZUB3kITMW9QrJj09+I+Luftb0xHdJauyl/kwhS4TzOtt9qdZi1YjzwL4nojS2PyLaVYSFn02snONQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rr8wPNbRGRKY/7UR505z32m6gMgc31MQMHggbFx8s2Q=;
 b=eLllzWjIqlH4Z5z0y/PSwGn3na8O2xxuFG7xDZ+MZLPBIuGP2D+vKdNPtWJdhq9iMJmorBQZVWpONI9puQBWhr6RcuPzQVnJN47dkZbftFXLNWbf3/u8nIheDHIm9JxAIT+CN4WIoipKqga7Mv/i3g/xwnXs+G2IKGDUcYeJ8h8Nc9iSHeJ4EKQq9wLPBy1C5vIYaUVbXDCSANm81W7SsTetA6Tm2G1YBTCYJxgsd0yl133joXe85qZmwA+ACf2yxraUSwoxC+Nqt7l5yu+kIs+usj1W488pNKSxtyNVGrn9aDZZGspr/Xnfegn3Xyr0wMx35MkPFrhVt3FXViZRQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rr8wPNbRGRKY/7UR505z32m6gMgc31MQMHggbFx8s2Q=;
 b=4uVqGxeL8+W4UKPre55NlSrwEeczgvXXjnkSRixdDkjNIKpeHfKoxMSp7YoBRcssPxBmeCqFmGYD1FXa+ZvRez2YtbUftxc5nnS6H0B/6mwrd125Vk/G03Bjt1+4M8fs3K39EPQQQwWAAJJLYktZLWf7zdxZPDrHvMveHSH/oI0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by PH7PR12MB6811.namprd12.prod.outlook.com (2603:10b6:510:1b5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.29; Fri, 22 Mar
 2024 19:18:10 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::873e:e31:6eff:36a4]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::873e:e31:6eff:36a4%5]) with mapi id 15.20.7409.010; Fri, 22 Mar 2024
 19:18:09 +0000
Message-ID: <2dfb3395-0d1f-4739-afce-c6a4ec3f9b7c@amd.com>
Date: Fri, 22 Mar 2024 14:18:06 -0500
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v2] target/i386: Fix CPUID encoding of Fn8000001E_ECX
To: pbonzini@redhat.com, richard.henderson@linaro.org
Cc: weijiang.yang@intel.com, philmd@linaro.org, dwmw@amazon.co.uk,
 paul@xen.org, joao.m.martins@oracle.com, qemu-devel@nongnu.org,
 mtosatti@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
 marcel.apfelbaum@gmail.com, yang.zhong@intel.com, jing2.liu@intel.com,
 vkuznets@redhat.com, michael.roth@amd.com, wei.huang2@amd.com,
 berrange@redhat.com, bdas@redhat.com
References: <20240102231738.46553-1-babu.moger@amd.com>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <20240102231738.46553-1-babu.moger@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR11CA0017.namprd11.prod.outlook.com
 (2603:10b6:806:6e::22) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|PH7PR12MB6811:EE_
X-MS-Office365-Filtering-Correlation-Id: c3810d25-1ecd-4ef9-43de-08dc4aa4cf83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TPhwB3ldaWHgjYMokhHBwCCWAc1gyuWK8kIcWSYalL5Gn3TYAcUMzBuzhtVzVyZy6QKmLudeGHMVzTI8W7eZF25y7uh2HBaV2o+1xTi1FcZ/wLdlFlvzb3LBeFlPm2Jl470ZCs1LS7wT1MeA1upY5rXGqb3cMG3PyCZKTEv85bmzTH5n/g1aNElJg0QFCq1LsLViLCGzxEn1GYPy1pDW9lsuBseKNuEYtxsnmmhh54AhqNkqS1/jsyH/pRQWdlCoWS87NkZ2YyI3LX6JcpJqFHxM7XRj/JXSP1/Jye/bD+ZDUnssA6zdxyP+6MFT8J/YreeR4ccMZ4FBUri4YVj8+d3OBIzhayzpib1ktcsRPn9EXLFYI7bwxg+A2aMhujS2YnWdlQVvrpTLSjcNw1O6zXFe/oXCV0W0Dmprvvlo3buPM3sH6fS0qfNTR54SUuaqjy2kLZu9whHqcgObh+/kHzRuY+5pww8E7umE8fI5MxeqmnA12cT5YWSUxF8yDYGLSqSJYHOVKHMVtsZ5ztJFd5B8+ovm4dRCDFgsTXdcN3gfZex9Es3vVjTXfpZzzrRWjbr9z4VzcyXT0W1m+WUdroo6Ov/Tr0zVRcN8UXPDmQE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bW5rRDlIRjJrTkZPT3BSR3JtMWpwMmJGVXk4RTRYaVVyL1E2NlM2YnNRTE1S?=
 =?utf-8?B?T0VuYWpWWTQza241TVRFa2thRUZwMm1FWVBEL1Z4eFhIT3U4NkNvN1JmbkJT?=
 =?utf-8?B?cm1BUGhjditmUWZsaHRoRHN2dHdFLzM2ZHZROUtCMGNJUEdLY0dnRFNPOEYz?=
 =?utf-8?B?MHVPOHhwUUtMYkU5WVFzYTM4SHFWM29mQVpJd3BDQ0VMc09hZWpNclV6ekxw?=
 =?utf-8?B?MjVTU3lZTllnWDJyZnV5Vm1HNGtDSm9pUldhU0ljcVBJZzF3M1d0Q0tmVEVD?=
 =?utf-8?B?OHAzc21QcVV2TU53T0YvRy9FMWlLcFFoZ2FIejdVcGJ5eU01VFAwV0xyekR5?=
 =?utf-8?B?MjhFTG9oZ1U0aTg5ZWJLeUU1QVJhcStoZlNtS0Q3S28vYnF6a3dUVUpTd3R2?=
 =?utf-8?B?ZjIyUG53R01YUkxNUTNXNHNZcHFvVWJxbXFzZms1UDM5QVV1V1NVS3ZsM2h5?=
 =?utf-8?B?VDJKTnl1NnR2TjhvSHRDN0VLdUpJTHhCSGdtNm5yclVUNjlJSzdNeTMzd1pB?=
 =?utf-8?B?dDNRVWNCQUNOTXpWcUZWcCtSay90SWlVaVBOQzgzcXJjYmJKY3pNbm01c1ZY?=
 =?utf-8?B?emdzWmI4UXY2SmQxNWFpdUtQN1I3Nkg0dHF1S280QVUxSkpkVi9VRHFDajVy?=
 =?utf-8?B?ZDk1Y0JNR0pzck5renFSdEdkTmwydkZKcUhlaVBRN3Q4em1YRXROYUpPR0tM?=
 =?utf-8?B?TzZ5ODI2dkRZVWt2WCtoR1BXWDdpbDdjNmtGTzh2YmlvdjBmSFpjOWt5VzNk?=
 =?utf-8?B?WEErNmNXV2FrSnJzaTM0U095eUtLUnpaeW1zeUphQXhySEh6bWw5NHN2R29u?=
 =?utf-8?B?TWxQeU12M1pnTVArb2N6TXJianB0dEZvM2FiUitpNGZZSk1GeHZtc2JqZDd1?=
 =?utf-8?B?QUcrS3BPaG9WRkpScjlrZSt6U2w3Tmxwb2JDQ0N5VDdsVWJXbEJMUlZRYUJU?=
 =?utf-8?B?NHdValBPMGpQejVUOVIycURUaDlJc2Y4cDRoUFozS3lDUkhpOE1Gc05RbFRk?=
 =?utf-8?B?WHA2b1p2K0dCOVAySnRrdFRIS0tPWmhMb0FlV0VBYXFjM1V5d0E0c1p5OHZi?=
 =?utf-8?B?MnZZU0dQZDJhY2ZUUi8va2pZeE0wS3FHVTB5ZTJuNHkybTBOWHU2Ny8yTnJQ?=
 =?utf-8?B?NzV4QlZDcGYyREZUZkM2MU1HOUVWaUgyR2NLK01ES1RYQ0ZHR3V4dDlwSk1S?=
 =?utf-8?B?SGV3WFRMOVYxalg2ZjQ4UWwzWWxDRlZybVdPZXY2TUpGUVFyTEs5RWFsVjFC?=
 =?utf-8?B?MWUvZVdhNTlzUHNRa3NzeVZpL0dYZVVYVUc1dEo0ODk1ZVA5WHZZNXBQVVN4?=
 =?utf-8?B?L1lwN0Y0MTJWSGZJWkFYN3N2Z2NKZXpsNFRYUldrZmN5T3BlSXIwMmF0QWha?=
 =?utf-8?B?emJkbGZ2QXZLNCtLMjFWWENyWXZpUEJFSUE3c3hrMytEbDlWVUFiWUxleklT?=
 =?utf-8?B?amdLSUFzTkMwUmIyTTlIbXdZWTJ4czYyOFZWYUw1RytHSk9nTHhTaTh0ZTll?=
 =?utf-8?B?R1dqR2MzMmE3UXBLRDNoeVJBVkJkV005elFTY3ZXcTBQUnplVm5DVlFqUUlu?=
 =?utf-8?B?VTVLVllpQTd6S3I3YnZCYjAzZ1I3Q2ZsMlA2VDJpZElmYzNvTmpFOS9TWUJH?=
 =?utf-8?B?YW90VmxJY3dyNm5jcmZxZWVWRzNOVlcxYkI0dTRYaE1SNmFaSzdWaGpLU0d2?=
 =?utf-8?B?MXphUXRZeHlhS3VleUZ0ZEZTcnpmV1Q0M05qMmQ1NFVmcDVBMWNWZGNTY05x?=
 =?utf-8?B?MkUyNUVmdXlyeVpxUzNFejRib3piazJiSTBHbTVyM1JpMlFWL3gzNXQwY0Zl?=
 =?utf-8?B?aWxaL0Y1U0l2ckx6WllYOFN1d3N6QlUwVU8reDI3SFQ1clMwMmpQenZnTzJP?=
 =?utf-8?B?YXBPRUh1Vi9URlNYVnhsZGZYcmtwVlBtcXM4ZGpRNnZxaTBuampXMmJUeVBT?=
 =?utf-8?B?ZDVHK1BaZUZyWnlKOWVIeldqWVc5bDVLUi9sbGkzZXRvV3lpaGsyaVU0T29q?=
 =?utf-8?B?OXhIc1JBM1daZlZXYmtRQTJBR3Y2MVZ6OTZuRERsQks3RlJ1bEVHcXpxdzZz?=
 =?utf-8?B?QmptN3BPZjVNK1ZJbWd0Z29rU2dJa3RhYzZTTGMxeXlFaW43aTlJemdVOHgy?=
 =?utf-8?Q?R3zA=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3810d25-1ecd-4ef9-43de-08dc4aa4cf83
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2024 19:18:09.8245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E0OIyJc2ZByj8Qn+t2oTwBdcc8/mSQjrYhjDATlWEHIs8PI2D0qv7I9H0QSvlq1Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6811

Any feedback or concerns with this patch? Otherwise can this be merged?
Thanks
Babu

On 1/2/24 17:17, Babu Moger wrote:
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
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> v2: Rebased to the latest tree.
>     Updated the pc_compat_8_2 for the new flag.
>     Added the comment for new property legacy_multi_node.
>     Added Reviwed-by from Zhao.
> ---
>  hw/i386/pc.c      |  4 +++-
>  target/i386/cpu.c | 18 ++++++++++--------
>  target/i386/cpu.h |  6 ++++++
>  3 files changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index 496498df3a..a504e05e62 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -78,7 +78,9 @@
>      { "qemu64-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v, },\
>      { "athlon-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v, },
>  
> -GlobalProperty pc_compat_8_2[] = {};
> +GlobalProperty pc_compat_8_2[] = {
> +    { TYPE_X86_CPU, "legacy-multi-node", "on" },
> +};
>  const size_t pc_compat_8_2_len = G_N_ELEMENTS(pc_compat_8_2);
>  
>  GlobalProperty pc_compat_8_1[] = {};
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 95d5f16cd5..2cc84e8500 100644
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
> @@ -7895,6 +7896,7 @@ static Property x86_cpu_properties[] = {
>       * own cache information (see x86_cpu_load_def()).
>       */
>      DEFINE_PROP_BOOL("legacy-cache", X86CPU, legacy_cache, true),
> +    DEFINE_PROP_BOOL("legacy-multi-node", X86CPU, legacy_multi_node, false),
>      DEFINE_PROP_BOOL("xen-vapic", X86CPU, xen_vapic, false),
>  
>      /*
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index ef987f344c..6ef4396fc5 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1989,6 +1989,12 @@ struct ArchCPU {
>       */
>      bool legacy_cache;
>  
> +    /* Compatibility bits for old machine types.
> +     * If true decode the CPUID Function 0x8000001E_ECX to support multiple
> +     * nodes per processor
> +     */
> +    bool legacy_multi_node;
> +
>      /* Compatibility bits for old machine types: */
>      bool enable_cpuid_0xb;
>  

-- 
Thanks
Babu Moger

