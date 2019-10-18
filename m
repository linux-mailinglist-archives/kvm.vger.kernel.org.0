Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5D59DC07C
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 11:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633011AbfJRJCx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Oct 2019 05:02:53 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56120 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437687AbfJRJCx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Oct 2019 05:02:53 -0400
Received: from p5b06da22.dip0.t-ipconnect.de ([91.6.218.34] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iLO9f-0002Y0-4q; Fri, 18 Oct 2019 11:02:39 +0200
Date:   Fri, 18 Oct 2019 11:02:37 +0200 (CEST)
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
Subject: Re: [RFD] x86/split_lock: Request to Intel
In-Reply-To: <5da90713-9a0d-6466-64f7-db435ba07dbe@intel.com>
Message-ID: <alpine.DEB.2.21.1910181100000.1869@nanos.tec.linutronix.de>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com> <1560897679-228028-10-git-send-email-fenghua.yu@intel.com> <alpine.DEB.2.21.1906262209590.32342@nanos.tec.linutronix.de> <20190626203637.GC245468@romley-ivt3.sc.intel.com>
 <alpine.DEB.2.21.1906262338220.32342@nanos.tec.linutronix.de> <20190925180931.GG31852@linux.intel.com> <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com> <alpine.DEB.2.21.1910161142560.2046@nanos.tec.linutronix.de> <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com>
 <c3ff2fb3-4380-fb07-1fa3-15896a09e748@intel.com> <d30652bb-89fa-671a-5691-e2c76af231d0@redhat.com> <8808c9ac-0906-5eec-a31f-27cbec778f9c@intel.com> <alpine.DEB.2.21.1910161519260.2046@nanos.tec.linutronix.de> <ba2c0aab-1d7c-5cfd-0054-ac2c266c1df3@redhat.com>
 <alpine.DEB.2.21.1910171322530.1824@nanos.tec.linutronix.de> <5da90713-9a0d-6466-64f7-db435ba07dbe@intel.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 18 Oct 2019, Xiaoyao Li wrote:
> On 10/17/2019 8:29 PM, Thomas Gleixner wrote:
> > The more I look at this trainwreck, the less interested I am in merging any
> > of this at all.
> > 
> > The fact that it took Intel more than a year to figure out that the MSR is
> > per core and not per thread is yet another proof that this industry just
> > works by pure chance.
> > 
> 
> Whether it's per-core or per-thread doesn't affect much how we implement for
> host/native.

How useful.

> And also, no matter it's per-core or per-thread, we always can do something in
> VIRT.

It matters a lot. If it would be per thread then we would not have this
discussion at all.

> Maybe what matters is below.
> 
> > Seriously, this makes only sense when it's by default enabled and not
> > rendered useless by VIRT. Otherwise we never get any reports and none of
> > the issues are going to be fixed.
> > 
> 
> For VIRT, it doesn't want old guest to be killed due to #AC. But for native,
> it doesn't want VIRT to disable the #AC detection
> 
> I think it's just about the default behavior that whether to disable the
> host's #AC detection or kill the guest (SIGBUS or something else) once there
> is an split-lock #AC in guest.
> 
> So we can provide CONFIG option to set the default behavior and module
> parameter to let KVM set/change the default behavior.

Care to read through the whole discussion and figure out WHY it's not that
simple?

Thanks,

	tglx
