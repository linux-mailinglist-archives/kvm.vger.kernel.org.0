Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36AF56629C3
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 16:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbjAIPWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 10:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237154AbjAIPVk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 10:21:40 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27745392F0
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 07:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673277623; x=1704813623;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QwhWpIG98srAIvsgL6M1kIA+lZj5B8COGa6/ThGPJc8=;
  b=ZFXGEs7IFlW9M75mi9TeY3kYYGWCqKbmhvFBDF2snqfr2wefvce0fLKa
   6LqHtn4/Z2C8j6mH8XjRmvHoMXfiS2cZsZPgZjcOC8xlc54bfLLV9NEwO
   os7nINYRT4xUHV1vey2loDddb70vO5tBYxz/xuJgNJkdGoyUCjNr5qFaj
   ATEjZ9S+BG8KEXvaFx9J+c61S9BMGCs2UL/BRkQYoEhRh73tOmvRk9NoQ
   5ydzjpwgB94dOtspVowQBZP94tLcbRtrWDh0nFk2V/1p7zlwHBWmUI4n2
   6racPp/WG8dGdYFYmqjmfPXqK35kkFFXhLHLb7cvpQobrwl2ohjITEi39
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="324141096"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="324141096"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 07:20:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="650037627"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="650037627"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 09 Jan 2023 07:20:08 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 07:20:08 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 07:20:07 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 07:20:07 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 07:20:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MCwT/vis8vS85kXRonrQjgobcnlYdrtV657tyIQ0IiOzg9indCUCDvwsBGPujKbF1Q/G1XHsfQICiko2WT8ehjmO0FJUoiLOvMoYz4kZfojfsZ1oM4VKtSpu8VHkJ0O3Piki5aNupbS3Oed1450Q/e9T/JcIa5IbvFbF0ap/521JOQSpQfIxIrkUlKTTxZ04uw5KoXT6pbgwI7q9hapnklraotgw9fk2gkEZtxhQRXUnt4MFnfA/LNiJlX6eyW1Y4tttTa+4gXNsRbyDY7mLBe0/fI6JnsxKKPwMbqQuidw6zXT1PdJWgl2ubMoHmj7im/sdYJc2s6T+abCT7cGo/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i8PEZsAZZSjgO+sKbS/rBf31D7qMk+FM+E+XwYcYoeg=;
 b=K2p+s+Gwd9+caAyqZX9WzM31FuDTxu82YCX5ZAnFfYmPtiInjH+Tc4TL3J4EZ68R5cgOdURfJ+IMLzNZEtdFGq0UgOVnkKkKi6gEsxl/OzxWVkakSMRB2sDeg13etJwRRs+qkapEgFLQ9hwp8C3wwO5bwpXpuXnm4/R+JqXekm+JR7HLRcW6Gd8Y5t2fFvcGoTQtPyz9ZabbkL5NCZZ6NPHFhFlKJHyngPx5ostKgPjApDMFThJdXe4EVdMQfyMGRlhHm2wA0VXiF4pFJ9vI0UTSRQo3n0+jAo2/0Ct7XCPv92xK2tyki1A+EFtdwZm89clUBOpGzmNGS03goaWKqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB5077.namprd11.prod.outlook.com (2603:10b6:510:3b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 15:20:04 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 15:20:04 +0000
Message-ID: <967efc5b-6b5a-c00d-020b-1c3eea9f5cc6@intel.com>
Date:   Mon, 9 Jan 2023 23:20:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC 11/12] vfio: Add ioctls for device cdev iommufd
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-12-yi.l.liu@intel.com>
 <BN9PR11MB5276E47BF63C4553DD4C0F4C8CFE9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y7whYf5/f1ZRRwK1@nvidia.com>
 <f7ee1b8d-0aca-d211-b75f-04048bc367a2@intel.com>
 <Y7wu5UCHeZMZrzFQ@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Y7wu5UCHeZMZrzFQ@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0058.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::9) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH0PR11MB5077:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b074fcf-3ba0-444e-a5ca-08daf254fbed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MpU+n166CkqyrhU8FjbGfIIpvUyx1s2wahkrox/JjUP5VNQ8yH5hDR44k6KaiB/ITTAcXKBdnMt+MWD9wUE37d/wfC0Z1MfiaZQEBXU4mTFiUThVZqrd5Mw1y6osT6MJhP4JV7yuN0U/D2r0Ah8mNCnL6ZpQExmzai8r1ZBaOd4pjvgfag+5qk9bbZa5mBHDqGhS/CrbaOvO3BgmyKEVqQdUO31CsoFv1IuQimd0rHNPypvNme6gxYu4gNjbmuAIPYyerVcsuXVVXznP6KZiM6PIjrFYKntwVQ2tDnh4cMqg++VALB/c46DH/WVronsa+DPlV9ODn/Btngjc0cZlLOpnhYfXMoVZzAk2PtIq4XQ/4kGbwkPMdn5WAFqTP8DU1YZqx6k7p4s0U2JoWi30GYAShWj43Tk9tP/Pl6W5rve7Yrahy1Lpm0qSF1Vgy8kePUsDGG+Y/cvTCt/cXeOg+jX2CslsyfY6umJyKOPw96yQBOLdpbCPVGur7Ng/UV9qwFlKR73D9B4tnEjgdlxOv8RIiEx1YPokWORf5E3Iqg0weqyv4C/FDjhEMuM5xueJ1karHd3j4PYqiCh+Yzftvfp/5XXa1WwYFBQgrR9PnWc3bPKsY0UDpfum9Ya3poHNbYlYlDKEbAMjJDU+8XJppMmcKhCkLPkOIfP96lsFFciw8eVQUWgsKbSh2zEDEimlhCT3u2RSVYzPyljxIYMbrQnoykETegC9LCkSVAlGplE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199015)(8676002)(316002)(5660300002)(7416002)(26005)(6512007)(6486002)(478600001)(186003)(2616005)(41300700001)(31696002)(66946007)(4326008)(6916009)(66556008)(66476007)(54906003)(8936002)(83380400001)(36756003)(86362001)(53546011)(6666004)(31686004)(6506007)(38100700002)(82960400001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmQ3UFBXUkFvNnk3QWo2eWFFNTlWQzNoMFdMWjFiT1pEaXJuTU05QWtzMTFh?=
 =?utf-8?B?VTh3TlBhWUpZOHpDSjRmc2ZMREIyR3NLT3ZHWGY0VWJBSThMNUNxWHFrS0Ft?=
 =?utf-8?B?TzVIZ1ZRcVBTc2RGdGNVTG1aVXlUS1NaT0kzUFNQbENQQ0FyTTZHeWY3eEd0?=
 =?utf-8?B?OFJtdmRQUTA2eXhlYnQ1VWhZWFNyUjdpZm5DVmxIdUkzNlNDUnNSeGx1V2xr?=
 =?utf-8?B?bmxwdUJFNDFWbXpmVlJiWUpSMmI2SHNLdGwvRnZPNEc0NjlaY3FUSkRwclFY?=
 =?utf-8?B?eTBHYXpUSjdtcGQ0aUF6ZXd2NkF1bjdweVlRQzhmVTk0WE94VldTTngvSEt5?=
 =?utf-8?B?SFd1TFRxUG9sTWdCRG5hYytVb0pDL2JqS3hhTTR3ZlY2SGtVRStYRTF4QWFZ?=
 =?utf-8?B?SFhFWFNISGFyYXZ1V1NySGxkeTRqbmR3UURoTHJJRDBQaW9BNW1YZncrTkJM?=
 =?utf-8?B?cVBKazF2T1BCRmxUbUh0NHgzRXdjblcxRFB4MG5zbWljdWJJelh5dVRySUpI?=
 =?utf-8?B?WGlNdTNaYmtiazR0YjRPYk1UWmdnOVFDdlBsc1E0SmJQbVdqVStVblh4ZCtl?=
 =?utf-8?B?RVBxaWQzN2lXN1VRVmF4MzU3cVNYMFVHaDI0eTIxUGZLdk9kNjljMUk2QkUw?=
 =?utf-8?B?dGI2RFNrd25zZC9QNnhiNVlaS3pkcUV5Zk9ON1lQaFFsZ0U3ZXJlUE5lSnk2?=
 =?utf-8?B?eUJOdzBtWUFGYTEwVVd0L0JuRkRxaWxpNDZSTkpsUSsyZWEveDhVajgvMmFJ?=
 =?utf-8?B?b1ZxZnJsWVZYVTFzSHFVMklIenlNWDR0U2JKRkN0VDlrWFArU2k2ZWJxaWE0?=
 =?utf-8?B?RmtiY1c2MjUxZFI0bnl1YkY2WkdYNWRlY0c5RFloVm43Y3RNTnVoT3Y5eXFH?=
 =?utf-8?B?ZkthWHV3b2w0RkRTTHBRY3JpdWtpSnFrejNuTnhYeEFRWVhHaEU4bmxWQWRu?=
 =?utf-8?B?czFTb0FiVWZLSzV5d2k0KzJjeDJIQmZpRVNaS25QRWUydWFRL1VuWE5DV1R1?=
 =?utf-8?B?MURPeVdhY3poWi8zQTFLVW56WTZ4bUE3YWhVTkpxY0VHMEVkMHgrRFMrVkRh?=
 =?utf-8?B?ZlV0K0NQd0tzd3U0ZXpmUTFDWU5MNWFDeFlXd0VFV0dOOFR4MUZ3S05ONVcv?=
 =?utf-8?B?LyswT0ZCVE5kc21jdDRZZGRWUWhpdzhPU3BqU2NMd2t5YjBJbWFYdVpLZGJP?=
 =?utf-8?B?dFRDaG0zWStkdnFuaklkYUM0bTU5aTRWaXhCcThIVEVlZ0NCV1NMVU1nNkR3?=
 =?utf-8?B?YUFKamdwUndJQlppb1dVOWRlb21WaHFYWUk3N3orb3JXUXFDMXpiVE1PMHRU?=
 =?utf-8?B?dGRPQ05HSEtIY3pUdUw5RzJBeDFreFRxSEFDRFIvTGFhOHRPRG5LSlFUNnVk?=
 =?utf-8?B?VmEyYldGMTg4dDVVaXg3ay91eDFaaEtiWXJHWVhDb0FCcHdjUWlxNWpQSXdZ?=
 =?utf-8?B?WEYyc3pIeG9yTFAxSjd3UCtrUUpwZWg4eGdDMUxGcmVQVVdRTjFZUElPQ28x?=
 =?utf-8?B?TERuY0h2dWU5L1M0NVJUSFV2R3ZGUjlrWU85dzBseWN1T2dpamYzWXZsRUVx?=
 =?utf-8?B?SHZtdE9COFZRdjZuMkI5NWptT0svWXpxdjl0elBicXVsU3NhWUpGRjZvdDFh?=
 =?utf-8?B?eENVN1F5NjNCWXJ3TngvVmcyQ1JVbFV6eFg0MFdJNG1uNUFiblBzYjhrZU9s?=
 =?utf-8?B?M3NCMCttUWIxL0poSGJmdTZVTENna2pzV1VMN0wzRnNGYXhvcTF1SXBmczVn?=
 =?utf-8?B?VGIvMU1oNEwwdGFSREN2RTJvK0pjaVlHUmxQRHFMQldXTXlCU0tERHdjY1lH?=
 =?utf-8?B?cGFOYzBIeTEzNVF1cmpubVdTRThKVTNKWmRGWkhpbXZQbmV6QWo1bU4vSWxq?=
 =?utf-8?B?Sm83NzZZL2pCV2RyWWpDYXRDb1ZvYVZpN0JMTFM4NHp0LzZDd0pPT0c1Q2RZ?=
 =?utf-8?B?SmFXOFRwRVE3ZGVOSDFuRmxtMHFWNUN1ZjYwdkZtaVhVTDY4bmFwUGY2Mlc5?=
 =?utf-8?B?bUNJKzNVcUZXN0pyZm9Dd3hEbThEcXIzcnVJdVZ3bmVIMVpqMDY5c045THVK?=
 =?utf-8?B?R0dzYzZCQ3Q0NXhENnhzaURxcSs0MW1VSlg2N2NESEJQWnJOdEJvYlZQYllU?=
 =?utf-8?Q?SKZeLPGJddGx4/eFSzxVpEp9M?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b074fcf-3ba0-444e-a5ca-08daf254fbed
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 15:20:04.5426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qkGgtzXqBYRwq2Geo1uywtDFmkAT2WQVnsm6dAz5wNsWozC8zlghf3EzyDAQaEubnNnnrCV1+Q+lh4aDmZ/Oyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5077
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/1/9 23:12, Jason Gunthorpe wrote:
> On Mon, Jan 09, 2023 at 11:07:06PM +0800, Yi Liu wrote:
>> On 2023/1/9 22:14, Jason Gunthorpe wrote:
>>> On Mon, Jan 09, 2023 at 07:47:03AM +0000, Tian, Kevin wrote:
>>>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>>>> Sent: Monday, December 19, 2022 4:47 PM
>>>>>
>>>>> @@ -415,7 +416,7 @@ static int vfio_device_first_open(struct
>>>>> vfio_device_file *df,
>>>>>    	if (!try_module_get(device->dev->driver->owner))
>>>>>    		return -ENODEV;
>>>>>
>>>>> -	if (iommufd)
>>>>> +	if (iommufd && !IS_ERR(iommufd))
>>>>>    		ret = vfio_iommufd_bind(device, iommufd, dev_id, pt_id);
>>>>>    	else
>>>>>    		ret = vfio_device_group_use_iommu(device);
>>>>
>>>> can you elaborate how noiommu actually works in the cdev path?
>>>
>>> I still need someone to test the noiommu iommufd patch with dpdk, I'll
>>> post it in a minute
>>
>> I remembered I had mentioned I found one guy to help. But he mentioned
>> to me he has got some trouble. I think it may be due to environment. Let
>> me check with him tomorrow about if any update.
>>
>>> For cdev conversion no-iommu should be triggered by passing in -1 for
>>> the iommufd file descriptor to indicate there is no translation. Then
>>> the module parameter and security checks should be done before
>>> allowing the open to succeed with an identity translation in place.
>>>
>>> There should be a check that there is no iommu driver controlling the
>>> device as well..
>>
>> yes. I used ERR_PTR(-EINVAL) as an indicator of noiommu in this patch.
>> I admit this logic is incorrect. Should be
> 
> Oh please don't store ERR_PTRs in a structs..

okay. I need do it in other way. At first iommufd tells iommufd path
from the legacy group path. now, this is not enough. may need another
parameter to differ the iommufd normal path, iommufd noiommu path and
the legacy group path.

-- 
Regards,
Yi Liu
