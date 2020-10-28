Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE7429D430
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 22:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgJ1VuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Oct 2020 17:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbgJ1VuJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Oct 2020 17:50:09 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1E7C0613CF
        for <kvm@vger.kernel.org>; Wed, 28 Oct 2020 14:50:09 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id k65so1126796oih.8
        for <kvm@vger.kernel.org>; Wed, 28 Oct 2020 14:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GCggY7e0E7+nEDdFJbxSTJMV/259kn8n+mAT+V0LfCs=;
        b=TZY0xy2kFqGd+ZGUY4CRMyZLZa8Hbgx5e8LnBp7IOxKc+9+OK4Zz3jPaiZOlWNPJzH
         OW3NGsBwGXMuuPLEBuOMfjyUGUtC6llZQlpH1lKz+64yNjMlPVDu8wFHRjhGnsg2heJB
         G49tB9PpHBeJBQlaBhUGjX9HWMUEo08B3yJiM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GCggY7e0E7+nEDdFJbxSTJMV/259kn8n+mAT+V0LfCs=;
        b=B4cs63RQSbeNBJaYJgFpTFT2zVTXgZxzdhC4VevBT5vJEZ31mG9v4J+FM8o3WsQaqD
         r6WeiRgiyeCkcRT0rdqklVfkjBKN5kPBMWI5sBfTH7DDmHakp825G9e5cpCYqukAxK/l
         H2Ms9TaWEuDBJgvVHPGBoLLUTXT3uN9tY2Q7UpGvNpLJuqvazctis+JDAE5e4GvYaMhe
         9354p5mYJXf763aPByyegtro7czA0r/jpJmfR354OrLJmxhoy31t7ff1/TxUID+bXacL
         qUv/iwxFuASylX0ynjt/kfgRqtUbH0GKm5FFfUra+YFrPYWpQ8NX0CTTDBY7VAgNVCkm
         wExA==
X-Gm-Message-State: AOAM533rZrhjPY4/EByXHbAuZ2K4iLqf6q5SNrFw02gPj/7ZqhcyIZGr
        VrmYZxgx1feFXLR9mlMyJDyWo51zytyH6Q==
X-Google-Smtp-Source: ABdhPJxzcqY8mMTSCp/VBFyB1A2e7ggZHaADS42KkBYmv7xlONUZAyNXRIEqFK1eCAZAFxTteJ2hAQ==
X-Received: by 2002:a17:90b:3785:: with SMTP id mz5mr668722pjb.215.1603918197590;
        Wed, 28 Oct 2020 13:49:57 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w123sm502105pfd.34.2020.10.28.13.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 13:49:56 -0700 (PDT)
Date:   Wed, 28 Oct 2020 13:49:55 -0700
From:   Kees Cook <keescook@chromium.org>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     x86@kernel.org, kvm <kvm@vger.kernel.org>,
        iommu@lists.linux-foundation.org, joro@8bytes.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: Re: [PATCH v3 15/35] PCI: vmd: Use msi_msg shadow structs
Message-ID: <202010281347.2943F5B7@keescook>
References: <e6601ff691afb3266e365a91e8b221179daf22c2.camel@infradead.org>
 <20201024213535.443185-1-dwmw2@infradead.org>
 <20201024213535.443185-16-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201024213535.443185-16-dwmw2@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 24, 2020 at 10:35:15PM +0100, David Woodhouse wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> Use the x86 shadow structs in msi_msg instead of the macros.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  drivers/pci/controller/vmd.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
> index aa1b12bac9a1..72de3c6f644e 100644
> --- a/drivers/pci/controller/vmd.c
> +++ b/drivers/pci/controller/vmd.c
> @@ -18,7 +18,6 @@
>  #include <asm/irqdomain.h>
>  #include <asm/device.h>
>  #include <asm/msi.h>
> -#include <asm/msidef.h>
>  
>  #define VMD_CFGBAR	0
>  #define VMD_MEMBAR1	2
> @@ -131,10 +130,10 @@ static void vmd_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
>  	struct vmd_irq_list *irq = vmdirq->irq;
>  	struct vmd_dev *vmd = irq_data_get_irq_handler_data(data);
>  
> -	msg->address_hi = MSI_ADDR_BASE_HI;
> -	msg->address_lo = MSI_ADDR_BASE_LO |
> -			  MSI_ADDR_DEST_ID(index_from_irqs(vmd, irq));
> -	msg->data = 0;
> +	memset(&msg, 0, sizeof(*msg);

This should be:

+	memset(msg, 0, sizeof(*msg);

https://groups.google.com/g/clang-built-linux/c/N-DfCPz3alg

> +	msg->address_hi = X86_MSI_BASE_ADDRESS_HIGH;
> +	msg->arch_addr_lo.base_address = X86_MSI_BASE_ADDRESS_LOW;
> +	msg->arch_addr_lo.destid_0_7 = index_from_irqs(vmd, irq);
>  }
>  
>  /*
> -- 
> 2.26.2
> 

-- 
Kees Cook
