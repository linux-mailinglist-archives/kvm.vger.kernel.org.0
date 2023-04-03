Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1156D54E0
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 00:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbjDCWvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 18:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbjDCWvC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 18:51:02 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADE52724;
        Mon,  3 Apr 2023 15:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680562261; x=1712098261;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oHRuRLO1NtTOl9SGHLjCZnpzZQN1S8fPiLY29D6mcv4=;
  b=mLzo71WD5SwWNWamJg+Ld+TYPVJHreVotrocFcoIhMGYpCyaAL3rNXaW
   R/9vcWhJZw5TtpfnfJmc1NItsGvRo0njIHKHQutM0SrjIpMszQ0S4dmDh
   OBWb9SxcHlNsscgJcDzTzjgxjLQhI8UF7sFwGdhO8/jYyGid7GB0fHg8D
   bAsjzR4bPOy1jRXeWWeE0eS2ph8t3wxMDevV5IrYVTjY4YpBRX96H4Ma0
   m8MX29zcf/1+hdVpCHnj8iFsuS9v6BlT4ghFZTylHS+NPDpynMlSnSCSO
   1hIT/WGubr8ycGasvPfgEE27y7ooSyeA4XIK9J00c6if8+Yno5OWRT+FP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="369845419"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="369845419"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 15:51:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="688655496"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="688655496"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 03 Apr 2023 15:51:01 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 15:51:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 15:51:00 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 3 Apr 2023 15:51:00 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 3 Apr 2023 15:50:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pw6Vhd2ttpRG4LLgSPs5a9y8munIzGcoO2sTJP79KkIkUIjaQLJ1yGCc0U6psBBXB7yR3ncOapuPgKwTVUE9W1gjeKnFGoaXgYbeVuiEyQzeQyDUshgxr/5jGm7gG3/jSTt+wTIfJkJtSi3S5Ver5Gv424PTsT6ew3lq/ylTq1J+XUc7FdzRzmANjmeOvfvI92307pjHEK1PsoPzQ5JRykRidsxCSS1BSnOt8CEwgO0z1JRhfxAsimkNByIjcOvT8N7awqnydv1KsIJoLcN0UqvL+VMvOPX3jday83KPXLUNLbmpXSR2LFiAsV7oZza2qHDpPLgesG6mdYXNEzR+4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CINsLeEPXp/eiCynlikRHCAvcSbczN4AFpoGnlp5+Oc=;
 b=UL/inZB6VWyb2JfrBqGN90Vyez6bSGP7fcHZd1In3TpIqjPJ3MQ4vu0JZMLzofKQaMY9glmhhzwDEM4LT8CAEf6FyLzBf30bq6EVmIjmn3qdAtyKT/w0Gd3yfswuBRfxPDtC4DOFvQZtmCpqgsNtkX/xTCAVPT6evV4KuuQqPK0NMWzzXUtY9QAcamu2NUinJtu7p2OsFe7nrJhGsuuAdqAdUHQKyo2HdP98ajtNNwwcaYy/ULFZJFAjhHyLdkQjHlYVyCxseK4tsWmUkxLgXdt11zV26qDNUwQVyPLwOE8G1q5SatHbQ5eO4vuROX+PE2EsnokoTzE4ESo10ti1FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by SA2PR11MB5097.namprd11.prod.outlook.com (2603:10b6:806:11a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Mon, 3 Apr
 2023 22:50:58 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f%12]) with mapi id 15.20.6254.033; Mon, 3 Apr 2023
 22:50:57 +0000
Message-ID: <57a8c701-bf97-fddd-9ac0-fc4d09e3cb16@intel.com>
Date:   Mon, 3 Apr 2023 15:50:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH V2 7/8] vfio/pci: Support dynamic MSI-x
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <tglx@linutronix.de>, <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
References: <cover.1680038771.git.reinette.chatre@intel.com>
 <419f3ba2f732154d8ae079b3deb02d0fdbe3e258.1680038771.git.reinette.chatre@intel.com>
 <20230330164050.0069e2a5.alex.williamson@redhat.com>
 <20230330164214.67ccbdfa.alex.williamson@redhat.com>
 <688393bf-445c-15c5-e84d-1c16261a4197@intel.com>
 <20230331162456.3f52b9e3.alex.williamson@redhat.com>
 <e15d588e-b63f-ab70-f6ae-91ceea8be79a@intel.com>
 <20230403142227.1328b373.alex.williamson@redhat.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20230403142227.1328b373.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0052.namprd02.prod.outlook.com
 (2603:10b6:a03:54::29) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|SA2PR11MB5097:EE_
