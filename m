Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24FF8D8CD9
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 11:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392057AbfJPJrP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 05:47:15 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49480 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389173AbfJPJrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 05:47:15 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iKftX-0001qC-R8; Wed, 16 Oct 2019 11:47:03 +0200
Date:   Wed, 16 Oct 2019 11:47:03 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
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
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH v9 09/17] x86/split_lock: Handle #AC exception for split
 lock
In-Reply-To: <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com>
Message-ID: <alpine.DEB.2.21.1910161142560.2046@nanos.tec.linutronix.de>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com> <1560897679-228028-10-git-send-email-fenghua.yu@intel.com> <alpine.DEB.2.21.1906262209590.32342@nanos.tec.linutronix.de> <20190626203637.GC245468@romley-ivt3.sc.intel.com>
 <alpine.DEB.2.21.1906262338220.32342@nanos.tec.linutronix.de> <20190925180931.GG31852@linux.intel.com> <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Oct 2019, Paolo Bonzini wrote:
> On 25/09/19 20:09, Sean Christopherson wrote:
> >   - Remove KVM loading of MSR_TEST_CTRL, i.e. KVM *never* writes the CPU's
> >     actual MSR_TEST_CTRL.  KVM still emulates MSR_TEST_CTRL so that the
> >     guest can do WRMSR and handle its own #AC faults, but KVM doesn't
> >     change the value in hardware.
> > 
> >       * Allowing guest to enable split-lock detection can induce #AC on
> >         the host after it has been explicitly turned off, e.g. the sibling
> >         hyperthread hits an #AC in the host kernel, or worse, causes a
> >         different process in the host to SIGBUS.
> > 
> >       * Allowing guest to disable split-lock detection opens up the host
> >         to DoS attacks.
> > 
> >   - KVM advertises split-lock detection to guest/userspace if and only if
> >     split_lock_detect_disabled is zero.
> > 
> >   - Add a pr_warn_once() in KVM that triggers if split locks are disabled
> >     after support has been advertised to a guest.
> > 
> > Does this sound sane?
> 
> Not really, unfortunately.  Just never advertise split-lock detection to
> guests.  If the host has enabled split-lock detection, trap #AC and
> forward it to the host handler---which would disable split lock
> detection globally and reenter the guest.

Which completely defeats the purpose.

1) Sane guest

   Guest kernel has #AC handler and you basically prevent it from detecting
   malicious user space and killing it. You also prevent #AC detection in
   the guest kernel which limits debugability.

2) Malicious guest

   Trigger #AC to disable the host detection and then carry out the DoS
   attack.

Try again.

Thanks,

	tglx
