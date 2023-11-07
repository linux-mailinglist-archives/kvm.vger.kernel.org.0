Return-Path: <kvm+bounces-1063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C339E7E4963
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 20:48:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70B9B2813C5
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 19:48:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C6C836B07;
	Tue,  7 Nov 2023 19:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cbOrU83p"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97ACB36AFE
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 19:48:40 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BCC184;
	Tue,  7 Nov 2023 11:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699386520; x=1730922520;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ItggVrhJQj7rQu1ehQb68+Z1aS8tsFO/hUqmrh07L/k=;
  b=cbOrU83pDRhbWlm8EanpyHsPwKytGq71jhnNI2EPOsO2hpWTxq7KWea4
   kRlrLseBy2R/O4YWGS0zXxMLaMgPB6JBqCjZEZ2B6bOXHDjEIs/xtDBuB
   i1E4Zh61urElrw8wdObsS/BZveJ//VFq2YVmfIgf2yWc7qJ9GcCqyl/tv
   sHnczqfhwlis7k6knGbaQTadQVe1oEantbTN/Ualbz8ZPgvC7XYE4aA5q
   zpEKaAIELIlYjIqvaAPvKccbofmcNKvzxQaLEUhlvmgULRmSAldqR9ozo
   9021rJpXOYHHeyi2ptIJzxNsZfCjVmj/ZRM/5ceKpPk3VsgRfaeDaNQmX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2619543"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2619543"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 11:48:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10541781"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Nov 2023 11:48:40 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 7 Nov 2023 11:48:38 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 7 Nov 2023 11:48:38 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 7 Nov 2023 11:48:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YdQlHbp3z9RxOsbYr1jWWaUP3mL67diIMeBPULMpMdq8wcBGNvaDk/Ak+SGe6Xxmu3eCIRnQlOoi6H95gKNdNreQpetLJxauOL9KC/ZQvc55zKI1BWHhDRw8a0tlqpZOgiH4YLRNld+p3UxoykGVZgv21yfUW95n3OzJBkyFaT88yL9wAjDcDEnNxvNOcs8R+zQnlHlJGeEheiS/akZIIh9POSPlH/8BHokf+MLdtTlLHDoYiIO3a2oIykd5nLyu1f6MmeON/xjzTtnpXO4GDMAl96PyWJNYKfEH2eimMA6Ja9nbbj9zef4RJeGKmmaH8F4+ReL87kSjoQfuN8HSfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RMqFrEUhG8nxh0FVirlRAEmFvuRFlGGz+xg0C3WAmYk=;
 b=Jk30k9LhvwsyPZK/2vH1xqtIEk4DzgDY1rxV+AK20Y4vrevvMvcVy1iPxoxo2dE7H8OV3Zw1UdFnlQGlJQqItKCQ7T2KHxvrG6PA3PJm1xYI2magFZdVGKDpIepyXUKFoC2Rz9Iwe8ucjWUNRLvkuOsSFUwKpU5QCqs7kLgMtP4epH1v43Up3+IrHMVZlWgk+ApALI0OQx/JPmV/np256Xhl+EIpYttBPY39BQ3/Ji83okCEKHir57rg8AzYrALNFZc5EYv6eONgc41+XkHxE970eygT9zL1y6A3TG1CPRPXdWisXILFba9cLf3iyULFi7wB30AnpEeZqc7ojFja5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH3PR11MB8659.namprd11.prod.outlook.com (2603:10b6:610:1cf::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Tue, 7 Nov
 2023 19:48:31 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::6710:537d:b74:f1e5]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::6710:537d:b74:f1e5%5]) with mapi id 15.20.6954.029; Tue, 7 Nov 2023
 19:48:31 +0000
Message-ID: <7f8b89c7-7ae0-4f2d-9e46-e15a6db7f6d9@intel.com>
Date: Tue, 7 Nov 2023 11:48:28 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH V3 00/26] vfio/pci: Back guest interrupts from
 Interrupt Message Store (IMS)
