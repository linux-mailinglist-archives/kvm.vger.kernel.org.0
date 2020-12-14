Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5A22DA0CC
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 20:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502748AbgLNTrt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 14:47:49 -0500
Received: from mail-dm6nam12on2048.outbound.protection.outlook.com ([40.107.243.48]:10720
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2502617AbgLNTrl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 14:47:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ewO/iPbvBmIuTaomi2ShcqTb5TmEWtql6X8Dpd2i/R1pCnybVH8x4k4KohhOV6lxR4M8K9xIlKny9XyptD+QyYVuDd74kl+Ku0T+WEK13/Q9+VCV0gumMs/b0IlVH++SnO4DWXxIoFVdId/t8Q2oxaTx7CPiVmMv5uD8lz3Y/fYvknzbDlZGKnrCvG9VbFYUe2N2Uq1NTi8sF5hZqv2XuXwH8Sob/jcSAYDMhkK1ji0Vx0/ZnrxbxOjVR7qNWUZIxBVUCcCj1L3nEExNNCzi6NnlYq+tFX177pAsrfFHtVPU+Nwr2eyATFMKFoaMpCD8FAB/tXfmS4K5qxEVNrwuSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8bPaP5T32Kprz3xObdEIHWJhpfVmIYiO1JdAcURhiSQ=;
 b=gv3Oega2yvQ3WqHuDjIkciYqO11OrZSNlb44DgLTGKGFU9MwMnK+JvB44xUkgcrzGCby0R3jA1qZjhr3/9i2HQ11VsKBc7k9PS9YBM3IKDuN6drf2jkddF5ecnRin5NSnGt+h3Fk0WD35bjN8aBpFTFBRHfL+dF4mJUV30yqZVMWURP6miBugbFKKdJSGo/3KNTdOo3r5lxUWLx2TtsZrXm1y/+J54E/m0TkpeCx3Q8fsTUZQ/dHLN4dbmZ/XaYjZ9NKXuyeatvYKWWmU7GlBL6ik3qPbsFkgkt8kGl8ERElu2mdNwUZTDPZt2keHK4dojAQdUvE5HyeuuO92yFxmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8bPaP5T32Kprz3xObdEIHWJhpfVmIYiO1JdAcURhiSQ=;
 b=f5dps3a9nI3N1qIAvkeHkq9rza1WOiI/mYDXbJ/Oq693zGla2Qo0y7fa7okCazxHO72rV9rw6lYru0Pg6xjWt93qNcTh/B6OXN+evGuMU2Hlk7Z8ZROUW4t3hoPvgWupWMNQhRZDqcYsmVTmUVVCHERJX3D4d+5fGQgBHTtOmV8=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3179.namprd12.prod.outlook.com (2603:10b6:5:183::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.12; Mon, 14 Dec 2020 19:46:46 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3654.024; Mon, 14 Dec 2020
 19:46:46 +0000
Subject: Re: [PATCH v5 27/34] KVM: SVM: Add support for booting APs for an
 SEV-ES guest
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
 <47d11ed1c1a48ab71858fc3cde766bf67a4612d1.1607620209.git.thomas.lendacky@amd.com>
 <8ed48a0f-d490-d74d-d10a-968b561a4f2e@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <2fd11067-a04c-7ce6-3fe1-79a4658bdfe7@amd.com>
Date:   Mon, 14 Dec 2020 13:46:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <8ed48a0f-d490-d74d-d10a-968b561a4f2e@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH0PR04CA0038.namprd04.prod.outlook.com
 (2603:10b6:610:77::13) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by CH0PR04CA0038.namprd04.prod.outlook.com (2603:10b6:610:77::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Mon, 14 Dec 2020 19:46:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5d093b71-75fa-4305-ace3-08d8a068fdc3
X-MS-TrafficTypeDiagnostic: DM6PR12MB3179:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3179E33AB9C78A05B6378DBEECC70@DM6PR12MB3179.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mt2zHVXc0afM5eQe6UDYQ524Eyj2gylL940ZzzBIsAYjmo9I3djyv3vmnWkwgmj7QJ1FNWVM2Gd82eZTx9KaN2SxW9X0IEnz48Vs+aQqngLVrBX+DtAGZm1FUNBS38HSr0WyFBEV4w04nFmpFULQYEVn2rRYvhmiyF5REFAHUV9u0XLbxU3CWwMKlmCkSx0otpAPEA76qK8W3R/xmWvHGh/VApD3KNFaiFqnuXQn8budQiZP3fjGfaiOj5qfEFLR9Gq+speDUSvNmB43wId0ZPplh2l1j7vnxFf2XpB+ruk9GKB6/pWoGxzbYhDgI9XzAFMPKMhEf4WYhA5t6tzFmKwDawKDs1vBRG6MzfmhUfM6MEJBXQtka+rSlz6fzvh+PPO6GULRglUvMZPNx8M/F6zv894p9nnXTLvk2KN6e1tI10OCFtmkpAtoqhRmrT79
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(136003)(8936002)(6486002)(16576012)(66946007)(66556008)(66476007)(34490700003)(54906003)(53546011)(26005)(36756003)(4326008)(2906002)(5660300002)(86362001)(956004)(2616005)(8676002)(31696002)(16526019)(186003)(83380400001)(31686004)(508600001)(52116002)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UjUzYWJ4dEhTSVFZbko1c3QrRDd2Q0tXSWdBU2M5SDVrNWVDbVQ2eVNEZEdI?=
 =?utf-8?B?TlV3eDBIcmhCUjlVMmZiRzUxSjNSa2lzSXVNU21LNnIxTEEzS1gvbXNMTnRF?=
 =?utf-8?B?RmdrSDRmZXhxcjhLTFlFOThiOWtIQytuNTg1bitDeG8xeThUcG5KdzNqekxL?=
 =?utf-8?B?S0F4NGdkY1FSQTMyeG5TK00xNEdHYmxwamdyQTJBNU5MNlkwU3B2TU9DSksv?=
 =?utf-8?B?VTc0Y210UDFqZHdFRkQ5VUNXYmQvMW4vYmx5UTF3VHlkbktHNEFIcWpQMHl6?=
 =?utf-8?B?R2VwV0NITGJFY2tCNTBkcU90TFE1elltbGprQk9oazdEd3k1NXgwajdiSlky?=
 =?utf-8?B?cG5pZHdDQVlqWER1d1djc3lYZDN0M0g0MDYrMTRZRjZOVytERWF3NmQ5bE1Z?=
 =?utf-8?B?SElxa01ZL3FpUEd2b3QzZi9Va29GaW1nRkdRdmpCWFk5c3ArLzVza1NzOWU4?=
 =?utf-8?B?VEJwSGZkaUxWODd2KzhYdGdqV3gzTU80aEZ0SlZNYzAraGVFUkI2dTI4VUkv?=
 =?utf-8?B?dk9Ndk1sN1lReG16YXMrYVJsU1hHd1ZjUTZZTEtST3RSM1dWdFJMcFdnRHFW?=
 =?utf-8?B?WFhQbjhmTjBPT0JESGtHVHozMzdZWmx3aUp3TWhyendlMnJSaWY4S1Y4RVRU?=
 =?utf-8?B?RFhsbThUaXNRV2V1UHhGcStUeVhjMnAxR3RiVys2K2NIMFFvcUhZaGFMN2NH?=
 =?utf-8?B?WmRSdFVFQ3ZnM2kyZmxtMGlEQU5FR0ljVTBBV3ZJLzdJNnBxaDRYdkZXbFZk?=
 =?utf-8?B?VGR5WW1hY1ArMDRDSG9HUk1oQXZ3aDZaZnYvOHZEOTkxa0hYVm5XWHExenR6?=
 =?utf-8?B?V05SK0liOVlWN05NZTlja0JKSmYybFdUTm5pTyszNGdGU1hYQmNzVzArYnNL?=
 =?utf-8?B?WUdGSkMvblY3TExneVZXTGhESERjMnJ6RXZZd0FFUTlLcm5mZ2l4cmNsNklp?=
 =?utf-8?B?NEt2eDRZN1kraVNXV0hpWGgwYWxrTitwTDc2SWR0dUZZNVovTmt4V252U2ds?=
 =?utf-8?B?NlF2SU52LzJHeGt5Mmtqai9nTm53eElOTmJpQkhCWnh3eFh2RExKdDA4MStm?=
 =?utf-8?B?Um81b2ZKMkcyWmJxMEpyeWtuUHFIUWZVcUdPbkdBVkhZa0cwQjhKdXBuSmJT?=
 =?utf-8?B?ZHlJVjd0NDRpNmpkVWNiQ1RoVTN5a2l4dFZDbTVmU2lhTUFnd0UwaENBWVU4?=
 =?utf-8?B?UTh6OC9uUThTN01JaFJ3Y2w2TnRJeGVkcFFTWGEzNGhxWisrcFNSNkdXNFVw?=
 =?utf-8?B?WTFxT1Zsa0ZBMXBNK2ZDNTFNVFg1TUVJWFlzUmhEL2FGQ093THN3ckQ3L0dG?=
 =?utf-8?Q?zBUL9R29cyRuGG9ZGToLsHKTlUMv5ZmVe2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 19:46:46.6937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d093b71-75fa-4305-ace3-08d8a068fdc3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pyf97Jrcn/dQ7Qm0ThFF4LwFqbK1dg+uhnLg24+2oRTg4/O0srpzG9ggvSRT7PLP4LN78PAHLiPaQ9KNTIbNAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3179
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 10:03 AM, Paolo Bonzini wrote:
> On 10/12/20 18:10, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> Typically under KVM, an AP is booted using the INIT-SIPI-SIPI sequence,
>> where the guest vCPU register state is updated and then the vCPU is VMRUN
>> to begin execution of the AP. For an SEV-ES guest, this won't work because
>> the guest register state is encrypted.
>>
>> Following the GHCB specification, the hypervisor must not alter the guest
>> register state, so KVM must track an AP/vCPU boot. Should the guest want
>> to park the AP, it must use the AP Reset Hold exit event in place of, for
>> example, a HLT loop.
>>
>> First AP boot (first INIT-SIPI-SIPI sequence):
>>    Execute the AP (vCPU) as it was initialized and measured by the SEV-ES
>>    support. It is up to the guest to transfer control of the AP to the
>>    proper location.
>>
>> Subsequent AP boot:
>>    KVM will expect to receive an AP Reset Hold exit event indicating that
>>    the vCPU is being parked and will require an INIT-SIPI-SIPI sequence to
>>    awaken it. When the AP Reset Hold exit event is received, KVM will place
>>    the vCPU into a simulated HLT mode. Upon receiving the INIT-SIPI-SIPI
>>    sequence, KVM will make the vCPU runnable. It is again up to the guest
>>    to then transfer control of the AP to the proper location.
>>
>> The GHCB specification also requires the hypervisor to save the address of
>> an AP Jump Table so that, for example, vCPUs that have been parked by UEFI
>> can be started by the OS. Provide support for the AP Jump Table set/get
>> exit code.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h |  2 ++
>>   arch/x86/kvm/svm/sev.c          | 50 +++++++++++++++++++++++++++++++++
>>   arch/x86/kvm/svm/svm.c          |  7 +++++
>>   arch/x86/kvm/svm/svm.h          |  3 ++
>>   arch/x86/kvm/x86.c              |  9 ++++++
>>   5 files changed, 71 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h
>> b/arch/x86/include/asm/kvm_host.h
>> index 048b08437c33..60a3b9d33407 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1286,6 +1286,8 @@ struct kvm_x86_ops {
>>         void (*migrate_timers)(struct kvm_vcpu *vcpu);
>>       void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
>> +
>> +    void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
>>   };
>>     struct kvm_x86_nested_ops {
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index a7531de760b5..b47285384b1f 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -17,6 +17,8 @@
>>   #include <linux/processor.h>
>>   #include <linux/trace_events.h>
>>   +#include <asm/trapnr.h>
>> +
>>   #include "x86.h"
>>   #include "svm.h"
>>   #include "cpuid.h"
>> @@ -1449,6 +1451,8 @@ static int sev_es_validate_vmgexit(struct vcpu_svm
>> *svm)
>>           if (!ghcb_sw_scratch_is_valid(ghcb))
>>               goto vmgexit_err;
>>           break;
>> +    case SVM_VMGEXIT_AP_HLT_LOOP:
>> +    case SVM_VMGEXIT_AP_JUMP_TABLE:
>>       case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>>           break;
>>       default:
>> @@ -1770,6 +1774,35 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
>>                           control->exit_info_2,
>>                           svm->ghcb_sa);
>>           break;
>> +    case SVM_VMGEXIT_AP_HLT_LOOP:
>> +        svm->ap_hlt_loop = true;
> 
> This value needs to be communicated to userspace.  Let's get this right
> from the beginning and use a new KVM_MP_STATE_* value instead (perhaps
> reuse KVM_MP_STATE_STOPPED but for x86 #define it as
> KVM_MP_STATE_AP_HOLD_RECEIVED?).

Ok, let me look into this.

> 
>> @@ -68,6 +68,7 @@ struct kvm_sev_info {
>>      int fd;            /* SEV device fd */
>>      unsigned long pages_locked; /* Number of pages locked */
>>      struct list_head regions_list;  /* List of registered regions */
>> +    u64 ap_jump_table;    /* SEV-ES AP Jump Table address */
> 
> Do you have any plans for migration of this value?  How does the guest
> ensure that the hypervisor does not screw with it?

I'll be sure that this is part of the SEV-ES live migration support.

For SEV-ES, we can't guarantee that the hypervisor doesn't screw with it.
This is something that SEV-SNP will be able to address.

Thanks,
Tom

> 
> Paolo
> 
