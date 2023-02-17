Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A688169B42B
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 21:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjBQUrv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 15:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjBQUrt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 15:47:49 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A163C5CF16
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 12:47:35 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id l11-20020a170902cf8b00b0019ab46166a3so1403941ply.5
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 12:47:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jglgM7rGS6BZeewgUjhjVdRgQ10E1ZkiBvAtcJmwM0A=;
        b=Fk69sJTezn6jkRmpd1DOlrDi/iIq2WXleRsAJDJTt7OkCksspb8tAY4dpElPLjf14g
         UoKLZ0QOmMWCJfm6BikS/IJ88Vg4VqOMTMmV32uVmzMww2ByXxzElWT78pCh6cUcgPat
         QU4eRWO4pp2JAr+eH5yWeJbT3WCxjenoN81nCBjvS57Y0o2w0mNOBKJ4TUdbx1ZO9htN
         58LBXXOCJRQrfJ6D2Y6HU8hUzXfkcX5Gu6q6JmojEiMCvn12bUrYIJk93iibcjqMseWJ
         QVa1D7Z2dhdXlzPZ3pzQQIg0AGsdFGJ/kGsdCOF5CWodQJJHb4Evwae+Md76WDEQODN4
         W9lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jglgM7rGS6BZeewgUjhjVdRgQ10E1ZkiBvAtcJmwM0A=;
        b=JLcP0E+pif5PTEP1Gbu+boBcUSI5QchXU2vvWQLL4WdsXsoMu3/5LQdvrW0eKvcV6s
         DdGjsJpk6xEnMouI6sjRTOz/ZeK+40SIBQdeNjLJaDCvedySnp5XAx4gWIZviwy96WXY
         QNsYcfeI436mflM9fn8qwAALE89G8v4Y35R22ajkWX0DzqW8INN2nWYQiED4i3zcVDcs
         uhvU9c1rzhdrUk8yzVsZozh+zIlIje6TLt1LqmgLShXCipbG8MVPrA4Rpncii//nf5F4
         Rb/zVjsYFWiuMtf3mccIKewf07JXyhqrhPG0d/ZIqdf7muCU3JcUr1gN94HCS0Q+QnH5
         B0+g==
X-Gm-Message-State: AO0yUKUBPGuxl0dUGKBXBG+5+JdWV1lCizf/+UIlgvGBN6bWfMHz/y+b
        5vb4tMY/oVu0JgahnpGLxpCsQJadMUk=
X-Google-Smtp-Source: AK7set9UYCeqsW7R4kSLIqKVhLLvDClhaJZ1vJl7CZ3hUzRmm9/jrECrLYVaf6bJ9FxAYGOjU16oyF5BFjo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:914c:0:b0:4fb:933a:91d with SMTP id
 l73-20020a63914c000000b004fb933a091dmr267319pge.11.1676666855081; Fri, 17 Feb
 2023 12:47:35 -0800 (PST)
Date:   Fri, 17 Feb 2023 12:47:33 -0800
In-Reply-To: <CAF7b7mqeXcHdFHewX3enn-vxf6y7CUWjXjB3TXithZ_PnzVLQQ@mail.gmail.com>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-6-amoorthy@google.com>
 <87mt5fz5g6.wl-maz@kernel.org> <CAF7b7mr3iDBYWvX+ZPA1JeZgezX-BDo8VArwnjuzHUeWJmO32Q@mail.gmail.com>
 <Y+6iX6a22+GEuH1b@google.com> <CAF7b7mqeXcHdFHewX3enn-vxf6y7CUWjXjB3TXithZ_PnzVLQQ@mail.gmail.com>
Message-ID: <Y+/n5X8+fGitI8FE@google.com>
Subject: Re: [PATCH 5/8] kvm: Add cap/kvm_run field for memory fault exits
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, peterx@redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 17, 2023, Anish Moorthy wrote:
> On Thu, Feb 16, 2023 at 1:38=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > Ensuring that vCPUs "see" the new value and not corrupting memory are t=
wo very
> > different things.  Making the flag an atomic, wrapping with a rwlock, e=
tc... do
> > nothing to ensure vCPUs observe the new value.  And for non-crazy usage=
 of bools,
> > they're not even necessary to avoid memory corruption...
>=20
> Oh, that's news to me- I've learned to treat any unprotected concurrent a=
ccesses
> to memory as undefined behavior: guess there's always more to learn.

To expand a bit, undefined and non-deterministic are two different things. =
 In
this case, the behavior is not deterministic, but it _is_ defined.  Readers=
 will
either see %true or %false, but they will not see %beagle.=20

And more importantly _KVM_ doesn't care whether or not the behavior is dete=
rministic,
that's userspace's responsibility.  E.g. if KVM were endangered by the flag=
 changing
then some form of locking absolutely would be needed, but that's not the ca=
se here.
