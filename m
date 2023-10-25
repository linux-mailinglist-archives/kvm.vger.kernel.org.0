Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE58F7D6FD8
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 16:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbjJYOud (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 10:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234704AbjJYOuc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 10:50:32 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 25 Oct 2023 07:50:30 PDT
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D492B0;
        Wed, 25 Oct 2023 07:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698245430; x=1729781430;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E6CuEudN1zFnfoS5y9T/RID89DzGOqUuPqGbEpNsGlM=;
  b=hc3AYD6uzvEWAeMmC2Yr3GL5nyMRu9ISC6Kz2X+LsFh7JU8xJE3bZCsb
   v1ur9uTLcsFVShk9+ALOe6H2MFnSYeKi2vLs86n09OcYT8amdRgizCCjU
   d3o7AxVSGAabXtHFUAu0xyjDZIIBia6N33ycFoMR2O+S7MPrpdQnZ3iH0
   FF/NrITxHfk2P4pcuplbRq+PY7OgpKXgEsHdD9rqHnlp3MuFI3FidzCHw
   OzndN//73MaOVuHCetUy+ybLkzwk40fIvgmHzlbX1Gv9KM0ThwW09w8In
   fxw3VaP10ZPjtCiIToutQMWtteM18ZBWD7YLV6MdgVcZljooRbkmSO+wJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="115790"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="115790"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 07:49:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="849552241"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="849552241"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Oct 2023 07:49:26 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 25 Oct 2023 07:49:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 25 Oct 2023 07:49:25 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 25 Oct 2023 07:49:25 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 25 Oct 2023 07:49:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nkBAyX3W7YL2uj0m+TR8CKrUS5nBtvAWiMPkXbG2j5gzPxDGSQV1rE2OM8bEdxc8cYjf8y+vKtMd3DBMc4jPvQbCBivZrxkEXriWZGW3BBh62p7i/fei9SGBKd21kLv9iiknE1Sp7wejvHLOOR9Q7Acxf+bzy63rIDmZ0mct6fItOukOxxgWnsSHHDzAC+0Ldyysa8QLZGya1+CKO1Ma/+LEVm//qPQ91g7dSVNB6leiRWeqD3/OOBq6T4Px3Li4zSdXAZe9FcL6rCtH7Yr8cgJYM9dO/Ds1a50xwzGbACkhULLVP/0lT5iL6iUtH7t7Bs9xo1/gg3CTWjXb3VZryg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gXVegiWFB8RIcR/AbdX8tjrYArWIGoUMCVZgYd127fo=;
 b=VpwHAP/e8EhOAmO68dhd+NwR23iPKb9gChl1vzbgkc/puvsicAeIFrpw3A6UtbhL1hx3BBD8w470JTQuCa2ra+4ESHiqd3rzqxfbkfp1QUMDi3OnUqNbIQRzHHg4k+kJ9RZhtzq++4zz4isrvTwJBTd+zsTs6kYrnbuMbbPUk7tJLMTa3OUMDLDVaVK4BgYxAQ5CJshT9DWLyBegF3mri0xY6tCAehXzs9EAWrXGeJvZwPDT1Ln0H/yu9fyeOmfXcHQQTI39TJk51y8HI8GaFP7gDoIDy7Gq7Bttbd/5n25q1DtHltgT/xtWLL+Vt7wiw0wSEgB75ptRwCDDiaUofw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH7PR11MB5794.namprd11.prod.outlook.com (2603:10b6:510:131::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Wed, 25 Oct
 2023 14:49:22 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.6907.028; Wed, 25 Oct 2023
 14:49:22 +0000
Message-ID: <de1b148c-45c6-6517-0926-53d1aad8978e@intel.com>
Date:   Wed, 25 Oct 2023 22:49:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 06/25] x86/fpu/xstate: Opt-in kernel dynamic bits when
 calculate guest xstate size
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     Dave Hansen <dave.hansen@intel.com>, <pbonzini@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <peterz@infradead.org>, <chao.gao@intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-7-weijiang.yang@intel.com>
 <e0db6ffd-5d92-2a1a-bdfb-a190fe1ccd25@intel.com>
 <1347cf03-4598-f923-74e4-a3d193d9d2e9@intel.com>
 <ZTf5wPKXuHBQk0AN@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZTf5wPKXuHBQk0AN@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0012.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::8) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH7PR11MB5794:EE_
