Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8B76E845C
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbjDSWEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjDSWEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:04:12 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9FC49DB;
        Wed, 19 Apr 2023 15:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681941849; x=1713477849;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CXcU8xpV9gO+Q/hBq5JjmNs+2TV8XBgPkqNdbBMTEO4=;
  b=gUFrnkuHAmwiCtbJROyTVCkkfUiRCSiqfD5WTy1OKfAPROI1vUUpKdLw
   mBfTFuvg/DC/lAtxkMinKj4yn1M4C8EOmLXjqEX+DMRcB1LOC3u4LizX3
   qw0y1Y2M+xlQ5+NfocEo0TlsEapSgOmdbrIPYv5dIWrN7ADuYpcmrwy+3
   tiF7GbUF5d5MU5gmm0AprpUlWGcrBnfIdqBYkINl2AkcRyaxQV92uDFAY
   G+I/3GHJBKYwuIpC/3it6qNqNI/oasjSPZuBru2zIU2WB36R4N8PYHrvK
   ddpCWN37k+l60x0n5siPBD8/MwMTpFep0siQXZu0U0fb1QVXPFmSLc8W4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="325181491"
X-IronPort-AV: E=Sophos;i="5.99,210,1677571200"; 
   d="scan'208";a="325181491"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 15:03:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="724191251"
X-IronPort-AV: E=Sophos;i="5.99,210,1677571200"; 
   d="scan'208";a="724191251"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 19 Apr 2023 15:03:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 19 Apr 2023 15:03:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 19 Apr 2023 15:03:22 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 19 Apr 2023 15:03:22 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 19 Apr 2023 15:03:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V35HZ/ctO4nZH532jNVNMdZAnDVn+xwqaXUPNJCniafrTaXzU/XDG5qFRu1vfPzLG5WbtAsASVUDpFRMbY0Cq3+FPYWVUUYHSKpysgIDOUAnj3JO5pyTuXWQmzWixBsVsH3Q+SM1Rj9L8yJyuO1aipSGURjvXQhPCdcw244Im12AegGX/XAsiqaufYrvVCw7/Nza9hp14NjTb0PJ5eUcWBD+MCkiCfl1q6I508IwPchR2FaiDzz6QfroRBXfoAGhqnJ6Yus6rgEy8Gkpo9IjumCknQdtTYf72J5qVfrVu5ChxPBdeGRrrXAC7QXLuA6HbffJOgmZt58qiNxgD3ntvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xN+dwuwCfSz+XR8QceKFgCrX/nhdqy/zNvhMPMmuo3c=;
 b=WeBxU0vbzdSDJ8/brc3Z09xORYO7Vxoacnvsk27UBipUwdyZE/IZ46ORi60zS/aW/winZE3eumZFJJxaYFIO844zN0+Y8ZeMGnaw3vWa3L3iwvVQU30fTfBi2NsLzM5QBJ7e9lKB/kDdwPThgHIhLj12MKW63+5ExVTcW4jricERJ5+sFi8SiCLWO5eE5L2F5juSw9T9mJ3+pS8IK7PV/lmzCMerzZs3/ov1uRLoFsC2uNQJe3EHBWWw/ruNEIoL/NG2nCB5wkfy3iuu9pa/Sm3MC9ODGR7AngjRxzpDW3/3WDEQTjMkOYfUUrFMmk54W5/s5hEXdiSqZl0kDpJ6Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by CY8PR11MB7778.namprd11.prod.outlook.com (2603:10b6:930:76::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Wed, 19 Apr
 2023 22:03:20 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::4bd:cce2:58ce:cd6b]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::4bd:cce2:58ce:cd6b%3]) with mapi id 15.20.6319.020; Wed, 19 Apr 2023
 22:03:19 +0000
Message-ID: <9fe0b270-c2c1-8b36-5508-d26ae79a9b2a@intel.com>
Date:   Wed, 19 Apr 2023 15:03:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH V3 09/10] vfio/pci: Support dynamic MSI-X
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <tglx@linutronix.de>, <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
References: <cover.1681837892.git.reinette.chatre@intel.com>
 <86cda5cf2742feff3b14954284fb509863355050.1681837892.git.reinette.chatre@intel.com>
 <20230418163829.149e8881.alex.williamson@redhat.com>
 <f0d22db8-213d-92f7-963a-9d015c0a9d79@intel.com>
 <20230419153804.7ad0b122.alex.williamson@redhat.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20230419153804.7ad0b122.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0058.prod.exchangelabs.com (2603:10b6:a03:94::35)
 To CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|CY8PR11MB7778:EE_
