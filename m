Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6554561EA
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 19:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhKRSFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 13:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbhKRSFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 13:05:23 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52ECC06173E
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:02:22 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so8887867pja.1
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F/aX29JhqFiyWVGDBmlPUQzn5wyWn1RYbWmxi309hXQ=;
        b=dLDlUhL5ow168T0suaa5qUj0qznT4FI0Kvp1pJZVbA6U5MqG8zkvt2V0dGhbVnoF3d
         iw8ATMy/dmp/5sYGhxyr1yY+4M3hLd+Mb7z1QeArTOOIGfFv8h3jsUmYQimnoniT0Qg9
         5vReWRUgBQ3g2tZ2V60pYHvER1CRDSwTfD6AbTIgWwZaCa/+A91r4GU0pLEIIx1yKdTk
         nUrjN9fr7tGJ+I4zAdW9+KUIMd4qEe7FkvRYzSKu78FY80CIXc2tiQ2+ICviGXBqevGU
         5yYon1Dnj5eD9Z782nk0E5NsErh+lxQaxQDLu8Ajf1/oU8i14AO9e+p68Lz3oekxCWpl
         hcIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F/aX29JhqFiyWVGDBmlPUQzn5wyWn1RYbWmxi309hXQ=;
        b=pucnn11RciV5kJkRXyD0/Eyxe5Xa1OmaZY7vr87YzlpCNZtTxtoE/ZO5NNFwmrnCOA
         BGrXrlE20CkLYIFUuzue9ywAojo2/Nvt0Iyn6LoAjWTu1yzZ/KERcQaDwK9PKtZgB43w
         fhxEoQP7vauX0+IUSjlNoZyyBt4STqOV8RlpdurZXV9zpViKr7udSK8l8RSGJjBo5i+e
         6JG8cxixQXvCFpSWalYTnazMZZCG17QVTGCCBWz+CpKEhEX7TPrSdqby4YCMiAHbsaFP
         49/1wNr8ZrwC+WQkOm1DF+L+rZNPfkaQMhmcKZ5mbQ2fktqON4g7JZ4J1+eLW3sLNRG2
         fO9w==
X-Gm-Message-State: AOAM531YwCaxDMj5mDJ3eJR/r9Ir9QZ10tecRH6GdnlKunMlKdynKNzY
        x/I+2l67WiXd2cN96Ts4auP6Wg==
X-Google-Smtp-Source: ABdhPJxtYIXOknnHt8eU9kz70UZuSvvfxYXDubUQj+PZrhnxNrUfqT1GLVQ70vZ8Vjxz+b0l/mdMLw==
X-Received: by 2002:a17:902:e544:b0:144:e3fa:3c2e with SMTP id n4-20020a170902e54400b00144e3fa3c2emr749574plf.17.1637258542157;
        Thu, 18 Nov 2021 10:02:22 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y7sm245178pge.44.2021.11.18.10.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:02:21 -0800 (PST)
Date:   Thu, 18 Nov 2021 18:02:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [RFC 11/19] KVM: x86/mmu: Factor shadow_zero_check out of
 make_spte
Message-ID: <YZaVKcFoKR4lqDIZ@google.com>
References: <20211110223010.1392399-1-bgardon@google.com>
 <20211110223010.1392399-12-bgardon@google.com>
 <YZW02M0+YzAzBF/w@google.com>
 <YZXIqAHftH4d+B9Y@google.com>
 <YZaBSf+bPc69WR1R@google.com>
 <db8a2431-8a05-bd50-dd79-74c814c71edd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db8a2431-8a05-bd50-dd79-74c814c71edd@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 18, 2021, Paolo Bonzini wrote:
> On 11/18/21 17:37, Sean Christopherson wrote:
> > > It's a bit ugly in that we'd pass both @kvm and @vcpu, so that needs some more
> > > thought, but at minimum it means there's no need to recalc the reserved bits.
> > 
> > Ok, I think my final vote is to have the reserved bits passed in, but with the
> > non-nested TDP reserved bits being computed at MMU init.
> 
> Yes, and that's also where I was getting with the idea of moving part of the
> "direct" MMU (man, naming these things is so hard) to struct kvm: split the
> per-vCPU state from the constant one and initialize the latter just once.
> Though perhaps I was putting the cart slightly before the horse.
> 
> On the topic of naming, we have a lot of things to name:
> 
> - the two MMU codebases: you Googlers are trying to grandfather "legacy" and
> "TDP" into upstream

Heh, I think that's like 99.9% me.

> but that's not a great name because the former is used also when shadowing
> EPT/NPT.  I'm thinking of standardizing on "shadow" and "TDP" (it's not
> perfect because of the 32-bit and tdp_mmu=0 cases, but it's a start).  Maybe
> even split parts of mmu.c out into shadow_mmu.c.

But shadow is flat out wrong until EPT and NPT support is ripped out of the "legacy"
MMU.

> - the two walkers (I'm quite convinced of splitting that part out of struct
> kvm_mmu and getting rid of walk_mmu/nested_mmu): that's easy, it can be
> walk01 and walk12 with "walk" pointing to one of them

I am all in favor of walk01 and walk12, the guest_mmu vs. nested_mmu confusion
is painful.

> - the two MMUs: with nested_mmu gone, root_mmu and guest_mmu are much less
> confusing and we can keep those names.

I would prefer root_mmu and nested_tdp_mmu.  guest_mmu is misleading because its
not used for all cases of sp->role.guest_mode=1, i.e. when L1 is not using TDP
then guest_mode=1 but KVM isn't using guest_mmu.
