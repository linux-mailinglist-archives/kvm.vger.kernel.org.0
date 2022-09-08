Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7879A5B2060
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 16:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbiIHOTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 10:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbiIHOTU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 10:19:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC86C3F7D
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 07:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662646758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sj0j1/EwNaNiYCgqtvcaX7YkQpfFYYuh+QHYDbdvJLU=;
        b=ZVlfn9U1W15c4s4Dxhx4nvpHM1Xhl0XLAmjGRLTXkIdRlAX7l9RM7+bzChWBWgE8Ns7aCG
        FwG8CZ7ksT3ZyXDJTzEIknwXENZ5E8SA0zFJzpU4AK3QLDKXpqUYmKvaFzSlKx1bPEfOsY
        KPi66C8fAU9jktznFQgiQd69lVqI6vE=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-16-bIWGVXMuN0uJtuUuScpjuQ-1; Thu, 08 Sep 2022 10:19:17 -0400
X-MC-Unique: bIWGVXMuN0uJtuUuScpjuQ-1
Received: by mail-qt1-f198.google.com with SMTP id fv24-20020a05622a4a1800b003445e593889so14460952qtb.2
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 07:19:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=sj0j1/EwNaNiYCgqtvcaX7YkQpfFYYuh+QHYDbdvJLU=;
        b=YIsfoCvjuWYk3aGpFw8K2JYfyHu6VIjm1tUUckkw2bLx9RYYGSg0vrLwtqvUIIsvbP
         HY8BPvKhtirjWr5cxqKOBY2THochlxIsswn5slSyb7iEBmivN72SU8lVgGxrD1p/hW7T
         ySc+6+xeszsr97Dzg3AJwSTPOjKgE1uDHKbfpR8NOLYUKuFLvp8DPPUIeWE5jPCiOtLt
         kUzNOrgr+g2yIL2rEht6Q3ApI3wjbf5EaZ6Usy+jZIO/rGaSokGcf4kiADAdD8jUiI6D
         UYFsRivm1kj0wyIO7hucDMYsg89DtHwcct97lNHGm4l9FBStJ4tXA6GSRDL7acGU321o
         GwjQ==
X-Gm-Message-State: ACgBeo00UvzOxy495mUzDQjMKeXkF8fw2YjLbSFwx2ezlS04DaPqcPEn
        lkDkCIXWxqDjJ2VuE2UGD/zNlQSS97+z9zueCy9hBkq6CImUYyGMGZ9qXHc/n4Jy1AAPDBDzeRT
        Ltw7UjpaVxclA
X-Received: by 2002:a05:620a:4089:b0:6bb:97e6:d5b1 with SMTP id f9-20020a05620a408900b006bb97e6d5b1mr6787895qko.117.1662646757223;
        Thu, 08 Sep 2022 07:19:17 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4/9g+keRZgPRRoaXAzaKw6MuLgieKzN5XyVN5i3GFgAb8TSSvEMf/fkzIKS7MSqD7qCifnhg==
X-Received: by 2002:a05:620a:4089:b0:6bb:97e6:d5b1 with SMTP id f9-20020a05620a408900b006bb97e6d5b1mr6787872qko.117.1662646756967;
        Thu, 08 Sep 2022 07:19:16 -0700 (PDT)
Received: from redhat.com ([45.144.113.243])
        by smtp.gmail.com with ESMTPSA id j7-20020a05620a410700b006bc68cfcdf7sm17723380qko.13.2022.09.08.07.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 07:19:16 -0700 (PDT)
Date:   Thu, 8 Sep 2022 10:19:11 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sergio Lopez <slp@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>
Subject: Re: [PATCH v2 2/2] [RfC] expose host-phys-bits to guest
Message-ID: <20220908101757-mutt-send-email-mst@kernel.org>
References: <20220908113109.470792-1-kraxel@redhat.com>
 <20220908113109.470792-3-kraxel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908113109.470792-3-kraxel@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 08, 2022 at 01:31:09PM +0200, Gerd Hoffmann wrote:
