Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351CD1D5078
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 16:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgEOO3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 10:29:32 -0400
Received: from mga14.intel.com ([192.55.52.115]:24702 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgEOO3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 10:29:31 -0400
IronPort-SDR: MxhfQV6JLrqJ5Y8TC0XWQILeVqOzdWmadBvxjerjvFqb/S+2en2b+g+QouUpGBmu9DzwJe6hq8
 b19vXmcQhvhA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 07:29:31 -0700
IronPort-SDR: 5Mod3dLutkOQAA7qN2CR+FnarTJ77VTVx42GX7ZN5icfvxbrg/i/9tJ3mMBxYkEtsrVJJs26LH
 f0nIvRJpUdvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,395,1583222400"; 
   d="scan'208";a="266618493"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 15 May 2020 07:29:30 -0700
Date:   Fri, 15 May 2020 07:29:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 1/3 v3] KVM: x86: Create mask for guest CR4 reserved bits
 in kvm_update_cpuid()
Message-ID: <20200515142930.GB17572@linux.intel.com>
References: <20200515053609.3347-1-krish.sadhukhan@oracle.com>
 <20200515053609.3347-2-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515053609.3347-2-krish.sadhukhan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 15, 2020 at 01:36:07AM -0400, Krish Sadhukhan wrote:
> Instead of creating the mask for guest CR4 reserved bits in kvm_valid_cr4(),
> do it in kvm_update_cpuid() so that it can be reused instead of creating it
> each time kvm_valid_cr4() is called.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/cpuid.c            |  2 ++
>  arch/x86/kvm/x86.c              | 24 ++----------------------
>  arch/x86/kvm/x86.h              | 21 +++++++++++++++++++++
>  4 files changed, 27 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 42a2d0d..e2d9e4b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -820,6 +820,8 @@ struct kvm_vcpu_arch {
>  
>  	/* AMD MSRC001_0015 Hardware Configuration */
>  	u64 msr_hwcr;
> +
> +	u64 guest_cr4_reserved_bits;

This can be an 'unsigned long', the u64 type in the existing code is a goof
on my part.  I'd also vote to co-locate it with the other cr4 variables and
abbreviate reserved to keep the name manageable, e.g.

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ae6a93ed83d39..21ece121e1858 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -573,6 +573,7 @@ struct kvm_vcpu_arch {
        unsigned long cr3;
        unsigned long cr4;
        unsigned long cr4_guest_owned_bits;
+       unsigned long cr4_guest_rsvd_bits;
        unsigned long cr8;
        u32 pkru;
        u32 hflags;
