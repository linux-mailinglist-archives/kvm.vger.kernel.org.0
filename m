Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8B76956D4
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 03:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjBNCzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 21:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBNCzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 21:55:49 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFDD17CCC
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 18:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676343346; x=1707879346;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oiQCol8b2ENZKXBECl0XRAOjUs4xMTMjqupJ6Lggufo=;
  b=OtuSdOBgtC99sDFBlX7+rJDUiGMHvZyGP/GHX63zR4dhwj+tmHgIPyHC
   w0nl6UC8ap1qGUFwuyLFrxn5NSEwNZnGxn4+ap1rk8eIx/5jtBu7Zt1D/
   XhcDNA3DGgWN//F/QlB09FASL5BrVOjCGsaefBi0PIFInBrHyghousqog
   Sdv20ki8XYESm1I66tb8aoNwvzqKdzDQFG4fL5YvUDjfYuzJJpcSVyd9/
   RJeUa+lHFmkx7H1WH26cZYZpoaL4jFm+ACwQHCTCMewVTqxdAoHV94i26
   RFy56dqq1cKTb3r0ErlmdnGS6mXaWJn8kglWs4zdxPbAG/9issyswePy+
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="393464313"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="393464313"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 18:55:45 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="778125858"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="778125858"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.213.213]) ([10.254.213.213])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 18:55:42 -0800
Message-ID: <4f848515-462b-163e-a6ad-5bb16cc99518@linux.intel.com>
Date:   Tue, 14 Feb 2023 10:55:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v4 2/9] KVM: x86: MMU: Clear CR3 LAM bits when allocate
 shadow root
To:     Robert Hoo <robert.hu@linux.intel.com>,
        Chao Gao <chao.gao@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, isaku.yamahata@intel.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <20230209024022.3371768-3-robert.hu@linux.intel.com>
 <Y+TDEsdjYljRzlPY@gao-cwp>
 <83692d6b284768b132b78dd6f21e226a028ba308.camel@linux.intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <83692d6b284768b132b78dd6f21e226a028ba308.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/9/2023 9:02 PM, Robert Hoo wrote:
> On Thu, 2023-02-09 at 17:55 +0800, Chao Gao wrote:
>> On Thu, Feb 09, 2023 at 10:40:15AM +0800, Robert Hoo wrote:
>>> --- a/arch/x86/kvm/mmu/mmu.c
>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>> @@ -3698,8 +3698,11 @@ static int mmu_alloc_shadow_roots(struct
>>> kvm_vcpu *vcpu)
>>> 	gfn_t root_gfn, root_pgd;
>>> 	int quadrant, i, r;
>>> 	hpa_t root;
>>> -
>> The blank line should be kept.
> OK
>>> +#ifdef CONFIG_X86_64
>>> +	root_pgd = mmu->get_guest_pgd(vcpu) & ~(X86_CR3_LAM_U48 |
>>> X86_CR3_LAM_U57);
>>> +#else
>>> 	root_pgd = mmu->get_guest_pgd(vcpu);
>>> +#endif
>> Why are other call sites of mmu->get_guest_pgd() not changed?
> Emm, the other 3 are
> FNAME(walk_addr_generic)()
> kvm_arch_setup_async_pf()
> kvm_arch_async_page_ready
>
> In former version, I clear CR3.LAM bits for guest_pgd inside mmu-
>> get_guest_pgd(). I think this is generic. Perhaps I should still do it
> in that way. Let's wait for other's comments on this.
> Thanks for pointing out.

I also prefer to handle it inside get_guest_pdg,
but in kvm_arch_setup_async_pf()/kvm_arch_async_page_ready(), the value 
is assigned to
cr3 of struct kvm_arch_async_pf, does it requires all fileds of cr3?


>
>> And what's
>> the value of the #ifdef?
> LAM is only available in 64 bit mode.

In other modes, the two bits are either ignored or not defined, seems 
safe to clear the two bits unconditionally.


>>> 	root_gfn = root_pgd >> PAGE_SHIFT;
>>>
>>> 	if (mmu_check_root(vcpu, root_gfn))
>>> -- 
>>> 2.31.1
>>>
