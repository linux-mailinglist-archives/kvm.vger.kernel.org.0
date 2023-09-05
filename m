Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA85792A70
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 19:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236962AbjIEQhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 12:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241415AbjIEQKD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 12:10:03 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2061a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::61a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BC71BCB;
        Tue,  5 Sep 2023 09:02:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mX0eXshGCaHsgDAzFTf4dOPttQJsTHsge8X54Aj5QKbcos5BIP+o0FnoKCmDei8aNY63ckScEwzfhHtwfJ3KUk1qY5aAHgCvh/kmh0vdhIhiGFRONNfv6zN7CKch0Dz4bMgckkCJwS4KZGxu4wrp934j4VRclEfITwfk2kKk5z+o40/KKjxhuMzd/dfua6RSjkAoJgbpx+/6fhEtNhEDCpp9p3hrxiwJZkyfOAxVReT9EETodJXGjj8kyzdiTHQikQw1bKkhTsAzp0AX117qZBI5Sc/t8njeS4zfeqD7ToMi7dut6yrrEUE3V3p0UNhvsduBEanlzvlA0hZw1NHOMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Gnnso5zIiYvxAJ0lWmkewY0PcrxQVsKSk0JpJ3+E8w=;
 b=bRBymqeE3qvafF1K8RkYfGzjyj++mS/rK0CB8PdMLPoHY/B4b0zgb44UMauKbxHW5LfxGQpfxELGT9dWMRhtw02gZ0bFKpwE81YLEId/UAIO5kvLmsn1e6ixp+Xovo5IvgPiAOr2hj58/ow2xL21xuAtbQLDrdtp7HTSK/tDOjkT4jFHEyJDCagySq0VYwvnbYjaRtIJARLR+ijvzPFBBsTjbbCDT60hDOhHe86ZhWI9RnwIBSeIVrVaFsrte5Q5zH92yjonQ1f+lgts3GAerXAiIaLDfsXsLVE4UWgGWuyjyDB28iWFCS1aSfUlSeDrE0/5Ck/FVZRKovGa/cwGXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Gnnso5zIiYvxAJ0lWmkewY0PcrxQVsKSk0JpJ3+E8w=;
 b=Buav8YAxmRKx6jrN+eWK66nDcIMuR7eamFJRngbKD4HFYWyptxZp8uO/75HTBvoIdGuoDwokfIvQK7VFFOaJS2JkY8rv5eahsvzPrnTC4UCCZeQBd73he4qZjl4BLMD5llugHXP6Y3b1h9AcC+vmeINLC0cNqV3H5PziA6pUwwc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DS7PR12MB6190.namprd12.prod.outlook.com (2603:10b6:8:99::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.32; Tue, 5 Sep
 2023 16:00:31 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 16:00:31 +0000
Message-ID: <aa466f6f-9b21-7bf6-84de-82b3aa722f36@amd.com>
Date:   Tue, 5 Sep 2023 11:00:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 12/13] KVM: SVM: Enable IBS virtualization on non SEV-ES
 and SEV-ES guests
Content-Language: en-US
To:     Manali Shukla <manali.shukla@amd.com>, kvm@vger.kernel.org,
        seanjc@google.com
Cc:     linux-doc@vger.kernel.org, linux-perf-users@vger.kernel.org,
        x86@kernel.org, pbonzini@redhat.com, peterz@infradead.org,
        bp@alien8.de, santosh.shukla@amd.com, ravi.bangoria@amd.com,
        nikunj@amd.com
References: <20230904095347.14994-1-manali.shukla@amd.com>
 <20230904095347.14994-13-manali.shukla@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230904095347.14994-13-manali.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR08CA0029.namprd08.prod.outlook.com
 (2603:10b6:5:80::42) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DS7PR12MB6190:EE_
