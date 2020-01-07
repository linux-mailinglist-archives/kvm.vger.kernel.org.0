Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1ED1337BA
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 00:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgAGXv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 18:51:59 -0500
Received: from mail-eopbgr770052.outbound.protection.outlook.com ([40.107.77.52]:36554
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726470AbgAGXv6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 18:51:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kQkWy7ObzW1h5Msix0YKUAnFNr9NRLINrcnGhUSHdVkBa9VIU867YSgMm604FkGCfwAEz8vz7heStz57BfXbmDf1IQz0C0pMjobXs+3XIrnA47QaKl2X2gm4+n2Ox5yA3ILQ8662CPPmf9euAGbUiGabYC2H13wKHLNO5+lWkLTtbM9pH5UQ67SVlAZAEKVDYU9T6t7+JNxq8cG8yNvw8StscwSS7ngyRyUtKcesE1fK7ypt4yP1dO6XYZZ6CLCi2K6ZlP4dy1NkF142LvXaTa9pVoBQMWF2mDHCHrr3YV1N6g6KEWcygAAqEgVNwWJpd+m19d9eKYu0PByTKd1wsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ZKls98hm1UE9oZ8b89NtgPH1XcPYTckd1e56qM6Zkk=;
 b=h53q+hAkLBpTORPLDAfseTzH5FxaWbesWOx2g4aXg09yW6lO9CayNhN+aAhiQ2Gc6Il8GbCRr7MuQHxhO6EDLgHNRN2HQQYA+y3s38m3zwoTnsQ5g54rxPHEvtAmb6TL0faX7O1CSPbBygVvDVSAZ7XvxBAz2zuKYipNwOSUKxmoGBRhm1xzKIWeE5+awxVW/iQrQ9ziwB1mlippHzzzPQ0+65jzaUhxk8uoUaFQDogQCML7ntM8idXqqUHH7Ayr500zwx5DJL3cmL8orLjQ/UtmrZL0F8OIWMX9fAIWTmNejfDWn5opSwdFeUpkvsPzsBRacl0/6KHSBBMS7ngVNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ZKls98hm1UE9oZ8b89NtgPH1XcPYTckd1e56qM6Zkk=;
 b=zIoxdjzd+alhGUfOzmOZevQqcnme3aStk+eA+IQS9vbIjz92qzQpunDWZKFMWdK/5LUJ809tEQm9uj0RNYrbsQCgqaDp++/Nz7z4NXE0DTTyOLCEMosLqBhsQ/xAV4BurZJYx4cbu0ZVT+10ZZ/NJtAntMDAkAGXz/ST0nyXA/I=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.71.154) by
 DM6PR12MB2617.namprd12.prod.outlook.com (20.176.116.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Tue, 7 Jan 2020 23:51:54 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270%7]) with mapi id 15.20.2602.016; Tue, 7 Jan 2020
 23:51:53 +0000
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
 <f5c2e60c-536f-e0cd-98b9-86e6da82e48f@amd.com>
 <20200106233846.GC12879@linux.intel.com>
 <a4fb7657-59b6-2a3f-1765-037a9a9cd03a@amd.com>
 <20200107222813.GB16987@linux.intel.com>
 <298352c6-7670-2929-9621-1124775bfaed@amd.com>
 <20200107233102.GC16987@linux.intel.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <c60d15f2-ca10-678c-30aa-5369cf3864c7@amd.com>
Date:   Tue, 7 Jan 2020 17:51:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <20200107233102.GC16987@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0026.prod.exchangelabs.com (2603:10b6:804:2::36)
 To DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
