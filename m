Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433D163A4A9
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 10:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiK1JSy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 04:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiK1JSx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 04:18:53 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292821659C
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 01:18:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669627130; x=1701163130;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AWLgRNNImLztBuixpvQ+eN35iMl7HRP8iYflHf2QL/Q=;
  b=DVHljwBXX2Asd+691Ama0j9kmJYOMiIUzA5PQB6nNZsIDhTzbs5tK4nj
   4YVUUSzM0O0Cn8SuYNf0KMGrE//TUcz42WNvikezcFhvsW5GVG3DcU/B9
   01ia3JNjaYLJYCCcCokcHGjEQh9lmIFwvAvG4qX4Jz783aGzbSFkQj5a4
   IEuD6k1abqKzNjHUnGcD/gcrmPzZv+9LhgJnCLa4DSlVZFHWpjlZvnO/u
   WXBe5Unt1qRQ2SSdi8MxAbHEH5FuoUd8bADrjE0qOkaOgKrm2idbVw0hF
   dVRD2ihb0TjOlyqbux+WExXKk2VbHbNO/ZaJx3i7t+RB3a4PMPvOGuaMS
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="314823445"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="314823445"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 01:18:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="972188859"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="972188859"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 28 Nov 2022 01:18:49 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 01:18:49 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 01:18:49 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 01:18:49 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 01:18:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NvjLUldlJw6qDGzkP14Qog1B8yoaXV1hybaHiwGe46T089uyLLlloM4kZI8AIUvFz9/i27guRfSv8Pdx16/Fsq6RXLcNqtJdzudeTREnqux3jCiC6Zr1tZ+K7D6yKalHFPAn+xcR+eOHZCxFPzw3NB+mC4/eqKJM9ZohMq0R+IBW4R2BD0k47O2e7xDQ37r1DxWfKUJrBxYI9uHnrvQTwqR5uk29TaBE8oCcRcHd4oZ8rcO5RJ5hcfjiVK1rMHilxopzjlaW5fYmO0xfr0t/WwyVvBm3XHE36BIblN2xtUandVHRQ0pJNNtyloUjEt19UnulCi8ib3/rwhu1IcUJzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=urQm9YhQq4XOFballrpnYI+vCKXbA055MasJ4PDzCQY=;
 b=BkgX53ICoyAwNLi3pIQY3aZr+G8DkoEi0SCwu9IPliGiZrsyX2/tb6e2f5G5a5CNGrx+WMY4yMm+zNe1BPQjZPobOlozXB4+B429fxhcJq10PMb3VKFVPW7bD5CURjAj5ae10oC3UYI6sBBiLfMi20icMFeIiGFu1tEov/N/O2zoAeGZYKHJkVtXMFMAhLPqC0nvzJVUzdzyzpQ7BD04GVuBz/1HhtJ5FU9Krj72e9hFN4EIVp1JHIa5G3BR2MTTExn23P2Hub9on5akU3Bm3IM5PdWS1fWs6fmXNk/pWpdk3HNhtSXX0hGTEJYPKCSdxOGWo5G6OuCHTmkk9AHN5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS7PR11MB6013.namprd11.prod.outlook.com (2603:10b6:8:70::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 09:18:47 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%7]) with mapi id 15.20.5857.020; Mon, 28 Nov 2022
 09:18:47 +0000