X-MS-Office365-Filtering-Correlation-Id: 1329ca06-72b4-40bf-0437-08dbae29399e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7yedxH1wF3v+rnIuw7Z+cbep7OqdyCVOpi/lQY1McY73/+WfDzRBQWEndSRFpeq6MLCIreXZAFROhsSJhSpRD47UYxURVYbqXpnstEyw/nwqLpve98ctd+GT+0tL/mGWC/U+xjQboaQrRZe+XS8zzBpMxDBZl0VK+9nqN++rT73GdiGhzNHKXKEVsn9tlbeWXh86Fg2512dFfEV7G1rljEZs23z7KikGqhAmYfxmZnO2J1DT3z8RwRlhIfsO3M7vTrplqp/FCwb9TdWLtdoNq4UydjzQh4kGlLdnxzZntaGljKglExkhC7LKOnTj0ydGcdhb9u8X0lAeJZp+pW1wu+ZzeCnmNlp7Zp9VGF5Tbh3d3Cm0LAmUuBB545wca8iw+Th3xWKILXsHBjrXDu5MMvoUKQMTGA54zd+ULu1y8P3jD2/2cUqkwius7QbNagVy66aoWA8lethpTzPXPz1wPEQA3i7bAoq/TR+BBrcvc2oBtOIIux46Z1KfBkXBL60RiSTZOVSQDRaspGKXQQ77qkJfJ+VWdyqFOHQ5ZNHFbc4Hwc4iKVnb3alitDwRbfz/hGG5a2yT1M6lwNAHiUTp2U6KSGJpfWgEcROo+tiLN16e4QaEF7LWCVrmIo4rgfwIMS6dfBhQdEhXcZLWaCUO6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(366004)(376002)(346002)(136003)(186009)(1800799009)(451199024)(53546011)(6486002)(6506007)(41300700001)(478600001)(2906002)(36756003)(6512007)(38100700002)(316002)(31696002)(66476007)(66946007)(66556008)(86362001)(6666004)(8936002)(8676002)(4326008)(31686004)(26005)(2616005)(83380400001)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZTVIY3YwRWFYZUJHbXJCeWpsRGx6clExUjdJUTdoaGp0WnR1UmQ1SkpBdHVE?=
 =?utf-8?B?Slc1MXJRdnhtUXY5OUhiRnpIV2E3bmpvc3hHVmZ6Uld1alZqZnFtMklkQllq?=
 =?utf-8?B?eStVZ0VsUVJLNi9OcnVsU1YrRGdRMDQ3Ny9iL3VMV0dFaXgxR3ZzZ1FUT1VR?=
 =?utf-8?B?cVZnOGdKeS9PZ3VkbWFiNnp5Y2hUemhwR1VLcHJCOStJbUl0cDhWaWRQKzNj?=
 =?utf-8?B?d3NBSU5pdm9La3p4UDVZZWdwRlVyTU9id01zcXVnTlgwN05DQTBjanlZd1ND?=
 =?utf-8?B?T1QzZzUwNWJFbkFxZkxoTHZLeVNCODMyWHFCcUZLNnBlb1dGY1NPTVRlQ0w3?=
 =?utf-8?B?NVFwOWdiUTUvbmF5Y0ZEOFNIaVlPQUIxY0ZKbUZCT0hBUFBSR3BuaGN6TDNY?=
 =?utf-8?B?cFVwVkR3ZldPVDJRWnhYWmZZcXJWdm5LRG5WMGJuRkh3eURVZzRsRzVQcHQ5?=
 =?utf-8?B?Y1pqTjNFcDh1TFFta0hZakxtWkN5K3pZSm9BWEVicjBCa2xqaklrZFJoTEI2?=
 =?utf-8?B?ci9mdkhPTTJVeWpvMnZ3SUFlWnhIQWI1ZHoybWh6QU5MOUFFTnFXWThrS1JG?=
 =?utf-8?B?TFhSaXIrUTN4RmdPenZSdjhPZ2NRcHZBbU1DQ2l4aHNpeEQ5aXcxbkJzOVdz?=
 =?utf-8?B?TThpVVlUWUR0R2hQVEpFQjRsREx0T3VUMkp1Mk44NE54VlNJaS9UMjkvQURN?=
 =?utf-8?B?U1JJOGFZa3FaYXArR21zUlNtNTNEVXA5TEdTUkk3UVBJMGxnTEp0S1ZlRDEr?=
 =?utf-8?B?dXhqWndsN0xxbXdndGR3WGJyS1h0cFdIYmdZZXFhOGo2L3JyS2NyQXFJVytk?=
 =?utf-8?B?ZWRkZ1lvZzRudUNEK3dacDhYTHdDZjN6OXhheXNiSGlkSDhxMS9SRFRvMExn?=
 =?utf-8?B?M2J0WUtOTGNGSW0zQm9Vd2tPVU1IK2doMWFKYUw4NXFvaTBXQk5kVnRsM3hl?=
 =?utf-8?B?V3g5bktQcVVBZm9pK0dta3VwTWFMdzIxREZnWVh6QmlxVU1wbEw2bjVWZ2x6?=
 =?utf-8?B?aWJyMFN0bVp4WUhhNXRJUjZGWVoya3h5UEpzbm5nWHFpVk1Ud1NQbzZqdWJY?=
 =?utf-8?B?QUNWangxY0pIbEsrd0J1YXA5WlhXVGZyQ29nQnJmT1VlVm9lR0dySUx5Y21o?=
 =?utf-8?B?RUM0ekpROTVKQ1hSREtuVUIyNUNtaTJYdUpkUU9FYVk5R2tnckJNZCsyS1Fp?=
 =?utf-8?B?V3N1eWpqVnlCY3FLbXFZSUt6cUhyVlNRNFF1R09sRC9DRmYvcXl2RHo1bjF5?=
 =?utf-8?B?OHNFUk5LMEJFdHUvM3Q5aUE5UHdaT3BvUGNjRkdwVzV2elVuR3JxN2hpaVpU?=
 =?utf-8?B?dzFVMTJwSlpiNFYvS1N2WndndUNMK1IzcEhGY3dBRlJYOEZoQW1wYkVTRWZO?=
 =?utf-8?B?YzRab2Y4czZSZ05FNGlxS1lyOXZSYm5mbUFxN2NNWDkyTjRVUDE5a1NiSFNw?=
 =?utf-8?B?MndkYXc0U0IyMEtRVytrMGxEWnNXQ2dUenZ3ai9EeFdtdzNHeTkyS3k0UDhl?=
 =?utf-8?B?cVljZWRBQ1E2b0FrQStXbFE4OVpuRmZnek5OY3pBUVBRT0owVjJydHRDdGU2?=
 =?utf-8?B?aGNtY1gzbllCeDBKU3BVM0kvbGs3cjl2aFBCMmpNakVOYUlSeXMvblhadmZR?=
 =?utf-8?B?RWFCWjg5OWpNOTY0NUY5K1U2VXg4RVQ3Y09XK2hxeGFNblRzNmkwV1BORkxF?=
 =?utf-8?B?eXN2emVPdVZnTWFrS3VXNEo5N1NQQ09LMlgzQ3RIMExEeWpnMXBodm02RnZB?=
 =?utf-8?B?bzVtcTd3Qkd5ODVZSlFxY2lROTNOemowV0J3ZkZVZ2VoZVUrUzdkYU56V21Q?=
 =?utf-8?B?bnRJcDNrcmswWkxsR05scTdMUStxQVRvaWJEU2d5LzNQd3R1OGJiQWljb0du?=
 =?utf-8?B?QXpya3dmdkQ5b01YczczMXdZMFloLy9jNng2KzJIMTk0c0E5dzR4RCs2b0Mv?=
 =?utf-8?B?c2ZjRll2VkNLbVhCMHcxc0VIOHZ4cUZjWTJQZkJTTGc2QldoMVFZdk4rQlpy?=
 =?utf-8?B?WllKZG14NXE4QkpVSTVoYlF1NHVXUlAzTzRsSkZmYlQzV1Z1cmhISHptVUJ4?=
 =?utf-8?B?VjN0MVZyZWZvQkYvb3N1LzBMNWZ1ckxPcmVKa2h1UTE0T1dKd2JabFBEcEJS?=
 =?utf-8?Q?GPJkwF6uKuMX0hzMZR29iUZgS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1329ca06-72b4-40bf-0437-08dbae29399e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 16:00:31.5253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 45s6ubFNFiKFmoNGL8CwX2xn/Qu7dTezy52XwnKJ48O0c1A7PbtTHPM01VKZPMBibeJAskv8LhKzrgyXb081kA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6190
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/4/23 04:53, Manali Shukla wrote:
> To enable IBS virtualization capability on non SEV-ES guests, bit 2
> at offset 0xb8 in VMCB is set to 1 for non SEV-ES guests.

