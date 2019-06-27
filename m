Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDED57CED
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 09:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfF0HMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 03:12:37 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:52547 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbfF0HMh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 03:12:37 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hgOZu-0003ul-58; Thu, 27 Jun 2019 09:12:18 +0200
Date:   Thu, 27 Jun 2019 09:12:16 +0200 (CEST)
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
In-Reply-To: <b52b0f72-e242-68b1-640c-85759bdce869@linux.intel.com>
Message-ID: <alpine.DEB.2.21.1906270901120.32342@nanos.tec.linutronix.de>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com> <1560897679-228028-12-git-send-email-fenghua.yu@intel.com> <b52b0f72-e242-68b1-640c-85759bdce869@linux.intel.com>
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


A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

A: Yes
Q: Should I trim all irrelevant context?

On Thu, 27 Jun 2019, Xiaoyao Li wrote:
>
> Do you have any comments on this one as the policy of how to expose split lock
> detection (emulate TEST_CTL) for guest changed.
> 
> This patch makes the implementation as below:
> 
> Host	|Guest	|Actual value in guest	|split lock happen in guest
> ------------------------------------------------------------------
> on	|off	|	on		|report #AC to userspace
> 	|on	|	on		|inject #AC back to guest
> ------------------------------------------------------------------
> off	|off	|	off		|No #AC
> 	|on	|	on		|inject #AC back to guest

A: Because it's way better to provide implementation details and useless
   references to the SDM.

Q: What's the reason that this table is _NOT_ part of the changelog?

> In case 2, when split lock detection of both host and guest on, if there is a
> split lock is guest, it will inject #AC back to userspace. Then if #AC is from
> guest userspace apps, guest kernel sends SIGBUS to userspace apps instead of
> whole guest killed by host. If #AC is from guest kernel, guest kernel may
> clear it's split lock bit in test_ctl msr and re-execute the instruction, then
> it goes into case 1, the #AC will report to host userspace, e.g., QEMU.

The real interesting question is whether the #AC on split lock prevents the
actual bus lock or not. If it does then the above is fine.

If not, then it would be trivial for a malicious guest to set the
SPLIT_LOCK_ENABLE bit and "handle" the exception pro forma, return to the
offending instruction and trigger another one. It lowers the rate, but that
doesn't make it any better.

The SDM is as usual too vague to be useful. Please clarify.

Thanks,

	tglx
