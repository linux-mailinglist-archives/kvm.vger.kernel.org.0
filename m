Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1607D512A41
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 05:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237416AbiD1D7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 23:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbiD1D7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 23:59:00 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B45F3337C;
        Wed, 27 Apr 2022 20:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651118144; x=1682654144;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UM3ugeObnhWoZ4muc5hHOKA0zHtXIpTMZ5+iv76ouZE=;
  b=k4/QYlY8RYgCl+56Dctm1Pm6KwMQC7mD88XuRpNGWPIb4DHtAEEL1QQZ
   Cmpby7b5Z7LKyaPdzYyZiUKVHD1B8RAKV05uv0QFbpdA0/R0QUYWR9VAn
   BHBL+O7pANDqNiEiDY8SIqNVv8RCoT1MGd3YDnp/nrcWp70ilA+o182zE
   XBqeg9oj3ItlAFwdNZ10bqTMIK10ehRMYmCmBkvTL4d6swiEag+ChzXEB
   PexYjA6DNlKnrfy5lKKhioIoG28A4sgbVXvXRhReVfSJAE90gL9YiB8Mu
   KgtdtqmAhfSwVQdR2wDiPU5ioAaSru/yRAyYBnLQ5wATa1h6g+6fk/Bof
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="266309888"
X-IronPort-AV: E=Sophos;i="5.90,295,1643702400"; 
   d="scan'208";a="266309888"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 20:55:43 -0700
X-IronPort-AV: E=Sophos;i="5.90,295,1643702400"; 
   d="scan'208";a="565409201"
Received: from gachar1x-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.58.159])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 20:55:39 -0700
Message-ID: <8cb0535827a73b3fac75ac8b0163045ef166efa6.camel@intel.com>
Subject: Re: [PATCH v3 10/21] x86/virt/tdx: Add placeholder to coveret all
 system RAM as TDX memory
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
Date:   Thu, 28 Apr 2022 15:55:37 +1200
In-Reply-To: <73c8e61c-1057-a3ff-904d-6b7ddaaac83b@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <6230ef28be8c360ab326c8f592acf1964ac065c1.1649219184.git.kai.huang@intel.com>
         <d69c08da-80fa-2001-bbe8-8c45552e74ae@intel.com>
         <228cfa7e5326fa378c1dde2b5e9022146f97b706.camel@intel.com>
         <1624e839-81e5-7bc7-533b-c5c838d35f47@intel.com>
         <a6fb489700ce00fcb32a670a2fd7bf99a113d878.camel@intel.com>
         <73c8e61c-1057-a3ff-904d-6b7ddaaac83b@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-04-27 at 20:40 -0700, Dave Hansen wrote:
> On 4/27/22 18:35, Kai Huang wrote:
> > On Wed, 2022-04-27 at 18:07 -0700, Dave Hansen wrote:
> > > Also, considering that you're about to go allocate potentially gigabytes
> > > of physically contiguous memory, it seems laughable that you'd go to any
> > > trouble at all to allocate an array of pointers here.  Why not just
> > > 
> > > 	kcalloc(tdx_sysinfo.max_tdmrs, sizeof(struct tmdr_info), ...);
> > 
> > kmalloc() guarantees the size-alignment if the size is power-of-two.  TDMR_INFO
> > (512-bytes) itself is  power of two, but the 'max_tdmrs x sizeof(TDMR_INFO)' may
> > not be power of two.  For instance, when max_tdmrs == 3, the result is not
> > power-of-two.
> > 
> > Or am I wrong? I am not good at math though.
> 
> No, you're right, the kcalloc() wouldn't work for odd sizes.
> 
> But, the point is still that you don't need an array of pointers.  Use
> vmalloc().  Use a plain old alloc_pages_exact().  Why bother wasting
> the memory and addiong the complexity of an array of pointers?

OK.  This makes sense.

One thing I didn't say clearly is TDMR_INFO is 512-byte aligned, but not could
be larger than 512 bytes, and the maximum number of reserved areas in TDMR_INFO
is enumerated via TDSYSINFO_STRUCT.  We can always roundup TDMR_INFO size to be
512-byte aligned, and calculate enough pages to hold maximum number of
TDMR_INFO.  In this case, we can still guarantee each TDMR_INFO is 512-byte
aligned.

I'll change to use alloc_pages_exact(), since we can get physical address of
TDMR_INFO from it easily.

> 
> > > Or, heck, just vmalloc() the dang thing.  Why even bother with the array
> > > of pointers?
> > > 
> > > 
> > > > > > +	if (!tdmr_array) {
> > > > > > +		ret = -ENOMEM;
> > > > > > +		goto out;
> > > > > > +	}
> > > > > > +
> > > > > > +	/* Construct TDMRs to build TDX memory */
> > > > > > +	ret = construct_tdmrs(tdmr_array, &tdmr_num);
> > > > > > +	if (ret)
> > > > > > +		goto out_free_tdmrs;
> > > > > > +
> > > > > >  	/*
> > > > > >  	 * Return -EFAULT until all steps of TDX module
> > > > > >  	 * initialization are done.
> > > > > >  	 */
> > > > > >  	ret = -EFAULT;
> > > > > 
> > > > > There's the -EFAULT again.  I'd replace these with a better error code.
> > > > 
> > > > I couldn't think out a better error code.  -EINVAL looks doesn't suit.  -EAGAIN
> > > > also doesn't make sense for now since we always shutdown the TDX module in case
> > > > of any error so caller should never retry.  I think we need some error code to
> > > > tell "the job isn't done yet".  Perhaps -EBUSY?
> > > 
> > > Is this going to retry if it sees -EFAULT or -EBUSY?
> > 
> > No.  Currently we always shutdown the module in case of any error.  Caller won't
> > be able to retry.
> > 
> > In the future, this can be optimized.  We don't shutdown the module in case of
> > *some* error (i.e. -ENOMEM), but record an internal state when error happened,
> > so the caller can retry again.  For now, there's no retry.
> 
> Just make the error codes -EINVAL, please.  I don't think anything else
> makes sense.
> 

OK will do.

-- 
Thanks,
-Kai


