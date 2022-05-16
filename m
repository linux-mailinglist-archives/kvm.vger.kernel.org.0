Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6262529377
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 00:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242211AbiEPWPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 18:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233180AbiEPWPI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 18:15:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63BF72CE1B
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 15:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652739305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U1uTN3maQ1+w+xJcBSJn07JGiDAloIMKrbbD5XWs9b0=;
        b=ACm5Rz8zxa7D2crMpi9zL7/ARdr1whqKp3uQ4Icu/61pSgPXVWjijoJslrpcf4hvDLgPqL
        f9TJ4tkaqoJz6F9GFfYJHgXiCXfKQ9OCXNbZmn2tMW1I/HHRWQ8uMoao3wdKJ2U1IVwtT0
        99lzrWxHXUDnYckFQ/WS0Op3Zaw/z78=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-363-88R4CVD-MEe4AAcze7GptA-1; Mon, 16 May 2022 18:15:04 -0400
X-MC-Unique: 88R4CVD-MEe4AAcze7GptA-1
Received: by mail-il1-f200.google.com with SMTP id h13-20020a056e021b8d00b002d128cb1b7dso1715445ili.19
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 15:15:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U1uTN3maQ1+w+xJcBSJn07JGiDAloIMKrbbD5XWs9b0=;
        b=1yYEoxpaxSuxqmVdfHF9/HkpuyS1BDujIWu5vc4WN8AHOTEWqk7PVlhKXYUDPEOLOC
         /0UQx8vAp0o4Ok4NZ5fqF/7eWcVgC8j8vK+OzsgkeyizP2aD+O0vX2hhOxpv5nsZel6S
         SxuBTU1Y/8ShFlnVJ5ZpxasEPAS+XshvmFsRaLZqGRS9zioZWkZGFW432dxKP1A38Gq3
         dWOHiiSYKgBU8QHwxqybySnx6Pn3CzdDW72JKe1KDP3PxhV1q3km9Ks6PbV4wA4hx+sP
         O7MzCvS097Mrlw2Wrv7IwIDjIaNZ/I/6hd9vvPHVAYWm3+OcX1iSFS3wZa8zjEn4drZh
         cByA==
X-Gm-Message-State: AOAM532BobBAM1DjwOovPAbpBr7nz0iCLs8eUHTOFrPFWdlJ4Gqc+lam
        bmNDfe9B9sHwEZAxTfOaC6EZlnQNbFlihBZFmSXZMetbwMrYMCc+EtufXj5nIWWe3AfFDuJ1fM6
        h2OVwljPikXeQ
X-Received: by 2002:a05:6638:1308:b0:32b:d5f7:62e6 with SMTP id r8-20020a056638130800b0032bd5f762e6mr10025099jad.52.1652739303510;
        Mon, 16 May 2022 15:15:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTxMzRvwofyd22DuUR416qbiqRqmwVhUV1IiK143vczsnJr6VBUebqJ+aQRes9PuV8iS+PsA==
X-Received: by 2002:a05:6638:1308:b0:32b:d5f7:62e6 with SMTP id r8-20020a056638130800b0032bd5f762e6mr10025091jad.52.1652739303303;
        Mon, 16 May 2022 15:15:03 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id w4-20020a05663800c400b0032b5316724dsm3110476jao.22.2022.05.16.15.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 15:15:02 -0700 (PDT)
Date:   Mon, 16 May 2022 18:15:01 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Subject: Re: [PATCH 7/9] KVM: selftests: Link selftests directly with lib
 object files
Message-ID: <YoLM5caUPbkJ7DEy@xz-m1.local>
References: <20220429183935.1094599-1-dmatlack@google.com>
 <20220429183935.1094599-8-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220429183935.1094599-8-dmatlack@google.com>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 06:39:33PM +0000, David Matlack wrote:
> The linker does obey strong/weak symbols when linking static libraries,
> it simply resolves an undefined symbol to the first-encountered symbol.
> This means that defining __weak arch-generic functions and then defining
> arch-specific strong functions to override them in libkvm will not
> always work.
> 
> More specifically, if we have:
> 
> lib/generic.c:
> 
>   void __weak foo(void)
>   {
>           pr_info("weak\n");
>   }
> 
>   void bar(void)
>   {
>           foo();
>   }
> 
> lib/x86_64/arch.c:
> 
>   void foo(void)
>   {
>           pr_info("strong\n");
>   }
> 
> And a selftest that calls bar(), it will print "weak". Now if you make
> generic.o explicitly depend on arch.o (e.g. add function to arch.c that
> is called directly from generic.c) it will print "strong". In other
> words, it seems that the linker is free to throw out arch.o when linking
> because generic.o does not explicitly depend on it, which causes the
> linker to lose the strong symbol.
> 
> One solution is to link libkvm.a with --whole-archive so that the linker
> doesn't throw away object files it thinks are unnecessary. However that
> is a bit difficult to plumb since we are using the common selftests
> makefile rules. An easier solution is to drop libkvm.a just link
> selftests with all the .o files that were originally in libkvm.a.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index af582d168621..c1eb6acb30de 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -172,12 +172,13 @@ LDFLAGS += -pthread $(no-pie-option) $(pgste-option)
>  # $(TEST_GEN_PROGS) starts with $(OUTPUT)/
>  include ../lib.mk
>  
> -STATIC_LIBS := $(OUTPUT)/libkvm.a
>  LIBKVM_C := $(filter %.c,$(LIBKVM))
>  LIBKVM_S := $(filter %.S,$(LIBKVM))
>  LIBKVM_C_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_C))
>  LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
> -EXTRA_CLEAN += $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(STATIC_LIBS) cscope.*
> +LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ)
> +
> +EXTRA_CLEAN += $(LIBKVM_OBJS) cscope.*
>  
>  x := $(shell mkdir -p $(sort $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
>  $(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c
> @@ -186,13 +187,9 @@ $(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c
>  $(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S
>  	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
>  
> -LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ)
> -$(OUTPUT)/libkvm.a: $(LIBKVM_OBJS)
> -	$(AR) crs $@ $^
> -
>  x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
> -all: $(STATIC_LIBS)
> -$(TEST_GEN_PROGS): $(STATIC_LIBS)
> +all: $(LIBKVM_OBJS)

Can this line be dropped alongside?  Default targets should have already
been set in ../lib.mk anyway iiuc, and they all depend on the objs.

> +$(TEST_GEN_PROGS): $(LIBKVM_OBJS)

Never know such a difference, but it does seem true to happen..  Good to
learn this.

Reviewed-by: Peter Xu <peterx@redhat.com>

Thanks,

-- 
Peter Xu

