Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8B5A134C36
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 20:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgAHTyW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 14:54:22 -0500
Received: from mail-mw2nam12on2054.outbound.protection.outlook.com ([40.107.244.54]:29537
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726129AbgAHTyV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 14:54:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iAC+ZZLJDFTIRiTyu+0sdXudeckm3s/LJtI33IDz7WzRQGc07C13Az0+gi1yxOx/9VWI7Mrp5v0zObVxjBUt+krGs+FDDjAfiEf1EyFCBMdvVWog26R+MX/1nmpaP+RCnoQ9aIXgFFsy7Fx70/Fo6Br12AEYiSbBzy6Tku42gtpDRWBlvam5p8eWM4waoNwUW5sztokMusss+2eWp/Pk7lXcb7QxKO3z+TtZLNXP85eGFO8QVIglWdDi2ltYXQy5EBwlDKbesx5KDU+10Vrx2Q23nIdmXM9gVJ1pHLRW83Mf6O9XPrrFcSifJoIYIUxJJIj5KKVwUqEu0J5AQmq24w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3dHh9PDD4+bAuOgu5Lir7WjDde8VfVBXyeCtwVb4ps=;
 b=djsBUEcMgBXMdWlADnPx6f3LHiJ68IgoSAEtF8SxLFNWzWNQh1cuLSVcPoboTRSUEUJAtJ5Wr9ysbcaMowMXZfhphv7/dBNe9wy0xhEoxuF6ykw/uTr6F24xH0qoINrjKKKEAcPd6s5h9D7vPOnLVTxGVBKsgXzdwrLEJPI6V++RqOFcIR6Zd9fC9gez4hsF3eItKMLhSu8M1euITxBsm9AXxCxkA6Rsc9zODUECmwFEBxNok4pBFd0QPfbnX4vyuMI7KSgGQfnGfoiBUF0J0tkw99XMOgTXQj1OjH/9KoKYtBgqUkr+WU+hs4CK0BUoVj+bDQoclcWZWaaqGGaOcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3dHh9PDD4+bAuOgu5Lir7WjDde8VfVBXyeCtwVb4ps=;
 b=JeEw5oYE83fJb2T9hLiraCqSF7cYydBqmkuzeSSUQxWB2I6pkTACbgDR0JQ6PoRSBqH222zyJSB4HEVUNM4bSrVo+Z+jORsB4g8iLK4D707ZSBUzhGv4o3+i8Kx4GUGscc+0TVXkkS+96uDEXU6lRDfKEM6rZly8RnMRtdUl2A4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.71.154) by
 DM6PR12MB4074.namprd12.prod.outlook.com (10.141.186.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.8; Wed, 8 Jan 2020 19:54:17 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270%7]) with mapi id 15.20.2602.017; Wed, 8 Jan 2020
 19:54:17 +0000
Subject: Re: [PATCH v3] KVM: SVM: Override default MMIO mask if memory
 encryption is enabled
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <6d2b7e37ca4dca92fadd1f3df93803fd17aa70ad.1578508816.git.thomas.lendacky@amd.com>
 <20200108191958.GA31899@linux.intel.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <724e62a5-b7ff-0b55-bdf6-63f43606ef08@amd.com>
Date:   Wed, 8 Jan 2020 13:54:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <20200108191958.GA31899@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0201CA0041.namprd02.prod.outlook.com
 (2603:10b6:803:2e::27) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