X-MS-Office365-Filtering-Correlation-Id: de01c2d6-1367-4997-22bd-08db3495e32f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oWUqhjx8mKJROpBaF1ktflY2DyZ6fWcdksX5+4w0h+gjJ5Sq73yZQkmdBQnuniCqhIrIyQvlLjDc72TnxELo6twgw+2scMrO9sJKnIo5D8ZU6ilIUFxzSaxdbug3w0cs+Ih0x1spzGdyynARKfeMEPpLm/zJWwQxcYYYfMKJz46DY4WKwPm77pk5GcphSoLb8TvVeLC4W3HTsc2b1CYZG2BympL1P/24dHAm+t7bYQDNKRtCpLp+gcWjhY2vpOxDnhXsArB/8iAeH62/NNzWqMmRYaWdWGuNOHU7nWb8pw2QxLaI7SqT/uaLTmeWdO61vg1S+z3maWqRabimaDTWOWz91Ek0gVJ1/52iix48u/Lo3Uea2zfs6buXm+cBBWGfEeZ1yOc4Wm1LM7aI//+5kxp7RucHnaSY4/Q4VhxRNAxwhPO4t7RDo6uFQEHLe1NBGO9zdDoH9aFoiXjruQ3i6rTsUCN0sMhecHcoIgvtKZYYyTESk7XhroX3MF0aHlYJgcUPqb9/h+NN3Jz3r5/Gx224q5CUD1xZXcsVyToDel18uJn2IOeoqBW69SzmNAYB/gg1bSCPJbPPEjl8SrnUUG+SsRSkBetdz9luJMBvE9yLZSQAgKfWypDefKFkBpIJw5XjF8bWF6W3aFBIN7XWhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(136003)(346002)(366004)(376002)(451199021)(86362001)(31696002)(36756003)(2906002)(31686004)(2616005)(53546011)(6486002)(83380400001)(186003)(26005)(6666004)(6506007)(6512007)(8676002)(4326008)(66476007)(316002)(66556008)(478600001)(66946007)(6916009)(41300700001)(38100700002)(5660300002)(44832011)(82960400001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ME5BQVFpU1p4c3NleFlrM1NxSi9rREhKT0ZNcVU1UzBvZFdmcFc1N05Lcldv?=
 =?utf-8?B?MFhNUDFmeGNxajQrT1NseE43R3ZKYjlMYzdDREVQaWVHcVdjeDlGNnFvRlVI?=
 =?utf-8?B?YVFveEZoa29GSXFzanlCeng3ajh4ZWM2UU9WV2M2cXBYcDdNOFUrVnJ2ZE1Z?=
 =?utf-8?B?Z3NkN3F0STZEWlE4RlFwaXJUOXNjWDNoZS9rRjVjVWVVWmdreEJtbklZYzhv?=
 =?utf-8?B?Skx0NVJsdzNYT1RqdXRIcGFKNVJBaGNLNFNtVzErc3piRVlMM0F5dGlSTDNW?=
 =?utf-8?B?bHAyWnFRcGliSnRZS1ljM2J1YmdWK1FDaTdOS3dwWDJyTmIrVk9RdHd5VG9p?=
 =?utf-8?B?Mk1rYStmR3VHUjQrUEdTOWJFUldickdEVEJONGFtVXh5S0JrV2wwTUR0M3J1?=
 =?utf-8?B?d0YwSmdpR1ZhRUNjUlBVakQ4dTRwYnVMN1JHV3l3N0dpUzhkS2RsRVpQTkNS?=
 =?utf-8?B?MXZENlUwTkdVVXE1Y1ZkZHpDQkxVb0ZCNklVZVFiY3RDa0QxYzFsUEpXSzNV?=
 =?utf-8?B?VUc0R2JMbWVrOVNjQXdBb2crdlZPaklRcTRvNG5waG92QTd5R2FnaDV6WE1r?=
 =?utf-8?B?ZDNEeXBvODRGYlZUZnk5RmNZVnR1WXBBNkZjWExRUlJSeGxPWTA0VEt6dzRk?=
 =?utf-8?B?OTZhM25SWll2QjBBYURHdkN4NkI0ZUVhdGtmYndReDlLZnVZaEl1Sm1sVTNL?=
 =?utf-8?B?VXNROVpZRGpxR3V4U09JaThJTy9CWDNxTG1acVlrK2NRYVlDVkpIaXhleUhN?=
 =?utf-8?B?Szg5cnhlRmkwMVBEM0xWbnhhZjJ1b2dTY3dvNS9zQlUxaFlRQXJvRGgzWjhk?=
 =?utf-8?B?bHpsOWxmVUtlSW1jeURIVDJJTm9lV0tQbEZYTWI3WnYvOE5neDlXeDBGSnRW?=
 =?utf-8?B?RzB1bXk5eldGSlVETUxCekFGK1ZrOG5PREdqTHlDK0NZUnRDdmxaM0Fra091?=
 =?utf-8?B?MkdHdllWczg5dGNscnBkc2Ryb2FYVzFKaEkyZ3VHM2lFeFhzcC9pVGxwOVdN?=
 =?utf-8?B?Y01FQnFXb3lDSG5xdWdBY0loRG01bFh0TDd4VXJkUFhSQ0NyaDM1R015bUlF?=
 =?utf-8?B?THg5QzVvSXNEeVRYTURpaHZ5bno4eFJld2xucDZvWHRURUtFNzZpbW9NYU1r?=
 =?utf-8?B?aGliTTVNRU5leWplbjlLRzhUbU5oZ1ltL0dGUjNiVFhrUjRRQUFCbytWQnZM?=
 =?utf-8?B?c05Uay9rUXpsWk9CTkNPTzFvVmgwQnVvOFJTU0FVaTV5TjdGU2NQNGhIMG94?=
 =?utf-8?B?UmFEcnZEYXdiZ2ZsRytCN2h0WkwxcDF5OUhXaUoyaXBnN0ZDbzFWeWxqQWZN?=
 =?utf-8?B?RkxFd0pMUHF4MlUrYUNJUk1xUVJaNHhVb1Blb21rU3lNbGxpa1dQMDZKWkRT?=
 =?utf-8?B?NFNPUTgzeVgya3d3SkorelhFQWRuZFdvN0FibVJzbC9laUtuWFM2aWg0N0Jl?=
 =?utf-8?B?dTJmZkV3SjZDZko4bE1mcDNkYktydzdPazZtZ0lUVWFaaVZXTnUxYTBpSmor?=
 =?utf-8?B?ci80M2l5SmdJWnc5OVdiVS8rRDA0bjlMVm11WEVmTThmT0hHNU5TVW5KM1Rw?=
 =?utf-8?B?clJJbGwreFRqSkF6eDlsYkRtbm43cG03VjlFajNwS0sxTzA5bTlLT0FKRCtQ?=
 =?utf-8?B?dEJpQjVNV01IQmVFWWJxOTNsRUVmL3lrZEUxbVJRRDQzK0UvaFVUTlQ2UU5i?=
 =?utf-8?B?bW5jVUpheUM5S0JFZGEzQjZ2YlJNdjhUcy9abGpJNDJwaVZXK25YeW5kditJ?=
 =?utf-8?B?RUJDWjlXemt2T2F2azlTTG8yY1BPdTUxSXhRa0JQWUhMbEp2WFc0YzlZeWdw?=
 =?utf-8?B?WWZnQlBENnNPMmFYNXlTb3ZyWDhuNDIrODJlZmtnZzF3Nm9raU5FMzZVZnNz?=
 =?utf-8?B?VDFBTzIzNFlJUDdUN1p0bHB4azNKTzI2UFA0cnhjRS9kcGNEOWdkNzNlcFFi?=
 =?utf-8?B?eUJZUDF1Tk5JQ2w2SDFTbk5naDdXWEFPRGI1VGt5WGh0dnpOTXMxNFNPWTFY?=
 =?utf-8?B?M21ZamQwSldnN0tJUXY3d2FxZnVtWjU0by9IOU0yd29vbnRmdUU3Z0kzbCtn?=
 =?utf-8?B?eTJUT3kxdG1Vdzc3aHJPa2dnVXIrdTJPYTh2TUwxUDFEYVo1K2M3ZmtPTExx?=
 =?utf-8?B?dDZVd0xaVXRVemJ5ZGlSbENCQVRzMStyeldHTlBPSHJBOWRsSndPeWFvRFFt?=
 =?utf-8?B?S3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: de01c2d6-1367-4997-22bd-08db3495e32f
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 22:50:57.2281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pPhBRGKyJyVQTOHoVy+allv9PepvGpWAltIcX2ozMo/u5DK40XZFOt/OOoMSrG8Z+RS3nyxYHkddPnHLytYPLWMiHhRnca1jcnInc3xjIrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5097
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 4/3/2023 1:22 PM, Alex Williamson wrote:
> On Mon, 3 Apr 2023 10:31:23 -0700
> Reinette Chatre <reinette.chatre@intel.com> wrote:
> 
>> Hi Alex,
>>
>> On 3/31/2023 3:24 PM, Alex Williamson wrote:
>>> On Fri, 31 Mar 2023 10:49:16 -0700
>>> Reinette Chatre <reinette.chatre@intel.com> wrote:  
>>>> On 3/30/2023 3:42 PM, Alex Williamson wrote:  
>>>>> On Thu, 30 Mar 2023 16:40:50 -0600
>>>>> Alex Williamson <alex.williamson@redhat.com> wrote:
>>>>>     
>>>>>> On Tue, 28 Mar 2023 14:53:34 -0700
>>>>>> Reinette Chatre <reinette.chatre@intel.com> wrote:
>>>>>>    
>>
>> ...
>>
>>>>>>> +		msix_map.index = vector;
>>>>>>> +		msix_map.virq = irq;
>>>>>>> +		pci_msix_free_irq(pdev, msix_map);
>>>>>>> +	}
>>>>>>> +	vfio_pci_memory_unlock_and_restore(vdev, cmd);
>>>>>>>  out_put_eventfd_ctx:
>>>>>>>  	eventfd_ctx_put(trigger);
>>>>>>>  out_free_name:
>>>>>>>  	kfree(ctx->name);
>>>>>>>  	ctx->name = NULL;
>>>>>>> +out_free_ctx:
>>>>>>> +	if (allow_dyn_alloc && new_ctx)
>>>>>>> +		vfio_irq_ctx_free(vdev, ctx, vector);
>>>>>>>  	return ret;
>>>>>>>  }
>>>>>>>        
>>>>>>
>>>>>> Do we really need the new_ctx test in the above cases?  Thanks,    
>>>>
>>>> new_ctx is not required for correctness but instead is used to keep
>>>> the code symmetric. 
>>>> Specifically, if the user enables MSI-X without providing triggers and
>>>> then later assign triggers then an error path without new_ctx would unwind
>>>> more than done in this function, it would free the context that
>>>> was allocated within vfio_msi_enable().   
>>>
>>> Seems like we already have that asymmetry, if a trigger is unset we'll
>>> free the ctx allocated by vfio_msi_enable().  Tracking which are  
>>
>> Apologies, but could you please elaborate on where the asymmetry is? I am
>> not able to see a flow in this solution where the ctx allocated by
>> vfio_msi_enable() is freed if the trigger is unset.
> 
> The user first calls SET_IRQS to enable MSI-X with some number of
> vectors with (potentially) an eventfd for each vector.  The user later
> calls SET_IRQS passing a -1 eventfd for one or more of the vectors with
> an eventfd initialized in the prior step.  Given that we find the ctx,
> the ctx has a trigger, and assuming dynamic allocation is supported, the
> ctx is freed and vfio_msi_set_vector_signal() returns w/o allocating a
> new ctx.  We've de-allocated both the irq and context initialized from
> vfio_msi_enable().

