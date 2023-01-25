Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5F067B850
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 18:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235476AbjAYRWG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 12:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235394AbjAYRWC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 12:22:02 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEAEB46C
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 09:22:01 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id b1so18637539ybn.11
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 09:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+NF7WOwKXStbVcCBmnQTR8aAYHjwReQdf6MvWz/ieQE=;
        b=G/sP0Ge2BbmLK5C1fYqIhHmfO9YiRHy87eRqbWpmlZctgb1Mjd3hQa4bOwD180MWX6
         N9m5BZ5ghS2tzwTNr12nV3VeSN0+z9yP0c4kJa8fVHf0liLZpx9LSNTEL28uc4R/m8Xd
         DTt9dY/swPExNObKMFXnORILtXrqvfvPIy7kzOUkT25jJo53AbsZlXcJaaoY0pxtCLXS
         qgm7XaZfzBEKVqNPbBdF0AhzVYtmjGNYtzFnqQUr3odJs29myMNgBOQe8LMz9PeTVJLp
         7+pVgI1I+vSb3zqVmxeKhnMsVmNFvn/PsYcbOlBZDilIwwcmDqrHgsUVs8ak5XGd8/tq
         3RgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+NF7WOwKXStbVcCBmnQTR8aAYHjwReQdf6MvWz/ieQE=;
        b=X9HjgETcaOvGHA5cZNslc3W0WItvxtgX4ATtDxhuLvH7Zs+2fHEp/DWPkj1ZxTYA8h
         9jclut2C+FNf+yiG9OFqeMMufhZ50R1wiHHn1XUojVQfSYt5VsjcpPm8vqJTuMNlBVWB
         8aPXFjk7DKIOeg/7XTlMMjZoLhgqM3xfTqumh7CqurYDZw0tC5//P9uAvJa7/e2o878t
         x4KcyKU079kxIkI1QsDFKaUcvPF0MxnLNCJA5X1HpXqeClolJrpDrwxhEp2CXbpNPv9e
         m7o4/jZJLN1/cdGGBbO941TeJzkQw47GhIyDi4JOSJgbKqm2HRphXujcdxsdSxQLjlmo
         1yPw==
X-Gm-Message-State: AFqh2krGqymB5lVhD5f2NyrVM94G3mfDKUPHcfk6r3PnORDFmvj8quT4
        3iR6ZZdXAEHBZqgkq7V4GL9UpiD0Ba3feL923JCghg==
X-Google-Smtp-Source: AMrXdXu3jKBxFWKV9U7HEoc8nZkdzpu/vB3yVyIUHmWHNLUO+5YjJYHaG1m9/rmSDsx5131N51uq+J+p+rywDrfAr5Q=
X-Received: by 2002:a25:1984:0:b0:7fe:e7f5:e228 with SMTP id
 126-20020a251984000000b007fee7f5e228mr1798951ybz.582.1674667320995; Wed, 25
 Jan 2023 09:22:00 -0800 (PST)
MIME-Version: 1.0
References: <20230119173559.2517103-1-dmatlack@google.com> <Y9B8A+/FSPCrAANT@google.com>
 <Y9B9FZReDVwdNNrS@google.com>
In-Reply-To: <Y9B9FZReDVwdNNrS@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 25 Jan 2023 09:21:34 -0800
Message-ID: <CALzav=fAVF5VDj76Pd9m+G+-A+UdvCS1tTVGCyvnvtgq4eFOSg@mail.gmail.com>
Subject: Re: [PATCH 0/7] KVM: Add a common API for range-based TLB invalidation
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org,
        Raghavendra Rao Ananta <rananta@google.com>
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

On Tue, Jan 24, 2023 at 4:51 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> On Wed, Jan 25, 2023 at 12:46:59AM +0000, Sean Christopherson wrote:
> > On Thu, Jan 19, 2023, David Matlack wrote:
> >
> > Did a quick read through, didn't see anything I disagree with.
>
> LGTM for the tiny amount of arm64 changes, though I imagine David will
> do a v2 to completely get rid of the affected Kconfig.

Thanks both for taking a look.

> > Is there any urgency to getting this merged?  If not, due to the dependencies
> > with x86 stuff queued for 6.3, and because of the cross-architecture changes, it
> > might be easiest to plan on landing this in 6.4.  That would allow Paolo to create
> > an immutable topic branch fairly early on.
>
> +1, that buys us some time to go through the rounds on the arm64 side
> such that we could possibly stack the TLBIRANGE work on top.

The main benefit of merging in 6.3 would be to make Raghavendra's life
simpler/easier so he can build the next version of his arm64 TLBI
series on top. But I guess he can still do that with a topic branch.

I'll go ahead and send a v2 on top of the changes from Hou you queued
for 6.3, Sean, and we can plan on landing that in 6.4 (barring any
further feedback or conflicts).
