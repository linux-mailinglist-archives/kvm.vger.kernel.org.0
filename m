Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93EF230E15F
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 18:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhBCRrX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 12:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbhBCRrW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 12:47:22 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F87C061573
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 09:46:42 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id f6so192199ioz.5
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 09:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dzh6Szd68SNbk4V2VI6tuXFXXPHzJoleMwdVCBlnvgU=;
        b=Jq3Efsv/7vUYP40QeFUNejML2XmCm9ySZisia3boixp+rou/miUrGoX/23QXEWY0nq
         fa+/HUz8/GxIjLWgJ+7Ip8Dr4izCHXA+VweL82YBSfJtrgWLN+TFKcyfA0vwsZBukONS
         icmxX8a5Pzfc29plYqUHYjETk5jrtgfn8yTwdV2ugRP27y359nQUq4JSJMbqzHp82OsL
         N8cHdX3Xyh2dFeUQLNiUIBXfyfqIWBMi1SOL0D/RYg9HpqMbonAudeOlGYL27a4v7bOD
         RZ7RJbC/wCT5FD8bOwmdpq3MXPtW2cRZofasFD6hDLsxxNeenLYeFI0C7Vb70lFFtp4+
         hlNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dzh6Szd68SNbk4V2VI6tuXFXXPHzJoleMwdVCBlnvgU=;
        b=JRK9bCNbOjsXJxy7YlnEU3Znl2SVbi9M8TuLKLwohNRs9gQROV2IY8uKoTq95KH7iL
         vHsa2TXTOr7OAuKdTL6y5dN8cNN3vXFu4/cXhAXk7r1Ep1aHBL09/F6+QQN/8nxbKuzv
         rjJVVa3FaeFgwbSs9hh2CSIZdqjGXGsHZ5IIzXExPcrkqeZVezUXDw1FIk2zlGGC1Qyu
         0lG7ePNsKovk3p19Y6qE0a6V0oWkAF2bPNUvoBdN057d0gQz515PGlJIkQTv/Jjhr0Fe
         ZkYCpvo//sfpfo0yIIxcbjS6rXKyChqcAaSHo3s9YIBkOU4u+nRuwTw0LzY8ZGS9BrlF
         cqdg==
X-Gm-Message-State: AOAM530dz2qax0+Ab0knkXQp493BSrgdNWPMni8PRb+K7M/AY9c4Pk2E
        QSpjQXaqPD0gZY77Jhf+ERlQ189zvwuNFU7pq08Wag==
X-Google-Smtp-Source: ABdhPJwV/n6GtQBrLYdwdPxlhTaz5T6VrhI384pIUPj4Jh0GcYlZaFZ7DFmw2DUegateQtjgMHdC8NnmowO56cg8ZHE=
X-Received: by 2002:a5d:8155:: with SMTP id f21mr3440813ioo.9.1612374401592;
 Wed, 03 Feb 2021 09:46:41 -0800 (PST)
MIME-Version: 1.0
References: <20210202185734.1680553-1-bgardon@google.com> <20210202185734.1680553-24-bgardon@google.com>
 <d2c4ae90-1e60-23ed-4bda-24cf88db04c9@redhat.com>
In-Reply-To: <d2c4ae90-1e60-23ed-4bda-24cf88db04c9@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 3 Feb 2021 09:46:30 -0800
Message-ID: <CANgfPd-ELyPrn5z0N+o8R6Ci=O25XF+EDU-HDGgvVXGV7uF-dQ@mail.gmail.com>
Subject: Re: [PATCH v2 23/28] KVM: x86/mmu: Allow parallel page faults for the
 TDP MMU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
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

On Wed, Feb 3, 2021 at 4:40 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 02/02/21 19:57, Ben Gardon wrote:
> >
> > -     write_lock(&vcpu->kvm->mmu_lock);
> > +
> > +     if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
> > +             read_lock(&vcpu->kvm->mmu_lock);
> > +     else
> > +             write_lock(&vcpu->kvm->mmu_lock);
> > +
>
> I'd like to make this into two helper functions, but I'm not sure about
> the naming:
>
> - kvm_mmu_read_lock_for_root/kvm_mmu_read_unlock_for_root: not precise
> because it's really write-locked for shadow MMU roots
>
> - kvm_mmu_lock_for_root/kvm_mmu_unlock_for_root: not clear that TDP MMU
> operations will need to operate in shared-lock mode
>
> I prefer the first because at least it's the conservative option, but
> I'm open to other opinions and suggestions.
>
> Paolo
>

Of the above two options, I like the second one, though I'd be happy
with either. I agree the first is more conservative, in that it's
clear the MMU lock could be shared. It feels a little misleading,
though to have read in the name of the function but then acquire the
write lock, especially since there's code below that which expects the
write lock. I don't know of a good way to abstract this into a helper
without some comments to make it clear what's going on, but maybe
there's a slightly more open-coded compromise:
if (!kvm_mmu_read_lock_for_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
         write_lock(&vcpu->kvm->mmu_lock);
or
enum kvm_mmu_lock_mode lock_mode =
get_mmu_lock_mode_for_root(vcpu->kvm, vcpu->arch.mmu->root_hpa);
....
kvm_mmu_lock_for_mode(lock_mode);

Not sure if either of those are actually clearer, but the latter
trends in the direction the RCF took, having an enum to capture
read/write and whether or not yo yield in a lock mode parameter.
