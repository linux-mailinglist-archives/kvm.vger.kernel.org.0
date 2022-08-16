Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9DB59604F
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 18:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236485AbiHPQbn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 12:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234814AbiHPQb3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 12:31:29 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9ED80346
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 09:31:22 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id z25so15636125lfr.2
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 09:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=AvurrjGiyBXdmuXFEoA6ZmZLBaJjQpagNVgad8BC6+w=;
        b=gDl2zZjjpVKemNuAX57UGH/QV1jo14vuzXUTrZzxDkjLO7Y09jp81EIoX7mp7hXH7c
         UpZK75HqgLC5WHW5nIOkmUh6OO9M1j6hx6jVZ4RnXQMO/cjfjp/nsnM+ojPIWzvt4GnY
         ioFjkDUzebFRw/mAf31xTgTllC9iKYiDSVEOVLEUFWjPSbZZVBonnYD/2vhkuKtbbKGU
         y7BGakCvX7XnW1wBNilHjCzU0y3PkwUACCWwp0nnODvYaY1fFP11jD8lEI4C8WW1u9zk
         dXdciQM8T7nM+DeCDpyxzuNTDPfEhvGIjGzB6HwLGMelwepWUbH0QPX5KRBWKC94+k/4
         iWRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=AvurrjGiyBXdmuXFEoA6ZmZLBaJjQpagNVgad8BC6+w=;
        b=5ujhCVolAXUInl6KItnmgeK0KHxhsUJ/jN12guCHqoUnbDaDWTw4Oesg/hbBhRaReW
         Ffxc26ytchj3n7OPQxzKrFy5ZkqjVwWxzUUsWjfjRauTuUKHpJMNcD+4tpLNKN8K9uW7
         PpM0vTP5l7c12ma6miIhGKhZ8NVjyAEP9jUugZ2+RFAlEltzOjmp+sDiTXKw71+dl63c
         9SKftS0y52Jql8J9OCQzw1eGnPMPBYQNlVc4bm33kItQRQUBkST8agvzzEmw/0uKm5qB
         QdDdSZhP0JZiJkT6Uerdi/s6TUv3tHYnxl3ngRYf/FEBBzYmEtA5Nq49OzRoSNApgSlM
         z0og==
X-Gm-Message-State: ACgBeo2o3aKzrce3xNptqPTHyYCbhRQMb4eXl7BBm7MYkTE50dFxNIHT
        g1c9HSUCDBP+mKKEoapnMtjwPU4b/JgXSp/ox4CLQtnKvGkTqw==
X-Google-Smtp-Source: AA6agR6LZazg3a66ucGMhI9Da425d3Nrlx00aV3sDKauwi84N8XhPciBz45iVbedtljmJUWM5U3Q908p3EbS6ACasxo=
X-Received: by 2002:ac2:4943:0:b0:48c:e42a:f0d9 with SMTP id
 o3-20020ac24943000000b0048ce42af0d9mr7024701lfi.528.1660667480622; Tue, 16
 Aug 2022 09:31:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220815230110.2266741-1-dmatlack@google.com> <YvtSc9ofTg1z8tt7@worktop.programming.kicks-ass.net>
In-Reply-To: <YvtSc9ofTg1z8tt7@worktop.programming.kicks-ass.net>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 16 Aug 2022 09:30:54 -0700
Message-ID: <CALzav=eWhg=ZMxVcGf9w_svn1XaTZABN5VoFP3fgxPiHohaMFQ@mail.gmail.com>
Subject: Re: [PATCH 0/9] KVM: x86/mmu: Always enable the TDP MMU when TDP is enabled
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        kvm list <kvm@vger.kernel.org>
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

On Tue, Aug 16, 2022 at 1:17 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Mon, Aug 15, 2022 at 04:01:01PM -0700, David Matlack wrote:
> > Patch 1 deletes the module parameter tdp_mmu and forces KVM to always
> > use the TDP MMU when TDP hardware support is enabled.  The rest of the
> > patches are related cleanups that follow (although the kvm_faultin_pfn()
> > cleanups at the end are only tangentially related at best).
> >
> > The TDP MMU was introduced in 5.10 and has been enabled by default since
> > 5.15. At this point there are no known functionality gaps between the
> > TDP MMU and the shadow MMU, and the TDP MMU uses less memory and scales
> > better with the number of vCPUs. In other words, there is no good reason
> > to disable the TDP MMU.
>
> Then how are you going to test the shadow mmu code -- which I assume is
> still relevant for the platforms that don't have this hardware support
> you speak of?

TDP hardware support can still be disabled with module parameters
(kvm_intel.ept=N and kvm_amd.npt=N).

The tdp_mmu module parameter only controls whether KVM uses the TDP
MMU or shadow MMU *when TDP hardware is enabled*.
