Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945F1204441
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 01:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731477AbgFVXFM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 19:05:12 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34734 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726977AbgFVXFL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 19:05:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592867109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QGOgXyP+V6ZX9XlqYc/aL6AiCKn6armXlX3+teRFbrQ=;
        b=K3kYYbqNRZm8MbIdvTIu8kCu9D2YYIJfuS0SrewyoIf6daKuRICzbUcRuW/Nl8WGGdWGe3
        zO2iOrQjMBHRjN1tNH6BOLsSHg6haNliN4N7TnKh4jHpoY6CWI0VroRJDq/GN5rYQWG3rL
        dwD3NEa21kUcm7B/uxOYLhuJ6aHJZTM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-vc0RjPlZMIGR3y_lwaXIXQ-1; Mon, 22 Jun 2020 19:05:07 -0400
X-MC-Unique: vc0RjPlZMIGR3y_lwaXIXQ-1
Received: by mail-wm1-f70.google.com with SMTP id s134so993466wme.6
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 16:05:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QGOgXyP+V6ZX9XlqYc/aL6AiCKn6armXlX3+teRFbrQ=;
        b=r27u6SLJjtQxqnFnnTUqTpG/NbuPooJyg+yBGToOakTVcuvPM66S+WopbWHkO4bCOG
         IuIEJ9sGKDwrID5m1KtOY2qY6nSPg77VpvxD/qWnMBNWlAKzqWXhTGYEZ1q16VoWelVn
         QYPNOHakVFTgKRzGtT85hwRXI+rSqpJXrbRs3E5p6t962URQqJ249mZmOfY+mZByq0WO
         w83d3cScMcedhgSBpOxfKpcSXwasqwHWduZuuRlKeJW1OKsOTDmThSYP+eEYChW8S/iB
         gKP6NjMT09TmPZDz+fC/aaS3GKnVK6zsYr/t5BZpsZfh8PRWdGZVr7cm4IDs43XSAtau
         OOgA==
X-Gm-Message-State: AOAM530vc6NIjxM2em4jAdVf2dazBg7ID9jLFuUij7i2WrkzN8Msb9ai
        ifoLUJ72Xx3uw2c5uNE4IEIdukT3QLoaZ+OwIvChv2ldeZxam22tntK8zPYC8/Wy/vc9NXEAz3j
        NUQMuBPaSkuEr
X-Received: by 2002:adf:f5ce:: with SMTP id k14mr7448098wrp.234.1592867105788;
        Mon, 22 Jun 2020 16:05:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxBBEMAjHoewU6Nrlx/mZXv+KZawK3Ben4raFY7rVGgPz59FlY8qkmg7223neCsMd3Vmh9t+w==
X-Received: by 2002:adf:f5ce:: with SMTP id k14mr7448056wrp.234.1592867105436;
        Mon, 22 Jun 2020 16:05:05 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id k11sm16975667wrd.23.2020.06.22.16.05.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 16:05:04 -0700 (PDT)
Subject: Re: [PATCH v2] target/arm: Check supported KVM features globally (not
 per vCPU)
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
        qemu-arm@nongnu.org, Andrew Jones <drjones@redhat.com>,
        Haibo Xu <haibo.xu@linaro.org>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
