Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA92D557DCE
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 16:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbiFWOb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 10:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbiFWOby (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 10:31:54 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E7E4578F
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 07:31:52 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 9so1029549pgd.7
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 07:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SdE1Q+FcIHNdzvHylki5AIGEmd7N5R8sBfbJlSX0V5M=;
        b=O3yF4t8UGVG0qmedo7bFOSVoLfU69kgt3uZgtLN+p298+LsaWx3piWWHvwrtOCrSmf
         MhNhoPdfi3sHp15DQhMbwRJVDE/Hi3TJt6RR5uuEn/372PZKCymelEOT3q1YqTDdiojO
         3XCTJVYeKKeHpP5aMnagBgY7dMncCsNflyUdpXwqeEUIciwk5egWd+UyvhD3sL5LqALT
         RMTU8uzvchBw07rkiaruQbdcZcqEz3phXzVIDCzbhZPm+nTlWYqlFJmXGflDHO5VNMuB
         9AhukAv5fUOamgiBwpRxFlVPKy1JeKxs26HMdTB3r6NqybVxC+gl4sbwuFKvWvTt1c+V
         t4VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SdE1Q+FcIHNdzvHylki5AIGEmd7N5R8sBfbJlSX0V5M=;
        b=dgIuASM4IpbnsJIocDoWO0C7ZewvokP+8XPaju6ArmXniRRSfLsX4m3uSJJ81Fwubk
         LffpdG/FQreZm+ScVQOUGfQ9tsdZIftQR8PRulfK3iiGni/1Vyb739NmGrvZusqGW/Ub
         x2UHRdcM8wQb2t9nxPqLinSJb4BUXeeCkNy7OZ2hV5LtuL6mmxP94UY9tri/7gf/L68O
         Cuoe/r6KBtx61XEinigjVsoxIon3JP6P3RzVeZwX61wuZ2wykoTj9j0eDzXoaC6NXbwH
         RvdxXz379v++DgqzCJypcTQ+oMXdZlBGfkvvjkEQLTwyHHx1GkNlwGg9faABJ0VbzW+M
         mPMA==
X-Gm-Message-State: AJIora/TauYQ+MTTV72ricCh2nlT4Fmf9V5M3eC5X1OfkQC4yazh9wXZ
        39tQovkxIG4o6ED5lX5WJHhthQ==
X-Google-Smtp-Source: AGRyM1s+/p15SaFZzmeOpC2GidYUhYH38ADbe6rtkG2Iae5V1dUrzuMDysKbpQPsePjwMEHt62hJRQ==
X-Received: by 2002:a63:7946:0:b0:408:c6ac:939b with SMTP id u67-20020a637946000000b00408c6ac939bmr7834470pgc.349.1655994711761;
        Thu, 23 Jun 2022 07:31:51 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id jj9-20020a170903048900b0016a100c9a2esm11019125plb.112.2022.06.23.07.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 07:31:51 -0700 (PDT)
Date:   Thu, 23 Jun 2022 14:31:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>
Subject: Re: [PATCH 3/4] kvm: Add new pfn error KVM_PFN_ERR_INTR
Message-ID: <YrR5U1mHP9fYQ1k9@google.com>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-4-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622213656.81546-4-peterx@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 22, 2022, Peter Xu wrote:
> Add one new PFN error type to show when we cannot finish fetching the PFN
> due to interruptions.  For example, by receiving a generic signal.
> 
> This prepares KVM to be able to respond to SIGUSR1 (for QEMU that's the
> SIGIPI) even during e.g. handling an userfaultfd page fault.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  include/linux/kvm_host.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index b646b6fcaec6..4f84a442f67f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -96,6 +96,7 @@
>  #define KVM_PFN_ERR_FAULT	(KVM_PFN_ERR_MASK)
>  #define KVM_PFN_ERR_HWPOISON	(KVM_PFN_ERR_MASK + 1)
>  #define KVM_PFN_ERR_RO_FAULT	(KVM_PFN_ERR_MASK + 2)
> +#define KVM_PFN_ERR_INTR	(KVM_PFN_ERR_MASK + 3)
>  
>  /*
>   * error pfns indicate that the gfn is in slot but faild to
> @@ -106,6 +107,16 @@ static inline bool is_error_pfn(kvm_pfn_t pfn)
>  	return !!(pfn & KVM_PFN_ERR_MASK);
>  }
>  
> +/*
> + * When KVM_PFN_ERR_INTR is returned, it means we're interrupted during
> + * fetching the PFN (e.g. a signal might have arrived), so we may want to
> + * retry at some later point and kick the userspace to handle the signal.
> + */
> +static inline bool is_intr_pfn(kvm_pfn_t pfn)
> +{
> +	return pfn == KVM_PFN_ERR_INTR;

What about is_sigpending_pfn() and KVM_PFN_ERR_SIGPENDING?  "intr" is too close to
a real thing KVM will encounter, and I think knowing that KVM is effectively
responding to a pending signal is the most important detail for KVM developers
encountering this code for this first time.  E.g. from KVM_PFN_ERR_INTR alone, one
might think that any interrupt during GUP will trigger this.

> +}
> +
>  /*
>   * error_noslot pfns indicate that the gfn can not be
>   * translated to pfn - it is not in slot or failed to
> -- 
> 2.32.0
> 
