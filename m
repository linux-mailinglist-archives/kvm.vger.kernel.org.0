Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6516D6A9F
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 19:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236383AbjDDRby (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 13:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236289AbjDDRbc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 13:31:32 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1335BBD;
        Tue,  4 Apr 2023 10:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680629416; x=1712165416;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8YsOcamFj/GZ7RdNrOr12BW1GS2lE0s5+Sifae3X/XA=;
  b=TNJPytIvWu2oXWW/UG6FUhTjE1Npg8hbEzC3UimTWFOGjuR8+rCYwXJs
   AWgX/2M2+y2NoLlG46qcJxVaTISnyeK5AoqO11QNs0NkSxPQdbVskdFJ3
   3lOy7tpcyX0wsaXrNITgnq18OdCZ9wHiDYvbYX+CO8U6WbeIT4W+mW0YR
   URDT3hL+9Q7zJVZb0Bwk+7Wb9+y4uRjy8uXsa4cgGdE7rwUglXFguUeLa
   TC7xxxBWkC4jCHH44OGikjPTeoo4zQfVFm4NlvAZ+hcc3qoM1BEXlA0aJ
   J8Cuh+qAhOZO76XalMyjIUNf5kwQIMAwbxUMyBpnuW0BBT7M6gMi+rxo7
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="428540642"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="428540642"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 10:29:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="636607405"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="636607405"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 04 Apr 2023 10:29:21 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 10:29:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 10:29:20 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 4 Apr 2023 10:29:20 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 4 Apr 2023 10:29:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJZCg5nbRuDDarCeUNSCwZGGa9pSdnL3xZ5rkDPdlRZzosoua0+8XSSmKMfUj3xESO2u+5xj+QQ+iuYClhqx6+IBaWzJLmgOYGk+m1ggPkgQ0UBNlm0x9+wz0Xi0G5MkJmtm7ZQ9GRvej8dEH+y4Q2sSuid88LzMHK2Qo7m70qE61EIR0/8uRQb2l/I1hSJHIHqlAOnEEb0QxAy8s4ZNeJxXKE0nghLbVnqHf6OPMvQujpAltPRnNGisIIddoe5PV2VhWoDw69r2ErfxB5c7xZPa4RfsG8MU3t/WZ6N73hdCO9X/pxrUZdC93vAdNfDht4Fr7QXVYifnXEqsLQmbLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q7pYe5nFBH+3fEUutnlHIZ9ZYnXTcqQ3fLzLp8VJokY=;
 b=JsvP6Xjxgqfl+FG4M0rKVCWlqGwYTQALsEjFRuPiHPtp1QlQaXCHmq02hEo/Z6FEiDgKC1HHy84lE68XElt9vINS7EdRveHHz2o2piF/EtC0opLzzvCy9co/7Ek7vb3boklBwcVr5RYEWyruW9hGGe+8czNmWW74D+3XU4m1Ja2BhYe/xYx9f5IZpdxaEB5IdrlZs99zStbsoesAl6FurUs1/mw0UoL/qCknB4kPC6nqnXVkD7KwypjB9/qzL/XotmxBF+ZGq3BJeicjHe2gVsqj5ghQvhbMiIWO9sBu2pzgBsXDbu0qzZ0L5f814rHAv9St0oa9SIUsi3U8VViePA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by PH0PR11MB5063.namprd11.prod.outlook.com (2603:10b6:510:3d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 17:29:18 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f%12]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 17:29:17 +0000
Message-ID: <ad8c9137-bd57-4862-46c8-2c77a21b3419@intel.com>
Date:   Tue, 4 Apr 2023 10:29:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH V2 7/8] vfio/pci: Support dynamic MSI-x
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1680038771.git.reinette.chatre@intel.com>
 <419f3ba2f732154d8ae079b3deb02d0fdbe3e258.1680038771.git.reinette.chatre@intel.com>
 <20230330164050.0069e2a5.alex.williamson@redhat.com>
 <20230330164214.67ccbdfa.alex.williamson@redhat.com>
 <688393bf-445c-15c5-e84d-1c16261a4197@intel.com>
 <20230331162456.3f52b9e3.alex.williamson@redhat.com>
 <e15d588e-b63f-ab70-f6ae-91ceea8be79a@intel.com>
 <20230403142227.1328b373.alex.williamson@redhat.com>
 <57a8c701-bf97-fddd-9ac0-fc4d09e3cb16@intel.com>
 <20230403211841.0e206b67.alex.williamson@redhat.com>
 <BN9PR11MB527626CAE4BA7ECB64F0E9728C939@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <BN9PR11MB527626CAE4BA7ECB64F0E9728C939@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0002.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::15) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|PH0PR11MB5063:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d53c659-585b-4096-f75f-08db35321dc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h4YmItiAhQVL9lMEmm24kHYcA92RFrLCvV9gWL7t9ZSQDmLyn246YgDGXgANivLLul/hmIMd2uVBuN019Gj3aQOJi+0wMD7riYmZ4zhzm2WUU+lpun7f+8FdBKXfWyjxwLjKjzOqAjk8SVJb92X5eUu8Lx9eCidNj8w19KqKUXWnuyv4k2EN0V6DJMcI26TOxl/kfMwWfGd81NEqAxFD91XigULnRkhn1HC8Um4cLutIvRWb3za9mQ9dsg3yJ1U9+MrfGnOcc8J9aDXAJPSV9zoyLM2tvnARc+WFsL3qGk/3EN1ilJCJhU8lvDULAURDbdn3XfU8TDn+CQyMJEkeb6wNABd7viTXqphrA6tCG7bzY4zY49S/gePf6uV56a3Hlq1xEjtTRzEf0axKBUrk68o8P4n8IGNB4gu0CNEsyOzJ3ze68uQKGh27uydtW4tf5axcx1zoXUzr4Q7GUUkbxCbRL9IczIHOVxMO2DNbxwcKWZapBpX4AHIr25TBF+qQG3cRJvSTtVugMqzrTiClR/xnL8nSXp+shwj/QtcQquA5m1UHPsMY9MtvpG2Gi+T0hPLZh7DlGlyy1lkiTSW0KhPayz8ouGOu3Ggzhsv93Z6x8jKlrQ5anEC6O4INhKTZt3+3y55RI8+ZpUffv+qAsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(346002)(39860400002)(396003)(376002)(451199021)(31686004)(6486002)(4326008)(66476007)(8676002)(54906003)(478600001)(66556008)(41300700001)(110136005)(66946007)(316002)(31696002)(86362001)(36756003)(83380400001)(2616005)(53546011)(26005)(6506007)(6666004)(6512007)(8936002)(2906002)(5660300002)(44832011)(82960400001)(186003)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVRROCtpemZkR3liTXE0U2pvK1Jla09qci93SmRrVGZEZ1FPdXhsdDc2bUoy?=
 =?utf-8?B?UjZ0aVVGUVZRRXZWUTdia3pQYnNGaVRXTlFVSXVubTA2UEFqQ1hTMC9HRU8y?=
 =?utf-8?B?Y0lnb3YwQm1FWGIydEdLMDJFT0swcmJWWE9yb2tLMGdrRUp4SWpOU0VhWkdF?=
 =?utf-8?B?S0VZZ0lzK2lwdTVDMlZaRExROWZsdHpOTHJBU0FOcjY4SmNqTDRWdHRNSnBN?=
 =?utf-8?B?ZElERkdXTSs4YXRDUWVGUEZNTUIrQy9PNjhGbkRUdHlZSVFEM0NNeU1XWnNn?=
 =?utf-8?B?blgvdzlvR2xmYXpNUE1sQ1RKbmxIeHk4cXBQVjVOY2ZWUTRFbldlT1ZrVUhL?=
 =?utf-8?B?NGE2cVJNRzZJdkRvWGxvc3d4SXRjczJGaUR5ZXRVekRCaU5sdkhPMVJqbGs5?=
 =?utf-8?B?RDBVVXdDTWRnRis0M29YbG5xUkNuM00ydll6cW5ySml3RS9NdzNlZCtRZ092?=
 =?utf-8?B?ZWJiWkQ4dldQRnU2R2cyZkNrZTJpYjdkQTlLLzNuVDFGUWdSTFB2OTVCQW1H?=
 =?utf-8?B?ZFhMM3dUMHNQaHdsZlR1V2Z1bXZJakZnVnFIajBHZ01QU0MxaE1Sb2tKUk1V?=
 =?utf-8?B?M0h1c1Z4L05VUjRyRVhDYjlldFBhWmVKVkh5YjZzZVpXYzdzbXoxdnh3RnRO?=
 =?utf-8?B?WFZ0SHhaeGtZUllsNVpUU3NJMjkvNmlCZGZFeHBzRTE2SlFKMnAyaW9mckZC?=
 =?utf-8?B?VFFndmtLODA0bUlzWFlQQlcyd2pwK1plSlBEVWl6WEttYlQ4cTN3U0Qvekh0?=
 =?utf-8?B?TXZWdnB5VkZIM29lZklqSTFBNlhXMzVPbGZvS0ptbnVXRlIzaldoMzhzUjJR?=
 =?utf-8?B?dTZKNDltMzFiYXZoZmxDaXhBWFBQc0xKMGs0VjFjVGtEbU5LNDN0ek05b3lh?=
 =?utf-8?B?UlpuYjdvNjluQUE1WWhIMjZMVkJ2WHBnSXczQm9zcDN0TmZXYmRzSmlwd2pU?=
 =?utf-8?B?RDlCT3E5U2tTUEZRRU4wZWN0YVJsbk1ZMnJFTVB6My9VMHU2V0J6bUxzbGN4?=
 =?utf-8?B?em1LR3Q3YUlSa0hCSm5pK1QvZTVPR3htZmhLRHNrVnNZN0pGSXZ3RDJkemdH?=
 =?utf-8?B?UFUxekxvNTQ5OTdKR3lER0p4eS9EYkJxeERRemdlUEdDRTh3dnVZc0VETUl2?=
 =?utf-8?B?TnhPK3lFY01MSWYvWWcrNHNUWFByREV6REJMREVZUlJFejlKcERJTUs2Tk96?=
 =?utf-8?B?RmEwYXJleGNVd3UwUDYzRy9iYWIycnExL2JOdG5ibEZGMm14Z2tqYjhqcHVO?=
 =?utf-8?B?WFl3Um1hV2Z4bWkrTWxwSXBwUlVMay9JaDRUdk56S1lTTzJNK3dKdVFpbnZh?=
 =?utf-8?B?TktGMzJ5Y3FvZnF4WTN2OGJzc3JkYThUeEpUaHRvQWY4NWhVZ3FSbEZXTFgw?=
 =?utf-8?B?bnBMZmhRTmZvZzg2cXk5YjhXS2dqR0Urd0l2UDd5SkI5eFM4RmJZaXhRd3F4?=
 =?utf-8?B?WnlQN3BlZ0FHRTJ0T0tGS3ZtbVJOVkt2M1h4a0prRExubWlNQ2YydHBJWlg0?=
 =?utf-8?B?aVFuQWduSG85NVlkdGJWeWlIT2w2bjh1eDJSRkN2dmx2TFEwTWducURkTS9y?=
 =?utf-8?B?dnNYazAzTStTM1pOakl1aXlObDZMUEdFQXVqRUtrMmtDVFpRVm5NVVNYNVBN?=
 =?utf-8?B?cFNNbVdLQ2c2K29CdUhLbnNmL3pZSkZxNUhsWnNiS01IakxUOWZoRmRvcWtU?=
 =?utf-8?B?Mlh3dSs4clZLdlhlK2NEM2pzanBhcElHbGZISW1UU2JpYkVob3BzejE1NytB?=
 =?utf-8?B?OVphQ1JqeVBFVmhMdC82Z2xlS1hNRThyME9jZkwxdnVrZm1Odm9zK0JmVFND?=
 =?utf-8?B?am51MXQvRThuY2YvcGhaUnZIdnQxVU1OWnVDcFBzc1BmRjVFVU41ZzFHYmNV?=
 =?utf-8?B?OGtHVmxiSGlUOUVNdXAyYUorK2FFMUNtUkhyRmk2SUswbE5nVlVvMmxYVDJl?=
 =?utf-8?B?VERoaC9mUzgwcCttbmJnSUhydEV1TGxWR1YvcUFUaVU2VmQ1OWRsTHpuVlZv?=
 =?utf-8?B?SmErVEZFM0R3Y1RqTEJZT0lVNXFUTDlHdEI3cE1la09teXZSajk3aEJrL2lv?=
 =?utf-8?B?UkNSL2VhcHFrMmhkVFZaTDRUT2RvMTR3c2lMYlBDVGlsSzBQUGhWMkJQdVB0?=
 =?utf-8?B?NElrNUZkRHgyVlRZRXZacjlUM29DZFVFcDMvVU4zUFpLT2tBZktIdTJKdE9B?=
 =?utf-8?B?bmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d53c659-585b-4096-f75f-08db35321dc6
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 17:29:17.1160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a/BDlP3SrhtaxtNF+4mhJ3iqszAAh/dfXKENAo0+SGObcpjVSS0oF3YHEwlTF3HcXKaipsz9JNsA8TaR/26yPs4ZnSIPTZxPPDhoRHSt+M8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5063
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