References: <20200619095542.2095-1-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <51efbadc-8061-47f6-ed0b-9b846ace36d7@redhat.com>
Date:   Tue, 23 Jun 2020 01:05:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200619095542.2095-1-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/06/20 11:55, Philippe Mathieu-Daudé wrote:
> Since commit d70c996df23f, when enabling the PMU we get:
> 
>   $ qemu-system-aarch64 -cpu host,pmu=on -M virt,accel=kvm,gic-version=3
>   Segmentation fault (core dumped)
> 
>   Thread 1 "qemu-system-aar" received signal SIGSEGV, Segmentation fault.
>   0x0000aaaaaae356d0 in kvm_ioctl (s=0x0, type=44547) at accel/kvm/kvm-all.c:2588
>   2588        ret = ioctl(s->fd, type, arg);
>   (gdb) bt
>   #0  0x0000aaaaaae356d0 in kvm_ioctl (s=0x0, type=44547) at accel/kvm/kvm-all.c:2588
>   #1  0x0000aaaaaae31568 in kvm_check_extension (s=0x0, extension=126) at accel/kvm/kvm-all.c:916
>   #2  0x0000aaaaaafce254 in kvm_arm_pmu_supported (cpu=0xaaaaac214ab0) at target/arm/kvm.c:213
>   #3  0x0000aaaaaafc0f94 in arm_set_pmu (obj=0xaaaaac214ab0, value=true, errp=0xffffffffe438) at target/arm/cpu.c:1111
>   #4  0x0000aaaaab5533ac in property_set_bool (obj=0xaaaaac214ab0, v=0xaaaaac223a80, name=0xaaaaac11a970 "pmu", opaque=0xaaaaac222730, errp=0xffffffffe438) at qom/object.c:2170
>   #5  0x0000aaaaab5512f0 in object_property_set (obj=0xaaaaac214ab0, v=0xaaaaac223a80, name=0xaaaaac11a970 "pmu", errp=0xffffffffe438) at qom/object.c:1328
>   #6  0x0000aaaaab551e10 in object_property_parse (obj=0xaaaaac214ab0, string=0xaaaaac11b4c0 "on", name=0xaaaaac11a970 "pmu", errp=0xffffffffe438) at qom/object.c:1561
>   #7  0x0000aaaaab54ee8c in object_apply_global_props (obj=0xaaaaac214ab0, props=0xaaaaac018e20, errp=0xaaaaabd6fd88 <error_fatal>) at qom/object.c:407
>   #8  0x0000aaaaab1dd5a4 in qdev_prop_set_globals (dev=0xaaaaac214ab0) at hw/core/qdev-properties.c:1218
>   #9  0x0000aaaaab1d9fac in device_post_init (obj=0xaaaaac214ab0) at hw/core/qdev.c:1050
>   ...
>   #15 0x0000aaaaab54f310 in object_initialize_with_type (obj=0xaaaaac214ab0, size=52208, type=0xaaaaabe237f0) at qom/object.c:512
>   #16 0x0000aaaaab54fa24 in object_new_with_type (type=0xaaaaabe237f0) at qom/object.c:687
>   #17 0x0000aaaaab54fa80 in object_new (typename=0xaaaaabe23970 "host-arm-cpu") at qom/object.c:702
>   #18 0x0000aaaaaaf04a74 in machvirt_init (machine=0xaaaaac0a8550) at hw/arm/virt.c:1770
>   #19 0x0000aaaaab1e8720 in machine_run_board_init (machine=0xaaaaac0a8550) at hw/core/machine.c:1138
>   #20 0x0000aaaaaaf95394 in qemu_init (argc=5, argv=0xffffffffea58, envp=0xffffffffea88) at softmmu/vl.c:4348
>   #21 0x0000aaaaaada3f74 in main (argc=<optimized out>, argv=<optimized out>, envp=<optimized out>) at softmmu/main.c:48
> 
> This is because in frame #2, cpu->kvm_state is still NULL
> (the vCPU is not yet realized).
> 
> KVM has a hard requirement of all cores supporting the same
> feature set. We only need to check if the accelerator supports
> a feature, not each vCPU individually.
> 
> Fix by kvm_arm_<FEATURE>_supported() functions take a AccelState
> argument (already realized/valid at this point) instead of a
> CPUState argument.
> 
> Reported-by: Haibo Xu <haibo.xu@linaro.org>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
> v2: Use global kvm_state (bonzini)
> 
> Paolo, does this break migration of encrypted memory assumptions?
> 
> Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Supersedes: <20200617130800.26355-1-philmd@redhat.com>
> ---
>  target/arm/kvm_arm.h | 21 +++++++++------------
>  target/arm/cpu.c     |  2 +-
>  target/arm/cpu64.c   | 10 +++++-----
>  target/arm/kvm.c     |  4 ++--
>  target/arm/kvm64.c   | 14 +++++---------
>  5 files changed, 22 insertions(+), 29 deletions(-)
> 
> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> index 48bf5e16d5..a4ce4fd93d 100644
> --- a/target/arm/kvm_arm.h
> +++ b/target/arm/kvm_arm.h
> @@ -269,29 +269,26 @@ void kvm_arm_add_vcpu_properties(Object *obj);
>  
>  /**
>   * kvm_arm_aarch32_supported:
> - * @cs: CPUState
>   *
> - * Returns: true if the KVM VCPU can enable AArch32 mode
> + * Returns: true if KVM can enable AArch32 mode
>   * and false otherwise.
>   */
> -bool kvm_arm_aarch32_supported(CPUState *cs);
> +bool kvm_arm_aarch32_supported(void);
>  
>  /**
>   * kvm_arm_pmu_supported:
> - * @cs: CPUState
>   *
> - * Returns: true if the KVM VCPU can enable its PMU
> + * Returns: true if KVM can enable the PMU
>   * and false otherwise.
>   */
> -bool kvm_arm_pmu_supported(CPUState *cs);
> +bool kvm_arm_pmu_supported(void);
>  
>  /**
>   * kvm_arm_sve_supported:
> - * @cs: CPUState
>   *
> - * Returns true if the KVM VCPU can enable SVE and false otherwise.
> + * Returns true if KVM can enable SVE and false otherwise.
>   */
> -bool kvm_arm_sve_supported(CPUState *cs);
> +bool kvm_arm_sve_supported(void);
>  
>  /**
>   * kvm_arm_get_max_vm_ipa_size:
> @@ -359,17 +356,17 @@ static inline void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
>  
>  static inline void kvm_arm_add_vcpu_properties(Object *obj) {}
>  
> -static inline bool kvm_arm_aarch32_supported(CPUState *cs)
> +static inline bool kvm_arm_aarch32_supported(void)
>  {
>      return false;
>  }
>  
> -static inline bool kvm_arm_pmu_supported(CPUState *cs)
> +static inline bool kvm_arm_pmu_supported(void)
>  {
>      return false;
>  }
>  
> -static inline bool kvm_arm_sve_supported(CPUState *cs)
> +static inline bool kvm_arm_sve_supported(void)
>  {
>      return false;
>  }
> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index 5b7a36b5d7..e44e18062c 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -1108,7 +1108,7 @@ static void arm_set_pmu(Object *obj, bool value, Error **errp)
>      ARMCPU *cpu = ARM_CPU(obj);
>  
>      if (value) {
> -        if (kvm_enabled() && !kvm_arm_pmu_supported(CPU(cpu))) {
> +        if (kvm_enabled() && !kvm_arm_pmu_supported()) {
>              error_setg(errp, "'pmu' feature not supported by KVM on this host");
>              return;
>          }
> diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
> index 778cecc2e6..a0c1d8894b 100644
> --- a/target/arm/cpu64.c
> +++ b/target/arm/cpu64.c
> @@ -266,7 +266,7 @@ void arm_cpu_sve_finalize(ARMCPU *cpu, Error **errp)
>  
>      /* Collect the set of vector lengths supported by KVM. */
>      bitmap_zero(kvm_supported, ARM_MAX_VQ);
> -    if (kvm_enabled() && kvm_arm_sve_supported(CPU(cpu))) {
> +    if (kvm_enabled() && kvm_arm_sve_supported()) {
>          kvm_arm_sve_get_vls(CPU(cpu), kvm_supported);
>      } else if (kvm_enabled()) {
>          assert(!cpu_isar_feature(aa64_sve, cpu));
> @@ -473,7 +473,7 @@ static void cpu_max_set_sve_max_vq(Object *obj, Visitor *v, const char *name,
>          return;
>      }
>  
> -    if (kvm_enabled() && !kvm_arm_sve_supported(CPU(cpu))) {
> +    if (kvm_enabled() && !kvm_arm_sve_supported()) {
>          error_setg(errp, "cannot set sve-max-vq");
>          error_append_hint(errp, "SVE not supported by KVM on this host\n");
>          return;
> @@ -519,7 +519,7 @@ static void cpu_arm_set_sve_vq(Object *obj, Visitor *v, const char *name,
>          return;
>      }
>  
> -    if (value && kvm_enabled() && !kvm_arm_sve_supported(CPU(cpu))) {
> +    if (value && kvm_enabled() && !kvm_arm_sve_supported()) {
>          error_setg(errp, "cannot enable %s", name);
>          error_append_hint(errp, "SVE not supported by KVM on this host\n");
>          return;
> @@ -556,7 +556,7 @@ static void cpu_arm_set_sve(Object *obj, Visitor *v, const char *name,
>          return;
>      }
>  
> -    if (value && kvm_enabled() && !kvm_arm_sve_supported(CPU(cpu))) {
> +    if (value && kvm_enabled() && !kvm_arm_sve_supported()) {
>          error_setg(errp, "'sve' feature not supported by KVM on this host");
>          return;
>      }
> @@ -751,7 +751,7 @@ static void aarch64_cpu_set_aarch64(Object *obj, bool value, Error **errp)
>       * uniform execution state like do_interrupt.
>       */
>      if (value == false) {
> -        if (!kvm_enabled() || !kvm_arm_aarch32_supported(CPU(cpu))) {
> +        if (!kvm_enabled() || !kvm_arm_aarch32_supported()) {
>              error_setg(errp, "'aarch64' feature cannot be disabled "
>                               "unless KVM is enabled and 32-bit EL1 "
>                               "is supported");
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index eef3bbd1cc..7c672c78b8 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -208,9 +208,9 @@ void kvm_arm_add_vcpu_properties(Object *obj)
>      }
>  }
>  
> -bool kvm_arm_pmu_supported(CPUState *cpu)
> +bool kvm_arm_pmu_supported(void)
>  {
> -    return kvm_check_extension(cpu->kvm_state, KVM_CAP_ARM_PMU_V3);
> +    return kvm_check_extension(kvm_state, KVM_CAP_ARM_PMU_V3);
>  }
>  
>  int kvm_arm_get_max_vm_ipa_size(MachineState *ms)
> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> index f09ed9f4df..3dc494aaa7 100644
> --- a/target/arm/kvm64.c
> +++ b/target/arm/kvm64.c
> @@ -652,18 +652,14 @@ bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>      return true;
>  }
>  
> -bool kvm_arm_aarch32_supported(CPUState *cpu)
> +bool kvm_arm_aarch32_supported(void)
>  {
> -    KVMState *s = KVM_STATE(current_accel());
> -
> -    return kvm_check_extension(s, KVM_CAP_ARM_EL1_32BIT);
> +    return kvm_check_extension(kvm_state, KVM_CAP_ARM_EL1_32BIT);
>  }
>  
> -bool kvm_arm_sve_supported(CPUState *cpu)
> +bool kvm_arm_sve_supported(void)
>  {
> -    KVMState *s = KVM_STATE(current_accel());
> -
> -    return kvm_check_extension(s, KVM_CAP_ARM_SVE);
> +    return kvm_check_extension(kvm_state, KVM_CAP_ARM_SVE);
>  }
>  
>  QEMU_BUILD_BUG_ON(KVM_ARM64_SVE_VQ_MIN != 1);
> @@ -798,7 +794,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>          env->features &= ~(1ULL << ARM_FEATURE_PMU);
>      }
>      if (cpu_isar_feature(aa64_sve, cpu)) {
> -        assert(kvm_arm_sve_supported(cs));
> +        assert(kvm_arm_sve_supported());
>          cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_SVE;
>      }
>  
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

I think the patch and the test can go through the ARM tree.

Thanks,

Paolo

