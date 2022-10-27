Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A1660FBDE
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 17:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235699AbiJ0P1M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 11:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235642AbiJ0P1J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 11:27:09 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B20817537B;
        Thu, 27 Oct 2022 08:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666884429; x=1698420429;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=g6NyrQKF9LXeHoOqXcvYnumDkoDsCA06btGLwWECbcQ=;
  b=cXx7AKZQxM6xMz9OYsAQ5QbCE8KHpy8BgZr6u0uDwZC3iTQpG35YnRpU
   YZ4MPncpFMyVWnuHh7F+xp/0Pf4dZODiJ788CLyI0Nh8KBVRiNfwcxOGa
   gCfP16DVTj8hOAPfPG9ccI3k4NosAifVCocsvXRhu9+rdLOf2MrDWaIbK
   bz/gDnPvJeE2kX2nhVk2GwJmIV7RuAlpY11rDIF9U6eEVQ9DMrc++VAPk
   hCohVOTMDAy4Giwm1KpjU5ig1iTPx2BYwsrzw11UbWrN3wZSKItf7THTb
   9agaLMdW/AAyD8/HHE75a0r11WABFuPuB9EA+bNOBDDFjE/FD30ExJS5k
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="291556175"
X-IronPort-AV: E=Sophos;i="5.95,218,1661842800"; 
   d="scan'208";a="291556175"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 08:27:08 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="663657349"
X-IronPort-AV: E=Sophos;i="5.95,218,1661842800"; 
   d="scan'208";a="663657349"
Received: from vstelter-mobl.amr.corp.intel.com (HELO [10.212.214.108]) ([10.212.214.108])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 08:27:07 -0700
Message-ID: <03677288-2e96-a66e-fb1a-331e3b0d112f@intel.com>
Date:   Thu, 27 Oct 2022 08:27:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v6 01/21] x86/tdx: Use enum to define page level of TDX
 supported page sizes
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, peterz@infradead.org,
        ak@linux.intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1666824663.git.kai.huang@intel.com>
 <8a5b40d43f8b993a48b99d6647b16a82b433627c.1666824663.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <8a5b40d43f8b993a48b99d6647b16a82b433627c.1666824663.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/26/22 16:16, Kai Huang wrote:
> +/*
> + * Get the TDX page level based on the kernel page level.  The caller
> + * to make sure only pass 4K/2M/1G kernel page level.
> + */
> +static inline enum tdx_pg_level to_tdx_pg_level(enum pg_level pglvl)
> +{
> +	switch (pglvl) {
> +	case PG_LEVEL_4K:
> +		return TDX_PG_LEVEL_4K;
> +	case PG_LEVEL_2M:
> +		return TDX_PG_LEVEL_2M;
> +	case PG_LEVEL_1G:
> +		return TDX_PG_LEVEL_1G;
> +	default:
> +		WARN_ON_ONCE(1);
> +	}
> +	return TDX_PG_LEVEL_NUM;
> +}

Is TDX_PG_LEVEL_NUM part of the ABI?  Or, is this going to accidentally
pass a whacky value to the SEAM module?

This needs something like this at the call-site:

	page_size = to_tdx_pg_level(pg_level);
	if (page_size >= TDX_PG_LEVEL_NUM)
		return false;