This is correct. The comment I responded to was in regards to an unset
trigger. The flow you describe is when a trigger is set. Not that
it changes your point though, which is that vfio_msi_set_vector_signal()
frees memory allocated by vfio_msi_enable(). This is clear to me. This
is intended behavior. My concern is/was with the error path where a function
failing may not be expected to change state, you address that concern below.

>>> allocated where is unnecessarily complex, how about a policy that  
>>
>> I do not see this as tracking where allocations are made. Instead I
>> see it as containing/compartmentalizing state changes with the goal of
>> making the code easier to understand and maintain. Specifically, new_ctx
>> is used so that if vfio_msi_set_vector_signal() fails, the state 
>> before and after vfio_msi_set_vector_signal() will be the same.
> 
> That's not really possible given how we teardown the existing ctx
> before configuring the new one and unwind to disable contexts in
> vfio_msi_set_block()

Very unlikely indeed. I agree.

>> I do agree that it makes vfio_msi_set_vector_signal() more complex
>> and I can remove new_ctx if you find that this is unnecessary after
>> considering the motivations behind its use. 
> 
> If the goal is to allow the user to swap one eventfd for another, where
> the result will always be the new eventfd on success or the old eventfd
> on error, I don't see that this code does that, or that we've ever
> attempted to make such a guarantee.  If the ioctl errors, I think the
> eventfds are generally deconfigured.   We certainly have the unwind code
> that we discussed earlier that deconfigures all the vectors previously
> touched in the loop (which seems to be another path where we could
> de-allocate from the set of initial ctxs).

