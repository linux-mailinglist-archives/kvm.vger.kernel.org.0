Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E062269DA4D
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 06:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbjBUFOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 00:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbjBUFOR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 00:14:17 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E542FF2E
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 21:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676956455; x=1708492455;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=r5NxBrLxlzfYrU8ZiY2I9orOukvysH0hvluokRcU4Sw=;
  b=DpZvFbPmbMHXLdig+1AUTEGXy8V8UDRbYejby/vcNIDle7rWC2rZk8XB
   lvqRJwZQv7PkbFTneI0fNOKQ1+jjtSKBPQkGm4FlBKSuXOpY/gzdLSqbm
   hvnYSgEIQIwb95rxp9Cph6jfbghKaY3VrcuB2R0T91iiRbDUr2Ny1d8B8
   Mo7BCpIj1cWjkUuJe9M5ajKneoUYG+f7D+kSa5+/7XnOV6b1JbtL10rkM
   QJnRrzEc7yV6RcM3vhOd9pmJ3ya6l9XppSFTfn8hzHqiB536mHr8jPX6T
   Kg0k9M8Yqy9RK6dybxF4rfkT7O0iD4H68s8G4Az47IdcqKVyf/zYBJ6zx
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="331212088"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="331212088"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 21:14:15 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="780861213"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="780861213"
Received: from leiwang7-mobl.ccr.corp.intel.com (HELO [10.238.212.107]) ([10.238.212.107])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 21:14:13 -0800
Message-ID: <219476ab-c8e6-95a8-ee0b-348421362ced@intel.com>
Date:   Tue, 21 Feb 2023 13:14:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.1
Subject: Re: [PATCH v3 6/8] target/i386/intel-pt: Enable host pass through of
 Intel PT
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20221208062513.2589476-1-xiaoyao.li@intel.com>
 <20221208062513.2589476-7-xiaoyao.li@intel.com>
