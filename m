Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091DB546EA6
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 22:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347415AbiFJUsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 16:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347010AbiFJUso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 16:48:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8A9E117E15
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 13:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654894120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tG6/YMPLKbLdglovMiXh4lWEYt8RMVI/N8rDwxGKhDM=;
        b=hpD63t0VTkvsspD9YNzkM3GKlD65D7LGXTSyj+Jqv6zUWTMK33mx98irTm218eq2inVJwE
        Xod/MPg3AI7IQaAExzo7rYfvPNCFzTQwWLXaMjaPuYyA0RCsOB7IYkle/AK6yWsvZfRBbj
        Vqqu429RtcqnO7I++0BQLlgzQEL5DN0=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-114-3lbWaELXPiK1MclTe6VJJA-1; Fri, 10 Jun 2022 16:48:39 -0400
X-MC-Unique: 3lbWaELXPiK1MclTe6VJJA-1
Received: by mail-qv1-f72.google.com with SMTP id j2-20020a0cfd42000000b0045ad9cba5deso318618qvs.5
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 13:48:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tG6/YMPLKbLdglovMiXh4lWEYt8RMVI/N8rDwxGKhDM=;
        b=MGtyYcMkL3zL3zjCXJmkBdq9NgNvjspvIPL2N+BpmIUH8YYG+4B8GB185YBx/Vmw/t
         mg0fWvwXo5jNcfObPZRQvEuQHmZgEt/vVQPeEqnR0AUSWPq6yPRYSWXjnuwLdVxpK8uc
         xVKVMW3n2cDeH5BmzuziV8AUWI1YzRqzaom6AoHHFsBAKzENh7sCd+Oel4lXmyWLVqEA
         /jttb6aFlS6u2oieLLIEM/90OQQ127P246Km8ulpA1EhhZA/O/rNfvcgxaVbY22hYXSw
         qg7dcNEbcSxaaauwfXT0rtPmmgc3eUvLtHL30IxzZNCbwuGisheoOLy4DRed5ZZVuNi4
         5bYA==
X-Gm-Message-State: AOAM530JndctlnDT5JEw6EGZGSixthxjH4uG7g2Pom/ryImEe7hjnPt7
        h3ni7s0qNOedmIK2AMELjwc3VJp8i6E7ZiWVrDdurlY6SNMRs6CexYV6ccBM3blTWGxrR9MeFP5
        w+OawhJjuMa8/
X-Received: by 2002:a05:620a:12a8:b0:6a6:b12c:88bc with SMTP id x8-20020a05620a12a800b006a6b12c88bcmr22172286qki.336.1654894118905;
        Fri, 10 Jun 2022 13:48:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmF0JMik+i2p9IHqZpM6JWfgy/KVBRsSrYCyx4uC0YVKyEc2o1M7N3miRwhPrsU8AifquoMw==
X-Received: by 2002:a05:620a:12a8:b0:6a6:b12c:88bc with SMTP id x8-20020a05620a12a800b006a6b12c88bcmr22172271qki.336.1654894118565;
        Fri, 10 Jun 2022 13:48:38 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id u9-20020a05620a430900b006a60190ed0fsm317025qko.74.2022.06.10.13.48.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jun 2022 13:48:37 -0700 (PDT)
Message-ID: <a3d0a093-3d59-5882-c9c8-6619e5aeb3ab@redhat.com>
Date:   Fri, 10 Jun 2022 22:48:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH RFC 1/2] arm/kvm: enable MTE if available
Content-Language: en-US
To:     Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220512131146.78457-1-cohuck@redhat.com>
 <20220512131146.78457-2-cohuck@redhat.com>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20220512131146.78457-2-cohuck@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Connie,
On 5/12/22 15:11, Cornelia Huck wrote:
> We need to disable migration, as we do not yet have a way to migrate
> the tags as well.

This patch does much more than adding a migration blocker ;-) you may
describe the new cpu option and how it works.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  target/arm/cpu.c     | 18 ++++------
>  target/arm/cpu.h     |  4 +++
>  target/arm/cpu64.c   | 78 ++++++++++++++++++++++++++++++++++++++++++++
>  target/arm/kvm64.c   |  5 +++
>  target/arm/kvm_arm.h | 12 +++++++
>  target/arm/monitor.c |  1 +
>  6 files changed, 106 insertions(+), 12 deletions(-)
> 
> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index 029f644768b1..f0505815b1e7 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -1435,6 +1435,11 @@ void arm_cpu_finalize_features(ARMCPU *cpu, Error **errp)
>              error_propagate(errp, local_err);
>              return;
>          }
> +        arm_cpu_mte_finalize(cpu, &local_err);
> +        if (local_err != NULL) {
> +            error_propagate(errp, local_err);
> +            return;
> +        }
>      }
>  
>      if (kvm_enabled()) {
> @@ -1504,7 +1509,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
>          }
>          if (cpu->tag_memory) {
>              error_setg(errp,
> -                       "Cannot enable KVM when guest CPUs has MTE enabled");
> +                       "Cannot enable KVM when guest CPUs has tag memory enabled");
before this series, tag_memory was used to detect MTE was enabled at
machine level. And this was not compatible with KVM.

