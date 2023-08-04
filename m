Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0846976F84B
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 05:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbjHDDQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 23:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbjHDDO3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 23:14:29 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF81C44AF;
        Thu,  3 Aug 2023 20:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691118837; x=1722654837;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DN6c6wvAVEUg2e5UF1+t0c5zuq1uc1pavPqDG4T9YNY=;
  b=LBxvP50ujEK0rpLSZAJsWlekttU1y8sS6abo6nCsIjiSPfvVcGGtoxZ3
   tkKzenRFCfsz3pmYqx0hPDjg7M8kPKKVlCNPBi/XQ/E2C03pAOBmZ4Krw
   rrfhBDKp7HMQQZhdJCm0ZhM3j7XXR4Yc/+3dhYtReN455BC1enFNiopBJ
   5aNb8tALBtmadQ/deB7ZupO4NOwOpLX90NhUpyNaSp+het6P+mm+7Kc5p
   fBqOIfherlBTl6HpjrOk+A7ZFq8xsCpvSkv9p/+e31jZkT0lBgNvmQKHe
   wYHDPDJaf1uUIz1GVsCuVabD4PmwoLlOtqL4Qpo3neGu97qNkpJPJ/Bnb
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="349645065"
X-IronPort-AV: E=Sophos;i="6.01,253,1684825200"; 
   d="scan'208";a="349645065"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 20:13:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="729883009"
X-IronPort-AV: E=Sophos;i="6.01,253,1684825200"; 
   d="scan'208";a="729883009"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 03 Aug 2023 20:13:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 20:13:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 20:13:49 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 3 Aug 2023 20:13:49 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 3 Aug 2023 20:13:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBrRNGlP3g8kUJwzhoSAlmeBsV4fujoIoj8l7Biwp9sHMGf3T8q1mHm6bs3rdirZl5yHF2Jo2IMHWiFf6M6xtDL1C6oAQf3je/lwrC97SNu3T+koBC/aruhvKZ2L1mtNLKUFSfZz0Ei1IMRJsYy3ETbRwlIKzy5/gTPNn4CKn4w0NfgyEMyMas5+a8wmMWTbFWSFz4bCw/G8zGB0XgIDM/FPVX9/le+8ktg7ljF0aZe9f5SRrqxWXNhF66vgpyLrFpoegLMCBV3H6QNwpToabMbCtPU8hvLsfWqplE3WmWKWJyab6QljWSou16VHjVtkMI8UTInQxcyU+Vb7HJVoLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eb5DZuNwFh0Nkew3+FFOH6pl3mKA5JlhAYrZItZo8so=;
 b=Hmq0A1oDmgeOmXBJksCqvtU+b6STUQW0AONfFH9H+DLvrGBjRfid402P1PwNJJLenmwgDxv5eVXl1hxVdTYBk1IYcErKE1F/hVj/if2L95QM4fyrPBqKte1E+qup/lAPDA3I15K8oZqGJUTmp19mblaekZbgPruMIhK+BkFmqVuvPmq930e7BL8XvCHTCmGqMJx30ZsOkUyq2tYsEN9slDJ/H8L523qO/PMM2h1P2O3pqeClhao1e6ZoVr5hqfxvPYGC6L4i7Jv4w/9iR/jguAqTpLK6Pp3QpFmvA5CBYzrX9b3aj46hmMw4nR2d/1yXbykJc2spcgRSB3nWWSnjSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS7PR11MB6077.namprd11.prod.outlook.com (2603:10b6:8:87::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Fri, 4 Aug
 2023 03:13:46 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%6]) with mapi id 15.20.6652.021; Fri, 4 Aug 2023
 03:13:46 +0000
Message-ID: <83d767df-c9ef-1bee-40c0-2360598aafa8@intel.com>
Date:   Fri, 4 Aug 2023 11:13:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v5 08/19] KVM:x86: Report KVM supported CET MSRs as
 to-be-saved
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-9-weijiang.yang@intel.com>
 <ZMuDyzxqtIpeoy34@chao-email>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZMuDyzxqtIpeoy34@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0010.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::12) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS7PR11MB6077:EE_
