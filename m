Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84BCA65D736
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 16:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235070AbjADPWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 10:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235156AbjADPWh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 10:22:37 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01D4EB1
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 07:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672845756; x=1704381756;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k7CEnXKbGS1wUA5KmOXxoEto2Hbo4AzyXq5wkV3qoLw=;
  b=WE7BKbTk9kqvgSmMJ5eXZh1rro1ah/jNlWSy0pqArcLY/smTnUdqXX2A
   uzMdi9xGyopuBARtCwEt3Pt7La1Nk7sh4Sv/qS4gVG7z41Bl4hq4IOZ4D
   JLvoQE+YF8UB7CZKCNTwVRQ1BE1VxYONGGjlVuQWWdvbzubdDflv0PBTp
   mri70qnXrt/xySyjk7gTO3utEblazZNhNzDO1ueTzDv/lka6+zEwFvyRb
   k8ekzN0m+vYjoWKgNl9zIAHmxsar+ShOw4frKXb4GWM4JQGZoaRxEHRrI
   NrkmDRnoZvW5EQ4PnU3uOg7Tc31PisdYSiWboFT+28eHTrRtQRxf7QBDW
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="386387742"
X-IronPort-AV: E=Sophos;i="5.96,300,1665471600"; 
   d="scan'208";a="386387742"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 07:22:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="648609433"
X-IronPort-AV: E=Sophos;i="5.96,300,1665471600"; 
   d="scan'208";a="648609433"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 04 Jan 2023 07:22:35 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 4 Jan 2023 07:22:35 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 4 Jan 2023 07:22:34 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 4 Jan 2023 07:22:34 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 4 Jan 2023 07:22:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQ+yVuJTGN5uAECRZ1qy0TRUmRNV4V5oSMMYDtwnsmgHjcaO9JvJL3NrnMRpdfw8IRJpJlLPTDxSsWlUXX0nr4H5RSaWS3gweCkZGVv78oQmyStTwF5ANAt1uP7YTn8M05peXIrFDMoUlCWFZB/odvzeFPfTeXzF66LtoJZ9HP7/66oAai93cICt36X64b6jDNQYWEls5ezkbYsCa5X6TnUC285EKWYyG5TgrRcjGbxKzzcQopPGb3OChQkvRJkkT+mMH7H/R6z9lEfxhTq1YEJ6RY6TW2ngKYG69Gwcf0327YRm6uRVl6vurjG27KQ/4ghOazvRH/5SJDQa9KOVGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rIL8UwbfqQekvQ7s0J/uoV1TQ3vpHP1cbi5LQWWSiZc=;
 b=b1OZBL+3elrakvKqeR3ReMG31WIDLpkuulIhZw6lm+WKvalxDH7B+ZIFBwRq31us77Xu+06+cJg3PA2R8rFdX0y0aQHlEJnFr307uWuPJEI5V2AhdWCuF7ug5HhRcPlXo1MOfMOGyozGqg0aBwisUr6JQtZ0yzeSIf16nJS0SKzFDp7x3S+MU96chwjzUJrKh2MOE4L1SxBx2svWfpwNRKO2hIwRisgnZj2HjfAc8uIg+TfOwpC3NKnHlBBuDGXanN36HaoUzUK4AvrUUcdt4WbLDMdScta1nR3XVINTAdHJ8AeWgkUKWomecDN6L3EIkCJ2ERJGcCjiMDbZradv6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by LV2PR11MB6070.namprd11.prod.outlook.com (2603:10b6:408:179::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 15:22:31 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::991e:f94d:f7ac:4f8]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::991e:f94d:f7ac:4f8%9]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 15:22:31 +0000
Message-ID: <0d99265e-c0d5-4587-c419-6b486b49d097@intel.com>
Date:   Wed, 4 Jan 2023 23:23:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC 00/12] Add vfio_device cdev for iommufd support
Content-Language: en-US
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kevin.tian@intel.com>, <cohuck@redhat.com>,
        <eric.auger@redhat.com>, <nicolinc@nvidia.com>,
        <kvm@vger.kernel.org>, <mjrosato@linux.ibm.com>,
        <chao.p.peng@linux.intel.com>, <yi.y.sun@linux.intel.com>,
        <peterx@redhat.com>, <jasowang@redhat.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20221219084718.9342-1-yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0016.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::17) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|LV2PR11MB6070:EE_
