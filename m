Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493762B09BC
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 17:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbgKLQTr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 11:19:47 -0500
Received: from mail-dm6nam10on2081.outbound.protection.outlook.com ([40.107.93.81]:3200
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728414AbgKLQTq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Nov 2020 11:19:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRz2xdWxgRFRZCcaw2uprGTqk05jWY2HixsUUAH2uUM9Knlp2FsKvmNWKJaxjDFRlj8G/Kw6X/aCRbAC1U2CgWb6XYWmQGrLdYAQcNVhYUzORgeuyBKMemF9SWPbeUANKwR2cNleZBdrrI5gKzxlRM3MEuFwcrsmAqVJltzMm4D6JfDuJ8ireZGfkbm5mPVhyYFyuf8LrQWX6DhqZs9E8oNMws9QOZ6tv/5GxhycSoTy3iNKxb0zIjvGFwUAttj7nXEgAFMz4iyhtRUcvv8MpHxCzFtrencgqkP9M7bpL11+YXCHpdPtYe6WYWXKyWHQPYBzmyUm2fW5D1GPIgH58A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YobjNSdPsEcGAKoX3tYRjhRKMSXIPRFxtpLF2YUItvw=;
 b=hkAxFLNPw0UL4KBA+ZRYCoNpEUyzpqFxVRXruEG/uM0fg02wq1KijqdHr1U4KJa7w5zgxPm+j6uhYL19JFl0XkFfIVWlWktErCcgDEFabGQC/ahdVErSCao4IuM5YGjBAoOuM0EmI65JB2hw3jxcDq/dm6rE+sWJD9T/19bqPUJAxW4pmsJGRiADot4KWMmwu5gYGQw+V4Wotj1PLEWs7oPGxz6bDoHJN1pfEMOPpZQ6Ge2welJS5DiGbsyJsnM/+InUPReIGU+ps/jWp1cWrMGmnm41CtU/flh32gRnJxKxzabk1Gy7Cz53/TfaXd6KvM7lW5OT7MVVdP8mFSgcAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YobjNSdPsEcGAKoX3tYRjhRKMSXIPRFxtpLF2YUItvw=;
 b=i7XDUMxcWNxrm4pj2b8oyL7zXIAWSEz2+4CZt3KeWzhwp2S/FMKwWeYzXn7eCLutlP1+Vz4ZRn3oLfpsQQw7OkbBNoBGa8X/vqimhkrDJHdA3PpNAFllIm6FwVveoZ3moIjw9FD3B9QSBXxM1zF9GxRUkSu4WAaR92xnTI/WpNc=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN6PR12MB4702.namprd12.prod.outlook.com (2603:10b6:805:e4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.24; Thu, 12 Nov
 2020 16:19:43 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece%3]) with mapi id 15.20.3541.026; Thu, 12 Nov 2020
 16:19:43 +0000
Subject: Re: [PATCH 2/2] KVM:SVM: Mask SEV encryption bit from CR3 reserved
 bits
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     junaids@google.com, wanpengli@tencent.com, kvm@vger.kernel.org,
        joro@8bytes.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de, vkuznets@redhat.com,
        jmattson@google.com
References: <160514082171.31583.9995411273370528911.stgit@bmoger-ubuntu>
 <160514090654.31583.12433653224184517852.stgit@bmoger-ubuntu>
 <09c5a083-a841-7d0e-f315-1d480e929957@redhat.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <48cd9218-cc30-65b6-343c-804dea427e30@amd.com>
