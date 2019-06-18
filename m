Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 892B14A6F7
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 18:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbfFRQcx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 12:32:53 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39533 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729319AbfFRQcw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 12:32:52 -0400
Received: by mail-wr1-f68.google.com with SMTP id x4so213544wrt.6
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 09:32:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FtcEXFK7NlBTMcGOYcg47ugmC8KoonYwN3BxvE7Oqy0=;
        b=qFZn3MmYam+1zbxlNQJhkZsCteIMdoI2FtTB9Hqek3092LlFjWhxK8mHiR4BwIOKoC
         IIcMeYqWKcdfbYgE4ZrcOyFZu69wFkI6T27bDtIyrWlMJLKxf3WIOSNMD67Z9yPnnUk8
         o3wdf+q5EQ31kPaNo6LEiIfaGASQN991haxSGL9r2ip//g/nMWPZBpg9IMXswbv2CFTG
         nhobyDeEHlmXu08UpuoGJ18n24EXpycfSl2+3Dq85teHGjXMQcpiY4YZWPAUAj6ZLmm+
         4Eph1aYlGbj3MQXjRIH5qb8Ikn8NwRslwb2evivXsZBAbLMsFMk6JpkI2mdbi72ZpWjF
         6lwg==
X-Gm-Message-State: APjAAAUwOEpEvITvu/qNUXlpBnzvYR+5yCby+CPlPlBt9qvLZfNPadHd
        gZa1ccX2MUSSMNq9tkgBaYF/Iw7eRYk=
X-Google-Smtp-Source: APXvYqwgt2hfL2TJvfr61m8X37Gn70MdhTh+pKILU4xTFz0PJfKwsKptrxFU50qzKrPDZRaiaHRXFQ==
X-Received: by 2002:adf:d4c1:: with SMTP id w1mr17369002wrk.229.1560875569728;
        Tue, 18 Jun 2019 09:32:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:51c0:d03f:68e:1f6d? ([2001:b07:6468:f312:51c0:d03f:68e:1f6d])
        by smtp.gmail.com with ESMTPSA id l124sm4711746wmf.36.2019.06.18.09.32.48
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 09:32:49 -0700 (PDT)
Subject: Re: [PATCH v2] target/i386: define a new MSR based feature word -
 FEAT_CORE_CAPABILITY
