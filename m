Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355AB589664
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 05:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238616AbiHDDOq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 23:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiHDDOp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 23:14:45 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3FC52FC1;
        Wed,  3 Aug 2022 20:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659582884; x=1691118884;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=squso8r/c+UWK6kXhvD4uSt0IoOM/RkbfSgBXz2VYGk=;
  b=RgIvnJgGHprWw7TXc15sAoEMPG9ddk0De5AwampAUp/84f8KOkXbSFuo
   AJzQql6Frb6woU/mCPgprUDeiCyp/xw7PFHABIG3e75jaUsICbx2v/tH6
   xAAOEcC7hw4d3nMnkkdF4OGESWu2TAvJ//nMYSkQXmihyaEbpH3SDOKB6
   fD4I9woJ3+ldAXE3iUbwjte/yLgjAQweaZ3u5gprYnO3P2BMIJfSCU4nj
   I+vhxsBYsNohGvLbm9YrAr0H/I0zteySiyx0dBmc4mQpgCrjhgUWwAxQd
   7le9djcbyexAYDLh5SK7f5+psNBMBsu6vDvh0wd34RdTB+ZH77rZTOBkX
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10428"; a="276745235"
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="276745235"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 20:14:43 -0700
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="578895482"
Received: from yxing1-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.169.130])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 20:14:40 -0700
Date:   Thu, 4 Aug 2022 11:14:36 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, jmattson@google.com,
        joro@8bytes.org, wanpengli@tencent.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: X86: Explicitly set the 'fault.async_page_fault'
 value in kvm_fixup_and_inject_pf_error().
Message-ID: <20220804031436.scozztchwd6iqxbv@linux.intel.com>
References: <20220718074756.53788-1-yu.c.zhang@linux.intel.com>
 <Ytb/le8ymDSyx8oJ@google.com>
 <20220721092214.tohdta5ewba556th@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721092214.tohdta5ewba556th@linux.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 21, 2022 at 05:22:14PM +0800, Yu Zhang wrote:
> On Tue, Jul 19, 2022 at 07:01:41PM +0000, Sean Christopherson wrote:
> > On Mon, Jul 18, 2022, Yu Zhang wrote:
> > > kvm_fixup_and_inject_pf_error() was introduced to fixup the error code(
> > > e.g., to add RSVD flag) and inject the #PF to the guest, when guest
> > > MAXPHYADDR is smaller than the host one.
> > > 
> > > When it comes to nested, L0 is expected to intercept and fix up the #PF
> > > and then inject to L2 directly if
> > > - L2.MAXPHYADDR < L0.MAXPHYADDR and
> > > - L1 has no intention to intercept L2's #PF (e.g., L2 and L1 have the
> > >   same MAXPHYADDR value && L1 is using EPT for L2),
> > > instead of constructing a #PF VM Exit to L1. Currently, with PFEC_MASK
> > > and PFEC_MATCH both set to 0 in vmcs02, the interception and injection
> > > may happen on all L2 #PFs.
> > > 
> > > However, failing to initialize 'fault' in kvm_fixup_and_inject_pf_error()
> > > may cause the fault.async_page_fault being NOT zeroed, and later the #PF
> > > being treated as a nested async page fault, and then being injected to L1.
> > > Instead of zeroing 'fault' at the beginning of this function, we mannually
> > > set the value of 'fault.async_page_fault', because false is the value we
> > > really expect.
> > > 
> > > Fixes: 897861479c064 ("KVM: x86: Add helper functions for illegal GPA checking and page fault injection")
> > > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216178
> > > Reported-by: Yang Lixiao <lixiao.yang@intel.com>
> > > Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > 
> > No need for my SoB, I was just providing feedback.  Other than that, 
> > 
> Thanks! It's a very detailed suggestion. :)
> 
> > Reviewed-by: Sean Christopherson <seanjc@google.com>
> > 
> 
> @Paolo Any comment on this fix, and on the test case change(https://www.spinics.net/lists/kvm/msg283600.html)? Thanks!
> 
> B.R.
> Yu

Ping... Or should I send another version? Thanks!

B.R.
Yu
