Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0463526336
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 15:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbiEMNjI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 09:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381510AbiEMNhk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 09:37:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A6EA3E2E
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 06:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652449057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dje7gUvz5ERjOzAnMi7xaWYpJ+DQ4JH+qWGxndahImg=;
        b=IQLwMWb+qMlKhcgGoQXFw8AvLzw4LWiWgT8bWyet79WPnUuZZ2qHL1/5BxUxCo5TQ+ZcJo
        H+CSPR62lpGuunmijENB3Rl9AGTeUuSB/a2SSacbpgn44m3WTWapTLcR1bmmKEc7U+feQs
        wBNq2o+5a9gALkG4QknNuoMZqFutES0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-213-MyWDmfQxNhirRA4tsGhWqA-1; Fri, 13 May 2022 09:37:36 -0400
X-MC-Unique: MyWDmfQxNhirRA4tsGhWqA-1
Received: by mail-wm1-f69.google.com with SMTP id bg7-20020a05600c3c8700b0039468585269so2937726wmb.3
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 06:37:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dje7gUvz5ERjOzAnMi7xaWYpJ+DQ4JH+qWGxndahImg=;
        b=sDrcVpDmlugPkuvdnzYiF0wLgPtwDa7XQrWdgXndPYRVfsJxYx4ufjKeMcowBuU0D0
         8NSuxuxsqbMqrPs3mkARndX7ysJww+3sRIvBzdbE7nJnryrONNSEcR02rKVkbPkN5Lue
         zsJK+I3qX6eaNAumxKocgtIhppHgrczY2CrGDe/4LZ7x/xsh1WJmnoN/B3vVuPnboxQ0
         NmKsiZUrQy3VeUjsPuLf39Nz+R/Ee6JykmnDZt6Mv7MN4q8IkM36HFqUolkOYP0HrkqP
         dvCz9N2xbX+Yrg7iTjH+8j1uCsnXQ+awH9H0SjqNiwnJEOTPqehpxzdffEQJpkzqDNLq
         c2SQ==
X-Gm-Message-State: AOAM530eyFOXyGJSLEaUV1FOK5e+xp7PO7LLYRNUeuIPKN39c7gUE/SS
        x8BYlz2rxLbFIVetQfK966BIgGDKW0NSaYizVzmZtqZytawDYViFERBEF7FQNgfkskdjfQiTk37
        EZTf9trOrU/6r
X-Received: by 2002:a05:600c:4e51:b0:394:513b:934 with SMTP id e17-20020a05600c4e5100b00394513b0934mr4665794wmq.164.1652449054063;
        Fri, 13 May 2022 06:37:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzB5jwJ9OltT4QNOsvYvSZjyOhEyx2rmKexRGPVscnMucHyLNhAAmmeeONvGi+npOrZkTNTHA==
X-Received: by 2002:a05:600c:4e51:b0:394:513b:934 with SMTP id e17-20020a05600c4e5100b00394513b0934mr4665778wmq.164.1652449053816;
        Fri, 13 May 2022 06:37:33 -0700 (PDT)
Received: from redhat.com ([2.53.15.195])
        by smtp.gmail.com with ESMTPSA id t21-20020adfa2d5000000b0020c5253d901sm2144190wra.77.2022.05.13.06.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 06:37:32 -0700 (PDT)
Date:   Fri, 13 May 2022 09:37:26 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     qemu-devel@nongnu.org, Peter Xu <peterx@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Claudio Fontana <cfontana@suse.de>,
        Igor Mammedov <imammedo@redhat.com>,
        Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>
Subject: Re: [PATCH 1/4] target/i386: Fix sanity check on max APIC ID /
 X2APIC enablement
Message-ID: <20220513093616-mutt-send-email-mst@kernel.org>
References: <20220314142544.150555-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314142544.150555-1-dwmw2@infradead.org>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 14, 2022 at 02:25:41PM +0000, David Woodhouse wrote:
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
> 
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> Acked-by: Claudio Fontana <cfontana@suse.de>


Fow now I applied this as-is, in particular because if the added split
irqchip test make check started failing for me on Fedora.
Igor please go ahead and make a change on top limiting things
to the split irqchip.

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
> -- 
> 2.33.1

