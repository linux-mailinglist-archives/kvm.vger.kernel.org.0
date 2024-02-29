Return-Path: <kvm+bounces-10511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1479786CC94
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 16:14:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBAB8285367
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 15:14:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A290613A269;
	Thu, 29 Feb 2024 15:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5YEWCQYZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455EB67C71
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 15:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709219636; cv=fail; b=dfkCJzVLDSPfG2A3LQZIgVaUzILU/wdjxVGmtE2YPhhLCfkn2AJNSi+tpcTXpHIWeEYEhFF2FDrFioSw5Fz2VmKwjIRSzOs31Gzm5RZgZ6LWX8vu7b+8uib4ae10Ub53icAalfBASmFJtggCDG/4LjAEbXCq1Sx+r+B0D4kIvDw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709219636; c=relaxed/simple;
	bh=lr2j4XHIqCeqvCfh1Q+JtYF8ZewzkodVOpjzq/7ErSM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jdTZHR/Jij8FDDXNW3VEIFfrL0aNueCNmF8bszhrBwFYrNJo1UgItSXhu6UfVFAf6I29Ye0EMLmQtObb9X7+j4+ohxJxT9SM95qiF8SAR8CDPWwO4mHtXE6BQt3hcRb45LnUGqNtojHURBYfTbUMGJzIAF2p/77dEr/CjOROU0c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5YEWCQYZ; arc=fail smtp.client-ip=40.107.244.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LO8wzxGSydyAiWjHxqxEqeyIXHPHAOPPsuH8Yn+tzW1pIf3kevGuVpieEtrgYvip/XXrBBaPxLl8+Jsh82dasX1UoGMzOIlVsXiLjyI++ECyqUPCUn3tzOGnHC6IpdO7U48dEAa4bLTP8MlrcJ2ugJ9J8UhrX8kDd3j2nlM6uHregZ8Gz1aDoHYkMm4d6UhqO4F+kjoEQ5ucz3d7RirjRqX0VSIvg30caAHcnWW9RevA60tcG+/g1gixBxit/1xE5ujt905M5WNvL8u4HlN7boc0NMWhN6YWx6Bl4/vuJtpE1Tsu5ca73Y2LmuMbNGlrHyCF6wi73e5an35I4jK8fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a6CXqKYcykxJ8Rlt0CEWYhKeJk2OMgOnrSVn4JQxPQQ=;
 b=VdpW2N/Ho3VLxBQPnkMJetpqva8ljJuITxosCMMxyHAKhDU/L/ihkom2NRR9bWmdwf2WWnLAV4Su32XEoeu3dNghyLA5lDhAI30b5hmXxfpqyqFHK6zAmocqxnKbFlBulhjXYhREXcbRMYpxPvREb/VuYdCAK7Xffxq0E44nkLFRon3IfICc/gEjm6U+umH9yg+VhSZe/Zhcurb6rV3GHEXoRGo7pgbwQ2GCWbbw0C1Im6hsRIP7y9tOyybFkTmjyQCP9lOtWcip0hnN0qcCTqfivTUGy7Usf3Ks4lKLWrOq5vtD8knXUlBm77SUwpyXwBn+lYciqUQpJZIGkTqveA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6CXqKYcykxJ8Rlt0CEWYhKeJk2OMgOnrSVn4JQxPQQ=;
 b=5YEWCQYZi98Vb1urhpAQrCrZ4ROOXLZfa+wWnoq0RW5iqnkwPBF6yg9E6MhyOOoGk0NnZmE6CGbGZc/YfXrS+r5X82imDwwbxQDrOfyQ2ge+28TI2L3Q4xUAPVkXkb+NyVy19EGXNGbQCSYdnIhSLpKHsgl2j7NfdJ2OXXHkYWY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by DM4PR12MB8500.namprd12.prod.outlook.com (2603:10b6:8:190::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.39; Thu, 29 Feb
 2024 15:13:51 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b49d:bb81:38b6:ce54]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b49d:bb81:38b6:ce54%4]) with mapi id 15.20.7316.039; Thu, 29 Feb 2024
 15:13:50 +0000
