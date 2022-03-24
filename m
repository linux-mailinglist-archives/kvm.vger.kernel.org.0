Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8C14E6A3D
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 22:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355361AbiCXVdY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 17:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354202AbiCXVcw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 17:32:52 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CA5ADD6D
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 14:31:19 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id b13so3073450pfv.0
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 14:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PkVWjMpiO98nzKDVQQrcUIwfsuWOhTX7zsEIwTfXQz8=;
        b=A0A6FAu85y4IM7Zo4rk6dxWiWIM9dUf4Os4IUjZ3SSIulTjV98iyKNbN2AIj2gb7TV
         sQ+xrKPhSeg4c+s324IsR/3LnTh3Sb5Tjkqv7rDerWbWZsSDobupIxEHcyEeR656C1/P
         rjnshrunYyXzx8NkmBRRrv3jJ3WMFa00cAUj/3Xe/w90ZLDpZpWEuzYRaV+t+VV7mgNJ
         i5u/qGMQYovyhH3M1cX7iF9+38RmLqtjl0CRmTu8EX1UfUM1qWaLdjJbyqE0MchcrACz
         FFNnprPyCdHUsslti/xCAEBD0GXl+XDLp9eYu9PtPJV2C3OZCDrIfzDZN6lcjdKeqM2N
         crRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PkVWjMpiO98nzKDVQQrcUIwfsuWOhTX7zsEIwTfXQz8=;
        b=3ZmYoi25EaafpyYJiUOugv2mZhkkGwcBQi9TXWXiMpd3wrXjFQ2nWrcBK5b9Nq4xQm
         yKVgxbYQBbgpKHQXHmO/smZOkyZPr17kABejj2OpB9XQwCHYatdUOw84+m2dAAAogn1t
         +82b2IVAZWeQTCeuljpv1WiHb1R4xlmGJQImbgWLlkOM0MLAABlptv9zvvsECprFjKS7
         FVgagd1EG+bMYM215QUxybwoJJa80q3rTrMTBUQPodlx/+z1zT9AFYEaipfznM6f9Pci
         sfKY7y0jcUT9dF7zrZ1SDQ5OfF+zy7YVMm4wf3vuajd7cjhqoeke1LZmww+fc98zrlx0
         g6Dg==
X-Gm-Message-State: AOAM530LYJuHvhyyHSCluPXArLslfD3bJ2NzsApyXdHZepN3BumaijPo
        Rf3ucrujDydx08mC9aJq8GUn8g==
X-Google-Smtp-Source: ABdhPJyNXAQ+2L6fResIakOaE6XHoiEy3QRCUcnDi5KbkAdZjQv98JflphIymS2xgPFzyRyM8nz54Q==
X-Received: by 2002:a62:fb0f:0:b0:4f2:6d3f:5ffb with SMTP id x15-20020a62fb0f000000b004f26d3f5ffbmr6683025pfm.55.1648157479119;
        Thu, 24 Mar 2022 14:31:19 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q18-20020aa78432000000b004fb0a5aa2c7sm342172pfn.183.2022.03.24.14.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 14:31:18 -0700 (PDT)
Date:   Thu, 24 Mar 2022 21:31:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 00/21] KVM: x86: Event/exception fixes and cleanups
Message-ID: <YjzjIhyw6aqsSI7Q@google.com>
References: <20220311032801.3467418-1-seanjc@google.com>
 <08548cb00c4b20426e5ee9ae2432744d6fa44fe8.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08548cb00c4b20426e5ee9ae2432744d6fa44fe8.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 13, 2022, Maxim Levitsky wrote:
> On Fri, 2022-03-11 at 03:27 +0000, Sean Christopherson wrote:
> > The main goal of this series is to fix KVM's longstanding bug of not
> > honoring L1's exception intercepts wants when handling an exception that
> > occurs during delivery of a different exception.  E.g. if L0 and L1 are
> > using shadow paging, and L2 hits a #PF, and then hits another #PF while
> > vectoring the first #PF due to _L1_ not having a shadow page for the IDT,
> > KVM needs to check L1's intercepts before morphing the #PF => #PF => #DF
> > so that the #PF is routed to L1, not injected into L2 as a #DF.
> > 
> > nVMX has hacked around the bug for years by overriding the #PF injector
> > for shadow paging to go straight to VM-Exit, and nSVM has started doing
> > the same.  The hacks mostly work, but they're incomplete, confusing, and
> > lead to other hacky code, e.g. bailing from the emulator because #PF
> > injection forced a VM-Exit and suddenly KVM is back in L1.
> > 
> > Everything leading up to that are related fixes and cleanups I encountered
> > along the way; some through code inspection, some through tests (I truly
> > thought this series was finished 10 commits and 3 days ago...).
> > 
> > Nothing in here is all that urgent; all bugs tagged for stable have been
> > around for multiple releases (years in most cases).
> > 
> I am just curious. Are you aware that I worked on this few months ago?

Ah, so that's why I had a feeling of deja vu when factoring out kvm_queued_exception.
I completely forgot about it :-/  In my defense, that was nearly a year ago[1][2], though
I suppose one could argue 11 == "a few" :-)

[1] https://lore.kernel.org/all/20210225154135.405125-1-mlevitsk@redhat.com
[2] https://lore.kernel.org/all/20210401143817.1030695-3-mlevitsk@redhat.com

> I am sure that you even reviewed some of my code back then.

Yep, now that I've found the threads I remember discussing the mechanics.

> If so, could you have had at least mentioned this and/or pinged me to continue
> working on this instead of re-implementing it?

I'm invoking Hanlon's razor[*]; I certainly didn't intended to stomp over your
work, I simply forgot.

As for the technical aspects, looking back at your series, I strongly considered
taking the same approach of splitting pending vs. injected (again, without any
recollection of your work).  I ultimately opted to go with the "immediated morph
to pending VM-Exit" approach as it allows KVM to do the right thing in almost every
case without requiring new ABI, and even if KVM screws up, e.g. queues multiple
pending exceptions.  It also neatly handles one-off things like async #PF in L2.

However, I hadn't considered your approach, which addresses the ABI conundrum by
processing pending=>injected immediately after handling the VM-Exit.  I can't think
of any reason that wouldn't work, but I really don't like splitting the event
priority logic, nor do I like having two event injection sites (getting rid of the
extra calls to kvm_check_nested_events() is still on my wish list).  If we could go
back in time, I would likely vote for properly tracking injected vs. pending, but
since we're mostly stuck with KVM's ABI, I prefer the "immediately morph to pending
VM-Exit" hack over the "immediately morph to 'injected' exception" hack.

[*] https://en.wikipedia.org/wiki/Hanlon%27s_razor
