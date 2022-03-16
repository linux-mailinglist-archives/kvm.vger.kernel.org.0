Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D126D4DAD29
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 10:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345055AbiCPJFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 05:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiCPJFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 05:05:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4866B517D6
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 02:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647421471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p4b18JDdIA23xku1asRfU8GSHk5Hq4wQ8NYHafXEvJw=;
        b=Yaxx6FcltDWy2LOOxZfGfLMo/7HIlRXilWehR5OA+3llT9AqV08aTp49cnfwB2dtv2Q1gq
        QLvYGhyekRc5pIvZWa7C8nUN0lVHoHdvrOHQvA2Zw+6SB+Z+HzMEppdGNBB30FLQZ98QY7
        AFE07yaMMTWfJTB99Fqpl17cHodwSl0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-110-ZZiqXhfTOTOJLldNSEaJYg-1; Wed, 16 Mar 2022 05:04:30 -0400
X-MC-Unique: ZZiqXhfTOTOJLldNSEaJYg-1
Received: by mail-ed1-f69.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso924313edt.20
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 02:04:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p4b18JDdIA23xku1asRfU8GSHk5Hq4wQ8NYHafXEvJw=;
        b=KghG05/a7KxN0WXjsbplO41j5oVNKEm7ShQFPv9nb+izhhkFKFCW6fYv+cRFnyyBZn
         yvJxdAk7DYuFDU0cq1U8vzb3QTtalJOGTrCyPs/554FIeh9Ywst+rnnOmvnRhlAsFHlt
         ie9K4hSPRCLgTavU40sfaofFc0/TWxvQa6dFrFhne39bZohm5QoGXGlEERvlvjdJR4nR
         MFqB3i/8zj6Us7AGsTc1AkmbUjrR/YXeujU6x0HJxd2CUNb4NvMTmCNTEXFoI6YfgVB9
         KC7tNKahCOMmNuqq5PXORGC18qrHYu7ojHwnDNsuxz6MWxjTRuwz+L2nCjIUFZgtCk9S
         oPNg==
X-Gm-Message-State: AOAM533iLKs+UxyqHTivvHlECp2xdeS8BJ1sy0ERiNibJwIWQrbkyBdY
        6W0aAwaSp//8q4J2wOMfrIQPfQ7ztpjVpY66krFesNjqUz6eq/eKgiFFUYU3JodH2G2oxgfE6GW
        JinHYFNuIdWg3
X-Received: by 2002:a05:6402:484:b0:415:d931:cb2f with SMTP id k4-20020a056402048400b00415d931cb2fmr28755270edv.287.1647421468055;
        Wed, 16 Mar 2022 02:04:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6vbOkdX2sZ4j3IBSv1ToNL65ZV2X37CiLr293SLnqCYWmt7SMpyk8T2yzkY8h6wuWJMj7tQ==
X-Received: by 2002:a05:6402:484:b0:415:d931:cb2f with SMTP id k4-20020a056402048400b00415d931cb2fmr28755251edv.287.1647421467847;
        Wed, 16 Mar 2022 02:04:27 -0700 (PDT)