X-MS-Office365-Filtering-Correlation-Id: 68e05cb4-d6f2-485c-7ba8-08dbd5699307
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wUciTmAgl3jLIDcBGIjwkZtyC5q8WG+0hY1qIPRyAFKLzdsKSDsJSBX43gHtwsLYNMWzCjk7gjyt9jny1/6RpqNO31CZu4BPyS2un77tsiaP733NrsD6MqnAnL41eG/r2u+jdvOmWAI9hm7oX9HC6mvlvTTiXKQm0Y6r0Nj8Euf626+nZa5Z619HfTJ2jBdFxpiiYhtYMo+ABYnUJBaEQVRiU8NIxuGJTWMWhPVbI1P0MK1dcfrYaMLXwwd4TyWOFvuXMySzUNM3IzTC744bxxjKvUb05UkxczszivSpi3+U9BtWVsfDXjxj2LCCQyN6U5pWDYMRh94JfHH1VLRnRhq9+qqx9MafNFsGN9LNyfGpnOKDcMma1iyuS70ivRZTQRjtnosvnNym500H4kpt2srDgsy8AEza7ZeXTePeXsvRcEMPcq6LzAX9hW57mPS+BK6xSUChoRWNSNhXFqK+CmVNPqXzyRmxZWNEiunK0/a3T4d4/S74t3V7wsOf2zaB4fU/THUvXXZJ5kjwizzPorLMdOGJnzRVB/kDasaTkwRHiZa1Ohdd6Bq+OzwY/QjZ6dX6If5+j+hmfsTFhubgfk5N9ekZBq0vxM3sJR1lC1oZZ2ICxdC+128EYiPmb+0eex0GPbtlik9EjabumA4Vrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(346002)(396003)(136003)(366004)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(86362001)(31696002)(66946007)(6486002)(66476007)(83380400001)(31686004)(5660300002)(38100700002)(66899024)(2906002)(41300700001)(8676002)(66556008)(478600001)(26005)(6916009)(6512007)(316002)(2616005)(4326008)(6666004)(8936002)(36756003)(6506007)(82960400001)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGtrekU5RzY5d0NFdUpNOGpFekhPeHE3UFMvY0gwWmZ2bFBibWMvNnpEeklx?=
 =?utf-8?B?cFJaZ2oweVNjZUZBczdnVVhZMVZjTUJxUUVsWTM2RXdZc0wyQnNsWWxsYWFl?=
 =?utf-8?B?M1VNNFFaVUhzTGV1d3NiaThuR25vY2dISnh3ZHpTQWxISkNEbmlIYk5XOHhE?=
 =?utf-8?B?NUZnd2JVMFFJZUF2a3E2aW4rQjdFN2Q2YmxYVHZlTWtUZ0dseEJsK3Y0djhI?=
 =?utf-8?B?WmtZZzJkd0M5djZDSCtFYm5aeFBDOVM5UTN5L3M2UnJMVU1MSTh6MUpGNC9y?=
 =?utf-8?B?QlZTdmdFMnkwOHJtSnFaRmhPbFlnU3FJbExUQ1k3d3Y4VmpaQmFKeDd4eUx0?=
 =?utf-8?B?dVJpREhTcVEzR1RvTXo0cXd1eUdnZHhOZ2Z6ZkNQdnowcDhSeEJyTjlZcVV1?=
 =?utf-8?B?aGRFVDdlTGZwVGxQWDBPNmdtNm9XSlpmNTdTUjAwWjBuQ2MzSmprTlhLdng1?=
 =?utf-8?B?eDZFN0M1dTljdG1TYzFOQjAyZ1MzY1h2YmVvMmZLZHRBcGJJMDMzWGJndFBC?=
 =?utf-8?B?dldjblViYkYvdEdPSlVWNVZYRlBPdGYvMklkbnI4WGE3QWluOXd0WTU4ZVFE?=
 =?utf-8?B?ZjFnRnplUEpDemJnQ3V6RVNISksxUkE0YjY5UlFUYXljSVduT3ErcFAxUVdp?=
 =?utf-8?B?QUVjd2JHOTNPQ2JQSXN3c1hpQ2xYRkQrcEQrTG91WHVKaUViZ3hmZzNsM1Rx?=
 =?utf-8?B?V2pkSWIvNnNsSlZ1M0Y5RHdLZks3OUF6ZW1NU2pzcmZ4V0xLN1NNOHV4Q0JY?=
 =?utf-8?B?dk9Hb0lTeStaTDJJR2Q5ekhlM0ZFOEpTV0pNb3hTYzNMc1ZMbVlEc055U1h5?=
 =?utf-8?B?SDE1MGpmMkJPeUxYaXdtV1o5dm56dStrV3hZUmVqQ2JkYmh3RFBhVENjenVt?=
 =?utf-8?B?WGtzaGlPMkI3dk00OUF0L0JqSFR3YmM4aE1NRjZKVFNGdmVlT3hlZW1HTFZ4?=
 =?utf-8?B?MmZrZXFqOGQvWDgrOWhsYmJ3czVpcE15QXh2QXhhd1VXRHR6OGdSN2d0WW0v?=
 =?utf-8?B?QURKTHdCMlc5NWJXVzdMaUsvZWlyK2MzWVUyMFR4a2tYWmhwTDBJbi9TMnVI?=
 =?utf-8?B?T2N6TlhxVW9GZnVUSmcyK2JuOTlhU010dHhWclRScElvMWhQUzhYZ2U0ZDJD?=
 =?utf-8?B?Lzh4M01vZlYxS2RlcldSYmJGTE5RVXRjTmFWaWNWMG9kcmcwODkxaTRGbEE0?=
 =?utf-8?B?MGFreXRKVmE0d1BHcmkzeitmMlNzTjJ6aGFnZ1BCS0RqMXNPUWJHMDBxSUJz?=
 =?utf-8?B?Z2VScG1YamJJZjNJR3FiUlV3RWlpQ1N1OEhQM2NzV25oOWxremQvY2lod1I5?=
 =?utf-8?B?emcwUWMxdnBNVmR6ajF4TEpuNjhrRUtlRzBVdHhyRisra0FLbjA2NkFlckdO?=
 =?utf-8?B?STQ0MXEzbDU5anJkQ2Q4ZGJROXppeVprNHNxV0RKQ2RqaG5WbEZyTmFLSG1m?=
 =?utf-8?B?S0U5aTFVbitDbWR5Ynh0ZlpWZFdUNzdySjJKODdJQzYvOGJkUGVTa0hWMEVX?=
 =?utf-8?B?Y3IyVFRENmh1Mit5b0ozVmNqbHZpa0lqNU90OU1yQVVEYkI0Uk1OSkluei90?=
 =?utf-8?B?b24yZXhFbHhxL0xiRW5Cd210VUJZZEZzZzFvNkZCSUJNVi9XMGtiTXAwbnAr?=
 =?utf-8?B?RHdTWmJrazFCcDdFSEVVT1gxTWhMUTZqdHc2ZDJPTzF6cEl3SGI1UFJmbDIz?=
 =?utf-8?B?VmVINFpCVTdvampPMEhCRzgrcmhCaHZiN2IxYUpqTEpZUzNhdGVPTDFHdE5Z?=
 =?utf-8?B?bnpyZHovNEkwNTRFUGZac1NjWXRHbVRTOXBkc3BueWcyUHUxeFh3ZEgwMVlK?=
 =?utf-8?B?WHMydWJreEtFaEQ0Z0h5QUVxWXZoTm9hdlYvVG55WGZMK2FId1FpRzgwRHNF?=
 =?utf-8?B?bXdSS0dnRDVQZENydWowVVA5czI0MFFHYmszOFhVbk9jUjZEODNOYzFYZHR1?=
 =?utf-8?B?UmZaSzRJMm5XL00yU29DdWkrN1cvMGZTTW02RFV3TTR4RUcraG1UdzAxUk11?=
 =?utf-8?B?SEpoaDBPUHFUdjZxQVRBOTRLTTFFRzNVMCttYzBBdE56TjFZUkdTVGtjWTdZ?=
 =?utf-8?B?Tnd4QXQ4UzVyREVaaWxUc3hHSVRZSTMvRXh0d2JMNTdURnR0MVRjYmM5cDM4?=
 =?utf-8?B?VTkxWHpSTVIrZ3UyWWFVaTl3VlQzaGxmTzJSSmlVTHZaVlpJVlcybjZMWEFF?=
 =?utf-8?B?S0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 68e05cb4-d6f2-485c-7ba8-08dbd5699307
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2023 14:49:21.9461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LgkxOF7oJOQlDY0b/F2TIJ/owgTVn0krODTXNU7zZyNm2GeYuMy3P0DfGMZRPrMCCsax8GWOoD+sYT9Fk2UB7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5794
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/25/2023 1:07 AM, Sean Christopherson wrote:
> On Fri, Sep 15, 2023, Weijiang Yang wrote:
>> On 9/15/2023 1:40 AM, Dave Hansen wrote:
>>> On 9/13/23 23:33, Yang Weijiang wrote:
>>>> --- a/arch/x86/kernel/fpu/xstate.c
>>>> +++ b/arch/x86/kernel/fpu/xstate.c
>>>> @@ -1636,9 +1636,17 @@ static int __xstate_request_perm(u64 permitted, u64 requested, bool guest)
>>>>    	/* Calculate the resulting kernel state size */
>>>>    	mask = permitted | requested;
>>>> -	/* Take supervisor states into account on the host */
>>>> +	/*
>>>> +	 * Take supervisor states into account on the host. And add
>>>> +	 * kernel dynamic xfeatures to guest since guest kernel may
>>>> +	 * enable corresponding CPU feaures and the xstate registers
>>>> +	 * need to be saved/restored properly.
>>>> +	 */
>>>>    	if (!guest)
>>>>    		mask |= xfeatures_mask_supervisor();
>>>> +	else
>>>> +		mask |= fpu_kernel_dynamic_xfeatures;
> This looks wrong.  Per commit 781c64bfcb73 ("x86/fpu/xstate: Handle supervisor
> states in XSTATE permissions"), mask at this point only contains user features,
> which somewhat unintuitively doesn't include CET_USER (I get that they're MSRs
> and thus supervisor state, it's just the name that's odd).

