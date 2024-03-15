Return-Path: <kvm+bounces-11869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D02A987C6A4
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 01:02:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80D91281208
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 00:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 712351C11;
	Fri, 15 Mar 2024 00:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KiDwR4zj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A99363B;
	Fri, 15 Mar 2024 00:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710460944; cv=fail; b=B/5Pom9L4LZKTI1n3+rQGnwIxc4qgQjVZmz/q2oWUQNaqKt8yt2lDQD6WtVRn0OQJ0ivWONVFvcMKdeRRhjC82OPwfG+w9Mo1I4VO0I4GA48o2lCVzC3gBGkJoaqYAfjHtqkEz2T/JGfbvq0vyOaoCx+gai5D2vzD4AvNNDq9Nc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710460944; c=relaxed/simple;
	bh=2ej5kx7XN625hmuQxihOI7UO6Tm8t9/FPm2Vj6SDXzc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FhcdQXRjshRsCNAC1rpxDIjCC0jwwgTYSPPHyZsBFazdKFTNOcO/2biIr0D0OQGmcJeV1ZQFdbOBdTJ0V2pQZXhnuKa1OHc7rcDQW66KgRsJ2e4Y63oP/YbRE3iOzAS3b4uH89k4tXbUEZm1W8/ALFRxqOFUcTKp7Z2QCVzlpX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KiDwR4zj; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710460943; x=1741996943;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2ej5kx7XN625hmuQxihOI7UO6Tm8t9/FPm2Vj6SDXzc=;
  b=KiDwR4zj7dkCyXPQvAynSVuV5uu7rrf4+yCG7OMnPXve8pjdDKAXNoGl
   r4dPqZVM+LHoH5Y+GFnuRgCwFikgN8ue+akHN1+oYU0Hn2UbI9Cry01k4
   wtN3FhmwI+UYqdOIFoibV0EFVlyCywJ2AiQC/5max77s18ZSpIQGjgozj
   o7O+maz/1U9Sbk0eLal6flUXbDtlhsANRbTq+ZbcvQVCRziU/5xxUxJja
   3PTrEAQEhgoAqqJPG3tXUhs4i0+UENi/Pd/DmEzZF1YQ9TqU5LskWU9TI
   jHRjPIC3e/QHyJR9qwS9D0rzXFG30dLOyQj9f0XHzAbWEezY4nnTMCFjO
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="9128422"
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="9128422"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 17:02:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="17144556"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Mar 2024 17:02:21 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Mar 2024 17:02:21 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Mar 2024 17:02:20 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 14 Mar 2024 17:02:20 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 14 Mar 2024 17:02:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kju5xUtOZiXMVyNtMFINM+FUi2Lyhzt5WcQuwJQeVGgGS8CpZs2p76rV4k0KGKx8aRz0kwjkJGWCphZC8GG/djTeCr2Q+mpJ01FwF8sbFI8NuXv7PkMUKpxX8ZofrZ95U95a5HTCO7mXSTnDT/559/e2v1Rdi2wlEWDg2Ym83gqPXQHTgWp0Sa8G5PTqWChGXz+oJFOFmr8jIigjLt2VUtUjV/LzPtkRAUYeMHpQjqe0XzvLdpJ8P7bEu4EbpPpjaxJxLnwkyZCq/yMWxsC/5HRqyZ0CvFP7hoWkRdlYy+t9l2ZTulViEbX8L0XhOBTrFVtQkI0BWLsy/lm1IoudxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MK3aoAOnIamHbcQa+bvcOnYEFmhXMEQrJ3oMyoMMqw4=;
 b=dg7PgHkQ8+x/M6Ac9Vt0KpFJ1c/xROQ1k75uzsVPAkFX1Z9a2LtVZ6hOB5J17Nixkqu+GbjPSqiZJeuO40x2Ngu8In5I68kKBXEyzAHmes7hynZuHsCmSwr7+Hr7Tkv9nCaf1qIhbCl2vnGQptkjkFTvv0AMWpd5oukzGJ8l7XtjEzW2hXUISyGLZeXHopMvUvhgH6ZzUXSqeW4NjyPeWGDL77dlgNFzmTC+WKjjFKoo3eoATF2KuFEg7hCcc6bQzNMdI2UGAkmb9B/FEJPf5dfm+/ucbCLGyj0X+OIHfjMSBP9JVXFyoIMANb76U+qvXr1NrEaJTFeyHilsn9jhjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB7917.namprd11.prod.outlook.com (2603:10b6:208:3fe::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.20; Fri, 15 Mar
 2024 00:02:10 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7386.015; Fri, 15 Mar 2024
 00:02:10 +0000
Message-ID: <e6e8f585-b718-4f53-88f6-89832a1e4b9f@intel.com>
Date: Fri, 15 Mar 2024 13:02:01 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Content-Language: en-US
To: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, <chen.bo@intel.com>, <hang.yuan@intel.com>,
	<tina.zhang@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <8f64043a6c393c017347bf8954d92b84b58603ec.1708933498.git.isaku.yamahata@intel.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <8f64043a6c393c017347bf8954d92b84b58603ec.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0030.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::35) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|IA1PR11MB7917:EE_
