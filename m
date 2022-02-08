Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2094ADFAA
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 18:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383493AbiBHR3t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 12:29:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242978AbiBHR3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 12:29:48 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8115C061576
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 09:29:44 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id n23so292872pfo.1
        for <kvm@vger.kernel.org>; Tue, 08 Feb 2022 09:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fsUwRxSsX+G8xGWS1HEWow090yW+YYPFlcyEjg1XLVo=;
        b=m8OITRUF3qO3145j2yNxK1mPyFY2YT02Ur6jUYn+GKO1VRlHnMOaWUIL1sJdwvDojR
         oPEc6/htpJRKU8c7xf7vc/wn2V5Vqfmo7MwOGRi3FfJhVDi93iKYQNEc2sDs5ZZw9dCL
         qKk1P7cMBZz3TX6McC1uwcjvFdUosTNzGmXzJHiu62KBM6bTPU0SQEro9mvq0jmA5cfE
         9BHYodaXyLIa6oWQ81Q/yQzq39DQ6xivRV4aZO1F9I05hVxk78XB8o90BuTmvLE/wn7a
         5TO1oR931tzsXvUUr0AytwlFJfTGB/BKojykDfy07jLUMTPNp8PgyRJTz63JOWmSrp6I
         HnlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fsUwRxSsX+G8xGWS1HEWow090yW+YYPFlcyEjg1XLVo=;
        b=t5k+pa3/qpBlZ8wa+uDvwrXh7Q1v9c9wiGbzF2+V59/WLiSvolpDewl56UKJviGC2T
         bItKsJgKnG/PmDNFKfvTmLhNGdnLNHlNM+DUfzZtyCzPtR9J2p6TIlU2E3YQF5DEUsbx
         fp54RH/6qqDxEZNcVkZs6g7AlPBVcJCyIzks+MzBxKMxvXiqZsDMbKBjSP1luTDE4x6E
         lLAMm/XyLnmEsIrH/1ESPtkjsQoEKjkILvYXrmCVpu4s/RFJ15WXRCYlXqtO1y6vpN/8
         //NMQXwt8iXM5sPpMlyJhsmTU0QVEqa8DBl9T8H3BIOZvYjEzlVh0jcukNqFptEggBhY
         m5pw==
X-Gm-Message-State: AOAM533EFUKRZfW0aoZqrFCJCnAaRPDgzaaTnzBdXPSVz+cUuAKH9pT7
        lsVeuhpH4KlyAWHQag0FX0qynQ==
X-Google-Smtp-Source: ABdhPJz6zmIEKBOeOCKKdJ5NUffOHN3XDCXl133mR5D4ANHuh+PWBr7nuWITYY9fxOfb8fUgBYb/GQ==
X-Received: by 2002:a05:6a00:16d4:: with SMTP id l20mr5358471pfc.5.1644341384078;
        Tue, 08 Feb 2022 09:29:44 -0800 (PST)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id y18sm11758088pgh.67.2022.02.08.09.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:29:43 -0800 (PST)
Date:   Tue, 8 Feb 2022 09:29:39 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: vgic: Read HW interrupt pending state from
 the HW
Message-ID: <YgKogzsdCi9K4drb@google.com>
References: <20220208123726.3604198-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208123726.3604198-1-maz@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 08, 2022 at 12:37:26PM +0000, Marc Zyngier wrote:
> It appears that a read access to GIC[DR]_I[CS]PENDRn doesn't always
> result in the pending interrupts being accurately reported if they are
> mapped to a HW interrupt. This is particularily visible when acking
> the timer interrupt and reading the GICR_ISPENDR1 register immediately
> after, for example (the interrupt appears as not-pending while it really
> is...).
> 
> This is because a HW interrupt has its 'active and pending state' kept
> in the *physical* distributor, and not in the virtual one, as mandated
> by the spec (this is what allows the direct deactivation). The virtual
> distributor only caries the pending and active *states* (note the
> plural, as these are two independent and non-overlapping states).
> 
> Fix it by reading the HW state back, either from the timer itself or
> from the distributor if necessary.
> 
> Reported-by: Ricardo Koller <ricarkol@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-mmio.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
> index 7068da080799..49837d3a3ef5 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio.c
> @@ -248,6 +248,8 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
>  						    IRQCHIP_STATE_PENDING,
>  						    &val);
>  			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
> +		} else if (vgic_irq_is_mapped_level(irq)) {
> +			val = vgic_get_phys_line_level(irq);
>  		} else {
>  			val = irq_is_pending(irq);
>  		}
> -- 
> 2.34.1
> 

Thanks Marc!

Tested this fix with a selftest that we are planning to upstream soon.
It fires and handles arch timer IRQs while checking the pending state
along the way.

Tested-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
