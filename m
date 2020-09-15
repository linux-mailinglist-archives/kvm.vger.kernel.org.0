Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD9F26B231
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 00:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbgIOWmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 18:42:21 -0400
Received: from mail-bn8nam11on2040.outbound.protection.outlook.com ([40.107.236.40]:13984
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727464AbgIOP4l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 11:56:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ldz5ViChDu/cv7ouXilHAh/jr9lpuDYNizKcWmroN/+DalTOipHVgLBesTyr7nervVZN3GWhsJryjmFD0UmObU8YB8dHCLxAPdnzZuFMMXw6EFTmWKKt9gF4s1Oiw+OPOyu9IHyRspIZlOOS8xYasn+stAUalGRW62PWyIQ0xwpWgKOM99//J7oWLVog+oOgM4Q4mgjt2mT/ScRtGkMgL8g6qaKf02iueDwPR76FE6u3jN+3dG5a+qWLk0aFRH6UGl9cVuA6GdrmnyruN5vjFfBh9D01y8GQH+A75zwK26BOmgesYwYpTlnxOQw0/th6XTwvzySea2W51bvoUuKsTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qu4M2+lFOsaFwBfZthQg/qXJ0aJjeMcvSDNYsKheM8Y=;
 b=EHy9qSBN5qhFQP8N8jHrNWn4O/iN++AMJ/w5eoTQ03rSP54Jyr8l9enJwhP4DVTgiE+1iHWMBjNDFBsAXO1V0mOhDufagEAfLtJMxDQuC/B45tsBT8QRfOqatpSQ6feay44eUDT9sLFgSgG+HqDKVlrhr1/QV0bWNEIJnsULeHiWEtWxR2DObvMGJQcVyJdS14WCFI0BJ8cZh36oLpOjEAKu/n31fLlg2urPBaWbCojIASXW38/zE7yKhCPpzoQeNQK1kHYSiT9jQZifeHlpF9rM+u9tIbBgEjqVIS8zoJ+SGZxbUW0hYiltvzIb+qHzodv8Psd+06pYnlmCzR52vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qu4M2+lFOsaFwBfZthQg/qXJ0aJjeMcvSDNYsKheM8Y=;
 b=3OJpzgIsUU/3uA0/igWDAlA5f4XkwJfUOxNpb1iKSWSchZyEEODVlPnVoTTbTUkqo6DgK0VTGi+Kv/DHiMw76m9xMBbbm8liD78qugGzBC0yCkQgJyCzyHjvGKylEBYYoGL5d7BswJaXSj8cHb2MCM83OOaAtB+8JEaTk8WUmKk=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0150.namprd12.prod.outlook.com (2603:10b6:910:23::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.17; Tue, 15 Sep
 2020 15:56:31 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443%10]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 15:56:31 +0000
Subject: Re: [RFC PATCH 22/35] KVM: SVM: Add support for CR0 write traps for
 an SEV-ES guest
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
 <68f885b63b18e5c72eae92c9c681296083c0ccd8.1600114548.git.thomas.lendacky@amd.com>
 <20200914221353.GJ7192@sjchrist-ice>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <f634cb2d-5464-6e48-2511-b3b0cbde24cf@amd.com>
Date:   Tue, 15 Sep 2020 10:56:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200914221353.GJ7192@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR04CA0041.namprd04.prod.outlook.com
 (2603:10b6:3:12b::27) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM5PR04CA0041.namprd04.prod.outlook.com (2603:10b6:3:12b::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 15:56:30 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 36370ae8-aa18-4375-f61e-08d8598fe9d7
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0150:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB015083D6E0826D248DEFCE5EEC200@CY4PR1201MB0150.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hjalNUVQrND5MDdbLS+53cEdP/SKzl1K6ZsWZrvgXwR/8yfK6hIoeSY8N/KVqrev+eegwfAGXs8ji1bEcCOs0sigOjAxsFtV1IuCm0/GfNe1JkL+OjXWX37Zz/oHvSs64vcujRsFGGsRc79mvAGOUKDVbeiNb+2tihsyDxm4OBXfqebTD7BquTy51O27oJh7LaZ/dRsmyexYa+uqwRoXWO2yEdKzwE/Bau5/xV4Y80+gE4kFBuJ+YIRYjzAibnBGG1/Um78TOXRb4MbYD8qQxm+vvfRs47GA8Wl5WZzIYBFK7lmpS6s5UCRPFEyEwvBwFqXzJ+eD+UKC4QSJdp9lUdDEtG93jXFqW2/Yjls3AFjy7QDZ3VaOQosRULMjNzReal1XIlZIAmcWFaeOJz4ndzJ/Z+HjtmHI5FmQ6mEKQvg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(52116002)(66556008)(66476007)(6916009)(26005)(6486002)(86362001)(16526019)(186003)(66946007)(53546011)(83380400001)(4326008)(8676002)(16576012)(31696002)(478600001)(316002)(8936002)(54906003)(31686004)(36756003)(2906002)(7416002)(956004)(2616005)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bcmC6uVpzgxIqiPtFgjTLutTKcQ2fHbFWGsmjPAVLmEQHxDcuLvsmHYFKcRo1SfQjF2/VFF76ZutfuIktLtwU1TybEte4I4hlB/5CpDtSFW84q3+EQrlajyLiHQ4j75IOEbX364vD9SVy2L9Cz4gLPzBoeLgyja8TKLX2Vc1CscaqpcGixA1MCBSts4Du34aT6dae+Vj4jcuP09NKUv2o+9tus8iwlEO4Qzx/e5EvJFoLFITCHU5SvISostxkPiIFPi8d8SAW9fWaxu5Lz61WLelocws8b3EKQrcUQJBIOthPqsP9t0lPzfl2EDvNm6/C/O+uc9v8D0uEQ6JEGWNavb93fxarbE4PgokpnRjWwWhZOz0KMfJ/WgacTmohbQK9fXogZdAIkLuTsF08E6VZq58ZUUEXyNnuzKUbxHMA5nuGNV1cwMYO77slHcKMKBCvKMhflccvL63F05c1EF4BQD055z8+5mlQqA+bneI3+7Oib0SQqHg2b7UopunxJcxEWC/cjKPPZpMKZNMn1n3zMV/ag6C3VhXMxt1AWNXW8vis2r5i+++douztIxtM5P5zgZSjyiXm5EVL6w3djdIop63E69Qf7LgrVZZHSvUeMeRDS6SmsM9NVwr7q9Hy4tCQ1/EuItImHBHhhFNyhbITw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36370ae8-aa18-4375-f61e-08d8598fe9d7
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 15:56:31.3544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LIRzrE1ngiBkRgLHGybzgwbbILu1acebdcY2VAwaUHVdGm/I/5AszWLq0slOCbAwCv/1GcZYwJ9qQAt8o5mxsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0150
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/14/20 5:13 PM, Sean Christopherson wrote:
> On Mon, Sep 14, 2020 at 03:15:36PM -0500, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index b65bd0c986d4..6f5988c305e1 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -799,11 +799,29 @@ bool pdptrs_changed(struct kvm_vcpu *vcpu)
>>  }
>>  EXPORT_SYMBOL_GPL(pdptrs_changed);
>>  
>> +static void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0,
>> +			     unsigned long cr0)
> 
> What about using __kvm_set_cr*() instead of kvm_post_set_cr*()?  That would
> show that __kvm_set_cr*() is a subordinate of kvm_set_cr*(), and from the
> SVM side would provide the hint that the code is skipping the front end of
> kvm_set_cr*().

