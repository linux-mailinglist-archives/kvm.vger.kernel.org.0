Return-Path: <kvm+bounces-14708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 86F1D8A5F7A
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 02:56:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F10C11F21EA8
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 00:56:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50FC45223;
	Tue, 16 Apr 2024 00:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lbzdBNgy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AAE1849;
	Tue, 16 Apr 2024 00:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713228954; cv=fail; b=g2wsAz8WkVUIbzMNt0FUMPlUaqpIeq3TabWs3ts1jSt3R071XGgeENY2jgOsq0bzsHrdSM+j7tLufC3uZZXJNUVj21UZAJV+qvdwWjk7zVnpbBh15ap2G554+4TT7NesWhlACCq3hqbZjZiKlLFJzSDds1GXR2pCgSasljW1xWU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713228954; c=relaxed/simple;
	bh=ScV7LmoyEvWBSJUHpvsyhsuZLBesi4i800GWRqaSldg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LchpKk5rseDfv07ycfZafcC6n8jxkdz+/Ln6MHWHDDr+b9x/BWmSiTJl4S0Dldy/UuS7aMss14ItmdO/oRwjuXX0UVIK5N1i3lHgkgXoJ60EmbjZBsHK20oRHNqfJ2o/3jhYP0pF9/UIC0njnAxd6ArRRQvDdAQFIfYOJNgdwlk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lbzdBNgy; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713228952; x=1744764952;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ScV7LmoyEvWBSJUHpvsyhsuZLBesi4i800GWRqaSldg=;
  b=lbzdBNgyFNV3bvvtqkifIAyDfUQdZVcwmkvnchl8/jKEYYyjDGUgqWDz
   t6OTlZNntU4H7mSD17YAgNJxcjomPH1WOj+hhA5vXYFzPlgXJQ2M8E3F5
   CodL9UZVn4sQEz7U717HrIsXNFRfdunxXXD27RRp9bD/+AE3lGj/jeM17
   NefVZVwlkLo7JNDUYNGORrYX3cAEipoPjpLjKTCDkvQ3Tx34vzanxZGH9
   QME6hQOWo7Ov/AfeEyPfLFmraH0tlnDWTit10wEYojxDMHhdhZwZ+lEXG
   WtNv9wOSNQR2T+abuAP7z4nDtAHmTKB2LbRyZNW3Snd+vScjTlA9Zp4cI
   A==;
X-CSE-ConnectionGUID: XPUx0FbFSx+TL5xcYtYIMg==
X-CSE-MsgGUID: Wk7mUm3NSWqucAuSYb3G9Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="19354356"
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="19354356"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 17:55:50 -0700
X-CSE-ConnectionGUID: T1T3481RTfWwU+o10gjMlQ==
X-CSE-MsgGUID: G5SXvN1sRLe7e6fV9O9YLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="26749432"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Apr 2024 17:55:50 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Apr 2024 17:55:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Apr 2024 17:55:49 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 15 Apr 2024 17:55:49 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 15 Apr 2024 17:55:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iBW1SLUdrECCu5YM/BJOmyv2mlG8y1I/GOwDpMW1M50e2uPgC5n1CJX+AIMLZFO3WOg44hxv99oxc5O4LwMEDea3c5RSolMG22dEBjlRbfQl602NfEI6d033sPsMPIqI5DHwNMfz0zMX4hQARdC0dVHryv8dzt39f7lpi1jgo3E/jvPG8Q7F2R3ogXL019zQACKoPekfJ7AhBeeLcev8BOn/ncwvjAUw1PycpHbSjnijHo4Dag+nns1iFz6WgHO8uXFYm0ELo8N/mhk/iu7RBVeBqxl0cr+0cg/+YvLuU8bKu+g34jCwHtYIDlkLMbxMuBIPQHAR5jSVc8bSwwaNWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UPYGtG+j5Nx+oakv/ftgoqhySTAO+Nd3K7IlNf4FL5M=;
 b=Kwtipkfk93NJhgs1bpB1BJIUzjBXaudXF7fGN14/o5HilMG42n8Ux6FnoFTBAbDmSKhA0agaiRzUSiXm9njjZyclUthWGZs37zlCIMYXP9UW/on5H3gbHNU53TjxRWHnfendYfTwPkeAxh9XUOaHK9R96e8JwCyCjecPdmE1DvGuH5XxA1g7Jn3s/s4tXYi5rZ7N/O5R+S7k2Ckv8vZ+AK0C3bWaFfTAWxD66FM6GiEd0IixZ0g40pXV70Y2o4Qfk80dMp3vV8uR0pbx/8/+J5+SsfTZ5/aplTSuE5JPihohLtiu4OU/PhjHSWaUrh3LwyS/uSBg0OeOTe2Ee7mcOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by SA1PR11MB5801.namprd11.prod.outlook.com (2603:10b6:806:23d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.25; Tue, 16 Apr
 2024 00:55:43 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::dd06:e9e7:d35a:77b0]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::dd06:e9e7:d35a:77b0%5]) with mapi id 15.20.7472.027; Tue, 16 Apr 2024
 00:55:43 +0000