Message-ID: <28861625-d500-e5e9-98cc-d1ea10fe06b6@intel.com>
Date:   Mon, 28 Nov 2022 17:19:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC v2 05/11] vfio: Make vfio_device_open() group agnostic
Content-Language: en-US
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
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276CD3944B24228753883418C139@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0016.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::17) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DS7PR11MB6013:EE_
X-MS-Office365-Filtering-Correlation-Id: 70d3f94c-19ff-44f8-63b3-08dad1218dbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RihMRUkSF+c1SwB4uLWuz+GF1bFjp5/lebeeQHq6SpkMMnQ36VPhlnRTP3YT3ygdK8se/qDyK6ZgIcGmqZ7uBboPilun0nMd8cUNVlxk1n2YV7CdcUMCHe9rGWKbjPxcY2nQOWd3py/edHuJ7zkrfRaauYT8oBMR+luaAKVW1LMjbXfowpHAwskDzO8MbRFfQmpofmYp1+687aQ9TkJhwJBORJM5XTOOwlPSQoVKYAUDuvdQgd8ERNY0paHaFbQQd2izQ9I+Xg//iUDJLxfmtpgBaOunxVnxlrHzPACpOVjGO7a9EmT+mpm6rY6PJkpG0+QVGjpvDrJtl3gIdycCBal769AMWKwyqVrfRcG7D3YpyoN4B+cxiwGLQsTTlMt/kFuf585j1eUIdXNlN45UjaJYgY+J7b776PeKGwrj8X+/q+xQQAJEibwvW2MTCttARue0aH3A6CeGQEnVofeb/pdW6KQlZYv5AJmQnsxnSbWI49D4JVN+5PiQiqQ1vnobnZRw7miX35XvVB7Ae+lJ0R8xbZvYaYeIBFqlXORdiKUXGgZiNEZBALekyF3a55m0vlv/XW8WVo/I4rin2dlGu1XzNsEPi12eiwItAtjYIZEmkCv2afQmUP966nmMXnK+vsR++RYB7XAonT45jlonBBCBZ4VlKlVoklS+CTMMLXJoHaX0D/v/0V+9ZZlkQMNdmxhrhHmXiGaw/TMPrV2/pDBVIoaZtp6051nxk/aW0Yc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(396003)(366004)(136003)(376002)(451199015)(2906002)(53546011)(186003)(6486002)(478600001)(6666004)(6512007)(26005)(6506007)(36756003)(38100700002)(31696002)(82960400001)(86362001)(83380400001)(2616005)(41300700001)(31686004)(66476007)(8676002)(66556008)(66946007)(5660300002)(4326008)(8936002)(54906003)(316002)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2tJZGUwaVIybXhpQnpNNjRMN3V2OTdKdVYwWHc3VmwyRDk1NDNYdTFPRHA2?=
 =?utf-8?B?NDIySHNMUG00WUtncjFLRFdlZ1h3NGdRSGtKVWZnLzk0SUkwYk5VQkoxaXBX?=
 =?utf-8?B?Q1NNMDA3TWVIS2RKcWJUS2JucWh0TFBUOWtrZGpLRVd2TG5ZWEVYQnFWRDIx?=
 =?utf-8?B?ZnluUzhVcGdCZkNyaGtreUtNK3hJdU0vMDliSW9XcmliL00xTW5iTVZTcVJt?=
 =?utf-8?B?ZlcyV0drWW90ckdEdjE2eE53MFdxMVNVZXg2NUdjclMyUjhRQWl1U1kraE1l?=
 =?utf-8?B?NlFJZ3VWbXdCaU9PeGtvRG5mNHNpSk9yWGppZVA1NFFmUmZ4Z29DUGNMUFJI?=
 =?utf-8?B?bXNXbDJRcnBZMllWblErT2hTbE1kQlhQQWlneVBubzB0SWRCdmVvSzVxcjNz?=
 =?utf-8?B?ZjBYODVGSWV1cXMxWU1zNVVyTi8rSmhtWldtc3kyMkt0WFpKUnZ1ejZSSUFy?=
 =?utf-8?B?THp2Q3RGR2hXUjJEMVNiTnRKcXZGazMzU0pOS0JFWFhzZnNXNWp3WmF2ZmFu?=
 =?utf-8?B?am9jTUw4b1lxMi83Y2JKeWR1SDBOTk95TGx5SStTSk8wVllENXlENnpSdjQy?=
 =?utf-8?B?TTF0ZlJIYWg2bHFZaUhFcDIzNDBRMEZ6aDlWUkl5cldITDB1S2diWGpEKzdz?=
 =?utf-8?B?aXFISDZtK1V4VUtERDRacGh6NWdzbHlCN1N6ZzJSYkNkNi9WTE9wdHVRTy9h?=
 =?utf-8?B?NGowcnl6UUc4Yy9yMXRkbDRwU0QzdE42Zkw4QlhCU3FvY1VubGozbFpocmhm?=
 =?utf-8?B?VnNrazhUc1pxWGkvOGpJQXRNUUpCbUg3eWxoVEt0RWJGRDJJMW9wMXd6ZFor?=
 =?utf-8?B?eDN3bU1kbG5xQ0hvZ09ESjRlTkJVVmxwa3pnUDJ0RGd3ZjhORGd6UVN2VGZj?=
 =?utf-8?B?VDI3YzdVNGNtT3RVd1VtTUJKbWY1Y1FlQ1hVb0Q4U1pBcGtWdUpBZ0lvYmdp?=
 =?utf-8?B?Y1pRa2pUanFvd2xVWDlWWVlmamVLZFdqaHVLcitaNHA2RkxpM1N2dXNTK1Bk?=
 =?utf-8?B?ckNTaVQvc0EwYjRPbVJ2Tk1VYmhoZ0NkUkxQcW9XeEt1T3BJRHdvaHZHSHJB?=
 =?utf-8?B?TmlkTXlhN25GZFordkFpRjJlL05ubi8xNG9sSVU4YkNzRnRtaWRiSTNjNTFi?=
 =?utf-8?B?WituNURNdnlybnZmZ0hMUlFPQUNsWTJXRTQ2VWZYZ2JLMFNhN2hISEw4cjRL?=
 =?utf-8?B?bTEvdVNGTVV1RjVOMVl0Tnc0L0dSZFc1c3o2cjNMTW5GZGFKV05ZNnNnam55?=
 =?utf-8?B?RnJzZWtlaTdyNXMwb29SamVXZ3Y0ck5CU3RpUlN2b3dOVTBTQUFwVllodVlT?=
 =?utf-8?B?L2RSb2Y5UEdSUVJ5bXJOOEttZzhNVERWditFd2JRNHJkcWtpbFNsTndiakJr?=
 =?utf-8?B?MG1mUHNtZnplZCtaVVhHRDdLeDRVNGZPWXdrbHl2YTYvNG1Yb1Q4ejcyQ0VF?=
 =?utf-8?B?U0paVWdkd0RHUWlqaEw2YkFOdGpFbXV0VkxwQ3JpTHZ6bFFJanQreDU2ajVp?=
 =?utf-8?B?MUdFb1c4cmt3b3M1U2ZHdFRyYVJXSXVGWndRMkV5NWQ5aVJNTGpOemVsQWEr?=
 =?utf-8?B?alhPVSt1MEJOOXNjQVFpQmdsNXc1NFBTWkJXVnRHOXl3eTgyWEV0MFU0bWt0?=
 =?utf-8?B?blVGUDErZjNUckd2ck94WkNzaktMMG80blREL0xBV0IrRkdsVnJZdUh3NTlU?=
 =?utf-8?B?cDBoZllPcnEyVk5KVG5rOEFDNjFDSE9Xblc2d1RNODFpZXN3Q211RE01V21R?=
 =?utf-8?B?ZTIwRmtCMEFQb1RRTWU2ZC9UQlB4cXpoNE04ZjFWL2plTDc5MHU0UzlsNlJ6?=
 =?utf-8?B?RWYxRHRtMU1SLzFuVm5zQy9NQWJFZWNBWlBXN1hkZG5WZDBDSElqUnp6VGVH?=
 =?utf-8?B?REgrSlBYYWdkaHZSREZlclAxOTNPblVlWTZ1aUhSUUlWbWVJdm1FallOQmYr?=
 =?utf-8?B?ajR0VkhQREFQMGNMU1d6dFBJSTZydTJHdFhOTzdFSGtpZDV4YWFBUjVYMzNo?=
 =?utf-8?B?S3NpT3BJUGFqZUM0VGRSeHNuQjNSNnVPRU81bWR0VUNrMWhWQkRJT1dhd25h?=
 =?utf-8?B?K3E4bTEzWWMyNzQ2S2c3bUpwcTRld1NjYXZuOWYyS1UvdTU5RzlGelcwa3Nj?=
 =?utf-8?Q?p03gh9chlWWIlHufx5HLsiutW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 70d3f94c-19ff-44f8-63b3-08dad1218dbe
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 09:18:47.1661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5B8tj0M4cCibcD0RZcc9seN0m9/xtyH7UWFLpixsOuKeqtIfYjgCzqLHvtlD1NrHAjGYMXrQ0L7PXHlfXusAGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6013
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/28 16:17, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Thursday, November 24, 2022 8:27 PM
>>
>> This prepares for moving group specific code to separate file.
>>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> ---
>>   drivers/vfio/vfio_main.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
>> index edcfa8a61096..fcb9f778fc9b 100644
>> --- a/drivers/vfio/vfio_main.c
>> +++ b/drivers/vfio/vfio_main.c
>> @@ -878,9 +878,6 @@ static struct file *vfio_device_open(struct vfio_device
>> *device)
>>   	 */
>>   	filep->f_mode |= (FMODE_PREAD | FMODE_PWRITE);
>>
>> -	if (device->group->type == VFIO_NO_IOMMU)
>> -		dev_warn(device->dev, "vfio-noiommu device opened by
>> user "
>> -			 "(%s:%d)\n", current->comm, task_pid_nr(current));
>>   	/*
>>   	 * On success the ref of device is moved to the file and
>>   	 * put in vfio_device_fops_release()
>> @@ -927,6 +924,10 @@ static int vfio_group_ioctl_get_device_fd(struct
>> vfio_group *group,
>>   		goto err_put_fdno;
>>   	}
>>
>> +	if (group->type == VFIO_NO_IOMMU)
>> +		dev_warn(device->dev, "vfio-noiommu device opened by
>> user "
>> +			 "(%s:%d)\n", current->comm, task_pid_nr(current));
>> +
>>   	fd_install(fdno, filep);
>>   	return fdno;
>>
> 
> Do we want to support no-iommu mode in future cdev path?
> 
> If yes keeping the check in vfio_device_open() makes more sense. Just
> replace direct device->group reference with a helper e.g.:
> 
> 	vfio_device_group_noiommu()

I didn't see a reason cdev cannot support no-iommu mode. so a helper to
check noiommu is reasonable.

-- 
Regards,
Yi Liu
