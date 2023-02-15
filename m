Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C99C697363
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbjBOBT0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbjBOBTZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:19:25 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDD234310
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676423943; x=1707959943;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DrEiXy2zTFAfkJptzVhLo5qm89yswEoZmsjWm8b3cCc=;
  b=liqh8vW5XYd8XqQczNH/c9kxOGicmbajz5rH0OUqLbStHEbH+89CupDy
   ujptfXJTlRzu2DJxx0AkCdHg/IAlp3Ap6ceST+TtInci7Zo5y4E1KRXOp
   2V3wgP1PCaR5nFRxJYqRs5o3ovvrE2v0vlG6D6yuz3cqRt7ZEaDavqnzQ
   bPt9f/ciLo/qnkfSHwbS6SnAXT3aXb8GYSRyBysVzPjDc3xWbzepJTllr
   zAcPkQfzaGZLhqvh7+9Z+gx2skI4fYLrXJ5VbntsmbFkRLumc4ngErcsx
   gbv6LIm2OMH7zKacYYPX0Atq3s9uE+WzSGY3EzP6eLysxtobtpRsWAOCK
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="358734191"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="358734191"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 17:17:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="699760107"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="699760107"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga008.jf.intel.com with ESMTP; 14 Feb 2023 17:17:34 -0800
Message-ID: <7d2c8c4cf0bc3aeb965ed92d483a1c60e04af7f3.camel@linux.intel.com>
Subject: Re: [PATCH v4 2/9] KVM: x86: MMU: Clear CR3 LAM bits when allocate
 shadow root
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>,
        Chao Gao <chao.gao@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, isaku.yamahata@intel.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Date:   Wed, 15 Feb 2023 09:17:33 +0800
In-Reply-To: <4f848515-462b-163e-a6ad-5bb16cc99518@linux.intel.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <20230209024022.3371768-3-robert.hu@linux.intel.com>
         <Y+TDEsdjYljRzlPY@gao-cwp>
         <83692d6b284768b132b78dd6f21e226a028ba308.camel@linux.intel.com>
         <4f848515-462b-163e-a6ad-5bb16cc99518@linux.intel.com>
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

On Tue, 2023-02-14 at 10:55 +0800, Binbin Wu wrote:
> > Emm, the other 3 are
> > FNAME(walk_addr_generic)()
> > kvm_arch_setup_async_pf()
> > kvm_arch_async_page_ready
> > 
> > In former version, I clear CR3.LAM bits for guest_pgd inside mmu-
> > > get_guest_pgd(). I think this is generic. Perhaps I should still
> > > do it
> > 
> > in that way. Let's wait for other's comments on this.
> > Thanks for pointing out.
> 
> I also prefer to handle it inside get_guest_pdg,
> but in kvm_arch_setup_async_pf()/kvm_arch_async_page_ready(), the
> value 
> is assigned to
> cr3 of struct kvm_arch_async_pf, does it requires all fileds of cr3?
> 
I'm looking into the async PF. Anyone who's familiar with async PF can
shed some light?

If kvm_arch_setup_async_pf()/kvm_arch_async_page_ready() needs whole
CR3, would you agree we have 2 methods: get_cr3() and get_pgd()?


