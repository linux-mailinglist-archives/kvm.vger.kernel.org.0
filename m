Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE72652DD9
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 09:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiLUIXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 03:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiLUIXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 03:23:06 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2DFF5F
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 00:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671610985; x=1703146985;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mgjs1xSF08jGDm1gXUek4CDRj3pUifX25AjEWLPyfww=;
  b=Y6xiuK/Ba10oVo+JNIctfPlbIlzE7NccqA5hgGIjBemz3InfxDH2wfnL
   Nv8bElQJY5zsN/xVuiYkzbcSGmi1u1zVIQ9xxiqKdAOZvISIMANNQlEIs
   zEzAHo0IySckgzdOPONLaOKzAFTr6FE3Tvr4Y+QtZva/rchXzMOz42XuI
   IgHOCyy1orWfuuT8WRuauhCvoxF0B1wfdO5VpkxNP5tdzD/Bu9+Fo+1X9
   8asaIb+I8N7jRjDW5FFqROYTQfc4pwItY43h1/Zw8GOOpSRgEdOhR/d9h
   398isoQNpAWnttc4mx7u2iHhAb9qNT5e85ocEn31J0S056Jbpd9ku6adK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="321728446"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="321728446"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 00:22:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="740093308"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="740093308"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Dec 2022 00:22:34 -0800
Message-ID: <99219ca2f5b0fdb2daa825374235a0b05b74724f.camel@linux.intel.com>
Subject: Re: [PATCH v3 6/9] KVM: x86: Untag LAM bits when applicable
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        Jingqi Liu <jingqi.liu@intel.com>
Date:   Wed, 21 Dec 2022 16:22:33 +0800
In-Reply-To: <20221221025527.jbsordepwfytdwmx@yy-desk-7060>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
         <20221209044557.1496580-7-robert.hu@linux.intel.com>
         <20221221025527.jbsordepwfytdwmx@yy-desk-7060>
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

On Wed, 2022-12-21 at 10:55 +0800, Yuan Yao wrote:
> > +#ifdef CONFIG_X86_64
> > +/* untag addr for guest, according to vCPU CR3 and CR4 settings */
> > +static inline u64 kvm_untagged_addr(u64 addr, struct kvm_vcpu
> > *vcpu)
> > +{
> > +	if (addr >> 63 == 0) {
> > +		/* User pointers */
> > +		if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U57)
> > +			addr = get_canonical(addr, 57);
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
> 
> IIUC, LAM_47 userspace canonical checking rule requests "bit 63 ==
> bit 47 == 0"
> before sign-extened the address.
> 
> if so looks it's guest's fault to not follow the LAM canonical
> checking rule,
> what's the behavior of such violation on bare metal, #GP ? 

Spec (ISE 10.2) doesn't mention a #GP for this case. IIUC, those
overlap bits are zeroed.
Current native Kernel LAM only enables LAM_U57.

> The behavior
> shuld be same for guest instead of WARN_ON() on host, host does
> nothing wrong.
> 
Agree that host did nothing wrong. So remove WARN_ON(), use a pr_warn()
instead? I here meant to warn that such case happens.


