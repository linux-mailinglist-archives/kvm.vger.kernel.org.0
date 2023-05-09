Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6FA86FD06E
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 23:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235275AbjEIVB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 17:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235368AbjEIVBv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 17:01:51 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3C54499
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 14:01:16 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id ca18e2360f4ac-76355514e03so468038339f.0
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 14:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683666075; x=1686258075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pGveV70EhrzKH5NDozv/FlcoyfGp++y/44scfhvFNg0=;
        b=Bg1HibwIhH17YVJmRlBcFS5kUNOeDrSlOoR1d1rH5aLPnENMrk6muV3ZsLwlN/qjIh
         lMLcTw36JoI8+boKllmNFd5fsdCaXbiSDxcPTt3op1ID8ds64oAUN4Vb5a4lLE5H30RV
         ++TQTd9by+hUiJAqXKJyvnZfv4O3vKjyOQrUoj2yozveH7Vfi4At1DXa1Rilu5YTpN+0
         gQvEodzASWEkk0OFPwi1TXirmL8Y8YKcfg6BTcWryEJKFZiDLolaryl6a+WkO5OIWoLM
         q8HECg3V5Br7FqkjFFZW4xXVsFlB1TwAZmFEhv4g4ncFgSTf/bAoQZOfaYHLlBubc0BR
         AoaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683666075; x=1686258075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pGveV70EhrzKH5NDozv/FlcoyfGp++y/44scfhvFNg0=;
        b=hu645+9Y6tS/VsgYv9hjwJ1SrICtkqtdTK39znD8UcbaLcKPwI3HDc82Tsm5q1oS8V
         DP708F8YB9SRiQKJJIksMRPx9RFEd9b1bVZ10/7Tdml31WAQrfKslhryguCk6OG6syv/
         Msopz6EUCdD7k9gJc/1SbkWnZcBkBewlhJLeK5xc9I6W0Ht3aXgW+tDcuaJD3esauXO9
         VApNKRu/gyqluFjQZ/qX0KM0DeFZB5hQJ23P0vmoquV3KAR3G6ab/eyj/h0j2vffjAp0
         dcRuJ4aO8UnzZWAHtnhiIOT15/7fn0HE0hlj8kl+nplTbrXiXGKPhiwnqH/kTvNL+7CU
         ZLUA==
X-Gm-Message-State: AC+VfDyadqjm+TAb6CwEpoZ5ne4zxa4jYmzRJ52EqR/OLuUz8v0ABuPd
        OUfvphXD9glGJsRcbgKv4u1K4MRIjgE1KBMRT6eqdggvJEeiotkE4g0=
X-Google-Smtp-Source: ACHHUZ4A9uKe5Oz5G8ou57kXdOkTSfd4mvGR419ZB3kR7LxUaQjr0JsRk5SlRXyBWxyaujTRDRo2s1AIGXCXwFrhE6w=
X-Received: by 2002:a05:6102:3656:b0:42f:f1c6:b017 with SMTP id
 s22-20020a056102365600b0042ff1c6b017mr5860042vsu.27.1683665561734; Tue, 09
 May 2023 13:52:41 -0700 (PDT)
MIME-Version: 1.0
References: <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
 <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
 <ZErahL/7DKimG+46@x1n> <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
 <ZFLPlRReglM/Vgfu@x1n> <ZFLRpEV09lrpJqua@x1n> <ZFLVS+UvpG5w747u@google.com>
 <ZFLyGDoXHQrN1CCD@x1n> <ZFQC5TZ9tVSvxFWt@x1n> <CAF7b7mrTGL8rLVCmsmX4dZinZHRFFB7R7kX0Wv9FZR-B-4xhhw@mail.gmail.com>
 <ZFhO9dlaFQRwaPFa@x1n>
In-Reply-To: <ZFhO9dlaFQRwaPFa@x1n>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Tue, 9 May 2023 13:52:05 -0700
Message-ID: <CAF7b7mqPdfbzj6cOWPsg+Owysc-SOTF+6UUymd9f0Mctag=8DQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
To:     Peter Xu <peterx@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oliver.upton@linux.dev, James Houghton <jthoughton@google.com>,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        kvm <kvm@vger.kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Sun, May 7, 2023 at 6:23=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> I explained why I think it could be useful to test this in my reply to
> Nadav, do you think it makes sense to you?

Ah, I actually missed your reply to Nadav: didn't realize you had sent
*two* emails.

> While OTOH if multi-uffd can scale well, then there's a chance of
> general solution as long as we can remove the single-queue
> contention over the whole guest mem.

I don't quite understand your statement here: if we pursue multi-uffd,
then it seems to me that by definition we've removed the single
queue(s) for all of guest memory, and thus the associated contention.
And we'd still have the issue of multiple vCPUs contending for a
single UFFD.

But I do share some of your curiosity about multi-uffd performance,
especially since some of my earlier numbers indicated that multi-uffd
doesn't scale linearly, even when each vCPU corresponds to a single
UFFD.

So, I grabbed some more profiles for 32 and 64 vcpus using the following co=
mmand
./demand_paging_test -b 512M -u MINOR -s shmem -v <n> -r 1 -c <1,...,n>

The 32-vcpu config achieves a per-vcpu paging rate of 8.8k. That rate
goes down to 3.9k (!) with 64 vCPUs. I don't immediately see the issue
from the traces, but safe to say it's definitely not scaling. Since I
applied your fixes from earlier, the prefaulting isn't being counted
against the demand paging rate either.

32-vcpu profile:
https://drive.google.com/file/d/19ZZDxZArhSsbW_5u5VcmLT48osHlO9TG/view?usp=
=3Ddrivesdk
64-vcpu profile:
https://drive.google.com/file/d/1dyLOLVHRNdkUoFFr7gxqtoSZGn1_GqmS/view?usp=
=3Ddrivesdk

Do let me know if you need svg files instead and I'll try and figure that o=
ut.
