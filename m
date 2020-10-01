Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B3827F6DF
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 02:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732261AbgJAAuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 20:50:50 -0400
Received: from mga06.intel.com ([134.134.136.31]:16253 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730155AbgJAAuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 20:50:50 -0400
IronPort-SDR: XwDaK8Pu50MlxwFJaFtHbBExUmA+wfVVhNI8gli80t2g/kg00rRG7+ezGIV0gqiN2Qqjk+WkgH
 osM1/PPgHaag==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="224191697"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="224191697"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 17:50:45 -0700
IronPort-SDR: zzWp8FNr668IQ5GQjFyU9cpz1qcqsFaxhqS8h+vAZG1QMbrKPCDAvRVwG33Hqt/5YcL62YFy3S
 IHF6BJWOtNXQ==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="351734009"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 17:50:43 -0700
Date:   Wed, 30 Sep 2020 17:50:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 3/4 v2] KVM: nSVM: Test non-MBZ reserved bits in CR3 in
 long mode
Message-ID: <20201001005041.GE2988@linux.intel.com>
References: <20200928072043.9359-1-krish.sadhukhan@oracle.com>
 <20200928072043.9359-4-krish.sadhukhan@oracle.com>
 <20200929031154.GC31514@linux.intel.com>
 <5f236941-5086-167a-6518-6191d8ef04cf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5f236941-5086-167a-6518-6191d8ef04cf@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 30, 2020 at 05:29:24PM -0700, Krish Sadhukhan wrote:
> 
> On 9/28/20 8:11 PM, Sean Christopherson wrote:
> >On Mon, Sep 28, 2020 at 07:20:42AM +0000, Krish Sadhukhan wrote:
> >>According to section "CR3" in APM vol. 2, the non-MBZ reserved bits in CR3
> >>need to be set by software as follows:
> >>
> >>	"Reserved Bits. Reserved fields should be cleared to 0 by software
> >>	when writing CR3."
> >Nothing in the shortlog or changelog actually states what this patch does.
> >"Test non-MBZ reserved bits in CR3 in long mode" is rather ambiguous, and
> >IIUC, the changelog is straight up misleading.
> >
> >Based on the discussion from v1, I _think_ this test verifies that KVM does
> >_not_ fail nested VMRUN if non-MBZ bits are set, correct?
> 
> Not KVM, hardware rather.  Hardware doesn't consider it as an invalid guest
> state if non-MBZ reserved bits are set.
> >
> >If so, then something like:
> >
> >   KVM: nSVM: Verify non-MBZ CR3 reserved bits can be set in long mode
> >
> >with further explanation in the changelog would be very helpful.
> 
> Even though the non-MBZ reserved bits are ignored by the consistency checks
> in hardware, eventually page-table walks fail. So, I am wondering whether it

Page table walks fail how?  Are you referring to forcing the #NPF, or does
the CPU puke on the non-MBZ reserved bits at some point?

> is appropriate to say,
> 
>             "Verify non-MBZ CR3 reserved bits can be set in long mode"
> 
> because the test is inducing an artificial failure even before any guest
> instruction is executed. We are not entering the guest with these bits set.

Yes we are, unless I'm misunderstanding how SVM handles VMRUN.  "entering" the
guest does not mean successfully executing guest code, it means loading guest
state and completing the world switch.  I don't think I'm misunderstanding,
because the test explicitly clears the NPT PML4[0]'s present bit to induce a
#NPF.  That means the CPU is fetching instructions, and again unless there's
details about NPT that I'm missing, the fact that the test sees a #NPF means
that the CPU successfully completed the GVA->GPA translation using the "bad"
CR3.

> I prefer to keep the commit header as is and rather expand the commit
> message to explain what I have described here. How about that ?

That's fine, so long as it documents both what the test is actually verifying
and what is/isn't legal.
