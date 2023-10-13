Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 943797C82A8
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 11:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbjJMJ6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 05:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbjJMJ6V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 05:58:21 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E446EC9
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 02:58:17 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-53db360294fso3534806a12.3
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 02:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697191096; x=1697795896; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nlysa/0HAt7XwTL7Sd4FpaqX2JsJYLCn7DORbQofqo8=;
        b=oOMpA4RXR0o11JOgKrZ9y5tA2Q/b42jxUUNbnlqH1R4WkXfQWqlGzTMZiESAveKcvw
         wcvS+CIGmAIOmFrdXOXJL1eRd8TlwOk/nPyISBVDYKHw1A26stgOveoXVl18dh0B5hTu
         uw+dix3PkS+ZW5Dfw+C/L4poA2Tl+afXpXxno+JcFEx6iqm7RmnvZWKq4JRgxJHvVsJx
         d+ov7ljdPoly132MDMEuB36JKFNCmm+IYrl/5AFC8NAKte7GjQnVU5GN9482hK1mjSkz
         eFQykZuMndnbMusmbVVjso8TrGDzdIdezM3BITYytwVre8MyuAurMuP50t+y5MUY3xuc
         wLbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697191096; x=1697795896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nlysa/0HAt7XwTL7Sd4FpaqX2JsJYLCn7DORbQofqo8=;
        b=C56ZV2fz5p/yWTrzBg5JOi4qWg+Hi0zvfAGz5zpUj+uTpYsAODX8KIIkh0ULEScGBo
         NyUnPAYVzu5LLvAQVkXajMiiKNY7AE9hVUeDMJo4vm8HyqcD+C2wO8vK0+aVR6WsCun9
         eP8ocdTjaZ/EaqEiL3q7Xh/zLsOX12kWwbN4387hIKnGxGkQTqfGE/oQHr1iwDLtadWG
         ScRUeS2CuSqbZamIJ/NpVriXpnWdXgd3ohHgiC6/L44BMkZYOWdxuSGgtIQN63M8DeY8
         FGX7KaEYufgRjhGpYiPR3D1sKHBJIAQ1rHpg0XvxgQZBg26Yc2r8fsZ+YEChd0X8XDIT
         QKJQ==
X-Gm-Message-State: AOJu0Yz13zX8lJS4sDCtAvcGUB4shJRS0su2rhpJyAPH0osRm3EpxZz5
        5groBTcAd29AZWW2bRCNN6zaCIOJY2DWLjFPevU=
X-Google-Smtp-Source: AGHT+IEguRhdGJwf0aIebN3fBCeHhRTYBl34+o54X7nhqZBgpclVfefxrGnH7qQH1m05Yq6L5Ya53A==
X-Received: by 2002:aa7:c998:0:b0:530:a226:1f25 with SMTP id c24-20020aa7c998000000b00530a2261f25mr21443281edt.17.1697191096257;
        Fri, 13 Oct 2023 02:58:16 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id u19-20020a50d513000000b0053e408aec8bsm650498edi.6.2023.10.13.02.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Oct 2023 02:58:15 -0700 (PDT)
Date:   Fri, 13 Oct 2023 11:58:14 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Conor Dooley <conor@kernel.org>
Cc:     Alexandre Ghiti <alexghiti@rivosinc.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        kasan-dev@googlegroups.com, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-efi@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 4/5] riscv: Suffix all page table entry pointers with 'p'
Message-ID: <20231013-19d487ddc6b6efd6d6f62f88@orel>
References: <20231002151031.110551-1-alexghiti@rivosinc.com>
 <20231002151031.110551-5-alexghiti@rivosinc.com>
 <20231012-envision-grooving-e6e0461099f1@spud>
 <20231012-exclusion-moaner-d26780f9eb00@spud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012-exclusion-moaner-d26780f9eb00@spud>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 12, 2023 at 12:35:00PM +0100, Conor Dooley wrote:
> On Thu, Oct 12, 2023 at 12:33:15PM +0100, Conor Dooley wrote:
> > Hey Alex,
> > 
> > On Mon, Oct 02, 2023 at 05:10:30PM +0200, Alexandre Ghiti wrote:
> > > That makes it more clear what the underlying type is, no functional
> > > changes intended.
> > 
> > Scanning through stuff on patchwork, this really doesn't seem worth the
> > churn. I thought this sort of Hungarian notation-esque stuff was a
> > relic of a time before I could read & our docs even go as far as to
> 
> s/go/went/, I see the language got changed in more recent releases of
> the kernel!

The documentation seems to still be against it, but, despite that and
the two very valid points raised by Marco (backporting and git-blame),
I think ptep is special and I'm mostly in favor of this change. We may
not need to s/r every instance, but certainly functions which need to
refer to both the pte and the ptep representations of entries becomes
more clear when using the 'p' convention (and then it's nice to have
ptep used everywhere else too for consistency...)

Anyway, just my 2 cents.

Thanks,
drew
