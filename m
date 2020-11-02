Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DCD2A318F
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 18:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbgKBRbf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 12:31:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:58695 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgKBRbf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 12:31:35 -0500
IronPort-SDR: Qp1/uALvXGx4w5lJK0MqhrW1/UV8ahNVVg37THQP/y6PKC2OqffeD0sW8hiIre9i8ueuUPNv+h
 SR69FTHoAZUw==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="155909597"
X-IronPort-AV: E=Sophos;i="5.77,445,1596524400"; 
   d="scan'208";a="155909597"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 09:31:34 -0800
IronPort-SDR: XDYVXdpZ637dAUON1ShOdypkhvFUCwXcWPE21VX6qdWBLfkxhohSWuTOtBiK7a1QP//whSl54N
 zjidFknihj3w==
X-IronPort-AV: E=Sophos;i="5.77,445,1596524400"; 
   d="scan'208";a="528093774"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 09:31:33 -0800
Date:   Mon, 2 Nov 2020 09:31:32 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Tao Xu <tao3.xu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH] KVM: VMX: Enable Notify VM exit
Message-ID: <20201102173130.GC21563@linux.intel.com>
References: <20201102061445.191638-1-tao3.xu@intel.com>
 <CALCETrVqdq4zw=Dcd6dZzSmUZTMXHP50d=SRSaY2AV5sauUzOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVqdq4zw=Dcd6dZzSmUZTMXHP50d=SRSaY2AV5sauUzOw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 02, 2020 at 08:43:30AM -0800, Andy Lutomirski wrote:
> On Sun, Nov 1, 2020 at 10:14 PM Tao Xu <tao3.xu@intel.com> wrote:
> > 2. Another patch to disable interception of #DB and #AC when notify
> > VM-Exiting is enabled.
> 
> Whoa there.
> 
> A VM control that says "hey, CPU, if you messed up and livelocked for
> a long time, please break out of the loop" is not a substitute for
> fixing the livelocks.  So I don't think you get do disable
> interception of #DB and #AC.

I think that can be incorporated into a module param, i.e. let the platform
owner decide which tool(s) they want to use to mitigate the legacy architecture
flaws.

> I also think you should print a loud warning

I'm not so sure on this one, e.g. userspace could just spin up a new instance
if its malicious guest and spam the kernel log.

> and have some intelligent handling when this new exit triggers.

We discussed something similar in the context of the new bus lock VM-Exit.  I
don't know that it makes sense to try and add intelligence into the kernel.
In many use cases, e.g. clouds, the userspace VMM is trusted (inasmuch as
userspace can be trusted), while the guest is completely untrusted.  Reporting
the error to userspace and letting the userspace stack take action is likely
preferable to doing something fancy in the kernel.


Tao, this patch should probably be tagged RFC, at least until we can experiment
with the threshold on real silicon.  KVM and kernel behavior may depend on the
accuracy of detecting actual attacks, e.g. if we can set a threshold that has
zero false negatives and near-zero false postives, then it probably makes sense
to be more assertive in how such VM-Exits are reported and logged.
