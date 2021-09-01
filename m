Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373D53FE548
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 00:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245614AbhIAWLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 18:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244373AbhIAWLP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 18:11:15 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D6EC061575
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 15:10:17 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id a15so1148457iot.2
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 15:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KGjRFCzfFxSnSrNaojtITxfWpjAOQrO+uEsac7dWTTA=;
        b=OOv/w+/psizy/DhiK4zgTzBa+yQSn/axNYDdGlR698y7GMR6zMuAi8a9i4OuVbJLj3
         fxD9JF82Ws31zhzEUgBPX8DyK2uc5kiIr+iDVadf9MWECxBs6evXSoq5kcnSaN46O5bp
         B5VZpg7XIgwW5ytafFIlN9wteWQn88jXrRqcyEjFL0L1h6vjf0ZFDqOolmNB+QJ7q/ak
         3LdJxADcRoOE1RnP3pEbq+pX9f9mXOV4yNFMF89myZ/5WsWQWA4JzdA7i61pov79exlC
         45VVE8GosGLs1VbO1TF3PymyAC3q/7uspmPnOapVMh9PmqySmvvqo1DaS2J8kSn+Q4iu
         z7Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KGjRFCzfFxSnSrNaojtITxfWpjAOQrO+uEsac7dWTTA=;
        b=jLbj/pZKxwaoEzDvMBKPN0GXpEftMVZ3mr+DF+ADIxZaQxXnOtk7ROI+urCGFb9VNH
         TFdQdVaEBZRTZxmDTwvoJNheCrdBBor2QAce5ossLlUN/GMOMv77ohAKXYvXvx4crEnq
         cb/pypCaAZGZWKTKaztYTL6prhT7se+FbmViE1pMoxAs325A04yfsKTKdAxHwGw6pNHO
         XvXrU1BsN4mwWCvlClYj/KcaDUj3dt8sDALbdDH2dgOYd2Mex7c4nAr4rHlXiLFjOmMl
         jrCLFIUhBMjMdk0azOnSpOoZkbx7nv0te9sL1ix9wstDJb8oKut0hEb4LGblTUgOLEej
         ESWA==
X-Gm-Message-State: AOAM5324jQ4voqUrhmAWduzdkgonOhSazcr5R8YTscsWvGqoKYogV4WV
        vdt7ih2DB99L6/BenvE0bv54Hg==
X-Google-Smtp-Source: ABdhPJySzt8yvEcNMvACBvDBo4zdwifpTI+hcV+s3GieMcGv75P4h3hv4hnkMh9HLpsRhVbkfBXl9Q==
X-Received: by 2002:a05:6602:2c07:: with SMTP id w7mr50345iov.122.1630534217200;
        Wed, 01 Sep 2021 15:10:17 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id a17sm489028ios.36.2021.09.01.15.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 15:10:16 -0700 (PDT)
Date:   Wed, 1 Sep 2021 22:10:13 +0000
From:   Oliver Upton <oupton@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 03/12] KVM: arm64: selftests: Add support for cpu_relax
Message-ID: <YS/6RZG7Elr9fPQP@google.com>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-4-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901211412.4171835-4-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 09:14:03PM +0000, Raghavendra Rao Ananta wrote:
> Implement the guest helper routine, cpu_relax(), to yield
> the processor to other tasks.
> 
> The function was derived from
> arch/arm64/include/asm/vdso/processor.h.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  tools/testing/selftests/kvm/include/aarch64/processor.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 082cc97ad8d3..78df059dc974 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -191,6 +191,11 @@ asm(
>  	val;								  \
>  })
>  
> +static inline void cpu_relax(void)
> +{
> +	asm volatile("yield" ::: "memory");
> +}
> +
>  #define isb()		asm volatile("isb" : : : "memory")
>  #define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
>  #define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
> -- 
> 2.33.0.153.gba50c8fa24-goog
> 
