Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13EA552903
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 03:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243207AbiFUBcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 21:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243193AbiFUBce (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 21:32:34 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD321928B
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 18:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655775154; x=1687311154;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z8fYYuKYCbW9FryOqsKC5lztDWWq3ZI0a0gofUK4uJc=;
  b=Pto/+KR5xgWFqR4kCs3L+g2wH7wwGbQdyQU4cl2Lf0wDuoJDl0DuDUP4
   H5gRkEEvCgQOCqt2NrFw4FTxWqiyDX8GiLwOuuw/SxnI4RTKOCq1iP4Ui
   +0GnVUyW9e2rIXCRO7SJquXhjpKzyaejvR3GQzUNMeGcaItSZo8YhJ62S
   9QuoJxg/UwPm+d+h6Ex0r0yHcLPAYu1fzaYzDPp/aE0vADzTb1JrWY3Ls
   8cYUmPOc+qzNQ7xBqhJhRCQZZ3pUS3Yi4zOW+IltD5LhcvUbQ4UMpWwax
   DtxwZmaqteVUh1k8I7KiTarbiV5uGhX13Pt2wh9e/BRAggMBzMnvRC98X
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="259822141"
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="259822141"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 18:32:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="689697725"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga002.fm.intel.com with ESMTP; 20 Jun 2022 18:32:33 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 20 Jun 2022 18:32:33 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 20 Jun 2022 18:32:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 20 Jun 2022 18:32:32 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 20 Jun 2022 18:32:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6sw6grmSF0iwghoTYIOx5rxpSqj+S6ltc8rwY/ctM1yvamLs1gHQrxLI6T53VFuAwO9roT1Rwoq0ZC/uT7BpGnSYb4QUHekUNyfaAU4yLCqKz/juMVUVuc28kL/oeHpeRsshWl74ieuNS29+83UcTeBEA4F6PO08ZZ2rS82Lh+Fs6i0RsM3dLCa956GrZoF+I8X2Sb25Gu3mQKFnIFc/C1bj9O7csHBGpdSbhDqOk18WXv0TSg7yAZZZ48pu//N63EkbFusvJcZ4PoWN20MpeWGTw6S85eXGINzxU+HAdp7mUoaIb7CSFYVK7/xztr/o9iFSrWZE2d8kklzlUArwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ksVRSQG626YonvMjw6dQk3LuQgCh2Ji1HeeIAu83DuE=;
 b=KGh88cSYdANNH/S51dimaZgx69AdwEpNxk/ouPpZ4jKm5sBzx7vVTG9ce3icEmsH0P6vsV/LD8IM1lGKUO4RBclgMEN3QCECmQ/zWoRP1it7RHYDSMbxYr/d3biT6AiwsuQOomOiBd/G3a3vvPkjhgmmnsejHkVCvMmDj6SDxI0cyRsPfCB2tPdkq2r1TCvn9jeyTlQi3xsU+9e38xxsk/VDy1Sbxz7918Z0fs9TCGsqXXjEdYWUgVYmSYwmMRDTP8eYcPzDCxg/aj2Ax5DvEQa75UBrQE4zFnhQFz6V9pQTiWQTqYvpb35RopAZrTn5VZG3+n71qLfQAfqEO9fzSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by CY4PR11MB1815.namprd11.prod.outlook.com (2603:10b6:903:125::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Tue, 21 Jun
 2022 01:32:30 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::10cf:116a:e4c:f0f5]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::10cf:116a:e4c:f0f5%7]) with mapi id 15.20.5353.021; Tue, 21 Jun 2022
 01:32:30 +0000
Message-ID: <39235b19-53e3-315a-b651-c4de4a31c508@intel.com>
Date:   Tue, 21 Jun 2022 09:31:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [Patch 1/1] vfio: Move "device->open_count--" out of group_rwsem
 in vfio_device_open()
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        <alex.williamson@redhat.com>
CC:     <kevin.tian@intel.com>, <kvm@vger.kernel.org>, <jgg@nvidia.com>
References: <20220620085459.200015-1-yi.l.liu@intel.com>
 <20220620085459.200015-2-yi.l.liu@intel.com>
 <98a0b35a-ff5d-419b-1eba-af6c565de244@linux.ibm.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <98a0b35a-ff5d-419b-1eba-af6c565de244@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR18CA0003.namprd18.prod.outlook.com
 (2603:10b6:208:23c::8) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83742aae-dd2e-40e5-35ff-08da5325e872
