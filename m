Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB38690975
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 14:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjBINDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 08:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjBINDD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 08:03:03 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19EED55E5C
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 05:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675947782; x=1707483782;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gGIrcxvQXEWwWozWX5fOJx0UgAVsKxXUkDUA+kq+Kxs=;
  b=WZRFbZ1KUVU5Jmqg0FC7rVHNZMKhfEOplYT1RbQBQ+04XWdTy3KebZLk
   xjyFx/NpbQNxCOTw1wwLEpS0tBMZa/ufVmx9PY+NL1bW8tKKLZdoAqEw9
   Wh7QmvXTnttwnB22cgpCTZgF20bdWFs+GoJcGuCrTHw7A0zwytm/NRSFo
   VDkskT0+o3frpMqt8YFPoX+kTklfClj4nqfz8oVmk4WNvwdfgaKBU6Uqv
   qeXtEZIjl+lTGgY8/e/s3UMvrR/xeBpWkHVF1aabI6qF7oobBKz0W5jb4
   Fj1d3EXDvHxG9fa/pvk2x86IVz5dqBAgSCsAOk5rRQ0zCcDNoBmblwEN9
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="357501185"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="357501185"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 05:03:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="996537525"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="996537525"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga005.fm.intel.com with ESMTP; 09 Feb 2023 05:02:56 -0800
Message-ID: <83692d6b284768b132b78dd6f21e226a028ba308.camel@linux.intel.com>
Subject: Re: [PATCH v4 2/9] KVM: x86: MMU: Clear CR3 LAM bits when allocate
 shadow root
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, isaku.yamahata@intel.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Date:   Thu, 09 Feb 2023 21:02:55 +0800
In-Reply-To: <Y+TDEsdjYljRzlPY@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <20230209024022.3371768-3-robert.hu@linux.intel.com>
         <Y+TDEsdjYljRzlPY@gao-cwp>
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

On Thu, 2023-02-09 at 17:55 +0800, Chao Gao wrote:
> On Thu, Feb 09, 2023 at 10:40:15AM +0800, Robert Hoo wrote:
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3698,8 +3698,11 @@ static int mmu_alloc_shadow_roots(struct
> > kvm_vcpu *vcpu)
> > 	gfn_t root_gfn, root_pgd;
> > 	int quadrant, i, r;
> > 	hpa_t root;
> > -
> 
> The blank line should be kept.

OK
> 
> > +#ifdef CONFIG_X86_64
> > +	root_pgd = mmu->get_guest_pgd(vcpu) & ~(X86_CR3_LAM_U48 |
> > X86_CR3_LAM_U57);
> > +#else
> > 	root_pgd = mmu->get_guest_pgd(vcpu);
> > +#endif
> 
> Why are other call sites of mmu->get_guest_pgd() not changed? 

Emm, the other 3 are
FNAME(walk_addr_generic)()
kvm_arch_setup_async_pf()
kvm_arch_async_page_ready

In former version, I clear CR3.LAM bits for guest_pgd inside mmu-
>get_guest_pgd(). I think this is generic. Perhaps I should still do it
in that way. Let's wait for other's comments on this.
Thanks for pointing out.

> And what's
> the value of the #ifdef?

LAM is only available in 64 bit mode.
> 
> > 	root_gfn = root_pgd >> PAGE_SHIFT;
> > 
> > 	if (mmu_check_root(vcpu, root_gfn))
> > -- 
> > 2.31.1
> > 

