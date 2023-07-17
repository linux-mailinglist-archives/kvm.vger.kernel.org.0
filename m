Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798C77566DC
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 16:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjGQOxd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 10:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjGQOxc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 10:53:32 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F8AE72;
        Mon, 17 Jul 2023 07:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689605611; x=1721141611;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=08bGGgW1l7rlQQS6ONjNOLDr+jtJ5xjVWBt/oOlKRLY=;
  b=Dugj/fWzjt6WnCJp3buHNGFx2c8LOf2Omc7WMgJ/WX0WISsF1D2yondT
   30q8epzlHxue6ak1Z7juWKB8DvRbtnIT2nDzE0JvBQJIsg9iaN+fUZlhK
   SZIAwDbQJgXs8hAUmJEtpnZWSrpk5RIKFb2xrQLKxsezxwe18rrUm7KD8
   mKZePPnEMBdU8hNkgwYRUaqWydBEc1yg1yKiJKgZTKUaqYKZQcIVCswfZ
   ACPuIqi3HjZ3kjp+JZNY0Hp29eoXhT4tT0DVz1BccVnbTPowlRFlt76Df
   NnwtFWP43hkWMsg8zSFHDsVxy6dSxEVjrqp3r/mnxg0mrTUmG0ckgL++0
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="355885111"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="355885111"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2023 07:53:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="793274914"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="793274914"
Received: from avandeve-mobl1.amr.corp.intel.com (HELO [10.209.118.243]) ([10.209.118.243])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2023 07:53:29 -0700
Message-ID: <dc78085a-f9e2-b4ee-b85f-8709dfbe445e@linux.intel.com>
Date:   Mon, 17 Jul 2023 07:53:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 3/4] intel_idle: Add support for using intel_idle in a VM
 guest using just hlt
Content-Language: en-US
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, linux-pm@vger.kernel.org,
        artem.bityutskiy@linux.intel.com, kvm <kvm@vger.kernel.org>,
        Dan Wu <dan1.wu@intel.com>
References: <20230605154716.840930-1-arjan@linux.intel.com>
 <20230605154716.840930-4-arjan@linux.intel.com>
 <5c7de6d5-7706-c4a5-7c41-146db1269aff@intel.com>
 <747dca0b-7e79-738a-c622-3e2df61849ca@linux.intel.com>
 <CAJZ5v0h4PGFKB0kOL7-odNxNnSn-RxyGfj7atEcNLVfzep6pXw@mail.gmail.com>
From:   Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <CAJZ5v0h4PGFKB0kOL7-odNxNnSn-RxyGfj7atEcNLVfzep6pXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/17/2023 7:51 AM, Rafael J. Wysocki wrote:
> On Mon, Jul 17, 2023 at 4:10 PM Arjan van de Ven <arjan@linux.intel.com> wrote:
>>
>>> It leads to below MSR access error on SPR.
>> yeah I have a fix for this but Peter instead wants to delete the whole thing...
>> ... so I'm sort of stuck in two worlds. I'll send the fix today but Rafael will need to
>> chose if he wants to revert or not
> 
> I thought that you wanted to fix this rather than to revert, but the
> latter is entirely fine with me too.
> 

I would rather fix of course, and will send the fixes out shorty (final test ongoing)

