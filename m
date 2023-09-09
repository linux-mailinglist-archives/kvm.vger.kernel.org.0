Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E8079948C
	for <lists+kvm@lfdr.de>; Sat,  9 Sep 2023 02:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346208AbjIIAnl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 20:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344157AbjIIAnU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 20:43:20 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02CA3C34
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 17:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694220040; x=1725756040;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=I5jvwfMsxfYlRCSXtGVsF7pNipt5ltLSaowIJo8lMxo=;
  b=jLwJyuF6v0whmtX+1eigLCbaw6QDR+noWNc0wnuah+mkgzd7vn+OyKeD
   LFwPrDAN9vdr24yT8soY/gEMqUbMLc5fqtk8U8o6WwMdrPBj6eVxht7pZ
   Eds5Z8iWd3ABcM7hfyOknl5cwaVkq2bSFcBzJVDHgwKuWiw1fpM1hXNtP
   MthEaaBWAD0jUW7+ewq4xJE2YbCkbw17Ll9/aVOaK+Eq63owp2BiDLaAs
   +yy37GhqSgVlQ5tw2uEbeSmxX05ZecmIbZs6afFbf96NC4Dm6SpfcwNsc
   +FoDJbeYmTfg7tx7soRHU/lzLQ+a8Kvn2R1K3k1zuXryAgHZVO88cnvI/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10827"; a="362829494"
X-IronPort-AV: E=Sophos;i="6.02,238,1688454000"; 
   d="scan'208";a="362829494"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2023 17:38:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10827"; a="857596786"
X-IronPort-AV: E=Sophos;i="6.02,238,1688454000"; 
   d="scan'208";a="857596786"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2023 17:38:10 -0700
Date:   Sat, 9 Sep 2023 08:35:31 +0800
From:   Tao Su <tao1.su@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        guang.zeng@intel.com, yi1.lai@intel.com
Subject: Re: [PATCH v2] KVM: x86: Clear bit12 of ICR after APIC-write VM-exit
Message-ID: <ZPu901UaixMVzOQt@linux.bj.intel.com>
References: <20230908041115.987682-1-tao1.su@linux.intel.com>
 <ZPrzfPkpLc9nSEZP@chao-email>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPrzfPkpLc9nSEZP@chao-email>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 08, 2023 at 06:12:12PM +0800, Chao Gao wrote:
> On Fri, Sep 08, 2023 at 12:11:15PM +0800, Tao Su wrote:
> >When IPI virtualization is enabled, a WARN is triggered if bit12 of ICR
> >MSR is set after APIC-write VM-exit. The reason is kvm_apic_send_ipi()
> >thinks the APIC_ICR_BUSY bit should be cleared because KVM has no delay,
> >but kvm_apic_write_nodecode() doesn't clear the APIC_ICR_BUSY bit.
> >
> >Bit12 of ICR is different from other reserved bits(31:20, 17:16 and 13).
> >When bit12 is set, it will cause APIC-wirte VM-exit but not #GP. For
> 
> s/wirte/write
> 
> >reading bit12 back as '0' which is a safer approach, clearing bit12 in
> >x2APIC mode is needed.
> 
> how about quoting what Sean said:
> (w/ a slight change to the last sentence)
> 
> Under the x2APIC section, regarding ICR, the SDM says:
> 
>   It remains readable only to aid in debugging; however, software should not
>   assume the value returned by reading the ICR is the last written value.
> 
> I.e. KVM basically has free reign to do whatever it wants, so long as it doesn't
> confuse userspace or break KVM's ABI.
> 
> Clear bit12 so that it reads back as '0'. This approach is safer than "do
> nothing" and is consistent with the case where IPI virtualization is
> disabled or not supported, i.e.,
> 
> 	handle_fastpath_set_x2apic_icr_irqoff() -> kvm_x2apic_icr_write()
> 
> >
> >Although bit12 of ICR is no longer APIC_ICR_BUSY in x2APIC, keeping it
> >is far easier to understand what's going on, especially given that it
> >may be repurposed for something new.
> 
> Probably you can remove this paragraph. it is not clear w/o the context
> that there was an attempt to rename APIC_ICR_BUSY for x2apic while fixing
> the issue.

Yes, agree with all the above, this is more correct and clear description.

Thanks,
Tao

> 
> >
> >Link: https://lore.kernel.org/all/ZPj6iF0Q7iynn62p@google.com/
> >Fixes: 5413bcba7ed5 ("KVM: x86: Add support for vICR APIC-write VM-Exits in x2APIC mode")
> >Signed-off-by: Tao Su <tao1.su@linux.intel.com>
> >Tested-by: Yi Lai <yi1.lai@intel.com>
> 
> Apart from above nits on the changelog, this patch looks good to me.
> 
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> 
> >---
> >Changelog:
> >
> >v2:
> >  - Drop the unnecessary alias for bit12 of ICR.
> >  - Add back kvm_lapic_get_reg64() that was removed by mistake.
> >  - Modify the commit message to make it clearer.
> >
> >v1: https://lore.kernel.org/all/20230904013555.725413-1-tao1.su@linux.intel.com/
> >---
> > arch/x86/kvm/lapic.c | 6 +++---
> > 1 file changed, 3 insertions(+), 3 deletions(-)
> >
> >diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> >index dcd60b39e794..664d5a78b46a 100644
> >--- a/arch/x86/kvm/lapic.c
> >+++ b/arch/x86/kvm/lapic.c
> >@@ -2450,13 +2450,13 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
> > 	 * ICR is a single 64-bit register when x2APIC is enabled.  For legacy
> > 	 * xAPIC, ICR writes need to go down the common (slightly slower) path
> > 	 * to get the upper half from ICR2.
> >+	 *
> >+	 * TODO: optimize to just emulate side effect w/o one more write
> > 	 */
> > 	if (apic_x2apic_mode(apic) && offset == APIC_ICR) {
> > 		val = kvm_lapic_get_reg64(apic, APIC_ICR);
> >-		kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
> >-		trace_kvm_apic_write(APIC_ICR, val);
> >+		kvm_x2apic_icr_write(apic, val);
> > 	} else {
> >-		/* TODO: optimize to just emulate side effect w/o one more write */
> > 		val = kvm_lapic_get_reg(apic, offset);
> > 		kvm_lapic_reg_write(apic, offset, (u32)val);
> > 	}
> >
> >base-commit: a48fa7efaf1161c1c898931fe4c7f0070964233a
> >-- 
> >2.34.1
> >
