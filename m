Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22AC348BA92
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 23:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346091AbiAKWMx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 17:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346058AbiAKWMw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 17:12:52 -0500
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7781C06173F
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 14:12:51 -0800 (PST)
Received: by mail-ua1-x92a.google.com with SMTP id y4so1334511uad.1
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 14:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nbz7vvk/g5/wyCkKEDLwDSJe+JJYzX4xi71jSjqd8Ds=;
        b=nxOeeZBxizto3wdZqks3d+GuM/48NtxocfE27Xr6dqtR7ijr6ny0cpE1j8ZUo8irHN
         FUTPJOvHC2oqzVB7ose2KipHP7/ndid7ROLpw5blVzVqPYSxx3vAUr98tVkavFnbQfUK
         pLMhQeEVTGVT6MqluFvDbj+Qx3itH7a6DGeqsIJGdPXTD05RBFF0LElrQEUb+lLCSb7o
         +8H54rhaP8Yy4jJOZyUB9PhmQyFDyOKB1IB9lHvEDFJBWzAUQdb3Sd34x9sXII/2NMP1
         NsOYpCd8uTDlBYaIifrXaGwiehi1nnh4P1rSK3cpSoydYYtHYkZ9iGc4A6Kz2yqLIx5q
         iw9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nbz7vvk/g5/wyCkKEDLwDSJe+JJYzX4xi71jSjqd8Ds=;
        b=QhxcCpUGaPN8cX2Cl0ECWc+rbnt64vMVebiuvEvGlPmXoxzEel3TT+Db+/U5KIpRyf
         i+gvhKGGek8lc4iUqXZke9TQJG1ASF7ZS1oemPffiNJQWDK+45tL8aWFFeapXw7139KY
         7UoBsmi2touLIpNBwOkTR+bynch0CwUaMfQwCTodV8UQHApbZdhEO9abZSmqWexbuC2T
         dwRRhw+W2jR/nVs1Z38a+baAAz7INCGDENMod9s5J6SS0uGHHISba19WA03KGhb1omN7
         lBYEEctO/7Lftq245AmaiEvu6/hyoXbeX5hBU3OHXmIv9TrGXJU0wbUC++Ofhx4R+k/d
         I+pg==
X-Gm-Message-State: AOAM533vBZA1rTENsaZNjf5uVp87T4p4KD5sT3hFgrOfFgDWZOZdQMKb
        3VGZCvBH9DX55b9FHwMsXHzUnq6aObF+p3VVROI+eg==
X-Google-Smtp-Source: ABdhPJzN+ft96CWqj5Q5pNpe5OnVUqYzJeoEqIa+2c9dEmh0mAlkqxKfCPmLLnid4IgaThqckNk6o/WOedpsjDOPsGs=
X-Received: by 2002:a05:6102:50a2:: with SMTP id bl34mr1703201vsb.16.1641939170862;
 Tue, 11 Jan 2022 14:12:50 -0800 (PST)
MIME-Version: 1.0
References: <20220110210441.2074798-1-jingzhangos@google.com>
 <20220110210441.2074798-2-jingzhangos@google.com> <87bl0itvt9.wl-maz@kernel.org>
In-Reply-To: <87bl0itvt9.wl-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 11 Jan 2022 14:12:39 -0800
Message-ID: <CAAdAUtiGYRgdp4qMwhPcYypUa2h_B6qWF8PkUEccHksKKsLoog@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] KVM: arm64: Use read/write spin lock for MMU protection
To:     Marc Zyngier <maz@kernel.org>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 11, 2022 at 2:23 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 10 Jan 2022 21:04:39 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > To reduce the contentions caused by MMU lock, some MMU operations can
> > be performed under read lock.
> > One improvement is to add a fast path for permission relaxation during
> > dirty logging under the read lock.
>
> This commit message really doesn't say what this patch does
> (converting our MMU spinlock to a rwlock, and replacing all instances
> of the lock being acquired with a write lock acquisition). Crucially,
> it only mention the read lock which appears *nowhere* in this patch.
>
Good point. Will use the below message instead for future posts.
"Replace MMU spinlock with rwlock and update all instances of the lock
being acquired with a write lock acquisition.
Future commit will add a fast path for permission relaxation during
dirty logging under a read lock."
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
Thanks,
Jing
