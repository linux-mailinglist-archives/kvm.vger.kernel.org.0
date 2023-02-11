Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D81692E88
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 06:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjBKF5f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Feb 2023 00:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKF5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Feb 2023 00:57:34 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F54834334
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 21:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676095052; x=1707631052;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X2tDxwxHj1OE3uCQDnX2rTJXSnqDaBa+dR2xKf7AW1Y=;
  b=mutf28fakSGLRbz5ZWJMcLu1XlRNVR1lfZgSuT19lpt49sFfgzdlaPRm
   tuFjqRAO1pwRR+TLrPM/gDlG86XJRgEcKEAgK7gzJvXn3HTPhSSj9fxkn
   rZlC6alVcNlYAlQH1ikLdu67R/huKZgoxRtZ5bjA+fGks5kdeD3oFJboU
   dzzepr5fkiSuwxea/NKAb/xLkUfFRouqHZPT2qAALl40DpEMW+J90onE0
   BpVvocFUCImBBSJbdX1So9HxG4pJ3cQUsK3uL5TOfOCUn5dC80yiMOs3c
   t35yJLsSzsh0KUQo+pLwRmLDrOr2gFSEn920dd7Psj4yIpruleeaj8wpm
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="310951939"
X-IronPort-AV: E=Sophos;i="5.97,289,1669104000"; 
   d="scan'208";a="310951939"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 21:57:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="757009243"
X-IronPort-AV: E=Sophos;i="5.97,289,1669104000"; 
   d="scan'208";a="757009243"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Feb 2023 21:57:29 -0800
Message-ID: <468be41d91840501db0bb49c4e518a0020e6018f.camel@linux.intel.com>
Subject: Re: [PATCH v4 5/9] KVM: x86: Untag LAM bits when applicable
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, isaku.yamahata@intel.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Date:   Sat, 11 Feb 2023 13:57:28 +0800
In-Reply-To: <Y+ZdFtr1fJkdCtRL@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <20230209024022.3371768-6-robert.hu@linux.intel.com>
         <Y+ZdFtr1fJkdCtRL@gao-cwp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-02-10 at 23:04 +0800, Chao Gao wrote:
> Why emit a WARN()? the behavior is undefined or something KVM cannot
> emulated?
> 
Oh, it should have been removed per Yuan's comment on last version;
sorry forgot to.
Originally, I wrote an WARN_ON() (perhaps WARN_ON_ONCE() is better)
here, as an assert this should never happen to KVM. But now considering
emulation part, it's possible. 

> > 
[...]
> 
> This is a MSR write, so LAM masking isn't performed on this write
> according to LAM spec.

Right.

> Am I misunderstanding something?
> 
> > +
[...]
> > @@ -1809,6 +1809,10 @@ static int __kvm_set_msr(struct kvm_vcpu
> > *vcpu, u32 index, u64 data,
> > 	case MSR_KERNEL_GS_BASE:
> > 	case MSR_CSTAR:
> > 	case MSR_LSTAR:
> > +		/*
> > +		 * The strict canonical checking still applies to MSR
> > +		 * writing even LAM is enabled.
> > +		 */
> > 		if (is_noncanonical_address(data, vcpu))
> 
> LAM spec says:
> 
> 	Processors that support LAM continue to require the addresses
> written to
> 	control registers or MSRs be 57-bit canonical if the processor
> supports
> 	5-level paging or 48-bit canonical if it supports only 4-level
> paging
> 
> My understanding is 57-bit canonical checking is performed if the
> processor
> __supports__ 5-level paging. Then the is_noncanonical_address() here
> is
> arguably wrong. Could you double-confirm and fix it?
> 
Emm, condition of "support" V.S. "enabled", you mean
vcpu_virt_addr_bits(), right?
{
	return kvm_read_cr4_bits(vcpu, X86_CR4_LA57) ? 57 : 48;
}

This is worth double-confirm. Let me check with Yu. Thanks.

> > 			return 1;
> > 		break;
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index 8ec5cc983062..7228895d4a6f 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -201,6 +201,38 @@ static inline bool is_noncanonical_address(u64
> > la, struct kvm_vcpu *vcpu)
> > 	return !__is_canonical_address(la, vcpu_virt_addr_bits(vcpu));
> > }
> > 
> > +#ifdef CONFIG_X86_64
> 
> I don't get the purpose of the #ifdef. Shouldn't you check if the
> vcpu
> is in 64-bit long mode?
> 
Good question, thanks. It inspires me:
1) can 32-bit host/kvm support 64-bit guest kernel?
2) if !64-bit mode (guest), should CPUID enumeration gone? or #GP on
guest attempts to set CR3/CR4 lam bits?

> > +/* untag addr for guest, according to vCPU CR3 and CR4 settings */
> > +static inline u64 kvm_untagged_addr(u64 addr, struct kvm_vcpu
> > *vcpu)
> > +{
> > +	if (addr >> 63 == 0) {
> > +		/* User pointers */
> > +		if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U57)
> > +			addr = __canonical_address(addr, 57);
> 
> braces are missing.

Careful review, thanks.
Curious this escaped checkpatch.pl.
> 
> https://www.kernel.org/doc/html/latest/process/coding-style.html#placing-braces-and-spaces
> 
> > +		else if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U48) {
> > +			/*
> > +			 * If guest enabled 5-level paging and LAM_U48,
> > +			 * bit 47 should be 0, bit 48:56 contains meta
> > data
> > +			 * although bit 47:56 are valid 5-level address
> > +			 * bits.
> > +			 * If LAM_U48 and 4-level paging, bit47 is 0.
> > +			 */
> > +			WARN_ON(addr & _BITUL(47));
> > +			addr = __canonical_address(addr, 48);
> > +		}
> > +	} else if (kvm_read_cr4(vcpu) & X86_CR4_LAM_SUP) { /*
> > Supervisor pointers */
> > +		if (kvm_read_cr4(vcpu) & X86_CR4_LA57)
> 
> use kvm_read_cr4_bits here to save potential VMCS_READs.

Right, thanks.

