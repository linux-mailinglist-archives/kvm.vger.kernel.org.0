Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910084BFE31
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 17:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbiBVQMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 11:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbiBVQMu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 11:12:50 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DE5164D0D
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 08:12:25 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id p23so17435032pgj.2
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 08:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m+2kSLFbYN2+70tyjIr4MyhGsB3G0IRe/QtcucZWlVE=;
        b=sJgeq1Q2JoP477UlO6zNHt2pFibeRZpiOYTHhHcBn/Bgw8FAYAtdbHo6gM7FpViTju
         pRbIjSByD2jRYieWNHNG1HBndeJYqVKZUDyVmrmlng47BHvmMOvdts6qMRaiLIxLCUaP
         myKn86p5UX4YRYB5WDanbBmVEcjT6XGPhsoqGqxLxsNEuIvqEof24FnvVNuYMQXeUVnB
         THhVQ72EyCiZRsPK4+QourY9HG3n5rsDK8aQ0qdGQuxVDxXzjhkee3dkehuTzx/y+FPt
         fqhDzhfFgM4cNGDhzpmBDdX8AS37ok7tqnco2zxUkNFPdSracUr73FFqKvz3Gp5q26z7
         Uwug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m+2kSLFbYN2+70tyjIr4MyhGsB3G0IRe/QtcucZWlVE=;
        b=j2bZDa9yhZmet+GjuF6a0EAof/eH+EiYFVcgr613DaYQsjzOgJOGR2W6fkX7axklNd
         g7pIfrivmsOeChcnJkMLXAcTIKl4Zmq84JHZ8e2uKWQs8XdgpFti5A2dzA+/QQRPWYY+
         nXj6cqD4IcnERsxCKMsebyn//SMT2sh90BpRQGZs+/r4srW94NnwNdFV5NfVrnciVKV/
         TYLUTz3dncmBxNxd4NA3b72PkzIjxUNn1cxQEiUnHCFfe3UPEwaGVscnOrItKthtyIJb
         mYa5ZWllxnc+KRmVzTIieMWTwc9Eb1GsKUcrQp/3ExvVE/2ISA2vve0tU6tcpFaAsGvG
         1MPg==
X-Gm-Message-State: AOAM532iBZFX7Cs/NXnb1xV4527SSYzJ1mJ3Qror1ngYXXNQz9uHZzIy
        RuqAdJOAaXtCNDoAxzacnqml+g==
X-Google-Smtp-Source: ABdhPJwbLccPnpk5Bmg+NMt5LyFVwsBpprikLRmYFUYyhAgTF7sdWkezNMD4mNCr1L+919MyCvI4jw==
X-Received: by 2002:a65:680a:0:b0:34d:efd6:7a5f with SMTP id l10-20020a65680a000000b0034defd67a5fmr19950831pgt.213.1645546344720;
        Tue, 22 Feb 2022 08:12:24 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v13sm18381780pfu.196.2022.02.22.08.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 08:12:24 -0800 (PST)
Date:   Tue, 22 Feb 2022 16:12:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH] selftests: KVM: add sev_migrate_tests on machines
 without SEV-ES
Message-ID: <YhULZDZPQVsDHLPf@google.com>
References: <20220218100910.35767-1-pbonzini@redhat.com>
 <CAMkAt6rS-YrrSoYSU_9AukoTfrAy5awNFw3dkbCrFNoq0b3fWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMkAt6rS-YrrSoYSU_9AukoTfrAy5awNFw3dkbCrFNoq0b3fWw@mail.gmail.com>
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

On Fri, Feb 18, 2022, Peter Gonda wrote:
> On Fri, Feb 18, 2022 at 3:09 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > +#define X86_FEATURE_SEV (1 << 1)
> > +#define X86_FEATURE_SEV_ES (1 << 3)
> 
> These conflict with these names but have different values:
> https://elixir.bootlin.com/linux/latest/source/arch/x86/include/asm/cpufeatures.h#L402.
> Is that normal in selftests or should we go with another name?

It's normal.  The kernel uses semi-arbitrary values that don't map directly to
CPUID.  I like Paolo's suggestion of pulling in KVM-Unit-Tests' approach for
dealing with CPUID features[*]; if/when that happens these definitions will become
less ad hoc.

[*] https://lore.kernel.org/all/16823e91-5caf-f52e-e0dc-28ebb9a87b47@redhat.com
