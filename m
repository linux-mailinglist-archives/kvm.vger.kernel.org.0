Return-Path: <kvm+bounces-3072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2331800587
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 09:28:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0C5F1C20FE8
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 08:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DF361C297;
	Fri,  1 Dec 2023 08:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m1irM3Ns"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44363170F;
	Fri,  1 Dec 2023 00:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701419306; x=1732955306;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R41JfhKfnUE+8HPwe/KqQZtXm42KgqqrbM5hx9xGJ0I=;
  b=m1irM3NsY/9mzyupaXGFgSh2uajo2h1hFbwANbQZCuvnZh5Few0npvof
   8/twmCMZzgdeaWsFahWASHl9tmEwJZIGgBv9yarL7UamtV5s4pHCzGikt
   9ETj101sisX56a+TIVobZLK8Tv0GiWPa5JhDkDTTp5GEEuh0Civl3rb1e
   P86X8JX0Wzr6fp5xrA3H3yZvCO6CnUjv3/mjoU0p42Nr1N8NdAtq34fHr
   VG7bLFaqLTxrEmxTrXdxkmkkR+UzJT5QvPqadpDXbj9TyTP/swX1qffvg
   nNX+XtkAr71rM8i1Ezeip3tR3JuhiVnea2411EphgIqtknn00Wt04BODe
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="390625346"
X-IronPort-AV: E=Sophos;i="6.04,241,1695711600"; 
   d="scan'208";a="390625346"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2023 00:28:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="913510648"
X-IronPort-AV: E=Sophos;i="6.04,241,1695711600"; 
   d="scan'208";a="913510648"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Dec 2023 00:28:13 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 1 Dec 2023 00:28:13 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 1 Dec 2023 00:28:12 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Fri, 1 Dec 2023 00:28:12 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Fri, 1 Dec 2023 00:28:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=csP0xfnKef4qtmU6g1DPAHEdARsKpJ2oBvk8O6AkhbMB4iAoxlR/Du/v6pqfbw5smCVtkyQ6ml+uoGe+UFac5uatrYU10zbCpsHOwp+SbG4fbj0tp5qZvTKdu/J1jSgYBYZcgvv5W+GJF6XzvL+c3m4+FSPZyD9I9YA7DjRsyXfkft2aMEznVXIWGZZtstknjesf55lBnslLdbiURd7/J93ZS348hAadVBDKtIEQdI35fc9HT6b53ClkKJvGKuvYyWFnkwEJz2phIBwbqTB/Q0BfqNlVY6WijMMTVqfVfroezrBkPWXG1vq4iOJ2CtK6XlpenprBpC030rTqLlC3hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i2ae9uuxPGBqif05BusAjNaKfBCnh1aYY7UJpQ23Cb0=;
 b=OPevJIIFbNQyQbc3KGnQEJTF0EerzTowSmkkqP/RTossYJH4y6gt7vzQRE49x+RiF0cDZ4bjuPLY85zZIsUa4IniVO6PaGHCi2AzBXPxzA2rGt6bSUg/QjkLSc33i8nL56LGFb0WvGKT5pF9qkL8U1XucgIjpdd1R5NPoCPQJt5iM8qwfh3uRUYi6ber8Wbjs8eEk9C+q0IHGN6hmayGd8eEJ9n66008rOkzmThMZ21ed744BAGFci8v8d11drd+yqJUJpEjPchAPA0MYlM2D6UDZ8cF6fNsCrLBVzyAPDwZOjR1whoyh3AXttN59eavWwvEYY99RmvmesdYolB68Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA0PR11MB7838.namprd11.prod.outlook.com (2603:10b6:208:402::12)
 by DM4PR11MB5517.namprd11.prod.outlook.com (2603:10b6:5:388::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Fri, 1 Dec
 2023 08:28:10 +0000
Received: from IA0PR11MB7838.namprd11.prod.outlook.com
 ([fe80::cbb6:48f6:d69d:f657]) by IA0PR11MB7838.namprd11.prod.outlook.com
 ([fe80::cbb6:48f6:d69d:f657%5]) with mapi id 15.20.7046.023; Fri, 1 Dec 2023
 08:28:10 +0000
Message-ID: <5a1e2856-5469-4bea-9685-1bbbc3e06b46@intel.com>
Date: Fri, 1 Dec 2023 16:27:49 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH iwl-next v4 05/12] ice: Log virtual channel messages in PF
To: Simon Horman <horms@kernel.org>
CC: <intel-wired-lan@lists.osuosl.org>, <kvm@vger.kernel.org>,
	<netdev@vger.kernel.org>, <lingyu.liu@intel.com>, <kevin.tian@intel.com>,
	<madhu.chittim@intel.com>, <sridhar.samudrala@intel.com>,
	<alex.williamson@redhat.com>, <jgg@nvidia.com>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <brett.creeley@amd.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>
