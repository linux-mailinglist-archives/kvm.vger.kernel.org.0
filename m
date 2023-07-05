Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B941747E25
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 09:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbjGEHXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 03:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbjGEHXi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 03:23:38 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72101E4F;
        Wed,  5 Jul 2023 00:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688541814; x=1720077814;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NS28w+WymzMKhKs2KK3bH5xOvIImsi/4GcjzUcK6qWc=;
  b=DycUrvykXu/+MQPUVrs7LVJidAJ4S4ABZgrmiwHHzL7If6Yb+JPr87+9
   i70UtabVFNNybSWKNN2frODEGnns7wbNchDA9AEMcfaupmCpXHAyW8lsv
   O8RGLbxzvV9gYaxUvkqwHdKLCcEkKW45YxNo53fS/vvG26YfHaPggVtnF
   F+SOEcmQdjfS4yZ0zEjN5IVi4Ywe4tR9OtPX3BQ83NsAHV1Q6cw7eKzmb
   RUQXakVHfHrhzH3yvPT9Bjy2ME4nN/67DjP/KVOtNiDHFTm/zkwjH4/Gm
   pXPe+01Hmy398lhdOJaVUMqCREcdyo5nL8WDK9XV6uXrXHaHOiiDMVNsM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="365838932"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="365838932"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 00:23:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="789062435"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="789062435"
Received: from jialinji-mobl4.ccr.corp.intel.com (HELO localhost) ([10.255.30.200])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 00:23:29 -0700
Date:   Wed, 5 Jul 2023 15:23:35 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v7 3/8] KVM: Make __kvm_follow_pfn not imply FOLL_GET
Message-ID: <20230705072335.xfest7csh27f67v3@linux.intel.com>
References: <20230704075054.3344915-1-stevensd@google.com>
 <20230704075054.3344915-4-stevensd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230704075054.3344915-4-stevensd@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>  
> +void kvm_set_page_accessed(struct page *page);
> +void kvm_set_page_dirty(struct page *page);
> +
No one calls these 2 routines in this patch. How about move this change to
[PATCH v7 5/8] KVM: x86/mmu: Don't pass FOLL_GET to __kvm_follow_pfn ?

...

> @@ -2930,17 +2933,19 @@ static bool kvm_is_ad_tracked_page(struct page *page)
>  	return !PageReserved(page);
>  }
>  
> -static void kvm_set_page_dirty(struct page *page)
> +void kvm_set_page_dirty(struct page *page)
>  {
>  	if (kvm_is_ad_tracked_page(page))
>  		SetPageDirty(page);
>  }
> +EXPORT_SYMBOL_GPL(kvm_set_page_dirty);
>  
> -static void kvm_set_page_accessed(struct page *page)
> +void kvm_set_page_accessed(struct page *page)
>  {
>  	if (kvm_is_ad_tracked_page(page))
>  		mark_page_accessed(page);
>  }
> +EXPORT_SYMBOL_GPL(kvm_set_page_accessed);

Same here.

B.R.
Yu
