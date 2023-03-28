Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDCCE6CBA1A
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 11:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjC1JHT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 05:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbjC1JHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 05:07:16 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113085271
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 02:07:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+9swpkDxLbQpwhfJHd8G+/dlQss2HVRcl7Mlh5lKXZO3pBJQizCbEYYqB39oOCkfNn32I3zcNHaOupA6bvF3JH0GqK3Nf0I+wEwFGPdCnCoEjON4SG8CMFYE1EOBklwSeb1nePORR4WklniJVe3Y5ncZRmbQt3pfWOkZB5kGMy1ZmfXInkrluJ1TgJfdUgdBAVK7R/c/pAjIlUqECsRrlmm4KOPhtAugTDu0jHST0Pl0wG8uML7sBUT/XLLr5tHk0ILr/2hQ7xFXr8v7wq4coWk4skJ8fWQrPnFYP0hpW7dW6kBPlO3ARflRba9v/g5oZ/mn6sIUNXaSbeggfjUUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lv7S8OHpHlPJ9INNpWqFrZHw+cW4+mGqUsyd319hqkA=;
 b=UgVOExJFdGcqwOtG72Psrx5oKr8Uryt5zhL6p2Mn3bZjJ+U+1V0QP5tGlvHSsIjiFsFlTWfX7uhZnorwMgaPxz9RbkafNFbqtEHFO8WBfl0qKA8Y8rJd1mUFH9iwnVQuU/cnibHv7fsEmgVUdqHn51MgzDjs28RYsuNd9gWNle4HRa6v+9yZwu7eLaLD+2XWBt6l36eyOiW3Q0xfl4jx2Jr5HUQ2VPfZWGbz/9Rgwu3wxAVq6VxMMbUnznzAtYdZlynCURxj0vVrZuYcvU9/kY4XLMYVunPrLrb99rb7pVjNy1LrNEpfPwGN6EJkhQMmu0Skxay1n8La9tJJCLRvlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lv7S8OHpHlPJ9INNpWqFrZHw+cW4+mGqUsyd319hqkA=;
 b=4b+eom9wsp5G5ezT9y9DfdbcSkyhtKNIcpmmwvS+hKui50at7Jmu+ICTkB28LvlZu7BBBC1OCY39U7rVxEiK3Q0Nry1DASvf0vzvWPFOL9gqw1fC4ZXU+oCNBn9r6WdYQYotP5ffy9UdY47BTWdEdDw5EzyOtMwKDK7g5QcJWGI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 SA1PR12MB7246.namprd12.prod.outlook.com (2603:10b6:806:2bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.32; Tue, 28 Mar
 2023 09:07:10 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::1185:1d60:8b6e:89d3]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::1185:1d60:8b6e:89d3%7]) with mapi id 15.20.6178.037; Tue, 28 Mar 2023
 09:07:10 +0000
Message-ID: <63e71a7c-3767-dd00-7744-8a12663ad814@amd.com>
Date:   Tue, 28 Mar 2023 20:07:01 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.7.2
Subject: Re: [PATCH v2 1/2] iommu/amd: Don't block updates to GATag if guest
 mode is on
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vasant Hegde <vasant.hegde@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        kvm@vger.kernel.org
References: <20230316200219.42673-1-joao.m.martins@oracle.com>
 <20230316200219.42673-2-joao.m.martins@oracle.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20230316200219.42673-2-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0058.ausprd01.prod.outlook.com
 (2603:10c6:10:ea::9) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|SA1PR12MB7246:EE_
