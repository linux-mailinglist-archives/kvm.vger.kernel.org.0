Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D76588599
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 03:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234951AbiHCB6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 21:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236006AbiHCB5v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 21:57:51 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FC456B90
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 18:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659491867; x=1691027867;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lX8nJwznbbItYIRdF9sQ+TpjIVKEM9yi99c8n2atRuo=;
  b=eIbKSoXOtdE7huX6pk47EgvCnKb2W+mpUMZdw3zDub+3a5iBLmEWEUg1
   rFIlqqSkdxTDnq+JtDA8aQayFkZtcJuiwMUaj+KY/mptVfRVpfo45j+E/
   pADptuqr9RdyX5SOKMLFyJyavR1JeUvGXBxddyUOP31hGSK9aUmjkpVrH
   I7j4ID5QwG/kNjnzWDK5R+k0P3w9kKJ5fNIwv714OOG7c2ZV92oImkiCp
   uzGfu4MoCYsplDjgdmI0U/fYzVemypcpKS2ipizdsTAijR0glpVMpWG5f
   AgUUF0TYaxcPb415kf62wccKlVwH5Acm8yXfQXFyteFK3Va4sAxwSM2DW
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10427"; a="353563701"
X-IronPort-AV: E=Sophos;i="5.93,212,1654585200"; 
   d="scan'208";a="353563701"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 18:57:47 -0700
X-IronPort-AV: E=Sophos;i="5.93,212,1654585200"; 
   d="scan'208";a="630953193"
Received: from jifangxi-mobl2.ccr.corp.intel.com (HELO localhost) ([10.249.168.16])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 18:57:45 -0700
Date:   Wed, 3 Aug 2022 09:57:42 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] X86: Set up EPT before running
 vmx_pf_exception_test
Message-ID: <20220803015742.v2kzo5edaqdmi456@linux.intel.com>
References: <20220715113334.52491-1-yu.c.zhang@linux.intel.com>
 <YumMC1hAVpTWLmap@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YumMC1hAVpTWLmap@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 02, 2022 at 08:41:47PM +0000, Sean Christopherson wrote:
> On Fri, Jul 15, 2022, Yu Zhang wrote:
> > Although currently vmx_pf_exception_test can succeed, its
> > success is actually because we are using identical mappings
> > in the page tables and EB.PF is not set by L1. In practice,
> > the #PFs shall be expected by L1, if it is using shadowing
> > for L2.
> 
> I'm a bit lost.  Is there an actual failure somewhere?  AFAICT, this passes when
> run as L1 or L2, with or without EPT enabled.

Thanks for your reply, Sean.

There's no failure. But IMHO, there should have been(for the
vmx_pf_exception_test, not the access test) -  L1 shall expect
#PF induced VM exits, when it is using shadow for L2.

B.R.
Yu


> > So just set up the EPT, and clear the EB.PT, then L1 has the
> > right to claim a failure if a #PF is encountered.
> > 
> > Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> > ---
> >  x86/vmx_tests.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c > > index
4d581e7..cc90611 100644
> > --- a/x86/vmx_tests.c
> > +++ b/x86/vmx_tests.c
> > @@ -10639,6 +10639,17 @@ static void __vmx_pf_exception_test(invalidate_tlb_t inv_fn, void *data)
> >  
> >  static void vmx_pf_exception_test(void)
> >  {
> > +	u32 eb;
> > +
> > +	if (setup_ept(false)) {
> > +		printf("EPT not supported.\n");
> > +		return;
> > +	}
> > +
> > +	eb = vmcs_read(EXC_BITMAP);
> > +	eb &= ~(1 << PF_VECTOR);
> > +	vmcs_write(EXC_BITMAP, eb);
> > +
> >  	__vmx_pf_exception_test(NULL, NULL);
> >  }
> >  
> > -- 
> > 2.25.1
> > 
