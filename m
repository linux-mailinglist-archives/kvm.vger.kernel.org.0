Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4BBE131C25
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 00:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgAFXOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 18:14:50 -0500
Received: from mail-bn8nam11on2042.outbound.protection.outlook.com ([40.107.236.42]:31182
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726545AbgAFXOu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 18:14:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gX0nzSjjfs7QdHeQzqCODULv5BN3lq0Lf5RtX83f9Nq6C+ZjXfLnSgwFlDU+8sDLLAsDAtFqFbDx0NOD1kThe/WLyFLvZjwtIIzQwXBeEd+cnBYR1wwzbx18B0YyS5IJblY5jCJ0+X1x+mWIenUYWFUDU05i1CF5ih+s7WtWA02aE2pwhxB3KpV/d6QxIB/cQaTLH3/HiDtiluwcTHJuww0uZzII7aIBg0o7E3OH64dT7Tp1BI0va78pYHMpWyfXMsKrT1jHifYQ2UOxJtzwwpeJTWLvPv+isU1NDg8pArZiLeGPxjve/h6xq3MAWIEVFxEoYCNB3FjTgVr4MwmKag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v8jxL0enkufvfrZR3F6z2/Tc7SIx8eK/ErIsCmySD9g=;
 b=JvMZcuAWrWB4B+T/8svR8Wb8mjf00VZPdSS50YyiSiSniDfdR0AshM8/5KRSCQU6bqhVSRy92EONnXZl8NcigKK5f81sbcUYY/DloseCnjuK6/PolQW1AUGyz8xm2AvZKq0gNrDmnbYFla0oeIecDzA6OY+0GghmdZlQ/Ek01x2DjNbxga/KBen0tQYIYDYpVhcv1gGXVBfGKxN2AW7S18ipyYkvYAFPySnhWCZgDONhP48moOlTR14lfAXLJmtP8MNerTebgcK2PYlPV1lHas1h3Mw1guq8N7JJiIoOLgKjVrY9pkDf2y45y35NwKGd7umHn8CJGpQT5MpEdGjrJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v8jxL0enkufvfrZR3F6z2/Tc7SIx8eK/ErIsCmySD9g=;
 b=GLrH0FqPsNRA6ZGNgfhlwd+oZCzgdh+Rr7Kt/4uH43UBNQBdAC/MgiNZB6owaokIQRr5U13xVD0P7+wTS3fXpmsur2wv45bvSQ+a4UQkTs/5rTD15wmouyIDxoZ9mjWMBllwGDXrtPvlrI5iRsrG3pUCY4mttqAbUm+pa/5NKh8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.71.154) by
 DM6PR12MB3913.namprd12.prod.outlook.com (10.255.174.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Mon, 6 Jan 2020 23:14:07 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270%7]) with mapi id 15.20.2602.016; Mon, 6 Jan 2020
 23:14:07 +0000
Subject: Re: [PATCH v2] KVM: SVM: Override default MMIO mask if memory
 encryption is enabled
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <d741b3a58769749b7873fea703c027a68b8e2e3d.1577462279.git.thomas.lendacky@amd.com>
 <20200106224931.GB12879@linux.intel.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <f5c2e60c-536f-e0cd-98b9-86e6da82e48f@amd.com>
Date:   Mon, 6 Jan 2020 17:14:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <20200106224931.GB12879@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0031.namprd05.prod.outlook.com
 (2603:10b6:803:40::44) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