MIME-Version: 1.0
Received: from [10.236.30.74] (165.204.77.1) by SN2PR01CA0026.prod.exchangelabs.com (2603:10b6:804:2::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.12 via Frontend Transport; Tue, 7 Jan 2020 23:51:53 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0354fead-4dca-4b81-33d3-08d793cc9286
X-MS-TrafficTypeDiagnostic: DM6PR12MB2617:|DM6PR12MB2617:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2617A621D9AC744432FFB3EFEC3F0@DM6PR12MB2617.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 027578BB13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(189003)(199004)(52116002)(2616005)(66946007)(54906003)(316002)(16576012)(66556008)(66476007)(4326008)(8936002)(956004)(6916009)(16526019)(81156014)(31686004)(81166006)(8676002)(2906002)(478600001)(31696002)(86362001)(6486002)(26005)(5660300002)(36756003)(53546011)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2617;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /rdUnbVHFvPHR9IWoIr7F5nstpT7xCBu1YlShjcl8e45rTTFKzt3geoAhmqbPd14hPUzobC8JXtG5UkwTNDVdOJLZL/SwSD/3SiXOAOB9wZIHk7sVuzUpfms9agmO3FZcKRi2X6KIjSJL0Wks/GvacQZ4VgycxuU4HXwWGB7/rnf28ZevQHuNptDAdZfyXR8gRbjOb4l1RPKWaj+nA3rVjIQ6cAptDce2U0SFIZBQvzimgIgSo5vnd96B7go0ECNXeMIODntDAas77xpvff/j7HYAJw2p/xNGggJacQZhlYbkZt0dP0bdIYin5AvJ7T/Dv20oJ5psQ80riSdGSQ9QKI8qZe5U1MFod+JiChzp1W/l+I6lbIxnxHIWOeR34Rrxk3FLtvT9Npjy0oCqvg8yWZr+K/Wg0yHztVbxtFLdhh2UUGt0NZQBjdA30Udo2I/
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0354fead-4dca-4b81-33d3-08d793cc9286
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2020 23:51:53.9353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GLXijPROjDTjcICvdP9Ua2ZZGDMs5MVAQDvcYFeyi8S/hIUZjIXahy0yoQNwqLPOmesIefdzf/YENUlIhDvx6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2617
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/7/20 5:31 PM, Sean Christopherson wrote:
> On Tue, Jan 07, 2020 at 04:54:34PM -0600, Tom Lendacky wrote:
>> On 1/7/20 4:28 PM, Sean Christopherson wrote:
>>> On Tue, Jan 07, 2020 at 02:16:37PM -0600, Tom Lendacky wrote:
>>>> On 1/6/20 5:38 PM, Sean Christopherson wrote:
>>>>> On Mon, Jan 06, 2020 at 05:14:04PM -0600, Tom Lendacky wrote:
>>>>>> On 1/6/20 4:49 PM, Sean Christopherson wrote:
>>>>>>> This doesn't handle the case where x86_phys_bits _isn't_ reduced by SME/SEV
>>>>>>> on a future processor, i.e. x86_phys_bits==52.
>>>>>>
>>>>>> Not sure I follow. If MSR_K8_SYSCFG_MEM_ENCRYPT is set then there will
>>>>>> always be a reduction in physical addressing (so I'm told).
>>>>>
>>>>> Hmm, I'm going off APM Vol 2, which states, or at least strongly implies,
>>>>> that reducing the PA space is optional.  Section 7.10.2 is especially
>>>>> clear on this:
>>>>>
>>>>>   In implementations where the physical address size of the processor is
>>>>>   reduced when memory encryption features are enabled, software must
>>>>>   ensure it is executing from addresses where these upper physical address
>>>>>   bits are 0 prior to setting SYSCFG[MemEncryptionModEn].
>>>>
>>>> It's probably not likely, but given what is stated, I can modify my patch
>>>> to check for a x86_phys_bits == 52 and skip the call to set the mask, eg:
>>>>
>>>> 	if (msr & MSR_K8_SYSCFG_MEM_ENCRYPT &&
>>>> 	    boot_cpu_data.x86_phys_bits < 52) {
>>>>
>>>>>
>>>>> But, hopefully the other approach I have in mind actually works, as it's
>>>>> significantly less special-case code and would naturally handle either
>>>>> case, i.e. make this a moot point.
>>>>
>>>> I'll hold off on the above and wait for your patch.
>>>
>>> Sorry for the delay, this is a bigger mess than originally thought.  Or
>>> I'm completely misunderstanding the issue, which is also a distinct
>>> possibility :-)
>>>
>>> Due to KVM activating its L1TF mitigation irrespective of whether the CPU
>>> is whitelisted as not being vulnerable to L1TF, simply using 86_phys_bits
>>> to avoid colliding with the C-bit isn't sufficient as the L1TF mitigation
>>> uses those first five reserved PA bits to store the MMIO GFN.  Setting
>>> BIT(x86_phys_bits) for all MMIO sptes would cause it to be interpreted as
>>> a GFN bit when the L1TF mitigation is active and lead to bogus MMIO.
>>
>> The L1TF mitigation only gets applied when:
>>   boot_cpu_data.x86_cache_bits < 52 - shadow_nonpresent_or_rsvd_mask_len
>>
>>   and with shadow_nonpresent_or_rsvd_mask_len = 5, that means that means
>>   boot_cpu_data.x86_cache_bits < 47.
>>
>> On AMD processors that support memory encryption, the x86_cache_bits value
>> is not adjusted, just the x86_phys_bits. So for AMD processors that have
>> memory encryption support, this value will be at least 48 and therefore
>> not activate the L1TF mitigation.
> 
> Ah.  Hrm.  I'd prefer to clean that code up to make the interactions more
> explicit, but may be we can separate that out.
> 
>>> The only sane approach I can think of is to activate the L1TF mitigation
>>> based on whether the CPU is vulnerable to L1TF, as opposed to activating> the mitigation purely based on the max PA of the CPU.  Since all CPUs that
>>> support SME/SEV are whitelisted as NO_L1TF, the L1TF mitigation and C-bit
>>> should never be active at the same time.
>>
>> There is still the issue of setting a single bit that can conflict with
>> the C-bit. As it is today, if the C-bit were to be defined as bit 51, then
>> KVM would not take a nested page fault and MMIO would be broken.
> 
> Wouldn't Paolo's patch to use the raw "cpuid_eax(0x80000008) & 0xff" for
> shadow_phys_bits fix that particular collision by causing
> kvm_set_mmio_spte_mask() to clear the present bit?  Or am I misundertanding
> how the PA reduction interacts with the C-Bit?
> 
> AIUI, using phys_bits=48, then the standard scenario is Cbit=47 and some
> additional bits 46:M are reserved.  Applying that logic to phys_bits=52,
> then Cbit=51 and bits 50:M are reserved, so there's a collision but it's

There's no requirement that the C-bit correspond to phys_bits. So, for
example, you can have C-bit=51 and phys_bits=48 and so 47:M are reserved.

Thanks,
Tom

> mostly benign because shadow_phys_bits==52, which triggers this:
> 
> 	if (IS_ENABLED(CONFIG_X86_64) && shadow_phys_bits == 52)
> 		mask &= ~1ull;
> 
> In other words, Paolo's patch fixes the fatal bug, but unnecessarily
> disables optimized MMIO page faults.  To remedy that, your idea is to rely
> on the (undocumented?) behavior that there are always additional reserved
> bits between Cbit and the reduced x86_phys_bits.
> 
