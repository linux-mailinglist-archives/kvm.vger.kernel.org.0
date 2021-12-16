Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88348476A5B
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 07:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234104AbhLPG30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 01:29:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28409 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234099AbhLPG30 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Dec 2021 01:29:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639636164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hltzC0jH0InsE4jc4nIJQXMG5CeN7I/5TezuBuQh9eE=;
        b=RZ3RoD2fxmMbt9u6cYgXd0M7STT1PhN9DtJQG7Q3qEOHxs6LsgcClN9YC3dvkM6cUtir7D
        wwEMf3+GPSEjXvQk/KLugASx67jNHSol2K0OHvX0gyWsNIINfc2bOpEsz1DChp235RYDc+
        Rhg905gdXFgrhUgXn//ta2csUrxKI2Q=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-30-qbHANV3ZPba8KFOU--Wm6Q-1; Thu, 16 Dec 2021 01:29:22 -0500
X-MC-Unique: qbHANV3ZPba8KFOU--Wm6Q-1
Received: by mail-wm1-f70.google.com with SMTP id f202-20020a1c1fd3000000b00344f1cae317so639278wmf.0
        for <kvm@vger.kernel.org>; Wed, 15 Dec 2021 22:29:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hltzC0jH0InsE4jc4nIJQXMG5CeN7I/5TezuBuQh9eE=;
        b=hqoLWULUciX6RzLAY9Pt4C0IldRHPto1wHt/3eNSIMl2VKCCCNhez8XI39dclyw3AQ
         C84415OfvqmkcNqy3e8Y3K8ZBykfi0I0A9CGQP/pZkpNoTj7AMrkAj1YN1ImOxxJ29Mu
         V8g2w6/4a1AqL23rF7CBdOum8THJjOIXm98hl5v7WLrdkv543B1fnxoZXywbgRuK0Oj9
         6ZzwXkZzpVAl6ymZ9R8+tWpU8MdKKqtp340s9xMNiHuaD5wkXhF4740GXXxgNqA08+q2
         cn95+lo48xguGM/wvmgx42Zv3hSmklePpA7CqiomWq9EiIIHN2yxH8mTc7BRNCboE2LD
         fHFw==
X-Gm-Message-State: AOAM5337yXvkBeO7Ldgftrq/nVv5mPAwNAWBHYvZD9/3ldUqFFtoOdf5
        jLWA0QNmjauu1g3zx8wV/5guZllh8kbt2j7eVNJhTCi71qWgZzyOMq2dEBBPSNYDNurejPdngS4
        WQxq08Jg5pOEI
X-Received: by 2002:adf:9142:: with SMTP id j60mr7672052wrj.647.1639636160074;
        Wed, 15 Dec 2021 22:29:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzX+T9NNLdFZLk9doCVVEU/thTxcm8lH7TAils+KIVa32uOr+/Y76DYKjl6obHoWYvFCKXSKQ==
X-Received: by 2002:adf:9142:: with SMTP id j60mr7672033wrj.647.1639636159849;
        Wed, 15 Dec 2021 22:29:19 -0800 (PST)
Received: from xz-m1.local ([64.64.123.12])
        by smtp.gmail.com with ESMTPSA id f18sm3780031wre.7.2021.12.15.22.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 22:29:19 -0800 (PST)
Date:   Thu, 16 Dec 2021 14:29:12 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/4] target/i386: Fix sanity check on max APIC ID /
 X2APIC enablement
Message-ID: <YbrcuC+MEigJpxCS@xz-m1.local>
References: <20211209220840.14889-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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

I'm wondering whether we should still leave it be in the accel code, or is
therer something that guarantees when reaching here kvm accel is initialized?

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
> 

-- 
Peter Xu

