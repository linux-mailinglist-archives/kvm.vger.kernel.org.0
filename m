Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910D37D08BF
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 08:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376331AbjJTGuH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 02:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346958AbjJTGuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 02:50:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EB6B8;
        Thu, 19 Oct 2023 23:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697784604; x=1729320604;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HvLuF4bbKaVyOY+xHRylu4yJH0nNbtNSYbBG1961hJE=;
  b=lwsgOkvj393w+0YCPEKtH4v+uYKCYQCreqXS5S/7DbWeKunwosBIXwUU
   uHFWiTSVbif9OQUZTRpwbRvZ/UB8CcNu4mELGqBE0KJVdEYAUz2pRDxbv
   EINjSaIU5/SWZHY9zpecXcRDyvm7zbvffJyHcudqSNcOOKqCmw/HJPyxE
   D0oXxOvAYRWqF64HC5Aq53c9l3GouRu822PpStviuAcuZpvaRlBwvNuet
   xjffYrVkCSbDMUf91HLE5biKesyDbS6NrVOOH19s0uT/4IdVbEbzgkQXY
   kkryyBT5v2fLTEopPqZPPelRsHRx8mey32MORCNSg34ByyEfXJ39vV/Zt
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="385317567"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="385317567"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2023 23:50:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="5290019"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Oct 2023 23:50:05 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 19 Oct 2023 23:50:03 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 19 Oct 2023 23:50:03 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 19 Oct 2023 23:50:03 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 19 Oct 2023 23:50:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZPLBW0CGX5q9E2iwJHp3040zIbDyKg2GB+IpeUbeiQAYPYWychLesa1kiQdIN1e46ZPuG51NpCdQQrCTSWSCBlOUOXh5amKnQ0UQ/Pvv0A7VRmaxIMpr1dkJgNHtjIGGVbO8/Cm6DZauqcml6OpHOAeT4hR2Xecwq3jAD9w27FHFl3mfvL612K/9DMPywZ3sRE3t+TTADlcboBvJRouxUiSBbDmnsNMQWMEK1tswQP/l2fVleVCtCkFg+Y7bSmZ4/dQLfa/Uq+FkBdgaB5QZczmgGMS6YFw6LjVVPE4Iob11cQkpYqlM/MmxGGLTu0sePsWYiRDu7CzrqPMnmy6qnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HvLuF4bbKaVyOY+xHRylu4yJH0nNbtNSYbBG1961hJE=;
 b=kbUzgpKjqdlp5JtVF1HiZYDr3aHmRNKVjwR8oCGzzDWuPyJSUWi1+p2bxDH0gCXpYE7sLu6OO+pMMmxafYzCV8dd6W29K6rVMtd+XkkfuYBxx+RKqePGBm60MwZGRA+eK/0x+KR1lx9a3NDR2/nPBYoWjRB6UdY65rAjIj8ehqXeV9rEGJb0P1oYpoEgS3gvMWiWA7FE3vPcSeB14LhHSKCV/VeXCpmNgWbL8S5AJ7O6s1JSA/Ybf0kFgXEEfnVKnoHCLLPhiPWvg/LR8/ILIJlMOzsdCPqP0t13Ekan4Mr7RCgmoWSnj19QBpvClVO665ymewV3eE+WLYBW1m/PzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA0PR11MB7838.namprd11.prod.outlook.com (2603:10b6:208:402::12)
 by CO1PR11MB5121.namprd11.prod.outlook.com (2603:10b6:303:98::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 06:50:00 +0000
Received: from IA0PR11MB7838.namprd11.prod.outlook.com
 ([fe80::a35e:550e:d46c:c777]) by IA0PR11MB7838.namprd11.prod.outlook.com
 ([fe80::a35e:550e:d46c:c777%7]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 06:50:00 +0000
Message-ID: <150f4c9b-5107-feca-c753-9390f29193e6@intel.com>
Date:   Fri, 20 Oct 2023 14:49:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.15.1
Subject: Re: [PATCH iwl-next v3 00/13] Add E800 live migration driver
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <lingyu.liu@intel.com>,
        <kevin.tian@intel.com>, <madhu.chittim@intel.com>,
        <sridhar.samudrala@intel.com>, <alex.williamson@redhat.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <brett.creeley@amd.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>
References: <20230918062546.40419-1-yahui.cao@intel.com>
 <20231016165120.GA441518@nvidia.com>
Content-Language: en-US
From:   "Cao, Yahui" <yahui.cao@intel.com>
In-Reply-To: <20231016165120.GA441518@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0073.apcprd02.prod.outlook.com
 (2603:1096:4:90::13) To IA0PR11MB7838.namprd11.prod.outlook.com
 (2603:10b6:208:402::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR11MB7838:EE_|CO1PR11MB5121:EE_
X-MS-Office365-Filtering-Correlation-Id: 17b320ba-cd6d-486c-4ebf-08dbd138c7d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8/q0io0VDy0kCzoVQe6Th31juyMjp/L/1LpmVF6P5FJwXZscyLJqxm9o9uEWFmMbtY1pvfTWbHAD7/N8AAf0ejcbnknh7uQ4iI7BsLdQwlERyqWqNmD+W1C+224wBaHQbXW0iOJ400M6WUVPls7akP/9qPowRm1A9KI+h2gzFIA4BlZAVLcZnJSKA/dnk1eddlYVrAZ+sx9uEmg0jqdGQRU74XjOjtVSzBof9FdQ/OzukRvGesXoni1x06CTtPVh9D0SVIOKroktVg0LwyIqSE3anxwB8/eyk6u039cDFpYIZIQK5hWP4RUlylaG6fgzgyfV8ewz9wgo5MRGsJVnADOKGoLrWsZXDPbFpfWCJwocUkctDg4s4IMrnlzAnfds4yNAwi8651F9bu5xX1PHsCb2M2iBVgW6gypfINlUal6VuwGmfjjB302p2AqUJroZyaB4fvgL6ercJ/tg99gjd6l6Cc5PEfYBJbMop3EUXTLxHLpdxipBOdWxicX+ttfphIKQIb31YVmA6W9WChp1Eoa2ApWyXckRPeWydRt8pHA53Ualx81tGpA90A82eOSM8lAyP5nqcswGS9lUF+Q2zr640JxCeNVZBvMad+y5E8fAWz/XmzSkQxBuKpNkP/vl34dcaTBWYmvh56uZJhFxtw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR11MB7838.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(346002)(376002)(39860400002)(136003)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(36756003)(41300700001)(8936002)(8676002)(4326008)(5660300002)(4744005)(2906002)(31696002)(7416002)(86362001)(31686004)(6506007)(6666004)(53546011)(83380400001)(6486002)(38100700002)(6512007)(2616005)(6916009)(316002)(107886003)(478600001)(26005)(82960400001)(66476007)(66556008)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVMzVThzSTArR29xY3hrZVpMOERzZDRoTU5peDdKOUxrbCtjUWZjeFdTc3lS?=
 =?utf-8?B?RUdpb1JUM2JyV1dEUDk2RkxUWExYVFdvemdCYTZBRjNtVkFFYU5DM2I1VlNO?=
 =?utf-8?B?b2Z5Y1k0Y0JOZGkxSkQzOGgyQU9Cc2laSDhZZ2gzaEJKZ1RiSkUweEpObGtp?=
 =?utf-8?B?VmhSQlNKdWY2dFZyTHl1TFFub3cxZmlkR084WnhWY2JqUU1WWFM2dmFTMWh0?=
 =?utf-8?B?OXYxK0NMOW1qREhDSVI4Zm9xWU1pdGplRHBJV0g1UVNnWVAxYzVaUGRaWFE1?=
 =?utf-8?B?dmxkRW1Ia0dCQUFERmZwTkwyKzJBaW92TDIycmNDOTBTY2M0SzJtMldCeGF0?=
 =?utf-8?B?NjlRRnFtdy9SbG5nUjZiRUtOMTFRWStLVm5jdVBwb2dZQjJDSHhnaUpJb2h6?=
 =?utf-8?B?ZDh6UnQ3czRDU21aUXlaUWtsNWp6QmhDdmRkVnIyZ0lqejl5dko5R0pCa0Vr?=
 =?utf-8?B?alNiVUFqcEVFS2NETSt5bVNXSWt0L2JZNDJPcWFMSmhOcVV2YmVxSjE4cFU2?=
 =?utf-8?B?M3FmUlR0Wjg2ZDFZaUNaUXdMVVZHM0xqYThiNTlrdVExYUVOTmd5dzIzSW9M?=
 =?utf-8?B?b2JaTjVmMHl2STA5dXFGMDduaWo0N3dWN29VU2tBL1FOMFUzWTRaOXJTOHJx?=
 =?utf-8?B?cnQrc0tnMDNBU0JlWmxtcHgyeDl4RGs5N3ZuRkV2RFJzb1JLT1pzbW14YTVq?=
 =?utf-8?B?SHdMbkl3OEMwRmdjaGIrYzF2NDVPMXUycXJwRVlKTkw2MWQyNkpUZWVjczhu?=
 =?utf-8?B?TTQyT2RaU05QNUxDYnBVaVBlYm1UYTNsWmtmb0xrKytXaTM5WmVmUEJ2blE1?=
 =?utf-8?B?K2p4ZGRnV01ZZEpsN3FmT0dIL252bFA4WE9UZ1ZHVWtKVTM1VFRHbmcxVFp0?=
 =?utf-8?B?YmRvK3N3WmRuSiswczNFTXZjMnNSZTVBUXRvVGw5TnV0R0VkdFhTT1AwY1kz?=
 =?utf-8?B?ZXZoUkpacGtUa1RIR3lnZW9LSzF2aDJCMThhOXF3dSsrZksxbHZPQTlXazhZ?=
 =?utf-8?B?eVNOZXF1RXlyVEhhaWppTkFDd3E0N2Z6d2JSSGNwNmxrUzFSSkF1RUZvbW9q?=
 =?utf-8?B?Umc1YjhKWEVoNE41YWZUTGFIMDNmMnFyYU5VUU1FYXFoRUtvOFVUeVViSmFU?=
 =?utf-8?B?enVmODRuL2NYSkZnYTVndWo3WHdWbWxkQU4vRVFoR2NuN3NtMHRDYU4rL3h0?=
 =?utf-8?B?ZUJNbk0wNXRvYk16TWFFaGlJQnFoZWg0NEVZUUV2K2JmTFlibVQyWU0vTUlk?=
 =?utf-8?B?aXdzVXN3ZHFYN2p6a1dlYXNNSG15Q3FwbHdsaldGNStSeHVrTHFleVZ4ZHJk?=
 =?utf-8?B?UDJNMHF5MTNaNWJ2bWRnK1JlbUREYkpRdnMyd2RIaW1ldGJHeDBLdEI2TWRt?=
 =?utf-8?B?YjNERk8rYkdtVWU3M3J3cUZtbC81eXcyT3VyV29SNDMxU1NEdHVWOHA3MC9G?=
 =?utf-8?B?TG4xQlpXbkQ0NDNYemY1SXZHOE5TQitDK0NqQ0FpUFNabVdibTdTOXNIV1Vw?=
 =?utf-8?B?UTV5MnJBa3djWE5GelFSaG5QdEswZWorRWM0YzNBTzBHaVpOblVqUU9ZcEtT?=
 =?utf-8?B?UU04U2QrMW9HaXc5bUxCRWJBMjJUWG1mbnUwdEE0NTB1RTlTVzRYWnM2UHM3?=
 =?utf-8?B?Wll6VExvTVp0Z1NIK1JuZkQyUTZMOVpmaEtzVlVlSlR0UGpsem5pTEExcVYv?=
 =?utf-8?B?Vnl3TTVGdDF2MmlwNEFwVForRG5RemhSeUl2cFFDdXlaRWxrVkRPZ1NtQVpk?=
 =?utf-8?B?YmlmeGo0UUFIbnFNeVdRV2dVRjNiR2ZJVU5JZGIzZWhmSldySGtCZzZJMktD?=
 =?utf-8?B?WXdwY0VrSk8vTC9sRTlwWnh2QVI2d2FzYzVlWVdTeVdZU3dDcGVvM2hYTUxB?=
 =?utf-8?B?ZTFUV05mYmdHNm9UVU1ZeU51cUZDS1ZXZ05uc1pEZmRHdWlIdEZWb3pTQlA2?=
 =?utf-8?B?VnhVNUN0QU45c2RaaXNEVElKSDFJeTZ3NnFJYms4bklnQVhPdDVOcHNnakdv?=
 =?utf-8?B?Z0gxRks2RjFNeDVza0M3eGoxcGNQaTVYcVdrY2RhNWxIRDg5bjBucXFBTHM3?=
 =?utf-8?B?VzRqR2FTWEpNRVJvTjN3cnRTbWRxTmZieXJCbmxiOHk5Ti9aQ21DMEZ0b3hK?=
 =?utf-8?Q?biY1HA7Qm4rwG1OLOrs+ba4PA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 17b320ba-cd6d-486c-4ebf-08dbd138c7d3
X-MS-Exchange-CrossTenant-AuthSource: IA0PR11MB7838.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 06:50:00.7159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ehsuYPvZqQ8OaQtA1Zc65X+GC9Cp+DYHtdvWCAtIwxGbajYpQgUXbjtxAQM6FwLRsGt04g9wmLNcLDz+G3H4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5121
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/17/2023 12:51 AM, Jason Gunthorpe wrote:
> On Mon, Sep 18, 2023 at 06:25:33AM +0000, Yahui Cao wrote:
>> This series adds vfio live migration support for Intel E810 VF devices
>> based on the v2 migration protocol definition series discussed here[0].
>>
>> Steps to test:
>> 1. Bind one or more E810 VF devices to the module ice_vfio_pci.ko
>> 2. Assign the VFs to the virtual machine and enable device live migration
>> 3. Run a workload using IAVF inside the VM, for example, iperf.
>> 4. Migrate the VM from the source node to a destination node.
> It looked better that the previous versions, I wanted to take a closer
> look but the series didn't apply to v6.6-rc6. When you send v4 with
> the compilation fixed include a git link please
>
> Jason


Sure. I'll send next version with compilation fixed and a git link.

Thanks.
Yahui.

