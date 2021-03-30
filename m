Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF5034F1E2
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 21:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbhC3T6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 15:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbhC3T6Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 15:58:25 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139BFC061764
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 12:58:25 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id j25so12893436pfe.2
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 12:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wTEyxuaapP4d1SHF7RcerzFayP475kgkIctZEDORCvY=;
        b=envgQwKOhZLGzYbrjTo3+nEI/ILCJz7AV2GNZ37sA4tCFJ/jO9jwiK5voJwg3r/eds
         n/zOAXzsVLcOacfLuS5VHUc/Z+MqB19zQ52tsRetZLD7hBDRRdqbtww6YeIzEisRIyMw
         UnfTrppUFQicAdk3Yb3QZQbrg/qIsNA3dGPVEIftHW0s1SOq7Hgyee3Ke9l4JB7cfcim
         WfxyAvKImmJ2KZPyBj2tHvhaebrjJjZxU5509A9Ch4WA/EkIVJwDkd6/BmVOdrShBU9j
         tfeAKC2/dsPTX8UPAidLNUSrGVz0OIl962YLH0QZ9VroDrpQvyJk5f+1O5KmnTp/LVWY
         h0QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wTEyxuaapP4d1SHF7RcerzFayP475kgkIctZEDORCvY=;
        b=BElnTehYQFW8zPwoK2oxvVLhnUHQtCxssIM6r65RAZAZnxT8f7xP2ChzAbHEsYZRJp
         FJsyLhAgTasVMZ85k3ncWgwri9OofyOiI3W01UCaJ4kAiLi2fRUOuCd6T7aszGroBnTF
         mYd723DipPMCnKBo4PWH21k2CQFed0zl+6em2HdNNxW4bJjrnwCFN1aDQbpUUmcAhvg/
         PQHyCPg4v5Xcsq8HoNwJOBPOSDk0isJHL85vLigHqtO5bQ8McVWHAycPNswFPJvYBvOT
         PXp3MRgobDhNhyqwU9RrgOdfQJwYnJvVcPSqXHMB7ggrXVkkj124MIvp5BsTEDoZJdCW
         cJUg==
X-Gm-Message-State: AOAM5333izY6EkgNH39vsErDJAc51YWhxlRTEza1tHZ5qcI2r9DCARUc
        /lUxEtCG2hmu3IjwmHhAhx3J+w==
X-Google-Smtp-Source: ABdhPJy/H3xYrm77zteXXmXwOlrnRIg3rQpdyEYIba7syOVncG/8FqBI2t2hNnALYH3MbklxzEVjZA==
X-Received: by 2002:a63:5361:: with SMTP id t33mr29952003pgl.439.1617134304318;
        Tue, 30 Mar 2021 12:58:24 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id f16sm10723866pfj.220.2021.03.30.12.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 12:58:23 -0700 (PDT)
Date:   Tue, 30 Mar 2021 19:58:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        kvm-ppc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/18] KVM: Consolidate and optimize MMU notifiers
Message-ID: <YGOC2wqn5k9WkY39@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <CANgfPd_gpWsa4F3VdcpoBYqPR4dSBWNYCW1YdeOnu1wQdUz+0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd_gpWsa4F3VdcpoBYqPR4dSBWNYCW1YdeOnu1wQdUz+0A@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 30, 2021, Ben Gardon wrote:
> On Thu, Mar 25, 2021 at 7:20 PM Sean Christopherson <seanjc@google.com> wrote:
> > Patch 10 moves x86's memslot walkers into common KVM.  I chose x86 purely
> > because I could actually test it.  All architectures use nearly identical
> > code, so I don't think it actually matters in the end.
> 
> I'm still reviewing 10 and 14-18. 10 is a huge change and the diff is
> pretty hard to parse.

Ya :-/  I don't see an easy way to break it up without creating a massive diff,
e.g. it could be staged in x86 and moved to common, but I don't think that would
fundamentally change the diff.  Although I admittedly didn't spend _that_ much
time thinking about how to break it up.

> > Patches 11-13 move arm64, MIPS, and PPC to the new APIs.
> >
> > Patch 14 yanks out the old APIs.
> >
> > Patch 15 adds the mmu_lock elision, but only for unpaired notifications.
> 
> Reading through all this code and considering the changes I'm
> preparing for the TDP MMU have me wondering if it might help to have a
> more general purpose MMU lock context struct which could be embedded
> in the structs added in this patch. I'm thinking something like:
> enum kvm_mmu_lock_mode {
>     KVM_MMU_LOCK_NONE,
>     KVM_MMU_LOCK_READ,
>     KVM_MMU_LOCK_WRITE,
> };
> 
> struct kvm_mmu_lock_context {
>     enum kvm_mmu_lock_mode lock_mode;
>     bool can_block;
>     bool can_yield;

Not that it matters right now, but can_block and can_yield are the same thing.
I considered s/can_yield/can_block to make it all consistent, but that felt like
unnecessary thrash.

>     bool flush;

Drat.  This made me realize that the 'struct kvm_gfn_range' passed to arch code
isn't tagged 'const'.  I thought I had done that, but obviously not.

Anyways, what I was going to say before that realization is that the downside to
putting flush into kvm_gfn_range is that it would have to lose its 'const'
qualifier.  That's all a moot point if it's not easily constified though.

Const aside, my gut reaction is that it will probably be cleaner to keep the
flush stuff in arch code, separate from the kvm_gfn_range passed in by common
KVM.  Looping 'flush' back into the helpers is x86 specific at this point, and
AFAICT that's not likely to change any time soon.

For rwlock support, if we get to the point where kvm_age_gfn() and/or
kvm_test_age_gfn() can take mmu_lock for read, then it definitely makes sense to
track locking in kvm_gfn_range, assuming it isn't the sole entity that prevents
consifying kvm_range_range.

> };
> 
> This could yield some grossly long lines, but it would also have
> potential to unify a bunch of ad-hoc handling.
> The above struct could also fit into a single byte, so it'd be pretty
> easy to pass it around.
