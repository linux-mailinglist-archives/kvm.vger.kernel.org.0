Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 100724F9D8F
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 21:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239212AbiDHTOr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 15:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiDHTOq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 15:14:46 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03EB1D3737;
        Fri,  8 Apr 2022 12:12:41 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id t13so8547471pgn.8;
        Fri, 08 Apr 2022 12:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Uy4F0Fk/PWFh6uay6zK20+cILya0GAY2kAyzuCAi76Q=;
        b=QFVkNAEmVrpy9izWYK9CIaLbN1LvIyqUkCjYDENt2DbBbszsp7F6z29x3kpo5MtNRP
         6Wf8WzPI+a2xDCihmwMerunOJyjHMN6uqz04+geAKDPYSiaiIdaCd5hg1zN2fGchX40a
         EJZXFtuyvjyuzOF9dBrt5QKZxW+Yfv2BKqYJnxeAYs9J2eSk49myTZkY43pUHF8zscC0
         01x16lbcGDmSBHpFBGVoBOKqJD2S0bu7+NHrK5VF6zhSlMGAD97gXCEUjw5izDOtqak6
         whE8VPND2RbHjFGS0fMN6ZGKhjvT76yl5eMbw5km42Yrl5fBnRQBDwJK5EmREReaVeHm
         Dr4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Uy4F0Fk/PWFh6uay6zK20+cILya0GAY2kAyzuCAi76Q=;
        b=1fpchC8bl5X4f59bSk+k40bAuYDEfcCBskYdOrom7QrewU5+TZvg/gbhasCyg38rDK
         2gDRG+bKOrNgJtDLu0fvsRom1DzjdNPaL12louwIgoTawfQPnElVT5nS6dZEb7Dea9EO
         8RMlP0c3MpxzpIQnBX4EMc07AN1GCN/GFcpP2sNell6ZX/krxjWxnqyVPQK+6F5TW2z6
         2cNwz+ddvhow76cX4RArANPiVQ2yj5y7PNC8R/6zQubuUK8VczhgDMN9TSAt73KRCwrK
         SvR1qB/dIazqIKzwsMiyZBPBuaysUMDz/C6aPOv8psFxsboZ6s4YcAXNrtQm0Y1C3ov5
         sChQ==
X-Gm-Message-State: AOAM532PZ+qzqH4qgDtpVW5iRejl3T7veSX5tNUaXWtCdOZh7bIEbZKk
        DnjkTEiofB5U8bHXlu4nlUw/tP8OJCM=
X-Google-Smtp-Source: ABdhPJxqHQW4FI6QmzFE+h288eDNEpvFoIUxwykE1lxmJm96zIrbhC0+cEYp8LvdYbgXhnvTNIG6XQ==
X-Received: by 2002:a63:de41:0:b0:398:db26:bb6 with SMTP id y1-20020a63de41000000b00398db260bb6mr16660037pgi.516.1649445160944;
        Fri, 08 Apr 2022 12:12:40 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id q14-20020aa7960e000000b0050595cd0238sm560711pfg.99.2022.04.08.12.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 12:12:40 -0700 (PDT)
Date:   Fri, 8 Apr 2022 12:12:39 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 042/104] KVM: x86/mmu: Track shadow MMIO
 value/mask on a per-VM basis
Message-ID: <20220408191239.GD857847@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <b494b94bf2d6a5d841cb76e63e255d4cff906d83.1646422845.git.isaku.yamahata@intel.com>
 <1c7710a87eed650e4423935012e27747fb8c9dd8.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1c7710a87eed650e4423935012e27747fb8c9dd8.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 06, 2022 at 11:06:41PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> > diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> > index 5071e8332db2..ea83927b9231 100644
