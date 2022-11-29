Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBDDB63C03D
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 13:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbiK2MlT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 07:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbiK2MlS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 07:41:18 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DF25EFB0
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 04:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669725677; x=1701261677;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LDPkGenlqJ0IGbAYKXQN1H4Pw6ZUC4/PSF/lCV3U2EQ=;
  b=KMECh30340RdwXGoioCSuXjHtWcvZQUzmTNi181/noeoSQV1JLmMaebB
   /l3Rt188HFEACha7y4ITpqG2OBuS/zFQt3RkB9uAvSgDM3txrcdZ5uExj
   gn3R/SBkdLsPHdBbyfvF05SpL3YB7wzb/9pjfPHvbbFzv/Y9exbIjLmoE
   j4Dj3UoA83T2s7UmOrhqXDhxPR0/B1OZtGNqZEU0AyuNvgmGBtQFrAQZ7
   vWmyExeGtpTqnfRMADUxxPmIXCHH0HTDEf3UF3MBiavEDfZWSH6/Kh79U
   Pmfo2ExG9y1wCqY94VDDm3+H2c7H+bdSw8VYmKDhGL5cYzFpZWRmZZ4K5
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="298446913"
X-IronPort-AV: E=Sophos;i="5.96,203,1665471600"; 
   d="scan'208";a="298446913"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 04:41:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="645884207"
X-IronPort-AV: E=Sophos;i="5.96,203,1665471600"; 
   d="scan'208";a="645884207"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 29 Nov 2022 04:41:16 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 29 Nov 2022 04:41:15 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 29 Nov 2022 04:41:15 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 29 Nov 2022 04:41:15 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 29 Nov 2022 04:41:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3D8ix7ILFJ/HfiOrJicdFGwU+eRGdBvNE8HnyoybX6d5/lD6rmwCVIhBAD+8Nkv12L83jWE956cOd7zlmSD4Rup+9n2rLyMz7R+bJTyzmX7grhGRQq+oCvPcMPFW29RBo+e+t25vmKoTgiwT8hsIHIkYAlbOh8+od22El++5RH/fVz5yM6RAfbATLHwcbXA3pXiJmah2o0neHK14vZ7zwUNrSLt6gvQTDMV3kvCs2DYt94/0IpS18Gg0Pco1uDJD63DS51U8JKRaimvZ3fypQY5f/bHI4DNg/dbcyAnILiT0qL10HEJ5T5N2nMQR1CpEMqXOsnYH1KpHHJUoxhd3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e9NDuLQlOGAQ4kUZqzNurPc3PN2nOj+5ANlRVmVl8iQ=;
 b=jEE5BytnmSsgJX/burSAYXJgWs3fs6f2pcVPFaRtmAmn6wsNinjUNsNV9m52ADgeW6d/mIoxbnhO3fwuRSdX6BlP8e1Z8ZNNtvg4vtxgNzORwEAx9tv/tU4A6U8Jt9u8MFcBJpqc/vxlZkvswf27d0cTLeNYFwc0dxqr1tHKIwoYa8WGGNzfOLlxnB+sb5ikeT2K/fV8FpQhdD7h0E4AUW8CHcTOlicTpwle5u3I3nZo7RqjGu7jbSdLJUqoyod4/EXkABRoyGPTE8vBw7ufqkX9UWy+FUb0I7A1VZ/34wc0GhIFxFPGjRwyorqLTa9S9mlFFX5ufEeyKOthStjhEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by DS0PR11MB6519.namprd11.prod.outlook.com (2603:10b6:8:d1::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 12:41:08 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::df5b:7a63:f34b:d301]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::df5b:7a63:f34b:d301%9]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 12:41:08 +0000
Message-ID: <2b57ae74-da41-50ff-13be-3069cd703ebc@intel.com>
Date:   Tue, 29 Nov 2022 20:41:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v3 00/11] Connect VFIO to IOMMUFD
Content-Language: en-US
From:   Yi Liu <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>, Yu He <yu.he@intel.com>
References: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <b35d92c9-c10e-11c0-6cb2-df66f117c13f@intel.com>
 <Y34ZTYah83eE1tm9@nvidia.com>
 <063990c3-c244-1f7f-4e01-348023832066@intel.com>
