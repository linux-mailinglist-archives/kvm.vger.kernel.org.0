Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD9B588054
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 18:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236422AbiHBQed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 12:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237804AbiHBQeb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 12:34:31 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B00F481CA
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 09:34:30 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id r14so16237991ljp.2
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 09:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=SfZoTACqO1kuVkp4wgMQFVuT+8zwCFihmXjSQbfcjAY=;
        b=rQR0qT0A80RapBIF9aQb9iwXYo5L1YHXXsvCRm+YhJdHHIkgCDYG8JteRQSm/+R0N7
         3/U47110CTA7UYkSE4hSy7eIHs866iNxI2btd3mU/c2KXH+Kod/cOtkOQf7ccKBhc7yF
         I5CFluHib48gwGjUldncFXjse7Vc0pO21BOIjMc8eA1B+hisvMa1OGnu8xiTbDRHyZzz
         BAX/539j4aIqztucsN+g1cznwXXhRComYe98ICxav1gqa9wLjZZCdwW/w0Ga1SmW9zrR
         z0OHLHpwakJDZR6Hf6JOkPDrOtRgdrKDriZ4iMidDk3sBi/AdrudxaR4/5iqR/HP26+O
         T6Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=SfZoTACqO1kuVkp4wgMQFVuT+8zwCFihmXjSQbfcjAY=;
        b=O0CtqCDSIPZsSGtfMaF4b2+U66UbQmq3asOffrnFHZcE/BZu2OuJ9vGAJbulmII+Rz
         7WForTxTYZH1Y63fkE0xg/++CM/lcPmKbqig/soD0jzYRGaJO4+/J5RSpWjo/0nGUDJ7
         i4wcyDxl2jythHJOT+syHbS1MI/fE6vhdVHKksIDApvDYZaKCLezhIQWsD1TfQzLDIck
         zs6UgKrBH9940+YoVzyaou+QMkK/FaFfmo1JbFpKtC/nVvKi7kf9UJ/MaqiRHqCxcqaK
         8OY7pdkQ1qHvVg6+fImT9sru1pPKYd2UCLpQ6Kq6Wg6E1lX7HtPPF0JCrYnBCwbklr75
         Um7g==
X-Gm-Message-State: AJIora/7Qkub4cOvHaVvsoQ5mr1mnFkdw4LF2AevUXVOxFB8UTKW1CQN
        Q/ziJnT/YDP7BmzjzAEg+ukGlraLWl26oZYYBN5ljA==
X-Google-Smtp-Source: AGRyM1s61hTPpIC+hAWV0friZVteo9oDBtFC95C9ODAe2dB3HYSdSiDEVlf0xrklPtcOoQaCROU4+1FSH1DBd9qJlNg=
X-Received: by 2002:a2e:a884:0:b0:25d:ea06:6a3f with SMTP id
 m4-20020a2ea884000000b0025dea066a3fmr6462084ljq.335.1659458068698; Tue, 02
 Aug 2022 09:34:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <d1a1da631b44f425d929767fda74c90de2d87a8d.1651774250.git.isaku.yamahata@intel.com>
 <YuhTPxZNhxFs+xjc@google.com> <YuhheIdg47zCDiNi@google.com> <29929897856941e0896954011d0ecc34@intel.com>
In-Reply-To: <29929897856941e0896954011d0ecc34@intel.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 2 Aug 2022 09:34:02 -0700
Message-ID: <CALzav=esHsBL7XL91HmqT89+VBeAhR3avSbdUWk-OScD=eoymQ@mail.gmail.com>
Subject: Re: [RFC PATCH v6 036/104] KVM: x86/mmu: Explicitly check for MMIO
 spte in fast page fault
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "erdemaktas@google.com" <erdemaktas@google.com>,
        Sagi Shahar <sagis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 1, 2022 at 6:46 PM Huang, Kai <kai.huang@intel.com> wrote:
>
> > On Mon, Aug 01, 2022, David Matlack wrote:
> > > On Thu, May 05, 2022 at 11:14:30AM -0700, isaku.yamahata@intel.com wrote:
> > > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > >
> > > > Explicitly check for an MMIO spte in the fast page fault flow.  TDX
> > > > will use a not-present entry for MMIO sptes, which can be mistaken
> > > > for an access-tracked spte since both have SPTE_SPECIAL_MASK set.
> > > >
> > > > MMIO sptes are handled in handle_mmio_page_fault for non-TDX VMs, so
> > > > this patch does not affect them.  TDX will handle MMIO emulation
> > > > through a hypercall instead.
> > > >
> > > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > ---
> > > >  arch/x86/kvm/mmu/mmu.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c index
> > > > d1c37295bb6e..4a12d862bbb6 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -3184,7 +3184,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu,
> > struct kvm_page_fault *fault)
> > > >           else
> > > >                   sptep = fast_pf_get_last_sptep(vcpu, fault->addr,
> > &spte);
> > > >
> > > > -         if (!is_shadow_present_pte(spte))
> > > > +         if (!is_shadow_present_pte(spte) || is_mmio_spte(spte))
> > >
> > > I wonder if this patch is really necessary. is_shadow_present_pte()
> > > checks if SPTE_MMU_PRESENT_MASK is set (which is bit 11, not
> > > shadow_present_mask). Do TDX VMs set bit 11 in MMIO SPTEs?
> >
> > This patch should be unnecessary, TDX's not-present SPTEs was one of my
> > motivations
> > for adding MMU_PRESENT.   Bit 11 most definitely must not be set for MMIO
> > SPTEs.
>
> As we already discussed, Isaku will drop this patch.

Ah, I missed that discussion. Can you share a link so I can catch up?
