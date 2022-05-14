Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A280526F57
	for <lists+kvm@lfdr.de>; Sat, 14 May 2022 09:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiENCwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 22:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiENCw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 22:52:26 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFAA1308844
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 17:56:03 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id b12so132869pju.3
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 17:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YYxVvNkXOVsJBJNW7IkLQOo2NBhIQpi5g9EjRSQk2JE=;
        b=OWYMsjKOYyifYrajLqOHfATFsj04q/ZkdSMEMcZCdk4QcYAfNu/YwT46b6noyZk6my
         oEq0ANS3mBxLf9IMrnOmQNzPVZUyZLH3QwXBEYsWmaP4Zf4rf7v/QJP6kGbk2y2uGPa6
         K+qprWkgQaasnfSCphUTng5U3bX5o+NoVVRWAJvnpuK6PMu9wRxf1jlARd/msP+8c69S
         StBxP4DB35ZWCsoVH15DOc1mk0P/5CPfD/qtct9xfbcH6e1kGoIEvIpJ6XDI8rRkKnFd
         BY3bhHmbJZ2NUSMah0uF8cqiDniC/nnbzoHXnomLCxFT7QSZHWOiUcQ1kuDAcr5m2Lfw
         uyrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YYxVvNkXOVsJBJNW7IkLQOo2NBhIQpi5g9EjRSQk2JE=;
        b=mSQzYxyPlfXhD+9DGxkHogXySL5IaDJOqJo61Sk+32zVZXGLh59e4PsGBIUdw3Q899
         bGbv0lNNfD7zWj9Z6WTSUi9fyMsAJe5/HLTEYcWl24wOgiu7rQLSEorBD2TRHhFJlznA
         9HWkZq27i699pkLtZatvSRgZ0gsLj1P0SGZTRyJCNVvRPX7ijI+KMzLwfuY5r3iytnlG
         868a5zWJfnZ8SI4jUNxcPELOxKBhLn2TtBXvHuE1eZvPULc9uxgeq/jqGv3ZIbOc2EIU
         323pARa9TitUbdRCzW8+8OIwGhKL/5TjrBB4w6qvfb073pAE8hf7/KLARkYoZPtvjn7U
         pYDg==
X-Gm-Message-State: AOAM532+ObPqUrJqp+jWTdR3vuzXkJnGmEU66X30p0KMx9Ke8hnkp7/H
        c+88fyu/nujt7HNckISLJa1vFA==
X-Google-Smtp-Source: ABdhPJzOOX3Ge/keGa+MRHcrzVM9fOR+XRs85V4bqiqf/c8ZmTZa30jgQmtVDlB3V2CsRcWpJ8oSeA==
X-Received: by 2002:a17:903:22cf:b0:15e:cf4e:79c9 with SMTP id y15-20020a17090322cf00b0015ecf4e79c9mr7334366plg.54.1652489763178;
        Fri, 13 May 2022 17:56:03 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id fv7-20020a17090b0e8700b001cd4989fecfsm4170476pjb.27.2022.05.13.17.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 17:56:01 -0700 (PDT)
Date:   Sat, 14 May 2022 00:55:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Drop RWX=0 SPTEs during ept_sync_page()
Message-ID: <Yn7+HrYbXhror09V@google.com>
References: <20220513195000.99371-1-seanjc@google.com>
 <20220513195000.99371-2-seanjc@google.com>
 <CALzav=d36gccJv345Phdr0AJx9=6=TP=iZ60dscgQr64Rq4Kew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=d36gccJv345Phdr0AJx9=6=TP=iZ60dscgQr64Rq4Kew@mail.gmail.com>
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

On Fri, May 13, 2022, David Matlack wrote:
> On Fri, May 13, 2022 at 12:50 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > Drop SPTEs whose new protections will yield a RWX=0 SPTE, i.e. a SPTE
> > that is marked shadow-present but is not-present in the page tables.  If
> > EPT with execute-only support is in use by L1, KVM can create a RWX=0
> > SPTE can be created for an EPTE if the upper level combined permissions
> > are R (or RW) and the leaf EPTE is changed from R (or RW) to X.
> 
> For some reason I found this sentence hard to read.

Heh, probably because "KVM can create a RWX=0 SPTE can be created" is nonsensical.
I botched a late edit to the changelog...

> What about this:
> 
>   When shadowing EPT and NX HugePages is enabled, if the guest changes

This doesn' thave anything to do with NX HugePages, it's an execute-only specific
bug where L1 can create a gPTE that is !READABLE but is considered PRESENT because
it is EXECUTABLE.  If the upper level protections are R or RW, the resulting
protections for the entire translation are RWX=0.  All of sync_page()'s existing
checks filter out only !PRESENT gPTE, because without execute-only, all upper
levels are guaranteed to be at least READABLE.
