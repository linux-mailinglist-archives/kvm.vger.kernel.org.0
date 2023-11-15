Return-Path: <kvm+bounces-1803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49A2F7EBEEC
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 09:57:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7287C1C20A46
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:57:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9E415247;
	Wed, 15 Nov 2023 08:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TnUwUtXv"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1898F7E
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 08:56:52 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC6D114;
	Wed, 15 Nov 2023 00:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700038610; x=1731574610;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dhEMn7BnC+LT7KHF6xc22edw6+Uwzwd1N5Gt4aqSOj8=;
  b=TnUwUtXvV3Rh5dKMc5P/D1dJHE/KLTluR/22/H0W7O3pC+1GL9BQGl4h
   qxuFA5iOL02+khhdf9W2xsw7YBEWwi9kbTWZFbO//Gtuhdjb6J4mjdKeh
   ahDsXWCywknKNX+NbI05UFrebfpjQK1xWrXxoC0SdoGojX1KL+PayZUmC
   C5XKX2vCPd7iizkHFWPYLNyUPy4OlSLCTJDoGk+O8jFmF/pwaIBcjiAOn
   LxcdnNKQruxdsr60mp3v1WAKODSM/Z1qgKR0k+MrLnEWKhYknacCkQip4
   IWHZ7ANVuoaUvwMnPdL/CKDJ0iT6Uy+JdLLojPQlDwcdXuBhMtBwlo8w5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="393699531"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="393699531"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 00:56:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="6339891"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Nov 2023 00:56:47 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 15 Nov 2023 00:56:46 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 15 Nov 2023 00:56:46 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 15 Nov 2023 00:56:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bDNsyfxsVY/TDEmRYAe56toVqtuk/vaajJYOp/gY+Z5biN7tkp07Q3jyRPSoHld9KqGPiAOEImy2CepGCw+vKg2sB0y8O7+fPW8glv2vcvcCRgrrJQXR5gZQddNZEBWun7bZ1DBwRn5XIFOuCrEbQGw8VKKJ7fwPov8DKjEWPKXuCcqd358G50MwlRVcbba0RDdrYiWHU2s4j1CtnDntQTCbTcGKvU1WR5ZNADvo3a7e5fcLhGE1wBSRoP2IPNDC8WCER4Qp0/naVN9Y8+omtzvoqI+gvJehsNMEBpV+zIfZkgI49tgndMZkfsEyHngu6ouV4bAYD/SqKb1z2u6LVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q9cU0prsL114Zp0wm9Wqwc0wvePSqC39GxG8BousuVE=;
 b=fuZ0WZgJzrDh3H2yBsHvby1/+hdLAE2jQr4Ve2ad3ikh/jj6LzmwT0IfcPtk9Q9wJHenW4FBzQle6YanLFLwkvm8Mxxo1sNDwR59G0IbbN8l45r7EqogSMUZ73fhVsVkH+6u8e1JwxdkA4V9KGS+PqeA7KOdhtQq6XxQmLNAlvnV5AaJCVchBlYZq5GVysa9CvGvIhjCpDk1MdKNmme134BkO0TOVxij2SaFu6OKO+bSy9I9liPwh24NHyBKzACXgeXdeNDFoHkfAOHF5t1YqyZBxn+5+Hh79yWhRTfiA6T+g9NBwqoaTnk0NGX18y57fZZxWhE1PeGvo8j7mAbr0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA3PR11MB7528.namprd11.prod.outlook.com (2603:10b6:806:317::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Wed, 15 Nov
 2023 08:56:38 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7002.015; Wed, 15 Nov 2023
 08:56:38 +0000
Message-ID: <9a0ac0f9-bdb4-4b05-b583-f1b3ae0edda8@intel.com>
Date: Wed, 15 Nov 2023 16:56:27 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 25/25] KVM: nVMX: Enable CET support for nested guest
Content-Language: en-US
To: Maxim Levitsky <mlevitsk@redhat.com>, Chao Gao <chao.gao@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <dave.hansen@intel.com>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-26-weijiang.yang@intel.com>
 <ZUGzZiF0Jn8GVcr+@chao-email>
 <e29c2c8c18f989b83ea2d696ae93590fe5c0ff53.camel@redhat.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <e29c2c8c18f989b83ea2d696ae93590fe5c0ff53.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0100.apcprd03.prod.outlook.com
 (2603:1096:4:7c::28) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA3PR11MB7528:EE_
