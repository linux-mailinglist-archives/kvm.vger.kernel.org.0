Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D663C55A1A6
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 21:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbiFXTCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 15:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiFXTCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 15:02:08 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9978481C56;
        Fri, 24 Jun 2022 12:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656097327; x=1687633327;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rw+WyFUAf3l7fMVQp8VWYt4eiSC3w+U9RlZ7M9htBWE=;
  b=McSb1pbAeCWWPBJuORdhsUaFY+kxe7r+INjwzLk9N+VNpJPU7YUWZen0
   +DCsRi/7WV61vKbLKGVlUsH2xinu8TKGninO8rumAdf+Dy8V34QJk8gZj
   tXmuy+UJnftQB+Gn1qik2YrJ2SUSlGUrd1NhkISJSrqv+hRhsuAS+P9gl
   xNH/DTkUaFxgIT/XZ+GPHtbVofCH9iuHOFIxUmq4jHwLYd2U+qOT3Lw6M
   vjCRvlEXSHjRqTY4LV50Uz6K8COiAfDsJUyeS1ZYRxAhCD4AmuakG+UNK
   vopU3y9Xg+aJ5clm3QbpdONtGihlcvPOBVuq2q4Y3pJB1IEDzXUxnJ0uf
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10388"; a="306534456"
X-IronPort-AV: E=Sophos;i="5.92,220,1650956400"; 
   d="scan'208";a="306534456"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 12:02:07 -0700
X-IronPort-AV: E=Sophos;i="5.92,220,1650956400"; 
   d="scan'208";a="731432538"
Received: from mdedeogl-mobl.amr.corp.intel.com (HELO [10.209.126.186]) ([10.209.126.186])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 12:02:06 -0700
Message-ID: <9a4ff92a-1d79-d91e-0dbc-a1cbde215184@intel.com>
Date:   Fri, 24 Jun 2022 12:01:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v5 05/22] x86/virt/tdx: Prevent hot-add driver managed
 memory
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, akpm@linux-foundation.org
References: <cover.1655894131.git.kai.huang@intel.com>
 <173e1f9b2348f29e5f7d939855b8dd98625bcb35.1655894131.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <173e1f9b2348f29e5f7d939855b8dd98625bcb35.1655894131.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/22 04:16, Kai Huang wrote:
> @@ -1319,6 +1330,10 @@ int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>  	if (ret)
>  		return ret;
>  
> +	ret = arch_memory_add_precheck(nid, start, size, mhp_flags);
> +	if (ret)
> +		return ret;

Shouldn't a patch that claims to be only for "driver managed memory" be
patching add_memory_driver_managed()?
