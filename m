Return-Path: <kvm+bounces-13475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 983378974AC
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 17:58:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 65DDDB2F5EF
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 15:56:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71FFF14A63E;
	Wed,  3 Apr 2024 15:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zqaPCyu3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2112.outbound.protection.outlook.com [40.107.100.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D8614A4EC;
	Wed,  3 Apr 2024 15:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712159750; cv=fail; b=KeLO7Z0dcAwgHxMbj0/ZuYwnBjgnpzAfMGMrAL2xCDYyypS90OmbsQUOPlilv2Gee2sWSzP+Kl897XK7gv9bpZyitvKwzsGrTBImFTdBJaLq1bLYgssYDADTcTQpZsrObBB9NMRskUned7WlItt0Ksfd1MAJGMXbisuTgjcTTBo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712159750; c=relaxed/simple;
	bh=qfrYQjU4USrEBYawgEZhEKLdhHrIWZYlxjMObL7dlCY=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DC5afh7aRXs95kZ09zZR2mlv0gX11iBPhwQ5l6ItR8dN5YMFakqJaK1ZRpJ9Xx16RdqDYPTlf3F3huCZ3L+GXTOpRcRfEWKwMbzE0lyiXmiSOcL/Zjk7WSb5Q7aunm7XPLMzxBMGxHY5jh95I9wLHP69XJHVNNnWdVdLk44/ipI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zqaPCyu3; arc=fail smtp.client-ip=40.107.100.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJ3kdH5kd7uKy0elVG+or3/WjutxzQcy5Obd9laEIc9Qum4kvpDBNfkj/XonDzpn6iFhxRH3nrULUxYVzu1p650YHUvQMoOpDyXaD1die8h+URxz/EGLYEavDDsPyNFp0u01uiOUXO7RjfCRSRRcNlo+uo5pkTQTpAeqb9C/wgqagvXFo1QEk4Aq4h9hRWyAbXvNES/tV2klTiYBRiw2ZB1l0zaEGR1pp5kQTpPKYd29f9hyj1gcWzyd3B8M1EK4NsN5cHm1Jfj/396RTFwzGzpnlQG++O8ScEQxVtqO5cuUmyTQ4DATzQ9fCbSel2GSueQE8m32ZGBaFOerwNDljg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xcNPQFkxgNBplDbNxc+kcUPvW/gsV3sBVhtG/g0PTeE=;
 b=Fnb7bukOUdX0pAv6CYB+BhHep9QMDAMzF1gApaJf1jPZ3oa+oHd/roR5PNORoabFw4HXGSfjPEUfmGDqIv/q9NfFbvOTtQ/QaSNzx4Lq8xzSkurFAbFNEsIg5fUuuiFG4La1TjATmoej2uPju4aWSoT5gXUtbW+OBDyMxcoXAXWPax2wrbC3R9yu2XxAsB0abtg5W9tpL7fj6O3NXmyPyrBqdYcZDiP0/ESiIep2j3TZ6ArPVfRKcJ7pNUs/vAMDj2W2hnbYu2x+3I0QDdQJ9ULcF1pBzwoUl25mebtOEx4/of3Hb1muxqjx5V1lM5cOIWvxneg0UkpK1RRXmB7FRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xcNPQFkxgNBplDbNxc+kcUPvW/gsV3sBVhtG/g0PTeE=;
 b=zqaPCyu3j77UIx9k2+Og7pEh5Ckz+UTYDrGgLVUyfqm2awC8aU+u1U2jK7nW29ki8zVYi+2rB3jqBqrt6gsGhGcEitqxasU1iZx4IiXPUHwr5iDF9WTMC0B0bwjNsh+eGr1PlxRg+9QOfuTMkh/f1DZBPVfQPmZ/KNHxE5Zv7XE=
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by SJ2PR12MB7991.namprd12.prod.outlook.com (2603:10b6:a03:4d1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Wed, 3 Apr
 2024 15:55:45 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1032:4da5:7572:508]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1032:4da5:7572:508%6]) with mapi id 15.20.7409.042; Wed, 3 Apr 2024
 15:55:45 +0000
Message-ID: <07f6fffc-5c96-48c6-4df9-74010a28d283@amd.com>
Date: Wed, 3 Apr 2024 10:55:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3] KVM:SVM: Flush cache only on CPUs running SEV guest
To: Zheyun Shen <szy0127@sjtu.edu.cn>, Sean Christopherson
 <seanjc@google.com>, pbonzini <pbonzini@redhat.com>,
 tglx <tglx@linutronix.de>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