X-MS-Office365-Filtering-Correlation-Id: c0d9e679-2ffd-4976-253a-08db4121e1fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2CAS0pyDlYy1+VIwyw6iX47BOQ+0jmfqSopgUnLnAdcp7+5QvM65ORSlodjPN8xPpZZQz9ujnl58/5Xl6rO6wKUgwXfiPTfOKOp6D6IizasEE32H03FD6CUc4U8lXOozEMY1lpreuJZDcZDXHmen7RvUuqY+am4SK08lQoLVwTIV7r5XQrCsAhw+0ovPxgV89FXqyxRGWAzHS5mnWS99+92jTy26x58b3TbDl54OAemBQbvZ85NQSSuuIOLqDl7OtRaXYraqtBNIR61ivV0oaYIQcBzUwDk5SV0UKGfpG2JzNzQxlYD50J6zAGtuCqYfWL1QbWSAMeGRd0+duHuTWV+Go1EUGUQVDuLaVvU/6qM360V5kM9fHVnOPj5SSQy3pYCIKX6z5QEOKrpOprip3vfWu4pDPoTsGNwMI8qWH13ZhmDOHKkTRPK1KTGTuuN8EOu6FnsqnyGqpI+kl58aPvjb3gcUtMkNPq7BdtRpbbHinBqvIKu5ifPRKRXyT/1Pq7WeDaQEMHrhyV9fd+fbZ13pc+6GtG/4FYiVyaulA/L/23dleXU4OOTFhOO1vqEccDTX4HQYEyM9NpbKoCKfenemUWuK1qiJZ9snxUIJr3cxHgWsbz3RMep3T89Dn3+JDcTBxB1IoGUa/BYEjuHflQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(346002)(39860400002)(136003)(366004)(451199021)(2906002)(44832011)(2616005)(478600001)(6666004)(26005)(86362001)(31696002)(53546011)(6512007)(6506007)(6486002)(36756003)(186003)(82960400001)(41300700001)(8676002)(8936002)(38100700002)(31686004)(4326008)(66556008)(66476007)(66946007)(83380400001)(316002)(6916009)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0RCcWRQaVhKTDFTTTBLTUNCSEduajlrNXlQVExXejRQMEdMZStqbGt4MEUz?=
 =?utf-8?B?Y0lDVWNvVWNYVytRWGExN2U3Vm9UTEkyVDlKaXNkTk8rbkw0Y3dkczVoTmFD?=
 =?utf-8?B?Z0VIcmpSK3BzdWw4eHRlbVJEZXJveFg2azJrNFhqQkNaZnFwZkgwNS9kWGl3?=
 =?utf-8?B?LzJUbFNnTkpadlFHWlZScXR5dXBrYzIxUHk5di9QT25HUzZsNzhuQytNdDJz?=
 =?utf-8?B?RERkbVc4RVdGMkZjWkY3cWJWKy94Vm5mRTl1TlM3UmZLUS83aW05cjNNbVV4?=
 =?utf-8?B?SVJ3RHUrNDlmRExCK0lHTUx0aFArY1p0YVZFYjlTOVl5V2lvVGlkT1lGLzhq?=
 =?utf-8?B?MGcycUpBUnM2Ty9GbTYrRDFhbnN0NmNrUXdGQ3puT003VG9WSFVmeDdCTmJI?=
 =?utf-8?B?bm5Wb2xqSllTeGxLK1FLTis4YlRKeTRtVjFETFlXRTNqMzUxV3E4T0toN3Ba?=
 =?utf-8?B?VEozeXEvR3lkbytZZzZoYTVsTE45NnhTZnUvaG5pMWgwMk5mUFMvbTY0WEd5?=
 =?utf-8?B?V0hQaGZIdzdUNytuQnJLbUgrSDhVMzE0TVNteG9kZWdhYVdHUGJETU43L3FY?=
 =?utf-8?B?NlczbnVnUkkyazdBcFd0MnNkTzJaTGYrR0RvVUNFc2t2TlRvZSt3VkxHcEU4?=
 =?utf-8?B?VzRpUGc3UVdYWFQ4YlRwZTVDRG5zaWVnWngwS09uMEtBdEpPZXFCcHdVcW9a?=
 =?utf-8?B?MnJKWHlpTTM2Q1Z0R0dMeDZnUEpnUnZQMVF3RTd5aHJ2NXdMVU5ISnRxWmI0?=
 =?utf-8?B?aVZYcHJ3RnduQTliNUV1WjNaMWI1b3k1R01wdVltNTZWeWpnZG9YcTBuSTlI?=
 =?utf-8?B?dzRzYVZUN2ZrcEdZTllWTnlNWm1oVytwZmJQb2tncis3SUJHb2l2NytueWs1?=
 =?utf-8?B?NU05cDJiOUFSR2tJZnZMSnRVQTFQNEw5WUpITFpwUzYxSnNFdytrWTRORHUy?=
 =?utf-8?B?SFpxOHIyMGx5RVRETzdhQjlDdGhneC9XaVNUc2tLekJNTVo5V1dCQnNmUVg2?=
 =?utf-8?B?T2JUWWEzZzBsR3BGMmtBNTkrWm94TDFrVDlNYTZRNk1mLzVobWQ4dWpjcUR3?=
 =?utf-8?B?b0RUc1o5RlIwRWJYR0M0WW1xNHVZcG1HV3E4MmQzWmI4TXBTQ3FRVFp3WHR5?=
 =?utf-8?B?TGlRRDJYUHUrMERzUkZIUEZLMk1YZ3JUd0s3RGZuUWhIRkZaRzJ1aFZ0WVZr?=
 =?utf-8?B?S1ZDRTM5NENTOEc4MXdNU1ZmWkxZaGdOSkRraTJsR05MQ2hxZEFLTCt5VXZw?=
 =?utf-8?B?WXI1d0oraWIrb1dDcGVBelhYL3RxcXVCc1k4WTdKMVBqd1M3bUVXWDRPT25W?=
 =?utf-8?B?S0ZRNnRmN3FuOHBlWWt0ejZrM2Q2cUhOK1MzOWpDTGwySTRjMmxJQ0Nqdnps?=
 =?utf-8?B?dWV2OCsvL1BKdkQ4b2l4eVFJOW92alJwa0REdkJXRytNaXdtWUFtL0FpaXYx?=
 =?utf-8?B?Y2RkZWRYMmE0dmt5MWp3T0lUT0t6T2pmL2RXbVJBdjBnL293MGdTQnJQTTJ0?=
 =?utf-8?B?WUFZdUUyT1FZSkZDU0pyMG43ZkFzaDFJYUVJZlpMYlFicEJPWkhuUG11Q0tG?=
 =?utf-8?B?akpHRGhleEc0NXczMFdHNE5USmgzTXEwVE5tNVN0dlBwU21WVEZ3SXNNdEkx?=
 =?utf-8?B?ajJOWXFiODRwQWhwTUhiMjdCSlFmRGpUbUlOWWQ1bzBWakZjWnUzanFrSUF5?=
 =?utf-8?B?SDYvTVVheERFVnR2M1l5cjgwS0hKd21HelZWU2lwamJLTW9UM2Vzb1hnSUwy?=
 =?utf-8?B?anJoMDAyUGtrOFRvY1dXUC83YjRQVzh1NkhSdFppUmgzYnAwUytzMFBBOG1R?=
 =?utf-8?B?a3lWcmdXQWZOZ3Y5WU1scE5GZ1ZKUHVIbkM2S2JGc3FXcm5ycWFDWlA1Qnlt?=
 =?utf-8?B?UTNnaFJoR2JhSzBkTDJvMStabVBQYUtzc3Fjdmhkb1JxYnVxT3VyMU5SaHZS?=
 =?utf-8?B?c1ZxQytpZnpwSWtENG5UT3QrdnF1Z01PUkhWaHdXZkQxckpUejVCLzhxeGF2?=
 =?utf-8?B?c240aXF1TEl4ZkdJSWZYWWdQVVhxM0ZZT1BZUTVrSG5FOW5aN3J4TkpFWWRI?=
 =?utf-8?B?Z3RFVUFHWXJ6TVIxeHM5NVNVaktQVnhzOXRUUUNGYjJ3R01tdHNuS0VGRDlD?=
 =?utf-8?B?ak5jZG5rNHAzUHN5TUxITk1sQVYwRStNeGdXRGtRbmh4VU1sOGlCZlgvZXFZ?=
 =?utf-8?B?NFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c0d9e679-2ffd-4976-253a-08db4121e1fc
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 22:03:18.6516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zXkstmYvXeqy+bb4EAMmdS0IAkdfvKjj1d7TGh7S+JNAmRSMs9Xl5WqQd2xQnJigd22Ga5gkfWmDd9ssLjO9zw1Lne9Ntr2pJEY0pVttRSE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7778
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 4/19/2023 2:38 PM, Alex Williamson wrote:
> On Wed, 19 Apr 2023 11:13:29 -0700
> Reinette Chatre <reinette.chatre@intel.com> wrote:
>> On 4/18/2023 3:38 PM, Alex Williamson wrote:
>>> On Tue, 18 Apr 2023 10:29:20 -0700
>>> Reinette Chatre <reinette.chatre@intel.com> wrote:
>>>   
>>>> Recently introduced pci_msix_alloc_irq_at() and pci_msix_free_irq()
>>>> enables an individual MSI-X interrupt to be allocated and freed after
>>>> MSI-X enabling.
>>>>
>>>> Use dynamic MSI-X (if supported by the device) to allocate an interrupt
>>>> after MSI-X is enabled. An MSI-X interrupt is dynamically allocated at
>>>> the time a valid eventfd is assigned. This is different behavior from
>>>> a range provided during MSI-X enabling where interrupts are allocated
>>>> for the entire range whether a valid eventfd is provided for each
>>>> interrupt or not.
>>>>
>>>> Do not dynamically free interrupts, leave that to when MSI-X is
>>>> disabled.  
>>>
>>> But we do, sometimes, even if essentially only on the error path.  Is
>>> that worthwhile?  It seems like we could entirely remove
>>> vfio_msi_free_irq() and rely only on pci_free_irq_vectors() on MSI/X
>>> teardown.  
>>
>> Yes, it is only on the error path where dynamic MSI-X interrupts are
>> removed. I do not know how to determine if it is worthwhile. On the
>> kernel side failure seems unlikely since it would mean memory cannot
>> be allocated or request_irq() failed. In these cases it may not be
>> worthwhile since user space may try again and having the interrupt
>> already allocated would be helpful. The remaining error seems to be
>> if user space provided an invalid eventfd. An allocation in response
>> to wrong user input is a concern to me. Should we consider
>> buggy/malicious users? I am uncertain here so would defer to your
>> guidance.
> 
> I don't really see that a malicious user can exploit anything here,
> their irq allocation is bound by the device support and they're
> entitled to make use of the full vector set of the device by virtue of
> having ownership of the device.  All the MSI-X allocated irqs are freed
> when the interrupt mode is changed or the device is released regardless.
> 
> The end result is also no different than if the user had not configured
> the vector when enabling MSI-X or configured it and later de-configured
> with a -1 eventfd.  The irq is allocated but not attached to a ctx.
> We're intentionally using this as a cache.
> 
> Also, as implemented here in v3, we might be freeing from the original
> allocation rather than a new, dynamically allocated irq.