Ok, I'll change this (and the others) to __kvm_set_cr* and export them.

> 
>> +{
>> +	unsigned long update_bits = X86_CR0_PG | X86_CR0_WP;
>> +
>> +	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
>> +		kvm_clear_async_pf_completion_queue(vcpu);
>> +		kvm_async_pf_hash_reset(vcpu);
>> +	}
>> +
>> +	if ((cr0 ^ old_cr0) & update_bits)
>> +		kvm_mmu_reset_context(vcpu);
>> +
>> +	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
>> +	    kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
>> +	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
>> +		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
>> +}
>> +
>>  int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>>  {
>>  	unsigned long old_cr0 = kvm_read_cr0(vcpu);
>>  	unsigned long pdptr_bits = X86_CR0_CD | X86_CR0_NW | X86_CR0_PG;
>> -	unsigned long update_bits = X86_CR0_PG | X86_CR0_WP;
>>  
>>  	cr0 |= X86_CR0_ET;
>>  
>> @@ -842,22 +860,23 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>>  
>>  	kvm_x86_ops.set_cr0(vcpu, cr0);
>>  
>> -	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
>> -		kvm_clear_async_pf_completion_queue(vcpu);
>> -		kvm_async_pf_hash_reset(vcpu);
>> -	}
>> +	kvm_post_set_cr0(vcpu, old_cr0, cr0);
>>  
>> -	if ((cr0 ^ old_cr0) & update_bits)
>> -		kvm_mmu_reset_context(vcpu);
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_set_cr0);
>>  
>> -	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
>> -	    kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
>> -	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
>> -		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
>> +int kvm_track_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
> 
> I really dislike the "track" terminology.  For me, using "track" as the verb
> in a function implies the function activates tracking.  But it's probably a
> moot point, because similar to EFER, I don't see any reason to put the front
> end of the emulation into x86.c.  Both getting old_cr0 and setting
> vcpu->arch.cr0 can be done in svm.c

Yup, I can move that to svm.c.

Thanks,
Tom

> 
>> +{
>> +	unsigned long old_cr0 = kvm_read_cr0(vcpu);
>> +
>> +	vcpu->arch.cr0 = cr0;
>> +
>> +	kvm_post_set_cr0(vcpu, old_cr0, cr0);
>>  
>>  	return 0;
>>  }
>> -EXPORT_SYMBOL_GPL(kvm_set_cr0);
>> +EXPORT_SYMBOL_GPL(kvm_track_cr0);
>>  
>>  void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
>>  {
>> -- 
>> 2.28.0
>>
