Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288716374E9
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 10:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiKXJOx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 04:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKXJOv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 04:14:51 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2319B7C8
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 01:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669281290; x=1700817290;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xKaL3NtuxKzIYAexfVymW7sYIxsV27GrXOQJipdZ7zQ=;
  b=LQvQ9mql8sa8KdZ63BvH8TamCQyvnuzp/WPzIyHFKJM02t4LclJ/r/th
   Tftb/OutbaNvIATi1eBVs/U/9V6sm7JJRRjrVopQ4zcNjIysUYSFjhqn9
   +npyHmfbfexuJN8qpTnG/rfLns9Uzx6ffM4kbecQmes3XRqdvZgt64zfW
   OS/2hiachcsT/je+8LpV+puTsY86t1yoVstlVoKfjb0Y4IDB2FImblyQC
   EQRlDxJLNWj0XAa8UZMVTlkoTGmZ7AanrfgMNramAaVTNYMidtj8DKYR3
   urQMVLIaGsfz3GgLGuRvG3khXaJLz9dzX3OD90xBqWh1/UPrgwsaJSOYY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="315409559"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="315409559"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 01:14:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="731076841"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="731076841"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Nov 2022 01:14:42 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 01:14:42 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 01:14:41 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 24 Nov 2022 01:14:41 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 24 Nov 2022 01:14:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O5fSqLwBJ/nUdNdZq3qskQUekU6vTy8eaWwdnsrCZA8+RsPOLJ5uOz8X4bDvQB5F4AhOyYr04tgLV0dpqBRCND40AmOla017SnSiJxnjsPU/NNwHF+7l42CBAP6wGDPuKGm/cpjVJXOxBs6LyAAPP7fU1gju1ZBtPqj5NrsUmWZxLozrvXSJdr7zLXdunTat0vOExLsqeFbVCG2jXvpRWLpV+YQzaQg+0QCQtyS+u0YQQIuFcPtK+Ac37RmuAo44bUVnwnaOApPQfBH8rTNzwxupJI2OIjne5pOj+3h4n/dAXl1hvWFP/UHVd5BOl22yWovxqflen4PQBMZJaSqvAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JcFvVakHJEiclF4MtQT4NuR9ZZoSf+Nun0s1/sFBfuY=;
 b=iyEhwCccbfdWMiWY2IL8waoG8cnVab5VQe8cUYpjwqQ9/hJWgXlJw4l/HpZRyj+9JSgtiTO4X4j7FuEWAa81NSijlXuqhOT34s3b3Ty3KOXTZS6JsTZmxtoZVVL0HJLBYrLXXpq//Tj7uerA+l0rislTtOFdfwytptjPmY3YRpGVOQSr28EghHVVo+lWcdkR5NTh4H29b0yOY5RqPYhy4SYsFOdIxX9XPsEA8xOQ+1fabZ/PTlTDNb5hPDOFjnKTPsr2cOMIHgFhge9stElafEG7AUEnnS1hO5gGCV41H84EI2dknWmX23bu9sLTNI7OHxRBveXzyGuA0r3jw93IDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BL1PR11MB5317.namprd11.prod.outlook.com (2603:10b6:208:309::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17; Thu, 24 Nov
 2022 09:14:34 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%6]) with mapi id 15.20.5834.015; Thu, 24 Nov 2022
 09:14:34 +0000
Message-ID: <39bcd0d8-17c1-79d0-ed9e-123dacbd4b63@intel.com>
Date:   Thu, 24 Nov 2022 17:15:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [iommufd 1/2] i915/gvt: Move kvmgt_protect_table_init() and
 gvt_cache_init() into init
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
References: <20221123134832.429589-1-yi.l.liu@intel.com>
 <20221123134832.429589-2-yi.l.liu@intel.com>
 <BN9PR11MB5276413337536E76B2B0DA0E8C0F9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276413337536E76B2B0DA0E8C0F9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGXP274CA0002.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::14)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|BL1PR11MB5317:EE_
