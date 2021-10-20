Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8BC8435574
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 23:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhJTVqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 17:46:05 -0400
Received: from mail-co1nam11on2087.outbound.protection.outlook.com ([40.107.220.87]:43712
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230181AbhJTVqE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 17:46:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AtH/27Ovqe6fHUxa5OhYR9SLFuBy1q1m2mtMHNUnzbjmy02W9wqMoraWGdnzImFW2bQlq3aPZcvul84bL5Pw0O38kFaT5lybUXBUmhK9OCflV88vmH3Z5yqNiMAPaU4NYVqGkwaW4sfBKGy0YA2ol7p1F09oCJDZcMz8vtWBXvCrdTRsQiVUM06wuujz++X2Gxyckt4TGni5Y67beVQcHuF86nsiq+luOpdAaYaBKC7eKqDN48CXIsImO2lRYePuHHPYCeMZAMD7n8zpyQ3fOa03truOVTTnz+LtKzyeXyGIh16eCmZk+FBhonKV4lbygyrkZg0TTYSwGxdAPLRZqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2pHTkGxk3aJhueRknWsAbyL6ewAfJyewuXv8CkknZ3s=;
 b=lBHFQ5KyQ0pRSgrzgmOiUzteIjBxSAhVyXfQtSXyGn0pr4QtssRe5CUltExWTvS+1bZ28qAC7FQTVR9qa0IzKb0uuD4/SZsBnNeQAa/Qs5SSLbJOzcHID5ZDqxDimfx1C0OJOBg0ZxCzwOO4cmIBa6Z6AcfWz8vUBy/0yIqKJE7dtAxuHaLC2mPBlLw3eWngP/uRxeqL+lt8SZWoAxLdBVL1m/bGz84sVU1E5oPrX+rXJIQf6QHir3clbv9rTrCxtENrutsV4i07AncqA1ighyDqRi/UJqYAeeOPIDwt6WLYOYtQgXEAdbakifJ4zaseOVzxNsa3widJSKDJfXR7WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2pHTkGxk3aJhueRknWsAbyL6ewAfJyewuXv8CkknZ3s=;
 b=KaCEFFy7ZLTRDI3EX4lypANWSAWoOIfaZjb2du4PoheTKzRW/EGvuBuGzT6qufxJEUEMJIBAP81MIag8HW3H4hth7Qm0h9BBkUVKKjprs6foiw4Y0vSE/udGTGCHbV3uZcjy4Uv79PVWOhEZ9R/7BJ4I3PKb5fxIFGVZbFvnqS8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5248.namprd12.prod.outlook.com (2603:10b6:5:39c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Wed, 20 Oct
 2021 21:43:48 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%7]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 21:43:47 +0000
Subject: Re: [PATCH 3/5 V10] KVM: SEV: Add support for SEV-ES intra host
 migration
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <20211012204858.3614961-1-pgonda@google.com>
 <20211012204858.3614961-4-pgonda@google.com>
 <00cba883-204e-67ea-8dba-3e834af1aa6e@amd.com>
 <CAMkAt6qRq-cUT5QYAZZZ26mTcBjfVXQzX8LCrD63omSRR=SJOA@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <ca31adfd-79a0-f65d-85db-3feb49ab0c41@amd.com>
Date:   Wed, 20 Oct 2021 16:43:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <CAMkAt6qRq-cUT5QYAZZZ26mTcBjfVXQzX8LCrD63omSRR=SJOA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR14CA0025.namprd14.prod.outlook.com
 (2603:10b6:208:23e::30) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by MN2PR14CA0025.namprd14.prod.outlook.com (2603:10b6:208:23e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 21:43:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90439d34-a2b4-45e5-82fb-08d99412b27d
X-MS-TrafficTypeDiagnostic: DM4PR12MB5248:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB52484765BE96F39FEBBA815FECBE9@DM4PR12MB5248.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IqUyAh+Qb7GLjoWDJnR8Qlj24s9ELFwVwHLUxAb/l1fvZjRnISLXtHqhCCbAKYyURsMZxWpfjAevbNSBZdbswmTDjjyM7Lc72HTvI+V0erxDhPauBPuxueHYq4qy10RZNqdwKal9tJMGX6aM5EvzkEvuL16rsXJv4CLEiW0GfkZEBFySzwshUeai3bHRGD0/NubpVm1fw17hmmaveLYTM5G3xPfJpIsQ4CD+qO5pOFEtwHe2gGXY2BZIsI/UBkonpJ+nYQzGGRuaV/PTLyFXEkoHyQ6XyHTBaG/YcW9J5CMTwSSGK7J4+v1Qg7qQXL/PEk6Bsb46DCIQobd4UaDPtJYoFRFvH2Moy3e2+Sp3hokmZrCnPlQ9eKjjs9lf0jv7bPpnWkqfLSE/4ztLckZbk0bN0bxQxrN1MXPV2LpfcmuKhuUubf0n1Yyqppt50G/PjigpDE1KWneibcTqkgLxTDJmX02CI6/0LeqbfzHA4S835QOmz2Y7l2z1uO4sE2KxSXCD6CbOuSLczxlBY7i8dywvl1tBbpBLFyvbUtum5KCksqTeVZjRiRHsxKGezLHPPRVPZ/MgvYR6b04U8k2uL1J40VdANZtN8MNkCg+bV78E0wHP53uF1xsVJezsdnPYpJ/vmd4ol81JhdWO1f8BaZ7mf9LtvKbmtmfvg0MYYc4Lq7BfTG58tmI9ZdY7GFiHV29Cd/5D89NOFI+RGqXXAx+CC4lvm3BXzS88XuxdWUWNUJ3p7xML3v+/UBW+NYss
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(16576012)(6916009)(508600001)(8936002)(36756003)(83380400001)(66556008)(6486002)(2906002)(186003)(66476007)(38100700002)(956004)(31686004)(4326008)(86362001)(66946007)(53546011)(7416002)(2616005)(54906003)(26005)(5660300002)(8676002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjlZVnFvZVRWM1l3UFM3WERXdmJRakhrbC9EOFdsSll0MXZtUGErK3FIdGdX?=
 =?utf-8?B?TGZrMi8yS0ZmbUhGT3JXemNLV1pYZkZKbjFzcXNZcldSYXJLM3ZwQzVkNUFG?=
 =?utf-8?B?NDhEenZxSUplT09TaVpPMzF6d3MzeU9DR2FxeTdPUEdlSjlIZk9VdWZEbzA1?=
 =?utf-8?B?SW5MM2ZzNkNxc0JnR2l2UGVrRHR5c0ZkT2lkRkZ1cmVmUmpVQnYrbHlVRzJT?=
 =?utf-8?B?QUhmb0Q1UXI0SUdHK2U4TWM3bzZ1YkpYcFJ6TlBva1hPaHhFa281SFhXQjda?=
 =?utf-8?B?MEFjU3U3aVp1Zm5PRGt3bVUwd2dNeDZUbkliYmlYazI5Q2Z0RE8zZHNZSFZh?=
 =?utf-8?B?TnVNaStHRk9GR0ZxbjI1b0MzUnNJNW4yQWcyQWN2d1phTUFaQmNKQzdFK2JT?=
 =?utf-8?B?anJBc2xydWtic0VQaVJVMjI2WStNUTFDUlFrRDFsZjlselRITTFvYTZsaWZr?=
 =?utf-8?B?TTMzZi9ETzZpUXpNZGgyd2luYVNVUEF1dCsyZmc2ZG5hV1dxSjNWd3J1OVpl?=
 =?utf-8?B?dUppWnJMb0FlRUMzQnN6Nk9CdzdSS2V6bXlSUVJTMVd5a2FiODVkcHlKbHJw?=
 =?utf-8?B?ajAwa0hmOXpXZXMrcVk1QmRlMk1kbmNQUUR3VFYwS3dRMUlLMFJ0akdkVi8w?=
 =?utf-8?B?TkkyQkw3aDZUNE9RK1YvQjZ0Z1RZS1U2RGlPc1llTGhXa2VUNmp3bkdIVml0?=
 =?utf-8?B?d0NnZVpsUy9NOWxIWmJadzkvWFVzajNGdk5CUHZLWW5TNSt0MkRwd2dkbk1k?=
 =?utf-8?B?SEhPWk4rZ0QvYk01ZlZEdXdwQzFZakw0cUZSTXYzM0VRbFNkM0VYekdLYzNy?=
 =?utf-8?B?UnluaGgwdjEwcXIwUi9ENjdYZm9QSjE0N3JRMit5VFRFaTQvbTcxTCt6akJX?=
 =?utf-8?B?V0EwNDBhcVYzTE1jM1R1N3RPeVZYYXJMQ2lEQjdTNG5jbWE0TDlId0VjSEJR?=
 =?utf-8?B?Mmt2Rk1CQ0ZTSzlrdnNnbHU4M29nQUVWOGxybHAvY2s4dStGZDVKSVdpdlhs?=
 =?utf-8?B?SmJzbTEzeXpyWmV2V2hldDJjR3FlR0FxNUpiSWNaN2N2aHdhdUMzeWtJaFVO?=
 =?utf-8?B?N2tzc05sWmJKSlFIUmhUemZaRFh0NkpnSGdHVXZPSS8zcEZpa05GQUw5UUtx?=
 =?utf-8?B?SVJZSDVQa0FrUXpOeTAxbFVqbnlUbjFXWTlZWFE0RFhkSVBCMFlBa1F0L1dz?=
 =?utf-8?B?RWhkeWxKK3FuUG1BSzhiTkVRbGFRdVozdEg4dHFvOTBCakZ0NjUxT1MzN3h2?=
 =?utf-8?B?dGp2SEptMmJNVVcxMkttN0ZuQVM3UGZ3MGNTZVRibFdlYU9vbnk3RGphYkdI?=
 =?utf-8?B?OXNEZWNvYk0wTTFrUjhkb054S2toeFBXOXp5allHWTVnWTc2WVNUUVhoWDFq?=
 =?utf-8?B?cGY4MmsvVFE5RUtpbHpCYVg3WVEvT3VCdlBJODFHeWdSc0ZjdnN4Mm9aSnpX?=
 =?utf-8?B?SDBmRVZPdDhnN0dyanVhM2Q2dGI0NVNEeldiY3h1Q3dtSHdNREtzL2ZudGJ3?=
 =?utf-8?B?Q1NFckU3VWFrVkgvR3ZMY0FiYTZyanJvdnpBKzRncGViRnNqVDVaNWdHblNv?=
 =?utf-8?B?RVdWUjBiaVA2K3pleC9yTk54WXNXVTYrZ1h2Q2NJSkxzQi9sL0NDSTFRWG5F?=
 =?utf-8?B?bVRIZ0Z0SzdreGQ0VlJISHlnTzFGeHphUFVoM0F5NTlnOGJBdmc3ZVl6WjFY?=
 =?utf-8?B?UWs5K1dWYkhqR3hsYVRmNEorRU5GOFNvcTRyZXBDVmVLVkp3SXJFVnEzV2Iw?=
 =?utf-8?Q?XRnymU3f8AmKilLoUB7YFRHgehUoOx/pX/fDaK+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90439d34-a2b4-45e5-82fb-08d99412b27d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 21:43:47.7843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tlendack@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5248
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/20/21 3:43 PM, Peter Gonda wrote:
> On Fri, Oct 15, 2021 at 3:36 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>
>> On 10/12/21 3:48 PM, Peter Gonda wrote:
>>> For SEV-ES to work with intra host migration the VMSAs, GHCB metadata,
>>> and other SEV-ES info needs to be preserved along with the guest's
>>> memory.
>>>
>>> Signed-off-by: Peter Gonda <pgonda@google.com>
>>> Reviewed-by: Marc Orr <marcorr@google.com>
>>> Cc: Marc Orr <marcorr@google.com>
>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>> Cc: Sean Christopherson <seanjc@google.com>
>>> Cc: David Rientjes <rientjes@google.com>
>>> Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
>>> Cc: Brijesh Singh <brijesh.singh@amd.com>
>>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>>> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
>>> Cc: Wanpeng Li <wanpengli@tencent.com>
>>> Cc: Jim Mattson <jmattson@google.com>
>>> Cc: Joerg Roedel <joro@8bytes.org>
>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>> Cc: Ingo Molnar <mingo@redhat.com>
>>> Cc: Borislav Petkov <bp@alien8.de>
>>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>>> Cc: kvm@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>> ---
>>>    arch/x86/kvm/svm/sev.c | 48 +++++++++++++++++++++++++++++++++++++++++-
>>>    1 file changed, 47 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index 42ff1ccfe1dc..a486ab08a766 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -1600,6 +1600,46 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
>>>        list_replace_init(&src->regions_list, &dst->regions_list);
>>>    }
>>>
>>> +static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
>>> +{
>>> +     int i;
>>> +     struct kvm_vcpu *dst_vcpu, *src_vcpu;
>>> +     struct vcpu_svm *dst_svm, *src_svm;
>>> +
>>> +     if (atomic_read(&src->online_vcpus) != atomic_read(&dst->online_vcpus))
>>> +             return -EINVAL;
>>> +
>>> +     kvm_for_each_vcpu(i, src_vcpu, src) {
>>> +             if (!src_vcpu->arch.guest_state_protected)
>>> +                     return -EINVAL;
>>> +     }
>>> +
>>> +     kvm_for_each_vcpu(i, src_vcpu, src) {
>>> +             src_svm = to_svm(src_vcpu);
>>> +             dst_vcpu = kvm_get_vcpu(dst, i);
>>> +             dst_svm = to_svm(dst_vcpu);
>>> +
>>> +             /*
>>> +              * Transfer VMSA and GHCB state to the destination.  Nullify and
>>> +              * clear source fields as appropriate, the state now belongs to
>>> +              * the destination.
>>> +              */
>>> +             dst_vcpu->vcpu_id = src_vcpu->vcpu_id;
>>> +             memcpy(&dst_svm->sev_es, &src_svm->sev_es,
>>> +                    sizeof(dst_svm->sev_es));
>>> +             dst_svm->vmcb->control.ghcb_gpa =
>>> +                             src_svm->vmcb->control.ghcb_gpa;
>>> +             dst_svm->vmcb->control.vmsa_pa = __pa(dst_svm->sev_es.vmsa);
>>> +             dst_vcpu->arch.guest_state_protected = true;
>>
>> Maybe just add a blank line here to separate the setting and clearing
>> (only if you have to do another version).
>>
>>> +             src_svm->vmcb->control.ghcb_gpa = 0;
>>> +             src_svm->vmcb->control.vmsa_pa = 0;
>>> +             src_vcpu->arch.guest_state_protected = false;
>>
>> In the previous patch you were clearing some of the fields that are now in
>> the vcpu_sev_es_state. Did you want to memset that to zero now?
> 
> Oops, making that an easy memset was one of the pros of the |sev_es|
> refactor. Will fix and add newline in V11.

And totally up to you, but I think you can replace the memcpy() above with 
a direct assignment, if you want:

	dst_svm->sev_es = src_svm->sev_es;

Thanks,
Tom

> 
>>
>> Thanks,
>> Tom
>>
>>> +     }
>>> +     to_kvm_svm(src)->sev_info.es_active = false;
>>> +
>>> +     return 0;
>>> +}
>>> +
