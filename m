Return-Path: <kvm+bounces-11231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 733EC87454A
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 01:49:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08A5B284382
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 00:49:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B792A4A28;
	Thu,  7 Mar 2024 00:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eH8KcNQp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8E41859;
	Thu,  7 Mar 2024 00:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709772549; cv=fail; b=TPkZJSJebPYxTMylwx+qLbNF31J5lR7kZysGn6JXfg5pohu9LqjYf3gQ4nmjy3Wz2snkkLq7gGGRI4yKvcikweBzFEGdKoak2zTjUmvXh4nRh/MOLlNfvPw4EZTRsvin3jkSqsF9sjsXS9L4fH8yCxzqD9uhUCaIC67zqlRSFXg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709772549; c=relaxed/simple;
	bh=zYLmx7prCVbVQXW++ghb89wrKY0o11YAsZVVZh6WR5A=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r/PXba0dn4sq1cu78JUIDqVICaAI2F6252gkuhcHslQySSvN8k/SChBaEoqzuEU9XwOUul/lnFkHDnQ8a/PrTJsUzIVPeU5BsdRGm9j9G5taQSA+s9OUplaLPPZHZazBtTxzM3oa5f5IQVxfcrto7nK76mP6I3rDDf0ZpZ1mt2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eH8KcNQp; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709772548; x=1741308548;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zYLmx7prCVbVQXW++ghb89wrKY0o11YAsZVVZh6WR5A=;
  b=eH8KcNQp0CmFbapTdW56u+MB7cW4IjJ/jHfYtIc0hQQNGSWNwvo7Jx99
   UX1CpoRN0D4Mf8RKdGegnTfSvMMY6RpSOPSorjq4u5RaReM1oeDMTf0Tn
   g5+swu2uZSG8IDxhtB2RnaDAQ2IbknAIB7laKUnaECw1nWB2XkxO6Qcn/
   cMvos9F204PeUiT9BDg4PEL6D4UYscjAuG10x2Tr3G/sPbP46fDgOSI7h
   +3fWm0FIKYi2bpxtRkAncpL8NsiikWZrT7jZhMYYn9k4mk7+NOLl7xlin
   8GQP3VpO22joGEdXHvJv26Kg1eIyqOmDMn7ogzzny2iRC6py+p9g9D+Zt
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="7361713"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="7361713"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 16:49:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="14496596"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 16:49:07 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 16:49:07 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 16:49:06 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 16:49:06 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 16:49:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OaGd+0BVfQd6WG5wWZMasR4Cyj3bDFSL+KUX9kChS5sfDILGnfgYIkuGVI4vBpE3RuFi2N09tjhNQwU2OFfW/ovx6chHhiLbtn6iDVwpVyFDndSKFei5MSV+UHuMsD9MXRfnfhnrIUnODxk9tBhxiONwSjnbfR4vSsHmknCY/3PHGQT9uIY9iOf+wfpWYP9X+koobSZW92AHm/Su4Qt2jO5Inm58G6LHqFVbhOxt+KuJ4VwoiORtxrrgUFIrrpq8JBGOfPezB6YzCSXIl0XfKH3R7uWZnZAIkMedevB9tW6a+d9kRqMQuX74ctCXLZpuEbfZtOEXGQQKsyBUa74jMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5kq5oVsEKDQB4tV1SGVVH6f1GhQDWRvltgwJzJm55y8=;
 b=B+6ylBIkjqD3l4fzpoqjfDGZ9VxyXkRNuX5fupWVzYoOa1yezgZnbUL/AMtqRxuMTkrZbOSGfdvs2JFd32pZQ0Zr+iE/z2VprRTRBrLz0SN85yx5f91rTSDdp4rEsJ0EeCgfMt5G47jdRZ+1cH/kiydn1ZY2ZSLO9HIT8mM+0gnvDdLvUT1fBcxEw31+bxhIgdp8Mvfkemk0/vrRV+kcM9vJATBSyht8eV8saWysPL5/lJykIewPk18/g6zuiX9l8nFJJd2II82hrroyzjrmpJi5tvZuVBVR0f5WwakFoyQFXpFh8Y5S/kblEXb7ivWts69zkiDbM5v7QZMhjJ1ygQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB6728.namprd11.prod.outlook.com (2603:10b6:806:264::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Thu, 7 Mar
 2024 00:49:03 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7362.019; Thu, 7 Mar 2024
 00:49:03 +0000
Message-ID: <d325e811-c80d-49ba-85cf-06893cec659a@intel.com>
Date: Thu, 7 Mar 2024 13:48:55 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/16] KVM: x86/mmu: Handle no-slot faults at the
 beginning of kvm_faultin_pfn()
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yan Zhao
	<yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, "Michael
 Roth" <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, "Chao
 Peng" <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, "David
 Matlack" <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-14-seanjc@google.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240228024147.41573-14-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0003.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::8) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SN7PR11MB6728:EE_