X-MS-TrafficTypeDiagnostic: CY4PR11MB1815:EE_
X-Microsoft-Antispam-PRVS: <CY4PR11MB1815E699C5CF62D33CEE6239C3B39@CY4PR11MB1815.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3t50/WNJo/zQ8n1n1XS1UhVm5G1GPW2sP/JNEmn3FEuO74SwZYuzmk4EYYXUmtrv0NHBsuNzKrB80JSp4afI5/dAnUXmngEAZRUHNa5sA2q1WMuozsghKULhnF2h1RdNadkbAEEjHK6nAytfMbUFPjIvx88qIxYcwmObx+dJAdd97Mb/vpX3w2I6qsd86lro6eUpgOKUI4B4iCU22jx3PB2Z3R25Sf1k8EU9UVLWIniy/ayfUvR0BbpU4PAFLRPwP9vR2zobnSWIa5tTCcFXrTkyTjy3SrY4L/2DFw7j529nm/l1rS6Jyvz7ML8PJGNDt/HBagYAnqlLd2oyqUE8qPiwNR3IyTlES05dUApVpYLM14dXvb+YQGUAdS5TwVIXHTyDyutLCIxUbPHadHXaCn6QYkjms5ZegWQj/lcbicI11zsjDzpailIxOWJ1FZT4ktivKYwDReldMjD5CiOD1eCQz1NUT0/kE+A/qboF2TAh8+igHg30QRQ9w7bG6HV9l1e3YpNZoCdeidOuqJcJKk5igzyssh4tCfTLpES0uWfjYWGbrIFZ0+f79tUSyuVXgxGBvzk9GoTxNvW25MZQwvZkppaQ2j1+Mh3O9b4ukgQiiX8GE6pOQ+y1K0r3p3nXGhnC69YUK277Nj9RQrD3eWZSWHLtPvOwHaxuPMA5vQ1XF2dpTU0W9NAW9LUKXnxa09WckON6icDGybXCCDcqSAeL+YiXaDD11AJGnbbW9ks=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(136003)(376002)(396003)(39860400002)(8936002)(66946007)(2906002)(4326008)(6666004)(66476007)(6506007)(66556008)(8676002)(31696002)(5660300002)(6486002)(86362001)(478600001)(36756003)(26005)(53546011)(316002)(31686004)(6512007)(41300700001)(186003)(83380400001)(2616005)(38100700002)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NU8yK0hCc3d5dUNqazE5aWY0aU1GdUY5aUNadEJIZzBSQk1RNHZHeThqWE1F?=
 =?utf-8?B?ejk3bFM3VEtCdUdPZmJaazNZWkE3ZFpRWHFsVHNZUno0dXRqMkVQTEo4OTBk?=
 =?utf-8?B?eExlRElwWlBpajZOajdlcXhPSC9wOTk0TGFHelZZeEt4b1M0VE9ETHJ4MUxt?=
 =?utf-8?B?ekdINldyU1E5dUptN3lWRGZvUzlrYTd0S0Zzam9la1E1R1R1OGsyTUp6bXFK?=
 =?utf-8?B?aDlDVGliRTFPT1hqS1FzMEdHRjFlbHV2VWdERUwreHdzN2JXcnY4YXBlcENx?=
 =?utf-8?B?Y2M2UVAzWEJ6VWwzRHEyaVZtMXllbGhoOVorbllwR2dFeEFTdVZaMC9ab3dF?=
 =?utf-8?B?VEpiTTlSN00vMXFIZUloUTV6TlBTOFYwNEFwNExBZlZ6QkEzYWZCcVpDZjZS?=
 =?utf-8?B?S0hIWTFjMnh5T1NkWlE4OXdjQ2hCeW9pL3ZuQU9SajltN3N0MmVTMkJ2eWJR?=
 =?utf-8?B?bUREdTBLMnl1Y1hZWlFDWCtOd2ViRW1WbzEydGVBMllZRVMyaTFJZDNXenRy?=
 =?utf-8?B?cGtvR25VcVZlR1c5NEV3amlTeERDSlFsdVJ0alh6YTdISTRadUdmcDNJbitn?=
 =?utf-8?B?RG96VGNySTJZdkR1OUxJUm5Bd2RyekRIQjQzalowbE9KQkNxN1ZSWHFxT2tU?=
 =?utf-8?B?bFdkV3FRR1RMbSs5RHdHd2RNcCtGOXVMN3JPdW9GRnZPWXI5RG1IYXdyMlpx?=
 =?utf-8?B?d2QrekNOMHpaK0NhYzZwS2dVZW94SDdJU1p0UUtINDN1bnMrZkxYOWY3emFq?=
 =?utf-8?B?cnVrLzR4RitWVmpuNlcvSzUrNEUzR3VSRjA3TGhIdW9rVlFFTC9TWU12ZmZZ?=
 =?utf-8?B?S094VnczTDBZZVhmVDdyWHFEZGZ1WWpWNnR5MlZDaE5IRURoMGFucmw2cW9X?=
 =?utf-8?B?WjVUdTVGU1BHODcycytqeDlwK0xteTNxZjhBL3p3d2VUb0VaMjI0RU1uS2l5?=
 =?utf-8?B?dVU3SWpoVFU2b3lJQ3RnaERFSUpsTWVwTzJmemVTMlZXbm1TdkNnajZUcEl4?=
 =?utf-8?B?V3pWUzVJNnNyWGtHaVczQTRUeEIzTU1nbm95MTZhKzhLeUNrNkh4Nmo1c0lw?=
 =?utf-8?B?U0s3RmpxTGtrNW1SYTZtMUhUZWdkVXloTXRKL2V2MjhtRitJK1NrUWR2NXJx?=
 =?utf-8?B?RVU1UTZoYVlMNTVHUThPK3llYlVmOWJQMVFuUEF0ZTZtMlh3QTlkSGdIdzRQ?=
 =?utf-8?B?WURTNGNPa3E3SWUzUHJ0amsxRUFLYktIREh0NG1EL1IzTjZpR0ViMkRyUStp?=
 =?utf-8?B?NEdZc2hUSGRuTWdRa1E5QkF6RkNsOVNNaHhXR0lTS2xERDBjdG1XQlk3TzN3?=
 =?utf-8?B?bis5ZGszZFUzRmtkOGtMWEtNendDaTdiY0YxRXFmVVNQSmRIRUxWWXMrcTgx?=
 =?utf-8?B?WldxK3BGMVdFb1lDVjRCd2hHYVh5TVJKWjJiWjBnazhZMjV6YnZTZ3V3QTRj?=
 =?utf-8?B?ZkxWajFjM2JJYmN2eXp1ZmNpdmFCdGtrNFh4Um03TkY0cDNRWkc1VzZiMmVu?=
 =?utf-8?B?cW4yd3A0elVlOG1Mcm1WNVFjNTFvYk02Y0kxTG96b0JBcGlpaDJRbkN0bU5S?=
 =?utf-8?B?VGFuNGdLbjl3ZGV6V2tHQ1dud3RYaDZ0WnVUQ2pIUHpGRlJudG0vU3VBcXhB?=
 =?utf-8?B?VndBeTVlN3pUNUY0NDhoR2JhcmwwMXRvUUJDQU1FM1pUMWt3T1JjeDRZUnNy?=
 =?utf-8?B?NytiUlFZWkNoTkIvUllMVkF0Zzc3MU1jaVlBZzMzdEcxV3JYZ09oZFZYQjVm?=
 =?utf-8?B?VHdjdG85OXBVZnJsNmk2bkN0MUQ2YkVremdDaVorb2MxbUVXaFY5K3J5QXhv?=
 =?utf-8?B?c2VVWG1Ubm4zYjJHNUxQc29rYXdIUUltUjlON2pKblRhai81YUxTWS9XTjVr?=
 =?utf-8?B?cXV1N2tDcy9WMllmRkNkenVYYThNRmF4QU5WTG1lajI3WFFHd25NRk45U0Vk?=
 =?utf-8?B?d3drNXQ1d2U0dXZ1NnVZQldpd2ZtUE8xbGp1SEQrMmkyY0lpYUVZR2pnYXZ6?=
 =?utf-8?B?clk3VlNsY01IUzdoSDFFYlc3YXpnSEtVQjVBVHI1SEtpUzJwZFQwWFJJT3kx?=
 =?utf-8?B?VzZFRUVybENaOFdBWVk4NkRzWWYxNWVCQ2NlQWlBc2NzTkc1SmZhYTJnUVZn?=
 =?utf-8?B?Tmc5MktOQ2JKTmIyVWYxc0hpbVQwcU16czJ5Q3ROZERmU0xQMUxXVXFDRUta?=
 =?utf-8?B?RXBpVzBwbUcwV2JBLzhick1aV3hnTjBBUmVFbWp0KzhLMWdZMUdBY05NaDNm?=
 =?utf-8?B?NHMwVFMwYms1cnNSS05jaXhBZVduOWIrbWhUaVE2K3hTU1lpRElBazJ6Rlhh?=
 =?utf-8?B?YTVKd25YOVNSMmI1VW4xOHdFb0ticXBJVVBNaTB3WGpranNOMmw3dz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 83742aae-dd2e-40e5-35ff-08da5325e872
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 01:32:30.6757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uIQYUb+CDa3bI0uz0MazQsNuQTpodNVCg0fyKgzZpt/r0aC/x4OfG2xe6L94YZaoUMX0s3J73HGRUX0LZ1wTaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1815
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/6/21 04:13, Matthew Rosato wrote:
> On 6/20/22 4:54 AM, Yi Liu wrote:
>> No need to protect open_count with group_rwsem
>>
>> Fixes: 421cfe6596f6 ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM")
>>
>> cc: Matthew Rosato <mjrosato@linux.ibm.com>
>> cc: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> 
> Seems pretty harmless as-is, but you are correct group_rwsem can be dropped 
> earlier; we do not protect the count with group_rwsem elsewhere (see 
> vfio_device_fops_release as a comparison, where we already drop group_rwsem 
> before open_count--)

