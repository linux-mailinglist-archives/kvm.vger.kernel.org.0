Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021BF508227
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 09:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359761AbiDTHcV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 03:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359719AbiDTHcS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 03:32:18 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9B43B2AC;
        Wed, 20 Apr 2022 00:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650439773; x=1681975773;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+2VkkaHgs7Bi4lmS3LREzrgtsND2nPSs2jyfSDUHHGU=;
  b=UZluPZINbjZCeCKdtOV5ANkT+aU0cv1b24ntmZoknuYw8hqim/iNpULc
   MNhHhovbHKJgrWCRnRq0CAm/hfY3qC+jwgfs2tI0uA1r29zk5m7erIc4D
   VWQIsuBdANH6hV3Ub5OFX16LbupJSUaiE42YJNsTG1p+X6kUsMgBaLaQJ
   dUTl0atcHYsmCVG5BYaZoZkEHKwJMMzj1A0oV1Wyu2XcKmeRwKyi++bCl
   +aLB4G2+JTCCqsGSbrGfYGgQ+8rDHVVlKvjU88A6OKx/7t5L01f8urPWK
   P+0pfy03Cd/h17GCO1778ODdMuBhw4bdtY38Kh7vWCaXef0PNPD/C/aaS
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="261565065"
X-IronPort-AV: E=Sophos;i="5.90,275,1643702400"; 
   d="scan'208";a="261565065"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 00:29:33 -0700
X-IronPort-AV: E=Sophos;i="5.90,275,1643702400"; 
   d="scan'208";a="562007675"
Received: from ktuv-desk2.amr.corp.intel.com (HELO [10.212.227.192]) ([10.212.227.192])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 00:29:32 -0700
Message-ID: <faf366f9-a0cb-4121-e5bf-c63e6d0b14aa@linux.intel.com>
Date:   Wed, 20 Apr 2022 00:29:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v3 03/21] x86/virt/tdx: Implement the SEAMCALL base
 function
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com, isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <1c3f555934c73301a9cbf10232500f3d15efe3cc.1649219184.git.kai.huang@intel.com>
 <dd9d6f7d-5cec-e6b7-2fa0-5bf1fdcb79b5@linux.intel.com>
 <d1b88a6e08feee137df9acd2cdf37f7685171f4b.camel@intel.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <d1b88a6e08feee137df9acd2cdf37f7685171f4b.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/19/22 9:16 PM, Kai Huang wrote:
> On Tue, 2022-04-19 at 07:07 -0700, Sathyanarayanan Kuppuswamy wrote:
>>
>> On 4/5/22 9:49 PM, Kai Huang wrote:
>>> SEAMCALL leaf functions use an ABI different from the x86-64 system-v
>>> ABI.  Instead, they share the same ABI with the TDCALL leaf functions.
>>
>> TDCALL is a new term for this patch set. Maybe add some detail about
>> it in ()?.
>>
>>>
> 
> TDCALL implementation is already in tip/tdx.  This series will be rebased to it.
> I don't think we need to explain more about something that is already in the tip
> tree?

Since you have already expanded terms like TD,TDX and SEAM in this patch
set, I thought you wanted to explain TDX terms to make it easy for new 
readers. So to keep it uniform, I have suggested adding some brief 
details about the TDCALL.

But I am fine either way.

> 
> 

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
