Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884B96D4EFF
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 19:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbjDCRbe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 13:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDCRbc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 13:31:32 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DCDC1980;
        Mon,  3 Apr 2023 10:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680543091; x=1712079091;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dCw8OhRZXBkpAIzBFOryxplmDFjVX1KRA+kYJBjr6cc=;
  b=mWaNAXzIMnQP0pMq6sWJPU9pYcX+QtJYft+n06+4WM3OBgRq/R29urHV
   b/Z8pwcpZkSoZAlGWKqOf6+i6+hQm7Vibo1OzXEGwFoZznmejvFRlaqIn
   UxfBHF74OIG2r6uFQfY+wkYSp6f3ddD43HHsN/l1qLu2/vzfCG2PPhO1e
   f9kUlsxsXoqAZP0pMAjcCSfRtrVmsNGsuu+4NSumBU46tSGW0LfyV2FZV
   1XBkcVKAswF3cQcgVooUc+34QNgAEzEIVrIKTLBMxGTQ0SE7r29jEemf9
   1WHr5aO3y/UD5q1t0df5LUUFZ4iO8auv1DYO4/cmCX5wqITwx6gxsjYo5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="340698688"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="340698688"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 10:31:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="860295148"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="860295148"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 03 Apr 2023 10:31:30 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 10:31:30 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 10:31:29 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 3 Apr 2023 10:31:29 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 3 Apr 2023 10:31:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XGq/AfuNK6wBnMtst2ffrBjwmwAE3s5h41JR8lLyFNJoi84c7fXH7KtnOcFaPuFhY7IsN9CeZZC6QKtdWKIV75NbeTrDxLCbAQs/Tg90ScTiScIXQaUbXtdTRUzei7L6HPHTKwU0v3zn3y4PB7SGYuZhz286f4CjZ7mpqww5xcB+53XP4NFXn/IewHJEIwckKQsxTaA2kjAcmAkaP4qIBjUjAAInoEUJYDwyqZuGAcz0Cfp6FLfCebF+m2UH7MEdOEGud/EtX4DH5RkeTt7uIvc4/So39P4Emx+zshtq5twQqQ7R6nIZUbkhFiHcloE3ruI1F1hvZfjDGgMeXlTvqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ayKB14AmKzTQ13GYaBV46Xv1+gE3F2PZNcIUpyFk0n0=;
 b=ig2iQs4zzMT6KuyhB/44nI8zy7xA50NeQG4P40ZzXEBM1n9wS1P1LrKW5SGm6fsYQCjlUdXEYw7wUMpfmCgzSyaOLhN0J8bpKK9uB3tWsZ+vsYp5BVu+NX6w/adX8FxGeoX3OAOwlOU2WCG/fh1gKMdEsulwueA8ru0KHtI0YuysAL6HasbpZ7/zDg4QkG5HitxwivSAnPveK55Zs0xMHsjRm+ykjxkczsPoGLHajJCDsUyTb34vYQ0OO6vcf1rxpLq7k185CaI/p2FZZmSUQJl7oKuSOdphFHCuAtCXyF64scyOU91wVhE8U8xI284der7Sqr2sX0y5Mh0mT5jKug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by CY5PR11MB6535.namprd11.prod.outlook.com (2603:10b6:930:41::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Mon, 3 Apr
 2023 17:31:27 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f%12]) with mapi id 15.20.6254.033; Mon, 3 Apr 2023
 17:31:27 +0000
