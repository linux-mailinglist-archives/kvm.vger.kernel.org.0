Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 975F64DA61C
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 00:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349818AbiCOXNy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 19:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238090AbiCOXNx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 19:13:53 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FD954BD7
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 16:12:41 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id v35so1357220ybi.10
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 16:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bY5xtSrH39029xqE3mOOcec5o9mj3nUWmGzVJpEccxo=;
        b=Kd8Hv0JDmH3YkSwU8rpWKqK11gwQ5RHa2i26ofq5z9ax+InqOEKhrdmlftL5mlCHG5
         jwk+gYxQeGW5zFpWK1LImFyaoTxjzGO2tJVtCaPzS97kLptqsz2lexAXlEGun6UleVpr
         ZwyGMoN/HrFcIZfbPRVFXczcc1F/axmnlaCZywOX1zrb/6tvTeu925CdgSI9zhVTEB9i
         AEsZBBMGbAE8qEhhLCCJhXUYpgKlqSr9nLQsZNh1TGk0iS78WY79WwrRZzt1991xIKmw
         wQ7oWPzLQMpQ0BNWzic6O7cBBTlZPtbQTvEIAh791Ls5NFLsEEy8tySw8htT/ExgLOzX
         kmOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bY5xtSrH39029xqE3mOOcec5o9mj3nUWmGzVJpEccxo=;
        b=nWcZhMzBCz36ftPIa1S4zs41YDMKNEb/mqPn9a0+19m0gIcYiTbHBWGWd6W0y0IvM7
         xK4Fj9+6Q5Sg3UAZAaTThwI4tMi1pDEWDJ+nep+N3nH8BehRT0ao9iyOi/3L2iEPFy78
         /Jr7dEU2PMm0xs0wWNZhOMUQaDIKsAdVZzOnT/+FnWcwTtVAhTUB7gToz+KT/I9WXJl8
         vkuh8/ajO9PPMPcrZNFh5yLxSy2S9ACxdKD/rUD7PJInQkgG07jY2m5tKBlPpzSsgYkN
         NlBveym9gKsqhgCNU/e4PL4Jfpnlw5qLySrbvijNzH10o8kWhfFuYfNRqQ8D8TXTtbWJ
         ROhg==
X-Gm-Message-State: AOAM533ncvU8kQrYw0eiTZUAex6AVZhlhkbZdKfMzTxKyrT1nJIXAoU6
        yM1zfSpMALXxBzbxEvcQ2nTF0xaGBguxivP4otqqJGeQpJc=
X-Google-Smtp-Source: ABdhPJw+a9V+CQ42uBU5RiZg8cgJJ4ma0rpA3cptTi+WEytuDbMct0Evs4q6GtxXBTEDrLJRR3pheOqaWghQ31HrSqY=
X-Received: by 2002:a25:bf87:0:b0:622:1e66:e7fd with SMTP id
 l7-20020a25bf87000000b006221e66e7fdmr25848318ybk.341.1647385959996; Tue, 15
 Mar 2022 16:12:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220310164532.1821490-1-bgardon@google.com> <Yio8QtuMd6COcnEw@google.com>
 <CANgfPd9xr5ev7fEiwBVUi89iHkuywq-Ba9zOeCMSTFmLkO243w@mail.gmail.com> <YiqxtIz+T1LGE1Ju@google.com>
In-Reply-To: <YiqxtIz+T1LGE1Ju@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 15 Mar 2022 17:12:29 -0600
Message-ID: <CANgfPd9N0UsA7_uMU4vs43gdH7A3UrcrY-OdmXoxQ2PyctwxsA@mail.gmail.com>
Subject: Re: [PATCH 00/13] KVM: x86: Add a cap to disable NX hugepages on a VM
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
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

Okay, I'll hold off on the memslot refactor in v2, but if folks have
feedback on the other aspects of the v1 patch series, I'd appreciate
it.
If not, I'll try to get a v2 sent out.
I think that the commits adding utility functions for the binary stats
interface to the binary stats test could be queued separately from the
rest of this series and will be helpful for other folks working on new
selftests.

On Thu, Mar 10, 2022 at 8:19 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Mar 10, 2022, Ben Gardon wrote:
> > Those patches are a lot of churn, but at least to me, they make the
> > code much more readable. Currently there are many functions which just
> > pass along 0 for the memslot, and often have multiple other numerical
> > arguments, which makes it hard to understand what the function is
> > doing.
>
> Yeah, my solution for that was to rip out all the params.  E.g. the most used
> function I ended up with is
>
>   static inline struct kvm_vm *vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
>                                                      void *guest_code)
>   {
>         return __vm_create_with_one_vcpu(vcpu, 0, guest_code);
>   }
>
> and then the usage is
>
>         vm = vm_create_with_one_vcpu(&vcpu, guest_main);
>
>         supp_cpuid = kvm_get_supported_cpuid();
>         cpuid2 = vcpu_get_cpuid(vcpu);
>
> My overarching complaint with the selftests is that they make the hard things hard,
> and the easy things harder.  If a test wants to be backed by hugepages, it shouldn't
> have to manually specify a memslot.
>
> Let me post my selftests rework as RFC (_very_ RFC at this point).  I was hoping to
> do more than compile test before posting anything, but it's going to be multiple
> weeks before I'll get back to it.  Hopefully it'll start a discussion on actually
> rewriting the framework so that writing new tests is less painful, and so that every
> new thing that comes along doesn't require poking at 50 different tests.
