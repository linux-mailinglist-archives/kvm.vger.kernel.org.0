Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711221F7DF3
	for <lists+kvm@lfdr.de>; Fri, 12 Jun 2020 22:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgFLUHI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jun 2020 16:07:08 -0400
Received: from mail-dm6nam10on2089.outbound.protection.outlook.com ([40.107.93.89]:29198
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726268AbgFLUHH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jun 2020 16:07:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hT43n5whl/1fiyuAKKWrjVmBGnZDz1QmdaKU2l9ujJwX8EGQNS8ofaW5lp9lKsH+JDcNbnY5RsgXtj/J/koXJ/Su9bslHgFQj6GcdbGIP0ULjmhznr2ALs07wbUM2iBtwffBXYovCsE5e6BQtxj3Ew/ZmepN1HIWOoKfMMkL8Q3ZZ3RmxWCay1iU1RaxZY2nCZtdYF/l/8ILm1vh7kRhNtoXzP9sCHZECsRJYkbM7EAsk9XDiElRKfyaczlPgVZmcb/Zmy+RJGSwzMGWmTW9jaBhySAvR3kuHmDhQFJsX+HZLowS60zAeQFuBt5ghb+5SfaV17zNUTdzO41iafgRrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CScYqAgFB/p5mnHNFBqzG8lXeqgSZkxwTh1uPb6QmRo=;
 b=aBivlMxmn7Rz8oBS3qU487Jaa38Lx8t8CAYn0o3vkQVrECBrw2h4k5dfzoZeoNhkvjgmMx4akS624PYSk3HkxaSz9f1nYA4w2qWVkR+jbn0uUZ2NVC0f+59dhRlnJF94W5bXRcuAXNH98EoNW5z4eq2FT2drZWhxVFB2oKXIAW8H4G5uZekG1w2NFi9yQT4fY5gkSA3Am7VE2qzad8NZutJ28dUyUUsEd0R4PM5VsAswMbmbMsMh3IJ2QSe0DZ3YXR8HudO99qY8zyDcnSM+2jAo8MMNQYJkgGf/1UEBKzBvAsZatOByo7D9VORkU+7HoJpeIyC438cW3UwpWIUc1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CScYqAgFB/p5mnHNFBqzG8lXeqgSZkxwTh1uPb6QmRo=;
 b=NJQBgxio7ZWzQCWGVip8HRn8tr0RinUSZzch9l43BBsozryFu27e01sIvxDXvT66KAuE4JmUY4o6oD8maUe/ixLYPtKWwf6JYv6RcX7FjeRaDLXQDClfNQwsqzD9UiBOIE32gTpZCHa4llfDZta2E4fftQT4oAjaAWujBUY+BBw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4464.namprd12.prod.outlook.com (2603:10b6:806:9f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.21; Fri, 12 Jun
 2020 20:07:02 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2%3]) with mapi id 15.20.3088.021; Fri, 12 Jun 2020
 20:07:02 +0000
Subject: Re: [PATCH 1/3] KVM: X86: Move handling of INVPCID types to x86
To:     Jim Mattson <jmattson@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
References: <159191202523.31436.11959784252237488867.stgit@bmoger-ubuntu>
 <159191211555.31436.7157754769653935735.stgit@bmoger-ubuntu>
 <CALMp9eQrC5a2oquCPerEm29p482mik7Zbh=o74waTY6xqXZohA@mail.gmail.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <281e219d-07f2-6d10-f93b-fb5b19e71a21@amd.com>
