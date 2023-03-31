Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E966D26F9
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 19:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbjCaRti (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 13:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232501AbjCaRtg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 13:49:36 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7582720DBF;
        Fri, 31 Mar 2023 10:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680284963; x=1711820963;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ccj+6m1qt41b7U8EnDvLzzpha83/a6L+gJtZbONlM3M=;
  b=DD5ZrPKPQrzQ9hjfmmUJ8e8CDbZlEbGED2JumPyPlFtWUnM5nhJzc5QV
   zIr21p54ZjBlkjyV5Y8U4FppMds7qNVrXkqlxgIXyo71F+BrcTBF83G7h
   nxWigyyfb0fpTxqRycaZ6XKQSj62n0tssLWPlKJnZMq+vMXBVANWnVorX
   vP+vgfGBZqIyg1lafL/IWsRTz6HMJAfgi4DHbfxGz7/q8KTnhURDqygFG
   0BsMufe4lsUI6jX7ReOoce4QFLRE98r0qaCluq29dEvxT7ITCw8Sd5OLa
   hjAc7Jeg8LxY3cvztroWfwHFxoTwH5+N+wTzPMiZ2QrBPVD3i7qYwbEos
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10666"; a="369316210"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="369316210"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2023 10:49:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10666"; a="754461653"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="754461653"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 31 Mar 2023 10:49:22 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 31 Mar 2023 10:49:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 31 Mar 2023 10:49:22 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 31 Mar 2023 10:49:22 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 31 Mar 2023 10:49:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IAAqaZyifIQ6Fpf1+/smbfDZWK0XWRUxpALvOjRz7cVWV01DA8716QtghFg4YXzJyHfwFT/eLpP3yKp+YT8yCDPjW8zGgZsnRD9yBMiAeuK00hSS7KGq7hIePLbh29JbS2KOLfT6eDKPX3lT0gQ5J8KkcSk/HK8U6mdgzfFmV2RDFoozroCNHdL6Dp5c3wcXNyKMZ5skH0cpnI41pUsIkcRYjrYKiUHgxvPhUqLALgDFTqAniJpTVgiGrFDhVH/se3p80Z8QIGaeSL5/ZmKrK461GeTWQ0ic3Dn6fhivlgkJ8+5NydokvKJ3/URyh4mJJIFUlk7597omD6LHdG7fsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=klOHslI3JNJv8LPS50UAfp1O7KQqo5kc2G2dxoWVE98=;
 b=k0uXK57+FliLfpzry+iiF5SsOEzx+CfaZl9lr+qVvVbj8/SUVSr/vlfypA27HmPnEtfyiGJc4k1snJ/80qVBE3fzczfI8oO1sfvUJYTuQViarsxZHMhpOoCHp3vmxZs0BYCK2Yxy+K+6Ck1Fey4JdcrJ6fsm7jFZvWRCfRUjbbkr4JzOS9X9UExnyo9lB4So1lc6DqRV635vjh7cJQZjZjpxbZynLzYPIFfFKwqL5NQSzy6fl4/WJXOC48zpqiwQic4nr1Lc7gtIolaJMdszXwKawkb9vKeG5g59OXoDL7vcKEBzoPAD+1p+Ma2CgRmywwDQpvJEMRy14o6zhp5XmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by PH0PR11MB5877.namprd11.prod.outlook.com (2603:10b6:510:141::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Fri, 31 Mar
 2023 17:49:20 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f%12]) with mapi id 15.20.6254.024; Fri, 31 Mar
 2023 17:49:19 +0000
