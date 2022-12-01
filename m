Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44E763EA20
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 08:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiLAHIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 02:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiLAHIL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 02:08:11 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A518F43AC3
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 23:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669878489; x=1701414489;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9KAjv4AWldwJgsJCBDFbp/4PUUHYk/sQl9YFTzGAaWw=;
  b=chnP9VLuQSU010qkIShr8fUJ1pioUBEQbTugLhrgoMv8MdLbWQDT5mhR
   ZR3u7wq79Axg30L5yertKSToUPrIbLmipeZPHP08W8bow7wOphry64mTZ
   QjZ74YxfCVD5UKPUqP4OwO8aQh1Ppi9wyC9L6uCNPm0H2uqr3bJMCyH4R
   aAmFeL1xhlPb6xE59PTqpbqcd9IpAFXh+QMyAUM6zrJNluwr40zhHZA0D
   USiCHoENJH7623xXqut1dWe0+v8jjwp2otZQaQNYurlXd32awkbCeUQTc
   DmgezqkVHYa/cygnXkrvl5edlXo/F7C5dpxSYSkKz64u1vXqq9E+8cDsm
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="303213888"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="303213888"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 23:07:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="750678762"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="750678762"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 30 Nov 2022 23:07:42 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 23:07:42 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 23:07:41 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 30 Nov 2022 23:07:41 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 30 Nov 2022 23:07:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a4wIH5TDResDTIRlOSewWtwLj3Ft/DxH5UdyHOKCZzan0RUFfUr/G+bZrJ6ipL2w0gwMNk/GqBnz6vkq8NYA01YaqAnMwQOd1FquPKe9jFRc/aQbuGq4Mgqm57AsmAxB5pNwRp1txgMSUxGvFrighVJ8il3yTVKF/4xj7wGUOF5TGxPKfcpvzGPbbolAoljmfRicMzVWwzXkXhBC4aUHh84AjIk1q6dZv0qr6qvpFd7jre+3VmVjinC8npbZ3UDIgl7sirjOOuyNRpMDEDJyvTgkaLJQj6mViHjavHvxIZCkYmXLIZ+GJM18iBN9k46l/ZoKstSGuQMpADGf+rAubQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tm2bu9S1wFPkDR4AHnzTQQbtnwJxnk1/0Cskyvi8Q48=;
 b=kSvW4ayK4g8wZvX0r2tJJBi5FMfeFJxbXoh3XZXJKk8Y1EuHSgTkyUp01cgbz2XCAMgCOWVuCmwxsK8VSNnlljgzA7hVnLiu+6sDJPfxlsj5ahFcsAGSvXAsFtzlbzM615UkckskxVNTNBpxZYmZQFJxV7RwvV9052Y0+vA8cjbgBEZI+vgHYeZgFhuAlL5zD8zmRifn1BBsLRb75dJBXRw8j81Mh5U94IAqdOAsnnLHQ2XXt+c7iZFD3baUrz3qhUqZvsPu7zNghFtY1ds90N8OrnmmEqluygEiQ57PrBTpPx+0s52z822uWMdR4FvZxAoRxWHk/2rgMo5czG3NQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM6PR11MB4673.namprd11.prod.outlook.com (2603:10b6:5:2a4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 07:07:40 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%7]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 07:07:40 +0000
Message-ID: <f57fcc1d-a3a4-c423-a863-b1958a8d453f@intel.com>
Date:   Thu, 1 Dec 2022 15:08:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC v2 05/11] vfio: Make vfio_device_open() group agnostic
Content-Language: en-US
From:   Yi Liu <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-6-yi.l.liu@intel.com>
 <BN9PR11MB5276CD3944B24228753883418C139@BN9PR11MB5276.namprd11.prod.outlook.com>
 <28861625-d500-e5e9-98cc-d1ea10fe06b6@intel.com>
