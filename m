Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF994E7B47
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 01:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbiCYXEP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 19:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234066AbiCYXEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 19:04:14 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CD651E7B
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 16:02:39 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n18so9713920plg.5
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 16:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RDTJ2bGKsyg8KfpwWQiMrlouH1KCGMV8rUa8lEFeJps=;
        b=aYOIVYtu80RxHpdFnwvgx3yyi0P7hN/OMzb9J5wSiiz5f7pX3vdtpLyEAxevtyKn//
         xeVFmsc4y9tOPUNRtNE5cCfdXy9Cot2H0/mUElJMCy32P4tQ1dts2wgsV8qcJg7h0QZ7
         qub9UEznnxnJJzO+tSatq2BvxNKTWUvofLatMBHCBpAtyB+jM6RzVDOLE7vfjLvmzHkb
         e1B8CInnGUTymswRzzVS+TUbSQH9e8ywFlz/UzPxzvlvcj7x0U7VB4em6qGIeltd/PI5
         6ExzVd2aHnbOTjM61USlbbi4c+rlOtN6ImElf9CxdR2m+eINJW5fh7Kkx7RUMM45UQUv
         NGRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RDTJ2bGKsyg8KfpwWQiMrlouH1KCGMV8rUa8lEFeJps=;
        b=3lKnZ5RoVVbrMCfVvPtmLe/FJ8nA62DWrB++Gp41a0X4I8aBPcyrtULZYPiJu9DURQ
         FTo5t6wSI20PkkjqIGy+75DyzY1sedgUMKNhjR+/uW3mfJdf6gnYkxaW7rpo7J80xofP
         hNfmjcgYDSaayVgM/XwaO9zrzxugnmv2Rv4di+kvqMp7E2DpttD29XehKNAHaDX5+OnV
         37Qku1hBb2ZTSJh3VCGkezVWgXAwHfGVd5CaRcTGjTVToKo3Jz1DpdT2gU/ik5NZbEfR
         j4By5gARk+x2sPnjpeAtdtV7gqbcSNvmeJEZTEJLa+cTYJCagqau5SRZmR97vnRnYoRr
         /IGg==
X-Gm-Message-State: AOAM530+IM6kANJtCm1r6DR80hM0eXCgRzJ4KTxWjs9bHUA0opI8jvFp
        Dxpj9GfDZhopuOggh098Fww6Rg==
X-Google-Smtp-Source: ABdhPJxmNHF3zDTC1ndQwKMHNRa2JwCcCjESyisIvqbKDWHfpEBodDTpGP7VSexHnij3Pa5djLC5yw==
X-Received: by 2002:a17:902:ce8b:b0:154:42e2:924e with SMTP id f11-20020a170902ce8b00b0015442e2924emr14096487plg.138.1648249358691;
        Fri, 25 Mar 2022 16:02:38 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o24-20020a17090a5b1800b001c6aaafa5fbsm7030187pji.24.2022.03.25.16.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 16:02:38 -0700 (PDT)
Date:   Fri, 25 Mar 2022 23:02:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 00/21] KVM: x86: Event/exception fixes and cleanups
Message-ID: <Yj5KCqtu7KZiGtgN@google.com>
References: <20220311032801.3467418-1-seanjc@google.com>
 <08548cb00c4b20426e5ee9ae2432744d6fa44fe8.camel@redhat.com>
 <YjzjIhyw6aqsSI7Q@google.com>
 <e64d9972-339c-c661-afbd-38f1f2ea476a@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e64d9972-339c-c661-afbd-38f1f2ea476a@maciej.szmigiero.name>
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

On Fri, Mar 25, 2022, Maciej S. Szmigiero wrote:
> So, what's the plan here: is your patch set Sean considered to supersede
> Maxim's earlier proposed changes or will you post an updated patch set
> incorporating at least some of them?

Next step is to reach a consensus on how we want to solve the problem (or if we
can't reach consensus, until Paolo uses his special powers).  I definitely won't
post anything new until there's more conversation.

> I am asking because I have a series that touches the same general area
> of KVM [1] and would preferably have it based on the final form of the
> event injection code to avoid unforeseen negative interactions between
> these changes.

I don't think you need to do anything, at a glance your changes are orthogonal
even though they have similar themes.  Any conflicts should be minor.
