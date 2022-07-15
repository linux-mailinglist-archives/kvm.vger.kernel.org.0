Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F1F57677F
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 21:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiGOTd3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 15:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbiGOTdO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 15:33:14 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3CD88769
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 12:32:20 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id q7so6726436lji.12
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 12:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=62LisgB4vdQ1c8/8kKz4C1ZR0gAFFmPHrTTuWUasxRc=;
        b=I357LQfZoWHINcZeQOB0qENb6Wm1+23xXnjo8XkSmZKLJEzFpspjbAypIfyusq4IOA
         wtLfUE0E++I5ViHa1WBkjLsa9pRMaElsmGv9UeCg0DKFIlwSeg+Z4ApouD1x3KxU6o8U
         2nhnwZS2bJkJtVL+/iBuaLnZ/t45wrQKFA07cDsGQFFEAE7qQBCKyf6CPrXSzMCu3vKt
         mNc12vbFt0QU05MaHiKUS3CHtj3JaHPZD+LQO3uxjyqezzuZkg98BA92P93zrogwpQkC
         UAnCSDmbQo/DHTuq932KrHsIAiCZcfsSifethSJe5MVFC2xJ+yn+05GRU7W9gSopiH2C
         S3/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=62LisgB4vdQ1c8/8kKz4C1ZR0gAFFmPHrTTuWUasxRc=;
        b=3sAXWIX3F9N6Qn5oeFDWCREv4tNJ2H8OoCvpxVkxDfgwyEiH20Ys7vzWNjlFNLRAvv
         +n2CPXLn6kvcbWI5QxspKf+Ks9cnZmZMEwjYKV1beML0SW7BdWKTncIw2ZmjFapHty2X
         FjA/lJEqLuhSsHGBHv4KyjIf83fpcQF1DBdVH3kH+A6da0/FaXqvYeyB6TlFPlf4V0V5
         KpIDql2Jpo7HGozIZule7u1y419d0dMv/lVEnAw6JUGLpePBdMv5gr3LgIiDJZZkZw0r
         WNfnVXr/YoTJvhe2jzd9GN1XVLUcOMXkpSzzYxHrLJiwVmmv3sFxBJxQH8aMblNT1X4H
         X79g==
X-Gm-Message-State: AJIora/rW4yP4Gu5BaxsKKZHZZ0cnOm2BJFSexwvFRQY+4LbCtI/bVPz
        vgFuEgvgn8bz/+ygCUsAp2fV5cfJHaYvDej0W+MXEg==
X-Google-Smtp-Source: AGRyM1vXl7wBE94PXzXIhMJnnOOI4FEuJNATilHuOmLU7pVA4YVkFPgDacg8SvhrLvy+nbmyEgKcJLDK1Vj/rnk63u8=
X-Received: by 2002:a2e:be22:0:b0:25d:6179:4439 with SMTP id
 z34-20020a2ebe22000000b0025d61794439mr7834488ljq.369.1657913538165; Fri, 15
 Jul 2022 12:32:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220618001618.1840806-1-seanjc@google.com> <19bba1a0-8fb7-2aae-a65a-1111e29b92d3@redhat.com>
 <YrHbml1HAfDtvMfn@google.com>
In-Reply-To: <YrHbml1HAfDtvMfn@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 15 Jul 2022 13:32:06 -0600
Message-ID: <CAMkAt6p8_OUQ5rv7DsSjPX6_EUQV6TUn0L3Q4uT1B23e32PkSQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] KVM: selftests: Consolidate ucall code
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Colton Lewis <coltonlewis@google.com>,
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Jun 21, 2022 at 8:55 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Jun 20, 2022, Paolo Bonzini wrote:
> > On 6/18/22 02:16, Sean Christopherson wrote:
> > > Consolidate the code for making and getting ucalls.  All architectures pass
> > > the ucall struct via memory, so filling and copying the struct is 100%
> > > generic.  The only per-arch code is sending and receiving the address of
> > > said struct.
> > >
> > > Tested on x86 and arm, compile tested on s390 and RISC-V.
> >
> > I'm not sure about doing this yet.  The SEV tests added multiple
> > implementations of the ucalls in one architecture.  I have rebased those
> > recently (not the SEV part) to get more familiar with the new kvm_vcpu API
> > for selftests, and was going to look at your old review next...
>
> I had forgotten about that code.  My idea of a per-VM list[*] would fit nicely on
> top, though maybe drop the last patch from this series.
>
> [*] https://lore.kernel.org/all/Yc4gcJdhxthBKUUd@google.com

I just sent an RFC of SEV selftesting using Sean's suggestion built on
the first 2 patches in this series. I think they work well with the
encrypted VMs ucalling.

https://lore.kernel.org/all/20220715192956.1873315-1-pgonda@google.com/
