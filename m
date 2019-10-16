Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B14C9D9429
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 16:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404753AbfJPOnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 10:43:46 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50458 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727291AbfJPOnq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 10:43:46 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iKkWM-0006wq-TK; Wed, 16 Oct 2019 16:43:26 +0200
Date:   Wed, 16 Oct 2019 16:43:26 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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
In-Reply-To: <8808c9ac-0906-5eec-a31f-27cbec778f9c@intel.com>
Message-ID: <alpine.DEB.2.21.1910161519260.2046@nanos.tec.linutronix.de>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com> <1560897679-228028-10-git-send-email-fenghua.yu@intel.com> <alpine.DEB.2.21.1906262209590.32342@nanos.tec.linutronix.de> <20190626203637.GC245468@romley-ivt3.sc.intel.com>
 <alpine.DEB.2.21.1906262338220.32342@nanos.tec.linutronix.de> <20190925180931.GG31852@linux.intel.com> <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com> <alpine.DEB.2.21.1910161142560.2046@nanos.tec.linutronix.de> <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com>
 <c3ff2fb3-4380-fb07-1fa3-15896a09e748@intel.com> <d30652bb-89fa-671a-5691-e2c76af231d0@redhat.com> <8808c9ac-0906-5eec-a31f-27cbec778f9c@intel.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Oct 2019, Xiaoyao Li wrote:
> On 10/16/2019 7:26 PM, Paolo Bonzini wrote:
> > Old guests are prevalent enough that enabling split-lock detection by
> > default would be a big usability issue.  And even ignoring that, you
> > would get the issue you describe below:
> 
> Right, whether enabling split-lock detection is made by the administrator. The
> administrator is supposed to know the consequence of enabling it. Enabling it
> means don't want any split-lock happens in userspace, of course VMM softwares
> are under control.

I have no idea what you are talking about, but the whole thing is trivial
enough to describe in a decision matrix:

N | #AC       | #AC enabled | SMT | Ctrl    | Guest | Action
R | available | on host     |     | exposed | #AC   |
--|-----------|-------------|-----|---------|-------|---------------------
  |           |             |     |         |       |
0 | N         |     x       |  x  |   N     |   x   | None
  |           |             |     |         |       |
1 | Y         |     N       |  x  |   N     |   x   | None
  |           |             |     |         |       |
2 | Y         |     Y       |  x  |   Y     |   Y   | Forward to guest
  |           |             |     |         |       |
3 | Y         |     Y       |  N  |   Y     |   N   | A) Store in vCPU and
  |           |             |     |         |       |    toggle on VMENTER/EXIT
  |           |             |     |         |       |
  |           |             |     |         |       | B) SIGBUS or KVM exit code
  |           |             |     |         |       |
4 | Y         |     Y       |  Y  |   Y     |   N   | A) Disable globally on
  |           |             |     |         |       |    host. Store in vCPU/guest
  |           |             |     |         |       |    state and evtl. reenable
  |           |             |     |         |       |    when guest goes away.
  |           |             |     |         |       | 
  |           |             |     |         |       | B) SIGBUS or KVM exit code

  [234] need proper accounting and tracepoints in KVM

  [34]  need a policy decision in KVM

Now there are a two possible state transitions:

 #AC enabled on host during runtime

   Existing guests are not notified. Nothing changes.


 #AC disabled on host during runtime

   That only affects state #2 from the above table and there are two
   possible solutions:

     1) Do nothing.

     2) Issue a notification to the guest. This would be doable at least
     	for Linux guests because any guest kernel which handles #AC is
	at least the same generation as the host which added #AC.

   	Whether it's worth it, I don't know, but it makes sense at least
	for consistency reasons.

     For a first step I'd go for 'Do nothing'

SMT state transitions could be handled in a similar way, but I don't think
it's worth the trouble. The above should cover everything at least on a
best effort basis.

Thanks,

	tglx
