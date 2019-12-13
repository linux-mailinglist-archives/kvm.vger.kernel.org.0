Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD66E11E308
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 12:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfLMLx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 06:53:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33653 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726798AbfLMLx5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 06:53:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576238035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KFc9zrc0lnaWTXScDbTfhkxNxQpAVklGF7JvKKV46Yw=;
        b=NIq0g6l6ZE9JoL1iTfZRt6SKdKhDsLEwn8jkibl/ymV+B47vsIFhA2iark6dfWMV8r1/QO
        h3ihU0G/MC9rHCTV5hD1qgRBNboisq39CcBbGpFOneXC82AiHJv1E46xi10UI9RJGD60Vt
        4nIN+UTiEEXsZIA9Jk1PxiNvfCcuT2o=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-9c81xAPaMoiZ3xjovl76rg-1; Fri, 13 Dec 2019 06:53:54 -0500
X-MC-Unique: 9c81xAPaMoiZ3xjovl76rg-1
Received: by mail-wm1-f70.google.com with SMTP id q21so2247815wmc.7
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 03:53:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KFc9zrc0lnaWTXScDbTfhkxNxQpAVklGF7JvKKV46Yw=;
        b=klE10IWl7sOYioW7Z2L1o5we/ZS9FtzjPuF9HDRkokbG5PhRzHr5f26halHoTE8v3y
         NEtnORVuCnK6co2H7efxUu+87rE1T0QsYSb7zm1lUJ2kmBTSEPHEjdb8YvGdgfFOivXB
         PruQNNQqntDycRCgmLIVshs/+g2gdl1hzTUKvl4wKIOYP2Dt2SL0VJ4kleZPQb181BXl
         oGBniGCKtkarbmXm8bCj9/hwxcWd7z9mcYhgtvv9bkbvxdl7sRUwuA0TzVhCpwaqaDbT
         I4ZLS6/oTL+p0McF702f3RqftPraopumGsxYn/8KQzNFGUm6MiyJ/+6b5Mfchrktg6GB
         3mug==
X-Gm-Message-State: APjAAAXO+LCW3sggItQfRbhUkP6csHavcfkOHiLVBo8sT+U/wQnIw8hB
        xMHK+9NvVX9Tkx6U5Qfb8XOhJ//DlM/vbVeEG5w9ZJwVvVeevKaRKEj5OWvvNyFw41hec/IxHDA
        oBFiUxQLKBqop
X-Received: by 2002:a5d:438c:: with SMTP id i12mr12627052wrq.196.1576238032828;
        Fri, 13 Dec 2019 03:53:52 -0800 (PST)
X-Google-Smtp-Source: APXvYqxE7FtlDzOpp15v3gB8QZ5NmgbfFuNJttdfg1aRcxPzTDf+i1ne4B/nU2LrXS9RYAUmFXdN7A==
X-Received: by 2002:a5d:438c:: with SMTP id i12mr12627035wrq.196.1576238032554;
        Fri, 13 Dec 2019 03:53:52 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id g18sm9437905wmh.48.2019.12.13.03.53.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2019 03:53:51 -0800 (PST)
Subject: Re: [PATCH] hw/i386: De-duplicate gsi_handler() to remove
 kvm_pc_gsi_handler()
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <20191213110736.10767-1-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3d1afe84-9d17-eaea-bddf-62f1c6064ee9@redhat.com>
Date:   Fri, 13 Dec 2019 12:53:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191213110736.10767-1-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/12/19 12:07, Philippe Mathieu-Daudé wrote:
> Both gsi_handler() and kvm_pc_gsi_handler() have the same content,
> except one comment. Move the comment, and de-duplicate the code.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  include/sysemu/kvm.h |  1 -
>  hw/i386/kvm/ioapic.c | 12 ------------
>  hw/i386/pc.c         |  5 ++---
>  3 files changed, 2 insertions(+), 16 deletions(-)
> 
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index 9fe233b9bf..f5d0d0d710 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -515,7 +515,6 @@ int kvm_irqchip_add_irqfd_notifier(KVMState *s, EventNotifier *n,
>  int kvm_irqchip_remove_irqfd_notifier(KVMState *s, EventNotifier *n,
>                                        qemu_irq irq);
>  void kvm_irqchip_set_qemuirq_gsi(KVMState *s, qemu_irq irq, int gsi);
> -void kvm_pc_gsi_handler(void *opaque, int n, int level);
>  void kvm_pc_setup_irq_routing(bool pci_enabled);
>  void kvm_init_irq_routing(KVMState *s);
>  
> diff --git a/hw/i386/kvm/ioapic.c b/hw/i386/kvm/ioapic.c
> index f94729c565..bae7413a39 100644
> --- a/hw/i386/kvm/ioapic.c
> +++ b/hw/i386/kvm/ioapic.c
> @@ -48,18 +48,6 @@ void kvm_pc_setup_irq_routing(bool pci_enabled)
>      }
>  }
>  
> -void kvm_pc_gsi_handler(void *opaque, int n, int level)
> -{
> -    GSIState *s = opaque;
> -
> -    if (n < ISA_NUM_IRQS) {
> -        /* Kernel will forward to both PIC and IOAPIC */
> -        qemu_set_irq(s->i8259_irq[n], level);
> -    } else {
> -        qemu_set_irq(s->ioapic_irq[n], level);
> -    }
> -}
> -
>  typedef struct KVMIOAPICState KVMIOAPICState;
>  
>  struct KVMIOAPICState {
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index ac08e63604..97e9049b71 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -350,6 +350,7 @@ void gsi_handler(void *opaque, int n, int level)
>  
>      DPRINTF("pc: %s GSI %d\n", level ? "raising" : "lowering", n);
>      if (n < ISA_NUM_IRQS) {
> +        /* Under KVM, Kernel will forward to both PIC and IOAPIC */
>          qemu_set_irq(s->i8259_irq[n], level);
>      }
>      qemu_set_irq(s->ioapic_irq[n], level);
> @@ -362,10 +363,8 @@ GSIState *pc_gsi_create(qemu_irq **irqs, bool pci_enabled)
>      s = g_new0(GSIState, 1);
>      if (kvm_ioapic_in_kernel()) {
>          kvm_pc_setup_irq_routing(pci_enabled);
> -        *irqs = qemu_allocate_irqs(kvm_pc_gsi_handler, s, GSI_NUM_PINS);
> -    } else {
> -        *irqs = qemu_allocate_irqs(gsi_handler, s, GSI_NUM_PINS);
>      }
> +    *irqs = qemu_allocate_irqs(gsi_handler, s, GSI_NUM_PINS);
>  
>      return s;
>  }
> 

Queued, thanks.

Paolo

