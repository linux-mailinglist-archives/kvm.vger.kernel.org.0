Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB815697FDA
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 16:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjBOPu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 10:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjBOPuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 10:50:24 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBFA38B6C;
        Wed, 15 Feb 2023 07:50:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOSUuCVbI4Wdex3euxikB15NBswrriXDs/UZWoWDYPwn20lKftEUtkFmYAiT9l/+RaE85AsJWbt/AQO/zBoHdEUVpAHYPFn+5q7NVvBYGsecub/153QupJhkeFBKZGlG7APuhZHDZ7Ke4Xs5XyGF4Qzxe6KARhtXU7nnhs/DTxou3NYrCQtD+8eQtxM3FM9eZnG+DfS6iJNwPdi6orUf17ZlZkzL1QuIy7GfZ6Pw/m0fAYAQ7pOpxmH/1A4IEvBgmXrW8gOv1QfzcIvEVOr3Yg3asY0wHhNZkebAnDHlUsZcq5ez4vh0PngttlyyDu3NA1BW6qLhj7i3ts0lLZRIZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1ljsWrIdCYDKNzY7rih+QOlQb7BU0wpyv4qWu2BJ3s=;
 b=QIDtVmGkX7bNkP9s0fm3oYw1ui2CrQn86C5yOWVkNaVDmZC2PapGI2cy1xBG2OTALKbcK2KXHA3M4s+HudkxApLkUOlw3CJb8Jb30S2SXxIa/Od/UIwtBWIC6WnZVXOXJqc3+y5bE1j5gdHS2kqiC1KCV7IZuEPW/mCfk13LnxpL3bVK0wefjd2bJniv9fDrm6ARz/ScaRLxo3TCyaqgS04HhqPNjjMLimAQoVm11u/rmUq7s2of91rBTn9ncG6u7Po8znMKO2hIMXCP1VToCL4kpK/VV/0B/kxf0g17r4q0KwjINRwBo8sHM/qC+FpzcsnOdGI1BMwPHzA2kwuCEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1ljsWrIdCYDKNzY7rih+QOlQb7BU0wpyv4qWu2BJ3s=;
 b=Ln+qbp/psa/SFzyQeTuO+CQJuOKMsqKDqqtW4Fo58LMwFBmkf0ODqMKUY5YV+Hv16IcWUqKnVfiVUWjzVtlPxRbX4HZFe0616yMnP0oItzKPtrTVuRv2BQ1K+r/7IDcZ7IXjidI6fjng95GXrvdLShI3fXWnSGBykk0h6dcn+z4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 PH8PR12MB7280.namprd12.prod.outlook.com (2603:10b6:510:220::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 15:50:20 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c4fa:4cd7:4538:e54b]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c4fa:4cd7:4538:e54b%6]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 15:50:20 +0000
Message-ID: <0ed33e2d-87b4-71fc-3de7-5e193e386331@amd.com>
Date:   Wed, 15 Feb 2023 22:50:11 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 2/3] KVM: SVM: Modify AVIC GATag to support max number
 of 512 vCPUs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
References: <20230207002156.521736-1-seanjc@google.com>
 <20230207002156.521736-3-seanjc@google.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <20230207002156.521736-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0032.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::23) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|PH8PR12MB7280:EE_
