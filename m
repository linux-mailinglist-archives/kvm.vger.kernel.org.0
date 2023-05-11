Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F646FE978
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 03:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236905AbjEKBag (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 21:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236172AbjEKBaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 21:30:35 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6D44EE8;
        Wed, 10 May 2023 18:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683768634; x=1715304634;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=u4WqbkHoxAV8VYoBAPgpHd4rjkwFS+Zg4DYcUWmcsy4=;
  b=FcYHYJN0mrAJjBRxNdZX6km8jIvpWJzFtesnusWs4o3OB+IPYAi5wbNz
   E5H+wM530Q1NSbNmO1EuJCjddbd33sjG/YP2+UmcLe4Vyw5eWMsw0fPLP
   FLLkOAxM0kA8ddvkG49GtgPSbH+bmc++I2Hud+mNtUKy0/Zd6lPvBJ/qV
   4ByhRbjX45Vqskj1aIOtCpvSvitzcmEQLwX7uVL8zIQMpLKwHhKUYJIxj
   kZiTX2cvJYgquIxyWagW67L3+stS84oLol0wBf6AGjYHteot4jkM0O/ds
   qrHve7x1nFzPHh1ACmi8LqS72Ci39EmK4GxRiPUSiuxBB4/i2LiUntKoL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="350397636"
X-IronPort-AV: E=Sophos;i="5.99,265,1677571200"; 
   d="scan'208";a="350397636"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 18:30:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="789173188"
X-IronPort-AV: E=Sophos;i="5.99,265,1677571200"; 
   d="scan'208";a="789173188"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.215.43]) ([10.254.215.43])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 18:30:32 -0700
Message-ID: <121e4796-6150-4bc7-fc6b-3dc292966687@linux.intel.com>
Date:   Thu, 11 May 2023 09:30:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v8 1/6] KVM: x86: Consolidate flags for __linearize()
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
 <20230510060611.12950-2-binbin.wu@linux.intel.com>
 <c9cbb52001c7229a6d6d140262adb327233f75fb.camel@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <c9cbb52001c7229a6d6d140262adb327233f75fb.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/10/2023 8:41 PM, Huang, Kai wrote:
> On Wed, 2023-05-10 at 14:06 +0800, Binbin Wu wrote:
>> Define a 32-bit parameter and consolidate the two bools into it.
> Technically, per C standard I don't think you can "define" a parameter of a
> function, but can only "declare".
>
>> __linearize() has two bool parameters write and fetch. And new flag
>> will be needed to support new feature (e.g. LAM needs a flag to skip
>> address untag under some conditions).
> Since this is the first patch to mention LAM in this series, it would be better
> to use the full name Intel Linear Address Masking (LAM).
>    
>> No functional change intended.
>>
>> In the follow-up patches, the new parameter will be extended for LAM.
> A duplicated sentence to me.  Perhaps you can just remove it.
>
> Some changelog material FYI:
>
> 	Consolidate two bool parameters (write/fetch) of __linearize() into a
> 	'u32 flag' parameter to make the function be more concise and future
> 	extendable, i.e. to support Intel Linear Address Masking (LAM), which
> 	allows high non-address bits of linear address to be used as metadata.
>
> 	Define two flags to replace the two bools.  A new flag will be added to
> 	to support LAM to skip masking off metadata bits of linear address
> under
> 	some conditions.
>
> 	No functional change intended.
Thanks, will update it.

>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Anyway:
>
> Acked-by: Kai Huang <kai.huang@intel.com>

