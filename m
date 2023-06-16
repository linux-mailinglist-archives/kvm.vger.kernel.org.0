Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87B2D732809
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 08:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjFPG5G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 02:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240822AbjFPG47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 02:56:59 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AB71FE8;
        Thu, 15 Jun 2023 23:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686898618; x=1718434618;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3ULNT7A1MT5NGpv4sQJRzs8cJ4D9Azrw+arYJsjHQpU=;
  b=M1yrkzfoeYYDRSvNbm9C9CFyLA4cTLNxDjnKRcy9rTDTWKk3WipHJ3ef
   1hkJWB0WBrF2p1qeihRTNow1jnkHFQStgg2f2+4Dkkd3EjwfipZLhXFju
   I88hYysVF60WX8xSxeARTS1RNNiyhtGV4fhJjMN183PkiVz5zd1ZJMJji
   ZKFWZFUBiupfY747JDZpX6bx3wLzFg16txrwWpuhkr8NB/3uv1GAwXK/l
   cwJe2c6hpOfz4gqdsbuRA5r4JVmlfXQN1UOWMFRO/Y5ofcUohojK9lOEN
   Ogen7CyS7lW1hbVEq+eLL0+tghhc87AkQqAvXFz1uMV1jpdN5MxX3fjMY
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="343884139"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="343884139"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 23:56:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="706976748"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="706976748"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 15 Jun 2023 23:56:45 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 23:56:44 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 23:56:44 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 23:56:44 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 23:56:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m1g8xZNiRD2v2fPUwPjb1qinkIH00e9TIVEp2fVzrW+OGkUBBWeZuMPAUVuglj6bMg/XmX7tl37vFP9C7Aywj4ww5La/gpBYhrCsCcwmTEZfvmwVYlIyjttxuRpSPtprZ/TRTAVi1U0Xco/t+4tz+fOgDsveJGPVYS2bD77JDzq11gXQi8O3asAGbiKvHxybHIVgXVfg+4kSNnTxdh/5rFEi8U9eH0E9ZcvaykdH1P49gJls9OWfpgBKvDoFC5X4FGvM32lou7vAsIqsYgsQPlj1d/yqfQLGxWovYcUtePh8WKxjdMgr6BftkEK80mY4/WLBJnZX2uD0RTUvwXJHCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K5xuEb/MQaXNnLLQYIm2Pq9vNUr43h/qBliHl9rHWj8=;
 b=O2EKOx4NNCWOF2bX6ZhByBSsNmwg7EVvA0aZ/cY4ZH32JYg1ul7oqU698GLyawO49kD24mi7sWxy1xkj0UkfMahpXW1mw4jJSoD880sM0IdTmNm9JTNEmaJMiIJrGNQ/eKfvk5S0J4Kyhwwk8uLHykvrFzWxF1Mv2NEILxE/lZIn5/D5SNVPc1pVLaOng6BdiuTYwvMDUh4PQmxjpBf0ooswaBZmSHqdQ1bJfSsLlIonEHE0xJE8IRroV59qf/a7ugqzjffLw2M3TY2mnnkWjVa3dDfJrYcyvJ5zWB7Y2jDQrVNw2XRr3vaZAzxqvyPOudwtiKBVv360EjbLjWIZ0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM4PR11MB5567.namprd11.prod.outlook.com (2603:10b6:5:39a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.29; Fri, 16 Jun
 2023 06:56:31 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 06:56:31 +0000
Message-ID: <dfdf6d93-a68c-bb07-e59e-8d888dd6ebb6@intel.com>
Date:   Fri, 16 Jun 2023 14:56:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 10/21] KVM:x86: Add #CP support in guest exception
 classification
To:     Sean Christopherson <seanjc@google.com>
CC:     Chao Gao <chao.gao@intel.com>, <pbonzini@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <peterz@infradead.org>, <rppt@kernel.org>,
        <binbin.wu@linux.intel.com>, <rick.p.edgecombe@intel.com>,
        <john.allen@amd.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-11-weijiang.yang@intel.com>
 <ZH73kDx6VCaBFiyh@chao-email>
 <21568052-eb0f-a8d6-5225-3b422e9470e9@intel.com>
 <ZIulniryqlj0hLnt@google.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZIulniryqlj0hLnt@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG3P274CA0003.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::15)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM4PR11MB5567:EE_
