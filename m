Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA072F2642
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 03:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbhALCZZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 21:25:25 -0500
Received: from mga07.intel.com ([134.134.136.100]:3978 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbhALCZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 21:25:25 -0500
IronPort-SDR: HBvjqQw+qmT8B2VPezNAmfGXZJP8VMTFx3jayVp762W55HauBFPYis8GmzcJI+2t+03Fafthla
 RxhHwf+RlPhA==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="242040056"
X-IronPort-AV: E=Sophos;i="5.79,340,1602572400"; 
   d="scan'208";a="242040056"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 18:24:44 -0800
IronPort-SDR: nL9ruWuxWD/nCSoKNLHntIVgvGs+7b30LkClJCvHR6ZkTXHJz13vYx27RQZ0c2k9D+YvWkrFH0
 DQVKUMA3cIXA==
X-IronPort-AV: E=Sophos;i="5.79,340,1602572400"; 
   d="scan'208";a="381240943"
Received: from yangzhon-virtual.bj.intel.com (HELO yangzhon-Virtual) ([10.238.144.101])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA256; 11 Jan 2021 18:24:40 -0800
Date:   Tue, 12 Jan 2021 10:13:21 +0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, tony.luck@intel.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, kyung.min.park@intel.com, x86@kernel.org,
        yang.zhong@intel.com
Subject: Re: [PATCH 1/2] Enumerate AVX Vector Neural Network instructions
Message-ID: <20210112021321.GA9922@yangzhon-Virtual>
References: <20210105004909.42000-1-yang.zhong@intel.com>
 <20210105004909.42000-2-yang.zhong@intel.com>
 <8fa46290-28d8-5f61-1ce4-8e83bf911106@redhat.com>
 <20210105121456.GE28649@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105121456.GE28649@zn.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 05, 2021 at 01:14:56PM +0100, Borislav Petkov wrote:
> On Tue, Jan 05, 2021 at 12:47:23PM +0100, Paolo Bonzini wrote:
> > On 05/01/21 01:49, Yang Zhong wrote:
> > > From: Kyung Min Park <kyung.min.park@intel.com>
> > > 
> > > Add AVX version of the Vector Neural Network (VNNI) Instructions.
> > > 
> > > A processor supports AVX VNNI instructions if CPUID.0x07.0x1:EAX[4] is
> > > present. The following instructions are available when this feature is
> > > present.
> > >    1. VPDPBUS: Multiply and Add Unsigned and Signed Bytes
> > >    2. VPDPBUSDS: Multiply and Add Unsigned and Signed Bytes with Saturation
> > >    3. VPDPWSSD: Multiply and Add Signed Word Integers
> > >    4. VPDPWSSDS: Multiply and Add Signed Integers with Saturation
> > > 
> > > The only in-kernel usage of this is kvm passthrough. The CPU feature
> > > flag is shown as "avx_vnni" in /proc/cpuinfo.
> > > 
> > > This instruction is currently documented in the latest "extensions"
> > > manual (ISE). It will appear in the "main" manual (SDM) in the future.
> > > 
> > > Signed-off-by: Kyung Min Park <kyung.min.park@intel.com>
> > > Signed-off-by: Yang Zhong <yang.zhong@intel.com>
> > > Reviewed-by: Tony Luck <tony.luck@intel.com>
> > > ---
> > >   arch/x86/include/asm/cpufeatures.h | 1 +
> > >   1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> > > index f5ef2d5b9231..d10d9962bd9b 100644
> > > --- a/arch/x86/include/asm/cpufeatures.h
> > > +++ b/arch/x86/include/asm/cpufeatures.h
> > > @@ -293,6 +293,7 @@
> > >   #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
> > >   /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
> > > +#define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
> > >   #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
> > >   /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
> > > 
> > 
> > Boris, is it possible to have a topic branch for this patch?
> 
> Just take it through your tree pls.
> 
> Acked-by: Borislav Petkov <bp@suse.de>
>
  
  Paolo, Boris has acked this kernel patch, and if i need send new patchset to add this 
  acked-by info ? or kvm tree will directly pull this patchset? thanks.

  Yang  

   
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
