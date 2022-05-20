Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C549652F601
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 01:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344692AbiETXJ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 19:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbiETXJ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 19:09:26 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F0B1912CC
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:09:25 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id v33-20020a4a9764000000b0035f814bb06eso1755092ooi.11
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cuk0qcmGS8cM64doehFHXUQ595iUNlebvGcE5hkj4FI=;
        b=UcgnXcNbyg/BBnAxhF4sO44mYVNNeu47n/vqseVyVHFWgUJWMrrN2wVeWo4986+GSs
         Dkkx7gRlwD729TVtmZhETQRkFKydvo7EQu5LoU0IcM21rbQc8mJ7s4mO0sXdGzPt6zZK
         ZmaPYcHmS12OnECeDOmPXhsyVjvJTodjQcNxlwGFWJ6fsyvffR/a62fve2g8yaW1eoEb
         T3/ScizblTEwkMRwkfFUao6FrvWGKOH/2uZo5fc+rIP6ugY6RuTHTEqhCEWHZ6hBImqq
         0xZcEFQRtQWtESE6J4wlTSI5aTsfTdLTKdrlUIUJZWrRreZTFwKt8PFI8Q0x+Kcz/A6k
         KW7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cuk0qcmGS8cM64doehFHXUQ595iUNlebvGcE5hkj4FI=;
        b=cigjuQ2af1Gg4LSDNpnTNEjGxQqYxzjLb1wQt7OuDFA2hlfHnW8y37EXGcYZ8LR94S
         g5isdCWo+UXiyJplc7L5kMlUpbui6UHE7UBUN2/VIq8R2/B6aJL97XGAVpgpcuaOULay
         2HtKuPOjeY1PuJh3t3+AcwM+f/u5geZ/m9TSpXp+GJdhgACVO8ksCgpt/P5lhY3P/5hc
         gIwWiQcQ2FfuWLAmUAguVokqlqnRwEQje40bvTH3u3dP0pD+Ksii/Fh4+o9DSP1ipCnp
         Yd69HHJcMPBzwzymCdJ2jR+yax5oYZXR4L9RBMeIwnDSh1mzgyAqwyVov2YQWYmWpI01
         I2yw==
X-Gm-Message-State: AOAM5318NcBE4CMa8EIteJOdDOfDh4tU7qUtnBMGLOMPnpzysIGUGfPU
        P487A89H+2XSdeX78tpMY+3X7C3h8QV5hohZewkKDsTGMYA=
X-Google-Smtp-Source: ABdhPJxFkuan6uh/hfkLeyK7M70zJX1smTy1bmUeeyNkdD+zNutdo59Aj+L6XtoTXUkRz7rRcuL/STrupEr9HN3bnIE=
X-Received: by 2002:a4a:bb0e:0:b0:40e:5e64:3647 with SMTP id
 f14-20020a4abb0e000000b0040e5e643647mr2835301oop.85.1653088164060; Fri, 20
 May 2022 16:09:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAPUGS=oTTzn+HjXMdSK7jsysCagfipmnj25ofNFKD03rq=3Brw@mail.gmail.com>
 <YoVkkrXbGFz3PmVY@google.com> <CAPUGS=pK57C+yb7Pr5o-LFBWHE-jP8+6-zSrigxVm=hcOtqi=g@mail.gmail.com>
 <YoeyRibqS3dzvku6@google.com> <CAPUGS=rLcHQWpdjSaEMNTthR5EH8opZoOvW1OSs0zPJezBPbYg@mail.gmail.com>
In-Reply-To: <CAPUGS=rLcHQWpdjSaEMNTthR5EH8opZoOvW1OSs0zPJezBPbYg@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 20 May 2022 16:09:12 -0700
Message-ID: <CALMp9eRP7gSMB+-CyxtnTniyfuzJdP3qy9G=5f8rMbfDNGZFeg@mail.gmail.com>
Subject: Re: A really weird guest crash, that ONLY happens on KVM, and ONLY on
 6th gen+ Intel Core CPU's
To:     Brian Cowan <brcowan@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
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

On Fri, May 20, 2022 at 3:03 PM Brian Cowan <brcowan@gmail.com> wrote:
>
> Well, the weird thing is that this is hypervisor-specific. KVM=kaboom.
> VirtualBox is happy, and we can't make this happen on
> roughly-analogous ESX hosts. I can't directly test on my (ubuntu)
> laptop because the driver won't build on the too-new ubuntu 20.04.2
> "Hardware enablement" kernel as it's too new. But either all the other
> hypervisors are doing this wrong and allowing this access, or KVM is.
>
> Not being a kernel expert makes this interesting. I'm passing the
> possibility list over the wall to the kernel folks, but most of the
> evidence we're seeing **seems** to point to KVM...

Which version of kvm? Any unusual kvm module parameters?

Does the guest under the happy hypervisors report that it has smap (in
/proc/cpuidinfo)?
