Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 665DB176488
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 21:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgCBUCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 15:02:30 -0500
Received: from mga14.intel.com ([192.55.52.115]:29490 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgCBUCa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 15:02:30 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 12:02:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,508,1574150400"; 
   d="scan'208";a="351618287"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 02 Mar 2020 12:02:29 -0800
Date:   Mon, 2 Mar 2020 12:02:29 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/13] KVM: x86: Allow userspace to disable the
 emulator
Message-ID: <20200302200229.GE6244@linux.intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com>
 <3ec358a8-859d-9ef1-7392-372d55b28ee4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ec358a8-859d-9ef1-7392-372d55b28ee4@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 02, 2020 at 07:42:31PM +0100, Paolo Bonzini wrote:
> On 19/02/20 00:29, Sean Christopherson wrote:
> > The primary intent of this series is to dynamically allocate the emulator
> > and get KVM to a state where the emulator *could* be disabled at some
> > point in the future.  Actually allowing userspace to disable the emulator
> > was a minor change at that point, so I threw it in.
> > 
> > Dynamically allocating the emulator shrinks the size of x86 vcpus by
> > ~2.5k bytes, which is important because 'struct vcpu_vmx' has once again
> > fattened up and squeaked past the PAGE_ALLOC_COSTLY_ORDER threshold.
> > Moving the emulator to its own allocation gives us some breathing room
> > for the near future, and has some other nice side effects.
> > 
> > As for disabling the emulator... in the not-too-distant future, I expect
> > there will be use cases that can truly disable KVM's emulator, e.g. for
> > security (KVM's and/or the guests).  I don't have a strong opinion on
> > whether or not KVM should actually allow userspace to disable the emulator
> > without a concrete use case (unless there already is a use case?), which
> > is why that part is done in its own tiny patch.
> > 
> > Running without an emulator has been "tested" in the sense that the
> > selftests that don't require emulation continue to pass, and everything
> > else fails with the expected "emulation error".
> 
> I agree with Vitaly that, if we want this, it should be a KVM_ENABLE_CAP
> instead.  The first 10 patches are very nice cleanups though so I plan
> to apply them (with Vitaly's suggested nits for review) after you answer
> the question on patch 10.

Works for me, thanks!
