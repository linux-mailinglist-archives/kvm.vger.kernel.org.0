Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAFD3652D03
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 07:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbiLUGqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 01:46:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLUGqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 01:46:14 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A061EC71
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 22:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671605174; x=1703141174;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HLP0tqH83t6Yl3CRC06jQBuzt6TmMP/qQFrVM6CF5S4=;
  b=i3IdVFZyv1lDgmcXRW8ewij/PV+dyKWdaFxWuKxn2ogdo6tgGVey2d5q
   ghHNTbODPtTl6ElSlWPsQ2dBNn2p86OvKm+++oHwSoGju1QGWgvKr3+8I
   AtVkwhK5NKnj8VeClxh/lFzMphyD0Ay5SoXGEhIHBvS0mAFSDKa0u/E7a
   9FqjQ5C07Gi3a9VtfVjr5yHLnv5lf59xWH4ebH5NKESL/pljzRyfsPlv7
   AMns8qtWzj9Q7wz0MwNcVvzZEU3HOhGOXB5WG5vbwr7I71pcvPHzZOyQk
   WBNZzkorRlL/VLGoe2LwfZi/M9GFdzI+dgrB0dNwsN6P6GNkdNQfcIXZ7
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="300145921"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="300145921"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 22:46:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="740065476"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="740065476"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Dec 2022 22:46:13 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 22:46:12 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 22:46:12 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 20 Dec 2022 22:46:12 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 20 Dec 2022 22:46:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AD+n3oLKKqndeK7zqwrlVNIvMbgK0LXf/dVmtyPfOCNV2/GwjaVAWpGn6/X2jlPh+fcRkrSAAHGJA3dbGDpjiqZ4lQGIMcxlbnmbecYmxOQjz2bk0zmjB3Zfcg4+GecC+nXFpKH2/s9mAPpxotBzfNqLWMPP8LLNdMHN+m5hVnTy9MJgiEpceY2nN/3GaZbkZBn3Z1koMJ4eXAiVNIoa0D1UhOS+RUWh0jNMxYFTXxec6+UHdQPd8lvpNUKhBPX4r4mH9xhoBL4em8tunBM7f/lOe1wSKuNEqhp3BIMs5ude/iLfSx8BJWYw9p9NzROeL2wPjJWfmScYlhWoidflxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jqZGyr7hNJy4SMCznukUwCu6mDC0FfvuYtA9s+mLX4E=;
 b=U8iL6ZW6Sz3fKOLr8G/GqejNdfUsLTslI2vZGvCjEbWy6r3rjcmfQPE17ditFsUZYsdqUkBICp6EDbyVQnRP+tZGDLApHCAiZao2kWjYqO9OpABF9Uz/VhldOqJWX58ipR/DvIAGuqto4ou/PS3N0V3Rs1liFdr+NPcypcTkfNvA2CH0XUseoI6MvNoi9alyWmhx6IFsXQstWBGjngeuMgWHRo2c+YBesKYJmHxExM3MDqons6udgsZ4wTt2n4V6nYwbyJYXFiyFmNAhEwmoyT0mdk4JqsiH88/INKTtFSrvuwkBoRbKYKsar/w7+rYz0bLghCiSnDpcbUQx3WviQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MN6PR11MB8145.namprd11.prod.outlook.com (2603:10b6:208:474::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Wed, 21 Dec
 2022 06:46:09 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::991e:f94d:f7ac:4f8]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::991e:f94d:f7ac:4f8%8]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 06:46:09 +0000
Message-ID: <4cf86553-e3c6-81d9-fa35-f7a3a2bdccfa@intel.com>
Date:   Wed, 21 Dec 2022 14:46:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC 01/12] vfio: Allocate per device file structure
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-2-yi.l.liu@intel.com>
 <BN9PR11MB52761BBD44F2CD5C121035708CEB9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB52761BBD44F2CD5C121035708CEB9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::17) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|MN6PR11MB8145:EE_
