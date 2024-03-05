Return-Path: <kvm+bounces-11075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CE4D872A75
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 23:51:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BC311C21961
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 22:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7140412D209;
	Tue,  5 Mar 2024 22:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aRMcisij"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6936512B17E;
	Tue,  5 Mar 2024 22:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709679094; cv=fail; b=CO0kKLc4wicpBuJ3QXDGhOpcM4FPNmc62pMABX7KCrQO14mEumQ0HNPbsvFrtxjuBY6w9/sNMR1Gs5/50RVDlo+8FsQS2cjwfqCQDTXT2j7sn7tOXdq9cltwULLx4dvgu8Ja5/kxcR6sulRdGcSfcNkmbEMG8jlB2C1b6E0KNTU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709679094; c=relaxed/simple;
	bh=Mh7kdjCyxN50fMPxjryvyfBLd7JCJMa0gcx1C8Ogv1Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=j2tOkI5d/bOgzdSKVOIFgXoobuzxakRXyj0GPr4WquRLCMW0z1CYvuUSRkWYc+yPJVHxiCOQV/lZG5Cj4u1Rn5bMxSwlzj4Lepq1iGOdsHO347PQ3ammUeaT28MHARNXeWdbTuDCpprRGk3D5+sFjYc4B+xtpAvez72yeA9hr5U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aRMcisij; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nsPVuD5nUrvd/blXZ4+7Z4b5/wMU8C95zKxHLIcMPul8VDdmngqGbJgB7iw8c7sETChXfoX9bVElxiNzboiHi3FyKdC3+axtBMx63EguKDv+ft+s2c11Va9J/rxjrwradTZTrHpve9CM2FlV3t9qCY5aOb/u3NMg8XrFM0991FoDFnuJGHKs729WlLMYDU9LVpUXrV7dUDl0hR47Agn1kYhOn9EzR1r103+FGMD+OCtfzL3Zugvvx/RghcfhmqQAiNyeuxGMC8Cok8MWdqwc7kPgFDq1HNeoiXkTcbLW6xHNuOTxkwLPEG6tdiAh5WEKzvIrqapTmvxbH3eUc9JBXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UWUtNbkGmVsVli8Qw79CDp6GVoWAdGdxoWY6K8wxMnw=;
 b=g3y/H3K7tBtjorMV6Hs5dGlarBjwwKDOS7rgVAVIX7W2NhN8gdn+H7GL5sVo3eTxJ8GADDFx5gRB6K74mxSFAG7BlPTqGR7GgC70lfBQwjWB0dNSf+iLd9GfIlnxpNSQUHadNNJABP9J1R1+ZoG6Qk/VTd53Fkt6rIjTRPZJ89e0I9zxAcHLnTJbswqyMbhd4+RtESGf9PZg/BmX6RYTNrvqsxwyC5WCMQ+cNOoNUEBJD5Zu5QNqUzZ7sQpvH83XYvXZ9yvC62nMb7zu1/Ozn9BQv9nV8LTJIaSIVuWAxTwJ19eGi9B2KC0InbBkHtbakQt2L9gnQlxQm5IZTSFV3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UWUtNbkGmVsVli8Qw79CDp6GVoWAdGdxoWY6K8wxMnw=;
 b=aRMcisijcG4OBduit7SNrybryy48ENkwuIFH76Z99pziBz8QPrG6YP5vfsDm80TlDzamRKi4gzLX/pVYZhZzvq1IgLzKEq5697Ksay8OZX6XBq5zWjs+DFbRE/mq9qfpKzv3XWvxKqG1A6TjihUNAbZRIgkGJJd3UjGwSB7/1Zw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by SA1PR12MB8946.namprd12.prod.outlook.com (2603:10b6:806:375::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.39; Tue, 5 Mar
 2024 22:51:29 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::4c26:40af:e1fd:849e]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::4c26:40af:e1fd:849e%7]) with mapi id 15.20.7339.035; Tue, 5 Mar 2024
 22:51:29 +0000
