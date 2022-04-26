Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536F2510586
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 19:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350613AbiDZRiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 13:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349185AbiDZRiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 13:38:04 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F4E98F68
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 10:34:56 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id t11-20020a17090ad50b00b001d95bf21996so2745225pju.2
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 10:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KJ3TjbUDUHMUD+3QeBvQ6msePCohu6uuyPtrB9gBXs8=;
        b=W26uTutrIfZF2LhWTa29eWHsVLf51t2fmiDS2g1zS+TBsc2k0U4hmORsULaMed6CVd
         jcLXqndhag2r8pnLYxEwbAE/sH0lcGRCXVN/G0FG5RkwXGxW0RHC3C8bYFfNxILu/5cC
         8/tXOoTghrZbJaOmGFxqnSqV207wE2XH1Q//eawUdwOUxDivhFwHJfKLJSs/mJSHOf27
         SQTDW2qHS23SfTNNumqhWf0UlfS2V8DWeGRl19TO9CCsVr+MS3je1g2ySQnEelj11iLn
         vjMC5ErQZuBqQzYOHKGc/yCyJNpecvjgaTze27NzqmTu/ON5xQprMO2eJAExKcEuDoxc
         V6Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KJ3TjbUDUHMUD+3QeBvQ6msePCohu6uuyPtrB9gBXs8=;
        b=4IzY2oCEtot5u/TabowLYsCqbF4XAnmRD7quHfnC+G29Nkcn6doTr5soGzXVUTPnXt
         Q0uXAwTg2kAjI3SREks9pXEld67vLZqBURhhlIPOEpTa+nkB3xAMMkOigEceHxK4Lmc4
         zMimEybDkPtlLvdOBKJOuIkuGNpc/P472+eV1COmiBsJdW+J0mj7AJBMFot3jk1wndeo
         jtfxIj3UjlX/Yi/A2/oqMmZ2+vPj/IUvFzhJ91mS+XEDkcCA/j5pLFZ/Ch2NPAY12q6x
         /tu23iNjSOZZLKAaveewsv/wuHkV9iR9+IscpGnJQGj2joj08zjyvJlgIZWrA1ReB8QC
         c3ug==
X-Gm-Message-State: AOAM533Z+x1RK5l6G/dwd+lEk6MXIow27XLz6webB7VUCYdSLf8crVPp
        3SsvSl5hAa8XeAxcP3+8UNdtL3jwlcQ61A==
X-Google-Smtp-Source: ABdhPJxDNI+3hUU4V5iyn9ZWBG9CrUlQxYDJewKZCQMYGMwWub8Dx0tFnclyQWkwDIPvr7VYJrldSg==
X-Received: by 2002:a17:90a:ab81:b0:1ca:8a76:cdda with SMTP id n1-20020a17090aab8100b001ca8a76cddamr38600800pjq.26.1650994495763;
        Tue, 26 Apr 2022 10:34:55 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n20-20020a634d54000000b0039d18bf7864sm13411283pgl.20.2022.04.26.10.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 10:34:55 -0700 (PDT)
Date:   Tue, 26 Apr 2022 17:34:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: kvm_gfn_to_pfn_cache_refresh started getting a warning recently
Message-ID: <YmgtPGur0Uwk5Yg6@google.com>
References: <e415e20f899407fb24dfb8ecbc1940c5cb14a302.camel@redhat.com>
 <YmghjwgcSZzuH7Rb@google.com>
 <cc0c62dd-9c95-f3b9-b736-226b8c864cd4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc0c62dd-9c95-f3b9-b736-226b8c864cd4@redhat.com>
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

On Tue, Apr 26, 2022, Paolo Bonzini wrote:
> On 4/26/22 18:45, Sean Christopherson wrote:
> > On Tue, Apr 26, 2022, Maxim Levitsky wrote:
> > > [  390.511995] BUG: sleeping function called from invalid context at include/linux/highmem-internal.h:161
> > > [  390.513681] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 4439, name: CPU 0/KVM
> > 
> > This is my fault.  memremap() can sleep as well.  I'll work on a fix.
> 
> Indeed, "KVM: Fix race between mmu_notifier invalidation and pfncache
> refresh" hadn't gone through a full test cycle yet.

And I didn't run with PROVE_LOCKING :-(

I'm pretty sure there's an existing memory leak too.  If a refresh occurs, but
the pfn ends up being the same, KVM will keep references to both the "old" and the
"new", but only release one when the cache is destroyed.

The refcounting bug begs the question of why KVM even keeps a reference.  This code
really should look exactly like the page fault path, i.e. should drop the reference
to the pfn once the pfn has been installed into the cache and obtained protection
via the mmu_notifier.
