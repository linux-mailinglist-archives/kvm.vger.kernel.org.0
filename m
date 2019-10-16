Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 582EAD9718
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 18:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406169AbfJPQXk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 12:23:40 -0400
Received: from mga07.intel.com ([134.134.136.100]:12166 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727138AbfJPQXj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 12:23:39 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 09:23:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,304,1566889200"; 
   d="scan'208";a="208439185"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 16 Oct 2019 09:23:38 -0700
Date:   Wed, 16 Oct 2019 09:23:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH v9 09/17] x86/split_lock: Handle #AC exception for split
 lock
Message-ID: <20191016162337.GC5866@linux.intel.com>
References: <20190925180931.GG31852@linux.intel.com>
 <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com>
 <alpine.DEB.2.21.1910161142560.2046@nanos.tec.linutronix.de>
 <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com>
 <alpine.DEB.2.21.1910161244060.2046@nanos.tec.linutronix.de>
 <3a12810b-1196-b70a-aa2e-9fe17dc7341a@redhat.com>
 <b2c42a64-eb42-1f18-f609-42eec3faef18@intel.com>
 <d2fc3cbe-1506-94fc-73a4-8ed55dc9337d@redhat.com>
 <20191016154116.GA5866@linux.intel.com>
 <d235ed9a-314c-705c-691f-b31f2f8fa4e8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d235ed9a-314c-705c-691f-b31f2f8fa4e8@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 16, 2019 at 05:43:53PM +0200, Paolo Bonzini wrote:
> On 16/10/19 17:41, Sean Christopherson wrote:
> > On Wed, Oct 16, 2019 at 04:08:14PM +0200, Paolo Bonzini wrote:
> >> SIGBUS (actually a new KVM_EXIT_INTERNAL_ERROR result from KVM_RUN is
> >> better, but that's the idea) is for when you're debugging guests.
> >> Global disable (or alternatively, disable SMT) is for production use.
> > 
> > Alternatively, for guests without split-lock #AC enabled, what if KVM were
> > to emulate the faulting instruction with split-lock detection temporarily
> > disabled?
> 
> Yes we can get fancy, but remember that KVM is not yet supporting
> emulation of locked instructions.  Adding it is possible but shouldn't
> be in the critical path for the whole feature.

Ah, didn't realize that.  I'm surprised emulating all locks with cmpxchg
doesn't cause problems (or am I misreading the code?).  Assuming I'm
reading the code correctly, the #AC path could kick all other vCPUS on
emulation failure and then retry emulation to "guarantee" success.  Though
that's starting to build quite the house of cards.

> How would you disable split-lock detection temporarily?  Just tweak
> MSR_TEST_CTRL for the time of running the one instruction, and cross
> fingers that the sibling doesn't notice?

Tweak MSR_TEST_CTRL, with logic to handle the scenario where split-lock
detection is globally disable during emulation (so KVM doesn't
inadvertantly re-enable it).

There isn't much for the sibling to notice.  The kernel would temporarily
allow split-locks on the sibling, but that's a performance issue and isn't
directly fatal.  A missed #AC in the host kernel would only delay the
inevitable global disabling of split-lock.  A missed #AC in userspace would
again just delay the inevitable SIGBUS.