X-MS-Office365-Filtering-Correlation-Id: 37bc8feb-65f8-4a73-f766-08dacdfc4cf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N9/pAM/YgLXlyTPFDXBsP2rObyBLanGbi4Ttu//ujbmxpnQN+1ntEH9rpV1p1zK5F5jRtdmzdc2yUqeCM1bUYNaBAKCeOUz3PXR8A8+Vkndxc/xmK/V+UKEPRWs47PF/v5S0U1XKYQ+6BK6ipAyz6qv7OMwUgxFs2XhEjWg+901YpdLX35CAY8TN7R0ORodcXV6tQ24dYJX2571QWftBC5fByEmnByCs25rcCmQZ1fg8JAcbY59Sf4cHWfefA2Y/lheA2G/A2mA+/v9AxOqP1rkH9DMGuYuEPOEuctE+JpM6tjxbLsQTNjjHmW9Qw+/US5g+YIGqYyaYRnjhEmAKPiliOJwe9jVY0pWM3Uz0iep8suOJDMM64wXyb0GzbvJmv6OUc7jGZTQLESral+2ddpFup3lBpq1pCGbR5mn5ZT5fGVyqrO4fmDjlLcCUOdHEnynQWBRRcmQFI++r7PAQrzHhyFKLGaMfrvHvyKvp7cSm5sKrcbaaWM5A3eIEibZ1NEqq8VeE9nPQpt0/MOCo4/cGJUCDmi9/4ayZg6r3Iwo5CeNHOIEph81nuOb4oc8TEDBWirxRk7Nf1V4fqe9tsiHO0BNDOpJc53lCteb5gGERFJjrYM/clo52W6TFHUI1lUno73EAuf/oKXLLn1tk5x77Jtt8F+FyI8c6CeRRX3a0hvaUH0KargWhzQc2vIq6uLJckVWZ2r/EEd1hYsLEsz89uyjr1v7wahqDTy4kyXg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199015)(41300700001)(5660300002)(2906002)(8936002)(26005)(6512007)(54906003)(38100700002)(6506007)(53546011)(82960400001)(316002)(110136005)(6666004)(36756003)(31686004)(4326008)(66476007)(8676002)(66556008)(86362001)(6486002)(31696002)(186003)(83380400001)(2616005)(66946007)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2l3RmR4ZTk2TG5GQW1SNk1FN2ZQVXBwSE9iaE8zKzIyN3JHS0NXYkI1V0ZY?=
 =?utf-8?B?SmlKVVRucmdaaUNZY2VhdTc2WjBnSlRTSmcydTd5WGV3RjZnV3dXUWN6anVS?=
 =?utf-8?B?TFhGM0NKK20rOEtqenRZem5nR2c5L2ZQcE5CWm9sVHBaYTJKQnNWaU5sWWJL?=
 =?utf-8?B?WFpuODVGZjNERThyTmdVQ3NsdWgrdTlQV29lS0JtU3V4ZzlzNERsS0FsbTdi?=
 =?utf-8?B?UjlKRisvWGxMekdjZGtDTklaM0FFWVVIWHVuM1ArTUIwdjJ0QThmVEE1S2Ns?=
 =?utf-8?B?VFJGYmkvcGdFdlIrS2lFM3g4bHhUb3hKMVlBSjkwQkZKZkt6OHBlM2RNbXhx?=
 =?utf-8?B?ZlJ3S1BLc3g3REJQNXY4L21YeDJnczdRQ3pjRFRwWTl2MlVyTXBQQXdEZnNa?=
 =?utf-8?B?U0Nad0dEdGdSODlLSll2V29QMVBVMTdyNkRaUEFHajVYZW14cGVGTzNmV0pU?=
 =?utf-8?B?ZzdYbHNRQVdZOFVmZC90aWlXMFBmdzI2VFU5Smk2bGw5VnJFRXh6cHo2SU1h?=
 =?utf-8?B?WGVJU1F1WFZVdVphaE5mYmtkcTgxQ29YMlhxakhTNDMzNzVabzZ4QkExaDZi?=
 =?utf-8?B?dDVJZGFuSHRBRkxaM1g1Ui9IMm4zZm1lQnJURVpscnNGQ1dqQmM4dXdoTE9H?=
 =?utf-8?B?eFhyQUpsc2FsbTNrNjNkZDhhcjNwRXg1VG95a3A5eVdFNXBTS1MwNlFCLzJV?=
 =?utf-8?B?d3lIS08wSkl6VW4wbVl2eTJBaFgrZmFXeDN6SUpQczBrcXdhbEJSUlZVWnMv?=
 =?utf-8?B?Y1dETFBqOUtUaGhkM1VRd2R3SXRaV1RmU2p3QzFhem1GUXdRbTI1Z0NPMXda?=
 =?utf-8?B?MkxweUpEMEwvdEV4QjZmSFNib1NURWs1cjFUdW5nUnM4Y0prdEJ2eFc5UGZy?=
 =?utf-8?B?ckt1N21ZNmJsNXA0RWhIY3RoSzNZWlM4RDlQUWo2cFB2TmRJNFhWa0Zkbzh0?=
 =?utf-8?B?NUk2NDFqdGFnU2hITzJhTHJ4dTgzTjA4T0pUUEQ4Z1IyckkvT2dseS83VmNj?=
 =?utf-8?B?QkdaS2EwOVVDQWRSZ0dXTGhzejZseWRzVVJ0OUx1NUhsSjBZdmx4cFY1T1Bo?=
 =?utf-8?B?MlZya1FJdXFhcG4wWjAwNlUwTnR6VE8xL3Fid0N1SENKb0RkK0s3K2ZDTlJM?=
 =?utf-8?B?QWM5ckIrTGZtMm5BTCtMTml6KzdxbUxJU0hQdzBic09mbGl6NVJvWmdaT1Bq?=
 =?utf-8?B?cWJQWHhGbVhDcTlMTjRkcENja2RzMXJ0UXc3R0JkUGd3KzRvY1ZQNmVGeHdW?=
 =?utf-8?B?UUpZRS9EbG5KclVPZU5udlIyOXBqRURRRTNrQVc5bnJhRVRKVmhGVlBsZ0x4?=
 =?utf-8?B?Nk52K0VkS0ZCSlFGd2Q5a0lmU3VVZnQxVE1IRU1JSG5CMXBLZ2N4aDJzK2Z3?=
 =?utf-8?B?WGFYdGJabjJoYXZkaVhFVmRudVpTZUJlbEFUMVl3NFdGei9JWVl0WVZSWFli?=
 =?utf-8?B?SXNGZjBZWUpSdk9DT1lSYkN4NHhKQWhhZTZEazhTa1lYenQva212NHdGSDk1?=
 =?utf-8?B?WGdzd3RjV25ETERNMnpzd0lwbE9RNld4ZTYrckJTUmhKSFJkbzJhbHRqVGlS?=
 =?utf-8?B?Z0YzeHU2aDBYbXhRdEZoSkNmRW5HbVAvZmNSbHRVVHFNODRjb1Y2SUxUdHo5?=
 =?utf-8?B?QWhsM1VZZkswMmhWaFA4ckpaRzY4anVnakN3WnhUb1Fxbng4VDk4TXBsbVZJ?=
 =?utf-8?B?cU12d1k2aEttRm1jSGs1aVk2cXExOUU1UWlpK2R6TmcvcnBXN0xvOS9DdVRK?=
 =?utf-8?B?Z3RYQjRRM2lnL3l6MThRTGlQWTlMQUduV0pxWHZaY0g5SVU1bkhGaGgrL201?=
 =?utf-8?B?UFVOallLc2pjM2ZwWEdHdkxvdklCbVJXaWEzWG0wS3QrK2Y5TjlCTlBzbjQ2?=
 =?utf-8?B?d1h0bWlmVFl5S0VxOUpIbzhxTHhmY3NEZGpVTjNwRzBDNjBmNUtzdkt2a2ll?=
 =?utf-8?B?cGpRdHBIeXRIK0JJSS9iMkQzOTBtTlJ1Mkw3Rzh1YTdmaEFCMjRPQXdXSWJJ?=
 =?utf-8?B?MWJvaC9RNWlONUFVeXoyWjBsQm5FVXhNUmZObE9WMStyTEVvUWswdjJ1RXhD?=
 =?utf-8?B?MjRyRkN5cmFNN3lQbzVOalM0Q3psNHBmbGxSbVN5bEdTR1lEQWU5RVFmeUhK?=
 =?utf-8?Q?UdxwcwiF3V/HcbnlPuaKeuD9F?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 37bc8feb-65f8-4a73-f766-08dacdfc4cf6
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 09:14:34.5251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TELU+lEouok9wWcZUe+Wn2hKcUSf2nVIgIr/HLsh69kJfM7Hp87jy5oXfZ9xSxG9iQimzKS2Z4789TDGxpK3sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5317
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

