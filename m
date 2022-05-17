Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667B352A519
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 16:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344944AbiEQOmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 10:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236258AbiEQOmT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 10:42:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 70B872E0BC
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 07:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652798537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hTjqsV1Fp+r+noPld4SG87IVv2bHAbFunBtzqB6+vis=;
        b=fDsStp5R1XB4esuQD0Qn9m6Vv/X4EshP/nM+iyMsHexqiUKGwhf23a2nrtDaMzLpNEPqdx
        IJcUbIfeV+wdjtyeNGEGKjP1f9CaqBXsQuW5ItsnL8GpDstnxHM/ih1Bf++INGCiIExqu7
        0StW/Ek+nLEncWEpC0ZSw9vBoZBH7YU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-U91L9dPVOjeFsgG-79Smow-1; Tue, 17 May 2022 10:42:14 -0400
X-MC-Unique: U91L9dPVOjeFsgG-79Smow-1
Received: by mail-ej1-f70.google.com with SMTP id v13-20020a170906b00d00b006f51e289f7cso7408450ejy.19
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 07:42:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hTjqsV1Fp+r+noPld4SG87IVv2bHAbFunBtzqB6+vis=;
        b=eSDrmfSYzTIyio/Jay3zi8MKivsgRU8LhIGuYJqsjEgSyefkIRPJ7eIGShQnr64wtU
         VUyUfzM1aexdZUZQsjgczOlOUIuOCDsSrjQUe6FiTQ7hKsY0FQKLmcubA19NQ8y1RHuE
         KvudnLM8KVjk71hwj4UPD1pAL5VPFWOBwgjMavoHJi7EHcukfHpElgS8WRtA/Qdbnchx
         6184vCLenRWWFGumaViYX5/ofJav2I7UqaJsK/5f9t0RDMhFSquFpGjyXSY1S7Fslp7m
         xjXMuQXuRFboVEeVOG/giBdE3w8SEPIE+CNY1k9tYzEUdw6bYox7CFxGUP7ed2h0e9Jy
         0HCg==
X-Gm-Message-State: AOAM532rmnJ/Z5DKnH1f0msszWntv0I1wUCYO8eRdsIqZQkyehnlBIs/
        IAGW0s51dQAz9Jdjts1JQFebOTm6w/ovQ48WR+fXLFzxjoIPq7BR2BTotCZcS3v2uNRIWEKKw49
        3Ul86gBT5E3ib
X-Received: by 2002:a05:6402:238f:b0:42a:98d8:ae1b with SMTP id j15-20020a056402238f00b0042a98d8ae1bmr17423848eda.168.1652798530562;
        Tue, 17 May 2022 07:42:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJye0bbFmMONyTqmP3It4fL7QuUCBzVF03Vy8Tp5rLhkr7l+Xsej5oxl8SSRjnzPPSKeMkbGMg==
X-Received: by 2002:a05:6402:238f:b0:42a:98d8:ae1b with SMTP id j15-20020a056402238f00b0042a98d8ae1bmr17423824eda.168.1652798530348;
        Tue, 17 May 2022 07:42:10 -0700 (PDT)
Received: from gator (cst2-173-79.cust.vodafone.cz. [31.30.173.79])
        by smtp.gmail.com with ESMTPSA id e9-20020a056402104900b0042ac0e79bb6sm1853112edu.45.2022.05.17.07.42.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 07:42:09 -0700 (PDT)
Date:   Tue, 17 May 2022 16:42:07 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Bill Wendling <morbo@google.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Zixuan Wang <zixuanwang@google.com>,
        Cornelia Huck <cohuck@redhat.com>, kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH] arm64: Check for dynamic relocs with
 readelf
Message-ID: <20220517144207.662hyp276g3syzf2@gator>
References: <20220504230446.2253109-1-morbo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504230446.2253109-1-morbo@google.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 04, 2022 at 04:04:46PM -0700, Bill Wendling wrote:
> Clang's version of objdump doesn't recognize "setftest.elf" as a dynamic
> object and produces an error stating such.
> 
> 	$ llvm-objdump -R ./arm/selftest.elf
> 	arm/selftest.elf:	file format elf64-littleaarch64
> 	llvm-objdump: error: './arm/selftest.elf': not a dynamic object
> 
> This causes the ARM64 "arch_elf_check" check to fail. Using "readelf
> -rW" is a better option way to get the same information and produces the
> same information in both binutils and LLVM.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  arm/Makefile.arm64 | 6 +++---
>  configure          | 2 ++
>  2 files changed, 5 insertions(+), 3 deletions(-)

Merged to https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git master

Thanks,
drew



> 
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index 6feac76f895f..42e18e771b3b 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -14,9 +14,9 @@ mno_outline_atomics := $(call cc-option, -mno-outline-atomics, "")
>  CFLAGS += $(mno_outline_atomics)
>  
>  define arch_elf_check =
> -	$(if $(shell ! $(OBJDUMP) -R $(1) >&/dev/null && echo "nok"),
> -		$(error $(shell $(OBJDUMP) -R $(1) 2>&1)))
> -	$(if $(shell $(OBJDUMP) -R $(1) | grep R_ | grep -v R_AARCH64_RELATIVE),
> +	$(if $(shell ! $(READELF) -rW $(1) >&/dev/null && echo "nok"),
> +		$(error $(shell $(READELF) -rW $(1) 2>&1)))
> +	$(if $(shell $(READELF) -rW $(1) | grep R_ | grep -v R_AARCH64_RELATIVE),
>  		$(error $(1) has unsupported reloc types))
>  endef
>  
> diff --git a/configure b/configure
> index 86c3095a245a..23085da7dcc5 100755
> --- a/configure
> +++ b/configure
> @@ -12,6 +12,7 @@ cflags=
>  ld=ld
>  objcopy=objcopy
>  objdump=objdump
> +readelf=readelf
>  ar=ar
>  addr2line=addr2line
>  arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
> @@ -372,6 +373,7 @@ CFLAGS=$cflags
>  LD=$cross_prefix$ld
>  OBJCOPY=$cross_prefix$objcopy
>  OBJDUMP=$cross_prefix$objdump
> +READELF=$cross_prefix$readelf
>  AR=$cross_prefix$ar
>  ADDR2LINE=$cross_prefix$addr2line
>  TEST_DIR=$testdir
> -- 
> 2.36.0.464.gb9c8b46e94-goog
> 