Content-Language: en-US
To: "Tian, Kevin" <kevin.tian@intel.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, "yishaih@nvidia.com"
	<yishaih@nvidia.com>, "shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>, "Liu, Jing2"
	<jing2.liu@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, "Yu, Fenghua"
	<fenghua.yu@intel.com>, "tom.zanussi@linux.intel.com"
	<tom.zanussi@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <cover.1698422237.git.reinette.chatre@intel.com>
 <BL1PR11MB52710EAB683507AD7FAD6A5B8CA0A@BL1PR11MB5271.namprd11.prod.outlook.com>
 <20231101120714.7763ed35.alex.williamson@redhat.com>
 <BN9PR11MB52769292F138F69D8717BE8D8CA6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231102151352.1731de78.alex.williamson@redhat.com>
 <BN9PR11MB5276BCEA3275EC7203E06FDA8CA5A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231103095119.63aa796f.alex.williamson@redhat.com>
 <BN9PR11MB52765E82CB809DA7C04A3EF18CA9A@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <BN9PR11MB52765E82CB809DA7C04A3EF18CA9A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0359.namprd04.prod.outlook.com
 (2603:10b6:303:8a::34) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH3PR11MB8659:EE_
X-MS-Office365-Filtering-Correlation-Id: 52eac5d5-c7c0-4b2d-28a7-08dbdfca84bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eirrlUOhfED4SGIur7/mv2IDFaejwr6wzcAH5HhooUJE7ej/oe4/bXZOpcq/GaE/D7qYjl/khrW+xIt8E7AETMhRI0qhDv1E9kcDhbfGvkHVaSTi9w3L7NjAQZQvFvsUR0DA16BVO4jZR0sy4B8CXX87XGEVSvQpQeEwWkW5PAUDuW1tQoj3u8qVqpNUrgxeloOE4ILSzOKlnolGqCHy1WpQBYJTZFzv9opXbJfajYTaa9egjYf1AjIaq1I5JYUvPSamK09REth8QEDTeN3vq2syWqzfMLzPgLnI9QCI7MUyadesLIiq58ZYK+YHGoCwiA6UZSMxtTCJzDKcziLK0DQFIul9Aho5PxqJCtDRCB6Fqjh29TAVaHZfiwBQJy5YkRU9rhD85fOccaG+M+mleeYSpJ2G6V++0baBcOwDklpF+qVW8jwngIXmSnXXUYyB30PLsG/mjDXukx+E6gW9yhLhqk8M6eCGP6DWA2I6dcNFLvb5u5nc9TLOcN0M9EWNUHXHpc/XM5VJsKp9Rmi38sKZPFFLWKwa2Qzh3qrZtAcVtGEvmLNG7GZLuDWmBUk+fFXGKXkMeDMT4Yx74kAwkm8OIubqpFAATsdby8vbg9otByIqhsPHiHmufijr46oEws/KkmsjjM+BHMDAE3kgtw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(396003)(366004)(39860400002)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(66899024)(31686004)(6506007)(478600001)(6512007)(53546011)(2616005)(6486002)(6666004)(44832011)(31696002)(36756003)(38100700002)(82960400001)(86362001)(41300700001)(5660300002)(66556008)(316002)(66476007)(2906002)(83380400001)(54906003)(26005)(15650500001)(110136005)(66946007)(8676002)(4326008)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWd2Zm5tWlU4Ny9QZU1UcFIxZTc2OHpOOW1wNEQ5bDZNbjlKRnp6djBPbk8y?=
 =?utf-8?B?MlZqMk0xazlGR0wyRGF3MVFnUDNvUlpNZ3MwQlNPQUgzWXJ6OXZobDJSM2pT?=
 =?utf-8?B?UHlYWWNFZ0ZIR0ZqOWpaREdBclNUUlZwOTJKRjFNNGxIVlMrRWJnQVdDejc2?=
 =?utf-8?B?YWRKTm5VaTFUUDNZWHdkbDhsbkVCZy9KYVM0Y05UMHNsYzZEcDRmRFlWZUdV?=
 =?utf-8?B?ejVVOU9JcEUzMUlIRDF6L3NjTklKd2lwWXhMK0ZCbmhtVE1BTW5HZ3lWZmFJ?=
 =?utf-8?B?eER6QUx5elFReEZmTnhmK0VRUUJTT1FabEo1ZG5CdHNtQXd0WlFvbDBodW9r?=
 =?utf-8?B?aUQzUitqR3M1YjdKWmxTVCsxL1RraHdsTTBIenRuZ09scGpnSmhpeU9iUTRG?=
 =?utf-8?B?Y0dML3ZtTHRwOWhKNElVcVRIU0Q5TVlHV2xxbDhyWHh4T0pWVTZ4YzdDQ2U1?=
 =?utf-8?B?SjE5Nmd0SGpxUkExa2lKUWdKdVhwZ1RzS0UvNUFWSHRIckF0NVpYWUhZK1VE?=
 =?utf-8?B?bkV4aGtTcVFxL1NhZ0dGc25nUFQxUmRtZ0QvUFdYWTB1U1BGTnN1VVVJZDFD?=
 =?utf-8?B?cjR5eGVrME9iTWZnRXJoM25rNU1LVFVZZjdVVnVJcmVGRmtLdHRTMFpzK1Rq?=
 =?utf-8?B?Q1VwREhaSU5tNEhnMVRjLytNcnBJN1dZNVBQS3hna20zMW5MMWhiMVNlSklx?=
 =?utf-8?B?eDRaQjhNWFpmaDBNakhQNVdoa3ZmeGJja3dtTXAzZS9maXpaSTRBbi9Wc0tR?=
 =?utf-8?B?VUtNczVrQ2c4VTFzNkQ2NStKaERUcTdoT0JsQjBqUHBkcEZhNWxsUEVoeDZ1?=
 =?utf-8?B?STVCcmxIdEN2cmZWUXZNb1lPbG16clI1S0xDSTVpZDVZZjJyWHRIaG4vb3J0?=
 =?utf-8?B?bnRESXBkbmtNTjFBNXFvUWptZy84cjNPcTNLa0FJMXhJaEJjUGZSdnhCZHFm?=
 =?utf-8?B?TW04dVF1RmNBQTVrdjN1aU81UnFVOVFhcGpsbE50MHpCN0sxOVA5UmV2N0NG?=
 =?utf-8?B?OEZMUmFHd0JDZzEwMmlvOGNDMjFRS29NSzhQT1FrTWd4aWJQRDZNcldYNVVi?=
 =?utf-8?B?bzJkUmRuRDZNeVVMUGhpN1ZjNmkycGN4MnNGUXh2cTduU3dPVGtQcERDUVN6?=
 =?utf-8?B?a25jRmFvcDNiNHBwQnI4VTNIdTFzQWlrSmIwakZORTFBZnBSNEYxVUNKdkla?=
 =?utf-8?B?VEwvOE9RSXQ4UllEQS9DQjlrQXBUOE1zd0RlQXUxUG5BRHlQQXZxdmRnWnBt?=
 =?utf-8?B?emxOSWFSWDZWV0RFQk9scnFGKy9KZXFGVUJrb01xOFBhVzcvWnNuSE5kdHpL?=
 =?utf-8?B?bVQzRGw5aW4yTEpVemo1V1VSMlJXa2xlMXN2QWczcTQvNTJyM2pGaSs2R1RC?=
 =?utf-8?B?ZUZmWXpxcU02SkVFWjJLOFdFbTBHcGtrZTE3RVJSTzEwd25Oc29uV3cyeXFQ?=
 =?utf-8?B?bFV4RzVDZGNFMDBjMUpMYTV6cVNmdDkvcVBOdDhiL3dBSHYybUsxTjZtY2ZI?=
 =?utf-8?B?WHhUaTJRYXFzQXBKMDNtYkE0dm9xdXFFRWM1NDBKb1ZycjFpaDI5czFFdllS?=
 =?utf-8?B?bVllVzNJV1BhMWhUcVpEMnRpN3FJdit6THBkaXZRNS9NNlR6L1Zzait0NFpG?=
 =?utf-8?B?Z0Z2eldMUzlqWSsvUUw1NzZRYUJJek4wdTFrSW1lM2ZRMkdJTWhEdVRGdnpF?=
 =?utf-8?B?T3RCY0xPUzRtV0trVm5CSnVON1VPdmRhdEdRMUF3NUZZNGk1N1ZOY01RRW96?=
 =?utf-8?B?T0U3c0lINTVxYmZUL3pMSlEyQkdZVjh0OEw3dXluY01uZmNENDhPL2h4SVdP?=
 =?utf-8?B?dGlZblVWdHhBVnFIcHd3MDZ1RThLZk5zVnJJQkZLMWZyVnlnMW9WMHIxWFI1?=
 =?utf-8?B?UWxRTHRSZldsMTdLek1HQnltUUF6Q0IxRFNTeStDZnVGbGs4WjJkd0krNXlu?=
 =?utf-8?B?Q2kwTzFxZkJXdGdEeGZPT2RVcHNLZFRoYVlBeGkzNndUUUxCUlBJUHFIL0dU?=
 =?utf-8?B?bytrUHo5ZDN0UFVNOGpvK1IrVGl2SVhsYWdtZHQydVJuanN4S3FCVENkMDR0?=
 =?utf-8?B?N0lQRUI5NDlGTG5McENoeGFPYUEwWm50YUl5RXBsOGhIaE1LTHpMZjlXRXBF?=
 =?utf-8?B?UXBZSkt0cmFteW94UllXSU5EeFNOdHpBUFIzWDhSOEU1dE1KR0U1REkxN3hk?=
 =?utf-8?B?cGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 52eac5d5-c7c0-4b2d-28a7-08dbdfca84bd
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 19:48:30.8498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +k6Cm2bH0Eu1CLdb/YMLOp42wu1rsVtJ2UWYG5EKHrz9x/qSxIaUuqXmm2F08Oz2xcvUFGS4+OZMR9cRMoz3DPvrtcrS57wHQHt41BScKFk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8659
X-OriginatorOrg: intel.com

