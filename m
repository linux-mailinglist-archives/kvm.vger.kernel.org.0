Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3E15B0989
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 18:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiIGQDm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 12:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiIGQDU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 12:03:20 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE70EBD139
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 09:01:53 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id h188so13995065pgc.12
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 09:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=9KRnzPYLXFBo8deCdwkWdxXfiCPHIvAWarLP6/mjRfI=;
        b=RICBO0Cf7lNCidLiQFP61ZEw/gLkbT1IfOF8uo8Fn6mPoUAWcsIc1DSV6PWdMmzp9s
         hKhGPwEW0oy6s+FAr1nPJ8pVQGdoqSAOTRaPAlt6LLTBq3GwXurgZcGBO7gqRVuKsbnF
         3KdbGqfrikBf/zbfJempULa3z5ofASZx27yDCP4/KGJERxJO7m3fVbE1rEPdnSjiTiHe
         gBUY80jTwbWjhXDj/kJ/TUycRhMg6W0yBwRx0mG70DVcGW8YA/AOY2gVD1k4jsGKqO3a
         eqNQg/6F8uiUrWqUKA8bpdKPWje571fetOz9ktUtLH05tBNt7Uhxj0BbHWgO4Wbg59SM
         FK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=9KRnzPYLXFBo8deCdwkWdxXfiCPHIvAWarLP6/mjRfI=;
        b=QGquhm7pK8smsBhLknjMZP4EiVo1Ut+PLurCMPUrlCwL1wl704JvotPWBCF8CsxaIn
         rNGD59yglFgppXGMatvzHcLgQGynJPtLk9BKN9m0XpI9zN3ampy409AEdQM8TH03CikH
         AolJVi499kgSodjKp6aGS8WnGIXHvh63F9lONxlByv8Oyb68rC5N9ctmqvadrfd1kRtx
         YLZhn0saRSpJrUBBF0KbKBT15b05afZ8mKmfT9EWa5WjhlyPNr53aJbeJrm+6mOs6UVR
         wJDkwxPCXr7m850JBkpAgyN0LJiXtOivkj/EAFuIuuyk41Ks92qOsgbCAkn/h+zw6c3F
         AyzA==
X-Gm-Message-State: ACgBeo279WwBhiJB/d1bQMtOdRHQvnGLEnlsX86hrRvCfsQ6W4IoPAm5
        59Xhn2UT6XBO0xX71KJ4jK3fXw==
X-Google-Smtp-Source: AA6agR42QGbCPYeSwzUFTzvX3lJhhFP3T5eSJNzWl9Y6r0NmQ1eBHZNAONmviQHhEOZp3CJ1KAF32w==
X-Received: by 2002:a63:5818:0:b0:430:a25d:e728 with SMTP id m24-20020a635818000000b00430a25de728mr3902575pgb.264.1662566504471;
        Wed, 07 Sep 2022 09:01:44 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u1-20020a632341000000b0042a6dde1d66sm9245576pgm.43.2022.09.07.09.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 09:01:44 -0700 (PDT)
Date:   Wed, 7 Sep 2022 16:01:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: kvm: Fix a compile error in
 selftests/kvm/rseq_test.c
Message-ID: <YxjAZOGF9uSE2+AT@google.com>
References: <20220802071240.84626-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220802071240.84626-1-cloudliang@tencent.com>
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

On Tue, Aug 02, 2022, Jinrong Liang wrote:
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> The following warning appears when executing:
> 	make -C tools/testing/selftests/kvm
> 
> rseq_test.c: In function ‘main’:
> rseq_test.c:237:33: warning: implicit declaration of function ‘gettid’; did you mean ‘getgid’? [-Wimplicit-function-declaration]
>           (void *)(unsigned long)gettid());
>                                  ^~~~~~
>                                  getgid
> /usr/bin/ld: /tmp/ccr5mMko.o: in function `main':
> ../kvm/tools/testing/selftests/kvm/rseq_test.c:237: undefined reference to `gettid'
> collect2: error: ld returned 1 exit status
> make: *** [../lib.mk:173: ../kvm/tools/testing/selftests/kvm/rseq_test] Error 1
> 
> Use the more compatible syscall(SYS_gettid) instead of gettid() to fix it.
> More subsequent reuse may cause it to be wrapped in a lib file.
> 
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>


Paolo, do you want to grab this for 6.0?  It doesn't look like we're going to have
a more elegant solution anytime soon...
