Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6860717E00
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 18:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727515AbfEHQWP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 12:22:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:17199 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727150AbfEHQWP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 12:22:15 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 09:21:59 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga006.fm.intel.com with ESMTP; 08 May 2019 09:21:59 -0700
Date:   Wed, 8 May 2019 09:21:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     bugzilla-daemon@bugzilla.kernel.org,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [Bug 203543] Starting with kernel 5.1.0-rc6,  kvm_intel can no
 longer be loaded in nested kvm/guests
Message-ID: <20190508162158.GA19656@linux.intel.com>
References: <bug-203543-28872@https.bugzilla.kernel.org/>
 <bug-203543-28872-daKc1aTVTb@https.bugzilla.kernel.org/>
 <CFB6AAEE-1B47-4D1D-9083-68F138964B68@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CFB6AAEE-1B47-4D1D-9083-68F138964B68@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 07:00:54PM +0300, Liran Alon wrote:
> +Paolo
> 
> What are your thoughts on this?  What is the reason that KVM relies on
> CPU_BASED_RDPMC_EXITING to be exposed from underlying CPU? How is it critical
> for it’s functionality?  If it’s because we want to make sure that we hide
> host PMCs, we should condition this to be a min requirement of kvm_intel only
> in case underlying CPU exposes PMU to begin with.  Do you agree? If yes, I
> can create the patch to fix this.

I sent a revert of the change to hide CPU_BASED_RDPMC_EXITING, KVM's
previous behavior is correct.  The RDPMC instruction was introduced long
before Architctural Perf Mon and so the existence of the exiting control
is dependent only on the instruction, e.g. P4 (Prescott), Core (Yonah)
and Core2 (Merom) all support VMX and RDPMC with non-archictectural
perf mon capabilities.

The KVM unit test first execute RDPMC with interception disabled in the
unit test host, i.e. the #GP is the correct architectural behavior and
needs to be handled by the unit test.  The most robust fix would be to
eat any #GP on RDPMC in the unit test, though it's likely much simpler
to only execute RDPMC with interception disabled if arch perf mon is
supported.
