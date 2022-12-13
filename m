Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD7D64BDB5
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 21:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236766AbiLMUDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 15:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235545AbiLMUDJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 15:03:09 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048D6F00
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 12:03:09 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so4728835pjm.2
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 12:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SlLKeNs0EWVsu+ptfdWBNmvU18ZVhMR61XWdAxFV9XQ=;
        b=Jgh2h70gyFoI+vZEt+HRyYhvy8YXmJruypdwVRYeOAtwakBPLsrcx6y+QvB3hUhUNm
         v/DiIWAZ3oh+MtBheCrEL++Gyb7HLAT1gDnpqMiVuiB04sbr6RL+4HisIMlXsah7jJHs
         BQh9UrAAjRfz+6OEQK8DW+ZocCeLgGW7E9/YuE4vDZ2U7pCZP9xxdvcW7BRNNE9/dvXk
         UHFZHnLNmVVz3QPKDVMD9nL2tc1Un2n3p3lY72Vrrn4IEro5ne4Mp2Xd+uRIFimABqMP
         9hVMz9Et/jMsgOYssc4gfckHfVOAIkEUwXeMIcmjytkpiwFO3ZODSvpun/Uk3hH9yVpu
         tYKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SlLKeNs0EWVsu+ptfdWBNmvU18ZVhMR61XWdAxFV9XQ=;
        b=7WFeal3gPFoTQyBwvxs7WBcpeHRnf+CgxvrqJ/4TSUR3Lssez2wvL1Z5BjQi/OmoTD
         CbAN3jEBofLVk+NhqFOVLufoATmTkS1k6h8Y4qbMCnbkW2Jmp1uBweaMcNxgYnA7EVKb
         dOdgenaA2uRCwDNOBtTuAfs0NS0i5eV0EWsNLgS3vD0uu2hkNSJhDjhGq6ItMCp8Cwi4
         5ywOaCBABemYAUaqNG3NFxy6fVRCbwA0Km/j7hifdA8N6Ms4awGq3vH0AE2Yah7Ax+AS
         hx0yX0CO4tcXreva1oOs3OEbpt0PTmNZ+LfZGpVGz/DmWi0n/cjN9KiRdwdyHruQL4RM
         PQyg==
X-Gm-Message-State: ANoB5pksDmw//3n59gJGsPQ+ME+hfjNp2WkPZiq0Cn5Xuyw3ItmcysRl
        L2N317yJDlK5Je463otliqLdmQ==
X-Google-Smtp-Source: AA0mqf43rfeTLye05owqv8MbDwr9r9xovoe2k6ziCGD54isSIqaMDQrLxrh/vw468kpaItrUN7BQ5g==
X-Received: by 2002:a17:902:7b96:b0:189:858f:b5c0 with SMTP id w22-20020a1709027b9600b00189858fb5c0mr428994pll.0.1670961788301;
        Tue, 13 Dec 2022 12:03:08 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u5-20020a170903124500b00189667acf19sm289595plh.95.2022.12.13.12.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 12:03:07 -0800 (PST)
Date:   Tue, 13 Dec 2022 20:03:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Ricardo Koller <ricarkol@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Cc:     David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 06/14] KVM: selftests: Rename UNAME_M to ARCH_DIR, fill
 explicitly for x86
Message-ID: <Y5jadzKz6Qi9MiI9@google.com>
References: <20221213001653.3852042-1-seanjc@google.com>
 <20221213001653.3852042-7-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213001653.3852042-7-seanjc@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+David

On Tue, Dec 13, 2022, Sean Christopherson wrote:
> Rename UNAME_M to ARCH_DIR and explicitly set it directly for x86.  At
> this point, the name of the arch directory really doesn't have anything
> to do with `uname -m`, and UNAME_M is unnecessarily confusing given that
> its purpose is purely to identify the arch specific directory.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> -# No change necessary for x86_64
> -UNAME_M := $(shell uname -m)
> -
> -# Set UNAME_M for arm64 compile/install to work
> -ifeq ($(ARCH),arm64)
> -	UNAME_M := aarch64
> -endif
> -# Set UNAME_M s390x compile/install to work
> -ifeq ($(ARCH),s390)
> -	UNAME_M := s390x
> -endif
> -# Set UNAME_M riscv compile/install to work
> -ifeq ($(ARCH),riscv)
> -	UNAME_M := riscv
> +ifeq ($(ARCH),x86)

As discovered by by David, this breaks doing "ARCH=x86_64 make", which is an
allowed/supported variant in the kernel proper, so this needs to be:

  ifneq (,$(filter $(ARCH),x86 x86_64))

or alternatively

  ifeq ($(ARCH),x86_64)
  ARCH := x86
  endif

Hmm, unless there's a reason to keep ARCH=x86_64, the latter appears to be the
better option as lib.mak doesn't play nice with x86_64 either, e.g. `ARCH=x86_64
LLVM=1 make` fails.  That's arguably a lib.mak bug, but it's trivial to handle
in KVM's makefile so forcing lib.mak to handle both seems unnecessary.

I'll also add a comment to call out that $(ARCH) follows the kernel's terminology
for arch/*, whereas for whatever reason KVM selftests effectively uses `uname -m`
terminology.

One last thought/question, what do y'all think about renaming directories to
follow the kernel proper?  I.e. aarch64=>arm64, s390x=>s390, and x86_64=>x86.
Then $(ARCH_DIR) would go away.  The churn would be unfortunate, but it would be
nice to align with arch/ and tools/arch/.

> +	ARCH_DIR := x86_64
> +else ifeq ($(ARCH),arm64)
> +	ARCH_DIR := aarch64
> +else ifeq ($(ARCH),s390)
> +	ARCH_DIR := s390x
> +else ifeq ($(ARCH),riscv)
> +	ARCH_DIR := riscv
> +else
> +$(error Unknown architecture '$(ARCH)')
>  endif
