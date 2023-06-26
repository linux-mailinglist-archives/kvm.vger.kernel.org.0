Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D2C73D688
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 05:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjFZDkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 23:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbjFZDkd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 23:40:33 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEE613D;
        Sun, 25 Jun 2023 20:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687750832; x=1719286832;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=E0qiag9kGdb4yAdl+0DWGOkHehnUQZplHn8B8iTO+1g=;
  b=S1fuMo/uv8K5munYqAgRqq7SheNY9uWkk7qiFK3qGuDSmF4IIAEBnWUV
   objMbxDE0Zv3diHdaOeosqgNFkxhI2uGfRzZ941NHoPHyi/RW4qzVNrsD
   5sODxH3mA7S6x/PDmgC2LXZeB+ofNY1yMrknCRDJPa6GoqgwIZGJhDwhk
   lFf4Ea8GcZjefbnzpu5QFeSmwuCkSiHxpQpk6bxWmVzO4TPOKByJsuGna
   lzofUxAHqWvkHBoJOPHRrtwOxsyfSsAuzjq5JB3ccWBDh0hSKAI4IUbgC
   uJBsiNLG2bQAhTn67WyKBlhlTbGj1b/iKtCIpZk1TX1M+XirVKhM2QQUB
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="361205061"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="361205061"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2023 20:40:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="890145287"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="890145287"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga005.jf.intel.com with ESMTP; 25 Jun 2023 20:40:28 -0700
Date:   Mon, 26 Jun 2023 11:40:28 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao <chao.gao@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, kai.huang@intel.com,
        robert.hoo.linux@gmail.com
Subject: Re: [PATCH v3 07/11] KVM: VMX: drop IPAT in memtype when CD=1 for
 KVM_X86_QUIRK_CD_NW_CLEARED
Message-ID: <20230626034027.g75sliwf46impob3@yy-desk-7060>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
 <20230616023815.7439-1-yan.y.zhao@intel.com>
 <ZJESMaG5Thb5LWtt@chao-email>
 <ZJEQNTvfwOSsSzrf@yzhao56-desk.sh.intel.com>
 <45be3429-f352-920a-d1af-7f3a07930f5d@intel.com>
 <ZJjW9Kstbfa+LmAV@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJjW9Kstbfa+LmAV@yzhao56-desk.sh.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 26, 2023 at 08:08:20AM +0800, Yan Zhao wrote:
> On Sun, Jun 25, 2023 at 03:14:37PM +0800, Xiaoyao Li wrote:
> > On 6/20/2023 10:34 AM, Yan Zhao wrote:
> > > On Tue, Jun 20, 2023 at 10:42:57AM +0800, Chao Gao wrote:
> > > > On Fri, Jun 16, 2023 at 10:38:15AM +0800, Yan Zhao wrote:
> > > > > For KVM_X86_QUIRK_CD_NW_CLEARED, remove the ignore PAT bit in EPT memory
> > > > > types when cache is disabled and non-coherent DMA are present.
> > > > >
> > > > > With the quirk KVM_X86_QUIRK_CD_NW_CLEARED, WB + IPAT are returned as the
> > > > > EPT memory type when guest cache is disabled before this patch.
> > > > > Removing the IPAT bit in this patch will allow effective memory type to
> > > > > honor PAT values as well, which will make the effective memory type
> > > > Given guest sets CR0.CD, what's the point of honoring (guest) PAT? e.g.,
> > > > which guests can benefit from this change?
> > > This patch is actually a preparation for later patch 10 to implement
> > > fine-grained zap.
> > > If when CR0.CD=1 the EPT type is WB + IPAT, and
> > > when CR0.CD=0 + mtrr enabled, EPT type is WB or UC or ..., which are
> > > without IPAT, then we have to always zap all EPT entries.
> > >
> > > Given removing the IPAT bit when CR0.CD=1 only makes the quirk
> > > KVM_X86_QUIRK_CD_NW_CLEARED more strict (meaning it could be WC/UC... if
> > > the guest PAT overwrites it), it's still acceptable.
> >
> > Per my understanding, the reason why KVM had KVM_X86_QUIRK_CD_NW_CLEARED is
> > to ensure the memory type is WB to achieve better boot performance for old
> > OVMF.
> It works well for OVMF c9e5618f84b0cb54a9ac2d7604f7b7e7859b45a7,
> which is Apr 14 2015.
>
>
> > you need to justify the original purpose is not broken by this patch.
>
> Hmm, to dig into the history, the reason for this quirk is explained below:
>
> commit fb279950ba02e3210a16b11ecfa8871f3ee0ca49
> Author: Xiao Guangrong <guangrong.xiao@intel.com>
> Date:   Thu Jul 16 03:25:56 2015 +0800
>
>     KVM: vmx: obey KVM_QUIRK_CD_NW_CLEARED
>
>     OVMF depends on WB to boot fast, because it only clears caches after
>     it has set up MTRRs---which is too late.
>
>     Let's do writeback if CR0.CD is set to make it happy, similar to what
>     SVM is already doing.
>
>
> which means WB is only a must for fast boot before OVMF has set up MTRRs.
> At that period, PAT is default to WB.
>
> After OVMF setting up MTRR, according to the definition of no-fill cache
> mode, "Strict memory ordering is not enforced unless the MTRRs are
> disabled and/or all memory is referenced as uncached", it's valid to
> honor PAT in no-fill cache mode.

Does it also mean that, the honor PAT in such no-fill cache mode should
also happen for non-quirk case ? e.g. the effective memory type can be
WC if EPT is UC + guest PAT is WC for CD=1.

> Besides, if the guest explicitly claim UC via PAT, why should KVM return
> WB?
> In other words, if it's still slow caused by a UC value in guest PAT,
> it's desired to be fixed in guest instead of a workaround in KVM.

the quirk may not work after this patch if the guest PAT is
stronger than WB for CD=1, we don't if any guest "works correctly" based
on this quirk, I hope no. How about highlight this in commit message
explicitly ?

Also I agree that such issue should be fixed in guest not in KVM.

>
>
>
>
