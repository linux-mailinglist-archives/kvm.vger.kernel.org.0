Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B65951798D
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 23:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347523AbiEBWBV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 18:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387840AbiEBV7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 17:59:40 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64455F33;
        Mon,  2 May 2022 14:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651528558; x=1683064558;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xkColIiWzUzT63cjf0p5tiFtU1yhRN1jJlgXlzvVJqY=;
  b=AfWWk3dqhm8sCaX51ak8gVDAVC/2QTLsqoO3+DlRUDn7w/jboVdQzT+k
   rMYzpoNIub05Z0u1y3jNK3oCL1PO2P1lDC8uX58BWu/zGvDwqb9HnMLIo
   2JoacArZzTYA1ROGGEzV3MixzNOOGKgVLQXtfzizqj+Ucyr7z6MhEKpwU
   V5iobYoQzkW+Nz5xBABrBz1BGomYblJvFUNQ9Zovf1mdQLw7s1Wq++0Oe
   p9uiZfsVDMAQeUkVBr7EBUrFZtcMFWOOr339iJ7Tlpu3/4lyMp/+j71go
   8ox4cFUUgzqEtn7R6ir+ExbuJElfGvVnrH9kB2BUyChGyYjbCw2qhVTQs
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="266924602"
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="266924602"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 14:55:58 -0700
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="598813198"
Received: from chgan-mobl1.gar.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.60.238])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 14:55:54 -0700
Message-ID: <8ba1a3ec3a4c5a02c28476cbb36118f61aea8a6c.camel@intel.com>
Subject: Re: [PATCH v3 13/21] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Tue, 03 May 2022 09:55:52 +1200
In-Reply-To: <8d5715b5-d561-f482-af11-03a9a46e651a@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <ffc2eefdd212a31278978e8bfccd571355db69b0.1649219184.git.kai.huang@intel.com>
         <c9b17e50-e665-3fc6-be8c-5bb16afa784e@intel.com>
         <3664ab2a8e0b0fcbb4b048b5c3aa5a6e85f9618a.camel@intel.com>
         <5984b61f-6a4a-c12a-944d-f4a78bdefc3d@intel.com>
         <af603d66512ec5dca0c240cf81c83de7dfe730e7.camel@intel.com>
         <8d5715b5-d561-f482-af11-03a9a46e651a@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-05-02 at 07:17 -0700, Dave Hansen wrote:
> On 5/1/22 22:59, Kai Huang wrote:
> > On Fri, 2022-04-29 at 07:20 -0700, Dave Hansen wrote:
> > How about adding below in the changelog:
> > 
> > "
> > However using alloc_contig_pages() to allocate large physically contiguous
> > memory at runtime may fail.  The larger the allocation, the more likely it is to
> > fail.  Due to the fragmentation, the kernel may need to move pages out of the
> > to-be-allocated contiguous memory range but it may fail to move even the last
> > stubborn page.  A good way (although not foolproof) is to launch a TD VM early
> > in boot to get PAMTs allocated before memory gets fragmented or consumed.
> > "
> 
> Better, although it's getting a bit off topic for this changelog.
> 
> Just be short and sweet:
> 
> 1. the allocation can fail
> 2. Launch a VM early to (badly) mitigate this
> 3. the only way to fix it is to add a boot option
> 
OK. Thanks.

> 
> > > > > > +	/*
> > > > > > +	 * One TDMR must cover at least one (or partial) RAM entry,
> > > > > > +	 * otherwise it is kernel bug.  WARN_ON() in this case.
> > > > > > +	 */
> > > > > > +	if (WARN_ON_ONCE((start >= end) || start >= TDMR_END(tdmr)))
> > > > > > +		return 0;
> > > 
> > > This really means "no RAM found for this TDMR", right?  Can we say that,
> > > please.
> > 
> > OK will add it.  How about:
> > 
> > 	/*
> > 	 * No RAM found for this TDMR.  WARN() in this case, as it
> > 	 * cannot happen otherwise it is a kernel bug.
> > 	 */
> 
> The only useful information in that comment is the first sentence.  The
> jibberish about WARN() is patently obvious from the next two lines of code.
> 
> *WHY* can't this happen?  How might it have actually happened?

When TDMRs are created, we already have made sure one TDMR must cover at least
one or partial RAM entry.

-- 
Thanks,
-Kai


