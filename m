Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F635770BC3
	for <lists+kvm@lfdr.de>; Sat,  5 Aug 2023 00:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjHDWKm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 18:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjHDWKl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 18:10:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78A9E6E
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 15:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691186997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=evYrVf/iKCZzrXphWuBBZKTjd3mBH9ss4zSdxYs7MUs=;
        b=PDszbfKBcnagiXLInDCz6a7qLODua/mhBABPqptZHPgKdx76zaicnD1U9dQyfZdjgad93A
        G5cbcik+/Ywa9DwyYx4LR5xX7CyaDAggMfwjYAtO98vB3s8d2vlwVkLewiSHVr19MBlQqq
        6iL3iuE3pbcpVWOicx6I8WlEU4g2Z3Y=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-o_PnwxuINMWjULvd7UqXuw-1; Fri, 04 Aug 2023 18:09:55 -0400
X-MC-Unique: o_PnwxuINMWjULvd7UqXuw-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5223bdb71e5so1569953a12.0
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 15:09:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691186994; x=1691791794;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=evYrVf/iKCZzrXphWuBBZKTjd3mBH9ss4zSdxYs7MUs=;
        b=eD4OKey+eTOTl6E8XGpoacUT4X5PaimC0exkw5ZBUlH5hOpoAo73PLVI0z/yh/FHa0
         lHKC6EkqV3tiItofetvvCx1F5h9ficd2VZVDxYSq1TTeWsDCOU8FYhXjNmR29YMF3kAs
         m2VXtkx2+ffwDT7d8rCuneDfEjTHAH7kWxrJU3vvEzaO+HhU3BaWU9M9bdGuLbrFPKah
         VLw+oIHlWx61Y/uqfAJ4XLVjM9Agk8e9LUYgbkEdFMYL2cBjF807FV5Mv7OC4+5vU9S3
         r28bUnX/mQmrnJNu4Y4ggkrmfh4vcRWCzst2iQ/doHF1OJ9lCL041ZcG7tYrQV8aa+3c
         PJGA==
X-Gm-Message-State: AOJu0YyYOoSg3+AeE7CxYzYA3Z/QBfbNm4dwzz78wn1o5DJMIArrraIj
        c/ioBl/wry2f79sENZUWt03qusi/qGNRWX9PRzqCAZZiXZcA6Wkx1I2dOZavB1qbINq+F8tSIzA
        iTx4iySbJlls1
X-Received: by 2002:aa7:c990:0:b0:521:a99b:a233 with SMTP id c16-20020aa7c990000000b00521a99ba233mr2648702edt.10.1691186994115;
        Fri, 04 Aug 2023 15:09:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBekLNPRykim88ENWzH/K7RT7FRQkvjiPm6lNHDHg7kFI2E3ObIAF2P2Vh1gJoj7x5HPbMiw==
X-Received: by 2002:aa7:c990:0:b0:521:a99b:a233 with SMTP id c16-20020aa7c990000000b00521a99ba233mr2648687edt.10.1691186993726;
        Fri, 04 Aug 2023 15:09:53 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id p12-20020aa7d30c000000b00522ce914f51sm1774622edq.67.2023.08.04.15.09.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Aug 2023 15:09:53 -0700 (PDT)
Message-ID: <ff7fecca-8413-6625-4d10-a6b3c21fc24d@redhat.com>
Date:   Sat, 5 Aug 2023 00:09:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] selftests/rseq: Fix build with undefined __weak
Content-Language: en-US
To:     Mark Brown <broonie@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, stable@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20230804-kselftest-rseq-build-v1-1-015830b66aa9@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230804-kselftest-rseq-build-v1-1-015830b66aa9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/23 21:22, Mark Brown wrote:
> Commit 3bcbc20942db ("selftests/rseq: Play nice with binaries statically
> linked against glibc 2.35+") which is now in Linus' tree introduced uses
> of __weak but did nothing to ensure that a definition is provided for it
> resulting in build failures for the rseq tests:
> 
> rseq.c:41:1: error: unknown type name '__weak'
> __weak ptrdiff_t __rseq_offset;
> ^
> rseq.c:41:17: error: expected ';' after top level declarator
> __weak ptrdiff_t __rseq_offset;
>                  ^
>                  ;
> rseq.c:42:1: error: unknown type name '__weak'
> __weak unsigned int __rseq_size;
> ^
> rseq.c:43:1: error: unknown type name '__weak'
> __weak unsigned int __rseq_flags;
> 
> Fix this by using the definition from tools/include compiler.h.
> 

Queued, thanks.  Sorry for the breakage.

Paolo

> Fixes: 3bcbc20942db ("selftests/rseq: Play nice with binaries statically linked against glibc 2.35+")
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
> It'd be good if the KVM testing could include builds of the rseq
> selftests, the KVM tests pull in code from rseq but not the build system
> which has resulted in multiple failures like this.
> ---
>   tools/testing/selftests/rseq/Makefile | 4 +++-
>   tools/testing/selftests/rseq/rseq.c   | 2 ++
>   2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/rseq/Makefile b/tools/testing/selftests/rseq/Makefile
> index b357ba24af06..7a957c7d459a 100644
> --- a/tools/testing/selftests/rseq/Makefile
> +++ b/tools/testing/selftests/rseq/Makefile
> @@ -4,8 +4,10 @@ ifneq ($(shell $(CC) --version 2>&1 | head -n 1 | grep clang),)
>   CLANG_FLAGS += -no-integrated-as
>   endif
>   
> +top_srcdir = ../../../..
> +
>   CFLAGS += -O2 -Wall -g -I./ $(KHDR_INCLUDES) -L$(OUTPUT) -Wl,-rpath=./ \
> -	  $(CLANG_FLAGS)
> +	  $(CLANG_FLAGS) -I$(top_srcdir)/tools/include
>   LDLIBS += -lpthread -ldl
>   
>   # Own dependencies because we only want to build against 1st prerequisite, but
> diff --git a/tools/testing/selftests/rseq/rseq.c b/tools/testing/selftests/rseq/rseq.c
> index a723da253244..96e812bdf8a4 100644
> --- a/tools/testing/selftests/rseq/rseq.c
> +++ b/tools/testing/selftests/rseq/rseq.c
> @@ -31,6 +31,8 @@
>   #include <sys/auxv.h>
>   #include <linux/auxvec.h>
>   
> +#include <linux/compiler.h>
> +
>   #include "../kselftest.h"
>   #include "rseq.h"
>   
> 
> ---
> base-commit: 5d0c230f1de8c7515b6567d9afba1f196fb4e2f4
> change-id: 20230804-kselftest-rseq-build-9d537942b1de
> 
> Best regards,

