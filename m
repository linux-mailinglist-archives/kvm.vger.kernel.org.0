Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95FE865BC32
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 09:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237011AbjACI1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 03:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjACI1G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 03:27:06 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA8EDF87;
        Tue,  3 Jan 2023 00:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672734425; x=1704270425;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5beijWPU1uPpW8czZDjIwlVtrcesTLaWCl4YOM+jLzw=;
  b=IEwEQTC7arDaWA5x0kJMJ95s4YHWpIRNZljA0aq2sjxCzfscuM0Hr6Yg
   gYjV4oelWyMyZksYdZPrx7h+Krltgp3UyXuSfgKJ7GJAR6fyT4cXUjgQd
   xoQEWsIUnOQqfR3GswyLTvMXxIggrGYR640PPOZTuwDM36Xg/2cTyarkC
   dVubaAziBVPjg/VkY4zSS4bKYN8DrInF3dwd3rvmw0QK6A/xoYd54BY6p
   DtNAF2zaDKKp73B3EwjKv2hk88pGvcpkYzwPaUra4i77W+zvupOkosubq
   ZkrLEwnOszJfdhI1bgGdjixzNlhqKST4o8RSYCx1/U4zhsxXZTYz9DQOh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10578"; a="407868363"
X-IronPort-AV: E=Sophos;i="5.96,296,1665471600"; 
   d="scan'208";a="407868363"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 00:27:05 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10578"; a="983494958"
X-IronPort-AV: E=Sophos;i="5.96,296,1665471600"; 
   d="scan'208";a="983494958"
Received: from leiwang7-mobl.ccr.corp.intel.com (HELO [10.254.213.238]) ([10.254.213.238])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 00:27:03 -0800
Message-ID: <44e77307-8c49-e350-49e4-d5fa3261db27@intel.com>
Date:   Tue, 3 Jan 2023 16:26:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.1
Subject: Re: [PATCH v10 000/108] KVM TDX basic feature support
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
From:   "Wang, Lei" <lei4.wang@intel.com>
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/30/2022 2:22 PM, isaku.yamahata@intel.com wrote:

> ** Detecting the TDX module readiness.
> TDX host patch series implements the detection of the TDX module availability
> and its initialization so that KVM can use it.  Also it manages Host KeyID
> (HKID) assigned to guest TD.
> The assumed APIs the TDX host patch series provides are
> - int seamrr_enabled()
>   Check if required cpu feature (SEAM mode) is available. This only check CPU
>   feature availability.  At this point, the TDX module may not be ready for KVM
>   to use.
> - int init_tdx(void);
>   Initialization of TDX module so that the TDX module is ready for KVM to use.
> - const struct tdsysinfo_struct *tdx_get_sysinfo(void);
>   Return the system wide information about the TDX module.  NULL if the TDX
>   isn't initialized.
> - u32 tdx_get_global_keyid(void);
>   Return global key id that is used for the TDX module itself.
> - int tdx_keyid_alloc(void);
>   Allocate HKID for guest TD.
> - void tdx_keyid_free(int keyid);
>   Free HKID for guest TD.

tdx_enable() is introduced by TDX host patch series and used in patch 5, should
it be added to this list too?
