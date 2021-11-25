Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C88045D3C5
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 04:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbhKYD4H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 22:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbhKYDyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 22:54:06 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E50C061746;
        Wed, 24 Nov 2021 19:50:56 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id x6so5813292iol.13;
        Wed, 24 Nov 2021 19:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0y/VmP1c+bFWVUhVG+XLKmEwew3RmrCGf9PkOC1xvzA=;
        b=eiTwUqC4nLNQb1IFh9xaWZhc/AzFUKXgGO2C1nTiZdKbn0Jz3z7mxWwg2EaEavZnTF
         bBgWn5tsNFct2IDVy05I+gqlZ3PnZe5Vt/UASfrjnSvtzSjjeP/MODS3m39McNA/AbZZ
         tmniyIfFI/Ai8reedeqMy4JgkUGIDXA+eg1qiRB2Q4ix0Yq+gBVQjWoG6y47RuOgav6s
         iLj+u8ouuCDQqzvs/fJ4GCsOsWmvWjMSz+32daWAEeKIwthFaOKq3Xyil7HNIn6qD76d
         zt0OfgXEByTdY4KD30bRvy4Y4YheN9iWvOb/v6Fa2NbSYblrCvPG+S8Ya3oN5BQMr2dg
         +k0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0y/VmP1c+bFWVUhVG+XLKmEwew3RmrCGf9PkOC1xvzA=;
        b=nXKsPMBjPK3rjfdrnf3z/Zta1Ta9bxp3hcwBiBjrxEI65h6cgQZgGZZ3Pq9Vzyhez9
         3E3958hmhc/Xr9K9XF4O79xkwZUHautc5KtJyDd3LmLEi7XL3dk6oD0keVr4axdTlQ0l
         zM8dTV/sEsevGCe5KGhI9r66EpByyEZh7vHcg4YzZad1xfutrnJ7Qv0LXmko2T5ZiJRO
         /LMgE/QXURIlnfV7TJxFvxzvdEb4XQxA0e1OSev7KV9CH9KVgMJ/nM4O/yc4wAaQrtd4
         Kzbu9mrKTVJ4JcLmputwoVXYBJ9oE23BnWulyuxqz9zqW36nYFfQXaSLqT0x1lPeym2O
         z5+A==
X-Gm-Message-State: AOAM533tCzkdUTZV7TCQsssAdLFQhlnEUFOp9K2wbVM3mDXv81y6bENH
        UTxMgZrSoXkLrCKT0eqnevay/J6UIcEsbXNJ2g8=
X-Google-Smtp-Source: ABdhPJzpbVMy01M9qsGg/1ZVEkzdw6FRToxwDJngNDyCLZBfhz/7JLd1r5NAnHKxKgsskGRaeKZd1F2ruZOuzMaDT3s=
X-Received: by 2002:a5d:8e07:: with SMTP id e7mr21032612iod.148.1637812255615;
 Wed, 24 Nov 2021 19:50:55 -0800 (PST)
MIME-Version: 1.0
References: <20211125014944.536398-1-seanjc@google.com> <20211125014944.536398-2-seanjc@google.com>
In-Reply-To: <20211125014944.536398-2-seanjc@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Thu, 25 Nov 2021 11:50:44 +0800
Message-ID: <CAJhGHyBisXe9t0hFsuBfDvQXwAabKhfMfmRPDdCkNDXWzteyKA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: nVMX: Flush current VPID (L1 vs. L2) for KVM_REQ_TLB_FLUSH_GUEST
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 25, 2021 at 9:49 AM Sean Christopherson <seanjc@google.com> wrote:

> Reported-by: Lai Jiangshan <jiangshanlai+lkml@gmail.com>

Oh, I just noticed that I made an incorrect configuration in Gmail.
I hope it be
Reported-by: Lai Jiangshan <jiangshanlai@gmail.com>
when it comes to "Reviewed-by", "Reported-by" as my email address in
the file MAINTAINERS.