Thank you for your patience in hearing and addressing my concerns. I plan
to remove new_ctx in the next version.

>>> devices supporting vdev->has_dyn_msix only ever have active contexts
>>> allocated?  Thanks,  
>>
>> What do you see as an "active context"? A policy that is currently enforced
>> is that an allocated context always has an allocated interrupt associated
>> with it. I do not see how this could be expanded to also require an
>> enabled interrupt because interrupt enabling requires a trigger that
>> may not be available.
> 
> A context is essentially meant to track a trigger, ie. an eventfd
> provided by the user.  In the static case all the irqs are necessarily
> pre-allocated, therefore we had no reason to consider a dynamic array
> for the contexts.  However, a given context is really only "active" if
> it has a trigger, otherwise it's just a placeholder.  When the
> placeholder is filled by an eventfd, the pre-allocated irq is enabled.

I see.

> 
> This proposal seems to be a hybrid approach, pre-allocating some
> initial set of irqs and contexts and expecting the differentiation to
> occur only when new vectors are added, though we have some disagreement
> about this per above.  Unfortunately I don't see an API to enable MSI-X
> without some vectors, so some pre-allocation of irqs seems to be
> required regardless.

Right. pci_alloc_irq_vectors() or equivalent continues to be needed to
enable MSI-X. Even so, it does seem possible (within vfio_msi_enable())
to just allocate one vector using pci_alloc_irq_vectors()
and then immediately free it using pci_msix_free_irq(). What do you think?
If I understand correctly this can be done without allocating any context
and leave MSI-X enabled without any interrupts allocated. This could be a
way to accomplish the "active context" policy for dynamic allocation.
This is not a policy that can be applied broadly to interrupt contexts though
because MSI and non-dynamic MSI-X could still have contexts with allocated
interrupts without eventfd.

> But if non-active contexts were only placeholders in the pre-dynamic
> world and we now manage them via a dynamic array, why is there any
> pre-allocation of contexts without knowing the nature of the eventfd to
> fill it?  We could have more commonality between cases if contexts are
> always dynamically allocated, which might simplify differentiation of
> the has_dyn_msix cases largely to wrappers allocating and freeing irqs.
> Thanks,

Thank you very much for your guidance. I will digest this some more and 
see how wrappers could be used. In the mean time while trying to think how
to unify this code I do think there is an issue in this patch in that
the get_cached_msi_msg()/pci_write_msi_msg()
should not be in an else branch.

Specifically, I think it needs to be:
	if (msix) {
		if (irq == -EINVAL) {
			/* dynamically allocate interrupt */
		}
		get_cached_msi_msg(irq, &msg);
		pci_write_msi_msg(irq, &msg);
	}


Thank you very much

Reinette