Message-ID: <e15d588e-b63f-ab70-f6ae-91ceea8be79a@intel.com>
Date:   Mon, 3 Apr 2023 10:31:23 -0700
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
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20230331162456.3f52b9e3.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0075.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::20) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|CY5PR11MB6535:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c5e43a5-6259-4522-1b0d-08db34694107
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ouWZiXSFn0+KOQULausTTxqrnVdn4MlwPOXvNEBnwXqB5CEocV5RSdYLl88KQiI843k+UAMDWDKF7PwRhGlKbM9FxvgjE5f6D6Tbx36PKe0KKBg+kAjBEaXo9159hXYwT/zGGQzshJVtl3ay4AdkJf0eqy0Z9gpIzqxLuhYv2h8Li7orKcgNQzwEXv7ZrTlcpkBrwTGKMlrNfTUIZ7FZ/qY2SJ8R9M8yNHg+jxUbo37bcHI7VPN8k9kxdJDhnolhKqTUG46lQ3gskI9WEOnpciklhehffJA9yc/38f0NKWckOwBQcTlwKoGeh+2IHHoBGcd2ikUk1BcFHDy6tHhYQH8DQw4jgf1tLTgqhrMWLuEJwGy/2nZoBy38f0FQb97SrwSOLPARK3wKsMgvInNqO6zMgASe+DbOJQBrOsJiK3cS57Spb6DuXZ6REBz37Qk/UWaletC726KILlNM94dOA/4+dVM0Ucu5Jf4xnruqUgo0dnCqoIHPMkgcnGjsDY1gUXwh8jGL9cneCSlMEMPdX40s6yLumuFDHdK9dXHbB54bmsPyguWnDBM3/JSqjZYqrufb1KbDXidAzWk9spxFFIOHv6ZpzzzkXoZUFxDGYVogdOdZzr+4TWpO4I16xrpQhXj0pTIyYrxpG2tRX4KpYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(346002)(136003)(366004)(451199021)(41300700001)(4326008)(8936002)(82960400001)(26005)(316002)(5660300002)(31696002)(38100700002)(86362001)(44832011)(6916009)(66476007)(66556008)(66946007)(8676002)(31686004)(478600001)(2906002)(83380400001)(6486002)(2616005)(186003)(6666004)(53546011)(6512007)(6506007)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WDh6MCtPNlRCejVTemV6OHJpL3d5K2RjWjVSTFNISUZCRWZhMUV2Ui96b1g0?=
 =?utf-8?B?NXd6TmxyS2dtZk8xN3M3TkNXZ29QSHpYV09BWDhkZHYwckUraWZCc1FxVmZn?=
 =?utf-8?B?MjdUeml3YmJvOGxqczhQL2hEVWxtbjl1L1BxWks3dmh5ay9hck5tZDNYVWU1?=
 =?utf-8?B?UlB0RDEvMkdDUy9BUzVqTmZoZ3RaVks0N1UvOFJTdXl1Rmg1VzZ4VjV0MnR0?=
 =?utf-8?B?TGpTRy9LaTdQOHB1azJzMit2NWNXNXcxNHdmc2R5RlF6UllYY3puU2JPem1o?=
 =?utf-8?B?bWlURHdsd25KYXlxZEVwbFJmU01sM0tIblgxMUlQejNYbDh0R05UZkNUR2Q3?=
 =?utf-8?B?MUd0bDlVNjZ0V25rTUYrR1I0OHR6ckNDSllESHlqQVV3SU9xNnZSbjhRQWZs?=
 =?utf-8?B?aG5WNUJTTkxTckZoZzIzdy84a1o4UWtiYm03VXgreW9ZR3MwdjFaVE1VMExV?=
 =?utf-8?B?K0FOSlphS1FIYjNLYm92TnlPcEM2YnUwUk9kMGpIdFZjRDh6dFQxdzRLMXZ0?=
 =?utf-8?B?SGtWeGU1YmxXUkZISis2dFNDNEdqSUh5YlNKUU82TXBmakQwV2Zic1ozOHpa?=
 =?utf-8?B?Z1V0SkhlaUxWQkNIUE5kalo3ejlQbWhNOFBKcmU5bWhHczhiYm0xaVZMQTJn?=
 =?utf-8?B?cWp4Rk1HYkx4SytpT2hvamZGbWFPMU5lay9hK3VSL3ljK0gzQW1xTDI0U2t3?=
 =?utf-8?B?TmRLcXlHdjZTYmFxamUydEtoblJqMms1cno2OHhsN2psMmNRc2d6MFQxWTR1?=
 =?utf-8?B?ZkppODFHMW5RdGVsV2pwYXlNdUw2d09qOFpyMnpkWHZsa1ZVVUVqL2RwRGlm?=
 =?utf-8?B?WWpWVm5aanRNL1NlYnlsSVR4SDBkM25vbWFyMXZnWTJyZWI4elFrS1pVbXdC?=
 =?utf-8?B?cW1uQ0I2MXZPNURhbEM0TVc3ZzlEc2RHQ3VwRUtJdFNnR2Y3Mk01SmZVWnB4?=
 =?utf-8?B?YjFzU2JTSTRlRENNSkk3NjBDcytVVGJ1eFFWU2xQY3Z1Uk1CajhIMHVLUjZs?=
 =?utf-8?B?TEt4N3F5NXN5VloxbWt4TmM1c3ZUNnE4MlN5Q0NaMUg5TjZaMmtPQVd6MlYv?=
 =?utf-8?B?WUpkRUJuL0F3Y1BBaW5zSkJHeWxUb0M5R3FxVDVXSGJpdnhVcTBMNnhIQ3Vu?=
 =?utf-8?B?cTFJMm5Wc1ZEU3hRWU52cUEzc05aN1IyOURVS1c1OFRXSHM5SnNHNFdjMTFD?=
 =?utf-8?B?K3F2SUp6bTUwU0E2NVBCMkxXUWZaK3graDc3U2cwRXNtYUpxVDFybldQL1Jt?=
 =?utf-8?B?S1JPNWJNTHBqNkdMWUI0M3ltcmt4a25FandMZTBSRHJGQkFXV1ZOUDZ5b3Uz?=
 =?utf-8?B?NHlTa3ByekFOUzFsZnFHVkp0SnZRQ3BPTHFYZ0JFaE5sanlxS3g5ZWFYRGJu?=
 =?utf-8?B?S3JoRC9mdEVocWlPb05tQlhWaFdrYlphRUtvNUxaZHdUZm03NjBMdCtSMnB5?=
 =?utf-8?B?YWlYZHl3Y2Q5UHNQTTRDZkRqcTJqZllHMDVKN3gzY3owWUJKTGUrditHbEo1?=
 =?utf-8?B?M0RBT216REVlUUg3VkZheUNLZVBtSDJGSnlheXRGWVh0c2FNZ0p4SWRkT2kx?=
 =?utf-8?B?a0s3N2xEZWd0b21LUnVxT0NCSTJEZGpxcUlEQmNJV3RzNDVpOEZEejlid3Y5?=
 =?utf-8?B?cklqMXRpTkNzVzlrak91YVpibGVWUkJmOE8wMFdqbWl6M3JhV2F0d3h3S0x0?=
 =?utf-8?B?bjNCV3NpY1gvZFMrdVpMcnJmZGdLVGpCTG53TzFrNHlnZlNkTzk4WWd6b25L?=
 =?utf-8?B?Wlg5eklOWDRwU1N0MFY3dkcvNHphQWpLYm1zdFVZejAydDVkSU1HeDVkWUh6?=
 =?utf-8?B?UlNsTUUxSU8xZi9QWHdlOUMxVEo2UnkvVGNBUERla2ZvSzVXd3N6NWNNNERt?=
 =?utf-8?B?YkY5UWswU0hSZmkzdEY3T252NmdSZTlITnBNVDBXV1g0ZE5xODNmbUs5WnNr?=
 =?utf-8?B?MXEyMmlCMGNxS2dKbFN3M1Y5dDd2bEd5cHJ2MmFsVW9zbW96Z2JpTWlXWnNN?=
 =?utf-8?B?YUVJYWpvcTlDUXoyckt3ZjJBREVUSmszcHBUY1VLYlUrTzVWN0VIOHg3blpr?=
 =?utf-8?B?QlBRekF6RXVVSUNDNDNmdHNJNlErL1dJaXRlTDRYQ1p1RGR5UVFoQjU3clFj?=
 =?utf-8?B?V3lDUk1kOVBxZ0tuS0xGbDhyb1hKQ29vM0Vna3l2c2RXZkdBdkZNUXJnT211?=
 =?utf-8?B?dVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c5e43a5-6259-4522-1b0d-08db34694107
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 17:31:27.3036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: baUhLm/K1D++9x9OczlySs4x1hHxZrZa2kIRm2INDsSfIfc/5JhbkpznEGmM7jLROxucOYB3ghZ7uIRAygP5pXmeNc5irba4hdWjj0ukACk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6535
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 3/31/2023 3:24 PM, Alex Williamson wrote:
> On Fri, 31 Mar 2023 10:49:16 -0700
> Reinette Chatre <reinette.chatre@intel.com> wrote:
>> On 3/30/2023 3:42 PM, Alex Williamson wrote:
>>> On Thu, 30 Mar 2023 16:40:50 -0600
>>> Alex Williamson <alex.williamson@redhat.com> wrote:
>>>   
>>>> On Tue, 28 Mar 2023 14:53:34 -0700
>>>> Reinette Chatre <reinette.chatre@intel.com> wrote:
>>>>  

