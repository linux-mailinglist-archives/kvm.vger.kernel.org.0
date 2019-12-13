Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 325CE11E321
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 13:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfLMMCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 07:02:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54096 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726717AbfLMMCn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 07:02:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576238562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KFc9zrc0lnaWTXScDbTfhkxNxQpAVklGF7JvKKV46Yw=;
        b=VZKWoBzUQB1Khb4k0JSPkgCfH1S0j/mk5SLL5WB0IOGUBep6L0nuFHph1b1rPdh1ppcPdk
        glYc2KJ/netvFjHyzxcdzyeHIGypJdnCAEIhJ6ONvow6NQyN9ou8ziYjDyXqy6nyfr2jSj
        80zpKfZv2hshbRwnrljfvQF4Yue3RP8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-Sa6w3k9QMti5v0EG2gVDQw-1; Fri, 13 Dec 2019 07:02:41 -0500
X-MC-Unique: Sa6w3k9QMti5v0EG2gVDQw-1
Received: by mail-wr1-f70.google.com with SMTP id t3so2475552wrm.23
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 04:02:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KFc9zrc0lnaWTXScDbTfhkxNxQpAVklGF7JvKKV46Yw=;
        b=VOKb259y4sGFFgTj5PCTf7nFibBOyDlKlCdYyxoHUl3INx7XnNAP90Iq52hBtk2RCa
         8BGUIxJRKNu2pERMgD/edS4IvAI0qy8VGnJn8dg/+et93CoZUHsM2R1qYPWdCJhJuo94
         dRB3jzyO6PhCMUmsLongs8CQBp/JAzhf5sRjRmLuRsZLbFmug/i05wE/f2icCrBc3sd0
         j1pdl6SY9FPYajB1Fip1+ib9H+aG+P/nElQ/JKrEvk3PS51/uCdOwH1A5ikAEhslc7D1
         KjL2w/iiz6kwQsT2H6UiRS1Cye3VkgF8Yv0+YDRdNn6K0rGV+h0tDLKe4g2QDfHMAJ83
         61Zw==
X-Gm-Message-State: APjAAAW6o9Yru/8TJ/kfw2pMDlltw/fuKoGnn0efYbGcFEiItEslT8P6
        i+W+JaIrMuQIBtPKWvSKBDCpzplSSmI9oG4e0B5BtU9y1S5xTbUo/iuPsH1/1LUVkEWL8nJC7PQ
        aePUNCw+Tt+g2
X-Received: by 2002:a05:600c:21da:: with SMTP id x26mr12626474wmj.4.1576238559917;
        Fri, 13 Dec 2019 04:02:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqwoCftRM04qYwi72pC5q921M1Ds05cpN5tdRSlsIAa2FJQ3rJ756T/keW2JOQHWPggqcz0ujA==
X-Received: by 2002:a05:600c:21da:: with SMTP id x26mr12626438wmj.4.1576238559671;
        Fri, 13 Dec 2019 04:02:39 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id u8sm9915651wmm.15.2019.12.13.04.02.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2019 04:02:39 -0800 (PST)
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
Message-ID: <02225320-0c42-33d2-6e30-16935eaaa5d2@redhat.com>
Date:   Fri, 13 Dec 2019 13:02:30 +0100
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

