Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B0D1A6DB8
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 23:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388711AbgDMVDX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 17:03:23 -0400
Received: from mga17.intel.com ([192.55.52.151]:9081 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733294AbgDMVDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 17:03:21 -0400
IronPort-SDR: Vq39kN+fgtq4ONm26zf422RiYXdh8Dg8UNLlOnaw/OMLV+FUx7rlrXn42xOPD8VOoNUa7Kd4eF
 3qd0pFwPFYlQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2020 14:03:20 -0700
IronPort-SDR: SUSb0/CTAwUjQg6ehDXpMOr7u4mG0dmFDGUa6IybO0PIa8Kh4DcwBG3K7TG8qZOHA09V/+Iz96
 l0d7FsFz+ySg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,380,1580803200"; 
   d="scan'208";a="453303181"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 13 Apr 2020 14:03:20 -0700
Date:   Mon, 13 Apr 2020 14:03:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [RFC PATCH] KVM: SVM: Use do_machine_check to pass MCE to the
 host
Message-ID: <20200413210320.GA21204@linux.intel.com>
References: <20200411153627.3474710-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200411153627.3474710-1-ubizjak@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 11, 2020 at 05:36:27PM +0200, Uros Bizjak wrote:
> Use do_machine_check instead of INT $12 to pass MCE to the host,
> the same approach VMX uses.
> 
> On a related note, there is no reason to limit the use of do_machine_check
> to 64 bit targets, as is currently done for VMX. MCE handling works
> for both target families.

...

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 8959514eaf0f..01330096ff3e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4572,7 +4572,7 @@ static int handle_rmode_exception(struct kvm_vcpu *vcpu,
>   */
>  static void kvm_machine_check(void)
>  {
> -#if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_64)
> +#if defined(CONFIG_X86_MCE)

This VMX change needs to be a separate patch, and it arguably warrants:

  Cc: stable@vger.kernel.org
  Fixes: a0861c02a981 ("KVM: Add VT-x machine check support")

>  	struct pt_regs regs = {
>  		.cs = 3, /* Fake ring 3 no matter what the guest ran on */
>  		.flags = X86_EFLAGS_IF,
> -- 
> 2.25.2
> 
