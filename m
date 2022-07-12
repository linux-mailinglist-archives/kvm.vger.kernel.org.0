Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D2D5717C7
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 12:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbiGLK57 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 06:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbiGLK5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 06:57:40 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA64AEF48;
        Tue, 12 Jul 2022 03:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657623459; x=1689159459;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=owzfM9nmoJGk0jCIdaocCpnOUllHnhVFqerbRCX6fdo=;
  b=FMbQiu7WgTGsvM0n/SlV7z6lXvjq0YahDAAGmISLG8WpE6FtMkv4iXCx
   Vi61ArVm7e0UaY/Xad5xrTq2GUAqGTqFf7Tp5GLlM5eOsYvv6WaXMwdSI
   40uWr3gmwZjubLcokwuAlHhDQPB6R/hZ/z5ZxReRQSrVZTQjsh+zuNrXu
   XQJwjvbI2V2mLjln+ZWdoY+GYn2RNR4pzVkVNQ7RZ2STq7GZCJ7tCp9f2
   gcM6RejMQs8xszEdo2hM55p9pJOyp5miQxy1INR7rubvK444UXcpPi+zD
   JnsS7TR3323KLvb6AEMzhAQ29X1nl7eG8+1v+eQTqXxEMol5qObvx9MP3
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="267938972"
X-IronPort-AV: E=Sophos;i="5.92,265,1650956400"; 
   d="scan'208";a="267938972"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 03:57:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,265,1650956400"; 
   d="scan'208";a="592589842"
Received: from chaop.bj.intel.com (HELO localhost) ([10.240.192.101])
  by orsmga007.jf.intel.com with ESMTP; 12 Jul 2022 03:57:36 -0700
Date:   Tue, 12 Jul 2022 18:54:19 +0800
From:   Chao Peng <chao.p.peng@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        chao.p.peng@intel.com
Subject: Re: [PATCH v7 000/102] KVM TDX basic feature support
Message-ID: <20220712105419.GB2805143@chaop.bj.intel.com>
Reply-To: Chao Peng <chao.p.peng@linux.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <20220711151701.GA1375147@ls.amr.corp.intel.com>
 <20220712050714.GA26573@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712050714.GA26573@gao-cwp>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 12, 2022 at 01:07:20PM +0800, Chao Gao wrote:
> On Mon, Jul 11, 2022 at 08:17:01AM -0700, Isaku Yamahata wrote:
> >Hi. Because my description on large page support was terse, I wrote up more
> >detailed one.  Any feedback/thoughts on large page support?
> >
> >TDP MMU large page support design
> >
> >Two main discussion points
> >* how to track page status. private vs shared, no-largepage vs can-be-largepage
> 
> ...
> 
> >
> >Tracking private/shared and large page mappable
> >-----------------------------------------------
> >VMM needs to track that page is mapped as private or shared at 4KB granularity.
> >For efficiency of EPT violation path (****), at 2MB and 1GB level, VMM should
> >track the page can be mapped as a large page (regarding private/shared).  VMM
> >updates it on MapGPA and references it on the EPT violation path. (****)
> 
> Isaku,
> 
> + Peng Chao
> 
> Doesn't UPM guarantee that 2MB/1GB large page in CR3 should be either all
> private or all shared?
> 
> KVM always retrieves the mapping level in CR3 and enforces that EPT's
> page level is not greater than that in CR3. My point is if UPM already enforces
> no mixed pages in a large page, then KVM needn't do that again (UPM can
> be trusted).

The backing store in the UMP can tell KVM which page level it can
support for a given private gpa, similar to host_pfn_mapping_level() for
shared address.

However, this solely represents the backing store's capability, KVM
still needs additional info to decide whether that can be safely mapped
as 2M/1G, e.g. all the following pages in the 2M/1G range should be all
private, currently this is not something backing store can tell.

Actually, in UPM v7 we let KVM record this info so one possible solution
is making use of it.

  https://lkml.org/lkml/2022/7/6/259

Then to map a page as 2M, KVM needs to check:
  - Memory backing store support that level
  - All pages in 2M range are private as we recorded through
    KVM_MEMORY_ENCRYPT_{UN,}REG_REGION
  - No existing partial 4K map(s) in 2M range

Chao
> 
> Maybe I am misunderstanding something?