X-MS-Office365-Filtering-Correlation-Id: 274e741e-f7c6-41ce-d7a0-08dbe5b8c67f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZKTeK1jmYukzkAj3uyTVxX3S0mX8h3cUC8607Ob4pI7fY/tck1vFQ47Hl5Y7rR+WEhem8nq2/576sA4Zt2XdCAEhtewRKZaonabIE+6BxSAGUzIBZbWqdmymp+zVG/hd7MCNaqP6o49uHtYkY3klqPH4UbIu3F0oBVVEFmXf9sqr3qOxZ9Uig8thFdOK/AOkNe4VgK708e0RpnZqs91oG4DmZpq291dcNPtvr+vzYvAsWxKNIvX2tEQE7w72CaGgCuZqGfQRBO6Io9ZCiXEaz7eb1jaJ6js2woVE0EsoL9cMl7PNEVpZslv/TaykSdn5+OOITdmsvbV/gezjf6GMUL9Zao0YtOYcoDz5uOzrcLYVq6PR0BwhZAqR6BsKofrpspcfD83/8/d6PEveMCTZrBQzD8Q1hp/2gVRQIfJAsJ1ueFAKLSAbkABzqijQd2KIEgbTsLSkyNk7syrIRacZNsI1Wsxn9ZNyKX9XjcN08yUBy2DbBav+73dF2xwN+rANOLD1TR0M36RcFa1NTjL3NGV3RWFC2fUvBrtKB6fwTUfHn3/QYlJdyWbhX+W0IRK59NcztykQ4XfShNg9vcQUm+EoIwbkc+sJbBQel1ZVbp3k6SkjqnrHLVHl/Bus5OLgRaBMUuc2Ef+NcxBJlGd//g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(366004)(376002)(136003)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(2906002)(66476007)(5660300002)(38100700002)(41300700001)(53546011)(316002)(6636002)(86362001)(66556008)(66946007)(31696002)(82960400001)(36756003)(110136005)(478600001)(2616005)(26005)(6512007)(6666004)(6506007)(6486002)(8936002)(83380400001)(8676002)(4326008)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3JCNFB2aTZDbGxVN3IrZ0NWdDNWQk1qTmljc2hIa2xUMXF5ZWh0MU83UFFj?=
 =?utf-8?B?QW93dGIzUG9KUXg5aEJqUkc0YVE1Ym1VNGNpRWpjZHpyU1UrcDE5dkV2QS84?=
 =?utf-8?B?OEFDQ1c4allrVTVURWhrOHl1Ryt5STBuZzFjaWtJbGFobjZrWEFCbU9hMzVv?=
 =?utf-8?B?Vk1UMzJmNEdJc2J3dFppNjFDdHZXdGxUQUxCVFFHYVB2RndOTmxCR2NybmZU?=
 =?utf-8?B?MnRlc3JFaElXS2RONmtuYlJtcTRNcU9EYnlVT25ZSTdORXBOdkZoalFsczhC?=
 =?utf-8?B?STZlVTBRN2J5STlENURSZ2drN0JVQVJEbUQ1b255MFBDMVFQSm4xL0lNS1Bt?=
 =?utf-8?B?KzVDckdaU2pwYldoN0UyMlBRT1dVa1NHMDFSQ3B4aXkxd1FJdGhVbWtya2R0?=
 =?utf-8?B?TG5YOUNIMWdtUGxPSEY0OUFETHMxanJZQnhnTnI2eHBUK3ZrU0oxS2NOZXhs?=
 =?utf-8?B?V3V3LzRWODVndXhSdWt5TlhKMEMvSUlCNTVsRWRhcjhBeThhS3FYenZIT09S?=
 =?utf-8?B?dkVFZ2N6Y2NTS1J2L09KNnNlbm1vZkF3QzF3cVhldFlZazR5d1N0U21ib1VB?=
 =?utf-8?B?TU52anVZVTQwNDlRK0RzZ2oxVkFiTlJDcXJPY2hFaGxoZmtPazNBU0RzRUZK?=
 =?utf-8?B?a3pnZnR3ajVqbVd5R0l2WEFyN3N0Zi9naGVtcVdGajlhV0RUZnZVVVYyS0dk?=
 =?utf-8?B?Q1V5aDRnMXRTUmEyNXhlVlVjdzRSM09iWHNPbWhLTTh1Z2JYVGFYZjVJMlNX?=
 =?utf-8?B?R0FjTG9LYXJYd2VkcTFqeXA0WHZ4R1MvQThKMExhbyt0N3dnQUJ2YmU2cmYw?=
 =?utf-8?B?YllsVmtCR1JLNjE3OXN0STBRa05OQzZ3Tzg2Z2ZMR2tEcmlhNlFmbjNlUHR1?=
 =?utf-8?B?T0llQzAwS1Jzc1BvTEpaeUlvTnVaWEJYTWhPS1ByeU1JbkQxdFI5c1Z0b0hp?=
 =?utf-8?B?eEEyODRjM0ZjclpyRFo5bW0zQjFnc0VNQnZNenhEMDhTWFNnNS9QR2gxNjhH?=
 =?utf-8?B?ajY0S010MGM4ckVUOFovalBoRjBxU2JqOTAwVFRkY0ZBVEdtRzFyeHgzdlFa?=
 =?utf-8?B?a2dTWUJXVGsrMUVEajhaQzBKV05BaElvN1ZTUncyOXJLbEd2Z1k5MW42a0pa?=
 =?utf-8?B?UzcxVStlbUV5aTBibllmRVl4MlYvY1M1a2h4NjRzZmVZZ1ZJT3VSUGxFdXM0?=
 =?utf-8?B?N25SdEc2SFo2aFZDZFUyZmJyM0daS1pVT05uNDg0RGMzcVh0Mk1EUWtURFNS?=
 =?utf-8?B?UnZrbEJlZHJJNXVidytaTUlrTzlYbmw2Y3VvaGVqZWY1RUJudGJ0eUdGbENF?=
 =?utf-8?B?Z09EMG1INzlBbFc1d3JIQzZORmQ3RDg3bFhJK0p4VUpTK0ltTnZQdWM2WllZ?=
 =?utf-8?B?YWVCeE1xWVdMTXRmTEk0S1RKR29lemRHaVBqRSthUVBNRUdMTTViZXdYQ2xQ?=
 =?utf-8?B?MmtHSUYwS1AyemlFRjhJdCt5cktsdTVIekRrOTF3U1FGMERETCtBbm5TaEIr?=
 =?utf-8?B?UDh0YVBjdWtwbmZ1SXk1d2pRdXJQR091T1VSM1BzOWRQd05HeVBCTXBzV1A1?=
 =?utf-8?B?RVVBZjUrM0ZyTVdZK0VnK1NLUi9QVXMvNnRrYmJRUGJNUklXUE1CTk9Ga0J1?=
 =?utf-8?B?S2wwRUJoTnVQVmJkT3VWRVBzMXVQc2JnY01OOS8zMmcrNGVqTGdRY0RwVzJT?=
 =?utf-8?B?Z2FxRjZMaEdjaU5UaU9KdGFQWWNSa1JoV0dyb3QwemZTekJxYmRKeFlrQlZR?=
 =?utf-8?B?VEZDNHdiUEtxNlFUQ0N2dzJsVm1UUmZ3cFVLdlBUKzNNWW1YL21JZVloYUpK?=
 =?utf-8?B?VGh3aGNuNm9DZGlDcE9lNnZpUFFtSGpuRUh6dUdXczNtM2pBdkxRN0lvN3k5?=
 =?utf-8?B?eHg0L09mUldOT3YvWGJkYkpqYllQS3A3TGRHT2lTZnROL3V1d0lpWHZ5ODlE?=
 =?utf-8?B?QVlZZG54K0pFMHZ4cllURVU0OEpUS3h1TUVLYlNtYVorQlhsaSs0OFhqSVRG?=
 =?utf-8?B?SUxsYUhQRklPcXlqcmVlejcrUWFJTHNXcHZOdFRCOThERVNCVmtEdGJDK1ky?=
 =?utf-8?B?eFRYRW5INU54cUs4eFYwWjg5VmdzVytvMVpUV2hCSWF6OFhIOW1nRDVTUzdw?=
 =?utf-8?B?VVIyZVZCZ1B2VUpCRTVMZHdsYThUekM5Ti83YWxjNWp0UnNKcHU3aDBJSUF6?=
 =?utf-8?B?WlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 274e741e-f7c6-41ce-d7a0-08dbe5b8c67f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2023 08:56:37.6773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VPdaErqrp+x67PhlaZ47PyAIbifmDfvgp+Vly36IHVI7tgsgOhEWCcgqiCqJSbBGd6QOQSIfTbpTbrQXV2p4JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7528
