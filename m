Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1782DD4C2F
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2019 04:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbfJLCme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Oct 2019 22:42:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54208 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727072AbfJLCme (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Oct 2019 22:42:34 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 010492BF02;
        Sat, 12 Oct 2019 02:42:34 +0000 (UTC)
Received: from localhost (ovpn-116-20.phx2.redhat.com [10.3.116.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 94E6D5C1B2;
        Sat, 12 Oct 2019 02:42:33 +0000 (UTC)
Date:   Fri, 11 Oct 2019 23:42:32 -0300
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Luwei Kang <luwei.kang@intel.com>
Cc:     pbonzini@redhat.com, rth@twiddle.net, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] target/i386: Add support for put/get PEBS registers
Message-ID: <20191012024232.GA832@habkost.net>
References: <1567056175-14275-1-git-send-email-luwei.kang@intel.com>
 <1567056175-14275-2-git-send-email-luwei.kang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567056175-14275-2-git-send-email-luwei.kang@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Sat, 12 Oct 2019 02:42:34 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 01:22:55PM +0800, Luwei Kang wrote:
> This patch add a new feature words for IA32_PERF_CAPABILITIES (RO)
> register that serve to expose PEBS output Intel PT feature.
> The registers relate with PEBS need to be set/get when PEBS output
> Intel PT is supported in guest.
> 
> Signed-off-by: Luwei Kang <luwei.kang@intel.com>

Sorry for taking so long to take a look at the series.

What's the status of the kernel KVM patches for this?

> ---
>  target/i386/cpu.c | 20 ++++++++++++++++++++
>  target/i386/cpu.h |  4 ++++
>  target/i386/kvm.c | 36 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 60 insertions(+)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 9e0bac3..7fe34c0 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1244,6 +1244,26 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>              },
>          },
>      },
> +    [FEAT_PERF_CAPABILITIES] = {
> +        .type = MSR_FEATURE_WORD,
> +        .feat_names = {
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            "pebs-output-pt", NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +        },
> +        .msr = {
> +            .index = MSR_IA32_PERF_CAPABILITIES,
> +            .cpuid_dep = {
> +                FEAT_1_ECX,
> +                CPUID_EXT_PDCM,
> +            },
> +        },
> +    },
>  };
>  
>  typedef struct X86RegisterInfo32 {
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index d7cec36..0904004 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -347,6 +347,7 @@ typedef enum X86Seg {
>  #define MSR_IA32_PRED_CMD               0x49
>  #define MSR_IA32_CORE_CAPABILITY        0xcf
>  #define MSR_IA32_ARCH_CAPABILITIES      0x10a
> +#define MSR_IA32_PERF_CAPABILITIES      0x345
>  #define MSR_IA32_TSCDEADLINE            0x6e0
>  
>  #define FEATURE_CONTROL_LOCKED                    (1<<0)
> @@ -503,6 +504,7 @@ typedef enum FeatureWord {
>      FEAT_XSAVE_COMP_HI, /* CPUID[EAX=0xd,ECX=0].EDX */
>      FEAT_ARCH_CAPABILITIES,
>      FEAT_CORE_CAPABILITY,
> +    FEAT_PERF_CAPABILITIES,
>      FEATURE_WORDS,
>  } FeatureWord;
>  
> @@ -754,6 +756,8 @@ typedef uint32_t FeatureWordArray[FEATURE_WORDS];
>  
>  #define MSR_CORE_CAP_SPLIT_LOCK_DETECT  (1U << 5)
>  
> +#define MSR_PERF_CAP_PEBS_VIA_PT        (1ULL << 16)
> +
>  /* Supported Hyper-V Enlightenments */
>  #define HYPERV_FEAT_RELAXED             0
>  #define HYPERV_FEAT_VAPIC               1
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 8023c67..c0dcc13 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -2651,6 +2651,20 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>                  kvm_msr_entry_add(cpu, MSR_IA32_RTIT_ADDR0_A + i,
>                              env->msr_rtit_addrs[i]);
>              }
> +
> +            if (env->features[FEAT_PERF_CAPABILITIES] &
> +                                        MSR_PERF_CAP_PEBS_VIA_PT) {
> +                kvm_msr_entry_add(cpu, MSR_IA32_PEBS_ENABLE,
> +                                env->msr_pebs_enable);
> +                for (i = 0; i < num_architectural_pmu_fixed_counters; i++) {
> +                    kvm_msr_entry_add(cpu, MSR_RELOAD_FIXED_CTR0 + i,
> +                                env->msr_reload_fixed_ctr[i]);
> +                }
> +                for (i = 0; i < num_architectural_pmu_gp_counters; i++) {
> +                    kvm_msr_entry_add(cpu, MSR_RELOAD_PMC0 + i,
> +                                env->msr_reload_pmc[i]);
> +                }
> +            }
>          }
>  
>          /* Note: MSR_IA32_FEATURE_CONTROL is written separately, see
> @@ -2989,6 +3003,16 @@ static int kvm_get_msrs(X86CPU *cpu)
>          for (i = 0; i < addr_num; i++) {
>              kvm_msr_entry_add(cpu, MSR_IA32_RTIT_ADDR0_A + i, 0);
>          }
> +
> +        if (env->features[FEAT_PERF_CAPABILITIES] & MSR_PERF_CAP_PEBS_VIA_PT) {
> +            kvm_msr_entry_add(cpu, MSR_IA32_PEBS_ENABLE, 0);
> +            for (i = 0; i < num_architectural_pmu_fixed_counters; i++) {
> +                kvm_msr_entry_add(cpu, MSR_RELOAD_FIXED_CTR0 + i, 0);
> +            }
> +            for (i = 0; i < num_architectural_pmu_gp_counters; i++) {
> +                kvm_msr_entry_add(cpu, MSR_RELOAD_PMC0 + i, 0);
> +            }
> +        }
>      }
>  
>      ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_MSRS, cpu->kvm_msr_buf);
> @@ -3268,6 +3292,18 @@ static int kvm_get_msrs(X86CPU *cpu)
>          case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
>              env->msr_rtit_addrs[index - MSR_IA32_RTIT_ADDR0_A] = msrs[i].data;
>              break;
> +        case MSR_IA32_PEBS_ENABLE:
> +            env->msr_pebs_enable = msrs[i].data;
> +            break;
> +        case MSR_RELOAD_FIXED_CTR0 ...
> +                                MSR_RELOAD_FIXED_CTR0 + MAX_FIXED_COUNTERS - 1:
> +            env->msr_reload_fixed_ctr[index - MSR_RELOAD_FIXED_CTR0] =
> +                                                                msrs[i].data;
> +            break;
> +        case MSR_RELOAD_PMC0 ...
> +                                MSR_RELOAD_PMC0 + MAX_GP_COUNTERS - 1:
> +            env->msr_reload_fixed_ctr[index - MSR_RELOAD_PMC0] = msrs[i].data;
> +            break;
>          }
>      }
>  
> -- 
> 1.8.3.1
> 

-- 
Eduardo
