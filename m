Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58C48153473
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 16:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgBEPoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 10:44:46 -0500
Received: from mga17.intel.com ([192.55.52.151]:45345 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726592AbgBEPoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 10:44:46 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 07:44:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,406,1574150400"; 
   d="scan'208";a="279408298"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Feb 2020 07:44:45 -0800
Date:   Wed, 5 Feb 2020 07:44:45 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] x86: Use "-cpu host" for PCID tests
Message-ID: <20200205154444.GE4877@linux.intel.com>
References: <20200204194809.2077-1-sean.j.christopherson@intel.com>
 <150744a7-5be7-8ed6-9eea-cc9c1b46a425@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150744a7-5be7-8ed6-9eea-cc9c1b46a425@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 05, 2020 at 04:26:40PM +0100, Paolo Bonzini wrote:
> On 04/02/20 20:48, Sean Christopherson wrote:
> > Use the host CPU model for the PCID tests to allow testing the various
> > combinations of PCID and INVPCID enabled/disabled without having to
> > manually change the kvm-unit-tests command line.  I.e. give users the
> > option of changing the command line *OR* running on a (virtual) CPU
> > with or without PCID and/or INVPCID.
> 
> I don't understand. :)

I was trying to test a change in the code that clears INVPCID in guest's
CPUID if PCID isn't supported.  To do that, I ran the PCID unit test in L1,
using L0 Qemu to hide PCID and/or INVPCID from L1 to iterate over the four
combinations of PCID and INVPCID being enabled/disabled.  But the test in
L1 never exercised INVPCID=y because unittest.cfg runs with the test with
"-cpu=qemu64,+pcid".

By using qemu64, the only way to test INVPCID=y is to manually run the test
a different "-cpu..." command.  The idea behind "-cpu=host" is to enable
running different combinations of the test in L1 by hiding features from L1
instead of by running the test with different commands.

In other words, if I create an L1 with PCID=y and INVPCID=y, I expect that
running the as-configured PCID unit tests would actually test PCID=Y and
INVPCID=y.
