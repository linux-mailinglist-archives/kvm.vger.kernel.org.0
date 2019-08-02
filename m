Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08CBA802AC
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2019 00:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388697AbfHBWXX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 18:23:23 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40613 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730633AbfHBWXX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 18:23:23 -0400
Received: from pd9ef1cb8.dip0.t-ipconnect.de ([217.239.28.184] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1htfwv-0002gc-Jk; Sat, 03 Aug 2019 00:22:57 +0200
Date:   Sat, 3 Aug 2019 00:22:54 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Julia Cartwright <julia@ni.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, kvm@vger.kernel.org,
        Radim Krcmar <rkrcmar@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: Re: [patch 2/5] x86/kvm: Handle task_work on VMENTER/EXIT
In-Reply-To: <c8294b01-62d1-95df-6ff6-213f945a434f@redhat.com>
Message-ID: <alpine.DEB.2.21.1908030015330.4029@nanos.tec.linutronix.de>
References: <20190801143250.370326052@linutronix.de> <20190801143657.887648487@linutronix.de> <20190801162451.GE31538@redhat.com> <alpine.DEB.2.21.1908012025100.1789@nanos.tec.linutronix.de> <20190801213550.GE6783@linux.intel.com>
 <alpine.DEB.2.21.1908012343530.1789@nanos.tec.linutronix.de> <alpine.DEB.2.21.1908012345000.1789@nanos.tec.linutronix.de> <c8294b01-62d1-95df-6ff6-213f945a434f@redhat.com>
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

On Fri, 2 Aug 2019, Paolo Bonzini wrote:
> On 01/08/19 23:47, Thomas Gleixner wrote:
> > Right you are about cond_resched() being called, but for SRCU this does not
> > matter unless there is some way to do a synchronize operation on that SRCU
> > entity. It might have some other performance side effect though.
> 
> I would use srcu_read_unlock/lock around the call.
> 
> However, I'm wondering if the API can be improved because basically we
> have six functions for three checks of TIF flags.  Does it make sense to
> have something like task_has_request_flags and task_do_requests (names
> are horrible I know) that can be used like
> 
> 	if (task_has_request_flags()) {
> 		int err;
> 		...srcu_read_unlock...
> 		// return -EINTR if signal_pending
> 		err = task_do_requests();
> 		if (err < 0)
> 			goto exit_no_srcu_read_unlock;
> 		...srcu_read_lock...
> 	}
> 
> taking care of all three cases with a single hook?  This is important
> especially because all these checks are done by all KVM architectures in
> slightly different ways, and a unified API would be a good reason to
> make all architectures look the same.
> 
> (Of course I could also define this unified API in virt/kvm/kvm_main.c,
> so this is not blocking the series in any way!).

You're not holding up something. Having a common function for this is
definitely the right approach.

As this is virt specific because it only checks for non arch specific bits
(TIF_NOTIFY_RESUME should be available for all KVM archs) and the TIF bits
are a subset of the available TIF bits because all others do not make any
sense there, this really should be a common function for KVM so that all
other archs which obviously lack a TIF_NOTIFY_RESUME check, can be fixed up
and consolidated. If we add another TIF check later then we only have to do
it in one place.

Thanks,

	tglx