References: <1860502863.219296.1710395908135.JavaMail.zimbra@sjtu.edu.cn>
Content-Language: en-US
In-Reply-To: <1860502863.219296.1710395908135.JavaMail.zimbra@sjtu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0339.namprd03.prod.outlook.com
 (2603:10b6:8:55::18) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|SJ2PR12MB7991:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5NKyqVMJGdprB/fF0fd69NYc2kqh7R1XCmUi6NzTFUHt/z+SkeMtRZlsPlQ+ogOVqI4No0qHnMsQDEB02Pb4WVeotOXwrrGYLCh5suIeOGffkdKa2SI+/RhgQlQSaz7RdCH2EnNQG2s/P4G3DTAsDOqqPfMGbkmlPR6GpwqsgirJx2a8o1HFQ33MnlHLF/N5ipniUuMxiJTYJYTfHJJS3jClEEGVMd/s9ai/k4gEeZwy8zVOISScTB0iL29c0wNit3Mjoa4yWT3u77sQ3NnVWpCAKf6py8rweQDDy1yk+GNG0FDSvkFzyMvmargLaD8L3a/jYzxD2Rk+9W207Wc37QUNsoafSrujvFiNUyvVjjGgeDvMV64oXUOb7LSpWkz+FWw8qe5tglGM+JICWwOQgmbUSgij0Pdon7cY997AipPQlxJOiQaWeOWJuyU9tHkSMbPYbyg3n0cGSeBY97cjM0eZKf612MmKy1vbKaHyW6ynavPUxNWbDKtRh4f3iINA267x7/DgEcjYNW3BPB1q+aN8pVKMM3vUljUCvOWvCG+k+N9EJ9F3FCnPB/kIaETwX/BEG9DBkgqkFxq6RbLTYRFin/GIcxCowFCeX0k+RDXkYxtx0ZgoUp1RtqNsvofP2RXlVOnZxW4FGKObHwcrXv6vc+EMfRgYQ31ciLRn+4g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R0FQNDRhNTJJNTg2WUpnVlFSckdBWURUeDJoTmJvU3ExbWIydGxLVjVXNUFK?=
 =?utf-8?B?Y1hzdElMNHVtdG9FTW8vM3ZIOUFUSjFwQXFIcmovTHI1MVRKd3pXWE9JK29B?=
 =?utf-8?B?cVVOTFBIY0tPZmdEMmFiY0tVMjFaT0w3NHpIcU05ZzcwT0Uvd1NDL2ttS3p6?=
 =?utf-8?B?R1BoMkZJRHc3VlNEdkJOcEdRN3plV2dRWVV1b3hCZFVqQmFIdTRZM2pNN0Ny?=
 =?utf-8?B?RENqTWJIemNtZC9HRWNVdmIyV0lORjdKZkRJU1dyNC9jVlpGMzFFZmNjK2FH?=
 =?utf-8?B?eGlDR1BsRWJQWUw0bXk4ZmNreUF5K29iSytZTnQraHkxdzNUWk1JQWJGbmJW?=
 =?utf-8?B?S2VBNFUvRjdiUkMrbkxDUDk2K3lnNGdZZlNrdGVKY2JmNTNGeW04ZHUwVXFP?=
 =?utf-8?B?OUNvMFl4OGRMQ29qV1F0R1U2MTlTcnlPdkl6MnZMSXRMQWgyanl1SDM5MWtD?=
 =?utf-8?B?VnRkL1UvcjE1RVlNUWhpR09sNDRsaWRlQWlBMGg2QzlETTF5MzJsaEhnelFV?=
 =?utf-8?B?TFVNNHZpOFg0cFkzU3N2dVNYTEk5c0dpc0t4djlBNmRJYUVQL3N1NGg5R3dC?=
 =?utf-8?B?bU5CZi9ZVzRWWXhOWXhIN2t4dTgzWmtaeXFvVXEvZEF3K3hqMDEwTDkwL3ky?=
 =?utf-8?B?cTQ0ZEJ4RmNzSTJGQVM4ME9UYkt1cGNDaUpQMm1FVXF5cUhSaDMyNk55RXA1?=
 =?utf-8?B?TVJRaGwxa3ZMQXVMNzBhR0txbVFobEdlcUs5QVY0YlVPZHhkYnRHQTNYbjFJ?=
 =?utf-8?B?blYrTGovM0RxZUUwbEo0QW9pS2plOG8xOFJ3Zk5FTSt2WHJuQlNrV2hwRUFt?=
 =?utf-8?B?bERSY0NuWUtVQnpBYm1USS9rNitYQld2dUhBWWlMSjNNclpLdnJaL3hwbHdE?=
 =?utf-8?B?L0w2OVVwZVpoRkN0R3NWUlBxUE92L1YvdkhOdTgvL1VodWo0MWh0THRIODdJ?=
 =?utf-8?B?S0JpNUtCM3JacEdrdkgvRVp6eWMrWVZad2xZcDBqQm9XUzhWcEwxS1BCNlp1?=
 =?utf-8?B?YXYreU1lUFVUeTU2d0s2OTVUZCtCTm9DbGxPeW42UWxHelBDZWNZVFovYWNl?=
 =?utf-8?B?OXJtL0NZd216ZjFUeWZodUxLR3hPeXJXRWtRWFUrb3Fub1VEYnhUbElmcDBh?=
 =?utf-8?B?cHExMjJLbG55d2poc3Z1SWlkQ1Roa0lRKys3VjE3OWc4cU9sdC9NdjYyYVR2?=
 =?utf-8?B?c3Q3Rmk1bGVZU1I3OEpoa1NEUHQ5SmJkM2RjeTdEQVRVYlplODBQU0M2a3RR?=
 =?utf-8?B?Y21mS2NmT2NxYk00RlRPQzE1TUdFZmx1QUJlUmJoUGcvdmN0ZUIxaHFGWmFY?=
 =?utf-8?B?U0RBeVNKcmVSTVF1WGQxalhRVlgxU0lFQjhVZE5EcWlEMms2cTdlZCtrRjNa?=
 =?utf-8?B?Z1g1NzZTNXR6Mi8rYkNmMVV3ZVRqNitmSUJ4QytUTlJOdUk1cFp6UDZFdnR6?=
 =?utf-8?B?YVFCQWNPSVFtYXREZDhUdmx4U2NuRDNIZEE3YVpoUkYzQ2N0S3BrSUpQZktn?=
 =?utf-8?B?SzB3VWtycSszTW9hbEoxQkFGT1lBUEczRlBtdjZZbGJGUThHUFNuWXhmOUxm?=
 =?utf-8?B?b052ZjJxQXF0RTVKaXZBYzlzYVkwNzcrT3czSjVIKzBqVndxWFBXbHZoRTJq?=
 =?utf-8?B?aUZBRjU3N3FBK3ZqVkpVSFNPYXpxbHE1cVFjdU5jb3dWYnFMWHV3Y1lQeDg5?=
 =?utf-8?B?eXdoUnk1REROSTFQLy9oKzRmSXJNekU2Y0poVEJ6cnFaRFZ2U0IyaDZGUzN6?=
 =?utf-8?B?eGVlOE4xRCtCQVFSNE1KdTdsQ05FZzhIQmh1U25MSHZWbnZjWG9WUGRKSCtp?=
 =?utf-8?B?a2w2K2xsbzBmWmJBSmUyUE80eUx1ZzBCOVBmRXYwWE1XRDZkU2FmTnVZUGUx?=
 =?utf-8?B?a1dSMTNDbVZUYlExRnJwVWlQVWx4WVJTWTVaWS9lUHpEN2ExYnl4b1ZWdWpL?=
 =?utf-8?B?ZGxobi9vMnNnTE1NSllHcjRUY3Q1TGRGTTlRMExpOHVlSUk3MjZNbm9CNGpM?=
 =?utf-8?B?KzdyYW1TaG5LRDFKRGZ1N0htYWFRVGxpYlJrSm1HdFVWSGl5aWIzUFQ4MTE3?=
 =?utf-8?B?bVpiMldGK0hBQzBNUGs2dEg5TklUTHgvcThtMnEvSEU3czhlRmlkZXppWjM5?=
 =?utf-8?Q?MDPq/+ko4ww0AXGG7SkB1FITl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 092b6c9f-caa5-4de8-0151-08dc53f685ae
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2024 15:55:45.1029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ryXfQWKihW1zrTR7S7sVOTbNFohrucSpRD/SwG8dLF+5s22M32bWEBY4R1k8rXJ8Dx/UcO5mzxNbBTZK8M83Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7991

