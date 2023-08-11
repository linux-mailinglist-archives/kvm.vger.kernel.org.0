Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38FAE778FA7
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 14:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbjHKMiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 08:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjHKMiI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 08:38:08 -0400
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B24EE65
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 05:38:06 -0700 (PDT)
Received: by mail-vk1-xa2e.google.com with SMTP id 71dfb90a1353d-4871396a94fso760907e0c.1
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 05:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691757485; x=1692362285;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EvRsZaCvxzdM5qQ74utVXRoJOdLTQO1MpcAYCJUSp2s=;
        b=RK9AT6X9/XmZS8WZvd3n2tAOdWTwvHJu+/X1uxCzjSC5LTa14KPrZSoSIKIs95nlux
         nhrgZeg5ahuLbvxanmOe+kMLx9sQ3jV0L4UMMduN7KqWkAYPWnCauONOCNHBQtzTDrA+
         vK9Olg9A21WrSnCtVwYtYUW1klNX4A0aeQFyrTQZrV4z+a0GkNNyURzOERpm1kyYN5RK
         bq03bySby1MLn6X6j8wKf9qRuRJI7tPQFkpVDeSO+NEDOgmoHQbknCzWnx89ZZZQT4GA
         zAJJjP1En1KDwwTpD/CeCwGYgtnFV8maNTXTNmDftRm5XJ0CeJAZ1mbHtmKDdkvL25tp
         1noQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691757485; x=1692362285;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EvRsZaCvxzdM5qQ74utVXRoJOdLTQO1MpcAYCJUSp2s=;
        b=XkZfuHZjYqIFRagl/5VKNQ0vS/8OW6H7kaQhjBRKHRHC/mov2gDnr3h3CweZqu3gle
         7ytTvla9247srQbCWT4UlgsOiSLE5//n8pM7czEjL4CcAr5fYVZOUJOcytWtnGcfvf+A
         8TlkuZFvr4YirWcSTFIvosmd0QDYnXS1qmaemjwCqBz4AnT/9RConW1WReuXiPLDovSi
         waqal6y6voX+ufc51mUKaGkc7d1QsvL2yEAXc9Vod4UcKL07u61A4RUlOV5PYSow4mMK
         CKqz7Bm5q3BJZqf8zAxQuFNlQe3tl28KYza3D/N+G11z6PZ9+c/PKEBc/gha7hBURdqS
         dvuA==
X-Gm-Message-State: AOJu0Yz1rn9k72FHpbymsAASm1YYNpjHlZuGg4mJUeOeFw39aRkkcemI
        QfShDX9RO+KQZDmZa3ikbU3FpiEnOtPNlwTPQBsvVlbs82M=
X-Google-Smtp-Source: AGHT+IGXI3c/JO5pz+pmQySybtKvZ/10uS89VksQh1myjVDi8TVMkg1NOpR8fMvhtKiyxZ/y6/ejA9soc0E5WxgCqv8=
X-Received: by 2002:a1f:bd49:0:b0:471:1785:e838 with SMTP id
 n70-20020a1fbd49000000b004711785e838mr2099256vkf.2.1691757485498; Fri, 11 Aug
 2023 05:38:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAG+wEg21f6PPEnP2N7oE=48PBSd_2bHOcRsTy_ZuBpa2=dGuiA@mail.gmail.com>
 <ZMAGuic1viMLtV7h@google.com> <CAG+wEg3X1Tc_PW6E=pLHKFyAfJD0n2n25Fw2JYCuHrfDC_Ph0Q@mail.gmail.com>
 <ZMp3bR2YkK2QGIFH@google.com> <CAG+wEg2x-oGALCwKkHOxcrcdjP6ceU=K52UoQE2ht6ut1O46ug@mail.gmail.com>
 <ZMqX7TJavsx8WEY2@google.com> <CAG+wEg1d7xViMt3HDusmd=a6NArt_iMbxHwJHBcjyc=GntGK2g@mail.gmail.com>
 <ZNJ2V2vRXckMwPX2@google.com> <e21d306a-bed6-36e1-be99-7cdab6b36d11@ewheeler.net>
 <e1d2a8c-ff48-bc69-693-9fe75138632b@ewheeler.net> <ZNV5rrq1Ja7QgES5@google.com>
