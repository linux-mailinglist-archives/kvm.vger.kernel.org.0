Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC775347C7
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 03:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345396AbiEZBEe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 21:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235621AbiEZBEb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 21:04:31 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5E58D691;
        Wed, 25 May 2022 18:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653527070; x=1685063070;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=o9Dut7uwRK4DimJ5k0okbFXL72hzra19bcCoT9j7B4s=;
  b=mFNXTHGVSsEkel2jdOWQMP1UDW8ZO06zketPhX60ZAoPa6tsvBDHjc2Q
   fia5l9ovVrukOwvqOaip8zVgOoVpxuSk+YOxbF6277DCqAgkslcqJ5C09
   JO4RVKb3EUCa2XnCsHtmnV6bkH60mdSzyikyayuXY9eiKyV0gtqp6EKEo
   qfeQYFjl/E30wfX1/+ZRguEaoQgdvuywb7+hAcidNhanI+tcPZlVs1pjA
   fJvWEvMwGBlQxeXuyqtg5EX78RJ0KE/ELLDANn4w6ZgXW0Gs2sotyWdZc
   WQRwySMVo3vJCcXwj1SsRmnfM7OULFjd+Vub1sxA1SXJ70dlU+H0td0a4
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10358"; a="253854254"
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="253854254"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 18:04:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="559940686"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga002.jf.intel.com with ESMTP; 25 May 2022 18:04:27 -0700
Date:   Thu, 26 May 2022 09:04:26 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Lei Wang <lei4.wang@intel.com>
Subject: Re: [PATCH 1/2] KVM: VMX: Sanitize VM-Entry/VM-Exit control pairs at
 kvm_intel load time
Message-ID: <20220526010426.aayo3qmgylatnkdt@yy-desk-7060>
References: <20220525210447.2758436-1-seanjc@google.com>
 <20220525210447.2758436-2-seanjc@google.com>
 <20220525232744.e6g77merw7pita3s@yy-desk-7060>
 <Yo7M95ILNsHSBtqj@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo7M95ILNsHSBtqj@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022 at 12:42:31AM +0000, Sean Christopherson wrote:
> On Thu, May 26, 2022, Yuan Yao wrote:
> > On Wed, May 25, 2022 at 09:04:46PM +0000, Sean Christopherson wrote:
> > > @@ -2614,6 +2635,20 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
> > >  				&_vmentry_control) < 0)
> > >  		return -EIO;
> > >
> > > +	for (i = 0; i < ARRAY_SIZE(vmcs_entry_exit_pairs); i++) {
> > > +		u32 n_ctrl = vmcs_entry_exit_pairs[i].entry_control;
> > > +		u32 x_ctrl = vmcs_entry_exit_pairs[i].exit_control;
> > > +
> > > +		if (!(_vmentry_control & n_ctrl) == !(_vmexit_control & x_ctrl))
> > > +			continue;
> > > +
> > > +		pr_warn_once("Inconsistent VM-Entry/VM-Exit pair, entry = %x, exit = %x\n",
> > > +			     _vmentry_control & n_ctrl, _vmexit_control & x_ctrl);
> >
> > How about "n_ctrl, x_ctrl);" ? In 0/1 or 1/0 case this
> > outputs all information of real inconsistent bits but not 0.
>
> I thought about adding the stringified control name to the output (yay macros),
> but opted for the simplest approach because this should be a very, very rare
> event.  All the necessary info is there, it just takes a bit of leg work to get
> from a single control bit to the related control name and finally to its pair.
>
> I'm not totally against printing more info, but if we're going to bother doing so,
> my vote is to print names instead of numbers.

Agree for simplest approach because this should be rare event, thanks.
