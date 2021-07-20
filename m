Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88233D0445
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 00:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhGTV2L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 17:28:11 -0400
Received: from mail-mw2nam10on2059.outbound.protection.outlook.com ([40.107.94.59]:9600
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230083AbhGTV2G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jul 2021 17:28:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eOxes4JBNSDRYNOeueoyWFj8ISfszm4zcNqrCYEMa1ZTGRKDMkeD9dTkIqRhb/vclLDV32XlUX9UjDH2hN8I/uMZWWBqh+6irCcuSnESofY7c/9g+5VS+77KSDWdzD1jyKrmevwvGGRy4861SjNXK5u8taGPDCO5/sUHyt1dPe/jBlw0SxRjdOenbGBVx66lTsEdnxOfm/yOYb7U5oXLP57jDlSnrs5PeAN+QAHmfFbFFzKCWYplKut9ljcirThEVKxIMwxM4t0A6v4SfKtzf1c+PUksK2ZItxnz5cjJmAGz0i/C2ZZcHO6tqnLvrGUXSeWcmxqfaJvRPrdYlyTOvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=StzZI9MnA5qHQ1IHRtZTAXwM7Uny9yhnQXOxViENKa0=;
 b=cxjaPUCwvD/LwrSQxMXUcKmvHpYPINsREfJ4sIgXoewZILbHx6uNqrgLUp4soxFdEzLZ+q1+AaEQsGEZ0/t+XkHC4jUdzwjAl7/8zZ2iTI1X41h5fE3P0vUM/tLV2K5JqgLYNjifmArxglQNWq5z0Wcwbt8i/ANg8oF1xwr/ybJd0MAOfgvgQm3J1b/JmwNaFLJwhtdfeEAlCQleN9DT/p0kow5GbhBSDtI/9fJvxydkhn3kU7a7HcXpJOhngyztROCz5yO9VEPgAP56ErDQIlYJg+4XUNAaD3QfSJkReHk1Aj3gVCmFvQbsZDEGs0b5AIIC4Cmi2hiKojgvsVh51Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=StzZI9MnA5qHQ1IHRtZTAXwM7Uny9yhnQXOxViENKa0=;
 b=I43wKmCDvsD8J4nwcNpCw2oTaxlteivOdbIfJLtTn1ggHpjpBQLpjPStuAv6B9fdvej5RnD+kJ13hRIpL6TbUz/Ecea+b7dkZxjP1K4jzJ5myl9zHLcVPQBMp1tWaICl49OPHCpE5+YfVPU5qd4G+VSUThSXgtLkh7PAvl+WbFM=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5376.namprd12.prod.outlook.com (2603:10b6:5:39a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.32; Tue, 20 Jul
 2021 22:08:27 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::73:2581:970b:3208]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::73:2581:970b:3208%3]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 22:08:27 +0000
Subject: Re: [RFC PATCH v2 24/69] KVM: x86: Introduce "protected guest"
 concept and block disallowed ioctls
To:     Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <482264f17fa0652faad9bd5364d652d11cb2ecb8.1625186503.git.isaku.yamahata@intel.com>
 <02ca73b2-7f04-813d-5bb7-649c0edafa06@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <209a57e9-ca9c-3939-4aaa-4602e3dd7cdd@amd.com>
