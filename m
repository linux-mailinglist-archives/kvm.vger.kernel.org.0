Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F049A57A298
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 17:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238065AbiGSPEy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 11:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238483AbiGSPEZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 11:04:25 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC6D4D4DA;
        Tue, 19 Jul 2022 08:04:25 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id b7-20020a17090a12c700b001f20eb82a08so1086934pjg.3;
        Tue, 19 Jul 2022 08:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eKcTqsNwSSuOFT+Ql0M87PqnleLM6znmzYu6pJpa+4k=;
        b=cdqzTRcmZWlHu0awENUx4WVU/0T2KPzbHeiEwex/6WGqXjxor+ok9Oh4LEHMTTHf5X
         6r1awrZkZ1kuubEtdJBf3eVG5Fin1dGl32sDGHfEGGdrCkdwEs5HJI7X40cGJnyO1tp0
         VXrEkqNN568KMpWUA0/RRLzW5zXdZw0Ga2GdPXbJql8169LZsihqpCc+/YOw2cW5Rf4T
         NQfWJByZ0OxlRHMIx5udImECCrIWip0Q4HkaRberO+JILq/B9/2Gvswu1zXBtcrqj9V0
         4L8Loib19W8P8m2I8lHn2VXRX2jIlcM/mGmWQ0Nq6pCRPUDQa+mPsUA1fh2OZniteCoY
         Xhww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eKcTqsNwSSuOFT+Ql0M87PqnleLM6znmzYu6pJpa+4k=;
        b=isjClFA43pdo2YWvg08Zu8pDYUrE+ZZfEQ/Gf4VvszI4c+MbEd7BPJ7b968D4U9j6p
         ORa7dd+h6VxVuv3G5cForgPbEM0ScnEWP+GlfevT5Yc2yqfvfPAYeCxSA0EyYdTUNkw1
         6HFViv1zKOjE1gtnECFaQXKj90fk+mSGuUBfEPkFTwVQuIdWh+L1TucWHnwKZBo/mltX
         7BkKhCkSKVXLwkHoxsQMLp4nQ/YxFvBfIp4XXxkvaT+4MslCdPCdPb6ArA+0v+ruvO4s
         tTTuax1uoYth7HYmqjmr+ZzS5fPNvgGqMrnbFM1PYRjVxT44pLAOzR5sIeYdw4YFt+xS
         CRFw==
X-Gm-Message-State: AJIora+GMwLmJxr2m3apBmlUz3ZpvsFIFsNcPtIApO7ezlMkpe3qXjv4
        lbH18JZgsYLWNWETJjSVjJA=
X-Google-Smtp-Source: AGRyM1sIE9BeEHBGrgdRgrrSUVEulxTzOUymGx3HCMMvuSO9M14eFrp3rV0/MEqRxs6lQy0n541HZg==
X-Received: by 2002:a17:902:e84e:b0:16b:f773:4692 with SMTP id t14-20020a170902e84e00b0016bf7734692mr33531902plg.19.1658243064426;
        Tue, 19 Jul 2022 08:04:24 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id j20-20020a170902759400b00161ccdc172dsm11726149pll.300.2022.07.19.08.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 08:04:23 -0700 (PDT)
Date:   Tue, 19 Jul 2022 08:04:22 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 043/102] KVM: x86/mmu: Focibly use TDP MMU for TDX
Message-ID: <20220719150422.GY1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <c198d2be26aa9a041176826cf86b51a337427783.1656366338.git.isaku.yamahata@intel.com>
 <Ysw6HdGSIECkP5RC@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ysw6HdGSIECkP5RC@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 11, 2022 at 02:56:29PM +0000,
Sean Christopherson <seanjc@google.com> wrote:

> s/Focibly/Forcibly, but that's a moot point because KVM shouldn't override the
> the module param.  KVM should instead _require_ the TDP MMU to be enabled.  E.g.
> if userspace disables the TDP MMU to workaround a fatal bug, then forcing the TDP
> MMU may silently expose KVM to said bug.
> 
> And overriding tdp_enabled is just mind-boggling broken, all of the SPTE masks
> will be wrong.
> 
> On Mon, Jun 27, 2022, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > In this patch series, TDX supports only TDP MMU and doesn't support legacy
> > MMU.  Forcibly use TDP MMU for TDX irrelevant of kernel parameter to
> > disable TDP MMU.
> 
> Do not refer to the "patch series", instead phrase the statement with respect to
> what KVM support.
> 
>   Require the TDP MMU for TDX guests, the so called "shadow" MMU does not
>   support mapping guest private memory, i.e. does not support Secure-EPT.

Thanks for rewrite of the commit message.  Now the TDP MMU is default, I'll change

> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 82f1bfac7ee6..7eb41b176d1e 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -18,8 +18,13 @@ int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
> >  {
> >  	struct workqueue_struct *wq;
> >  
> > -	if (!tdp_enabled || !READ_ONCE(tdp_mmu_enabled))
> > -		return 0;
> > +	/*
> > +	 *  Because TDX supports only TDP MMU, forcibly use TDP MMU in the case
> > +	 *  of TDX.
> > +	 */
> > +	if (kvm->arch.vm_type != KVM_X86_TDX_VM &&
> > +		(!tdp_enabled || !READ_ONCE(tdp_mmu_enabled)))
> > +		return false;
> 
> Yeah, no.
> 
> 	if (!tdp_enabled || !READ_ONCE(tdp_mmu_enabled))
> 		return kvm->arch.vm_type == KVM_X86_TDX_VM ? -EINVAL : 0;

I'll use -EOPNOTSUPP instead of -EINVAL.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
