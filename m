Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E98658A97
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 09:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbiL2IkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 03:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiL2IkT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 03:40:19 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E20DF08;
        Thu, 29 Dec 2022 00:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672303218; x=1703839218;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W+79IVNWwMSKeBShiQ+GE3D8iijRoeri4uPh5dvRvHM=;
  b=Iu/mGoNsiA+wJ70NBSkjq4PvxFRwByyzhVrGVClMdWNs76fHX9Wlc50o
   4HeNanLZWWR+zaARUrMyDsc2VuLxGbGa+zg9kckJzZ9aSSWblyxKCIpzo
   JiK5u1eHByiKApuxIOTLJfGePJoSJe+LoVZ4NLareTRXMLAmHm99imR5w
   zCOLD/ZTtrzH4Tds8QXr6IU41iet+o8rXb6Tsc2RGHEPi0lQfHFLBE2j1
   gMqnJYctEFuEURFBD8Q6qbQjhP7bRP7u645vZqFKXIHKYgrmS1FGBoOzE
   l3DAFDNzeyzrlYhGI2bzm8S+WVn2ayMfh5DDbeVOlGzabJ7eDvLAwhVEq
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10574"; a="321085113"
X-IronPort-AV: E=Sophos;i="5.96,283,1665471600"; 
   d="scan'208";a="321085113"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2022 00:40:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10574"; a="722012376"
X-IronPort-AV: E=Sophos;i="5.96,283,1665471600"; 
   d="scan'208";a="722012376"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 29 Dec 2022 00:40:17 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 29 Dec 2022 00:40:17 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 29 Dec 2022 00:40:16 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 29 Dec 2022 00:40:16 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 29 Dec 2022 00:40:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0a/j+eg3pN+NhXLMvmJr64/A8HgWGiF+lFRacwKit3nrqNvgOnuhBI9hDO6jE78Rfyp1EWbfKbq+RVAHhALYbyYcbfffb80u9Yqdv4yxlUr/BHq8bPzTN+L+j9mFzvZfttYhrIp6jvgNQafT2uBeaWbEKZKPKbQjL/MzZVj1NL3d4k0Eh89CHSglLPHuSdMa3zbcF8wYG/H7WdcxDurgSulup0w24k7F/h/mSinxgGNCosTsm2pjvQMeLtelptmGh2JiuYe2yKknKADGHOGEfptNJiP+RJquiImIAI/sveD4BX5TZ8cFL6g+ebxwaT5c6XtaeBuNGxzrB2o62uTxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NjqOHXxDBZ/7VTxjmNt3ZO+OV0EpH1ToO/QHyTXNXJU=;
 b=TpAzSa4LuvAopr/NK5uYNEi11KhptACt58nm1LGYq1YyMXGB8m/aaQ3NS7w+qdLTF+UJZqcyUyQ7GcTQuvsGWFIZsgK6JrGCMIb8qm3dv8IR+kDGcn5P5abv7IFRdc2tgmwBgJpJouQw3ZdWzMZhdIBfVQ29bvtiwA5MDdZmPM7/o4SBK1aW5Z+g4w6/9KAv6t/+sug9iBBADZLE9l1Gy/HAa0jEiOQ6XBy87hxhQoZgOeB+Hi61z7bdQBVZUJE/xA18FxAmfsNCmM723D9b0Qm2VB8wqqgIIVHQ1lmW8qFFm5ra1OcVJY0Ss2JA+BgSupw9c4a6BUdJYxLctdtKlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 08:40:08 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe%3]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 08:40:08 +0000
Message-ID: <ec4f0298-f169-4f23-5dc5-3e3cba2a1b24@intel.com>
Date:   Thu, 29 Dec 2022 16:38:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [RFC PATCH 6/9] kvm/x86: Add ARCH_CAP_VIRTUAL_ENUM for guest
 MSR_IA32_ARCH_CAPABILITIES
To:     "Zhang, Chen" <chen.zhang@intel.com>
CC:     "Gao, Chao" <chao.gao@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20221210160046.2608762-1-chen.zhang@intel.com>
 <20221210160046.2608762-7-chen.zhang@intel.com>
 <d4dec151-553f-e762-7fcc-81ae82b5c211@intel.com>
 <MWHPR11MB0031EEA971FDA614271C22449BF39@MWHPR11MB0031.namprd11.prod.outlook.com>
 <cbbdb23f-4261-4f48-4143-c5fb6c78da06@intel.com>
 <MWHPR11MB0031974C4A46C1895FF8C9929BF39@MWHPR11MB0031.namprd11.prod.outlook.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <MWHPR11MB0031974C4A46C1895FF8C9929BF39@MWHPR11MB0031.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR06CA0018.apcprd06.prod.outlook.com
 (2603:1096:4:186::8) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA1PR11MB6733:EE_
