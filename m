Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83C14662923
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 15:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235799AbjAIOzR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 09:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236456AbjAIOzK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 09:55:10 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5FC0E25
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 06:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673276109; x=1704812109;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LekaTX4QvwM05U0xt2Obcv9FW21AzNrGBScxVDildKs=;
  b=OJYjIriOSvv8fI1vG6TXQlXK9EOg4mg3hqkBey2tCq0J/BC7LesPF9xl
   Ck5P8Ob5Sj+iBXgsz+RHidg1IoT4rk2T1Gh/LvjkaI2nYmZT+bf4dlbQy
   xyTgKG5V+kC814GrWH205/CM8GUMn8ESu1QtC+wRk7xdG8pfHQOEvFLav
   N3Tf6a+k8eDCJx1lyHmJJTpKwZFlwhY4hz97XOZZSx917IRvoAtMjOEcG
   eQy5IB1dlqbwUiMQwtO1CFdH1SjWzzPSGggfLeuh7K0kidj05oqzs8CCh
   8HMsu7pAypuQ1YzNN94RhXc3C49Y33ESpkTx04iXatZLoQ+qL0rpECRkk
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="324133753"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="324133753"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 06:54:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="656702388"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="656702388"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 09 Jan 2023 06:54:47 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 06:54:47 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 06:54:46 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 06:54:46 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 06:54:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bIijJrVVR9z8ZHEDqu9lDm5Uzw96jVtnKJIS8IrHjMDtSfkjvV6bN7QWiFzFdyg1+A/6o4EB6vZDmSCq7IYnBdajFosAnofNDvY+qXRoXHNwht64gtzC9OSpugFIZ8zXAxFmyYVR5+wuY3hYjzyJSqy1BHw2j6grmovGbc7J0VCskjxlDwf0ivBUOdxraiUrhyQUewiGcu2hW3NjD9cGqr6gysMFR/Ut4coSvo7/n7vXbO9O/2/HyC95HARfUxQcQp5SqdFdrmGzRAGU5tfYWPh8DcwwiHdgTtm6R6YqXMmDdVmrPb3KMEFwLKWzGeVe9rrqzoDhkXQn5i81fh8rKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PZbbz4xoEy3gWoYdpqETUGopFVv8z1VFu3odhV4RtC8=;
 b=TuistRKGSa7ObUh7Cj90pqKZmzP+w1UvfbFowsOvNsDOy9U2HC0jV1KCG4ZJMacpe4KPa1dkZ3dfLrPcU6ulEHNYwtqheuxQiwAD0UfhhOITmRxU/F8WePVp5lhVCxIZtuCe6ogtP+xZAtKhBk+3AV43cqzzcH0L9jB+xFgSxJuOJEM4AvOJXcQmhu6bCALKm1j2JCYIbhKIiaW/tV/md9uVxfTAMrOHNdBx0s7aH5ojI7JKdTM8Bqv/EEd7o9MoBesTicmbb9vJobE89r60Ppvb8LqQKNQlMxFPsXmeTmBovPMew39xrtz/9ZBKqs9C7lE2/Hp5XA1rz/nwwOblhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB6352.namprd11.prod.outlook.com (2603:10b6:8:cb::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Mon, 9 Jan 2023 14:54:44 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 14:54:44 +0000
Message-ID: <aca8f7dc-4360-9ee7-09ca-b534bbb63d35@intel.com>
Date:   Mon, 9 Jan 2023 22:55:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC 11/12] vfio: Add ioctls for device cdev iommufd
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
 <20221219084718.9342-12-yi.l.liu@intel.com>
 <BN9PR11MB5276E47BF63C4553DD4C0F4C8CFE9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276E47BF63C4553DD4C0F4C8CFE9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0041.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::10)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DS0PR11MB6352:EE_