Date:   Thu, 12 Nov 2020 10:19:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <09c5a083-a841-7d0e-f315-1d480e929957@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR20CA0039.namprd20.prod.outlook.com
 (2603:10b6:3:13d::25) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by DM5PR20CA0039.namprd20.prod.outlook.com (2603:10b6:3:13d::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25 via Frontend Transport; Thu, 12 Nov 2020 16:19:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 051bbb14-0d78-4a80-935a-08d88726c356
X-MS-TrafficTypeDiagnostic: SN6PR12MB4702:
X-Microsoft-Antispam-PRVS: <SN6PR12MB47021348066CDC24B41944A495E70@SN6PR12MB4702.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FiHY5PhOLssPd3n9VkyNJoo2RxnxD/zvwypHgBF1B/Noe024cQgqyQ8QkGTwWOxlZz0+/wznkEQiIwhMDaZCjRs+eN0sY6WUrXD0By52CVRFc0qx1LFdhFhdzzmyVm+FoQCaQagb2oFpIax6VWjpZt2omjRaQPqbIR03bNC6gLWiHOoktW/+fHOTpcmRCuKuYMgATUkyzIH4MrVEdaJSTqpcVgHrnNY85wNScuqrYP3gA+HPICqLNWrMECJhaauZP7kGUwOJgjU1gVMS7kpm6+hPBgXFIz2BK5df6UuaPUrs+aDjch5TGzEoflYp2YGWJU7d0GekTXqZVFmuxH6X41F+SBkdWqHT2ShOs6SW4Gwxz1UUmI5CvrU470hMGEHF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(376002)(366004)(66946007)(66556008)(66476007)(7416002)(4326008)(5660300002)(86362001)(6916009)(52116002)(478600001)(36756003)(53546011)(316002)(44832011)(16576012)(26005)(8936002)(186003)(956004)(2616005)(83380400001)(31696002)(8676002)(16526019)(6486002)(2906002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: MCJPFRescswFgFGSOifpn1oNL5K0FxkGIBAlfyjWGJbK+dBTdxEc9uHh4vYr5NNNyw1rosZudWScoXwyWJ5gNg7qWHzK6QoXDuzMP+Zm3tFTdyt+71b1GqnMx9cCns89N9uAtXsT7MGkj78hNaC+8aWMqPWKVmdZLbKIblE2om+WiiFep74kwRV57qSY4aCXWTwcoTfLW2S2bq1ZGih/5lDHL02qU6/OWDt8LSFfnutYQdryjyad5vKlHYXffG7vKJd+rXeCoMwrcONg6GMcvCRuZGX7LygefjFF5ekxKpAjW6aXZ7g2ywbIG9dJt9JED59XwUDkBCEHskL4sBvx4ISHjVTN8kuqOiSbMY2D+a4gO55oVmR84zC/+eHK1TRkn3XUehUxYeoUkxYQfX3k/rfqJVX65zLWbPeX2nFaesqgFaeqAilSoswTZYU+5d3gFIfXd7zgM436r6RX2ic5TR4aWhSiS3xHFLMey0PHiKrY59KFa2gPoI7I0YEe5AXxLZKh1Bkalt/GojsWWKFtxkNDL/+bMMuhVeeIjV3zRx7rjAfcovJMm6yC+HIVD1UfqOgyKHKAJORzG9DSB+d4Esqgz+Y7rQilLGxjpq06m3Ltp4a11OQ+lxqFxEa5SOmed+oysCrY5j4hX+JzDXDdFw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 051bbb14-0d78-4a80-935a-08d88726c356
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2020 16:19:43.3910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LrBEt6akSJq04gulwL2byJWlsVg+t5AuX4lW/B0PJzzbg23vUyfDkj+br2OGUMpZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4702
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/12/20 2:32 AM, Paolo Bonzini wrote:
> On 12/11/20 01:28, Babu Moger wrote:
>> Add support to the mask_cr3_rsvd_bits() callback to mask the
>> encryption bit from the CR3 value when SEV is enabled.
>>
>> Additionally, cache the encryption mask for quick access during
>> the check.
>>
>> Fixes: a780a3ea628268b2 ("KVM: X86: Fix reserved bits check for MOV to
>> CR3")
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> ---
>>   arch/x86/kvm/svm/svm.c |   11 ++++++++++-
>>   arch/x86/kvm/svm/svm.h |    3 +++
>>   2 files changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index a491a47d7f5c..c2b1e52810c6 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3741,6 +3741,7 @@ static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu,
>> gfn_t gfn, bool is_mmio)
>>   static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>   {
>>       struct vcpu_svm *svm = to_svm(vcpu);
>> +    struct kvm_cpuid_entry2 *best;
>>         vcpu->arch.xsaves_enabled = guest_cpuid_has(vcpu,
>> X86_FEATURE_XSAVE) &&
>>                       boot_cpu_has(X86_FEATURE_XSAVE) &&
>> @@ -3771,6 +3772,12 @@ static void svm_vcpu_after_set_cpuid(struct
>> kvm_vcpu *vcpu)
>>       if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
>>           kvm_request_apicv_update(vcpu->kvm, false,
>>                        APICV_INHIBIT_REASON_NESTED);
>> +
>> +    best = kvm_find_cpuid_entry(vcpu, 0x8000001F, 0);
>> +    if (best)
>> +        svm->sev_enc_mask = ~(1UL << (best->ebx & 0x3f));
>> +    else
>> +        svm->sev_enc_mask = ~0UL;
>>   }
>>     static bool svm_has_wbinvd_exit(void)
>> @@ -4072,7 +4079,9 @@ static void enable_smi_window(struct kvm_vcpu *vcpu)
>>     static unsigned long svm_mask_cr3_rsvd_bits(struct kvm_vcpu *vcpu,
>> unsigned long cr3)
>>   {
>> -    return cr3;
>> +    struct vcpu_svm *svm = to_svm(vcpu);
>> +
>> +    return sev_guest(vcpu->kvm) ? (cr3 & svm->sev_enc_mask) : cr3;
>>   }
>>     static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void
>> *insn, int insn_len)
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index 1d853fe4c778..57a36645a0e4 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -152,6 +152,9 @@ struct vcpu_svm {
>>       u64 *avic_physical_id_cache;
>>       bool avic_is_running;
>>   +    /* SEV Memory encryption mask */
>> +    unsigned long sev_enc_mask;
>> +
>>       /*
>>        * Per-vcpu list of struct amd_svm_iommu_ir:
>>        * This is used mainly to store interrupt remapping information used
>>
> 
> Instead of adding a new callback, you can add a field to struct
> kvm_vcpu_arch:
> 
>      if (is_long_mode(vcpu) &&
> -        (cr3 & rsvd_bits(cpuid_maxphyaddr(vcpu), 63)))
> +        (cr3 & vcpu->arch.cr3_lm_rsvd_bits))
> 
> Set it in kvm_vcpu_after_set_cpuid, and clear the memory encryption bit in
> kvm_x86_ops.vcpu_after_set_cpuid.

Yes. That should work. Will resubmit the patches. Thanks
