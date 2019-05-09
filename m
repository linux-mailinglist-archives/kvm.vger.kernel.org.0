Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB0A1934E
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 22:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfEIUUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 16:20:01 -0400
Received: from mga17.intel.com ([192.55.52.151]:4228 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726952AbfEIUUB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 16:20:01 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 May 2019 13:20:00 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga006.jf.intel.com with ESMTP; 09 May 2019 13:20:00 -0700
Date:   Thu, 9 May 2019 13:20:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yi Wang <wang.yi59@zte.com.cn>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [next] KVM: lapic: allow set apic debug dynamically
Message-ID: <20190509201959.GA12810@linux.intel.com>
References: <1557398877-32750-1-git-send-email-wang.yi59@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557398877-32750-1-git-send-email-wang.yi59@zte.com.cn>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 09, 2019 at 06:47:57PM +0800, Yi Wang wrote:
> There are many functions invoke apic_debug(), which is defined
> a null function by default, and that's incovenient for debuging
> lapic.
> 
> This patch allows setting apic debug according to add a apic_dbg
> parameter of kvm.
> 
> Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
> ---
> v2: change apic_dbg to bool and tag __read_mostly. Thanks to Sean.
> 
>  arch/x86/kvm/lapic.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 9bf70cf..0827e7c 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -54,8 +54,13 @@
>  #define PRIu64 "u"
>  #define PRIo64 "o"
>  
> +static bool apic_dbg __read_mostly;
> +module_param(apic_dbg, bool, 0644);

Probably don't need to shorten "debug".

> +
>  /* #define apic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg) */
> -#define apic_debug(fmt, arg...) do {} while (0)
> +#define apic_debug(fmt, arg...) do {  if (apic_dbg)   \
> +	printk(KERN_DEBUG fmt, ##arg);    \
> +} while (0)

Pulling in your comment regarding sched_debug and noirqdebug...

On Thu, May 09, 2019 at 08:29:38AM +0800, wang.yi59@zte.com.cn wrote:
> Also, we have some similar parameters already, such like sched_debug,
> noirqdebug :)

The IRQ debug hook is a completely different beast than the APIC debug
messages.

sched_debug is a much better comparison.  The param only exists if
CONFIG_SCHED_DEBUG=y, which is "default y" but "depends on DEBUG_KERNEL".
That seems like the route to go if we want the ability to toggle APIC
debugging at runtime.  And if we go with an all encompassing config,
e.g. CONFIG_KVM_DEBUG, we can use it to wrap x86/mmu.c's debug param as
well (and rename it to mmu_debug).

>  
>  /* 14 is the version for Xeon and Pentium 8.4.8*/
>  #define APIC_VERSION			(0x14UL | ((KVM_APIC_LVT_NUM - 1) << 16))
> -- 
> 1.8.3.1
> 
