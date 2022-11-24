Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDC7637582
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 10:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiKXJqd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 04:46:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiKXJq3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 04:46:29 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095D0129C2B;
        Thu, 24 Nov 2022 01:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ks1H8LH0BwkXY5vORDZGIvyia5Wd5A6kpehSBFlNEBY=; b=erf680/HVVr5bFzSvnt96yD+iA
        xz/OeAheGIsEoie2tjZO0CqnCada0PKlTjn0EYBSSlAexpnS3FVXtSlUQTcYWNFEqn5uoEmRT2To7
        EqNUU1ck+tPFRFAhd8FvB/lrkpm9qGrXRZfYU++722JDp9+SwDAmuPJX9prfUZg1Ikeet58589DOv
        FpJQ3VchFPtVqUvQ7C+oxnKbU8mhstYPVe+YRrzlXSl33jB/QkmKTWQfwk6QmYlC81h2cMVL6v0g1
        Go06abJLPiD75+Zyc3hZmHoothW68bLcUylvo0BWlHJXzcyxbEmVxEch6IxHbDPLhck3FdHQPUhEw
        dbrRtIrw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oy8o0-004885-2T; Thu, 24 Nov 2022 09:46:04 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B70C0300446;
        Thu, 24 Nov 2022 10:46:02 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8C19F2C1A6A6D; Thu, 24 Nov 2022 10:46:02 +0100 (CET)
Date:   Thu, 24 Nov 2022 10:46:02 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Li, Xin3" <xin3.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Message-ID: <Y389WnT9BKPhTsgM@hirez.programming.kicks-ass.net>
References: <Y3IFo9NrAcYalBzM@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161299749E12D484DE9302BA8049@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y3NZQBJugRt07udw@hirez.programming.kicks-ass.net>
 <DM5PR1101MB2172D7D7BC49255DB3752802A8069@DM5PR1101MB2172.namprd11.prod.outlook.com>
 <Y3ZYiKbJacmejY3K@google.com>
 <BN6PR1101MB21611347D37CF40403B974EDA8099@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <BN6PR1101MB2161FCA1989E3C6499192028A80D9@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y302kxLEhcp20d65@google.com>
 <BN6PR1101MB216162F44664713802201FAFA80C9@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y36Fy/OYO5u0AzEG@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y36Fy/OYO5u0AzEG@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 23, 2022 at 08:42:51PM +0000, Sean Christopherson wrote:
>  arch/x86/kvm/kvm_cache_regs.h | 16 +++++------
>  arch/x86/kvm/vmx/vmenter.S    |  4 +--
>  arch/x86/kvm/vmx/vmx.c        | 51 ++++++++++++++++++-----------------
>  arch/x86/kvm/vmx/vmx.h        |  2 +-
>  arch/x86/kvm/x86.h            |  6 ++---
>  5 files changed, 41 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index c09174f73a34..af9bd0374915 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -50,26 +50,26 @@ BUILD_KVM_GPR_ACCESSORS(r15, R15)
>   * 1	  0	  register in vcpu->arch
>   * 1	  1	  register in vcpu->arch, needs to be stored back
>   */
> -static inline bool kvm_register_is_available(struct kvm_vcpu *vcpu,
> -					     enum kvm_reg reg)
> +static __always_inline bool kvm_register_is_available(struct kvm_vcpu *vcpu,
> +						      enum kvm_reg reg)
>  {
>  	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
>  }
>  
> -static inline bool kvm_register_is_dirty(struct kvm_vcpu *vcpu,
> -					 enum kvm_reg reg)
> +static __always_inline bool kvm_register_is_dirty(struct kvm_vcpu *vcpu,
> +						  enum kvm_reg reg)
>  {
>  	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
>  }
>  
> -static inline void kvm_register_mark_available(struct kvm_vcpu *vcpu,
> -					       enum kvm_reg reg)
> +static __always_inline void kvm_register_mark_available(struct kvm_vcpu *vcpu,
> +							enum kvm_reg reg)
>  {
>  	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
>  }
>  
> -static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
> -					   enum kvm_reg reg)
> +static __always_inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
> +						    enum kvm_reg reg)
>  {
>  	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
>  	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);

You'll have to consider include/asm-generic/bitops/instrumented-non-atomic.h
and friend, and the above should probably switch to using:

  arch_test_bit(), arch___set_bit() resp.

to avoid the explicit instrumentation.

