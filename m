Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D649E4EFCCB
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 00:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352762AbiDAW3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 18:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236927AbiDAW26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 18:28:58 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D91D5DE72;
        Fri,  1 Apr 2022 15:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648852028; x=1680388028;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UJNICAG6TCIb/4Af9Q1KfBvjRZRVQS+n33nr6c0+nyU=;
  b=FjdhunpEd+pBPSdkQV9QiklehUW7ztGvUortbPeaMU46wsXgso9BU/sP
   SfZGCQmGMroSTCJ/lpwXOG/SogaBQE4e7ObJKIFnNf7DSNWXAyZaFcgMI
   wcNGTdbKMarn5pOgsjgv7TL82uwP95ZUpFZRN535bS5pPr3yiqJVVW2t2
   JHX/dxJWjI3vDprvES2/ZjOLpfjucnunifOn6w6ovGkN/16wtyg3QeXn5
   0d/nnOpA3F79PjDAD/voddAYNwwLc5F31pAzQz5rsIdHwAeDR7vCZ39XX
   Yh7BIKcN9GxNqaYA5fwbHg/MIFBxuUHMQKjclQ8+OBerCvw9gFsig+KLS
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="240182092"
X-IronPort-AV: E=Sophos;i="5.90,228,1643702400"; 
   d="scan'208";a="240182092"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 15:27:07 -0700
X-IronPort-AV: E=Sophos;i="5.90,228,1643702400"; 
   d="scan'208";a="522938992"
Received: from tmle-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.131.147])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 15:27:05 -0700
Message-ID: <43098446667829fc592b7cc7d5fd463319d37562.camel@intel.com>
Subject: Re: [RFC PATCH v5 038/104] KVM: x86/mmu: Allow per-VM override of
 the TDP max page level
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>
Date:   Sat, 02 Apr 2022 11:27:03 +1300
In-Reply-To: <YkcHZo3i+rki+9lK@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <5cc4b1c90d929b7f4f9829a42c0b63b52af0c1ed.1646422845.git.isaku.yamahata@intel.com>
         <c6fb151ced1675d1c93aa18ad8c57c2ffc4e9fcb.camel@intel.com>
         <YkcHZo3i+rki+9lK@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-04-01 at 14:08 +0000, Sean Christopherson wrote:
> On Fri, Apr 01, 2022, Kai Huang wrote:
> > On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > 
> > > In the existing x86 KVM MMU code, there is already max_level member in
> > > struct kvm_page_fault with KVM_MAX_HUGEPAGE_LEVEL initial value.  The KVM
> > > page fault handler denies page size larger than max_level.
> > > 
> > > Add per-VM member to indicate the allowed maximum page size with
> > > KVM_MAX_HUGEPAGE_LEVEL as default value and initialize max_level in struct
> > > kvm_page_fault with it.
> > > 
> > > For the guest TD, the set per-VM value for allows maximum page size to 4K
> > > page size.  Then only allowed page size is 4K.  It means large page is
> > > disabled.
> > 
> > Do not support large page for TD is the reason that you want this change, but
> > not the result.  Please refine a little bit.
> 
> Not supporting huge pages was fine for the PoC, but I'd prefer not to merge TDX
> without support for huge pages.  Has any work been put into enabling huge pages?
> If so, what's the technical blocker?  If not...

Hi Sean,

Is there any reason large page support must be included in the initial merge of
TDX?  Large page is more about performance improvement I think.  Given this
series is already very big, perhaps we can do it later.

-- 
Thanks,
-Kai


