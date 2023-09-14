Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939FD7A0AAD
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 18:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238200AbjINQWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 12:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbjINQWj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 12:22:39 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CE81FC0;
        Thu, 14 Sep 2023 09:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694708555; x=1726244555;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ne10332tLXxVYP5I0FRwMxBk1f5aF0fngK2Siw6b0Ts=;
  b=WvwWtUxbZ30PCkjs+2ieGNpzyhOczh2y6bEO5fF7b6DbcpeuxS0Jg62w
   M1gaD1+nS8KhTGE1npWlocU+Otko4T6H5+D2mWV8pnunVfDDczMa41K4F
   uZ1iWEK9wT9QW53kFzcxNMmT46vgwYJr1DPeROr+F82NiPn55qv/u7dc2
   gbY06HNmHtdjg1ZDpaZ5L1lKk3/NHjIVh46kfs7VXrVHEOjiDR8Fpi1d3
   DMpQsxMVrJrlqaRZpn8lB2wutISX8QRxPKbGqqD5r3S6vm8iOmvF9X1Fa
   ahmyJWEXtUzwScvmfpr/H285NDMfMoR8ZCQzxeAEVSXm2CBDeJMuOhAIe
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="358421814"
X-IronPort-AV: E=Sophos;i="6.02,146,1688454000"; 
   d="scan'208";a="358421814"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 09:22:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="887881863"
X-IronPort-AV: E=Sophos;i="6.02,146,1688454000"; 
   d="scan'208";a="887881863"
Received: from spswartz-mobl.amr.corp.intel.com (HELO [10.209.21.97]) ([10.209.21.97])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 09:21:51 -0700
Message-ID: <d8c3888c-4266-d781-5d0a-381a57a9c35c@intel.com>
Date:   Thu, 14 Sep 2023 09:22:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH v6 05/25] x86/fpu/xstate: Remove kernel dynamic xfeatures
 from kernel default_features
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, chao.gao@intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-6-weijiang.yang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230914063325.85503-6-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/13/23 23:33, Yang Weijiang wrote:
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -845,6 +845,7 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
>  	/* Clean out dynamic features from default */
>  	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
>  	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
> +	fpu_kernel_cfg.default_features &= ~fpu_kernel_dynamic_xfeatures;

I'd much rather that this be a closer analog to XFEATURE_MASK_USER_DYNAMIC.

Please define a XFEATURE_MASK_KERNEL_DYNAMIC value and use it here.
Don't use a dynamically generated one.
