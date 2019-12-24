Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68C5012A3DA
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2019 19:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbfLXSPF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 13:15:05 -0500
Received: from mail-co1nam11on2050.outbound.protection.outlook.com ([40.107.220.50]:45985
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726171AbfLXSPF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 13:15:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NF2JnYD3Ip5rIcSeSho5LQCm/xMuZbhamyXNR8Nlc8KX7TCasRuq9929e8VEf3V9MARTk8eWNefnuSclovxVaq3jxUj4LhdZ32m3VCk4y7RaW5vPBfyjWusNUILfHga3Om33af/8lOXUsX46V91jLnCD853OBnidx8AU6unBrbrMwzxC8d6Tq2WHBH8cgYAkatwRRRr12aWB9SRoeP89scvUGCpt5awqSXoIAQO4LjNJ1dBvHrzoQfTOXQ1Hm2YUK1wP/Z3iJqSV02kMH9MSwYTnFT+bm0Q8M3BflctNSoKz8x3o0Fi9MBtgXrQbJBNmffcFZ0zRwRVF+S2PZWXOXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxbkKClUsngwpxdME4ey4vJaqttoGQblIgxeu/4RwsM=;
 b=mzLUlzKoJmPwDVelKtK52waVMMFq6reyngGuDDi1v3XJaEb72h0NRevcr3NgVpXCI7lPZ0zIcTNqrvz4XWHAzccKgpQ8Pu9Xu4l02iZ7hBcQdMO86ZMz7QQwPYfP7OgsGBRLfyB6So64g23XngD//tbFEI5BrH7kFDOgBaNZ3ES1UofWDPGIMZ8stiIsAGhrvIUbWhksoaq2MLHS0+RVv753yv0QEXlyW+XUb9LiGJrpDVud5OrhN9mXPXKxNEuz0w6hi3Jm8POpcHk9Ge24ZWvrNgvkX/yFfm1z8O/N56eXLuZSfwwj8ISwnjed8LZDEnQ7dJpkfjEB7Dmc73kx5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxbkKClUsngwpxdME4ey4vJaqttoGQblIgxeu/4RwsM=;
 b=bv8tAiiZTc67inkM7aM4/wR3o6oDrSoCSNiGIGUxaxUvJyLH24bP+8T1E4Jg06ixRolDSCcw2kbRQrqaWCiTISOCOsSlWxx9gLadP7bWj+QYfwpsKK9JPSmwvsuElt/fDTqUi4ZOuNlLGgxghzKdIro8vajtt/t1kSYGDEkSNTA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.71.154) by
 DM6PR12MB4138.namprd12.prod.outlook.com (10.141.8.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Tue, 24 Dec 2019 18:14:22 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270%7]) with mapi id 15.20.2559.017; Tue, 24 Dec 2019
 18:14:22 +0000
Subject: Re: [PATCH v1 1/2] KVM: x86/mmu: Allow for overriding MMIO SPTE mask
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1576698347.git.thomas.lendacky@amd.com>
 <10fdb77c9b6795f68137cf4315571ab791ab6feb.1576698347.git.thomas.lendacky@amd.com>
 <f0bc54c8-cea2-e574-6191-5c34d1b504c9@amd.com>
 <20191218202702.GF25201@linux.intel.com>
 <9ffc1936-dbdc-52c8-bbd4-24c773728452@amd.com>
Message-ID: <aba52c8b-3238-b2f7-e770-5669bea6c64e@amd.com>
Date:   Tue, 24 Dec 2019 12:14:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <9ffc1936-dbdc-52c8-bbd4-24c773728452@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0401CA0006.namprd04.prod.outlook.com
 (2603:10b6:803:21::16) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
