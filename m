Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE06559663B
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 02:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237929AbiHQAHN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 20:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237930AbiHQAHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 20:07:10 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6775F5E66C
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 17:07:08 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id p125so10730696pfp.2
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 17:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=DnaRmL+U+YfuPBRbML9hLskPCbcaMs+gfoPDre5bUhM=;
        b=UDjqHvY5V3lgNcChRgEXtBr8rGjAib3ZD98iy0ySLgzjY4lZN2dkLPvH1EUcXg79+1
         xyLQeV8OiF6H4AzZbXCRSoTJaifNPVOHu9mTFS+XEyzmj9UsYg13wgoC67/t/s3nOyHu
         YOQVTKl+FhSHM+dIl2jbyrHHWGIImApnWL5aAQ+OO7nkw3d1Dexx1MoQrp5Sih9wjIXt
         tm2eAuJ5+N0dM/e8hXtTOcfJyNrxKjmQcoQTqc7EJRVWf9NKn4wPI00n0lgnYVkfjpbP
         lzVLPM70iW0MzJxmrlfwPQ+IDMw7XdwnbFCj6jirb4+mTgESuC7TwMpA/6kJsKYIiyf0
         JOQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=DnaRmL+U+YfuPBRbML9hLskPCbcaMs+gfoPDre5bUhM=;
        b=dOeSfXFZ6IyoTGwzAv9npTTtDy5tr975ryyrQj81QBkN1h38uc/Y2+gQKNTobYRjoZ
         RDMwvW0jbbifZ6N+RPkH3OKNFmz2xQSy4QVqDoUK7+jif6wGqLZEAcvuHe58AWdSX1JX
         u8aLANRniCMd30RSsBMvOA9b8tI2d9WtLT6gfQuGb7Zu52K4gY2S6GexMaOCCtzIaNek
         i34U3ongy5TnQ8qYKdasilXFoFRSC9ltjWGG2hn+J9NsdGuwUaEXkSocoEPLgRP77bB8
         3ZOBsiDDt+Ry0BBpzoLO9/2g4FqmxZSnv3n/wAHV6p/zk/Fkcl38+uG5Y/2ryz16mZ1Y
         401g==
X-Gm-Message-State: ACgBeo0BiursBU6oKy4YYbRbNsRF/Ayw/1HJnH7NOcd/JKhPozlZdPLA
        vbj3KTPBpR68BVVM4brLsLtf+zjaFjEmhA==
X-Google-Smtp-Source: AA6agR7GxRSAFz0PCpFM8GtA24cRoZ34N2x1WIOZ9aAo/rP+sai0986WsVkMk5ITzti52Gm/xnY72g==
X-Received: by 2002:a63:cf0b:0:b0:419:f140:2876 with SMTP id j11-20020a63cf0b000000b00419f1402876mr19553366pgg.303.1660694827780;
        Tue, 16 Aug 2022 17:07:07 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a5-20020aa78e85000000b00518e1251197sm9286836pfr.148.2022.08.16.17.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 17:07:07 -0700 (PDT)
Date:   Wed, 17 Aug 2022 00:07:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com, vkuznets@redhat.com
Subject: Re: [PATCH v2 8/9] KVM: x86: lapic does not have to process INIT if
 it is blocked
Message-ID: <YvwxJzHC5xYnc7CJ@google.com>
References: <20220811210605.402337-1-pbonzini@redhat.com>
 <20220811210605.402337-9-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811210605.402337-9-pbonzini@redhat.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 11, 2022, Paolo Bonzini wrote:
> Do not return true from kvm_apic_has_events, and consequently from
> kvm_vcpu_has_events, if the vCPU is not going to process an INIT.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/i8259.c            | 2 +-
>  arch/x86/kvm/lapic.h            | 2 +-
>  arch/x86/kvm/x86.c              | 5 +++++
>  arch/x86/kvm/x86.h              | 5 -----
>  5 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 293ff678fff5..1ce4ebc41118 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2042,6 +2042,7 @@ void __user *__x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
>  				     u32 size);
>  bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu);
>  bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu);
> +bool kvm_vcpu_latch_init(struct kvm_vcpu *vcpu);
>  
>  bool kvm_intr_is_single_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
>  			     struct kvm_vcpu **dest_vcpu);
> diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
> index e1bb6218bb96..177555eea54e 100644
> --- a/arch/x86/kvm/i8259.c
> +++ b/arch/x86/kvm/i8259.c
> @@ -29,9 +29,9 @@
>  #include <linux/mm.h>
>  #include <linux/slab.h>
>  #include <linux/bitops.h>
> -#include "irq.h"
> +#include <linux/kvm_host.h>
>  
> -#include <linux/kvm_host.h>
> +#include "irq.h"
>  #include "trace.h"
>  
>  #define pr_pic_unimpl(fmt, ...)	\
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 117a46df5cc1..12577ddccdfc 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -225,7 +225,7 @@ static inline bool kvm_vcpu_apicv_active(struct kvm_vcpu *vcpu)
>  
>  static inline bool kvm_apic_has_events(struct kvm_vcpu *vcpu)
>  {
> -	return lapic_in_kernel(vcpu) && vcpu->arch.apic->pending_events;
> +	return lapic_in_kernel(vcpu) && vcpu->arch.apic->pending_events && !kvm_vcpu_latch_init(vcpu);

Blech, the kvm_apic_has_events() name is awful (as is pending_events), e.g. it
really should be kvm_apic_has_pending_sipi_or_init().

To avoid the odd kvm_vcpu_latch_init() declaration and the long line above, what
if we open code this in kvm_vcpu_has_events() like we do for NMI, SMI, etc...?

And as follow-up, I would love to rename kvm_vcpu_latch_init() => kvm_vcpu_init_blocked(),
kvm_apic_has_events(), and pending_events.

E.g. for this patch just do:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9f11b505cbee..559900736a71 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12533,7 +12533,8 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
        if (!list_empty_careful(&vcpu->async_pf.done))
                return true;

-       if (kvm_apic_has_events(vcpu))
+       /* comment explaning that SIPIs are dropped in this case. */
+       if (kvm_apic_has_events(vcpu) && !kvm_vcpu_latch_init(vcpu))
                return true;

        if (vcpu->arch.pv.pv_unhalted)