X-MS-Office365-Filtering-Correlation-Id: f2426630-a776-41a4-70ab-08db9498d0b0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b+jFDDEm8Z4gq3QgEfv500fYVpjkd/YFX669Elbhplc3O9O47CEkjEGeoQnAER4IrnUUvCz8o4jlZOCYFqddmDtVQ7vx5gp5QTinMYcOyolsDPh2RDoegPWOaCNxFuA1dD7oTpewAwuw4N5AxLp+BC8eoZvhz8zL2x9vaB6iT8jicNHHZ1qblOwmLxDqoo2Jb3fxHUy9wg7TaBXEU+MwezI6zj/D/bi9BoDlG9FJuYeg4c+4PA57BKAEYz9Ayb903pm2YxP7HlocDSv6ja8AX6fR2a3iwR482VRFHE3U7cyYCufNosDhT0r2P+ZpRkjZk+4xKiPH9m82x00YjEyG1zwkbLSC/1yrgLfL4Jb/2xbYAjxn1ZjFNJqy+vZMr1ut5VRvD2FqF4XPOq4bMnd8+KiSZtly2EWnc23ZhMN2dfm374GDireb0EHH6n59v7tOt2Gt5QQ+TMALjvkKFXrOvPkQH/jepkmW3OcjtAyzHpi1eqv5OLat3f76V/T06y8So5P3p0vYnmM9fxWgmsMOJq8BWik4i6xCwz7UKn3E6uhMJKYIish0FRsjnN+LzkV1otPxTnRaH8vfvlmF2wDdh8/MRGxQ+EJkEpFxQiMduBEuCehWeKNqaKkKns/cntoAKXxAWTWTqjhesH8th7Ebpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(376002)(396003)(136003)(366004)(451199021)(1800799003)(186006)(36756003)(86362001)(31696002)(31686004)(37006003)(478600001)(82960400001)(38100700002)(2616005)(83380400001)(6506007)(26005)(53546011)(6666004)(6486002)(41300700001)(8936002)(6862004)(8676002)(6512007)(4326008)(66476007)(66556008)(316002)(5660300002)(66946007)(2906002)(6636002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cEdVTHJnZUJnSS9WS3FXbVQ4ZU5XbjlieGFTOWFxTUh2ZU8vZ0VLS09sSUVE?=
 =?utf-8?B?YkxWelJUdXRPRGIwYzdWd1JmV3Y3VE1wS3JGNlZtcjFINzlCYURwdHlKWVB4?=
 =?utf-8?B?TWxYbVYyNEx5RUlhNU9CRVJPb2xXMlpnNjNCTEJ4dDhhbXVpNjF2UGY3a1pn?=
 =?utf-8?B?T0pVYXNuNGxpcDZadytlc1Jtc3V3azl6bjg3ZXBvUjJObytWNkJZcEU4MXpT?=
 =?utf-8?B?WFArZFpYa2NDUXF3cHRLN0JoSkVQRFJ4a3Ayd3pVOE1GYVljK3l6REw0NkRr?=
 =?utf-8?B?N1dMSXNER0NJdzFrUDRZN1ByUlpXQURiSkFvNmxpVldqc1JoRFF6d1cvNjF4?=
 =?utf-8?B?ZHZIRWhUYTNNMnVRT1N5cVhzZE5ablg0akFKcVZienNGTGJ5MjBUS0xtMU1y?=
 =?utf-8?B?NmxjaUszZXowSXFDOXI4dExraWovR1g3d2FOT05CejdUakR5TjFGbHQ0R0hX?=
 =?utf-8?B?SUpYdk9xMis3R0tQeXh5cnYvY2k0SVYzUUtrdDJhZFJYckVaT1RWYk5EbTVE?=
 =?utf-8?B?ZzFLMncyaDAzRGFNeTBMREFQZFcrUklmK095S3JxVnp1WjlQK1lMejErYXRt?=
 =?utf-8?B?YWtLVXREMXVObytFYk8zTVVvMmRKK0VLOE0vcGdGTlZ2Vi9rNG1lS2QzYWpS?=
 =?utf-8?B?b0VOYnhTVnZmVkxXeXJVVlR1a1d1RWMwSDNmeGd0OWMwdkdCQWpFV01KSGVZ?=
 =?utf-8?B?ZFBWQ1YxdEJnUnk1djRBamUvSmhwQ1RLOTZsYVpjVmFTWUJTYWdNYmV6YXpn?=
 =?utf-8?B?SGYvbE93M1RuaVYzOW5SZHBPbDFlQTdtejRXU0lXeU04WVhtQ3NyWFhTOTA1?=
 =?utf-8?B?UGdaLzhuR09kdUt3Mm9XZkl4SUJ5MzhnK2NoVVJkTHlFM3Fad1Y0bHYzMHNH?=
 =?utf-8?B?UWNORGxJa0IxUWlmYUtPb0ZqU2loZFgzWGpvQTRsWFZIY2VVaXhXdnJpT25I?=
 =?utf-8?B?QzZ3dFlhZ05waG5kUVRDbTVRckwxbk5sYnFTNVBDMDV2Y0hCamZGeFdUa1F0?=
 =?utf-8?B?d0F5aHoydWhyNXJwNzNNMnd6ckE5bG90K1p4b3YzUFlpRFVKa1NzdWZEbklZ?=
 =?utf-8?B?aFhacHhWeHBsUUpaSU9HNjJYbkdkYnNmTzRIT0cvMDA2N3BWNFViempqdGJz?=
 =?utf-8?B?Qys5bWNsMVlsYWsvL1hEZHVYYnlRUEdhaEVWbkZYdjBpSlN0ODZZZk9uV3Vl?=
 =?utf-8?B?S0hCaDFMbHFwMUJSQjJqVTJYcEpxa2Fjc2xyZXZaTlBVWkZtcW9SekJ0RVRX?=
 =?utf-8?B?WklURGJTanlpZTVNNXBVSXBNKzE2bEZ5RXFUTVNSRVNsczFzalNGM1BzRjRF?=
 =?utf-8?B?a2pqWWNPSG5PWmhkZkU1QXM4ZWFRaEZmdGJLV2w5RXJHanE0NTRnREUxaTNs?=
 =?utf-8?B?RnE5WjdmczAwVmFCaGNpWkxIdFpOUVRTUGFEUDhpRjB4UkxkZkFubHNydmti?=
 =?utf-8?B?eVFNMjExWnN1K1B6U3FuRDNFUHhLK250aGtKY0YxQUl6VzRGUHVadEZIY3ZB?=
 =?utf-8?B?VmxmeGg3dHBOdGlvTVVQWm56d09GYng3SFlKcXhoQVNmVkh2UmFnYk5tREN2?=
 =?utf-8?B?RGRMeE9PTmgzNlhJNkk2ZDF3bXNyeGE3anZWU3lvUEhlWC9lSTE4OWZ2ZjhU?=
 =?utf-8?B?Zy9jWHdLNzRjTGlKMEF4NEplYUpNd2NucnNjNjlFbXA4OWgyR1FIYU5mZkdG?=
 =?utf-8?B?dDQ3VHZzcE1sMVBVUnpFRjNrd0lRUC9KMDhIUGdRMGxsTmRwY3lZbW03MlpK?=
 =?utf-8?B?WkZLdmZ0TXVVT0NqT0N3SGRoZkF3ejJFRzhqYldOelp3N0xPbDI3ZitlUU4v?=
 =?utf-8?B?UVpLRjgrZ3dlcWlrYmt0RGV3M1RRVE5xNDFVdDFGT2pkUytXa1JrQUljcGhz?=
 =?utf-8?B?OXVXZjU4V1NGRCtia3pGQSt5ekZ6N2MxbU1OTXJkOTR6cFVhem9BVUlBUVlr?=
 =?utf-8?B?TzdYdzBPTWJLcFZvbTRwK0h2R1cvMnQ3NHVWK3FhY1ppTE1FQWJuSTY5emRl?=
 =?utf-8?B?T3JrcWxaaHJEZHc3OHFoTW1ReVNHeHRpdDA0eWZSa3FFbDRRbUV3SDVQdEpU?=
 =?utf-8?B?aUV0YThNdWRUMGJtcmc4MnRiYTJSbDh1dkN1cW91NXJLRXBvMW5XUXFSSUFJ?=
 =?utf-8?B?dUhWWU03ZVpVSjJJTHhmTXJSRVAxajlaeVVvZ3o4UHdERUtBM3BPb3YvelBH?=
 =?utf-8?B?UFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f2426630-a776-41a4-70ab-08db9498d0b0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2023 03:13:46.2989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KEGxSR2Ef2t7G7GeacwS1KzPYfuw5rae98LOdP4QCZIVehvGUw46lIsKB/xVEPSBQFnxZceuvKlEdtcCkMNp9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6077
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/3/2023 6:39 PM, Chao Gao wrote:
> On Thu, Aug 03, 2023 at 12:27:21AM -0400, Yang Weijiang wrote:
>> Add all CET MSRs including the synthesized GUEST_SSP to report list.
>> PL{0,1,2}_SSP are independent to host XSAVE management with later
>> patches. MSR_IA32_U_CET and MSR_IA32_PL3_SSP are XSAVE-managed on
>> host side. MSR_IA32_S_CET/MSR_IA32_INT_SSP_TAB/MSR_KVM_GUEST_SSP
>> are not XSAVE-managed.
>>
>> When CET IBT/SHSTK are enumerated to guest, both user and supervisor
>> modes should be supported for architechtural integrity, i.e., two
>> modes are supported as both or neither.
> I think whether MSRs are XSAVE-managed or not isn't related or important in
> this patch. And I don't get what's the intent of the last paragraph.
I recalled the original intent to say, although kvm_is_cet_supported() only checks the
host support of user mode states, but user and supervisor mode states are exposed
as a bundle, i.e., both or neither. So it can enforce the same check for both
user and supervisor states support.
> how about:
>
> Add CET MSRs to the list of MSRs reported to userspace if the feature
> i.e., IBT or SHSTK, associated with the MSRs is supported by KVM.
It's OK for me, thanks!
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>> arch/x86/include/uapi/asm/kvm_para.h |  1 +
>> arch/x86/kvm/x86.c                   | 10 ++++++++++
>> arch/x86/kvm/x86.h                   | 10 ++++++++++
>> 3 files changed, 21 insertions(+)
>>
>> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
>> index 6e64b27b2c1e..7af465e4e0bd 100644
>> --- a/arch/x86/include/uapi/asm/kvm_para.h
>> +++ b/arch/x86/include/uapi/asm/kvm_para.h
>> @@ -58,6 +58,7 @@
>> #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
>> #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
>> #define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
>> +#define MSR_KVM_GUEST_SSP	0x4b564d09
>>
>> struct kvm_steal_time {
>> 	__u64 steal;
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 82b9f14990da..d68ef87fe007 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1463,6 +1463,9 @@ static const u32 msrs_to_save_base[] = {
>>
>> 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
>> 	MSR_IA32_XSS,
>> +	MSR_IA32_U_CET, MSR_IA32_S_CET,
>> +	MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP, MSR_IA32_PL2_SSP,
>> +	MSR_IA32_PL3_SSP, MSR_IA32_INT_SSP_TAB, MSR_KVM_GUEST_SSP,
> MSR_KVM_GUEST_SSP really should be added by a separate patch.
>
> it is incorrect to put MSR_KVM_GUEST_SSP here because the rdmsr_safe() in
> kvm_probe_msr_to_save() will fail since hardware doesn't have this MSR.
>
> IMO, MSR_KVM_GUEST_SSP should go to emulated_msrs_all[].
Nice catch! Will move it to emulated_msrs_all, thanks!
>> };
>>
>> static const u32 msrs_to_save_pmu[] = {
>> @@ -7214,6 +7217,13 @@ static void kvm_probe_msr_to_save(u32 msr_index)
>> 		if (!kvm_caps.supported_xss)
>> 			return;
>> 		break;
>> +	case MSR_IA32_U_CET:
>> +	case MSR_IA32_S_CET:
>> +	case MSR_KVM_GUEST_SSP:
>> +	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
>> +		if (!kvm_is_cet_supported())
> shall we consider the case where IBT is supported while SS isn't
> (e.g., in L1 guest)?
Yes, but userspace should be able to access SHSTK MSRs even only IBT is exposed to guest so
far as KVM can support SHSTK MSRs. And here is to advertise all the supported CET MSRs.
So maybe we don't need to check specific feature support.
> if yes, we should do
> 	case MSR_IA32_U_CET:
> 	case MSR_IA32_S_CET:
> 		if (!kvm_is_cet_supported())
> 			return;
> 	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
> 		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> 			return;
> 	
>
>
>> +			return;
>> +		break;
>> 	default:
>> 		break;
>> 	}
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index 82e3dafc5453..6e6292915f8c 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -362,6 +362,16 @@ static inline bool kvm_mpx_supported(void)
>> 		== (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
>> }
>>
>> +#define CET_XSTATE_MASK (XFEATURE_MASK_CET_USER)
>> +/*
>> + * Shadow Stack and Indirect Branch Tracking feature enabling depends on
>> + * whether host side CET user xstate bit is supported or not.
>> + */
>> +static inline bool kvm_is_cet_supported(void)
>> +{
>> +	return (kvm_caps.supported_xss & CET_XSTATE_MASK) == CET_XSTATE_MASK;
> why not just check if SHSTK or IBT is supported explicitly, i.e.,
>
> 	return kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
> 	       kvm_cpu_cap_has(X86_FEATURE_IBT);
>
> this is straightforward. And strictly speaking, the support of a feature and
> the support of managing a feature's state via XSAVE(S) are two different things.x
I think using exiting check implies two things:
1. Platform/KVM can support CET features.
2. CET user mode MSRs are backed by host thus are guaranteed to be valid.
i.e., the purpose is to check guest CET dependencies instead of features' availability.

kvm_cpu_cap_has(X86_FEATURE_SHSTK) || kvm_cpu_cap_has(X86_FEATURE_IBT)

only tells at least one of the CET features is supported by KVM.

> then patch 16 has no need to do
>
> +	/*
> +	 * If SHSTK and IBT are not available in KVM, clear CET user bit in
> +	 * kvm_caps.supported_xss so that kvm_is_cet__supported() returns
> +	 * false when called.
> +	 */
> +	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> +	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
> +		kvm_caps.supported_xss &= ~CET_XSTATE_MASK;

