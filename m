Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2857963B61F
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 00:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234785AbiK1Xt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 18:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiK1Xt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 18:49:26 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAB62872B
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 15:49:23 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id w15-20020a17090a380f00b0021873113cb4so11726440pjb.0
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 15:49:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=58wLbXZQqSCYCg7xOlR8lAwt7cU3HWV7an3QPAF/aSM=;
        b=V4B8cV49OnyUFCKxirfutkS1FWLot5o98FEE7gocZSgtTylMRh9bB7f8k4+7V/+IEw
         b21NSnkAfwsPcR8rSgl1q/PM9RoO2MnnEiEeoCfk6sPvXAQwc0N6U/tj2NJqLXuP+q6/
         hFGjUTeJNjHe7m9UAMZChUNJ+6NXq4ql9YSG3TqWDCbZNheTVZk1s0JGgeQS/DW4buyg
         5Ey0SXZadlvtR0rWaiehRDUGXxFhJUcgwPK/fjPe0U7x4n2IznvCPNLnod84A2GcCjeK
         HN+WDTghUgmMlGA115HAIuUXMJKIGeMl0xf9kf1X3OqToZ5qdcGIpxOMZzlvEbuW3+iH
         DJNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=58wLbXZQqSCYCg7xOlR8lAwt7cU3HWV7an3QPAF/aSM=;
        b=wLAAI3xFVqjjJhZAV4UVe26aFovg2nLVYD6CB/WRD8Lo89XHzTnc6Mm3VCOMS3ETQe
         lNkGSEDx56Ei9CqpXPQqJue73undPcslOrlUoRp8/aLLvEhcRmfDGHrh7vGbdrUO8Y4G
         fMfITepoCHZDhFahi2aDy4SQ2HKCNX61B7T8yEjdbOn/sTsPAy4ywnIOtVqWQDwrm0fM
         4fyoAA9IKC5j7KK6v378Lc5BZjijo6rW0H5eWLR8hv/JjwrZiyKcZ5J5jtvBQI6nm+kR
         IisKSufQGLidtQ/n1/+ZRlKbjtRKHIkGjq9omPYXBMK7HqDFJ0lmxSkdJHHb/zoKhE5A
         yfqA==
X-Gm-Message-State: ANoB5plNEDO7biX68BgZAQOuYbLz0MzZrKOEeANhyDI2AuP9oQJ6tDw/
        RvY3d3q1djWPSEcsi8qOKpLJ+Q==
X-Google-Smtp-Source: AA0mqf4VO9eAEZiHJ6+DrNZcAiIfTkyyefhpiaHEGVgY/dey2gslJzVQcjvIR8D5DhPM7ImWl0knIQ==
X-Received: by 2002:a17:902:bb84:b0:184:e4db:e3e with SMTP id m4-20020a170902bb8400b00184e4db0e3emr38177995pls.47.1669679362812;
        Mon, 28 Nov 2022 15:49:22 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x23-20020a170902b41700b001890cbd1ff1sm9376946plr.149.2022.11.28.15.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 15:49:22 -0800 (PST)
Date:   Mon, 28 Nov 2022 23:49:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v10 035/108] KVM: x86/mmu: Track shadow MMIO value on a
 per-VM basis
Message-ID: <Y4VI//c9cYROYV4p@google.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <f1c9996fa4f4bc71b3feee8407d247aeabb8968e.1667110240.git.isaku.yamahata@intel.com>
 <Y3wvhWyIKNzczFov@yzhao56-desk.sh.intel.com>
 <887a77acc9bf96f7c7bea519ab7ebdd27fb67985.camel@intel.com>
 <Y4AIYGGEU3BdrQgV@yzhao56-desk.sh.intel.com>
 <8e14a7732a2d873846d07c4ec467fb7c48b2307f.camel@intel.com>
 <Y4AOMo00B0vlQfIU@yzhao56-desk.sh.intel.com>
 <1ad20facd81dd346e00ff686ae4a0550123de851.camel@intel.com>
 <Y4AUrLJtk7pK082i@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4AUrLJtk7pK082i@yzhao56-desk.sh.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 25, 2022, Yan Zhao wrote:
> On Fri, Nov 25, 2022 at 09:07:09AM +0800, Huang, Kai wrote:
> > On Fri, 2022-11-25 at 08:37 +0800, Yan Zhao wrote:
> > > On Fri, Nov 25, 2022 at 08:45:01AM +0800, Huang, Kai wrote:
> > > > On Fri, 2022-11-25 at 08:12 +0800, Yan Zhao wrote:
> > > > > On Fri, Nov 25, 2022 at 08:13:48AM +0800, Huang, Kai wrote:
> > > > > > On Tue, 2022-11-22 at 10:10 +0800, Yan Zhao wrote:
> > > > > > > Also make enable_mmio_caching to be a per-VM value?
> > > > > > > As if the shadow_mmio_value is 0, mmio_caching needs to be disabled.
> > > > > > 
> > > > > > If I recall correctly, Sean said we can disable TDX guests if mmio_caching is
> > > > > > disabled (we also will need to change to allow enable_mmio_caching to still be
> > > > > > true when mmio_value is 0).
> > > > > > 
> > > > > > SEV_ES has similar logic:
> > > > > > 
> > > > > > void __init sev_hardware_setup(void)
> > > > > > {
> > > > > > 
> > > > > > 	...
> > > > > > 
> > > > > >         /*
> > > > > >          * SEV-ES requires MMIO caching as KVM doesn't have access to the guest
> > > > > >          * instruction stream, i.e. can't emulate in response to a #NPF and
> > > > > >          * instead relies on #NPF(RSVD) being reflected into the guest as #VC
> > > > > >          * (the guest can then do a #VMGEXIT to request MMIO emulation).
> > > > > >          */
> > > > > >         if (!enable_mmio_caching)
> > > > > >                 goto out;
> > > > > > 
> > > > > 
> > > > > Would enabling mmio caching in per-VM basis be better?
> > > > > 
> > > > 
> > > > We need Paolo/Sean to decide.
> > > > 
> > > > The thing is TDX guests always require mmio_caching being enabled.  For VMX
> > > > guests, normally we will always enable mmio_caching too.  So I think per-VM
> > > > basis mmio_caching is not that useful.
> > > With per-VM basis enabling, I think we can get rid of the kvm_gfn_shared_mask(kvm)
> > > in below code and also in handle_abnormal_pfn()
> > > 
> > > static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
> > > {
> > >         return (spte & shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&
> > >                likely(enable_mmio_caching || kvm_gfn_shared_mask(kvm));
> > > }
> > > 
> > 
> > It needs to go anyway regardless per-VM mmio_caching or not, as explained we
> > need to change to allow enable_mmio_caching to be true even mmio_value is 0.

Yes, the kvm_gfn_shared_mask() in is_mmio_spte() should not exist.

> Or it's better to check enable_mmio_caching is true in
> kvm_mmu_set_mmio_spte_value() as below. 
> 
> void kvm_mmu_set_mmio_spte_value(struct kvm *kvm, u64 mmio_value)
> {
>         WARN_ON(!enable_mmio_caching);
>         kvm->arch.shadow_mmio_value = mmio_value;

Eh, if you're going to bother with that assert, capture the more subtle aspects
as well, e.g. that EPT is enabled and that shadow_mmio_mask has been set to the
expected value.  I would also ditch the helper and just open code this in TDX
code, I doubt there's a use case outside of TDX+VMX coexistence.