Received: from localhost (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id bm24-20020a170906c05800b006d58518e55fsm612760ejb.46.2022.03.16.02.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 02:04:27 -0700 (PDT)
Date:   Wed, 16 Mar 2022 10:04:25 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Claudio Fontana <cfontana@suse.de>,
        "Daniel P . =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>
Subject: Re: [PATCH 1/4] target/i386: Fix sanity check on max APIC ID /
 X2APIC enablement
Message-ID: <20220316100425.2758afc3@redhat.com>
In-Reply-To: <20220314142544.150555-1-dwmw2@infradead.org>
References: <20220314142544.150555-1-dwmw2@infradead.org>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Mar 2022 14:25:41 +0000
David Woodhouse <dwmw2@infradead.org> wrote:

> The check on x86ms->apic_id_limit in pc_machine_done() had two problems.
> 
> Firstly, we need KVM to support the X2APIC API in order to allow IRQ
> delivery to APICs >= 255. So we need to call/check kvm_enable_x2apic(),
> which was done elsewhere in *some* cases but not all.
> 
> Secondly, microvm needs the same check. So move it from pc_machine_done()
> to x86_cpus_init() where it will work for both.
> 
> The check in kvm_cpu_instance_init() is now redundant and can be dropped.

Well, I retested with the latest upstream kernel (both guest and host),
and adding kvm_enable_x2apic() is not sufficient as guest according
to your patches in kernel caps max APICID at 255 unless kvm-msi-ext-dest-id
is enabled. And attempt in enabling kvm-msi-ext-dest-id with kernel-irqchip
fails.
So number of usable CPUs in guest stays at legacy level, leaving the rest
of CPUs in limbo.


> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> Acked-by: Claudio Fontana <cfontana@suse.de>
> ---
>  hw/i386/pc.c              |  8 --------
>  hw/i386/x86.c             | 16 ++++++++++++++++
>  target/i386/kvm/kvm-cpu.c |  2 +-
>  3 files changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index fd55fc725c..d3ab28fec5 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -740,14 +740,6 @@ void pc_machine_done(Notifier *notifier, void *data)
>          /* update FW_CFG_NB_CPUS to account for -device added CPUs */
>          fw_cfg_modify_i16(x86ms->fw_cfg, FW_CFG_NB_CPUS, x86ms->boot_cpus);
>      }
> -
> -
> -    if (x86ms->apic_id_limit > 255 && !xen_enabled() &&
> -        !kvm_irqchip_in_kernel()) {
> -        error_report("current -smp configuration requires kernel "
> -                     "irqchip support.");
> -        exit(EXIT_FAILURE);
> -    }
>  }
>  
>  void pc_guest_info_init(PCMachineState *pcms)
> diff --git a/hw/i386/x86.c b/hw/i386/x86.c
> index 4cf107baea..8da55d58ea 100644
> --- a/hw/i386/x86.c
> +++ b/hw/i386/x86.c
> @@ -39,6 +39,7 @@
>  #include "sysemu/replay.h"
>  #include "sysemu/sysemu.h"
>  #include "sysemu/cpu-timers.h"
> +#include "sysemu/xen.h"
>  #include "trace.h"
>  
>  #include "hw/i386/x86.h"
> @@ -123,6 +124,21 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
>       */
>      x86ms->apic_id_limit = x86_cpu_apic_id_from_index(x86ms,
>                                                        ms->smp.max_cpus - 1) + 1;
> +
> +    /*
> +     * Can we support APIC ID 255 or higher?
> +     *
> +     * Under Xen: yes.
> +     * With userspace emulated lapic: no
> +     * With KVM's in-kernel lapic: only if X2APIC API is enabled.
> +     */
> +    if (x86ms->apic_id_limit > 255 && !xen_enabled() &&
> +        (!kvm_irqchip_in_kernel() || !kvm_enable_x2apic())) {
> +        error_report("current -smp configuration requires kernel "
> +                     "irqchip and X2APIC API support.");
> +        exit(EXIT_FAILURE);
> +    }
> +
>      possible_cpus = mc->possible_cpu_arch_ids(ms);
>      for (i = 0; i < ms->smp.cpus; i++) {
>          x86_cpu_new(x86ms, possible_cpus->cpus[i].arch_id, &error_fatal);
> diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
> index d95028018e..c60cb2dafb 100644
> --- a/target/i386/kvm/kvm-cpu.c
> +++ b/target/i386/kvm/kvm-cpu.c
> @@ -165,7 +165,7 @@ static void kvm_cpu_instance_init(CPUState *cs)
>          /* only applies to builtin_x86_defs cpus */
>          if (!kvm_irqchip_in_kernel()) {
>              x86_cpu_change_kvm_default("x2apic", "off");
> -        } else if (kvm_irqchip_is_split() && kvm_enable_x2apic()) {
> +        } else if (kvm_irqchip_is_split()) {
>              x86_cpu_change_kvm_default("kvm-msi-ext-dest-id", "on");
>          }
>  

