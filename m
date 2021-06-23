Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51033B2238
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 23:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhFWVJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 17:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbhFWVJO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 17:09:14 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAE8C061756
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 14:06:55 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id s17-20020a17090a8811b029016e89654f93so4584635pjn.1
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 14:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NGOtnJRM413AW/4WzGgBLLTqbXHQ1TD22dgtA07InvY=;
        b=d+7AgKkBClG4Pi7p+1wrEXh5Vw7Ffgd5qmz+Ifmsk9unDXMJwnMadmgiOclHpqjXfQ
         kUBsjWgXXWjEa/W2Fxm6rj+GEzi1gXYks4nUyZiLqRqd5ga3B+Ee5Xq0aR7BtQIo27jm
         9BbQRI49JsfoAPU/5thquB7J164rNuol74IIAN5OWgvmS3U2tQdnkRC+R+3MZx9mNmVR
         LLI/O/1MYjYQ2gsbbT7X3MJOShiAQs3OcE8/9gzwELLe8sbbTu5/vXeoOUCncYxn5Kzj
         /Mbjkb1+zQ+iiZmr2QFRE3HciQHLuOvr7BOf/ntZp8dg83rgxas+khDXe5ereDFht2sw
         gcCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NGOtnJRM413AW/4WzGgBLLTqbXHQ1TD22dgtA07InvY=;
        b=H0FayexSoBldFEjKM2OFECuEQcyoaMdoJBnrzESBQ794O5vsGwdaUBA92+EBU70XJK
         MfPExhF95qxzTcuMwV7fWUn9JQpPMT9gKJ6mDpy4HSFtSKY1wecqqXn/pxGbNJTxLk6g
         BeDPbvhES70MwB2JN7s4CsjAQC05kfjHVxJcbkGn5GhnR/r4tIQTOH/KBpS8HAmN9c7F
         Nu8/Sxy6zOHfrPnEkm8VtH4fJyodTGEf3m21VrlPJ9pi3lFHuSXCYrIhXgoyKuR0b39z
         ETyWaX4pLV4+NDHvmDr2Q2IojrK+H3xxzBYFYbfXAnzaPw/dy63sDSHaFoVQdAtIumeH
         c0uA==
X-Gm-Message-State: AOAM532uq8LbAcficp5hEKeS04I9bqoKg56+QYT2RsujiegPwQK34Nta
        KHCSF/F7m19GYSA84PEZFX5tCA==
X-Google-Smtp-Source: ABdhPJxmcGvI6WF/6wJ4phX5MiTOXtD1weAlXETOb2PhcyTtcuAy620UrfS6qWp1nh89/XX4bqdPlQ==
X-Received: by 2002:a17:902:9a01:b029:11a:d4e:8f4 with SMTP id v1-20020a1709029a01b029011a0d4e08f4mr1271615plp.52.1624482414587;
        Wed, 23 Jun 2021 14:06:54 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 190sm46371pgd.1.2021.06.23.14.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 14:06:54 -0700 (PDT)
Date:   Wed, 23 Jun 2021 21:06:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 00/54] KVM: x86/mmu: Bug fixes and summer cleaning
Message-ID: <YNOiar3ySxs0Z3N3@google.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <b4efb3fd-9591-3153-5a64-19afb12edb2b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4efb3fd-9591-3153-5a64-19afb12edb2b@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23, 2021, Paolo Bonzini wrote:
> On 22/06/21 19:56, Sean Christopherson wrote:
> > Patch 01 is the only patch that is remotely 5.13 worthy, and even then
> > only because it's about as safe as a patch can be.  Everything else is far
> > from urgent as these bugs have existed for quite some time.
> 
> Maybe patch 54 (not sarcastic), but I agree it's not at all necessary.
> 
> This is good stuff, I made a few comments but almost all of them (all except
> the last comment on patch 9, "Unconditionally zap unsync SPs") are cosmetic
> and I can resolve them myself.

The 0-day bot also reported some warnings.  vcpu_to_role_regs() needs to be
static, the helpers are added without a user.  I liked the idea of adding the
helpers in one patch, but I can't really defend adding them without a user. :-/

   arch/x86/kvm/mmu/mmu.c:209:26: warning: no previous prototype for function 'vcpu_to_role_regs' [-Wmissing-prototypes]
   struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
                            ^
   arch/x86/kvm/mmu/mmu.c:209:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
   ^
   static
   arch/x86/kvm/mmu/mmu.c:199:1: warning: unused function '____is_cr0_wp' [-Wunused-function]
   BUILD_MMU_ROLE_REGS_ACCESSOR(cr0, wp, X86_CR0_WP);

> 
> I'd like your input on renaming is_{cr0,cr4,efer}_* to is_mmu_* (and
> possibly reduce the four underscores to two...).
> 
> If I get remarks by tomorrow, I'll get this into 5.14, otherwise consider
> everything but the first eight patches queued only for 5.15.
> 
> > I labeled the "sections" of this mess in the shortlog below.
> > 
> > P.S. Does anyone know how PKRU interacts with NPT?  I assume/hope NPT
> >       accesses, which are always "user", ignore PKRU, but the APM doesn't
> >       say a thing.  If PKRU is ignored, KVM has some fixing to do.  If PKRU
> >       isn't ignored, AMD has some fixing to do:-)
> > 
> > P.S.S. This series pulled in one patch from my vCPU RESET/INIT series,
> >         "Properly reset MMU context at vCPU RESET/INIT", as that was needed
> >         to fix a root_level bug on VMX.  My goal is to get the RESET/INIT
> >         series refreshed later this week and thoroughly bombard everyone.
> 
> Note that it won't get into 5.14 anyway, since I plan to send my first pull
> request to Linus as soon as Friday.

Good to know.  I'll still try to get it out tomorrow as I'll be on vacation
for a few weeks starting Friday, and I'm afraid I'll completely forget what's in
the series :-)
