Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E46278F47
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 19:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbgIYRAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 13:00:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:2149 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgIYRAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 13:00:47 -0400
IronPort-SDR: HdzKTVl1mHh9/M7UVqUkbo+8YCG0n/AprBsd6UTurIRUNQUVSvTng8ezp0WQAv+oWBEcMsep+x
 AfKroZxOmdDw==
X-IronPort-AV: E=McAfee;i="6000,8403,9755"; a="149236260"
X-IronPort-AV: E=Sophos;i="5.77,302,1596524400"; 
   d="scan'208";a="149236260"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 10:00:44 -0700
IronPort-SDR: 6N8ivLkqnnd2bn5U+j4zqY15q1XntncTtYZH1JiR4NLnvBVXx96w0CnbSmk4HwsES3EEo7c23V
 rfEb4OHh8buw==
X-IronPort-AV: E=Sophos;i="5.77,302,1596524400"; 
   d="scan'208";a="310885499"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 10:00:44 -0700
Date:   Fri, 25 Sep 2020 10:00:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        kvm-ppc@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [RFC PATCH 0/3] KVM: Introduce "VM bugged" concept
Message-ID: <20200925170042.GB31528@linux.intel.com>
References: <20200923224530.17735-1-sean.j.christopherson@intel.com>
 <874knlrf4a.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874knlrf4a.wl-maz@kernel.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 05:32:53PM +0100, Marc Zyngier wrote:
> Hi Sean,
> 
> On Wed, 23 Sep 2020 23:45:27 +0100,
> Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > 
> > This series introduces a concept we've discussed a few times in x86 land.
> > The crux of the problem is that x86 has a few cases where KVM could
> > theoretically encounter a software or hardware bug deep in a call stack
> > without any sane way to propagate the error out to userspace.
> > 
> > Another use case would be for scenarios where letting the VM live will
> > do more harm than good, e.g. we've been using KVM_BUG_ON for early TDX
> > enabling as botching anything related to secure paging all but guarantees
> > there will be a flood of WARNs and error messages because lower level PTE
> > operations will fail if an upper level operation failed.
> > 
> > The basic idea is to WARN_ONCE if a bug is encountered, kick all vCPUs out
> > to userspace, and mark the VM as bugged so that no ioctls() can be issued
> > on the VM or its devices/vCPUs.
> > 
> > RFC as I've done nowhere near enough testing to verify that rejecting the
> > ioctls(), evicting running vCPUs, etc... works as intended.
> 
> I'm quite like the idea. However, I wonder whether preventing the
> vcpus from re-entering the guest is enough. When something goes really
> wrong, is it safe to allow the userspace process to terminate normally
> and free the associated memory?

Yes and no.  Yes, there are potential scenarios where freeing memory is unsafe,
e.g. with TDX, improper sanitization of memory can lead to machine checks due
to integrity errors, i.e. freeing memory that wasn't sanitized is not safe.

But, our in-development code intentionally leaks pages that couldn't be
sanitized (with plenty of yelling).  So, "no" in the sense that, IMO, KVM
should be written such that it's sufficiently paranoid when handling "special"
memory (or other state).

> And is it still safe to allow new VMs to be started?

Hmm, anything that is truly fatal to the host/KVM should probably use BUG()
or even panic() directly.  E.g. to avoid a userspace bypass by unloading and
reloading KVM when it's built as a module, we'd have to set a flag in the
kernel proper.
