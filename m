Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD42745ACED
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 20:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240079AbhKWUBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 15:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239618AbhKWUBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 15:01:39 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D1C8C061574
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 11:58:31 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id f9so110526ioo.11
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 11:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gzkHFWCeJ5B0HVtGojsjqbGpQYRfubbgVYpeWL+4Wf4=;
        b=QcEWH5gQ3keGnFBHuTq11/AVEIGGI3PUY29+an7xWGSG0yhl4PFxoJ6e9Ybw2rFGbh
         ak+7FM/GTuM9npHLorAY/fGa6GqVe4eURzonq4MRTJbBKA4kVmXCy/fxf0Kgwx7lsjN5
         vh/swCRkJSHFmW9DRGlr9FcN33dviD3cXCfNXm4/aomy/yiW8vp6HUjhWZiLhj8/+Mm1
         CX705eYfzgIrYvI0SDpG2Ib/sfMP4BMFfhldFznJBL3d0GcFxu0NyopyM6Rb75Dz5qMp
         XsY8KALIxxSHv7/+5KmLsPi0GdEf71KDED4W+vI4n4NRunhlZvf1Yl/X29sPo/onA7GR
         T0yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gzkHFWCeJ5B0HVtGojsjqbGpQYRfubbgVYpeWL+4Wf4=;
        b=MSmuWEGhMuyf/10cnG0oBqSo2Msg1eXDJWJgFCNrt2ijJKsjGQE2y57muEjyepVmUe
         ChdFz4PQQipN0bQah9wdMJtZLT3fkMBbUu61iwRFApLXxQpTMfhWW38uh+K3ccZ3Jm4O
         RW+qA7sTOF+VPW9bRYxymKob9dESua3e2AlqH6LXq5rvPYf1s+q1HuMVOwunHi2mqYI/
         SnjToQbmzfKSF4TiIOcGb9I49pZjPxTbmKeAdn8RjqO1eBTg83OpGFzzUrsp6nEhIPws
         kmxylmhR3Dwvc3+ZzpTUVQkXGFUqzTIis0Fov8Jbww/drVUDpdt7st75xtV2IVFUZFSa
         XuQQ==
X-Gm-Message-State: AOAM532WRJW6vhHwMWDomdKuHHpIS/8R17U3AkLZ41Xah8vsJsSo3etR
        shyPizm+TlQoWnZ34CXozz6mD5IP3WFURmW+8TIrfw==
X-Google-Smtp-Source: ABdhPJy5P0sr4ayilFNItLf0ekqsSE3fZ9eCTEk9wA1SVD8rSOpPakRE9oiR1+L8xMg/MZaIyota8Yu1T98NEinCbao=
X-Received: by 2002:a5d:9493:: with SMTP id v19mr8150597ioj.34.1637697510750;
 Tue, 23 Nov 2021 11:58:30 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com> <20211120045046.3940942-28-seanjc@google.com>
In-Reply-To: <20211120045046.3940942-28-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 23 Nov 2021 11:58:19 -0800
Message-ID: <CANgfPd-MNnx0GVZCHcDYUyx5kqAQSr=s_QGr8zDyw8Wnz0devQ@mail.gmail.com>
Subject: Re: [PATCH 27/28] KVM: x86/mmu: Do remote TLB flush before dropping
 RCU in TDP MMU resched
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021 at 8:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> When yielding in the TDP MMU iterator, service any pending TLB flush
> before  dropping RCU protections in anticipation of using the callers RCU
> "lock" as a proxy for vCPUs in the guest.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 79a52717916c..55c16680b927 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -732,11 +732,11 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
>                 return false;
>
>         if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
> -               rcu_read_unlock();
> -
>                 if (flush)
>                         kvm_flush_remote_tlbs(kvm);
>
> +               rcu_read_unlock();
> +

Just to check my understanding:
Theoretically PT memory could be freed as soon as we release the RCU
lock, if this is the only thread in a read critical section. In order
to ensure that we can use RCU as a proxy for TLB flushes we need to
flush the TLBs while still holding the RCU read lock. Without this
change (and with the next one) we could wind up in a situation where
we drop the RCU read lock, then the RCU callback runs and frees the
memory, and then the guest does a lookup through the paging structure
caches and we get a use-after-free bug. By flushing in an RCU critical
section, we ensure that the TLBs will have been flushed by the time
the RCU callback runs to free the memory. Clever!

>                 if (shared)
>                         cond_resched_rwlock_read(&kvm->mmu_lock);
>                 else
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