s/for non SEV-ES guests//

> 
> To enable IBS virtualization capability on SEV-ES guests, bit 12 in
> SEV_FEATURES in VMSA is set to 1 for SEV-ES guests.

s/for SEV-ES guests//

> 
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>   arch/x86/include/asm/svm.h |  4 ++++
>   arch/x86/kvm/svm/sev.c     |  5 ++++-
>   arch/x86/kvm/svm/svm.c     | 26 +++++++++++++++++++++++++-
>   3 files changed, 33 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 58b60842a3b7..a31bf803b993 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -215,6 +215,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>   #define LBR_CTL_ENABLE_MASK BIT_ULL(0)
>   #define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
>   
> +#define VIRTUAL_IBS_ENABLE_MASK BIT_ULL(2)
> +
>   #define SVM_INTERRUPT_SHADOW_MASK	BIT_ULL(0)
>   #define SVM_GUEST_INTERRUPT_MASK	BIT_ULL(1)
>   
> @@ -259,6 +261,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>   
>   #define VMCB_AVIC_APIC_BAR_MASK				0xFFFFFFFFFF000ULL
>   
> +#define SVM_SEV_ES_FEAT_VIBS				BIT(12)

Based on the SNP series, this shouldn't be added in between all the AVIC 
features, but rather after them, just before the vmcb_seg struct. And 
probably best to just call it SVM_SEV_FEAT_VIBS.