X-OriginatorOrg: intel.com

On 11/1/2023 5:54 PM, Maxim Levitsky wrote:
> On Wed, 2023-11-01 at 10:09 +0800, Chao Gao wrote:
>> On Thu, Sep 14, 2023 at 02:33:25AM -0400, Yang Weijiang wrote:
>>> Set up CET MSRs, related VM_ENTRY/EXIT control bits and fixed CR4 setting
>>> to enable CET for nested VM.
>>>
>>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>>> ---
>>> arch/x86/kvm/vmx/nested.c | 27 +++++++++++++++++++++++++--
>>> arch/x86/kvm/vmx/vmcs12.c |  6 ++++++
>>> arch/x86/kvm/vmx/vmcs12.h | 14 +++++++++++++-
>>> arch/x86/kvm/vmx/vmx.c    |  2 ++
>>> 4 files changed, 46 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>>> index 78a3be394d00..2c4ff13fddb0 100644
>>> --- a/arch/x86/kvm/vmx/nested.c
>>> +++ b/arch/x86/kvm/vmx/nested.c
>>> @@ -660,6 +660,28 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>>> 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>>> 					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
>>>
>>> +	/* Pass CET MSRs to nested VM if L0 and L1 are set to pass-through. */
>>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>>> +					 MSR_IA32_U_CET, MSR_TYPE_RW);
>>> +
>>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>>> +					 MSR_IA32_S_CET, MSR_TYPE_RW);
>>> +
>>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>>> +					 MSR_IA32_PL0_SSP, MSR_TYPE_RW);
>>> +
>>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>>> +					 MSR_IA32_PL1_SSP, MSR_TYPE_RW);
>>> +
>>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>>> +					 MSR_IA32_PL2_SSP, MSR_TYPE_RW);
>>> +
>>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>>> +					 MSR_IA32_PL3_SSP, MSR_TYPE_RW);
>>> +
>>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>>> +					 MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW);
>>> +
>>> 	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
>>>
>>> 	vmx->nested.force_msr_bitmap_recalc = false;
>>> @@ -6794,7 +6816,7 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
>>> 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
>>> #endif
>>> 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
>>> -		VM_EXIT_CLEAR_BNDCFGS;
>>> +		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_CET_STATE;
>>> 	msrs->exit_ctls_high |=
>>> 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
>>> 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
>>> @@ -6816,7 +6838,8 @@ static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
>>> #ifdef CONFIG_X86_64
>>> 		VM_ENTRY_IA32E_MODE |
>>> #endif
>>> -		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS;
>>> +		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
>>> +		VM_ENTRY_LOAD_CET_STATE;
>>> 	msrs->entry_ctls_high |=
>>> 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
>>> 		 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
>>> diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
>>> index 106a72c923ca..4233b5ca9461 100644
>>> --- a/arch/x86/kvm/vmx/vmcs12.c
>>> +++ b/arch/x86/kvm/vmx/vmcs12.c
>>> @@ -139,6 +139,9 @@ const unsigned short vmcs12_field_offsets[] = {
>>> 	FIELD(GUEST_PENDING_DBG_EXCEPTIONS, guest_pending_dbg_exceptions),
>>> 	FIELD(GUEST_SYSENTER_ESP, guest_sysenter_esp),
>>> 	FIELD(GUEST_SYSENTER_EIP, guest_sysenter_eip),
>>> +	FIELD(GUEST_S_CET, guest_s_cet),
>>> +	FIELD(GUEST_SSP, guest_ssp),
>>> +	FIELD(GUEST_INTR_SSP_TABLE, guest_ssp_tbl),
>> I think we need to sync guest states, e.g., guest_s_cet/guest_ssp/guest_ssp_tbl,
>> between vmcs02 and vmcs12 on nested VM entry/exit, probably in
>> sync_vmcs02_to_vmcs12() and prepare_vmcs12() or "_rare" variants of them.
>>
> Aha, this is why I suspected that nested support is incomplete,
> 100% agree.
>
> In particular, looking at Intel's SDM I see that:
>
> HOST_S_CET, HOST_SSP, HOST_INTR_SSP_TABLE needs to be copied from vmcb12 to vmcb02 but not vise versa
> because the CPU doesn't touch them.
>
> GUEST_S_CET, GUEST_SSP, GUEST_INTR_SSP_TABLE should be copied bi-directionally.

Yes, I'll make this part of code complete in next version, thanks!

> This of course depends on the corresponding vm entry and vm exit controls being set.
> That means that it is legal in theory to do VM entry/exit with CET enabled but not use
> VM_ENTRY_LOAD_CET_STATE and/or VM_EXIT_LOAD_CET_STATE,
> because for example nested hypervisor in theory can opt to save/load these itself.
>
> I think that this is all, but I also can't be 100% sure. This thing has to be tested well before
> we can be sure that it works.
>
> Best regards,
> 	Maxim Levitsky
>


