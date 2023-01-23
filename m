Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C8E677D0B
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 14:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbjAWNvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 08:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbjAWNvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 08:51:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADFC422F
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 05:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674481821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ln7RV5TktuNnFYrmLpu+ljAXvmQvp0L9lRlGKHLDIYM=;
        b=V2dFwRX2j7e/go+DJG3UFhySJLdhwMC6JaP27cfL93vWmuLwDZNc17dYKi/wZKe3mrVznP
        IyEwCbZH69fjs/8qEhfGZcYu3eID8JTq2CDhg3HExNGlL210ZQN4+lZz3s5yesg7v/E+k9
        pyRRFAlTLzdWyVw7XFe6oWTgAKLJBao=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-590-yOuZC6BuNEycHFCtij3a4g-1; Mon, 23 Jan 2023 08:50:18 -0500
X-MC-Unique: yOuZC6BuNEycHFCtij3a4g-1
Received: by mail-qt1-f200.google.com with SMTP id j14-20020ac874ce000000b003b6917d0731so4119696qtr.4
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 05:50:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ln7RV5TktuNnFYrmLpu+ljAXvmQvp0L9lRlGKHLDIYM=;
        b=ALDy8cRkzEzNQH5cyivsoUFy/WUkkphU/3c/qsprJYkMls1W1zLYxxaMmf2FjUIYst
         +QRKq8xncjoXBIfgozAWkcX4EegSKawSDiBTvIa/bStjp0/7f8pIpTpv5Z33HhA/p/22
         SB7hWTxwEA9n+pAyOzuvMdan7IXfPMF+zRnASCvbbm80kpm2nz1GxxYKTexih+oK7MOR
         SafLIVfeNevcouxrd0lC0d3jMLAOJF9T8hovtFxcm3/tUUPXLy8ixwuabFJvazkXehns
         3qK4KEZ3vKGL0Jkm8e18vh1A+Ouc5aihOhCP3glkgZhfuemA/ifmwc9zAqpkGH1kpau/
         RH7Q==
X-Gm-Message-State: AFqh2koYEzIpQVSsjgXUBxdHnss2p3rp5mRcCJKjFdsQ5UENg/WTz6BA
        01JJQKc1OVYZTadZbAU6C/pB8x2W+y4h1n8LKp9mQRKFyKv4zBWl5JFNYE197nybNDEm1ytLVkx
        I5+VvFq1rgJN6
X-Received: by 2002:a05:622a:1e1b:b0:3a9:8842:5860 with SMTP id br27-20020a05622a1e1b00b003a988425860mr34502632qtb.45.1674481817681;
        Mon, 23 Jan 2023 05:50:17 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv0NyC3ib4pxPx5PQVybNmtY0pcmro7NE/DE44hN66hOO6DcYqZ8nN72nMDG4t4L7yA9jCNLQ==
X-Received: by 2002:a05:622a:1e1b:b0:3a9:8842:5860 with SMTP id br27-20020a05622a1e1b00b003a988425860mr34502599qtb.45.1674481817312;
        Mon, 23 Jan 2023 05:50:17 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ez11-20020a05622a4c8b00b003afbf704c7csm8558178qtb.24.2023.01.23.05.50.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 05:50:16 -0800 (PST)
Message-ID: <44d82d98-6a27-f4d3-9773-670231f82c63@redhat.com>
Date:   Mon, 23 Jan 2023 14:50:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v4 1/2] arm/kvm: add support for MTE
Content-Language: en-US
To:     Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>
References: <20230111161317.52250-1-cohuck@redhat.com>
 <20230111161317.52250-2-cohuck@redhat.com>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20230111161317.52250-2-cohuck@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Connie,