Message-ID: <c2a77e1c-0c52-434f-b505-917aa7ec3d20@amd.com>
Date: Thu, 29 Feb 2024 09:13:47 -0600
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v9 07/21] i386/cpu: Use APIC ID info get NumSharingCache
 for CPUID[0x8000001D].EAX[bits 25:14]
Content-Language: en-US
To: Zhao Liu <zhao1.liu@linux.intel.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Zhuocheng Ding <zhuocheng.ding@intel.com>, Yongwei Ma
 <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
 <20240227103231.1556302-8-zhao1.liu@linux.intel.com>
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <20240227103231.1556302-8-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0077.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::22) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|DM4PR12MB8500:EE_
X-MS-Office365-Filtering-Correlation-Id: 07a54063-9dd8-4996-a6d7-08dc393908bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nMPfkYYjTG033Uf2yRiJuf5ZdpEKNWxyjUNcRTAiNFFSFct/f36yp/QcYAxOK35utAnYtinrs0BupxTA7meWrz4JAuX7im5L/VPsvGXfaEK5fKT8ObCJrJkDomaaJPnXh36d0thsmDNhO9FQI4sQ0D83zyBaWbgAbojK1QS0vRJz4ft3CYzRssrk7TtfVb2t43wBQJfEcH249zCwM8Aiq3YjIF+gBFoBRL1nml6T72V00W1P1fhAruXQHsBPIu/vdJobhSh2fNT2cXocalfIA4fNLH0IeSGdZTQRb98NyvifwymB0WyluJOC49lfkluC2ot3wvjHQ012KYoqQ//mzk2n7CAoDPXlTIXH0iZaddn74RCK41E6LO389HgXxXjHxVMSXdbleT9/WRpYzTlJQkG0thNOyz8QoRJ6uW30xfJPvqNw+3qLmzoxKYmihzcQ4ye/2Rw8s9oAxkmCil4Y/dj0kPOYyAWaLBN48+6YLPSUrM0j9GyNczNkimV68cGD3ovDJ3xSE/yv7RGRnL2lfOO9ZMoYhYViWYZ4Ty+Ju+ajkX5MuF39Lj0TRm8HSKiy/n+wgQIc1Ozah3UxAgz+mjKkOB8mynliH5sX4zxojDRaLOe57ejdC+YwoOsrSCjvWSHdD1WlFeEyZDhwQy3G11Q85EZ4G97y0+80eoKt9GLkFpoqUxLE2I+J89660OQPtQ2qBWYAOrZuQ4j4fHe2wg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aHBPMFVLTFF6OVEwcnd6bGhBbXdCaCtVUEhBdTlQZ1Z5ejdtbldLYnUwTXJj?=
 =?utf-8?B?ak5kcXNlcmh3M05hbExPbmNEUEZXcGd6eFJVVEwyM0Y2bWZ2WUhweEZQSFZs?=
 =?utf-8?B?S1ZvbVpSei9Zei9tdzhVZnQ1WWF3bXdsc0E3ZWd3S3FOZnh5dUNHZy85WWdH?=
 =?utf-8?B?M3N2N09OeUlia3B0bkh2dGx4dXVaZzJCcmhyd1lBdHd6RVdWbHFubjN4SGNN?=
 =?utf-8?B?R3FNZ00xdUZydFlGNkVQTE91QWpmZ2d5U2ZwMVJMSG1OK04xL0JJYTQ2WDA0?=
 =?utf-8?B?RU1Ld25QaEduKzBoSzBadXdTNzFtdmtDaE8vb0lGODdkU0E4QjJKYUJZYVFC?=
 =?utf-8?B?eTRWcHd4QkJhYUxWbEhIM0pxbHhLV0VQYkVTWWcrckVyYjAzaWZhYkZvZE1r?=
 =?utf-8?B?elg0RjNRK0RmUUFVNjZoQ3FYQUpDbmZldnplR1M2RVhVczl0R0ZSRVNGZWpv?=
 =?utf-8?B?ek55VEZ4a24vNHcxZ0tpdEdNbC8zdERpYy93SlNpeGcvdWJXUFhjNDAzVjZT?=
 =?utf-8?B?MnVwSDcwbW1DSnN3VWFyN0U3eUN0NkgzMGNyWm4wa2lBTTJiTkdDVUtxNm4y?=
 =?utf-8?B?RVpvRU1NVlBXSzN2MzhOSThrblluZ1R4VzVuMXNXUTJHQUhUSzRabWVzZDgx?=
 =?utf-8?B?TUhmMWZiU0w1aDlYL3o0ZnQ5a0hGSVRRb3FEWEJoREgxdlZCV0tvRm54MktS?=
 =?utf-8?B?cUFNU1VxVzNKY0l6Tk1zTnhDSUcvWFpaZFdSUUREbUhPR0NwSzM4aHJZR1pS?=
 =?utf-8?B?Yk5MdE5Qa1pqSndINDhNcUpzVlNwMTRCMmhPMXIwMDlDZ1hVbS9jMnppMG9T?=
 =?utf-8?B?ckZCbXlYUzMvNlFLODB4aDJnbjc2NEZZV2RKb3g4aW94SDlOcVN6OTdQWkIv?=
 =?utf-8?B?NEExL05JK3hOY0xnenI5TW1YOTJFMGVSU0V6VjNGWFBwQW1ETnp3VnBseENw?=
 =?utf-8?B?MWxtODN2U0VsUnFGeFM2L21HUStFZ2hCVWJWZjkzUGcydHZ3d01NSnpOYnRu?=
 =?utf-8?B?amZDWmtMSjBzWHlYRnNyaVdjODRyQ2ptM3RsSDNBekxDY2JwWi9paTBtN2dD?=
 =?utf-8?B?Um9pcFVTSFNlbVExV0hZQkRWNjZaWFVvZk9PeGNWbzJGZ1Q5bEVVTWhxVkEz?=
 =?utf-8?B?TWVFU2syUXVIRjdrTGYzb2xnQkpNVHEza05zUFluVHJ2SmcrUW40TlJBdDFp?=
 =?utf-8?B?czY1TG8rVEd3N1JBRHlwbm5HenR3UzA5YzZhcWh1ZkZWOFJjNCtIWG45aGsw?=
 =?utf-8?B?YVNPd2VWK2l5R1NlaER4WTROYzRkSWhxVHJDUHdZa2FvSlo4eDA1aXJxeVhU?=
 =?utf-8?B?bkxacjNOQWhVNS96ekRDbElXNmg0cU1xVi9OcithVklWRFZVYURTeEdsYmx2?=
 =?utf-8?B?bHpLbnQvZUx2c0IwcHh0dXNPeW9oMjZPRjZ3VlNZenppTGNlVE1qRDdRREZC?=
 =?utf-8?B?czdLVmE0ZllOenhKb2JyMzZweVdQVkJxbGw1WjZURWhxaVVIODRaNEhSb2I0?=
 =?utf-8?B?MlVYNUJFZEhHRkdSNXZkQ3Myd0ZMUm9oWTk4LzZrWTk3RWhYaEVLb0ZwUUlQ?=
 =?utf-8?B?UnhGL3Q1cXJ5SXdmWUxuZFNQR2JETXFSUzNiZGlVVTVDcnA2NnBEaWs4LzQw?=
 =?utf-8?B?Y2V0d1ExTjIzRStVbXB0bytEZTNqOVo3U0hja2lQY0w2NHFSUXdSVk9aNFhD?=
 =?utf-8?B?Z2xSc1JFNGl3WFZEamVPcmN3VytmaUh6TjJwM3lETXlXRW9oOTlBLzhuU3Vq?=
 =?utf-8?B?VU05cVdQK0lIcUFzMk5hZE9Fc3RFUDRXUTNldC8yb0F1cFpzL0dZYmc5aWVh?=
 =?utf-8?B?d2Vpank4ZXZyaTl5K3dLRm42UnZ3MjlRd2x2ZnoralFESTRhRW9ZYjZGY0V6?=
 =?utf-8?B?cHBWTUg0a3pBc01rL2hSaHprVlBkSlJtT29SMnptNStJazY3WG1RY0VOVEZq?=
 =?utf-8?B?b3FhYTV2WXBneGUxUUtUNXpFR3VPek1KdjQzUWVCN0oyQURzeGswUEtYdmlG?=
 =?utf-8?B?dGhETmVyRXB2QjFKZ2dlWG5mdjBsMlRvdjF4bmRLVCtyTXJvaXNxMWd6TDla?=
 =?utf-8?B?aWd5dTBPRGk2WlV3NlRKeHZFZWFJejU4dnVpMi8xOWRHREt3VmNUanhBTGJL?=
 =?utf-8?Q?0Kak=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07a54063-9dd8-4996-a6d7-08dc393908bd
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 15:13:50.3718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v3MAqzZSc2sOV/Z6Lv6KCFzB6qXSq0+0xcMiADAZ3mx1tx4L50za9LBbi5J8CpCb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8500



