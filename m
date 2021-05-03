Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E58371E99
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 19:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhECRa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 13:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbhECRaz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 13:30:55 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2BAC06174A
        for <kvm@vger.kernel.org>; Mon,  3 May 2021 10:30:00 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id i24so7205630edy.8
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 10:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wo+3D2WH6zYwTkILvVy6D/EkEPxtoZBBnnAY6b6btd4=;
        b=sEGX8JuBNskey+iHEkDuFkLzMsN8mdfs5ym8ZOw6mVx23SZFxzP3RgCAcoRiBr6TPy
         fytvGyD6UGsc3MctHTcM152ui5Bm8crn9r5W1WPZA+mWKXi2pt3TH1xJOtOXZpKRPsk8
         63mjaA8bNYBoXVrih6tCRGT6ZLXuoBLHgB2PZjgHBFjiP5aMjp7oG2rGmfZdxKEu/k3B
         RQHQcS2N7zee+JD0YdlADTQjfgcjupfRhR+wEiuRErmoe5zeNtc4+mPp5Clp33uOGwTU
         yNM8pcC8oRd1fZ26aiOk6u77uiwiU8PW2dbjKqSGTVMVHWxjWYsPyNIiG8x9tn+CeQFI
         byHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wo+3D2WH6zYwTkILvVy6D/EkEPxtoZBBnnAY6b6btd4=;
        b=cIj1VWuLURzfSe0VWAe6k5DrXUTn7OTiTdsxjIdRoTH7RWbW56Bg5XAAKrE7YE7Hb3
         njxvl8bGDwczodVtCXxsrSIcF+pDzvmd3M8McVi9cgMPuSutAlw4MobP3L4Xew6B4Gei
         RocMU1Fqb+RJTZlQUs/m3BqxMDwHTKiPBDq1qMq9n6SPlyqE4dqWPQhvP1szZq+HGHVG
         34GRPv7u/WDQZRn6AbrmnREwYVs45qSGOzj6sFNL7Mq/Z0yNmQ2Q1+S0I6MoGbnat6Cm
         WQnjLg3I0RtuU/d+dztOEhUOK1iCbfry5+wRbU5b005Iu404cQEKVfZdp+BJP7qxDb6H
         F8+Q==
X-Gm-Message-State: AOAM530khjauHby6muq34OGvumoBPJVYSwDAlTShGKK3uJuZOZ8qi5L1
        8cPZ9ZkTnkuaX/2/DU3X7HsjhST69AgG5TzHvSbqYA==
X-Google-Smtp-Source: ABdhPJyU5c1skKCSJwjpn4CF3EhnwaMRKedy59htKPIKzkTK643efQAWfH8HBBvmzxuv782rYPKfCxu7ar+C4333clY=
X-Received: by 2002:a50:eb47:: with SMTP id z7mr19538118edp.68.1620062998464;
 Mon, 03 May 2021 10:29:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210429211833.3361994-1-bgardon@google.com> <20210429211833.3361994-8-bgardon@google.com>
 <ad4ccd85-a5c0-b80f-f268-14ed0f82a3ad@redhat.com>
In-Reply-To: <ad4ccd85-a5c0-b80f-f268-14ed0f82a3ad@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 3 May 2021 10:29:47 -0700
Message-ID: <CANgfPd-mhu3YD_D2ne7QRiuAavKuge_CQuLwNSSKkLw0qeVoDA@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] KVM: x86/mmu: Lazily allocate memslot rmaps
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
> > +int alloc_memslots_rmaps(struct kvm *kvm, struct kvm_memslots *slots)
>
> This can be static, can't it?

Ah, yes. Absolutely.

>
> Paolo
>
> > +{
> > +     struct kvm_memory_slot *slot;
> > +     int r = 0;
> > +
> > +     kvm_for_each_memslot(slot, slots) {
> > +             r = alloc_memslot_rmap(kvm, slot, slot->npages);
> > +             if (r)
> > +                     break;
> > +     }
> > +     return r;
> > +}
> > +
>
