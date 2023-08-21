Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4131278360C
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 01:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbjHUXBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 19:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjHUXA7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 19:00:59 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32023137
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 16:00:58 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-68a402c1fcdso1059333b3a.1
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 16:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692658857; x=1693263657;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Klij9wv5DPga//TKbsnaBDvfDfkb7jucsR0dMXHv8YQ=;
        b=s5Lr2ep7iAKN7KmGI1/v5pG4Fy5SbsntwOSZqJY7MHXxB04MlnLd/Dc4viOVbX6HKt
         rh4vXMaIp3VwS4ETG3pVWewzCfqSaxZl1wt5NA9vbuST4U+MFPIr7iheAoW+/o+GAgTK
         9Y2oK50suHEUb64boUuFKgjJBsFoFzrfmF4pw9flPdDqIoEhv4eCyNPAZvHwjzlGRmzY
         X661l9f6GhvmlkU1UAz+kPEnqe2+gGJAALMhHgMN8DKLBkmmMilGYbvewvdTgHlC/VxL
         RU5YyJhET/KfxUS3CFgiH7aMR2g4LFe583XYupalNuQiv/rk0aQ92ziQtsCONwRYoUq1
         8Ezw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692658857; x=1693263657;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Klij9wv5DPga//TKbsnaBDvfDfkb7jucsR0dMXHv8YQ=;
        b=bh55Fag2iik8VPu+/Yy9Hm92dDBKnf8wAIdW5sdaIBbG6OrB7bqhpHgYu66LfKw8Y5
         j/BQRZ2bkCkrvUbOEOdl+xuH1BDY4nF+b69bPf2pUGLv5994dQ1ccvF8tYqs4WbG9JSD
         phgCCXjdld7sVA/HvZL0ANLpMfnk5bBlVb6aYpI3z/mY9GGbyUel9u1n5/IPwjKWj3qn
         vq4sp+BCvFbUhU4bPfLkLMyt6kxE0rr/uy0yhfQEV3vPuG5gkXoVhlPUhS2BIFmzy0Yf
         OhJxKkhILV5x7AacmGLn29CriebYWkDvSz1AW1YbTpolk2Iu2S/pnKIAtluK+tuCZTPJ
         LNDQ==
X-Gm-Message-State: AOJu0YyHXH5IMDqPqjSTJ5KB9y2jq/iKFL0ex0iAua2wUTZAwz4WVuAh
        tVFGt9FrIphdrnmvSIhx0A4=
X-Google-Smtp-Source: AGHT+IHv/GegNd8oLQThewA7cqV9YChRmbTzNOQyZgtTBoOJOXZJqPenMjxk1PJgmY8inKr8cDR9nw==
X-Received: by 2002:a05:6a20:4417:b0:140:54ab:7f43 with SMTP id ce23-20020a056a20441700b0014054ab7f43mr7284618pzb.52.1692658857456;
        Mon, 21 Aug 2023 16:00:57 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id a9-20020a62bd09000000b0068844ee18dfsm6584873pff.83.2023.08.21.16.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Aug 2023 16:00:56 -0700 (PDT)
Date:   Mon, 21 Aug 2023 16:00:54 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v2 08/58] i386/tdx: Adjust the supported CPUID based on
 TDX restrictions
Message-ID: <20230821230054.GB3642077@ls.amr.corp.intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-9-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230818095041.1973309-9-xiaoyao.li@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 18, 2023 at 05:49:51AM -0400,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 56cb826f6125..3198bc9fd5fb 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
...
> +static inline uint32_t host_cpuid_reg(uint32_t function,
> +                                      uint32_t index, int reg)
> +{
> +    uint32_t eax, ebx, ecx, edx;
> +    uint32_t ret = 0;
> +
> +    host_cpuid(function, index, &eax, &ebx, &ecx, &edx);
> +
> +    switch (reg) {
> +    case R_EAX:
> +        ret |= eax;
> +        break;
> +    case R_EBX:
> +        ret |= ebx;
> +        break;
> +    case R_ECX:
> +        ret |= ecx;
> +        break;
> +    case R_EDX:
> +        ret |= edx;

Nitpick: "|" isn't needed as we initialize ret = 0 above. Just '='.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>
