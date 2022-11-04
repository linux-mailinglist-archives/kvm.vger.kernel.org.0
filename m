Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1A3619F10
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 18:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiKDRoB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 13:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbiKDRno (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 13:43:44 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FA2748E8
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 10:42:40 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id v1so8016559wrt.11
        for <kvm@vger.kernel.org>; Fri, 04 Nov 2022 10:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gZRaWO/V1xiqx1eDC7r3VOOHIFPvaFpSyP31c7Jcw6s=;
        b=moVmMmYBwK6xOn+awu4Z2/Q+mLOImqr4cXxGAy1//sAXvXmk+uwiPJ1KnAFv/5MJdx
         WKxFXzVqwdlx5SH8sQFjR9m9CemQd5+udzUFNvRd3Duvl4mjdkzhwN4SfCmPCd5bBNZL
         M+XbukpM6pFEup0kX94kJUjYR8wzIVuzxtYCSWzOmxRcpykfgbMZ69effEZvbi0o7Qce
         qfMq9cLcShSfWjlyjW2f4Es9+mlJ48cQsRneRwUj7IvcgsoyV+nC0RY/Y2XIX64ZsN/7
         Yo4WRHqM2sfKt7yzKGgr5+DrH0R0IrBCRpz3dahyUL1Enwik8EfkA2IwMLrcAXvE0q4l
         FKyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gZRaWO/V1xiqx1eDC7r3VOOHIFPvaFpSyP31c7Jcw6s=;
        b=to3zOmyLfvQWqY7O8CHIgvXcpfYzD814VyYG7ewMaW5EAeUn2kM02EEjqXGAiO8nDF
         +2Xz9QMHrha3HM2+dPtqZt1Kg4/oBznUgG20sUpo+0KZovCHxzdIrZNRCnfDhJ6AGDZW
         w7e9FpGESzgZKMkkyrz3hPzKSkfJY6enyMzPhJVYusD1Ys9qs5XQihaXHj37h2dganNN
         1dzmwMoigYD9WbSWXwyvi/QZuLyR1I/L1uZwrxdbrbYMSQ7n8IfLuBApaewbUMIXg6pQ
         8IITxDJgJLgqFaGhNkLLB4MRqfxTnXrWC5tODtUd534+RpDrG1pace5eEnw0SG9gQr/y
         vHOg==
X-Gm-Message-State: ACrzQf2v5+/Bz5okj6TLULhFjcF6LsxxqNMtdrrgJkiDpnHInXXaBdIf
        h7Jq5X4c7Sy5kf+kz2A9K8aVyyOfizO0PxBiA/nDUw==
X-Google-Smtp-Source: AMsMyM6oeAl9VU7IukG+ufk/d0220k0kvPLgAWMaVWWu9lfDLGiKZIeuyB2sA3qpRQ42h5Db8GK0C/zT7dQz5Xt2uI8=
X-Received: by 2002:a5d:53cf:0:b0:236:bbc0:236 with SMTP id
 a15-20020a5d53cf000000b00236bbc00236mr21494089wrw.572.1667583758732; Fri, 04
 Nov 2022 10:42:38 -0700 (PDT)
MIME-Version: 1.0
References: <20221104011041.290951-1-pcc@google.com> <86a656r8nh.wl-maz@kernel.org>
In-Reply-To: <86a656r8nh.wl-maz@kernel.org>
From:   Peter Collingbourne <pcc@google.com>
Date:   Fri, 4 Nov 2022 10:42:27 -0700
Message-ID: <CAMn1gO62ugtyL9-0hE=DCn=EJ6JY+=Li3QTKPeNULdUhZdnM7w@mail.gmail.com>
Subject: Re: [PATCH v5 0/8] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Cornelia Huck <cohuck@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        linux-mm <linux-mm@kvack.org>
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

On Fri, Nov 4, 2022 at 9:23 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 04 Nov 2022 01:10:33 +0000,
> Peter Collingbourne <pcc@google.com> wrote:
> >
> > Hi,
> >
> > This patch series allows VMMs to use shared mappings in MTE enabled
> > guests. The first five patches were taken from Catalin's tree [1] which
> > addressed some review feedback from when they were previously sent out
> > as v3 of this series. The first patch from Catalin's tree makes room
> > for an additional PG_arch_3 flag by making the newer PG_arch_* flags
> > arch-dependent. The next four patches are based on a series that
> > Catalin sent out prior to v3, whose cover letter [2] I quote from below:
> >
> > > This series aims to fix the races between initialising the tags on a
> > > page and setting the PG_mte_tagged flag. Currently the flag is set
> > > either before or after that tag initialisation and this can lead to CoW
> > > copying stale tags. The first patch moves the flag setting after the
> > > tags have been initialised, solving the CoW issue. However, concurrent
> > > mprotect() on a shared mapping may (very rarely) lead to valid tags
> > > being zeroed.
> > >
> > > The second skips the sanitise_mte_tags() call in kvm_set_spte_gfn(),
> > > deferring it to user_mem_abort(). The outcome is that no
> > > sanitise_mte_tags() can be simplified to skip the pfn_to_online_page()
> > > check and only rely on VM_MTE_ALLOWED vma flag that can be checked in
> > > user_mem_abort().
> > >
> > > The third and fourth patches use PG_arch_3 as a lock for page tagging,
> > > based on Peter Collingbourne's idea of a two-bit lock.
> > >
> > > I think the first patch can be queued but the rest needs some in depth
> > > review and test. With this series (if correct) we could allos MAP_SHARED
> > > on KVM guest memory but this is to be discussed separately as there are
> > > some KVM ABI implications.
> >
> > In this v5 I rebased Catalin's tree onto -next again. Please double check
>
> Please don't do use -next as a base. In-flight series should be based
> on a *stable* tag, either 6.0 or one of the early -RCs. If there is a
> known conflict with -next, do mention it in the cover letter and
> provide a resolution.

Okay, I will keep that in mind.

> > my rebase, which resolved the conflict with commit a8e5e5146ad0 ("arm64:
> > mte: Avoid setting PG_mte_tagged if no tags cleared or restored").
>
> This commit seems part of -rc1, so I guess the patches directly apply
> on top of that tag?

Yes, sorry, this also applies cleanly to -rc1.

> > I now have Reviewed-by for all patches except for the last one, which adds
> > the documentation. Thanks for the reviews so far, and please take a look!
>
> I'd really like the MM folks (list now cc'd) to look at the relevant
> patches (1 and 5) and ack them before I take this.

Okay, here are the lore links for the convenience of the MM folks:
https://lore.kernel.org/all/20221104011041.290951-2-pcc@google.com/
https://lore.kernel.org/all/20221104011041.290951-6-pcc@google.com/

Peter