X-MS-Office365-Filtering-Correlation-Id: 76983dcc-b293-4159-9761-08dc4483294c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AYh4iSxxnp82sK5aHS2Pz1X1kRY64hDb7AfYfwnPYeQ+colsu2OpqwPe3gdvZcdVFoVGb19FYXKEaaHCZ6QES9oRuSMZwYKnwJEsrKG+9XSNzkrU9lBBQguw9TNZ1h8l/dvJ1wCrhCi9LsME4/qRNQP/Hv2PFrNJQeRwQ+G1x7F3dHkkJVG+LPyh00Ma3J0hYrg7oHBH05fighIIP2H0X2ffIvsSETK6PGz9t533JnB/TA+/+SEDjQeqkWymmHojc2El3uUmErmSHT4LM/56NwmDDNrs6JnRgHkcRJ6FEiPHFikW4eLtkP4ST/2V+v3XbZ1kfs6AyuY1gg7Jp1jO5HPcoNV94NQ/x5GDIg9ppDmJyloz7xrXLX019PYwEjueDV+vGjw1YnnVFpIx9FLWP1CktJvKLP3sb3CsInzc8afjr6c4tfH9oIgOt8KOQ6Gl+5zUYojhIBvemWZMQYX9xN5OqSu/v0NIArMs1pnmn/nTvLSfbYgo06pRn6FqmqzTguIjQC8GRAFK5EPtoOWTCOmX4PGwh3/DKCgHKKJeQzOVjMD0TzKXYs2+Dh5fcnWrXsdhQm64AtWOxB04fBCNh7QqcPbiTPzA03zxskSx5Ea5TK3qzesT/b/3wEVVZV+IdajDnBOn4zNivRayx9IzNFmwaTEeV95oRBXOh/gCqwg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlZoMUdFVjJ1TFByQ1lGZktCQjNyOHdPNjU5YnNRQVViRCt3aW03ck9LM2U2?=
 =?utf-8?B?NGJVNmdFK0hyeEN6RmlFRHJFclkxZDZUcXJDL21BMUx4OXhKY2ZsZTdtNTRu?=
 =?utf-8?B?RWc0VnVyaU4vMXFhMmxtWGNGZDRJUHRPY2tEbGx0Nk4rN1dqMERaclQrOGVP?=
 =?utf-8?B?MlRBN3p1U1AyMXBoTmRFaWxRUmJzU1p3K0hUam90OHczRFRPTHA2TDFoMjIy?=
 =?utf-8?B?Y0FhdUw5dWJJc1JTMFBNd3U4dEYwc1hrMTZ4dFhFK1JNK2N6ZmhaeUlrMWh1?=
 =?utf-8?B?ckRnMzhUZ1dOQVExR2wrRFg4dmN3RVhCaWxMUVpsZU5tSXUzOXFWSkE2Kzlw?=
 =?utf-8?B?SFlwdEc0QnJGTlg4N0UxKzdvelJVbkNqSC9OSGR3eTljS3VDcDVQdjFtNUxG?=
 =?utf-8?B?aGtQdTF4YXY2NDgrb2l3WnVRNzBOUmJNbkQ3QVdLRXI4UUhsUjdIMDRmZlJj?=
 =?utf-8?B?WE56MmFOOXpkR0dEMkIra1lRRlNMRWc0Mk84VU80Q1ZTZnRtQTdyZjNwdW9L?=
 =?utf-8?B?N0NmOVdIdzBNTHh4d3ptUTZPNXZEVmVpejExSE9XVnlrMGYzL0Rxd3AvS2Q5?=
 =?utf-8?B?c0NzMDVtZlFFWUYzQnBMNzNsaDFTQjJhZTMwUC9wbkNvelM2TEs3aEhMNCtx?=
 =?utf-8?B?UzFJeGVPY2NWVzVJcEhZV2h6eW5kcGtDb1NnQUkvNEhGbS9YemFVTnNSalgw?=
 =?utf-8?B?ajdqVVNTTE1HdnRoMjE1NVJNa3RySGFXb011NUx1b2c2Wkl5eW80ME4zOHF5?=
 =?utf-8?B?bHgwamx0ZlNVZ1hZOE9oV3RYaFVkQzNjRVcvZmZLRnpSWGxMV2ZqKy83b3Zs?=
 =?utf-8?B?bzY3MmZ3WUVHRHBqUXpuSjltcnNJbXFSQnAzOVgzU3JtQ2tPaW51U2kvMzZ5?=
 =?utf-8?B?UklSQlpJRzhPdUx3WmNYVitVWExjaVB0RFJVVXp6UXVPWThTY1g5cGpsdXFK?=
 =?utf-8?B?eEYwZkVIOTQxdWN0YXMyZkxHbkpQcEY3cFlrTnpoVGVtUURzNUhCbC9Wa2ZZ?=
 =?utf-8?B?WndzeVJrY3hrcW9obHdGSkx1THROL0dKQUhZZ3Fad3hwZzFyRUlpVDRLSVRY?=
 =?utf-8?B?UWhIMStnek02dUtxWkFZNkRqdTFEc285M1Y3K2NUbTVlWnl6Y1o4RW9pTUU0?=
 =?utf-8?B?SjVtMWFEWDNjTTBwaURZZGhXMzh1UXgrWmZPRVNmWFQ3cDJ2Q1JHSElDVk1B?=
 =?utf-8?B?b1pwSEU4czEzNVM0ZmVhdWcvY3BieG9RYnBnRlJCVzJQeEptR3lpcGk5eVVK?=
 =?utf-8?B?L1VLL0JmSE9vYmJJdG8vNTY3SE01RkVuRC9RdUNIOVkzdWgwMDFRK0E0TzRZ?=
 =?utf-8?B?L2E4aEo2dFpwOEJzMkl2Qit3ZkVDSVhGWisvaEVRYUZjWkp3dTUwaUNqUlVj?=
 =?utf-8?B?d1p0ZXdIMC9GUFhlVWFIbzA4ckE0RW5yWHpUYzZwaUJUUWp1eTBydW11OTJs?=
 =?utf-8?B?QlRVMjhaZm9XNUNiQktzTmlWZGNLbU9jWllkaDN0aS83TmZFOEZCdlp6eURI?=
 =?utf-8?B?ME9uVy85TEN4V3dMRFJ5cjlKcDlYbExQbFFpVmszVjJkd2ExaUQ1enM0MFhH?=
 =?utf-8?B?WS9IR3dnYitrTjFrSU5jeFpFNHpsYzdkZWRENHYyTHhwQnY0enkyTU5KL2da?=
 =?utf-8?B?SVllaE5VcU1UQVpDdGR0SkQvemh4VjVEL3dubHpmTGVCOG9jVkJoVC9ocS9F?=
 =?utf-8?B?cjRJQS9LZG5oOHlseFo3SXF6SWdGYzFSOWZWeCs1L3hKYlU2YkJKaHkzRFJy?=
 =?utf-8?B?YnRkbTRpa1ZSVlFYQm5wb1ZnQkhyTlFMUVE4WUQzc2xBNmpLL0lvQkcyT3lR?=
 =?utf-8?B?QUhDOXlLNnZSbEJzcll3M2ZrYmxuU0Nhckg3WjNLdGJiT2p6UTFWdTRsS2I2?=
 =?utf-8?B?cHhYeGFvRW0yRHpTYXB3eG0zUEkvR09YQ3BlTVdXTENFM3d4TC92MHZXUWVQ?=
 =?utf-8?B?T1dhYm5UUDZQM1BzcWpuUWhmeWlUTklZdUwvS1o0NWROeXVZb2diejFJNE1n?=
 =?utf-8?B?ZmMzU3lOZ01mU3JML3h6eW5hUnJyWndXUW93YUZwNldWWC9EcFBObVBMNjhK?=
 =?utf-8?B?SVYva1YzRHlaTlhHZ2x3ZUpvcEcxRklYVnlIYnBVaU5xbDhrOEpMNDVQNXBW?=
 =?utf-8?Q?ctrC4ouxt0sPtUROhpqEkTEPZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 76983dcc-b293-4159-9761-08dc4483294c
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2024 00:02:10.5581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZUleSFSS60tavNQLOGLNLUKOO92QwuqRBd359wL1hYKK00FaELyzHxluqCY4ZrV9bKdVYmbzXyNjw3gims7H6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7917
X-OriginatorOrg: intel.com



On 26/02/2024 9:25 pm, isaku.yamahata@intel.com wrote:
> From: Kai Huang <kai.huang@intel.com>
> 
> KVM will need to make SEAMCALLs to create and run TDX guests.  Export
> SEAMCALL functions for KVM to use.
> 

Could you also list the reason that we want to expose __seamcall() 
directly, rather than wanting to put some higher level wrappers in the 
TDX host code, and export them?

For example, we can give a summary of the SEAMCALLs (e.g., how many in 
total, and roughly introduce them based on categories) that will be used 
by KVM, and clarify the reasons why we want to just export __seamcall().

E.g., we can say something like this:

TD;LR:

KVM roughly will need to use dozens of SEAMCALLs, and all these are 
logically related to creating and running TDX guests.  It makes more 
sense to just export __seamcall() and let KVM maintain these VM-related 
wrappers rather than having the TDX host code to provide wrappers for 
each SEAMCALL or higher-level abstraction.

Long version:

You give a detailed explanation of SEAMCALLs that will be used by KVM, 
and clarify logically it's better to manage these code in KVM.