> +
>   #define AVIC_UNACCEL_ACCESS_WRITE_MASK		1
>   #define AVIC_UNACCEL_ACCESS_OFFSET_MASK		0xFF0
>   #define AVIC_UNACCEL_ACCESS_VECTOR_MASK		0xFFFFFFFF
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 41706335cedd..e0ef3a2323d6 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -59,7 +59,7 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
>   #define sev_es_enabled false
>   #endif /* CONFIG_KVM_AMD_SEV */
>   
> -static bool sev_es_vibs_enabled;
> +static bool sev_es_vibs_enabled = true;

No need to change this if you follow my comment from the previous patch. 
Also, maybe this should just be called sev_es_vibs, since it's more a 
capability (similar to how in svm.c it is just vibs).

>   static u8 sev_enc_bit;
>   static DECLARE_RWSEM(sev_deactivate_lock);
>   static DEFINE_MUTEX(sev_bitmap_lock);
> @@ -607,6 +607,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>   	save->xss  = svm->vcpu.arch.ia32_xss;
>   	save->dr6  = svm->vcpu.arch.dr6;
>   
> +	if (svm->ibs_enabled && sev_es_vibs_enabled)

This should solely rely on svm->ibs_enabled, which means that 
svm->ibs_enabled should have previously been set to false if 
sev_es_vibs_enabled is false.

> +		save->sev_features |= SVM_SEV_ES_FEAT_VIBS;
> +
>   	pr_debug("Virtual Machine Save Area (VMSA):\n");
>   	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
>   
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 0cfe23bb144a..b85120f0d3ac 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -234,7 +234,7 @@ static int lbrv = true;
>   module_param(lbrv, int, 0444);
>   
>   /* enable/disable IBS virtualization */
> -static int vibs;
> +static int vibs = true;
>   module_param(vibs, int, 0444);
>   
>   static int tsc_scaling = true;
> @@ -1245,10 +1245,13 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
>   		/*
>   		 * If hardware supports VIBS then no need to intercept IBS MSRS
>   		 * when VIBS is enabled in guest.
> +		 *
> +		 * Enable VIBS by setting bit 2 at offset 0xb8 in VMCB.
>   		 */
>   		if (vibs) {
>   			if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_IBS)) {
>   				svm_ibs_msr_interception(svm, false);
> +				svm->vmcb->control.virt_ext |= VIRTUAL_IBS_ENABLE_MASK;

This appears to do this for any type of guest, is this valid to do for 
SEV-ES guests?

Thanks,
Tom

>   				svm->ibs_enabled = true;
>   
>   				/*
> @@ -5166,6 +5169,24 @@ static __init void svm_adjust_mmio_mask(void)
>   	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
>   }
>   
> +static void svm_ibs_set_cpu_caps(void)
> +{
> +	kvm_cpu_cap_set(X86_FEATURE_IBS);
> +	kvm_cpu_cap_set(X86_FEATURE_EXTLVT);
> +	kvm_cpu_cap_set(X86_FEATURE_EXTAPIC);
> +	kvm_cpu_cap_set(X86_FEATURE_IBS_AVAIL);
> +	kvm_cpu_cap_set(X86_FEATURE_IBS_FETCHSAM);
> +	kvm_cpu_cap_set(X86_FEATURE_IBS_OPSAM);
> +	kvm_cpu_cap_set(X86_FEATURE_IBS_RDWROPCNT);
> +	kvm_cpu_cap_set(X86_FEATURE_IBS_OPCNT);
> +	kvm_cpu_cap_set(X86_FEATURE_IBS_BRNTRGT);
> +	kvm_cpu_cap_set(X86_FEATURE_IBS_OPCNTEXT);
> +	kvm_cpu_cap_set(X86_FEATURE_IBS_RIPINVALIDCHK);
> +	kvm_cpu_cap_set(X86_FEATURE_IBS_OPBRNFUSE);
> +	kvm_cpu_cap_set(X86_FEATURE_IBS_FETCHCTLEXTD);
> +	kvm_cpu_cap_set(X86_FEATURE_IBS_ZEN4_EXT);
> +}
> +
>   static __init void svm_set_cpu_caps(void)
>   {
>   	kvm_set_cpu_caps();
> @@ -5208,6 +5229,9 @@ static __init void svm_set_cpu_caps(void)
>   		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
>   	}
>   
> +	if (vibs)
> +		svm_ibs_set_cpu_caps();
> +
>   	/* CPUID 0x80000008 */
>   	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
>   	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
