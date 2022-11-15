Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD38628E4C
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 01:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236152AbiKOA1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 19:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiKOA1u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 19:27:50 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CB415FDE
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 16:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668472069; x=1700008069;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=C8W+Gj9CFMjz9YpNbNfbVGdMeI9jWUpodEgJfr2w1do=;
  b=PSkGifdTln7ffqrduKTIEfju200LYWPASv3H+8hIdqgkBkhivHNT4Hg7
   RGJxMEPWvVp216AWeaxSGnA+puIMibnh8PeR3HSekRaxVSY1xsKEIEcz5
   bKi5M7H1bCpmE0DEFrUY1wM0zSnSsT9zyRTCCtGGWTCxGH/ikJgYhk8Tg
   Jph49RpqnnMIKl/K6CEFSD+n1W2O27sFrC7kCe35l1rC/0PdzdBWX1+s0
   VYbr9Qhvh+SpK/4/TXnA9LR2DVby0aaP3jTi+DIYqgCmMf4AAvpIV1mre
   YBHeTClTKiy6Wjrj8p7fUyITQawr6y7jhhGaub8DXbNBa2KPoqZziN65e
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="292517419"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="292517419"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 16:27:49 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="633018676"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="633018676"
Received: from yjiang5-mobl.amr.corp.intel.com (HELO localhost) ([10.212.78.37])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 16:27:48 -0800
Date:   Mon, 14 Nov 2022 16:27:47 -0800
From:   Yunhong Jiang <yunhong.jiang@linux.intel.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v7 3/4] KVM: arm64: Dirty quota-based throttling of vcpus
Message-ID: <20221115002747.GC7867@yjiang5-mobl.amr.corp.intel.com>
References: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
 <20221113170507.208810-4-shivam.kumar1@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221113170507.208810-4-shivam.kumar1@nutanix.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 13, 2022 at 05:05:10PM +0000, Shivam Kumar wrote:
> Exit to userspace whenever the dirty quota is exhausted (i.e. dirty count
> equals/exceeds dirty quota) to request more dirty quota.
> 
> Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
> Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
> ---
>  arch/arm64/kvm/arm.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 94d33e296e10..850024982dd9 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -746,6 +746,15 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>  
>  		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
>  			return kvm_vcpu_suspend(vcpu);
> +
> +		if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
> +			struct kvm_run *run = vcpu->run;
> +
> +			run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
> +			run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
> +			run->dirty_quota_exit.quota = vcpu->dirty_quota;
> +			return 0;
> +		}
There is a recheck on x86 side, but not here. Any architecture specific reason?
Sorry if I missed anything.

BTW, not sure if the x86/arm code can be combined into a common function. I
don't see any architecture specific code here.
