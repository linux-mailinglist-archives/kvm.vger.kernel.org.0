Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702DD69636C
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 13:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbjBNMYQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 07:24:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBNMYP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 07:24:15 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743D025299
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 04:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676377454; x=1707913454;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e1BGtsEAqK3z7fVJBo0bMIQFKXhmIEbFECFPgb0gg38=;
  b=mfrg3uWiE2Hc5R7tH11JWCMoKLT0K0haF4/7AR36ErQ3oJxIcdnWmh75
   cGt4kvDOwV9mFP/taQnT8zKg0+1a1xaucktaywQJbiAc7welRl+Cujhc/
   fqy1HcM3mFwURMhpwPBeKDLz88lozQoVcpufzbBZ1XDYDfIYRR69sxVFh
   YbSFrUSgAHYhjauH8rqJ1TUCgAhPznhgF8VklFBt9Nf26jdfSErNNtZN5
   0etU+NKv3fSMAGqLuzITfSPdXtmWbaBISqyxbLTWmqna0yb47NN+SSQ0h
   2QUrlcdjTF489RHFxd+5WiCY09zue6bsoaBeAZsyyzy9EIQ6EsaL/g6sq
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="319178308"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="319178308"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 04:24:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="843155408"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="843155408"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga005.jf.intel.com with ESMTP; 14 Feb 2023 04:24:10 -0800
Message-ID: <d1d819b00a6dda7a58b25f7b0692ad53473497d8.camel@linux.intel.com>
Subject: Re: [PATCH v4 1/9] KVM: x86: Intercept CR4.LAM_SUP when LAM feature
 is enabled in guest
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>, seanjc@google.com,
        pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com
Cc:     kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Date:   Tue, 14 Feb 2023 20:24:09 +0800
In-Reply-To: <1e8df25a-4c25-6738-dd92-a58c28282eb0@linux.intel.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <20230209024022.3371768-2-robert.hu@linux.intel.com>
         <814481b6-c316-22bd-2193-6aa700db47b5@linux.intel.com>
         <90d0f1ffec67e015e3f0f1ce9d8d719634469a82.camel@linux.intel.com>
         <1e8df25a-4c25-6738-dd92-a58c28282eb0@linux.intel.com>
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

On Tue, 2023-02-14 at 17:00 +0800, Binbin Wu wrote:
> According to the code of set_cr4_guest_host_mask,
> vcpu->arch.cr4_guest_owned_bits is a subset of
> KVM_POSSIBLE_CR4_GUEST_BITS,
> and X86_CR4_LAM_SUP is not included in KVM_POSSIBLE_CR4_GUEST_BITS.
> No matter change CR4_RESERVED_BITS or not, X86_CR4_LAM_SUP will
> always be set in CR4_GUEST_HOST_MASK.
> 
> 
set_cr4_guest_host_mask():
	vcpu->arch.cr4_guest_owned_bits = KVM_POSSIBLE_CR4_GUEST_BITS &
			~vcpu->arch.cr4_guest_rsvd_bits;

kvm_vcpu_after_set_cpuid():
	vcpu->arch.cr4_guest_rsvd_bits =
	    __cr4_reserved_bits(guest_cpuid_has, vcpu);