Message-ID: <688393bf-445c-15c5-e84d-1c16261a4197@intel.com>
Date:   Fri, 31 Mar 2023 10:49:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH V2 7/8] vfio/pci: Support dynamic MSI-x
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
Content-Language: en-US
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20230330164214.67ccbdfa.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::13) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|PH0PR11MB5877:EE_
X-MS-Office365-Filtering-Correlation-Id: 00d80037-4d7c-4625-0bc6-08db321040ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6d7guS9gudkMKir7D2k4NEbWHXf5DJ+tF7GQ+MFQXAt82WRkQ0JMZg929wZkuJ1y+KjHihTMdwSZf1mSO/xnqpEJPGqCfMQ/pbvs9wp7aEKBSGDTdaa/unPS7xgdjBvh+UjWECRrbPIU8H0ycE5ByESdG7HSkpineHlvo2l0HjwlRX0j3sHB5Cc4NBzh2EJCpWcz1db+CZRv2djwMD+iksbuFKPd6JumBBXv5xnY4XvZBHtGP6PSsD0JAdOaAyH9mrpfeqA2ZsZCe3+MsBkFdp1HHJEPdWO7TFT+re6O3BAqt3BVkkHTd1eBMYjkupDi4OqC5TXgZJvj2b5n9KNRhBHTAQA0xetKTWMe+mQQonbeZcmakJamoGGKgIVJY+PfmoYeolA88ODVEVEt79tTuXUjspY1ji7GRZKUDwI3pakMUwsANi7sRBsmI8TYHDOD7NPmfT1wyjw83EB/cqwYaf0lDsuU7UmQ7XKEqyILv6XjdkqZUubqS1Q3Ya8CUTlDKyankVdPyxWz/YU27yv9HXzicIJ//Ok/9HlQGIfZVIfg6cegpT8KeWHuEgdozCPqKNOBQH/03+1+SCdtFFmTZBUEQKUUZW+0Q558zuwk/63Ntu+RJFjKtv1BgZJHLfOYC1d1IAK82h2YXVJbSyk3yQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(396003)(346002)(366004)(136003)(451199021)(316002)(8676002)(31696002)(82960400001)(44832011)(36756003)(86362001)(8936002)(66556008)(38100700002)(4326008)(66476007)(6916009)(2906002)(5660300002)(66946007)(186003)(6506007)(41300700001)(478600001)(6666004)(53546011)(26005)(6512007)(31686004)(83380400001)(2616005)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVRuN2RmWGVZaUdwM3VCQXZFcVdsMUpUR3ZKYlZZZ2RFVGFkRk15MlFJcmUr?=
 =?utf-8?B?RUpJeWNqUEpiaWVxNlAzZHlHclJaZWdQREtNdnVWc3lMMHRhbHZQVGRyemF5?=
 =?utf-8?B?SzJxcTJ6dWlyN0hWd3Jhb1RNa3VpTjQyOW5oL1dyMFp1Q0NKNGZFOUJpTlFI?=
 =?utf-8?B?ZnVJMWlPOUl4djd0QWU4UDlSZk5Zd3kzenNXeVRRQm9neExnc0hBcGVCa2xs?=
 =?utf-8?B?b3VEQmNHajgyUUI5T2NRRkJmK3JFd3EyQkVOaS94VkY5VUlPTlUrZk9yZG1H?=
 =?utf-8?B?Y3lBSzJGTjMzdGd5YU5RYkJaMzUyY1dEcnlaWWFMYVkvUzlpNEUxejZnUkNq?=
 =?utf-8?B?SmtjbGtHSkZzM3JIRi9IMU5RV2x1enlsc2ZFQk9MczZOMmZMcHRVYWdXM0Z1?=
 =?utf-8?B?Zm1TOUdlOUFwWFVRNzJUazlhNm1FdlBGb2RhZVBGR0t0MGJpMEFudzJRWDgr?=
 =?utf-8?B?dllBZWRnMVpTUkN2V1ltQmRBK0dJT014aVRhWklWV2tjTUxZRk9NMlRtRU1p?=
 =?utf-8?B?ekZxV1FMUm9yOWMveDdRTGtVRmtTY2N3M0hQa3NIU2RFbXcxNEtrVlZVaWVB?=
 =?utf-8?B?NitkMVNjM25ENEh6aFFJVVpPK3A1VkpHL3lLL1FTRnk4Mm1UcjN6S0NaQVUw?=
 =?utf-8?B?OUVGZDhIdFd6VUtyRmR4Rm5hOG9tZk5CVHRnMDJadW50cmdXUkNYQU5Ga1Iw?=
 =?utf-8?B?d1pzNXhyTFJoamI5VGVvWDdIRUFtWDQ4UjgvSXhQcXJMT1BsUTdiUEk1a3Zi?=
 =?utf-8?B?cEJhUVZ3ZkJPclZOZTJlcFFUQUI3VzBPOVF2Y2d5eXBlc2VtdHhOempOQVhk?=
 =?utf-8?B?VDZoTWM1cHh1UEsyNzlWQ3dmWVA1LzUweDJDS0hUMlBDbWdoUVJENlZ1WDFq?=
 =?utf-8?B?SDFhWHY5eXNUck5SMGtJY0NWckVPUnBDdHNBMEt0R3BJdGlqa2Y0TGkwZTVi?=
 =?utf-8?B?VVkwMC9pMGRITHJXNi94Tm11MVBmSkFkdDlQa2ZuZll5UmY5emVMOHFobGMw?=
 =?utf-8?B?eDl4a1hkanVCWmlIV1FZSGoxKzN3K2drZTdIMDVmemFIeEJrQUc5NUhpVTJC?=
 =?utf-8?B?UkRPSEViMEhXZFNDMnB6eDNGblIzV1J5WHNNYWdRWGV6bExjbENTanFMUDJh?=
 =?utf-8?B?YjZRS2NCUFN2YS9QMmM0cTB1cmdsYVNoa0FreFQwdWdqVzNOY3B5MEVYdnVL?=
 =?utf-8?B?cFpCalcvK0NxaExsaE1iYVhYZVZzZUFBUXZEaHZveHVrYk9udTB5K1VlcEdD?=
 =?utf-8?B?VXBScjBLcjJUS01YdVR2MWFUMHcvQ0ZnN21idXl5N0R1N3dsK0krOGVCbGJs?=
 =?utf-8?B?TGlmOFRNZ3cxSGRJUm0vRTNoUzNEbnRkOUtSa0luUDBDVWxRdzgzQzVnU29T?=
 =?utf-8?B?QzBJWlRWbVRIQnBqWUF3TUtYV1VhNGgvWU9HZkRxbjNtcWZIU0hqcW14M0xl?=
 =?utf-8?B?T3owK2lCNVRidEhWWTY1V2JZdUt3d0dSdXFWa1hwVEJVMHFPcWptcEM4MjdZ?=
 =?utf-8?B?OGFLWGdmYkFlWjd5Y3AranlIWEVub1llL0xZVzhOcDdvMFhvWHU2MnQxNFVO?=
 =?utf-8?B?cExaL2pVU3dmcWYzeFN0U0JlNHd4UlZYeUYzNFZibUtodGt2cGx1SWtYbXFw?=
 =?utf-8?B?OUJTaTZnOGJQT0pqT3JIaFpNLy93Q1pTRXJQSTljUTFoYmMzVWFpSHJHK1JR?=
 =?utf-8?B?K3R3b1lBVzJuTGEwM0JEU2h5dHNCaC9wd3V4U00rUFJOQmhyUnFmRzkzczZP?=
 =?utf-8?B?YnNCL0pMSXRjZ1lWbFUrQlRhcjk0NDBhY3VHdktkbjdvakIvVnFqOEhvY0FQ?=
 =?utf-8?B?L210ZmFxNXM0N0tHNlZhdDNVSm1lVmh5MXR3QTNaenVRZWJRNG1NRENsZU55?=
 =?utf-8?B?R1JUSHhqMjlzV0RhVnRkWUhaRmYxTis2ci8vWW5ZTFZnUWRxSGcwV1ExT1JE?=
 =?utf-8?B?Ukd0d0pDbG1OeTJWNkZIWlYzRlRwQm1aM3o5YXZ4bzVlb3Y1b3YyZWZ0U3VP?=
 =?utf-8?B?MEZqNElaWjZlTkI4ckx5eERqUk8ya0dURTlRQTNjZlBaR24ycjFkUnJoUW95?=
 =?utf-8?B?Z2dCeUg4YXVEQlhpYmJnNU5yR1J0YmtFbFQrZE5iOTZCOGFhZC9UYXhSZGEr?=
 =?utf-8?B?MnhlRnpxVzVXZExIeUk4UWxqYis0blF1cnZKVzlYaTNqeDlacWM1TXozNUtD?=
 =?utf-8?B?QlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 00d80037-4d7c-4625-0bc6-08db321040ec
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 17:49:19.6232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /L8pYqhCiWmbIy1ANHgYbipksbXe+xkmOBdMAat05bO+kspxsuVIp6x/GmpLDWhHeAQ31WYg8ghWlL5+YdX5kg0HCfgYeSvcQav8uqqEcx4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5877
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 3/30/2023 3:42 PM, Alex Williamson wrote:
> On Thu, 30 Mar 2023 16:40:50 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
>> On Tue, 28 Mar 2023 14:53:34 -0700
>> Reinette Chatre <reinette.chatre@intel.com> wrote:
>>

