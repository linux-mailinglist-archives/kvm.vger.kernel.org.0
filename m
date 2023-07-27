Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0CB7648E2
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 09:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbjG0HjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 03:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbjG0Hin (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 03:38:43 -0400
Received: from mgamail.intel.com (unknown [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7A035B1;
        Thu, 27 Jul 2023 00:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690442929; x=1721978929;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pPrxK6dMfUOmu++62YAYbSQjZchTb6r8Y3A4xdvo9Yg=;
  b=oIEX9LLS08ZuDOGRsa+R/37wmYXqMJr07wmmDIg4GSqfXrmnoy7sSHnu
   BVRalpyV++CvpiaNbxHbmbVNhBsMkz4KxgQkTDoqJNGismbGwsJgStAES
   jH9ZeE129oZGY+Z0gBGpg8E3NqQhoa83dcWL8vfWNi14QxzGEJKyZ1YBP
   GtTswdtesR96fWF9PN/8EYo73miTCUFjoQAlp5BkvRgfUI5gFDVqjMvEw
   jCD3ZHR0vTXI+Bd2TloLox1cnL1nS/CH1BUBvxW0n+5n/02r0STZ8LDuT
   6jM0TYQH60Iudpc0IRK6S4/L43Qt7OAoiKDyBNyMBY/VltJKxAq0Oh/C9
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="434508769"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="434508769"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2023 00:26:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="840609292"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="840609292"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 27 Jul 2023 00:26:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 27 Jul 2023 00:26:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 27 Jul 2023 00:26:27 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 27 Jul 2023 00:26:27 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 27 Jul 2023 00:26:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtG9C01V/J9d8Eq3J9KxxJFolXAlCCn1u4gn9XX6JYu974RyD9DflRY69CRoz7QofkgHa6SPzXUqRm2cvKuKbRowQSba1YVJZtLcvCFgaIk8AB464d/FC5hAfd2MFLV64N9KNmwrRdwTxKuehLAokwCCUfKKgM3nV8NNgrOxhU4b2bTXCrWMbN+r+fVxz4knAXzsvC1rddP8ESK9e7nWdLbTX0yoftyAJQKfJSJ4b2R3dsHfwOGcRuUpW+M19COChggCPvPAOeY87xMSpCkCRv5jY4tX0Yeooa7g7Iv+DmQAydS8+56mTUtciMm9QMCYLBZTMihufEhTkcK5kHdFYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xFL5dMfhT3ObMptu4ye6yw8mKpCWP4xspavAmJMA38w=;
 b=Ht2rU80eZ3RvrTaDl679/cIGqStJF0XK0N+w7/+Qvr+LpwLP2EYS7NkgmVTPiaeMVbM2WzitVT9qavPpy2Z/ZVrFTZMo/8Q9SgDmvRPOOaJHwyVWWBFTdbjrjl7k/OYwB8dIgfjrEdq1Bqr/sWBM7lo8jWzMczKpxBXVuN3yQj7G6h1Io4C5G6uwJCHI+EEiXK9fwgxklvHzFaw4ty5khdMz4dZsI4XH96g1t131z89zG/h4cblmAcOeh6ylrkZ8ndsjiFQ0oPvp6wDhjBi7I9c/ULlemIo9WZfi8kpS0o2BkNLLLJOfqNM5zZPD7xT5mWhwa2X9g2pvCGpEiclDIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH0PR11MB4950.namprd11.prod.outlook.com (2603:10b6:510:33::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Thu, 27 Jul
 2023 07:26:20 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37%6]) with mapi id 15.20.6631.026; Thu, 27 Jul 2023
 07:26:20 +0000
Message-ID: <46d43a2c-387c-c037-7952-d20cd6e1f325@intel.com>
Date:   Thu, 27 Jul 2023 15:26:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 17/20] KVM:x86: Enable CET virtualization for VMX and
 advertise to userspace
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-18-weijiang.yang@intel.com>
 <ZMIPeAHn5aN2HVS4@chao-email>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZMIPeAHn5aN2HVS4@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0005.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::11) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH0PR11MB4950:EE_
