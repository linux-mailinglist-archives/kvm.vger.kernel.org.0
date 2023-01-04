Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1513265CB50
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 02:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbjADBUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 20:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjADBUE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 20:20:04 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76412CD
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 17:20:03 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id b2so34453405pld.7
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 17:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T8llHjR/KQu58vDYm+H0ZW1/5cWe3F1SVFXfrX2ssKw=;
        b=e5RJU+JW14exSHanVzjQr6x1Q+wSY3Wpe9awigVhR1BiYRBZEU9W0BVIrrX/aVyqG0
         Y/5VaDKcsJZxckZn14g0rfSItOQ57y+4JIgyHsrSIub1MAG53kt04U50STocLDM0J7sn
         QFyP6xW1wHF5U+zbhc8NRF0wlvmOcUt6AKBIOn5+vjZZZ0Gqv4gEs7xV6409M+6SBAkS
         YH3xIGZJmi4QK9Nx65lrMlRqda04kU/WbxF+7CinjYZ/g0xNbdP9PIeHWKf0weW9lxHw
         BCKjtNvdDy++5YY1Tow6B0lJCcED661MzsT241XV/k+5MBFqdEuck7s9HoxesDmlB24c
         0ugQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T8llHjR/KQu58vDYm+H0ZW1/5cWe3F1SVFXfrX2ssKw=;
        b=FQpoph6fFR5jC/heU0faDYbYdn3Zkdj5prECL3vlczQoId8OxHPQ7OfC1YH83WjqiG
         XaweYhmqN9Ge0lQnTpzNfJGd1TShMPIMIOEEWFIlROyFdCjDtCS6l5vvlGona96NKRAx
         ADM34dx2EPyQCGL9IuBOY57PzLKQpmk1tZ6gwANNG3TeIUsdAQl/gr9bGHW4Th1+XPcs
         ip2+WpRNRjIVs/8RlJ3h8JLbeTSH9iErf9D+rPC9JtR5lVFnDrZGzRk1vS8z7MatXHbL
         oXS+Tw91m6Iljscu6zE8Lej5ldr8rPesPgd9XK/4PSXNbDoqXechVO4HH/yJeN29nu7V
         iU0A==
X-Gm-Message-State: AFqh2krVl8NemG86hdP03eVu70WSqt2SGQ6gL30vaOCw8aOPSGHra4lr
        cGNyTKulWDSgdMx14YzQgaD/ig==
X-Google-Smtp-Source: AMrXdXvUtv379swOd0R3oaMvDQyW13GYD5V9BwZP8VPERQc+bDajwVIrshsYMc6ZAUnSJPJDlWn+rA==
X-Received: by 2002:a17:902:dad0:b0:191:1543:6b2f with SMTP id q16-20020a170902dad000b0019115436b2fmr4061929plx.3.1672795203106;
        Tue, 03 Jan 2023 17:20:03 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p4-20020a170902e74400b00178b9c997e5sm22960993plf.138.2023.01.03.17.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 17:20:02 -0800 (PST)
Date:   Wed, 4 Jan 2023 01:19:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Hao Peng <flyingpenghao@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: use unified srcu interface function
Message-ID: <Y7TUPw5i5BejllCB@google.com>
References: <CAPm50aJTh7optC=gBXfj+1HKVu+9U0165mYH0sjj3Jqgf8Aivg@mail.gmail.com>
 <Y5KNvgzakT1Vvxy4@google.com>
 <CAPm50aJv2_6321BgLXB6SWH1CcoYM4733fsovtB_5zhoP_7x+Q@mail.gmail.com>
 <365fe273-ba11-eb12-4d80-a2e6a17bf0fa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <365fe273-ba11-eb12-4d80-a2e6a17bf0fa@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 23, 2022, Paolo Bonzini wrote:
> On 12/20/22 08:47, Hao Peng wrote:
> > > > +       old = srcu_dereference_check(kvm->irq_routing, &kvm->irq_srcu,
> > > > +                                       lockdep_is_held(&kvm->irq_lock));
> > > Readers of irq_routing are protected via kvm->irq_srcu, but this writer is never
> > > called with kvm->irq_srcu held.  I do like the of replacing '1' with
> > > lockdep_is_held(&kvm->irq_lock) to document the protection, so what about just
> > > doing that?  I.e.
> > > 
> > Sorry for the long delay in replying. Although kvm->irq_srcu is not required
> > to protect irq_routing here, this interface function srcu_dereference_check
> > indicates that irq_routing is protected by kvm->irq_srcu in the kvm subsystem.
> > Thanks.
> > 
> 
> I agree, the last two arguments basically are alternative conditions to
> satisfy the check:
> 
> #define srcu_dereference_check(p, ssp, c) \
>         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
>                                 (c) || srcu_read_lock_held(ssp), __rcu)
> 
> The idea is to share the code between readers and writers,

But readers and writers naturally don't share code, and the subsequent
synchronize_srcu_expedited() is what really documents the interaction between
readers and writers.

It's definitely not a sticking point though, and this one does seems to be the
outlier in KVM.

> so what do you think of adding a
> 
> #define kvm_get_irq_routing(kvm) srcu_dereference_check(...)
> 
> macro at the top of virt/kvm/irqchip.c?

I'm fine with any approach, though a macro seems like overkill.