On 2022/11/24 15:07, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Wednesday, November 23, 2022 9:49 PM
>>
>> vfio_iommufd_bind() creates an access which has an unmap callback, which
>> can be called immediately. So dma_unmap() callback should tolerate the
>> unmaps that come before the emulated device is opened.
> 
> this should first talk about how it works today and then why iommufd changes
> it.
> 
>>
>> To achieve above, move the protect_table_init and gvt_cache_init into the
>> init op which is supposed to be triggered prior to the open_device() op.
> 
> what about below?
> --
> vfio container registers .dma_unmap() callback after the device is opened.
> So it's fine for mdev drivers to initialize internal mapping cache in
> .open_device(). See vfio_device_container_register().
> 
> Now with iommufd an access ops with an unmap callback is registered
> when the device is bound to iommufd which is before .open_device()
> is called. This implies gvt's .dma_unmap() could be called before its
> internal mapping cache is initialized.
> 
> The fix is moving gvt mapping cache initialization to vGPU creation.
> While at it also move ptable initialization together.

much clearer :-)

>>
>> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
>> Cc: Zhi Wang <zhi.a.wang@intel.com>
>> Cc: Kevin Tian <kevin.tian@intel.com>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> ---
>>   drivers/gpu/drm/i915/gvt/gvt.h   | 2 ++
>>   drivers/gpu/drm/i915/gvt/kvmgt.c | 7 ++-----
>>   drivers/gpu/drm/i915/gvt/vgpu.c  | 2 ++
>>   3 files changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
>> index dbf8d7470b2c..a3a7e16078ba 100644
>> --- a/drivers/gpu/drm/i915/gvt/gvt.h
>> +++ b/drivers/gpu/drm/i915/gvt/gvt.h
>> @@ -754,6 +754,8 @@ void intel_gvt_debugfs_remove_vgpu(struct
>> intel_vgpu *vgpu);
>>   void intel_gvt_debugfs_init(struct intel_gvt *gvt);
>>   void intel_gvt_debugfs_clean(struct intel_gvt *gvt);
>>
>> +void gvt_cache_init(struct intel_vgpu *vgpu);
>> +void kvmgt_protect_table_init(struct intel_vgpu *info);
>>   int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn);
>>   int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn);
>>   int intel_gvt_dma_pin_guest_page(struct intel_vgpu *vgpu, dma_addr_t
>> dma_addr);
>> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c
>> b/drivers/gpu/drm/i915/gvt/kvmgt.c
>> index 579b230a0f58..cb21b1ba4162 100644
>> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
>> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
>> @@ -322,7 +322,7 @@ static void gvt_cache_destroy(struct intel_vgpu *vgpu)
>>   	}
>>   }
>>
>> -static void gvt_cache_init(struct intel_vgpu *vgpu)
>> +void gvt_cache_init(struct intel_vgpu *vgpu)
> 
> those are local functions. Just move to vgpu.c.
> 
> or you can remove the function wrap and directly put the internal lines
> in intel_gvt_create_vgpu()

