Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C109752546A
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 20:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357245AbiELSES (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 14:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238781AbiELSEQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 14:04:16 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4FB703C7
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 11:04:14 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id r71so4947250pgr.0
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 11:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v1QbIZe1SWTSb2l4Go+bRTbBo3uijeYEo8m/JNDJBEs=;
        b=gF0JytBSn9OhDNNyaH7h/qZX8B/TiR7oUO+WU4d8Dj6f64VGLF5WWitf/goD0iiO0l
         3o3l8PUxqhmxKB3ppHX/7LftcwckySrKjd+l+yAWxTmd91aY9XndmVU6ae4DRoiNtV76
         EUf1G3aE68Hn+V9P90YZxVS4FWU3QPNoxmWi6NekaUttD1f9OkYtaV4NW5grdewzKxqo
         0f4zmsaHrXzKVtVqgFlu10P/ml+VrELz61ij4QnL13SVjkDHrFte865ibXOv6+dnbv1O
         /17kLKUG2MYmlpXijx1YWH4BRrTbsij2tagqA4GOSTNXNaw+CYLRUmCC6IpOFJXmDZfc
         h8jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v1QbIZe1SWTSb2l4Go+bRTbBo3uijeYEo8m/JNDJBEs=;
        b=5am1p5Lx4Ws6wJyf82/Bppg9fJ22YaksCECUndzI6waBtZ0MbD8lSg/10d4L175SNQ
         tURT2MH3QJTx4Zm/OYyciJzUBRfW7gs2xfIrAJiX9Vr1gzip95rZwTDh8OlsDBl2t058
         VDD/3vsm4jzDQpgxoci3DGV3pF53Zq4SOUFTf+FiYqIafMZjwKTqMFKKXkrNPTFHiVXs
         GEUStUn3afH4SVgJduxSsS6Kzw6CN9MRK4w8tRVosX+61V/iyzk3rnU5wJwI5L0zdkyn
         c2/lpDVT8UjLQbGyysNQzdc/8rb79lt76bVwKitD/vEH/AE3TruYS5EyS1/vsNBb+Rbp
         /cyg==
X-Gm-Message-State: AOAM530PAnEB9u0z7FkmCoCW/6YKGrydBTTBLrkiAmo7bfr4bTWsomes
        n6Z7z6qpjYKD1P6/xr6RzVX9fjgKFq8=
X-Google-Smtp-Source: ABdhPJyYOt+c7xcAOJvhFu/ZqvxN8I7kt2BUj/EwmmxCXTxMhoFaM0hVaIvAhuhob50D/SDcdwo9rg==
X-Received: by 2002:a63:80c6:0:b0:3c2:88f0:9035 with SMTP id j189-20020a6380c6000000b003c288f09035mr674497pgd.606.1652378654142;
        Thu, 12 May 2022 11:04:14 -0700 (PDT)
Received: from localhost ([192.55.54.48])
        by smtp.gmail.com with ESMTPSA id g12-20020aa796ac000000b0050dc76281a8sm118573pfk.130.2022.05.12.11.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 11:04:13 -0700 (PDT)
Date:   Thu, 12 May 2022 11:04:12 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, Gerd Hoffmann <kraxel@redhat.com>,
        Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com
Subject: Re: [RFC PATCH v4 14/36] i386/tdx: Implement user specified tsc
 frequency
Message-ID: <20220512180412.GG2789321@ls.amr.corp.intel.com>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-15-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220512031803.3315890-15-xiaoyao.li@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 12, 2022 at 11:17:41AM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> Reuse "-cpu,tsc-frequency=" to get user wanted tsc frequency and pass it
> to KVM_TDX_INIT_VM.
> 
> Besides, sanity check the tsc frequency to be in the legal range and
> legal granularity (required by TDX module).

Just to make it sure.
You didn't use VM-scoped KVM_SET_TSC_KHZ because KVM side patch is still in
kvm/queue?  Once the patch lands, we should use it.

Thanks,

> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  target/i386/kvm/kvm.c |  8 ++++++++
>  target/i386/kvm/tdx.c | 18 ++++++++++++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index f2d7c3cf59ac..c51125ab200f 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -818,6 +818,14 @@ static int kvm_arch_set_tsc_khz(CPUState *cs)
>      int r, cur_freq;
>      bool set_ioctl = false;
>  
> +    /*
> +     * TD guest's TSC is immutable, it cannot be set/changed via
> +     * KVM_SET_TSC_KHZ, but only be initialized via KVM_TDX_INIT_VM
> +     */
> +    if (is_tdx_vm()) {
> +        return 0;
> +    }
> +
>      if (!env->tsc_khz) {
>          return 0;
>      }
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 9f2cdf640b5c..622efc409438 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -35,6 +35,9 @@
>  #define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
>  #define TDX_TD_ATTRIBUTES_PERFMON           BIT_ULL(63)
>  
> +#define TDX_MIN_TSC_FREQUENCY_KHZ   (100 * 1000)
> +#define TDX_MAX_TSC_FREQUENCY_KHZ   (10 * 1000 * 1000)
> +
>  static TdxGuest *tdx_guest;
>  
>  /* It's valid after kvm_confidential_guest_init()->kvm_tdx_init() */
> @@ -211,6 +214,20 @@ int tdx_pre_create_vcpu(CPUState *cpu)
>          goto out;
>      }
>  
> +    r = -EINVAL;
> +    if (env->tsc_khz && (env->tsc_khz < TDX_MIN_TSC_FREQUENCY_KHZ ||
> +                         env->tsc_khz > TDX_MAX_TSC_FREQUENCY_KHZ)) {
> +        error_report("Invalid TSC %ld KHz, must specify cpu_frequency between [%d, %d] kHz",
> +                      env->tsc_khz, TDX_MIN_TSC_FREQUENCY_KHZ,
> +                      TDX_MAX_TSC_FREQUENCY_KHZ);
> +        goto out;
> +    }
> +
> +    if (env->tsc_khz % (25 * 1000)) {
> +        error_report("Invalid TSC %ld KHz, it must be multiple of 25MHz", env->tsc_khz);
> +        goto out;
> +    }
> +
>      r = setup_td_guest_attributes(x86cpu);
>      if (r) {
>          goto out;
> @@ -221,6 +238,7 @@ int tdx_pre_create_vcpu(CPUState *cpu)
>  
>      init_vm.attributes = tdx_guest->attributes;
>      init_vm.max_vcpus = ms->smp.cpus;
> +    init_vm.tsc_khz = env->tsc_khz;
>  
>      r = tdx_vm_ioctl(KVM_TDX_INIT_VM, 0, &init_vm);
>      if (r < 0) {
> -- 
> 2.27.0
> 
> 

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
