Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B494F727A
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 05:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238425AbiDGDHm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 23:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239625AbiDGDHd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 23:07:33 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BD01728A2;
        Wed,  6 Apr 2022 20:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649300734; x=1680836734;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gTlEW+MnEt4Yg4ugz2gQv4geZPmPTLyREDOaBsuLWF8=;
  b=W64r/Vsoiiv/YzBW493ruXp5HzBPy0qzDfC/mQzXX9TJA5yTVkfKKlLq
   vDRfW/CGhciMFMhlVucVCth6RF7L0jw2RaVuhtbSiqDFs5FL5BfRlStom
   5GOWvPN8Ag92UwlK7fq/yPuHRLlP5fGXMHfupHpK9jqI//YNntd9mP6Av
   GD1qqTfonJlCnTsDC9bkAwb+aVBt7S8o7U2kqyVP3FjtqKcT7mZBAPUip
   V2BLjjf/p6RKgaM/6REThtEuVwV4dNqgXc9lecJ4qWrxBmp2ws5JC+fTV
   +padftdo5av3A2OBfbTRoQ7X1jRIvw82ZulRd+DJxrsa04iapY1iSmkVF
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="241146947"
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="241146947"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 20:05:34 -0700
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="570852321"
Received: from mgailhax-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.55.23])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 20:05:31 -0700
Message-ID: <1f66f2e10041f95d8780f294c7f951f4b518395f.camel@intel.com>
Subject: Re: [RFC PATCH v5 042/104] KVM: x86/mmu: Track shadow MMIO
 value/mask on a per-VM basis
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Thu, 07 Apr 2022 15:05:29 +1200
In-Reply-To: <1c7710a87eed650e4423935012e27747fb8c9dd8.camel@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <b494b94bf2d6a5d841cb76e63e255d4cff906d83.1646422845.git.isaku.yamahata@intel.com>
         <1c7710a87eed650e4423935012e27747fb8c9dd8.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-04-06 at 23:06 +1200, Kai Huang wrote:
> >   void kvm_mmu_reset_all_pte_masks(void)
> >   {
> >   	u8 low_phys_bits;
> > -	u64 mask;
> >   
> >   	shadow_phys_bits = kvm_get_shadow_phys_bits();
> >   
> > @@ -389,9 +383,13 @@ void kvm_mmu_reset_all_pte_masks(void)
> >   	 * PTEs and so the reserved PA approach must be disabled.
> >   	 */
> >   	if (shadow_phys_bits < 52)
> > -		mask = BIT_ULL(51) | PT_PRESENT_MASK;
> > +		shadow_default_mmio_mask = BIT_ULL(51) | PT_PRESENT_MASK;
> 
> Hmm...  Not related to this patch, but it seems there's a bug here.  On a
> MKTME
> enabled system (but not TDX) with 52 physical bits, the shadow_phys_bits will
> be
> set to < 52 (depending on how many MKTME KeyIDs are configured by BIOS).  In
> this case, bit 51 is set, but actually bit 51 isn't a reserved bit in this
> case.
> Instead, it is a MKTME KeyID bit.  Therefore, above setting won't cause #PF,
> but
> will use a non-zero MKTME keyID to access the physical address.
> 
> Paolo/Sean, any comments here?

After looking at the code more carefully, this is not correct.  shadow_phys_bits
will be 52 on a MKTME-enabled system.  Please ignore this.

-- 
Thanks,
-Kai


