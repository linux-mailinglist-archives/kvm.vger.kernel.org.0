Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31843661794
	for <lists+kvm@lfdr.de>; Sun,  8 Jan 2023 18:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbjAHRjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 12:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235924AbjAHRjU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 12:39:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB858F5AD
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 09:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673199517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ospAaWs2G/JeimFgX2rChYxXvF/0gkVJgZbjj+MuJNE=;
        b=OwKR8MNcogCqmB147f5tGBvFGhK5GioO3YKO/Jr49pYo8pOFWpisQXl6aR4Rf/suT5Uknq
        ozUIksj17X38t735J44z1+BUByz2gF8PSaAxQd+ySvfsO6c2M8zPSdyH2iZe2v/uJy+sbl
        ldQQpeZS77qvn/24P+NUHaQRXdpGqKo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-44-kne1DERZMfyHGPQgxjvLDg-1; Sun, 08 Jan 2023 12:38:35 -0500
X-MC-Unique: kne1DERZMfyHGPQgxjvLDg-1
Received: by mail-ed1-f69.google.com with SMTP id y21-20020a056402359500b0048123f0f8deso4006371edc.23
        for <kvm@vger.kernel.org>; Sun, 08 Jan 2023 09:38:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ospAaWs2G/JeimFgX2rChYxXvF/0gkVJgZbjj+MuJNE=;
        b=srJyCgyTNk0WqCGUNqLPv4T/IfTV7kTbEGsllrd1TT4LSu75zhG+7nT70fbeX8aCW1
         SDjXM/tLQE61NloyLenLWuej5aV6/r2VaA7snuBL095T8kosjA3GKv9DCBzDSznzou+B
         KVm/XI/ywuDHyVNv+PRIYS0wAMZ49vHxIaXtQobMarfdJ/ZA9w9UElHt2AAVeC34VZlw
         3a/WQdJTTU+wpJ4Y1OLmmyS/F1aSa/CpXY650WTpdbn74CbKdP8Z1awXjHRcg6Jp7HCj
         p7Pdonmv6ebxhfmjue6VD62GF99OPT4/NUoHvUt6n2YiQcUevfHMYeFso+W8JVtDz2wQ
         TuHQ==
X-Gm-Message-State: AFqh2kqhDAfrASrbhZEpBDwxWrtBaanVhl+W8idIg/PYdafqLS42kQbg
        lTEz9jIuSo+lJGYb+vK+o11vPYTS1iEYZBY2j1RNvzw0a5tCCK4HsWcawY4rhM/UApqhfyudDKW
        1uSUPHXWJGKFZ
X-Received: by 2002:a17:907:6e16:b0:7c0:9f6f:6d8 with SMTP id sd22-20020a1709076e1600b007c09f6f06d8mr68968964ejc.2.1673199514519;
        Sun, 08 Jan 2023 09:38:34 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs8XML+gYNBuoTC6l6oUvO1lDn1E1It03N6XT+5yMwdlbQ8IGFTStMzOSvIv+eI/F20YPTC1w==
X-Received: by 2002:a17:907:6e16:b0:7c0:9f6f:6d8 with SMTP id sd22-20020a1709076e1600b007c09f6f06d8mr68968950ejc.2.1673199514359;
        Sun, 08 Jan 2023 09:38:34 -0800 (PST)
Received: from starship ([89.237.103.62])
        by smtp.gmail.com with ESMTPSA id sb25-20020a1709076d9900b007b2a58e31dasm2703474ejc.145.2023.01.08.09.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 09:38:33 -0800 (PST)
Message-ID: <5dbe58d89f8a65ecfebdaf5cb263b9b4e359ce55.camel@redhat.com>
Subject: Re: [PATCH 4/6] KVM: x86: Split out logic to generate "readable"
 APIC regs mask to helper
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Orr <marcorr@google.com>, Ben Gardon <bgardon@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>
Date:   Sun, 08 Jan 2023 19:38:32 +0200
In-Reply-To: <20230107011025.565472-5-seanjc@google.com>
References: <20230107011025.565472-1-seanjc@google.com>
         <20230107011025.565472-5-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2023-01-07 at 01:10 +0000, Sean Christopherson wrote:
> Move the generation of the readable APIC regs bitmask to a standalone
> helper so that VMX can use the mask for its MSR interception bitmaps.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 34 +++++++++++++++++++++-------------
>  arch/x86/kvm/lapic.h |  2 ++
>  2 files changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index c49b13418638..19697fe9b2c7 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1529,12 +1529,9 @@ static inline struct kvm_lapic *to_lapic(struct kvm_io_device *dev)
>  #define APIC_REGS_MASK(first, count) \
>  	(APIC_REG_MASK(first) * ((1ull << (count)) - 1))
>  
> -static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
> -			      void *data)
> +u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic)
>  {
> -	unsigned char alignment = offset & 0xf;
> -	u32 result;
> -	/* this bitmask has a bit cleared for each reserved register */
> +	/* Leave bits '0' for reserved and write-only registers. */
>  	u64 valid_reg_mask =
>  		APIC_REG_MASK(APIC_ID) |
>  		APIC_REG_MASK(APIC_LVR) |
> @@ -1560,22 +1557,33 @@ static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
>  	if (kvm_lapic_lvt_supported(apic, LVT_CMCI))
>  		valid_reg_mask |= APIC_REG_MASK(APIC_LVTCMCI);
>  
> -	/*
> -	 * ARBPRI, DFR, and ICR2 are not valid in x2APIC mode.  WARN if KVM
> -	 * reads ICR in x2APIC mode as it's an 8-byte register in x2APIC and
> -	 * needs to be manually handled by the caller.
> -	 */
> +	/* ARBPRI, DFR, and ICR2 are not valid in x2APIC mode. */
>  	if (!apic_x2apic_mode(apic))
>  		valid_reg_mask |= APIC_REG_MASK(APIC_ARBPRI) |
>  				  APIC_REG_MASK(APIC_DFR) |
>  				  APIC_REG_MASK(APIC_ICR2);
> -	else
> -		WARN_ON_ONCE(offset == APIC_ICR);
> +
> +	return valid_reg_mask;
> +}
> +EXPORT_SYMBOL_GPL(kvm_lapic_readable_reg_mask);
> +
> +static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
> +			      void *data)
> +{
> +	unsigned char alignment = offset & 0xf;
> +	u32 result;
> +
> +	/*
> +	 * WARN if KVM reads ICR in x2APIC mode, as it's an 8-byte register in
> +	 * x2APIC and needs to be manually handled by the caller.
> +	 */
> +	WARN_ON_ONCE(apic_x2apic_mode(apic) && offset == APIC_ICR);
>  
>  	if (alignment + len > 4)
>  		return 1;
>  
> -	if (offset > 0x3f0 || !(valid_reg_mask & APIC_REG_MASK(offset)))
> +	if (offset > 0x3f0 ||
> +	    !(kvm_lapic_readable_reg_mask(apic) & APIC_REG_MASK(offset)))
>  		return 1;
>  
>  	result = __apic_read(apic, offset & ~0xf);
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index df316ede7546..0a0ea4b5dd8c 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -146,6 +146,8 @@ int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
>  int kvm_lapic_set_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len);
>  void kvm_lapic_exit(void);
>  
> +u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic);
> +
>  #define VEC_POS(v) ((v) & (32 - 1))
>  #define REG_POS(v) (((v) >> 5) << 4)
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

