Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398D926B6C1
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 02:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbgIPAKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 20:10:35 -0400
Received: from mail-eopbgr770045.outbound.protection.outlook.com ([40.107.77.45]:65351
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726929AbgIOO0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 10:26:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J49XIuIp8KOXJK1wgBMuMr2Z5i8w5kdxjmOOm6RR4jkBBYbBySTBs9z2c2Cq+zLRcsdk4WkJHEY727OE8I6y5xa9JqxQZD5i7uBED6vGzOH3p9Z3aF7VDex3Tdb7uU8JulrEL7G0gnmyGMXRmXQHhC1QVQsHKpPvWF5TxY4v3TZuFgGJdZg/+yl604E62Ib0Ea0QZbtpkxBVW5T0enGpxAWe5kFZjSvnyn3mIszgOlS8JdWJnGyeX9jhokmkTc1mg3yZ2Arpr2IHdYhSMQXHNRQjzo0skowE1f9FY7fElMhubi/bD9N/Vw9bqdOdQPpVeq3/BuGesNeu0yRY1PwDdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+5cwpUCA7UHhpM99FuIX6fTRzxjuWrSjlbMYB8MIjxA=;
 b=ne9if5sVI+Vhj35iTk25B97WlLivtlMWmnFh3e/8lx5n8Ie/lgqAXWRQVoaPeXcam0thjdq1ggbe7UHeE6KONywkYjyGW6+BulasdUwqe9UJ9VNdaSrgzXMNdwXccv2cj4cN39KNOZhb6lTPObkn+dgTI0nxsG/+s5L0wMqs51ZiDz84fheqirAmvvuduvjHGcNqOe8+U0ZKSVSIdN7I26ZAzNuwhhgvvtuLPb6WqyqRQRe9rV3mDUkzdNpVrNj8H3m5nKbyZBjtE6BkQTgITk5UcIG2B8ZYyikUF4qHaW2h5qG83IhLsDMvlWH15Or5+5JIArREKuFSLkdGf8K5Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+5cwpUCA7UHhpM99FuIX6fTRzxjuWrSjlbMYB8MIjxA=;
 b=s4rRZFwtvnHiNejJgURtH6jYhvC11igyQA7zbbCIJuuFuUF5JbI7PVVhOBFmLFdpw6WqD6auQmQ2fT6IikkSyUX9MUf/Cfc3ei4dmEDT9tHjfkvnvbEcH2vOGlwxOD8i5NmoMrnAEt/rYV5a3gS+G8FVuG0XB/jkx2Gi8a8D5U8=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0213.namprd12.prod.outlook.com (2603:10b6:910:21::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 15 Sep
 2020 14:25:21 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443%10]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 14:25:21 +0000
Subject: Re: [RFC PATCH 26/35] KVM: SVM: Guest FPU state save/restore not
 needed for SEV-ES guest
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
 <ac35a419e395d355d86f3b44ce219dc63864db00.1600114548.git.thomas.lendacky@amd.com>
 <20200914213917.GD7192@sjchrist-ice>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <b37cd9e1-c610-bebb-936a-ab8f73766e63@amd.com>
Date:   Tue, 15 Sep 2020 09:25:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200914213917.GD7192@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM3PR12CA0079.namprd12.prod.outlook.com
 (2603:10b6:0:57::23) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM3PR12CA0079.namprd12.prod.outlook.com (2603:10b6:0:57::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 14:25:19 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c459b5db-7d10-456d-e3d4-08d859832cfd
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0213:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0213128E3B55587B39152A9EEC200@CY4PR1201MB0213.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q0LQrAF88XdwPZWVvQXvZxb9d7p1LUifZDrn1s1QWm0TnKgxXB5BtPwy/XlZha+pi32TkGvq2/75Z19wo+AWSk07lcx4y/f8LwjjqRplFrweyVPUROg52K1U/RQrWuLVC3FNr53Kj2hYpWNazuxIBI9/AeFI8Kjm+Hk3uZYWFq+d/mOJ4cnHJomrrtR25TpkpJXIZjQ68N5etVrtPg9qtINrqpNjdh3ncvGu59AVOEbDjdw/pEAFKMYXAMQEE7jO/4SbKPApIqit7Gh4OQ3bbbhsbZLwAV0WgW9A/drO7S+qPaKBewgredC+wRjI/lGYIejdqtAm2pK1JOMxP3aXM5ebyr2Z38P48x9H7bvShgV/ubpM45nSqVGJbOQ6TXESxaEBCv3VLAf5ov+h+1lK+Rikv1gbSZ7BqEeMWvytsjyPUpkDDPVysX2s7SA204s/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(366004)(376002)(346002)(86362001)(6486002)(16526019)(2906002)(186003)(26005)(53546011)(31696002)(5660300002)(316002)(16576012)(478600001)(36756003)(6916009)(52116002)(8936002)(956004)(2616005)(8676002)(7416002)(31686004)(66556008)(66476007)(83380400001)(54906003)(4326008)(66946007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UTNH36tQjnmquQdyC3+yl686/xqLBGOIWXqzzkdKWlU4VWx3T5qt4cjzvZXZr6EQI4fHwaovsZPhcheZ9a2NAzW3QLArfO3ohjRT0rcLVQqFafSOl87UbWb5ZYOm0uBzibi5Ev8d2swomKiqdOzA0Ht8hEXfNMFM/MmpgqY0n9n+doc/iINDVtQXvbXzb7v/qzmkdA1bRDy0UdL1agjQlADWF5XEsGWOTs7DWhbH9F5dUs99ALnCerALkKVKOaaNYc16jvX+7ygv3md5yhLPmw4x/hx14EvWTK1dKPoUZZjrF/1Bf0HgZIiXbMqfTJ9F9aWbVqUzVoSQHlw7m62aGrb056ayFWWq8jFdkBPG1skiec6LQms/fCo1GYk4eo07PIXr62HxU5tel+KAH3VUkmRUQhca7/Ky/Fx1PNJluOpJE7TOsn4ldboJoBz4kUiOP1Hp0PgZimndO1PcAg/1R20Uohnh9ykRsrc0x47Oxz/hPWnAlop/wBhqVXzNUtVM6j2yk+eAxx6omH9FWA7ZbmmLlc4Ch73eUjF2IQYb1MteHm8z0VnaDHxvGAt68pYlMejlL4NcdzZ1w/wXZXMcCb77FXfl+N2zOwYFRAEbPYo45nKK3H8ZyUyXEKOEPsZVYWjsj+bG6vRzWl26uyjOzA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c459b5db-7d10-456d-e3d4-08d859832cfd
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 14:25:20.7057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ekyZvkjO+nJF/J509gIHor7Z8oR080PvBW+SKTAsTNcv4WIlpACqVk8Y0aNmKaLwafUFlwTktqSY3z+rYpgJaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0213
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/14/20 4:39 PM, Sean Christopherson wrote:
> On Mon, Sep 14, 2020 at 03:15:40PM -0500, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> The guest FPU is automatically restored on VMRUN and saved on VMEXIT by
>> the hardware, so there is no reason to do this in KVM.
> 
> I assume hardware has its own buffer?  If so, a better approach would be to
> not allocate arch.guest_fpu in the first place, and then rework KVM to key
> off !guest_fpu.

Yup, let me look into that.

Thanks,
Tom

> 
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  arch/x86/kvm/svm/svm.c |  8 ++++++--
>>  arch/x86/kvm/x86.c     | 18 ++++++++++++++----
>>  2 files changed, 20 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index b35c2de1130c..48699c41b62a 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3682,7 +3682,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>>  		svm_set_dr6(svm, DR6_FIXED_1 | DR6_RTM);
>>  
>>  	clgi();
>> -	kvm_load_guest_xsave_state(vcpu);
>> +
>> +	if (!sev_es_guest(svm->vcpu.kvm))
>> +		kvm_load_guest_xsave_state(vcpu);
>>  
>>  	if (lapic_in_kernel(vcpu) &&
>>  		vcpu->arch.apic->lapic_timer.timer_advance_ns)
>> @@ -3728,7 +3730,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>>  	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
>>  		kvm_before_interrupt(&svm->vcpu);
>>  
>> -	kvm_load_host_xsave_state(vcpu);
>> +	if (!sev_es_guest(svm->vcpu.kvm))
>> +		kvm_load_host_xsave_state(vcpu);
>> +
>>  	stgi();
>>  
>>  	/* Any pending NMI will happen here */
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 76efe70cd635..a53e24c1c5d1 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -8896,9 +8896,14 @@ static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
>>  
>>  	kvm_save_current_fpu(vcpu->arch.user_fpu);
>>  
>> -	/* PKRU is separately restored in kvm_x86_ops.run.  */
>> -	__copy_kernel_to_fpregs(&vcpu->arch.guest_fpu->state,
>> -				~XFEATURE_MASK_PKRU);
>> +	/*
>> +	 * An encrypted save area means that the guest state can't be
>> +	 * set by the hypervisor, so skip trying to set it.
>> +	 */
>> +	if (!vcpu->arch.vmsa_encrypted)
>> +		/* PKRU is separately restored in kvm_x86_ops.run. */
>> +		__copy_kernel_to_fpregs(&vcpu->arch.guest_fpu->state,
>> +					~XFEATURE_MASK_PKRU);
>>  
>>  	fpregs_mark_activate();
>>  	fpregs_unlock();
>> @@ -8911,7 +8916,12 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
>>  {
>>  	fpregs_lock();
>>  
>> -	kvm_save_current_fpu(vcpu->arch.guest_fpu);
>> +	/*
>> +	 * An encrypted save area means that the guest state can't be
>> +	 * read/saved by the hypervisor, so skip trying to save it.
>> +	 */
>> +	if (!vcpu->arch.vmsa_encrypted)
>> +		kvm_save_current_fpu(vcpu->arch.guest_fpu);
>>  
>>  	copy_kernel_to_fpregs(&vcpu->arch.user_fpu->state);
>>  
>> -- 
>> 2.28.0
>>
