Return-Path: <kvm+bounces-11271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BF1D874873
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 08:04:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 312B92839CF
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 07:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 956B81D52B;
	Thu,  7 Mar 2024 07:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DcLEwG2O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252EE1CD09;
	Thu,  7 Mar 2024 07:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709795092; cv=fail; b=U2E9d1TUfkMfc62wz4UTPcbcq7BCEfqdoeBxAvnl1G5c/f6b0OMgi/R5j1rZ9LtyMg364k2L/7KkFJmPEx4ncG/eWxSNMWUP6XowuYcWCo0EAA6X+9QWPHCs0f3hGQ0nM3bnf2+dTJQndleDKe4OMV5AA25mRCDQiZU1XzA9yG4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709795092; c=relaxed/simple;
	bh=+Jna62Nwqkr57fP+GODKcwkr12bZo4ucv+O0+LVROG8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TEd5wXgZhKgYVQ5/uT4hl0lScRUSEpuSuTn+Sl2ZTnQoZyM2/o1+fIDDhKlHfimV4kLnRTd9lg1BHr1pWmceRLTWVFPrVBQ4/UAPPDmG8dRd3EZod0CiGYcnUxtLnOKGd0NN6uRPq5TlnD6HYtCKRF+Iq/P3nDPZrUo0/INln40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DcLEwG2O; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709795091; x=1741331091;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+Jna62Nwqkr57fP+GODKcwkr12bZo4ucv+O0+LVROG8=;
  b=DcLEwG2OlLSFd8vlTkQmm3AyZTLZ7gDRiwUf4m0HRa3VMJ1Xn5oEveDz
   u6gbSgprZ6lCQ4oe2ChsV5XEBy7kq1KkqLWGEcNF1cLOYzDa7hW6U/HQ2
   X4raddHaaGcBkAmzq7k2WYT5UTyPuEwBHRY/m4X+jnra0MO2uFaKpjc7X
   GAViUslh2TcUDJXi/QlxurQSdMW0fnlErbqXqv6S0VFMFQntypp/zFhvM
   SXJSRICXz1NgG0lcTBVad8cSeQfXCkHVouNwShim74/c1w2vLvmAEfieA
   uxIK4HnEep40NTNMRjPf1OMBRf4yJXIJpF3K/0ph6NxO/+GGdpQih4FWC
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="4590880"
X-IronPort-AV: E=Sophos;i="6.06,210,1705392000"; 
   d="scan'208";a="4590880"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 23:04:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,210,1705392000"; 
   d="scan'208";a="10445099"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 23:04:50 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 23:04:49 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 23:04:48 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 23:04:48 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 23:04:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jDrLzJv2xn1CV5DuTlkpASlb4mHQ0VaHJWJmuNXjQUo5T1TUROQ6vzju0/HjwFEkQND0pJfK51W5/5AFm9tzM955a1u0HAaLLq+w0Y/wjo/U0Zl4DmtJprelRiMrhWrHtcVSXmqy21AwQNCaiyL7LpeyJPrxpdJlgWe3PQo4UPkA1OPJ5NWkISSMO3fa+zgdkURvyoYHLYtQNX4/9AuM33BynmtOQ7iVmlGwBLSPZH2vVdSgJJ6ZADwgY1pEdttNCEIghba6nJUnzSu3tZs+VGMtFQAVlK1Z0dsHAOOgCTGXMlC/30EB7TjaRVpD4qEnD+Gghzr3A3+kcw1AAO7HuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NciOV+7kswt8UPmXZIboGRY3EIfyYuzBuhXSz1Cadgc=;
 b=SX4ELjHNJzrUVdliH0Uw3QyOKgsxaUM5n6FssbZi7OsFmUTqt2ppHx7HgUS+s5V3O4AqVIZiM6/GuKEqsg35s0IJUXqiWgAHsfFNnzSzAGjS391GcRvs13+ZU/D83t9HFeGIBOlbewF8w1DbdDKMEvnp2S3jOWT40YoBs3EJdwz0XzkERbp2E7aJW+zbfUjSaixsWxu7in5lRTwYca1usNBuIXFimezqrch+PAlhfjiee0yixCVtI97WaxIwax+vG3RX9OynU1Lcl16zeXI+mQl1hxrax+TKGK+haYVwoq77f17zSmaP7JANx7gJtLS18canMKt8KSPYNXLaBEQgjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by LV3PR11MB8601.namprd11.prod.outlook.com (2603:10b6:408:1b8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.23; Thu, 7 Mar
 2024 07:04:45 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::65ce:9835:2c02:b61b]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::65ce:9835:2c02:b61b%7]) with mapi id 15.20.7386.006; Thu, 7 Mar 2024
 07:04:45 +0000