Hasn't it changed now with this series? Sorry I don't know much about
that tag_memory along with the KVM use case? Can you describe it as well
in the cover letter.
>              return;
>          }
>      }
> @@ -1882,17 +1887,6 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
>                                         ID_PFR1, VIRTUALIZATION, 0);
>      }
>  
> -#ifndef CONFIG_USER_ONLY
> -    if (cpu->tag_memory == NULL && cpu_isar_feature(aa64_mte, cpu)) {
> -        /*
> -         * Disable the MTE feature bits if we do not have tag-memory
> -         * provided by the machine.
> -         */
> -        cpu->isar.id_aa64pfr1 =
> -            FIELD_DP64(cpu->isar.id_aa64pfr1, ID_AA64PFR1, MTE, 0);
> -    }
> -#endif
> -
>      /* MPU can be configured out of a PMSA CPU either by setting has-mpu
>       * to false or by setting pmsav7-dregion to 0.
>       */
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index 18ca61e8e25b..183506713e96 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -208,11 +208,13 @@ typedef struct {
>  void arm_cpu_sve_finalize(ARMCPU *cpu, Error **errp);
>  void arm_cpu_pauth_finalize(ARMCPU *cpu, Error **errp);
>  void arm_cpu_lpa2_finalize(ARMCPU *cpu, Error **errp);
> +void arm_cpu_mte_finalize(ARMCPU *cpu, Error **errp);
>  #else
>  # define ARM_MAX_VQ    1
>  static inline void arm_cpu_sve_finalize(ARMCPU *cpu, Error **errp) { }
>  static inline void arm_cpu_pauth_finalize(ARMCPU *cpu, Error **errp) { }
>  static inline void arm_cpu_lpa2_finalize(ARMCPU *cpu, Error **errp) { }
> +static inline void arm_cpu_mte_finalize(ARMCPU *cpu, Error **errp) { }
>  #endif
>  
>  typedef struct ARMVectorReg {
> @@ -993,6 +995,7 @@ struct ArchCPU {
>      bool prop_pauth;
>      bool prop_pauth_impdef;
>      bool prop_lpa2;
> +    bool prop_mte;
>  
>      /* DCZ blocksize, in log_2(words), ie low 4 bits of DCZID_EL0 */
>      uint32_t dcz_blocksize;
> @@ -1091,6 +1094,7 @@ void aarch64_sve_change_el(CPUARMState *env, int old_el,
>                             int new_el, bool el0_a64);
>  void aarch64_add_sve_properties(Object *obj);
>  void aarch64_add_pauth_properties(Object *obj);
> +void aarch64_add_mte_properties(Object *obj);
>  
>  /*
>   * SVE registers are encoded in KVM's memory in an endianness-invariant format.
> diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
> index 04427e073f17..eea9ad195470 100644
> --- a/target/arm/cpu64.c
> +++ b/target/arm/cpu64.c
> @@ -35,7 +35,11 @@
>  #include "qapi/visitor.h"
>  #include "hw/qdev-properties.h"
>  #include "internals.h"
> +#include "migration/blocker.h"
>  
> +#ifdef CONFIG_KVM
> +static Error *mte_migration_blocker;
> +#endif
>  
>  static void aarch64_a57_initfn(Object *obj)
>  {
> @@ -785,6 +789,78 @@ void arm_cpu_lpa2_finalize(ARMCPU *cpu, Error **errp)
>      cpu->isar.id_aa64mmfr0 = t;
>  }
>  
> +static Property arm_cpu_mte_property =
> +    DEFINE_PROP_BOOL("mte", ARMCPU, prop_mte, true);
> +
> +void aarch64_add_mte_properties(Object *obj)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +
> +    /*
> +     * For tcg, the machine type may provide tag memory for MTE emulation.
s/machine type/machine?
> +     * We do not know whether that is the case at this point in time, so
> +     * default MTE to on and check later.
> +     * This preserves pre-existing behaviour, but is really a bit awkward.
> +     */
> +    qdev_property_add_static(DEVICE(obj), &arm_cpu_mte_property);
> +    if (kvm_enabled()) {
> +        /*
> +         * Default MTE to off, as long as migration support is not
> +         * yet implemented.
> +         * TODO: implement migration support for kvm
> +         */
> +        cpu->prop_mte = false;
> +    }
> +}
> +
> +void arm_cpu_mte_finalize(ARMCPU *cpu, Error **errp)
> +{
> +    if (!cpu->prop_mte) {
> +        /* Disable MTE feature bits. */
> +        cpu->isar.id_aa64pfr1 =
> +            FIELD_DP64(cpu->isar.id_aa64pfr1, ID_AA64PFR1, MTE, 0);
> +        return;
> +    }
> +#ifndef CONFIG_USER_ONLY
> +    if (!kvm_enabled()) {
> +        if (cpu_isar_feature(aa64_mte, cpu) && !cpu->tag_memory) {
> +            /*
> +             * Disable the MTE feature bits, unless we have tag-memory
> +             * provided by the machine.
> +             * This silent downgrade is not really nice if the user had
> +             * explicitly requested MTE to be enabled by the cpu, but it
> +             * preserves pre-existing behaviour. In an ideal world, we


Can't we "simply" prevent the end-user from using the prop_mte option
with a TCG CPU? and have something like

For TCG, MTE depends on the CPU feature availability + machine tag memory
For KVM, MTE depends on the user opt-in + CPU feature avail (if
relevant) + host VM capability (?)

But maybe I miss the point ...
> +             * would fail if MTE was requested, but no tag memory has
> +             * been provided.
> +             */
> +            cpu->isar.id_aa64pfr1 =
> +                FIELD_DP64(cpu->isar.id_aa64pfr1, ID_AA64PFR1, MTE, 0);
> +        }
> +        if (!cpu_isar_feature(aa64_mte, cpu)) {
> +            cpu->prop_mte = false;
> +        }
> +        return;
> +    }
> +    if (kvm_arm_mte_supported()) {
> +#ifdef CONFIG_KVM
> +        if (kvm_vm_enable_cap(kvm_state, KVM_CAP_ARM_MTE, 0)) {
> +            error_setg(errp, "Failed to enable KVM_CAP_ARM_MTE");
> +        } else {
> +            /* TODO: add proper migration support with MTE enabled */
> +            if (!mte_migration_blocker) {
> +                error_setg(&mte_migration_blocker,
> +                           "Live migration disabled due to MTE enabled");
> +                if (migrate_add_blocker(mte_migration_blocker, NULL)) {
error_free(mte_migration_blocker);
mte_migration_blocker = NULL;
> +                    error_setg(errp, "Failed to add MTE migration blocker");
> +                }
> +            }
> +        }
> +#endif
> +    }
> +    /* When HVF provides support for MTE, add it here */
> +#endif
> +}
> +
>  static void aarch64_host_initfn(Object *obj)
>  {
>  #if defined(CONFIG_KVM)
> @@ -793,6 +869,7 @@ static void aarch64_host_initfn(Object *obj)
>      if (arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
>          aarch64_add_sve_properties(obj);
>          aarch64_add_pauth_properties(obj);
> +        aarch64_add_mte_properties(obj);
>      }
>  #elif defined(CONFIG_HVF)
>      ARMCPU *cpu = ARM_CPU(obj);
> @@ -958,6 +1035,7 @@ static void aarch64_max_initfn(Object *obj)
>      object_property_add(obj, "sve-max-vq", "uint32", cpu_max_get_sve_max_vq,
>                          cpu_max_set_sve_max_vq, NULL, NULL);
>      qdev_property_add_static(DEVICE(obj), &arm_cpu_lpa2_property);
> +    aarch64_add_mte_properties(obj);
>  }
>  
>  static void aarch64_a64fx_initfn(Object *obj)
> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> index b8cfaf5782ac..d129a264a3f6 100644
> --- a/target/arm/kvm64.c
> +++ b/target/arm/kvm64.c
> @@ -746,6 +746,11 @@ bool kvm_arm_steal_time_supported(void)
>      return kvm_check_extension(kvm_state, KVM_CAP_STEAL_TIME);
>  }
>  
> +bool kvm_arm_mte_supported(void)
> +{
> +    return kvm_check_extension(kvm_state, KVM_CAP_ARM_MTE);
> +}
> +
>  QEMU_BUILD_BUG_ON(KVM_ARM64_SVE_VQ_MIN != 1);
>  
>  void kvm_arm_sve_get_vls(CPUState *cs, unsigned long *map)
> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> index b7f78b521545..13f06ed5e0ea 100644
> --- a/target/arm/kvm_arm.h
> +++ b/target/arm/kvm_arm.h
> @@ -306,6 +306,13 @@ bool kvm_arm_pmu_supported(void);
>   */
>  bool kvm_arm_sve_supported(void);
>  
> +/**
> + * kvm_arm_mte_supported:
> + *
> + * Returns: true if KVM can enable MTE, and false otherwise.
> + */
> +bool kvm_arm_mte_supported(void);
> +
>  /**
>   * kvm_arm_get_max_vm_ipa_size:
>   * @ms: Machine state handle
> @@ -396,6 +403,11 @@ static inline bool kvm_arm_steal_time_supported(void)
>      return false;
>  }
>  
> +static inline bool kvm_arm_mte_supported(void)
> +{
> +    return false;
> +}
> +
>  /*
>   * These functions should never actually be called without KVM support.
>   */
> diff --git a/target/arm/monitor.c b/target/arm/monitor.c
> index 80c64fa3556d..f13ff2664b67 100644
> --- a/target/arm/monitor.c
> +++ b/target/arm/monitor.c
> @@ -96,6 +96,7 @@ static const char *cpu_model_advertised_features[] = {
>      "sve1408", "sve1536", "sve1664", "sve1792", "sve1920", "sve2048",
>      "kvm-no-adjvtime", "kvm-steal-time",
>      "pauth", "pauth-impdef",
> +    "mte",
>      NULL
>  };
>  
Eric