I think the user-only boundary becomes unclear when fpstate_reset() introduce below line:
fpu->perm.__state_perm          = fpu_kernel_cfg.default_features;

Then in xstate_request_perm(), it re-uses above reset value for __xstate_request_perm(),
so in the latter, the mask is already mixed with supervisor xfeatures.

> IIUC, the "dynamic" features contains CET_KERNEL, whereas xfeatures_mask_supervisor()
> conatins PASID, CET_USER, and CET_KERNEL.  PASID isn't virtualized by KVM, but
> doesn't that mean CET_USER will get dropped/lost if userspace requests AMX/XTILE
> enabling?

Yes, __state_size is correct for guest enabled xfeatures, including CET_USER, and it gets
removed from __state_perm.

IIUC, from current qemu/kernel interaction for guest permission settings, __xstate_request_perm()
is called only _ONCE_ to set AMX/XTILE for every vCPU thread, so the removal of guest supervisor
xfeatures won't hurt guest! ;-/

> The existing code also seems odd, but I might be missing something.  Won't the
> kernel drop PASID if the guest request AMX/XTILE?

Yeah, dropped after the first invocation.

> I'm not at all familiar with
> what PASID state is managed via XSAVE, so I've no idea if that's an actual problem
> or just an oddity.
>
>>>>    	ksize = xstate_calculate_size(mask, compacted);
>>> Heh, you changed the "guest" naming in "fpu_kernel_dynamic_xfeatures"
>>> but didn't change the logic.
>>>
>>> As it's coded at the moment *ALL* "fpu_kernel_dynamic_xfeatures" are
>>> guest xfeatures.  So, they're different in name only.
> ...
>
>>> Would there ever be any reason for KVM to be on a system which supports a
>>> dynamic kernel feature but where it doesn't get enabled for guest use, or
>>> at least shouldn't have the FPU space allocated?
>> I haven't heard of that kind of usage for other features so far, CET
>> supervisor xstate is the only dynamic kernel feature now,  not sure whether
>> other CPU features having supervisor xstate would share the handling logic
>> like CET does one day.
> There are definitely scenarios where CET will not be exposed to KVM guests, but
> I don't see any reason to make the guest FPU space dynamically sized for CET.
> It's what, 40 bytes?

Could it also be xsave/xrstor operation efficiency for non-guest threads?

> I would much prefer to avoid the whole "dynamic" thing and instead make CET
> explicitly guest-only.  E.g. fpu_kernel_guest_only_xfeatures?  Or even better
> if it doesn't cause weirdness elsewhere, a dedicated fpu_guest_cfg.  For me at
> least, a fpu_guest_cfg would make it easier to understand what all is going on.

Agree,  guess non-kernel-generic designs are not very much welcome for kernel...