X-MS-Office365-Filtering-Correlation-Id: c6a3cb23-eced-44da-1e34-08dc3e4062bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j4aInVkNrhrOqKY//i5pGTASHe1uTN4neFkZnWeCjddK3enx6jehj7U3D0LAZd0JevftIX/jAOglDNVVlQbu93rWl8EpEcqKazE5jbDub8ZZ60Vpj/XeZ7ApNpKaUiLeauwme92S5UWc2mTI+pQMWfuiH/Bdj5uPj3/aB8Sa8N1GKq2RtjJifO7lXxA3Xy8Q+s/rEOHEgqGAmUtN2nytN5fugUFhcOK2Vo6foNa4wO3f0jNamU4UeX16ck2+W9ECRgf9bbiKhnnWhMHzDwY7aHaDUGo5n2B84/Vqcx/g80ybctFUvJ1H2QMfQdpjKO7SwC9rINaIrjC2ScWJdL78zIzLZYKjKYXQnqdgWzbuB1alHi9qfzJYBh/7M6H9Dmye03FzXhx2TSgosyhc8s628OCFm1L7JSpAo8qMS9S3mFH2anHk+HSELDIWGfbqrz+Pjhn+6AQ5GoqSItNPdzTmwu118Z4LbRMrurANuT0H8ZVAC6JCSbYcHT05InOxdkJoASoOp+HJuUK8VWDdghhflaakMwRHyxcCKHAAC6OdSP+i+JEJt+cTcIOvYGuaEnLGZ9kBJNlzWA6k6P43KfvF2Eo32pGZYfwTsX75op5eYiRNlw3P31aDioYkdgvUIoa0MPTbFwB8ko74+1unzM5nCEB5NbfJazF0k2bSgFI5fos=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UytpMDlQMzRsZmpGY3EveTFKclJMbkRYS1FRUkFXZ3lPUXFTcXM3R2p1MFlU?=
 =?utf-8?B?MFZuRHVLS0dNMFY1bW4yd0xtMUttN2FmS2IyWlpHS3orT3F3SmdwQWl3NWlE?=
 =?utf-8?B?SmV3M2pvL2lpOFkraEtUQWRYWmwwUVVJY3ZHK2oxOGQrRUdacWlhTzZnVDhi?=
 =?utf-8?B?UE43WVI4bFo0RUV5RjU1SmNnR2hieSt1NkN4T3BveDQ3YlJwRDZGWmg3SXlO?=
 =?utf-8?B?RmFUaHJucjdsc25XU2cwdVRWU29iRFNoZm9jam1tQjZVdWVaaTZvU2NZSnNh?=
 =?utf-8?B?WHpDT0p5ZmhRaERkMVJualJFUjZYVkpUek1pY0NhRHZHZGZ6c1RxWXVNOHlH?=
 =?utf-8?B?K2RIclAwTjVpZjJSNVFCTGRTZGxPd1dua0tBN0ppM1hQL2duSnR0UGovYm16?=
 =?utf-8?B?ZXF6OWFRbXFUY0V2QjFUU0M2dlZNUUllaVVidmVxUkJvUXJxQldIQUNIMGJJ?=
 =?utf-8?B?N1k5L0tjKy9oMkpnNGdKRnA2d0dxZXk0Y09GcEVHSUQyTDJYbGp1RGpnTFlz?=
 =?utf-8?B?L0NibGRTRFhzM2tXWXNUMDVHYTMyT0dCaFJzbDAzeUxmdU1POW9TcUN2QXgx?=
 =?utf-8?B?MUIxTXhwaWZoWXVuMzY3eE1TLzFEZExCYk9JRncySHFTQ0tFSGUyT0w5bGFY?=
 =?utf-8?B?OVNxY0ZmclhCSVhBT2pFR2V3VjZMUUY1NVlGZXkwRSsrOHhBL05zaHNRRXVI?=
 =?utf-8?B?S1QrT1c5UmE2NlNIR1UzTjlTWjNUaFVwdTlCS2xNZTIwTFlwRGJoQjZ4elN3?=
 =?utf-8?B?aXRNNktoWEROM1htQk96Uk51R1VLUERFQ0svY1VLdXJjRlh3MHcwZTJGalds?=
 =?utf-8?B?T2NtV01FZkNZUzQwQXdZd3BpZW9tdUZpWXorVVU3S3FSbTVzSTFSN3VGV3ky?=
 =?utf-8?B?VktYdC94Qy9Oa2pxMmxTZzQwL3JOUWNMTWQxOGZmRmNGT0IxajJvU2MzNFJi?=
 =?utf-8?B?YjhJK1JWREFCOHBFN0h4S1JwTjJ5V2FtVkE5ZXlJbUdLZWRjdFd6Y0gyNjBa?=
 =?utf-8?B?UEJ3VkpyV3hEWjd2bE43SkpROEpldndrMUxPTVJ5Qm1LUEVpTjBUc0dQOWpw?=
 =?utf-8?B?em1RTnkxeERORUVzNDNkaTJ6Y3NlNUh5cGM2SUhwM2ZPa2xYTWNheWIydDhN?=
 =?utf-8?B?SVlIRS9obTJlWTJRNkE4WldLOGhDNTV3VEZZei9Xc0xJaXl0QW5Za292TjFJ?=
 =?utf-8?B?OWlVbTViWk1oV0dxV0pqWG1HSjB1Yit3WDFRK1BaSFA2WmdiamVnWmNBTklI?=
 =?utf-8?B?ZWluK3ZLSkwvUnN5Q0xFZEZnYjhMUjhLeDh4cWRTUWV5U0pvTjNBVk9ON1hr?=
 =?utf-8?B?VlBES2VRVXUrSHFKVXlqaTZKSWUyOGp2eE15RkYwaUpDUmJFc3llRlduNlBP?=
 =?utf-8?B?UmRTRERlMFQyM1hvV0EvNlF5akxjYk04bG1XdlNUR1VwSXdjbGNrQ1B2ejV4?=
 =?utf-8?B?S1daSGpQZkIzWUUwRmd5OXczRVpkQ2FJTE9qSHN2TE1kTDhZUFIrcFY1b3RU?=
 =?utf-8?B?TVdrblhsalkvVUlYZEk3L3hhVEJKbytBODkwallzbm9pY1RBVVRQN0I1VkVt?=
 =?utf-8?B?TzU0MXVGSm8vdlVIQ29zcWNoYzlQakE0MWsyRlNidmM5K3ZtNzk3RTNxV2ZP?=
 =?utf-8?B?ajIxc2MrRUlVd2VNRzJ4QnhGRnI5R24wV29KK3dVTVNPQk83cHAxTHVJaHRn?=
 =?utf-8?B?V3ppZFg1cTJqbzNySlRkZXNqS2JXZnBEV284ZTNDUlZxczU1SzMrY05EcDBv?=
 =?utf-8?B?Z0xvaW1HbkhLZ0JPNmtaTHF0Z1BtRm0yTCtmRHRaKzE2WUI5Qk1UR3BsOUNF?=
 =?utf-8?B?SURYVGJTNlZtV3dQd1RKS2N2bk93NXQybnhuWEtIQkZVTUJ1SkYvbXo4N092?=
 =?utf-8?B?dWFSejFUWHN5M2hGNlROcDVOS1Z1NlMvekJzY0ZsWlZjTkdnNVJzTVhVWHhM?=
 =?utf-8?B?Mm9MbU90aWpnZjlHNTgzOUxub29aaE01T1V3OFpUdEtYdVFDbXdOMDVhMzk5?=
 =?utf-8?B?V1BlQnFvOEFlcStWMWJYaDlRbDgxN0JuVkZqNXRibWpvOGFuQVB6aWE2a2Fp?=
 =?utf-8?B?ZjBSTWtaeGpucFRLaU9lUkdTcWNHTUpCSjJBeGlXSWsvZ2tJTFlkT1luVkVJ?=
 =?utf-8?Q?5dK0O9CdOBD3mwtkKTzdgDNe6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6a3cb23-eced-44da-1e34-08dc3e4062bc
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2024 00:49:03.6513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iJqeUTUvVASkjZtsoli14vmG0GuOiCXVp/vx/xq0PhgUcc3Gzl3MXEJKaVdgCknbJDy0UzMGyuqWrnjXWiQgEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6728
X-OriginatorOrg: intel.com



