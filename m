Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605844EE8DD
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 09:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343760AbiDAHPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 03:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343740AbiDAHPJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 03:15:09 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D0ABAE;
        Fri,  1 Apr 2022 00:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648797198; x=1680333198;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v7BxFZS7EqBUMLT0jC44zPK3Hm0zxzgqgjgsmXPUMUw=;
  b=Ac42CdQetfvW8slyl4NOL6AoLTBR/8A9IIRmo7HIlpSxy16IgCCsMTSo
   l1IMWjIb28B8RtTdhyi/32Qe4EcZhNUtI2/SuoDd4rJEQ5XdBpDxgbxTb
   qeChU8nvUfzOOq1lZOLGCFf+T7HXZOnKJ4NbttwIwi+yJteois7xg/tOD
   qFxxZ61Kyo++AQQuGvT/r7hQle70wahFujccmTadEWRBUoUaUFUm1yr5Y
   4hzHOC5HEE7RGa+iS5A/Ez0D/lPOwr3csI1b0Ppc6QRmA37f3agEDjfty
   0Cvi+4ORg2+jloTOCrjpN+XN6GCDeC6xXx8hXX8jwnwDzSKSNPSf1sFrx
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10303"; a="240652800"
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="240652800"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 00:13:18 -0700
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="547686744"
Received: from jamendoz-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.95.128])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 00:13:15 -0700
Message-ID: <3cfffe9a29e53ae58dc59d0af3d52128babde79f.camel@intel.com>
Subject: Re: [RFC PATCH v5 037/104] KVM: x86/mmu: Allow non-zero init value
 for shadow PTE
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Fri, 01 Apr 2022 20:13:13 +1300
In-Reply-To: <968de4765e63d8255ae1b3ac7062ffdca64706e4.camel@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <b74b3660f9d16deafe83f2670539a8287bef988f.1646422845.git.isaku.yamahata@intel.com>
         <968de4765e63d8255ae1b3ac7062ffdca64706e4.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-04-01 at 18:13 +1300, Kai Huang wrote:
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -617,9 +617,9 @@ static int mmu_spte_clear_track_bits(struct kvm *kvm,
> > u64 *sptep)
> >   	int level = sptep_to_sp(sptep)->role.level;
> >   
> >   	if (!spte_has_volatile_bits(old_spte))
> > -		__update_clear_spte_fast(sptep, 0ull);
> > +		__update_clear_spte_fast(sptep, shadow_init_value);
> >   	else
> > -		old_spte = __update_clear_spte_slow(sptep, 0ull);
> > +		old_spte = __update_clear_spte_slow(sptep,
> > shadow_init_value);
> 
> I guess it's better to have some comment here.  Allow non-zero init value for
> shadow PTE doesn't necessarily mean the initial value should be used when one
> PTE is zapped.  I think mmu_spte_clear_track_bits() is only called for mapping
> of normal (shared) memory but not MMIO? Then perhaps it's better to have a
> comment to explain we want "suppress #VE" set to get a real EPT violation for
> normal memory access from guest?

Btw, I think the relevant part of TDP MMU change should be included in this
patch too otherwise TDP MMU is broken with this patch.

Actually in this series legacy MMU is not supported to work with TDX, so above
change to legacy MMU doesn't matter actually.  Instead, TDP MMU change should be
here.

-- 
Thanks,
-Kai


