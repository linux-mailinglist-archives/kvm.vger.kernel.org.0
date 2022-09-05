Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724AB5ACECC
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 11:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237179AbiIEJ1T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 05:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235459AbiIEJ1R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 05:27:17 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E33E2F674;
        Mon,  5 Sep 2022 02:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662370037; x=1693906037;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=o5on7g5eU/u1Xj26JnLalnuCczll+Sh3zwqNAD3wro8=;
  b=mSUZlriTCYUjZy7UhAVR+7NphSV6LO+Gx7N2tmHCvxMkHMDavyDIVFLb
   4BhR2S68Z0YrO6WM2Qx1Azhr7ERYtKaWhT2Xmer+kRQtjSz/O2uP0kXs3
   C4Sgzkv1cxYXcNq8cFxHFwqaGp5zL1/EiVSsW8xczr49zfIKV7IomYD76
   GZP7vUFXlO8wa3wJK/C5jbgNtBOw5kHuQ/NnciDRysbqx+8VHYRwlle16
   QgMyZ0gUbZt/nqsPhwbwmQAni9f45yrVy0+M/3Znb9X6MHSrt5XTJcWMV
   PNjjvZaL+y9ulCRLPfFPftVYODqGof+3H9WXRYl3muy4Pi0ZZPoxD/N22
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10460"; a="276743134"
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="276743134"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2022 02:27:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="675213318"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga008.fm.intel.com with ESMTP; 05 Sep 2022 02:27:13 -0700
Date:   Mon, 5 Sep 2022 17:27:12 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        isaku.yamahata@gmail.com, Kai Huang <kai.huang@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 09/22] KVM: Do processor compatibility check on resume
Message-ID: <20220905092712.5mque5oajiaj7kuq@yy-desk-7060>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
 <b5bf18656469f667d1015cc1d62e5caba2f56e96.1662084396.git.isaku.yamahata@intel.com>
 <20220905084014.uanoazei77i3xjjo@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220905084014.uanoazei77i3xjjo@yy-desk-7060>
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

On Mon, Sep 05, 2022 at 04:40:14PM +0800, Yuan Yao wrote:
> On Thu, Sep 01, 2022 at 07:17:44PM -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > So far the processor compatibility check is not done on resume. It should
> > be done.
>
> The resume happens for resuming from S3/S4, so the compatibility
> checking is used to detecte CPU replacement, or resume from S4 on an
> different machine ?

By did experiments, I found the resume is called once on CPU 0 before
other CPUs come UP, so yes it's necessary to check it.

>
> >
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  virt/kvm/kvm_main.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 0ac00c711384..fc55447c4dba 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -5715,6 +5715,13 @@ static int kvm_suspend(void)
> >
> >  static void kvm_resume(void)
> >  {
> > +	if (kvm_arch_check_processor_compat())
> > +		/*
> > +		 * No warning here because kvm_arch_check_processor_compat()
> > +		 * would have warned with more information.
> > +		 */
> > +		return; /* FIXME: disable KVM */
> > +
> >  	if (kvm_usage_count) {
> >  		lockdep_assert_not_held(&kvm_count_lock);
> >  		hardware_enable_nolock((void *)__func__);
> > --
> > 2.25.1
> >