Received: from [10.236.30.194] (165.204.77.1) by SN4PR0501CA0031.namprd05.prod.outlook.com (2603:10b6:803:40::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.7 via Frontend Transport; Mon, 6 Jan 2020 23:14:06 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 361f76dd-5270-4363-23e6-08d792fe2112
X-MS-TrafficTypeDiagnostic: DM6PR12MB3913:|DM6PR12MB3913:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB39137AD53660C717EBF81702EC3C0@DM6PR12MB3913.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0274272F87
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(189003)(199004)(5660300002)(31686004)(52116002)(2906002)(478600001)(4326008)(16576012)(316002)(16526019)(54906003)(31696002)(26005)(186003)(6486002)(8676002)(2616005)(956004)(81166006)(81156014)(8936002)(6916009)(86362001)(66946007)(66476007)(66556008)(53546011)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3913;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XvXPcf2RY7aYwa0NGuB6P6/VcyP+tBxsgAT+TveiU445Jtnw4y8uyA2Vo1BVaLWDU1pjEesG1srFKthn3yc+UC7gt14UIaXcE7AaA3yVQ0bkLI15TgCNQKMm0CpnARahUIkxdnNTJunX4aaU9B3rphM0u1W3Dhiy9zx3kKK3/uN2fjMYdEPdFlX5zFMiTLKhkLg9IyMtPgY2WTj4R844Cpj8s125wYaCnKhfcBe7Mwjw2nL16mfgxqU0naulfUZCd4uQoashqzwvRllurGnpw9AdlilghiHkW5lxQMyB72S6jM9f8tUYFqWH+svQPRvBNK89hvadllR41EvmUF7tJuFO9w2996p52nXxq9KP5BiO2kTVcPEMuT3tIhb8Q7LMC5qrryS74K9ObRSU3mVSLjK4zK4HLp6B38sHHn25LMedEJ1JSSvetxuHIo+ekggm
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 361f76dd-5270-4363-23e6-08d792fe2112
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2020 23:14:07.3058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DqDE1n+Z0dv0dpkczapl7ljIfsrMblsMfO8fYcJP6dTRqlz/ITIZPrbsRGGwefQB5RWwjqOydiVzvUKPrql4Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3913
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/6/20 4:49 PM, Sean Christopherson wrote:
> On Fri, Dec 27, 2019 at 09:58:00AM -0600, Tom Lendacky wrote:
>> The KVM MMIO support uses bit 51 as the reserved bit to cause nested page
>> faults when a guest performs MMIO. The AMD memory encryption support uses
>> a CPUID function to define the encryption bit position. Given this, it is
>> possible that these bits can conflict.
>>
>> Use svm_hardware_setup() to override the MMIO mask if memory encryption
>> support is enabled. When memory encryption support is enabled the physical
>> address width is reduced and the first bit after the last valid reduced
>> physical address bit will always be reserved. Use this bit as the MMIO
>> mask.
>>
>> Fixes: 28a1f3ac1d0c ("kvm: x86: Set highest physical address bits in non-present/reserved SPTEs")
>> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  arch/x86/kvm/svm.c | 26 ++++++++++++++++++++++++++
>>  1 file changed, 26 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index 122d4ce3b1ab..2cb834b5982a 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -1361,6 +1361,32 @@ static __init int svm_hardware_setup(void)
>>  		}
>>  	}
>>  
>> +	/*
>> +	 * The default MMIO mask is a single bit (excluding the present bit),
>> +	 * which could conflict with the memory encryption bit. Check for
>> +	 * memory encryption support and override the default MMIO masks if
>> +	 * it is enabled.
>> +	 */
>> +	if (cpuid_eax(0x80000000) >= 0x8000001f) {
>> +		u64 msr, mask;
>> +
>> +		rdmsrl(MSR_K8_SYSCFG, msr);
>> +		if (msr & MSR_K8_SYSCFG_MEM_ENCRYPT)  {
>> +			/*
>> +			 * The physical addressing width is reduced. The first
>> +			 * bit above the new physical addressing limit will
>> +			 * always be reserved. Use this bit and the present bit
>> +			 * to generate a page fault with PFER.RSV = 1.
>> +			 */
>> +			mask = BIT_ULL(boot_cpu_data.x86_phys_bits);
> 
> This doesn't handle the case where x86_phys_bits _isn't_ reduced by SME/SEV
> on a future processor, i.e. x86_phys_bits==52.

Not sure I follow. If MSR_K8_SYSCFG_MEM_ENCRYPT is set then there will
always be a reduction in physical addressing (so I'm told). And if
MSR_K8_SYSCFG_MEM_ENCRYPT isn't set and x86_phys_bits == 52, then
everything should be fine with the existing kvm_set_mmio_spte_mask()
function where bit 51 is set but the present bit isn't, correct?

Thanks,
Tom

> 
> After staring at things for a while, I think we can handle this issue with
> minimal fuss by special casing MKTME in kvm_set_mmio_spte_mask().  I'll
> send a patch, I have a related bug fix for kvm_set_mmio_spte_mask() that
> touches the same code.
> 
>> +			mask |= BIT_ULL(0);
>> +
>> +			kvm_mmu_set_mmio_spte_mask(mask, mask,
>> +						   PT_WRITABLE_MASK |
>> +						   PT_USER_MASK);
>> +		}
>> +	}
>> +
>>  	for_each_possible_cpu(cpu) {
>>  		r = svm_cpu_init(cpu);
>>  		if (r)
>> -- 
>> 2.17.1
>>
