Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E492330475F
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 20:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732483AbhAZRFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 12:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389577AbhAZHlf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 02:41:35 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC74C061756
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 23:39:28 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id n3so3926096qvf.11
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 23:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MuwuMM1E8EDH+ukP+fboaIDTRxHiGHEVLbQM3XUxmow=;
        b=cd/IZ7dTUOKWb4uxlB9z6AelujYZfyEijwkUXr6NM5yTwl+513pkERu6h0dMWkhdaU
         At23qG9KTayL3QvCcZJZDYJC33EhuLzzs10LzS4N9jM5ieLQ/Zc8wxRKCfQZLpi2+OSZ
         DvpfPKJ6icTje8vFQO9dFH07mj4NftWxu8Rmw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MuwuMM1E8EDH+ukP+fboaIDTRxHiGHEVLbQM3XUxmow=;
        b=Rxw0lD/6JW6n33oxbP4t2gzzp4X/0Dwx/fcaCiaCMbzWdQgcpV7sr0GUFN4Bj6N/ns
         45kAXMJtD3gWYfW136zWnPKdEl3a/82rXqi635Lu1qBhGnv7aGdod/AUktT7Z1NcC+nY
         QdDrM7erYyM2ZTFyoHLRaDVLwEiASbED6zsQRHF0xt/BXxTg4TYlQN2zwYUaW6XygsGT
         zAk1m7e5d2HRdQ1CRARTtufYsKshWOWuWGd5E/XSDC7He8SWT5JjbCHm89N87xygI6e6
         NuuhO65DxgMJ9cwXTcN6NRRbd8hvjrtpSqh78sWzP2zFIxLnbzbJhxKsXKjjPd/q/ocd
         XM8A==
X-Gm-Message-State: AOAM530tUnOgaX0DiVtI+GBly977rB09dCsIgUAApVmqSIhRJXxLdd4c
        qKPgGchX4aHN5bCqosq11U87hBMT4/awJGA5tSF0UQ==
X-Google-Smtp-Source: ABdhPJx2m2RK3FQFasvssPNmERYPUcOGckV3GmTjsOq1oZjbkp1d0L3SN2CIYmwEZ8kJTM5lEImXMaoaoAu951JMl7M=
X-Received: by 2002:a0c:a905:: with SMTP id y5mr4391981qva.55.1611646767316;
 Mon, 25 Jan 2021 23:39:27 -0800 (PST)
MIME-Version: 1.0
References: <20210125064234.2078146-1-stevensd@google.com> <YA8PXCEVukW0UzC5@google.com>
In-Reply-To: <YA8PXCEVukW0UzC5@google.com>
From:   David Stevens <stevensd@chromium.org>
Date:   Tue, 26 Jan 2021 16:39:16 +0900
Message-ID: <CAD=HUj5YMtSJY6ZO9TRXHDEfWRM1o3Lrm7nkz=G2VJ_oZ-c5mw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: consider the hva in mmu_notifer retry
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        kvm-ppc@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > This has the secondary effect of greatly reducing the likelihood of extreme
>
> Out of curiosity, is this really the _secondary_ effect?  I would expect this
> change to primarily benefit scenarios where the invalidation has gotten
> waylaid for whatever reason.

Yeah, this is the primary benefit. I was thinking about it as the
reduction in page fault retries is the direct effect, and that in turn
leads to a secondary effect of a reduction in the chance of extreme
latency. But I guess that's not a particularly important distinction
to make. I'll reword this.

>
> This needs a comment to explicitly state that 'count > 1' cannot be done at
> this time.  My initial thought is that it would be more intuitive to check for
> 'count > 1' here, but that would potentially check the wrong wrange when count
> goes from 2->1.  The comment about persistence in invalidate_range_start() is a
> good hint, but I think it's worth being explicit to avoid bad "cleanup" in the
> future.
>
> > +     if (unlikely(kvm->mmu_notifier_count)) {
> > +             if (kvm->mmu_notifier_range_start <= hva &&
> > +                 hva < kvm->mmu_notifier_range_end)

I'm not sure I understand what you're suggesting here. How exactly
would 'count > 1' be used incorrectly here? I'm fine with adding a
comment, but I'm not sure what the comment needs to clarify.

-David
