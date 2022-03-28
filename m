Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31EC4E8BAF
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 03:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237308AbiC1BnS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Mar 2022 21:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiC1BnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Mar 2022 21:43:17 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDC848895;
        Sun, 27 Mar 2022 18:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648431698; x=1679967698;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jLSjB5TiH7kJ9GJHi06kkk1lwOsQ6eqXdeUcYlJC/LI=;
  b=lqxdHVp0l/IkoyG7QVEQcQfJoD+Xa+07d7gRe4Ie/ntro7W+zgQS2NJD
   pao0f8QFw8F6uc6B/1sXd1ewWwaj7IaYsfzzLstY1H8iCFutETrcKg/mF
   jUo8LQy6tG55hTaxj1WJltYVtSS/E8yo0BdQp/JjVwgG2hbXhCg+kNTie
   Km1tRUg/kd+DdBc2KNIIpnmxrORJl2VNFXkiJMzyMzIZGfOXQpCNklZci
   LsVxTSeBZZAzJxZUVVgA7LuSp7AggjpfCxojc2qh0zWg04woSJjIwHTG8
   YMFlh4ScX5x8VTnVXe3J0YQnrO8DEH6t3Yh9TPt6vZJ4AH+FqZYtjp8Ci
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10299"; a="258858639"
X-IronPort-AV: E=Sophos;i="5.90,216,1643702400"; 
   d="scan'208";a="258858639"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2022 18:41:38 -0700
X-IronPort-AV: E=Sophos;i="5.90,216,1643702400"; 
   d="scan'208";a="502341505"
Received: from stung2-mobl.gar.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.94.73])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2022 18:41:35 -0700
Message-ID: <926af8966a2233574ee0e679d9fc3c8209477156.camel@intel.com>
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
Date:   Mon, 28 Mar 2022 14:41:32 +1300
In-Reply-To: <BN9PR11MB5276B5986582F9AD11D993618C189@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1647167475.git.kai.huang@intel.com>
         <269a053607357eedd9a1e8ddf0e7240ae0c3985c.1647167475.git.kai.huang@intel.com>
         <BN9PR11MB5276B5986582F9AD11D993618C189@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-03-23 at 16:35 +1300, Tian, Kevin wrote:
> > From: Kai Huang <kai.huang@intel.com>
> > Sent: Sunday, March 13, 2022 6:50 PM
> > 
> > Secure Arbitration Mode (SEAM) is an extension of VMX architecture.  It
> > defines a new VMX root operation (SEAM VMX root) and a new VMX non-
> > root
> > operation (SEAM VMX non-root) which isolate from legacy VMX root and
> > VMX
> > non-root mode.
> 
> s/isolate/are isolated/

OK thanks.

> 
> > 
> > A CPU-attested software module (called the 'TDX module') runs in SEAM
> > VMX root to manage the crypto protected VMs running in SEAM VMX non-
> > root.
> > SEAM VMX root is also used to host another CPU-attested software module
> > (called the 'P-SEAMLDR') to load and update the TDX module.
> > 
> > Host kernel transits to either the P-SEAMLDR or the TDX module via the
> > new SEAMCALL instruction.  SEAMCALLs are host-side interface functions
> > defined by the P-SEAMLDR and the TDX module around the new SEAMCALL
> > instruction.  They are similar to a hypercall, except they are made by
> 
> "SEAMCALLs are ... functions ... around the new SEAMCALL instruction"
> 
> This is confusing. Probably just:

May I ask why is it confusing?

> 
> "SEAMCALL functions are defined and handled by the P-SEAMLDR and
> the TDX module"
> 
> > host kernel to the SEAM software.
> > 
> > SEAMCALLs use an ABI different from the x86-64 system-v ABI.  Instead,
> > they share the same ABI with the TDCALL.  %rax is used to carry both the
> > SEAMCALL leaf function number (input) and the completion status code
> > (output).  Additional GPRs (%rcx, %rdx, %r8->%r11) may be further used
> > as both input and output operands in individual leaf SEAMCALLs.
> > 
> > Implement a C function __seamcall() to do SEAMCALL using the assembly
> > macro used by __tdx_module_call() (the implementation of TDCALL).  The
> > only exception not covered here is TDENTER leaf function which takes
> > all GPRs and XMM0-XMM15 as both input and output.  The caller of TDENTER
> > should implement its own logic to call TDENTER directly instead of using
> > this function.
> > 
> > SEAMCALL instruction is essentially a VMExit from VMX root to SEAM VMX
> > root, and it can fail with VMfailInvalid, for instance, when the SEAM
> > software module is not loaded.  The C function __seamcall() returns
> > TDX_SEAMCALL_VMFAILINVALID, which doesn't conflict with any actual error
> > code of SEAMCALLs, to uniquely represent this case.
> 
> SEAMCALL is TDX specific, is it? If yes, there is no need to have both
> TDX and SEAMCALL in one macro, i.e. above can be SEAMCALL_VMFAILINVALID.

This is defined in TDX guest series.  I just use it.

https://lore.kernel.org/lkml/20220324152415.grt6xvhblmd4uccu@black.fi.intel.com/T/#md0b1aa563bd003ab625de159612a0d07e3ded7cb



-- 
Thanks,
-Kai