X-MS-Office365-Filtering-Correlation-Id: c8d6c4a9-f79d-4a91-dbc0-08dae9784a84
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s9cLW+FZ1iB4QgnjsbLg4DxE++yqu/sU18jdDqV9DdTiuH540doNAypr/JKfJ/BTjDJkp9LAW2MTIJJNXPc7T8GSaJGdNR9UhjB5prs2Mhnl522RBHULuGmQ7tf0md77WpNQ9Jo0ABXBVkFM5vUUziGoI+acazaIGTWBn9STQ8xjc6dCKXasXWDLl9zKLMzAVkpna1BzeoW1OoeAIZ7dY4YdO0W5DgCYLE4mD6QdgLUGZNw39biNouRxLg1ah+KALnySkLMf5ZI03eSIb5RJXHMyZt2FQOOBj5ji/wqcLKbkQsHffslg4Nkx3U8DRHrJeu7xklRYh8/BA1bmkit5FrB0nObXhC/4TAlTaAKHGOZxX+oRbMKg0h9KqeMifB5zn498y1fPx9dBfZyFfYF4L205GE6LM/hsSUJYMRds+zNoThY1uR8O1NUR3zjI25KXrFelkWX7Ddg/vVasJ+J/P37ADIPTf9jTPudcsgJRg/KyQnC1KfisDZg0vlt2O4fkRjidTaZXo0T/syDI6oLfrTKiwlP4WeElHLZPQw0sQGPQtls/pqvDKqOcsDrpPpoZMEOKVOhbI9zLRho+bQEZt0TmQpXKVwDSZG/uL4BspLiKGKo6Ctkng53is0hbCg9uveh0ZhXTBl079cswoYpyRsQV+m1iad8vzBoF7OAgzbCbC0PCh+HglXWMBVk9BLkFKlcjHFxlB5HEocAI/BPwad9a+v5ePQ1gA+i8P8UmAv3NmkLIdqaEhuC2uvIDj1ryu5pddHhRwzD9oU/oy/OVyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199015)(82960400001)(2906002)(5660300002)(7416002)(41300700001)(6666004)(478600001)(966005)(6486002)(6506007)(6512007)(53546011)(186003)(26005)(36756003)(83380400001)(6862004)(66556008)(66476007)(66946007)(8676002)(4326008)(8936002)(31696002)(2616005)(86362001)(54906003)(6636002)(37006003)(31686004)(38100700002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?em9JZVJ4OUZlMk9oUWtqK3VObW0wL1ZxZXNRcVJEeGJrak1aVzBDNjE0bHVn?=
 =?utf-8?B?TXQ1M2tCNWdRdStZRkZWSDVYVXNpTHpXTDIyVDJoRjM4WHI0YVhrK2puYmMx?=
 =?utf-8?B?alorWEFkSmQrUTkzR1FFdFNacDhxUEg3aU96cGFlL1pjTzQvbjdkRFBSd0pl?=
 =?utf-8?B?aGRnY1o1UjlSdnV0VzJaT085aU41U2tLNnZMaFE4ZmdWUWprSzNOTUEzYk12?=
 =?utf-8?B?NEkxUURyZHRmNHQzRFF4WmpjVDVrWGlzSmxHVzZYZytqYllPKzBaOTY0TmRP?=
 =?utf-8?B?UmYzaG5WWGVxMjRmeG5vblNQM3B5bWdFYWtDNE92UXZpKzdNZUh4QUdSMGda?=
 =?utf-8?B?ZUFzV1g3cFhtVGkzRUtqM3ovRm4xd2w2M01ZZFh2THlyWkFLQU1jekNkT3k3?=
 =?utf-8?B?dVF1WVlINEhId0NVNFdTbDY1Y0RHd2NzVzJ4SWFvUE00N2tWVHdHYm4wSHVk?=
 =?utf-8?B?Z3B0a28wbGxIWFU0bGozMUt3ZFBnUkdWOWF6WXh5eXdIR0xyOFA2dUFSRzBE?=
 =?utf-8?B?Q1pGSzhldnhEN1Z4d1ZFb2doMVpCdDRvMmJmZW5ybi9wazZvRmZ3eXV5UG5p?=
 =?utf-8?B?Vmp5ZTk3YWRwZXFwOXYxK2xNOXBLK2QvK1dCVXlFb1dKZFZoRDJITm9XL05P?=
 =?utf-8?B?UEF3TEIyVzVkRlVIS0xkazJ6UUVZbVp0Y0tVSTJFalBPekJDSXEzcFhsdHd4?=
 =?utf-8?B?ZDRGb3I2OFZSQWdJRXBGaXdzZXZqV3FwWEJQTHNCYjV1Z3BTYXdDZDZUTDZa?=
 =?utf-8?B?cDZRZU95cHU2Q0JjQjlyVlpqZFh4Zk1sYUpvbDBKS3BXUDhoeFBuL2Z3N0NE?=
 =?utf-8?B?SWNMTmcxMG1ObXY2RUJMazN5VkJoYjdXeE40b1hSQVpQV1o1cmdaM1QzQng5?=
 =?utf-8?B?T3JNeGNOQkIwUjI5dXdBQVJ5TTNNcTRuVkxmanBiQVFGVXJOMVdIRTZlejNk?=
 =?utf-8?B?VExuazJnaDc5TUsrY2ZxT213WmRSdHhnbHc0bm5mUlVvR2ZpOVhCVlZkRkJH?=
 =?utf-8?B?aEVzS2UydlhCenV3Q1lxV1hmaGNqMHpQcmRNblplemdIay9nVGFUalhBNUNX?=
 =?utf-8?B?czExUks1QXZqWllDcGQrVlR4UXJsbjVsSzFPSWtCcDNNVUhKRys0dDNETFUr?=
 =?utf-8?B?TWltV1dZdXRqaUdad3pWdXc1dG9XS1hiR284RS9uVXdZcVcvV0JjWFlZQWI3?=
 =?utf-8?B?cy8yTnpUbGVUWXhwQzZSZzdMQTFKYnRLREJMeFJqbmVlYjRVZFRyWlZOVEJI?=
 =?utf-8?B?b3R4VkZlaHNBdTNiMUduaTVMZnJtWWpSN2RIZnMyWFJBd0h1ZXI3NW42R0ZY?=
 =?utf-8?B?UnBsejBhZWwxcmxpL2M5azVEQng0UGtnZmlXYkdQU1FTQi96WUJKaU9hcVFx?=
 =?utf-8?B?amhscFhOMis5M1pqT2N5eUxyVlUyU1UwVit4Y1lQYUNmSWVQRXBqSmNVT3lT?=
 =?utf-8?B?ZU9mUDd5RWxSZGZscyt3M1VmN3JkZG03aDAyTDFobVJ4b0pEaEs5ZFF3eDJa?=
 =?utf-8?B?WmtmNlYzTVBZRjlRcG5ENm8yUTBkbDRxcDd1OEdoSWRmRGtLNm5jb3RoZXBR?=
 =?utf-8?B?U2VleTFxTlJjN2VxbnFWNEJrVXBlK3FFTG9Ca2x1NkhSVTAzSjBKcEJ6NkNm?=
 =?utf-8?B?Z1RsTmNtZUtwbzVwc1I0UCtNb2NubWFtWXVuamRST0grZGZKVmhmWGhRNEdS?=
 =?utf-8?B?Vnh6YzQ0RnkyNUJxKzloM0tHeXZlZ29Ra2RuOU9DSm5lL3M3QktobGF5aUlC?=
 =?utf-8?B?MlM5aDhNSXFPZDU3U0hKWGFEREEzUlBSQ1VhL3RiZVlIT0JXVXE0azhVTE9O?=
 =?utf-8?B?YTFKaDdPblBmNHlRNVpmS3puV0dsZDJneVpoeCtyU3lpV3psbGVmYkNMTXpr?=
 =?utf-8?B?amhpa3I0aVlBSU5INnRuNy9OQTZpMGRMQnV6OWdHUXh3eUE2Z3ZCam9ZcG9h?=
 =?utf-8?B?Mi9CbXk2Z3oxK0twbjkxZmFwallhK3kzQ2d4dVdjRXRNNkNQUm1BYkY1cXZH?=
 =?utf-8?B?ek0ya1BkUVd0MjVHWm9DT2hEWTFzdlZGVmVMRzltb3JnckI5bDNhSlBWb2Zm?=
 =?utf-8?B?U1l1WXB2VjFqNzJ3WmtPb2FPUG1LMTE3OVVKUVdkUDl4Y1NyVmhiQndVMmZj?=
 =?utf-8?B?WUQ2M0RJd2FLNGJQbXloODhrR0VtRk54VzcvYWN5WmVtT0hieko0L3E0eTNo?=
 =?utf-8?B?WXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c8d6c4a9-f79d-4a91-dbc0-08dae9784a84
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 08:40:08.5351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n+4+epQoDMY3W49tdaVudupCSJJRnUQVcB8/UnHXhH/c0YYSEr22CBCkLjKVI9nUC3fr80/havnq8qmsmoRESg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6733
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/29/2022 3:41 PM, Zhang, Chen wrote:
>
>> -----Original Message-----
>> From: Yang, Weijiang <weijiang.yang@intel.com>
>> Sent: Thursday, December 29, 2022 3:03 PM
>> To: Zhang, Chen <chen.zhang@intel.com>
>> Cc: Gao, Chao <chao.gao@intel.com>; Pawan Gupta
>> <pawan.kumar.gupta@linux.intel.com>; Paolo Bonzini
>> <pbonzini@redhat.com>; Christopherson,, Sean <seanjc@google.com>; H.
>> Peter Anvin <hpa@zytor.com>; Dave Hansen <dave.hansen@linux.intel.com>;
>> Borislav Petkov <bp@alien8.de>; Ingo Molnar <mingo@redhat.com>; Thomas
>> Gleixner <tglx@linutronix.de>; x86@kernel.org; linux-kernel@vger.kernel.org;
>> kvm@vger.kernel.org
>> Subject: Re: [RFC PATCH 6/9] kvm/x86: Add ARCH_CAP_VIRTUAL_ENUM for
>> guest MSR_IA32_ARCH_CAPABILITIES
>>
>>
>> On 12/29/2022 10:58 AM, Zhang, Chen wrote:
>>
>> [...]
>>
>>>> \
>>>>> +	 ARCH_CAP_VIRTUAL_ENUM)
>>>>>
>>>>>     static u64 kvm_get_arch_capabilities(void)
>>>>>     {
>>>>> @@ -1607,6 +1611,13 @@ static u64 kvm_get_arch_capabilities(void)
>>>>>     	 */
>>>>>     	data |= ARCH_CAP_PSCHANGE_MC_NO;
>>>>>
>>>>> +	/*
>>>>> +	 * Virtual MSRs can allow guests to notify VMM whether or not
>>>>> +	 * they are using specific software mitigation, allowing a VMM
>>>>> +	 * to enable there hardware control only where necessary.
>>>>> +	 */
>>>>> +	data |= ARCH_CAP_VIRTUAL_ENUM;
>>>> IMO, this is:  data &= ARCH_CAP_VIRTUAL_ENUM; because it requires
>>>> platform support.
>>> Intel defined the virtual MSRs for software mitigations for all platforms.
>>> KVM should be unconditionally opened it for the software mitigation in
>> migration pools.
>>> For example migration from the old platform to the new platform.
>>> Please check the Software Mitigations in Migration Pools section in
>> documents:
>>> https://www.intel.com/content/www/us/en/developer/articles/technical/s
>>> oftware-security-guidance/technical-documentation/branch-history-injec
>>> tion.html
>> If this series running on old platforms, how VMM can set specific vmcs fields,
>>
>> e.g., “virtualize IA32_SPEC_CTRL” VM-execution control, to mitigate guest
>> issues?
> Enable the virtual MSRs does not means to enable the “virtualize IA32_SPEC_CTRL”.
> KVM will check "cpu_has_virt_spec_ctrl()" before set specific VMCS.


What I'm concerned is, if the feature is not supported on some 
platforms, unconditionally

exposing to guest would make it wrongly "think"  the feature is 
supported on HW, but actually

WMM can do nothing to mitigate issues. Read through the patch set, looks 
like guest cannot

even get any errors during feature configuration in this case. So I 
suggest add more

sanity checks. Did I  miss something?


>
> Thanks
> Chen
>
>>
>>>>> +
>>>>>     	/*
>>>>>     	 * If we're doing cache flushes (either "always" or "cond")
>>>>>     	 * we will do one whenever the guest does a vmlaunch/vmresume.
>>>>> @@ -1657,6 +1668,9 @@ static int kvm_get_msr_feature(struct
>>>> kvm_msr_entry *msr)
>>>>>     	case MSR_IA32_UCODE_REV:
>>>>>     		rdmsrl_safe(msr->index, &msr->data);
>>>>>     		break;
>>>>> +	case MSR_VIRTUAL_ENUMERATION:
>>>>> +		msr->data = VIRT_ENUM_MITIGATION_CTRL_SUPPORT;
>>>> Need to check bit 63 of host MSR_ARCH_CAPABILITIES before expose the
>>>> feature.
>>> Refer to the above comments.
>>>
>>> Thanks
>>> Chen
>>>
>>>>> +		break;
>>>>>     	default:
>>>>>     		return static_call(kvm_x86_get_msr_feature)(msr);
>>>>>     	}