Received: from [10.236.30.194] (165.204.77.1) by SN4PR0401CA0006.namprd04.prod.outlook.com (2603:10b6:803:21::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Tue, 24 Dec 2019 18:14:21 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6b49e87e-6a5c-42e4-342c-08d7889d19dd
X-MS-TrafficTypeDiagnostic: DM6PR12MB4138:|DM6PR12MB4138:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4138A888EC80437FDFF6E6D9EC290@DM6PR12MB4138.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0261CCEEDF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(136003)(396003)(376002)(199004)(189003)(16576012)(2616005)(81166006)(478600001)(316002)(16526019)(956004)(81156014)(6666004)(2906002)(31686004)(186003)(8936002)(6486002)(54906003)(26005)(31696002)(4326008)(8676002)(66556008)(66476007)(66946007)(86362001)(6916009)(52116002)(53546011)(5660300002)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB4138;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ouEKXJbHaPepu1pWeeJa3hW4DPJGr3GGUOj0I5LEF4ssb5pVnRnDlAWFmmz/QO0/A/YgsNarjiPxR5sBEUc4DF+/LdCw+cpGQAlyeEivrBSrVL65SZYqqTKodliYLMpSuP3DWv7kUgAXgkbDheFextO+pWNplQQIx9G1uIElVTTy9b7rY/GXcHs1wyuDjhgdv2AYz6wvX8WInj0mqAxH3whNgUK1KSI/LT7VzyoV/3b1oIydyH1A8z04zL+T8H05DGQLX105WxF8sa6FIPw20f7YbmFU4QGD2V84sNBnbpVgoip03ZMtOQEPUgD/pmiD3vvVw1bd3TyswDOeE4HLDFRz/qKKisplGEsbyy4PdSMVLGlooCXTavZ8B3cUOdM5NuEVYVCagpJwOoZLOBIlQEOD+GyoNckYdDX6AJOK+UvqIkmLhlKx9rA/bMHAO8Os
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b49e87e-6a5c-42e4-342c-08d7889d19dd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2019 18:14:22.4253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gs7kNZvmH3rGxt1z751MTfNNEP6va2NYlzg51hcwA12oZtanfhBzLT0jCmqHbR53Pjgu+GObLHeiZWQUUtxJrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/18/19 3:18 PM, Tom Lendacky wrote:
> On 12/18/19 2:27 PM, Sean Christopherson wrote:
>> On Wed, Dec 18, 2019 at 01:51:23PM -0600, Tom Lendacky wrote:
>>> On 12/18/19 1:45 PM, Tom Lendacky wrote:
>>>> The KVM MMIO support uses bit 51 as the reserved bit to cause nested page
>>>> faults when a guest performs MMIO. The AMD memory encryption support uses
>>>> CPUID functions to define the encryption bit position. Given this, KVM
>>>> can't assume that bit 51 will be safe all the time.
>>>>
>>>> Add a callback to return a reserved bit(s) mask that can be used for the
>>>> MMIO pagetable entries. The callback is not responsible for setting the
>>>> present bit.
>>>>
>>>> If a callback is registered:
>>>>   - any non-zero mask returned is updated with the present bit and used
>>>>     as the MMIO SPTE mask.
>>>>   - a zero mask returned results in a mask with only bit 51 set (i.e. no
>>>>     present bit) as the MMIO SPTE mask, similar to the way 52-bit physical
>>>>     addressing is handled.
>>>>
>>>> If no callback is registered, the current method of setting the MMIO SPTE
>>>> mask is used.
>>>>
>>>> Fixes: 28a1f3ac1d0c ("kvm: x86: Set highest physical address bits in non-present/reserved SPTEs")
>>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>>> ---
>>>>  arch/x86/include/asm/kvm_host.h |  4 ++-
>>>>  arch/x86/kvm/mmu/mmu.c          | 54 +++++++++++++++++++++------------
>>>>  arch/x86/kvm/x86.c              |  2 +-
>>>>  3 files changed, 38 insertions(+), 22 deletions(-)
>>>
>>> This patch has some extra churn because kvm_x86_ops isn't set yet when the
>>> call to kvm_set_mmio_spte_mask() is made. If it's not a problem to move
>>> setting kvm_x86_ops just a bit earlier in kvm_arch_init(), some of the
>>> churn can be avoided.
>>
>> As a completely different alternative, what about handling this purely
>> within SVM code by overriding the masks during svm_hardware_setup(),
>> similar to how VMX handles EPT's custom masks, e.g.:
>>
>> 	/*
>> 	 * Override the MMIO masks if memory encryption support is enabled:
>> 	 *   The physical addressing width is reduced. The first bit above the
>> 	 *   new physical addressing limit will always be reserved.
>> 	 */
>> 	if (cpuid_eax(0x80000000) >= 0x8000001f) {
>> 		rdmsrl(MSR_K8_SYSCFG, msr);
>> 		if (msr & MSR_K8_SYSCFG_MEM_ENCRYPT) {
>> 			mask = BIT_ULL(boot_cpu_data.x86_phys_bits) | BIT_ULL(0);
>> 			kvm_mmu_set_mmio_spte_mask(mask, mask,
>> 						   ACC_WRITE_MASK | ACC_USER_MASK);
>> 		}
>> 	}
> 
> Works for me if no one has objections to doing it that way (and will
> actually make going into stable much easier).

No objections, so I'll re-submit using Sean's suggested override method.

Thanks,
Tom

> 
> Thanks,
> Tom
> 
>>