Message-ID: <54f8943d-529a-4fa2-83f3-b79eeb0446ca@intel.com>
Date: Thu, 7 Mar 2024 15:04:39 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 013/130] KVM: x86: Use PFERR_GUEST_ENC_MASK to
 indicate fault is private
Content-Language: en-US
To: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <c560cdadb7d0dc88b831cf1a5382cf6f166ff022.1708933498.git.isaku.yamahata@intel.com>
From: Yin Fengwei <fengwei.yin@intel.com>
In-Reply-To: <c560cdadb7d0dc88b831cf1a5382cf6f166ff022.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0043.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::12)
 To CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4820:EE_|LV3PR11MB8601:EE_
X-MS-Office365-Filtering-Correlation-Id: ebf14fa9-4de5-40d0-e365-08dc3e74dea3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RQVNMPmQqtA+dhVwTZzpNyvmZ8dsDMMYZmLbgXonX0iRretMBkS0WuhfYYZ3FBQvuRFvZUbkTCH+P4RdcGeZdhy8q9GZpeVvZDD43yMXZCl+KMp6nvQY37jaNpJLUbL3K1XbCnyRUccvdYjZCnHaE5gDkiu8rXMzSSZvJNDWANJoVlO+/RV48edV2TULccb5/A7Kai5clxayPpr0Isqd5rJ/z7zZhnFMwt1pCEC7Cv3NtuSPbe59Gds+TOCrgLoI1Ell2hoBeWt3UmTcPynkTkLM0QcMu12UM98cLRwuiE5ZKMSdBRyVZXgu8DDigDN7l3W15yL778eOmrNqOumJ/YSSG5Qg4zDSdV7i8v/M2SrUlr6661I7oZiArCL5oEWgxcPmlX8GINrfJJe0UOrs7YjRQefYaIkjeejhYuYPpoIOEgdaFCCdgGE/yOrtB0QP5Wti0mhTknsBSoNwdeu7T5L/wJi0tCxQZND3R9q8+83RdUfbIvqFdrpXqUVknyUZMxG2LHg+EKf8am1hvh6KaPS9szx7fOcirAAUnoA/j7590xAAUM0b0CWlbEuuAp6DofQRae22k6vilK6D/5dUSNlyeA88iaeJP362zwOUaeXwP2xji208DaLCWbT0CQiaVPdphn74ojypS8CbWUND7Gyv6ADtfcO3/tVI+L898jw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dnF1ZzdOeEVJbjJ2V3N2ZjFyS3Q4Z3dyYkNIWEdOUGQvYThPVFNnUDE0MkxI?=
 =?utf-8?B?MmZ0OVIxYXdVODQ1ekVuVUNUTll6OHZEN1JPVlgwd25GU1duTkFrZVFYWVpp?=
 =?utf-8?B?REtxZUJ0aVc2c3p5V1ZCUUJaTTU3V1NGdHZHd1BqREc4U2k4ZXdLRWhsbm5T?=
 =?utf-8?B?R0lFUjJwSHM2K1RVeVZnS3lFM0pXM2JqQUc0eC9ZUTgvR2g1L3d4eUdLYk1a?=
 =?utf-8?B?cHh0L3FqNjFYcVJKejBIdE5PKzRyYTBlb05HNWdocFJsTzVYOCtseXc3NlBu?=
 =?utf-8?B?SDdEYVJMSXVmRitkNEJpQUthRWsvT0h0T0xITmtUTTMrZWdKWXFyVlBkd1JU?=
 =?utf-8?B?SXB2V2IvV1FVcXVlYXd4emtuOUZDdTV5dWYrRDd5alJCc0JKeDJJdldwU0k5?=
 =?utf-8?B?dmtPMHcwbU94M3hKdk5zdEw1SzY2ZXM3emtmVUZDMCt3YTJvTjdSc1hZRzBK?=
 =?utf-8?B?MmdtNURKaGFMM2VhNUZmdC9XNWFYTDJITG14aVVkZGVUeUo1bURWaGxzTDAy?=
 =?utf-8?B?azJkejlZNk5JSVMxSUlXbDF5UTVKYlZYbVJCQ0pyb0VwS1c0QWsyQ29uOUpX?=
 =?utf-8?B?by84ZWlpZVM0WDRLS20xTjArSEMvZWQzKzAxdWlvWFJFME4wand6emFyT1F4?=
 =?utf-8?B?Q3hibHhPRDVRdEFucFBVa2tyWmx3ZVhkVXdDRERhcmJNVUFmc2l3d3M1aUha?=
 =?utf-8?B?RFE5VjRqU1NJODJHWnBSaW9kQ0JEUk9xR2xsZ0tzVmpVZ3U1bHlLRWx1OWVk?=
 =?utf-8?B?dDlBRmhoNWFnWnk4VGFsNC9sTEhCNkZjYmRtbUFkN09MOWxqUVRXc1AvbjUz?=
 =?utf-8?B?bTR0SWRyWlJ0MHB5WDZnS3VqeXlMSkFBd0Z1dUVUeHJEMTA1T0VrMEFHaDdr?=
 =?utf-8?B?N1U4OGNNakk0dDJEQWtIdEp6d3B6bE1LWkNPWjBkN2xXd254Tm9JUWRLY3NP?=
 =?utf-8?B?NGJsTFBWYTlLdUhoUGw0c2kzTkNpdVY4ZXZySmFaQlh4VmQxRW9VZUkvVFJ6?=
 =?utf-8?B?UEhNdExRbkkrR09PR0FxMXNmbWJCSU9BRm1ZR0pqelZIczdIbnFVU1dESWRT?=
 =?utf-8?B?ZzBETE1zenBHRGhmbUo4S3MyckxoenJtbmhVeDZ6WHFtaUxjSzhrUmUwZWwx?=
 =?utf-8?B?eldzWDRYdm4vdG4xc3pjQWdGd3MzKzFJWlZ6NW9wOXZIQXJ4VzBJd0Z6RUdJ?=
 =?utf-8?B?Rm9nZFdDaGNHd0x6eXJqN3AzWUVab01KazRZMGRtSUVKYjlMOW53U0tVVmxI?=
 =?utf-8?B?U3RpRTFoZTVtZkk5ODZsTlhaMUlZbkhUY1k4Qjl4R0MrSng4WEdWRDZsZmlk?=
 =?utf-8?B?ZVBYUmtYa2tEWnVoMGxPbTZzVUhKTU5hQVljTFBIdEIrV0haRTh5WUVvRTRz?=
 =?utf-8?B?YmpFbXAvZm93QS9qMXU4R0ZBanNTRXd0bFVOS1FpOTlLMTd2VU56d2crRHMr?=
 =?utf-8?B?Q1YzQnlRMlNUY0lLQlFNRzIwM1MxejlPdUdMbk41a1g2M3ZpN29SQVZWelhD?=
 =?utf-8?B?dEFiKzdrWUFMeDV4dzFIUzV0L3EzMTFDSVR1Y3JyZG40UEFPWWwyVjM3WlV0?=
 =?utf-8?B?NUJoVElxdXFRc1J3dzdSVVBqTmsvdVhBOWVvWDd0dWIxQ3kzSU5tREhFQjdB?=
 =?utf-8?B?ZHhFeW1aUDZvNFd0USt1RnBnUjF4NWRtaUlTQ1phbEd1dUE3eUJERmd4QmZV?=
 =?utf-8?B?WERyWTI0M21ZM3l5VGk0UFNlc2YycHdQM1ZBY0JPK01oVmg5VlMvYUdVRHg1?=
 =?utf-8?B?STFUdkV4c1JESFBQNWdXVnBuRmNmTGgrNXA1d1dJaW5ycXJJTTdESTY3Q2E5?=
 =?utf-8?B?YWhjaWtzalVlZ0lMeEZyU3JrcDB4Q1Z3UHh3WXlaNWhxcXFQOEhoZFB0YWFJ?=
 =?utf-8?B?U21vVkpNYXhleDB5QnNPODNtY2JIRUpiY2ZzNi8zRkY1alplY2lNeVJFN3lu?=
 =?utf-8?B?bmJuTWpRamtDcE1obTZzNGViVUovb2x0T2pJVGxKdGlCZGlTRVJuYloySjVN?=
 =?utf-8?B?QXZENzkyTmpSbXNQTHpDK0IyMXRJZXV4T0V5RzYzZzZNR0MyWFErWEtxbWF3?=
 =?utf-8?B?bVlZVjJDSlpPRU1OWjEybjhQSGx3Q0lpb0RvZ2VVVkNEMzNYdEpIN0p4MVVs?=
 =?utf-8?B?QkpUNnRENEZBREU4Q0VWcHAzWUxmZzBGUC8wT2lVL2F3d3lIajJGTk5OZTBw?=
 =?utf-8?B?cFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ebf14fa9-4de5-40d0-e365-08dc3e74dea3
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2024 07:04:45.6091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q7mOcX86CpPzke8Qd4wU3JLJxepxXb5odENfpRf5x3FUoeOm+cNo2VU5U6m2oO1FDuYlwNdJufBynlhSfKk1Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8601
X-OriginatorOrg: intel.com



On 2/26/24 16:25, isaku.yamahata@intel.com wrote:
> +	/*
> +	 * This is racy with updating memory attributes with mmu_seq.  If we
> +	 * hit a race, it would result in retrying page fault.
> +	 */
> +	if (vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM &&
There are more than two times of similar check in this patchset.
Maybe it's better to add a helper function to tell whether the type
is KVM_X86_SW_PROTECTED_VM?


Regards
Yin, Fengwei

> +	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(cr2_or_gpa)))
> +		error_code |= PFERR_GUEST_ENC_MASK;
> +

