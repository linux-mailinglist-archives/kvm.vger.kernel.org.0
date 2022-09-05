Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CEE5ACE04
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 10:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236948AbiIEIlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 04:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238169AbiIEIk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 04:40:58 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9B52654;
        Mon,  5 Sep 2022 01:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662367221; x=1693903221;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=btdeNSlwm5b5+Fc8dEtnw3mA1Hti4hAjCaqKbQB4+Sc=;
  b=ndpMLtLVJcnx5jeL235pCMi0g1rPKydsAtKhoKIqVGTeN2g17IIVy41/
   0BrfknKM+nPjXCLlFNC8h6H5m9b4ihxX1BPpAdHorYvNZu57F+vcpOYcj
   T0R8Gvqn5aox4Opd0tuV+gpU0T2hQj6FBcqsxAS6nUgC2B8lh/PX9xInU
   0MH2pdZZnKr3OYIb7vOWCNSVpB3tvvwSgLrCyl3pA7yWUuj/ozHCYzUVE
   2n0Hu8MBRXw4w60aDPE9zAuV4crtPqpwSz7xi3B7y9sxxCrriypZl8kvv
   ZJqy3khR6JQtNA4u/BrCOd52tXTv3CfT9weF/PFQuTBQvdd5M61VD2qpR
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10460"; a="322508352"
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="322508352"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2022 01:40:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="858885905"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga006.fm.intel.com with ESMTP; 05 Sep 2022 01:40:15 -0700
Date:   Mon, 5 Sep 2022 16:40:14 +0800
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
Message-ID: <20220905084014.uanoazei77i3xjjo@yy-desk-7060>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
 <b5bf18656469f667d1015cc1d62e5caba2f56e96.1662084396.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5bf18656469f667d1015cc1d62e5caba2f56e96.1662084396.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022 at 07:17:44PM -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> So far the processor compatibility check is not done on resume. It should
> be done.

The resume happens for resuming from S3/S4, so the compatibility
checking is used to detecte CPU replacement, or resume from S4 on an
different machine ?

>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  virt/kvm/kvm_main.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 0ac00c711384..fc55447c4dba 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5715,6 +5715,13 @@ static int kvm_suspend(void)
>
>  static void kvm_resume(void)
>  {
> +	if (kvm_arch_check_processor_compat())
> +		/*
> +		 * No warning here because kvm_arch_check_processor_compat()
> +		 * would have warned with more information.
> +		 */
> +		return; /* FIXME: disable KVM */
> +
>  	if (kvm_usage_count) {
>  		lockdep_assert_not_held(&kvm_count_lock);
>  		hardware_enable_nolock((void *)__func__);
> --
> 2.25.1
>