On 28/02/2024 3:41 pm, Sean Christopherson wrote:
> Handle the "no memslot" case at the beginning of kvm_faultin_pfn(), just
> after the private versus shared check, so that there's no need to
> repeatedly query whether or not a slot exists.  This also makes it more
> obvious that, except for private vs. shared attributes, the process of
> faulting in a pfn simply doesn't apply to gfns without a slot.
> 
> Opportunistically stuff @fault's metadata in kvm_handle_noslot_fault() so
> that it doesn't need to be duplicated in all paths that invoke
> kvm_handle_noslot_fault(), and to minimize the probability of not stuffing
> the right fields.
> 
> Leave the existing handle behind, but convert it to a WARN, to guard
> against __kvm_faultin_pfn() unexpectedly nullifying fault->slot.
> 
> Cc: David Matlack <dmatlack@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Kai Huang <kai.huang@intel.com>

One nit ...


> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -235,7 +235,7 @@ struct kvm_page_fault {
>   	/* The memslot containing gfn. May be NULL. */
>   	struct kvm_memory_slot *slot;
>   
> -	/* Outputs of kvm_faultin_pfn.  */
> +	/* Outputs of kvm_faultin_pfn. */
>   	unsigned long mmu_seq;
>   	kvm_pfn_t pfn;
>   	hva_t hva;

... how about get rid of this non-related fix?

Yeah it's annoying but do in a separate patch?

