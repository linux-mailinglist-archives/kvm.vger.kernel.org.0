Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1C655C3D2
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242411AbiF1AE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 20:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiF1AE6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 20:04:58 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC94955BD;
        Mon, 27 Jun 2022 17:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656374697; x=1687910697;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vqC6za7ZN5iR/9XFisZNkkM6BFIN5Rq0bwxydFNlIpw=;
  b=F10pxssDNMWSeBlKTDcYA9Kxs34RT7s7Uq3gmbsfUJz9jr5yZ3dwl9EI
   vV6csWik8QiDNRh9MqGkzl//jo/TnQwcytvm4IJcIk2KzOl3H+dCEbixY
   pTKLAj8/KthURIKukp8nuKFsgyTJbKyo2/OlHWgeMv5U2L0HIL3gXCPV7
   YWxzwguW3v7Tlxa7YGB62NBsMVvc1sFXE6Jj/enZhvAdf3/a+adl2Vvux
   XUAHO+NVKm5Amul9cC1dz7hEno66piupla60rBwDkT4dD0bxYuVQqZvpa
   UByryYalIF4t0lRLym58BIMHGd+DZHHHcAP8VpSV6MTd6o1EoFW+TLX2o
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="261395817"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="261395817"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 17:04:57 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="732526044"
Received: from jsagoe-mobl1.amr.corp.intel.com (HELO [10.209.12.66]) ([10.209.12.66])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 17:04:57 -0700
Message-ID: <606f7526-23b8-a114-020f-b5fcdeecf90b@intel.com>
Date:   Mon, 27 Jun 2022 17:03:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v5 08/22] x86/virt/tdx: Shut down TDX module in case of
 error
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
References: <cover.1655894131.git.kai.huang@intel.com>
 <89fffc70cdbb74c80bb324364b712ec41e5f8b91.1655894131.git.kai.huang@intel.com>
 <765a20f1-681d-33c2-68e9-24cc249fe6f9@intel.com>
 <cc90e5f8be0c6f48a144240d4569b15bd4b75dd8.camel@intel.com>
 <77c90075-79d4-7cc7-f266-1b67e586513b@intel.com>
 <2b94afd608303f104376e6a775b211714e34bc7e.camel@intel.com>
 <6ed2746d-f44c-4511-7373-5706dd7c3f0f@intel.com>
 <a3831d3fc926905585f9fb1e14e13e502c1f5b65.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <a3831d3fc926905585f9fb1e14e13e502c1f5b65.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/27/22 16:59, Kai Huang wrote:
> If so,  in the assembly, I think we can just XOR TDX_SW_ERROR to the %rax and
> return %rax:
> 
> 2:
>         /*
> 	 * SEAMCALL caused #GP or #UD.  By reaching here %eax contains
> 	 * the trap number.  Convert trap number to TDX error code by setting
> 	 * TDX_SW_ERROR to the high 32-bits of %rax.
> 	 */
> 	xorq	$TDX_SW_ERROR, %rax
> 
> How does this look?

I guess it doesn't matter if you know the things being masked together
are padded correctly, but I probably would have done a straight OR, not XOR.

Otherwise, I think that looks OK.  Simplifies the assembly for sure.
