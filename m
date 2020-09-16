Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4BB26C62F
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 19:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgIPRgX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 13:36:23 -0400
Received: from mail-eopbgr700050.outbound.protection.outlook.com ([40.107.70.50]:57665
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727010AbgIPRfn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 13:35:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YtPCcmzD2Ar+09rhxf5ehg2XRAD7b2PaeIFrGNh5vcoV35t3j1tUK3miK5D1C1JIvFtFsolQI5nDBlofhVm+IRkCi/H+YC1Z9vs01KJTj/edW6CeCXx9qMB4O2Kq/ARMoMAKuNYYmXSuBdu1CGoAm1I9HcO0PJQIloO8x35kWwr8IKoIOVMfaVXI0uHrxZpgWyy40btpYBuDZzFs5S2mx9kZnxmy71ovZd3efx9q5R34rXaveuRV6qNl5POgnsyQIGjpVFV8t/YynFDE5C34rrtrrpokNEJOL0vwk34QofJdxJYexQkX+zwIBNWhwbwSqODI7H27lFLx/34wlpLp3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5FKX+2ak1zjWTjQu0HUTm+jyXoBwNhJXBcXJMgHble8=;
 b=LkF47r72DM/WvvKmFBFWB68O/uVkGZBI8LCdrQMn38UcPxlhkRAdxer3USI0pl7c/mTMpHtl6VWMzACnGge0lPUKClM6/d16L16kJQl1hXIHqg4F9DhxqGlS7jBVVCdEG6HnGqDD+Ir7N0geuHDMcr1GLVUycS4QHhiqwoAUP5UqHietB+oFiQygcnh1ZhGBF3oLWpbZ8yH0N+KkzFc3oCY8U1UJq6RlI7ISwwW3h+FOhN9My5GYUqS9F48bcSzUlBRQ6zgmZ12q1YMz+lj2Z1Qe578uLAAo2pO2AAhgervwBM4hQ0qtz94j3bXvcYbActqI2Ww5qfp7LxXe3GbIMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5FKX+2ak1zjWTjQu0HUTm+jyXoBwNhJXBcXJMgHble8=;
 b=iGzhAxNMAzu5idtbapANwYm7Ec4n7yYP4zdjc06hC8D6UB+UcMDPCyBG1bm6R+PPYn0ixIdoVZVLltHUKs0o7+RRwY/aTmY0pvuLOIJcG9sUR/8LUVQAHlh+qityorc+pdbLkUPSrE88QWdOBnZqn9m+uz+wjH0ZszL7sdISX64=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4075.namprd12.prod.outlook.com (2603:10b6:5:21d::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3391.14; Wed, 16 Sep 2020 14:54:21 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.011; Wed, 16 Sep 2020
 14:54:21 +0000
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
 <ba417215-530d-98df-5ceb-35b10ee09243@amd.com>
 <20200915162836.GA8420@sjchrist-ice>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <897433e3-cfcb-43c8-821c-0a854f874ccf@amd.com>
Date:   Wed, 16 Sep 2020 09:54:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200915162836.GA8420@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:805:de::35) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN6PR05CA0022.namprd05.prod.outlook.com (2603:10b6:805:de::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.9 via Frontend Transport; Wed, 16 Sep 2020 14:54:20 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e403fb50-71f1-472b-da2b-08d85a506538
X-MS-TrafficTypeDiagnostic: DM6PR12MB4075:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4075B6476B9134508474F81DEC210@DM6PR12MB4075.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3FJpZlNfysoJS/AOEpHxfvmlE/Bbo3am4YERcd6ZzQSpnsWMBler2V14OknVTm7+6mDiUVPGoBmZRKorMzFvdLexlP+26h0s5a/gzCmt4hfSX4kxgdKDIl94wojFWOHLbl4kj67uMMkjVPlR5WWD68ZEqid5snvx9ba4jPxo0LblvozTnCGSi2QHfPOs11xnqJHDQf5vdVlTVaT14DwgDlLevLVB8TwqxMZIYQkxbwsmOUah73YsJUcgslEd5lrQN2gVsNnM+RQiIcHJFnaj/pmqV48Ahg8fYuvls+ylhWkFS3AMlNFHtczwNtrXp145I7AkiOD8JFsclldPdd88dDjozx5M50xVJAyFNlT6OJ3dcv4Y6KZnONZG/WF4M0R2i5hzhpeXjreZ3+WhX6tdk/K1SYTjx2VAB8T1/EjTQON2ix/L50Z11+c+TlSVzoLAui8Z1p2MWlXiROQziG6Zkbi5Bs2ezOmy31c++pz1IgJlPftTYwq/eB0YRVY5BJs5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(36756003)(16576012)(956004)(2616005)(86362001)(54906003)(7416002)(16526019)(6486002)(186003)(5660300002)(478600001)(83380400001)(31686004)(66946007)(66476007)(66556008)(4326008)(8676002)(6916009)(53546011)(966005)(2906002)(316002)(52116002)(31696002)(8936002)(26005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: n2SQGt0Ckh5X5IOSGPKv5kdJAhGpOyGYNy6Yy0PLEpRCTK/ezUXM27FQfF01r/rqaM7nP2Sjr6EAKZxa/nLj0jlidfiWmIHM/QJp+WcQ2jfcSwjgBaLIhSvcSFPozjQ7ePYnAVxcOBVstQRscABTyzehWarv6lFaz9FQX9rp+Hsq8y5yqtsCasC1vllOCfujokYgmGxlC+jCeZckhIBNS28HjvW2I29iWQQxJGVwZOgNwO0k+0ZpiyvMSdid+vzAJ2+UXJXKQApZnYGGsLa3AJ0AQWs4M7chOE6F/lVOKDPlHvMgAAho5WcwIVrW0CPZ+0jkQhCTzI8FrgajIhi5ZDmy8xKTMaGemhy+oq8PNargyDD/UfduKnJX2X4Lv1B1I0tbdW9jUBFSy9ZyePprpteJN/9H1PyRTRHmIX5fNRa1LyJzu/ykk1fatAKWGu47i0vv4/shjdWmyOi0GxiqEs0xBSV9BnKXs495sBRk4alJaLPjBrbjOh1n4QS1K5DdWdg76OkWAY2upprjwOgz3WT0JaEEXQVKK12Oms4iPrYFT/h84yqRnGUHKGW0wZeWiknYKfsk//bjFSMH3ZBad3Pv0Qe+WfIu0Sjgr8Bn5J716QMhGmgxpGLoQNVOsuxIKFkna8fHdnjVAlzg0gPodA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e403fb50-71f1-472b-da2b-08d85a506538
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 14:54:21.7492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KCCaIM/cfapLcZF/tzvXXEE1OdYot+w+dca0xsJ7ynScP83+ObXXGC0q+Ve2eQjY2SHyRiB3fXHy4nkmbhcW1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4075
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/15/20 11:28 AM, Sean Christopherson wrote:
> On Tue, Sep 15, 2020 at 08:24:22AM -0500, Tom Lendacky wrote:
>> On 9/14/20 3:58 PM, Sean Christopherson wrote:
>>>> @@ -79,6 +88,9 @@ static inline void kvm_register_write(struct kvm_vcpu *vcpu, int reg,
>>>>  	if (WARN_ON_ONCE((unsigned int)reg >= NR_VCPU_REGS))
>>>>  		return;
>>>>  
>>>> +	if (kvm_x86_ops.reg_write_override)
>>>> +		kvm_x86_ops.reg_write_override(vcpu, reg, val);
>>>
>>>
>>> There has to be a more optimal approach for propagating registers between
>>> vcpu->arch.regs and the VMSA than adding a per-GPR hook.  Why not simply
>>> copy the entire set of registers to/from the VMSA on every exit and entry?
>>> AFAICT, valid_bits is only used in the read path, and KVM doesn't do anything
>>> sophistated when it hits a !valid_bits reads.
>>
>> That would probably be ok. And actually, the code might be able to just
>> check the GHCB valid bitmap for valid regs on exit, copy them and then
>> clear the bitmap. The write code could check if vmsa_encrypted is set and
>> then set a "valid" bit for the reg that could be used to set regs on entry.
>>
>> I'm not sure if turning kvm_vcpu_arch.regs into a struct and adding a
>> valid bit would be overkill or not.
> 
> KVM already has space in regs_avail and regs_dirty for GPRs, they're just not
> used by the get/set helpers because they're always loaded/stored for both SVM
> and VMX.
> 
> I assume nothing will break if KVM "writes" random GPRs in the VMSA?  I can't
> see how the guest would achieve any level of security if it wantonly consumes
> GPRs, i.e. it's the guest's responsibility to consume only the relevant GPRs.

Right, the guest should only read the registers that it is expecting to be
provided by the hypervisor as set forth in the GHCB spec. It shouldn't
load any other registers that the hypervisor provides. The Linux SEV-ES
guest support follows this model and will only load the registers that are
specified via the GHCB spec for a particular NAE event, ignoring anything
else provided.

> 
> If that holds true, than avoiding the copying isn't functionally necessary, and
> is really just a performance optimization.  One potentially crazy idea would be
> to change vcpu->arch.regs to be a pointer (defaults a __regs array), and then
> have SEV-ES switch it to point directly at the VMSA array (I think the layout
> is identical for x86-64?).

That would be nice, but it isn't quite laid out like that. Before SEV-ES
support, RAX and RSP were the only GPRs saved. With the arrival of SEV-ES,
the remaining registers were added to the VMSA, but a number of bytes
after RAX and RSP. So right now, there are reserved areas where RAX and
RSP would have been at the new register block in the VMSA (see offset
0x300 in the VMSA layout of the APM volume 2,
https://www.amd.com/system/files/TechDocs/24593.pdf).

I might be able to move the RAX and RSP values before the VMSA is
encrypted (or the GHCB returned), assuming those fields would stay
reserved, but I don't think that can be guaranteed.

Let me see if I can put something together using regs_avail and regs_dirty.

> 
>>>> @@ -4012,6 +4052,99 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
>>>>  		   (svm->vmcb->control.intercept & (1ULL << INTERCEPT_INIT));
>>>>  }
>>>>  
>>>> +/*
>>>> + * These return values represent the offset in quad words within the VM save
>>>> + * area. This allows them to be accessed by casting the save area to a u64
>>>> + * array.
>>>> + */
>>>> +#define VMSA_REG_ENTRY(_field)	 (offsetof(struct vmcb_save_area, _field) / sizeof(u64))
>>>> +#define VMSA_REG_UNDEF		 VMSA_REG_ENTRY(valid_bitmap)
>>>> +static inline unsigned int vcpu_to_vmsa_entry(enum kvm_reg reg)
>>>> +{
>>>> +	switch (reg) {
>>>> +	case VCPU_REGS_RAX:	return VMSA_REG_ENTRY(rax);
>>>> +	case VCPU_REGS_RBX:	return VMSA_REG_ENTRY(rbx);
>>>> +	case VCPU_REGS_RCX:	return VMSA_REG_ENTRY(rcx);
>>>> +	case VCPU_REGS_RDX:	return VMSA_REG_ENTRY(rdx);
>>>> +	case VCPU_REGS_RSP:	return VMSA_REG_ENTRY(rsp);
>>>> +	case VCPU_REGS_RBP:	return VMSA_REG_ENTRY(rbp);
>>>> +	case VCPU_REGS_RSI:	return VMSA_REG_ENTRY(rsi);
>>>> +	case VCPU_REGS_RDI:	return VMSA_REG_ENTRY(rdi);
>>>> +#ifdef CONFIG_X86_64
> 
> Is KVM SEV-ES going to support 32-bit builds?

No, SEV-ES won't support 32-bit builds and since those fields are always
defined, I can just remove this #ifdef.

> 
>>>> +	case VCPU_REGS_R8:	return VMSA_REG_ENTRY(r8);
>>>> +	case VCPU_REGS_R9:	return VMSA_REG_ENTRY(r9);
>>>> +	case VCPU_REGS_R10:	return VMSA_REG_ENTRY(r10);
>>>> +	case VCPU_REGS_R11:	return VMSA_REG_ENTRY(r11);
>>>> +	case VCPU_REGS_R12:	return VMSA_REG_ENTRY(r12);
>>>> +	case VCPU_REGS_R13:	return VMSA_REG_ENTRY(r13);
>>>> +	case VCPU_REGS_R14:	return VMSA_REG_ENTRY(r14);
>>>> +	case VCPU_REGS_R15:	return VMSA_REG_ENTRY(r15);
>>>> +#endif
>>>> +	case VCPU_REGS_RIP:	return VMSA_REG_ENTRY(rip);
>>>> +	default:
>>>> +		WARN_ONCE(1, "unsupported VCPU to VMSA register conversion\n");
>>>> +		return VMSA_REG_UNDEF;
>>>> +	}
>>>> +}
>>>> +
>>>> +/* For SEV-ES guests, populate the vCPU register from the appropriate VMSA/GHCB */
>>>> +static void svm_reg_read_override(struct kvm_vcpu *vcpu, enum kvm_reg reg)
>>>> +{
>>>> +	struct vmcb_save_area *vmsa;
>>>> +	struct vcpu_svm *svm;
>>>> +	unsigned int entry;
>>>> +	unsigned long val;
>>>> +	u64 *vmsa_reg;
>>>> +
>>>> +	if (!sev_es_guest(vcpu->kvm))
>>>> +		return;
>>>> +
>>>> +	entry = vcpu_to_vmsa_entry(reg);
>>>> +	if (entry == VMSA_REG_UNDEF)
>>>> +		return;
>>>> +
>>>> +	svm = to_svm(vcpu);
>>>> +	vmsa = get_vmsa(svm);
>>>> +	vmsa_reg = (u64 *)vmsa;
>>>> +	val = (unsigned long)vmsa_reg[entry];
>>>> +
>>>> +	/* If a GHCB is mapped, check the bitmap of valid entries */
>>>> +	if (svm->ghcb) {
>>>> +		if (!test_bit(entry, (unsigned long *)vmsa->valid_bitmap))
>>>> +			val = 0;
>>>
>>> Is KVM relying on this being 0?  Would it make sense to stuff something like
>>> 0xaaaa... or 0xdeadbeefdeadbeef so that consumption of bogus data is more
>>> noticeable?
>>
>> No, KVM isn't relying on this being 0. I thought about using something
>> other than 0 here, but settled on just using 0. I'm open to changing that,
>> though. I'm not sure if there's an easy way to short-circuit the intercept
>> and respond back with an error at this point, that would be optimal.
> 
> Ya, responding with an error would be ideal.  At this point, we're taking the
> same lazy approach for TDX and effectively consuming garbage if the guest
> requests emulation but doesn't expose the necessary GPRs.  That being said,
> TDX's guest/host ABI is quite rigid, so all the "is this register valid"
> checks could be hardcoded into the higher level "emulation" flows.
> 
> Would that also be an option for SEV-ES?

Meaning adding the expected input checks at VMEXIT time in the VMGEXIT
handler, so that accesses later are guaranteed to be good? That is an
option and might also address one of the other points you brought up about
 about receiving exits that are not supported/expected.

Thanks,
Tom

> 