yes. maybe see Zhenyu and Zhi's input. which way is preferred by them.

>>   {
>>   	vgpu->gfn_cache = RB_ROOT;
>>   	vgpu->dma_addr_cache = RB_ROOT;
>> @@ -330,7 +330,7 @@ static void gvt_cache_init(struct intel_vgpu *vgpu)
>>   	mutex_init(&vgpu->cache_lock);
>>   }
>>
>> -static void kvmgt_protect_table_init(struct intel_vgpu *info)
>> +void kvmgt_protect_table_init(struct intel_vgpu *info)
>>   {
>>   	hash_init(info->ptable);
>>   }
>> @@ -671,9 +671,6 @@ static int intel_vgpu_open_device(struct vfio_device
>> *vfio_dev)
>>
>>   	vgpu->attached = true;
>>
>> -	kvmgt_protect_table_init(vgpu);
>> -	gvt_cache_init(vgpu);
>> -
>>   	vgpu->track_node.track_write = kvmgt_page_track_write;
>>   	vgpu->track_node.track_flush_slot = kvmgt_page_track_flush_slot;
>>   	kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
>> diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c
>> b/drivers/gpu/drm/i915/gvt/vgpu.c
>> index 56c71474008a..036e1a72a26b 100644
>> --- a/drivers/gpu/drm/i915/gvt/vgpu.c
>> +++ b/drivers/gpu/drm/i915/gvt/vgpu.c
>> @@ -382,6 +382,8 @@ int intel_gvt_create_vgpu(struct intel_vgpu *vgpu,
>>
>>   	intel_gvt_update_reg_whitelist(vgpu);
>>   	mutex_unlock(&gvt->lock);
>> +	kvmgt_protect_table_init(vgpu);
>> +	gvt_cache_init(vgpu);
>>   	return 0;
>>
>>   out_clean_sched_policy:
>> --
>> 2.34.1
> 

-- 
Regards,
Yi Liu
