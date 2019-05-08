Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65299181DD
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 23:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbfEHV7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 17:59:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:48603 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726837AbfEHV7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 17:59:44 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 14:59:31 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga003.jf.intel.com with ESMTP; 08 May 2019 14:59:31 -0700
Date:   Wed, 8 May 2019 14:59:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yi Wang <wang.yi59@zte.com.cn>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [next] KVM: lapic: allow setting apic debug dynamically
Message-ID: <20190508215931.GG19656@linux.intel.com>
References: <1557211053-17275-1-git-send-email-wang.yi59@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557211053-17275-1-git-send-email-wang.yi59@zte.com.cn>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 07, 2019 at 02:37:33PM +0800, Yi Wang wrote:
> There are many functions invoke apic_debug(), which is defined
> as a null function by default, and that's incovenient for debuging
> lapic.
> 
> This patch allows setting apic debug according to add a apic_dbg
> parameter of kvm.
> 
> Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
> ---
>  arch/x86/kvm/lapic.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 9bf70cf..4d8f10f 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -54,8 +54,13 @@
>  #define PRIu64 "u"
>  #define PRIo64 "o"
>  
> +static int apic_dbg;

s/int/bool to get this to compile.  And module params of this nature
should be tagged __read_mostly.

> +module_param(apic_dbg, bool, 0644);
> +
>  /* #define apic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg) */
> -#define apic_debug(fmt, arg...) do {} while (0)
> +#define apic_debug(fmt, arg...) do {  if (apic_dbg)   \
> +	printk(KERN_DEBUG fmt, ##arg);    \
> +} while (0)

I don't think we want to do this unless there is a very, very strong
argument to do so.  The reason debug messages like this are #ifdef'd
out is because they add conditional branches all over the place and
measurably increase the code size.  E.g.: this patch would increase
KVM's code footprint by 1100+ bytes:

 [Nr] Name              Type            Address          Off    Size   ES Flg Lk Inf Al
  [ 2] .text             PROGBITS        0000000000000000 000070 04c282 00  AX  0   0 16

vs.

  [ 2] .text             PROGBITS        0000000000000000 000070 04c6d2 00  AX  0   0 16


>  
>  /* 14 is the version for Xeon and Pentium 8.4.8*/
>  #define APIC_VERSION			(0x14UL | ((KVM_APIC_LVT_NUM - 1) << 16))
> -- 
> 1.8.3.1
> 
