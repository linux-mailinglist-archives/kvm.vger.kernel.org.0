Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12DFD7918D3
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 15:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239112AbjIDNmP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 09:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjIDNmN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 09:42:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C28198C
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 06:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693834818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ybX7f7bAE82t3NvaDRdD2Bv2sV2dup/rJ1RYllQVyTI=;
        b=SQkIHujXSFyqVRtrLNPF2QTZRdx3Jl3lYZkRZZOTvpxAilWoI8sBwWY4exi3JN0ycDBpUt
        sH3dVR1nhGUXIwReexzEpn0Ur2DEwc3CnReIB2jTgiuAjbeB8B29l3RLW0bJy5CWQYsSdW
        PchWrEb4pdxYLuLIpWqhntckOZyrQg8=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-97-oglL4_eePGer7NXEKbBPlg-1; Mon, 04 Sep 2023 09:40:17 -0400
X-MC-Unique: oglL4_eePGer7NXEKbBPlg-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-50084bf5da1so1529520e87.0
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 06:40:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693834816; x=1694439616;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ybX7f7bAE82t3NvaDRdD2Bv2sV2dup/rJ1RYllQVyTI=;
        b=Ft/5atWazuI2a0PhXDCrcAwGIHwDCxtal8K9JPJ7gNewhGQGFG2R137eHPcPvZumYc
         Cz/EFZY11cnz69wd83hBlvV4q57W+BBbmkYCLTWJ7Ngkh45g0vMdjLd9WPou+vDpXiYX
         NLNp9BwIjMA/oGKVs3gdimGFL7cyB+VqQDGXc21BQ5ZbM+pdh2tUBU+wz2PdHZyOkTcC
         AA912kd6yRdeLJU8DEQotvq4GvALnyxWaUwlN+22mulxbM9ns1hHhOOvtJnr2hctSVw/
         cJH+mdnxs3z8gaW5q1EHlwE+uZzbpmtI5sQ7S2FVSC+RKAKHnHPncoo5FTWvq2M6erUV
         Lrow==
X-Gm-Message-State: AOJu0YwxxFiYZLohm35Ri87FLwqDbfQeFmC98eg7mh71Pai3e7Inb/0e
        LopjTnxVbKssNUrjJ4jKexYxLR2SXLLprxmWS3Ia2d2baMbPS7cVP+F97H6SGqFTAnfn2tA8ynx
        KMAdh20mj2oD4
X-Received: by 2002:a19:761a:0:b0:500:a368:a962 with SMTP id c26-20020a19761a000000b00500a368a962mr5727653lff.43.1693834816043;
        Mon, 04 Sep 2023 06:40:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF2/XtxuVlxB4/EWyheU+X5EwxV5jHkgwv144yyWkMy25vIixUm43Z48pPaZRSoxXwX4P36TA==
X-Received: by 2002:a19:761a:0:b0:500:a368:a962 with SMTP id c26-20020a19761a000000b00500a368a962mr5727636lff.43.1693834815650;
        Mon, 04 Sep 2023 06:40:15 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id n10-20020adffe0a000000b003140f47224csm14482451wrr.15.2023.09.04.06.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Sep 2023 06:40:14 -0700 (PDT)
Message-ID: <4b7bb33a-625d-5ad4-2110-c575b173aad9@redhat.com>
Date:   Mon, 4 Sep 2023 15:40:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 07/13] target/i386: Allow elision of kvm_enable_x2apic()
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
References: <20230904124325.79040-1-philmd@linaro.org>
 <20230904124325.79040-8-philmd@linaro.org>
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230904124325.79040-8-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/4/23 14:43, Philippe Mathieu-Daudé wrote:
> Call kvm_enabled() before kvm_enable_x2apic() to
> let the compiler elide its call.
> 
> Suggested-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   hw/i386/intel_iommu.c      | 2 +-
>   hw/i386/x86.c              | 2 +-
>   target/i386/kvm/kvm-stub.c | 7 -------
>   3 files changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> index 3ca71df369..c9961ef752 100644
> --- a/hw/i386/intel_iommu.c
> +++ b/hw/i386/intel_iommu.c
> @@ -4053,7 +4053,7 @@ static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
>               error_setg(errp, "eim=on requires accel=kvm,kernel-irqchip=split");
>               return false;
>           }
> -        if (!kvm_enable_x2apic()) {
> +        if (kvm_enabled() && !kvm_enable_x2apic()) {
>               error_setg(errp, "eim=on requires support on the KVM side"
>                                "(X2APIC_API, first shipped in v4.7)");
>               return false;
> diff --git a/hw/i386/x86.c b/hw/i386/x86.c
> index a88a126123..d2920af792 100644
> --- a/hw/i386/x86.c
> +++ b/hw/i386/x86.c
> @@ -136,7 +136,7 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
>        * With KVM's in-kernel lapic: only if X2APIC API is enabled.
>        */
>       if (x86ms->apic_id_limit > 255 && !xen_enabled() &&
> -        (!kvm_irqchip_in_kernel() || !kvm_enable_x2apic())) {
> +        kvm_enabled() && (!kvm_irqchip_in_kernel() || !kvm_enable_x2apic())) {

This "!xen && kvm" expression can be simplified.

I am queuing the series with this squashed in:

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index d2920af792d..3e86cf3060f 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -129,14 +129,11 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
                                                        ms->smp.max_cpus - 1) + 1;
  
      /*
-     * Can we support APIC ID 255 or higher?
-     *
-     * Under Xen: yes.
-     * With userspace emulated lapic: no
-     * With KVM's in-kernel lapic: only if X2APIC API is enabled.
+     * Can we support APIC ID 255 or higher?  With KVM, that requires
+     * both in-kernel lapic and X2APIC userspace API.
       */
-    if (x86ms->apic_id_limit > 255 && !xen_enabled() &&
-        kvm_enabled() && (!kvm_irqchip_in_kernel() || !kvm_enable_x2apic())) {
+    if (x86ms->apic_id_limit > 255 && kvm_enabled() &&
+        (!kvm_irqchip_in_kernel() || !kvm_enable_x2apic())) {
          error_report("current -smp configuration requires kernel "
                       "irqchip and X2APIC API support.");
          exit(EXIT_FAILURE);

Paolo

>           error_report("current -smp configuration requires kernel "
>                        "irqchip and X2APIC API support.");
>           exit(EXIT_FAILURE);
> diff --git a/target/i386/kvm/kvm-stub.c b/target/i386/kvm/kvm-stub.c
> index f985d9a1d3..62cccebee4 100644
> --- a/target/i386/kvm/kvm-stub.c
> +++ b/target/i386/kvm/kvm-stub.c
> @@ -12,13 +12,6 @@
>   #include "qemu/osdep.h"
>   #include "kvm_i386.h"
>   
> -#ifndef __OPTIMIZE__
> -bool kvm_enable_x2apic(void)
> -{
> -    return false;
> -}
> -#endif
> -
>   bool kvm_hv_vpindex_settable(void)
>   {
>       return false;