...

>>> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
>>> index b3a258e58625..755b752ca17e 100644
>>> --- a/drivers/vfio/pci/vfio_pci_intrs.c
>>> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
>>> @@ -55,6 +55,13 @@ struct vfio_pci_irq_ctx *vfio_irq_ctx_get(struct vfio_pci_core_device *vdev,
>>>  	return xa_load(&vdev->ctx, index);
>>>  }
>>>  
>>> +static void vfio_irq_ctx_free(struct vfio_pci_core_device *vdev,
>>> +			      struct vfio_pci_irq_ctx *ctx, unsigned long index)
>>> +{
>>> +	xa_erase(&vdev->ctx, index);
>>> +	kfree(ctx);
>>> +}
> 
> Also, the function below should use this rather than open coding the
> same now.  Thanks,

It should, yes. Thank you. Will do.


>>>  static void vfio_irq_ctx_free_all(struct vfio_pci_core_device *vdev)
>>>  {
>>>  	struct vfio_pci_irq_ctx *ctx;
>>> @@ -409,33 +416,62 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>>>  {
>>>  	struct pci_dev *pdev = vdev->pdev;
>>>  	struct vfio_pci_irq_ctx *ctx;
>>> +	struct msi_map msix_map = {};
>>> +	bool allow_dyn_alloc = false;
>>>  	struct eventfd_ctx *trigger;
>>> +	bool new_ctx = false;
>>>  	int irq, ret;
>>>  	u16 cmd;
>>>  
>>> +	/* Only MSI-X allows dynamic allocation. */
>>> +	if (msix && pci_msix_can_alloc_dyn(vdev->pdev))
>>> +		allow_dyn_alloc = true;  
>>
>> Should vfio-pci-core probe this and store it in a field on
>> vfio_pci_core_device so that we can simply use something like
>> vdev->has_dyn_msix throughout?

It is not obvious to me if you mean this with vfio-pci-core probe,
but it looks like a change to vfio_pci_core_enable() may be
appropriate with a snippet like below:

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a743b98ba29a..a474ce80a555 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -533,6 +533,8 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 	} else
 		vdev->msix_bar = 0xFF;
 
+	vdev->has_dyn_msix = pci_msix_can_alloc_dyn(pdev);
+
 	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
 		vdev->has_vga = true;
 
Please do note that I placed it outside of the earlier "if (msix_pos)" since
pci_msix_can_alloc_dyn() has its own "if (!dev->msix_cap)". If you prefer
to keep all the vdev->*msix* together I can move it into the if statement.

With vdev->has_dyn_msix available "allow_dyn_alloc" can be dropped as you
stated.

>>
>>> +
>>>  	ctx = vfio_irq_ctx_get(vdev, vector);
>>> -	if (!ctx)
>>> +	if (!ctx && !allow_dyn_alloc)
>>>  		return -EINVAL;
>>> +
>>>  	irq = pci_irq_vector(pdev, vector);
>>> +	/* Context and interrupt are always allocated together. */
>>> +	WARN_ON((ctx && irq == -EINVAL) || (!ctx && irq != -EINVAL));
>>>  
>>> -	if (ctx->trigger) {
>>> +	if (ctx && ctx->trigger) {
>>>  		irq_bypass_unregister_producer(&ctx->producer);
>>>  
>>>  		cmd = vfio_pci_memory_lock_and_enable(vdev);
>>>  		free_irq(irq, ctx->trigger);
>>> +		if (allow_dyn_alloc) {  
>>
>> It almost seems easier to define msix_map in each scope that it's used:
>>
>> 			struct msi_map map = { .index = vector,
>> 					       .virq = irq };
>>

Sure. Will do.

>>> +			msix_map.index = vector;
>>> +			msix_map.virq = irq;
>>> +			pci_msix_free_irq(pdev, msix_map);
>>> +			irq = -EINVAL;
>>> +		}
>>>  		vfio_pci_memory_unlock_and_restore(vdev, cmd);
>>>  		kfree(ctx->name);
>>>  		eventfd_ctx_put(ctx->trigger);
>>>  		ctx->trigger = NULL;
>>> +		if (allow_dyn_alloc) {
>>> +			vfio_irq_ctx_free(vdev, ctx, vector);
>>> +			ctx = NULL;
>>> +		}
>>>  	}
>>>  
>>>  	if (fd < 0)
>>>  		return 0;
>>>  
>>> +	if (!ctx) {
>>> +		ctx = vfio_irq_ctx_alloc_single(vdev, vector);
>>> +		if (!ctx)
>>> +			return -ENOMEM;
>>> +		new_ctx = true;
>>> +	}
>>> +
>>>  	ctx->name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-msi%s[%d](%s)",
>>>  			      msix ? "x" : "", vector, pci_name(pdev));
>>> -	if (!ctx->name)
>>> -		return -ENOMEM;
>>> +	if (!ctx->name) {
>>> +		ret = -ENOMEM;
>>> +		goto out_free_ctx;
>>> +	}
>>>  
>>>  	trigger = eventfd_ctx_fdget(fd);
>>>  	if (IS_ERR(trigger)) {
>>> @@ -443,25 +479,38 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>>>  		goto out_free_name;
>>>  	}
>>>  
>>> -	/*
>>> -	 * The MSIx vector table resides in device memory which may be cleared
>>> -	 * via backdoor resets. We don't allow direct access to the vector
>>> -	 * table so even if a userspace driver attempts to save/restore around
>>> -	 * such a reset it would be unsuccessful. To avoid this, restore the
>>> -	 * cached value of the message prior to enabling.
>>> -	 */
>>>  	cmd = vfio_pci_memory_lock_and_enable(vdev);
>>>  	if (msix) {
>>> -		struct msi_msg msg;
>>> -
>>> -		get_cached_msi_msg(irq, &msg);
>>> -		pci_write_msi_msg(irq, &msg);
>>> +		if (irq == -EINVAL) {
>>> +			msix_map = pci_msix_alloc_irq_at(pdev, vector, NULL);  
>>
>> 			struct msi_map map = pci_msix_alloc_irq_at(pdev,
>> 								vector, NULL);

Will do.

>>> +			if (msix_map.index < 0) {
>>> +				vfio_pci_memory_unlock_and_restore(vdev, cmd);
>>> +				ret = msix_map.index;
>>> +				goto out_put_eventfd_ctx;
>>> +			}
>>> +			irq = msix_map.virq;
>>> +		} else {
>>> +			/*
>>> +			 * The MSIx vector table resides in device memory which
>>> +			 * may be cleared via backdoor resets. We don't allow
>>> +			 * direct access to the vector table so even if a
>>> +			 * userspace driver attempts to save/restore around
>>> +			 * such a reset it would be unsuccessful. To avoid
>>> +			 * this, restore the cached value of the message prior
>>> +			 * to enabling.
>>> +			 */  
>>
>> You've only just copied this comment down to here, but I think it's a
>> bit stale.  Maybe we should update it to something that helps explain
>> this split better, maybe:
>>
>> 			/*
>> 			 * If the vector was previously allocated, refresh the
>> 			 * on-device message data before enabling in case it had
>> 			 * been cleared or corrupted since writing.
>> 			 */
>>
>> IIRC, that was the purpose of writing it back to the device and the
>> blocking of direct access is no longer accurate anyway.

Thank you. Will do. To keep this patch focused I plan to separate
this change into a new prep patch that will be placed earlier in
this series.

>>
>>> +			struct msi_msg msg;
>>> +
>>> +			get_cached_msi_msg(irq, &msg);
>>> +			pci_write_msi_msg(irq, &msg);
>>> +		}
>>>  	}
>>>  
>>>  	ret = request_irq(irq, vfio_msihandler, 0, ctx->name, trigger);
>>> -	vfio_pci_memory_unlock_and_restore(vdev, cmd);
>>>  	if (ret)
>>> -		goto out_put_eventfd_ctx;
>>> +		goto out_free_irq_locked;
>>> +
>>> +	vfio_pci_memory_unlock_and_restore(vdev, cmd);
>>>  
>>>  	ctx->producer.token = trigger;
>>>  	ctx->producer.irq = irq;
>>> @@ -477,11 +526,21 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>>>  
>>>  	return 0;
>>>  
>>> +out_free_irq_locked:
>>> +	if (allow_dyn_alloc && new_ctx) {  
>>
>> 		struct msi_map map = { .index = vector,
>> 				       .virq = irq };
>>

Will do.

>>> +		msix_map.index = vector;
>>> +		msix_map.virq = irq;
>>> +		pci_msix_free_irq(pdev, msix_map);
>>> +	}
>>> +	vfio_pci_memory_unlock_and_restore(vdev, cmd);
>>>  out_put_eventfd_ctx:
>>>  	eventfd_ctx_put(trigger);
>>>  out_free_name:
>>>  	kfree(ctx->name);
>>>  	ctx->name = NULL;
>>> +out_free_ctx:
>>> +	if (allow_dyn_alloc && new_ctx)
>>> +		vfio_irq_ctx_free(vdev, ctx, vector);
>>>  	return ret;
>>>  }
>>>    
>>
>> Do we really need the new_ctx test in the above cases?  Thanks,

new_ctx is not required for correctness but instead is used to keep
the code symmetric. 
Specifically, if the user enables MSI-X without providing triggers and
then later assign triggers then an error path without new_ctx would unwind
more than done in this function, it would free the context that
was allocated within vfio_msi_enable(). 

Reinette
