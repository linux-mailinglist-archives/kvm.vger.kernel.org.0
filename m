Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48E551D0A5
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 07:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389127AbiEFFbX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 01:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389116AbiEFFbV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 01:31:21 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6282C91;
        Thu,  5 May 2022 22:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651814859; x=1683350859;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jjJ7o6bLleTyPSL5b0r/x/WkMwEejBsryTcFEZh8gPU=;
  b=NHkpr+PE1Rb8RVvHCpakawJcvpL9zOrcoFMsayLXcdo/795v+pQ2CAMT
   hHy6jOqA+7sJ+pAIUEj9umkWCjRt3qAmZqbdOSwTtY0q7arkVgFNUGzKm
   Tsd9Rhtg+/n+G1ZBawkcB2m3f0XYWNQZkYl/fuOaRv4YL7ofvNJgibgIc
   06uThUi7552dzJ7GIOBPJrN5VLtAxkTvTlzbVLfosyOpQLSwlagypxGIZ
   E7hrZG1gCvZlYs7luQQZti/0MFhnAPSo4ef28maJE7RxLKjaOJgrvawZr
   tEdA/j43g0UWJwJ+ufNecxdTMwq3poEor6RgrgHmz5MJgiPh+gxp6W1sc
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="328901599"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="328901599"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 22:27:38 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="585780403"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.169.36]) ([10.249.169.36])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 22:27:35 -0700
Message-ID: <0233f2dc-31b9-ff30-67c9-2ad5871e7dda@intel.com>
Date:   Fri, 6 May 2022 13:27:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [RFC PATCH v6 025/104] KVM: TDX: initialize VM with TDX specific
 parameters
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <fbc23565f7556e7b33227bcad95441195bb4758d.1651774250.git.isaku.yamahata@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <fbc23565f7556e7b33227bcad95441195bb4758d.1651774250.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/2022 2:14 AM, isaku.yamahata@intel.com wrote:

...

> +	if (init_vm->tsc_khz) {
> +		guest_tsc_khz = init_vm->tsc_khz;
> +		kvm->arch.default_tsc_khz = guest_tsc_khz;
> +	} else
> +		guest_tsc_khz = kvm->arch.default_tsc_khz;
> +	td_params->tsc_frequency = TDX_TSC_KHZ_TO_25MHZ(guest_tsc_khz);

Isaku,

I think Paolo meant

1. user space calls VM-scope KVM_SET_TSC_KHZ

and

2. td_params->tsc_frequency = 
TDX_TSC_KHZ_TO_25MHZ(kvm->arch.default_tsc_khz);

in 
https://lore.kernel.org/all/e392b53a-fbaa-4724-07f4-171424144f70@redhat.com/

so we can drop @tsc_khz in struct kvm_tdx_init_vm.
