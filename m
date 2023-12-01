Return-Path: <kvm+bounces-3082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6604800761
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 10:46:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B34E281971
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 09:46:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B9191DDEC;
	Fri,  1 Dec 2023 09:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cdwNLnCe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B847139;
	Fri,  1 Dec 2023 01:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701423973; x=1732959973;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Mnvez3UjyVih3A48Iv1s9xE6yns4AykFiIOIBJTLHDs=;
  b=cdwNLnCeNfEaSV1T89uzAx0ohUJhVguz42u8kycmjrig6Bnfck4MOiQO
   aBZrPsdo1PvHVzBco0+X1GpgbhbU0TzsoZOgqwnh0DRQl3MLanKj3fdqE
   vLLY6rBErdCRVaeK2yoApj4D19V/dpumAo2A2Rn+dgV+2osdw1O5jpKFO
   F69ZAe+ZpNGLFrslS1vJ4kTutLwMWj0qgWAcUwbImXsxYCDVonG/1h8um
   VZld5jikfgXUaRFEZtaJqTKdZFBTw4WhO/NfqZqIUfgVY/IZ2MXo8kOK1
   ShD1oalxX0kjxkziszpUF45u0Vn8C+QYMXhLiPi+8+UEwxpT8jkiMN8OR
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="355537"
X-IronPort-AV: E=Sophos;i="6.04,241,1695711600"; 
   d="scan'208";a="355537"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2023 01:46:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="840125717"
X-IronPort-AV: E=Sophos;i="6.04,241,1695711600"; 
   d="scan'208";a="840125717"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Dec 2023 01:46:11 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 1 Dec 2023 01:46:11 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 1 Dec 2023 01:46:10 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Fri, 1 Dec 2023 01:46:10 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Fri, 1 Dec 2023 01:46:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXwKnr4B56lb+WSBlpe8IRnkwnzotfuaPIM6yuFy+pHqNsxcDxjvf0jzb7BdvBZZl7t5FiLrRHmhJRrsiGJmOlbNwZMZtjKOWCbo0i0IZi4CgZJEHPAqP+lHR97ecrjkhgrOHgRMqii93B1bkxVCic8sYiqvSqOSGcgzODPoZzof6vwOxFEgU0mSkn2RUQ4AzXYSDyMZusFyY8pX6si0FMxLjj8GXycFZKdOKXKbzmx+6HnJfTUQk2+jmqIvQTOwYk+mS7JIDfLbJqOJly8BvNf4e0Dp41jzdm3Snm/vnnGWp3yqklOwlHIJ/hTzVfipTKM+hmy/oQE4bPShD/Unjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/cyIe73qdDv9lG/msO9unIu5yPVNa9xZ1uTKRYH4HM4=;
 b=l6wo62MpCdDfTdI8DLsl+OVJZGgsxt8N3frnYD2x8RcCPZliihrAo0VrOjEr6YdQWR3l91SQZSG3sZOpkPzCGCCHLt3E4dvj9auiISbaQuPwN5o5Uca7+3U92JXaHrzOWaOCZNxMKERMqtPDks2qQ6I2gCg0PFj56Ws74vLRkFQvm1NiAXUIaG5b0HDMVVBC9USXwnxC54zzSwA4pmZQ00x3nszqG23MKcsGMYpyvOfPYqBY0OtXrWpB+EfsJs4x1TL/nZJwPZoS7cxak4RzRrHn8VlCFEbQ6UrRlEBUmoCvx8Dq9DOdC0x/WnJKiG7TnZg8CEHGrYz28D+GpTmAmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA1PR11MB6823.namprd11.prod.outlook.com (2603:10b6:806:2b0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.28; Fri, 1 Dec
 2023 09:46:04 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7046.027; Fri, 1 Dec 2023
 09:46:04 +0000
Message-ID: <e79d43ea-3ca0-44ca-9a55-b8e2c5094cf2@intel.com>
Date: Fri, 1 Dec 2023 17:45:53 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 22/26] KVM: VMX: Set up interception for CET MSRs
Content-Language: en-US
To: Maxim Levitsky <mlevitsk@redhat.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <peterz@infradead.org>,
	<chao.gao@intel.com>, <rick.p.edgecombe@intel.com>, <john.allen@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<dave.hansen@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-23-weijiang.yang@intel.com>
 <393d82243b7f44731439717be82b20fbeda45c77.camel@redhat.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <393d82243b7f44731439717be82b20fbeda45c77.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR03CA0093.apcprd03.prod.outlook.com
 (2603:1096:4:7c::21) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA1PR11MB6823:EE_
