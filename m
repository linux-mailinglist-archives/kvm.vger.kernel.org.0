Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C42C753145B
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 18:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237437AbiEWO7s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 10:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237309AbiEWO7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 10:59:48 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92015B8B8
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 07:59:46 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 31so13897538pgp.8
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 07:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DFcYVXODv/uBzvDJHDbZg+Ml/E4lGZcMHzTQgnzw4EM=;
        b=NwQWARYR4RZn2CAjQsYJadNYKaVW7MzIoN/nMg9jqwZlNBfbREqbdLtvZDoDO4Z2kK
         frsixTGjYcfMSjEKLZrD2vdypr6UgcYPwluAhmygBe7J0iPQPRRpsxKMuCD2XDLMU5Fw
         YKIk0kZtQaTotXXV0gEALpq61WUPMlRJ9s9udlSDwkyZ0fPDfCadLx/guzuApI5THQjy
         kVJps1ZbRB1fgjk14rCp7iryt8xav4rO6OQDBi5GVJiXZ7FLYPXd4kEvJAx6VhVSOrDz
         v/7LuT/Ze0wUPUT03WLrgJzZdIC9iRn6D+edqU24cB0Z510B9DqpPeLekOs55zxrqupz
         JLnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DFcYVXODv/uBzvDJHDbZg+Ml/E4lGZcMHzTQgnzw4EM=;
        b=zdTbb49aX7Pp2xytCUFOYKVYUf5Fae/20jU+g/GWxMPgza7tT2ls6ld+7ly36iLHNX
         FU0DA61A3zG3hIOg5MBJI0KVVoAgQIrr9AhaFJ5RWyk0rlzbtoIZzxHtA1eCO/Js5fOv
         xIlJH7s1qvysTKSgjB0K6NlMkHFW6A3UPIoPUKg3TNJZsyvcD6uB3TNpUgwX3nkLHEXt
         XCs6PwLyLdTXGRAj/LzD9DcCWNI6MQHCClEImTuomSQeFpy20uez+XJ62mTejEw//Prf
         SDJ+cx4sDkqBa0J91Q1kiBFQjz9nG5qP3hkT7/coKCl4FhhzcKjTkjXIzbIvhejRPIai
         oRfQ==
X-Gm-Message-State: AOAM5324kuCUCHKdXdKyzC23O75qDLyB0vs6S0m9ovUvtuhH5zQHGocZ
        oG/nrLb7Q22hrXE7KyyH3wQ=
X-Google-Smtp-Source: ABdhPJzQGTfhJi9vv+DQqQOwi2a4+S5UgWmHwyMRqF95siRlqXEmNb/p7WKMlsk/F/iLSiOqPhXFmQ==
X-Received: by 2002:a63:fc1d:0:b0:3fa:218e:1329 with SMTP id j29-20020a63fc1d000000b003fa218e1329mr7403816pgi.268.1653317986095;
        Mon, 23 May 2022 07:59:46 -0700 (PDT)
Received: from localhost ([192.55.54.48])
        by smtp.gmail.com with ESMTPSA id h11-20020a170902f2cb00b0015f33717794sm5211722plc.42.2022.05.23.07.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 07:59:45 -0700 (PDT)
Date:   Mon, 23 May 2022 07:59:44 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com,
        Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com
Subject: Re: [RFC PATCH v4 07/36] i386/tdx: Introduce is_tdx_vm() helper and
 cache tdx_guest object
Message-ID: <20220523145944.GB3095181@ls.amr.corp.intel.com>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-8-xiaoyao.li@intel.com>
 <20220523084817.ydle4f4acsoppbgr@sirius.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220523084817.ydle4f4acsoppbgr@sirius.home.kraxel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 23, 2022 at 10:48:17AM +0200,
Gerd Hoffmann <kraxel@redhat.com> wrote:

> > diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
> > index c8a23d95258d..4036ca2f3f99 100644
> > --- a/target/i386/kvm/tdx.h
> > +++ b/target/i386/kvm/tdx.h
> > @@ -1,6 +1,10 @@
> >  #ifndef QEMU_I386_TDX_H
> >  #define QEMU_I386_TDX_H
> >  
> > +#ifndef CONFIG_USER_ONLY
> > +#include CONFIG_DEVICES /* CONFIG_TDX */
> > +#endif
> > +
> >  #include "exec/confidential-guest-support.h"
> >  
> >  #define TYPE_TDX_GUEST "tdx-guest"
> > @@ -16,6 +20,12 @@ typedef struct TdxGuest {
> >      uint64_t attributes;    /* TD attributes */
> >  } TdxGuest;
> >  
> > +#ifdef CONFIG_TDX
> > +bool is_tdx_vm(void);
> > +#else
> > +#define is_tdx_vm() 0
> 
> Just add that to the tdx-stubs.c file you already created in one of the
> previous patches and drop this #ifdef mess ;)

This is for consistency with SEV.  Anyway Either way is okay.

From target/i386/sev.h
  ...
  #ifdef CONFIG_SEV
  bool sev_enabled(void);
  bool sev_es_enabled(void);
  #else
  #define sev_enabled() 0
  #define sev_es_enabled() 0
  #endif

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