yes. this is exactly how I found it. Normally, I compare the err handling 
path with the release function to see if they are aligned. :-)

> FWIW, this change now also drops group_rswem before setting device->kvm = 
> NULL, but that's also OK (again, just like vfio_device_fops_release) -- 
> While the setting of device->kvm before open_device is technically done 
> while holding the group_rwsem, this is done to protect the group kvm value 
> we are copying from, and we should not be relying on that to protect the 
> contents of device->kvm; instead we assume this value will not change until 
> after the device is closed and while under the dev_set->lock.

yes. set device->kvm to be NULL has no need to hold group_rwsem. BTW. I
also doubt whether the device->ops->open_device(device) and 
device->ops->close_device(device) should be protected by group_rwsem or
not. seems not, right? group_rwsem protects the fields under vfio_group.
For the open_device/close_device() device->dev_set->lock is enough. Maybe
another nit fix.

> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> 
>> ---
>>   drivers/vfio/vfio.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
>> index 61e71c1154be..44c3bf8023ac 100644
>> --- a/drivers/vfio/vfio.c
>> +++ b/drivers/vfio/vfio.c
>> @@ -1146,10 +1146,10 @@ static struct file *vfio_device_open(struct 
>> vfio_device *device)
>>       if (device->open_count == 1 && device->ops->close_device)
>>           device->ops->close_device(device);
>>   err_undo_count:
>> +    up_read(&device->group->group_rwsem);
>>       device->open_count--;
>>       if (device->open_count == 0 && device->kvm)
>>           device->kvm = NULL;
>> -    up_read(&device->group->group_rwsem);
>>       mutex_unlock(&device->dev_set->lock);
>>       module_put(device->dev->driver->owner);
>>   err_unassign_container:
> 

-- 
Regards,
Yi Liu
