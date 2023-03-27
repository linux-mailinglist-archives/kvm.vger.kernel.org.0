Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618666CA837
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 16:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbjC0Ou1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 10:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232993AbjC0OuV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 10:50:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BCCE5
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 07:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679928574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6mgt1YP3OU6K5VrFpeP0QEImFZdTmdePxo1sSjajw1U=;
        b=XUcXZt6ZZWkLk1hMtERrPAiapt/9cPA1d4G8L8Km7/yIUHMmTVMkgAKq3P3wAzZ727WYcR
        Oua9D4a5O7vaIMQoV7mMz9JeppoXxSc4X5dYfaGLBDADnkzGGQJGhigBXrqmzEUvA0Tzrt
        nHmD1J18P+uOUufnaVYMPi3Vznt4CV0=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-P_deqkiyMsKYeQzsC8mK0g-1; Mon, 27 Mar 2023 10:49:33 -0400
X-MC-Unique: P_deqkiyMsKYeQzsC8mK0g-1
Received: by mail-qv1-f70.google.com with SMTP id v8-20020a0ccd88000000b005c1927d1609so3605953qvm.12
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 07:49:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679928573;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6mgt1YP3OU6K5VrFpeP0QEImFZdTmdePxo1sSjajw1U=;
        b=8RQooUE6Zmr+/SPIo7/P6VSHwcJaYQo9B7NMjZ05bctmio5wOSwTIikya7cAOIT7ft
         ZtwzjNloNby/Py07rpVxuv0jQKzjismSn/4dOxa878yoY5PFuLSivn3KzWYdBkEA6hK6
         WqdtNy4gfl+hUhCa70QQvqJESbcxr/AhePF5GECFW6lqaLtV+Vq2w9qbivnsE76jQbb8
         g5W/XHt0vUtKqbV+Oc9TmRJMcvGumTz7Bni/0pJOYUZzfMwIxFR7Z7wtr6QJRLSggUZh
         nj741MWJYP/l2hvBx9L+bUXqQiOX1c85e3n0cipK279zNqSu7Jvs1qxg7Oy//c5T0G8C
         9U4Q==
X-Gm-Message-State: AO0yUKXxyRW7jRnev5m6P0YxCdDfaz3oDl7fYbfA+DCjqDwGWPzExD/4
        t97cLTwyKFK5NCFZ0uB5DtPLPccJpT5C93xFCXP9WezeBXhC56jgtsG4RlMCr8xcVFHGExALK4y
        5XDV+l+P/g55c
X-Received: by 2002:a05:622a:1a17:b0:3bf:c423:c384 with SMTP id f23-20020a05622a1a1700b003bfc423c384mr33238935qtb.15.1679928573181;
        Mon, 27 Mar 2023 07:49:33 -0700 (PDT)
X-Google-Smtp-Source: AK7set9si+K4JcviTTipBQ6wZQvqSqfH2mPFnCbwI4rvR3NHWxjDP4pDJ7VDNuLhU35RW65H49iEpQ==
X-Received: by 2002:a05:622a:1a17:b0:3bf:c423:c384 with SMTP id f23-20020a05622a1a1700b003bfc423c384mr33238909qtb.15.1679928572950;
        Mon, 27 Mar 2023 07:49:32 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-177-5.web.vodafone.de. [109.43.177.5])
        by smtp.gmail.com with ESMTPSA id do31-20020a05620a2b1f00b00746ac77366fsm3127814qkb.12.2023.03.27.07.49.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 07:49:32 -0700 (PDT)
Message-ID: <0787fb2b-9a22-9fa7-cead-768e43cb79af@redhat.com>
Date:   Mon, 27 Mar 2023 16:49:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests v3 04/13] powerpc: Abstract H_CEDE calls into a
 sleep functions
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     Laurent Vivier <lvivier@redhat.com>
References: <20230327124520.2707537-1-npiggin@gmail.com>
 <20230327124520.2707537-5-npiggin@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230327124520.2707537-5-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/03/2023 14.45, Nicholas Piggin wrote:
> This consolidates several implementations, and it no longer leaves
> MSR[EE] enabled after the decrementer interrupt is handled, but
> rather disables it on return.
> 
> The handler no longer allows a continuous ticking, but rather dec
> has to be re-armed and EE re-enabled (e.g., via H_CEDE hcall) each
> time.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
> Since v2:
> - Comment about DEC interrupt firing [Thomas review]
> 
>   lib/powerpc/asm/handlers.h  |  2 +-
>   lib/powerpc/asm/ppc_asm.h   |  1 +
>   lib/powerpc/asm/processor.h |  7 ++++++
>   lib/powerpc/handlers.c      | 10 ++++-----
>   lib/powerpc/processor.c     | 43 +++++++++++++++++++++++++++++++++++++
>   powerpc/sprs.c              |  6 +-----
>   powerpc/tm.c                | 20 +----------------
>   7 files changed, 58 insertions(+), 31 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

