Return-Path: <kvm+bounces-12339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5774881988
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 23:38:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3BD61B24ECA
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 22:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04E9585C48;
	Wed, 20 Mar 2024 22:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BoGbc2CT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AE0339BC;
	Wed, 20 Mar 2024 22:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710974296; cv=fail; b=twv8xSC4OeCVGW7T6eUQcYCCDYH9dXbHLppj3qy9isJn7Nhfy8SXyUfaAVvAp5Bbru5yq1ahes5wiYHqipeMULSd/2dG+FlNh0M6ByQtpitY87xy0HcaJHMkii5s/Mc033dBaeIW3FobEW6zAZjlS5j9dqsop9o2/8vxBAuTcgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710974296; c=relaxed/simple;
	bh=6ERLXYPnVPnbKW6DshUxPtOubJvjrKhH08EQ0d/ZWsI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I3ss3gBsX539U1fHyBTE2FBWn9nDQ7GhE+zWKd4aqRVMxCAq52v8zbtIj/EpQjUGT4IVbKRR+VsNT21UUub08USEga0c0rb19wZ65XuPoX2xAvpeP/aozPuLTHqI+GibeqsUPtoF+v8YC4LJS49yrLgTjiFA94lQgT6Fw6KxJ1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BoGbc2CT; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710974294; x=1742510294;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6ERLXYPnVPnbKW6DshUxPtOubJvjrKhH08EQ0d/ZWsI=;
  b=BoGbc2CTCGRXk4rWAeitYRlVerRm64RxGtQsb3BBx28O7aVrteRF2GYc
   eGvXoJgzSfv+NrFG4chUjpv4de0sNGECirdtH5k9PXSpXheImP4J2SXDN
   XW3BY/ES/xf0blLH/3ZjFj3exD4fNcyh1T+s2Q5Vhs5/wnZ0jmqh+0H6h
   uoEXO+4qA9xQdOVUyfgppzuUVFOprHxUoipY3xhvdgg9aavVQzZTMJM+O
   her1GOwoy6mDeRSAju9ElpOIdzgf44E6tbNPyRceTq7WC46IWjah8gHdC
   kGBuwAxgvpmxTBsuocN7hjbQtHxo6wLGbcHyIXj7WGPOYfdImuB8KSwJR
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="6143205"
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="6143205"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 15:38:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="14202640"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Mar 2024 15:38:13 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 20 Mar 2024 15:38:12 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 20 Mar 2024 15:38:12 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 20 Mar 2024 15:38:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=apIXg0n9lLK/qH9QLR5fe4Gd1/FokUtGAQtmV7Lfucev1oWaMmZ/XPxsoTbWfnyixsK7eejVTMq9oZNZBpzFye8ZQeEkaDcOFB2RJv2CNgjfEErBFLGQHqfN8dErqdTCc5OiNRWzxZQ5qGeoyrIyXkZ+AmZ6D7AHahk+4lgrjPL2aYJH73VZdlEwwlLpnIBK0abfiOjF8UBBkJ1gAgPMjnDjx9WD8fwbpJnxQAvxOeG8bf0wo/z2fYvBKDKJ3Xv8pri3gr6sMur0S32i5P8eMNSYYxeAb6xuaWBB9anpMQoezlKgCHHLwSnqPpMepfrNp54TSUjr3gP0/bbfrbSCSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3cB31/rZ7eOqYvfzyH8171TIRujtH0t7GHWLs6t6B50=;
 b=W1iJmfI2dJOnvbXC3+AfyvyHN9mqR+IXpk4xl0RpaSEYGnnrgUZfPk0idAjUYRPnwPRVZ/SPkokgE4aE4sL1YNDLyiqFTBYzPupn9YaDdTFchbdnDExZY0qhmTy/MPFD+dw8eD850zIQtJt/Zw5RRq7Mq1sBO9OE6x/ZviSow6BcVKmnfl7DPZn6VyF7A4s+69MRd2HpbT6/aho13Z1ILfKgv2ZsOK1zRuAWtAlx7qm2sYvOW8jJ/FGaeNl6r3J2N8FiOO+G0NBIuzD6F1pIrlzPa2k3vB8KmvH/CN6FxygCG24eg24LYQqAZjRQhWT7HOYUQWISPhYYEoQIbNamWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB6419.namprd11.prod.outlook.com (2603:10b6:208:3a9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.12; Wed, 20 Mar
 2024 22:38:09 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.010; Wed, 20 Mar 2024
 22:38:09 +0000
Message-ID: <46638b78-eb75-4ab4-af7e-b3cad0d00d7b@intel.com>
Date: Thu, 21 Mar 2024 11:37:58 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 029/130] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Content-Language: en-US
To: Isaku Yamahata <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, <chen.bo@intel.com>, <hang.yuan@intel.com>,
	<tina.zhang@intel.com>, Sean Christopherson
	<sean.j.christopherson@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>, <isaku.yamahata@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7cfd33d896fce7b49bcf4b7179d0ded22c06b8c2.1708933498.git.isaku.yamahata@intel.com>
 <579cb765-8a5e-4058-bc1d-9de7ac4b95d1@intel.com>
 <20240320213600.GI1994522@ls.amr.corp.intel.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240320213600.GI1994522@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0283.namprd04.prod.outlook.com
 (2603:10b6:303:89::18) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|IA1PR11MB6419:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f174984-0ccd-4378-b75f-08dc492e6b10
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aLSjx21l2G561bj7zyPKhFGw0+S98tzkXvFwlQhjdwIUt5q5JnMIs9IiKvJC/V1c6wi63eBFM+14jV/Ad17Uti02uezlrnb9AKnP0x0QOGcuLmO45CNtApfeqOi5/fi0mgARX0HAe5ck1CialFfGVtiACjrcwHRKCVRhLFEZR/eF/APsGGY7RLaSKH24wFj/7qim+mbA4BpritD8HOQr52lKyS8DWy5fIjfz7PY7/aA3cM+0HYJ+AeWMMKaGgwV7k9Y+Nwbw7D7GCySeXaHH7weoWnknU/wzQXXZn/pVFdutqUj4fYQp1EV1/ujSXkKpqy5zgv/jPcHbfPXRFFl1zr22eFPFW3iIXS5orS1OMKhMvasRojge05Ac8RTA9TCG0MvQw2RcKc0rU0xzK2qGNm8hSJPH6/pL1fuJFGVeTOvDGaASLnq4dlrHoehP+uYOcH4UDGstxAPH+pGFW1mYR6O7bhasSBUq8Ffi96qiPrJmj8qC2CyWzkt2KpDg7arQNjB+wn0DStKldMmtVoSrDyRs44XD0vgBetaUCxuyuZhUBeecPL4cWf6p8Cwn7lASw75C4sMl/gp6QWcgbPxdTlAMCIMMz9qVMVmC5STFWOlqNS/u8f/SrdAxdoDvpAsr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEgrbGdMUG1CcXVOYjZWL0dMMjNuQ3d6bUZvU3FDRzBkMWoydm1XR0tqQ3Bk?=
 =?utf-8?B?U0dzUlJxelI0NW1BTkJhK0lzZTFudEZkQUY2eVBicDNkbFpocGMrY1BVc0sw?=
 =?utf-8?B?eElNQUlBNmtMUUp4ZEhpODdmRjlYbHR6c1E3eVpXR2xxNDFoS1JhMkp3bTMv?=
 =?utf-8?B?ZUVHYlo3cmFTUFdqNU9XWFBSM1Y5cmZyUVlFdWUwOS96VE5BYnpZUGtVdVFS?=
 =?utf-8?B?Q2JRQVRXWkR0cDQ1c3ppaW1MQVdpdkFtWFk0bzRZV0ZJREFOS1VIY1E4K0NM?=
 =?utf-8?B?V09tcW5lR1MrK2xacTF6RW52Z2RlUXlLdktEWk9tYWp2WWY4OFFUbVV0QmZr?=
 =?utf-8?B?RnlZYXVlaXI2T2dFdkNQd0I4WmRUS1RMQ3I4TmFGRmd3NkJUb00wTFYzTndp?=
 =?utf-8?B?aXJQbndvSEpPWFZpeEZoZVBqR3lFVTEyMWRJcVhiMWtWV0t1SisyV3E5T0tS?=
 =?utf-8?B?UFFxblZsaHpMRkZWQnJLOVJNTkhoZGdUWG5FTzFFYjRqV1pOTzFBYUtQc29k?=
 =?utf-8?B?WjMvWjdwU25RMG9pcFlBK21LcTVIUWVhYVNKaUJaLzZiKzdWdWx6ZTRGOWpD?=
 =?utf-8?B?NEl3STgrSXVVZFBleHJ0czQxT3p5WStBOGZrZXpKSS9kZnJOb0c3Wi96L3M2?=
 =?utf-8?B?c0dIWXQ5U2NIUDFONnBWcDJJWm5vY3hENlRLVTdaamlJL09iMGlkNGZRMzBB?=
 =?utf-8?B?SWxSL1FmWi9vdFlwbktKYWFndS9rRlpMRThXUWVQTkhBSGNmQjhKMjJWc1ZE?=
 =?utf-8?B?UCtSdTRuaG9LT2tScENRTjN3M0ljeTRnRWRuY2dkTWllZTBCRGxMOTFQclVk?=
 =?utf-8?B?YjFvUlhPR3puK0dCQmdtVjlaRFBTT3ViWi9UcVNrcExGQkh4VTRodml0MUly?=
 =?utf-8?B?alpaekk2dTFtaGZOeGI4L3Y5c0VhZmZsMDNHYllhZWR2ZkhLdWFsRHpSSkRX?=
 =?utf-8?B?UVRTTWRxYWZzZ1ZWZmkzS1pXaDhFeWptckxEa2tseWN1SDdoazFRNmEzeVI5?=
 =?utf-8?B?SFRrdWZ4dU9JengrQ09PUkJhR0N3d2pWWVYwZU1jZUhCMFpaVUlWRzdZVmpE?=
 =?utf-8?B?dnZtRXBOZFEwTThvUE1jeEdsenIyaVdJOEJ1T1MvTTJVZEFBb0Jra1RUWlk3?=
 =?utf-8?B?dnQ2L25yYi9VcHdoY3RNMFdDOGlPeFZMWEpKWEI1Ukw4cmUyRjZITEMrYzRF?=
 =?utf-8?B?NlVCUEJGTUY3bWtjd283dHFCT2J1L2NNNzg3VnBLbDNRYjM0bVdoUTlCZjl1?=
 =?utf-8?B?UkpGbGJ2R1VhVGFsOXdmUkZ0ODFwalBBNk1uUVJ5MGVtYXFDcUp6aURnejF1?=
 =?utf-8?B?NEV2WUI4N0xOVjZ1M2VvOXFjSVpJUHhQUDVGNUg2MWYwT3JyOWtreEF2WjZt?=
 =?utf-8?B?cExhL2NPWldKV2MzSjcxNk9YQkhJbS9JUU9UejE4elBVdkxCRk5rL0xKdUFE?=
 =?utf-8?B?bk16T1JEV3NGVUZRYVdlRjRKL3poRkFQM1FzSzhCRjFqVStxVGtzNitzLzdi?=
 =?utf-8?B?T1k1bTRJQUZpWEhvdGxWQXh2MkFPUEdMRzZrVjdnK0RwOTRjbmNyQ3pCOFdG?=
 =?utf-8?B?ckczVDJheUdDM2RHRUc3R2UwaFpTOWZFSEZVSERQYWdwb3l2R25ZU1V6T1RI?=
 =?utf-8?B?NDhMK3ZPbWRPRTBwNURhcnVtRmxXNXdzYVoraEVrTTBiY3prZU5BT1VzVmVs?=
 =?utf-8?B?L3E4dGtRdHlKeFh4QkozL1RsVGJjVUZJc0V1cHBhV2owRjYvdXk4b3BNOVlq?=
 =?utf-8?B?cTZVUjBKTTVxbUxJd2JTaG5NMWxSK1lMcnhkRjMvWWF0ZysrWnRrU2VkYmY3?=
 =?utf-8?B?NUpzbVpHYjA4a1BSNlovY3psSHYwVGFSbTk2VUFvMGltcUs5VUQ1M3hYQjdN?=
 =?utf-8?B?OXpSYWs4bTlzTSttdEJ1cFowOGpYM0tTNy9SZjlld1hmdUowVXFHYml6QnhP?=
 =?utf-8?B?OEFHWUxtN0JtdWtJL3pmaFlDWnc3b0lYSGNYcXlncmpiS2RlUFcvR2FiZ29u?=
 =?utf-8?B?clBxZ3VVK3FaM2x5MnVSdkZXUUwzZEN4dHlrWnhzRnI0WGhscjBLOTFaY0NL?=
 =?utf-8?B?WWpiQUFFNGxaS3pYYitnSXFQTnhYY25yaUtiaDQ0STZYVlA3T2s1TnJFRTRE?=
 =?utf-8?Q?jqePO0x/ptNolfmtwyeBGntuM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f174984-0ccd-4378-b75f-08dc492e6b10
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 22:38:09.4464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sk/9z3Ep/kcSZ+IO2LWgvQzgwYcCSDiTqKCAENwycEeDVZYo5iTyVn85Ot1nbHdV1Zl9B6+3Gj+apgtUyPzX7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6419
X-OriginatorOrg: intel.com



