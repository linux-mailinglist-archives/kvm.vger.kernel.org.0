Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0082C3B2203
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 22:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhFWUuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 16:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhFWUuX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 16:50:23 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE33C061756
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 13:48:04 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id f10so1817480plg.0
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 13:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KPQttoS4IMq2aybrhdSAm6wEH6LRGO37mRcOcCH2GA8=;
        b=rVe8KpaPY6kuM41sXjMWkWWA8fPUg7oZ5+RvsxBdHwA2VILv0xeGl+zEVx6WWIqYB2
         b8W3o+cQbjq/CkIkuSvSoppk9qaxXQ3n6wivXVRhiULHDlnUUbnvzACC8Hzeu344fmCe
         +MRYbs7TXP1gO/WcFMG4gkeDal78jioeE/CKgLPs7axUTDDkXGJ4OEhHk3Y6TYqhkA35
         BMNjGZzUsjtVfNQ/F/imdW+cPbNqGRkYzxnoquOEDzpJvXLh00fl51wuI2Z4Hqm4JOpz
         UMK39lBFhtyhPnOIHJelnWA8ESS7YencEm3AIAv6HvDumgirDhpf2PiqI8xH3ChuNPRq
         5x9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KPQttoS4IMq2aybrhdSAm6wEH6LRGO37mRcOcCH2GA8=;
        b=LX3tP5Qx3ATwkn4rW62WNfXCRJ3AsR7kOUTPgOJ+96iPv3jrUiFrMRgQTar/VSfRKj
         dFt+Fm9QBcCfvLHEQYRAbYkfTMYofyyPhtWi9PH0MlQILJRa9ZpU8qXQnoj8KxE/kGfo
         22RTNnjYw6bgR6yCE8sERRxerpnKwNOXHnMc6V4UnYvb9gx63xhgSbm6xZPX6xIJuohd
         6jchYQ3ZaSbREtoBPEW5etRP5PlnZd2CqUTry3zx9q4ziTOTxq41eNBFHOUeq1HAXlmI
         XcE1S5uuytdOgpm1EEXTl94IIh4hAGD5MgaToHW1LPu2pUoD4OsFiGtWCBIn6FuE9l+3
         XDrg==
X-Gm-Message-State: AOAM532iNRKexyaGiVlaXFY4zpu74wpXxoFWZ8K2Zqe3ME0TW2kqVVxl
        FJdb9ql6YHijpst3WHJvAcRA9g==
X-Google-Smtp-Source: ABdhPJzfKt5rhw5CZw6QaYPIr2PW/BBph0kOlQHC2t7P/nr5KdNQk+VU29QNNta8gNtKaLlWXe4Haw==
X-Received: by 2002:a17:90a:7381:: with SMTP id j1mr11247671pjg.29.1624481284023;
        Wed, 23 Jun 2021 13:48:04 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q18sm25708pgj.8.2021.06.23.13.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 13:48:03 -0700 (PDT)
Date:   Wed, 23 Jun 2021 20:47:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 25/54] KVM: x86/mmu: Add helpers to query mmu_role bits
Message-ID: <YNOd/0RxSnqmDBvd@google.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-26-seanjc@google.com>
 <1babfd1c-bee1-12e5-a9d9-9507891efdfd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1babfd1c-bee1-12e5-a9d9-9507891efdfd@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23, 2021, Paolo Bonzini wrote:
> On 22/06/21 19:57, Sean Christopherson wrote:
> > +static inline bool is_##reg##_##name(struct kvm_mmu *mmu)	\
> 
> What do you think about calling these is_mmu_##name?  The point of having
> these helpers is that the register doesn't count, and they return the
> effective value (e.g. false in most EPT cases).

I strongly prefer to keep <reg> in the name, both to match the mmu_role bits and
to make it a bit more clear that it's reflective (modified) register state, as
opposed to PTEs or even something else entirely.  E.g. I always struggled to
remember the purpose of mmu->nx flag.

I wouldn't be opposed to is_mmu_##reg##_##name() though.  I omitted the "mmu"
part because it was loosely implied by the "struct kvm_mmu" param, and to keep
line lengths short.  But being explicit is usually a good thing, and looking at
the code I don't see any lines that would wrap if "mmu" were added.

> > +{								\
> > +	return !!(mmu->mmu_role. base_or_ext . reg##_##name);	\
> > +}
> > +BUILD_MMU_ROLE_ACCESSOR(ext,  cr0, pg);
> > +BUILD_MMU_ROLE_ACCESSOR(base, cr0, wp);
> > +BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pse);
> > +BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pae);
> > +BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smep);
> > +BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smap);
> > +BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pke);
> > +BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, la57);
> > +BUILD_MMU_ROLE_ACCESSOR(base, efer, nx);
> > +
> >   struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
> 
