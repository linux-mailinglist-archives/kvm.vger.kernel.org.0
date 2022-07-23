Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F5857EA88
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 02:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbiGWAB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 20:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiGWAB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 20:01:57 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C66C06D1
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:01:56 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id k16so5778524pls.8
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5SPjP3md/CGBm0+sPT1l6nq7K2L6BN5vDp8ulsH6LwQ=;
        b=Sr+3JD7hljNlTOJg6LYONXm3XW0q/PCWlxWVd6ZMC9cg/xl5dRvDnnjCMy4ec8iPtT
         eNSGd7XCofi7taqx2a4dHM1ewP2C1NO3xClMsJ5FC0xmiw6qey+eLnyOdJKb5+hkPIO4
         hNshfc8/BKq195gMukjpRfALKlTR788EGBzesnUwhLvFiLuuZB7pXfH5v3G5wum4fSOE
         7x0MGIHfNqHROt2LsOBc+5eWYQRvFPFMGV+vn3QKvQRASAuzVCzasRzHPbiuW107rFqr
         6opqZ7hFMGu/YmEPXwdTqXAA5NlICALRYRN81zM3aUoc+GnxalRu+i5gvgqnVWJstfNF
         ABAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5SPjP3md/CGBm0+sPT1l6nq7K2L6BN5vDp8ulsH6LwQ=;
        b=OO92w2b1n2fcaFmbXlkH4XjAJ444j6erTsNtB7odKfEz1htc3sdJYk8C8hg1IykyBn
         jKMvn8mSMAxLifBYbwTT5/baDy8uEarcqEqkZnSqiTeaE3U/XLWNob2ZcJDZIjThTNEI
         aG0ooHBOwwEXQTZQv17o2PRV1QcRzx7K4cBIBMVX5y08HdLMIB8hkVCjMl0AI81R75zo
         qrwJ2eMl7bJOvx6wzHEzPxEgr+HntKgdQO42KSXtqikNHl8Nq7Ier6wmdOLLalkglX55
         z5H/pnIm4IIZaulXt2UGxRUHbRNy9mNsLW0etmqXjwzYh/DcIJ1pTzK6f+tiFarIVk/9
         FxIg==
X-Gm-Message-State: AJIora+oK0WIejIcSsqC8WrJPAPH6i+E5Y2gUm4r4IUzB72QTJnlWUwv
        RFkotEsWKNVMynnprK9KHuDlmQ==
X-Google-Smtp-Source: AGRyM1uy6SDnA7IVF3c1DD/eA3do+TS/ZWD/aOJ9q562iG5rUxY95gfayC4VMwdOxE+YQK8P36NnMw==
X-Received: by 2002:a17:90a:6281:b0:1f2:1f17:4023 with SMTP id d1-20020a17090a628100b001f21f174023mr17463337pjj.243.1658534516194;
        Fri, 22 Jul 2022 17:01:56 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902f70a00b0016be6a554b5sm4326483plo.233.2022.07.22.17.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 17:01:55 -0700 (PDT)
Date:   Sat, 23 Jul 2022 00:01:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        "open list:CLANG/LLVM BUILD SUPPORT" <llvm@lists.linux.dev>,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: selftests: Fix KVM_EXCEPTION_MAGIC build with
 Clang
Message-ID: <Yts6cCcnfg1xV54O@google.com>
References: <20220722234838.2160385-1-dmatlack@google.com>
 <20220722234838.2160385-2-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722234838.2160385-2-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 22, 2022, David Matlack wrote:
> Change KVM_EXCEPTION_MAGIC to use the all-caps "ULL", rather than lower
> case. This fixes a build failure with Clang:
> 
>   In file included from x86_64/hyperv_features.c:13:
>   include/x86_64/processor.h:825:9: error: unexpected token in argument list
>           return kvm_asm_safe("wrmsr", "a"(val & -1u), "d"(val >> 32), "c"(msr));
>                  ^
>   include/x86_64/processor.h:802:15: note: expanded from macro 'kvm_asm_safe'
>           asm volatile(KVM_ASM_SAFE(insn)                 \
>                        ^
>   include/x86_64/processor.h:785:2: note: expanded from macro 'KVM_ASM_SAFE'
>           "mov $" __stringify(KVM_EXCEPTION_MAGIC) ", %%r9\n\t"   \
>           ^
>   <inline asm>:1:18: note: instantiated into assembly here
>           mov $0xabacadabaull, %r9
>                           ^
> 
> Fixes: 3b23054cd3f5 ("KVM: selftests: Add x86-64 support for exception fixup")
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  tools/testing/selftests/kvm/include/x86_64/processor.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 45edf45821d0..51c6661aca77 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -754,7 +754,7 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
>  			void (*handler)(struct ex_regs *));
>  
>  /* If a toddler were to say "abracadabra". */
> -#define KVM_EXCEPTION_MAGIC 0xabacadabaull
> +#define KVM_EXCEPTION_MAGIC 0xabacadabaULL

Really?!?!?! That's what makes clang happy?!?!?
