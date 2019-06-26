Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABC0B573ED
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 23:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfFZVwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 17:52:15 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50424 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfFZVwO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 17:52:14 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hgFpg-0008Cm-OQ; Wed, 26 Jun 2019 23:52:00 +0200
Date:   Wed, 26 Jun 2019 23:51:59 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Fenghua Yu <fenghua.yu@intel.com>
cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
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
Subject: Re: [PATCH v9 15/17] x86/split_lock: Add documentation for split
 lock detection interface
In-Reply-To: <1560897679-228028-16-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.DEB.2.21.1906262348540.32342@nanos.tec.linutronix.de>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com> <1560897679-228028-16-git-send-email-fenghua.yu@intel.com>
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

On Tue, 18 Jun 2019, Fenghua Yu wrote:

> It is useful for development and debugging to document the new debugfs
> interface /sys/kernel/debug/x86/split_lock_detect.
> 
> A new debugfs documentation is created to describe the split lock detection
> interface. In the future, more entries may be added in the documentation to
> describe other interfaces under /sys/kernel/debug/x86 directory.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  Documentation/ABI/testing/debugfs-x86 | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>  create mode 100644 Documentation/ABI/testing/debugfs-x86
> 
> diff --git a/Documentation/ABI/testing/debugfs-x86 b/Documentation/ABI/testing/debugfs-x86
> new file mode 100644
> index 000000000000..17a1e9ed6712
> --- /dev/null
> +++ b/Documentation/ABI/testing/debugfs-x86
> @@ -0,0 +1,21 @@
> +What:		/sys/kernel/debugfs/x86/split_lock_detect
> +Date:		May 2019
> +Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
> +Description:	(RW) Control split lock detection on Intel Tremont and
> +		future CPUs
> +
> +		Reads return split lock detection status:
> +			0: disabled
> +			1: enabled
> +
> +		Writes enable or disable split lock detection:
> +			The first character is one of 'Nn0' or [oO][fF] for off
> +			disables the feature.
> +			The first character is one of 'Yy1' or [oO][nN] for on
> +			enables the feature.
> +
> +		Please note the interface only shows or controls global setting.
> +		During run time, split lock detection on one CPU may be
> +		disabled if split lock operation in kernel code happens on
> +		the CPU. The interface doesn't show or control split lock
> +		detection on individual CPU.

But it should show that the debug output for the kernel has been globally
disabled instead of merily stating 'enabled' while it's already disabled on
a bunch on CPUs. I fundamentally despise inconsistent information. Even in
debugfs files inconsistency is a pain because it make debugging via mail/
bugzille etc. unnecessarily cumbersome.

Thanks,

	tglx