X-MS-Office365-Filtering-Correlation-Id: 29bd0e5f-422c-4f6e-d183-08daee677f5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X92Vp+ijtIYDMipJ1dT3HJOhkxSm4SqiiI6mFK5YvYolxwuLIhurmRG/vHwjrT1cqeNUEelrLi3Gj0ZF5WQMy4Xze0H1HQxNABpTgWGndAuYrr9AzzXZciHgqvla9AHYAcSL/4srdWnTa964Rl9JnLPacz+xVc3tq4Rcb3YEdv6+gj+kRTxPF15krqIbCWzo78xy0ewshCDzpLQQA443n5v/nDpFPvV/qxL65F//RiaKRRNxvI5+2E0Bls0ThVyH5riyQ1RW0hTcXckDsvu0oZoqYLDUFVmhgB3lxIaVvp59ppnS286tCZOMJHkDBJgurU+W/elRVwqsLnTv1pjjQLc6rsEJG/fJjccQnN7mkCsPWp7kShp1unoVExzyP78wlnhDet8kSf3ecRYY9yvDf42/mlTdhBMhw1jvm3NT1RSjnxSvTRarj1yiwcEWpMjM1p+g9hatPnTN9Mes6oIdmW1ngRy0/HcIQfIPM4PmF0jeNEVirt5/bQHfdmmuH/kGA2j3kgqJjZ/xCL7TDWSKpk6ygRxsCUG7W4gQGAN5qEzMO7gKBgRRyKQ39IBrrMmVveoV2Ki6RkMcxBFVnVzlCIQq3tDB7A5M6eAUb1LM+v+8H6wbEogHrx7QOm3MhoHSAq7eqMccl6kfZ7c71p2W7EV1Rd0l9KwUHH1kSvbPWbXcr3KAwF8sTK2TisURGOSqO6uL5wLeWLIBgFFf1VcXtpumZcdKutBtcxlSCn5XvOuvEozsVLzKBiETF4Ey7x1+LVstapV/ASZhlJUbUWW8aQe6rXBnLNbiieoeaMqfW7p7wPRw333vpuNZ4554Kbrn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(346002)(39860400002)(136003)(451199015)(5660300002)(7416002)(2906002)(8676002)(31686004)(4326008)(41300700001)(8936002)(66476007)(66946007)(66556008)(316002)(45080400002)(478600001)(6486002)(966005)(2616005)(186003)(6512007)(6506007)(83380400001)(26005)(6666004)(53546011)(82960400001)(38100700002)(31696002)(86362001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S215N2FueS9CdHNxZC94WlR0ZlpnTGs4S09ESnFOUHYwSHYwcjZMNEhzekdw?=
 =?utf-8?B?QlpLbmxPSmZPRkhCRXQveDZTVnlXVHpOUUFqb2NEem1TcWxQdFZDSjdHdXdi?=
 =?utf-8?B?UWZOdFlxWG9DakF5SFdUMFRqeUFQK2F6Ritzd0FvdzQ4QkFoZFRiSUh5NHlD?=
 =?utf-8?B?QUp1Mk9tOEUvZElzY2lXaVAyblpyMFVMaGRNcldJcHNZa1R1ZS9EQncwWENS?=
 =?utf-8?B?YlNJRXBDS0ljSkN3QnBMUTdkd1FaMlVHM3RHR2FQbDZjU0lQd0VTL0RuTDlI?=
 =?utf-8?B?NS9SVy90VjRBTE1rdmpCMmdsOE9RdDdKTm9RMXFLeHIxNzBRZytVTmN0RzVa?=
 =?utf-8?B?YUtWcHZlMy9OcXlpZXRNTlc4dytoSEV5ZnRKdXZ4TkNmdXlxR09Gbm5JZ054?=
 =?utf-8?B?ejJnbWkvVjhvNHIwd25raXllK0RFN0pEQ0JsbjQ5bTdKRGM3OGpjNWtJdzZQ?=
 =?utf-8?B?Y3VDOHQxVkhmK2dvbkovOStBbVlFV1pjb0x4UEQ4NWNzWFZnNGlqZy9peWZQ?=
 =?utf-8?B?bVY0Q2taRXlSelhlSlpnczJLWjlmTnMxY2pxY0NJRTgzNE1rZGZwR2FNSEtO?=
 =?utf-8?B?KzVRbzk5SkRsU3YyVllRU3VuRXYvdjRzRkV2bFhlZXViRGZJeHBYcFpMeXNv?=
 =?utf-8?B?NmJObTZ5TXk3UFNKakIzZkIyNTZTRnd6cWwvT2RiU1JxRlIydlQvT0M2TTZO?=
 =?utf-8?B?Y2ZSRS95eTg5UWN4bFpaYWhOcjBNV25MRzZ5ejlOeWJjQ0daamp3VzRuNkha?=
 =?utf-8?B?SHMrem1oTVY5WW5DdmRwZzlTY0FCVE9GWmhkZWlRR01vZ0cxUzhkazcwaWdL?=
 =?utf-8?B?OUdjQVZLOHVaUDVFRU96QzdMR1ZqaVlZZEZxQzVNMGtCVE1TNjArdGtraW1M?=
 =?utf-8?B?V3ZHTEZUTEk3ajdhVTJkcVdFMWM2RWtTRVJZYVM4cnZmNGtzbXQ4cW9jMFEy?=
 =?utf-8?B?NER0eWFwb0tYY0lXQ0VsOXNQMHR4T3dpcERVN05BdnN5RWQ3WHpDVEpic2pi?=
 =?utf-8?B?dTBQNTA3Y2U5TEFwYVJiR2RFb21sK1Ribk8wSGJ5TnlXamV5WVprYnVyUDA4?=
 =?utf-8?B?UDg1eXRlSTdpYjdYOWM5WHUrSm9xalRxOG9Bd1RNTnFsMmtiZVAveVlMYnZy?=
 =?utf-8?B?bTU2ZzFuOGY0VHRpOWZVclZwWDMwUE9mSUhKNGpyeUpCZnR4QjQwZDVyNEhQ?=
 =?utf-8?B?MVRVYkpqdnpLK1o0YkpCdXlWdW1NU1I4ZU1vOXFCcXZBUWJzbHdMclZ0dHRv?=
 =?utf-8?B?cnJHSjVKSXlaWkFwOU1CZjBrVTV3L3U3QlhLT1RjYjZOZDZ0NmNvQjUrbnZI?=
 =?utf-8?B?NHVNZ2hPalR6OXVLcUFSdk9ZRzdLTG1abzZPUTg3MVhvc0Y3NGcya2V5bDZO?=
 =?utf-8?B?SzlhMDRQNGpPTlpGYU9SUnZRSm1ZSktBeXhBWE5XVUxYRTI1Z3RnZjE4Zm4z?=
 =?utf-8?B?TzYvNFZVRDJPVzRVU1MxQVRlRWpKQTQrTWpESkIyU0RTV0RXZWwvTmxpVFhQ?=
 =?utf-8?B?Wlp1NGxwQUJ4NTBzd29SSC9RSGo2THI3N3lyZklSbG1hREtVQTRadFBmWDY4?=
 =?utf-8?B?dkVxeWdxbVVoUHVDYnlDU3FXbWFPektVOHRiNk0wc0RmYWQ3YnBHQ2l2QlZo?=
 =?utf-8?B?czlnYTBHeWhUNktvaEFhdkZpZkl2ZWZwVmdKZXlHeG45d0xlc09vTS9wUEJY?=
 =?utf-8?B?NkJjWG0xYVZYUzN2S0J3TVZYQUhUZ0RkR3hCK21tUTJkT2VvTzZWWldTTjlP?=
 =?utf-8?B?dTM5MGprVS9nOVo4bm1UWGFaZk83UjRxOHByQ2tCalFVK1Q5ZE96ODBqZFpV?=
 =?utf-8?B?d1ZyQzk3TGdDNDA3QUpxLy8xZnRacFhzbEFsaHZYdysrUnFxWWV3SWFnZ1NV?=
 =?utf-8?B?b3pTRVllRkNEWmFSKys4aWJkQnBMVTQ5RXJBZkpPU3FUWmU4N1NJZ0daMm5n?=
 =?utf-8?B?OXVzZVlJNDJJMlNCNWlZLzVjME9zWWZJL3VUTCtyM1R0eWNZcWNRL0VVZ1dB?=
 =?utf-8?B?bzVRcVZqUGV6aGpXY1F0ckJpdnNWQ0RzRzhoc1gxU0k1cGp2azVVM3IyNFJk?=
 =?utf-8?B?THJCRUFDRXovbFgrd0J4ekVMZEdVNnQzY25oMFdhNm1pQnI0VE5xd1BvZXhB?=
 =?utf-8?Q?rXTo4QlYTfFrQPAECnwJWYj2n?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 29bd0e5f-422c-4f6e-d183-08daee677f5e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 15:22:31.5433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IZzcEhfIiRFkEucqjpIz4x3dBPV3oWLUUsl4axaSVN86j7qc9P8JbLTDCIwg0Txq1heUi3QDwlsbPsjw5xHO4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6070
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/12/19 16:47, Yi Liu wrote:
> Existing VFIO provides group-centric user APIs for userspace. Userspace
> opens the /dev/vfio/$group_id first before getting device fd and hence
> getting access to device. This is not the desired model for iommufd. Per
> the conclusion of community discussion[1], iommufd provides device-centric
> kAPIs and requires its consumer (like VFIO) to be device-centric user
> APIs. Such user APIs are used to associate device with iommufd and also
> the I/O address spaces managed by the iommufd.
> 
> This series first introduces a per device file structure to be prepared
> for further enhancement and refactors the kvm-vfio code to be prepared
> for accepting device file from userspace. Then refactors the vfio to be
> able to handle iommufd binding. This refactor includes the mechanism of
> blocking device access before iommufd bind, making vfio_device_open() be
> exclusive between the group path and the cdev path. Eventually, adds the
> cdev support for vfio device, and makes group infrastructure optional as
> it is not needed when vfio device cdev is compiled.
> 
> This is also a base for further support iommu nesting for vfio device[2].
> 
> The complete code can be found in below branch, simple test done with the
> legacy group path and the cdev path. Draft QEMU branch can be found at[3]
> 
> https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_rfcv1
> (config CONFIG_IOMMUFD=y)
> 
> [1] https://lore.kernel.org/kvm/BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com/
> [2] https://github.com/yiliu1765/iommufd/tree/wip/iommufd-v6.1-rc3-nesting
> [3] https://github.com/yiliu1765/qemu/tree/wip/qemu-iommufd-6.1-rc3