> > --- a/arch/x86/kvm/mmu/spte.c
> > +++ b/arch/x86/kvm/mmu/spte.c
> > @@ -29,8 +29,7 @@ u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
> >  u64 __read_mostly shadow_user_mask;
> >  u64 __read_mostly shadow_accessed_mask;
> >  u64 __read_mostly shadow_dirty_mask;
> > -u64 __read_mostly shadow_mmio_value;
> > -u64 __read_mostly shadow_mmio_mask;
> > +u64 __read_mostly shadow_default_mmio_mask;
> >  u64 __read_mostly shadow_mmio_access_mask;
> >  u64 __read_mostly shadow_present_mask;
> >  u64 __read_mostly shadow_me_mask;
> > @@ -59,10 +58,11 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
> >  	u64 spte = generation_mmio_spte_mask(gen);
> >  	u64 gpa = gfn << PAGE_SHIFT;
> >  
> > -	WARN_ON_ONCE(!shadow_mmio_value);
> > +	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value &&
> > +		     !kvm_gfn_stolen_mask(vcpu->kvm));
> >  
> >  	access &= shadow_mmio_access_mask;
> > -	spte |= shadow_mmio_value | access;
> > +	spte |= vcpu->kvm->arch.shadow_mmio_value | access;
> >  	spte |= gpa | shadow_nonpresent_or_rsvd_mask;
> >  	spte |= (gpa & shadow_nonpresent_or_rsvd_mask)
> >  		<< SHADOW_NONPRESENT_OR_RSVD_MASK_LEN;
> > @@ -279,7 +279,8 @@ u64 mark_spte_for_access_track(u64 spte)
> >  	return spte;
> >  }
> >  
> > -void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
> > +void kvm_mmu_set_mmio_spte_mask(struct kvm *kvm, u64 mmio_value, u64 mmio_mask,
> > +				u64 access_mask)
> >  {
> >  	BUG_ON((u64)(unsigned)access_mask != access_mask);
> >  	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
> > @@ -308,39 +309,32 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
> >  	    WARN_ON(mmio_value && (REMOVED_SPTE & mmio_mask) == mmio_value))
> >  		mmio_value = 0;
> >  
> > -	shadow_mmio_value = mmio_value;
> > -	shadow_mmio_mask  = mmio_mask;
> > +	kvm->arch.shadow_mmio_value = mmio_value;
> > +	kvm->arch.shadow_mmio_mask = mmio_mask;
> >  	shadow_mmio_access_mask = access_mask;
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
> >  
> > -void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
> > +void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only, u64 init_value)
> >  {
> >  	shadow_user_mask	= VMX_EPT_READABLE_MASK;
> >  	shadow_accessed_mask	= has_ad_bits ? VMX_EPT_ACCESS_BIT : 0ull;
> >  	shadow_dirty_mask	= has_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull;
> >  	shadow_nx_mask		= 0ull;
> >  	shadow_x_mask		= VMX_EPT_EXECUTABLE_MASK;
> > -	shadow_present_mask	= has_exec_only ? 0ull : VMX_EPT_READABLE_MASK;
> > +	shadow_present_mask	=
> > +		(has_exec_only ? 0ull : VMX_EPT_READABLE_MASK) | init_value;
> 
> This change doesn't seem make any sense.  Why should "Suppress #VE" bit be set
> for a present PTE?

Because W or NX violation also needs #VE.  Although the name uses present, it's
actually readable.


> >  	shadow_acc_track_mask	= VMX_EPT_RWX_MASK;
> >  	shadow_me_mask		= 0ull;
> >  
> >  	shadow_host_writable_mask = EPT_SPTE_HOST_WRITABLE;
> >  	shadow_mmu_writable_mask  = EPT_SPTE_MMU_WRITABLE;
> > -
> > -	/*
> > -	 * EPT Misconfigurations are generated if the value of bits 2:0
> > -	 * of an EPT paging-structure entry is 110b (write/execute).
> > -	 */
> > -	kvm_mmu_set_mmio_spte_mask(VMX_EPT_MISCONFIG_WX_VALUE,
> > -				   VMX_EPT_RWX_MASK, 0);
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_mmu_set_ept_masks);
> >  
> >  void kvm_mmu_reset_all_pte_masks(void)
> >  {
> >  	u8 low_phys_bits;
> > -	u64 mask;
> >  
> >  	shadow_phys_bits = kvm_get_shadow_phys_bits();
> >  
> > @@ -389,9 +383,13 @@ void kvm_mmu_reset_all_pte_masks(void)
> >  	 * PTEs and so the reserved PA approach must be disabled.
> >  	 */
> >  	if (shadow_phys_bits < 52)
> > -		mask = BIT_ULL(51) | PT_PRESENT_MASK;
> > +		shadow_default_mmio_mask = BIT_ULL(51) | PT_PRESENT_MASK;
> 
> Hmm...  Not related to this patch, but it seems there's a bug here.  On a MKTME
> enabled system (but not TDX) with 52 physical bits, the shadow_phys_bits will be
> set to < 52 (depending on how many MKTME KeyIDs are configured by BIOS).  In
> this case, bit 51 is set, but actually bit 51 isn't a reserved bit in this case.
> Instead, it is a MKTME KeyID bit.  Therefore, above setting won't cause #PF, but
> will use a non-zero MKTME keyID to access the physical address.
> 
> Paolo/Sean, any comments here?
> 
> >  	else
> > -		mask = 0;
> > +		shadow_default_mmio_mask = 0;
> > +}
> >  
> > -	kvm_mmu_set_mmio_spte_mask(mask, mask, ACC_WRITE_MASK | ACC_USER_MASK);
> > +void kvm_mmu_set_default_mmio_spte_mask(u64 mask)
> > +{
> > +	shadow_default_mmio_mask = mask;
> >  }
> > +EXPORT_SYMBOL_GPL(kvm_mmu_set_default_mmio_spte_mask);
> > diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> > index 8e13a35ab8c9..bde843bce878 100644
> > --- a/arch/x86/kvm/mmu/spte.h
> > +++ b/arch/x86/kvm/mmu/spte.h
> > @@ -165,8 +165,7 @@ extern u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
> >  extern u64 __read_mostly shadow_user_mask;
> >  extern u64 __read_mostly shadow_accessed_mask;
> >  extern u64 __read_mostly shadow_dirty_mask;
> > -extern u64 __read_mostly shadow_mmio_value;
> > -extern u64 __read_mostly shadow_mmio_mask;
> > +extern u64 __read_mostly shadow_default_mmio_mask;
> >  extern u64 __read_mostly shadow_mmio_access_mask;
> >  extern u64 __read_mostly shadow_present_mask;
> >  extern u64 __read_mostly shadow_me_mask;
> > @@ -229,10 +228,10 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
> >   */
> >  extern u8 __read_mostly shadow_phys_bits;
> >  
> > -static inline bool is_mmio_spte(u64 spte)
> > +static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
> >  {
> > -	return (spte & shadow_mmio_mask) == shadow_mmio_value &&
> > -	       likely(shadow_mmio_value);
> > +	return (spte & kvm->arch.shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&
> > +		likely(kvm->arch.shadow_mmio_value || kvm_gfn_stolen_mask(kvm));
> 
> I don't like using kvm_gfn_stolen_mask() to check whether SPTE is MMIO. 
> kvm_gfn_stolen_mask() really doesn't imply anything regarding to setting up the
> value of MMIO SPTE.  At least, I guess we can use some is_protected_vm() sort of
> things since it implies guest memory is protected therefore legacy way handling
> of MMIO doesn't work (i.e. you cannot parse MMIO instruction).

As discussed in other thread, let's rename those functions.


> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 07fd892768be..00f88aa25047 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7065,6 +7065,14 @@ int vmx_vm_init(struct kvm *kvm)
> >  	if (!ple_gap)
> >  		kvm->arch.pause_in_guest = true;
> >  
> > +	/*
> > +	 * EPT Misconfigurations can be generated if the value of bits 2:0
> > +	 * of an EPT paging-structure entry is 110b (write/execute).
> > +	 */
> > +	if (enable_ept)
> > +		kvm_mmu_set_mmio_spte_mask(kvm, VMX_EPT_MISCONFIG_WX_VALUE,
> > +					   VMX_EPT_MISCONFIG_WX_VALUE, 0);
> 
> Should be:
> 
> 	kvm_mmu_set_mmio_spte_mask(kvm, VMX_EPT_MISCONFIG_WX_VALUE,
> 				   	VMX_EPT_RWX_MASK, 0);

Thanks for catching it.  It's fixed in github repo.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
