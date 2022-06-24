Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F13F55A112
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 20:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbiFXSio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 14:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiFXSin (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 14:38:43 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733E354BEC;
        Fri, 24 Jun 2022 11:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656095922; x=1687631922;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=B9kU50pQRrH8ip6M39PDMdwIkR+/caDx8kDBNekEpWE=;
  b=jjrYJi/4mhwFgPC21byaVdTjQOFHvOU3/wdSVWd6C8pDkTMPTvWlExiI
   QIhQZxCXW4YYNp2uUZ7yo/XbrVWmPspJl47VwpYTuSmgeBPHAJGeCXTfW
   nFlv26/FO7AHmbJ3JVNR8A68wbCz/BK40uwO/mtJgajAKeU4zBQCR2SmT
   DS+k0yt0cq4+ZinndVzxLEmR3MiOHQSKmRxqQyXFnP53MUnzSZssHZjhU
   tped6dmE92y9rQPXgibTOK9iLbtouY57gPCBvyEpDytgYMpIKcihOA4Fo
   qt9ZAJV59wHCmKDX3x5CJPJdFxD4mZmJlPWiYKv9lDQL0zeikUBqa7yvD
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10388"; a="278609698"
X-IronPort-AV: E=Sophos;i="5.92,220,1650956400"; 
   d="scan'208";a="278609698"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 11:38:42 -0700
X-IronPort-AV: E=Sophos;i="5.92,220,1650956400"; 
   d="scan'208";a="731426029"
Received: from mdedeogl-mobl.amr.corp.intel.com (HELO [10.209.126.186]) ([10.209.126.186])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 11:38:41 -0700
Message-ID: <069a062e-a4a6-09af-7b74-7f4929f2ec0b@intel.com>
Date:   Fri, 24 Jun 2022 11:38:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v5 07/22] x86/virt/tdx: Implement SEAMCALL function
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
 <095e6bbc57b4470e1e9a9104059a5238c9775f00.1655894131.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <095e6bbc57b4470e1e9a9104059a5238c9775f00.1655894131.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/22 04:16, Kai Huang wrote:
> SEAMCALL instruction causes #GP when SEAMRR isn't enabled, and #UD when
> CPU is not in VMX operation.  The TDX_MODULE_CALL macro doesn't handle
> SEAMCALL exceptions.  Leave to the caller to guarantee those conditions
> before calling __seamcall().

I was trying to make the argument earlier that you don't need *ANY*
detection for TDX, other than the ability to make a SEAMCALL.
Basically, patch 01/22 could go away.

You are right that:

	The TDX_MODULE_CALL macro doesn't handle SEAMCALL exceptions.

But, it's also not hard to make it *able* to handle exceptions.

So what does patch 01/22 buy us?  One EXTABLE entry?
