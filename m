Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1654E90D0
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 11:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239680AbiC1JMo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 05:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235827AbiC1JMm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 05:12:42 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F7A326FC;
        Mon, 28 Mar 2022 02:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648458662; x=1679994662;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BADStK/EoCj+rqPCYHQnLkncJNpermekoKEy0nC/TrA=;
  b=d0jcsE/twQnUIOQA3IbIr0Lt2uk6+Pse7Fp7JYysJARuFakAeLghKicB
   sRuEldkNb8qULdyv/wKw4Xhvgc+THQ6iPYzMErkR2ep4OnnaAz6A/ged9
   5qz7uqjaAW+gy2zQZFvpZiAmEJkDljSz6/3hnj7MT+30Agdi5FZhJiuf2
   qWk91aeoXZ1mkcffofjuTMQuv3raCj9c40jHbMXpHODLk8Av1FZ7iWPWZ
   uEXfPI5Lf0nYdN5w/uDJ+srLblYU79NKHmB0Cvf7cQu4yG41A710007U3
   FwSQO0IHfY5PEpdLOg72H6HM9vo6fnqjyRUpcDBvBVjMRaqn578Pi2qqH
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10299"; a="345389398"
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="345389398"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 02:10:44 -0700
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="719035063"
Received: from nhawacha-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.27.18])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 02:10:24 -0700
Message-ID: <cda00ff76a61869294f2b17c4c7be2ca8402af35.camel@intel.com>
Subject: Re: [PATCH v2 03/21] x86/virt/tdx: Implement the SEAMCALL base
 function
From:   Kai Huang <kai.huang@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "Hansen, Dave" <dave.hansen@intel.com>,
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
Date:   Mon, 28 Mar 2022 22:10:22 +1300
In-Reply-To: <BN9PR11MB5276D7C515C1F28300B0B3018C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1647167475.git.kai.huang@intel.com>
         <269a053607357eedd9a1e8ddf0e7240ae0c3985c.1647167475.git.kai.huang@intel.com>
         <BN9PR11MB5276B5986582F9AD11D993618C189@BN9PR11MB5276.namprd11.prod.outlook.com>
         <926af8966a2233574ee0e679d9fc3c8209477156.camel@intel.com>
         <BN9PR11MB5276D7C515C1F28300B0B3018C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
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

On Mon, 2022-03-28 at 21:16 +1300, Tian, Kevin wrote:
> > From: Huang, Kai <kai.huang@intel.com>
> > Sent: Monday, March 28, 2022 9:42 AM
> > 
> > 
> > > 
> > > > 
> > > > A CPU-attested software module (called the 'TDX module') runs in SEAM
> > > > VMX root to manage the crypto protected VMs running in SEAM VMX
> > non-
> > > > root.
> > > > SEAM VMX root is also used to host another CPU-attested software
> > module
> > > > (called the 'P-SEAMLDR') to load and update the TDX module.
> > > > 
> > > > Host kernel transits to either the P-SEAMLDR or the TDX module via the
> > > > new SEAMCALL instruction.  SEAMCALLs are host-side interface functions
> > > > defined by the P-SEAMLDR and the TDX module around the new
> > SEAMCALL
> > > > instruction.  They are similar to a hypercall, except they are made by
> > > 
> > > "SEAMCALLs are ... functions ... around the new SEAMCALL instruction"
> > > 
> > > This is confusing. Probably just:
> > 
> > May I ask why is it confusing?
> 
> SEAMCALL is an instruction. One of its arguments carries the function
> number.
> 

To confirm, are you saying the word "SEAMCALLs" is confusing, and we should use
"SEAMCALL leaf functions" instead?

-- 
Thanks,
-Kai


