Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01CC14FFA4B
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 17:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236560AbiDMPfJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 11:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234917AbiDMPfA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 11:35:00 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0B139B91
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 08:32:39 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id g12-20020a17090a640c00b001cb59d7a57cso4154324pjj.1
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 08:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hiY5e47Ko87MkIuTm3Q1jTYlfib2vDpGlep7TMJhc9k=;
        b=Q9gxT9nRG1LTxgkkOUk1qCK00K0XYxWgpNRVUIxImzeLs7XiMyPdgcVGJsjUUf/pY2
         nGM5QWtEokydtV8uhy7oesYrXrFTiUhqfKWNreuuE9WLPW/nvsi0lS1qzUx9Jzc1gme/
         y23Y+A5L4r3qsmP5N742xj7xd7KaaguVSN5oS/yUex5uSb5MwHKVOoeePvcrTvJ47s0E
         dKReepulDBRt62XXrHDF+eh+Ow9tnK7meHH7eprD6A/QPNnnYl83e+z49SBKT7giLd+n
         mxH5mhLjhvWc48tozh97oE3B4VvYqc8rQNp+i6YfLFdaXI9J2k2xCjO3krJ2zIrcgXy5
         qmJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hiY5e47Ko87MkIuTm3Q1jTYlfib2vDpGlep7TMJhc9k=;
        b=pC9jeBlc+8EHHlbMt2mdCqIRIS5jg418hs+cgAfTpS2qPJ2kKFdmvhClZZ+4DVVxzD
         yh/zCV2/mcPDQCLjWmRFWvBKY1CZaX7AUmGs6F8LLssx2TAq0Ex8FBG6wjfIwsBNafYr
         2EJFr4mm4hzZbRQvAUnIOyTOKrcH0iGTwjAJg5t0yQWYEbqK3jZZDUf9Oe6QsDSmw/DX
         FwtHVekBQFJi2r3fVjv2IKIZMHgfBdHWj/1uGDCKksQCb+OwpDAW6ZIlI38BDcvjZVHX
         ORnPcKp3jmqK6QDisfAU6Hqm15/j4CWBhNxf70Qi8PLwC8YNF46DCLTFu6RPxhSWcOLv
         3EpQ==
X-Gm-Message-State: AOAM5334PzdPEJXEjIPE8RXc6vl9XtWNeKYRdv4jQVH9tvRyzG0hRzC8
        3SF12RCEvChtBIkCriimrWGeig==
X-Google-Smtp-Source: ABdhPJwSs6PNtBuvPLZpQ+fLuyzDyamAXM9ZZct6t4rnjZdP2unsnaEnc0+Ry75ZRnjsRYT6G8RAgQ==
X-Received: by 2002:a17:90a:7:b0:1c7:c286:abc2 with SMTP id 7-20020a17090a000700b001c7c286abc2mr11600715pja.65.1649863958374;
        Wed, 13 Apr 2022 08:32:38 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x8-20020aa784c8000000b0050577c51d38sm19390312pfn.20.2022.04.13.08.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 08:32:37 -0700 (PDT)
Date:   Wed, 13 Apr 2022 15:32:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH V3 2/4] KVM: X86: Introduce role.glevel for level
 expanded pagetable
Message-ID: <YlbtEorfabzkRucF@google.com>
References: <20220330132152.4568-1-jiangshanlai@gmail.com>
 <20220330132152.4568-3-jiangshanlai@gmail.com>
 <YlXvtMqWpyM9Bjox@google.com>
 <caffa434-5644-ee73-1636-45a87517bae2@redhat.com>
 <YlbhVov4cvM26FnC@google.com>
 <d2122fb0-7327-0490-9077-c69bbfba4830@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2122fb0-7327-0490-9077-c69bbfba4830@redhat.com>
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

On Wed, Apr 13, 2022, Paolo Bonzini wrote:
> On 4/13/22 16:42, Sean Christopherson wrote:
> > On Wed, Apr 13, 2022, Paolo Bonzini wrote:
> > > On 4/12/22 23:31, Sean Christopherson wrote:
> > > > We don't need 4 bits for this.  Crossing our fingers that we never had to shadow
> > > > a 2-level guest with a 6-level host, we can do:
> > > > 
> > > > 		unsigned passthrough_delta:2;
> > > > 
> > > Basically, your passthrough_delta is level - glevel in Jiangshan's patches.
> > > You'll need 3 bits anyway when we remove direct later (that would be
> > > passthrough_delta == level).
> > 
> > Are we planning on removing direct?
> 
> I think so, it's redundant and the code almost always checks
> direct||passthrough (which would be passthrough_delta > 0 with your scheme).

It's not redundant, just split out.  E.g. if 3 bits are used for the target_level,
a special value is needed to indicate "direct", otherwise KVM couldn't differentiate
between indirect and direct.  Violent agreement and all that :-)

I'm ok dropping direct and rolling it into target_level, just so long as we add
helpers, e.g. IIUC they would be

static inline bool is_sp_direct(...)
{
	return !sp->role.target_level;
}

static inline bool is_sp_direct_or_passthrough(...)
{
	return sp->role.target_level != sp->role.level;
}

> > > Regarding the naming:
> > > 
> > > * If we keep Jiangshan's logic, I don't like the glevel name very much, any
> > > of mapping_level, target_level or direct_level would be clearer?
> > 
> > I don't love any of these names, especially glevel, because the field doesn't
> > strictly track the guest/mapping/target/direct level.  That could obviously be
> > remedied by making it valid at all times, but then the role would truly need 3
> > bits (on top of direct) to track 5-level guest paging.
> 
> Yes, it would need 3 bits but direct can be removed.
> 
> > > * If we go with yours, I would call the field "passthrough_levels".
> > 
> > Hmm, it's not a raw level though.
> 
> Hence the plural. :)

LOL, I honestly thought that was a typo.  Making it plural sounds like it's passing
through to multiple levels.