X-MS-Office365-Filtering-Correlation-Id: 1752b54e-8e02-46df-b5e1-08daf25171a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SC2zBss2xn594Wdj2oeRLXNpzFt9tcCZZ0TEZ3R7B77mJuTfCtjmUuMwOz6/05mzDnFliMjIhc8zhrUPRstwooUjg5IurBKE7DB4gwq8Q6o/+8k50/0CcHj4LkmR7WKygp7Go37Kwfik1qMI0cKBeds0KTvMJjIzMMda28DRWQhpvrhc7Yt05mE+4atrVRBuMSZ5jAjSyJiOBxGXnJ/Z82Hx7SGUjTO/BN7wAPFxEyuONFBDXGoENf4NFhU2woA3pmYPO/4F3BD34XLhwYuypXjaqe41tOVhDCM5HWLIYKKD8DoukpGwgoh/AlnnVS8HzlMeeIy75cteQUPGhGoWUzDCDPZxom280B42EQRmOdEwRyQWXJ+Zavsf0jYwjA64l96B7sS33Ag41AIL+V+sFxKgL+SAJdQNgBcXVSDq7vcHzuEP9wLn5Ldh4rw3o6u81Q0q1W3zW5ej1mT2UWgXcptQe9jyAxVkwSTtFZntEFSMwmwxCcn0C/W/WOh9Tkn7zsG9mJzkCkV0VgI0NcyWF7/WUw7fL0dQYoq/rW2z+6c/aUUWiSX0hv32uGazf+W64Lr9YYjaWFozbgLvBHXmvLK13zWmt9a9KIl6ShnIUHnQe3hJhss7r4b9uvX2r6W3CNQc/Tx0tUeUNVl8TeDmFMQq0Y2YNeeYbsLDrGfI8vf0waGL3a3BrmQzeoqvzRO+g/3M5T9wJfW84lv6NG2r9ApVrxf2Ng9YUCOxw+PkvYk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(346002)(396003)(39860400002)(136003)(451199015)(36756003)(86362001)(2906002)(82960400001)(8936002)(5660300002)(7416002)(41300700001)(83380400001)(31696002)(110136005)(66946007)(54906003)(31686004)(66556008)(53546011)(6666004)(6506007)(186003)(38100700002)(8676002)(6486002)(26005)(66476007)(4326008)(316002)(2616005)(478600001)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eUhpZkMxcStJWFQxRWRTOTNyY2l2VDVRUnpEWXdLa3ZKQzZ2TlAzNlNkRTRE?=
 =?utf-8?B?STZwRTQ5Q0ZzV3htMTJlV3MxS3Vad1VIMjFjRDdkQ3hzaUNFNTNtZ1pyYVo2?=
 =?utf-8?B?VWdveUIwVFptV2tnR3c5OCtjek02S2hEejgzd1F5cXpZNXlLT3gySXdFL05U?=
 =?utf-8?B?SDg2MlpONEZiRFRZMmQrMmorcWNreGRKRXd0enVRUmlJcGF4ZHQ0RXhNQ01W?=
 =?utf-8?B?WEsza1BveXRWSndHYm51SWF4aUMvK3JWQk5GTXJCUmhYemt2NGNkaHJPcFFI?=
 =?utf-8?B?NmVsWHpsendjTnZQRjRGUmhBTFJmK3lnTlVscE93RTRSQTYxRkppQ2VSMDRz?=
 =?utf-8?B?YjdsRkNwVUhSWWIwdmV5aC9hdTNoRUhWTHBURHFqNW1ocFY5MjFwdW5uRU53?=
 =?utf-8?B?ZGhyZWFJeXkrOFc4R3d4cytUb2dGeTk2U05sVEFaVnljSC9zcmJnMCtJSVAv?=
 =?utf-8?B?amczQ3FhWVl0WXNVZ1ZtQlRwaU85MzhoMXhSSVJGMEFlMzBIMW9KNEIvV3JE?=
 =?utf-8?B?U1RpbGp1eUhSLzc1bVMyb0RBWWpuMTkzbGN0ekt2bXltS2pGdThFVkJCa0Zk?=
 =?utf-8?B?SHUyVkYxZ1hPeXdDano3ajFGSWI1Y2V4VFg0eXBzeHJvNEk2VmU2b2pKNWZQ?=
 =?utf-8?B?ZktNUThSZ3B2UmpIblRMQUQ4TzhkSWMzWlNab2NSWFp6QS9YMWZ1YmJCSlhD?=
 =?utf-8?B?bDBIbXZLYXpCQXB6aHAwU24reVlKS1hoRlppblVhNi9GcmZONWNZVWljaU03?=
 =?utf-8?B?RXhhLzdvSml5YnlYRXRvekEwd1V4QXZ6ZnBlTWJGSXZuQ2tXcHdtV21MajBq?=
 =?utf-8?B?UFAwblNpbWhVMVBkTzVJZHZWZTVDU2xnQVlwTW9NWlhFTm1Va1k4WHg1cFY4?=
 =?utf-8?B?ejM4Sm01azRkRUlINTJjODdzN0dHK1BYWS9lbzg4KzVYUmQ1dHNhbTZsVXV4?=
 =?utf-8?B?MzFna21JZ1c2MHNKVHNucFJwN3pPb2J3U2dXekQvTjdCRGVDNVBjNXJlRWQ2?=
 =?utf-8?B?dTV0elhZdlRYTlJzcDdxRHFKOTYrUHN2bkpETVA3enhZL3MyOC9hQkVuWTRV?=
 =?utf-8?B?NXNxL0VLSHBXbDk4NWtnaER5RElTQXAxUlRFYVRvYWQ5T2VhNHY4Ymw3d2lK?=
 =?utf-8?B?RjVYbGtRazdVMlYxSlJ5Um41MEFtOWg2U0N4SGk4anE4M25pMG5MT2NmcHg4?=
 =?utf-8?B?VWg2SURJZkVlODRNTXJHS3huU2JRUlRPbDVZNUt0cUJ0Qk9yS0VTRFVLTTRB?=
 =?utf-8?B?UzNTNkk1UXRGeEMxSE8yS0tpeDdZZkY2M0tCeThSOVZBZ3ZOZUZWYTBWYzFJ?=
 =?utf-8?B?SUVlWkk1ZHRocEpMdjNjOGNKdzRHb3QxK2REU1JmVXFLUVlYbzFEdmZvZjNY?=
 =?utf-8?B?S2IwMnJ4Zmd0MmdXRzM5RVFETnh3Z2JzZWlNaEt6YTgrVjgvL084bVhsOFM1?=
 =?utf-8?B?SWJVaDMwVkpPeEo3RlpMY1ZPdWZWY1c1L2lzbCtYWnRKdXRuZkRXSllsMFJT?=
 =?utf-8?B?TVRQTUFVTTdCYkRndE5PalR0SERJbHhqQ1RPRVdRdDcrTGhSQ05Fb3RRQWJS?=
 =?utf-8?B?ZEdycnA2SnRBVnRPRXVudXRwcTFUYXZBN1NyU3dKRXNWdVZpN296eW9ULy9s?=
 =?utf-8?B?UDhyQmRYcVp6RVFXcC9ScWY1Mjc0bFUxblJ5TXlkTGVhYVB0Vms0K2pjbk9z?=
 =?utf-8?B?VFo2ZWR5SHVVOXlGSFMvTXk2Q2VNZmVEOGEvL29QMkROa2JGMUZUT1JuS3Np?=
 =?utf-8?B?MjlGb3MyT0d4dXhrN0VWRkd2dGxlMVYvdGNuc0FaL1JBNEhUQWtRellVbUN5?=
 =?utf-8?B?SGJJY21nMG5WVjBPbitJRUZ6Q0V2SzlONmJkQ1VGOTJkdG01cWNXaHo0NENq?=
 =?utf-8?B?aXZKRXllYjZSVVQxMTh3cHA2TzFVblk4YzBHVGdzSERvS2VZdW50QTNYZndq?=
 =?utf-8?B?dHc2a3pIRTQ3TkN1T0tPSktoZ1h0OVZ3M1NHbnFNSllGQStmb1U0eCt1Yzd0?=
 =?utf-8?B?SW5kWDljaVVsT0o2ME1hZDE4NjFzRktTSXM3QUJtZGYxNEt0MTV1T2RYd0xi?=
 =?utf-8?B?eHZPbTQ4Sk1PV2dmVEh4dlRjZ1dLdHhEZUpSdHhqTDVPT1NkdEdGM0xNVjB3?=
 =?utf-8?Q?wf/WY3XITPa9zzNiNi6aoCqpL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1752b54e-8e02-46df-b5e1-08daf25171a4
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 14:54:44.2532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SLItWUB8286IgBo1No0zG84aHxVfTx9P/2ly4hXHcqerjrEFxyx3SO1JNngvidA+QydF+xXol0dQzqPNXZMgIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6352
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

