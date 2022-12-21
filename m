Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79070652EAD
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 10:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbiLUJfv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 04:35:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234063AbiLUJfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 04:35:47 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4336540
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 01:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671615346; x=1703151346;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6/I5kFJcxQlETFoNaCDx3MSUTA8TZrs3VK/4QReMV68=;
  b=RA+cAb28QGtMXN3wWJ3g6gm6m4pJU1q39EkWjA2Niq6Gj6Rnevi2b1kw
   4guq2OxObl1CPhKhSNFZUGqmedb63SFwrE7eQgQuLgXvfBJL0zo+1/jje
   G8ovezDECBIskiH5XGMlGZh7lFllLbF0l1ZW81rH2zXWvfn81jHoADoBT
   jvGT6YXdLOXzqDhQXCo/8/xjfE7X7BRAqiYdb7M+SkV/E1RLvw+dKuo7k
   MZRr+LHNhjJdks7qK1kDTyR7uNx2heR8JL/AWnxvqwA+mXX+hDf4ENVvQ
   7fYzKIvvQ13MQ8Lw3w95A7CMQbcuDoEpzEZYWvy+frliMSDNmcCAJG87p
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="317465767"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="317465767"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 01:35:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="651351092"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="651351092"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga002.jf.intel.com with ESMTP; 21 Dec 2022 01:35:43 -0800
Date:   Wed, 21 Dec 2022 17:35:43 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH v3 6/9] KVM: x86: Untag LAM bits when applicable
Message-ID: <20221221093543.hq6lws77hxihgdeo@yy-desk-7060>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-7-robert.hu@linux.intel.com>
 <20221221025527.jbsordepwfytdwmx@yy-desk-7060>
 <99219ca2f5b0fdb2daa825374235a0b05b74724f.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99219ca2f5b0fdb2daa825374235a0b05b74724f.camel@linux.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 21, 2022 at 04:22:33PM +0800, Robert Hoo wrote:
> On Wed, 2022-12-21 at 10:55 +0800, Yuan Yao wrote:
> > > +#ifdef CONFIG_X86_64
> > > +/* untag addr for guest, according to vCPU CR3 and CR4 settings */
> > > +static inline u64 kvm_untagged_addr(u64 addr, struct kvm_vcpu
> > > *vcpu)
> > > +{
> > > +	if (addr >> 63 == 0) {
> > > +		/* User pointers */
> > > +		if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U57)
> > > +			addr = get_canonical(addr, 57);
> > > +		else if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U48) {
> > > +			/*
> > > +			 * If guest enabled 5-level paging and LAM_U48,
> > > +			 * bit 47 should be 0, bit 48:56 contains meta
> > > data
> > > +			 * although bit 47:56 are valid 5-level address
> > > +			 * bits.
> > > +			 * If LAM_U48 and 4-level paging, bit47 is 0.
> > > +			 */
> > > +			WARN_ON(addr & _BITUL(47));
> >
> > IIUC, LAM_47 userspace canonical checking rule requests "bit 63 ==
> > bit 47 == 0"
> > before sign-extened the address.
> >
> > if so looks it's guest's fault to not follow the LAM canonical
> > checking rule,
> > what's the behavior of such violation on bare metal, #GP ?
>
> Spec (ISE 10.2) doesn't mention a #GP for this case. IIUC, those
> overlap bits are zeroed.

I mean the behavior of violation of "bit 63 == bit 47 == 0" rule,
yes no words in ISE 10.2/3 describe the behavior of such violation
case, but do you know more details of this or had some experiments
on hardware/SIMIC ?

> Current native Kernel LAM only enables LAM_U57.
>
> > The behavior
> > shuld be same for guest instead of WARN_ON() on host, host does
> > nothing wrong.
> >
> Agree that host did nothing wrong. So remove WARN_ON(), use a pr_warn()
> instead? I here meant to warn that such case happens.

I personally think that's not necessary if no hardware behavior is defined
for such violation, KVM doesn't need to warn such guest violation on host,
like KVM already done for many other cases (e.g #GP is injected for
restricted canonical violation but not WARN_ON)

>
>