X-MS-Office365-Filtering-Correlation-Id: 84bd25d1-04f7-45df-b07e-08dbf252551c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Rft8+SyepcQZR292jfQWekPyFEhVqSdrC+l/HKYMOUHPeeNKwdMxuHacAP+QZH0E5ly4u1Q0AiilQNJQooZSF38rS+kcSgwKqdFTIfrA+/CJhYEBb0MRUIz/nkqjAkYc67Dm5/bLA6yEapjMwtZaF4Ju+UVc/FsTvomllsRC6JoGJOfq1gDBKoLXOWPPegH5Ms7d9qBjok+VUr2pxPfMKW+/Qb+tz/uO37uBGNkVdnPdXERtdmVNgh8ddwBAD+h0aHs+Sj4YdeCyzYYL5nsZD/xdCLuDN+sKvTRJxoC77PE7+muVyCwQMyB6zihjxyj6+ii64MRHa7mOWdWsRS2t1/59U8ZA40eGT8WB90xl/D86s5HiRsFbQvDVlKURtTRVAe+Zq0WjzpVKDsuwJfApgX+dog+GHCd1qciaBpEK9X4b1XpbyuKwufMhsQ6pDMcggiKzb9GZEPJNorgSWPjpBA2GPKMT/5a2B5j9tfxHjpT1KIx+uNqRVOUepFqdz5M809wx+RRlE2EtlGtiVwcj8/gWWgFh81fcpLfUrnpRQeop0kRpJZTu+t8xzI6Jvc/xZRyCsrlAmr3jqjiBLtZ2t7gZKuj+E7D9eTF+Hk5xMmQHOlLZM84y7x8LgT/e6lKoIj/uPgoFo+ydOhTEKPuLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(39860400002)(376002)(136003)(346002)(230922051799003)(186009)(1800799012)(451199024)(64100799003)(31686004)(5660300002)(86362001)(4001150100001)(2906002)(82960400001)(6512007)(53546011)(83380400001)(38100700002)(6506007)(107886003)(6666004)(2616005)(26005)(478600001)(6486002)(36756003)(41300700001)(66476007)(66556008)(66946007)(4326008)(316002)(8676002)(6916009)(8936002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d29SaDdRQmt2cW1FUTZyZ1RLZzdscWdrSTcwU0kzekdIV2sra0wzSUVaSmNp?=
 =?utf-8?B?eW9yUWRKbDFpWk84MFBsemhMVHlFdWJHT01iWmJkS0xSSlYveTZSWXYvSnh1?=
 =?utf-8?B?Vy84VFU1YVJ4NldvZDYzUjNUV09PVFpBeWYwMFNHMjFsNFJLdXlXMWdXZEhw?=
 =?utf-8?B?KzFPUTBBVGNrdVNaZVJPcWVNVW8yTXEvZ2pkQ3ZQT3ozUFA3SFNTWEtmakVL?=
 =?utf-8?B?MEx5eFJoc2pIdGxLaDJXUTdETXZvdG1qdThkanBtcjZEYnEyMG9zMnhoT1ln?=
 =?utf-8?B?akFwTWMzc3dYcFFTZ1kxTU9QcElQaWNRNEFibnlIdTRHb0ZXL0t1ajM4bnQy?=
 =?utf-8?B?aXRzMnF6aVNDZkFaZkNJWlRWSmZmKzkrL2ZSQmk1YnFNNkRnbW9UKzd5YzYz?=
 =?utf-8?B?elFqRW1EQmcrNlpSREtBNEpLSzBXTmJ1R1ViOG45NjFQTDJqOG1rSlA2OXln?=
 =?utf-8?B?ZEphRXM3eGFmcG9NOUZONVRZT2RrUmpyczRJdkJLRmZPaWpkTmRpQjd6ZERH?=
 =?utf-8?B?aWdkVGhKQks2SEs0Q3h0WTg0cDZtdHcrZVhaL28xRHM3K0o5YkR3RUFlNFZq?=
 =?utf-8?B?WGMxNjd3cHZ1ajlTcW9PaGpSMm5Beit2RXBVcEUyUFA2aHFGbnNpYUtTVGM0?=
 =?utf-8?B?QXRySzVuT2xBRmpqRTdMRDFHSjJxc3JOdk5DeFVkT2Q3NFZKUERIMXVERkpK?=
 =?utf-8?B?SmJ3SEpINzFoNENNelExSXNRLy9Ka1loL0YrYWs1cDlWdDJkeDdRNXNRQXVi?=
 =?utf-8?B?V0dvVlZjaC96TXJsY2laSFg5em40MzZjQ1llOXMzenE0cFE0MC9JemJOSzBO?=
 =?utf-8?B?QlE5ajRMVi9lVGRSdnBTRy9IaTFTck9sdkFmTk9TVXlQNlFnLzIvbW1vUnRw?=
 =?utf-8?B?V2RtNjZMZjU0N1BzOTBlUXVYTVIzUUF1OHZDTzJjNW42bW8wbFRPY1QxRXQx?=
 =?utf-8?B?c0NhR0ZBbDg0UFlUR2pQZ1BYWEVtSkFhUDNaS2pKa2Rhb0I3UktNU3N3Zmhu?=
 =?utf-8?B?RFJiSVRmR2tNSmZlVXYybFBIOC9BREV2Tmw0SnRDVDA5OGJZSFZJdVV2dUI0?=
 =?utf-8?B?RU56QVlXWGQ2T3ZiVnFsVWVVNVBPdHlmSzZCT1VvVm1mTWtkaG1YTnJaRVEr?=
 =?utf-8?B?bDFuSVM1dWpQZnByQjkvMjNtdlVSSFRXblZDNWFxV0lZRXlwVHl6OExUQ29K?=
 =?utf-8?B?WjZEL2dwMEVJZ3VoSGZTTEpvNVBhaDJqM3pzQXZGeEJCZ1lwMll3VTBuYnpl?=
 =?utf-8?B?ak90Q29QeU9vMHUvaWpMT2sySmJMVFVEUHhTWElxL2dSbUlNRFpZUGoxTTVX?=
 =?utf-8?B?RTlGeVFuc3ZJSk5UUVFoSzAyanFxOUZ2UHliMlZiTkJibEp4MzVSWEI3QXEr?=
 =?utf-8?B?TnB5UmpKeThsRlR5VUQ0aVBCMFo0Z0FFVHhqZGFrdWg5QTZ6QzN5dHQyVnFv?=
 =?utf-8?B?V2kxQUFPQzdSbDh6OGZ2M3Q2ZXZjeFM5d2crUzlDRlJXdVduQlVSUzYwZjBh?=
 =?utf-8?B?S0ZPN2pxZFhSbnlaN3F3MUxhMlNhazZyTXFlQUpiMmhLL1NKampnS3MwY2xK?=
 =?utf-8?B?dEFObDB3UWxPME9MTXFOMHQ2dzNvQ0hQaDRrRlgvbkJ2K1pJSlR0cWtOYndQ?=
 =?utf-8?B?TVdxSlpvN3kwOG5nWTRnOTJMVUpEQ1dyRks1R1dsaUJDSXBJVWl6TjFhTGR4?=
 =?utf-8?B?VWcyMTFiTGtGSFRYd3V6UjNrYkQvdURaQzdMcEJmR3NVTFNxeXYwanBvUWlZ?=
 =?utf-8?B?Q0ZyRkJwdkRyeEVHcndLTFIxb1NqZDlxMUt6U01Na2lGWHpUa095VFlPZlk5?=
 =?utf-8?B?eHdpcGFibzVtWThFeUR1VjFNa2F3OHFKNHl0bWZoS0pCeUw1MnlRMWN4M0FY?=
 =?utf-8?B?TlRQWkZVekRYOHUzMGNuU1ZsT1Q0NEJaSTlpcTRNM2xsL1hIaThuVkgrRXBG?=
 =?utf-8?B?NFBxRVppcWRrOSt4UkZNNmtaT1kwc0huWTNQOUgzUlFZVkNaYzkrTnErejA2?=
 =?utf-8?B?VEo1anB6bEtHL1RMR3FlcmlNbUpiZU9sUmVBWE5xNXZUaWorWEZnai9iczl3?=
 =?utf-8?B?UFd5ZHpsK3NJem04M2c2UUE1V29TZzFoZWZiM1hHMEVSRzJqOXRxdjZPVkxl?=
 =?utf-8?B?Q2w0VmFjWXEzRjdjelB0Z2d6OTRYVENCcFl1dlkvRk15TFVhN3E1VTZUYXcx?=
 =?utf-8?B?V0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 84bd25d1-04f7-45df-b07e-08dbf252551c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 09:46:03.7208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MU4wOuUilxrDVvML+XBJetfL/xN5eWR3BhFYFxtpZ7QaNKsqzeC0wErKVXW6F1SFiJMsqRZ+0aPZZsme9JpEng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6823
X-OriginatorOrg: intel.com

On 12/1/2023 1:44 AM, Maxim Levitsky wrote:
> On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
>> Enable/disable CET MSRs interception per associated feature configuration.
>> Shadow Stack feature requires all CET MSRs passed through to guest to make
>> it supported in user and supervisor mode while IBT feature only depends on
>> MSR_IA32_{U,S}_CETS_CET to enable user and supervisor IBT.
>>
>> Note, this MSR design introduced an architectural limitation of SHSTK and
>> IBT control for guest, i.e., when SHSTK is exposed, IBT is also available
>> to guest from architectual perspective since IBT relies on subset of SHSTK
>> relevant MSRs.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 42 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 554f665e59c3..e484333eddb0 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -699,6 +699,10 @@ static bool is_valid_passthrough_msr(u32 msr)
>>   	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
>>   		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
>>   		return true;
>> +	case MSR_IA32_U_CET:
>> +	case MSR_IA32_S_CET:
>> +	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
>> +		return true;
>>   	}
>>   
>>   	r = possible_passthrough_msr_slot(msr) != -ENOENT;
>> @@ -7766,6 +7770,42 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>>   		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
>>   }
>>   
>> +static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
>> +{
>> +	bool incpt;
>> +
>> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
>> +		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
>> +
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP,
>> +					  MSR_TYPE_RW, incpt);
>> +		if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
>> +			vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
>> +						  MSR_TYPE_RW, incpt);
>> +		if (!incpt)
>> +			return;
>> +	}
>> +
>> +	if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
>> +		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_IBT);
>> +
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
>> +					  MSR_TYPE_RW, incpt);
>> +	}
>> +}
>> +
>>   static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>   {
>>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>> @@ -7843,6 +7883,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>   
>>   	/* Refresh #PF interception to account for MAXPHYADDR changes. */
>>   	vmx_update_exception_bitmap(vcpu);
>> +
>> +	vmx_update_intercept_for_cet_msr(vcpu);
>>   }
>>   
>>   static u64 vmx_get_perf_capabilities(void)
> My review feedback from the previous patch still applies as well,
>
> I still think that we should either try a best effort approach to plug
> this virtualization hole, or we at least should fail guest creation
> if the virtualization hole is present as I said:
>
> "Another, much simpler option is to fail the guest creation if the shadow stack + indirect branch tracking
> state differs between host and the guest, unless both are disabled in the guest.
> (in essence don't let the guest be created if (2) or (3) happen)"
>
> Please at least tell me what do you think about this.

Oh, I thought I had replied this patch in v6 but I failed to send it out!
Let me explain it a bit, at early stage of this series, I thought of checking relevant host
feature enabling status before exposing guest CET features, but it's proved
unnecessary and user unfriendly.

E.g., we frequently disable host CET features due to whatever reasons on host,  then
the features cannot be used/tested in guest at all.  Technically, guest should be allowed
to run the features so long as the dependencies(i.e., xsave related support) are enabled
on host and there're no risks brought up by using of the features in guest.

I think cloud-computing should share the similar pain point when deploy CET into virtualization
usages.