From:   "Wang, Lei" <lei4.wang@intel.com>
Content-Language: en-US
In-Reply-To: <20221208062513.2589476-7-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/8/2022 2:25 PM, Xiaoyao Li wrote:
> commit e37a5c7fa459 ("i386: Add Intel Processor Trace feature support")
> added the support of Intel PT by making CPUID[14] of PT as fixed feature
> set (from ICX) for any CPU model on any host. This truly breaks the PT
> exposure on Intel SPR platform because SPR has less supported bitmap of
> CPUID(0x14,1):EBX[15:0] than ICX.
> 
> To fix the problem, enable pass through of host's PT capabilities for
> the cases "-cpu host/max" that it won't use default fixed PT feature set
> of ICX but expand automatically based on get_supported_cpuid reported by
> host. Meanwhile, it needs to ensure named CPU model still has the fixed
> PT feature set to not break the live migration case of
> "-cpu named_cpu_model,+intel-pt"
> 
> Introduces env->use_default_intel_pt flag.
>  - True means it's old CPU model that uses fixed PT feature set of ICX.
>  - False means the named CPU model has its own PT feature set.
> 
> Besides, to keep the same behavior for old CPU models that validate PT
> feature set against default fixed PT feature set of ICX in addition to
> validate from host's capabilities (via get_supported_cpuid) in
> x86_cpu_filter_features().
> 
> In the future, new named CPU model, e.g., Sapphire Rapids, can define
> its own PT feature set by setting @has_specific_intel_pt_feature_set to
> true and defines it's own FEAT_14_0_EBX, FEAT_14_0_ECX, FEAT_14_1_EAX
> and FEAT_14_1_EBX.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  target/i386/cpu.c | 71 ++++++++++++++++++++++++++---------------------
>  target/i386/cpu.h |  1 +
>  2 files changed, 40 insertions(+), 32 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index e302cbbebfc5..24f3c7b06698 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -5194,6 +5194,21 @@ static void x86_cpu_load_model(X86CPU *cpu, X86CPUModel *model)
>          env->features[w] = def->features[w];
>      }
>  
> +    /*
> +     * All (old) named CPU models have the same default values for INTEL_PT_*
> +     *
> +     * Assign the default value here since we don't want to manually copy/paste
> +     * it to all entries in builtin_x86_defs.
> +     */
> +    if (!env->features[FEAT_14_0_EBX] && !env->features[FEAT_14_0_ECX] &&
> +        !env->features[FEAT_14_1_EAX] && !env->features[FEAT_14_1_EBX]) {
> +        env->use_default_intel_pt = true;
> +        env->features[FEAT_14_0_EBX] = INTEL_PT_DEFAULT_0_EBX;
> +        env->features[FEAT_14_0_ECX] = INTEL_PT_DEFAULT_0_ECX;
> +        env->features[FEAT_14_1_EAX] = INTEL_PT_DEFAULT_1_EAX;
> +        env->features[FEAT_14_1_EBX] = INTEL_PT_DEFAULT_1_EBX;
> +    }
> +
>      /* legacy-cache defaults to 'off' if CPU model provides cache info */
>      cpu->legacy_cache = !def->cache_info;
>  
> @@ -5716,14 +5731,11 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>  
>          if (count == 0) {
>              *eax = INTEL_PT_MAX_SUBLEAF;
> -            *ebx = INTEL_PT_DEFAULT_0_EBX;
> -            *ecx = INTEL_PT_DEFAULT_0_ECX;
> -            if (env->features[FEAT_14_0_ECX] & CPUID_14_0_ECX_LIP) {
> -                *ecx |= CPUID_14_0_ECX_LIP;
> -            }
> +            *ebx = env->features[FEAT_14_0_EBX];
> +            *ecx = env->features[FEAT_14_0_ECX];
>          } else if (count == 1) {
> -            *eax = INTEL_PT_DEFAULT_1_EAX;
> -            *ebx = INTEL_PT_DEFAULT_1_EBX;
> +            *eax = env->features[FEAT_14_1_EAX];
> +            *ebx = env->features[FEAT_14_1_EBX];
>          }
>          break;
>      }
> @@ -6425,6 +6437,7 @@ static void x86_cpu_filter_features(X86CPU *cpu, bool verbose)
>      CPUX86State *env = &cpu->env;
>      FeatureWord w;
>      const char *prefix = NULL;
> +    uint64_t host_feat;
>  
>      if (verbose) {
>          prefix = accel_uses_host_cpuid()
> @@ -6433,8 +6446,7 @@ static void x86_cpu_filter_features(X86CPU *cpu, bool verbose)
>      }
>  
>      for (w = 0; w < FEATURE_WORDS; w++) {
> -        uint64_t host_feat =
> -            x86_cpu_get_supported_feature_word(w, false);
> +        host_feat = x86_cpu_get_supported_feature_word(w, false);
>          uint64_t requested_features = env->features[w];
>          uint64_t unavailable_features;
>  
> @@ -6458,31 +6470,26 @@ static void x86_cpu_filter_features(X86CPU *cpu, bool verbose)
>          mark_unavailable_features(cpu, w, unavailable_features, prefix);
>      }
>  
> -    if ((env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) &&
> -        kvm_enabled()) {
> -        KVMState *s = CPU(cpu)->kvm_state;
> -        uint32_t eax_0 = kvm_arch_get_supported_cpuid(s, 0x14, 0, R_EAX);
> -        uint32_t ebx_0 = kvm_arch_get_supported_cpuid(s, 0x14, 0, R_EBX);
> -        uint32_t ecx_0 = kvm_arch_get_supported_cpuid(s, 0x14, 0, R_ECX);
> -        uint32_t eax_1 = kvm_arch_get_supported_cpuid(s, 0x14, 1, R_EAX);
> -        uint32_t ebx_1 = kvm_arch_get_supported_cpuid(s, 0x14, 1, R_EBX);
> -
> -        if (!eax_0 ||
> -           ((ebx_0 & INTEL_PT_DEFAULT_0_EBX) != INTEL_PT_DEFAULT_0_EBX) ||
> -           ((ecx_0 & INTEL_PT_DEFAULT_0_ECX) != INTEL_PT_DEFAULT_0_ECX) ||
> -           ((eax_1 & INTEL_PT_DEFAULT_MTC_BITMAP) != INTEL_PT_DEFAULT_MTC_BITMAP) ||
> -           ((eax_1 & INTEL_PT_ADDR_RANGES_NUM_MASK) <
> -                                      INTEL_PT_DEFAULT_ADDR_RANGES_NUM) ||
> -           ((ebx_1 & INTEL_PT_DEFAULT_1_EBX) != INTEL_PT_DEFAULT_1_EBX) ||
> -           ((ecx_0 & CPUID_14_0_ECX_LIP) !=
> -                (env->features[FEAT_14_0_ECX] & CPUID_14_0_ECX_LIP))) {
> -            /*
> -             * Processor Trace capabilities aren't configurable, so if the
> -             * host can't emulate the capabilities we report on
> -             * cpu_x86_cpuid(), intel-pt can't be enabled on the current host.
> -             */
> +    if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) {
> +        /*
> +         * env->use_default_intel_pt is true means the CPU model doesn't have
> +         * INTEL_PT_* specified. In this case, we need to check it has the
> +         * value of default INTEL_PT to not break live migration
> +         */
> +        if (env->use_default_intel_pt &&
> +            ((env->features[FEAT_14_0_EBX] != INTEL_PT_DEFAULT_0_EBX) ||

When will the env->use_default_intel_pt be true and env->features[FEAT_14_0_EBX]
!= INTEL_PT_DEFAULT_0_EBX? It seems they will always be equal if
env->use_default_intel_pt is true according to your code above.

> +             ((env->features[FEAT_14_0_ECX] & ~CPUID_14_0_ECX_LIP) !=
> +              INTEL_PT_DEFAULT_0_ECX) ||
> +             (env->features[FEAT_14_1_EAX] != INTEL_PT_DEFAULT_1_EAX) ||
> +             (env->features[FEAT_14_1_EBX] != INTEL_PT_DEFAULT_1_EBX))) {
>              mark_unavailable_features(cpu, FEAT_7_0_EBX, CPUID_7_0_EBX_INTEL_PT, prefix);
>          }
> +
> +        host_feat = x86_cpu_get_supported_feature_word(FEAT_14_0_ECX, false);
> +        if ((env->features[FEAT_14_0_ECX] ^ host_feat) & CPUID_14_0_ECX_LIP) {
> +            warn_report("Cannot configure different Intel PT IP payload format than hardware");
> +            mark_unavailable_features(cpu, FEAT_7_0_EBX, CPUID_7_0_EBX_INTEL_PT, NULL);
> +        }
>      }
>  }
>  
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 93fb5a87b40e..91a3971c1c29 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1784,6 +1784,7 @@ typedef struct CPUArchState {
>      uint32_t cpuid_vendor2;
>      uint32_t cpuid_vendor3;
>      uint32_t cpuid_version;
> +    bool use_default_intel_pt;
>      FeatureWordArray features;
>      /* Features that were explicitly enabled/disabled */
>      FeatureWordArray user_features;
