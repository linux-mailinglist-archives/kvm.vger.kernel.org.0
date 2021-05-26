Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2140391B31
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 17:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235313AbhEZPJY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 11:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235299AbhEZPJX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 11:09:23 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D42C061574
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 08:07:51 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id f22so1180602pgb.9
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 08:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3KxbR9KLUJdHdi9WoVn2ioU2lLX3Osv4SjBPrJHHLpw=;
        b=i+FbhOYkmMxye7Hn3e2GqSSNrgdpxVk4Q1ICZ8+ls6kll9sYBZqHU2wSJABJgqxxxZ
         Gelb8ApsDLde1sShXE4f7n50JtuoKdygm7+WacKgSUvw8Hf19OvMe0NYb36Z3nL2qyDo
         z4RhorDEDA3i4siSVbhkJD4+hbOc5TzTxxVPuM99ovfztliDdhdtTjbX6O2Zb/W2k1T8
         Ns+W8okQO83L9gKu/FLjCWAzZ4yK7vXqJGmlBPqfk9t2zCZsQMDGs25ZFZsAXtF+Fww1
         8N3Ig//0cPanArfSunh6drKWX27WXm+EEXmop7dNcKJ8jXIAXjBtVtCxpUWCbzhyP8gC
         FNqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3KxbR9KLUJdHdi9WoVn2ioU2lLX3Osv4SjBPrJHHLpw=;
        b=pvgNDZOAwnd/+pz4ZSvDriUyTw6XtctGrLV14bJDTOPfJ7kADvBExMsC3CwFJWOkRu
         Bq41XGsv0yhnOqvxKT+JEqRq7+LKBv6tY+NXigunYYxhV8ljDCFVYY+x8wx3Dlygc3dg
         ETVpXe7f/5TvHLlt7YeQEPU51Xy1QmCsSyA9Xyql7E5+3oL2/3BSaTHRKU+CIdg3mj9F
         r6r2hhvxg4XR7/WXGdrdm8F/haA0PuDEnsqEfdy/4eXZh+45fN3xr4HnYKA+dv/o4FuS
         41+JwHVzM7HNm5Y5hfOqxtovZQEsuOlLjE9koc69lYIL3EFBvD9e2GCUK2WiLfuKJK77
         QP/w==
X-Gm-Message-State: AOAM533NQi0QV8WBGUXprCaqcBj2NVuo8SyDIiaiLsVKTzKsxQvpPXBn
        orFXS4N8ND0+g9a3CnSPcCOfIQ==
X-Google-Smtp-Source: ABdhPJyI+pZSHLvbcC6gufmgjNVBW8KFR/GsXg9zH0gPYi3YANjsdqgZd4pCNM1KpUswyMhcj/NCvg==
X-Received: by 2002:a05:6a00:26eb:b029:2db:6b23:18e9 with SMTP id p43-20020a056a0026ebb02902db6b2318e9mr35748283pfw.56.1622041670474;
        Wed, 26 May 2021 08:07:50 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id 11sm15791297pfh.182.2021.05.26.08.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 08:07:49 -0700 (PDT)
Date:   Wed, 26 May 2021 15:07:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Kechen Lu <kechenl@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] KVM: x86: Use common 'enable_apicv' variable for
 both APICv and AVIC
Message-ID: <YK5kQcTh8LmE0+8I@google.com>
References: <20210518144339.1987982-1-vkuznets@redhat.com>
 <20210518144339.1987982-4-vkuznets@redhat.com>
 <1b9a654596f755ee5ef42ce11136ed2bbb3995a0.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b9a654596f755ee5ef42ce11136ed2bbb3995a0.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021, Maxim Levitsky wrote:
> On Tue, 2021-05-18 at 16:43 +0200, Vitaly Kuznetsov wrote:
> > Unify VMX and SVM code by moving APICv/AVIC enablement tracking to common
> > 'enable_apicv' variable. Note: unlike APICv, AVIC is disabled by default.
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 9b6bca616929..23fdbba6b394 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -209,6 +209,9 @@ EXPORT_SYMBOL_GPL(host_efer);
> >  bool __read_mostly allow_smaller_maxphyaddr = 0;
> >  EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
> >  
> > +bool __read_mostly enable_apicv = true;
> 
> Nitpick: I don't like this asymmetry.
>
> VMX and the common code uses the enable_apicv module param and variable,
> while SVM uses avic, which sets the enable_apicv variable.
>  
> I'll prefer both VMX and SVM have their own private variable for their
> avic/apicv module param, which should set a common variable later.

I don't love the intermediate "avic" either, but there isn't a good alternative.
Forcing VMX to also use an intermediate doesn't make much sense, we'd be penalizing
ourselves in the form of unnecessary complexity just because AVIC needs to be
disabled by default for reasons KVM can't fix.

As for the asymmetry, I actually like it because it makes "avic" stand out and
highlights that there is weirdness with enabling AVIC.
