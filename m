Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7384C58745F
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 01:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbiHAX2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 19:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234201AbiHAX17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 19:27:59 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFBC2180B
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 16:27:56 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id t2so11871963ply.2
        for <kvm@vger.kernel.org>; Mon, 01 Aug 2022 16:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=/tTorCEzOmnUDzNhkZIciJ+wzNRg3nenVtbBYRc4+HY=;
        b=HLSxTUhjIGSoKgrpJTvEe2BSJUu8HkdegkhTgKCCzrprkf+z0kAg6VZmfFraeURLHp
         Q9yAx517aQZdg3uE6aHTtphBlf2HbSaoAu7IplrVUxdjdcr6ZlUbngoqSDy38iIIyipJ
         MIKZ171KgXMpKG0Wr6UtTfpvvdhUOgTNY8Sb4EZvT3T6CtC5cRGlv65e44FVKB1IJ5h1
         FhwhGKcXEsMnZvo3/RI18OVks1epLPGjShn145SqTrgm585AVZrDCmX4xu47TJp+4F2P
         XWnbH4Lg+yOehCBTVKDZesa+l1440fhkxKJ6OdxdPkA3fHtsoJyyVmgcNJveE0fm5QDp
         bmkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=/tTorCEzOmnUDzNhkZIciJ+wzNRg3nenVtbBYRc4+HY=;
        b=WEWOvZn5I6Cnrx7LO/0GTsvzWt7RyPw3Dfk9vgxi8bSW8KqnwqJZJPnHqdvzjazZUl
         RKbj7hChmuQoIYaVOBJGa3eeuTBMvsdkMtBvOxzMBT+DLAf92T3VEZdPSMwr21PdKzUa
         9aJwUqM0XZkv+Lo1XkPE+V19SGxq+rMAf3sMHO8aeW08keL4TtFlyNdZAkewsUTbzmHM
         urztSsvFEiENQDH+Vme1SB0bjdE0K49prArV9Vbj7aUI45+m+/vwWAIH4SWfhOtElPgz
         QOqqsUZx3bV2RlJS/SlpsH0r2FbUefFUFvBviikXQD1Q8ycbNoxaKhIlvUXYvjOIcDPu
         X4Lg==
X-Gm-Message-State: ACgBeo08WVV2t50xmg2Ni8BJNVCvJgpQ+NNqEN6Uw7RaITCzp2qesk7v
        i5Qcj6mF3q1IYJ58TDR9WkNKww==
X-Google-Smtp-Source: AA6agR5W3KyfYb0Ah0rzkQsVS3EmFauvkZr3Wm3ya6FofXb6KmVQ9TDyKYHTIH7cB5T2IOiTJJP76Q==
X-Received: by 2002:a17:902:f609:b0:168:dcbe:7c4d with SMTP id n9-20020a170902f60900b00168dcbe7c4dmr18480479plg.169.1659396476264;
        Mon, 01 Aug 2022 16:27:56 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id l5-20020a170903120500b0016d62ba5665sm10396763plh.254.2022.08.01.16.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 16:27:55 -0700 (PDT)
Date:   Mon, 1 Aug 2022 23:27:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>
Subject: Re: [RFC PATCH v6 036/104] KVM: x86/mmu: Explicitly check for MMIO
 spte in fast page fault
Message-ID: <YuhheIdg47zCDiNi@google.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <d1a1da631b44f425d929767fda74c90de2d87a8d.1651774250.git.isaku.yamahata@intel.com>
 <YuhTPxZNhxFs+xjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuhTPxZNhxFs+xjc@google.com>
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

On Mon, Aug 01, 2022, David Matlack wrote:
> On Thu, May 05, 2022 at 11:14:30AM -0700, isaku.yamahata@intel.com wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Explicitly check for an MMIO spte in the fast page fault flow.  TDX will
> > use a not-present entry for MMIO sptes, which can be mistaken for an
> > access-tracked spte since both have SPTE_SPECIAL_MASK set.
> > 
> > MMIO sptes are handled in handle_mmio_page_fault for non-TDX VMs, so this
> > patch does not affect them.  TDX will handle MMIO emulation through a
> > hypercall instead.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index d1c37295bb6e..4a12d862bbb6 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3184,7 +3184,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  		else
> >  			sptep = fast_pf_get_last_sptep(vcpu, fault->addr, &spte);
> >  
> > -		if (!is_shadow_present_pte(spte))
> > +		if (!is_shadow_present_pte(spte) || is_mmio_spte(spte))
> 
> I wonder if this patch is really necessary. is_shadow_present_pte()
> checks if SPTE_MMU_PRESENT_MASK is set (which is bit 11, not
> shadow_present_mask). Do TDX VMs set bit 11 in MMIO SPTEs?

This patch should be unnecessary, TDX's not-present SPTEs was one of my motivations
for adding MMU_PRESENT.   Bit 11 most definitely must not be set for MMIO SPTEs.
