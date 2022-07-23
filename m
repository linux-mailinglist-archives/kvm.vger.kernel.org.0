Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38DE557EA8D
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 02:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiGWAOQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 20:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiGWAOP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 20:14:15 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509C474CC3
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:14:14 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id h132so5611059pgc.10
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i4zvV8GRjb4CrksrmpeUffrn22CRBZOzQFKuTF6Of8o=;
        b=GwQS5AWoFCrKaW0tM0L+1wgUcavoqVtR0CO+RI9GAR8Q8tmmT8/2Vos7cnQE80DeNw
         Sbunv77tuAvGZpH95RAIwyg1fCn1o4BP0p1qF0cAnoj/DpSa1AREdV9wYu8+fIExdBme
         dlXWOoATf55aQvyff1tfbg+qxN42o28VYlwEE545oWdhEZh7QVTUfviwZm4VBqNbbclF
         u5DHcGD2U1wn37AyNCxwOVvsed+2lg5pgqxyiWUNQYIvNR0uebTng/kYZz+nfK+Alx9Z
         B0rjdwzFM/+IjZ+mhtG4qoT858pGbDlKGf6gpMctt+QOyr4LgTfroisA/CzLYIs8l7N2
         EzYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i4zvV8GRjb4CrksrmpeUffrn22CRBZOzQFKuTF6Of8o=;
        b=KoQ7aSASLnkGUPYL7XiGRECEEq+RNqsZXnFySW9klMRUkgv0OmdO+I6Xo1+K0fCt4E
         HOePQgfQX9bBJnCYghGJeuZ/jgF1ExZ1eJl/MRVNue79su4y/VlzFFMUVoSzDVYPxvu4
         ABOTfO9QBEqBkxhAetNxwcN6loEKiTKwBcv5GjNNxVHG2Aa4An0j1R/lNMyc01Z4z05v
         VA8EKnOgVBgOcnwAgg8xy6tdI0O3f5mxmMSnCdAV1Nm43WtP39lXk2eJ/Rylc5NDJ9LS
         EFNFlSg8ZsUT6acBUWaoi67xCN0R9CrhTebUwvaPDcKlMBipB4127rqVdWUU2KxFAWWM
         gpUQ==
X-Gm-Message-State: AJIora9F8HUe0aX8dh3JaIAtXLw6EAjDCc1g0QrV3Z1G5PPYKK7RJjSk
        xNKJZAyPNw4EU9OD/Gzd2B2lPQ==
X-Google-Smtp-Source: AGRyM1s0JzbXAEiT7frXN665wcHYrzXMgqGSKZtyAjZYTnu5nScuZ4YundvPe2A/a5yDGR73fiep3Q==
X-Received: by 2002:a05:6a00:1ad3:b0:52b:37ac:4435 with SMTP id f19-20020a056a001ad300b0052b37ac4435mr2304241pfv.25.1658535253553;
        Fri, 22 Jul 2022 17:14:13 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id 203-20020a6214d4000000b0052ba5fe74c8sm4543145pfu.54.2022.07.22.17.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 17:14:12 -0700 (PDT)
Date:   Sat, 23 Jul 2022 00:14:08 +0000
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
Subject: Re: [PATCH 2/2] KVM: selftests: Fix ambiguous mov in KVM_ASM_SAFE()
Message-ID: <Yts9UCEyOmr3uY4D@google.com>
References: <20220722234838.2160385-1-dmatlack@google.com>
 <20220722234838.2160385-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722234838.2160385-3-dmatlack@google.com>
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
> Change the mov in KVM_ASM_SAFE() that zeroes @vector to a movb to
> make it unambiguous.
> 
> This fixes a build failure with Clang since, unlike the GNU assembler,
> the LLVM integrated assembler rejects ambiguous X86 instructions that
> don't have suffixes:
> 
>   In file included from x86_64/hyperv_features.c:13:
>   include/x86_64/processor.h:825:9: error: ambiguous instructions require an explicit suffix (could be 'movb', 'movw', 'movl', or 'movq')
>           return kvm_asm_safe("wrmsr", "a"(val & -1u), "d"(val >> 32), "c"(msr));
>                  ^
>   include/x86_64/processor.h:802:15: note: expanded from macro 'kvm_asm_safe'
>           asm volatile(KVM_ASM_SAFE(insn)                 \
>                        ^
>   include/x86_64/processor.h:788:16: note: expanded from macro 'KVM_ASM_SAFE'
>           "1: " insn "\n\t"                                       \
>                         ^
>   <inline asm>:5:2: note: instantiated into assembly here
>           mov $0, 15(%rsp)
>           ^
> 
> It seems like this change could introduce undesirable behavior in the
> future, e.g. if someone used a type larger than a u8 for @vector, since
> KVM_ASM_SAFE() will only zero the bottom byte. I tried changing the type
> of @vector to an int to see what would happen. GCC failed to compile due
> to a size mismatch between `movb` and `%eax`. Clang succeeded in
> compiling, but the generated code looked correct, so perhaps it will not
> be an issue. That being said it seems like there could be a better
> solution to this issue that does not assume @vector is a u8.

Hrm, IIRC my intent was to not care about the size of "vector", but that may just
be revisionist thinking because the:

	"mov  %%r9b, %[vector]\n\t"				\

suggests it's nothing more than a screwed up.  A static assert on the size would
be nice, but I don't know how to make that work since the macros dump directly
into the asm.

> Fixes: 3b23054cd3f5 ("KVM: selftests: Add x86-64 support for exception fixup")
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Sean Christopherson <seanjc@google.com>
