Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56774694EE2
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 19:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbjBMSJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 13:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbjBMSJg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 13:09:36 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B053C2D;
        Mon, 13 Feb 2023 10:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676311758; x=1707847758;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=G5AV2pkXDQoTS6YCv9ce9+5JFgN9La2hpC0dnMFOo9o=;
  b=gT+wtp6M6kV/Yyf3QTkDS8xJBxZ57EXxp4E9GdpIBnQxUqqlgPQSnyY6
   kff2ADZbPOJHUKJgsnzyqYhyAnzKKJy7dqcLdfCN9QK66s8CQynDBWJOY
   w/qJDi4iFuItQqdXlu7OU5DY0TRqnMzl5IlfFKLLsVUkj8b/1aRcg/kdQ
   8xVSf2Yf2QG4vGVw/fHl8UlaP5ib2/HB9xW1QAt8pF+DKZ0B+cBuwFhpi
   l3xKuWXKwLuMQ+7EcCa9hPLdFFOAY2RSqLQIrtr8jQhYjFIM3OM9BfMTf
   h6tFn5iKeZ3YCSe+1oVXuiZ2m/OHXmflazjvWtH1/MOLCGaQ1UQ0NCNnJ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="395567986"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="395567986"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 10:07:32 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="842854085"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="842854085"
Received: from mlswanso-mobl.amr.corp.intel.com (HELO [10.251.26.232]) ([10.251.26.232])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 10:07:30 -0800
Message-ID: <2d9172c5-e1e7-bf94-c52b-0e9bc5b5b319@intel.com>
Date:   Mon, 13 Feb 2023 10:07:30 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, david@redhat.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1676286526.git.kai.huang@intel.com>
 <557c526a1190903d11d67c4e2c76e01f67f6eb15.1676286526.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <557c526a1190903d11d67c4e2c76e01f67f6eb15.1676286526.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/13/23 03:59, Kai Huang wrote:
> @@ -247,8 +395,17 @@ int tdx_enable(void)
>  		ret = __tdx_enable();
>  		break;
>  	case TDX_MODULE_INITIALIZED:
> -		/* Already initialized, great, tell the caller. */
> -		ret = 0;
> +		/*
> +		 * The previous call of __tdx_enable() may only have
> +		 * initialized part of present cpus during module
> +		 * initialization, and new cpus may have become online
> +		 * since then.
> +		 *
> +		 * To make sure all online cpus are TDX-runnable, always
> +		 * do per-cpu initialization for all online cpus here
> +		 * even the module has been initialized.
> +		 */
> +		ret = __tdx_enable_online_cpus();

I'm missing something here.  CPUs get initialized through either:

 1. __tdx_enable(), for the CPUs around at the time
 2. tdx_cpu_online(), for hotplugged CPUs after __tdx_enable()

But, this is a third class.  CPUs that came online after #1, but which
got missed by #2.  How can that happen?