X-MS-Office365-Filtering-Correlation-Id: da1b2018-804e-4cf4-1e2a-08db0f6c576f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CdK8M54fkcSDzjW5geIk3KnRrfM5626Lp+XVZdma2STrgofChM4420URDlDBGwjgSaG1doqHB4Z1Nip2/u2DQeOo7tcoeAwyokR1ptfL+hsZaA5iigorETcrjrblsp/Z86UeiT74OHPCL9XU56uLbLhffjv/5XejbBVGRhMtK4qYpzQNySWi7b1jrnJTM7/GboPp5g6Y19supLuHzYHUsB+HyDsukA6ZG6/KZfkOAAFPgaCXux1M3b8aFCFgsIIMbJpDV5zSXcJcYgCkrwNbpx6CRC/OPRmWxH8Qxg+Unu55zK6syfOrI9NUvY5a1VSDbQgXA6OobG0xllsvUOwkijQ0A+fKKPNtmgXqXGYEKkXDvNn0ixgyIfJdMleZv5RU+40YU/NkLTK4wMeUHPosrwSm35+pkuYXSknfYZo5zKcHC0wGSAxazCN2tLp34p2qQvX14AvBdDpQobLPWrXMByrPOf0cksDQ/AbVaaVcFtIJYlI7sOZmR7WvGUyxaq6mVIWYRTN+YfF8+VNdEmaOWnzcmW93kPjbl4kfycauKQOZ6kfyF+olUQD9fQrVo3hx8fAlf+9uqsK4KeRPoVU4a2HrNGKvd9W54Y0n4QVTplMDCXKpN6jVwScuYawYzBevSyugbEVUi/vyTCZhC03KJDDADHdlwrBOtA5v4Ea3RnwEX9WVAgs7JggmB5nnUr8lABSXFWrhm31A+PBpIEdv+fu41629q4S5gulz7Zjvqwo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(451199018)(5660300002)(6506007)(53546011)(38100700002)(186003)(6512007)(26005)(36756003)(6666004)(83380400001)(2616005)(41300700001)(66946007)(316002)(66556008)(31696002)(66476007)(86362001)(8676002)(8936002)(4326008)(6486002)(478600001)(110136005)(31686004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zk9qbEpjUnI4VGJpMTZtcXlDbGpSWnpHZzJlV2NoUER0a2NUVitsTmluZ0hQ?=
 =?utf-8?B?OVVkdzR2SGdmVkFFZzdVZTJyT2hPbnZ1WUE5RjNXTmZFL2ZXRmNtdXdPR3k4?=
 =?utf-8?B?Q2RyUU9qVTZwbXBPWmNuWUljUTNzSkYvV2FFSFN4cUxwb1JTdVM5bElqaUVk?=
 =?utf-8?B?VWJFWkIyZ2MvUXBhWlU1b0RHS0NBZU5sMlVpNmZscXFDZElRWjFFZkt0Mm1j?=
 =?utf-8?B?UWJHdE14NmxteFk3Um0vMFY0WUpEeXNWOVJxa0o5ZjBVUjI0M0VtSjRoRi9Q?=
 =?utf-8?B?TFR3YStXZDRtWWFyTmtjS01abVN3U250aTBMTGhlV0xFRlJxYlpjalByaXZO?=
 =?utf-8?B?ZFpYYUIzbTFzUUJ2NFRReFR5QnlNUmtRMGN6WHFKMzNrUDRwbXJ5OUxPa1hy?=
 =?utf-8?B?R3JCVWxyZ1VsbHZRZlo4UlE3bGEyMTA3WU1sNEVPUGtEZGRmcTJDbmlEOXJ0?=
 =?utf-8?B?YnhHSytpRHdQODFpRW1rZzlpZXpkTG8vVk9tRHNmTHV0aytmQUpxR256Q1dH?=
 =?utf-8?B?aWd1aWlidEdialhaWERDdEg5S1d5V2VNRjVPbi9Hd2xtcW93ODRJU3E1bG9w?=
 =?utf-8?B?MXllWit4ZWt5MWZMdzQ5aVQ0bkphRTFHek9FcVlyQ252ZVFhbTZSWnhHL3dL?=
 =?utf-8?B?TVcrMFkwUm1EalZnQ3hSY3NGYmhVUWE4czZGOHd0TkNJOHFKdWlXREk4VkZZ?=
 =?utf-8?B?dmozRGtpa2RTMTdJRkNrQzg2RStiTlduQzNDcGFzaHVIdGtCd3JyT3V6U0FI?=
 =?utf-8?B?RzViM1gxNUZKRnB6VHB6dXJ0c3BROG50SXFYTzR6bVBCL21mcHVrUG40cUc5?=
 =?utf-8?B?Nk9XZ3dRdVIrcjlUSWJpQVA5dzRweEgwQnlSMDN2K3NZRFQ5UG1NdmRHZW1P?=
 =?utf-8?B?ZnpvcUlsN1VVdTIxVEQ3SU9kUjhVaE5MSW1iaVpIbWkyVmt6cjUwQ1VFZDA0?=
 =?utf-8?B?YXdZVURrZXB3d1pBZDIyODlMSGlVaTg1ckgwMHNpMWpWZW5rR1NvQm1IdUJ1?=
 =?utf-8?B?ckhNTDVhQTU1N2dxVVlrRzJCL1ZVTW5CeUFoLzZQOTQrYU9ZdENmemQvRGpH?=
 =?utf-8?B?TmdlNzd5WXpuVUs1YVg0YUt1aWt3dlJhYlVaSTNXS294eGZzQ0FBSi9XZG5I?=
 =?utf-8?B?SWdMZ1ROVDlKekdIRW1XTzFyMUhGcnlMUys4TW01VjNrSXVVdTIvTjFWSDAx?=
 =?utf-8?B?RFp2ZnA4SkE0NWk4ZEt5TythS2dLNXJiUWxhV3hOMGRUK3lVeFd0TE5ta2NL?=
 =?utf-8?B?czJ2ZTVnMEJJVnMrTzlST1FFZzJtR3lMWWlDUGk2eldmZVU1d0cxUDhxdlRw?=
 =?utf-8?B?aGcwNUVrd0x3aHpRQTY1YUxWZEdoQklqVi93Q2dpV0hiRWIzZ2p0MERKd2ti?=
 =?utf-8?B?YmtuSzVQckhVNGtOVEdyWXF4N1JRNkhKdnA1NnRqMm0zNWxpVEVWbTFSYmZ2?=
 =?utf-8?B?SVdXR040SzV5VGUyWmdUZnMzSFhNNVVpNk9HNzFKQ2NnNmVhb3hId3dtTmJL?=
 =?utf-8?B?bjJWNGV5MU1xc0ZqUHN4YnBzVnZEMk1MQkF3a29xRnVIczVINitsbWt0a0R0?=
 =?utf-8?B?UkZZa05yYW4vQ2NzU3NQQmtHMHczODZjSlBkcDRNZzRVcGc3SXk2elJSSC9h?=
 =?utf-8?B?alZKUVZ3Wm1nMVprS3VrT1phdStXd2FSNFVJNk9idjZWSUUyVEVjb0Zib3Uv?=
 =?utf-8?B?L3dZb2s0K2pKNlFRQU1IVTM0S0Z5cHVNZnQ0dXBHZDNRaVY5R1JwZHA2RENx?=
 =?utf-8?B?dUlNdXVUb0MrZThsL3ErZ2UrZ2RpZXFQZDRONzg4L3NwN2MyUTVxa1NJSlVC?=
 =?utf-8?B?aUM5dmloR2dWZkthYXZPVUNEOUFMamxuNnJFZ3IvNFoxckJ3Y1F5c040S3dk?=
 =?utf-8?B?UHRnZjFBbVZNYVowKzdCSDQ4RE5oUjVWSDExRFdKS0JBSFVCNVNib2JKVG9j?=
 =?utf-8?B?cVNoRU55NGIrcER4N2NRMngwNzdKSmorNXVXV29DQTczMWFrd1pRZGtSMWRr?=
 =?utf-8?B?M3huaWgwb29Kb3dzUi9EYnY4QTN5YjFtWkNJcm5Ca2twVWtIUHgvOUtERXZM?=
 =?utf-8?B?aEFzOFpFeUxZYmFHamVXVVoxOVFGMXJxdEdFejhici85OENLOGJTeTZjNlk2?=
 =?utf-8?Q?3HUuEGhEIL7tjTdLrjJ/WP30d?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da1b2018-804e-4cf4-1e2a-08db0f6c576f
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 15:50:20.5059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fA44DF9adWwc9BBm3ia6H9rKqP6fB93iX0/5W4xJWb0EZuMh6kQU7PBG7wFe3uS0VTOBEQWItuPBQ7Y7XYa+Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7280
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/7/2023 7:21 AM, Sean Christopherson wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
> Define AVIC_VCPU_ID_MASK based on AVIC_PHYSICAL_MAX_INDEX, i.e. the mask
> that effectively controls the largest guest physical APIC ID supported by
> x2AVIC, instead of hardcoding the number of bits to 8 (and the number of
> VM bits to 24).
> 
> The AVIC GATag is programmed into the AMD IOMMU IRTE to provide a
> reference back to KVM in case the IOMMU cannot inject an interrupt into a
> non-running vCPU.  In such a case, the IOMMU notifies software by creating
> a GALog entry with the corresponded GATag, and KVM then uses the GATag to
> find the correct VM+vCPU to kick.  Dropping bit 8 from the GATag results
> in kicking the wrong vCPU when targeting vCPUs with x2APIC ID > 255.
> 
> Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
> Cc: stable@vger.kernel.org
> Reported-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/avic.c | 26 ++++++++++++++++++--------
>   1 file changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index ca684979e90d..326341a22153 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -27,19 +27,29 @@
>   #include "irq.h"
>   #include "svm.h"
>   
> -/* AVIC GATAG is encoded using VM and VCPU IDs */
> -#define AVIC_VCPU_ID_BITS		8
> -#define AVIC_VCPU_ID_MASK		((1 << AVIC_VCPU_ID_BITS) - 1)
> +/*
> + * Encode the arbitrary VM ID and the vCPU's default APIC ID, i.e the vCPU ID,
> + * into the GATag so that KVM can retrieve the correct vCPU from a GALog entry
> + * if an interrupt can't be delivered, e.g. because the vCPU isn't running.
> + *
> + * For the vCPU ID, use however many bits are currently allowed for the max
> + * guest physical APIC ID (limited by the size of the physical ID table), and
> + * use whatever bits remain to assign arbitrary AVIC IDs to VMs.  Note, the
> + * size of the GATag is defined by hardware (32 bits), but is an opaque value
> + * as far as hardware is concerned.
> + */
> +#define AVIC_VCPU_ID_MASK		AVIC_PHYSICAL_MAX_INDEX_MASK
>   
> -#define AVIC_VM_ID_BITS			24
> -#define AVIC_VM_ID_NR			(1 << AVIC_VM_ID_BITS)
> -#define AVIC_VM_ID_MASK			((1 << AVIC_VM_ID_BITS) - 1)
> +#define AVIC_VM_ID_SHIFT		HWEIGHT32(AVIC_PHYSICAL_MAX_INDEX_MASK)
> +#define AVIC_VM_ID_MASK			(GENMASK(31, AVIC_VM_ID_SHIFT) >> AVIC_VM_ID_SHIFT)
>   
> -#define AVIC_GATAG(x, y)		(((x & AVIC_VM_ID_MASK) << AVIC_VCPU_ID_BITS) | \
> +#define AVIC_GATAG(x, y)		(((x & AVIC_VM_ID_MASK) << AVIC_VM_ID_SHIFT) | \
>   						(y & AVIC_VCPU_ID_MASK))
> -#define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VCPU_ID_BITS) & AVIC_VM_ID_MASK)
> +#define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VM_ID_SHIFT) & AVIC_VM_ID_MASK)
>   #define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
>   
> +static_assert(AVIC_GATAG(AVIC_VM_ID_MASK, AVIC_VCPU_ID_MASK) == -1u);
> +
>   static bool force_avic;
>   module_param_unsafe(force_avic, bool, 0444);
>   

Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Thanks,
Suravee
