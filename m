Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF9779781C
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 18:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbjIGQmB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 12:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242526AbjIGQlr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 12:41:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C8DB32F
        for <kvm@vger.kernel.org>; Thu,  7 Sep 2023 08:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694101639; x=1725637639;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+XxI/zfHIFSOE3LTQ4Z/bBIZd8YSiPCzhAZUyvnviJ0=;
  b=jUoFLZBNbjcjmpPyIDtEmydGouaML56N0P8uPNQDJQiz+0WR4SugWn1W
   OF7/qqwbgoVK0Yp2DPC7iIjLzR1hru4MHDGpC6+XPNVYY7IR0bdyFsDFq
   YPfkDaQ3e8sGp0VgtznpK2no9NotNeh9z1jZBXqPAiGxiNpWNe4opNKkC
   qWoQYg5X6WoXoQ+iNt/5KfvB7aS5/YBJHeysHZfbwpcMxNsEF5ULt7ezx
   zJ+pSl5bvQyofNapuf2DQqubrTwdFNzkoCDTVS6bmLaCitK7yZPFNIa7m
   JojRgzzGrL2OBc9u165GVPwvs+dXW7BQfow+YlHtRY+6XFcCQ9h/VnbLm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="376222550"
X-IronPort-AV: E=Sophos;i="6.02,234,1688454000"; 
   d="scan'208";a="376222550"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2023 02:59:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="691723566"
X-IronPort-AV: E=Sophos;i="6.02,234,1688454000"; 
   d="scan'208";a="691723566"
Received: from linux.bj.intel.com ([10.238.157.71])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2023 02:59:11 -0700
Date:   Thu, 7 Sep 2023 17:56:31 +0800
From:   Tao Su <tao1.su@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com,
        guang.zeng@intel.com, yi1.lai@intel.com
Subject: Re: [PATCH 2/2] KVM: x86: Clear X2APIC_ICR_UNUSED_12 after
 APIC-write VM-exit
Message-ID: <ZPmeKHNJQpgoIZmW@linux.bj.intel.com>
References: <20230904013555.725413-1-tao1.su@linux.intel.com>
 <20230904013555.725413-3-tao1.su@linux.intel.com>
 <ZPezyAyVbdZSqhzk@google.com>
 <ZPgJDacP1LeO084Z@linux.bj.intel.com>
 <ZPj6iF0Q7iynn62p@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPj6iF0Q7iynn62p@google.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 06, 2023 at 03:17:44PM -0700, Sean Christopherson wrote:
> On Wed, Sep 06, 2023, Tao Su wrote:
> > On Tue, Sep 05, 2023 at 04:03:36PM -0700, Sean Christopherson wrote:
> > > +Suravee
> > > 
> > > On Mon, Sep 04, 2023, Tao Su wrote:
> > > > When IPI virtualization is enabled, a WARN is triggered if bit12 of ICR
> > > > MSR is set after APIC-write VM-exit. The reason is kvm_apic_send_ipi()
> > > > thinks the APIC_ICR_BUSY bit should be cleared because KVM has no delay,
> > > > but kvm_apic_write_nodecode() doesn't clear the APIC_ICR_BUSY bit.
> > > > 
> > > > Since bit12 of ICR is no longer BUSY bit but UNUSED bit in x2APIC mode,
> > > > and SDM has no detail about how hardware will handle the UNUSED bit12
> > > > set, we tested on Intel CPU (SRF/GNR) with IPI virtualization and found
> > > > the UNUSED bit12 was also cleared by hardware without #GP. Therefore,
> > > > the clearing of bit12 should be still kept being consistent with the
> > > > hardware behavior.
> > > 
> > > I'm confused.  If hardware clears the bit, then why is it set in the vAPIC page
> > > after a trap-like APIC-write VM-Exit?  In other words, how is this not a ucode
> > > or hardware bug?
> > 
> > Sorry, I didn't describe it clearly.
> > 
> > On bare-metal, bit12 of ICR MSR will be cleared after setting this bit.
> > 
> > If bit12 is set in guest, the bit is not cleared in the vAPIC page after APIC-write
> > VM-Exit. So whether to clear bit12 in vAPIC page needs to be considered.
> 
> I got that, the behavior just seems odd to me.  And I'm grumpy that Intel punted
> the problem to software.  But the SDM specifically calls out that this is the
> correct behavior :-/
> 
> Specifically, in the context of IPI virtualization:
> 
>   If ECX contains 830H, a general-protection fault occurs if any of bits 31:20,
>   17:16, or 13 of EAX is non-zero.
> 
> and
> 
>   If ECX contains 830H, the processor then checks the value of VICR to determine
>   whether the following are all true:
> 
>   Bits 19:18 (destination shorthand) are 00B (no shorthand).
>   Bit 15 (trigger mode) is 0 (edge).
>   Bit 12 (unused) is 0.
>   Bit 11 (destination mode) is 0 (physical).
>   Bits 10:8 (delivery mode) are 000B (fixed).
>   
>   If all of the items above are true, the processor performs IPI virtualization
>   using the 8-bit vector in byte 0 of VICR and the 32-bit APIC ID in VICR[63:32]
>   (see Section 30.1.6). Otherwise, the logical processor causes an APIC-write VM
>   exit (see Section 30.4.3.3).  If ECX contains 830H, the processor then checks
>   the value of VICR to determine whether the following are all true:
> 
> I.e. the "unused" busy bit must be zero.  The part that makes me grumpy is that
> hardware does check that other reserved bits are actually zero:
> 
>   If special processing applies, no general-protection exception is produced due
>   to the fact that the local APIC is in xAPIC mode. However, WRMSR does perform
>   the normal reserved-bit checking:
>    - If ECX contains 808H or 83FH, a general-protection fault occurs if either EDX or EAX[31:8] is non-zero.
>    - If ECX contains 80BH, a general-protection fault occurs if either EDX or EAX is non-zero.
>    - If ECX contains 830H, a general-protection fault occurs if any of bits 31:20, 17:16, or 13 of EAX is non-zero.
> 
> Which implies that the hardware *does* enforce all the other reserved bits, but
> punted bit 12 to the hypervisor :-(
> 
> That said, I think we have an "out".  Under the x2APIC section, regarding ICR,
> the SDM also says:
> 
>   It remains readable only to aid in debugging; however, software should not
>   assume the value returned by reading the ICR is the last written value.
> 
> I.e. KVM basically has free reign to do whatever it wants, so long as it doesn't
> confuse userspace or break KVM's ABI.  As much as I want to say "do nothing",
> clearing bit 12 so that it reads back as '0' is the safer approach.  Just please
> don't add a new #define for, it's far easier to understand what's going on if we
> just use APIC_ICR_BUSY, especially given that I highly doubt the bit will actually
> be repurposed for something new.

Thanks for such a detailed analysis. I will submit a patch to clear bit12 since it is
a safer approach, and also drop the unnecessary alias.

> 
> FWIW, I also suspect that hardware isn't clearing the busy bit per se, I suspect
> that hardware simply reads the bit as zero.
> 
> Side topic, unless I'm blind, KVM is missing the reserved bits #GP checks for ICR
> bits bits 31:20, 17:16, and 13.

Yes, it is needed to check the reserved bits of ICR and inject #GP when IPI virtualization
disabled (otherwise it is injected by hardware). The related kselftest is also necessary
to verify the #GP is correctly emulated.

Thanks,
Tao

