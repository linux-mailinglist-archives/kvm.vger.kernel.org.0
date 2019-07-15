Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE8E76863D
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 11:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbfGOJX2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 05:23:28 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40432 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729426AbfGOJX2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 05:23:28 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so14414369wmj.5
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2019 02:23:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b7fUN+rhLtdP+edpMTmUA1AjSDrKeFFxrf1SR4Cobak=;
        b=a4FJESquUKHBhcjaJ15lmGb/VIaqoMAgu/equhfbxK9cMIw/QSstZDMogZuJsm1t3D
         HEp8nY9Kgu7GaV84mN873yZA/wAWtuptIBJxwg37fiGUEGim5VUIBfTcTvF13wlYt+d/
         MWrHIwGzRQ98w5P/t/aRE9VfYlQdjUkiznIyZ7iHcf8bDhajSftFpb4iyFItb8zxID4X
         E8HxDF2cf2pGGSEvamyVPesHHaXEKuSdENlHSy5sg1Am+kNuvRlewIqgmuUGvok+PCED
         RaT2AYJptHkHDkbh79LS9vYN9v3sTqE0RkRm1dp4oDisL5ssjA1v6FpueGzhLb0i1PAc
         vRLQ==
X-Gm-Message-State: APjAAAVlr5cEL0eJRQrjtwfjOC/qS8V5QHmIdi3szHkt7ODSc10+OZ4l
        uLf/zkyIhi/cQ6nuyERyc/B//w==
X-Google-Smtp-Source: APXvYqwTZltZGSwUbk217kayRG3yp8c5SqUnvcDzF5tltrZNRRJVn3Lrq0ZyMF03aF5XhL3dWGXStQ==
X-Received: by 2002:a05:600c:1008:: with SMTP id c8mr23789343wmc.133.1563182605983;
        Mon, 15 Jul 2019 02:23:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e983:8394:d6:a612? ([2001:b07:6468:f312:e983:8394:d6:a612])
        by smtp.gmail.com with ESMTPSA id 4sm36462466wro.78.2019.07.15.02.23.25
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 02:23:25 -0700 (PDT)
Subject: Re: [Qemu-devel] [patch QEMU] kvm: i386: halt poll control MSR
 support