a ping in case of this series is "buried" deeply. :-)

> Regards,
> 	Yi Liu
> 
> Yi Liu (12):
>    vfio: Allocate per device file structure
>    vfio: Refine vfio file kAPIs
>    vfio: Accept vfio device file in the driver facing kAPI
>    kvm/vfio: Rename kvm_vfio_group to prepare for accepting vfio device
>      fd
>    kvm/vfio: Accept vfio device file from userspace
>    vfio: Pass struct vfio_device_file * to vfio_device_open/close()
>    vfio: Block device access via device fd until device is opened
>    vfio: Add infrastructure for bind_iommufd and attach
>    vfio: Make vfio_device_open() exclusive between group path and device
>      cdev path
>    vfio: Add cdev for vfio_device
>    vfio: Add ioctls for device cdev iommufd
>    vfio: Compile group optionally
> 
>   Documentation/virt/kvm/devices/vfio.rst |  32 +-
>   drivers/vfio/Kconfig                    |  17 +
>   drivers/vfio/Makefile                   |   3 +-
>   drivers/vfio/group.c                    | 131 +++----
>   drivers/vfio/iommufd.c                  |  79 +++-
>   drivers/vfio/pci/vfio_pci_core.c        |   4 +-
>   drivers/vfio/vfio.h                     | 108 +++++-
>   drivers/vfio/vfio_main.c                | 492 ++++++++++++++++++++++--
>   include/linux/vfio.h                    |  21 +-
>   include/uapi/linux/iommufd.h            |   2 +
>   include/uapi/linux/kvm.h                |  23 +-
>   include/uapi/linux/vfio.h               |  64 +++
>   virt/kvm/vfio.c                         | 143 +++----
>   13 files changed, 891 insertions(+), 228 deletions(-)
> 

-- 
Regards,
Yi Liu
