Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD34BA71EE
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 19:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729736AbfICRuK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 13:50:10 -0400
Received: from mga07.intel.com ([134.134.136.100]:23751 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728864AbfICRuK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 13:50:10 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 10:50:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,463,1559545200"; 
   d="scan'208";a="194429187"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga002.jf.intel.com with ESMTP; 03 Sep 2019 10:50:09 -0700
Date:   Tue, 3 Sep 2019 10:50:09 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nadav Amit <namit@vmware.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] x86: nVMX: Do not use test_skip()
 when multiple tests are run
Message-ID: <20190903175009.GK10768@linux.intel.com>
References: <20190830204031.3100-1-namit@vmware.com>
 <20190830204031.3100-2-namit@vmware.com>
 <20190903172840.GJ10768@linux.intel.com>
 <62FE01A3-810C-4254-92F2-D7047865752B@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <62FE01A3-810C-4254-92F2-D7047865752B@vmware.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 03, 2019 at 05:44:00PM +0000, Nadav Amit wrote:
> > On Sep 3, 2019, at 10:28 AM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > 
> > On Fri, Aug 30, 2019 at 01:40:30PM -0700, Nadav Amit wrote:
> >> Using test_skip() when multiple tests are run causes all the following
> >> tests to be skipped. Instead, just print a message and return.
> >> 
> >> Fixes: 47cc3d85c2fe ("nVMX x86: Check PML and EPT on vmentry of L2 guests")
> >> Fixes: 7fd449f2ed2e ("nVMX x86: Check VPID value on vmentry of L2 guests")
> >> Fixes: 181219bfd76b ("x86: Add test for checking NMI controls on vmentry of L2 guests")
> >> Fixes: 1d70eb823e12 ("nVMX x86: Check EPTP on vmentry of L2 guests")
> >> Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> >> Signed-off-by: Nadav Amit <namit@vmware.com>
> > 
> > invvpid_test_v2() also has a bunch of bad calls to test_skip().
> 
> In the case of invvpid_test_v2() the use seems correct, as the call is not
> encapsulated within a group of tests. You want to skip all the tests if
> invvpid is not supported for some reason.

Ah, I misread the code, I was thinking the longjmp was headed out of the
loop on vmx_tests.

> > What about removing test_skip() entirely?  The code for in_guest looks
> > suspect, e.g. at a glance it should use HYPERCALL_VMSKIP instead of
> > HYPERCALL_VMABORT.  The only somewhat legit usage is the ept tests, and
> > only then because the ept tests are all at the end of the array.
> > Returning success/failure from ept_access_test_setup() seems like a
> > better solution than test_skip.
> 
> I don’t know. test_skip() does seem “nice” in theory (as long as it is not
> used improperly). 

Agreed after rereading the code.

> Having said that, the fact that it uses HYPERCALL_VMABORT
> does seem wrong. I think it should be a separate change though.

Definitely.  I'll look at it when I get the chance.