In-Reply-To: <28861625-d500-e5e9-98cc-d1ea10fe06b6@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0171.apcprd04.prod.outlook.com (2603:1096:4::33)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DM6PR11MB4673:EE_
X-MS-Office365-Filtering-Correlation-Id: fe8d24d6-06fd-4540-1b57-08dad36abb1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o8TmWm5oO6u1o5m5hTIUbuOYqfspcC+PrwfBXzraiVvT4x7tHgNWLkhQAA94R3FvY6LzIsFhnugw5y14k4fQg6ZMbzxo1mcpOK5ANaRdrDP/OIHN10UB1reCrM62m02zs8Rrs3kx0kQ5mS+FiP2oU1fG3hp4/RilFPv4VrPReidD5MU3Swt55jhKzNslLNpxbeShqoIjFeCP1aDGgMT+tRLqiyH8uwPDJEgFjLfbJaNFPtUodNMYSy4CvQzSkemUEjBCZpn9Y2fDpH7inYgwwPLp1XvMYTBOlL7a6X1XLG6+b2zv/zZlir8w64jTDnTqiFgo101h6mRE5d2KNKw5uyhwtO6pv6/sIG7Jn4lWz2cNsuGe4Vue86S40aou9yX+WUmVn71t0dXtT7qy3hs9K1OXo/FdNH43EGDJmTNo5P0A/YNDMyakxr5X8LBL0VXdJZnAlkN+CLOTG2WqOXPMG+BVa63hT81sBuj2h6B7xewri6gqvteqv4Ydq7ecYAGK5o25IVXUcoYU/mRjXrgs2u87GyzvoAE6bTV+sHwUNE/x3b9/C+TtABiwUPXwOHX27yDR9TO0LSBWyBa6xwsy9q9ohng+UQEdNn0s2Wxs7xmkbkRYntCugvX8SyfH9L8uxtuycmW/lqkTDjShvuwumcLHhWrmzaBZCrxmy3KscaJnnCSvBZJPpknEoR1pVNIDWc/c4UpgWy/gV0PeZZPMYRdLXBoJ59q50395cRnnSdE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(366004)(396003)(136003)(346002)(451199015)(316002)(8936002)(186003)(110136005)(54906003)(5660300002)(6512007)(4326008)(8676002)(66946007)(66476007)(2616005)(26005)(41300700001)(36756003)(66556008)(38100700002)(82960400001)(2906002)(83380400001)(53546011)(86362001)(6666004)(6486002)(478600001)(31686004)(31696002)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?blRFWHNVVjBFcDJFVEQ0aksrd3ZjSS9lcGtzb0xTM1dDaE9oRjJoTXkxVGUz?=
 =?utf-8?B?SUx2aEJhNXZQT28yaDc2dXAxcVlibDdxL2szcmRZd2NQcTJGWlJqTGJmSkxw?=
 =?utf-8?B?T1REalBTMTR6cHJJRFVGNjI2U2RaeE9BcTY3SE9YTmMvYUpOdkVRdUlMYU5Q?=
 =?utf-8?B?MzBNY1duOUV4V2dCRUpSTDF6bHFQS3hIYnl6V0RSMzBycVR5NjhmWUtuUUlU?=
 =?utf-8?B?aTFBY0loWmF3WDhCdzJvZGRvWlhyRWcxeEZTR1VoY2dyMVZaV3JjMlJ5YW8x?=
 =?utf-8?B?SXM5S3JQZ2grSGthdzZ0M1haQnk2QWw0NnFyaG1qNmhBSmFuY2NrS3dRMUsw?=
 =?utf-8?B?VmZRZk1tSDFBejY0SEcwMVVjK05RWWxBZjZzYUdaUlR6a3VvZURyUmJnNVAr?=
 =?utf-8?B?d3hPWGdZdHdTdWNOQWdjKzBsM3VEUUo4ZzIwRFVIZEtxSkpQT2l2MGhmVkZK?=
 =?utf-8?B?RkRGV0VDV2NLWndNMVNIVVBjYXBvbkJsbHhmcmFoVStkOVdYdjhHaDBTenQr?=
 =?utf-8?B?OFdHTm8rQ2thSUpIaTZnTmFJOHBFOU93NkJKL2lTekR3Q3Fwdm1ZeGo1Z1lp?=
 =?utf-8?B?dmMvM1hSb2VoVmg3S3FNbFhYQjF3L0JrWGVPTzE1MDFEcGxHeXpVb211S3Vx?=
 =?utf-8?B?LzdFSnBFeDFLenZjMFlUUzlYUGgrRmdaeTBUcUFsUkJaMUM3Z1p4OVVpVHZV?=
 =?utf-8?B?OHVTUi80UkNWZ3BvUThjTDNzdjNOcWlYOUlMdVdVNFFZekdqdXJXUWZndlg2?=
 =?utf-8?B?VGpKSlVjYVpWTVAvMzFYd2ZvOFBJSHJFdXBYNUtUVFlGUXlYbEY5ZzZkVmc0?=
 =?utf-8?B?dEpRTm0wNjVjaHFaRHA5SzZnWHl2SE9yUmcreGk0RmxLZEt5b0g3UG1HUEhV?=
 =?utf-8?B?azRCUFRTWVIyditlWDBFYkwvTWUyTUF0cjNhVGtOMHNnZ2NnM2RZdkFzR1Zw?=
 =?utf-8?B?RDN3amJZTXluS0lBUnVHaXU4eUZvbXhmbStpb0dkcThuRzJWTWg1VEI0MHFo?=
 =?utf-8?B?TmtFWkFROU5RYUdzbG1DMVlJeTNTeTdPUW5oTzFIUittT0lWbG16c3BCbkJG?=
 =?utf-8?B?T3FUTFloVUtuRWFDaTROYndpVjFNd0JtSkRXRFBORWcyU2YwbGN0RTBGVnRI?=
 =?utf-8?B?SUFIemVHRTlWTTBHYnh1NUxGZ1RndFlxQmdKSFlhaC9HT1JMU0hTcjhxLzZy?=
 =?utf-8?B?RWY5K2treWVwMW9zcnRHdjFaZlZqRXJIOWFmN0xhS2FqVUc2UEsveFVBQ0FP?=
 =?utf-8?B?L1RTVWV1emhvb3pCU2F0em1CTHMzTVR5dFBYdW9pQU5HMkJqZjAwdi9ST3RE?=
 =?utf-8?B?RlFYUE50YmxTaXVJVE9ja3JTZVJ6R0pKc3RSWUtVVjIvcHpYajA0ZmFSVTRQ?=
 =?utf-8?B?cjRialpJR1VOdThrLys5WEdDSytRdkE3cHlQOE1JNWF6NVd2QzlPR1hKTUFi?=
 =?utf-8?B?MEdtcUVIcXVPeFdYK0tBM1VRQ1VJVWZjK09uZWdnZkY4UXozdWYvQ2RDYit3?=
 =?utf-8?B?Y3B2R2hVUHpzSURwUU5hQ3FWcFhNYzZmeXBFaUUyK08rRTIxS3BBY1RCenVh?=
 =?utf-8?B?YVhvQk54WjlzZUgyZjdVZE5WMUJGcFZ1clRzRGwwRTQrckF0NVFVczIxSWRQ?=
 =?utf-8?B?aVN5T3ZOTGpkWUgrc2czNWpqeVRpZkM0dGFnZE5kNzRaekVoNWdlcy9JMDJW?=
 =?utf-8?B?cFhMK3JvRkRoUkZWd2c5YUpOS0s5VEsvcWMyN3pJcU1jMndjTWYzN0JPKzYx?=
 =?utf-8?B?VThwV2w0YnQ0QVQ0RE9sSW5jVEhLT2syN2h6M2NqWjZHQU1FL2JTam9oaEg0?=
 =?utf-8?B?SzhYZHlyTlhnVVJTSXByMENQcEIzblVUbDR2bzIyMU5LMzV2RXRscDRPTjFN?=
 =?utf-8?B?WElVd1REWHM3M3drZEVSeWZFTCsyWkJSdFVjL213cjlMSXBnTC8vNER1d1FV?=
 =?utf-8?B?dVZOOEV1aHJYdXNwSkRTTTY3WitXWVNidFFHWFV3NjN3cUh0MG1tV1lUUE1B?=
 =?utf-8?B?b3NScFdpN2dxZkxRUXBMOFU4enQwaHgvdmEvTHo4RUFHUU1QNnJPSkY1dHpx?=
 =?utf-8?B?TisrSnJQY3ppdEg0eldHa1FDMUs2SFZBaTJGT20ydVhlMUl1NzM3N1RtcGMw?=
 =?utf-8?Q?rZgGyytFv6YRS5K1C/BIuT8tN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fe8d24d6-06fd-4540-1b57-08dad36abb1e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 07:07:39.9401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TMnRkMpzlOo7d7NJrsrBgnhiRVnGOY9ozxjw19mupA9F+vTp3ZZdCKJd/4fzuTlOttz3rurubOS15kLAOVIdPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4673
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/28 17:19, Yi Liu wrote:
> On 2022/11/28 16:17, Tian, Kevin wrote:
>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>> Sent: Thursday, November 24, 2022 8:27 PM
>>>
>>> This prepares for moving group specific code to separate file.
>>>
>>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>>> ---
>>>   drivers/vfio/vfio_main.c | 7 ++++---
>>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
>>> index edcfa8a61096..fcb9f778fc9b 100644
>>> --- a/drivers/vfio/vfio_main.c
>>> +++ b/drivers/vfio/vfio_main.c
>>> @@ -878,9 +878,6 @@ static struct file *vfio_device_open(struct vfio_device
>>> *device)
>>>        */
>>>       filep->f_mode |= (FMODE_PREAD | FMODE_PWRITE);
>>>
>>> -    if (device->group->type == VFIO_NO_IOMMU)
>>> -        dev_warn(device->dev, "vfio-noiommu device opened by
>>> user "
>>> -             "(%s:%d)\n", current->comm, task_pid_nr(current));
>>>       /*
>>>        * On success the ref of device is moved to the file and
>>>        * put in vfio_device_fops_release()
>>> @@ -927,6 +924,10 @@ static int vfio_group_ioctl_get_device_fd(struct
>>> vfio_group *group,
>>>           goto err_put_fdno;
>>>       }
>>>
>>> +    if (group->type == VFIO_NO_IOMMU)
>>> +        dev_warn(device->dev, "vfio-noiommu device opened by
>>> user "
>>> +             "(%s:%d)\n", current->comm, task_pid_nr(current));
>>> +
>>>       fd_install(fdno, filep);
>>>       return fdno;
>>>
>>
>> Do we want to support no-iommu mode in future cdev path?
>>
>> If yes keeping the check in vfio_device_open() makes more sense. Just
>> replace direct device->group reference with a helper e.g.:
>>
>>     vfio_device_group_noiommu()
> 
> I didn't see a reason cdev cannot support no-iommu mode. so a helper to
> check noiommu is reasonable.

This check should be done after opening device and the file. Current
vfio_device_open() opens device first and then open file. Open file is
group path specific, not needed in future device cdev path. So if want to
have this check in the common function, the open device and open file
order should be swapped. However, it is not necessary here. So may just
drop this patch and consider it in future device cdev series.

-- 
Regards,
Yi Liu
