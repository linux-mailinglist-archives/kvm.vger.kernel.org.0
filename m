Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B521764D462
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 01:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiLOANG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 19:13:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiLOAMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 19:12:40 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380AE1F7
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 16:07:35 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id t11-20020a17090a024b00b0021932afece4so982225pje.5
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 16:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pb7wtSqhUsiJT/a3zI1ZgZACkdos/PvCEsALhRD7glg=;
        b=VyavELua2UDV3DPpBxjdACYbQwNXQ8Lxh+v3Hj6Ai5T2t5CuSG4gQuO6uWROoJEjrz
         NBGKBft0oQd2RRRYIXhW1MwXcMzNeM0dp8jdXcQVnUNM9Zy2JHowtwr6ldX7bHn/51RK
         pWljkGzG/fvXdaTamPYwYkBCQq4pEg55YuKTJl+/gwZ9KCFnxATa2LbUrBLA/9i6MBae
         b89gtSW11RucluZ1JrydtOHEwM4z19AFgoGssZZJjeAHunU2rTWdFL0ZCQJFFjwPzN0Y
         1urhUBTa5Hb8TCS96d80hUH3Y6nKUEEthKW6y4Y5awhc/rTgXSWn/yKT7rjI7woRqjoa
         Ywlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pb7wtSqhUsiJT/a3zI1ZgZACkdos/PvCEsALhRD7glg=;
        b=I5xkB2jjuPFyOYkR27Ulmoh3E7sRxqgs/CP09EcE+HA6VQKuJlqekMqPo9zeat7F6z
         dvsjz6SxLQBHE8Mo0XVNNKHKdxhXFKhchWG/52HeMtN0HUzMBRznOI+sp1Y871r2AarN
         1fnxSA19jMjBH5QSaeD4CHdGk9/igvW7JOUBJ0SxAkddXuqVXJ00vgLrLRmjiecv/fWo
         CYKH1OUbCsrsLNUdLHX88qjPFNdwJLL/xnYaFb9aiTmNa+3+IG8sqmqmS5ThTN39Zzac
         UVgFBwHVg5ck1yHDw1cPv6sBjF40wFZdW+UxQ8Y3TuKmylYo2t6nyz/f0Wc2389rhUJU
         1BnA==
X-Gm-Message-State: AFqh2kqzxEkoNppNNr7D/z/JNZ/hq9WZoH+m4emnUCsLnWI5i0QkaM9y
        BfKrk7R58FOUa9yYsbMa7e7gRLpz7jinSFfR
X-Google-Smtp-Source: AMrXdXuIQEdEYOgal0R9/Gn0JAKyLdzxq8GPDcYcsz4/G3cMzW+yblEXxhSkk3kJOPm4PNaIJ3KryQ==
X-Received: by 2002:a17:902:a587:b0:189:6d32:afeb with SMTP id az7-20020a170902a58700b001896d32afebmr792045plb.1.1671062854573;
        Wed, 14 Dec 2022 16:07:34 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ik13-20020a170902ab0d00b0017d97d13b18sm2433491plb.65.2022.12.14.16.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 16:07:33 -0800 (PST)
Date:   Thu, 15 Dec 2022 00:07:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        oliver.upton@linux.dev, catalin.marinas@arm.com, will@kernel.org,
        paul@xen.org
Subject: Re: [PATCH v2] KVM: MMU: Make the definition of 'INVALID_GPA' common.
Message-ID: <Y5plQVtUEWZfXShw@google.com>
References: <20221213090405.762350-1-yu.c.zhang@linux.intel.com>
 <96faca1a685e0d6e7a77cbc9dadc8ae5c6c9a27c.camel@infradead.org>
 <20221214154714.3qj4wt3u36zwp67q@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214154714.3qj4wt3u36zwp67q@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022, Yu Zhang wrote:
> On Wed, Dec 14, 2022 at 11:10:54AM +0000, David Woodhouse wrote:
> > On Tue, 2022-12-13 at 17:04 +0800, Yu Zhang wrote:
> > > --- a/arch/x86/kvm/xen.c
> > > +++ b/arch/x86/kvm/xen.c
> > > @@ -41,7 +41,7 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
> > >         int ret = 0;
> > >         int idx = srcu_read_lock(&kvm->srcu);
> > >  
> > > -       if (gfn == GPA_INVALID) {
> > > +       if (gfn == INVALID_GPA) {
> > >                 kvm_gpc_deactivate(gpc);
> > >                 goto out;
> > >         }
> > > @@ -659,7 +659,7 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
> > >                 if (kvm->arch.xen.shinfo_cache.active)
> > >                         data->u.shared_info.gfn = gpa_to_gfn(kvm->arch.xen.shinfo_cache.gpa);
> > >                 else
> > > -                       data->u.shared_info.gfn = GPA_INVALID;
> > > +                       data->u.shared_info.gfn = INVALID_GPA;
> > >                 r = 0;
> > >                 break;
> > 
> > Strictly, those are INVALID_GFN not INVALID_GPA but I have so far
> > managed to pretend not to notice...
> > 
> > If we're bikeshedding the naming then I might have suggested
> > INVALID_PAGE but that already exists as an hpa_t type.
> 
> Thanks, David. INVALID_GFN sounds more reasonable for me.
> 
> But I am not sure if adding INVALID_GFN is necessary. Because for now
> only kvm_xen_shared_info_init() and kvm_xen_hvm_get_attr() use INVALID_GPA
> as a GFN. 
> 
> Any suggestion? Thanks!

It's not strictly necessary, but it's an easy change and I can't think of any
reason not to add INVALID_GFN.