On 21/03/2024 10:36 am, Isaku Yamahata wrote:
> On Wed, Mar 20, 2024 at 01:03:21PM +1300,
> "Huang, Kai" <kai.huang@intel.com> wrote:
> 
>>> +static inline u64 tdx_seamcall(u64 op, struct tdx_module_args *in,
>>> +			       struct tdx_module_args *out)
>>> +{
>>> +	u64 ret;
>>> +
>>> +	if (out) {
>>> +		*out = *in;
>>> +		ret = seamcall_ret(op, out);
>>> +	} else
>>> +		ret = seamcall(op, in);
>>
>> I think it's silly to have the @out argument in this way.
>>
>> What is the main reason to still have it?
>>
>> Yeah we used to have the @out in __seamcall() assembly function.  The
>> assembly code checks the @out and skips copying registers to @out when it is
>> NULL.
>>
>> But it got removed when we tried to unify the assembly for TDCALL/TDVMCALL
>> and SEAMCALL to have a *SINGLE* assembly macro.
>>
>> https://lore.kernel.org/lkml/cover.1692096753.git.kai.huang@intel.com/
>>
>> To me that means we should just accept the fact we will always have a valid
>> @out.
>>
>> But there might be some case that you _obviously_ need the @out and I
>> missed?
> 
> As I replied at [1], those four wrappers need to return values.
> The first three on error, the last one on success.
> 
>    [1] https://lore.kernel.org/kvm/20240320202040.GH1994522@ls.amr.corp.intel.com/
> 
>    tdh_mem_sept_add(kvm_tdx, gpa, tdx_level, hpa, &entry, &level_state);
>    tdh_mem_page_aug(kvm_tdx, gpa, hpa, &entry, &level_state);
>    tdh_mem_page_remove(kvm_tdx, gpa, tdx_level, &entry, &level_state);
>    u64 tdh_vp_rd(struct vcpu_tdx *tdx, u64 field, u64 *value)
> 
> We can delete out from other wrappers.

Ah, OK.  I got you don't want to invent separate wrappers for each 
seamcall() variants like:

  - tdx_seamcall(u64 fn, struct tdx_module_args *args);
  - tdx_seamcall_ret(u64 fn, struct tdx_module_args *args);
  - tdx_seamcall_saved_ret(u64 fn, struct tdx_module_args *args);

To be honest I found they were kinda annoying myself during the "unify 
TDCALL/SEAMCALL and TDVMCALL assembly" patchset.

But life is hard...

And given (it seems) we are going to remove kvm_spurious_fault(), I 
think the tdx_seamcall() variants are just very simple wrapper of plain 
seamcall() variants.

So how about we have some macros:

static inline bool is_seamcall_err_kernel_defined(u64 err)
{
	return err & TDX_SW_ERROR;
}

#define TDX_KVM_SEAMCALL(_kvm, _seamcall_func, _fn, _args)	\
	({				\
		u64 _ret = _seamcall_func(_fn, _args);
		KVM_BUG_ON(_kvm, is_seamcall_err_kernel_defined(_ret));
		_ret;
	})

#define tdx_kvm_seamcall(_kvm, _fn, _args)	\
	TDX_KVM_SEAMCALL(_kvm, seamcall, _fn, _args)

#define tdx_kvm_seamcall_ret(_kvm, _fn, _args)	\
	TDX_KVM_SEAMCALL(_kvm, seamcall_ret, _fn, _args)

#define tdx_kvm_seamcall_saved_ret(_kvm, _fn, _args)	\
	TDX_KVM_SEAMCALL(_kvm, seamcall_saved_ret, _fn, _args)

This is consistent with what we have in TDX host code, and this handles 
NO_ENTROPY error internally.

Or, maybe we can just use the seamcall_ret() for ALL SEAMCALLs, except 
using seamcall_saved_ret() for TDH.VP.ENTER.

u64 tdx_kvm_seamcall(sruct kvm*kvm, u64 fn,
			struct tdx_module_args *args)
{
	u64 ret = seamcall_ret(fn, args);

	KVM_BUG_ON(kvm, is_seamcall_err_kernel_defined(ret);

	return ret;
}

IIUC this at least should give us a single tdx_kvm_seamcall() API for 
majority (99%) code sites?

And obviously I'd like other people to weigh in too.

> Because only TDH.MNG.CREATE() and TDH.MNG.ADDCX() can return TDX_RND_NO_ENTROPY, > we can use __seamcall().  The TDX spec doesn't guarantee such error code
> convention.  It's very unlikely, though.

I don't quite follow the "convention" part.  Can you elaborate?

NO_ENTROPY is already handled in seamcall() variants.  Can we just use 
them directly?

> 
> 
>>> +static inline u64 tdh_sys_lp_shutdown(void)
>>> +{
>>> +	struct tdx_module_args in = {
>>> +	};
>>> +
>>> +	return tdx_seamcall(TDH_SYS_LP_SHUTDOWN, &in, NULL);
>>> +}
>>
>> As Sean already pointed out, I am sure it's/should not used in this series.
>>
>> That being said, I found it's not easy to determine whether one wrapper will
>> be used by this series or not.  The other option is we introduce the
>> wrapper(s) when they get actally used, but I can see (especially at this
>> stage) it's also a apple vs orange question that people may have different
>> preference.
>>
>> Perhaps we can say something like below in changelog ...
>>
>> "
>> Note, not all VM-managing related SEAMCALLs have a wrapper here, but only
>> provide wrappers that are essential to the run the TDX guest with basic
>> feature set.
>> "
>>
>> ... so that people will at least to pay attention to this during the review?
> 
> Makes sense. We can split this patch into other patches that first use the
> wrappers.

Obviously I didn't want to make you do dramatic patchset reorganization, 
so it's up to you.

