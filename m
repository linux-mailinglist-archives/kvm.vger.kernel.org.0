Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082885092E4
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 00:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382854AbiDTWi1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 18:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbiDTWi0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 18:38:26 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164F6403EF;
        Wed, 20 Apr 2022 15:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650494139; x=1682030139;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i1FV9ua/QKqRvQE28+dhqw9LbkWLdadta+7evj3sFmk=;
  b=oD+QQfkFtsDodvhhubmQLJVqUfV70VsMEINBKYKbBA+I31aAHwl8SKbS
   RP793G55btg8w/QdOlM32mc3VqOcITt+QyiSqtiQV16ZkCa1SlODicHk6
   Nmt67d/c5TzUpSNqj0SsRs/xsWkS+zJoJJQlQRlWsH4kTF4rWvyS8wkPt
   mHztCWsgLHRTT0oxqDh8YocQ96Eugf6WzOTozmnW7//rxboF6uQlgJ5OV
   nVfyCdmAXkCeZCd7g8QakMqxpB6EM/+nBto2e1AuUqO9C7leudkYIDZYt
   bV6cFcxaHOhyyXnE453iaKn3G5joJLCniZpGOIN0wkKLDaFceKgZshFVe
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="246056291"
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="246056291"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 15:35:35 -0700
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="658249359"
Received: from ssharm9-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.30.148])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 15:35:32 -0700
Message-ID: <a8085f189deffb367f446656bc1da619cd53d447.camel@intel.com>
Subject: Re: [PATCH v3 04/21] x86/virt/tdx: Add skeleton for detecting and
 initializing TDX on demand
From:   Kai Huang <kai.huang@intel.com>
To:     Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com, isaku.yamahata@intel.com
Date:   Thu, 21 Apr 2022 10:35:30 +1200
In-Reply-To: <136845e1-fe43-fbb6-3a95-741c46c42156@linux.intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <32dcf4c7acc95244a391458d79cd6907125c5c29.1649219184.git.kai.huang@intel.com>
         <bc078c41-89fd-0a24-7d8e-efcd5a697686@linux.intel.com>
         <fd954918981d5c823a8c2b8d1b346d4eb13f334f.camel@intel.com>
         <136845e1-fe43-fbb6-3a95-741c46c42156@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> 
> > > > +
> > > > +/**
> > > > + * tdx_detect - Detect whether the TDX module has been loaded
> > > > + *
> > > > + * Detect whether the TDX module has been loaded and ready for
> > > > + * initialization.  Only call this function when all cpus are
> > > > + * already in VMX operation.
> > > > + *
> > > > + * This function can be called in parallel by multiple callers.
> > > > + *
> > > > + * Return:
> > > > + *
> > > > + * * -0:	The TDX module has been loaded and ready for
> > > > + *		initialization.
> > > > + * * -ENODEV:	The TDX module is not loaded.
> > > > + * * -EPERM:	CPU is not in VMX operation.
> > > > + * * -EFAULT:	Other internal fatal errors.
> > > > + */
> > > > +int tdx_detect(void)
> > > 
> > > Will this function be used separately or always along with
> > > tdx_init()?
> > 
> > The caller should first use tdx_detect() and then use tdx_init().  If caller
> > only uses tdx_detect(), then TDX module won't be initialized (unless other
> > caller does this).  If caller calls tdx_init() before tdx_detect(),  it will get
> > error.
> > 
> 
> I just checked your patch set to understand where you are using
> tdx_detect()/tdx_init(). But I did not find any callers. Did I miss it? 
> or it is not used in your patch set?
> 

No you didn't.  They are not called in this series.  KVM series which is under
upstream process by Isaku will call them.  Dave once said w/o caller is fine as
for this particular case people know KVM is going to use them.  In cover letter
I also mentioned KVM support is under development by another series.  Next
version in cover letter, I'll explicitly call out this series doesn't have
caller of them but depends on KVM to call them.


-- 
Thanks,
-Kai


