Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D559122A046
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 21:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732360AbgGVTsG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 15:48:06 -0400
Received: from mga03.intel.com ([134.134.136.65]:61947 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbgGVTsG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 15:48:06 -0400
IronPort-SDR: dFYppU4XYY9lYqN3wpz+zx6Dc/i+Lm+34jLybgjumL7E7TsdIDotmUCAXXGOB+hnCa8BNQWmRh
 GFi4QIiRzHYQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="150387669"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="150387669"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 12:48:05 -0700
IronPort-SDR: r9maA/iucCrZf50hkHfb11scgmVnKBrFPuIo4JMHXQ5WBXO+oKh/rBRkE/qauSg6XRTdnSFFoh
 UV68JX0FhFdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="320399186"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga002.fm.intel.com with ESMTP; 22 Jul 2020 12:48:05 -0700
Date:   Wed, 22 Jul 2020 12:48:05 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [RESEND PATCH v13 00/11] Introduce support for guest CET feature
Message-ID: <20200722194805.GB9114@linux.intel.com>
References: <20200716031627.11492-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716031627.11492-1-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 16, 2020 at 11:16:16AM +0800, Yang Weijiang wrote:
> Control-flow Enforcement Technology (CET) provides protection against
> Return/Jump-Oriented Programming (ROP/JOP) attack. There're two CET
> sub-features: Shadow Stack (SHSTK) and Indirect Branch Tracking (IBT).
> SHSTK is to prevent ROP programming and IBT is to prevent JOP programming.
> 
> Several parts in KVM have been updated to provide VM CET support, including:
> CPUID/XSAVES config, MSR pass-through, user space MSR access interface, 
> vmentry/vmexit config, nested VM etc. These patches have dependency on CET
> kernel patches for xsaves support and CET definitions, e.g., MSR and related
> feature flags.
> 
> CET kernel patches are here:
> https://lkml.kernel.org/r/20200429220732.31602-1-yu-cheng.yu@intel.com
> 
> v13:
> - Added CET definitions as a separate patch to facilitate KVM test.

What I actually want to do is pull in actual kernel patches themselves so
that we can upstream KVM support without having to wait for the kernel to
sort out the ABI, which seems like it's going to drag on.

I was thinking that we'd only need the MSR/CR4/CPUID definitions, but forgot
that KVM also needs XSAVES context switching, so it's not as simple as I was
thinking.  It's still relatively simple, but it means there would be
functional changes in the kernel.

I'll respond to the main SSP series to pose the question of taking the two
small-ish kernel patches through the KVM tree.

>  arch/x86/include/asm/kvm_host.h      |   4 +-
>  arch/x86/include/asm/vmx.h           |   8 +
>  arch/x86/include/uapi/asm/kvm.h      |   1 +
>  arch/x86/include/uapi/asm/kvm_para.h |   7 +-
>  arch/x86/kvm/cpuid.c                 |  28 ++-
>  arch/x86/kvm/vmx/capabilities.h      |   5 +
>  arch/x86/kvm/vmx/nested.c            |  34 ++++
>  arch/x86/kvm/vmx/vmcs12.c            | 267 ++++++++++++++++-----------
>  arch/x86/kvm/vmx/vmcs12.h            |  14 +-
>  arch/x86/kvm/vmx/vmx.c               | 262 +++++++++++++++++++++++++-
>  arch/x86/kvm/x86.c                   |  53 +++++-
>  arch/x86/kvm/x86.h                   |   2 +-
>  include/linux/kvm_host.h             |  32 ++++
>  13 files changed, 590 insertions(+), 127 deletions(-)

I have quite a few comments/changes (will respond to individual patches),
but have done all the updates/rework and, assuming I haven't broken things,
we're nearing the point where I can carry this and push it past the finish
line, e.g. get acks from tip/x86 maintainers for the kernel patches and
send a pull request to Paolo.

I pushed the result to:

  https://github.com/sean-jc/linux/releases/tag/kvm-cet-v14-rc1

can you please review and test?  If everything looks good, I'll post v14.
If not, I'll work offline with you to get it into shape.

Thanks!