X-MS-Office365-Filtering-Correlation-Id: effa9b63-fc97-4b75-9605-08db6e36d03e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jFBgdItGTpyYHcUiMC0BabHhz5pImEXP8HFmAOJcZQJXsIEWKmSekpFL1sGzWaLpqgRJUL+ydflKaKQmWmcWKGPZB+0ir2J5bHfNInEtLucJJfL71aSCZPlKMYmZ9mfZz4mita1bmg/zmN8qUDwWLVgXwZu1lX8fkh1BI2GATIwhTDJKdiktoPAFUQ9xHQ2HVtNbqaZ7LZU6zFHIfevbcW72TpPL3nsmXaoi19eOmTNk91rHFeOlWpnTFURhvUxGHgtXDYaR9fxi1AJEMuHQlsUKvZdh8NKRObwgU0oue4zwlsM1NwVnvTt/1tj9WJJoK7ESSqffZe7QTFBSKA3+B9fqCJo519pt+gS9clch9ZcGEKm1DekuUJYHpalHfFGcqUxogInE7UVLjV04xVBJU/E/f8wEoFjQgNh6KeNrq2U8/3Nz2inmUb9s+0BcUNYGEysnAULJTIDRbOOvPEcBL9Pcx33mXscD5oU2PaZN3N5pA8WPYx6fLz6Hyl5mibFmfA3IJKdhroJ6p5B7XvjNwXcZMjw9ioZZOR/MAGuRDAqKdvxVcoFF/O7n73+3If8fK3n5ouIRfvWES+VMlUTZCXQgNVwKYWyC+cgYfvXk1EgQVaIdRg1afoN8x5m3x9XHMEOtR5hM2ZwaGrGhYb4aSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(346002)(376002)(136003)(39860400002)(451199021)(5660300002)(8936002)(41300700001)(6486002)(8676002)(316002)(6666004)(186003)(53546011)(6506007)(6512007)(31696002)(26005)(478600001)(31686004)(4326008)(66556008)(66946007)(6916009)(66476007)(86362001)(82960400001)(38100700002)(2616005)(83380400001)(36756003)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SWdpQWdWMWpJSldnM2VML21sR1ZBeldLNEpvSjRvWkRQZzVNcXVCeThHRmRM?=
 =?utf-8?B?R2pvcElsRU1qcGZ1U3RJckZGb091dWk0M2dGNjV1Y0NtQVM2TzdYNllXM1pH?=
 =?utf-8?B?d3FveEFhQUk2TDZMYWhkbnR2My9UV3Qzblc0ZjBkamtmS0U3Z256RTFzMEcz?=
 =?utf-8?B?elFLN0svMlRGWEhnUkpxd1JwMjhMQkRlSE83RXhCVExQN1NiUHd3Z256Q3N1?=
 =?utf-8?B?ekZSTlJRWlBhTzUvaTJhS2RzWFRrKzFleTRoSURvaERhSlpCVVJScy9hTUln?=
 =?utf-8?B?dm9aZ1VRTExNd0l4UGNhTGRyUUhhbU5HcGpaaE0xZjZrZmFBbzU0V2Z6UXhB?=
 =?utf-8?B?cFhOKzlURnZ3ZXlvVmhra2NvbWFNT1ZzOGttdmI1VytZTXM5eVVSeE1haVhq?=
 =?utf-8?B?UkhkZCtEN3V6ZzZIU1g0OVF6TlNOZkJxU2hnY2twWGVBMFdUZ0d6aFNSc3Zo?=
 =?utf-8?B?SitEZjNWUTVwRlRQRzZxNlRLMmc4V0dPYmx1UW4wSGRxUmJYZWNBT21wNFdG?=
 =?utf-8?B?a1JwajNrbS9jQmVRZTI0T3NEUytaemxrQlFzOElydURqSDE4bHZjSlVURUdu?=
 =?utf-8?B?Z01GeCtVQmc3MWNya2c2OUk3K2N1TTZIOVNYZ1Y2R3dJRzRBdDhiWXIzcExQ?=
 =?utf-8?B?eUQxdFRxY1FXc2E0WjAzdWlkamVvUWhENitJSTYxb3NwZFBFTHgzeU9KY2wr?=
 =?utf-8?B?aVVPVEQ3WVNwQkR1a2FCWkYzV3VvMkNkeU0xa2hJb2ZVcURWM3d6VytaWFQ3?=
 =?utf-8?B?cGJ1UjFyMHQ4UnZXSDNkMmdya3dTSlRzclZhSC9nTUJLbmIzT1d3czJQL1la?=
 =?utf-8?B?b1lQMW1OcitTVFBBSUpKelBaeFgxSEFHM0pMci9zTVNhL0V3RllrNDV2NENv?=
 =?utf-8?B?eEJDWkU1ZnpmUThCVlFrVzZ1ZDBXWmZUMjJJbzVUSkhBVStUdXo2ZFg4anAr?=
 =?utf-8?B?VXRyQVhHT2pDNk5SVU95OTUrQ0wwZTBnTDhIL1NkQUFFWVorVERPNUgzRFEw?=
 =?utf-8?B?a1hreGUyb2xJcktwS01WUDNnWWdtNVpIR1dNZllHanQ2ejVZeExDOC9zaWZ6?=
 =?utf-8?B?b09iVy90RDFhUnlGK25WRGw4Qmh3Sis2SkwvS0Nxb2dmdm11SGRpdllucFNo?=
 =?utf-8?B?T3hyd3hQdXcwOG9ZUnpqRTRYK2xJWVFJKzJDNmxuYnhNNk9yNmJEVFVvWG1F?=
 =?utf-8?B?Ty9hR09vUXRtZ3hLOUJuV2xBeTI0OFpFRExneXRQQjlobS9PaTYwNFJxcWtt?=
 =?utf-8?B?S2dDMk0rd0Y0OGQxY201TlVVOUM5ZGJLZk9nK1FoU0NsWU9MQk5mRitWa0Jx?=
 =?utf-8?B?dkF2UHpleitMNzA1cERjclErQlI0S3F3OGRKRGdiNlJlUDBSdThOZGo5ZC80?=
 =?utf-8?B?WkZVd0Z5TEFVVlRIWmNjdVhSMjhaZ0FlMGRGTFppdmtCbWRTRjR2MFN4RHhQ?=
 =?utf-8?B?a2FzQjJ1a0pNbk5YYjMwa1A5U21KMDIwTDRyQTdlc0hhRmZZSzhOdGRscjBK?=
 =?utf-8?B?UXd3NjNvVjdQZTlPUEdQQXBHK3E5dnF2WDB1RWZ0eTNnVkFJNlAvdnlFL1dJ?=
 =?utf-8?B?SkNsMEZKTDFlUExUMGtqNGRVQk1naFpQbFA2a3czYm1vS0Q4bGNha1R2UUxl?=
 =?utf-8?B?SXNNQXU0OHRDMUxpU1RUdFpiRlg4L3dNTE81UUtuT0R5czJxUFUyc250YSt3?=
 =?utf-8?B?bGNKRzZ0Szl2d2h3R3RySHRNenJjTGF4SHYrWWtFUmVxUHdKd2lGaWp3dzJY?=
 =?utf-8?B?TUIrOStQTTRBVVdhYTVxb3ZTSWFkMWludG1XZEwvbFg2cU9NMEpJY3pKZ1FQ?=
 =?utf-8?B?L3VqQTg2WG9XaXdkcFp3dElVeWJIbiszSzI3TWFWcjcxdjRtaXdGMXkwcTEr?=
 =?utf-8?B?OEdZei8xRk5TU0VVYW1KbFArYS9RbHlYRnJBUTNOY0RoZ2VjUjE0eFZEVExJ?=
 =?utf-8?B?ZXNLckRRc2d1ZUEyVmt6cGJNZFFRK1RyMEI3WW81WkZCUkJHZlJybWx0b1ZP?=
 =?utf-8?B?MG1CTjBjNUhueXVzSEpaTWZ0eVhVcitRSEkrMElweVJmRjJmQkh0RVhZVm1W?=
 =?utf-8?B?aXFXZmlBNUduRGJYTGcweEdkYkZSSDhiM0dXK1ZQZ2FYQkErNGYyeTZoU1Az?=
 =?utf-8?B?WGxoTFR0a2ppMC8rOWFHeElqS1JvMGtCOHp2SWNybHZ5b3M2VVZZa2l4L1RV?=
 =?utf-8?B?eXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: effa9b63-fc97-4b75-9605-08db6e36d03e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 06:56:30.7771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v/L2Ks2LtWayjo3VTYkqWEoznz2MzaZ6j1OknfUtHDSjBog1VcD6RBTX/eM1Yc8Yfo9BAvr+vZJAfe+Hf306MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5567
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/16/2023 7:58 AM, Sean Christopherson wrote:
> On Thu, Jun 08, 2023, Weijiang Yang wrote:
>> On 6/6/2023 5:08 PM, Chao Gao wrote:
>>> On Thu, May 11, 2023 at 12:08:46AM -0400, Yang Weijiang wrote:
>>>> Add handling for Control Protection (#CP) exceptions(vector 21).
>>>> The new vector is introduced for Intel's Control-Flow Enforcement
>>>> Technology (CET) relevant violation cases.
>>>>
>>>> Although #CP belongs contributory exception class, but the actual
>>>> effect is conditional on CET being exposed to guest. If CET is not
>>>> available to guest, #CP falls back to non-contributory and doesn't
>>>> have an error code.
>>> This sounds weird. is this the hardware behavior? If yes, could you
>>> point us to where this behavior is documented?
>> It's not SDM documented behavior.
> The #CP behavior needs to be documented.  Please pester whoever you need to in
> order to make that happen.

Do you mean documentation for #CP as an generic exception or the 
behavior in KVM as

this patch shows?

