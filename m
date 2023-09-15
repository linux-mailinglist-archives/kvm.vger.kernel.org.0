Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F42C7A164D
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 08:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbjIOGmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 02:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbjIOGmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 02:42:35 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A2DCCD;
        Thu, 14 Sep 2023 23:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694760150; x=1726296150;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fbFNWoG87CkGWumd9CDqbSMn/0iKQi7CjuLIhO+Im/E=;
  b=es52aVU0LG0ucCMRCENe0LtWdPSEzX9yrpAXhrHNb28TS3xNFaDSlt9l
   MIc8BmUbhBP8u5h/hPbyQf/Z3UYd0VLP5P44oAWvKlhAQR5iN+MCO5c9V
   hL47nun431j75CY472Aakmf2Yjqa7JVYg+9sNf2Wa+zw18kRKEGCoHlyH
   NUsUG17C8WOb/ONtb1x6XR3DEsy2Vd2z6tO87U6irWqw7zY7RSfegoP8f
   toReJMs6puUJHkdIfMjQVwZp3GEtr777Dw+hfyuVCFg2G3vaewobfBiLF
   w6SGJQ7nIR6EDLUnv53++haeybuXCRJgT2HUWVQzcBJMxP/fUXh85HI4b
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="358587939"
X-IronPort-AV: E=Sophos;i="6.02,148,1688454000"; 
   d="scan'208";a="358587939"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 23:42:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="888120142"
X-IronPort-AV: E=Sophos;i="6.02,148,1688454000"; 
   d="scan'208";a="888120142"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Sep 2023 23:41:55 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 14 Sep 2023 23:42:29 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 14 Sep 2023 23:42:29 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 14 Sep 2023 23:42:29 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 14 Sep 2023 23:42:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eO8doeMnvrohxbgQKErjQ+Rg0RcFHONa6/lcRHsvZpq2P8jHulP8rPPY9M3rNa4/WJpP/z9CJSq6D0K/p2mF70zVeb0wRnViW41pAKv/1yriPsoaMF8i/GXLv8BKyJqsvhbGqc8Opuaqj6UO8/DVsmCFSG2lYZqSEu7MzNDNSH/Tiqe9Gb49i1rkF7aZn3fo6/7yy7iLdPIEaQC4ebPx9kH5b9dtPZJS96Mgb8OuDs5k7OziY544Ubyw3AOx35kgIEiba9f27HLSsWvkJ31EhDz9X1r/R34cd8b9MNdFT+nGRaF2K+XIvabGdIEEQ3HYJ54ltV5U/XAcAnP0RWIQqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fbFNWoG87CkGWumd9CDqbSMn/0iKQi7CjuLIhO+Im/E=;
 b=HqEcHopX5g7KOWL+fwXw5h2GNkd8dxWOk99Olh4opTRHmxue3d5IAGUBjmlM9P0A6+IiSfwCOy4KXNiQgVzArPHBsudkG38+2LYXj8VqyHvlz8AUncNGEZGiztvfvUFha5h2MVQvI8olPqAefCc73R1zpOVcdkZkzqaQiLgjYDD2AE8zZ42Hvx6EIgE2IL92yH37ddQyIFRDAKs5QwaMX8cNRvQydHY93vRSQaMzLSkwMklaIK7U1NhrzpJwsidY/IpPq6lqi0cadr/8TXFeYO67aZL+0qF80nMTvxOq6IpHCgUcdjPIKu5vI/uOlIzshdN6/aRNYj+JyZOwEgU3wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by LV8PR11MB8557.namprd11.prod.outlook.com (2603:10b6:408:1e8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.38; Fri, 15 Sep
 2023 06:42:26 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90%7]) with mapi id 15.20.6792.021; Fri, 15 Sep 2023
 06:42:26 +0000
Message-ID: <eea8bf26-1c86-8e2b-9ded-cb0d09c08fcf@intel.com>
Date:   Fri, 15 Sep 2023 14:42:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH v6 04/25] x86/fpu/xstate: Introduce kernel dynamic
 xfeature set
Content-Language: en-US
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "peterz@infradead.org" <peterz@infradead.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "john.allen@amd.com" <john.allen@amd.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-5-weijiang.yang@intel.com>
 <f16beeec3fba23a34c426f311239935c5be920ab.camel@intel.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <f16beeec3fba23a34c426f311239935c5be920ab.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0193.apcprd04.prod.outlook.com
 (2603:1096:4:14::31) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|LV8PR11MB8557:EE_