On 4/3/2023 8:51 PM, Tian, Kevin wrote:
>> From: Alex Williamson <alex.williamson@redhat.com>
>> Sent: Tuesday, April 4, 2023 11:19 AM
>>>
>>> Thank you very much for your guidance. I will digest this some more and
>>> see how wrappers could be used. In the mean time while trying to think
>> how
>>> to unify this code I do think there is an issue in this patch in that
>>> the get_cached_msi_msg()/pci_write_msi_msg()
>>> should not be in an else branch.
>>>
>>> Specifically, I think it needs to be:
>>> 	if (msix) {
>>> 		if (irq == -EINVAL) {
>>> 			/* dynamically allocate interrupt */
>>> 		}
>>> 		get_cached_msi_msg(irq, &msg);
>>> 		pci_write_msi_msg(irq, &msg);
>>> 	}
>>
>> Yes, that's looked wrong to me all along, I think that resolves it.
>> Thanks,
>>
> 
> Do you mind elaborating why this change is required? I thought
> pci_msix_alloc_irq_at() will compose a new msi message to write
> hence no need to get cached value again in that case...

With this change an interrupt allocated via pci_msix_alloc_irq_at()
is treated the same as an interrupt allocated via pci_alloc_irq_vectors().

get_cached_msi_msg()/pci_write_msi_msg() is currently called for
every allocated interrupt and this snippet intends to maintain
this behavior.

One flow I considered that made me think this is fixing a bug is
as follows:
Scenario A (current behavior):
- host/user enables vectors 0, 1, 2 ,3 ,4
  - kernel allocates all interrupts via pci_alloc_irq_vectors()
  - get_cached_msi_msg()/pci_write_msi_msg() is called for each interrupt

Scenario B (this series):
- host/user enables vector 0
  - kernel allocates interrupt 0 via pci_alloc_irq_vectors()
  - get_cached_msi_msg()/pci_write_msi_msg() is called for interrupt 0
- host/user enables vector 1
  - kernel allocates interrupt 1 via pci_msix_alloc_irq_at()
  - get_cached_msi_msg()/pci_write_msi_msg() is NOT called for interrupt 1
    /* This seems a bug since host may expect same outcome as in scenario A */

I am not familiar with how the MSI messages are composed though and I surely
could have gotten this wrong. I would like to learn more after you considered
the motivation for this change.

Reinette