Received: from [10.236.30.74] (165.204.77.1) by SN4PR0201CA0041.namprd02.prod.outlook.com (2603:10b6:803:2e::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.12 via Frontend Transport; Wed, 8 Jan 2020 19:54:16 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e488c80d-1fff-4f64-ed17-08d794748b06
X-MS-TrafficTypeDiagnostic: DM6PR12MB4074:|DM6PR12MB4074:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB407408BBED3D751DE37E6A32EC3E0@DM6PR12MB4074.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 02760F0D1C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(366004)(39860400002)(376002)(189003)(199004)(8676002)(316002)(54906003)(81156014)(81166006)(26005)(66946007)(86362001)(6486002)(31696002)(31686004)(4326008)(66556008)(36756003)(66476007)(16576012)(2616005)(186003)(16526019)(956004)(2906002)(478600001)(8936002)(6916009)(53546011)(5660300002)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB4074;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: osJ4QgVTgc0ftgN00SMPuOl5TaXx4SM3PqXuKsLn+h4279p+IXXD8+/kZwxguzKJgsSlJwZA9IJq0zhbY63XNh5PAr3bH5tBfhYjf7x+PnP3cJ09tE0aav48A1Pqe9Aeh0RcF5XlIJv7foxRnkCzPILImeXvlAeFZ3O2T3wxGeoT/cxyCD0cfLiFk1aVOZyjE6/2pUN+QaxFWojwuwIOMZU5FgLDOLKsc8E8yZa6vv6arOUY388h1xza5t+LeyBf5USINz2kOj7aYaSLVaERYC88AICbGGY8x+8JDm69Vj9UxqyQLJmWfYhBxQOkZainUNj1l+JL1ershM+kI29yedzBzAlFgiqhQWoLSkUPGqLrUS9+jCBIQonQ9KWREkFLev21fOi2YDl9FMdKpw3B86KtkoP42B+W/Cd1Y4nFi+3reSifcS+3IBQMKzSNqhvo
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e488c80d-1fff-4f64-ed17-08d794748b06
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2020 19:54:17.3354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g8CaHfaXwZocHwMBhX6VaAvMvP+//BWHunm/4St1RK1IEXrm3xzwvD6LvOKl37i2e5H3o4Y+cl18N7oQjRqmFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4074
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/8/20 1:19 PM, Sean Christopherson wrote:
> On Wed, Jan 08, 2020 at 12:40:16PM -0600, Tom Lendacky wrote:
>> The KVM MMIO support uses bit 51 as the reserved bit to cause nested page
>> faults when a guest performs MMIO. The AMD memory encryption support uses
>> a CPUID function to define the encryption bit position. Given this, it is
>> possible that these bits can conflict.
>>
>> Use svm_hardware_setup() to override the MMIO mask if memory encryption
>> support is enabled. Various checks are performed to ensure that the mask
>> is properly defined and rsvd_bits() is used to generate the new mask (as
>> was done prior to the change that necessitated this patch).
>>
>> Fixes: 28a1f3ac1d0c ("kvm: x86: Set highest physical address bits in non-present/reserved SPTEs")
>> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> A few nits below, other than that:
> 
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
>>
>> ---
>>
>> Changes in v3:
>> - Add additional checks to ensure there are no conflicts between the
>>   encryption bit position and physical address setting.
>> - Use rsvd_bits() generated mask (as was previously used) instead of
>>   setting a single bit.
>>
>> Changes in v2:
>> - Use of svm_hardware_setup() to override MMIO mask rather than adding an
>>   override callback routine.
>> ---
>>  arch/x86/kvm/svm.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 51 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index 122d4ce3b1ab..9d6bd3fc12c8 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -1307,6 +1307,55 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
>>  	}
>>  }
>>  
>> +/*
>> + * The default MMIO mask is a single bit (excluding the present bit),
>> + * which could conflict with the memory encryption bit. Check for
>> + * memory encryption support and override the default MMIO masks if
>> + * it is enabled.
>> + */
>> +static __init void svm_adjust_mmio_mask(void)
>> +{
>> +	unsigned int enc_bit, mask_bit;
>> +	u64 msr, mask;
>> +
>> +	/* If there is no memory encryption support, use existing mask */
>> +	if (cpuid_eax(0x80000000) < 0x8000001f)
>> +		return;
>> +
>> +	/* If memory encryption is not enabled, use existing mask */
>> +	rdmsrl(MSR_K8_SYSCFG, msr);
>> +	if (!(msr & MSR_K8_SYSCFG_MEM_ENCRYPT))
>> +		return;
>> +
>> +	enc_bit = cpuid_ebx(0x8000001f) & 0x3f;
>> +	mask_bit = boot_cpu_data.x86_phys_bits;
>> +
>> +	/* Increment the mask bit if it is the same as the encryption bit */
>> +	if (enc_bit == mask_bit)
>> +		mask_bit++;
> 
> Nice!
> 
>> +
>> +	if (mask_bit > 51) {
>> +		/*
>> +		 * The mask bit is above 51, so use bit 51 without the present
>> +		 * bit.
>> +		 */
>> +		mask = BIT_ULL(51);
> 
> I don't think setting bit 51 is necessary.  Setting a reserved PA bit is
> purely to trigger the #PF, the MMIO spte itself is confirmed by the presence
> of SPTE_MMIO_MASK.
> 
> AFAICT, clearing only the present bit in kvm_set_mmio_spte_mask() is an
> odd implementation quirk, i.e. it can, and arguably should, simply clear
> the mask.  It's something I'd like to clean up (in mmu.c) and would prefer
> to not propagate here.

I can do that. I ran a quick boot test using a zero mask and didn't
encounter any issues. If no one has any reasons for having some bit
set in the MMIO mask when the present bit isn't set, I'll make that
change.

I'll hold off on V4 for a day or so before re-submitting.

Thanks,
Tom

> 
>> +	} else {
>> +		/*
>> +		 * Some bits above the physical addressing limit will always
>> +		 * be reserved, so use the rsvd_bits() function to generate
>> +		 * the mask. This mask, along with the present bit, will be
>> +		 * used to generate a page fault with PFER.RSV = 1.
>> +		 */
>> +		mask = rsvd_bits(mask_bit, 51);
>> +		mask |= BIT_ULL(0);
> 
> My personal preference would be to use PT_PRESENT_MASK (more crud in mmu.c
> that should be fixed).  And the brackets can be dropped if mask is set in
> a single line, e.g.:
> 
> 	/*
> 	 * Here be a comment.
> 	 */
> 	if (mask_bit > 51)
> 		mask = 0;
> 	else
> 		mask = rsvd_bits(mask_bit, 51) | PT_PRESENT_MASK;
> 
>> +	}
>> +
>> +	kvm_mmu_set_mmio_spte_mask(mask, mask,
>> +				   PT_WRITABLE_MASK |
>> +				   PT_USER_MASK);
>> +}
>> +
>>  static __init int svm_hardware_setup(void)
>>  {
>>  	int cpu;
>> @@ -1361,6 +1410,8 @@ static __init int svm_hardware_setup(void)
>>  		}
>>  	}
>>  
>> +	svm_adjust_mmio_mask();
>> +
>>  	for_each_possible_cpu(cpu) {
>>  		r = svm_cpu_init(cpu);
>>  		if (r)
>> -- 
>> 2.17.1
>>
