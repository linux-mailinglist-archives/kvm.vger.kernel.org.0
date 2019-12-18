Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A1E12547A
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 22:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfLRVSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 16:18:11 -0500
Received: from mail-co1nam11on2071.outbound.protection.outlook.com ([40.107.220.71]:6073
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725985AbfLRVSL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 16:18:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PDUqSCvkX6XsoGVn0h+OAOznQIdoTZzsSVYPXAZkfOAM5Bd6WnD0NoznHej6PttdgRHiXDZgr5xkV4T5s9yNnnCG1TuaapH6R5VfWHHh/W1llYvIv+PNvLPi9k/BLFGCJGeSNNRAIAOsufrE5Ztop7Br5Wk+9mRiaZWJOvcJ4Afc55A/C9z5V1mtc8vJ8RFDOr/RhkrfXIj2YwM5pUo8DAlwdM31U7GqciX7PfbQCJCupfRnHb3SezcGTh3g1XIXnHGkfWNmqWhgxUiA5dbG53g9/8LcqiRgTAqKU5XCwJr5WQxLeAW5YWwQjTtLJDp9CYjUmXVQ+fnYfzK1xlYtGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eHdkPZIw1g7KHGUzc7ykjDer9z79ueCzfXl8S7FO1Rg=;
 b=ivR+yWIxrLYPN+Qv6T++gIKgqZRv0dqdiQmr67Zmo1/uT9+mTqKEsVGlRoFB1+dK4UBPB0G5WKbyPMLoCLmhclGPH/xIWblVkfMwoD6dcgwRRgZS5nCVBjwISDp33GcwTFFvOi8EF6tq1KqXkJEcFW+oL7P2EAdaN1ct3sp4Xqvi/W74MZwSoTD31R5Ve4Fn2o5zpRDxWtg1D8yhpaaZrKt+yIl2mBh7pN1VT5hNuUZiKcYb8ylKSmacBp8yzhYZjK9ZuJuDTbhjXeScimhK7l4Fr4Wuo2oqBEo0FlM89atrMjafCQsIzO8d7JYjbkofag3fFB95GZA1FB9Kt6cWvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eHdkPZIw1g7KHGUzc7ykjDer9z79ueCzfXl8S7FO1Rg=;
 b=nZ5eTSMj42RHzMwCsq/K3bJA6S7ArEBXSDdcxDg8FQAnVX9Z5BgvLFWVniC1YSVa63vUkqg06VjAXZqZvG+ICOQE40G5Jrdfx13EdN734OjX3cEkrqqWh36+v//fKI9gcz5u93FIujExWKtMNc3dshRktzND7W4Tj2275Wn2Hwc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.71.154) by
 DM6PR12MB2940.namprd12.prod.outlook.com (20.179.71.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Wed, 18 Dec 2019 21:18:08 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270%7]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 21:18:08 +0000
Subject: Re: [PATCH v1 1/2] KVM: x86/mmu: Allow for overriding MMIO SPTE mask
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
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <9ffc1936-dbdc-52c8-bbd4-24c773728452@amd.com>
Date:   Wed, 18 Dec 2019 15:18:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <20191218202702.GF25201@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR07CA0083.namprd07.prod.outlook.com
 (2603:10b6:4:ad::48) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 17425309-12ba-43e2-83f0-08d783ffc746
X-MS-TrafficTypeDiagnostic: DM6PR12MB2940:|DM6PR12MB2940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2940FA09E32048846132B664EC530@DM6PR12MB2940.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0255DF69B9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(199004)(189003)(5660300002)(2616005)(31686004)(66556008)(26005)(86362001)(2906002)(4326008)(66476007)(8676002)(36756003)(81156014)(6486002)(478600001)(6512007)(52116002)(6916009)(54906003)(316002)(81166006)(6506007)(53546011)(31696002)(8936002)(66946007)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2940;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6fP222E/Wt6SxZv1ga95Xle/2j3J43uVyTIdbV6GvVHSGwixvf2Ep5cInmXuJciL4B3+th1TugDHXz4efMQCrlODej6dTp5l6IHu7b71lBBcc2kXZPOafoSRVFQxyaViHLH/LJ0dGibgHTkhtqjGaxF8hQ5olE3HjMEVSu1Xftuh2ecVwWwZs8mukHVT13r3oUQCCgDdUKjBEFBhHFuGlMLsigLUlk9zyWNGb137eHTsqGuVxPkdtqlYfbpq9sJcDz0BXGjy1Zm90wM5IitlyUgzqSyaCebfv/LYYv8eZ6HAhJIsGQDUk7X7U3pMLBA1z+aktoeVq6ElAN5QNyMv0+EUL+JqXHDY80J+yhrvHsfWdENLPhxjBBJyiAMTjccILTXL7tZZuDjhs2T7qNMCgVbgfCNR4S3s2DsEtVkYYHrnVMuPZ1GcJPzTBNBFywjB
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17425309-12ba-43e2-83f0-08d783ffc746
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2019 21:18:08.3898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nVguMUYWMY3QYG+13Ufx2rsU++bPo9mIAgmzhkI73eHIqyU79G77E4PQQxOQzYokdTf2auTO8uXht3dZy7Jyog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2940
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/18/19 2:27 PM, Sean Christopherson wrote:
> On Wed, Dec 18, 2019 at 01:51:23PM -0600, Tom Lendacky wrote:
>> On 12/18/19 1:45 PM, Tom Lendacky wrote:
>>> The KVM MMIO support uses bit 51 as the reserved bit to cause nested page
>>> faults when a guest performs MMIO. The AMD memory encryption support uses
>>> CPUID functions to define the encryption bit position. Given this, KVM
>>> can't assume that bit 51 will be safe all the time.
>>>
>>> Add a callback to return a reserved bit(s) mask that can be used for the
>>> MMIO pagetable entries. The callback is not responsible for setting the
>>> present bit.
>>>
>>> If a callback is registered:
>>>   - any non-zero mask returned is updated with the present bit and used
>>>     as the MMIO SPTE mask.
>>>   - a zero mask returned results in a mask with only bit 51 set (i.e. no
>>>     present bit) as the MMIO SPTE mask, similar to the way 52-bit physical
>>>     addressing is handled.
>>>
>>> If no callback is registered, the current method of setting the MMIO SPTE
>>> mask is used.
>>>
>>> Fixes: 28a1f3ac1d0c ("kvm: x86: Set highest physical address bits in non-present/reserved SPTEs")
>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>> ---
>>>  arch/x86/include/asm/kvm_host.h |  4 ++-
>>>  arch/x86/kvm/mmu/mmu.c          | 54 +++++++++++++++++++++------------
>>>  arch/x86/kvm/x86.c              |  2 +-
>>>  3 files changed, 38 insertions(+), 22 deletions(-)
>>
>> This patch has some extra churn because kvm_x86_ops isn't set yet when the
>> call to kvm_set_mmio_spte_mask() is made. If it's not a problem to move
>> setting kvm_x86_ops just a bit earlier in kvm_arch_init(), some of the
>> churn can be avoided.
> 
> As a completely different alternative, what about handling this purely
> within SVM code by overriding the masks during svm_hardware_setup(),
> similar to how VMX handles EPT's custom masks, e.g.:
> 
> 	/*
> 	 * Override the MMIO masks if memory encryption support is enabled:
> 	 *   The physical addressing width is reduced. The first bit above the
> 	 *   new physical addressing limit will always be reserved.
> 	 */
> 	if (cpuid_eax(0x80000000) >= 0x8000001f) {
> 		rdmsrl(MSR_K8_SYSCFG, msr);
> 		if (msr & MSR_K8_SYSCFG_MEM_ENCRYPT) {
> 			mask = BIT_ULL(boot_cpu_data.x86_phys_bits) | BIT_ULL(0);
> 			kvm_mmu_set_mmio_spte_mask(mask, mask,
> 						   ACC_WRITE_MASK | ACC_USER_MASK);
> 		}
> 	}

Works for me if no one has objections to doing it that way (and will
actually make going into stable much easier).

Thanks,
Tom

> 