X-MS-Office365-Filtering-Correlation-Id: 16882b85-85e8-45fd-8120-08db2f6bd000
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E0izkMTRc3ufSn9wdQz96Xw/A5F6CLrcKYDgcH8ouPDJ7o53gxqeOyAaObl4DDQLDYL7zzAPQyjh0V0saLb0RsR+hnAI0iO8ahXYEREyVcMw0XPohfc8L4oxsJqLHZewaS1B4aZaxDuur1Rs89hAGs1yILuon0lrTKOEJVRhRlxGlR5ihXZE1uP+2FVj6I4lXtwgBmzDf2n1ZhxtN8aCs5wTc4ReWnevDqcA5e7Or4r3VN+mCDAbCyW++PgQtJZFeP9bb8T7op4UE4P5o3s18BQLq06L8o2SW6QHJV+jWBT/Cu22yQXABQtcCXX0V4MSLkwQBCYlqVoN5E+VrPKHKGqPO2JLkH+HcAs1WbI0t4Vge4NoDq4l0TzM3bxNjj1oTSL8VnO3aQaFyeYWDHmn/56FVUEddOoojZJCN1lwqiKq9LxpxSin5IcAH36I5sutZsTNR/gL+316rPxax2Ic/xLaiJSoOA3iznstuLthGODz/+yGUFqesAAVIETmKSZ12JUPRxW0TNdmZFHOSQyRSj2ERlvzhr5Z9BCkROw1S9eQdSuWeKvrUVHD6sKqLXKyKnzd8NFOM+cc2bENa7TvfUFg01yonVqxkSg6rUY/oAi9BY3gSGRA3gVK6uCwf2FY12zZcwopkgs9dFTPj7dLYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(366004)(376002)(39860400002)(451199021)(31686004)(31696002)(36756003)(2906002)(15650500001)(478600001)(6666004)(6486002)(2616005)(83380400001)(54906003)(38100700002)(53546011)(6512007)(66946007)(4326008)(6506007)(316002)(8676002)(66556008)(66476007)(5660300002)(26005)(186003)(8936002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUNNNlk5MDV2R2V1em9UTVRvUjdkRUw1VzFTYTZwWWRhWGFiSTZzOG9QUFB3?=
 =?utf-8?B?Yng0WTlZTVRYdGJxNUlGZ2RWZWRjMkZka056WFdYQUtHSDdBSVROSW5JN3Rk?=
 =?utf-8?B?RGpCdkE5QWcwSmduV1FRZ0dQbFl5TjI3aVBEZUVRamV2b3orWEtkUWU0d3ow?=
 =?utf-8?B?NmZBNjhzb1ZaQzd1c2s0bVlEdklkTWRpd09BWnRnY2lGRDdGcytNV3NkL1Ro?=
 =?utf-8?B?dTB2WU5lRWZSbHNQeDQxa28vNlZrSEdDaXFpTE9iWlZ6UzUraDFyZ0hwS0Fu?=
 =?utf-8?B?N2lpd1dvZWRSNG15dy9HQ0VCcDUwZ0RhTGgyTW9ZUEpaQVQvNGFwdDE2WS9P?=
 =?utf-8?B?RHdMd1BDZ2FYS1g3alM0eU5jZ1NFYmV5MlpEV2hvYTR5YjZmZGJobEZ6bXFT?=
 =?utf-8?B?bnhuS0RSUzd3Sm9LckxHMHJsbUM5STFTejBoT2FNRVljd0NrUGN2QWVYb3M3?=
 =?utf-8?B?THROeDMzTS9OYnV5dGNPSlh5eE0yaU52aHlBTm5HUCtCelZ2cFZBaEMwdlVX?=
 =?utf-8?B?U1RGMm82ak9VRmVmWjBHT080MnEzNVRlUmhyNjVzVWU4S3VhbTJZR0pjUm9C?=
 =?utf-8?B?RUl0WWQwejN1elgxUklvN29jdEpibURNR1NNNnRMc3F3aXBRaW41S2VzaVUy?=
 =?utf-8?B?VC9TQlE2aGN5citzREdqY3JkWkpFUkhtUG8zaFBiR09NbXFWQXJqWkVVckZk?=
 =?utf-8?B?MXVUcFRCWVhVY2JaQTBvRXNBOEljOTVRWEpNeVpkQkNqTzBPdzlzR1RWZ3U1?=
 =?utf-8?B?SXIvck5WSzRyZWd3WmhBTCtoRWZJOXlNVkp4VEtndUlvalJteENJeHZ0M0NY?=
 =?utf-8?B?MEpqaGtVRldtUThZMmw1ZHllUkhiMzFZWWNjSEJpbC90YjFyRlJvYk1WbnFw?=
 =?utf-8?B?WHcyZkw4Z2NidnQ0ZjlLNzU3VDZ4NVkyWEdRZ01RVGRxRjQ2eHgyWHdtcXJt?=
 =?utf-8?B?M1ZyMTEwVk9NVmRva202RitwZ0xlM3pOak54U1RmeUR1UXFDOTIrZit4c3lk?=
 =?utf-8?B?MHZIOUNFSHN6YWtKY3YzRGtZSW1oNUY0eEx1dHJsdEJXanhYbC9UTEtqVVJl?=
 =?utf-8?B?bjczemJUVW96ZWJZa0pYZnRQS1NBUXRlR245K1d4eFEyQ0VYeEVhd1VJbGpj?=
 =?utf-8?B?b3JoZWZHUVo3ck52QjE3S0NEUUxadFdDRmU1UndKcFhBQU9DandxV2JWVWk2?=
 =?utf-8?B?LzZxdk1tT09BZ0ZMUEVWN1VmR29BRkN0MWt6QnFwSlhKUzNxZTltY2N3STQ3?=
 =?utf-8?B?b1ordFJVZkxFeGNPRFRvSkV5MFNKUUQreVpuWTN4ZVhZZDRxczVTODFtWjFI?=
 =?utf-8?B?bUJGOGV2V1BWc3llLzhZWlYxNVR0VUJQNTVxOURuN2xDNjFTakNxZ01pWHlz?=
 =?utf-8?B?UkRFRi9YUGJBUDVvLzFEMHZMdUVWbnV0K0o3U2dTQitOSTFiejdXQjZ0djIv?=
 =?utf-8?B?eVFYL2dkNVR0cVRGZWlxTGdkeU1EL0VoN1dBR0x1UEwwVzVMKzZNbCsvbWZV?=
 =?utf-8?B?ZkJkdkNJRHppK05EcnJwTEduMVZ0ZkVzS1JIMVl1TFowd1JhbTNwbzFoR2h3?=
 =?utf-8?B?Q2l1NkpSVkVNSVFOb3NDdzVQWHBuU1MvTm14R1ZPQkl6VkVweUZQaEt4bE5s?=
 =?utf-8?B?MzRlMFZ5V3llbVZiV01YbDl1RjVkR24yNjhrYlgwa0E2NHRBeTF3cyt4VHVv?=
 =?utf-8?B?Yis0eE9iSXJhK0Q3N2xsVGJQazlyOXNEZGpydWo2enRILzhEaTk2bEJveGx4?=
 =?utf-8?B?SWlhanRWT2M3Z09aOThiOFA0V0pudXpBaWtpMGVZam85MVF1c0pZTk1zd25h?=
 =?utf-8?B?K2pta3lsRWs0bFFTZFNQR1I5Tk5Ib1lTallMN2F3RFFKTVpUWVlKWGdkaFk5?=
 =?utf-8?B?VFBYTGJUYkVuNVgrV2YwbU8vbW9ZNEdpQmlzdkJQZ3lqaTAxZUUyVzdCQ2I1?=
 =?utf-8?B?aUV1QUZPSElmT2Nsc09YeTVBdk9aeHloTHhHUGFTaWwyY1I1T0F5bWI2eHd3?=
 =?utf-8?B?TmZZN3pQeXZodkdjTDhoVHh3L3R0UEFCbi9iaE9lajJkV3BZYkJJOHpSZHlD?=
 =?utf-8?B?dGg4OFpCbTR2cW9LYzYzLzBpaUdnSTFEWVp6U2ZUc3dZVUhNRGNnK1ZyR1lX?=
 =?utf-8?Q?acaJm4gXd+DjQhUKWEfS8UWyV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16882b85-85e8-45fd-8120-08db2f6bd000
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 09:07:10.4194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FoiQZcE+7GjdhfgwSOkBIkAbKS6Dloi4glpvzzObb7Xwgqr9MzgvOV96cwGNN2Hf473FIIELGEaOIw5/Ff7/Zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7246
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/3/23 07:02, Joao Martins wrote:
> On KVM GSI routing table updates, specially those where they have vIOMMUs
> with interrupt remapping enabled (to boot >255vcpus setups without relying
> on KVM_FEATURE_MSI_EXT_DEST_ID), a VMM may update the backing VF MSIs
> with a new VCPU affinity.
> 
> On AMD with AVIC enabled, the new vcpu affinity info is updated via:
> 	avic_pi_update_irte()
> 		irq_set_vcpu_affinity()
> 			amd_ir_set_vcpu_affinity()
> 				amd_iommu_{de}activate_guest_mode()
> 
> Where the IRTE[GATag] is updated with the new vcpu affinity. The GATag
> contains VM ID and VCPU ID, and is used by IOMMU hardware to signal KVM
> (via GALog) when interrupt cannot be delivered due to vCPU is in
> blocking state.
> 
> The issue is that amd_iommu_activate_guest_mode() will essentially
> only change IRTE fields on transitions from non-guest-mode to guest-mode
> and otherwise returns *with no changes to IRTE* on already configured
> guest-mode interrupts. To the guest this means that the VF interrupts
> remain affined to the first vCPU they were first configured,and guest
> will be unable to either VF interrupts and receive messages like this
> from spuruious interrupts (e.g. from waking the wrong vCPU in GALog):

The "either" above sounds like there should be a verb which it is not, 
or is it? (my english skills are meh). I kinda get the idea anyway (I hope).

btw s/spuruious/spurious/, says my vim. Thanks,

> 
> [  167.759472] __common_interrupt: 3.34 No irq handler for vector
> [  230.680927] mlx5_core 0000:00:02.0: mlx5_cmd_eq_recover:247:(pid
> 3122): Recovered 1 EQEs on cmd_eq
> [  230.681799] mlx5_core 0000:00:02.0:
> wait_func_handle_exec_timeout:1113:(pid 3122): cmd[0]: CREATE_CQ(0x400)
> recovered after timeout
> [  230.683266] __common_interrupt: 3.34 No irq handler for vector
> 
> Given the fact that amd_ir_set_vcpu_affinity() uses
> amd_iommu_activate_guest_mode() underneath it essentially means that VCPU
> affinity changes of IRTEs are nops. Fix it by dropping the check for
> guest-mode at amd_iommu_activate_guest_mode(). Same thing is applicable to
> amd_iommu_deactivate_guest_mode() although, even if the IRTE doesn't change
> underlying DestID on the host, the VFIO IRQ handler will still be able to
> poke at the right guest-vCPU.
> 
> Fixes: b9c6ff94e43a ("iommu/amd: Re-factor guest virtual APIC (de-)activation code")
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>   drivers/iommu/amd/iommu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 5a505ba5467e..bf3ebc9d6cde 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -3485,7 +3485,7 @@ int amd_iommu_activate_guest_mode(void *data)
>   	u64 valid;
>   
>   	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) ||
> -	    !entry || entry->lo.fields_vapic.guest_mode)
> +	    !entry)
>   		return 0;
>   
>   	valid = entry->lo.fields_vapic.valid;

-- 
Alexey