X-MS-Office365-Filtering-Correlation-Id: 9955019d-b355-4616-7f2c-08db8e72c5bd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5fTIz5uGq17U7OfIVyLtyqE39V/bOTg+whRD4wMFiIjiCOd1uXYy0L91qMiJHrNWxlMiR0OflyMN5PWAElOesq5Nlhj26HXg7uJRicBfLERI3fN7ELPK71SWApAbEgLFIa4pmanBNidMHgK7w2bzues9ZaeMpNhetIhVTyHU0xoGQ7YGl+UsfZFsnDsb9cZB+ZXTbkS56F7z7sh399tAgIbIKQtovBhoIZdODrjKASS/W828Y9QS8uRKt0r/D2y3N/J8MmXpieBNaDiyrgs0R1ibelSWFooYt7l3LH61Likr9i3kZlTVELZmo1X+7IDp9+HehS8fCi20F1mpb3nafiYaQeLAv+bTABkrRvfM/D1v8NQljN1WVVbL2BFGPYK2ppTXqeAplLJTlC+e6wprXWaF2rb97fREQFP7U6ehJYwdDpn/5w4hM1/30M+XrtKttPbxRZO+L+wvi+aciIs81B1R/JHHY2hOh9P9gQPpMq1pbIhhX7v28YkPo2jDYcyy1nPsE9L65xmYkXvbmOB8f4LPrD807oSXojbnVh+WqB0Huvw3Q5dntZHw17w7vPFC9yE0NGjF/3n+uYajfDcEo3k5e4XJlKa6f/6SSXivusQSGthA7MbNSJf4P++Gp46zGJgSP4HkbCi/jDHrXWs6tQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199021)(31686004)(37006003)(6512007)(6666004)(6486002)(478600001)(36756003)(31696002)(86362001)(66476007)(2906002)(4744005)(6862004)(2616005)(66556008)(6506007)(53546011)(186003)(26005)(66946007)(82960400001)(38100700002)(4326008)(6636002)(316002)(41300700001)(5660300002)(8936002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFRTSzh6SHFaUmt5ZURJK3grOUQ4TzhmZm1tait6dXkrVzhjSURaUDBLeHMx?=
 =?utf-8?B?dWxvbnBRaEx0emF5WXplNUhZZXZsOE8wbW5YVW1EMGZibDdhYWUzRElrY3dx?=
 =?utf-8?B?VjNoNFdrSmRIakdEOGxHcmlzTWtvOUI4aHlQK1NxSzkyUVo4VUx0TlRrdjZ3?=
 =?utf-8?B?T3lpUzdkMlNYQ1VPSDNza2hSUHB2UWZUTGhCa0ZaUWZVVXhQY2tCSW96R1Y5?=
 =?utf-8?B?eW5HWmdzbXphOUpZajdpSVM5TVNsMUNWQkhuczM5QUNRWW53S0FBQTlXdGY4?=
 =?utf-8?B?aG1zeDRrcHQvMEFXTzZ0b2dLTzNJVnlSaVliMVRpVjM0SjdnS2wyMktuK2cv?=
 =?utf-8?B?STcrNlZKQ1pzekRkUjFoK2Exa1dXYzkzaEQwSGd6eXJKaWNGbE5LemkzbDVi?=
 =?utf-8?B?THJPVU1FRlF2YVp2ZzJqdUZBNjdBdk5DaFVvVWh6QzlJc242WjdRNDVkS2E4?=
 =?utf-8?B?YlZ0ejRDVXMyTW9IZzVXQUwwOXVQT1k4Y1g5Y0dnaHR2K3F0T3ZIL0l1VGdn?=
 =?utf-8?B?N2RCbHdKcGxkaHI0RmtON2pJY0wyajVtYmd3NTRUTEZSMC9XQnE2bjZ3OGV3?=
 =?utf-8?B?T09wUitKTG1iOThsSzlCOHBRaXBRMnBDQ3pxT0VvSjRNK3BZZFdzaFI4SDFu?=
 =?utf-8?B?RVI4b1JQd3JFMzJYRjZCL1VvZVhmNWVnSDJ0K2t6Nk1GN1E1ZDZuQng4Nk5T?=
 =?utf-8?B?M2RiMDFLTGorNm1URVcxeXlGZktsVXl1RXBrRW41VFZGMDhBZnhOcWhhRFMy?=
 =?utf-8?B?UHNiQU5XSWFnaXc2S3ZZcDQrdmtvelFQeDg0MWFXRlc3aEdKWGFvMmd4VFlJ?=
 =?utf-8?B?VG1ERG9LcVdzNlZhb3VCeFRIdmo5N1h2ZFBCazhJTEVkL2QweE5maW5FaFBu?=
 =?utf-8?B?NUMvTC9NUFFaZmlHdS9DOVFJaTlsSERKYUtzMlhPRXZ6d1dVQmZDYnJ5MmVi?=
 =?utf-8?B?QUJ2Q0lUV000RlNKMzl0Q2E5cUkxdVU2T0FLalErMDFGSzQzMTQ5eWVUamFI?=
 =?utf-8?B?Z0JTYkRYVzZtWXh4cTl2dGREeitWcUpMRnpyTFJ0TWZhTkk1bExuSTQ5V2Zo?=
 =?utf-8?B?Q3l6Y0dlRFRJemVENjFKeEM1NWFQNG5iZWtRYkwzWjd1ejZXcENsbHhGZ2Ex?=
 =?utf-8?B?OVBaTjVXWE1hRWoxdC8yZEh4c29SczlUUGNoWnB6NnZwR01TMlhOdlR5ZGdL?=
 =?utf-8?B?SXRIekdDbTh2c0hUQStreWtjWWxtTGcrNzJPUVVlR0JBNDZ0TldaSUhoSi8z?=
 =?utf-8?B?bURaMVQycFlnYU1hazNkWlc1cnhBNUJiRjNXV2VzYThpcnlzNUtEamtLSVpz?=
 =?utf-8?B?akQ0ZUU2N3RHRW12SjBxbklkT0tmVHU5U2wxN0NNTlAyN2VkTU9YUG1ZdTRp?=
 =?utf-8?B?UWVGQ0oyMVlOLzlFbDYrOWp5M3RFa1d6cWZoOFlwSiswcEpJcjE0SEErRklq?=
 =?utf-8?B?bDIxb2JrRWlzY1ppNVNPMU0zblV0M3BnQ0FIVmYrN2t2bWcwQ2hFakZhcE1u?=
 =?utf-8?B?M0NrcFMwZGdFMm9KTXlqbmg1RmZGdUwzSUVDRHplcUlRR3ZsZFpRWDN5NjBr?=
 =?utf-8?B?S1hRRnR2ejJmdWxoemVoZ2lGeDQzRExQY3k2U0U3SE5qdjV3WHRuRWZjd0F4?=
 =?utf-8?B?UmIyYzBhVHNEcUdkaFBDYVM0SzhZVzNKd095NWFnZzJwWFBucXNkZmdlYlAv?=
 =?utf-8?B?ek1XQXhZcjhCdThYZ3hDem0ySmZEenE3Mkh5c0ZESFF1Qk1DaDVhSnNMWGEz?=
 =?utf-8?B?bUIvdWdYMFQ2bG1nbk90Z0lQU1RZcm5WQTZjOGdoMFFjY0tyTjlZWGM2T25n?=
 =?utf-8?B?YVJobTZCYmxkMFZ0R0FZeXBqZGY5UXBNalZDT0U5eTk2Z1BuVHFhZGlzYnFL?=
 =?utf-8?B?YkR6YjVpZEsxekk4VnVUaGtFYnJGY1RaeEE5cTVqaGZSQkxUTkJwNk11dnNQ?=
 =?utf-8?B?RFdhY2Jrc3RBZXhkYjNESFBQT1llVnNyOWdNbnhVaHZUR3RzMjBKVnNjUkFZ?=
 =?utf-8?B?VFplYVlDTkFkOTdJZU1IdXFyaFRXTWNlSEJEWWVzRk41SkJQeHoxTEZoQ2FM?=
 =?utf-8?B?dUtlb3AzTWIwSDRGcEN2T21Jdm5LL2VzSU1rTlNYc2lwMzEwREdBc3Q2c3J2?=
 =?utf-8?B?eE9DZ09MRWsrV2RkMGMrSzVKMk5KN3hseWd3SWp3RGxZQjBjVDhKeFpMdWdr?=
 =?utf-8?B?TXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9955019d-b355-4616-7f2c-08db8e72c5bd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 07:26:20.1394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4nBXWHsowlA9yIVHRS8bU7yQPghF5wUqdNg9aaX5AN9noeq5niPSj5TtW+OzPtSld28lygoAFsVfkJ7/HIrkeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4950
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,RDNS_NONE,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/27/2023 2:32 PM, Chao Gao wrote:
> On Thu, Jul 20, 2023 at 11:03:49PM -0400, Yang Weijiang wrote:
>> 	vmcs_conf->size = vmx_msr_high & 0x1fff;
>> -	vmcs_conf->basic_cap = vmx_msr_high & ~0x1fff;
>> +	vmcs_conf->basic_cap = vmx_msr_high & ~0x7fff;
> why bit 13 and 14 are masked here?

Oops, this is typo! Thanks!

