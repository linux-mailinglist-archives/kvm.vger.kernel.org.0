Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DADB64CD4A
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 16:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238904AbiLNPsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 10:48:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238819AbiLNPrg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 10:47:36 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48C027FF0
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 07:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671032841; x=1702568841;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WF7yMFDVq/TY9XKynV4qmcvJiOnMmzvsFwP2+9IC50c=;
  b=Eajy268U2TjIGijtILJ+7x8eRUysBoOUj5Rf77jM9s9flxFjKNgIJ//g
   pvmWHzf7razHVV2fM7YMjdM28ahDjeVL3kGuErsFnBw6I4VPEtNNmBwdj
   nuWvMEZ3ZovEPtUo2QbqzyIU5V8p1pAjwS3Bpadk9kJhfgYkCQDqOhWOU
   AgYYmez675wNYJLO9FrsqhTDFrbzY2VcXKeM3Y5N4T/kD42ET6JSsf0/C
   i+QiCzRJCy4m5tDrLyk0XBVLQm8ebbxtf6jXmusQyNjQY1VreFzrvA1QV
   uwUolZVHvWJ0/cdEMCDSweFr26Y/BpYUvc8ZvkGPi+BmGPJICIFuvwaCB
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="318478345"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="318478345"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 07:47:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="791340343"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="791340343"
Received: from jliu4-mobl.ccr.corp.intel.com (HELO localhost) ([10.254.215.175])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 07:47:16 -0800
Date:   Wed, 14 Dec 2022 23:47:14 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        catalin.marinas@arm.com, will@kernel.org, paul@xen.org
Subject: Re: [PATCH v2] KVM: MMU: Make the definition of 'INVALID_GPA' common.
Message-ID: <20221214154714.3qj4wt3u36zwp67q@linux.intel.com>
References: <20221213090405.762350-1-yu.c.zhang@linux.intel.com>
 <96faca1a685e0d6e7a77cbc9dadc8ae5c6c9a27c.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96faca1a685e0d6e7a77cbc9dadc8ae5c6c9a27c.camel@infradead.org>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 11:10:54AM +0000, David Woodhouse wrote:
> On Tue, 2022-12-13 at 17:04 +0800, Yu Zhang wrote:
> > --- a/arch/x86/kvm/xen.c
> > +++ b/arch/x86/kvm/xen.c
> > @@ -41,7 +41,7 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
> >         int ret = 0;
> >         int idx = srcu_read_lock(&kvm->srcu);
> >  
> > -       if (gfn == GPA_INVALID) {
> > +       if (gfn == INVALID_GPA) {
> >                 kvm_gpc_deactivate(gpc);
> >                 goto out;
> >         }
> > @@ -659,7 +659,7 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
> >                 if (kvm->arch.xen.shinfo_cache.active)
> >                         data->u.shared_info.gfn = gpa_to_gfn(kvm->arch.xen.shinfo_cache.gpa);
> >                 else
> > -                       data->u.shared_info.gfn = GPA_INVALID;
> > +                       data->u.shared_info.gfn = INVALID_GPA;
> >                 r = 0;
> >                 break;
> 
> Strictly, those are INVALID_GFN not INVALID_GPA but I have so far
> managed to pretend not to notice...
> 
> If we're bikeshedding the naming then I might have suggested
> INVALID_PAGE but that already exists as an hpa_t type.

Thanks, David. INVALID_GFN sounds more reasonable for me.

But I am not sure if adding INVALID_GFN is necessary. Because for now
only kvm_xen_shared_info_init() and kvm_xen_hvm_get_attr() use INVALID_GPA
as a GFN. 

Any suggestion? Thanks!

B.R.
Yu




