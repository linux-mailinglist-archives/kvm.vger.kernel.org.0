Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3714170374D
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 19:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244040AbjEORT1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 13:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243871AbjEORTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 13:19:07 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0402AD2D5
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 10:17:10 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f42d937d61so68287765e9.3
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 10:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684171028; x=1686763028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pRNM9TiImjxuTXseGdv/jjf6zIOSVE9iFFKWkLCdwbw=;
        b=s6AVoEauyNuLSEzLRJpAAC6NelJtBURB8ifKHg1U4vi+WcZ/fhM7bi+p5g39jV7tvx
         fkGwuxRYinQPCcwxVEc4iDmJPRU733fqSXQvgVolQl9K5Z+EqqafSsKu+hMpJ7A1u10W
         72BuRoJ7KKmXv5bn8QwiBZHgdvw6L69wtb0/nkoSH+oPCDoMvPFGM4MnPgBZ9BTcJrpp
         KHqoWa1if6fhgjy64zhDedQWzlkjakgqurSdp2vRHVRRKIdY5QfbUUd3s4TvUVp+bywk
         uE/eQR6WzYrZz9umVTBi3yHE7wpK+9vVj960cSKta8vQnyL58fHwLZtV9qbxM6SdVZjS
         PfWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684171028; x=1686763028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pRNM9TiImjxuTXseGdv/jjf6zIOSVE9iFFKWkLCdwbw=;
        b=VYvuxQsDjg51s+zJ8hboR6XzvRKFzWdQ5r7hFixIVN8lyS9jEPmAaJ3jRVVkrvyp9t
         nmzbYP5zZKN1iFvPBv+lZIPK7d4deWUfmlGXQx60Lwz5DUuFBgdaKTiovo9hy0h0nYeR
         9cvjoVvKLP1d+KvMElGMV/S89CQEt5ZcCqBIshHOCxFSchK3bwk6SEFowgCELhwOBuxb
         +lGM1kPZ+6pyFqxIWG+4g19w/IO81vG1jDuJilURtJ1Fb+d/9955tUlJ2FG2KDUxw+O4
         yg75V/ZRJ+bMsZnmZEMkHOiX59nqUe8HnySmkNKfY0/BGFCC5ukN702fb8rVMaMzRQlj
         75eg==
X-Gm-Message-State: AC+VfDziHUXZX9lzm9H+9g4N64p2JOTNn51FOw89COGBPMT/VIzEGgA0
        as9oxWLjQZXRS1wSdtYHCjZiqFYm685hFPmMH7ehtA==
X-Google-Smtp-Source: ACHHUZ7hVivkNOvDkroqqO/GCV8XH1xVY5YHgcP6OLoyOiqdL19EFyFXmodIF1lpjHnlQI26b3C+UXrzpl/cBtsFEUU=
X-Received: by 2002:a1c:f314:0:b0:3f4:f7c2:d681 with SMTP id
 q20-20020a1cf314000000b003f4f7c2d681mr8811102wmq.29.1684171028420; Mon, 15
 May 2023 10:17:08 -0700 (PDT)
MIME-Version: 1.0
References: <ZErahL/7DKimG+46@x1n> <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
 <ZFLPlRReglM/Vgfu@x1n> <ZFLRpEV09lrpJqua@x1n> <ZFLVS+UvpG5w747u@google.com>
 <ZFLyGDoXHQrN1CCD@x1n> <ZFQC5TZ9tVSvxFWt@x1n> <CAF7b7mrTGL8rLVCmsmX4dZinZHRFFB7R7kX0Wv9FZR-B-4xhhw@mail.gmail.com>
 <ZFhO9dlaFQRwaPFa@x1n> <CAF7b7mqPdfbzj6cOWPsg+Owysc-SOTF+6UUymd9f0Mctag=8DQ@mail.gmail.com>
 <ZFwRuCuYYMtuUFFA@x1n>
In-Reply-To: <ZFwRuCuYYMtuUFFA@x1n>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Mon, 15 May 2023 10:16:28 -0700
Message-ID: <CAF7b7mr_EZrBC_8mHxEXtj9u=4qFuxGUaSxH6qd2bz04HgbRzw@mail.gmail.com>
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

On Wed, May 10, 2023 at 2:51=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> What I wanted to do is to understand whether there's still chance to
> provide a generic solution.  I don't know why you have had a bunch of pmu
> stack showing in the graph, perhaps you forgot to disable some of the per=
f
> events when doing the test?  Let me know if you figure out why it happene=
d
> like that (so far I didn't see), but I feel guilty to keep overloading yo=
u
> with such questions.

Not at all, I'm happy to help try and answer as many questions as I
can. It helps me learn as well.

I'll see about revisiting these traces, but I'll be busy for the next
few days with other things so I doubt they'll come soon. I'll jump
back into the mailing list sometime on Thursday/Friday
