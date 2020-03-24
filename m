Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D13E4191863
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 19:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgCXSCQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 14:02:16 -0400
Received: from mga06.intel.com ([134.134.136.31]:44915 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727466AbgCXSCQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 14:02:16 -0400
IronPort-SDR: vNku9zUzny8Uuw9u1Zs0fnRB+6BT0NOL1mG8dN/MnV9/pNwkhiQ66QgYUn+nka7Nnbt61e379y
 rmmc8mr0JgQg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 11:02:08 -0700
IronPort-SDR: OYNmRJu447qOcND1nZkGVdZNobHuJ6KpDHrR/c/VCRNJ9Xf1O6/kIyfSfkNhndXoOg3chI0nLn
 jX3d1rqFGfMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,301,1580803200"; 
   d="scan'208";a="325988332"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 24 Mar 2020 11:02:07 -0700
Date:   Tue, 24 Mar 2020 11:02:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, hpa@zytor.com,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v5 3/9] x86/split_lock: Re-define the kernel param option
 for split_lock_detect
Message-ID: <20200324180207.GD5998@linux.intel.com>
References: <20200315050517.127446-1-xiaoyao.li@intel.com>
 <20200315050517.127446-4-xiaoyao.li@intel.com>
 <87r1xjov3a.fsf@nanos.tec.linutronix.de>
 <e708f6d2-8f96-903c-0bce-2eeecc4a237d@intel.com>
 <87r1xidoj1.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1xidoj1.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 24, 2020 at 11:40:18AM +0100, Thomas Gleixner wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> > On 3/24/2020 1:10 AM, Thomas Gleixner wrote:
> >> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> >> 
> >>> Change sld_off to sld_disable, which means disabling feature split lock
> >>> detection and it cannot be used in kernel nor can kvm expose it guest.
> >>> Of course, the X86_FEATURE_SPLIT_LOCK_DETECT is not set.
> >>>
> >>> Add a new optioin sld_kvm_only, which means kernel turns split lock
> >>> detection off, but kvm can expose it to guest.
> >> 
> >> What's the point of this? If the host is not clean, then you better fix
> >> the host first before trying to expose it to guests.
> >
> > It's not about whether or not host is clean. It's for the cases that 
> > users just don't want it enabled on host, to not break the applications 
> > or drivers that do have split lock issue.
> 
> It's very much about whether the host is split lock clean.
> 
> If your host kernel is not, then this wants to be fixed first. If your
> host application is broken, then either fix it or use "warn".

The "kvm only" option was my suggestion.  The thought was to provide a way
for users to leverage KVM to debug/test kernels without having to have a
known good kernel and/or to minimize the risk of crashing their physical
system.  E.g. debug a misbehaving driver by assigning its associated device
to a guest.
