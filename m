Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185F4486306
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 11:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238033AbiAFKiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 05:38:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232212AbiAFKiR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Jan 2022 05:38:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641465496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NUC0YRXeoKXluzQDQIK/Y3whFFHC8651FZ8FvN0u72g=;
        b=EcviAOLjL2O8it8JYFU8VNdSEP1t3ve/MG2HWQI0GPUzX00m3cQgatAgvp8Wf56XNz4BJ2
        VvMI2jYi/iPDfCzogTQn8v+bgf8tO3ghz4rvyJghX1JyiDs2OgVrteNNBeEz47Pbo2wJgY
        e+Q4t091DbiohT0X3KSbcIsbXgMJ660=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-0xgkBZIdNu-zFBgKNfPP3g-1; Thu, 06 Jan 2022 05:38:15 -0500
X-MC-Unique: 0xgkBZIdNu-zFBgKNfPP3g-1
Received: by mail-wr1-f72.google.com with SMTP id r1-20020adfb1c1000000b001a4852a806cso1077707wra.9
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 02:38:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NUC0YRXeoKXluzQDQIK/Y3whFFHC8651FZ8FvN0u72g=;
        b=MxS6wV26v7ZqUk5N4wy0jPWkzLPZ+muVlBsb/OZQmwAmucj3fG7CW5RJojVOMfCwro
         vi4hREkBjCBFNY2MetTEa8gFd3bsk6XUpj2eVzfke/B6AtYxGLN+kyiwuvNdNvKlJjCL
         wYaOAUMBpp6JtPFlZty+vjwHKmlkroQWFaBWSMuepYxFj7441S+4bJS9wnovRPTdao9x
         XI2++7GHESIAJc9sMQLO3T+WC+zof0HgvhQf1m5Mwv/8trZ1Bg+vwn4l6UrlHKY4kp46
         GGfJ8jEoEZ9lid/5JyO4lA0lHDO/jvtgXevVinKYTcTEJBLjYY5DXMMYqzfBNn2vxUGE
         I5Pg==
X-Gm-Message-State: AOAM532hEY+DNoOfPHm5H0HKfcZ1XxLeo3zYX3p+LPrxan9zvXitF1O8
        1YC0Y3fyb+U6yrjvCY49FX4/KYwej8x5Quzp6gqptTSBdqxJ5OaNzo9Mky0Qrxun67BKElUsNBU
        3MG/mAOBZ7xAI
X-Received: by 2002:adf:aad6:: with SMTP id i22mr49298205wrc.40.1641465493876;
        Thu, 06 Jan 2022 02:38:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJylk1pKCInzHxlwir57G4ozARZhGjfPcmXqX5THgVgQPPCTisQYurqlosTA2gbzoBHgK50UAA==
X-Received: by 2002:adf:aad6:: with SMTP id i22mr49298191wrc.40.1641465493683;
        Thu, 06 Jan 2022 02:38:13 -0800 (PST)
Received: from redhat.com ([2a03:c5c0:207e:991b:6857:5652:b903:a63b])
        by smtp.gmail.com with ESMTPSA id u3sm2125228wrs.0.2022.01.06.02.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 02:38:12 -0800 (PST)
Date:   Thu, 6 Jan 2022 05:38:09 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     qemu-devel@nongnu.org, Peter Xu <peterx@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/4] target/i386: Fix sanity check on max APIC ID /
 X2APIC enablement
Message-ID: <20220106053739-mutt-send-email-mst@kernel.org>
References: <20211209220840.14889-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209220840.14889-1-dwmw2@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 09, 2021 at 10:08:37PM +0000, David Woodhouse wrote:
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

Could I get an ack from KVM maintainers on this one please?
Thanks!

> ---
>  hw/i386/pc.c              |  8 --------
>  hw/i386/x86.c             | 16 ++++++++++++++++
>  target/i386/kvm/kvm-cpu.c |  2 +-
>  3 files changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index a2ef40ecbc..9959f93216 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -736,14 +736,6 @@ void pc_machine_done(Notifier *notifier, void *data)
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
> index b84840a1bb..f64639b873 100644
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
> @@ -136,6 +137,21 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
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
> 2.31.1