Message-ID: <34d64c12-9ed5-4c63-8465-29f7fdce20dc@intel.com>
Date: Tue, 16 Apr 2024 12:55:33 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 027/130] KVM: TDX: Define TDX architectural
 definitions
To: Isaku Yamahata <isaku.yamahata@linux.intel.com>, Yan Zhao
	<yan.y.zhao@intel.com>
CC: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <erdemaktas@google.com>, Sean Christopherson
	<seanjc@google.com>, Sagi Shahar <sagis@google.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>, Sean Christopherson
	<sean.j.christopherson@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <522cbfe6e5a351f88480790fe3c3be36c82ca4b1.1708933498.git.isaku.yamahata@intel.com>
 <ZeGC64sAzg4EN3G5@yzhao56-desk.sh.intel.com>
 <20240305082138.GD10568@ls.amr.corp.intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240305082138.GD10568@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0320.namprd03.prod.outlook.com
 (2603:10b6:303:dd::25) To PH7PR11MB5983.namprd11.prod.outlook.com
 (2603:10b6:510:1e2::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5983:EE_|SA1PR11MB5801:EE_
X-MS-Office365-Filtering-Correlation-Id: fab8cc67-7c29-4f74-4412-08dc5daff1bf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /DyDM8tEwZbUEiLMIxtZL1EghugwO7olB4a6kFFAdUTCT8fKrzL80QnzqF+n7X+uNyQVzO22TCzkb5zA9ZtFCl4u6CBpFX8Euq1FFgEUtVf/MFLjvYHImhEgTHtbN3QE/fXYcepP8GqypZPl0Y4Ec3ucawsLxVZ9RvhZmcS/ob7C/SlWuWT7pM/tSUsSDKHdJvgCF9t7Y4Kvo50SDHFPaJHIs1ikiJh4Q6J/WWNWpD/frZFCeDJ4N4ZQao+bFwVWUkXVZzsFTc2yVOL9wX4Ao+olNl45GxGhbr00QMR9GDw8kdN4EjCB3FF5bGmjqt70YsJHOjBtZVvfDFOBoYHuWFCyyZvf8OjwzNrnOZ3Lz+NmQYoPdU4vAmG7uu1IvxCyvCpKoKJfwaPdEayFjs578CZ9QuChN8knardS8SMN4Z8L1ledd1W665ss1nCCnAEDsKElXpj9hWqXhx+PK5MJs+KubTHpHqj5SiHT6XuF3elOnjox6R/KSiAc9jufG7tdLLiWcgPp2aO1/LBvisyeEUBkOqMrkCBto3p96gisoyqnoyd3RUOpOGX4ytkBkxGhJm3aZJ1SZpl1A2aUBgX49vP+pm3z5qBzN4Epmw7xz32MihXrbKRIE+m0soGglEbg22IylUdxAHeWWe1ss8TTwBbqvxAhWssBvdJDdaryyqM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QUtJcFNET2FnWkVBUllyYkpBYnhMUGtBQWZ2c0lvazVXdHZpVVpMRXZRMFM0?=
 =?utf-8?B?NktDZUVMM0RtaVlSOTgrOE9CZGtSSkNXcitLVVFwUHhvSHVyQmltR00vNUFH?=
 =?utf-8?B?elRING1UY0NhenBWQ1ZvSlpKMkNxWjhiRTFRbTNEemc1N3IzeTFZSkM2Vjlh?=
 =?utf-8?B?Ync0NFRaNFZRZjVNYWF4WjQxZEYwQ0dKcGhkMnJLOGRDOUowSnZNMnZvOFBO?=
 =?utf-8?B?cXpnRXQybk5CMm1xcDAxQUdDZUdlWUJkYzhLdlZob0hITlo1ZUVMaWtMOEo4?=
 =?utf-8?B?b3lWYnFsaGJFQXlYWTBJREZlTUREbWpuY2IwT1AwczdLL1A0RCtFT080TE9I?=
 =?utf-8?B?SGh4UUJWSmNJL2dSemwrU2E3R1hqV1lQTERlbzM3NlREQ3Z6VExzamFScGpn?=
 =?utf-8?B?eWJJTkNqV05yNm11VDR3ZFhURURNN2s3VnhoY2svUUtBS0ZRdmt4VUNLUjdx?=
 =?utf-8?B?Mno1cDBMcUFuai8rSVVNSFRocHpld01uTFV1N2JkN3oySGNxcVQwSXk5RHFm?=
 =?utf-8?B?RW1Ybm5ncml0eFpNM3JVNmY3Ym9HUWVyVGVpRnEwTkJiZFl5M0hweTFuaVFw?=
 =?utf-8?B?RktneU5pcFF5cUVWa0ZsY0hVSXQ2WXV2eVg0aU9wS3ZUNmNySUJtMjkyeE1T?=
 =?utf-8?B?UVZDMmNwaEFtR2tqVUtEUkRRVmxFZVdUOUhWekZpVEhGVUlONmRlTlVCT25Z?=
 =?utf-8?B?Y2FBS29jUlBoVHRYNEhhYWlBY1c4V21WWlFWZWZoSnM1LzZSSlVhUGFJNkcz?=
 =?utf-8?B?SjlJY0lIcXpXb2lIV1hjS05qdlZtOVd6Vmx5d1JsUW5yMEJtd25pQ2xaYmVh?=
 =?utf-8?B?ejJvMGY4aUpNV0taUHVyRVZvY1Vrc2NVc1hVV2swRER6eUVhMlRnaWNaVGFO?=
 =?utf-8?B?YllncitNendHcjFiak5uRXphYzBnRmxSNU9HbEVVMjlXNldvd3R3MDIyaG9W?=
 =?utf-8?B?WnJqeFFlVUpOdXN2T3NrRTBLU3JJZStXTVRpWkhtbDFrZmhWaThsc3dsWUQ1?=
 =?utf-8?B?MHhMV29VZ2s0eGtwV1hrejNjMjVYemgraExHL1B6VFZYQis2aWlVT0VqSXhO?=
 =?utf-8?B?WWxyeWlvQmtGcmp0RmZuaG9LMFl4ekdRZy81dEVVRUd5YWxNSHRuZVNBNDhl?=
 =?utf-8?B?dHVXeVFpMmxucEtRQ3EwWi9TY2VzVTFzc1VMRHFkMFRzOTIvWmVHM2FWVVQ1?=
 =?utf-8?B?b21odUhJYmZrWi9tU2FlTGwxajV1bzlZM3VlcjNFaEhCTWtLQXJMdE1Va0tm?=
 =?utf-8?B?MjM4WDZHdnR1OHF1S0NWTkNvOHJwdFZXRWhtMVFPMDRXQmpSYzdsbXd6aFUr?=
 =?utf-8?B?amgvR0FuUGY0dmZtSWswRHM3SUg1VkNFL0d1RXNlY3JtVThIVXNIREd5SEYz?=
 =?utf-8?B?WmliOGRhcjh5bTFCVFN6UUZCRFhCMFZGeUxsc0xtb3V5bmhtK0l6Z3ozbkpF?=
 =?utf-8?B?NWFhMWs3YUpOL2M2M1VibkM3bnZ1MVpXMGxmSnNpcVZJc0xScGQ2N0ZNMktY?=
 =?utf-8?B?dDhsWS9yVXJ3ZERqSmY1ayttTnNsbnZUWW5pUnQ3dmhhUVdtL0xLQ0FpK0Nv?=
 =?utf-8?B?K25RUUQwUE9TSGk5Y0ZrTkt2VkM0aEJ0VzVvdmhOZVZHcXJlMnM4V3owdUM5?=
 =?utf-8?B?S3Z1UGVXckxwOFVhN0EvNG84K3Njelk2ek5TWTZlekFmZTlYTjQrSEF0UjB3?=
 =?utf-8?B?K1BFSXlKeW9jUWx2QVpLWE1GRWdaVGR1RHBiaUVSbWpwZGFERmoweE1LaC9J?=
 =?utf-8?B?bmpkd2RpYkdEZnhoOEExQTYxcEVHZVNCTWRKSTY3RndYRVNObjkzZjJHN3BW?=
 =?utf-8?B?SHRJQ3luTHBjSzZFcXYzNzRrQ2Y3dURVM1FRKzlmL0c5V0VsdVVNTXRTaXVD?=
 =?utf-8?B?M011dDJKTzJMMk53L1lsajVOWGZmdndjcW15VWh4aDUxdkVFTUo2SWRJbmxJ?=
 =?utf-8?B?eVV3RVQ1NThFbXY2cmZoZTVNL1pDODZFRzloMWVzVGtXNHpXaHBSOXg1RlN1?=
 =?utf-8?B?Rk41ZEVIT0hIYjBBZWorQmdsSHREYjRtN01XSVlTZ3gyS3d0dlNRdWR6Y2Y2?=
 =?utf-8?B?RjFRdER5Z3Fia1BaQjFVMklob0VsZTkydkJXaDBzWFZXNVROc2RYMlpEQVUv?=
 =?utf-8?Q?zgWsrJUykaHVUofI2ZYCIa7BS?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fab8cc67-7c29-4f74-4412-08dc5daff1bf
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 00:55:43.7771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9gbOo1x2BX7HfaxXyrHJeRYNEzTBYAuc008cX8enrt5LBQTfuzOJqFBWLgkOakGFllUSTnUfw9VsOESZdHFDIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5801
X-OriginatorOrg: intel.com



On 5/03/2024 9:21 pm, Isaku Yamahata wrote:
> On Fri, Mar 01, 2024 at 03:25:31PM +0800,
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
>>> + * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
>>> + */
>>> +#define TDX_MAX_VCPUS	(~(u16)0)
>> This value will be treated as -1 in tdx_vm_init(),
>> 	"kvm->max_vcpus = min(kvm->max_vcpus, TDX_MAX_VCPUS);"
>>
>> This will lead to kvm->max_vcpus being -1 by default.
>> Is this by design or just an error?
>> If it's by design, why not set kvm->max_vcpus = -1 in tdx_vm_init() directly.
>> If an unexpected error, may below is better?
>>
>> #define TDX_MAX_VCPUS   (int)((u16)(~0UL))
>> or
>> #define TDX_MAX_VCPUS 65536
> 
> You're right. I'll use ((int)U16_MAX).
> As TDX 1.5 introduced metadata MAX_VCPUS_PER_TD, I'll update to get the value
> and trim it further. Something following.
> 

[...]

>   
> +	u16 max_vcpus_per_td;
> +

[...]

> -	kvm->max_vcpus = min(kvm->max_vcpus, TDX_MAX_VCPUS);
> +	kvm->max_vcpus = min3(kvm->max_vcpus, tdx_info->max_vcpus_per_td,
> +			     TDX_MAX_VCPUS);
>   

[...]

> -#define TDX_MAX_VCPUS	(~(u16)0)
> +#define TDX_MAX_VCPUS	((int)U16_MAX)

Why do you even need TDX_MAX_VCPUS, given it cannot exceed U16_MAX and 
you will have the 'u16 max_vcpus_per_td' anyway?

IIUC, in KVM_ENABLE_CAP(KVM_CAP_MAX_VCPUS), we can overwrite the 
kvm->max_vcpus to the 'max_vcpus' provided by the userspace, and make 
sure it doesn't exceed tdx_info->max_vcpus_per_td.

Anything I am missing?


