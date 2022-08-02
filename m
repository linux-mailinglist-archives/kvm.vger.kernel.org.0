Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988AE587560
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 04:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbiHBCBT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 22:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235904AbiHBCBR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 22:01:17 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85F3F5AE;
        Mon,  1 Aug 2022 19:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659405675; x=1690941675;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QFlgAKqTB8gdWypxOP5EQfQFZ19EkRrqD1V34Ml/mk0=;
  b=GnzOnI0/32UPZfU7T1W71NKY12KPvzAKT3YhNujOg9XeftIr/K2b0LuV
   zdqvwewrwI+H9V1AX3irNLM9OqVhQAxU0Rm0rJ7XLKSUwBvAKuGqmBYkm
   PtKYnwsgK7CN/PH0xdLqqRkyfz4d4+C47I7lDI/zvFgaIKLSsgZWZQiy1
   iLNwSuUYF7qOWM/xIuSRC81IVs7oOwZyB16/xpHA4VTyMpUrcaYuDraBS
   X+pZZkkOnPwlMEyEoWqgZPXcDk5IYgjpymVSkANvqvHNk5Z7CBC2uuJOy
   HXVXlHEQ/LsAoXvdTsyb1trn1e1rAoWmu59kfiFeYnb5XC2+9UowS6HM9
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="290072321"
X-IronPort-AV: E=Sophos;i="5.93,209,1654585200"; 
   d="scan'208";a="290072321"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 19:01:15 -0700
X-IronPort-AV: E=Sophos;i="5.93,209,1654585200"; 
   d="scan'208";a="661419442"
Received: from xinyuwa2-mobl1.ccr.corp.intel.com (HELO [10.255.28.181]) ([10.255.28.181])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 19:01:12 -0700
Message-ID: <7bd30975-fdcc-7d87-af4a-448b92bb6e02@linux.intel.com>
Date:   Tue, 2 Aug 2022 10:01:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH v5 1/22] x86/virt/tdx: Detect TDX during kernel boot
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
References: <cover.1655894131.git.kai.huang@intel.com>
 <062075b36150b119bf2d0a1262de973b0a2b11a7.1655894131.git.kai.huang@intel.com>
From:   "Wu, Binbin" <binbin.wu@linux.intel.com>
In-Reply-To: <062075b36150b119bf2d0a1262de973b0a2b11a7.1655894131.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/6/22 19:15, Kai Huang wrote:
> +	/*
> +	 * TDX guarantees at least two TDX KeyIDs are configured by
> +	 * BIOS, otherwise SEAMRR is disabled.  Invalid TDX private
> +	 * range means kernel bug (TDX is broken).
> +	 */
> +	if (WARN_ON(!tdx_keyid_start || tdx_keyid_num < 2)) {
Do you think it's better to define a meaningful macro instead of the 
number here and below?
> +		tdx_keyid_start = tdx_keyid_num = 0;
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +

> +
> +/**
> + * platform_tdx_enabled() - Return whether BIOS has enabled TDX
> + *
> + * Return whether BIOS has enabled TDX regardless whether the TDX module
> + * has been loaded or not.
> + */
> +bool platform_tdx_enabled(void)
> +{
> +	return tdx_keyid_num >= 2;
> +}
>
>