On 2/27/24 04:32, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> The commit 8f4202fb1080 ("i386: Populate AMD Processor Cache Information
> for cpuid 0x8000001D") adds the cache topology for AMD CPU by encoding
> the number of sharing threads directly.
> 
> From AMD's APM, NumSharingCache (CPUID[0x8000001D].EAX[bits 25:14])
> means [1]:
> 
> The number of logical processors sharing this cache is the value of
> this field incremented by 1. To determine which logical processors are
> sharing a cache, determine a Share Id for each processor as follows:
> 
> ShareId = LocalApicId >> log2(NumSharingCache+1)
> 
> Logical processors with the same ShareId then share a cache. If
> NumSharingCache+1 is not a power of two, round it up to the next power
> of two.
> 
> From the description above, the calculation of this field should be same
> as CPUID[4].EAX[bits 25:14] for Intel CPUs. So also use the offsets of
> APIC ID to calculate this field.
> 
> [1]: APM, vol.3, appendix.E.4.15 Function 8000_001Dh--Cache Topology
>      Information
> 
> Cc: Babu Moger <babu.moger@amd.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>


Reviewed-by: Babu Moger <babu.moger@amd.com>

> ---
> Changes since v7:
>  * Moved this patch after CPUID[4]'s similar change ("i386/cpu: Use APIC
>    ID offset to encode cache topo in CPUID[4]"). (Xiaoyao)
>  * Dropped Michael/Babu's Acked/Reviewed/Tested tags since the code
>    change due to the rebase.
>  * Re-added Yongwei's Tested tag For his re-testing (compilation on
>    Intel platforms).
> 
> Changes since v3:
>  * Rewrote the subject. (Babu)
>  * Deleted the original "comment/help" expression, as this behavior is
>    confirmed for AMD CPUs. (Babu)
>  * Renamed "num_apic_ids" (v3) to "num_sharing_cache" to match spec
>    definition. (Babu)
> 
> Changes since v1:
>  * Renamed "l3_threads" to "num_apic_ids" in
>    encode_cache_cpuid8000001d(). (Yanan)
>  * Added the description of the original commit and add Cc.
> ---
>  target/i386/cpu.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index c77bcbc44d59..df56c7a449c8 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -331,7 +331,7 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
>                                         uint32_t *eax, uint32_t *ebx,
>                                         uint32_t *ecx, uint32_t *edx)
>  {
> -    uint32_t l3_threads;
> +    uint32_t num_sharing_cache;
>      assert(cache->size == cache->line_size * cache->associativity *
>                            cache->partitions * cache->sets);
>  
> @@ -340,11 +340,11 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
>  
>      /* L3 is shared among multiple cores */
>      if (cache->level == 3) {
> -        l3_threads = topo_info->cores_per_die * topo_info->threads_per_core;
> -        *eax |= (l3_threads - 1) << 14;
> +        num_sharing_cache = 1 << apicid_die_offset(topo_info);
>      } else {
> -        *eax |= ((topo_info->threads_per_core - 1) << 14);
> +        num_sharing_cache = 1 << apicid_core_offset(topo_info);
>      }
> +    *eax |= (num_sharing_cache - 1) << 14;
>  
>      assert(cache->line_size > 0);
>      assert(cache->partitions > 0);

-- 
Thanks
Babu Moger