X-MS-Office365-Filtering-Correlation-Id: ee04b501-838f-4382-087b-08dae31f0ad5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hWzsUr4JCFVVci1x5zrpPUHdUDcsHh/Iq+zlRucVA5zO152pcSg7sEUYf3LVgNT2idFSgTyDpRW1T3pAU1LkNgPEF3dDP/kXRN5LYI591hvauUxyGlFYF42WfT6eYCKuzS051TR8c4TjEKlluSEQwtUX+FiUQgAKJe6hXCKoavAnqC8hD6uF4JQ8pgQygf9/3EjRJ5FA2SuXn4QJICjDrj1sCgLgRQ4fMJiLy3eFNz/9I/aB6Iycqka2PCTaYLIazhagGOaLtwRkBi6jPp6bAQHt9XZ6OYqEF3igloIsYN29Ny+2E+GHQLJbLScNn6TQUHCEcrKiM2qogcdgxkoxJnL/L+KVL9f17+xzgBbTY94OPZc+LimLstnyHLTKjGdFlY/udHZJHcWs3YUfftovAzsAPHQ9DdtqQgWDJoHB/akiKVz+YXI8j2E93SKSPZiV6ScBcy2HvcNsxcnmRFF1xqKtRRIevcpEkSk9L4F/7vaOQqOMANxjpNUvzofqZloW9ewW+Zw74VGiJXk/gCxSO4jBktxxr0VBgGtRyHYcFYfoo51mve18D33zdLDyTt1HB/kNvgI54sA9emqtW5M3Hga1tsNqijCk2Uqjn/jTnvDZTFLlY7hSyPRzmF8WTm+peKq5whxfjkZn/6jhmByu8zmbUXR20RhQD1BrIYWm+ZOtJ54VApiozb1OZfIM+97DcBrpYzvMR8936JbwFWGuGdKvD9r7lojgqnwcD6dzQoaHB+jCeb9UZItoN5L46Q5T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(136003)(376002)(346002)(366004)(451199015)(31686004)(2616005)(316002)(86362001)(478600001)(54906003)(110136005)(36756003)(38100700002)(82960400001)(186003)(53546011)(6512007)(26005)(6506007)(83380400001)(31696002)(8936002)(4744005)(8676002)(2906002)(6486002)(4326008)(5660300002)(41300700001)(6666004)(7416002)(66476007)(66946007)(66556008)(87944006)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3V1ZHdNVjN1V093RHpvdS92YlVhakpacXkycjFrVUFjL0p0VUt4TlZ4VDll?=
 =?utf-8?B?UlhWY2ZpaHphc3BKbE1LUHM1Qm9HT1U0NnNIWFlzVmtvYkVWN0ZPa2tySFhS?=
 =?utf-8?B?TkxLR2x1S0NZQS9zbzV3aXJLOWlreWFVK3drMStTaUVsZ2tjN2dZdlV3K21E?=
 =?utf-8?B?RTExTDBPc3R4bFFTZlp2ZWxBSUdOcHUzY1VvU21HTlQxM2dFK3J1VXl2NXNT?=
 =?utf-8?B?RzRyZlBrSU1sNHhBeDhOMU1aRFdycG1WTlJscEJYcHNVTVo5SWxreHBKUWJI?=
 =?utf-8?B?UFFOYjV5SGxxalRuajlNRGdDU25TRy8wUWNSRThxcTNOV0V4OTgvSnFwcC94?=
 =?utf-8?B?QmlTSTB0dHBEeURVL0J1TTVjNmo1QkJmS2JQZFBnY3UrODRuZ0xVTS9UMll2?=
 =?utf-8?B?dXJrZ2lYQXBpN0J3L1dkc0szcGlLMVZEWG9TNCt4Z3k4V0pzQmNwa2dDRzQr?=
 =?utf-8?B?a2gvQVg1a3hRcnFRb09mRVVsejdyeUQwdjE4UWwyZmhUbHRjQi9QaGZSTTJi?=
 =?utf-8?B?VUU0dmQyVjRSL2F6WkpkYUFjYmQ1b1VFb25kN3lUcyszWGxCa2w5VlllcHBR?=
 =?utf-8?B?SG5NY0s2Sm1DR2J1V01sTWhlQWQ4Y05QV25ReVJZQzREVmtIQkpSYlhNSDFW?=
 =?utf-8?B?TE8vSTlqYjBhOElHYjlKYTBTU01PUzV0aVJBWUhhMlJxYTg2RW1kRm9mZUdX?=
 =?utf-8?B?RExDekVYTkFvRVpxUlRncUx3Y2dhSVJpcHV4Slg0TWszTUg4cFkrSFFqT09J?=
 =?utf-8?B?ZEowbk1vclg4WW9TMi9wbXZiS2U1d0JlcGVFTHhQeStiNDZRZ3p6NEtiMWdP?=
 =?utf-8?B?K3VHeVRkK0g3UWxJQVpiaUsxTEVhdVZwMUdIL05LempiZUZSQi8yVVpqTlJj?=
 =?utf-8?B?b1lxdlAxeEF3aUgyem1EeTFNTkpaNTY1WkVXdGlqQk1uYlA2VThUcG9YbUtX?=
 =?utf-8?B?eVlUdFdxOU9GUklhL2dWVEdlbmR3NkFaSkJXdktXdXM4R05hZUtENjRqUDFn?=
 =?utf-8?B?UEJ5SlBiSGpBd3ZURGF3eVU3OVdCOSt5cGdRZGhIT3ZGVzVJWTRLWHB2UmlC?=
 =?utf-8?B?eHcxamNybjBGNWsveEF4c2wreUwyNTF4T1NnblkyS0o5OEsvT0NvdDVCOUZB?=
 =?utf-8?B?QkNRQlVHelZhOGRSdW9vUy9rWTB0M2ZVWU1sUStrWW1NK0xHa0s0QStkL3VJ?=
 =?utf-8?B?U1NwZGovV0Zld1Z0Y0dKYlVUY1FxQXM5NjZNckthNVhSRGp6WUUxdU9WRnlI?=
 =?utf-8?B?dksyZllQMjNBSjJPQjJTSHE4aVAyS0h4NFJUZjdzMWprbzMreUZUQ0xteHRy?=
 =?utf-8?B?L1B5UVlrMkVkVjRVMnZ2b2ZOQ0FkcFlZdjdJMWhqSEZ3Y2Y5YXF4NythUHV6?=
 =?utf-8?B?anZiOGRWbzhlYldqMVFMN0dUREkvOXN2QnVwSlFoRGp0dnVsVU5DaHA0Umcr?=
 =?utf-8?B?aUFaR0JEZEI2UGEwNFZIekV4MWxnSUpYZDVyTnlaRHRqOGNEallrVFM3Vmhs?=
 =?utf-8?B?VFU4NGxjVEN6aU9waE05S1cvK1FCNWdjbFFIeHQrN0dMQ1lOR2RyYVF2TTJX?=
 =?utf-8?B?NldEM1ZSWGpwREZNV3JZODdDZjBlQlQwOFlVWGZBOThRVkQ5SGFGeVJwL0ZC?=
 =?utf-8?B?YjhTaVZWeGtUM21WR2FHb1hNUjQyUkoyRFl5eWxXc2tBWi9NbHhQTklVdU12?=
 =?utf-8?B?cHJ3dDlXN0hRa0p4Z2hxMlNTdDRaaktjLzcrdk56VHZVRDdpd0dKWEk5dWF5?=
 =?utf-8?B?WVp3Q3ZsMExPdGJNK3JGMUFVa0ROS3l4Y1dpc1IxTUN5aHNFTEpHVndSRHB6?=
 =?utf-8?B?MGJtRkRxYVhDYUxZd09GSFA0MlBZNCtucTdmL3BTMFRCTDJCVWt3NU9mdjRI?=
 =?utf-8?B?alBJZjhpdytYdUVvdGlOaThWd2dod0xoL0NyRnpEQ2FQTCtyYVRmdnpxQzBz?=
 =?utf-8?B?cTBQZlNpakx4M0xUQzN0ejhvb1QyWnNJNG1tYVNUS1U1VGxUcFBZSGRIQnAy?=
 =?utf-8?B?YmM2VGUzclc3V1ZQM2FlKy80dFEwQXBGQUFmZGxBMXB0a2FNVnk4TUc0c1J4?=
 =?utf-8?B?bEQ3cGFkUDNCdURJOXhrV0lJTnlsaGNndEQ3WUtpREEvK2pWU05Pam1DUElz?=
 =?utf-8?Q?BVxNa9IppLKMggobHrubv/uDH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ee04b501-838f-4382-087b-08dae31f0ad5
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2022 06:46:09.4382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TPtzJbuKAl1+OfKTjMl8hQNb4ZGtVH0YRd0/1lCzgQV0Ti1SPxbIPVuKFWXcimMymsiQBOwx4ykJpWGzHx592w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8145
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/12/21 11:57, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Monday, December 19, 2022 4:47 PM
>>
>>   static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>>   {
>> -	struct vfio_device *device = filep->private_data;
>> +	struct vfio_device_file *df = filep->private_data;
>> +	struct vfio_device *device = df->device;
>>
>>   	vfio_device_group_close(device);
>> -
>> +	kfree(df);
>>   	vfio_device_put_registration(device);
> 
> Why putting kfree() in between the two invocations? There is no
> strict order requirement of doing so. It reads slightly better to
> free df either in the start or in the end.

yes, no strict order here. maybe in the end.

-- 
Regards,
Yi Liu