To:     Marcelo Tosatti <mtosatti@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <20190603230408.GA7938@amt.cnet>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1afdac17-3f86-5e5b-aebc-5311576ddefb@redhat.com>
Date:   Mon, 15 Jul 2019 11:23:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190603230408.GA7938@amt.cnet>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/06/19 01:04, Marcelo Tosatti wrote:
> (CC'ing qemu devel)
> 
> Add support for halt poll control MSR: save/restore, migration
> and new feature name.
> 
> The purpose of this MSR is to allow the guest to disable
> host halt poll.
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> diff --git a/include/standard-headers/asm-x86/kvm_para.h b/include/standard-headers/asm-x86/kvm_para.h
> index 35cd8d6..e171514 100644
> --- a/include/standard-headers/asm-x86/kvm_para.h
> +++ b/include/standard-headers/asm-x86/kvm_para.h
> @@ -29,6 +29,7 @@
>  #define KVM_FEATURE_PV_TLB_FLUSH	9
>  #define KVM_FEATURE_ASYNC_PF_VMEXIT	10
>  #define KVM_FEATURE_PV_SEND_IPI	11
> +#define KVM_FEATURE_POLL_CONTROL	12
>  
>  #define KVM_HINTS_REALTIME      0
>  
> @@ -47,6 +48,7 @@
>  #define MSR_KVM_ASYNC_PF_EN 0x4b564d02
>  #define MSR_KVM_STEAL_TIME  0x4b564d03
>  #define MSR_KVM_PV_EOI_EN      0x4b564d04
> +#define MSR_KVM_POLL_CONTROL	0x4b564d05
>  
>  struct kvm_steal_time {
>  	uint64_t steal;
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index c1ab86d..1ca6944 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -903,7 +903,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>              "kvmclock", "kvm-nopiodelay", "kvm-mmu", "kvmclock",
>              "kvm-asyncpf", "kvm-steal-time", "kvm-pv-eoi", "kvm-pv-unhalt",
>              NULL, "kvm-pv-tlb-flush", NULL, "kvm-pv-ipi",
> -            NULL, NULL, NULL, NULL,
> +            "kvm-poll-control", NULL, NULL, NULL,
>              NULL, NULL, NULL, NULL,
>              NULL, NULL, NULL, NULL,
>              "kvmclock-stable-bit", NULL, NULL, NULL,
> @@ -3001,6 +3001,7 @@ static PropValue kvm_default_props[] = {
>      { "kvm-asyncpf", "on" },
>      { "kvm-steal-time", "on" },
>      { "kvm-pv-eoi", "on" },
> +    { "kvm-poll-control", "on" },
>      { "kvmclock-stable-bit", "on" },
>      { "x2apic", "on" },
>      { "acpi", "off" },
> @@ -5660,6 +5661,8 @@ static void x86_cpu_initfn(Object *obj)
>      object_property_add_alias(obj, "kvm_steal_time", obj, "kvm-steal-time", &error_abort);
>      object_property_add_alias(obj, "kvm_pv_eoi", obj, "kvm-pv-eoi", &error_abort);
>      object_property_add_alias(obj, "kvm_pv_unhalt", obj, "kvm-pv-unhalt", &error_abort);
> +    object_property_add_alias(obj, "kvm_poll_control", obj, "kvm-poll-control",
> +                              &error_abort);
>      object_property_add_alias(obj, "svm_lock", obj, "svm-lock", &error_abort);
>      object_property_add_alias(obj, "nrip_save", obj, "nrip-save", &error_abort);
>      object_property_add_alias(obj, "tsc_scale", obj, "tsc-scale", &error_abort);
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index bd06523..21ed2f8 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1241,6 +1241,7 @@ typedef struct CPUX86State {
>      uint64_t steal_time_msr;
>      uint64_t async_pf_en_msr;
>      uint64_t pv_eoi_en_msr;
> +    uint64_t poll_control_msr;
>  
>      /* Partition-wide HV MSRs, will be updated only on the first vcpu */
>      uint64_t msr_hv_hypercall;
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 3b29ce5..a5e9cdf 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -1369,6 +1369,8 @@ void kvm_arch_reset_vcpu(X86CPU *cpu)
>  
>          hyperv_x86_synic_reset(cpu);
>      }
> +    /* enabled by default */
> +    env->poll_control_msr = 1;
>  }
>  
>  void kvm_arch_do_init_vcpu(X86CPU *cpu)
> @@ -2059,6 +2061,11 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>          if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_STEAL_TIME)) {
>              kvm_msr_entry_add(cpu, MSR_KVM_STEAL_TIME, env->steal_time_msr);
>          }
> +
> +        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_POLL_CONTROL)) {
> +            kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env->poll_control_msr);
> +        }
> +
>          if (has_architectural_pmu_version > 0) {
>              if (has_architectural_pmu_version > 1) {
>                  /* Stop the counter.  */
> @@ -2443,6 +2450,9 @@ static int kvm_get_msrs(X86CPU *cpu)
>      if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_STEAL_TIME)) {
>          kvm_msr_entry_add(cpu, MSR_KVM_STEAL_TIME, 0);
>      }
> +    if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_POLL_CONTROL)) {
> +        kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
> +    }
>      if (has_architectural_pmu_version > 0) {
>          if (has_architectural_pmu_version > 1) {
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
> @@ -2677,6 +2687,10 @@ static int kvm_get_msrs(X86CPU *cpu)
>          case MSR_KVM_STEAL_TIME:
>              env->steal_time_msr = msrs[i].data;
>              break;
> +        case MSR_KVM_POLL_CONTROL: {
> +            env->poll_control_msr = msrs[i].data;
> +            break;
> +        }
>          case MSR_CORE_PERF_FIXED_CTR_CTRL:
>              env->msr_fixed_ctr_ctrl = msrs[i].data;
>              break;
> diff --git a/target/i386/machine.c b/target/i386/machine.c
> index 225b5d4..1c23e5e 100644
> --- a/target/i386/machine.c
> +++ b/target/i386/machine.c
> @@ -323,6 +323,14 @@ static bool steal_time_msr_needed(void *opaque)
>      return cpu->env.steal_time_msr != 0;
>  }
>  
> +/* Poll control MSR enabled by default */
> +static bool poll_control_msr_needed(void *opaque)
> +{
> +    X86CPU *cpu = opaque;
> +
> +    return cpu->env.poll_control_msr != 1;
> +}
> +
>  static const VMStateDescription vmstate_steal_time_msr = {
>      .name = "cpu/steal_time_msr",
>      .version_id = 1,
> @@ -356,6 +364,17 @@ static const VMStateDescription vmstate_pv_eoi_msr = {
>      }
>  };
>  
> +static const VMStateDescription vmstate_poll_control_msr = {
> +    .name = "cpu/poll_control_msr",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .needed = poll_control_msr_needed,
> +    .fields = (VMStateField[]) {
> +        VMSTATE_UINT64(env.poll_control_msr, X86CPU),
> +        VMSTATE_END_OF_LIST()
> +    }
> +};
> +
>  static bool fpop_ip_dp_needed(void *opaque)
>  {
>      X86CPU *cpu = opaque;
> @@ -1062,6 +1081,7 @@ VMStateDescription vmstate_x86_cpu = {
>          &vmstate_async_pf_msr,
>          &vmstate_pv_eoi_msr,
>          &vmstate_steal_time_msr,
> +        &vmstate_poll_control_msr,
>          &vmstate_fpop_ip_dp,
>          &vmstate_msr_tsc_adjust,
>          &vmstate_msr_tscdeadline,
> 

Queued, thanks.  Sorry for missing it until now.

Paolo
