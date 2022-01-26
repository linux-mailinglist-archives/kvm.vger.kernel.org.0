Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20B249CDBF
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 16:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242644AbiAZPR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 10:17:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23258 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235789AbiAZPR3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 10:17:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643210248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=enco3IhisiiJCqxipp6ORBzLiXPjBMV853tTPBlB3V0=;
        b=M2wsyK+BG4/n2uUTIGYSnYC5DvFL81w12s9nai00H1zBald1g3vYBadEt7XBx1GtgKf0b0
        Wn9WaBMLp40aU24kOGRfV9EpelEpJ8vABr1dWvgGd5iY6aA9psxwWJi3CWaidNvmFIf6PX
        Z+SMhJ7Wu9U+JEEsLIyDwAC/Pp6pJb8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-nCJdNTXQNuCvNK1Jz_2--Q-1; Wed, 26 Jan 2022 10:17:27 -0500
X-MC-Unique: nCJdNTXQNuCvNK1Jz_2--Q-1
Received: by mail-ed1-f71.google.com with SMTP id w23-20020a50d797000000b00406d33c039dso9341091edi.11
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 07:17:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=enco3IhisiiJCqxipp6ORBzLiXPjBMV853tTPBlB3V0=;
        b=5nLvEVMlBPuk7+7ZNM77N87aPucraK7odmoRwRXWPPQoqaJaF7Wd/7Ba7Ce261VhhT
         kD8NSzUZusFWcb2TiuFXAIXYM58a5zSFirTqc0OzMGTkOiH2Z4u62EwvyemYdmNQMrz/
         t61N6OALLIzGraX5mrTs6oJxCIQk88T3Wfqn/oP68rh8DOyiN3tPDVIQiu0X7P2RQR8W
         1OOLZbXlCeJQIK7l0IIwOuzuX5vV3Kr1J09wL85hGwAnecL0T8Fuy9rnhvsr7RI9Th1k
         xu9YlMXxCwnjWz+PstBXfcVmaIs+mYynOandtBUFlV99NDuu/SzS33sLLLiAjth9CYIQ
         Y16g==
X-Gm-Message-State: AOAM530FKppnYOzCok60eIprm559/RmX3PbPBLuYKSylSQ8BdTdw5T7m
        hkrk1EhE6rb+ugPlGSHV8BZBroK52AHsPJ6g43Az4n82v4geLDkv9vh8y4i69YRHVWJNfljSaFg
        jIY5N228Ww0Im
X-Received: by 2002:a05:6402:42d0:: with SMTP id i16mr25601052edc.143.1643210245863;
        Wed, 26 Jan 2022 07:17:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwXMv3eA9lQHhc4IcU2U+Yip2mSW1MIOrMol37/92RnG0VGlb0ODLVMG1k0h0PbwSGsD36zSQ==
X-Received: by 2002:a05:6402:42d0:: with SMTP id i16mr25601041edc.143.1643210245721;
        Wed, 26 Jan 2022 07:17:25 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id h15sm7636317ejg.144.2022.01.26.07.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 07:17:25 -0800 (PST)
Date:   Wed, 26 Jan 2022 16:17:23 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        reijiw@google.com
Subject: Re: [PATCH 1/2] kvm: selftests: aarch64: fix assert in
 gicv3_access_reg
Message-ID: <20220126151723.xcpa5rdgxmcdv22c@gator>
References: <20220120173905.1047015-1-ricarkol@google.com>
 <20220120173905.1047015-2-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120173905.1047015-2-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 20, 2022 at 09:39:04AM -0800, Ricardo Koller wrote:
> The val argument in gicv3_access_reg can have any value when used for a
> read, not necessarily 0.  Fix the assert by checking val only for
> writes.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reported-by: Reiji Watanabe <reijiw@google.com>
> Cc: Andrew Jones <drjones@redhat.com>
> ---
>  tools/testing/selftests/kvm/lib/aarch64/gic_v3.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> index 00f613c0583c..e4945fe66620 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> @@ -159,7 +159,7 @@ static void gicv3_access_reg(uint32_t intid, uint64_t offset,
>  	uint32_t cpu_or_dist;
>  
>  	GUEST_ASSERT(bits_per_field <= reg_bits);
> -	GUEST_ASSERT(*val < (1U << bits_per_field));
> +	GUEST_ASSERT(!write || *val < (1U << bits_per_field));
>  	/* Some registers like IROUTER are 64 bit long. Those are currently not
>  	 * supported by readl nor writel, so just asserting here until then.
>  	 */
> -- 
> 2.35.0.rc0.227.g00780c9af4-goog
>

 
Reviewed-by: Andrew Jones <drjones@redhat.com>

