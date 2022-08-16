Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75FC6595E54
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 16:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235927AbiHPO0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 10:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235473AbiHPO0u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 10:26:50 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20B2BA9DB
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 07:26:49 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 24so9376292pgr.7
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 07:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=xxtvqSTTGpNlBZwMQ1VxRmEf46ztEqQH/d/PUohA5hw=;
        b=qcnquCp/HtX2Qy+eSVKR4hzJlwV+nAtJDTiYlZ83QLDsUQnZD0K9ugd5JcQVpNWUNl
         wwkFwzGMJiwXThlWLQtyDJe417YZMTXV0YeX75lZ0ZhEqvDp39juUCkSu9/tGM++X1Mp
         cMln65RmF7IX1iZZ6hPzvZok6qVrKtfG8PVlb+QGZMclIHuBmHdpnCTwompETQVnR7af
         wgGNTcpR6fCpAUYPilwXuBOo1F13MC+yecaBfQzbsO0EjHBwOVfj213kvYkbf47y4WMb
         Qsh/aKQDdf1zb/e1KXnualtWLRxEq3ZRGvLx1cuWAKQaEGDambIAaX6uzKpdKEjH6PKE
         Pkjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=xxtvqSTTGpNlBZwMQ1VxRmEf46ztEqQH/d/PUohA5hw=;
        b=KO5sQds2hOXz/km8lNqlMObX99O3dkIxA+zSZLEtI8fQk8lg6kiEOW0LeRAWRMRNQA
         zC+0uatWlCdkUREuzEVUtDTOmobdtLkjXnT2HwU0TtYBUuX47U98vlNvwwBrAKFABTZ+
         f5/0dwBgtkl7xafpZ9OF/yCWyaotNfqqeYO5fl+Lg+NBKUnumqH06vAxFI0/YGHo4UyB
         x0xeX2+mXPb0ni+ddHAPntWRvzMqjNGfZTM1iOUxVBJisD1ArG7SYA7Wge2N/5trMHJO
         sOABtSgQRQXihV8zu1Z1DssxA2Nmu3wUO64Tc2F3LvXngfAFt3CBxaMnA43g1MCpTDYi
         LP8w==
X-Gm-Message-State: ACgBeo3Lrw+PIsWyz9SfPGBKRok181RfBOYBSzLrdN/+MQYAlrP0O6RT
        GS0c5sEmcr+FC8TlPjSIx1DR+w==
X-Google-Smtp-Source: AA6agR4WWnbzqai8APk1Xxdaooy6RcWu8SH4QdJZ5dlsXpQEdsjZwdG73cTN4oUcJZHu2CULEo5cXg==
X-Received: by 2002:a65:4c0e:0:b0:41b:c11a:c006 with SMTP id u14-20020a654c0e000000b0041bc11ac006mr18516615pgq.299.1660660009087;
        Tue, 16 Aug 2022 07:26:49 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w11-20020a1709029a8b00b00168dadc7354sm9114276plp.78.2022.08.16.07.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 07:26:48 -0700 (PDT)
Date:   Tue, 16 Aug 2022 14:26:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, vannapurve@google.com
Subject: Re: [V3 09/11] tools: Add atomic_test_and_set_bit()
Message-ID: <YvupJOJ38CWUDhze@google.com>
References: <20220810152033.946942-1-pgonda@google.com>
 <20220810152033.946942-10-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810152033.946942-10-pgonda@google.com>
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

On Wed, Aug 10, 2022, Peter Gonda wrote:
> atomic_test_and_set_bit() allows for atomic bitmap usage from KVM
> selftests.
> 
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/arch/x86/include/asm/atomic.h    |  7 +++++++
>  tools/include/asm-generic/atomic-gcc.h | 15 +++++++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/tools/arch/x86/include/asm/atomic.h b/tools/arch/x86/include/asm/atomic.h
> index 1f5e26aae9fc..01cc27ec4520 100644
> --- a/tools/arch/x86/include/asm/atomic.h
> +++ b/tools/arch/x86/include/asm/atomic.h
> @@ -8,6 +8,7 @@
>  
>  #define LOCK_PREFIX "\n\tlock; "
>  
> +#include <asm/asm.h>
>  #include <asm/cmpxchg.h>
>  
>  /*
> @@ -70,4 +71,10 @@ static __always_inline int atomic_cmpxchg(atomic_t *v, int old, int new)
>  	return cmpxchg(&v->counter, old, new);
>  }
>  
> +static inline int atomic_test_and_set_bit(long nr, unsigned long *addr)
> +{
> +	GEN_BINARY_RMWcc(LOCK_PREFIX __ASM_SIZE(bts), *addr, "Ir", nr, "%0", "c");
> +

Unnecessary newline.

> +}
> +
>  #endif /* _TOOLS_LINUX_ASM_X86_ATOMIC_H */
> diff --git a/tools/include/asm-generic/atomic-gcc.h b/tools/include/asm-generic/atomic-gcc.h
> index 4c1966f7c77a..8d9b2d1768bf 100644
> --- a/tools/include/asm-generic/atomic-gcc.h
> +++ b/tools/include/asm-generic/atomic-gcc.h
> @@ -4,6 +4,7 @@
>  
>  #include <linux/compiler.h>
>  #include <linux/types.h>
> +#include <linux/bitops.h>
>  
>  /*
>   * Atomic operations that C can't guarantee us.  Useful for
> @@ -69,4 +70,18 @@ static inline int atomic_cmpxchg(atomic_t *v, int oldval, int newval)
>  	return cmpxchg(&(v)->counter, oldval, newval);
>  }
> +static inline int atomic_test_and_set_bit(long nr, unsigned long *addr)
> +{
> +	long old, val;
> +	unsigned long mask = BIT_MASK(nr);
> +
> +	addr += BIT_WORD(nr);
> +	val = READ_ONCE(*addr);
> +	if (val & mask)
> +		return 1;

Probably should drop the READ_ONCE() shortcut to stay consistent with the kernel
proper.

https://lore.kernel.org/all/CAHk-=wgSNiT5qJX53RHtWECsUiFq6d6VWYNAvu71ViOEan07yw@mail.gmail.com

> +
> +	old = cmpxchg(addr, val, val & mask);

This is wrong on two fronts: 1) cmpxchg() writes the entire new value, and 2) it
fails if the old value is not an exact match with what's in memory.  Bug #1 means
that setting a bit will clear all existing bits, and bug #2 means that this will
fail to set the bit if another atomic_test_and_set_bit() sneaks in between reading
into "val" and doing the cmpxchg.

And obviously dropping the READ_ONCE() above makes cmpxchg impossible (not a
coincidence, it's simply the wrong operation to use).

I believe what we want is:

	unsigned long mask = BIT_MASK(nr);
	long old;

	old = __sync_fetch_and_or(addr, mask);
	return !!(old & mask);

> +	return !!(old & mask);
> +}
> +
>  #endif /* __TOOLS_ASM_GENERIC_ATOMIC_H */
> -- 
> 2.37.1.559.g78731f0fdb-goog
> 
