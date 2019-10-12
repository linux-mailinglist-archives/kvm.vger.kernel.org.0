Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7600D4C5D
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2019 05:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfJLDOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Oct 2019 23:14:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42328 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbfJLDOK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Oct 2019 23:14:10 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6D4A3307D989;
        Sat, 12 Oct 2019 03:14:09 +0000 (UTC)
Received: from localhost (ovpn-116-20.phx2.redhat.com [10.3.116.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA0C76092D;
        Sat, 12 Oct 2019 03:14:08 +0000 (UTC)
Date:   Sat, 12 Oct 2019 00:14:07 -0300
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Luwei Kang <luwei.kang@intel.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        rth@twiddle.net, mtosatti@redhat.com,
        Chao Peng <chao.p.peng@linux.intel.com>
Subject: Re: [PATCH v4 2/2] i386: Add support to get/set/migrate Intel
 Processor Trace feature
Message-ID: <20191012031407.GK4084@habkost.net>
References: <1520182116-16485-1-git-send-email-luwei.kang@intel.com>
 <1520182116-16485-2-git-send-email-luwei.kang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1520182116-16485-2-git-send-email-luwei.kang@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Sat, 12 Oct 2019 03:14:09 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 05, 2018 at 12:48:36AM +0800, Luwei Kang wrote:
> From: Chao Peng <chao.p.peng@linux.intel.com>
> 
> Add Intel Processor Trace related definition. It also add
> corresponding part to kvm_get/set_msr and vmstate.
> 
> Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
> Signed-off-by: Luwei Kang <luwei.kang@intel.com>
[...]
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index f9f4cd1..097c953 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -1811,6 +1811,25 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>                  kvm_msr_entry_add(cpu, MSR_MTRRphysMask(i), mask);
>              }
>          }
> +        if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) {
> +            int addr_num = kvm_arch_get_supported_cpuid(kvm_state,
> +                                                    0x14, 1, R_EAX) & 0x7;
> +
> +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_CTL,
> +                            env->msr_rtit_ctrl);
> +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_STATUS,
> +                            env->msr_rtit_status);
> +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_OUTPUT_BASE,
> +                            env->msr_rtit_output_base);

This causes the following crash on some hosts:

  qemu-system-x86_64: error: failed to set MSR 0x560 to 0x0
  qemu-system-x86_64: target/i386/kvm.c:2673: kvm_put_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.

Checking for CPUID_7_0_EBX_INTEL_PT is not enough: KVM has
additional conditions that might prevent writing to this MSR
(PT_CAP_topa_output && PT_CAP_single_range_output).  This causes
QEMU to crash if some of the conditions aren't met.

Writing and reading this MSR (and the ones below) need to be
conditional on KVM_GET_MSR_INDEX_LIST.