References: <20231121025111.257597-1-yahui.cao@intel.com>
 <20231121025111.257597-6-yahui.cao@intel.com>
 <20231129171222.GF43811@kernel.org>
Content-Language: en-US
From: "Cao, Yahui" <yahui.cao@intel.com>
In-Reply-To: <20231129171222.GF43811@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0024.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::13) To IA0PR11MB7838.namprd11.prod.outlook.com
 (2603:10b6:208:402::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR11MB7838:EE_|DM4PR11MB5517:EE_
X-MS-Office365-Filtering-Correlation-Id: 88fe80b3-8a5f-4ba5-fadb-08dbf247739f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dLYWD2dXiz/mMYf+lO9nQ6yoD2MmMQykBVmSPd2UvR3VUPfJ/WESK+3at9rHGsjQrqZdM3qiXq0HmUA4/ewxr1JPcztvJuclgUNYz7BaDgHNb8jWmxv9NWJWl6+ajkDaP/JBt425cKT2HG9z7NvfTDtWPDnsnfgzc4P5tMzWGMrwGuESnH75fcQPNmYdHPRp+Fh3M53j5EYBE/cX3st6QB+LsgmUdmr6XeLg/cYi8ah4VyVgzrwYBRKhtOpCmn+w22Qwvgcr8npqNu4uHCgCuBHAurcUrL1KsS6Y+g3UVsRtTeef4xcD7h+m39rlf0Di8ijqezNw3juTpUKMPQEhiZ9IoPO9H6eiDsT8ZgbfcgJFiiza4zV5TUbM/LIMjHvwcIoUgFkCKr2COQPuLkNL5gi41C1TGfd+NoOW1L5H22LE5lSdfQV7HIdbrSidrTy27B0RtnmOjeFqpC3Ek9z7Mckcu6CMT7Sa7FShBLu28c4m0q57PmIT8B2IYcAntP1INJkPFYWcdInTzYUl2XCGAYqC09rhjcanSZewvGqJHTscPCc+IpOEE8u+B+fM2mXpAkzaVwC1za7WpgJDTyo6fNtX38s4FmJA1zSRcYJMHbCBSd7ep/J3wwo8d2qmpRNZdzEe1VLixhh/zBBp6vbISg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR11MB7838.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(39860400002)(136003)(366004)(396003)(230922051799003)(186009)(1800799012)(451199024)(64100799003)(31686004)(26005)(82960400001)(83380400001)(2616005)(6512007)(6666004)(38100700002)(53546011)(6506007)(478600001)(6486002)(8676002)(4326008)(8936002)(6916009)(66476007)(66556008)(316002)(66946007)(31696002)(36756003)(86362001)(7416002)(5660300002)(15650500001)(41300700001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmxDbVhWZTZFREFyZXZvYUpFTGs4dGZyUXFFRFFVSGlxbENLN1FZTnNmMWlt?=
 =?utf-8?B?QmlnZkYyaUtFeG8wbHQwQTVzSi8rVDhIeGNzWGJWTHRNeS9YNW1PUEp2VXJO?=
 =?utf-8?B?aWl2bGFybmxOL3pqU2tlWGdqNG1jVDdyUmltWFdqNENVWnBIOWZnblU1Q3BT?=
 =?utf-8?B?ZmdkUGFveFZTOTJtcThrNGd2VFRGdTJ3SWd0OHkvYlRsRk1CRjJtZkFmSjhq?=
 =?utf-8?B?Qjh5OSs0S1lraTN4STU5a2FtRWxkbUZtclFFQU9Uek8yVmtLRmlpMDhCU1l3?=
 =?utf-8?B?cHZCSnJLNC9zQmxkZkJXQUp5RWk2Rjkrb2h1dlhTSFYrUTZ4dzhmN2lIOC9F?=
 =?utf-8?B?RkJJSHNWaWQ2RzRqa0dkdzdKamg4R21QTHFTenRNM2YrcWdVNDMwM09sQ2Ns?=
 =?utf-8?B?Um1EbEExcVRDREpkQStqRE01Y3RORzR5bERPamhRbFRIdXgrQ29XZlJrdmxG?=
 =?utf-8?B?aDVyOSttWEJBVDlmejJxZ1MwVjc4Rk5IZDBPb2xNTlUwRFo2d0JMbTg1T0F5?=
 =?utf-8?B?RldYdnVHR2Jybk13OUgyNTkzMENWVFg3REtFSzNaUlBDeXNmRzBpbjBGRHdJ?=
 =?utf-8?B?RDVqeXRHOCtwYWgrRHVraUNOeDdoR3RnZDdqR0pGWlZmQWplK3k2WGl5US9S?=
 =?utf-8?B?UVhkS2ZnRVo1dW0vekI5N2tRWWxrVUNPTXZCcEMydVNEUUJoK0JiYUJuZ1lN?=
 =?utf-8?B?bVJvYVdZVTBhRW94MEhmZzI0ekozODJRY2x2MzRUTHhGQjlKeHV5dkg1czRh?=
 =?utf-8?B?VUJncWtHdVNXTWl0RDlGa241Q3RjeW03L29BTXA4elA4TjUrSkJZZ2pVUk1w?=
 =?utf-8?B?ZlU3NENVSGZScisxbjFvczNzSzRGVFNMR2xjTzNWcWdoVzg5MU9HYlE5WGo1?=
 =?utf-8?B?cW1haW1MaGNrUlhEVkl4RVN1Wk0wY1VBU3E0NlNnNlVlMkRlRU02MU81KzAz?=
 =?utf-8?B?UzhhWGtlM3pjcitZNFpncUNkWXltdkNmNlRLNkFvOUNxWVIzcE5NNlMzYWwv?=
 =?utf-8?B?S0xBbitmb2FlQVBxNlczdWE5TldFTGZtNllTZGV1SWU4dUpDb29jV0pRYnR6?=
 =?utf-8?B?azMyRm1IelhuTS9MNU14T0VTNWlZeHBudE5JMlJtUlR5ZXYzNXlHUTczWk5Q?=
 =?utf-8?B?OGgxWG9uMkp4SGQzUENVZHlGMmRMMXZ5U2t0L1Rzc1ZtZUo3Zm9jOWFzb2o1?=
 =?utf-8?B?ajFuSHdRSmhEaGhFdHdmenhESlhSUE1LS293U0ZnVmZoZ2NTOTM0cHF4Ymhv?=
 =?utf-8?B?NDRlWHRwa3hycU1ReHczSW5BUlozVGUzWkJnMEVFdmxRS09WTlUyQkdtaUtZ?=
 =?utf-8?B?UzBRN2Q3dFpWMThwM1FNVmlkbzREbjZaZmV6NUlCbW9TakpQL0xGbXJkd1Q1?=
 =?utf-8?B?K2Jtd0pDVzY0a09Sckg4eUJDbWN5cW9FakNNVi9zQWI5bDVVbEVFRDhVTXls?=
 =?utf-8?B?OVhXeGVQQjhwalJTeDg0MHhqWitJOG1seklmclA3MmlOZmxQMDhINmZYbjZN?=
 =?utf-8?B?RWZmTSszMUQxRnF1eWFWSWp4cUpOYnVzRlgvK0JJd281NlVMd0xjallJcjA4?=
 =?utf-8?B?VU5IcGYxRXZ1OTJ6dHNtbHlZY1RYVWJpcGI3WThBdnBKMVNrK2pqcUlZQkg0?=
 =?utf-8?B?QzI2MHdjWTFEOWtQQ3YwTnFGM1FidTBka01wQWw4UVlKa3VvTDZ6eEE4MExi?=
 =?utf-8?B?bDZnQ3A2UG05NGVDNTdHK3oybWVrOGhkdmpQTlZSRnlMTDg1SndMbWtYUzhl?=
 =?utf-8?B?VXFIRGx3VEJzTndSUVo1TkRicjVrNnNoZGtVOTZFNmRWUTVQUE5ia250YTQw?=
 =?utf-8?B?TlMxaTBKQ1M0VGpVZ1hKcG1zRUg2N3JVUGlrSEY4R2xjbXA1S2huYk41ZWs2?=
 =?utf-8?B?T01GMlVjSlNaNUpaM3Y3eTBZTWVzOHZBT29pcGZTZG5tWTNMY2VvWnh6eDE4?=
 =?utf-8?B?dk51ay85bGpCRThwQkgvVlBEeWNaL3YxWE5uMStJVmJucHlxWTNqOE40WWxk?=
 =?utf-8?B?OFVwUkVhbDByNkNsZ0twOUc3QW92ei9heHIxQjBvYXhCVGRnWFJHcFlNd0tX?=
 =?utf-8?B?NkQ2ZWJFcVpINmFxdXZyb1ZpQUVxTnhQYkE1bDVtTVBGWHVjbEZQdDhRSHB0?=
 =?utf-8?Q?ONqWpFExHA8xmJnnb2le9cpkW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 88fe80b3-8a5f-4ba5-fadb-08dbf247739f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR11MB7838.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 08:28:10.2773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eViJDah9n7le6E8kKfpI6lggbIVc1fHhPAUsTLxrcY/XMNqmo6awUFzO0C/RvjnyrflyaViv8dXpePz7M/+oCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5517
X-OriginatorOrg: intel.com



On 11/30/2023 1:12 AM, Simon Horman wrote:
> On Tue, Nov 21, 2023 at 02:51:04AM +0000, Yahui Cao wrote:
>> From: Lingyu Liu <lingyu.liu@intel.com>
>>
>> Save the virtual channel messages sent by VF on the source side during
>> runtime. The logged virtchnl messages will be transferred and loaded
>> into the device on the destination side during the device resume stage.
>>
>> For the feature which can not be migrated yet, it must be disabled or
>> blocked to prevent from being abused by VF. Otherwise, it may introduce
>> functional and security issue. Mask unsupported VF capability flags in
>> the VF-PF negotiaion stage.
>>
>> Signed-off-by: Lingyu Liu <lingyu.liu@intel.com>
>> Signed-off-by: Yahui Cao <yahui.cao@intel.com>
> 
> Hi Lingyu Liu and Yahui Cao,
> 
> some minor feedback from my side.
> 
> ...
> 
>> diff --git a/drivers/net/ethernet/intel/ice/ice_migration.c b/drivers/net/ethernet/intel/ice/ice_migration.c
> 
> ...
> 
>> +/**
>> + * ice_migration_log_vf_msg - Log request message from VF
>> + * @vf: pointer to the VF structure
>> + * @event: pointer to the AQ event
>> + *
>> + * Log VF message for later device state loading during live migration
>> + *
>> + * Return 0 for success, negative for error
>> + */
>> +int ice_migration_log_vf_msg(struct ice_vf *vf,
>> +			     struct ice_rq_event_info *event)
>> +{
>> +	struct ice_migration_virtchnl_msg_listnode *msg_listnode;
>> +	u32 v_opcode = le32_to_cpu(event->desc.cookie_high);
>> +	struct device *dev = ice_pf_to_dev(vf->pf);
>> +	u16 msglen = event->msg_len;
>> +	u8 *msg = event->msg_buf;
>> +
>> +	if (!ice_migration_is_loggable_msg(v_opcode))
>> +		return 0;
>> +
>> +	if (vf->virtchnl_msg_num >= VIRTCHNL_MSG_MAX) {
>> +		dev_warn(dev, "VF %d has maximum number virtual channel commands\n",
>> +			 vf->vf_id);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	msg_listnode = (struct ice_migration_virtchnl_msg_listnode *)
>> +			kzalloc(struct_size(msg_listnode,
>> +					    msg_slot.msg_buffer,
>> +					    msglen),
>> +				GFP_KERNEL);
> 
> nit: there is no need to cast the void * pointer returned by kzalloc().
> 
> Flagged by Coccinelle.

Sure. Will fix in next version.

> 
>> +	if (!msg_listnode) {
>> +		dev_err(dev, "VF %d failed to allocate memory for msg listnode\n",
>> +			vf->vf_id);
>> +		return -ENOMEM;
>> +	}
>> +	dev_dbg(dev, "VF %d save virtual channel command, op code: %d, len: %d\n",
>> +		vf->vf_id, v_opcode, msglen);
>> +	msg_listnode->msg_slot.opcode = v_opcode;
>> +	msg_listnode->msg_slot.msg_len = msglen;
>> +	memcpy(msg_listnode->msg_slot.msg_buffer, msg, msglen);
>> +	list_add_tail(&msg_listnode->node, &vf->virtchnl_msg_list);
>> +	vf->virtchnl_msg_num++;
>> +	vf->virtchnl_msg_size += struct_size(&msg_listnode->msg_slot,
>> +					     msg_buffer,
>> +					     msglen);
>> +	return 0;
>> +}
>> +
>> +/**
>> + * ice_migration_unlog_vf_msg - revert logged message
>> + * @vf: pointer to the VF structure
>> + * @v_opcode: virtchnl message operation code
>> + *
>> + * Remove the last virtual channel message logged before.
>> + */
>> +void ice_migration_unlog_vf_msg(struct ice_vf *vf, u32 v_opcode)
>> +{
>> +	struct ice_migration_virtchnl_msg_listnode *msg_listnode;
>> +
>> +	if (!ice_migration_is_loggable_msg(v_opcode))
>> +		return;
>> +
>> +	if (WARN_ON_ONCE(list_empty(&vf->virtchnl_msg_list)))
>> +		return;
>> +
>> +	msg_listnode =
>> +		list_last_entry(&vf->virtchnl_msg_list,
>> +				struct ice_migration_virtchnl_msg_listnode,
>> +				node);
>> +	if (WARN_ON_ONCE(msg_listnode->msg_slot.opcode != v_opcode))
>> +		return;
>> +
>> +	list_del(&msg_listnode->node);
>> +	kfree(msg_listnode);
> 
> msg_listnode is freed on the line above,
> but dereferenced in the usage of struct_size() below.
> 
> As flagged by Smatch and Coccinelle.
>  >> +	vf->virtchnl_msg_num--;
>> +	vf->virtchnl_msg_size -= struct_size(&msg_listnode->msg_slot,
>> +					     msg_buffer,
>> +					     msg_listnode->msg_slot.msg_len);
>> +}
> 
> ...
> 

Good catch :) Will fix in next version

Thanks.
Yahui.

