Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D1037A1A9
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 10:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhEKIYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 04:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbhEKIYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 04:24:20 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67B1C061574
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 01:23:14 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id w16so10150235oiv.3
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 01:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=045C15kVflz7mRdOnafmMq48e1iREZTBgktY8+UlBLQ=;
        b=usBH1qyQQe6ZPzFOrrb23X7llSmuVyi8/ugogrn0DiiqOcFmN5N23A+vwiQzhraS8I
         hDBFZmOD7bPeKqMqZo8QrZdYiEYJr1dbhBe6sko2QRH/zx40XZY3GPkkwPl9UxjZFfn4
         0KdaSoHhakKATnZ5BycuKM7nP2yysbq/lXMJKS17VMx+LyOE4cGhILRdTMmMrIFtAVYt
         yLBpIZWcHgRzF08cwsvWrAiAKGtuftRwOnihWAWz5XF1DSmZR9uz8gd1yhW/ry9sz9L8
         Fmf4BSKwOUGW2fBXegpREPe1+1QFb/nQomxM6kms+RmBvRLY5QXpBdgbdcBRgL89xVHx
         oBLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=045C15kVflz7mRdOnafmMq48e1iREZTBgktY8+UlBLQ=;
        b=ZnyCaZRbibNNX2XIzbfJQg0JXmO6PJvbEv+SwyVzi7O+NWDsdqLh/zlEqOy5gq0SpB
         F6HnULK+0brui5FbFxbZbBjs4stzxWk9lW62myZK/2FOPbDZSBy1sO+fRZj27fRdSeLv
         e3o7oaXTchVvHN37AJH0PvWt6ICkI5c9v+ASg3AZiF2lcx59qFnXF6hwOPOz6B3HN27K
         wAG9wjccqJjFsTucni0J9GIV+OigD27jD0y1pbCxg/H2gRYy0iRT+VOxXuJ4irymDk5R
         jLtjQQ19WFCEwTl1Ne2u7DqMaLL7pRmT5TxSh6U3qsmqYYA7jmYo2zeIXo97CRNfYLSP
         Wwnw==
X-Gm-Message-State: AOAM530eVLiMAoJJIUoraCy39+NbzvA5ZTSORwy1/lRNtel4vhVFILN3
        i5F3EOBfntV6p8CKyksyBYiIsGazXMRx9+ng5TNWjApCssqFtA==
X-Google-Smtp-Source: ABdhPJzIB4t03lWKbmxy3jCJsw9fAeIDQrCq1mc5kl0akqAeREBctE/IihK/+/BJ2lGPo6x8xW+oBaVTt8h+WzRQsHw=
X-Received: by 2002:aca:f5c7:: with SMTP id t190mr2559324oih.67.1620721393989;
 Tue, 11 May 2021 01:23:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210510094915.1909484-1-maz@kernel.org> <20210510094915.1909484-3-maz@kernel.org>
 <CA+EHjTzcfmt4mxh05a_P+nheQ_A2FuXhpgvKXuV5__pZP0SxkA@mail.gmail.com> <871radvg9n.wl-maz@kernel.org>
In-Reply-To: <871radvg9n.wl-maz@kernel.org>
From:   Fuad Tabba <tabba@google.com>
Date:   Tue, 11 May 2021 09:22:37 +0100
Message-ID: <CA+EHjTzoWYhgVjURzi9V8nGQO5DOimgGKv7gQcfrRgd-Gf2j2Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Commit pending PC adjustemnts before
 returning to userspace
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org,
        "open list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)" 
        <linux-arm-kernel@lists.infradead.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,


On Tue, May 11, 2021 at 9:14 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Fuad,
>
> On Tue, 11 May 2021 09:03:40 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Marc,
> >
> > > KVM: arm64: Commit pending PC adjustemnts before returning to userspace
> >
> > s/adjustments/adjustments
>
> Looks like Gmail refuses to let you mimic my spelling mistakes! :D
>
> >
> > On Mon, May 10, 2021 at 10:49 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > KVM currently updates PC (and the corresponding exception state)
> > > using a two phase approach: first by setting a set of flags,
> > > then by converting these flags into a state update when the vcpu
> > > is about to enter the guest.
> > >
> > > However, this creates a disconnect with userspace if the vcpu thread
> > > returns there with any exception/PC flag set. In this case, the exposed
> > > context is wrong, as userpsace doesn't have access to these flags
> > > (they aren't architectural). It also means that these flags are
> > > preserved across a reset, which isn't expected.
> > >
> > > To solve this problem, force an explicit synchronisation of the
> > > exception state on vcpu exit to userspace. As an optimisation
> > > for nVHE systems, only perform this when there is something pending.
> >
> > I've tested this with a few nvhe and vhe tests that exercise both
> > __kvm_adjust_pc call paths (__kvm_vcpu_run and
> > kvm_arch_vcpu_ioctl_run), and the tests ran as expected.  I'll do the
> > same for v2 when you send it out.
>
> Ah, that's interesting. Do you have tests that actually fail when
> hitting this bug? Given that this is pretty subtle, it'd be good to
> have a way to make sure it doesn't crop up again.

Nothing that fails, just code that generates exceptions or emulates
instructions at various points. That said, I think it should be
straightforward to write a selftest for this. I'll give it a go.

/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
