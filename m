Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA8A76B321
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 13:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbjHALX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 07:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233804AbjHALXi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 07:23:38 -0400
Received: from mgamail.intel.com (unknown [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B40A1B4;
        Tue,  1 Aug 2023 04:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690888983; x=1722424983;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VDDWcVGS+hK7IXvS4+aNte96aXqDwd9n+f1OJ3QKozM=;
  b=Vtxslftgfg1fO78WxmlWEzsE3gvrytR4kXs2R/oO9s9FWoAzI1JgvJ9Z
   0G+teNJ74nTKo754eNIkQdg8ife4oLoajXsy3+BK4RroeewxmXQhLcGg1
   Sv1F24tTbK2zPQoFUce9YPZHS73AzvKDttKAw41ZmRRlERPljzTYu50Tt
   mqR7tLuaDeoFjF9AgNgezRyQwHMJ7XGkY2zNK1PolhyV00X/X8d5Gfs95
   3Vp1He3fQR1fdqxCXj8M+tYNlR+L9Uzr8HOy/NBZD7FlGD6CBXYtMXCwX
   KIc4zyTDssve933/W09Xb6g2Bn5T2uTBooTi53SPgREs+G9CJp/Pkd24Z
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="400222158"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="400222158"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 04:22:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="722452742"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="722452742"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2023 04:22:59 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 04:22:58 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 04:22:58 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 1 Aug 2023 04:22:58 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 1 Aug 2023 04:22:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JoMKwrsw6LM/eW6YDAPq4BnCpmwIepwiDdsvi4K7K4VcoZZvukTeOoylZY+hC4v5W88wkfdo6TfaykrQooJAangQvGy8RPrj21FPmV4O1qPWt3bNQ5Juy8eO7EiccunVdaMdgijIAsPi0xx013kYqOYZAyrD+56f6BVpLxbIFudDoztF07g7+Q8XRKfqrDp8oiM7OPZaz2WVvn3XTo0wy2dMSJ9PxrU4zKkaGAZz1U4GMdi43MXer31mAfiUPHXJEH8etj+3Jgwe7JMWiAMXQZx4cCECWw8NsdmUe4gpTpE15lycJOjXs2FgkZpwc5EnSFguQL9BJ4ZTaXTH5u/wGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bYCMXN12YnfnluR3ICl//DvI+0S34FJQF46VezXg9qw=;
 b=CUq1KqUFH1tUdjLqyipcWpzwzn9IvMrZFf+iGxAyoKcl6ykaxzAPS1/PGFU2Oxo98C6LHNb+v8JME8780TMCA/KsluwVPEIkrfs95OVc+bM6Mi2aSvWAIDsYgrNSYUC9PxIqPDxOQLjBxEtBuwU56yFRAugwGgN1H5D3SgPVInwqAeUyekMcGt5QGGk8BVQGqLEyaMlE3ylEayV90k4NHp2xLD9MoSBSmwXNyM4kH4KDq+/b/w4BsM/jk4fZOYS76ZT5NEsTwZbH1v+iEFLEq4EMpUAC/RMISlVKzAIlXGfegUDG0B5LeZakqP7bsReqRklQV56EHZYLXl098tmDNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) by
 CH0PR11MB5521.namprd11.prod.outlook.com (2603:10b6:610:d4::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6631.44; Tue, 1 Aug 2023 11:22:56 +0000
Received: from DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e]) by DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e%2]) with mapi id 15.20.6631.043; Tue, 1 Aug 2023
 11:22:56 +0000
Message-ID: <a865ff81-9d5e-f937-735c-3c619df42785@intel.com>
Date:   Tue, 1 Aug 2023 14:22:50 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 03/29] drm/i915/gvt: Verify hugepages are contiguous in
 physical address space
Content-Language: en-US
To:     Yan Zhao <yan.y.zhao@intel.com>,
        Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Ben Gardon <bgardon@google.com>
References: <20230729013535.1070024-1-seanjc@google.com>
 <20230729013535.1070024-4-seanjc@google.com>
 <ZMhkJa2/9/aboPju@yzhao56-desk.sh.intel.com>