Great point.

> 
> My thinking is that if we think there's a benefit to caching any
> allocated irqs, we should do so consistently.  We don't currently know
> if the irq was allocated now or previously.  Tracking that would add
> complexity for little benefit.  The user can get to the same end result
> of an allocated, unused irq in numerous way, the state itself is not
> erroneous, and is actually in support of caching irq allocations.
> Removing the de-allocation of a single vector further simplifies the
> code as there exists only one path where irqs are freed, ie.
> pci_free_irq_vectors().
> 
> So I'd lean towards removing vfio_msi_free_irq().

Thank you for your detailed analysis. I understand and agree.
I will remove vfio_msi_free_irq().

>  
>>> I'd probably also add a comment in the commit log about the theory
>>> behind not dynamically freeing irqs, ie. latency, reliability, and
>>> whatever else we used to justify it.  Thanks,  
>>
>> Sure. How about something like below to replace the final sentence of
>> the changelog:
>>
>> "When a guest disables an interrupt, user space (Qemu) does not
>> disable the interrupt but instead assigns it a different trigger. A
>> common flow is thus for the VFIO_DEVICE_SET_IRQS ioctl() to be 
>> used to assign a new eventfd to an already enabled interrupt. Freeing
>> and re-allocating an interrupt in this scenario would add unnecessary
>> latency as well as uncertainty since the re-allocation may fail. Do
>> not dynamically free interrupts when an interrupt is disabled, instead
>> support a subsequent re-enable to draw from the initial allocation when
>> possible. Leave freeing of interrupts to when MSI-X is disabled."
> 
> There are other means besides caching irqs that could achieve the above,
> for instance if a trigger is simply swapped from one eventfd to another,
> that all happens within vfio_msi_set_vector_signal() where we could
> hold the irq for the transition.
> 
> I think I might justify it as:
> 
> 	The PCI-MSIX API requires that some number of irqs are
> 	allocated for an initial set of vectors when enabling MSI-X on
> 	the device.  When dynamic MSIX allocation is not supported, the
> 	vector table, and thus the allocated irq set can only be resized
> 	by disabling and re-enabling MSIX with a different range.  In
> 	that case the irq allocation is essentially a cache for
> 	configuring vectors within the previously allocated vector
> 	range.  When dynamic MSIX allocation is supported, the API
> 	still requires some initial set of irqs to be allocated, but
> 	also supports allocating and freeing specific irq vectors both
> 	within and beyond the initially allocated range.
> 
> 	For consistency between modes, as well as to reduce latency and
> 	improve reliability of allocations, and also simplicity, this
> 	implementation only releases irqs via pci_free_irq_vectors()
> 	when either the interrupt mode changes or the device is
> 	released.
> 
> Does that cover the key points for someone that might want to revisit
> this decision later?  Thanks,

It does so clearly, yes. Thank you so much for taking the time to
write this. I will include it in the changelog.

Reinette


