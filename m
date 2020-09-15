Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89AC226B821
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 02:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbgIPAgw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 20:36:52 -0400
Received: from mail-bn8nam11on2089.outbound.protection.outlook.com ([40.107.236.89]:43873
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726570AbgIONZE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 09:25:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MlGfdyXiIQqvVbMwwJPTUHH/a5G0gOEz1toaVTpTK/yI02ILEM6FALF6V2Bt6ycBKF1WMQ4AdYsVrrwjIDiPuAUi+MQwfeEGkgorNMmXPvKKHx1YUqLz5gaJUF3fD7eGhjtjP3zAkTkEwRR/kW+T9Y6cIvcKrSdv9xA/wJf/GgkG3E6oT06xz4s984NfgPd2pjdcCy+prGHDPDcNyp1YlbBKKxsfh7gOJx/17GwukSQK077EqEs4LkWH1R0DjIcmhoRX4utCbKsf9d9HOfL3vNOUx2lXqJ/iGY+UZkQ5pIAzqOCIH39oLeDxe3CWPj7XHRuiOrvg9Z/lvsH7mrZXWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M3wbtfzNibexxFgosqhLQsXvJ+q4ozNos5gC9uYfDLs=;
 b=HvuEcgVfFnfEd81Y2+l989Jxg9Obd8Z/hD9YwAa22mmMaj1dKcp9TjctzpNQ6jH9xbBCPNfsSKRQUI1grr1gYLHxPZBnOC1aTSKi3Djc5oK9s+CfqLu7Vqkwl5xkriVUMzoCdiYn64BzepyZpPRVLxQAZBsU71sQRXEaiY189nwfTR1ygQfiZHtodHv9t7jF2UnRLFtxaR6YjwmPik6cyKk1YqdbL4Bvmt7L3BLZRRuYdCavplZqZpwko1QmD8bXFdGTblCrajTwXNCUzdGbhnILPnAhIEu07zdynMl5BT5urqCyb2scM+0j1su4T23w2fItybI/YK/7dmGxiQKB2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M3wbtfzNibexxFgosqhLQsXvJ+q4ozNos5gC9uYfDLs=;
 b=xCTDpEYk/OOOUf5BdYsmnKZtnUawmyikG1PbegSRCKmRJeGyWl8SPQ7AClk4iD9vSJXubkmdygB+O9vKxfOaTDZPno7Ax9x1mjJh1JHbJyx2gG3PiuToyLBABECMk3fgMCS60JS0f0YHHMOzGUc/f+ZQuhnWvPVPfub9TeLZC98=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0023.namprd12.prod.outlook.com (2603:10b6:910:1f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.17; Tue, 15 Sep
 2020 13:24:24 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443%10]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 13:24:24 +0000
Subject: Re: [RFC PATCH 05/35] KVM: SVM: Add initial support for SEV-ES GHCB
 access to KVM
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <9e52807342691ff0d4b116af6e147021c61a2d71.1600114548.git.thomas.lendacky@amd.com>
 <20200914205801.GA7084@sjchrist-ice>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <ba417215-530d-98df-5ceb-35b10ee09243@amd.com>
Date:   Tue, 15 Sep 2020 08:24:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200914205801.GA7084@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0055.prod.exchangelabs.com (2603:10b6:800::23) To
 CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN2PR01CA0055.prod.exchangelabs.com (2603:10b6:800::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.18 via Frontend Transport; Tue, 15 Sep 2020 13:24:23 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bb240a8e-fe44-4bcb-6a3c-08d8597aa9db
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0023:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0023CFBFC64075061B25BC36EC200@CY4PR1201MB0023.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Hx4dSkCz7RIMHPWwgA5c8noZeL+B91FueIb6miWov3qAn3cMJZ7Z7kxMVcxJHdpdfAfhW2hrfILKm6A5PKJ7CoW2abIRw21Sv3czAMEnP988sgm5lnA9WMB6naLdH7wOoJozDOINxW86Z9SLBx7paznyZ0gMNisyR3jzlyRIj8oM9BGuHa4Y0VuKLFKfQzjSJBsqrcNSiebKiIvW+L4YWFf30aQu4zOSBhN4eK17ObH6pJsZ+xkNiARtC2FvGFmI48haM6RLPKdIuyYAZH95Ji4VYwOnDnQ2ENa6SM3oTNBzmnPCQO29NYn6HkG7QoCio3GXbM95pQYOfaL5gD/swryiw30/cwoKE+om0UmtneLzpB2kJbpmsNFKpmtLRnlgjNpZJKrIXXhoCDQXqeNjko7ydIE0ToN/qR+8dvDQ3DQ/l2P9xABfnX8cepcfcmibUTVZ2aP0gDmn8LC0qiaWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(478600001)(956004)(66556008)(66946007)(31696002)(86362001)(45080400002)(6486002)(36756003)(4326008)(66476007)(16526019)(966005)(26005)(5660300002)(30864003)(186003)(7416002)(52116002)(8676002)(2616005)(2906002)(31686004)(6916009)(8936002)(54906003)(53546011)(16576012)(316002)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uIOVftBW76ZqMyug47jqg8LHCsCkkK8Cew7CURZSVoHMyA6vFXt3TiHAFAfvuOghhMF35cnoFDiJXbn4YsqUBdOWrkievVyYljdH+dqgHDYNZR2tOkcUKuYnzcQg9KMY6ARowD/50tNUoA+vJR2I691AxQW+KuGel5GTlGripECEPFIFlMjoP0apXiv1gvcBud3zIfm8pZIcdzmnw3tsrD7OLpikH6EQetlH3pe+hNxEb6Gd2zsDtO4up52iuRcZ3f5BVK3YRULftwKZ1GbM6+vckoCND8oQoJJdwehubxAsQJ/4teVPtMMVaPvVmGfflyb+Dg/CXovZcvY/IpnO6jQNBR30zNEPblEPWzYNFLo4EGQRYQEd8MDU2I+0Jn01odcII1Ccd7fQV6zLbdR6AbOLhrLFqWmxFU5vBGw6TcV4EPbikrBYhNumD23wZMFFYFFQ4CwcBY3Aj54IYDsvUK21h9jPXpkfzYGyhYuZsCmcmtNRv1H81QwD9jQXMzmSB1KeVWbvbHyD3f6AWM3oPjbb9zHfxJ4Sx8nrji7s/XLBywUTFaleJpNY4KDwmOmbw5qnjijjSj14Quvr+Bflfm3E6sHkZ4Bk44F6GKIymVUu6ER8U3TUkMenXXWCV7BRdnThTC4bWgHD2xlJctiJxA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb240a8e-fe44-4bcb-6a3c-08d8597aa9db
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 13:24:24.7294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 10/DdafHvRUw+r5ZKpPaiq6yz2YJaAo0Jt5FNEIml7M94Jo+4qdLwFqo0WxSVvmDiZvk8JrwXgqWw+pTRqYjlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0023
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/14/20 3:58 PM, Sean Christopherson wrote:
> On Mon, Sep 14, 2020 at 03:15:19PM -0500, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> Provide initial support for accessing the GHCB when needing to access
>> registers for an SEV-ES guest. The support consists of:
>>
>>   - Accessing the GHCB instead of the VMSA when reading and writing
>>     guest registers (after the VMSA has been encrypted).
>>   - Creating register access override functions for reading and writing
>>     guest registers from the common KVM support.
>>   - Allocating pages for the VMSA and GHCB when creating each vCPU
>>     - The VMSA page holds the encrypted VMSA for the vCPU
>>     - The GHCB page is used to hold a copy of the guest GHCB during
>>       VMGEXIT processing.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h  |   7 ++
>>  arch/x86/include/asm/msr-index.h |   1 +
>>  arch/x86/kvm/kvm_cache_regs.h    |  30 +++++--
>>  arch/x86/kvm/svm/svm.c           | 138 ++++++++++++++++++++++++++++++-
>>  arch/x86/kvm/svm/svm.h           |  65 ++++++++++++++-
>>  5 files changed, 230 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 5303dbc5c9bc..c900992701d6 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -788,6 +788,9 @@ struct kvm_vcpu_arch {
>>  
>>  	/* AMD MSRC001_0015 Hardware Configuration */
>>  	u64 msr_hwcr;
>> +
>> +	/* SEV-ES support */
>> +	bool vmsa_encrypted;
> 
> 
> Peeking a little into the future, Intel needs a very similar flag for TDX[*].
> At a glance throughout the series,, I don't see anything that is super SEV-ES
> specific, so I think we could do s/vmsa_encrypted/guest_state_protected (or
> something along those lines).

Yup, I can do that.

> 
> [*] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fsoftware.intel.com%2Fcontent%2Fwww%2Fus%2Fen%2Fdevelop%2Farticles%2Fintel-trust-domain-extensions.html&amp;data=02%7C01%7Cthomas.lendacky%40amd.com%7Cd5fcf35d079042b095b308d858f0e12f%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637357138885657516&amp;sdata=aSclP%2BxSatvG9GOMEtWpXfdUxrLOlVcCXJNH41OdGms%3D&amp;reserved=0
> 
>>  };
>>  
>>  struct kvm_lpage_info {
>> @@ -1227,6 +1230,10 @@ struct kvm_x86_ops {
>>  	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
>>  
>>  	void (*migrate_timers)(struct kvm_vcpu *vcpu);
>> +
>> +	void (*reg_read_override)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
>> +	void (*reg_write_override)(struct kvm_vcpu *vcpu, enum kvm_reg reg,
>> +				   unsigned long val);
>>  };
>>  
>>  struct kvm_x86_nested_ops {
>> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
>> index 249a4147c4b2..16f5b20bb099 100644
>> --- a/arch/x86/include/asm/msr-index.h
>> +++ b/arch/x86/include/asm/msr-index.h
>> @@ -466,6 +466,7 @@
>>  #define MSR_AMD64_IBSBRTARGET		0xc001103b
>>  #define MSR_AMD64_IBSOPDATA4		0xc001103d
>>  #define MSR_AMD64_IBS_REG_COUNT_MAX	8 /* includes MSR_AMD64_IBSBRTARGET */
>> +#define MSR_AMD64_VM_PAGE_FLUSH		0xc001011e
>>  #define MSR_AMD64_SEV_ES_GHCB		0xc0010130
>>  #define MSR_AMD64_SEV			0xc0010131
>>  #define MSR_AMD64_SEV_ENABLED_BIT	0
>> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
>> index cfe83d4ae625..e87eb90999d5 100644
>> --- a/arch/x86/kvm/kvm_cache_regs.h
>> +++ b/arch/x86/kvm/kvm_cache_regs.h
>> @@ -9,15 +9,21 @@
>>  	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
>>  	 | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_PGE | X86_CR4_TSD)
>>  
>> -#define BUILD_KVM_GPR_ACCESSORS(lname, uname)				      \
>> -static __always_inline unsigned long kvm_##lname##_read(struct kvm_vcpu *vcpu)\
>> -{									      \
>> -	return vcpu->arch.regs[VCPU_REGS_##uname];			      \
>> -}									      \
>> -static __always_inline void kvm_##lname##_write(struct kvm_vcpu *vcpu,	      \
>> -						unsigned long val)	      \
>> -{									      \
>> -	vcpu->arch.regs[VCPU_REGS_##uname] = val;			      \
>> +#define BUILD_KVM_GPR_ACCESSORS(lname, uname)					\
>> +static __always_inline unsigned long kvm_##lname##_read(struct kvm_vcpu *vcpu)	\
>> +{										\
>> +	if (kvm_x86_ops.reg_read_override)					\
>> +		kvm_x86_ops.reg_read_override(vcpu, VCPU_REGS_##uname);		\
>> +										\
>> +	return vcpu->arch.regs[VCPU_REGS_##uname];				\
>> +}										\
>> +static __always_inline void kvm_##lname##_write(struct kvm_vcpu *vcpu,		\
>> +						unsigned long val)		\
>> +{										\
>> +	if (kvm_x86_ops.reg_write_override)					\
>> +		kvm_x86_ops.reg_write_override(vcpu, VCPU_REGS_##uname, val);	\
>> +										\
>> +	vcpu->arch.regs[VCPU_REGS_##uname] = val;				\
>>  }
>>  BUILD_KVM_GPR_ACCESSORS(rax, RAX)
>>  BUILD_KVM_GPR_ACCESSORS(rbx, RBX)
>> @@ -67,6 +73,9 @@ static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu, int reg)
>>  	if (WARN_ON_ONCE((unsigned int)reg >= NR_VCPU_REGS))
>>  		return 0;
>>  
>> +	if (kvm_x86_ops.reg_read_override)
>> +		kvm_x86_ops.reg_read_override(vcpu, reg);
>> +
>>  	if (!kvm_register_is_available(vcpu, reg))
>>  		kvm_x86_ops.cache_reg(vcpu, reg);
>>  
>> @@ -79,6 +88,9 @@ static inline void kvm_register_write(struct kvm_vcpu *vcpu, int reg,
>>  	if (WARN_ON_ONCE((unsigned int)reg >= NR_VCPU_REGS))
>>  		return;
>>  
>> +	if (kvm_x86_ops.reg_write_override)
>> +		kvm_x86_ops.reg_write_override(vcpu, reg, val);
> 
> 
> There has to be a more optimal approach for propagating registers between
> vcpu->arch.regs and the VMSA than adding a per-GPR hook.  Why not simply
> copy the entire set of registers to/from the VMSA on every exit and entry?
> AFAICT, valid_bits is only used in the read path, and KVM doesn't do anything
> sophistated when it hits a !valid_bits reads.

That would probably be ok. And actually, the code might be able to just
check the GHCB valid bitmap for valid regs on exit, copy them and then
clear the bitmap. The write code could check if vmsa_encrypted is set and
then set a "valid" bit for the reg that could be used to set regs on entry.

I'm not sure if turning kvm_vcpu_arch.regs into a struct and adding a
valid bit would be overkill or not.

> 
> If unconditional copying has a noticeable impact on e.g. IRQ handling
> latency, the save/restore could be limited to exits that may access guest
> state, which is presumably a well-defined, limited list.  Such exits are
> basically a slow path anyways, especially if the guest kernel is taking a
> #VC on the front eend.  Adding hooks to KVM_{GET,SET}_REGS to ensure userspace
> accesses are handled correcty would be trivial.
> 
> Adding per-GPR hooks will bloat common KVM for both VMX and SVM, and will
> likely have a noticeable performance impact on SVM due to adding 60-70 cycles
> to every GPR access for the retpoline.  Static calls will take the sting out
> of that, but it's still a lot of code bytes, that IMO, are completely
> unecessary.

Yes, definitely something I need to look into more.

> 
>> +
>>  	vcpu->arch.regs[reg] = val;
>>  	kvm_register_mark_dirty(vcpu, reg);
>>  }
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 779c167e42cc..d1f52211627a 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -1175,6 +1175,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>>  	struct page *msrpm_pages;
>>  	struct page *hsave_page;
>>  	struct page *nested_msrpm_pages;
>> +	struct page *vmsa_page = NULL;
>>  	int err;
>>  
>>  	BUILD_BUG_ON(offsetof(struct vcpu_svm, vcpu) != 0);
>> @@ -1197,9 +1198,19 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>>  	if (!hsave_page)
>>  		goto free_page3;
>>  
>> +	if (sev_es_guest(svm->vcpu.kvm)) {
>> +		/*
>> +		 * SEV-ES guests require a separate VMSA page used to contain
>> +		 * the encrypted register state of the guest.
>> +		 */
>> +		vmsa_page = alloc_page(GFP_KERNEL);
>> +		if (!vmsa_page)
>> +			goto free_page4;
>> +	}
>> +
>>  	err = avic_init_vcpu(svm);
>>  	if (err)
>> -		goto free_page4;
>> +		goto free_page5;
>>  
>>  	/* We initialize this flag to true to make sure that the is_running
>>  	 * bit would be set the first time the vcpu is loaded.
>> @@ -1219,6 +1230,12 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>>  	svm->vmcb = page_address(page);
>>  	clear_page(svm->vmcb);
>>  	svm->vmcb_pa = __sme_set(page_to_pfn(page) << PAGE_SHIFT);
>> +
>> +	if (vmsa_page) {
>> +		svm->vmsa = page_address(vmsa_page);
>> +		clear_page(svm->vmsa);
>> +	}
>> +
>>  	svm->asid_generation = 0;
>>  	init_vmcb(svm);
>>  
>> @@ -1227,6 +1244,9 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>>  
>>  	return 0;
>>  
>> +free_page5:
>> +	if (vmsa_page)
>> +		__free_page(vmsa_page);
>>  free_page4:
>>  	__free_page(hsave_page);
>>  free_page3:
>> @@ -1258,6 +1278,26 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
>>  	 */
>>  	svm_clear_current_vmcb(svm->vmcb);
>>  
>> +	if (sev_es_guest(vcpu->kvm)) {
>> +		struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
>> +
>> +		if (vcpu->arch.vmsa_encrypted) {
>> +			u64 page_to_flush;
>> +
>> +			/*
>> +			 * The VMSA page was used by hardware to hold guest
>> +			 * encrypted state, be sure to flush it before returning
>> +			 * it to the system. This is done using the VM Page
>> +			 * Flush MSR (which takes the page virtual address and
>> +			 * guest ASID).
>> +			 */
>> +			page_to_flush = (u64)svm->vmsa | sev->asid;
>> +			wrmsrl(MSR_AMD64_VM_PAGE_FLUSH, page_to_flush);
>> +		}
>> +
>> +		__free_page(virt_to_page(svm->vmsa));
>> +	}
>> +
>>  	__free_page(pfn_to_page(__sme_clr(svm->vmcb_pa) >> PAGE_SHIFT));
>>  	__free_pages(virt_to_page(svm->msrpm), MSRPM_ALLOC_ORDER);
>>  	__free_page(virt_to_page(svm->nested.hsave));
>> @@ -4012,6 +4052,99 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
>>  		   (svm->vmcb->control.intercept & (1ULL << INTERCEPT_INIT));
>>  }
>>  
>> +/*
>> + * These return values represent the offset in quad words within the VM save
>> + * area. This allows them to be accessed by casting the save area to a u64
>> + * array.
>> + */
>> +#define VMSA_REG_ENTRY(_field)	 (offsetof(struct vmcb_save_area, _field) / sizeof(u64))
>> +#define VMSA_REG_UNDEF		 VMSA_REG_ENTRY(valid_bitmap)
>> +static inline unsigned int vcpu_to_vmsa_entry(enum kvm_reg reg)
>> +{
>> +	switch (reg) {
>> +	case VCPU_REGS_RAX:	return VMSA_REG_ENTRY(rax);
>> +	case VCPU_REGS_RBX:	return VMSA_REG_ENTRY(rbx);
>> +	case VCPU_REGS_RCX:	return VMSA_REG_ENTRY(rcx);
>> +	case VCPU_REGS_RDX:	return VMSA_REG_ENTRY(rdx);
>> +	case VCPU_REGS_RSP:	return VMSA_REG_ENTRY(rsp);
>> +	case VCPU_REGS_RBP:	return VMSA_REG_ENTRY(rbp);
>> +	case VCPU_REGS_RSI:	return VMSA_REG_ENTRY(rsi);
>> +	case VCPU_REGS_RDI:	return VMSA_REG_ENTRY(rdi);
>> +#ifdef CONFIG_X86_64
>> +	case VCPU_REGS_R8:	return VMSA_REG_ENTRY(r8);
>> +	case VCPU_REGS_R9:	return VMSA_REG_ENTRY(r9);
>> +	case VCPU_REGS_R10:	return VMSA_REG_ENTRY(r10);
>> +	case VCPU_REGS_R11:	return VMSA_REG_ENTRY(r11);
>> +	case VCPU_REGS_R12:	return VMSA_REG_ENTRY(r12);
>> +	case VCPU_REGS_R13:	return VMSA_REG_ENTRY(r13);
>> +	case VCPU_REGS_R14:	return VMSA_REG_ENTRY(r14);
>> +	case VCPU_REGS_R15:	return VMSA_REG_ENTRY(r15);
>> +#endif
>> +	case VCPU_REGS_RIP:	return VMSA_REG_ENTRY(rip);
>> +	default:
>> +		WARN_ONCE(1, "unsupported VCPU to VMSA register conversion\n");
>> +		return VMSA_REG_UNDEF;
>> +	}
>> +}
>> +
>> +/* For SEV-ES guests, populate the vCPU register from the appropriate VMSA/GHCB */
>> +static void svm_reg_read_override(struct kvm_vcpu *vcpu, enum kvm_reg reg)
>> +{
>> +	struct vmcb_save_area *vmsa;
>> +	struct vcpu_svm *svm;
>> +	unsigned int entry;
>> +	unsigned long val;
>> +	u64 *vmsa_reg;
>> +
>> +	if (!sev_es_guest(vcpu->kvm))
>> +		return;
>> +
>> +	entry = vcpu_to_vmsa_entry(reg);
>> +	if (entry == VMSA_REG_UNDEF)
>> +		return;
>> +
>> +	svm = to_svm(vcpu);
>> +	vmsa = get_vmsa(svm);
>> +	vmsa_reg = (u64 *)vmsa;
>> +	val = (unsigned long)vmsa_reg[entry];
>> +
>> +	/* If a GHCB is mapped, check the bitmap of valid entries */
>> +	if (svm->ghcb) {
>> +		if (!test_bit(entry, (unsigned long *)vmsa->valid_bitmap))
>> +			val = 0;
> 
> Is KVM relying on this being 0?  Would it make sense to stuff something like
> 0xaaaa... or 0xdeadbeefdeadbeef so that consumption of bogus data is more
> noticeable?

No, KVM isn't relying on this being 0. I thought about using something
other than 0 here, but settled on just using 0. I'm open to changing that,
though. I'm not sure if there's an easy way to short-circuit the intercept
and respond back with an error at this point, that would be optimal.

> 
>> +	}
>> +
>> +	vcpu->arch.regs[reg] = val;
>> +}
>> +
>> +/* For SEV-ES guests, set the vCPU register in the appropriate VMSA */
>> +static void svm_reg_write_override(struct kvm_vcpu *vcpu, enum kvm_reg reg,
>> +				   unsigned long val)
>> +{
>> +	struct vmcb_save_area *vmsa;
>> +	struct vcpu_svm *svm;
>> +	unsigned int entry;
>> +	u64 *vmsa_reg;
>> +
>> +	entry = vcpu_to_vmsa_entry(reg);
>> +	if (entry == VMSA_REG_UNDEF)
>> +		return;
>> +
>> +	svm = to_svm(vcpu);
>> +	vmsa = get_vmsa(svm);
>> +	vmsa_reg = (u64 *)vmsa;
>> +
>> +	/* If a GHCB is mapped, set the bit to indicate a valid entry */
>> +	if (svm->ghcb) {
>> +		unsigned int index = entry / 8;
>> +		unsigned int shift = entry % 8;
>> +
>> +		vmsa->valid_bitmap[index] |= BIT(shift);
>> +	}
>> +
>> +	vmsa_reg[entry] = val;
>> +}
>> +
>>  static void svm_vm_destroy(struct kvm *kvm)
>>  {
>>  	avic_vm_destroy(kvm);
>> @@ -4150,6 +4283,9 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>>  	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
>>  
>>  	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
>> +
>> +	.reg_read_override = svm_reg_read_override,
>> +	.reg_write_override = svm_reg_write_override,
>>  };
>>  
>>  static struct kvm_x86_init_ops svm_init_ops __initdata = {
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index f42ba9d158df..ff587536f571 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -159,6 +159,10 @@ struct vcpu_svm {
>>  	 */
>>  	struct list_head ir_list;
>>  	spinlock_t ir_list_lock;
>> +
>> +	/* SEV-ES support */
>> +	struct vmcb_save_area *vmsa;
>> +	struct ghcb *ghcb;
>>  };
>>  
>>  struct svm_cpu_data {
>> @@ -509,9 +513,34 @@ void sev_hardware_teardown(void);
>>  
>>  static inline struct vmcb_save_area *get_vmsa(struct vcpu_svm *svm)
>>  {
>> -	return &svm->vmcb->save;
>> +	struct vmcb_save_area *vmsa;
>> +
>> +	if (sev_es_guest(svm->vcpu.kvm)) {
>> +		/*
>> +		 * Before LAUNCH_UPDATE_VMSA, use the actual SEV-ES save area
>> +		 * to construct the initial state.  Afterwards, use the mapped
>> +		 * GHCB in a VMGEXIT or the traditional save area as a scratch
>> +		 * area when outside of a VMGEXIT.
>> +		 */
>> +		if (svm->vcpu.arch.vmsa_encrypted) {
>> +			if (svm->ghcb)
>> +				vmsa = &svm->ghcb->save;
>> +			else
>> +				vmsa = &svm->vmcb->save;
>> +		} else {
>> +			vmsa = svm->vmsa;
>> +		}
> 
> Not sure if it's actually better, but this whole thing could be:
> 
> 	if (!sev_es_guest(svm->vcpu.kvm))
> 		return &svm->vmcb->save;
> 
> 	if (!svm->vcpu.arch.vmsa_encrypted)
> 		return svm->vmsa;
> 
> 	return svm->ghcb ? &svm->ghcb->save : &svm->vmcb->save;
> 

It does look cleaner.

> 
>> +	} else {
>> +		vmsa = &svm->vmcb->save;
>> +	}
>> +
>> +	return vmsa;
>>  }
>>  
>> +#define SEV_ES_SET_VALID(_vmsa, _field)					\
>> +	__set_bit(GHCB_BITMAP_IDX(_field),				\
>> +		  (unsigned long *)(_vmsa)->valid_bitmap)
>> +
>>  #define DEFINE_VMSA_SEGMENT_ENTRY(_field, _entry, _size)		\
>>  	static inline _size						\
>>  	svm_##_field##_read_##_entry(struct vcpu_svm *svm)		\
>> @@ -528,6 +557,9 @@ static inline struct vmcb_save_area *get_vmsa(struct vcpu_svm *svm)
>>  		struct vmcb_save_area *vmsa = get_vmsa(svm);		\
>>  									\
>>  		vmsa->_field._entry = value;				\
>> +		if (svm->vcpu.arch.vmsa_encrypted) {			\
> 
> Pretty sure braces are unnecessary on all these.

Yup, I can get rid of them.

Thanks,
Tom

> 
>> +			SEV_ES_SET_VALID(vmsa, _field);			\
>> +		}							\
>>  	}								\
>>  
>>  #define DEFINE_VMSA_SEGMENT_ACCESSOR(_field)				\
>> @@ -551,6 +583,9 @@ static inline struct vmcb_save_area *get_vmsa(struct vcpu_svm *svm)
>>  		struct vmcb_save_area *vmsa = get_vmsa(svm);		\
>>  									\
>>  		vmsa->_field = *seg;					\
>> +		if (svm->vcpu.arch.vmsa_encrypted) {			\
>> +			SEV_ES_SET_VALID(vmsa, _field);			\
>> +		}							\
>>  	}
>>  
>>  DEFINE_VMSA_SEGMENT_ACCESSOR(cs)
>> @@ -579,6 +614,9 @@ DEFINE_VMSA_SEGMENT_ACCESSOR(tr)
>>  		struct vmcb_save_area *vmsa = get_vmsa(svm);		\
>>  									\
>>  		vmsa->_field = value;					\
>> +		if (svm->vcpu.arch.vmsa_encrypted) {			\
>> +			SEV_ES_SET_VALID(vmsa, _field);			\
>> +		}							\
>>  	}								\
>>  									\
>>  	static inline void						\
>> @@ -587,6 +625,9 @@ DEFINE_VMSA_SEGMENT_ACCESSOR(tr)
>>  		struct vmcb_save_area *vmsa = get_vmsa(svm);		\
>>  									\
>>  		vmsa->_field &= value;					\
>> +		if (svm->vcpu.arch.vmsa_encrypted) {			\
>> +			SEV_ES_SET_VALID(vmsa, _field);			\
>> +		}							\
>>  	}								\
>>  									\
>>  	static inline void						\
>> @@ -595,6 +636,9 @@ DEFINE_VMSA_SEGMENT_ACCESSOR(tr)
>>  		struct vmcb_save_area *vmsa = get_vmsa(svm);		\
>>  									\
>>  		vmsa->_field |= value;					\
>> +		if (svm->vcpu.arch.vmsa_encrypted) {			\
>> +			SEV_ES_SET_VALID(vmsa, _field);			\
>> +		}							\