Date:   Tue, 20 Jul 2021 17:08:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <02ca73b2-7f04-813d-5bb7-649c0edafa06@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0118.namprd05.prod.outlook.com
 (2603:10b6:803:42::35) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.241] (165.204.77.1) by SN4PR0501CA0118.namprd05.prod.outlook.com (2603:10b6:803:42::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.11 via Frontend Transport; Tue, 20 Jul 2021 22:08:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 645a326a-30f3-4eb1-7123-08d94bcae61b
X-MS-TrafficTypeDiagnostic: DM4PR12MB5376:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5376200E2C48B81017A41CEDECE29@DM4PR12MB5376.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5LQiBfwLceTXY2A8iPQWTMfxVyOCOH+UaKBeF0ajiB4mey457ioS+p59j3Kru0/P4D096XhCVuB+wik4KoXmNq+fcEF17yuqg4ffjqYyT4CzmUm9EyY+2iP+FpbAjtqJBob7iit4FRXKi1NLnsxa/O0mfsFzyr0yUKD+8D2+UcuYpHmjQJAh78gZQKLC13mh6M1+PBd49mSCjeBJjw6x2kzvn64FPCixHI/RTmGw0b9ONGvuFhluT0eYDlWSvGWHqIwUSwLmKxlZ5l1F2dlawBsR6bOFzZCoCMTW0YmaaJfMRXBJJHhvgPlmUfW3Czpw2Gs4RSe6qSl1Z9M9RqQpNwhRVV5wwl3UrPOx52TVouEedH5oUHaWwBpll9oGkMMP0vieb2dylP0tlWzioJhtFpLX6MjHtZrCfKTODIK2cqjXgjYzhmvAySnCrXKdX9aZGvDMENls3U78f0lvL31rurHPCfSzb0W5nLZRMhiDAICDmTpuiK+Li2S5X3P5JC7FWRBlfrMwgOOlc+E/xrkAK5k/uHENkNATrC0wd5HjdH7TfeDYUygPNIZ9HJnHBGPpttgI9Xcvbhe5vm2hZ4yruEI8NqmSCUq2KCZdtC6Svgr+qsUKZxSJ2q4zdTtHKKHmfrXyssV8zDJRYcEHS3nuc+NxRVT7Z5XgPxMgkNjZyhFnY+2Bi7Sd/PWILtPJa49x0Jfr17b5Gs+/5zG+uv+nS6ERgtb+T/KJ7qYz2CxNaVHxcMpV8qj49bNcwaqMPp3L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(39850400004)(396003)(346002)(84040400004)(8936002)(316002)(4326008)(16576012)(110136005)(31686004)(66556008)(921005)(38100700002)(83380400001)(26005)(478600001)(54906003)(66476007)(31696002)(66946007)(2906002)(53546011)(30864003)(6486002)(956004)(2616005)(8676002)(5660300002)(186003)(86362001)(36756003)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGxaKzNybVY3Y0RUUmJEOGZtU0dEOVFtUklqZFBKSTJyNTNnRGRtdzBCRzlD?=
 =?utf-8?B?eDdTYlhDSUo2djU1Z2dPNk0wVVRrQ0VmeDNKQWprL3Y1L2pBZm9VLzl6N3B4?=
 =?utf-8?B?QzdhUnVPTTlPS1pxb3RwL3NHWm9oVE1FNk5vU0tGSHFrckVTaDJDVUxvaDl3?=
 =?utf-8?B?QStsYnlyWFBSU09pZ2RkTk9tOVBoMWlZcllBbHlsU3B0WVhEdUhKQUZORmRi?=
 =?utf-8?B?R0JHZk1qY21CYStNT20rN3lPWS8ycHd0eDNVTHBJWUtjbmdDSkVEL0ZRZFZ2?=
 =?utf-8?B?ZjZ1dHRiams3SUNTTUljdVNTU3A0Vjh0VjZKUC9uUkg0MTBxYy9lM2luR2NW?=
 =?utf-8?B?V0xxL2NJOFNUOVhXcTVKUWlTNkxVUUwrMzNHamFrOGFGM2pjcHBRMFhxNXRv?=
 =?utf-8?B?SWNjRjdpZlRmWXpRc3BPYkp1SnNicFZ4d095RXZJYmtmbzdhd0pPeVpMSEhi?=
 =?utf-8?B?R2pDTk44UTlsdTN5dDRDaUp2YWFJQlVraWlTVHhtYVRkTmtiTHMwMlVmU0hj?=
 =?utf-8?B?QThkYVRZUld2YysyaFlZUTdmek9LOHpnWjJvbkhyZWNQVlo2NmRXaENRSEFm?=
 =?utf-8?B?TGkvQzlSWktrdmVHUzdlNFAzenVFb1BVdWtrb1hMMzArWUlvcXo1b3ZWeGNE?=
 =?utf-8?B?Q2VIM3hCUkdsYU91RjBiVVFVZ1owMTNmWC9HY1RYcEdIOXd0VkkyUS9jUkZM?=
 =?utf-8?B?dmkzQnVmL0FvekhzK3hCWmtERjUyYkdZRWlSSHhHZzlRclA5Z2xYdWZtMStI?=
 =?utf-8?B?Qk5PeE5Ha2tNanFYamUrZWp4NEl5RmkwTjEyakEwZVdNRU10d1RWME14aStC?=
 =?utf-8?B?RHJhM3l6ZXFnaFBhWkh1clJCSDI3TjZBT0h3Rno4NjhaZk9RWW5FYjNGVDZy?=
 =?utf-8?B?TVNraWxKUzl0L3F4d1ZVc3gwOTZrRk1LSVR1VmtvWGFCRUU3TjRmRWFiSjh0?=
 =?utf-8?B?c0tnWkpUMS9Idm9zTEFRUDZoWTBqYkkzU1B5dFNwRmlEQmJXdVlMaTFqbllp?=
 =?utf-8?B?cHZCTGNDTmxZRU9EOVhVUzBpSytUOEZudzlzT2ZXUGZlTUp0cmMvWjZCODZH?=
 =?utf-8?B?Q0tCODBJS1IyTm4yUlc3R0kwTXVwZTJOMlZrWE9xZHYvbmdueWRtdWpYREN4?=
 =?utf-8?B?ci9WbkVQNzFkbUx0ZnFMcUNLcWh1MDgyTXdSb3hlVmFUUDNMdlRjdWc3L2FX?=
 =?utf-8?B?ekFNL09yZm9ZTzY1Qm5QbXdXeFQ3TWYyL1RacVFzMWZWZXFDWGluTmdJQkty?=
 =?utf-8?B?cERZZGpaTjVETFBoYnlOVUhULzZId1NHd3J4SG16ZThnVm91UlB0Y2ZaM2JF?=
 =?utf-8?B?OUcxMzRpblR0MWs4dWRLcDJvYlBLc1EwOW91UXphN0FmK1A3NEk0TDJBRU9N?=
 =?utf-8?B?cjc0bEJZOExSN2dRVDNwT1dObTJQTzRucE9FQkNNa08va3l0RDkva000MTJu?=
 =?utf-8?B?QkNXZy9VSVE4VmJraDIrZ3FzS0xTenAvSkFob1RaRW9ZdVBiZDNGQzJVV2pD?=
 =?utf-8?B?R0wrYVR4Sk5WQUZWWHl3M0wrcnA5enR4VTYzMHFmNjZPVm5LM05UL3JsT0Vq?=
 =?utf-8?B?RWVVVGhaMEIvdTNhOExOa05GSFNUYVVsK29VR05GN1Rpbi9rSGRpVlBDVllJ?=
 =?utf-8?B?QkYvWnVLNWxNTVVPdlVHUzVIQTIxZytlT0xVczk2RmY5Z3k5ZkRjQ1R5VGJ3?=
 =?utf-8?B?cmZaU05MRU5uWnlNMXEvTjVsU2Z6Njg0bThnZ0VZRXBTSXQ3NThhOHFIeVpL?=
 =?utf-8?Q?lKkDeFpavOS+88mOpZq1cOlHw4girLvwDI+V0cn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 645a326a-30f3-4eb1-7123-08d94bcae61b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 22:08:26.9305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FP6+qiP4oRyLfIYCZL/paDe99a7D5/ejWF1YS2/vn79VrXLi/yd8aylhfcfDMRcLxthYR3aQNu/quRLz2msm2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5376
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/6/21 8:59 AM, Paolo Bonzini wrote:
> On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>
>> Add 'guest_state_protected' to mark a VM's state as being protected by
>> hardware/firmware, e.g. SEV-ES or TDX-SEAM.  Use the flag to disallow
>> ioctls() and/or flows that attempt to access protected state.
>>
>> Return an error if userspace attempts to get/set register state for a
>> protected VM, e.g. a non-debug TDX guest.  KVM can't provide sane data,
>> it's userspace's responsibility to avoid attempting to read guest state
>> when it's known to be inaccessible.
>>
>> Retrieving vCPU events is the one exception, as the userspace VMM is
>> allowed to inject NMIs.
>>
>> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> ---
>>   arch/x86/kvm/x86.c | 104 +++++++++++++++++++++++++++++++++++++--------
>>   1 file changed, 86 insertions(+), 18 deletions(-)
> 
> Looks good, but it should be checked whether it breaks QEMU for SEV-ES.
>  Tom, can you help?

Sorry to take so long to get back to you... been really slammed, let me
look into this a bit more. But, some quick thoughts...

Offhand, the SMI isn't a problem since SEV-ES doesn't support SMM.

For kvm_vcpu_ioctl_x86_{get,set}_xsave(), can TDX use what was added for
SEV-ES:
  ed02b213098a ("KVM: SVM: Guest FPU state save/restore not needed for SEV-ES guest")

Same for kvm_arch_vcpu_ioctl_{get,set}_fpu().

The changes to kvm_arch_vcpu_ioctl_{get,set}_sregs() might cause issues,
since there are specific things allowed in __{get,set}_sregs. But I'll
need to dig a bit more on that.

Thanks,
Tom

> 
> Paolo
> 
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 271245ffc67c..b89845dfb679 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4297,6 +4297,10 @@ static int kvm_vcpu_ioctl_nmi(struct kvm_vcpu *vcpu)
>>     static int kvm_vcpu_ioctl_smi(struct kvm_vcpu *vcpu)
>>   {
>> +    /* TODO: use more precise flag */
>> +    if (vcpu->arch.guest_state_protected)
>> +        return -EINVAL;
>> +
>>       kvm_make_request(KVM_REQ_SMI, vcpu);
>>         return 0;
>> @@ -4343,6 +4347,10 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct
>> kvm_vcpu *vcpu,
>>       unsigned bank_num = mcg_cap & 0xff;
>>       u64 *banks = vcpu->arch.mce_banks;
>>   +    /* TODO: use more precise flag */
>> +    if (vcpu->arch.guest_state_protected)
>> +        return -EINVAL;
>> +
>>       if (mce->bank >= bank_num || !(mce->status & MCI_STATUS_VAL))
>>           return -EINVAL;
>>       /*
>> @@ -4438,7 +4446,8 @@ static void
>> kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
>>           vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft;
>>       events->interrupt.nr = vcpu->arch.interrupt.nr;
>>       events->interrupt.soft = 0;
>> -    events->interrupt.shadow =
>> static_call(kvm_x86_get_interrupt_shadow)(vcpu);
>> +    if (!vcpu->arch.guest_state_protected)
>> +        events->interrupt.shadow =
>> static_call(kvm_x86_get_interrupt_shadow)(vcpu);
>>         events->nmi.injected = vcpu->arch.nmi_injected;
>>       events->nmi.pending = vcpu->arch.nmi_pending != 0;
>> @@ -4467,11 +4476,17 @@ static void kvm_smm_changed(struct kvm_vcpu *vcpu);
>>   static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>>                             struct kvm_vcpu_events *events)
>>   {
>> -    if (events->flags & ~(KVM_VCPUEVENT_VALID_NMI_PENDING
>> -                  | KVM_VCPUEVENT_VALID_SIPI_VECTOR
>> -                  | KVM_VCPUEVENT_VALID_SHADOW
>> -                  | KVM_VCPUEVENT_VALID_SMM
>> -                  | KVM_VCPUEVENT_VALID_PAYLOAD))
>> +    u32 allowed_flags = KVM_VCPUEVENT_VALID_NMI_PENDING |
>> +                KVM_VCPUEVENT_VALID_SIPI_VECTOR |
>> +                KVM_VCPUEVENT_VALID_SHADOW |
>> +                KVM_VCPUEVENT_VALID_SMM |
>> +                KVM_VCPUEVENT_VALID_PAYLOAD;
>> +
>> +    /* TODO: introduce more precise flag */
>> +    if (vcpu->arch.guest_state_protected)
>> +        allowed_flags = KVM_VCPUEVENT_VALID_NMI_PENDING;
>> +
>> +    if (events->flags & ~allowed_flags)
>>           return -EINVAL;
>>         if (events->flags & KVM_VCPUEVENT_VALID_PAYLOAD) {
>> @@ -4552,17 +4567,22 @@ static int
>> kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>>       return 0;
>>   }
>>   -static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
>> -                         struct kvm_debugregs *dbgregs)
>> +static int kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
>> +                        struct kvm_debugregs *dbgregs)
>>   {
>>       unsigned long val;
>>   +    if (vcpu->arch.guest_state_protected)
>> +        return -EINVAL;
>> +
>>       memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
>>       kvm_get_dr(vcpu, 6, &val);
>>       dbgregs->dr6 = val;
>>       dbgregs->dr7 = vcpu->arch.dr7;
>>       dbgregs->flags = 0;
>>       memset(&dbgregs->reserved, 0, sizeof(dbgregs->reserved));
>> +
>> +    return 0;
>>   }
>>     static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
>> @@ -4576,6 +4596,9 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct
>> kvm_vcpu *vcpu,
>>       if (!kvm_dr7_valid(dbgregs->dr7))
>>           return -EINVAL;
>>   +    if (vcpu->arch.guest_state_protected)
>> +        return -EINVAL;
>> +
>>       memcpy(vcpu->arch.db, dbgregs->db, sizeof(vcpu->arch.db));
>>       kvm_update_dr0123(vcpu);
>>       vcpu->arch.dr6 = dbgregs->dr6;
>> @@ -4671,11 +4694,14 @@ static void load_xsave(struct kvm_vcpu *vcpu, u8
>> *src)
>>       }
>>   }
>>   -static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
>> -                     struct kvm_xsave *guest_xsave)
>> +static int kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
>> +                    struct kvm_xsave *guest_xsave)
>>   {
>> +    if (vcpu->arch.guest_state_protected)
>> +        return -EINVAL;
>> +
>>       if (!vcpu->arch.guest_fpu)
>> -        return;
>> +        return 0;
>>         if (boot_cpu_has(X86_FEATURE_XSAVE)) {
>>           memset(guest_xsave, 0, sizeof(struct kvm_xsave));
>> @@ -4687,6 +4713,8 @@ static void kvm_vcpu_ioctl_x86_get_xsave(struct
>> kvm_vcpu *vcpu,
>>           *(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)] =
>>               XFEATURE_MASK_FPSSE;
>>       }
>> +
>> +    return 0;
>>   }
>>     #define XSAVE_MXCSR_OFFSET 24
>> @@ -4697,6 +4725,9 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct
>> kvm_vcpu *vcpu,
>>       u64 xstate_bv;
>>       u32 mxcsr;
>>   +    if (vcpu->arch.guest_state_protected)
>> +        return -EINVAL;
>> +
>>       if (!vcpu->arch.guest_fpu)
>>           return 0;
>>   @@ -4722,18 +4753,22 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct
>> kvm_vcpu *vcpu,
>>       return 0;
>>   }
>>   -static void kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,
>> -                    struct kvm_xcrs *guest_xcrs)
>> +static int kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,
>> +                       struct kvm_xcrs *guest_xcrs)
>>   {
>> +    if (vcpu->arch.guest_state_protected)
>> +        return -EINVAL;
>> +
>>       if (!boot_cpu_has(X86_FEATURE_XSAVE)) {
>>           guest_xcrs->nr_xcrs = 0;
>> -        return;
>> +        return 0;
>>       }
>>         guest_xcrs->nr_xcrs = 1;
>>       guest_xcrs->flags = 0;
>>       guest_xcrs->xcrs[0].xcr = XCR_XFEATURE_ENABLED_MASK;
>>       guest_xcrs->xcrs[0].value = vcpu->arch.xcr0;
>> +    return 0;
>>   }
>>     static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
>> @@ -4741,6 +4776,9 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct
>> kvm_vcpu *vcpu,
>>   {
>>       int i, r = 0;
>>   +    if (vcpu->arch.guest_state_protected)
>> +        return -EINVAL;
>> +
>>       if (!boot_cpu_has(X86_FEATURE_XSAVE))
>>           return -EINVAL;
>>   @@ -5011,7 +5049,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>       case KVM_GET_DEBUGREGS: {
>>           struct kvm_debugregs dbgregs;
>>   -        kvm_vcpu_ioctl_x86_get_debugregs(vcpu, &dbgregs);
>> +        r = kvm_vcpu_ioctl_x86_get_debugregs(vcpu, &dbgregs);
>> +        if (r)
>> +            break;
>>             r = -EFAULT;
>>           if (copy_to_user(argp, &dbgregs,
>> @@ -5037,7 +5077,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>           if (!u.xsave)
>>               break;
>>   -        kvm_vcpu_ioctl_x86_get_xsave(vcpu, u.xsave);
>> +        r = kvm_vcpu_ioctl_x86_get_xsave(vcpu, u.xsave);
>> +        if (r)
>> +            break;
>>             r = -EFAULT;
>>           if (copy_to_user(argp, u.xsave, sizeof(struct kvm_xsave)))
>> @@ -5061,7 +5103,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>           if (!u.xcrs)
>>               break;
>>   -        kvm_vcpu_ioctl_x86_get_xcrs(vcpu, u.xcrs);
>> +        r = kvm_vcpu_ioctl_x86_get_xcrs(vcpu, u.xcrs);
>> +        if (r)
>> +            break;
>>             r = -EFAULT;
>>           if (copy_to_user(argp, u.xcrs,
>> @@ -9735,6 +9779,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>           goto out;
>>       }
>>   +    if (vcpu->arch.guest_state_protected &&
>> +        (kvm_run->kvm_valid_regs || kvm_run->kvm_dirty_regs)) {
>> +        r = -EINVAL;
>> +        goto out;
>> +    }
>> +
>>       if (kvm_run->kvm_dirty_regs) {
>>           r = sync_regs(vcpu);
>>           if (r != 0)
>> @@ -9765,7 +9815,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>     out:
>>       kvm_put_guest_fpu(vcpu);
>> -    if (kvm_run->kvm_valid_regs)
>> +    if (kvm_run->kvm_valid_regs && !vcpu->arch.guest_state_protected)
>>           store_regs(vcpu);
>>       post_kvm_run_save(vcpu);
>>       kvm_sigset_deactivate(vcpu);
>> @@ -9812,6 +9862,9 @@ static void __get_regs(struct kvm_vcpu *vcpu,
>> struct kvm_regs *regs)
>>     int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct
>> kvm_regs *regs)
>>   {
>> +    if (vcpu->arch.guest_state_protected)
>> +        return -EINVAL;
>> +
>>       vcpu_load(vcpu);
>>       __get_regs(vcpu, regs);
>>       vcpu_put(vcpu);
>> @@ -9852,6 +9905,9 @@ static void __set_regs(struct kvm_vcpu *vcpu,
>> struct kvm_regs *regs)
>>     int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct
>> kvm_regs *regs)
>>   {
>> +    if (vcpu->arch.guest_state_protected)
>> +        return -EINVAL;
>> +
>>       vcpu_load(vcpu);
>>       __set_regs(vcpu, regs);
>>       vcpu_put(vcpu);
>> @@ -9912,6 +9968,9 @@ static void __get_sregs(struct kvm_vcpu *vcpu,
>> struct kvm_sregs *sregs)
>>   int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
>>                     struct kvm_sregs *sregs)
>>   {
>> +    if (vcpu->arch.guest_state_protected)
>> +        return -EINVAL;
>> +
>>       vcpu_load(vcpu);
>>       __get_sregs(vcpu, sregs);
>>       vcpu_put(vcpu);
>> @@ -10112,6 +10171,9 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct
>> kvm_vcpu *vcpu,
>>   {
>>       int ret;
>>   +    if (vcpu->arch.guest_state_protected)
>> +        return -EINVAL;
>> +
>>       vcpu_load(vcpu);
>>       ret = __set_sregs(vcpu, sregs);
>>       vcpu_put(vcpu);
>> @@ -10205,6 +10267,9 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu
>> *vcpu, struct kvm_fpu *fpu)
>>   {
>>       struct fxregs_state *fxsave;
>>   +    if (vcpu->arch.guest_state_protected)
>> +        return -EINVAL;
>> +
>>       if (!vcpu->arch.guest_fpu)
>>           return 0;
>>   @@ -10228,6 +10293,9 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct
>> kvm_vcpu *vcpu, struct kvm_fpu *fpu)
>>   {
>>       struct fxregs_state *fxsave;
>>   +    if (vcpu->arch.guest_state_protected)
>> +        return -EINVAL;
>> +
>>       if (!vcpu->arch.guest_fpu)
>>           return 0;
>>  
> 
