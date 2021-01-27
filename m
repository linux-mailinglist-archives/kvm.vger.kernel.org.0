Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2950D3051A2
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 06:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238468AbhA0EX5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 23:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389663AbhA0AGv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 19:06:51 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DA7C0617A7
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 16:04:41 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id u15so48082plf.1
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 16:04:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ehN8g8luuF2BKLiZYDz35HTGbUgrzlwEK0VyDMRc1bE=;
        b=u+tGmLtats3b8HsEfxKVQgMK0GXcYfxMRPArDpxJoYSxVOHzNMkczWTT9UKc+iuL5c
         1i80Ybhtd+JjjT+hrlRpf+r1Oti1xkqj1SSUkApAb7iuqNc0hAkpN+PYw76+kF30zXuT
         xKNeJ0v6+/QBYk7eVYWEZTsCW8IasRNlBF9OpHVGxlio9+VdQohz9RpJPqPxKapSecTH
         XpaQaL94Nfi9thSv44/gpO6nt2eB1Ocr0Vtnc3sPmSduLvYB3U07MvoJrdF3T7Y1+n08
         NfLW9PKtYmJe5bubHPO75UGFwYTmQBwPme6NriQsLx5/PJNyd+X6U36wepGK/wdj+iNS
         wuJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ehN8g8luuF2BKLiZYDz35HTGbUgrzlwEK0VyDMRc1bE=;
        b=A1A9PWwbwJrdGWnL3NU+cJowXiGe+TKAZ7z3ORSlOb2ZJMvwd/lZ9LMe3hLDpC9hqL
         PKjo+uedq8J9RrLgRHwb/q3pQ2rs/0y1mmb9vyrJULZ2Vc6fkUU6ISoGX0GwaEfMm3mw
         GX74AoTeBMS0a5EW7X0IcN6VkfPthVE+So0dJBRnpw/aTyD2MsMXYmZA/XyU1S8iMJmn
         n391RiH2lA8OYrVKSJnmHCvrNxy0pvRGL/tV1DUI+12I/IeUgZJHjas3xA7L46qZefkC
         fSTrOljN2MjoWmC/0tBGOTL1sS0u4t3eP9c6ql5SVmna43TelXHeV+YtJjMOjdawy+K/
         DajA==
X-Gm-Message-State: AOAM5333a+pnv3F+xOWHNjfrYmNX9/EsjiGg6gSUPCER0hEEJs7JjIAW
        o5TYOO/YeEdoOIvzRA0b3VFYkw==
X-Google-Smtp-Source: ABdhPJzzbvfi/5tp5Y0OvbgmuXAJ+a6Aqpa1MNl1ySc5Qa2syXhxmjS34UST5dEuL1LWwufhbGgubw==
X-Received: by 2002:a17:90b:4a09:: with SMTP id kk9mr2478013pjb.15.1611705881203;
        Tue, 26 Jan 2021 16:04:41 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id y4sm75088pji.34.2021.01.26.16.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 16:04:40 -0800 (PST)
Date:   Tue, 26 Jan 2021 16:04:33 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     David Stevens <stevensd@chromium.org>
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
Subject: Re: [PATCH] KVM: x86/mmu: consider the hva in mmu_notifer retry
Message-ID: <YBCuEaxZu0MuD3MW@google.com>
References: <20210125064234.2078146-1-stevensd@google.com>
 <YA8PXCEVukW0UzC5@google.com>
 <CAD=HUj5YMtSJY6ZO9TRXHDEfWRM1o3Lrm7nkz=G2VJ_oZ-c5mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=HUj5YMtSJY6ZO9TRXHDEfWRM1o3Lrm7nkz=G2VJ_oZ-c5mw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 26, 2021, David Stevens wrote:
> > This needs a comment to explicitly state that 'count > 1' cannot be done at
> > this time.  My initial thought is that it would be more intuitive to check for
> > 'count > 1' here, but that would potentially check the wrong wrange when count
> > goes from 2->1.  The comment about persistence in invalidate_range_start() is a
> > good hint, but I think it's worth being explicit to avoid bad "cleanup" in the
> > future.
> >
> > > +     if (unlikely(kvm->mmu_notifier_count)) {
> > > +             if (kvm->mmu_notifier_range_start <= hva &&
> > > +                 hva < kvm->mmu_notifier_range_end)
> 
> I'm not sure I understand what you're suggesting here. How exactly
> would 'count > 1' be used incorrectly here? I'm fine with adding a
> comment, but I'm not sure what the comment needs to clarify.

There's no guarantee that the remaining in-progress invalidation when the count
goes from 2->1 is the same invalidation call that set range_start/range_end.

E.g. given two invalidations, A and B, the order of calls could be:

  kvm_mmu_notifier_invalidate_range_start(A)
  kvm_mmu_notifier_invalidate_range_start(B)
  kvm_mmu_notifier_invalidate_range_end(A)
  kvm_mmu_notifier_invalidate_range_end(B) <-- ???

or

  kvm_mmu_notifier_invalidate_range_start(A)
  kvm_mmu_notifier_invalidate_range_start(B)
  kvm_mmu_notifier_invalidate_range_end(B)
  kvm_mmu_notifier_invalidate_range_end(A) <-- ???

In the first case, "A" is in-progress when the count goes 2->1, in the second
case "B" is still in-progress.  Checking for "count > 1" in the consumer instead
of handling it in the producer (as you did) would lead to the consumer checking
against the wrong range.  I don't see a way to solve that without adding some
amount of history, which I agree is unnecessary.