From:   "Wang, Zhi A" <zhi.a.wang@intel.com>
In-Reply-To: <ZMhkJa2/9/aboPju@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0047.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::14) To DM4PR11MB5549.namprd11.prod.outlook.com
 (2603:10b6:5:388::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5549:EE_|CH0PR11MB5521:EE_
X-MS-Office365-Filtering-Correlation-Id: f6ae370a-4f5d-48e2-1bfb-08db9281a74f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6TvDnzS/9wwB4GyJSHL59PWkt/jYVOW0BXfmmR9iZxfe6WSJi3n++XOm0CAKsGHkZ7iyE9BjvXxcnhaldb5BoXpUzc41lmyOgVKIp+Fbr8MrjYexaronI2pdwDbbpn9jvccQ5spBuKNFqW6YELthFQqpzqS8ZJs2L0sZo+vR9TfERkqqoiOYFYbc2AgU549qZSHOb7CcRks3fVSXq/7JYwGN6Oc7Z5cCQ1Ke0EpmQftYkfXNf9iEjPB/004EIyJeeOIClxsxjzuXHjusJ5t1J9/+V5S3jsfMFivJWwU3rM9eugkH+dvy5qYlwVFVyjueLjBaobYKLFT5XhXWu/ZRsHzF1+1YPGlIOzKD8Bp6QC6HDwkcHTPN5DHnapDA9fDDdXooI0TB9zAENUYxYNe6oc49SF4btxRpseU3v+EFWWDV2fi/502BeBXiQI5zypvrcho2TiXZFHpfF6VqzqOJ6iQWrlaL1WokD3H61hkA1cMFYolSdIkpx6drw+To4eQYYcNn+EInL9q/hFvye7Gaqr5msJ+nNiSXcAdzzebVgUPtHfgEtcUy18T9EqTSZMT2dK1h34sUazRQbtesHSvoYgpoAXNX+A/Pn1kbHbxqYkBKixJlaON/dgUDKGRW3OvzPESzBKN/BdEjlT5abLA7BA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5549.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(136003)(346002)(39860400002)(396003)(451199021)(38100700002)(6506007)(5660300002)(53546011)(4326008)(66946007)(66556008)(66476007)(110136005)(82960400001)(54906003)(6512007)(478600001)(15650500001)(2906002)(2616005)(8936002)(8676002)(6486002)(41300700001)(31686004)(36756003)(31696002)(186003)(316002)(86362001)(6666004)(26005)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3laUmNQSFg1bGJLaTZjN3lveUFaRkV5b0Vpa1JVbXpWcHV2QW5Md3R5eVF6?=
 =?utf-8?B?QmFoTGoxSDNkdC9nRVRWVnM5UEZyd2cwZXFtSy8vaDZPWTg5UHh1aGZ6WWdU?=
 =?utf-8?B?Zks2aHNlMGFZWG9xcnUwSFFnSnZNTUlKYkYxY0YzRDZoMGdBMzUzVHVTVnhV?=
 =?utf-8?B?cGduWThBclZYN0RORUJqZm5oWHJVSjRpeWRvbE5XdXoxOWRBR3V4OXR1NFhk?=
 =?utf-8?B?Um00a210Z1g0cFlhL0lWN013QXRmN0F6c3Y1am44RFlGSE9kbzY2Qks5SHMz?=
 =?utf-8?B?WlVpdzhKNHpSeG04Y1Azbjd6M1N0NzlrVG0xdDJyKy9pdTVGWFNpaURtc1do?=
 =?utf-8?B?YW85WjdybHJiRHM4TEtwYjV0ZUdpTThtU3NHaHNiMlgvcyt2UG1LdWlZWTU1?=
 =?utf-8?B?L2JYY0ZncnNwY0IrbC8xZllWL3BhSnRCTWt2ZjAydHIvQnh4MW1SWmZJa3FW?=
 =?utf-8?B?cUZHdVN0VWJGV0ZETldqOHpxZkhjUXhtdkVkaWw3d1piQlBXN2VOakdqN0dh?=
 =?utf-8?B?S0RuTEJFa24wdzIySzVlVXd4emhnKy9XWlNEZ3RhRkFZdXN0ZEp6UjBzOGpp?=
 =?utf-8?B?bGwycnhEVjMveEx0ZVdvYmFKNng2NkQrWHdPUUVCd0xvUVU5OVhjaTZrNGUy?=
 =?utf-8?B?Q1N6aWZkMEhUcUQxVUp3Y3Zid3lYZU54dG9kd25hOGR3ZUVZRGQ1bXVzb3VO?=
 =?utf-8?B?bWhnazFvMjFESnYrR0tiVUNjTWRGUHlUdHpNeEN2ZzVBTE1RVEV4cVh4Qkxs?=
 =?utf-8?B?Si81TktiZDl5aDlwMEUvVzREU29ndHhFNFFaSFRDdHRPblJjZmpuekxKVWN3?=
 =?utf-8?B?MmpHN21CTU9GKzdYRU90UGtPTEk3QTZyQkZPNC9rUGlQY1lpdmxYbnZJeDVZ?=
 =?utf-8?B?bFdjb3hPMC9qV2Z4b3dZVWh4cCt6MzlsZHJhVnAvMy90SWxzcEo5NzkrTW5L?=
 =?utf-8?B?OW5sK2JxKzVmT0FZU0ZDcVAyUzBiLzh5a0YzZU9yMWNhWlk5d1ZjWWVsOE1E?=
 =?utf-8?B?OTJJbHpabWVrczhmUzlMNWtHUHRneExMZitBTTh5T08rVTlqeHdoS3hRWVdC?=
 =?utf-8?B?OS9jenVRRS9BbTRKWWRIRzg3UFk1d3FxdXpVM2tlS0xvS3RvODN2YTZEZ1dm?=
 =?utf-8?B?blBsUmY3SEFjYURRbE00eUdpUXhrSDVXdEdKaHBwejFGam5vSTBTNWorNUUx?=
 =?utf-8?B?Vm1IdUZQWWxhdTRGQi91c0xOQ2M4ak5lSVRZVGVEdjlQMzJIUnFDb1dQcmkx?=
 =?utf-8?B?a3hrNUlsOXhzVmV3QUlUcFJ1dFVZVExMaTMwWlVGcWVSdUVtQlI0azczdVB5?=
 =?utf-8?B?UU1vQmxPUXN2L3JsNXU2aXFrbVM1ZDArWGw3Qi9xbWVIQnl6ZDlRQ1Q3QUtV?=
 =?utf-8?B?d3BQRytDalZsQjNic3FuZ2VEb2JRWjNMd0gzSThVK05ZR2R5M29uMkRSNXpG?=
 =?utf-8?B?VXhya05aVHhyN3pTMXBEcGR0SHgyNXFmRzA0dnphR2lHNU5KNDdsV1hEWmk4?=
 =?utf-8?B?dXFZMnc3dHh5eWVndTE2WXJTelBUV3BNSFNuVm53QmNlUDQrenVWbjl2dU9j?=
 =?utf-8?B?bVlscW5LcHdKOWVFM0hnakU4cVR6SURYMCtDY2IrYXYxVDRhVG4rK2NGdE1s?=
 =?utf-8?B?QnVLY3Yyc0FSTDMwUFpKeXlxaHRXOXZuZk8rc2VpMkdRVzlPRE1IeFdrRGI0?=
 =?utf-8?B?aHA5L0VvbGRFZEtTalV2ZEcwWFpwN2ZSTlk5QjFBWkRuWkU5MDhUZ0FYRXJq?=
 =?utf-8?B?aXg0MWxIcFVudzBpZTJYOXErNGRVQjBWN0RudzcwbUVLbmlOUTVURGhubFo1?=
 =?utf-8?B?RnFYTTdreHpwcnZNVE91NzFhUHBWZERGNjZ1R3hhdkdXOG0rSTlRRDJwS1U4?=
 =?utf-8?B?RUFRRUUwY3gwVnA3Mlk4VW1oUFE5U0ZEd1ZNdis4NjhkUmFIc09mNmxZM0xv?=
 =?utf-8?B?Q0hISjV2dmVWVUdNWjl1WGJiYmJyd1pSNEJ2TEZtbjB1Ull1MVovYkhRZXpO?=
 =?utf-8?B?cXAzRzJkRzQxK2o5dElRZnFCaGVBS1B1M01vRVpxWURXdVhRcjBFMlVVMFlC?=
 =?utf-8?B?SzF0VUFPbWN5Tm4zc3VGOVZ1bzBFd3crREVyVDlZSkxHUlY5NHNHZjNpZm92?=
 =?utf-8?Q?gZTm0a3oMPxSyrgOzIrOiu3Nn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f6ae370a-4f5d-48e2-1bfb-08db9281a74f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5549.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2023 11:22:56.0703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WUDPBXnVAyxAJ94syuYknvu1Ukinh2fi/LBB/sOgKUHHFzPHGkRO1dcqpdcpc+1HWcBUYsEox0ScSLd5uOc7Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5521
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/1/2023 4:47 AM, Yan Zhao wrote:
> Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
>
> On Fri, Jul 28, 2023 at 06:35:09PM -0700, Sean Christopherson wrote:
>> When shadowing a GTT entry with a 2M page, verify that the pfns are
>> contiguous, not just that the struct page pointers are contiguous.  The
>> memory map is virtual contiguous if "CONFIG_FLATMEM=y ||
>> CONFIG_SPARSEMEM_VMEMMAP=y", but not for "CONFIG_SPARSEMEM=y &&
>> CONFIG_SPARSEMEM_VMEMMAP=n", so theoretically KVMGT could encounter struct
>> pages that are virtually contiguous, but not physically contiguous.
>>
>> In practice, this flaw is likely a non-issue as it would cause functional
>> problems iff a section isn't 2M aligned _and_ is directly adjacent to
>> another section with discontiguous pfns.
>>
>> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>   drivers/gpu/drm/i915/gvt/kvmgt.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
>> index de675d799c7d..429f0f993a13 100644
>> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
>> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
>> @@ -161,7 +161,7 @@ static int gvt_pin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
>>   
>>   		if (npage == 0)
>>   			base_page = cur_page;
>> -		else if (base_page + npage != cur_page) {
>> +		else if (page_to_pfn(base_page) + npage != page_to_pfn(cur_page)) {
>>   			gvt_vgpu_err("The pages are not continuous\n");
>>   			ret = -EINVAL;
>>   			npage++;
>> -- 
>> 2.41.0.487.g6d72f3e995-goog
>>
Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>