Message-ID: <edd86a97-b2ef-49e6-aa2b-16b1ef790d96@amd.com>
Date: Tue, 5 Mar 2024 16:51:27 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM:SVM: Flush cache only on CPUs running SEV guest
To: Sean Christopherson <seanjc@google.com>, Zheyun Shen <szy0127@sjtu.edu.cn>
Cc: pbonzini@redhat.com, tglx@linutronix.de, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <1880816055.4545532.1709260250219.JavaMail.zimbra@sjtu.edu.cn>
 <ZeYK-hNDQz5cFhre@google.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <ZeYK-hNDQz5cFhre@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0048.namprd13.prod.outlook.com
 (2603:10b6:806:22::23) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|SA1PR12MB8946:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c0cd3ab-7ff4-4acd-7333-08dc3d66cb86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Ik2fgOOwU+1URutUei4nMQty++I8NjnLJgLW6NPOd0vkq+qx0xyBBK9nfQng0CN94vUowE5KHv5loAEokkhsjPRJZq9lCngNgQ6f9w9Qb8idEF76LpYnYGKAWB3WfoeYAndB67Zp4ZJVlHLGEFGrYfEcr6H5uhpjPxR1a8IVaI0I7Qo1CeXuy4sec0qvR2NeMn67hbQlmM58ekAa5cZiA91QoOJUI1WtgeGbEx7+ND/ZFk4hS41U3wT7DS2KY6fQ24g44ZJgVrZFcEqaYedAUUbZZJwcvxSgo+AJxpOhESXO0daAesArHLmOXgFPiVjBGEIF3oa35OAehkgpFV92u7WE8ry5TW4NnkHDVsil5AeKNCRmnf0Dfns/jmBuf1njsMpHt5lHnXEQ9DcMRzHAh6UF0Yvk6wQlMDcoblh1sk1JLQOYdMPYoawKYgNz0G7fim8d2F0EfvSTRv1ZqOYXoIAq2DZQg0NSDSxCrUocQrI++gYx9XCBoK2R+oAMwn1FKGTq8I0jsjmaT8WCSOpFqloO6WURVcpHfiyjRiezNyYiKQBloNZ7W1J6Gv4uT9pMX+rlCdxUANAtiqlAvOfTzMXo/xQHG5KZdP+y8zpFPWbc+/2OUvWJ7jxJbe1NzmWgDPDmtgfIi4kC2ArgvzTo0p78D6hCTjd25c8RLwrJw7c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q0QzeUNZV3lsb1hPUjZSeDNaZEZjc2QrYWc5TUVQckVGNTFRVUo0V0JBNjUz?=
 =?utf-8?B?WmY4cjlzZFpFN2JQWUFZMlRhUjdvTnVnN2lFM2tiUDlLcUlmc1k1VEMxUzFp?=
 =?utf-8?B?NEpIWTZORUp4blJhak1uUDZEY0lDYnkyTHBVbE5YZ1FUbGxNdHo4cm1pU1Yz?=
 =?utf-8?B?RGcwUWViZXdVeTFQdjRvdmZtY3pTR0U1NE5TWnljTGtHTEF1M2ZLZUtmZHc0?=
 =?utf-8?B?cVR6U25CRkJwSEwzQ1R5dFp4a2kzWEtKVFR1dzRaZTBQNUIvcHNRU1pDWEo5?=
 =?utf-8?B?WlBYZFBKZnNpUXBpQ044RlhaMWpUUWdDeHJPSzRKNjduMHRJZ1pvYnNnR3dT?=
 =?utf-8?B?MVp2a2lxSGZPZmF1TVNORzVVcTRyWEJlRFpsQ3E2Zk9YTThOd1UxblBJdFpt?=
 =?utf-8?B?VEhiMTl3LzdCMnNGSGk4dEUxRXU0RU8yakY2UURHSmd1YVhlRmdISG5XdDVu?=
 =?utf-8?B?ZmlYWFhsdHROdlpNdHVvZEJ0R2FNbmo4bFdKNEdQakNwOW1kcTZDNzNvVExU?=
 =?utf-8?B?OG1wREtxU2d6SDhDMlRaamc2dnFpTkprNWV3UDJEK0xPcHpyTzAxbThkQmhZ?=
 =?utf-8?B?TVFCV3lTUSs2Njl0WGZVcXh4QXJ0KzFNQVVNQ0VNSkN2VlFrVmtCWk8rNHFo?=
 =?utf-8?B?WXlJV2FUWFVZY0UxZ0Evc0dxQ0dtTTk0ZmhnWSt0Rml0SWp1RlZtVzNZODA1?=
 =?utf-8?B?b2NaK2FZTEJuUU5NU1NzZlQ0VWlrQVZOSXNja3cwb044SkJ1OFpEMWg2dDd5?=
 =?utf-8?B?YXBhNFZ5VjNOUVM0NThQWFd2OER6NzM0Nm5TK2NkNFZyY2Qvb1VXcVc4dDZ0?=
 =?utf-8?B?enBPZ01EVU1ZTEtKNmdnQlpSaFRCbDRrdWFRSGV2UGNHQUR5VlZNd3BMUnpO?=
 =?utf-8?B?S1IwVWxqU285M3RiT2djZm9NZzMycHgxbVhiWHZhUE0zSTlZeXVYcGJuN2dU?=
 =?utf-8?B?cjZ2cGhVY0ZLallSZDFBUFRhczlSanAwalBGV3BhOWo1MVdOblRNZnJSQ2hD?=
 =?utf-8?B?R012V2JORFVXSEhqSUdtdGFseTNCbUZMaUE5d1JuSGo1SFpIb01ocDJsUk56?=
 =?utf-8?B?NWh4d1FzME9mTXR6KzR0ZEd5bkhja1NHbHBXRXI4ckwzNG55U0tpU0R0dDY1?=
 =?utf-8?B?TEg5bEpkY25aelBXTGpUVkExWGxnbGxpUHZkL1hOcFV6d0F2b0lOVWN4b29N?=
 =?utf-8?B?L1hqYzRFSmM4THBYR1RRL09uTDFtVE1jdkVKVHZEZytqQS9ZcktmVWdyKzMw?=
 =?utf-8?B?cXVMUUIyQyt4MSt2V2tPMnpCMTVZNm1lQSs0R1hRd281STJvRXZpVmJmMlFO?=
 =?utf-8?B?VWdOTWlxZmZTZXlBbFZDcmhhZGhJSzhZUUVjQzFHbjJBNVNRaVA3aDZnOEJM?=
 =?utf-8?B?VHVQT0RLc1h4ZENhWmpWZDd3QS9hVmZ0cjJhWjhPQXkzcHdTWmJzeE4wcHRm?=
 =?utf-8?B?bCsxc2xaRUYwemZjdm91L1piYlJDQXp5KzNEc0RhV0JIRVNjQkVuV1FHMlIv?=
 =?utf-8?B?Z1luZjAyRDF2VHRDbVgzWjJYV2dlQVdCNTVuQnlQSEQ1SmlTU0x0K0toSnF1?=
 =?utf-8?B?L0dKQTZMZ0t1SzN3TnJxRjNYVCt4cVdkRVg3bHJGZzI1dU4xTGNjNGpLSXhT?=
 =?utf-8?B?Q0N6TmczelhmV2pwaDVmMUhNVkQ0WUMyRUF1YkVmNHJNSlpNZWoxcHZJQjdF?=
 =?utf-8?B?d0dBY2k4K084VWFSNTEycmZOY2VyY1dudUxuS1h2YUR0S1hObjdJcUJOR0Vh?=
 =?utf-8?B?emp0cmx6T0I0a0JpSUoxditSNlp3RmczZFl2NVpJU05aWFd4VWw4Y29yREF5?=
 =?utf-8?B?cTNZQXJQWjZEZ2lPT0NBajUxRVVoQTFMZGVaY2YwdG9peWhnQ2QwY1ovaGVK?=
 =?utf-8?B?WjQ3eWFtWmFkMndmTTh3UEdFVjRhUWowOEpGRVRSU2RHS2o4TVZQQnV2Z2xr?=
 =?utf-8?B?NXBGdlQwOUtuSllkajBMK1diY2JSenVmVTBWYUg2SitYTDFYdzVJTS8vZUhF?=
 =?utf-8?B?VEtaOVUvbzBBT3d5MVAwSkZFTUFmY3lkcDA0enNONnM5ZG9obTNTdDNlc2I5?=
 =?utf-8?B?WHJSQldzRWxuSVhHZUZSOERXZHBHRnUrYzN2MlNIc3VNUThHRDZZMUYybGd3?=
 =?utf-8?Q?BTezSSdWgHveambEocUhy2daP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c0cd3ab-7ff4-4acd-7333-08dc3d66cb86
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2024 22:51:29.2226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EtBTzRDEjRkfR2CR9OdSpIpBeP6XjfnmVhARKgOPdTTuEaDGr5aRfpOMFhYNJGdijqPno5XRJN8I9xRKpncLGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8946