On 1/11/23 17:13, Cornelia Huck wrote:
> Introduce a new cpu feature flag to control MTE support. To preserve
> backwards compatibility for tcg, MTE will continue to be enabled as
> long as tag memory has been provided.
> 
> If MTE has been enabled, we need to disable migration, as we do not
this only applies to KVM acceleration
> yet have a way to migrate the tags as well. Therefore, MTE will stay
> off with KVM unless requested explicitly.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  docs/system/arm/cpu-features.rst |  21 +++++
>  hw/arm/virt.c                    |   2 +-
>  target/arm/cpu.c                 |  18 ++---
>  target/arm/cpu.h                 |   1 +
>  target/arm/cpu64.c               | 133 +++++++++++++++++++++++++++++++
>  target/arm/internals.h           |   1 +
>  target/arm/kvm64.c               |   5 ++
>  target/arm/kvm_arm.h             |  12 +++
>  target/arm/monitor.c             |   1 +
>  9 files changed, 181 insertions(+), 13 deletions(-)
> 
> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
> index 00c444042ff5..e278650c837e 100644
> --- a/docs/system/arm/cpu-features.rst
> +++ b/docs/system/arm/cpu-features.rst
> @@ -443,3 +443,24 @@ As with ``sve-default-vector-length``, if the default length is larger
>  than the maximum vector length enabled, the actual vector length will
>  be reduced.  If this property is set to ``-1`` then the default vector
>  length is set to the maximum possible length.
> +
> +MTE CPU Property
> +================
> +
> +The ``mte`` property controls the Memory Tagging Extension. For TCG, it requires
> +presence of tag memory (which can be turned on for the ``virt`` machine via
> +``mte=on``). For KVM, it requires the ``KVM_CAP_ARM_MTE`` capability; until
> +proper migration support is implemented, enabling MTE will install a migration
> +blocker.
maybe re-emphasize: when KVM is enabled
> +
> +If not specified explicitly via ``on`` or ``off``, MTE will be available
> +according to the following rules:
> +
> +* When TCG is used, MTE will be available iff tag memory is available; i.e. it
suggestion: is available at machine level
> +  preserves the behaviour prior to introduction of the feature.
s/prior to/prior to the ?
> +
> +* When KVM is used, MTE will default to off, so that migration will not
> +  unintentionally be blocked.
> +
> +* Other accelerators currently don't support MTE.
> +
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index ea2413a0bad7..42359e256ad0 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -2136,7 +2136,7 @@ static void machvirt_init(MachineState *machine)
>  
>      if (vms->mte && (kvm_enabled() || hvf_enabled())) {
>          error_report("mach-virt: %s does not support providing "
> -                     "MTE to the guest CPU",
> +                     "emulated MTE to the guest CPU",
each time I read this message I feel difficult to understand it. Why not
replacing by
"mach-virt does not support tag memory with %s acceleration" or
something alike?
>                       kvm_enabled() ? "KVM" : "HVF");
>          exit(1);
>      }
> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index 5f63316dbf22..decab743d0d5 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -1529,6 +1529,11 @@ void arm_cpu_finalize_features(ARMCPU *cpu, Error **errp)
>              error_propagate(errp, local_err);
>              return;
>          }
> +        arm_cpu_mte_finalize(cpu, &local_err);
> +        if (local_err != NULL) {
> +            error_propagate(errp, local_err);
> +            return;
> +        }
>      }
>  #endif
>  
> @@ -1605,7 +1610,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
>          }
>          if (cpu->tag_memory) {
>              error_setg(errp,
> -                       "Cannot enable %s when guest CPUs has MTE enabled",
> +                       "Cannot enable %s when guest CPUs has tag memory enabled",
>                         current_accel_name());
>              return;
>          }
> @@ -1984,17 +1989,6 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
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
>      if (tcg_enabled()) {
>          /*
>           * Don't report the Statistical Profiling Extension in the ID
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index bf2bce046d56..f1a9015a7ed7 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -1038,6 +1038,7 @@ struct ArchCPU {
>      bool prop_pauth;
>      bool prop_pauth_impdef;
>      bool prop_lpa2;
> +    OnOffAuto prop_mte;
>  
>      /* DCZ blocksize, in log_2(words), ie low 4 bits of DCZID_EL0 */
>      uint32_t dcz_blocksize;
> diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
> index 0e021960fb5b..3cf42ee05ca3 100644
> --- a/target/arm/cpu64.c
> +++ b/target/arm/cpu64.c
> @@ -29,6 +29,13 @@
>  #include "qapi/visitor.h"
>  #include "hw/qdev-properties.h"
>  #include "internals.h"
> +#include "migration/blocker.h"
> +#include "qapi/qapi-visit-common.h"
> +#include "hw/arm/virt.h"
> +
> +#ifdef CONFIG_KVM
> +static Error *mte_migration_blocker;
> +#endif
>  
>  static void aarch64_a35_initfn(Object *obj)
>  {
> @@ -1096,6 +1103,130 @@ static void aarch64_neoverse_n1_initfn(Object *obj)
>      cpu->isar.reset_pmcr_el0 = 0x410c3000;
>  }
>  
> +static void aarch64_cpu_get_mte(Object *obj, Visitor *v, const char *name,
> +                                void *opaque, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    OnOffAuto mte = cpu->prop_mte;
> +
> +    visit_type_OnOffAuto(v, name, &mte, errp);
> +}
> +
> +static void aarch64_cpu_set_mte(Object *obj, Visitor *v, const char *name,
> +                                void *opaque, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +
> +    visit_type_OnOffAuto(v, name, &cpu->prop_mte, errp);
> +
nit: spare void line
> +}
> +
> +static void aarch64_add_mte_properties(Object *obj)
> +{
> +    /*
> +     * For tcg, "AUTO" means turn on mte if tag memory has been provided, and
> +     * turn it off (without error) if not.
> +     * For kvm, "AUTO" currently means mte off, as migration is not supported
> +     * yet.
> +     * For all others, "AUTO" means mte off.
> +     */
> +    object_property_add(obj, "mte", "OnOffAuto", aarch64_cpu_get_mte,
> +                        aarch64_cpu_set_mte, NULL, NULL);
> +}
> +
> +static inline bool arm_machine_has_tag_memory(void)
> +{
> +#ifndef CONFIG_USER_ONLY
> +    Object *obj = object_dynamic_cast(qdev_get_machine(), TYPE_VIRT_MACHINE);
> +
> +    /* so far, only the virt machine has support for tag memory */
> +    if (obj) {
> +        VirtMachineState *vms = VIRT_MACHINE(obj);
> +
> +        return vms->mte;
> +    }
> +#endif
> +    return false;
> +}
> +
> +void arm_cpu_mte_finalize(ARMCPU *cpu, Error **errp)
> +{
> +    bool enable_mte;
> +
> +    switch (cpu->prop_mte) {
> +    case ON_OFF_AUTO_OFF:
> +        enable_mte = false;
> +        break;
> +    case ON_OFF_AUTO_ON:
> +        if (!kvm_enabled()) {
> +            if (cpu_isar_feature(aa64_mte, cpu)) {
> +                if (!arm_machine_has_tag_memory()) {
> +                    error_setg(errp, "mte=on requires tag memory");
> +                    return;
> +                }
> +            } else {
> +                error_setg(errp, "mte not provided");
mte not supported by this CPU type?
> +                return;
> +            }
> +        }
> +#ifdef CONFIG_KVM
> +        if (kvm_enabled() && !kvm_arm_mte_supported()) {
as you have stubs for both, is the #ifdef needed?
> +            error_setg(errp, "mte not supported by kvm");
> +            return;
> +        }
> +#endif
> +        enable_mte = true;
> +        break;
> +    default: /* AUTO */
> +        if (!kvm_enabled()) {
> +            if (cpu_isar_feature(aa64_mte, cpu)) {
> +                /*
> +                 * Tie mte enablement to presence of tag memory, in order to
> +                 * preserve pre-existing behaviour.
> +                 */
> +                enable_mte = arm_machine_has_tag_memory();
> +            } else {
> +                enable_mte = false;
> +            }
> +            break;
> +        } else {
> +            /*
> +             * This cannot yet be
> +             * enable_mte = kvm_arm_mte_supported();
> +             * as we don't support migration yet.
> +             */
> +            enable_mte = false;
> +        }
> +    }
> +
> +    if (!enable_mte) {
> +        /* Disable MTE feature bits. */
> +        cpu->isar.id_aa64pfr1 =
> +            FIELD_DP64(cpu->isar.id_aa64pfr1, ID_AA64PFR1, MTE, 0);
> +        return;
> +    }
> +
> +    /* accelerator-specific enablement */
> +    if (kvm_enabled()) {
> +#ifdef CONFIG_KVM
> +        if (kvm_vm_enable_cap(kvm_state, KVM_CAP_ARM_MTE, 0)) {
> +            error_setg(errp, "Failed to enable KVM_CAP_ARM_MTE");
nit: return and remove the else?
> +        } else {
> +            /* TODO: add proper migration support with MTE enabled */
> +            if (!mte_migration_blocker) {
> +                error_setg(&mte_migration_blocker,
> +                           "Live migration disabled due to MTE enabled");
> +                if (migrate_add_blocker(mte_migration_blocker, NULL)) {
Can't you pass the erro directly to migrate_add_blocker. Also  in
arm_gicv3_its_kvm.c or virtio-gpu-pci, < 0 is checked. Maybe worth to
double check the rationale.
> +                    error_setg(errp, "Failed to add MTE migration blocker");
> +                    error_free(mte_migration_blocker);
> +                    mte_migration_blocker = NULL;
> +                }
> +            }
> +        }
> +#endif
> +    }
> +}
> +
>  static void aarch64_host_initfn(Object *obj)
>  {
>  #if defined(CONFIG_KVM)
> @@ -1104,6 +1235,7 @@ static void aarch64_host_initfn(Object *obj)
>      if (arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
>          aarch64_add_sve_properties(obj);
>          aarch64_add_pauth_properties(obj);
> +        aarch64_add_mte_properties(obj);
>      }
>  #elif defined(CONFIG_HVF)
>      ARMCPU *cpu = ARM_CPU(obj);
> @@ -1300,6 +1432,7 @@ static void aarch64_max_initfn(Object *obj)
>      object_property_add(obj, "sve-max-vq", "uint32", cpu_max_get_sve_max_vq,
>                          cpu_max_set_sve_max_vq, NULL, NULL);
>      qdev_property_add_static(DEVICE(obj), &arm_cpu_lpa2_property);
> +    aarch64_add_mte_properties(obj);
>  }
>  
>  static const ARMCPUInfo aarch64_cpus[] = {
> diff --git a/target/arm/internals.h b/target/arm/internals.h
> index d9555309df0f..4dc6d19be42b 100644
> --- a/target/arm/internals.h
> +++ b/target/arm/internals.h
> @@ -1348,6 +1348,7 @@ void arm_cpu_sve_finalize(ARMCPU *cpu, Error **errp);
>  void arm_cpu_sme_finalize(ARMCPU *cpu, Error **errp);
>  void arm_cpu_pauth_finalize(ARMCPU *cpu, Error **errp);
>  void arm_cpu_lpa2_finalize(ARMCPU *cpu, Error **errp);
> +void arm_cpu_mte_finalize(ARMCPU *cpu, Error **errp);
>  #endif
>  
>  #ifdef CONFIG_USER_ONLY
> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> index 1197253d12f7..b777bd0a11d2 100644
> --- a/target/arm/kvm64.c
> +++ b/target/arm/kvm64.c
> @@ -764,6 +764,11 @@ bool kvm_arm_steal_time_supported(void)
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
>  uint32_t kvm_arm_sve_get_vls(CPUState *cs)
> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> index 99017b635ce4..762443f8a7c0 100644
> --- a/target/arm/kvm_arm.h
> +++ b/target/arm/kvm_arm.h
> @@ -305,6 +305,13 @@ bool kvm_arm_pmu_supported(void);
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
> @@ -395,6 +402,11 @@ static inline bool kvm_arm_steal_time_supported(void)
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
> index ecdd5ee81742..c419c81612ed 100644
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
Thanks

Eric

