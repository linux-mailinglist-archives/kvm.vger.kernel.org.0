Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C908D5342FA
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 20:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239981AbiEYSbJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 14:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbiEYSbG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 14:31:06 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFF1B0D36
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 11:31:04 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id a17so3228173plb.4
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 11:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uKEKe+Ju9YvCv725rpneaqx+x5ujavGQB4X6lkKgo/0=;
        b=cOUdrtWPdORQNfPkfg5tljXp1zxMyzR/pXl1JJVzhTE4kaJVif9+cF0sqI2vw7Dn2+
         r2eEw357z974jOUUNAh/c0U+Y8SKE8gZv3V5fd9zLPSWBcGR6LAGtA+SsmXNzS5ZRh2h
         YzMLNabwXsGJTQabDb558PeGgjHV0sDHCm5mLJuRZlnSUYdIb8hZ5tAGETZAnLnK4jwb
         Trmwl1MK3AybGU7ufuKmqqCYH/vSSWNpmpV4l3KRkRQOMprnbf93FM1F3aS4KJZkjm27
         WJ49nn32qT/q1yPdtpOpcGagud3iyI1+xu2BmIfcAbIFPRKrY5vZUKHav/uZb72JA4S9
         r+iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uKEKe+Ju9YvCv725rpneaqx+x5ujavGQB4X6lkKgo/0=;
        b=evvux/IVkGAkjDmD1TeDM83KuviBYD5h9abWmfLhEZE8EMBN1Z/o+CkSNuHVgLB/ic
         0KTvfFC39mHO3UJHGQYcmvtDOSNCs+YhJSTK77QxGQa7dPivFlpf0TOUj/0WeblaHgP7
         bj3WwDB8hXDNBYMu/2EYCkS4519pANw6iWUlRN2+UdlXYC/KQedGl8ovVcWfsfw8zBaI
         /ISAwHkRuagY3x2GLG5VDT0gxoywsZLE3wX4zJHXhVtG1m52Vi2uOXVCKyIQiBks5Yyw
         MSXpkJUbXhjyymCdVDTHTOufT1Tikk286sfvh81D/I+AiMP+Ay4+Iu5EJUEDM2ROn1vo
         R0yQ==
X-Gm-Message-State: AOAM53186r/6pQqBfTtW1mGoJXh1vKDp0YVUx+bh2DSoFhbsV87IVH2H
        zKdAviUtj99agzQfw/C69BbpGA==
X-Google-Smtp-Source: ABdhPJw2EBa/qgrDqKwQullOHbOR3Kuypun6v7iK35/XF4cnLYBwP62MlX48Y4bGmI9FYVvm24KacQ==
X-Received: by 2002:a17:902:9b93:b0:15f:17ce:3b97 with SMTP id y19-20020a1709029b9300b0015f17ce3b97mr34009600plp.174.1653503463763;
        Wed, 25 May 2022 11:31:03 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y14-20020a170902d64e00b001623b7bdd4asm4539088plh.10.2022.05.25.11.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 11:31:03 -0700 (PDT)
Date:   Wed, 25 May 2022 18:30:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Venkatesh Srinivas <venkateshs@chromium.org>
Cc:     kvm@vger.kernel.org, marcorr@google.com
Subject: Re: [PATCH v2 2/2] KVM: Inject #GP on invalid writes to x2APIC
 registers
Message-ID: <Yo5145jNvnlrjubM@google.com>
References: <20220525173933.1611076-1-venkateshs@chromium.org>
 <20220525173933.1611076-2-venkateshs@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525173933.1611076-2-venkateshs@chromium.org>
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

On Wed, May 25, 2022, Venkatesh Srinivas wrote:
> From: Marc Orr <marcorr@google.com>
> 
> From: Venkatesh Srinivas <venkateshs@chromium.org>

Heh, something is wonky in your setup, only Marc should get an explicit From:

> The upper bytes of any x2APIC register are reserved. Inject a #GP
> into the guest if any of these reserved bits are set.
> 
> Signed-off-by: Marc Orr <marcorr@google.com>
> Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
> ---
>  arch/x86/kvm/lapic.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 6f8522e8c492..617e4936c5cc 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2907,6 +2907,8 @@ int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>  
>  	if (!lapic_in_kernel(vcpu) || !apic_x2apic_mode(apic))
>  		return 1;
> +	else if (data >> 32)
> +		return 1;

This is incorrect, ICR is a 64-bit value.  Marc's changelog for the internal patch
was wrong, although the code was correct.

The correct upstream change is:

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 39b805666a18..54d0f350acdf 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2892,6 +2892,9 @@ static int kvm_lapic_msr_write(struct kvm_lapic *apic, u32 reg, u64 data)
        if (reg == APIC_ICR)
                return kvm_x2apic_icr_write(apic, data);

+       if (data >> 32)
+               return 1;
+
        return kvm_lapic_reg_write(apic, reg, (u32)data);
 }

As penance for not testing, can you write a KUT testcase to hit all the registers?
You could use e.g. SIPI to test that a 64-bit ICR value is _not_ rejected.

One thought would be to base your testcase on top of similar changes to msr.c to
blast all of the MCE MSRs, e.g. add a path/helper to enable x2APIC and iterate over
all registers.

[*] https://lore.kernel.org/all/20220512233045.4125471-1-seanjc@google.com