In-Reply-To: <ZNV5rrq1Ja7QgES5@google.com>
From:   Amaan Cheval <amaan.cheval@gmail.com>
Date:   Fri, 11 Aug 2023 18:07:53 +0530
Message-ID: <CAG+wEg1wio-0grasdwdfNHr7fHZkZWt2TF2LZtw65WZx42jkyQ@mail.gmail.com>
Subject: Re: Deadlock due to EPT_VIOLATION
To:     Sean Christopherson <seanjc@google.com>
Cc:     Eric Wheeler <kvm@lists.ewheeler.net>, brak@gameservers.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> There's a pretty big list, see the "failure" paths of do_numa_page() and
> migrate_misplaced_page().

Gotcha, thank you!

...

> Since it sounds like you can test with a custom kernel, try running with this
> patch and then enable the kvm_page_fault tracepoint when a vCPU gets
> stuck.  The below expands said tracepoint to capture information about
> mmu_notifiers and memslots generation.  With luck, it will reveal a smoking
> gun.

Thanks for the patch there. We tried migrating a locked up guest to a host with
this modified kernel twice (logs below). The guest "fixed itself" post
migration, so the results may not have captured the "problematic" kind of
page-fault, but here they are.

Complete logs of kvm_page_fault tracepoint events, starting just before the
migration (with 0 guests before the migration, so the first logs should be of
the problematic guest) as it resolves the lockup:

1. https://transfer.sh/QjB3MjeBqh/trace-kvm-kpf2.log
2. https://transfer.sh/wEFQm4hLHs/trace-kvm-pf.log

Truncated logs of `trace-cmd record -e kvm -e kvmmmu` in case context helps:

1. https://transfer.sh/FoFsNoFQCP/trace-kvm2.log
2. https://transfer.sh/LBFJryOfu7/trace-kvm.log

Note that for migration #2 in both respectively above (trace-kvm-pf.log and
trace-kvm.log), we didn't confirm that the guest was locked up before migration
mistakenly. It most likely was but in case trace #2 doesn't present the same
symptoms, that's why.

Off an uneducated glance, it seems like `in_prog = 0x1` at least once for every
`seq` / kvm_page_fault that seems to be "looping" and staying unresolved -
indicating a lock contention, perhaps, in trying to invalidate/read/write the
same page range?

Any leads on where in the source code I could look to understand how that might
happen?

----

@Eric

> Does the VM make progress even if is migrated to a kernel that presents the
> bug?

We're unsure which kernel versions do present the bug, so it's hard to say.
We've definitely seen it occur on kernels 5.15.49 to 6.1.38, but beyond that, we
don't know for certain. (Potentially as early as 5.10.103, though!)

> What was kernel version being migrated from and to?

The live migration where the issue was resolved by migrating, was from 6.1.12 to
6.5.0-rc2.

The traces above are for this live migration (source 6.1.x to target host
6.5.0-rc2).

Another migration was from 6.1.x to 6.1.39 (not for these traces). All of these
times the guest resumed/made progress post-migration.

> For example, was it from a >5.19 kernel to something earlier than 5.19?

No, we haven't tried migrating to < 5.19 yet - we have very few hosts running
kernels that old.

> For example, if the hung VM remains stuck after migrating to a >5.19 kernel
> but _not_ to a <5.19 kernel, then maybe bisect is an option.

From what Sean and I discussed above, we suspect that the VM remaining stuck is
likely due to the kernel softlock'ing from stalling in the kernel due to the
original bug.

We do know this issue _occurs_ as late as 6.1.38 at least (i.e. hosts running
6.1.38 have had guests lockup - we don't have hosts on more recent kernels, so
this isn't proof that it's been fixed since then, nor is migration proof of
that, IMO).
