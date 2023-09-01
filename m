Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B8D78F6B2
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 03:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348054AbjIAB3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 21:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348044AbjIAB3H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 21:29:07 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8C2E70
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 18:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693531726; x=1725067726;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=jcNJ3QYMrTqoK9L+yVuOb08DWygtNbDciY8Xr0vyAjs=;
  b=XCpauqdHj623g6K17aGsoa4HIKz5srC/M6GqfB6ZZN2v3VPApIwOMx9A
   PrRKxFM2aLShCcj3Vk8q4Hqy+mr+ovyhBIlyjYk9n3KqJZwlpRdCD0pV0
   wDTPOAApq5/HsUJV5rnhWW1RBJ7tzCUOWjhg5TuCoeys31vL5eOdi9Q3K
   TEdE3j1Ox8C58X5mDz56wk3TmCgqk8pN3etersemRPxgNW2eBQbYGn/CT
   DtjOpRXQ5+b0zZrWQX02nHaFkrf6Onhf7QPG/q1Yw/diyFrawq/zCnzms
   JP364xLmj7HBoz6LrvXrvuP5Jv8mtkiEqZZmT2ji7xAuvL1PJ0vIafqx+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="376045535"
X-IronPort-AV: E=Sophos;i="6.02,218,1688454000"; 
   d="scan'208";a="376045535"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2023 18:28:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="805244416"
X-IronPort-AV: E=Sophos;i="6.02,218,1688454000"; 
   d="scan'208";a="805244416"
Received: from chaop.bj.intel.com (HELO localhost) ([10.240.193.80])
  by fmsmga008.fm.intel.com with ESMTP; 31 Aug 2023 18:28:41 -0700
Date:   Fri, 1 Sep 2023 09:17:11 +0800
From:   Chao Peng <chao.p.peng@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Fuad Tabba <tabba@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jorg Rodel <jroedel@suse.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [RFC PATCH v11 00/29]  KVM: guest_memfd() and per-page attributes
Message-ID: <20230901011711.GA673287@chaop.bj.intel.com>
Reply-To: Chao Peng <chao.p.peng@linux.intel.com>
References: <20230718234512.1690985-1-seanjc@google.com>
 <ZOjpIL0SFH+E3Dj4@google.com>
 <20230829091233.GA72470@chaop.bj.intel.com>
 <ZPDcAuHcoRfU+yRX@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPDcAuHcoRfU+yRX@google.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 31, 2023 at 11:29:22AM -0700, Sean Christopherson wrote:
> On Tue, Aug 29, 2023, Chao Peng wrote:
> > On Fri, Aug 25, 2023 at 10:47:12AM -0700, Sean Christopherson wrote:
> > > 
> > > 
> > > Filemap vs. xarray
> > > ------------------
> > > This is the main item that needs attention.  I don't want to merge guest_memfd()
> > > without doing this comparison, as not using filemap means we don't need AS_UNMOVABLE.
> > > Arguably we could merge a filemap implementation without AS_UNMOVABLE and just eat
> > > the suboptimal behavior, but not waiting a little while longer to do everything we
> > > can to get this right the first time seems ridiculous after we've been working on
> > > this for literally years.
> > > 
> > > Paolo was going to work on an axarray implementation, but AFAIK he hasn't done
> > > anything yet.  We (Google) don't have anyone available to work on an xarray
> > > implementation for several weeks (at best), so if anyone has the bandwidth and
> > > desire to take stab at an xarray implementation, please speak up.
> > 
> > I can do some experiments in the following weeks on the xarray
> > direction. I'm not quite confident I understood all what Paolo
> > originally wanted to do, so questions may have.
> 
> FYI, I jumped the gun, sounds like Paolo got far enough along to form a strong
> opinion[*].

Yeah, I see that, that is a good news actually, then we can go ahead with
the current filemap one. I personally think these mm touchpoints are not
a big deal when compared to previous versions, most part we are just using
the APIs.

> 
> Thanks for volunteering though, much appreciated!

NP, any collaboration is to make this lasting years series merge earlier.

Chao
> 
> [*] https://lore.kernel.org/all/CABgObfay4FKV=foWLZzAWaC2kVHRnF1ib+6NC058QVZVFhGeyA@mail.gmail.com
