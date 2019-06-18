Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC2FB49C44
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 10:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbfFRIoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 04:44:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46522 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbfFRIoe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 04:44:34 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 38BA8308FC4B;
        Tue, 18 Jun 2019 08:44:26 +0000 (UTC)
Received: from work-vm (ovpn-117-76.ams2.redhat.com [10.36.117.76])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B7F662926;
        Tue, 18 Jun 2019 08:44:23 +0000 (UTC)
Date:   Tue, 18 Jun 2019 09:44:20 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, mtosatti@redhat.com,
        rth@twiddle.net, ehabkost@redhat.com, kvm@vger.kernel.org,
        jmattson@google.com, maran.wilson@oracle.com
Subject: Re: [QEMU PATCH v3 4/9] KVM: i386: Block migration for vCPUs exposed
 with nested virtualization
Message-ID: <20190618084420.GA2850@work-vm>
References: <20190617175658.135869-1-liran.alon@oracle.com>
 <20190617175658.135869-5-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617175658.135869-5-liran.alon@oracle.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 18 Jun 2019 08:44:34 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Liran Alon (liran.alon@oracle.com) wrote:
> Commit d98f26073beb ("target/i386: kvm: add VMX migration blocker")
> added a migration blocker for vCPU exposed with Intel VMX.
> However, migration should also be blocked for vCPU exposed with
> AMD SVM.
> 
> Both cases should be blocked because QEMU should extract additional
> vCPU state from KVM that should be migrated as part of vCPU VMState.
> E.g. Whether vCPU is running in guest-mode or host-mode.
> 
> Fixes: d98f26073beb ("target/i386: kvm: add VMX migration blocker")
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  target/i386/cpu.c |  6 ------
>  target/i386/cpu.h | 24 ++++++++++++++++++++++++
>  target/i386/kvm.c | 12 ++++++------
>  3 files changed, 30 insertions(+), 12 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 536d7d152044..197201087e65 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -5170,12 +5170,6 @@ static int x86_cpu_filter_features(X86CPU *cpu)
>      return rv;
>  }
>  
> -#define IS_INTEL_CPU(env) ((env)->cpuid_vendor1 == CPUID_VENDOR_INTEL_1 && \
> -                           (env)->cpuid_vendor2 == CPUID_VENDOR_INTEL_2 && \
> -                           (env)->cpuid_vendor3 == CPUID_VENDOR_INTEL_3)
> -#define IS_AMD_CPU(env) ((env)->cpuid_vendor1 == CPUID_VENDOR_AMD_1 && \
> -                         (env)->cpuid_vendor2 == CPUID_VENDOR_AMD_2 && \
> -                         (env)->cpuid_vendor3 == CPUID_VENDOR_AMD_3)
>  static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
>  {
>      CPUState *cs = CPU(dev);
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index fce6660bac00..79d9495ceb0c 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -728,6 +728,13 @@ typedef uint32_t FeatureWordArray[FEATURE_WORDS];
>  
>  #define CPUID_VENDOR_HYGON    "HygonGenuine"
>  
> +#define IS_INTEL_CPU(env) ((env)->cpuid_vendor1 == CPUID_VENDOR_INTEL_1 && \
> +                           (env)->cpuid_vendor2 == CPUID_VENDOR_INTEL_2 && \
> +                           (env)->cpuid_vendor3 == CPUID_VENDOR_INTEL_3)
> +#define IS_AMD_CPU(env) ((env)->cpuid_vendor1 == CPUID_VENDOR_AMD_1 && \
> +                         (env)->cpuid_vendor2 == CPUID_VENDOR_AMD_2 && \
> +                         (env)->cpuid_vendor3 == CPUID_VENDOR_AMD_3)
> +
>  #define CPUID_MWAIT_IBE     (1U << 1) /* Interrupts can exit capability */
>  #define CPUID_MWAIT_EMX     (1U << 0) /* enumeration supported */
>  
> @@ -1866,6 +1873,23 @@ static inline int32_t x86_get_a20_mask(CPUX86State *env)
>      }
>  }
>  
> +static inline bool cpu_has_vmx(CPUX86State *env)
> +{
> +    return (IS_INTEL_CPU(env) &&
> +            (env->features[FEAT_1_ECX] & CPUID_EXT_VMX));
> +}
> +
> +static inline bool cpu_has_svm(CPUX86State *env)
> +{
> +    return (IS_AMD_CPU(env) &&
> +            (env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_SVM));

Note that the Hygon Dhyana seems to have SVM set as well, see
target/i386/cpu.c and search for "Dhyana"

(Note the AMD users are going to be a bit more surprised by this
restriction than Intel users, since Nested has been enabled on AMD for a
long time).

Dave

> +}
> +
> +static inline bool cpu_has_nested_virt(CPUX86State *env)
> +{
> +    return (cpu_has_vmx(env) || cpu_has_svm(env));
> +}
> +
>  /* fpu_helper.c */
>  void update_fp_status(CPUX86State *env);
>  void update_mxcsr_status(CPUX86State *env);
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index c8fd53055d37..f43e2d69859e 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -906,7 +906,7 @@ static int hyperv_init_vcpu(X86CPU *cpu)
>  }
>  
>  static Error *invtsc_mig_blocker;
> -static Error *vmx_mig_blocker;
> +static Error *nested_virt_mig_blocker;
>  
>  #define KVM_MAX_CPUID_ENTRIES  100
>  
> @@ -1270,13 +1270,13 @@ int kvm_arch_init_vcpu(CPUState *cs)
>                                    !!(c->ecx & CPUID_EXT_SMX);
>      }
>  
> -    if ((env->features[FEAT_1_ECX] & CPUID_EXT_VMX) && !vmx_mig_blocker) {
> -        error_setg(&vmx_mig_blocker,
> -                   "Nested VMX virtualization does not support live migration yet");
> -        r = migrate_add_blocker(vmx_mig_blocker, &local_err);
> +    if (cpu_has_nested_virt(env) && !nested_virt_mig_blocker) {
> +        error_setg(&nested_virt_mig_blocker,
> +                   "Nested virtualization does not support live migration yet");
> +        r = migrate_add_blocker(nested_virt_mig_blocker, &local_err);
>          if (local_err) {
>              error_report_err(local_err);
> -            error_free(vmx_mig_blocker);
> +            error_free(nested_virt_mig_blocker);
>              return r;
>          }
>      }
> -- 
> 2.20.1
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
