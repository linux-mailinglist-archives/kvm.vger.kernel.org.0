Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02FBA57C774
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 11:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbiGUJWX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 05:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiGUJWV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 05:22:21 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024313D58D;
        Thu, 21 Jul 2022 02:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658395341; x=1689931341;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kqbkFzk5QokId2wm+eoTCqGrfTCQMoqbGZnB/kqmoA4=;
  b=C88P4xDNDsLreSFiQIPVSvzv4w9ctVlrABBU3x8Nf6+GeS8eWzgu644u
   w3kvfwp8mZ4U9kqDfx2JOIf0Hj9VHmOhNnEIwADqsnplWFu6fuJtnfyx8
   Q6Vdbq7GBkqT0otzdpuWPJus0DA1oVccrcE0pItj6qtDLeM7lpPgaZxmO
   SZ6/gVRepHtX8jRG5TVDtebS6aP5m4Fq3Ork+7Mn+7A6t4moR8b9pbR2j
   F1xWOEFhoyu2emXR0OAc1JxDJblo8C3tFhzrKqxbhhaWybVnEaObjo0Ho
   c3NP3XN5dd5WWJ8blJzDkIfxE/P1DQfoG4NRVu6nAvC9MEEgTFJSD5k2I
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="288162938"
X-IronPort-AV: E=Sophos;i="5.92,289,1650956400"; 
   d="scan'208";a="288162938"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 02:22:20 -0700
X-IronPort-AV: E=Sophos;i="5.92,289,1650956400"; 
   d="scan'208";a="573667492"
Received: from mpeng-mobl1.ccr.corp.intel.com (HELO localhost) ([10.249.169.45])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 02:22:17 -0700
Date:   Thu, 21 Jul 2022 17:22:14 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com,
        joro@8bytes.org, wanpengli@tencent.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: X86: Explicitly set the 'fault.async_page_fault'
 value in kvm_fixup_and_inject_pf_error().
Message-ID: <20220721092214.tohdta5ewba556th@linux.intel.com>
References: <20220718074756.53788-1-yu.c.zhang@linux.intel.com>
 <Ytb/le8ymDSyx8oJ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ytb/le8ymDSyx8oJ@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 19, 2022 at 07:01:41PM +0000, Sean Christopherson wrote:
> On Mon, Jul 18, 2022, Yu Zhang wrote:
> > kvm_fixup_and_inject_pf_error() was introduced to fixup the error code(
> > e.g., to add RSVD flag) and inject the #PF to the guest, when guest
> > MAXPHYADDR is smaller than the host one.
> > 
> > When it comes to nested, L0 is expected to intercept and fix up the #PF
> > and then inject to L2 directly if
> > - L2.MAXPHYADDR < L0.MAXPHYADDR and
> > - L1 has no intention to intercept L2's #PF (e.g., L2 and L1 have the
> >   same MAXPHYADDR value && L1 is using EPT for L2),
> > instead of constructing a #PF VM Exit to L1. Currently, with PFEC_MASK
> > and PFEC_MATCH both set to 0 in vmcs02, the interception and injection
> > may happen on all L2 #PFs.
> > 
> > However, failing to initialize 'fault' in kvm_fixup_and_inject_pf_error()
> > may cause the fault.async_page_fault being NOT zeroed, and later the #PF
> > being treated as a nested async page fault, and then being injected to L1.
> > Instead of zeroing 'fault' at the beginning of this function, we mannually
> > set the value of 'fault.async_page_fault', because false is the value we
> > really expect.
> > 
> > Fixes: 897861479c064 ("KVM: x86: Add helper functions for illegal GPA checking and page fault injection")
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216178
> > Reported-by: Yang Lixiao <lixiao.yang@intel.com>
> > Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> No need for my SoB, I was just providing feedback.  Other than that, 
> 
Thanks! It's a very detailed suggestion. :)

> Reviewed-by: Sean Christopherson <seanjc@google.com>
> 

@Paolo Any comment on this fix, and on the test case change(https://www.spinics.net/lists/kvm/msg283600.html)? Thanks!

B.R.
Yu