Hi Alex and Kevin,

On 11/7/2023 12:29 AM, Tian, Kevin wrote:
>> From: Alex Williamson <alex.williamson@redhat.com>
>> Sent: Friday, November 3, 2023 11:51 PM
>>
>> On Fri, 3 Nov 2023 07:23:13 +0000
>> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>>
>>>> From: Alex Williamson <alex.williamson@redhat.com>
>>>> Sent: Friday, November 3, 2023 5:14 AM
>>>>
>>>> On Thu, 2 Nov 2023 03:14:09 +0000
>>>> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>>>>
>>>>>> From: Tian, Kevin
>>>>>> Sent: Thursday, November 2, 2023 10:52 AM
>>>>>>
>>>>>>>
>>>>>>> Without an in-tree user of this code, we're just chopping up code for
>>>>>>> no real purpose.  There's no reason that a variant driver requiring
>> IMS
>>>>>>> couldn't initially implement their own SET_IRQS ioctl.  Doing that
>>>>>>
>>>>>> this is an interesting idea. We haven't seen a real usage which wants
>>>>>> such MSI emulation on IMS for variant drivers. but if the code is
>>>>>> simple enough to demonstrate the 1st user of IMS it might not be
>>>>>> a bad choice. There are additional trap-emulation required in the
>>>>>> device MMIO bar (mostly copying MSI permission entry which
>> contains
>>>>>> PASID info to the corresponding IMS entry). At a glance that area
>>>>>> is 4k-aligned so should be doable.
>>>>>>
>>>>>
>>>>> misread the spec. the MSI-X permission table which provides
>>>>> auxiliary data to MSI-X table is not 4k-aligned. It sits in the 1st
>>>>> 4k page together with many other registers. emulation of them
>>>>> could be simple with a native read/write handler but not sure
>>>>> whether any of them may sit in a hot path to affect perf due to
>>>>> trap...
>>>>
>>>> I'm not sure if you're referring to a specific device spec or the PCI
>>>> spec, but the PCI spec has long included an implementation note
>>>> suggesting alignment of the MSI-X vector table and pba and separation
>>>> from CSRs, and I see this is now even more strongly worded in the 6.0
>>>> spec.
>>>>
>>>> Note though that for QEMU, these are emulated in the VMM and not
>>>> written through to the device.  The result of writes to the vector
>>>> table in the VMM are translated to vector use/unuse operations, which
>>>> we see at the kernel level through SET_IRQS ioctl calls.  Are you
>>>> expecting to get PASID information written by the guest through the
>>>> emulated vector table?  That would entail something more than a simple
>>>> IMS backend to MSI-X frontend.  Thanks,
>>>>
>>>
>>> I was referring to IDXD device spec. Basically it allows a process to
>>> submit a descriptor which contains a completion interrupt handle.
>>> The handle is the index of a MSI-X entry or IMS entry allocated by
>>> the idxd driver. To mark the association between application and
>>> related handles the driver records the PASID of the application
>>> in an auxiliary structure for MSI-X (called MSI-X permission table)
>>> or directly in the IMS entry. This additional info includes whether
>>> an MSI-X/IMS entry has PASID enabled and if yes what is the PASID
>>> value to be checked against the descriptor.
>>>
>>> As you said virtualizing MSI-X table itself is via SET_IRQS and it's
>>> 4k aligned. Then we also need to capture guest updates to the MSI-X
>>> permission table and copy the PASID information into the
>>> corresponding IMS entry when using the IMS backend. It's MSI-X
>>> permission table not 4k aligned then trapping it will affect adjacent
>>> registers.
>>>
>>> My quick check in idxd spec doesn't reveal an real impact in perf
>>> critical path. Most registers are configuration/control registers
>>> accessed at driver init time and a few interrupt registers related
>>> to errors or administrative purpose.
>>
>> Right, it looks like you'll need to trap writes to the MSI-X
>> Permissions Table via a sparse mmap capability to avoid assumptions
>> whether it lives on the same page as the MSI-X vector table or PBA.
>> Ideally the hardware folks have considered this to avoid any conflict
>> with latency sensitive registers.
>>
>> The variant driver would use this for collecting the meta data relative
>> to the IMS interrupt, but this is all tangential to whether we
>> preemptively slice up vfio-pci-core's SET_IRQS ioctl or the iDXD driver
>> implements its own.
> 
> Agree
> 
>>
>> And just to be clear, I don't expect the iDXD variant driver to go to
>> extraordinary lengths to duplicate the core ioctl, we can certainly
>> refactor and export things where it makes sense, but I think it likely
>> makes more sense for the variant driver to implement the shell of the
>> ioctl rather than trying to multiplex the entire core ioctl with an ops
>> structure that's so intimately tied to the core implementation and
>> focused only on the MSI-X code paths.  Thanks,
>>
> 
> btw I'll let Reinette to decide whether she wants to implement such
> a variant driver or waits until idxd siov driver is ready to demonstrate
> the usage. One concern with the variant driver approach is lacking
> of a real-world usage (e.g. what IMS brings when guest only wants
> MSI-X on an assigned PF). Though it may provide a shorter path
> to enable the IMS backend support, also comes with the long-term
> maintenance burden.

Thank you very much for your guidance and advice.

I'd be happy to implement what is required for this work. Unfortunately
I am not confident that I understand what is meant with "variant driver".

I initially understood "variant driver" to mean the planned IDXD virtual
device driver (the "IDXD VDCM" driver) that will assign IDXD resources
to guests with varying granularity and back the guest MSI-X interrupts
of these virtual devices with IMS interrupts on the host. From Kevin
I understand "variant driver" is a new sample driver for an IDXD
assigned PF, backing guest MSI-X interrupts with IMS interrupts on
the host.

The IDXD VDCM driver is in progress. If a new variant driver needs to be
created then I still need to do some research in how to accomplish it.
Even so, it is not clear to me who the users of this new driver would be.
If the requirement is to demonstrate this VFIO IMS usage then we could
perhaps wait until the IDXD VDCM driver is ready and thus not have to deal
with additional maintenance burden.

In the mean time there are items that I do understand better
and will work on right away:
- Do not have ops span the SET_IRQS ioctl()
- Use container_of() instead of opaque pointer
- Do not ignore INTx, consider the mdev sample driver when refactoring
  this code.
- Consider the Intel vgpu driver as user of new emulated interrupt
  interface.

Reinette