> +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_OUTPUT_MASK,
> +                            env->msr_rtit_output_mask);
> +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_CR3_MATCH,
> +                            env->msr_rtit_cr3_match);
> +            for (i = 0; i < addr_num; i++) {
> +                kvm_msr_entry_add(cpu, MSR_IA32_RTIT_ADDR0_A + i,
> +                            env->msr_rtit_addrs[i]);
> +            }
> +        }
>  
>          /* Note: MSR_IA32_FEATURE_CONTROL is written separately, see
>           *       kvm_put_msr_feature_control. */
> @@ -2124,6 +2143,20 @@ static int kvm_get_msrs(X86CPU *cpu)
>          }
>      }
>  
> +    if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) {
> +        int addr_num =
> +            kvm_arch_get_supported_cpuid(kvm_state, 0x14, 1, R_EAX) & 0x7;
> +
> +        kvm_msr_entry_add(cpu, MSR_IA32_RTIT_CTL, 0);
> +        kvm_msr_entry_add(cpu, MSR_IA32_RTIT_STATUS, 0);
> +        kvm_msr_entry_add(cpu, MSR_IA32_RTIT_OUTPUT_BASE, 0);
> +        kvm_msr_entry_add(cpu, MSR_IA32_RTIT_OUTPUT_MASK, 0);
> +        kvm_msr_entry_add(cpu, MSR_IA32_RTIT_CR3_MATCH, 0);
> +        for (i = 0; i < addr_num; i++) {
> +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_ADDR0_A + i, 0);
> +        }
> +    }
> +
>      ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_MSRS, cpu->kvm_msr_buf);
>      if (ret < 0) {
>          return ret;
> @@ -2364,6 +2397,24 @@ static int kvm_get_msrs(X86CPU *cpu)
>          case MSR_IA32_SPEC_CTRL:
>              env->spec_ctrl = msrs[i].data;
>              break;
> +        case MSR_IA32_RTIT_CTL:
> +            env->msr_rtit_ctrl = msrs[i].data;
> +            break;
> +        case MSR_IA32_RTIT_STATUS:
> +            env->msr_rtit_status = msrs[i].data;
> +            break;
> +        case MSR_IA32_RTIT_OUTPUT_BASE:
> +            env->msr_rtit_output_base = msrs[i].data;
> +            break;
> +        case MSR_IA32_RTIT_OUTPUT_MASK:
> +            env->msr_rtit_output_mask = msrs[i].data;
> +            break;
> +        case MSR_IA32_RTIT_CR3_MATCH:
> +            env->msr_rtit_cr3_match = msrs[i].data;
> +            break;
> +        case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
> +            env->msr_rtit_addrs[index - MSR_IA32_RTIT_ADDR0_A] = msrs[i].data;
> +            break;
>          }
>      }
>  
> diff --git a/target/i386/machine.c b/target/i386/machine.c
> index 361c05a..c05fe6f 100644
> --- a/target/i386/machine.c
> +++ b/target/i386/machine.c
> @@ -837,6 +837,43 @@ static const VMStateDescription vmstate_spec_ctrl = {
>      }
>  };
>  
> +static bool intel_pt_enable_needed(void *opaque)
> +{
> +    X86CPU *cpu = opaque;
> +    CPUX86State *env = &cpu->env;
> +    int i;
> +
> +    if (env->msr_rtit_ctrl || env->msr_rtit_status ||
> +        env->msr_rtit_output_base || env->msr_rtit_output_mask ||
> +        env->msr_rtit_cr3_match) {
> +        return true;
> +    }
> +
> +    for (i = 0; i < MAX_RTIT_ADDRS; i++) {
> +        if (env->msr_rtit_addrs[i]) {
> +            return true;
> +        }
> +    }
> +
> +    return false;
> +}
> +
> +static const VMStateDescription vmstate_msr_intel_pt = {
> +    .name = "cpu/intel_pt",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .needed = intel_pt_enable_needed,
> +    .fields = (VMStateField[]) {
> +        VMSTATE_UINT64(env.msr_rtit_ctrl, X86CPU),
> +        VMSTATE_UINT64(env.msr_rtit_status, X86CPU),
> +        VMSTATE_UINT64(env.msr_rtit_output_base, X86CPU),
> +        VMSTATE_UINT64(env.msr_rtit_output_mask, X86CPU),
> +        VMSTATE_UINT64(env.msr_rtit_cr3_match, X86CPU),
> +        VMSTATE_UINT64_ARRAY(env.msr_rtit_addrs, X86CPU, MAX_RTIT_ADDRS),
> +        VMSTATE_END_OF_LIST()
> +    }
> +};
> +
>  VMStateDescription vmstate_x86_cpu = {
>      .name = "cpu",
>      .version_id = 12,
> @@ -957,6 +994,7 @@ VMStateDescription vmstate_x86_cpu = {
>  #endif
>          &vmstate_spec_ctrl,
>          &vmstate_mcg_ext_ctl,
> +        &vmstate_msr_intel_pt,
>          NULL
>      }
>  };
> -- 
> 1.8.3.1
> 

-- 
Eduardo
