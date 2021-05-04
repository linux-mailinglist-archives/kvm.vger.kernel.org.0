Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D23372EE0
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 19:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbhEDR1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 13:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbhEDR1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 13:27:13 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6626C061761
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 10:26:16 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id w3so14413109ejc.4
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 10:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rxPQs6Mc/0XgO0iPTxIWTDm1QwB91U+obNxE6TB3puk=;
        b=HSqaJrWOLagPy9VeCugMJRSqJH/RCVf4WnZv8AGdSA/g/g8gJ4ddCdfqzdjQpho/ep
         b+g8nDxDr5nXus+K6ZPidzG7zFFn2sJFMHfUXAUcv+BLUryxfHKI66wRKJmV6+2Ts51w
         QE1KVgsIh/P+qQ2Vo2nC20cGmK6aVvqR9Y6yATf6CoFsVM1OvxZNmgi6ULvdqtN2OQG3
         /a76ijrzglhwkrHfPINjg55fMOMvudZ4zQP3dBmhK6EveROGh+E2yp269tA0LgtbQW9C
         mqyfjPeQ2xfoMslqTTUQh191C7CHc0I7RYji2/7JgiFxTWnvfZI0zcOsAHqwrkl793rX
         E9Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rxPQs6Mc/0XgO0iPTxIWTDm1QwB91U+obNxE6TB3puk=;
        b=eng+4v3AVyu3WEFAqUBszKewTEFjzevynIn1Vg4lfFB2MA7bG9mT0ptkoLS9qgu6QO
         TQisQIvpaELmcTU+jsg0ucc5o+yveHo1/IfARQcLnSkoJhEkDnjBF9UAWZUaGkikEO3r
         sfxKzdx8kpCp73lNgmbx4uVXQey6+4St2KwZGm47CHxrfZ2DxIOh4mjUtquwxkOxw1J6
         Swd11vzCnwz9acbTXU7mD70Akt2+NxVoR1lLjEWJAkIOwpHbDxC31Dtqzaf31piTUED/
         ZeiufmIl1AsqdLolNzSuc03BzXOSfKgCdq3UZVblVpyY3aLsrDsRMUR4K+ql2DxV5j+h
         b0ig==
X-Gm-Message-State: AOAM532jlKaJcWX4wERAqVV4tqGq4OPyOkSwKedHIyQNcgUh8ur6pUQn
        R0iLQ2picjygfSjb8HDfo+/voJ2YUCnzJ13hIpzS/Hpmo5qbJg==
X-Google-Smtp-Source: ABdhPJyFNCokH6hoCachY2WucnKHo93RfBLcmZHm+pw764hTXNO5Lz696SFDbY3yUhOyP+Y3MBPIAfDivYvaBqO83Vo=
X-Received: by 2002:a17:906:11d4:: with SMTP id o20mr23126097eja.247.1620149175224;
 Tue, 04 May 2021 10:26:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210429211833.3361994-1-bgardon@google.com> <20210429211833.3361994-2-bgardon@google.com>
 <e9090079-2255-5a70-f909-89f6f65c12ed@redhat.com>
In-Reply-To: <e9090079-2255-5a70-f909-89f6f65c12ed@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 4 May 2021 10:26:03 -0700
Message-ID: <CANgfPd9O3d9b+WYgo+ke1Jx50=ep_f-ZC1gRqUET6PDsLxW+Gw@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] KVM: x86/mmu: Track if shadow MMU active
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 3, 2021 at 6:42 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 29/04/21 23:18, Ben Gardon wrote:
> > +void activate_shadow_mmu(struct kvm *kvm)
> > +{
> > +     kvm->arch.shadow_mmu_active = true;
> > +}
> > +
>
> I think there's no lock protecting both the write and the read side.
> Therefore this should be an smp_store_release, and all checks in
> patch 2 should be an smp_load_acquire.

That makes sense.

>
> Also, the assignments to slot->arch.rmap in patch 4 (alloc_memslot_rmap)
> should be an rcu_assign_pointer, while __gfn_to_rmap must be changed like so:
>
> +       struct kvm_rmap_head *head;
> ...
> -       return &slot->arch.rmap[level - PG_LEVEL_4K][idx];
> +       head = srcu_dereference(slot->arch.rmap[level - PG_LEVEL_4K], &kvm->srcu,
> +                                lockdep_is_held(&kvm->slots_arch_lock));
> +       return &head[idx];

I'm not sure I fully understand why this becomes necessary after patch
4. Isn't it already needed since the memslots are protected by RCU? Or
is there already a higher level rcu dereference?

__kvm_memslots already does an srcu dereference, so is there a path
where we aren't getting the slots from that function where this is
needed?

I wouldn't say that the rmaps are protected by RCU in any way that
separate from the memslots.

>
> Paolo
>
