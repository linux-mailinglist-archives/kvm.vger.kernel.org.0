Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400706A8FBE
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 04:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjCCDQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 22:16:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjCCDQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 22:16:41 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FAD14E89
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 19:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677813400; x=1709349400;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+8gvJUDXxmZ+UtGthuw4GOct7S5wYe8KrsxwKfLVQws=;
  b=YRdvQnrjJJTxsY+HJTlptO+v2vlNLiczV6IjvNXJDUy14nbxrc7T9bBb
   2rlNhWwb5A1nHhx4qMCwj6sXhzRGVbzzsBIM/rq96NqlCMDGOlGbydRjk
   fmDq5+75dU+R0NWRluFssn2kJRl0nwmX8HoSB7lH55eP8brv3KYciQEPE
   m2iqXIR+luwlvXkRyBjpElKPsrdiFbe1nE5j7GDj90XQez5QLLtQZpExZ
   RkvcgtdGeq/np8aPcKz8qYOAPPLIyoIJ1NqvAPag8kg2AxelCul6wz5ol
   7YtpZb3a9JBNI9Qbhflc5/wG1gjj403aeSN4zMQh8rJM3TuIxw/cxC4HS
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="362534069"
X-IronPort-AV: E=Sophos;i="5.98,229,1673942400"; 
   d="scan'208";a="362534069"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 19:16:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="818316566"
X-IronPort-AV: E=Sophos;i="5.98,229,1673942400"; 
   d="scan'208";a="818316566"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga001.fm.intel.com with ESMTP; 02 Mar 2023 19:16:38 -0800
Message-ID: <f1714f362630c29e7aeab24dcf75244d7fc41802.camel@linux.intel.com>
Subject: Re: [PATCH v5 4/5] KVM: x86: emulation: Apply LAM mask when
 emulating data access in 64-bit mode
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>, seanjc@google.com,
        pbonzini@redhat.com, chao.gao@intel.com
Cc:     kvm@vger.kernel.org
Date:   Fri, 03 Mar 2023 11:16:37 +0800
In-Reply-To: <52e5514d-89f3-f060-71fb-01da3fe81a7a@linux.intel.com>
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
         <20230227084547.404871-5-robert.hu@linux.intel.com>
         <79b1563b-71e3-3a3d-0812-76cca32fc7b3@linux.intel.com>
         <871716083508732b474ae22b381a58be66889707.camel@linux.intel.com>
         <52e5514d-89f3-f060-71fb-01da3fe81a7a@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-03-03 at 09:08 +0800, Binbin Wu wrote:
> On 3/2/2023 9:16 PM, Robert Hoo wrote:
> > On Thu, 2023-03-02 at 14:41 +0800, Binbin Wu wrote:
> > > __linearize is not the only path the modified LAM canonical check
> > > needed, also some vmexits path should be taken care of, like VMX,
> > > SGX
> > > ENCLS.
> > > 
> > 
> > SGX isn't in this version's implementation's scope, like nested
> > LAM.
> 
> LAM in SGX enclave mode is not the scope of the this version.
> But I think since the capability is exposed to guest, 

I think you can document this or other method to call out this to user.
Even Kernel enabling doesn't include SGX interaction yet, I doubt if
it's that urgent for KVM to do this at this phase.

> need to cover the 
> case if the guest use the supervisor mode pointer

No business with pointer mode here, I think.

>  as the operand of SGX 
> EENCS operations.
> 
> 
> > 
> > > Also the instruction INVLPG, INVPCID should have some special
> > > handling
> > > since LAM is not applied to the memory operand of the two
> > > instruction
> > > according to the LAM spec.
> > 
> > The spec's meaning on these 2 is: LAM masking doesn't apply to
> > their
> > operands (the address), so the behavior is like before LAM feature
> > introduced. No change.
> 
> Yes, LAM are not applied to the 2 instrustions, but the __linearize
> is 
> changed.
> For example, the emulation of invlpg (em_invpg) will also call it.
> So 
> need to handle the case specificlly.
> Can add a flag as the input of linearize to indicate the LAM check
> and 
> untag is needed or not.
> 
No need.

"The INVLPG instruction ...
LAM does not apply to the specified memory address. Thus, in 64-bit
mode, ** if the memory address specified is in non-canonical form then
the INVLPG is the same as a NOP. **

The INVPCID instruction ...
LAM does not apply to the specified memory address, and in 64-bit
mode ** if this memory address is in non-canonical form then the
processor generates a #GP(0) exception. **"

You can double confirm in SDM: Before-and-After LAM introduced, the
behavior hasn't changed. Thus you don't need to worry about these 2
INS's emulations.