On 2023/1/9 15:47, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Monday, December 19, 2022 4:47 PM
>>
>> @@ -415,7 +416,7 @@ static int vfio_device_first_open(struct
>> vfio_device_file *df,
>>   	if (!try_module_get(device->dev->driver->owner))
>>   		return -ENODEV;
>>
>> -	if (iommufd)
>> +	if (iommufd && !IS_ERR(iommufd))
>>   		ret = vfio_iommufd_bind(device, iommufd, dev_id, pt_id);
>>   	else
>>   		ret = vfio_device_group_use_iommu(device);
> 
> can you elaborate how noiommu actually works in the cdev path?
> 
> I'm a bit lost here.
> 
>> @@ -592,6 +600,8 @@ static int vfio_device_fops_release(struct inode
>> *inode, struct file *filep)
>>   	 */
>>   	if (!df->single_open)
>>   		vfio_device_group_close(df);
>> +	else
>> +		vfio_device_close(df);
>>   	kfree(df);
>>   	vfio_device_put_registration(device);
> 
> belong to last patch?

not really. In last patch, it only adds the cdev, but no ioctls.
Only when the BIND_IOMMUFD is added, should the df->single_open
possible be true. So I added it in this patch instead of last one.

> 
>> +	mutex_lock(&device->dev_set->lock);
>> +	/* Paired with smp_store_release() in vfio_device_open/close() */
>> +	access = smp_load_acquire(&df->access_granted);
>> +	if (access) {
>> +		ret = -EINVAL;
>> +		goto out_unlock;
>> +	}
> 
> Not sure it's required. The lock is already held then just checking
> df->iommufd should be sufficient.

you are right. check df->iommufd is enough.

>> +	mutex_lock(&device->dev_set->lock);
>> +	pt_id = attach.pt_id;
>> +	ret = vfio_iommufd_attach(device,
>> +				  pt_id != IOMMUFD_INVALID_ID ? &pt_id :
>> NULL);
>> +	if (ret)
>> +		goto out_unlock;
>> +
>> +	if (pt_id != IOMMUFD_INVALID_ID) {
> 
> it's clearer to use an 'attach' local variable

not quit get. We already have 'attach' in above lines.:-)

>> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
>> index 98ebba80cfa1..87680274c01b 100644
>> --- a/include/uapi/linux/iommufd.h
>> +++ b/include/uapi/linux/iommufd.h
>> @@ -9,6 +9,8 @@
>>
>>   #define IOMMUFD_TYPE (';')
>>
>> +#define IOMMUFD_INVALID_ID 0  /* valid ID starts from 1 */
> 
> Can you point out where valid IDs are guaranteed to start
> from 1?
> 
> According to _iommufd_object_alloc() it uses xa_limit_32b as
> limit which includes '0' as the lowest ID

xa_init_flags(&ictx->objects, XA_FLAGS_ALLOC1 | XA_FLAGS_ACCOUNT);

yes, but the xarray init uses XA_FLAGS_ALLOC1, and it means to allocate
ID from 1.

/* ALLOC is for a normal 0-based alloc.  ALLOC1 is for an 1-based alloc */

>> +/*
>> + * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 19,
>> + *				   struct vfio_device_bind_iommufd)
>> + *
>> + * Bind a vfio_device to the specified iommufd and an ioas or a hardware
>> + * page table.
> 
> this is stale. BIND now is only about bind. No ioas.

Oops, yes.

>> + * VFIO_DEVICE_ATTACH_IOMMUFD_PT - _IOW(VFIO_TYPE, VFIO_BASE +
>> 20,
>> + *					struct
>> vfio_device_attach_iommufd_pt)
>> + *
>> + * Attach a vfio device to an iommufd address space specified by IOAS
>> + * id or hardware page table id.
>> + *
>> + * Available only after a device has been bound to iommufd via
>> + * VFIO_DEVICE_BIND_IOMMUFD
>> + *
>> + * Undo by passing pt_id == IOMMUFD_INVALID_ID
>> + *
>> + * @argsz:	user filled size of this data.
>> + * @flags:	must be 0.
>> + * @pt_id:	Input the target id, can be an ioas or a hwpt allocated
>> + *		via iommufd subsystem, and output the attached pt_id. It
>> + *		be the ioas, hwpt itself or an hwpt created by kernel
>> + *		during the attachment.
> 
> Input the target id which can represent an ioas or a hwpt allocated
> via iommufd subsystem. Output the attached hwpt id which could
> be the specified hwpt itself or a hwpt automatically created for the
> specified ioas by kernel during the attachment.

got it.

-- 
Regards,
Yi Liu
