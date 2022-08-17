Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E0459747D
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 18:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237979AbiHQQuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 12:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241176AbiHQQuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 12:50:07 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA614861E5
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:50:06 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id z25so19757251lfr.2
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=GsFW6kdlk2EduzgAN4eQ0XmgIa9EIFOYjXTJTdknYIE=;
        b=oI55mYp1OVQPbK6T3xVW1yDh/wlfXArHlj+x+pu/hg7E7oVfo9CzkmaT2y048Gd7Md
         eyjfQzyA3YaQHU1JjNCBUegRlDBeSwViOz0B+Fajiee3f2XLbPsvP0YV877HiwgNscM6
         tBNbkPqLEZlIYdPzH0Sq0L5qICr9nLhWXg+Gq7r69Oo/pegDWWc5XMXJlets7weSp8Lm
         Vo0fKB1R1SLfvG0d7zF5XVC2Dz4YoSZwxCIvflHGYtZjSlVrDxF3YCoLhQRGYA2zHgUw
         Qm7ZOw84s5/mZ5oaYcoUXouh+cz+AjnsZ+ZU7sdZN4VDvXTB037aV4KNTCsAZJwpdoQt
         1bZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=GsFW6kdlk2EduzgAN4eQ0XmgIa9EIFOYjXTJTdknYIE=;
        b=msPaJQjCAi+1hyLRwG7v3LGdJQ9hf+LmFPXMC7bSJ0COhuulYbSUTzw9ui5Lnqy7wg
         dVeNSLojgwKAin4Fq8w1BmD7y9/LHoE3DkWxzQO8hWBIQn4IRLDNSrnGAhuNf3XDgcSQ
         vqJOpn1Uap3bdhVMLWiVpIWuAkplU8DId3/BpwVMBaZpK8LCkyHpKzaeTf5wcog43Cim
         xJHWZB4jniPSOAX2XNcNxAnwwdgN4f+5GUT2dZ96ks+dRKY8wc2enoSWqHtmOQEKqOWy
         4+my/mJAllP7KFcDrucxIJof4jiV9fzcXT52jUXnUbEtY4x46jTXldI9TsnHHN/ZmTKI
         ujNg==
X-Gm-Message-State: ACgBeo1fW/nbG7WnEKL05rcZqLE9goQ96vFb0xogkVOr50jEjq2MGte/
        bc/i8nINNB/nWIWwGQ1Mi9hyKtflpmHL7dyIUHdg8A==
X-Google-Smtp-Source: AA6agR5/4Sl9fA2o6ZknN1qLr7kDp6yOf/ND3F/lSHl0SXnaX4Dx11f15VZQnRj972GtFMJ17gZpKXi56sE1vXJpe6Q=
X-Received: by 2002:ac2:4c4f:0:b0:48b:1358:67e3 with SMTP id
 o15-20020ac24c4f000000b0048b135867e3mr8694435lfk.441.1660755004892; Wed, 17
 Aug 2022 09:50:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220815230110.2266741-1-dmatlack@google.com> <20220815230110.2266741-2-dmatlack@google.com>
 <4789d370-ac0d-992b-7161-8422c0b7837c@redhat.com>
In-Reply-To: <4789d370-ac0d-992b-7161-8422c0b7837c@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 17 Aug 2022 09:49:38 -0700
Message-ID: <CALzav=cvxR3R6v2CptJJfPaH1go1zxDE15Aedw3ztT-w+wcVKQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] KVM: x86/mmu: Always enable the TDP MMU when TDP is enabled
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
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

On Wed, Aug 17, 2022 at 3:05 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 8/16/22 01:01, David Matlack wrote:
> > Delete the module parameter tdp_mmu and force KVM to always use the TDP
> > MMU when TDP hardware support is enabled.
> >
> > The TDP MMU was introduced in 5.10 and has been enabled by default since
> > 5.15. At this point there are no known functionality gaps between the
> > TDP MMU and the shadow MMU, and the TDP MMU uses less memory and scales
> > better with the number of vCPUs. In other words, there is no good reason
> > to disable the TDP MMU.
> >
> > Dropping the ability to disable the TDP MMU reduces the number of
> > possible configurations that need to be tested to validate KVM (i.e. no
> > need to test with tdp_mmu=N), and simplifies the code.
>
> The snag is that the shadow MMU is only supported on 64-bit systems;
> testing tdp_mmu=0 is not a full replacement for booting up a 32-bit
> distro, but it's easier (I do 32-bit testing only with nested virt).

Ah, I did forget about 32-bit systems :(. Do Intel or AMD CPUs support
TDP in 32-bit mode?

> Personally I'd have no problem restricting KVM to x86-64 but I know
> people would complain.

As a middle-ground we could stop supporting TDP on 32-bit
systems. 32-bit KVM would continue working but just with shadow
paging.


>
> What about making the tdp_mmu module parameter read-only, so that at
> least kvm->arch.tdp_mmu_enabled can be replaced by a global variable?
>
> Paolo
>