On 3/4/24 11:55, Sean Christopherson wrote:
> +Tom
> 
> "KVM: SVM:" for the shortlog scope.
> 
> On Fri, Mar 01, 2024, Zheyun Shen wrote:
>> On AMD CPUs without ensuring cache consistency, each memory page reclamation in
>> an SEV guest triggers a call to wbinvd_on_all_cpus, thereby affecting the
>> performance of other programs on the host.
>>
>> Typically, an AMD server may have 128 cores or more, while the SEV guest might only
>> utilize 8 of these cores. Meanwhile, host can use qemu-affinity to bind these 8 vCPUs
>> to specific physical CPUs.
>>
>> Therefore, keeping a record of the physical core numbers each time a vCPU runs
>> can help avoid flushing the cache for all CPUs every time.
> 
> This needs an unequivocal statement from AMD that flushing caches only on CPUs
> that do VMRUN is sufficient.  That sounds like it should be obviously correct,
> as I don't see how else a cache line can be dirtied for the encrypted PA, but
> this entire non-coherent caches mess makes me more than a bit paranoid.

As long as the wbinvd_on_all_cpus() related to the ASID flushing isn't 
changed, this should be ok. And the code currently flushes the source 
pages when doing LAUNCH_UPDATE commands and adding encrypted regions, so 
should be good there.

