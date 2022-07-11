Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43FA956D45F
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 07:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiGKFst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 01:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGKFss (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 01:48:48 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CC415FCC;
        Sun, 10 Jul 2022 22:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657518527; x=1689054527;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nJ8PlUBoQwoeShO3ziyubBuG2AA62mhcNqL/Nkw5+kg=;
  b=X85//BZqeOUqbF6OOFzYdQ8dJjFqifi4pNcmUDAcqFNCuZEetTNyOUT0
   pt6imWpgfsGEpqRZ0XciucJtpZuZc+bP+wWsM6cM1YYVmfzvkkZ6ZdZN3
   KPZExkLO7IVjU4iK44LoIG3Kkv16+CkqaFYfDn+yulZCxd84wmqy+G5Py
   tUBvMgDMMPjplDFoDztm7CVGSF6lsLyzPXQdRw9MQZHm1Pmv9fEH29mUT
   8lDKF0sZF7moTuUNC42ou/GWnIG93hHVuI7QRfEMXx5e9Yfs/6/z4jVKL
   xweF1l8BghffHqcYI+f7MI8CkDO9IaH8LXtvDC2pz4RMofbzislXh+AnB
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="264357379"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="264357379"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2022 22:48:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="598921065"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga007.fm.intel.com with ESMTP; 10 Jul 2022 22:48:45 -0700
Date:   Mon, 11 Jul 2022 13:48:44 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 043/102] KVM: x86/mmu: Focibly use TDP MMU for TDX
Message-ID: <20220711054844.wb34vvqf74wkb2jp@yy-desk-7060>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <c198d2be26aa9a041176826cf86b51a337427783.1656366338.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c198d2be26aa9a041176826cf86b51a337427783.1656366338.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 27, 2022 at 02:53:35PM -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> In this patch series, TDX supports only TDP MMU and doesn't support legacy
> MMU.  Forcibly use TDP MMU for TDX irrelevant of kernel parameter to
> disable TDP MMU.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 82f1bfac7ee6..7eb41b176d1e 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -18,8 +18,13 @@ int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
>  {
>  	struct workqueue_struct *wq;
>
> -	if (!tdp_enabled || !READ_ONCE(tdp_mmu_enabled))
> -		return 0;
> +	/*
> +	 *  Because TDX supports only TDP MMU, forcibly use TDP MMU in the case
> +	 *  of TDX.
> +	 */
> +	if (kvm->arch.vm_type != KVM_X86_TDX_VM &&
> +		(!tdp_enabled || !READ_ONCE(tdp_mmu_enabled)))
> +		return false;

Please return 0 here for int return value type.

>
>  	wq = alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);
>  	if (!wq)
> --
> 2.25.1
>
