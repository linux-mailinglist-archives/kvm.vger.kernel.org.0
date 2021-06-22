Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833EE3B0E60
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 22:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbhFVUNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 16:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhFVUNE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 16:13:04 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7301FC061574
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:10:47 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c15so10936193pls.13
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=21xgjufa4gzmA5sbAsLTU+XApnrHffYBBU5/YlGT9j0=;
        b=Mu3afzjT7AjWy9DHCVVeSuPZpVVtPczT/SlM/TKhkGJ5yPCGdZMGzGrCcm94DX51vF
         uSd0J+yRUkulaiWRVvVWOnw+aFO3HmOQtCRaS4Pzd7jj1Myo3YSkIB/LFh9wX4YeWhAt
         P//uzUy+lt00HwTZ5H1USQGq0lCAzWuDZ9R8c9FyIz5X8QT8nNbwhLfWslgDzdkvAEWF
         N1lc71dmPNfVHjf0zjtUAfGNFhKHrkZSdGeFPoL6On9CUgw7JNgpcUmM/jtlnWBCn5Rc
         TuYDhnqLXA98SDcMVO1sT0jXf+Np1AS40pvs8KQ8Q4aInjxaginIyAJIGHqrtcpGkpmk
         e4Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=21xgjufa4gzmA5sbAsLTU+XApnrHffYBBU5/YlGT9j0=;
        b=YLkS/Dod+EAyG7dLNp1zebICUthwro4mU6KhB6DB+vt2YIGwsqJJ0ejaQ4Y/7y0nC9
         8h+pnxR5jNXQsouVGeTcKeroq0VeUUp+bJXdrOHZl6bXgLsxZoo2luKKNEhJPfwQdROO
         dM/+DZbKqjzRfLXkU49h/lshbcgoeUT46HBWIogMYCzhMRodSA19g6u+lEhOH7OgE8Jv
         GvzhLPCyq6A2CrTup6bpTN4g4Kfrtg0Jol5uR/1Q5iYQco0MqCxF+RVL9MhIf1BEjgc6
         OVEc+K1BF830ZJFkh+NJO3wwS6AqQiBYayF7ewvwV8ZAon093BXtcxvE+6dt62BGK3ki
         6ClQ==
X-Gm-Message-State: AOAM530ezI+7IfzacCYcq194D72AgmSt09271ro+TsLxPZJu6a4J/N9V
        m8lSWdHxozFzBBODegMFIVJFjA==
X-Google-Smtp-Source: ABdhPJxF79gefY2EG4keXirmC5v0DgovMexsMCqE+oiHoIDnceAda0/BVvB9iKbm51yWO16Wutm4wA==
X-Received: by 2002:a17:90a:1382:: with SMTP id i2mr5670751pja.221.1624392646714;
        Tue, 22 Jun 2021 13:10:46 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h8sm173171pfn.0.2021.06.22.13.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 13:10:46 -0700 (PDT)
Date:   Tue, 22 Jun 2021 20:10:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] x86: svm: Skip NPT-only part of guest CR3
 tests when NPT is disabled
Message-ID: <YNJDwlw8xltbfOPT@google.com>
References: <20210422025448.3475200-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422025448.3475200-1-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 21, 2021, Sean Christopherson wrote:
> Skip the sub-tests for guest CR3 that rely on NPT, unsurprisingly they
> fail when running with NPT disabled.  Alternatively, the test could be
> modified to poke into the legacy page tables, but obviously no one
> actually cares that much about shadow paging.
> 
> Fixes: 6d0ecbf ("nSVM: Test non-MBZ reserved bits in CR3 in long mode and legacy PAE mode")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Ping!  Doesn't look like this ever got merged.

> ---
>  x86/svm_tests.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 29a0b59..353ab6b 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -2237,6 +2237,9 @@ static void test_cr3(void)
>  
>  	vmcb->save.cr4 = cr4_saved & ~X86_CR4_PCIDE;
>  
> +	if (!npt_supported())
> +		goto skip_npt_only;
> +
>  	/* Clear P (Present) bit in NPT in order to trigger #NPF */
>  	pdpe[0] &= ~1ULL;
>  
> @@ -2255,6 +2258,8 @@ static void test_cr3(void)
>  	    SVM_CR3_PAE_LEGACY_RESERVED_MASK, SVM_EXIT_NPF, "(PAE) ");
>  
>  	pdpe[0] |= 1ULL;
> +
> +skip_npt_only:
>  	vmcb->save.cr3 = cr3_saved;
>  	vmcb->save.cr4 = cr4_saved;
>  }
> -- 
> 2.31.1.498.g6c1eba8ee3d-goog
> 