On 3/14/24 00:58, Zheyun Shen wrote:
> On AMD CPUs without ensuring cache consistency, each memory page
> reclamation in an SEV guest triggers a call to wbinvd_on_all_cpus(),
> thereby affecting the performance of other programs on the host.
> 
> Typically, an AMD server may have 128 cores or more, while the SEV guest
> might only utilize 8 of these cores. Meanwhile, host can use qemu-affinity
> to bind these 8 vCPUs to specific physical CPUs.
> 
> Therefore, keeping a record of the physical core numbers each time a vCPU
> runs can help avoid flushing the cache for all CPUs every time.
> 
> Since the usage of sev_flush_asids() isn't tied to a single VM, we just
> replace all wbinvd_on_all_cpus() with sev_do_wbinvd() except for that
> in sev_flush_asids().
> 
> Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>

Ran this through our (somewhat limited) CI and also on older hardware. 
Nothing bad happened, so:

Tested-by: Tom Lendacky <thomas.lendacky@amd.com>

Note, the patch itself seems white-space damaged - what should be tabs 
are all spaces.

> ---
> v2 -> v3:
> - Replaced get_cpu() with parameter cpu in pre_sev_run().
> 
> v1 -> v2:
> - Added sev_do_wbinvd() to wrap two operations.
> - Used cpumask_test_and_clear_cpu() to avoid concurrent problems.
> ---
>   arch/x86/kvm/svm/sev.c | 27 +++++++++++++++++++++++----
>   arch/x86/kvm/svm/svm.h |  3 +++
>   2 files changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f760106c3..743931e33 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -215,6 +215,24 @@ static void sev_asid_free(struct kvm_sev_info *sev)
>           sev->misc_cg = NULL;
>   }
>   
> +static struct cpumask *sev_get_wbinvd_dirty_mask(struct kvm *kvm)
> +{
> +        struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +
> +        return &sev->wbinvd_dirty_mask;
> +}
> +
> +static void sev_do_wbinvd(struct kvm *kvm)
> +{
> +        int cpu;
> +        struct cpumask *dirty_mask = sev_get_wbinvd_dirty_mask(kvm);
> +
> +        for_each_possible_cpu(cpu) {
> +                if (cpumask_test_and_clear_cpu(cpu, dirty_mask))
> +                        wbinvd_on_cpu(cpu);
> +        }
> +}
> +
>   static void sev_decommission(unsigned int handle)
>   {
>           struct sev_data_decommission decommission;
> @@ -2048,7 +2066,7 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
>            * releasing the pages back to the system for use. CLFLUSH will
>            * not do this, so issue a WBINVD.
>            */
> -        wbinvd_on_all_cpus();
> +        sev_do_wbinvd(kvm);
>   
>           __unregister_enc_region_locked(kvm, region);
>   
> @@ -2152,7 +2170,7 @@ void sev_vm_destroy(struct kvm *kvm)
>            * releasing the pages back to the system for use. CLFLUSH will
>            * not do this, so issue a WBINVD.
>            */
> -        wbinvd_on_all_cpus();
> +        sev_do_wbinvd(kvm);
>   
>           /*
>            * if userspace was terminated before unregistering the memory regions
> @@ -2343,7 +2361,7 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
>           return;
>   
>   do_wbinvd:
> -        wbinvd_on_all_cpus();
> +        sev_do_wbinvd(vcpu->kvm);
>   }
>   
>   void sev_guest_memory_reclaimed(struct kvm *kvm)
> @@ -2351,7 +2369,7 @@ void sev_guest_memory_reclaimed(struct kvm *kvm)
>           if (!sev_guest(kvm))
>                   return;
>   
> -        wbinvd_on_all_cpus();
> +        sev_do_wbinvd(kvm);
>   }
>   
>   void sev_free_vcpu(struct kvm_vcpu *vcpu)
> @@ -2648,6 +2666,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
>           sd->sev_vmcbs[asid] = svm->vmcb;
>           svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
>           vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
> +        cpumask_set_cpu(cpu, sev_get_wbinvd_dirty_mask(svm->vcpu.kvm));
>   }
>   
>   #define GHCB_SCRATCH_AREA_LIMIT                (16ULL * PAGE_SIZE)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 8ef95139c..de240a9e9 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -90,6 +90,9 @@ struct kvm_sev_info {
>           struct list_head mirror_entry; /* Use as a list entry of mirrors */
>           struct misc_cg *misc_cg; /* For misc cgroup accounting */
>           atomic_t migration_in_progress;
> +
> +        /* CPUs invoked VMRUN should do wbinvd after guest memory is reclaimed */
> +        struct cpumask wbinvd_dirty_mask;
>   };
>   
>   struct kvm_svm {
> --
> 2.34.1

