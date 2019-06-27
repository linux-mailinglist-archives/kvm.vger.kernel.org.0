Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1115823B
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 14:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfF0MMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 08:12:06 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53483 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfF0MMF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 08:12:05 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hgTFg-0001sk-Kg; Thu, 27 Jun 2019 14:11:44 +0200
Date:   Thu, 27 Jun 2019 14:11:43 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Xiaoyao Li <xiaoyao.li@linux.intel.com>
cc:     Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Christopherson Sean J <sean.j.christopherson@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH v9 11/17] kvm/vmx: Emulate MSR TEST_CTL
In-Reply-To: <fa53c72c-b1af-7d77-d39c-a9401dc65e27@linux.intel.com>
Message-ID: <alpine.DEB.2.21.1906271408380.32342@nanos.tec.linutronix.de>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com> <1560897679-228028-12-git-send-email-fenghua.yu@intel.com> <b52b0f72-e242-68b1-640c-85759bdce869@linux.intel.com> <alpine.DEB.2.21.1906270901120.32342@nanos.tec.linutronix.de>
 <fa53c72c-b1af-7d77-d39c-a9401dc65e27@linux.intel.com>
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

On Thu, 27 Jun 2019, Xiaoyao Li wrote:
> On 6/27/2019 3:12 PM, Thomas Gleixner wrote:
> > The real interesting question is whether the #AC on split lock prevents the
> > actual bus lock or not. If it does then the above is fine.
> > 
> > If not, then it would be trivial for a malicious guest to set the
> > SPLIT_LOCK_ENABLE bit and "handle" the exception pro forma, return to the
> > offending instruction and trigger another one. It lowers the rate, but that
> > doesn't make it any better.
> > 
> > The SDM is as usual too vague to be useful. Please clarify.
> > 
> This feature is to ensure no bus lock (due to split lock) in hardware, that to
> say, when bit 29 of TEST_CTL is set, there is no bus lock due to split lock
> can be acquired.

So enabling this prevents the bus lock, i.e. the exception is raised before
that happens.

Please add that information to the changelog as well because that's
important to know and makes me much more comfortable handing the #AC back
into the guest when it has it enabled.

Thanks,

	tglx