To:     Xiaoyao Li <xiaoyao.li@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paul Lai <paul.c.lai@intel.com>
References: <20190617153654.916-1-xiaoyao.li@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <78e052c3-5f85-5343-baac-a0c3d351c3d7@redhat.com>
Date:   Tue, 18 Jun 2019 18:32:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190617153654.916-1-xiaoyao.li@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/06/19 17:36, Xiaoyao Li wrote:
> MSR IA32_CORE_CAPABILITY is a feature-enumerating MSR, which only
> enumerates the feature split lock detection (via bit 5) by now.
> 
> The existence of MSR IA32_CORE_CAPABILITY is enumerated by CPUID.7_0:EDX[30].
> 
> The latest kernel patches about them can be found here:
> https://lkml.org/lkml/2019/4/24/1909
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
> ---
> Changelog:
> v2
>     Add definition of MSR_CORE_CAP_SPLIT_LOCK_DETECT for SNR cpu model
> ---
>  target/i386/cpu.c | 22 +++++++++++++++++++++-
>  target/i386/cpu.h |  5 +++++
>  target/i386/kvm.c |  9 +++++++++
>  3 files changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index fbed2eb804..fc47c650b8 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1085,7 +1085,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>              NULL, NULL, NULL, NULL,
>              NULL, NULL, NULL, NULL,
>              NULL, NULL, "spec-ctrl", "stibp",
> -            NULL, "arch-capabilities", NULL, "ssbd",
> +            NULL, "arch-capabilities", "core-capability", "ssbd",
>          },
>          .cpuid = {
>              .eax = 7,
> @@ -1203,6 +1203,26 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>              }
>          },
>      },
> +    [FEAT_CORE_CAPABILITY] = {
> +        .type = MSR_FEATURE_WORD,
> +        .feat_names = {
> +            NULL, NULL, NULL, NULL,
> +            NULL, "split-lock-detect", NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +        },
> +        .msr = {
> +            .index = MSR_IA32_CORE_CAPABILITY,
> +            .cpuid_dep = {
> +                FEAT_7_0_EDX,
> +                CPUID_7_0_EDX_CORE_CAPABILITY,
> +            },
> +        },
> +    },
>  };
>  
>  typedef struct X86RegisterInfo32 {
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 0732e059ec..192b0db076 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -345,6 +345,7 @@ typedef enum X86Seg {
>  #define MSR_IA32_SPEC_CTRL              0x48
>  #define MSR_VIRT_SSBD                   0xc001011f
>  #define MSR_IA32_PRED_CMD               0x49
> +#define MSR_IA32_CORE_CAPABILITY        0xcf
>  #define MSR_IA32_ARCH_CAPABILITIES      0x10a
>  #define MSR_IA32_TSCDEADLINE            0x6e0
>  
> @@ -496,6 +497,7 @@ typedef enum FeatureWord {
>      FEAT_XSAVE_COMP_LO, /* CPUID[EAX=0xd,ECX=0].EAX */
>      FEAT_XSAVE_COMP_HI, /* CPUID[EAX=0xd,ECX=0].EDX */
>      FEAT_ARCH_CAPABILITIES,
> +    FEAT_CORE_CAPABILITY,
>      FEATURE_WORDS,
>  } FeatureWord;
>  
> @@ -687,6 +689,7 @@ typedef uint32_t FeatureWordArray[FEATURE_WORDS];
>  #define CPUID_7_0_EDX_AVX512_4FMAPS (1U << 3) /* AVX512 Multiply Accumulation Single Precision */
>  #define CPUID_7_0_EDX_SPEC_CTRL     (1U << 26) /* Speculation Control */
>  #define CPUID_7_0_EDX_ARCH_CAPABILITIES (1U << 29)  /*Arch Capabilities*/
> +#define CPUID_7_0_EDX_CORE_CAPABILITY   (1U << 30)  /*Core Capability*/
>  #define CPUID_7_0_EDX_SPEC_CTRL_SSBD  (1U << 31) /* Speculative Store Bypass Disable */
>  
>  #define CPUID_8000_0008_EBX_WBNOINVD  (1U << 9)  /* Write back and
> @@ -734,6 +737,8 @@ typedef uint32_t FeatureWordArray[FEATURE_WORDS];
>  #define MSR_ARCH_CAP_SKIP_L1DFL_VMENTRY (1U << 3)
>  #define MSR_ARCH_CAP_SSB_NO     (1U << 4)
>  
> +#define MSR_CORE_CAP_SPLIT_LOCK_DETECT  (1U << 5)
> +
>  #ifndef HYPERV_SPINLOCK_NEVER_RETRY
>  #define HYPERV_SPINLOCK_NEVER_RETRY             0xFFFFFFFF
>  #endif
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 6899061b4e..da99e91ea9 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -95,6 +95,7 @@ static bool has_msr_spec_ctrl;
>  static bool has_msr_virt_ssbd;
>  static bool has_msr_smi_count;
>  static bool has_msr_arch_capabs;
> +static bool has_msr_core_capabs;
>  
>  static uint32_t has_architectural_pmu_version;
>  static uint32_t num_architectural_pmu_gp_counters;
> @@ -1515,6 +1516,9 @@ static int kvm_get_supported_msrs(KVMState *s)
>                  case MSR_IA32_ARCH_CAPABILITIES:
>                      has_msr_arch_capabs = true;
>                      break;
> +                case MSR_IA32_CORE_CAPABILITY:
> +                    has_msr_core_capabs = true;
> +                    break;
>                  }
>              }
>          }
> @@ -2041,6 +2045,11 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>                            env->features[FEAT_ARCH_CAPABILITIES]);
>      }
>  
> +    if (has_msr_core_capabs) {
> +        kvm_msr_entry_add(cpu, MSR_IA32_CORE_CAPABILITY,
> +                          env->features[FEAT_CORE_CAPABILITY]);
> +    }
> +
>      /*
>       * The following MSRs have side effects on the guest or are too heavy
>       * for normal writeback. Limit them to reset or full state updates.
> 

Queued, thanks.

Paolo
