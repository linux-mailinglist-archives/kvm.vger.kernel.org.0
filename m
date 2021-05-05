Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3DB237481B
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 20:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbhEESkF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 14:40:05 -0400
Received: from mail-dm6nam11on2067.outbound.protection.outlook.com ([40.107.223.67]:48448
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234163AbhEESkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 14:40:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hxUft5fzrx55yoc5VUIH0qkiI9PF43C/rmhhI+BIKC39A6xq9aFlEErUATScZeeejpvMfKy5PTMy9SOHnT9Gq4XMwPUXznEWOJORZnzJoQtAQF6CM2SR+LmFZ7KF8Ew8JfaOrU0RSKLZw78dlUBkXFvupdMLc8Nc+UhlsZt+A9fccQKY+ZWabVqRlytjllaOp7PCHTuSmjh3XymhitQlFn2VS2rUs/kg8OhYSZTnbh9T9OXCzk5SbG9ZvzeGMGkuhLdr2GElNLEiNS/KtbS9JCKSqSYit0HEOFc6UJXWlqXP5zjFRbb4/UTUONmlYPVNLUqwhbnIwJQlDzEBwumd7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLKOj/v2JxRsUMgUSpokksCMW9CoBBr0IljKpZOSesc=;
 b=h4Bmv+5a+d5TOq3DTl1g23Lxu5mHNOxxG93eMzPTupyJ644oejS+GVH5Y/2UQIdi/aUYNd4wa5JMPY/7+hdPWb5V5wyk/A3eubfMIa9+56Ocva6E4d8IIgeRBFIA+kNeiSJKbkVMKTLjzJ11IsTa+r8cEQmGeAKbaWSUQl78jKQR17DVL1N+Oq5w746TWxhWnoYEPyVx8ChO6w7lqfs9uz9xSW60ALeWj8hPz3j4iSeH8BQNUBE6VW7aZR/mpaUxJGUBrPL0Ihdp477/621W/qG2za1h2SwedoWnifBqbq+uQx6L9eiAuDINF0klU/wLKkhZQ3/5XFePzmmeGWUjuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLKOj/v2JxRsUMgUSpokksCMW9CoBBr0IljKpZOSesc=;
 b=EjpDSrvS7aROpzdMOfkFRt0h1DhxxImOZ3RWubbKn11UNjx91cUyfhEOyBV8IU9+AuIzHJjAP+FO4aqQlhcij30p62QdqfSWKC1WBydhr4k99P5hAayGiUjoOXtaGg8+33t8bMZlAB9GE3+ZTLFVdUJsj8vRs4l/ff1QlcCYTPo=
Authentication-Results: alien8.de; dkim=none (message not signed)
 header.d=none;alien8.de; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4087.41; Wed, 5 May 2021 18:39:07 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4087.044; Wed, 5 May 2021
 18:39:07 +0000
Subject: Re: SRCU dereference check warning with SEV-ES
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>
References: <601f1278-17dd-7124-f328-b865447ca160@amd.com>
 <c65e06ed-2bd8-cac9-a933-0117c99fc856@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <9bbc82fa-9560-185c-7780-052a3ee963b9@amd.com>
Date:   Wed, 5 May 2021 13:39:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <c65e06ed-2bd8-cac9-a933-0117c99fc856@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0039.namprd13.prod.outlook.com
 (2603:10b6:806:22::14) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SA9PR13CA0039.namprd13.prod.outlook.com (2603:10b6:806:22::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.9 via Frontend Transport; Wed, 5 May 2021 18:39:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ed17697-02aa-4ee2-c8df-08d90ff51062
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1772A85E075ABC6D973C8BBAEC599@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YaAoSmuVkBHWk6TgyB3BbpubsYuSvw4ELRnoFW/VpktNfsurE7D1d0/m5kuzuzbe/UXGAgF6PYLOqyxFXWmBS5dEMCpw7WZftMevZpW+1HDiM1fIAtIeSyjfO/ivtB++6YFIzPXVUNMX/21XslJzIPxuPtdfRFTwYnGMC78nqk5VtW77wLikqu459uqGS48q+QyoOlhBKftfeNhim8ywUawDroLQDsjHu65PJkLIvk4CLeP60uJ+2QhQkCPadAMGvLmdrcG/AlRNTeiyTugX7briaaiZO0JNlg3funUP0Y7D815a1Tv1mDCDjHSCbK7uSLkjTtHvlhW3I8aPlJ+Ewr7SEyxIoGx/PEXN5J5VWWZ81TSuzxJbElxVHVYa/EPQEENzTn+AEq4iYCK93qNSphy99D3JSWWwn0mEF1UU8TQwkc9q/NXHSm/8xRUGhm/nGtBykjKnZdqOEW0SKhChzvD0h2Q3X8cdh4pxDEYbFElRBx22d9IDVz1P9m1bJdKmklkMRVj4l3KsW4/POqjuOuPMaX5P1YB336dz/qozXEVY9quIUhz8tBtCfnC0xPcdvXInP6mxVrQC29LSudnbTxyqU5QQH3XxwSVHj23NEbdDfqst47tS234STD/Gd8HhGrqDV0/Lpgm2RObNhw/WfTccuPWFrvLbsLnBmVSFMdeAVr1iVOuU5YtxZfAWBORc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(376002)(136003)(346002)(396003)(2906002)(36756003)(66946007)(38100700002)(8676002)(6486002)(8936002)(110136005)(956004)(16576012)(86362001)(66556008)(66476007)(16526019)(316002)(31696002)(5660300002)(4326008)(83380400001)(186003)(53546011)(31686004)(2616005)(26005)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aDBKcjJPRHZOeGw3YWJrUmRpWUdYRWhKU0x0a1FFdzBLNSttc0tNL3dvbkFY?=
 =?utf-8?B?MDZORlFGWkhXSHdtb0J5dmV6cDRKa0Jhc3RlNkdXN0dCT3hSZWovOGgzWlpy?=
 =?utf-8?B?SGJGcmV6V1lGN29xRjJEbXhWS0MvQndSMkpva3hSUXljNTZSTWVmQS9MaDlF?=
 =?utf-8?B?WUlhemhGY21Cd0lkcDhTd0RiaTY2SnpEdkR1V3R0dEt2ZkRiQlRFa0U0UFA3?=
 =?utf-8?B?OW02WVZzeWp4OS9OQkdycXpaSVZLNWtiZlBKK2IvclpUUzBmVmRiNUM3YnRS?=
 =?utf-8?B?b0tEcG5QaUd2ZGNaY0kweVEvdjBkT1lMVmFEQjdnRzFKTHJZZzJ6bmd2QlN1?=
 =?utf-8?B?ZU9Ld0thZG5HdnZLeGZmZ1U2QWxWVVRVOTFrVVhwVGVlbzZMQVBTZ1BxWkFW?=
 =?utf-8?B?MmY1L0NMZHRHbGdFVmNjWldYWFlER1BKTUM5VGNQcjQ5MFp5KzNHaWFwSWND?=
 =?utf-8?B?MEJDMU1KaVhkSUQyV0UvR2xDQTRxV1R5YUFiek5Vd0pTQTM4TjNJNHJSbVR4?=
 =?utf-8?B?emQ2MVE5WjJ1TFFobmVrR0syYnJTV1VXN0dBaVFreTZwZzF6TjI1dEZDbzRj?=
 =?utf-8?B?TXFBLzlWRHpOV0k3Qmh1WnY0dzh1YWRvNElJK2tmK3dsVEJqeDB4OFh4Qmlj?=
 =?utf-8?B?RkQxREQ1STNIRitSVU5xelZ1c3VEaThLTWVHT1lVZjhsZUdQTUhuY3pSK0s5?=
 =?utf-8?B?KzZsMUpOVFFjSUNoMmdSQ2hBTkd1ZXN6L2p2VklpOHpYWVdNdUU3Rll1Mzd1?=
 =?utf-8?B?YWdMVW9pV2xWSGg3VjF0SnJBV2RUcDgxNjNyL3piQnFCY1FHRUZoaTR1K1JX?=
 =?utf-8?B?bVlMTW8waHpwRGtoTTQ3by8rTjFsNHhzRHFFbnplNGk4RmxWbXFJR0dEOUNC?=
 =?utf-8?B?eU14VG5xdGhlVDVJejRYTFNuWlRaMmcrU0tKd05EWVlkeFo2UXZPam0rMmZM?=
 =?utf-8?B?TzRQc0tnL1Yyck1TNGRJRjVnUzMvVDBMbGNpaUtwUW43YUI1cXVwU3Z0bk5q?=
 =?utf-8?B?SHZRTzR4dHc2QS9qSndmZnZWWXVHbkMvbUNNNjlYZGphdkUxZWhMWnpLV1p4?=
 =?utf-8?B?Zm5YWmVpUkhHUG1GblRaN3AyZ3dDUVZLT255QWx1a2JCR0ZTZFRqblNqMkdr?=
 =?utf-8?B?S3FWSzU0NkZ4SFh6QW14UDZlK05zUkdOcG0zMW1oWHJTSlgwd2E2clpoTFEw?=
 =?utf-8?B?RStXVmNVU2lCSmcvbVpqcHhLRTFxdURMT3MzWE1URmF6VFNnMmMrNE85TndB?=
 =?utf-8?B?ck9xQnVvd3pJOXNtd2hRZlF3LzdmNWNvS3YyTjVQVFc4YnBQWGxJTmg0MEpi?=
 =?utf-8?B?cVhXZnF6OFZxMEt0bWRQSWZRSHN1clpwZlVLRyszRnZWUnhyNlRmVDdGZndZ?=
 =?utf-8?B?UmZrd3lCZk4zQWRSK21NTEJ6WmNTRi9mczBlS09ObXNEZXR0aGcrK3hGaFZp?=
 =?utf-8?B?VktwMnBUWUFYemNmTzRjSlVMdDRyczJzM2hCbmV6MEx6T2ZaenR1cDh5MEZX?=
 =?utf-8?B?TXh0Z3ErT1JCeDV2OGNiM2QwR2FVSTVGeHQ2MHRUVVN2eUZtVy9UYXlzcDZM?=
 =?utf-8?B?NlpJUzRVY1hBTkNySDF4ZGhxclg5eEluZ3Y1SlNwcHdzY3l2ajhKOGhUVGh2?=
 =?utf-8?B?WVFWcHhGWGF6dkJDb3p3THVMMnhxWmpnMVc4clU3L3pUTDNYUjUxcGNaazhJ?=
 =?utf-8?B?b1I5OUgydXV6R1dMbDBqUUFoOWRSRkVzV3hUbS9yNW9iRnZXSUdXbzFLcHJm?=
 =?utf-8?Q?8HpOzFBwP1oFXkuMVV7AFbYumSvcHEl47bYp6+W?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed17697-02aa-4ee2-c8df-08d90ff51062
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 18:39:06.8488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kOPnxbE5J304PXPYbkTxoWbz+EFJP7yKICUfNzJMTdaetqLLR2ccW/KqyTdDZmSP+tOaHrClAtoq0eM+Jv/XXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/5/21 11:16 AM, Paolo Bonzini wrote:
> On 05/05/21 16:01, Tom Lendacky wrote:
>> Boris noticed the below warning when running an SEV-ES guest with
>> CONFIG_PROVE_LOCKING=y.
>>
>> The SRCU lock is released before invoking the vCPU run op where the SEV-ES
>> support will unmap the GHCB. Is the proper thing to do here to take the
>> SRCU lock around the call to kvm_vcpu_unmap() in this case? It does fix
>> the issue, but I just want to be sure that I shouldn't, instead, be taking
>> the memslot lock:
> 
> I would rather avoid having long-lived maps, as I am working on removing
> them from the Intel code.  However, it seems to me that the GHCB is almost
> not used after sev_handle_vmgexit returns?

Except for as you pointed out below, things like MMIO and IO. Anything
that has to exit to userspace to complete will still need the GHCB mapped
when coming back into the kernel if the shared buffer area of the GHCB is
being used.

Btw, what do you consider long lived maps?  Is having a map while context
switching back to userspace considered long lived? The GHCB will
(possibly) only be mapped on VMEXIT (VMGEXIT) and unmapped on the next
VMRUN for the vCPU. An AP reset hold could be a while, though.

> 
> If so, there's no need to keep it mapped until pre_sev_es_run:
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a9d8d6aafdb8..b2226a5e249d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2200,9 +2200,6 @@ static int sev_es_validate_vmgexit(struct vcpu_svm
> *svm)
>  
>  static void pre_sev_es_run(struct vcpu_svm *svm)
>  {
> -    if (!svm->ghcb)
> -        return;
> -
>      if (svm->ghcb_sa_free) {
>          /*
>           * The scratch area lives outside the GHCB, so there is a
> @@ -2220,13 +2217,6 @@ static void pre_sev_es_run(struct vcpu_svm *svm)
>          svm->ghcb_sa = NULL;
>          svm->ghcb_sa_free = false;
>      }
> -
> -    trace_kvm_vmgexit_exit(svm->vcpu.vcpu_id, svm->ghcb);
> -
> -    sev_es_sync_to_ghcb(svm);
> -
> -    kvm_vcpu_unmap(&svm->vcpu, &svm->ghcb_map, true);
> -    svm->ghcb = NULL;
>  }
>  
>  void pre_sev_run(struct vcpu_svm *svm, int cpu)
> @@ -2465,7 +2455,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  
>      ret = sev_es_validate_vmgexit(svm);
>      if (ret)
> -        return ret;
> +        goto out_unmap;
>  
>      sev_es_sync_from_ghcb(svm);
>      ghcb_set_sw_exit_info_1(ghcb, 0);
> @@ -2485,6 +2485,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>          ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
>          break;
>      case SVM_VMGEXIT_AP_HLT_LOOP:
> +        ghcb_set_sw_exit_info_2(svm->ghcb, 1);
>          ret = kvm_emulate_ap_reset_hold(vcpu);
>          break;
>      case SVM_VMGEXIT_AP_JUMP_TABLE: {
> @@ -2531,6 +2521,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>          ret = svm_invoke_exit_handler(vcpu, exit_code);
>      }
>  
> +    sev_es_sync_to_ghcb(svm);
> +
> +out_unmap:
> +    kvm_vcpu_unmap(&svm->vcpu, &svm->ghcb_map, true);
> +    svm->ghcb = NULL;
>      return ret;
>  }
>  
> @@ -2619,21 +2620,4 @@ void sev_es_prepare_guest_switch(struct vcpu_svm
> *svm, unsigned int cpu)
>  
>  void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>  {
> -    struct vcpu_svm *svm = to_svm(vcpu);
> -
> -    /* First SIPI: Use the values as initially set by the VMM */
> -    if (!svm->received_first_sipi) {
> -        svm->received_first_sipi = true;
> -        return;
> -    }
> -
> -    /*
> -     * Subsequent SIPI: Return from an AP Reset Hold VMGEXIT, where
> -     * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
> -     * non-zero value.
> -     */
> -    if (!svm->ghcb)
> -        return;
> -
> -    ghcb_set_sw_exit_info_2(svm->ghcb, 1);
>  }
> 
> However:
> 
> 1) I admit I got lost in the maze starting with sev_es_string_io

Yeah, kvm_sev_es_string_io bypasses the instruction emulation that would
normally be done to get register values and information about the port I/O
and supplies those directly. But in general, it follows the same exiting
to userspace to complete the port I/O operation.

> 
> 2) upon an AP reset hold exit, the above patch sets the EXITINFO2 field
> before the SIPI was received.  My understanding is that the processor will
> not see the value anyway until it resumes execution, and why would other
> vCPUs muck with the AP's GHCB.  But I'm not sure if it's okay.

As long as the vCPU might not be woken up for any reason other than a
SIPI, you can get a way with this. But if it was to be woken up for some
other reason (an IPI for some reason?), then you wouldn't want the
non-zero value set in the GHCB in advance, because that might cause the
vCPU to exit the HLT loop it is in waiting for the actual SIPI.

Thanks,
Tom

> 
> Paolo
> 
