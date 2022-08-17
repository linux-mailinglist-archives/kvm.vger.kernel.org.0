Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476CE597465
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 18:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240414AbiHQQnV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 12:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240396AbiHQQnS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 12:43:18 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AE9AE40
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:43:17 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id z20so14102629ljq.3
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=EHqiuIZ/DBtCoMP1++gj+/DJFZ917jiHTgTs1fdmlYU=;
        b=pG0kc7ej3O72qQ5Dt/KKa6sFhPID5jjN2CTiKR4fNL/2UOJKYToTjQOajKCXXJgcIu
         rqUewTVWU1y5FKz/d4/ApwS3T6OI3gHY0virJDPlXZqned3iTBqlYGaGL2QZCE9QIJos
         zRxuv3YQgEKJFj2oT41LAIXSQ79omXh08PR0HWRCG6G9Y930XDgUzyAphsXI6pWRbeUn
         FTLXIQoaGOdQ6vVe5pxnhmpnc27ba+y54EhfDyaT4K2v8oZg35A7WInT46kVdwweHUrl
         YJFa7125uk3Kmhmq2kGd4RPnjmtEJmn+3Io18k9fx+8bFy9bHuLBlypeUWSwq7x7hdci
         DeiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=EHqiuIZ/DBtCoMP1++gj+/DJFZ917jiHTgTs1fdmlYU=;
        b=Qx5bz/UGEuZ41khYBWJJKRkVZJ4NO2ZXWYfV2+n844EYtvioUOXM+E64zIG1HP7vhi
         +wzJAEdKe9c9Uo8zmIkNsRzCYV1F3jHabRuEwK9Psju+Fqw8Z0ic/EyWI6S4gWm1qDcX
         syJXF/7u1JyyXOqhMQYrpi8fhC8urjB3hc/X9w9wUayoWBUF0r9ZPxzBnYPeCi17ec5B
         KSpf1N9aOy554eAc2KZXWjVZkBqpKEfIzi+mW+wQYtNoaX5qT45fe2GgceMkBL3yGozv
         lQTMCOjO+AII0S7m9WUWAdRWPxNdCb8d7vssneBBec0VQ3yv9uL2KQWUgGTiEyKFu0qH
         nkKQ==
X-Gm-Message-State: ACgBeo1mM9WGlHwAswA2SccUuynX+Hfn6M0JYaR73zzsqPQU0ZkNoeWK
        OqwCqdHgUxXYfcsk+LyzBrcPZ5VQv39gMYlXiZvcsA==
X-Google-Smtp-Source: AA6agR6eybaCQEIXujf6zJDi5GyKNXn7sCMwEyYomKIksucBYtloszBnhNmjEitpkuE9ctzFb/OyvXKKqJiBCR/5YzI=
X-Received: by 2002:a2e:a884:0:b0:25d:ea06:6a3f with SMTP id
 m4-20020a2ea884000000b0025dea066a3fmr7732131ljq.335.1660754595328; Wed, 17
 Aug 2022 09:43:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220815230110.2266741-1-dmatlack@google.com> <YvtSc9ofTg1z8tt7@worktop.programming.kicks-ass.net>
 <CALzav=eWhg=ZMxVcGf9w_svn1XaTZABN5VoFP3fgxPiHohaMFQ@mail.gmail.com> <97103b92b9dc1723b1cbfe67ce529a0f065a76ed.camel@intel.com>
In-Reply-To: <97103b92b9dc1723b1cbfe67ce529a0f065a76ed.camel@intel.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 17 Aug 2022 09:42:49 -0700
Message-ID: <CALzav=ceSoMWooLu=riCn9WtKes7Jt3L0BaMb9uyA_D4=dvZEw@mail.gmail.com>
Subject: Re: [PATCH 0/9] KVM: x86/mmu: Always enable the TDP MMU when TDP is enabled
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "peterz@infradead.org" <peterz@infradead.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "bp@suse.de" <bp@suse.de>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Aug 17, 2022 at 3:01 AM Huang, Kai <kai.huang@intel.com> wrote:
>
> On Tue, 2022-08-16 at 09:30 -0700, David Matlack wrote:
> > On Tue, Aug 16, 2022 at 1:17 AM Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > > On Mon, Aug 15, 2022 at 04:01:01PM -0700, David Matlack wrote:
> > > > Patch 1 deletes the module parameter tdp_mmu and forces KVM to always
> > > > use the TDP MMU when TDP hardware support is enabled.  The rest of the
> > > > patches are related cleanups that follow (although the kvm_faultin_pfn()
> > > > cleanups at the end are only tangentially related at best).
> > > >
> > > > The TDP MMU was introduced in 5.10 and has been enabled by default since
> > > > 5.15. At this point there are no known functionality gaps between the
> > > > TDP MMU and the shadow MMU, and the TDP MMU uses less memory and scales
> > > > better with the number of vCPUs. In other words, there is no good reason
> > > > to disable the TDP MMU.
> > >
> > > Then how are you going to test the shadow mmu code -- which I assume is
> > > still relevant for the platforms that don't have this hardware support
> > > you speak of?
> >
> > TDP hardware support can still be disabled with module parameters
> > (kvm_intel.ept=N and kvm_amd.npt=N).
> >
> > The tdp_mmu module parameter only controls whether KVM uses the TDP
> > MMU or shadow MMU *when TDP hardware is enabled*.
>
> With the tdp_mmu module parameter, when we develop some code, we can at least
> easily test legacy MMU code (that it is still working) when *TDP hardware is
> enabled* by turning the parameter off.

I am proposing that KVM stops supporting this use-case, so testing it
would no longer be necessary. However, based on Paolo's reply there
might be a snag with 32-bit systems.

> Or when there's some problem with TDP
> MMU code, we can easily switch to use legacy MMU.

Who is "we" in this context? For cloud providers, switching a customer
VM from the TDP MMU back to the shadow MMU to fix an issue is not
feasible. The shadow MMU uses more memory and has worse performance
for larger VMs, i.e. switching comes with significant downsides that
are unlikely to be lower risk than simply rolling out a fix for the
TDP MMU.

Also, over time, the TDP MMU will be less and less likely to have bugs
than the shadow MMU for TDP-enabled use-cases. e.g. The TDP MMU has
been default enabled since 5.15, so it has likely received
significantly more test cycles than the shadow MMU in the past 5
releases.


>
> Do we want to lose those flexibilities?

>
> --
> Thanks,
> -Kai
>
>
