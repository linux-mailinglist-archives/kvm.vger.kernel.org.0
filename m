Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB08658827
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 01:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbiL2Als (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 19:41:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiL2Alo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 19:41:44 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321D5FD3
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 16:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672274504; x=1703810504;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WPmN4N2kS93OXmnVnhoSCFtZCc68DHx0UwP1dVBZZV8=;
  b=NoZwrXdoiptnmff0EZccYlpzoRAi7sFaUixMbzDMn9zhDWu5HSyrHxt1
   fOeYt4lkeF8v9hjty7HBBCVLI8w01iOL+xDfC0Ovc/Cg7TRR+jzfFhEKN
   DtU1eIlQK0Ztl3j6aEEUur3GmCI/MSj2giFF0KUPNkdKD6o7BPvApXE2s
   fCV7ResoLrrkqmvJzL34QDa3EYs1gQmW0E59pSHvFnR59Nwx3lrA6mYs1
   UXU4I/iyxG8aGIcQ3AzorJf9g3KPWdRDBLqiMoBMG7AqR7xLudjzZQJWd
   ixPzPhrVgVIu2lamxmklXfJlK+iB/Dd707K/vrNHYAKyKw6c1idWWGP3f
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10574"; a="322195451"
X-IronPort-AV: E=Sophos;i="5.96,282,1665471600"; 
   d="scan'208";a="322195451"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2022 16:41:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10574"; a="684061358"
X-IronPort-AV: E=Sophos;i="5.96,282,1665471600"; 
   d="scan'208";a="684061358"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga008.jf.intel.com with ESMTP; 28 Dec 2022 16:41:41 -0800
Message-ID: <c210fc0ec7a4ec3508aefa7a6b116ca4d2b197a5.camel@linux.intel.com>
Subject: Re: [PATCH v3 6/9] KVM: x86: Untag LAM bits when applicable
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>, pbonzini@redhat.com,
        seanjc@google.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org
Cc:     Jingqi Liu <jingqi.liu@intel.com>
Date:   Thu, 29 Dec 2022 08:41:41 +0800
In-Reply-To: <0bcb1c11-145d-0c45-4e46-a4ed9173e3c8@linux.intel.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
         <20221209044557.1496580-7-robert.hu@linux.intel.com>
         <0bcb1c11-145d-0c45-4e46-a4ed9173e3c8@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-12-28 at 16:32 +0800, Binbin Wu wrote:
> On 12/9/2022 12:45 PM, Robert Hoo wrote
> > +#ifdef CONFIG_X86_64
> > +/* untag addr for guest, according to vCPU CR3 and CR4 settings */
> > +static inline u64 kvm_untagged_addr(u64 addr, struct kvm_vcpu
> > *vcpu)
> > +{
> > +	if (addr >> 63 == 0) {
> > +		/* User pointers */
> > +		if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U57)
> > +			addr = get_canonical(addr, 57);
> 
> According to the spec, LAM_U57/LAM_SUP also performs a modified 
> canonicality check.
> 
> Why the check only be done for LAM_U48, but not for LAM_U57 and
> LAM_SUP 
> cases?
> 
Doesn't this check for LAM_U57?
And below else if branch checks LAM_U48.
And below outer else if branch checks CR4.LAM_SUP.
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
> > +			addr = get_canonical(addr, 48);
> > +		}
> > +	} else if (kvm_read_cr4(vcpu) & X86_CR4_LAM_SUP) { /*
> > Supervisor pointers */
> > +		if (kvm_read_cr4(vcpu) & X86_CR4_LA57)
> > +			addr = get_canonical(addr, 57);
> > +		else
> > +			addr = get_canonical(addr, 48);
> > +	}
> > +
> > +	return addr;
> > +}
...