X-MS-Office365-Filtering-Correlation-Id: 81c2d9e1-f3d3-4915-e885-08dbb5b6ec71
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XLD0qlVK6tIJg2K+a2vQocSYvusiqI4XzbrqRpWu/9ufm6Q4hCzW5M34w2ErOxLmWLKeXRP/26aHV6D5P4MCtW0BtY/ujmzLre1u/dAKtWLjaVxBzArIHC77CuefTM2thA4+Q6nWZUECchvLJcee7UpqSpMa4OFp/3uzPUa1g1TJJ7ML6BMEjzC986Mi3Pfegc36O14/HFtuPxlb2a2UhSkXi9MxBWfXvZmjCJoHicLFrNAk1OdgGQFwTCsgQNS2W47EPYA/NgogxMJ1a5EqbXjJzocV2x5syYyh4/6k58lh5g3SgyBlNx/p+YkiHhVyjQBClnsMv5EhOBLXddHQpdazbN0V2ReB3WIHXvTP6qQHAFTGe6ePUCGeu3U4lj0nlFhY90dZKY8Mp6wr7v9xxDcpeJenNMadrvboA55Hz8asLWyOe3jYOwGWTzdliusMfodZ7i2tG/OMu1hEnkyPBH07qzCcagGni6XKBnkTG1QMLNejAazG69fnxId4G9HdfmLb/DVjVCj1oCcuyvB1XfAiIIevabJNi6RGm1VJrPwniIR3A4VtKWBYtPQuNVKvI65gAluVJlp/X3BoqK3V6+SEftpRyLeFQ9GgbOL6oDRZYMzVF/Bzu6PKndo1Ei37c7F/nDIs4wlAN4sTpAy75w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(376002)(136003)(396003)(39860400002)(451199024)(1800799009)(186009)(2906002)(4744005)(5660300002)(478600001)(6506007)(6486002)(53546011)(6666004)(4326008)(66946007)(66476007)(8936002)(41300700001)(66556008)(8676002)(54906003)(110136005)(316002)(31696002)(86362001)(36756003)(26005)(6512007)(2616005)(38100700002)(82960400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eVJLWkJwcHBxWnNlL2lnYnlWd1lwdjMyVlhiMFJwaWlkY2JIQVFtTXE1SUpI?=
 =?utf-8?B?Ti9seWpMMmc1bnMyb3hyV1ZJVWZhdG5oeWRUakd1clkyVHpZZzVLK21UNmpH?=
 =?utf-8?B?bmNQeFFKUTg1VzFYcnpRTFZEakUySFJ3TXBDbGszK3Y5Q3NNK214bFJvL0Yz?=
 =?utf-8?B?Zncvb1VaanE0WFBBTUhCNGI4YVM3cjN2cTYrL0NTaWUxaytxT2J4UXIvckZN?=
 =?utf-8?B?amhvVndpdllSRk9RclVvbUF2Zk55dmVtM1V1ZVNvMkdBZFZYcUd1TkYrQVpT?=
 =?utf-8?B?NWZvcGQxeEVGZXk1Tk1rZTZkYTJERHg2NkFLYVhrc0JnVERuc3VqaXBHR1Nr?=
 =?utf-8?B?R2tCSUd4c29DbDZpcHd0ME02K2dMaGFQWVBUajEzdzk2WHFJYkM1MWdhMXFH?=
 =?utf-8?B?WmkxL3A5eWN5ckVJakw1MGNFK3JlcGNNUDQ4Y2syK2k1WmRRWFMzN29ZYSt6?=
 =?utf-8?B?cDlpbXg1RUEzMCttWEdSc1hQTzd1OFNreG9iSTBCQ2diUWtkNVlXKythamF5?=
 =?utf-8?B?cnphaXN2emxiS2N6R3NtMkY5R3Q2dGlQY3g5RngwdURUV2tieXpCL3JWR0dC?=
 =?utf-8?B?M1JSbHZjR09mTC9qamU1TUxKN2p1bXBBdjNCenRJeTBIaWxhUWxWcEJiSGJF?=
 =?utf-8?B?OXJVNHU5Qmd5UmlPTG5KbHZORHpiVDRLNWNPSmo5cGtMZVZ4YlE1TGZzMGZs?=
 =?utf-8?B?RHVKUytyaExtTXJnbnlaREwxQ1Y0dzdac3k1akFwN3pPVmttQnJ3R3dzem04?=
 =?utf-8?B?dXlENk9WMmh1S29pSE9JQjFVdytwS2xpQ0dwZlhHYXdncHhKZnBlemhzMG83?=
 =?utf-8?B?RHEwd2lYYXY2cUpaaXRFejltZ3QrTFo4N2txNFEwQlZ5N1Rsd3NlaE1CNUUz?=
 =?utf-8?B?cDZaRS83T3NwbmZ3VVpObjRFeFZlWUhXUVByZ2kweFRJV3Frdis5Umt1M1J4?=
 =?utf-8?B?bHVWMFRQa2ovRTgwdG50ZThVMTFWMHQ4K2J3ZkxPSExxc2RETnRObmsyNkJa?=
 =?utf-8?B?cytPZitCOUJmN1ZxZWttMjJVR2tpUmhBWG0zZlVNakZJQlErKzJENlVEYjJh?=
 =?utf-8?B?UnM0dlZPcDJoamtzM2pmWEcxNTB3SEZlb2dqNFpUb1BRUGVxQXpGaGw5NUpy?=
 =?utf-8?B?Sm50YWxIVVdRUE9DL0NtSjJ4UGhvODFxOGM2UzhRVkdVTTdXOGV2ZC9YSEll?=
 =?utf-8?B?bVRzOThVb1lSZGZvY21hYWlHQ01vRzVnWG5velhhckVIVWdzMTVycXI2Wmw0?=
 =?utf-8?B?NzloYmtKYm5HUzlmaDZOSWxXeWVjc3BLTEhMMzZzUHRHWUxvRlZLYisvdktL?=
 =?utf-8?B?QktuN2ZUTVhHQ3Jic2ZpNWJiRzV2WjYxenFJU1gzbEpzRGdqN1Jjb2thSW9s?=
 =?utf-8?B?cDdJemFUZ3pRSXd2c3BYMFdjRVFCTFl5Zk1MRFhwbktHaHhPZWtMZzVtNnZj?=
 =?utf-8?B?a3Z2dkZ4dHpWVHdJSmhYcEpHNWdUQlA1R04zVDE1S1I3eHRZRGlOaG5BVzhX?=
 =?utf-8?B?Q3d1eUVCUmZKZENuNVYwVTFnVW13R3lIQmV3VTVMQXdob3krMzZRWkpnNjRT?=
 =?utf-8?B?N2hpZjZEUXhWOWNENjI5emttZW80dUJKY0piNEVQTERMYnE4Y2o4UTdVUUdm?=
 =?utf-8?B?QURpS2pZdlhiWVphYzVWOEFucmNLb3N3L1dZRUZ4T3F4aVRUYUgxMVV3aGZJ?=
 =?utf-8?B?aldFWUVhSmp6eVpkaTF5UUxhMnY5SmxVSjMxeXowMnp3Q1M5T3lsNTRnZXMy?=
 =?utf-8?B?Qm1mR0NGMkZ1RTA1TWdleVJZVFVLS2w3aDRWZTNHQlpsV0RjZGtSSUhHUVBq?=
 =?utf-8?B?RHJzVzNGSm80NFBGNi8rZVhqVmYxd0luYWVQMFJIS25CMlllSXFEeWh6dkM1?=
 =?utf-8?B?QXgrVGlJN2hTWXJiNXpPWGo3OGZwS2ppVmZ5Y1hFR0UzRHNBZjFMdGpZRG1H?=
 =?utf-8?B?NUc2RFArVlZtb2VBQmU5VmxjZ0ZicTB5WjdBcVhLMDBtV1gwLytUY3NBcFdX?=
 =?utf-8?B?dHNReEdlcHZIYlg0TmdqSTFqdmkyUVEzWkw1L0Q4bGxaZmpBdDNuSC90bFpa?=
 =?utf-8?B?UjQwWWhWck02ZmVGL2ZRL0hWRXlSb0hYSXNOZkF2K1l1RENWYnVJTVpzRnU4?=
 =?utf-8?B?WmVzbkxPNDJUSmZVU211QTRlT1ptUFlMT1pMRVIrUkdVSnloOXpPcHVTakQ4?=
 =?utf-8?B?MUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 81c2d9e1-f3d3-4915-e885-08dbb5b6ec71
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2023 06:42:26.2103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WqQlq7Izv0i5k4MinmHQr5zf6VohC4jbHaUZje4acsBSelE5VSs6WMWA7ubTf6DWasBOMAhFi9G8F1wyXvWykg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8557
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/15/2023 8:24 AM, Edgecombe, Rick P wrote:
> On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
>> +static void __init init_kernel_dynamic_xfeatures(void)
>> +{
>> +       unsigned short cid;
>> +       int i;
>> +
>> +       for (i = 0; i < ARRAY_SIZE(xsave_kernel_dynamic_xfeatures);
>> i++) {
>> +               cid = xsave_kernel_dynamic_xfeatures[i];
>> +
>> +               if (cid && boot_cpu_has(cid))
>> +                       fpu_kernel_dynamic_xfeatures |= BIT_ULL(i);
>> +       }
>> +}
>> +
> I think this can be part of the max_features calculation that uses
> xsave_cpuid_features when you use use a fixed mask like Dave suggested
> in the other patch.

Yes, the max_features has already included CET supervisor state bit. After  use
fixed mask, this function is not needed.


