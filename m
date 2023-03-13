Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 693636B8195
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 20:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbjCMTRh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 15:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbjCMTRe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 15:17:34 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979F67B499;
        Mon, 13 Mar 2023 12:17:05 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id kb15so13096248pjb.1;
        Mon, 13 Mar 2023 12:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678735021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oSkOjtPlss6AuvdlJQeNlDJVqEVmmqn9psYvTsKnPLo=;
        b=Ont93xbDzqMettfhdIaPCqWEDvj7L+Hcp2WCdZwAL+5mR136ijE0lysM33wRwxnu0q
         c7xMJMrZekAbwxU5Ns2Bwhk7lFw3IY/x2Zjal3ziPSabNAHCfTSC2dkY5kemvv0cdYLf
         Yo3vCzaK/ro5jqbpooae3rrfeUjMTzKcmsPulMoh2vKtSrtPx2OSfctKW5zsDkkTIT/+
         mxO3Qdf9hoXjRiD6MF5fZ9HQiCHMQ4Qgp5T72ISGr1d8esGEkhIzCYzaN77q8lU4UM6Y
         HsyUBosyMCKbmA5Yv9iBzgN0/KZwtj8nHbOayqFJaQks/G2mFhflP9QSDwVehatrvSnx
         1n0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678735021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oSkOjtPlss6AuvdlJQeNlDJVqEVmmqn9psYvTsKnPLo=;
        b=eqATZJhuM2oyW4zNeN1P4JaxUgt8WKXo1ma8s5gAEUEnkg1zbKgao22x4Y/1A9n91y
         g4EYBxNrignrfqxtULilULe7A9VVN2oJKpHgTBpUeEDA/dkUHE7mWccZ49Gnm3zsWlod
         v3wGLTQe4yTfpkDMgElPY5JilM7/mYZpsk3Pxpj5J6zrDilTvGzQuypvEVHorYNpZ30z
         uBWAs0Q5Srw1SM/JFl71X/dk7VAGYMiICpGmnOt1QvvpAZymueXyogzjnprYUS5ggBfk
         V1Es9knG/b+6AhBGgW1bZ3ISA0Ew4nsen3zuG/jjf/6x8QqBgcJFM3sCceJgSr8PS2Wk
         gdCA==
X-Gm-Message-State: AO0yUKUrmvrEJMUJ7gcQ1K/sXKWKRy9yVbnCiPYJRqM80nAGSr0yCmJG
        rgcZkeiKKReZgdPFY2MnT5w=
X-Google-Smtp-Source: AK7set/cP7eJ88/46VWYlYel2vhzialBJEtmiAXI57ZJrcZ7nw2NFpMB2W9BRb1hqagg8f2LeOHZgQ==
X-Received: by 2002:a05:6a20:8ba7:b0:d0:76e3:16e6 with SMTP id m39-20020a056a208ba700b000d076e316e6mr17984345pzh.12.1678735020879;
        Mon, 13 Mar 2023 12:17:00 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id s5-20020aa78d45000000b006255a16be2fsm80288pfe.132.2023.03.13.12.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 12:17:00 -0700 (PDT)
Date:   Mon, 13 Mar 2023 12:16:58 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v13 009/113] KVM: TDX: Define TDX architectural
 definitions
Message-ID: <20230313191658.GB3922605@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <1e73822eacaa512aeb559a3f3b71ae4963bf9fdd.1678643052.git.isaku.yamahata@intel.com>
 <b0c8af03-882c-e675-8397-5b6f843fa4df@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b0c8af03-882c-e675-8397-5b6f843fa4df@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 13, 2023 at 07:37:43PM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> On 3/13/2023 1:55 AM, isaku.yamahata@intel.com wrote:
> > diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
> > new file mode 100644
> > index 000000000000..942a0e561a7b
> > --- /dev/null
> > +++ b/arch/x86/kvm/vmx/tdx_arch.h
> ...
> > +
> > +#define TDG_VP_VMCALL_GET_TD_VM_CALL_INFO		0x10000
> > +#define TDG_VP_VMCALL_MAP_GPA				0x10001
> > +#define TDG_VP_VMCALL_GET_QUOTE				0x10002
> > +#define TDG_VP_VMCALL_REPORT_FATAL_ERROR		0x10003
> > +#define TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT	0x10004
> 
> TDX guest side implementation defines
> 
>     /* TDX hypercall Leaf IDs */
>     #define TDVMCALL_MAP_GPA			0x10001
>     #define TDVMCALL_REPORT_FATAL_ERROR		0x10003
> 
> We need put these shared definitions between host and guest into some shared
> header file.

Good suggestion. Let me fix it.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