In-Reply-To: <063990c3-c244-1f7f-4e01-348023832066@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0110.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::14) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|DS0PR11MB6519:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e160f5e-33b8-4bb1-c2c4-08dad206fc90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j/HlZhi+1Uznm4/LsA9qTyW4I7PZ1dV1Pexj/p+rscx+wIbyEsDFrJ1sBJWHRO3sLC1oIk9utVt6VO+J62rz/Ea0EvAj5DK5GIAYwP+RioaCal21L+YPd5hbw8iAytSdCLkcIxCW7btpOWDJz+OubvC+jWhIjqOJTRVTCCjXJdL9yj9CN3kPSGZtzbzl3dmh4VCd3jU3Dg9AVSE8264HEnFkwvdCGC05UJZ/VggPece0q/Dk7P2VFwjPhp3Nh7+ckzdYGWZPiEtEvLLe3C5rkAbRqtCfK2bg+slaJ38qD2ZO2Hz7lhpxJ035KbfFNg6XU6IGqAobW0RclY961u/jxISuDGWi3IEuxDVm0hiHk3GDY7vmX5AboACtNxLvbi+VEU8J1o6rjYqtsfLwtlSNK+v+EL4Q0PebtGc42+83VuUMKSrdn0Nz74NaSsfvkANaVcUbkR5e1kTYHOhPceeQPBfEGmCuUUXnDZlGcUtGqPNGDN2FtUIdG4HkIKwXiup/mdmTRyonFKLV98FNwjw7Mnt9rmW4uWiQWPDGyCxlyTFj3SjIHPYd12FCH7IgZH4UcNUYYIYV4ZLH8o0w8VhWutjBH00C0VlePB7yANysgpqsCjXEzb0WUzTju9iJHmDYqi2xcDv8yv9lWslQ2I5m+6smSL+B2gO8TUmWx7Yh01HXLJj7Uinp/sayv85YFuQyTPBdVPK4gzU/wRiPUpIaJQjufruGvZkOpc9z8pATgyU4+25nfXgpjVbJ3lKmHjkzjMPYsttyVS7YcvuamZmeTMaga9GXkFAT2b3jBiD23jg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(316002)(6666004)(6506007)(6486002)(966005)(86362001)(31696002)(478600001)(83380400001)(31686004)(53546011)(2616005)(6512007)(26005)(54906003)(6916009)(41300700001)(5660300002)(82960400001)(2906002)(8936002)(38100700002)(186003)(8676002)(36756003)(4326008)(66476007)(66946007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OE1tazBuZlRWRVcwKzVsdU41REJLUXJRL05RT1BLem5vRythcnVoTW03eFZO?=
 =?utf-8?B?MjdNcGtqalJMNGdjRzFWZFMzMjdQRDl0SUhUSER4ZXhzY1VBZExMRFZGcnBu?=
 =?utf-8?B?SmZtblZkcG01aUEwMy92N0VXajRSbWhLT1RHVEJsQzBiMWhvdXBSK0o4ZXNE?=
 =?utf-8?B?N2JzWjB2UVVZdDRnSXRJcGNiRXkrNno4STFGdmk1QWRxQjJqZU52c0dTZC9V?=
 =?utf-8?B?V2xhNkZKM2J1andhazAvNHpTUFRrUHJaZXhVNFhLRytZT09EY2RGZW9tQ2pk?=
 =?utf-8?B?Vklld281amVtcUZNSDRRd3ZHODAwUnNlU1M4VCthWTNBdllTMHRXQ1ZlTkxp?=
 =?utf-8?B?Ynd0SGo2S01TSlo1b3loSXdPYTgzNDBjWVhnTzlldnp5NDFEb1UyVDhmV0J6?=
 =?utf-8?B?cVRUaUxiY1NUQXE1bDNVL3lrZCtja0w1c2UrSFpJQlVodUR2N1R1YjV0Q0hi?=
 =?utf-8?B?b1k3MUkvSGR1Q2pFd1E5QXo2TVh1bFd2cWhkYTVOU0kxLzYzRmdtWVdmZ0hT?=
 =?utf-8?B?UFozVkh4RzRxSVJpRXlYZzltSnZoVU51Nk43Z1VoejJJY0RzVWlpbnpBUVRS?=
 =?utf-8?B?NGtINUdxUmJ4dlRiQ2xTbzNWaVc1RmZoOVlSZ29mb0lEZ29tZnNKZnhiZWpq?=
 =?utf-8?B?ZTlRZHp4ODNhMCtjWGxsV2tBczNNbXlVWVdBeUFlK3ZOSVQ4bE1XbzQ2VkFU?=
 =?utf-8?B?T2lreExTUlJqR1Z4S2VFRHVBSUZFVFlocU80VnlnYm4yd3poUTNZYlBoQUZr?=
 =?utf-8?B?TGlqOUtURXl1d2RoOC9jb0g0cjZsVWlBQTFIM3N6M1B0VmNlaGMyUWRLZGRK?=
 =?utf-8?B?Y3dicTRPdmE2dVJ4VjZvRWZNWVBtakFmVVp5MS94YUU1WU5QUHRmdjRNQjhI?=
 =?utf-8?B?VkJIZk5aU2hHeUF6RjhYaGVNTEliV0VOUDZteGZSS0hubXQrRU5aL0hEczV6?=
 =?utf-8?B?VnVKc0FZWkU5OGUwSlliaWFHVm5SR3dyTG94b0xQTGhRNGRHU29yOWs2UmU5?=
 =?utf-8?B?dU5URmVQK01TOS85NWJQVkszd2tvZnNSQlBHQzhuZTN5K09qZ1phSytKdUZ4?=
 =?utf-8?B?cjRIc0cvd0N5YkpDZXNpTlVZVC9XNzhhVkdUNnBBWXFqVGZlNkJUMXJyTHFx?=
 =?utf-8?B?OG1YMDllRWJYR3NSOVhRa2ZoL0hEZjNwWWdTSHVFcEFBQno3K1hQcHJ3dGdO?=
 =?utf-8?B?Q0hGQVA1TERmQk5xWUdYbk1pZXV5VEZXcDh2SHZDZlFQRXowTldnWXFBdXZK?=
 =?utf-8?B?bHlVOGh6Q0MxbDFiL1VqTXpmNXR3VWRVQnpVVTg4UlNqWmd1cGZ4RzQ5NkJT?=
 =?utf-8?B?ODRMR0prNG8ralRjL1FOM3QvamVzb2hiT2tRcERrdHV2VDNEWk9kTktObzRn?=
 =?utf-8?B?RTJIeGh3bit1Ynh3aVNyeS9UUXpBZExEMVdmWGJCU3FuQ1FMRklKUzk0MHFy?=
 =?utf-8?B?L1pUNEpkSG1CUUpUZ0s5VDFyZ0JOa3R1cVN6cnBiTENoOG1tQ3lkd3FnWFFo?=
 =?utf-8?B?b3orNENBZGNQa2t3bFZ1WGpaV0RySjZWVUZxYzFmaGFLb1loNjlNUVM1cUs0?=
 =?utf-8?B?QmR6dVRBbmlsVHltUnJrYkRrOW5sTXQzTEMzR2x2U2h1NWpmWHFXSGpoUis3?=
 =?utf-8?B?RFltYnp1LzdyelgvY2QrT0JLRFMyVGhYaElmQ1Y2cUhlTXBFNGIyUjJtVUtT?=
 =?utf-8?B?MUVCcG94cE9XeUhuY0Q2TXFaSmp5bmdpRUlBTkdBOTEyNTRWSXhxUFhYdFZa?=
 =?utf-8?B?aUUwZ2NBM0dlRDBzeEYvWGNMbVo5eFpiSnF0STVjeVlieVdDKzFmWDAxdHU5?=
 =?utf-8?B?L284Unl3VXBQbFNtL1pPTDR0RDZKRWtvNkdpK0hINnV0VisreG5DVHJWYWR6?=
 =?utf-8?B?aUJCTVd3RXUyZ01URXZDckp2UnpmekYvanFuV1FpSkhnczBkaUxxTFlYREw2?=
 =?utf-8?B?cUJkcHhZaElEZVBBYVlxVTFta2lOOWFaVyttTWFIamN5ZEwrbk1JOUR3R0cy?=
 =?utf-8?B?dGFZaSttcHZCWGFZbnRKaHZrR0JZWXoxVkNwaHNQcUNiQzdYWDFaQUwxc1ZI?=
 =?utf-8?B?N2RJOXgzMmYrTEMralY5ckFyZk80bTQ0S0tsM0dBeG1kUzBVcHhyZ0RhbG9w?=
 =?utf-8?Q?yaGiKHJDmF26qDqjXBBpRTfLe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e160f5e-33b8-4bb1-c2c4-08dad206fc90
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 12:41:07.9382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GhJmeS1TDT4K+VAjE9llbQZN7zAAbZ7UTi6Xh+TnhLtEsfsb9hXySI25A+yvS++6JLDtxpfQSWVWi4XXgxMw+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6519
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/23 21:04, Yi Liu wrote:
> On 2022/11/23 20:59, Jason Gunthorpe wrote:
>> On Wed, Nov 23, 2022 at 10:44:12AM +0800, Yi Liu wrote:
>>> Hi Jason,
>>>
>>> On 2022/11/17 05:05, Jason Gunthorpe wrote:
>>>> This series provides an alternative container layer for VFIO implemented
>>>> using iommufd. This is optional, if CONFIG_IOMMUFD is not set then it will
>>>> not be compiled in.
>>>>
>>>> At this point iommufd can be injected by passing in a iommfd FD to
>>>> VFIO_GROUP_SET_CONTAINER which will use the VFIO compat layer in iommufd
>>>> to obtain the compat IOAS and then connect up all the VFIO drivers as
>>>> appropriate.
>>>>
>>>> This is temporary stopping point, a following series will provide a way to
>>>> directly open a VFIO device FD and directly connect it to IOMMUFD using
>>>> native ioctls that can expose the IOMMUFD features like hwpt, future
>>>> vPASID and dynamic attachment.
>>>>
>>>> This series, in compat mode, has passed all the qemu tests we have
>>>> available, including the test suites for the Intel GVT mdev. Aside from
>>>> the temporary limitation with P2P memory this is belived to be fully
>>>> compatible with VFIO.
>>>>
>>>> This is on github: 
>>>> https://github.com/jgunthorpe/linux/commits/vfio_iommufd
>>>>
>>>> It requires the iommufd series:
>>>>
>>>> https://lore.kernel.org/r/0-v5-4001c2997bd0+30c-iommufd_jgg@nvidia.com
>>>
>>> gvtg test encountered broken display with below commit in your for-next
>>> branch.
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/commit/?h=for-next&id=57f62422b6f0477afaddd2fc77a4bb9b94275f42 
>>>
>>>
>>> I noticed there are diffs in drivers/vfio/ and drivers/iommu/iommufd/
>>> between this commit and the last tested commit (37c9e6e44d77a). Seems
>>> to have regression due to the diffs.
>>
>> Do you have something more to go on? I am checking the diff and not
>> getting any idea. The above also merges v6.1-rc5 into the tree, is
>> there a chance rc5 is the gvt problem?
> 
> that is possible, I'll let my colleague revert it and try.

after reverting the v6.1-rc5 merge commit, the test is passed. also
tried your latest branch which has v6.1-rc6 merge commit, still observed
blank display. but this time, this issue can be recovered by restarting
gdm. It looks like the regression is not due to iommufd. May due to diff
in gvt and i915 itself. So reported a regression as below link.

https://lists.freedesktop.org/archives/intel-gvt-dev/2022-November/011488.html

-- 
Regards,
Yi Liu
