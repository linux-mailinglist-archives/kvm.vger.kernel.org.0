Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6191255E274
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240128AbiF0SKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 14:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240121AbiF0SKn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 14:10:43 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329A5B7C1
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 11:10:43 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id n16-20020a17090ade9000b001ed15b37424so10173679pjv.3
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 11:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E/xc4vvQ8vo4eVo9CE15HRjgjonsTfeZsZT+f2UzoE0=;
        b=YmN5ASGNqa/ZRD16iaGFqtUU2QPk+y0jvo/pT6kvq6W9KhcWBvi7wmLCledcGsT6U2
         O0gMjbuPWmxA4xxZqNPRDJafX4cGb2vsEQ1w9ap0NoUjVWn9CX5DEm2wtpVSFdDol94q
         dFJ97nlXk0/9lojXOOYVl/DflLo+T2bPlRwF4iwJRDunSSJcFInx1zUCBQ0TWT42aQtm
         pB7t7Fq8aeXJM8eqO9YjCTe/cYqK6IGiyHj8qRy4J0xjYv0sCRF8IhHddrH69RDA7a8D
         Rui+8bb7g6bBF05UDxMiWy7RPmD3sjnkcD8huwBHNKL7KEqpod1FJRLucsUmoQmost+o
         bq2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E/xc4vvQ8vo4eVo9CE15HRjgjonsTfeZsZT+f2UzoE0=;
        b=6mDZMGCtcp+AoN8l85p2NNVLLele9q/YDJVZhFdK1qDh453uUZC3CI+O77LTBtpGPI
         7abEAw9+OuR8pXCwSqrMe0vK6Mo/V7gGQ1zTsB8kyFdQPmWju2Rz+wcuND5DBrRCqfYu
         rxGoV8nsZN/Eev7N73Eop3S8HqZGFbUkO/V0zKnxUiEZ0HP2GQOdUseVdbfSiM7GUakc
         PHUQyYW1JbRJaQ6tLKWkuH23z97iI6ZchyeC/3vnkmicb+bVTlUyRQxQSsmrqB8GEfXS
         yi0eNpAv5TAd4dAwhl5L49ygZgp0+ZNje+9ZrI0vHW0CPDDpQ4FeLE9xCo6aDdPVBbGx
         XvjQ==
X-Gm-Message-State: AJIora9OkjYpO7YDW8+Fx7c9hbrDbYOVxTiWyTFGnx9HAgROhsuCzWNL
        u7KhG8MGGaXJs1JxddDXJQb5Pg==
X-Google-Smtp-Source: AGRyM1vbabjlhOLCSp+Rpm/zQgX2cUDD2rbX4ZYw7XBv3FtZVs8GpFw1rj9KQ0DTf2ewyH9dkOOKdQ==
X-Received: by 2002:a17:90b:3584:b0:1ee:fa46:3986 with SMTP id mm4-20020a17090b358400b001eefa463986mr559605pjb.227.1656353442636;
        Mon, 27 Jun 2022 11:10:42 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id k21-20020a6568d5000000b0040d5abae51esm7441815pgt.91.2022.06.27.11.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 11:10:42 -0700 (PDT)
Date:   Mon, 27 Jun 2022 18:10:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Greg Thelen <gthelen@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: SEV: Clear the pages pointer in sev_unpin_memory
Message-ID: <Yrnync27TAhgSRUq@google.com>
References: <20220627161123.1386853-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627161123.1386853-1-pgonda@google.com>
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

On Mon, Jun 27, 2022, Peter Gonda wrote:
> Clear to the @pages array pointer in sev_unpin_memory to avoid leaving a
> dangling pointer to invalid memory.
> 
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Cc: Greg Thelen <gthelen@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/x86/kvm/svm/sev.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 309bcdb2f929..485ad86c01c6 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -452,6 +452,7 @@ static void sev_unpin_memory(struct kvm *kvm, struct page **pages,
>  	unpin_user_pages(pages, npages);
>  	kvfree(pages);
>  	sev->pages_locked -= npages;
> +	*pages = NULL;

Would this have helped detect a real bug?  I generally like cleaning up, but this
leaves things in a somewhat inconsistent state, e.g. when unpinning a kvm_enc_region,
pages will be NULL but npages will be non-zero.  It's somewhat moot because the
region is immediately freed in that case, but that begs the question of what real
benefit this provides.  sev_dbg_crypt() is the only flow where there's much danger
of a use-after-free.

>  }
>  
>  static void sev_clflush_pages(struct page *pages[], unsigned long npages)
> -- 
> 2.37.0.rc0.161.g10f37bed90-goog
> 
