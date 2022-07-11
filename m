Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5135056D6FA
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 09:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiGKHmn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 03:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiGKHmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 03:42:42 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E77A6568
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 00:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657525361; x=1689061361;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cF+4K6QenlpyyE2inesFodiy/sFRApWcFUFlCGKhEWk=;
  b=aSP5VtWcyj9CiHUBIAqVXZDUQUw3i76k08F6ZTYCPgIJbvPQB8W3Omzw
   vyu8s+euqNVAy1gA2sfgt4dqDxHeKvbxejwcsO7GqL8gSpmRR9hXluKQJ
   jTec7rcV9+wcuc70khOBx4a/nJY78y2Y2DnpVldWKQQVE0GnMB3wlPcWN
   wYaSrw0Y9JqXEg2gZIdkGwlx5BrWDnBTKLANLLiJimOMY+GHKeY9NC2Un
   FUXCbj8by+Fj/GZuWVYUJO6prsTqF5saceV0Tli2aCV9N8Fts+0jXMppd
   AAkW0DlkgXU6AQamhnlNvJljAMbkz1q9jrqAeem5GXeTQ9Xp6s1iNxKZI
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="264374614"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="264374614"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 00:42:41 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="621972286"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.249.168.105]) ([10.249.168.105])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 00:42:39 -0700
Message-ID: <a8daba2a-8eb1-282d-4b0c-9dafcb4f3202@intel.com>
Date:   Mon, 11 Jul 2022 15:42:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [kvm-unit-tests PATCH v5 1/3] x86: Use report_skip to log
 messages when tests are skipped
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
References: <20220708051119.124100-1-weijiang.yang@intel.com>
 <YshSnqun+UKQGKE3@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <YshSnqun+UKQGKE3@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/8/2022 11:51 PM, Sean Christopherson wrote:
> On Fri, Jul 08, 2022, Yang Weijiang wrote:
>> report_skip() prints message with "SKIP:" prefix to explictly
>> tell which test is skipped, making the report screening easier.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   x86/vmx_tests.c | 38 +++++++++++++++++++-------------------
>>   1 file changed, 19 insertions(+), 19 deletions(-)
>>
>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>> index 4d581e7..27ab5ed 100644
>> --- a/x86/vmx_tests.c
>> +++ b/x86/vmx_tests.c
>> @@ -4107,7 +4107,7 @@ static void test_vpid(void)
>>   	int i;
>>   
>>   	if (!is_vpid_supported()) {
>> -		printf("Secondary controls and/or VPID not supported\n");
>> +		report_skip("Secondary controls and/or VPID not supported\n");
> All of the manual newlines need to be dropped, report_skip() automatically inserts
> a newline.
Thanks Sean. I've rebuilt the whole series and posted the new one here:

-----https://lore.kernel.org/all/20220711041841.126648-1-weijiang.yang@intel.com