...

>>>>> +		msix_map.index = vector;
>>>>> +		msix_map.virq = irq;
>>>>> +		pci_msix_free_irq(pdev, msix_map);
>>>>> +	}
>>>>> +	vfio_pci_memory_unlock_and_restore(vdev, cmd);
>>>>>  out_put_eventfd_ctx:
>>>>>  	eventfd_ctx_put(trigger);
>>>>>  out_free_name:
>>>>>  	kfree(ctx->name);
>>>>>  	ctx->name = NULL;
>>>>> +out_free_ctx:
>>>>> +	if (allow_dyn_alloc && new_ctx)
>>>>> +		vfio_irq_ctx_free(vdev, ctx, vector);
>>>>>  	return ret;
>>>>>  }
>>>>>      
>>>>
>>>> Do we really need the new_ctx test in the above cases?  Thanks,  
>>
>> new_ctx is not required for correctness but instead is used to keep
>> the code symmetric. 
>> Specifically, if the user enables MSI-X without providing triggers and
>> then later assign triggers then an error path without new_ctx would unwind
>> more than done in this function, it would free the context that
>> was allocated within vfio_msi_enable(). 
> 
> Seems like we already have that asymmetry, if a trigger is unset we'll
> free the ctx allocated by vfio_msi_enable().  Tracking which are

Apologies, but could you please elaborate on where the asymmetry is? I am
not able to see a flow in this solution where the ctx allocated by
vfio_msi_enable() is freed if the trigger is unset.

> allocated where is unnecessarily complex, how about a policy that

I do not see this as tracking where allocations are made. Instead I
see it as containing/compartmentalizing state changes with the goal of
making the code easier to understand and maintain. Specifically, new_ctx
is used so that if vfio_msi_set_vector_signal() fails, the state 
before and after vfio_msi_set_vector_signal() will be the same.

I do agree that it makes vfio_msi_set_vector_signal() more complex
and I can remove new_ctx if you find that this is unnecessary after
considering the motivations behind its use. 

> devices supporting vdev->has_dyn_msix only ever have active contexts
> allocated?  Thanks,

What do you see as an "active context"? A policy that is currently enforced
is that an allocated context always has an allocated interrupt associated
with it. I do not see how this could be expanded to also require an
enabled interrupt because interrupt enabling requires a trigger that
may not be available.

Reinette



