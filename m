Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF1B4EB6C2
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 01:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240462AbiC2XaL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 19:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiC2XaK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 19:30:10 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC05F39;
        Tue, 29 Mar 2022 16:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648596505; x=1680132505;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gzmBCGI/MQMl41/e4XEdKaqxJlbBNFcUeD2Jf3KlOBU=;
  b=C/1FVXQZkriNjtU139F7egvtv32Kn606nZ43ERfLSPyOQmIGqPh2yz9i
   Hkm56Dnnzjtk01CoGdkgsqzWhpwL3551WfCiCjWU+m61oNdCVtS4BkxWV
   2fUtPW++tUZjxCuLxhgju5ybhQ2RZ0dKcOapTaDeopHn7Kudv28Tdc6Hk
   xRMa6SY2cLzazMZg6Q56sBzWZO0rlWy3mmtSPha64bBhRqQm7Pi95oJ+y
   4zKilNVoY4V0m92DN3FpiBN8XNgAWUFFeM4q4FHIjKKIGJsgTYbrRCOg1
   kMQgia38ZPYjUn4DOfgiG2smd8PX2+B4jTb7rQFoXZ2eJQGD++nS1JKLk
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10301"; a="345835729"
X-IronPort-AV: E=Sophos;i="5.90,220,1643702400"; 
   d="scan'208";a="345835729"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2022 16:28:20 -0700
X-IronPort-AV: E=Sophos;i="5.90,220,1643702400"; 
   d="scan'208";a="585783066"
Received: from jaleon-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.95.100])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2022 16:28:17 -0700
Message-ID: <a2728619ef71add19d9b87af554fd2fc9bc0b7e0.camel@intel.com>
Subject: Re: [PATCH v2 01/21] x86/virt/tdx: Detect SEAM
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Date:   Wed, 30 Mar 2022 12:28:14 +1300
In-Reply-To: <20220329175234.GA1915371@ls.amr.corp.intel.com>
References: <cover.1647167475.git.kai.huang@intel.com>
         <a258224c26b6a08400d9a8678f5d88f749afe51e.1647167475.git.kai.huang@intel.com>
         <BN9PR11MB527657C2AA8B9ACD94C9D5468C189@BN9PR11MB5276.namprd11.prod.outlook.com>
         <51982ec477e43c686c5c64731715fee528750d85.camel@intel.com>
         <BN9PR11MB52765EE37C00F0FFA01447968C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
         <20220329175234.GA1915371@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-29 at 10:52 -0700, Isaku Yamahata wrote:
> On Mon, Mar 28, 2022 at 08:10:47AM +0000,
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
> 
> > > From: Huang, Kai <kai.huang@intel.com>
> > > Sent: Monday, March 28, 2022 11:55 AM
> > > 
> > > SEAMRR and TDX KeyIDs are configured by BIOS and they are static during
> > > machine's runtime.  On the other hand, TDX module can be updated and
> > > reinitialized at runtime (not supported in this series but will be supported in
> > > the future).  Theoretically, even P-SEAMLDR can be updated at runtime
> > > (although
> > > I think unlikely to be supported in Linux).  Therefore I think detecting
> > > SEAMRR
> > > and TDX KeyIDs at boot fits better.
> > 
> > If those info are static it's perfectly fine to detect them until they are
> > required... and following are not solid cases (e.g. just exposing SEAM
> > alone doesn't tell the availability of TDX) but let's also hear the opinions
> > from others.
> 
> One use case is cloud use case.  If TDX module is initialized dynamically at
> runtime, cloud management system wants to know if the physical machine is
> capable of TDX in addition to if TDX module is initialized.  Also how many TDs
> can be run on the machine even when TDX module is not initialized yet.  The
> management system will schedule TDs based on those information.

Thanks Isaku.  I'll keep current way for now.

-- 
Thanks,
-Kai


