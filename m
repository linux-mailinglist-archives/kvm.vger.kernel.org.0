Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF9B7D45BB
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 04:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbjJXCwM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 22:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbjJXCwM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 22:52:12 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583B5D7C;
        Mon, 23 Oct 2023 19:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698115926; x=1729651926;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QS9ojfjiZJDVYBisInBCGmDdzIORmnDy+ODdIxCW67k=;
  b=Haw1fo5d5XBi5SV7psdFcV7hyaJfLmJWO2wBy9Pz9JiqQ2OdySV+b3/5
   oJswXAYq3xOWsxNrKZk6TEEkfJpFLGIKuf0ZB8hlQwObH8bzFBO6QyHe5
   y1463zRxfZaluVlghuoq+tNmBOcY0/tW0ZOl4O1RbJfq/78IqBAWuUkV4
   eBqeyPH55TxW/LcqjR+/aDdgBU3mZKU/FoUIxkqFHkBnvXRQ4kYqg4ASS
   LFvsT4GZ9zdlEGGTGYWlOV7RcA61dwZUZrK/bbBfbRMV03s2ypGB015yT
   Vi7dS1rTt5r/Ai2unXwpOseBwCmWi0jcOTnqprfBXKFcj/YwCZLZzRtuo
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="366319197"
X-IronPort-AV: E=Sophos;i="6.03,246,1694761200"; 
   d="scan'208";a="366319197"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2023 19:52:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="902019106"
X-IronPort-AV: E=Sophos;i="6.03,246,1694761200"; 
   d="scan'208";a="902019106"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.9.167]) ([10.238.9.167])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2023 19:49:45 -0700
Message-ID: <20d4f3fc-7491-dbab-392b-8b914332cafe@linux.intel.com>
Date:   Tue, 24 Oct 2023 10:52:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH gmem] KVM: Fix off-by-one error when querying attributes
 in xarray
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20231023203531.2461809-1-seanjc@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20231023203531.2461809-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/24/2023 4:35 AM, Sean Christopherson wrote:
> Subtract -1 from kvm_range_has_memory_attributes()'s @end when using
> xas_find(), as "end" is exclusive whereas xas_find() takes an inclusive
> "max" as the maximal index to find/return.
>
> Reported-by: Binbin Wu <binbin.wu@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu<binbin.wu@linux.intel.com>



> ---
>   virt/kvm/kvm_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 959e866c84f0..12458959dd25 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2447,7 +2447,7 @@ bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
>   	rcu_read_lock();
>   
>   	if (!attrs) {
> -		has_attrs = !xas_find(&xas, end);
> +		has_attrs = !xas_find(&xas, end - 1);
>   		goto out;
>   	}
>   
>
> base-commit: 911b515af3ec5f53992b9cc162cf7d3893c2fbe2

