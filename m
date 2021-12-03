Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E667C467DAC
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 19:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243610AbhLCTDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 14:03:15 -0500
Received: from mail-bn7nam10on2046.outbound.protection.outlook.com ([40.107.92.46]:19169
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243519AbhLCTDM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 14:03:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XA0RLTaIwoXPm4SRYDH8nCv/+yOas2xdhb9qfiMcn/jQiw0AKI4s44Kv58FwnEyNIemouCSD2rkVQ0Xt80p2yvxDIh0KTPbizsGxdeuOhRLFFyzllqOmAUKP1DulPWTdOcYn20qz61UCuYwiBqrRBDOYW81C2BpnMIH28jr6NWH6DNHE8cHC5Trufn9OAOTU6CiXnYgp9ivEsCoc81z9kQlwgenfQ5SFGPuMvE7WBysHydzQvUjz/0yrSK0/6h9dYnJio4KVBpoqmCfh/Tpow/iv/RLprckS8YQD4RC5tNVNt3DYZjmTVAMSMownutlOjhs0PJ/xp65JhGEfy1ukBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MPundRD0QFz9/5T9BvePjXsJG5sxYSNayQQH2XZR9IE=;
 b=NL2okNJrcS+gTmUjxMSKZFsrz+x/bJiyx/ggTCGZ9AR/Paw+svNxvCbVk/QDl64AMLqSnmsz6hhcFZ2dv1I1zgAA73kdf1yi+cyJv44R3oVfpzKhTTpztbD3pB6BrH4fZiDFeF6EjhApE4bMMoPJ2yacnDnJAZ2vsTqebF0eHsv+8vBWtBiSTfXtgf4CJB3qoOxPTOK5YbThVmsDb7y4eiaoxRyMkExyqlgBDMug8QT3hKXpRovWHiNqD1BvzH4AZ8dpmwy+mhML39ISddIeC4bHfZYskIJXggzQrxcfX1l87b76/nPrHOe8cxUccynPNnnONS67MhD7FxaXq0jyCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPundRD0QFz9/5T9BvePjXsJG5sxYSNayQQH2XZR9IE=;
 b=3ntx59691sjRopD9JVAIdwLwNx1mFYJhZ1PmW9b7Bd3d9pUqG9ipbw4btg15YaDUb6GM+LjHP/ZIQuL6MlZhZoSUbgAy4URDiobHyeLRrdiuMPVrR9I862GO0JupWIFpUxlKQrHCDgkZbcfWiuWduZNHZVd34UJ3inf73TeBsLg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM6PR12MB5552.namprd12.prod.outlook.com (2603:10b6:5:1bd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Fri, 3 Dec
 2021 18:59:45 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.028; Fri, 3 Dec 2021
 18:59:45 +0000
Subject: Re: [PATCH] KVM: SVM: Do not terminate SEV-ES guests on GHCB
 validation failure
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <b57280b5562893e2616257ac9c2d4525a9aeeb42.1638471124.git.thomas.lendacky@amd.com>
 <YapIMYiJ+iIfHI+c@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <9ac5cf9c-0afb-86d1-1ef2-b3a7138010f2@amd.com>
Date:   Fri, 3 Dec 2021 12:59:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YapIMYiJ+iIfHI+c@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR2101CA0029.namprd21.prod.outlook.com
 (2603:10b6:805:106::39) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN6PR2101CA0029.namprd21.prod.outlook.com (2603:10b6:805:106::39) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Fri, 3 Dec 2021 18:59:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fa5a275-7d14-4b49-c512-08d9b68f1243
X-MS-TrafficTypeDiagnostic: DM6PR12MB5552:
X-Microsoft-Antispam-PRVS: <DM6PR12MB55521AEC9365090443DF56F2EC6A9@DM6PR12MB5552.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k+rIRrDwCT4D5ZNrCtaJBTayS26fap0xpDaiSSPwxzMVeH5FyO0WpA4B4M6pn2a1IM7CNkjhQIkxK6poszIoOKHLw0Lu9tNPHXUWkkpsVLP3gpLQu/628n/cl8NEAxi/BKsZJN7APhYmnhxTko/TQFX2e5UMJ1oXsB+kX2EjTJoa5x4NA4KilobfkBjiWJ65Mmv6AIn3AyHUlRhdpTOLwBvqKb/aPrCo4TVvhoZBMGJJ11s2cpg+iBpfrK02ksrl2KQaFSm2KI3HMlQUmf6pgKTtJKKklaNgcj20zPPqIa9xi0ylgPPmZxLmUowhvt1p6g2H9A1E+yvKSgIjLs3uKLTU3u8qAjQ78lVoXNTYhuEm5UyS38Cib59RYkoA32MGG0eSmOvaNU2C76m5gRPNbj6z7b/vs8MbnObVob+cUaezwx5xsxFYaZJ/7aKxnXmCjgBn2M+CVP1HTbu5jeKIFcbqVbxA/jLnKQ9x6vvr3i5PnJYkn1puzujBQSwl661SJisYEMGADalVT6uOeKjZse1wRMvtWH+7P9IrnxAo4j9UOzrK1hEK8k022t7wPtbemGL/Wsmj20iTPLxgezxYRQu6D9lyOBNkaWiBl926yqrw4PlD0H20ILoiBUTLBm/f1rB03DzN/oDiaeeJshP51bef2T3i4xlt6DJl2kNQTwuUh3mNq2YwUu8NBcQ4EM0SdMMuX8C6wgFrUn9f+dDZ/Pex+SF9DvHsnaQ3pnv7Rqj7W/+Wzir4lCGG8dXtcZg9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(66946007)(4326008)(66476007)(53546011)(38100700002)(5660300002)(31686004)(186003)(86362001)(8936002)(8676002)(26005)(6916009)(36756003)(66556008)(2906002)(6512007)(508600001)(2616005)(83380400001)(6506007)(7416002)(54906003)(316002)(6486002)(956004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K0p0QVRVVWdYQ0lVV09XWGNpMnhiWDNFM0E0TVgweXVKNytKOVJkUVcyR3RD?=
 =?utf-8?B?dHZqOExFaVBTV0t3U1gydk1ML0E1Q1Z6M0djSVJTWXBia3VvSjA0NlI2QS9x?=
 =?utf-8?B?ZTEvZWlWUHErSkVKbFZMRmlzUnQxMTQzbWd3TlFRWTlFaDRDK3Vuejk5NDJQ?=
 =?utf-8?B?MEh5dHNHNWtaTDZpdTFYYlo4TVcxRHhwZ29MYUNqVHJnQTZVaFJLVUZaV05G?=
 =?utf-8?B?U1BPTDNKQ3U3NHptWE10dk1pN0JTZjNseUJrKzR3LzFuSSt3TDVhM3VSS2sv?=
 =?utf-8?B?ZVpLclJRWU1uRUVGb3lqWUtVVHU2TzFLMzFia2M4aWxrYU4yVTlZLzNoY3lH?=
 =?utf-8?B?d0phd2hpWjV0b1pxcy9FcUVQNkN3akFvLzd1Y0JUeFU4TzluVEkxZHFPT1lG?=
 =?utf-8?B?ck1yaEZaY1h2WVlMdFl3QkpkRW4ySHVUbzE4eGRHQlM2bTY0dEpTcGF1LzlB?=
 =?utf-8?B?RTljVkRoc3RyUCt5NUJ0bVY3UXo2QkNic0tma00rUVVnT0k3bEtwSHR2eGVX?=
 =?utf-8?B?WU9UMEx1K1dGSDlNNWlaVU5TZTUrb2Z0czJNYU9ONmZ0YXFFMFRtVHB6RTFi?=
 =?utf-8?B?LzQ0SzVuVGovRXF6OHVzSlRDSDJaYjdxMzJZanNvdEhyc0J3dzk4VkVMMTdG?=
 =?utf-8?B?M2N4aXVhbnJJV2NvVnk5dGs1cHBPNDVNL3FuelNVcDV3S0RLQjJmMzdlaHk1?=
 =?utf-8?B?MkV1K2xIaVljRnRPMlQ4MFpDWVd5V0V4VFBZbnBZS3pWQll5bW1IMk8rcFNm?=
 =?utf-8?B?Q0UrZDBhSGxoMEVqeUdKNVQvT3htVkt3eURUdmRZaDFqNkVVOTZqRWRLKzIz?=
 =?utf-8?B?OUcwRVR4Z1RMTlBrS2l0VmpYY1BqOWcza2VuRWIycExER3pLRzBINy91ekxW?=
 =?utf-8?B?cE9rTE9aaXJjMVRLSndZaEpPQ1BHRFIxVElqNHMwN2QzZk91N1JQSE9BZTJs?=
 =?utf-8?B?aitNQlpyTmwxbnZzSjBaVU4rK2pOTHFUbDVRcVRsTHZJbi9Yd1Y2MnBST2Fm?=
 =?utf-8?B?eWtERFdSRXg3eThLZVcrcGJxNzJoT1V4SmFIaG1IbnNzNE8vZjZtTHZnSHdh?=
 =?utf-8?B?aDZXckJwS2ZWdXJTNEcwcWVxc3JJM3FVMGpweFhJSE4yZVJsTk1OZUNrRTBR?=
 =?utf-8?B?Rm5iR3NjT1RaSjArdXFuQ2pqYlIxMDV0R0RtVXVxQklWaFdJQWVnTVZsL2Qy?=
 =?utf-8?B?NGxETUozeTI1OVpCVi9rRnJ5T29tbEdteDBqQTd4cVpNZWQ2aC9JQTNSWG5l?=
 =?utf-8?B?QXhIckpGSkpWRVY3ZXhmZzRrcGFmSExZQkw5NHJCdWxrK2JmMWtQMW95K0ZC?=
 =?utf-8?B?b2pCK2MxRXV4UUR4TEdBOEMrdUgwYmMxMHk2UXc5aVRxRVcrSUVYVWhiNVpz?=
 =?utf-8?B?RVRMV0NhVk1mV3d3ZFJFQ2U1UzBHdmUvT2k0cmJBcnkyK1RoVDVQVG5MemZx?=
 =?utf-8?B?WlJBU2ZvZGtnaHlVd0xXUW5wNHJuTVcvWC9BMUp4SUJueStwVVRwd200cFFG?=
 =?utf-8?B?RjVCR1BmMnpsOCtWUExoUlE3VjkydDNwZmw3SmFKTlo0SW9hc1hnNE9Kdkx2?=
 =?utf-8?B?aXVyRmkyOEd0a1pCcU80QWdNaVFOeTlFa2VwV2RFcFYyMG9yNGlYWXQ4UjJU?=
 =?utf-8?B?TCtzVW4yRVpHTnlmYW9JNTlmeWVaWlo3eFptdlYzUllYK3hzQTdJRmZnODYr?=
 =?utf-8?B?MndLYjN2ZGdZYzNvWkNEV1ZHRDI3WWNHOUJzM1N6S2JqUzNkVUhVemlJWXFQ?=
 =?utf-8?B?Z2Q2WG53eUZ4dHgzdHI3RmxnRjAwMTlIcjc4dzZyNXVSQmM0K1A1aHRBa1px?=
 =?utf-8?B?TlkvNFdtQVhPZWtIU0dlcmp0MDJ5Y1RtWFl2UjZUcDRPM0wyVWRaV2ZKU2lZ?=
 =?utf-8?B?VW9hT3dwamtPUEJhQ1RzcjBURDM3ZWMwS3k1aXdoeCtVdkU4bU9QUlBKbnVa?=
 =?utf-8?B?RDYxd3dxZzhqRlI2VmlCUEU2dzZmRXVmYUZpaVhMS09ZYUpUMTJuVDlhem1Z?=
 =?utf-8?B?RDBTdnhscG0xMW1QOUlIbkpPQ080ZWI5b0lvWmgyL3hZNlRTejdMTHFDVS9y?=
 =?utf-8?B?cFBpWmJGa05DTSsxWUJ4dmVTb0RqMXNTMzZPeHUxU0YwdU9DemVoQk5hVits?=
 =?utf-8?B?M2VIanF5SlhNeWJib0E5WjJWenY2Q2hubkwvVHRDRzJ0eG9hR0o3SUgzei9D?=
 =?utf-8?Q?DzhXsvPk9PvCk370Vqi7joE=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fa5a275-7d14-4b49-c512-08d9b68f1243
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 18:59:45.4716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zhkL4wYgf9d4BcgYoq21W4br1y9Xs8fX+qum/MTxaj0PYcfH8r+ABcfQh8b6vcF4ur/orrOTlahx1hrHHAazpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5552
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/3/21 10:39 AM, Sean Christopherson wrote:
> On Thu, Dec 02, 2021, Tom Lendacky wrote:

>>   
>> -	return -EINVAL;
>> +	return false;
> 
> I'd really prefer that this helper continue to return 0/-EINVAL, there's no hint
> in the function name that this return true/false.  And given the usage, there's
> no advantage to returning true/false.  On the contrary, if there's a future
> condition where this needs to exit to userspace, we'll end up switching this all
> back to int.

I don't have any objection to that.

> 

>>   		}
>>   		scratch_va = kvzalloc(len, GFP_KERNEL_ACCOUNT);
>>   		if (!scratch_va)
>> -			return -ENOMEM;
> 
> ...because this is wrong.  Failure to allocate memory should exit to userspace,
> not report an error to the guest.
> 
>> +			goto e_scratch;
>>   
>>   		if (kvm_read_guest(svm->vcpu.kvm, scratch_gpa_beg, scratch_va, len)) {
>>   			/* Unable to copy scratch area from guest */
>>   			pr_err("vmgexit: kvm_read_guest for scratch area failed\n");
>>   
>>   			kvfree(scratch_va);
>> -			return -EFAULT;
>> +			goto e_scratch;
> 
> Same here, failure to read guest memory is a userspace issue and needs to be
> reported to userspace.

But it could be a guest issue as well...  whichever is preferred is ok by me.

> 
>>   		}
>>   
>>   		/*
> 
> IMO, this should be the patch (compile tested only).

I can test this, but probably won't be able to get to it until Monday.

Thanks,
Tom

> 
> ---
>   arch/x86/include/asm/sev-common.h | 11 +++++
>   arch/x86/kvm/svm/sev.c            | 75 +++++++++++++++++++------------
>   2 files changed, 58 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index 2cef6c5a52c2..6acaf5af0a3d 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -73,4 +73,15 @@
> 
>   #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
> 
> +/*
> + * Error codes related to GHCB input that can be communicated back to the guest
> + * by setting the lower 32-bits of the GHCB SW_EXITINFO1 field to 2.
> + */
> +#define GHCB_ERR_NOT_REGISTERED		1
> +#define GHCB_ERR_INVALID_USAGE		2
> +#define GHCB_ERR_INVALID_SCRATCH_AREA	3
> +#define GHCB_ERR_MISSING_INPUT		4
> +#define GHCB_ERR_INVALID_INPUT		5
> +#define GHCB_ERR_INVALID_EVENT		6
> +
>   #endif
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 713e3daa9574..60c6d7b216eb 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2357,20 +2357,25 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>   {
>   	struct kvm_vcpu *vcpu;
>   	struct ghcb *ghcb;
> -	u64 exit_code = 0;
> +	u64 exit_code;
> +	u64 reason;
> 
>   	ghcb = svm->sev_es.ghcb;
> 
> -	/* Only GHCB Usage code 0 is supported */
> -	if (ghcb->ghcb_usage)
> -		goto vmgexit_err;
> -
>   	/*
> -	 * Retrieve the exit code now even though is may not be marked valid
> +	 * Retrieve the exit code now even though it may not be marked valid
>   	 * as it could help with debugging.
>   	 */
>   	exit_code = ghcb_get_sw_exit_code(ghcb);
> 
> +	/* Only GHCB Usage code 0 is supported */
> +	if (ghcb->ghcb_usage) {
> +		reason = GHCB_ERR_INVALID_USAGE;
> +		goto vmgexit_err;
> +	}
> +
> +	reason = GHCB_ERR_MISSING_INPUT;
> +
>   	if (!ghcb_sw_exit_code_is_valid(ghcb) ||
>   	    !ghcb_sw_exit_info_1_is_valid(ghcb) ||
>   	    !ghcb_sw_exit_info_2_is_valid(ghcb))
> @@ -2449,6 +2454,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>   	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>   		break;
>   	default:
> +		reason = GHCB_ERR_INVALID_EVENT;
>   		goto vmgexit_err;
>   	}
> 
> @@ -2457,22 +2463,25 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>   vmgexit_err:
>   	vcpu = &svm->vcpu;
> 
> -	if (ghcb->ghcb_usage) {
> +	if (reason == GHCB_ERR_INVALID_USAGE) {
>   		vcpu_unimpl(vcpu, "vmgexit: ghcb usage %#x is not valid\n",
>   			    ghcb->ghcb_usage);
> +	} else if (reason == GHCB_ERR_INVALID_EVENT) {
> +		vcpu_unimpl(vcpu, "vmgexit: exit code %#llx is not valid\n",
> +			    exit_code);
>   	} else {
> -		vcpu_unimpl(vcpu, "vmgexit: exit reason %#llx is not valid\n",
> +		vcpu_unimpl(vcpu, "vmgexit: exit code %#llx input is not valid\n",
>   			    exit_code);
>   		dump_ghcb(svm);
>   	}
> 
> -	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
> -	vcpu->run->internal.ndata = 2;
> -	vcpu->run->internal.data[0] = exit_code;
> -	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
> +	/* Clear the valid entries fields */
> +	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
> 
> -	return -EINVAL;
> +	ghcb_set_sw_exit_info_1(ghcb, 2);
> +	ghcb_set_sw_exit_info_2(ghcb, reason);
> +
> +	return 1;
>   }
> 
>   void sev_es_unmap_ghcb(struct vcpu_svm *svm)
> @@ -2542,14 +2551,14 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
>   	scratch_gpa_beg = ghcb_get_sw_scratch(ghcb);
>   	if (!scratch_gpa_beg) {
>   		pr_err("vmgexit: scratch gpa not provided\n");
> -		return -EINVAL;
> +		goto e_scratch;
>   	}
> 
>   	scratch_gpa_end = scratch_gpa_beg + len;
>   	if (scratch_gpa_end < scratch_gpa_beg) {
>   		pr_err("vmgexit: scratch length (%#llx) not valid for scratch address (%#llx)\n",
>   		       len, scratch_gpa_beg);
> -		return -EINVAL;
> +		goto e_scratch;
>   	}
> 
>   	if ((scratch_gpa_beg & PAGE_MASK) == control->ghcb_gpa) {
> @@ -2567,7 +2576,7 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
>   		    scratch_gpa_end > ghcb_scratch_end) {
>   			pr_err("vmgexit: scratch area is outside of GHCB shared buffer area (%#llx - %#llx)\n",
>   			       scratch_gpa_beg, scratch_gpa_end);
> -			return -EINVAL;
> +			goto e_scratch;
>   		}
> 
>   		scratch_va = (void *)svm->sev_es.ghcb;
> @@ -2580,7 +2589,7 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
>   		if (len > GHCB_SCRATCH_AREA_LIMIT) {
>   			pr_err("vmgexit: scratch area exceeds KVM limits (%#llx requested, %#llx limit)\n",
>   			       len, GHCB_SCRATCH_AREA_LIMIT);
> -			return -EINVAL;
> +			goto e_scratch;
>   		}
>   		scratch_va = kvzalloc(len, GFP_KERNEL_ACCOUNT);
>   		if (!scratch_va)
> @@ -2608,6 +2617,12 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
>   	svm->sev_es.ghcb_sa_len = len;
> 
>   	return 0;
> +
> +e_scratch:
> +	ghcb_set_sw_exit_info_1(ghcb, 2);
> +	ghcb_set_sw_exit_info_2(ghcb, GHCB_ERR_INVALID_SCRATCH_AREA);
> +
> +	return 1;
>   }
> 
>   static void set_ghcb_msr_bits(struct vcpu_svm *svm, u64 value, u64 mask,
> @@ -2658,7 +2673,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
> 
>   		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_CPUID);
>   		if (!ret) {
> -			ret = -EINVAL;
> +			/* Error, keep GHCB MSR value as-is */
>   			break;
>   		}
> 
> @@ -2694,10 +2709,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>   						GHCB_MSR_TERM_REASON_POS);
>   		pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
>   			reason_set, reason_code);
> -		fallthrough;
> +
> +		ret = -EINVAL;
> +		break;
>   	}
>   	default:
> -		ret = -EINVAL;
> +		/* Error, keep GHCB MSR value as-is */
> +		break;
>   	}
> 
>   	trace_kvm_vmgexit_msr_protocol_exit(svm->vcpu.vcpu_id,
> @@ -2721,14 +2739,18 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
> 
>   	if (!ghcb_gpa) {
>   		vcpu_unimpl(vcpu, "vmgexit: GHCB gpa is not set\n");
> -		return -EINVAL;
> +
> +		/* Without a GHCB, just return right back to the guest */
> +		return 1;
>   	}
> 
>   	if (kvm_vcpu_map(vcpu, ghcb_gpa >> PAGE_SHIFT, &svm->sev_es.ghcb_map)) {
>   		/* Unable to map GHCB from guest */
>   		vcpu_unimpl(vcpu, "vmgexit: error mapping GHCB [%#llx] from guest\n",
>   			    ghcb_gpa);
> -		return -EINVAL;
> +
> +		/* Without a GHCB, just return right back to the guest */
> +		return 1;
>   	}
> 
>   	svm->sev_es.ghcb = svm->sev_es.ghcb_map.hva;
> @@ -2788,11 +2810,8 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>   		default:
>   			pr_err("svm: vmgexit: unsupported AP jump table request - exit_info_1=%#llx\n",
>   			       control->exit_info_1);
> -			ghcb_set_sw_exit_info_1(ghcb, 1);
> -			ghcb_set_sw_exit_info_2(ghcb,
> -						X86_TRAP_UD |
> -						SVM_EVTINJ_TYPE_EXEPT |
> -						SVM_EVTINJ_VALID);
> +			ghcb_set_sw_exit_info_1(ghcb, 2);
> +			ghcb_set_sw_exit_info_2(ghcb, GHCB_ERR_INVALID_INPUT);
>   		}
> 
>   		ret = 1;
> 
> base-commit: 70f433c2193fbfb5541ef98f973e087ddf2f9dfb
> --
> 
