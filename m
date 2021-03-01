Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A521327BE3
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 11:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbhCAKWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 05:22:00 -0500
Received: from mga07.intel.com ([134.134.136.100]:17227 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233449AbhCAKUZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 05:20:25 -0500
IronPort-SDR: hE3B0xOXaWnOtodorhoSZVTbNNQEY7BBPGKbxzDA0NLMOO3zIdgPfGm2Kwvt83vpT7YtSRdl31
 CDgjCulhGnmQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9909"; a="250471465"
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="250471465"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 02:19:22 -0800
IronPort-SDR: HWMXbnkrsNtWwf/vwcJYkoVZPfXN3j6DfQooG3By+HbM1/NcKq1AHeYOlfNGeUGSLRPog6kwpp
 zG+rExUQaVTQ==
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="585448335"
Received: from jscomeax-mobl.amr.corp.intel.com ([10.252.139.76])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 02:19:17 -0800
Message-ID: <3fce1dd2abd42597bde7ae9496bde7b9596b2797.camel@intel.com>
Subject: Re: [PATCH 02/25] x86/cpufeatures: Add SGX1 and SGX2 sub-features
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Date:   Mon, 01 Mar 2021 23:19:15 +1300
In-Reply-To: <20210301100037.GA6699@zn.tnic>
References: <cover.1614590788.git.kai.huang@intel.com>
         <bbfc8c833a62e4b55220834320829df1e17aff41.1614590788.git.kai.huang@intel.com>
         <20210301100037.GA6699@zn.tnic>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-03-01 at 11:00 +0100, Borislav Petkov wrote:
> On Mon, Mar 01, 2021 at 10:44:29PM +1300, Kai Huang wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > 
> > Add SGX1 and SGX2 feature flags, via CPUID.0x12.0x0.EAX, as scattered
> > features, since adding a new leaf for only two bits would be wasteful.
> > As part of virtualizing SGX, KVM will expose the SGX CPUID leafs to its
> > guest, and to do so correctly needs to query hardware and kernel support
> > for SGX1 and SGX2.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Acked-by: Dave Hansen <dave.hansen@intel.com>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/include/asm/cpufeatures.h | 2 ++
> >  arch/x86/kernel/cpu/cpuid-deps.c   | 2 ++
> >  arch/x86/kernel/cpu/scattered.c    | 2 ++
> >  3 files changed, 6 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> > index cc96e26d69f7..9502c445a3e9 100644
> > --- a/arch/x86/include/asm/cpufeatures.h
> > +++ b/arch/x86/include/asm/cpufeatures.h
> > @@ -290,6 +290,8 @@
> >  #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
> >  #define X86_FEATURE_SPLIT_LOCK_DETECT	(11*32+ 6) /* #AC for split lock */
> >  #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
> > +#define X86_FEATURE_SGX1		(11*32+ 8) /* "" Basic SGX */
> > +#define X86_FEATURE_SGX2        	(11*32+ 9) /* SGX Enclave Dynamic Memory Management (EDMM) */
> 
> "sgx1" is not gonna show in /proc/cpuinfo but "sgx2" will. Because...?

There's already X86_FEATURE_SGX, which shows "sgx" in /proc/cpuinfo. Showing "sgx1"
doesn't add anything. "sgx2" is useful because it adds additional functionality.

Both Sean and Paolo suggested this. Please see below discussion:

https://www.spinics.net/lists/kvm/msg234533.html

> 
> Also, you send a patchset once a week - not after two days. Please limit
> your spamming.
> 

OK. Thanks for reminding.