Date:   Fri, 12 Jun 2020 15:06:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <CALMp9eQrC5a2oquCPerEm29p482mik7Zbh=o74waTY6xqXZohA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0080.prod.exchangelabs.com (2603:10b6:800::48) To
 SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.79] (165.204.77.1) by SN2PR01CA0080.prod.exchangelabs.com (2603:10b6:800::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18 via Frontend Transport; Fri, 12 Jun 2020 20:06:59 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ba938c27-def1-4c1a-c4ea-08d80f0c2af0
X-MS-TrafficTypeDiagnostic: SA0PR12MB4464:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4464B7F9B0049F4EE083FB1595810@SA0PR12MB4464.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0432A04947
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kU8XBHCqtMXFkn0VJKWC6SMmLBwEsOgB6qbhSt55UCNM5vgTZ4mAd/XHPJUOFxzvaNqTLB0OUFeuOUarfnddIQ8oPSBUeMSrS8bxuuWEOtE6XHN4TcLr+7o4g3TfcPyInfc6S7Kc3zp629ES7vaLn4iJ0B7TlZ1/OTRQJeOcosOKvfbrA5MwmVN6U0XiFh8vN91KEehDSd2K+kzNCtfT7T18xmdZV8F9Qn89Yk+PtFa1dcmRhLiYvzn09Kfvn1UoXGNITDHlLewxENuYs2k7+SSSL+BID+kx3m6YDUfeCfuY+5FtwaEFIo9i9rOddM+dpNOCV/k+4Au77lbfwNyd1aBNwIJ6s7THhftzh3YAxs5ylYmSOELeVZOWvpHVeIRN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(346002)(366004)(376002)(66946007)(36756003)(956004)(26005)(44832011)(66556008)(54906003)(16576012)(31696002)(52116002)(16526019)(186003)(316002)(2616005)(83380400001)(5660300002)(86362001)(66476007)(53546011)(2906002)(8676002)(31686004)(6486002)(8936002)(6916009)(4326008)(478600001)(7416002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8EwXCNyeMd4QeY3H0JKPxI0YwsVoO7TvqJejuD7GhwmnPyTADGHfCZ6wKCSUdp/dSXXCVOwq0Y2MtcYqnF54glHB8XI/BAF9XcqzJMSZ9X31voctD+LZaRqkHS6tRNxT1A4Cgbjqsv5fqkiZKakHYIDy05Iu9giiLgMXIClf4QITQx7HtpPkTWLcWYDBxhYPKLEGsaQhfIYBMQPkxhkcJJDuhyVtyVxZ8JEan/NQy8HsJyBNuEvRPZyU6kULSeCLywijo4HVM/b8rNTTzrZ2GqtkPykGibtUyCJ1sdZlB+8+CjjN9e0KDXVSZ30DQpTuur4OFVhIYB8Y+2xMNVHPVTMeUSlfzUwxO2oNonuRlFJoyDEPQAonWX0ZDDbKwa6bsRW0aBlasBAKiRrZ5USFEAq6VtGew6fvStD8OD9X3qDtTuQ1qWa7AjmZmtQIWF5/r4Syn06oXHCK5puaxGBhtJDv1TIVkkJfHL7X7FO3Z8k=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba938c27-def1-4c1a-c4ea-08d80f0c2af0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2020 20:07:01.9304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j0gzf6jGZGeJw6ERhq0j3vMWse+rJyupKN+Z7I3HCaK4Erp4vOnl5Gx86WzeT1Ye
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4464
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/12/20 1:02 PM, Jim Mattson wrote:
> On Thu, Jun 11, 2020 at 2:48 PM Babu Moger <babu.moger@amd.com> wrote:
>>
>> INVPCID instruction handling is mostly same across both VMX and
>> SVM. So, move the code to common x86.c.
>>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> ---
>>  arch/x86/kvm/vmx/vmx.c |   78 +-----------------------------------------
>>  arch/x86/kvm/x86.c     |   89 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  arch/x86/kvm/x86.h     |    2 +
>>  3 files changed, 92 insertions(+), 77 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 170cc76a581f..d9c35f337da6 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -5477,29 +5477,15 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
>>  {
>>         u32 vmx_instruction_info;
>>         unsigned long type;
>> -       bool pcid_enabled;
>>         gva_t gva;
>> -       struct x86_exception e;
>> -       unsigned i;
>> -       unsigned long roots_to_free = 0;
>>         struct {
>>                 u64 pcid;
>>                 u64 gla;
>>         } operand;
>>
>> -       if (!guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
>> -               kvm_queue_exception(vcpu, UD_VECTOR);
>> -               return 1;
>> -       }
>> -
>>         vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
>>         type = kvm_register_readl(vcpu, (vmx_instruction_info >> 28) & 0xf);
>>
>> -       if (type > 3) {
>> -               kvm_inject_gp(vcpu, 0);
>> -               return 1;
>> -       }
>> -
> 
> You've introduced some fault priority inversions by sinking the above
> tests for #UD and #GP below the call to get_vmx_mem_address(), which
> may raise #UD, #GP, or #SS.

oh. Ok. I will restore the old order back. Thanks for spotting it.

> 
>>         /* According to the Intel instruction reference, the memory operand
>>          * is read even if it isn't needed (e.g., for type==all)
>>          */
>> @@ -5508,69 +5494,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
>>                                 sizeof(operand), &gva))
>>                 return 1;
>>
>> -       if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
>> -               kvm_inject_emulated_page_fault(vcpu, &e);
>> -               return 1;
>> -       }
>> -
>> -       if (operand.pcid >> 12 != 0) {
>> -               kvm_inject_gp(vcpu, 0);
>> -               return 1;
>> -       }
>> -
>> -       pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
>> -
>> -       switch (type) {
>> -       case INVPCID_TYPE_INDIV_ADDR:
>> -               if ((!pcid_enabled && (operand.pcid != 0)) ||
>> -                   is_noncanonical_address(operand.gla, vcpu)) {
>> -                       kvm_inject_gp(vcpu, 0);
>> -                       return 1;
>> -               }
>> -               kvm_mmu_invpcid_gva(vcpu, operand.gla, operand.pcid);
>> -               return kvm_skip_emulated_instruction(vcpu);
>> -
>> -       case INVPCID_TYPE_SINGLE_CTXT:
>> -               if (!pcid_enabled && (operand.pcid != 0)) {
>> -                       kvm_inject_gp(vcpu, 0);
>> -                       return 1;
>> -               }
>> -
>> -               if (kvm_get_active_pcid(vcpu) == operand.pcid) {
>> -                       kvm_mmu_sync_roots(vcpu);
>> -                       kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
>> -               }
>> -
>> -               for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
>> -                       if (kvm_get_pcid(vcpu, vcpu->arch.mmu->prev_roots[i].pgd)
>> -                           == operand.pcid)
>> -                               roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
>> -
>> -               kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, roots_to_free);
>> -               /*
>> -                * If neither the current cr3 nor any of the prev_roots use the
>> -                * given PCID, then nothing needs to be done here because a
>> -                * resync will happen anyway before switching to any other CR3.
>> -                */
>> -
>> -               return kvm_skip_emulated_instruction(vcpu);
>> -
>> -       case INVPCID_TYPE_ALL_NON_GLOBAL:
>> -               /*
>> -                * Currently, KVM doesn't mark global entries in the shadow
>> -                * page tables, so a non-global flush just degenerates to a
>> -                * global flush. If needed, we could optimize this later by
>> -                * keeping track of global entries in shadow page tables.
>> -                */
>> -
>> -               /* fall-through */
>> -       case INVPCID_TYPE_ALL_INCL_GLOBAL:
>> -               kvm_mmu_unload(vcpu);
>> -               return kvm_skip_emulated_instruction(vcpu);
>> -
>> -       default:
>> -               BUG(); /* We have already checked above that type <= 3 */
>> -       }
>> +       return kvm_handle_invpcid_types(vcpu,  gva, type);
>>  }
>>
>>  static int handle_pml_full(struct kvm_vcpu *vcpu)
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 9e41b5135340..13373359608c 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -72,6 +72,7 @@
>>  #include <asm/hypervisor.h>
>>  #include <asm/intel_pt.h>
>>  #include <asm/emulate_prefix.h>
>> +#include <asm/tlbflush.h>
>>  #include <clocksource/hyperv_timer.h>
>>
>>  #define CREATE_TRACE_POINTS
>> @@ -10714,6 +10715,94 @@ u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
>>  }
>>  EXPORT_SYMBOL_GPL(kvm_spec_ctrl_valid_bits);
>>
>> +int kvm_handle_invpcid_types(struct kvm_vcpu *vcpu, gva_t gva,
>> +                            unsigned long type)
>> +{
>> +       unsigned long roots_to_free = 0;
>> +       struct x86_exception e;
>> +       bool pcid_enabled;
>> +       unsigned i;
>> +       struct {
>> +               u64 pcid;
>> +               u64 gla;
>> +       } operand;
>> +
>> +       if (!guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
>> +               kvm_queue_exception(vcpu, UD_VECTOR);
>> +               return 1;
>> +       }
>> +
>> +       if (type > 3) {
>> +               kvm_inject_gp(vcpu, 0);
>> +               return 1;
>> +       }
>> +
>> +       if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
>> +               kvm_inject_emulated_page_fault(vcpu, &e);
>> +               return 1;
>> +       }
>> +
>> +       if (operand.pcid >> 12 != 0) {
>> +               kvm_inject_gp(vcpu, 0);
>> +               return 1;
>> +       }
>> +
>> +       pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
>> +
>> +       switch (type) {
>> +       case INVPCID_TYPE_INDIV_ADDR:
>> +               if ((!pcid_enabled && (operand.pcid != 0)) ||
>> +                   is_noncanonical_address(operand.gla, vcpu)) {
>> +                       kvm_inject_gp(vcpu, 0);
>> +                       return 1;
>> +               }
>> +               kvm_mmu_invpcid_gva(vcpu, operand.gla, operand.pcid);
>> +               return kvm_skip_emulated_instruction(vcpu);
>> +
>> +       case INVPCID_TYPE_SINGLE_CTXT:
>> +               if (!pcid_enabled && (operand.pcid != 0)) {
>> +                       kvm_inject_gp(vcpu, 0);
>> +                       return 1;
>> +               }
>> +
>> +               if (kvm_get_active_pcid(vcpu) == operand.pcid) {
>> +                       kvm_mmu_sync_roots(vcpu);
>> +                       kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
>> +               }
>> +
>> +               for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
>> +                       if (kvm_get_pcid(vcpu, vcpu->arch.mmu->prev_roots[i].pgd)
>> +                           == operand.pcid)
>> +                               roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
>> +
>> +               kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, roots_to_free);
>> +               /*
>> +                * If neither the current cr3 nor any of the prev_roots use the
>> +                * given PCID, then nothing needs to be done here because a
>> +                * resync will happen anyway before switching to any other CR3.
>> +                */
>> +
>> +               return kvm_skip_emulated_instruction(vcpu);
>> +
>> +       case INVPCID_TYPE_ALL_NON_GLOBAL:
>> +               /*
>> +                * Currently, KVM doesn't mark global entries in the shadow
>> +                * page tables, so a non-global flush just degenerates to a
>> +                * global flush. If needed, we could optimize this later by
>> +                * keeping track of global entries in shadow page tables.
>> +                */
>> +
>> +               /* fall-through */
>> +       case INVPCID_TYPE_ALL_INCL_GLOBAL:
>> +               kvm_mmu_unload(vcpu);
>> +               return kvm_skip_emulated_instruction(vcpu);
>> +
>> +       default:
>> +               BUG(); /* We have already checked above that type <= 3 */
>> +       }
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_handle_invpcid_types);
>> +
>>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
>>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
>>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index 6eb62e97e59f..8e23f2705344 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -365,5 +365,7 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
>>  void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
>>  u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
>>  bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu);
>> +int kvm_handle_invpcid_types(struct kvm_vcpu *vcpu, gva_t gva,
>> +                            unsigned long type);
>>
>>  #endif
>>
