Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9DEA478B4
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 05:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbfFQDjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jun 2019 23:39:09 -0400
Received: from mga14.intel.com ([192.55.52.115]:28077 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727625AbfFQDjJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jun 2019 23:39:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jun 2019 20:39:08 -0700
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 16 Jun 2019 20:39:05 -0700
Subject: Re: [PATCH v3 2/2] target/i386: Add support for save/load
 IA32_UMWAIT_CONTROL MSR
To:     Tao Xu <tao3.xu@intel.com>, pbonzini@redhat.com, rth@twiddle.net,
        ehabkost@redhat.com
Cc:     cohuck@redhat.com, mst@redhat.com, mtosatti@redhat.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org, jingqi.liu@intel.com
References: <20190616153525.27072-1-tao3.xu@intel.com>
 <20190616153525.27072-3-tao3.xu@intel.com>
From:   Xiaoyao Li <xiaoyao.li@linux.intel.com>
Message-ID: <94f9e831-38a0-3cc3-f566-6c8e5909d0fd@linux.intel.com>
Date:   Mon, 17 Jun 2019 11:39:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190616153525.27072-3-tao3.xu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/16/2019 11:35 PM, Tao Xu wrote:
> UMWAIT and TPAUSE instructions use IA32_UMWAIT_CONTROL at MSR index
> E1H to determines the maximum time in TSC-quanta that the processor
> can reside in either C0.1 or C0.2.
> 
> This patch is to Add support for save/load IA32_UMWAIT_CONTROL MSR in
> guest.
> 
> Co-developed-by: Jingqi Liu <jingqi.liu@intel.com>
> Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>
> Signed-off-by: Tao Xu <tao3.xu@intel.com>
> ---
> 
> no changes in v3:
> ---
>   target/i386/cpu.h     |  2 ++
>   target/i386/kvm.c     | 13 +++++++++++++
>   target/i386/machine.c | 20 ++++++++++++++++++++
>   3 files changed, 35 insertions(+)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 2f7c57a3c2..eb98b2e54a 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -450,6 +450,7 @@ typedef enum X86Seg {
>   
>   #define MSR_IA32_BNDCFGS                0x00000d90
>   #define MSR_IA32_XSS                    0x00000da0
> +#define MSR_IA32_UMWAIT_CONTROL         0xe1
>   
>   #define XSTATE_FP_BIT                   0
>   #define XSTATE_SSE_BIT                  1
> @@ -1348,6 +1349,7 @@ typedef struct CPUX86State {
>       uint16_t fpregs_format_vmstate;
>   
>       uint64_t xss;
> +    uint64_t umwait;
>   
>       TPRAccess tpr_access_type;
>   } CPUX86State;
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 3efdb90f11..506c7cd038 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -91,6 +91,7 @@ static bool has_msr_hv_stimer;
>   static bool has_msr_hv_frequencies;
>   static bool has_msr_hv_reenlightenment;
>   static bool has_msr_xss;
> +static bool has_msr_umwait;
>   static bool has_msr_spec_ctrl;
>   static bool has_msr_virt_ssbd;
>   static bool has_msr_smi_count;
> @@ -1486,6 +1487,9 @@ static int kvm_get_supported_msrs(KVMState *s)
>                   case MSR_IA32_XSS:
>                       has_msr_xss = true;
>                       break;
> +                case MSR_IA32_UMWAIT_CONTROL:
> +                    has_msr_umwait = true;
> +                    break;

Need to add MSR_IA32_UMWAIT_CONTROL into msrs_to_save[] in your kvm 
patches, otherwise qemu never goes into this case.

>                   case HV_X64_MSR_CRASH_CTL:
>                       has_msr_hv_crash = true;
>                       break;
> @@ -2023,6 +2027,9 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>       if (has_msr_xss) {
>           kvm_msr_entry_add(cpu, MSR_IA32_XSS, env->xss);
>       }
> +    if (has_msr_umwait) {
> +        kvm_msr_entry_add(cpu, MSR_IA32_UMWAIT_CONTROL, env->umwait);
> +    }
>       if (has_msr_spec_ctrl) {
>           kvm_msr_entry_add(cpu, MSR_IA32_SPEC_CTRL, env->spec_ctrl);
>       }
> @@ -2416,6 +2423,9 @@ static int kvm_get_msrs(X86CPU *cpu)
>       if (has_msr_xss) {
>           kvm_msr_entry_add(cpu, MSR_IA32_XSS, 0);
>       }
> +    if (has_msr_umwait) {
> +        kvm_msr_entry_add(cpu, MSR_IA32_UMWAIT_CONTROL, 0);
> +    }
>       if (has_msr_spec_ctrl) {
>           kvm_msr_entry_add(cpu, MSR_IA32_SPEC_CTRL, 0);
>       }
> @@ -2665,6 +2675,9 @@ static int kvm_get_msrs(X86CPU *cpu)
>           case MSR_IA32_XSS:
>               env->xss = msrs[i].data;
>               break;
> +        case MSR_IA32_UMWAIT_CONTROL:
> +            env->umwait = msrs[i].data;
> +            break;
>           default:
>               if (msrs[i].index >= MSR_MC0_CTL &&
>                   msrs[i].index < MSR_MC0_CTL + (env->mcg_cap & 0xff) * 4) {
> diff --git a/target/i386/machine.c b/target/i386/machine.c
> index 4aff1a763f..db388b6b85 100644
> --- a/target/i386/machine.c
> +++ b/target/i386/machine.c
> @@ -810,6 +810,25 @@ static const VMStateDescription vmstate_xss = {
>       }
>   };
>   
> +static bool umwait_needed(void *opaque)
> +{
> +    X86CPU *cpu = opaque;
> +    CPUX86State *env = &cpu->env;
> +
> +    return env->umwait != 0;
> +}
> +
> +static const VMStateDescription vmstate_umwait = {
> +    .name = "cpu/umwait",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .needed = umwait_needed,
> +    .fields = (VMStateField[]) {
> +        VMSTATE_UINT64(env.umwait, X86CPU),
> +        VMSTATE_END_OF_LIST()
> +    }
> +};
> +
>   #ifdef TARGET_X86_64
>   static bool pkru_needed(void *opaque)
>   {
> @@ -1100,6 +1119,7 @@ VMStateDescription vmstate_x86_cpu = {
>           &vmstate_msr_hyperv_reenlightenment,
>           &vmstate_avx512,
>           &vmstate_xss,
> +        &vmstate_umwait,
>           &vmstate_tsc_khz,
>           &vmstate_msr_smi_count,
>   #ifdef TARGET_X86_64
> 