> Move "host-phys-bits" property from cpu->host_phys_bits to
> cpu->env.features[FEAT_KVM_HINTS] (KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID bit).
> 
> This has the effect that the guest can see whenever host-phys-bits
> is turned on or not and act accordingly.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  target/i386/cpu.h      | 3 ---
>  hw/i386/microvm.c      | 7 ++++++-
>  target/i386/cpu.c      | 3 +--
>  target/i386/host-cpu.c | 5 ++++-
>  target/i386/kvm/kvm.c  | 1 +
>  5 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 82004b65b944..b9c6d3d9cac6 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1898,9 +1898,6 @@ struct ArchCPU {
>      /* if true fill the top bits of the MTRR_PHYSMASKn variable range */
>      bool fill_mtrr_mask;
>  
> -    /* if true override the phys_bits value with a value read from the host */
> -    bool host_phys_bits;
> -
>      /* if set, limit maximum value for phys_bits when host_phys_bits is true */
>      uint8_t host_phys_bits_limit;
>  
> diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
> index 52cafa003d8a..316bbc8ef946 100644
> --- a/hw/i386/microvm.c
> +++ b/hw/i386/microvm.c
> @@ -54,6 +54,8 @@
>  #include "kvm/kvm_i386.h"
>  #include "hw/xen/start_info.h"
>  
> +#include "standard-headers/asm-x86/kvm_para.h"
> +
>  #define MICROVM_QBOOT_FILENAME "qboot.rom"
>  #define MICROVM_BIOS_FILENAME  "bios-microvm.bin"
>  
> @@ -424,7 +426,10 @@ static void microvm_device_pre_plug_cb(HotplugHandler *hotplug_dev,
>  {
>      X86CPU *cpu = X86_CPU(dev);
>  
> -    cpu->host_phys_bits = true; /* need reliable phys-bits */
> +    /* need reliable phys-bits */
> +    cpu->env.features[FEAT_KVM_HINTS] |=
> +        (1 << KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID);
> +

Do we need compat machinery for this?

>      x86_cpu_pre_plug(hotplug_dev, dev, errp);
>  }
>  
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 1db1278a599b..d60f4498a3c3 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -778,7 +778,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>      [FEAT_KVM_HINTS] = {
>          .type = CPUID_FEATURE_WORD,
>          .feat_names = {
> -            "kvm-hint-dedicated", NULL, NULL, NULL,
> +            "kvm-hint-dedicated", "host-phys-bits", NULL, NULL,
>              NULL, NULL, NULL, NULL,
>              NULL, NULL, NULL, NULL,
>              NULL, NULL, NULL, NULL,
> @@ -7016,7 +7016,6 @@ static Property x86_cpu_properties[] = {
>      DEFINE_PROP_BOOL("x-force-features", X86CPU, force_features, false),
>      DEFINE_PROP_BOOL("kvm", X86CPU, expose_kvm, true),
>      DEFINE_PROP_UINT32("phys-bits", X86CPU, phys_bits, 0),
> -    DEFINE_PROP_BOOL("host-phys-bits", X86CPU, host_phys_bits, false),
>      DEFINE_PROP_UINT8("host-phys-bits-limit", X86CPU, host_phys_bits_limit, 0),
>      DEFINE_PROP_BOOL("fill-mtrr-mask", X86CPU, fill_mtrr_mask, true),
>      DEFINE_PROP_UINT32("level-func7", X86CPU, env.cpuid_level_func7,
> diff --git a/target/i386/host-cpu.c b/target/i386/host-cpu.c
> index 10f8aba86e53..a1d6b3ac962e 100644
> --- a/target/i386/host-cpu.c
> +++ b/target/i386/host-cpu.c
> @@ -13,6 +13,8 @@
>  #include "qapi/error.h"
>  #include "sysemu/sysemu.h"
>  
> +#include "standard-headers/asm-x86/kvm_para.h"
> +
>  /* Note: Only safe for use on x86(-64) hosts */
>  static uint32_t host_cpu_phys_bits(void)
>  {
> @@ -68,7 +70,8 @@ static uint32_t host_cpu_adjust_phys_bits(X86CPU *cpu)
>          warned = true;
>      }
>  
> -    if (cpu->host_phys_bits) {
> +    if (cpu->env.features[FEAT_KVM_HINTS] &
> +        (1 << KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID)) {
>          /* The user asked for us to use the host physical bits */
>          phys_bits = host_phys_bits;
>          if (cpu->host_phys_bits_limit &&

I think we still want to key this one off host_phys_bits
so it works for e.g. hyperv emulation too.

> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index a1fd1f53791d..3335c57b21b2 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -459,6 +459,7 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
>          }
>      } else if (function == KVM_CPUID_FEATURES && reg == R_EDX) {
>          ret |= 1U << KVM_HINTS_REALTIME;
> +        ret |= 1U << KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID;
>      }
>  
>      return ret;
> -- 
> 2.37.3

