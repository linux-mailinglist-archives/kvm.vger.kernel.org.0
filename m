Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3F750ED21
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 02:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239018AbiDZAIi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 20:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234498AbiDZAIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 20:08:37 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7603835857;
        Mon, 25 Apr 2022 17:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650931531; x=1682467531;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JiKB+A2uaXqkRjPBW7uR78DBY0vfODCV29cJBCN4srM=;
  b=dsS4DZ8ch0kQ5JrrDXvfNPqzqZH8tz8UChbjqdnE9hbQQ9q+2Hi4M2h4
   uAYH3fZ92n0guhIcQu5C4UBuY3TnOQh0Ke18LUtkHXyjiOYJxJqmPpPW2
   sDL9smOYrdoRDd6zCo6QVwxIMTbyII7TYEdftjr25mvIF/oIa0CdFZfna
   TdgWS2H77kHXazV71OC5b0XVyH6hL0Yf4M70xLPyOTdawY2oyqFHdhHUv
   Pgiva8d3VNAZJKnng69gvNV2rjADFGy63iGv00kaRYxGfqBBwqSU1pZyO
   bmnvUn2IvFfwLfUT5MhK0rkRcqLmmpcifqqCkST2/gh/lCl3mm6JFllXK
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="325886296"
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="325886296"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 17:05:30 -0700
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="616739283"
Received: from begriffi-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.0.169])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 17:05:26 -0700
Message-ID: <7887db8b5108b8dc9bd35868db561badca060b51.camel@intel.com>
Subject: Re: [PATCH v3 09/21] x86/virt/tdx: Get information about TDX module
 and convertible memory
From:   Kai Huang <kai.huang@intel.com>
To:     Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com, isaku.yamahata@intel.com
Date:   Tue, 26 Apr 2022 12:05:23 +1200
In-Reply-To: <8972b2ac-c786-8ff5-74fc-040cd4d81c86@linux.intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <145620795852bf24ba2124a3f8234fd4aaac19d4.1649219184.git.kai.huang@intel.com>
         <8972b2ac-c786-8ff5-74fc-040cd4d81c86@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> 
> > +}
> > +
> > +static int sanitize_cmrs(struct cmr_info *cmr_array, int cmr_num)
> 
> Since this function only deals with tdx_cmr_array, why pass it
> as argument?

I received comments to use cmr_num as argument and pass tdx_cmr_num to
sanitize_cmrs() and finalize it at the end of this function.  In this case I
think it's better to pass tdx_cmr_array as argument.  It also saves some typing
(tdx_cmr_array vs cmr_array) in sanitize_cmrs().

> 
> > +{
> > +	int i, j;
> > +
> > +	/*
> > +	 * Intel TDX module spec, 20.7.3 CMR_INFO:
> > +	 *
> > +	 *   TDH.SYS.INFO leaf function returns a MAX_CMRS (32) entry
> > +	 *   array of CMR_INFO entries. The CMRs are sorted from the
> > +	 *   lowest base address to the highest base address, and they
> > +	 *   are non-overlapping.
> > +	 *
> > +	 * This implies that BIOS may generate invalid empty entries
> > +	 * if total CMRs are less than 32.  Skip them manually.
> > +	 */
> > +	for (i = 0; i < cmr_num; i++) {
> > +		struct cmr_info *cmr = &cmr_array[i];
> > +		struct cmr_info *prev_cmr = NULL;
> 
> Why not keep declarations together at the top of the function?

Why? They are only used in this for-loop.

> 
> > +
> > +		/* Skip further invalid CMRs */
> > +		if (!cmr_valid(cmr))
> > +			break;
> > +
> > +		if (i > 0)
> > +			prev_cmr = &cmr_array[i - 1];
> > +
> > +		/*
> > +		 * It is a TDX firmware bug if CMRs are not
> > +		 * in address ascending order.
> > +		 */
> > +		if (prev_cmr && ((prev_cmr->base + prev_cmr->size) >
> > +					cmr->base)) {
> > +			pr_err("Firmware bug: CMRs not in address ascending order.\n");
> > +			return -EFAULT;
> > +		}
> 
> Since above condition is only true for i > 0 case, why not combine them
> together if (i > 0) {...}

It will make an additional ident for the above if() {} to check prev_cmr and
cmr.  I don't see it is better?

-- 
Thanks,
-Kai


