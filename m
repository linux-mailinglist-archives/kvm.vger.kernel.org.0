Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4AD6BBBC4
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 19:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbjCOSNe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 14:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbjCOSNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 14:13:32 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A61572BB;
        Wed, 15 Mar 2023 11:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678904011; x=1710440011;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=E//nrmQsW8a4Cr6Hfioyr2jv1DvoWwQ5iS9EmPkgcdM=;
  b=hhCDguwrUvfQLhx7Hb7ACdHm+s+yUXmG5Ubxi/XMsPtQIyuRw6HBDAfI
   51AvmZW6JF0m8y7++HupJS1wAY0Kn2+UPPhla8A00LZOgCrkyL+0Pe7Nc
   NueY6BM3hkhY2TKMS7s0guoROILM7aWsa44ESSNHsetZWdmPdeXys0Ht/
   NfReSclHeShxWV3k9G3x0sJg1A4/m8PIrgrxFkJD70jSv0/bdDx9jwXg3
   1f+wqmpZitMh+L4RgipY0XRco37c+f3aqtZMnwZAxinx2R5EXFMC2kFub
   ytSVIAlII7XmnkfAq+8jHSDnhOxefVuBI0WC28hKMufXBFtAxGGmE7Gy2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="318183595"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="318183595"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 11:13:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="743824772"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="743824772"
Received: from ahajda-mobl.ger.corp.intel.com (HELO [10.213.23.62]) ([10.213.23.62])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 11:13:28 -0700
Message-ID: <871f7c8b-0f54-7e9c-4253-b3878b010bbf@intel.com>
Date:   Wed, 15 Mar 2023 19:13:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
Subject: Re: [Intel-gfx] [PATCH v2 01/27] drm/i915/gvt: Verify pfn is "valid"
 before dereferencing "struct page"
Content-Language: en-US
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
Cc:     "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-2-seanjc@google.com>
 <DS0PR11MB63733BCF5AEBBF5F38FD2C01DCB99@DS0PR11MB6373.namprd11.prod.outlook.com>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <DS0PR11MB63733BCF5AEBBF5F38FD2C01DCB99@DS0PR11MB6373.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13.03.2023 16:37, Wang, Wei W wrote:
> On Saturday, March 11, 2023 8:23 AM, Sean Christopherson wrote:
>> diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
>> index 4ec85308379a..58b9b316ae46 100644
>> --- a/drivers/gpu/drm/i915/gvt/gtt.c
>> +++ b/drivers/gpu/drm/i915/gvt/gtt.c
>> @@ -1183,6 +1183,10 @@ static int is_2MB_gtt_possible(struct intel_vgpu
>> *vgpu,
>>   	pfn = gfn_to_pfn(vgpu->vfio_device.kvm, ops->get_pfn(entry));
>>   	if (is_error_noslot_pfn(pfn))
>>   		return -EINVAL;
>> +
>> +	if (!pfn_valid(pfn))
>> +		return -EINVAL;
>> +
> 
> Merge the two errors in one "if" to have less LOC?
> i.e.
> if (is_error_noslot_pfn(pfn) || !pfn_valid(pfn))
>      return -EINVAL;

you can just replace "if (is_error_noslot_pfn(pfn))" with "if 
(!pfn_valid(pfn))", it covers both cases.

Regards
Andrzej
