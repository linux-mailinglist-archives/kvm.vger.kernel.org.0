Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2524F3DADDA
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 22:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbhG2Uk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 16:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233146AbhG2Uk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 16:40:58 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618AFC061765
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 13:40:54 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id j1so11982208pjv.3
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 13:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jWa/gItRDp22hlKSvMJuEd/U3UQ52bV7L3SE7KcUcbo=;
        b=ebNEzb91974Wu9o3Wf9bISdIliikatv0/hBdlDVfuw6/MzcUHtNAKUFPZnNjhDbkLZ
         5wo3s/oYc5vD1p8Cqn0mPJsBOqNzRZ4issiPLWQGKEKLzuB1mzxQTPLI3JQLavyUxE73
         TvkZlwIfu06DvNIVLFwVNHt7r1xLsoawasw/bumcpx9g3sTZSSBvOfiOM4xvcQA7o+2R
         6ydPZfsZ/jTavLDJp5uo3CSv80L4Cu55I+HO02T2WXk+3kjQCKd7UaIJb26ajjQ8pupp
         Kxv2K1Bwuj47aevo4mADqfHXT71UjjU/uXqlIq+WeEte5lQOGmd5mjm1qszdr/6LuF5V
         TsfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jWa/gItRDp22hlKSvMJuEd/U3UQ52bV7L3SE7KcUcbo=;
        b=pPWSdGWHtAxBTq9KqVF8y3X50pRHqirKJEjIvn2Y7hEixh1JuTC7bg2RZ6ihi4uS+I
         nUvyOPP7iojeNzbJ+C5mEmvLP8KMAoF/Jd+R08DfXwxO+LnRItn52c/PrW/6kyPa0gM1
         rzP1mSH6ocoKMUrl5oqHAa8OOJ1wT0bo0BnHb9HFHKgl+z3VZxtL2o+jszQDgGFWEonx
         YF0jqy0dmdEUpKX7s8j/LNzxLjx//qU90wSgrD4a5xUX23ckpssgzItNPYWcBw6HFxEL
         HeOYTC37xJEO3huYFCTopZ98CzLQGbIJDCHR4hC5iFUDiVBrIuMnGq+eZOJv4e7GfibP
         nORw==
X-Gm-Message-State: AOAM531XoaxGVsZqOr4ekd8Wjin11rRtjgswab9z3AVVCJDLvjueD9zy
        kvvVusMeiZOPSaBSmjpmTJ2ZHA==
X-Google-Smtp-Source: ABdhPJzFSi4QMnRCl/6lB8rAqjQh3+Uc4cmtRn7cHk02ObMc76RhMDdvj330te8UP4yXze9wb+IkZA==
X-Received: by 2002:a17:903:230b:b029:12a:d8db:cd27 with SMTP id d11-20020a170903230bb029012ad8dbcd27mr6427408plh.42.1627591253662;
        Thu, 29 Jul 2021 13:40:53 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n12sm5176470pgr.2.2021.07.29.13.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 13:40:53 -0700 (PDT)
Date:   Thu, 29 Jul 2021 20:40:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: A question of TDP unloading.
Message-ID: <YQMSUalIaMe9/78r@google.com>
References: <20210727161957.lxevvmy37azm2h7z@linux.intel.com>
 <YQBLZ/RrBFxE4G4w@google.com>
 <20210728065605.e4ql2hzrj5fkngux@linux.intel.com>
 <20210728072514.GA375@yzhao56-desk.sh.intel.com>
 <CANgfPd_Rt3udm8mUHzX=MaXPOafkXhUt++7ACNsG1PnPiLswnw@mail.gmail.com>
 <20210728172241.aizlvj2alvxfvd43@linux.intel.com>
 <CANgfPd_o+HC80aqTQn7CA3o4rN2AFPDUp_Jxj9CQ6Rie9+yAug@mail.gmail.com>
 <20210729030056.uk644q3eeoux2qfa@linux.intel.com>
 <20210729025809.GA9585@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729025809.GA9585@yzhao56-desk.sh.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 29, 2021, Yan Zhao wrote:
> On Thu, Jul 29, 2021 at 11:00:56AM +0800, Yu Zhang wrote:
> > > 
> > > Ooof that's a lot of resets, though if there are only a handful of
> > > pages mapped, it might not be a noticeable performance impact. I think
> > > it'd be worth collecting some performance data to quantify the impact.
> > 
> > Yes. Too many reset will definitely hurt the performance, though I did not see
> > obvious delay.
> >
> 
> if I add below limits before unloading mmu, and with
> enable_unrestricted_guest=0, the boot time can be reduced to 31 secs
> from more than 5 minutes. 
> 
>  void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
>  {
> -       kvm_mmu_unload(vcpu);
> -       kvm_init_mmu(vcpu, true);
> +       union kvm_mmu_role new_role =
> +               kvm_calc_tdp_mmu_root_page_role(vcpu, false);
> +       struct kvm_mmu *context = &vcpu->arch.root_mmu;
> +       bool reset = false;
> +
> +       if (new_role.as_u64 != context->mmu_role.as_u64) {

Aha!  A clue!

This hack indicates that the call to kvm_mmu_reset_context() is spurious, i.e.
none of the MMU role bits in CR0/CR4/EFER are changing.  Dollars to donuts says
this is due to the long-standing hack-a-fix in enter_rmode() that unconditionally
reset the MMU when the guest entered real mode.

Prior to commit 5babbb43a58a ("KVM: VMX: Remove explicit MMU reset in enter_rmode()").
(sitting in kvm/queue), enter_rmode() to deal with unrestricted_guest=0 would
unconditionally do kvm_mmu_reset_context().  Based on the above, it sounds like
your guest is going in and out of RM/PM, i.e. toggling CR0.PE.  CR0.PE isn't a
MMU role bit, so the kvm_mmu_reset_context() is spurious unless CR0.PG is also
being changed.

TL;DR: Try the current kvm/queue, or at least after commit 5babbb43a58a
       ("KVM: VMX: Remove explicit MMU reset in enter_rmode()").

> +               kvm_mmu_unload(vcpu);
> +               reset = true;
> +       }
> +       kvm_init_mmu(vcpu, reset);
> 
> But with enable_unrestricted_guest=0, if I further modify the limits to
> "if (new_role.base.word != context->mmu_role.base.word)", the VM would
> fail to boot.
> so, with mmu extended role changes, unload the mmu is necessary in some
> situation, or at least we need to zap related sptes.
> 
> Thanks
> Yan