Would it make sense to make this configurable, with the current behavior 
the default, until testing looks good for a while?

Thanks,
Tom

> 
>> Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
>> ---
>>   arch/x86/include/asm/smp.h |  1 +
>>   arch/x86/kvm/svm/sev.c     | 28 ++++++++++++++++++++++++----
>>   arch/x86/kvm/svm/svm.c     |  4 ++++
>>   arch/x86/kvm/svm/svm.h     |  3 +++
>>   arch/x86/lib/cache-smp.c   |  7 +++++++
>>   5 files changed, 39 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
>> index 4fab2ed45..19297202b 100644
>> --- a/arch/x86/include/asm/smp.h
>> +++ b/arch/x86/include/asm/smp.h
>> @@ -120,6 +120,7 @@ void native_play_dead(void);
>>   void play_dead_common(void);
>>   void wbinvd_on_cpu(int cpu);
>>   int wbinvd_on_all_cpus(void);
>> +int wbinvd_on_cpus(struct cpumask *cpumask);
> 
> KVM already has an internal helper that does this, see kvm_emulate_wbinvd_noskip().
> I'm not necessarily advocating that we keep KVM's internal code, but I don't want
> two ways of doing the same thing.
> 
>>   void smp_kick_mwait_play_dead(void);
>>   
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index f760106c3..b6ed9a878 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -215,6 +215,21 @@ static void sev_asid_free(struct kvm_sev_info *sev)
>>           sev->misc_cg = NULL;
>>   }
>>   
>> +struct cpumask *sev_get_cpumask(struct kvm *kvm)
>> +{
>> +        struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> +
>> +        return &sev->cpumask;
>> +}
>> +
>> +void sev_clear_cpumask(struct kvm *kvm)
>> +{
>> +        struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> +
>> +        cpumask_clear(&sev->cpumask);
>> +}
>> +
>> +
> 
> Unnecessary newline.  But I would just delete these helpers.
> 
>>   static void sev_decommission(unsigned int handle)
>>   {
>>           struct sev_data_decommission decommission;
>> @@ -255,6 +270,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>           if (unlikely(sev->active))
>>                   return ret;
>>   
>> +        cpumask_clear(&sev->cpumask);
> 
> This is unnecessary, the mask is zero allocated.
> 
>>           sev->active = true;
>>           sev->es_active = argp->id == KVM_SEV_ES_INIT;
>>           asid = sev_asid_new(sev);
>> @@ -2048,7 +2064,8 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
>>            * releasing the pages back to the system for use. CLFLUSH will
>>            * not do this, so issue a WBINVD.
>>            */
>> -        wbinvd_on_all_cpus();
>> +        wbinvd_on_cpus(sev_get_cpumask(kvm));
>> +        sev_clear_cpumask(kvm);
> 
> Instead of copy+paste WBINVD+cpumask_clear() everywhere, add a prep patch to
> replace relevant open coded calls to wbinvd_on_all_cpus() with calls to
> sev_guest_memory_reclaimed().  Then only sev_guest_memory_reclaimed() needs to
> updated, and IMO it helps document why KVM is blasting WBINVD.
> 
> That's why I recommend deleting sev_get_cpumask() and sev_clear_cpumask(), there
> really should only be two places that touch the mask itself: svm
> 
>>           __unregister_enc_region_locked(kvm, region);
>>   
>> @@ -2152,7 +2169,8 @@ void sev_vm_destroy(struct kvm *kvm)
>>            * releasing the pages back to the system for use. CLFLUSH will
>>            * not do this, so issue a WBINVD.
>>            */
>> -        wbinvd_on_all_cpus();
>> +        wbinvd_on_cpus(sev_get_cpumask(kvm));
>> +        sev_clear_cpumask(kvm);
>>   
>>           /*
>>            * if userspace was terminated before unregistering the memory regions
>> @@ -2343,7 +2361,8 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
>>           return;
>>   
>>   do_wbinvd:
>> -        wbinvd_on_all_cpus();
>> +        wbinvd_on_cpus(sev_get_cpumask(vcpu->kvm));
>> +        sev_clear_cpumask(vcpu->kvm);
>>   }
>>   
>>   void sev_guest_memory_reclaimed(struct kvm *kvm)
>> @@ -2351,7 +2370,8 @@ void sev_guest_memory_reclaimed(struct kvm *kvm)
>>           if (!sev_guest(kvm))
>>                   return;
>>   
>> -        wbinvd_on_all_cpus();
>> +        wbinvd_on_cpus(sev_get_cpumask(kvm));
>> +        sev_clear_cpumask(kvm);
> 
> This is unsafe from a correctness perspective, as sev_guest_memory_reclaimed()
> is called without holding any KVM locks.  E.g. if a vCPU runs between blasting
> WBINVD and cpumask_clear(), KVM will fail to emit WBINVD on a future reclaim.
> 
> Making the mask per-vCPU, a la vcpu->arch.wbinvd_dirty_mask, doesn't solve the
> problem as KVM can't take vcpu->mutex in this path (sleeping may not be allowed),
> and that would create an unnecessary/unwated bottleneck.
> 
> The simplest solution I can think of is to iterate over all possible CPUs using
> cpumask_test_and_clear_cpu().
> 
>>   }
>>   
>>   void sev_free_vcpu(struct kvm_vcpu *vcpu)
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index e90b429c8..f9bfa6e57 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -4107,6 +4107,10 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
>>   
>>           amd_clear_divider();
>>   
>> +    if (sev_guest(vcpu->kvm))
> 
> Use tabs, not spaces.
> 
>> +                cpumask_set_cpu(smp_processor_id(), sev_get_cpumask(vcpu->kvm));
> 
> This does not need to be in the noinstr region, and it _shouldn't_ be in the
> noinstr region.  There's already a handy dandy pre_sev_run() that provides a
> convenient location to bury this stuff in SEV specific code.
> 
>> +
>>           if (sev_es_guest(vcpu->kvm))
>>                   __svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted);
>>           else
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index 8ef95139c..1577e200e 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -90,6 +90,7 @@ struct kvm_sev_info {
>>           struct list_head mirror_entry; /* Use as a list entry of mirrors */
>>           struct misc_cg *misc_cg; /* For misc cgroup accounting */
>>           atomic_t migration_in_progress;
>> +        struct cpumask cpumask; /* CPU list to flush */
> 
> That is not a helpful comment.  Flush what?  What adds to the list?  When is the
> list cleared.  Even the name is fairly useless, e.g. "
> 
> I'm also pretty sure this should be a cpumask_var_t, and dynamically allocated
> as appropriate.  And at that point, it should be allocated and filled if and only
> if the CPU doesn't have X86_FEATURE_SME_COHERENT.

