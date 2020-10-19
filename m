Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C0D292C57
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 19:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730687AbgJSRHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 13:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730498AbgJSRHt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Oct 2020 13:07:49 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E033C0613D0
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 10:07:49 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id k25so480255ioh.7
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 10:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HZILooKL2gY95V+6lOTyR2vnqSZKR9zVUyigLpIo2P4=;
        b=h4KCavmCnbr2GfebRzkZm4hUgsAoh0GHrDdPOH7uIzzR7wdYBc3pyvPs87fKOawa9A
         UDdZ5LMgksk8Vu+ujzkuGXpnW1sWlHXY/fb49M1f4Bdj8S5rl0dblZkgsRI5luuDfXbb
         XVID4xs1kkNcHFi5lJL5g1lwdBxhU3npBKrKFG1UU++toiDz/RhKnKXWMCmWhDu3xPQh
         u+gf/hGRkjQkbmDQmUUKmHkrE0UGP6a/qzir40lEjlVx07GOMj03B8Xhn9oGhfY+UtHG
         s6hF0574jV6PsM1kftclcJ4t8+NB2PHM0vbnVhShCiTmsGllZCejZIXovLqRw5fhlxre
         w1jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HZILooKL2gY95V+6lOTyR2vnqSZKR9zVUyigLpIo2P4=;
        b=UZ3U4qqQ3moE5YWRP1Nrf9qFl6HhBMgdAd5IfhzBe7U4A71CB4T0akhrcZiXWFJKs0
         vBrrPQVXcT2HckalcG1ZCjY9PojvfFkfigPzP1cOatkxyEm/OBQHkofuX15jYWs3zI7g
         qnuBOE6MNlkJyKub+5LrqhpBtMrXqfPbntI19H7xkjCBh39FlyEj1UBywj1kcGWsrrXj
         4bb41KW53XqtRREe1W1X5fbHSxOvua7IQkuOB0khK52Qbvnwgu8QOqD2krVE9mTpowUZ
         +kpnD+8oWX5d0YFzmbkB0xfLmKbsp7BNO+v4iPWisE/6YTCx+bgC/sB3WVCGBfUewAqA
         7EYQ==
X-Gm-Message-State: AOAM531Ff3k+Za/o6pT4rcy8oHeaYeUrgLTum1v3ROj67oGHR4McdKZ6
        gZQBMBXrua7SI9mE1wHHeNJ14uKSLnZL7Qrg+E3ZNg==
X-Google-Smtp-Source: ABdhPJzVMNAArce2/8Z1JgWeVuh1/9OKn71TGqBBKGtluXLV5A5t1fmht/Tb7yHi3S6l+S66FHZFhVSRJ8jRtMDU4pI=
X-Received: by 2002:a6b:1646:: with SMTP id 67mr309841iow.189.1603127268427;
 Mon, 19 Oct 2020 10:07:48 -0700 (PDT)
MIME-Version: 1.0
References: <20201014182700.2888246-1-bgardon@google.com> <20201014182700.2888246-16-bgardon@google.com>
 <f5e558b2-dab8-ca9e-6870-0c69d683703a@redhat.com>
In-Reply-To: <f5e558b2-dab8-ca9e-6870-0c69d683703a@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 19 Oct 2020 10:07:37 -0700
Message-ID: <CANgfPd9UgKK6tr9ArQsDB9ys4Ne=RVkDccY_Za4r4SSHWV46cQ@mail.gmail.com>
Subject: Re: [PATCH v2 15/20] kvm: x86/mmu: Support dirty logging for the TDP MMU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
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

On Fri, Oct 16, 2020 at 9:18 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 14/10/20 20:26, Ben Gardon wrote:
> >
> > +     if (kvm->arch.tdp_mmu_enabled)
> > +             kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
> > +                             slot->base_gfn + gfn_offset, mask, true);
>
> This was "false" in v1, I need --verbose for this change. :)

I don't think this changed from v1. Note that there are two callers in
mmu.c - kvm_mmu_write_protect_pt_masked and
kvm_mmu_clear_dirty_pt_masked. One calls with wrprot = true and the
other with wrprot = false.

>
> >       while (mask) {
> >               rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
>
> > +             spte_set = wrprot_gfn_range(kvm, root, slot->base_gfn,
> > +                             slot->base_gfn + slot->npages, min_level) ||
> > +                        spte_set;
>
> A few remaining instances of ||.

Gah, I thought I had gotten all of them. Thanks for catching these.

>
> Paolo
>
